Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab2DQQu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 12:50:26 -0400
Received: from host171.canaca.com ([67.55.55.225]:54494 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab2DQQuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 12:50:23 -0400
Message-ID: <b390b4f641a76b9c2a5240bf344faea9.squirrel@mungewell.org>
In-Reply-To: <alpine.LRH.2.00.1204171027220.11298@twin.jikos.cz>
References: <1316018905-4175-1-git-send-email-nlopezcasad@logitech.com>
    <4E77A221.1060909@t-online.de>
    <CAN+gG=EcaMrz2w-cVL-cCwi2NNVJ-NXOpOQpbjyFdCwn5+Bn+w@mail.gmail.com>
    <alpine.LRH.2.00.1204171027220.11298@twin.jikos.cz>
Date: Tue, 17 Apr 2012 12:50:12 -0400
Subject: Re: [PATCH v5 1/1] HID: Add full support for Logitech Unifying
 receivers
From: simon@mungewell.org
To: "Jiri Kosina" <jkosina@suse.cz>
Cc: "Benjamin Tissoires" <benjamin.tissoires@gmail.com>,
        =?iso-8859-1?Q?=22Richard_Sch=FCtz=22?= <r.schtz@t-online.de>,
        "Nestor Lopez Casado" <nlopezcasad@logitech.com>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "Jiri Kosina" <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, rtitmuss@logitech.com, ogay@logitech.com,
        jzanone@logitech.com
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 22 Sep 2011, Benjamin Tissoires wrote:
>
>> Hi Richard,
>>
>> here, you'll find a small C program that allows you to do a pairing of
>> a new device to a receiver.
>>
>> compile it with with gcc -o pairing_tool pairing_tool.c
>
> Could this perhaps be provided into Documentation/ or samples/ somewhere?
> I don't think that Logitech themselves do ship pairing application for
> Linux, or do they?
>
> If they don't, it'd be nice to have this at least documented somewhere, so
> that someone could write a pairing GUI.
>
> Thanks.

Hi all,
Just as an FYI there is the Logitech Wireless WiiWheel which also uses the
nRF24L01 in it's dongle.

This wheel is handled in Linux with 'hid-lg' and 'hid-lg4ff' drivers, but
we all know engineers are lazy and a certain amount of the control
protocol is likely to be similar.

Below are some notes I made (also
http://wiibrew.org/wiki/Logitech_USB_steering_wheel).

Maybe they are of some use from the Unifying dongles.
Cheers,
Simon


--
Configuration

The Wheel/Dongle are configured by writing to the feature port of the USB
dongle. This allows the control of the 'on-air' features, such as
initiating the wireless link, controlling the RF channel/hooping sequence
and RF addressing (sub-channel coding).

When first plugged in the wireless link between the dongle and the wheel
is not active, the link can be 'brought up' with writing the '0xAF
Command' followed by the '0xB2 Command'.

The commands take some time to action, this can be confirmed by reading
back the feature port, when the command completes the MSB of the first
byte will be cleared. For most commands the same data that was sent is
returned, some commands return different data.

Configure RX/TX Address?
    Byte 1 - 0xA9
    Byte 2 - 2nd and 4th Address/Sub-Channel Bytes
    Byte 3 = 3rd and 5th Address/Sub-Channel Bytes
    Note 1st Sub-Channel byte is always 0xAE

RF Test Mode
    Byte 1 = 0xAC
    Byte 2 = Test Mode

        0 - Normal Mode (LED flashes on/off as normal)
        1 - Constant TX (LED on), RF channel in 'P3' (can kill WiFi ;-)
        2 - Pulsed TX (LED flashes long-on/short-off)
        3 - Receive Only? (LED off), RF channel in 'P3'. Continually polls
nRF24L01 status and clears

    Byte 3 - RF Channel/Frequency

Initialise communications
    Byte 1 - 0xAF
    Byte 2 - Hopping Sequence (0x00..0x0F)

Change RX/TX Address
    Byte 1 - 0xB2
    Byte 2 - 2nd and 4th Address/Sub-Channel Bytes
    Byte 3 = 3rd and 5th Address/Sub-Channel Bytes
    Note 1st Sub-Channel byte is always 0xAE

The following commands do not cause SPI activity to the nRF24L01

Check Status?
    Byte 1 - 0xA8
    Returns RX/TX Address bytes in Byte 5 and Byte 6
    Returns whether the 'button' pressed in Byte 7 bit 5
    Returns something in Byte 7 bits 4..0 related to 'LED mode' (not a
direct map)
    Returns something in Byte 8 which depends on Byte 2 sent

LED Mode
    Byte 1 - 0xAA
    Byte 2 - changes the way the LED flashes, unknown what is actually
happening

Unknown
    Byte 1 - 0xAE
    Doesn't clear Byte 1 bit 7, like the other commands. Perhaps it is
waiting for something...
    Returns 0x14 in Byte 5 and 0x00 in Byte 6

Active Address?
    Byte 1 - 0xB3
    Only clears Byte 1 bit 7 if Command '0xAF' is issued first
    Returns values in Byte 5 and Byte 6 which are the values from Command
'0xB2' Bytes 2 & 3
--

