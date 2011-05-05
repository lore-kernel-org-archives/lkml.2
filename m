Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab1EENZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 09:25:31 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:62914 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab1EENZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 09:25:30 -0400
Message-ID: <613E2AF627DE4ABE92AD42D5D9E1BFE5@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Nori, Sekhar" <nsekhar@ti.com>, "Arnd Bergmann" <arnd@arndb.de>
Cc: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <sachi@mistralsolutions.com>, "Samuel Ortiz" <sameo@linux.intel.com>,
        "open list" <linux-kernel@vger.kernel.org>,
        "Watkins, Melissa" <m-watkins@ti.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <201104271605.09537.arnd@arndb.de> <CF1FC9DE1796407FB4D636189646927F@subhasishg> <201104280935.38787.arnd@arndb.de> <2543A75FDDB244D2A148C14BCAA5FD88@subhasishg> <B85A65D85D7EB246BE421B3FB0FBB593024CD0B8CC@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024CD0B8CC@dbde02.ent.ti.com>
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver.
Date: Thu, 5 May 2011 18:55:27 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am a bit lost,

If I understand correctly, there are two problems

1. In case of udev based driver loading, we will end up
loading both the drivers and the associated firmware.
This is not acceptable because both UART & CAN
use PRU0 & PRU1.

2. How do we switch between devices at run time.
This is required because MFD devices should be
capable of doing that.


Ok, if that understanding is somewhat correct, then, what we are
trying to do is load the firmware from the MFD driver itself.

So, in case of a switch between device, say from UART to CAN,
all the user has to do is copy a new firmware.

This firmware should contain some info regarding the device, like
say, device name & prunum.

So, in case a device requires both PRUs, then the firmware would
download for both PRUs.

In case a device requires only one PRU, then it can be downloaded
only into the requested PRU. So, the other PRU remains open for
any other firmware/device.

After loading the firmware, the MFD device should create the
platform devices based upon the firmware.

So, if only one PRU is used for UART, then the other PRU can be
used for CAN and the MFD should create two platform_devices.

If the UART uses both the PRUs, then the MFD should download
the firmware into both the PRUs but create only one platform_device.

But, in this case how do we download two different firmware
on two different PRUs. One way is to keep the firmware files
as its now, but add another file say firmware-config.txt,
consisting a list of parameters like,

START
MFD_ID0#0
MFD_ID0_PRU_NUM#PRU0
MFD_ID1#1
MFD_ID1_PRU_NUM#PRU1
END

OR

START
MFD_ID0#0
MFD_ID0_PRU_NUM#PRU0:PRU1
END

So, the MFD driver can do a request_firmware on this file first,
parse the device info and decide to request the main firmware.
This becomes something like the devices table that we have on
PPC.

Also, if PRU0 is loaded, we need some way of maintaining the
usage_count, So that the PRU0 is not loaded again accidently.
We can increase the usage_count from the MFD driver.
But, to decrement the usage_count, we can add an API
which will be called when the CAN or UART driver is rmmod.


Now how do we handle switch between devices.

We can either do a rmmod of the MFD driver, then again modprobe it.
So, the request_firmware is run again and the appropriate device is
loaded based upon the changed firmware-config.txt.

But, this does not look good, say what if the MFD driver is in-build.
Another way is that we can add a sysfs entry, which when written
with anything can re-evaluate the firmware_config.

What the hell, does anything make any sense ?


> Hi Subhasish,
>
> On Wed, May 04, 2011 at 12:48:43, Subhasish Ghosh wrote:
>> Hi Arnd,
>>
>> How about just doing something like:
>>
>> #> echo da8xx_pruss_uart >> firmware.bin
>>
>> i.e  just append the device name (from the board file) into the firmware
>> file.
>>
>> In the driver probe, we can parse from the bottom, when it reaches
>> "da8xx_pruss", the rest of the upper data is the firmware and from
>> the full name, we can determine if it's a CAN, UART or any other
>> peripheral.
>>
>> So, based on the platform_data, which the MFD driver received,
>> it can find out which device to initialize.
>
> If you are defining a firmware header, it may be
> worthwhile making sure you include information
> on features of the device being supported (I
> assume there will be differences in CAN features if
> the firmware uses both PRUs to support CAN versus
> UART on one PRU and CAN on another PRU).
>
> The MFD driver can parse this information and
> pass this on to the UART or CAN drivers.
>
> Thanks,
> Sekhar
>
>>
>> Also, does the line wrapping look any better ?
>>
>>
>> > On Thursday 28 April 2011 09:17:21 Subhasish Ghosh wrote:
>> >> >
>> >> > You can easily do that by adding a small header to the firmware
>> >> > format and interpret that header by the MFD driver. When the name
>> >> > of the subdevice is part of that header, the MFD driver does not
>> >> > need to understand the difference, it can simply pass that on
>> >> > when creating its child devices.
>> >>
>> >> I don't understand why loading the firmware should be done at the MFD
>> >> driver.
>> >> The user already specifies the device he/she wants to start on the PRU
>> >> via
>> >> modprobe.
>> >> A driver can be inserted, which can download a printer firmware on one
>> >> PRU
>> >> and a
>> >> scanner firmware on the other. This way both cores can be used for
>> >> separate
>> >> purposes.
>> >> I mean, say in a real MFD controller, that will also have two separate
>> >> cores
>> >> running on it,
>> >> just that, the firmware on it would not be downloaded runtime but 
>> >> fused
>> >> in
>> >> some non volatile memory.
>> >
>> > Then I must be misreading what your code currently does, because it 
>> > does
>> > not
>> > match your explanations. What I see in the platform code is that you
>> > create
>> > MFD cells for specific devices that get automatically created by the 
>> > MFD
>> > driver. This will cause udev to load the drivers for these devices, 
>> > which
>> > then load the firmware they need.
>> >
>> > Also, I cannot see how the method you describe would make it possible 
>> > to
>> > the same driver into both units, e.g. when you want to have two serial
>> > ports. The reason is that you currently hardcode the PRU number in the
>> > driver and that you cannot load a single driver twice.
>> >
>> > Finally, I'm trying to make sure that whatever solution you come up 
>> > with
>> > will still work when we migrate the code to using a flattened device 
>> > tree.
>> > In that case, you would ideally put the device firmware into the device
>> > tree as a property that matches whatever you have connected on the
>> > specific
>> > board (at least as an option, you can still fall back to
>> > request_firmware).
>> > You definitely want automatic module loading in that case.
>> >
>> > Note that using module loading with specific parameters in order to
>> > match the hardware is not a recommended procedure any more. The code
>> > really needs to work the same way when all drivers are built into the
>> > kernel. It should not be hard to use the firmware loading mechanism
>> > in the MFD driver to both load the firmware and configure the devices
>> > appropriately so we always use the right driver for the currently
>> > active devices.
>> >
>> > Arnd
>> >
>> > BTW, something is wrong with your email client line wrapping. I've 
>> > fixed
>> > this up manually before when replying, but please find a way to get 
>> > this
>> > right in the future.
>>
>>
> 
