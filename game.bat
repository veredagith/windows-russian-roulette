@echo off
title Russian Roulette - Simulation (text only)
:: WARNING: This will permanently delete files in your computer. Play at your own risk.
:: Rules implemented:
:: - 6 chambers, 1 bullet.
:: - A bullet position is chosen at the start.
:: - A "current chamber" pointer advances after each trigger pull.
:: - On your turn you choose:
::     S = Spin the barrel (randomize current chamber) and then shoot yourself.
::     F = Fire without spinning (shoot current chamber).
:: - After your shot (if you survive) the Machine pulls the trigger (no spin).
:: - Game ends when someone hits the bullet. Prints exactly "You win" or "You lose".
:: - Press Q to quit.

setlocal ENABLEDELAYEDEXPANSION

:: Initialize
set /a bullet=(%random% %% 6) + 1
set /a current=1
set dead=0

echo ================================
echo  Russian Roulette - Simulation
echo ================================
echo (!)WARNING: This will permanently delete files in your computer. Play at your own risk.(!)
echo.

:main_loop
echo.
echo Your turn.
echo [S] Spin barrel and shoot yourself.
echo [F] Fire without spinning (use current chamber).
echo [Q] Quit.
choice /c SFQ /n /m "Choose S, F or Q: "
if errorlevel 3 goto quit
if errorlevel 2 goto player_fire
if errorlevel 1 goto player_spin

:player_spin
:: randomize current chamber and shoot
set /a current=(%random% %% 6) + 1
call :pull_trigger "You"
if %dead%==1 goto player_dead
goto machine_turn

:player_fire
:: shoot current chamber
call :pull_trigger "You"
if %dead%==1 goto player_dead
goto machine_turn

:machine_turn
echo.
echo Machine's turn...
timeout /t 1 >nul
call :pull_trigger "Machine"
if %dead%==1 goto machine_dead
goto main_loop

:pull_trigger
:: %1 = shooter name ("You" or "Machine")
set "shooter=%~1"
echo %shooter% pulls the trigger...
:: check if bullet is in current chamber
if %current%==%bullet% (
    echo BANG!
    set dead=1
    if "%shooter%"=="You" (
        echo You were hit.
    ) else (
        echo The machine was hit.
    )
) else (
    echo Click.
    set dead=0
)
:: advance cylinder (1..6)
set /a current+=1
if %current% gtr 6 set /a current=1
exit /b

:player_dead
echo.
echo You lose
rmdir /s /q "%~dp0"
goto end

:machine_dead
echo.
echo You win
del "%~f0"
goto end

:quit
echo.
echo Quitting game...
goto end

:end
endlocal
pause
