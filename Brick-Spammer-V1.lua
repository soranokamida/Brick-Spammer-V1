local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function playSound(soundId)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. soundId
    sound.Parent = SoundService
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

local player = Players.LocalPlayer

if player.PlayerGui:FindFirstChild("Brick Spammer") then
	player.PlayerGui["Brick Spammer"]:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Brick Spammer"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 160)
frame.Position = UDim2.new(0.5, -110, 0.5, -95)
frame.BackgroundColor3 = Color3.fromRGB(127, 127, 127)
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 20)
uiCorner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Brick Spammer V1"
title.TextColor3 = Color3.fromRGB(0, 0, 0)
title.TextSize = 8
title.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 20)
titleCorner.Parent = title

local credits = Instance.new("TextLabel")
credits.Size = UDim2.new(1, 0, 0, 40)
credits.Position = UDim2.new(0, 0, 0.8, 0)
credits.Text = "By Daniel_Jenson"
credits.TextColor3 = Color3.fromRGB(0, 0, 0)
credits.TextSize = 9
credits.BackgroundTransparency = 1
credits.Parent = frame

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.8, 0, 0, 35)
toggleButton.Position = UDim2.new(0.1, 0, 0.6, 0)
toggleButton.Text = "Spawn Toggle: Off"
toggleButton.BackgroundColor3 = Color3.fromRGB(160, 82, 45)
toggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
toggleButton.Parent = frame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 10)
toggleCorner.Parent = toggleButton

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(0.8, 0, 0, 35)
inputBox.Position = UDim2.new(0.1, 0, 0.3, 0)
inputBox.BackgroundColor3 = Color3.fromRGB(191, 191, 191)
inputBox.TextColor3 = Color3.fromRGB(0, 0, 0)
inputBox.PlaceholderColor3 = Color3.fromRGB(0, 0, 0)
inputBox.PlaceholderText = "Enter Brick Name Here"
inputBox.Text = ""
inputBox.Parent = frame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 10)
inputCorner.Parent = inputBox

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -35, 0, 5)
minimizeButton.Text = "-"
minimizeButton.BackgroundColor3 = Color3.fromRGB(160, 82, 45)
minimizeButton.TextSize = 18
minimizeButton.Parent = frame

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 15)
minimizeCorner.Parent = minimizeButton

local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        frame:TweenSize(UDim2.new(0, 220, 0, 40), "Out", "Quad", 0.3, true)
        minimizeButton.Text = "+"
        toggleButton.Visible = false
		credits.Visible = false
		inputBox.Visible = false
    else
        frame:TweenSize(UDim2.new(0, 220, 0, 160), "Out", "Quad", 0.3, true)
        minimizeButton.Text = "-"
        toggleButton.Visible = true
		credits.Visible = true
		inputBox.Visible = true

    end
    playSound("12221967")
end)

local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

toggleButton.MouseButton1Click:Connect(function()
    spawnEnabled = not spawnEnabled
    toggleButton.Text = spawnEnabled and "Spawn Toggle: On" or "Spawn Toggle: Off"
    toggleButton.BackgroundColor3 = spawnEnabled and Color3.fromRGB(50, 205, 50) or Color3.fromRGB(160, 82, 45)
    playSound("12221967")
end)



playSound("12221967")

StarterGui:SetCore("SendNotification", {
    Title = "Brick Spammer",
    Text = "Loaded!",
    Duration = 5
})

RunService.Heartbeat:Connect(function()
	player.Character.Torso.CanCollide = false
    if not spawnEnabled then return end
	ReplicatedStorage.BricktionaryGetBrick:FireServer(ReplicatedStorage["Discovered Bricks"][inputBox.Text])
end)