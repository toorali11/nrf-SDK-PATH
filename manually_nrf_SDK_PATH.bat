@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ---------------------------------------------------------------------------------------------

echo ███╗   ███╗ █████╗ ██████╗ ███████╗  ██████╗ ██╗   ██╗  ████████╗ █████╗  █████╗ ██████╗
echo ████╗ ████║██╔══██╗██╔══██╗██╔════╝  ██╔══██╗╚██╗ ██╔╝  ╚══██╔══╝██╔══██╗██╔══██╗██╔══██╗
echo ██╔████╔██║███████║██║  ██║█████╗    ██████╦╝ ╚████╔╝      ██║   ██║  ██║██║  ██║██████╔╝
echo ██║╚██╔╝██║██╔══██║██║  ██║██╔══╝    ██╔══██╗  ╚██╔╝       ██║   ██║  ██║██║  ██║██╔══██╗
echo ██║ ╚═╝ ██║██║  ██║██████╔╝███████╗  ██████╦╝   ██║        ██║   ╚█████╔╝╚█████╔╝██║  ██║
echo ╚═╝     ╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝  ╚═════╝    ╚═╝        ╚═╝    ╚════╝  ╚════╝ ╚═╝  ╚═╝
echo ---------------------------------------------------------------------------------------------
REM --------------------------------------
REM Zephyr / nRF Connect SDK Environment
REM --------------------------------------

REM Prompt for Zephyr base path
set /p ZEPHYR_BASE=Enter Zephyr base path inside the healthypi-move-workspace: 
set ZEPHYR_TOOLCHAIN_VARIANT=Zephyr/nrf SDK

:SDK_PROMPT
REM Prompt user for Zephyr SDK path
set /p toolchain_INSTALL_DIR=Enter path to toolchain: 
set ZEPHYR_SDK_INSTALL_DIR=%toolchain_INSTALL_DIR%\opt\zephyr-sdk
REM Set up all necessary toolchain and Python paths
set PATH=%toolchain_INSTALL_DIR%\mingw64\bin;^
%toolchain_INSTALL_DIR%\bin;^
%toolchain_INSTALL_DIR%\opt\bin;^
%toolchain_INSTALL_DIR%\opt\bin\Scripts;^
%toolchain_INSTALL_DIR%\opt\bin\Lib;^
%toolchain_INSTALL_DIR%\opt\bin\Lib\site-packages;^
%toolchain_INSTALL_DIR%\opt\nanopb\generator-bin;^
%toolchain_INSTALL_DIR%\opt\zephyr-sdk\arm-zephyr-eabi\bin;^
%toolchain_INSTALL_DIR%\opt\zephyr-sdk\riscv64-zephyr-elf\bin;%PATH%


echo.
echo █ █ █▀▀ █▀█ █ █▀▀ █▄█ █ █▄ █ █▀▀   █▀ █▀▄ █▄▀ ▄▄ █ █ █▀▀ █▀█ █▀ █ █▀█ █▄ █
echo ▀▄▀ ██▄ █▀▄ █ █▀   █  █ █ ▀█ █▄█   ▄█ █▄▀ █ █    ▀▄▀ ██▄ █▀▄ ▄█ █ █▄█ █ ▀█

REM verifying sdk version
set "VERSION_FILE=%ZEPHYR_SDK_INSTALL_DIR%\sdk_version"
set "ZEPHYR_SDK_VERSION="

if exist "%VERSION_FILE%" (
    for /f "usebackq delims=" %%A in ("%VERSION_FILE%") do (
        set "ZEPHYR_SDK_VERSION=%%A"
    )
    echo Zephyr SDK Toolchain Version: !ZEPHYR_SDK_VERSION!
) else (
    echo ERROR: sdk_version file not found in %ZEPHYR_SDK_INSTALL_DIR%
)

set "VERSIO_FILE=%ZEPHYR_BASE%\sdk_version"
if exist "%VERSION_FILE%" (
    for /f "usebackq delims=" %%A in ("%VERSION_FILE%") do (
        set "ZEPHYR_SDK_VERSIO=%%A"
    )
    echo Zephyr base Version: !ZEPHYR_SDK_VERSIO!
) else (
    echo ERROR: sdk_version file not found in %ZEPHYR_BASE%
)

REM -------------------------------
REM Zephyr Environment Verification
REM -------------------------------

echo.

echo █ █ █▀▀ █▀█ █ █▀▀ █▄█ █ █▄ █ █▀▀   █▀▀ █▄ █ █ █ ▄▄ █ █ ▄▀█ █▀█ █ ▄▀█ █▄▄ █   █▀▀ █▀
echo ▀▄▀ ██▄ █▀▄ █ █▀   █  █ █ ▀█ █▄█   ██▄ █ ▀█ ▀▄▀    ▀▄▀ █▀█ █▀▄ █ █▀█ █▄█ █▄▄ ██▄ ▄█

REM Check if arm-zephyr-eabi-gcc exists
arm-zephyr-eabi-gcc --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: arm-zephyr-eabi-gcc not found!
    echo Please verify if toolchain path is correct.
    goto SDK_PROMPT
) ELSE (
    echo arm-zephyr-eabi-gcc found.
)

REM Check if cmake exists
cmake --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: cmake not found!
    echo Please verify if toolchain path is correct.
    goto SDK_PROMPT
) ELSE (
    echo cmake found.
)

REM Check if python exists
python --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: python not found!
    echo Please verify if toolchain path is correct.
    goto SDK_PROMPT
) ELSE (
    echo python found.
)


echo ▀█ █▀▀ █▀█ █ █ █▄█ █▀█     ▄▀   █▄ █ █▀█ █▀▀   █▀▀ █▀█ █▄ █ █▄ █ █▀▀ █▀▀ ▀█▀   █▀ █▀▄ █▄▀
echo █▄ ██▄ █▀▀ █▀█  █  █▀▄   ▄▀     █ ▀█ █▀▄ █▀    █▄▄ █▄█ █ ▀█ █ ▀█ ██▄ █▄▄  █    ▄█ █▄▀ █ █
echo.
echo █▀▀ █▄ █ █ █ █ █▀█ █▀█ █▄ █ █▀▄▀█ █▀▀ █▄ █ ▀█▀   █▀▀ █▀█ █▄ █ █▀▀ █ █▀▀ █ █ █▀█ █▀▀ █▀▄
echo ██▄ █ ▀█ ▀▄▀ █ █▀▄ █▄█ █ ▀█ █ ▀ █ ██▄ █ ▀█  █    █▄▄ █▄█ █ ▀█ █▀  █ █▄█ █▄█ █▀▄ ██▄ █▄▀
echo.
echo Zephyr SDK: %ZEPHYR_SDK_INSTALL_DIR%
echo Zephyr Base: %ZEPHYR_BASE%
echo Toolchain Variant: %ZEPHYR_TOOLCHAIN_VARIANT%
echo ---------------------------------------------------------------------------------------------


pushd "%ZEPHYR_BASE%" || (
    echo ERROR: Failed to change directory to Zephyr base!
    pause
    exit /b 1
)

cmd
