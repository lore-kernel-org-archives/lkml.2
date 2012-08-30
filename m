Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677Ab2H3Ht4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 03:49:56 -0400
Received: from webbox1416.server-home.net ([77.236.96.61]:58169 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750879Ab2H3Htz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 03:49:55 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Feng Tang <feng.tang@intel.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: Re: i2c-eg20t: regression since i2c_add_numbered_adapter change
Date: Thu, 30 Aug 2012 09:49:52 +0200
Message-ID: <4378288.tkkLiQ5MQ7@ws-stein>
User-Agent: KMail/4.8.5 (Linux/3.4.9-gentoo; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20120829204031.648a73e1@endymion.delvare>
References: <4401854.hVfHzgeqjT@ws-stein> <20120823162852.29243e9c@feng-i7> <20120829204031.648a73e1@endymion.delvare>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jean,

On Wednesday 29 August 2012 20:40:31, Jean Delvare wrote:
> Looks like what media and sound drivers are/were doing to assign fixed
> numbers to their devices. But my understanding is that this is a legacy
> thing and nobody should need to use that any longer. Adding this to all
> or even some i2c bus drivers looks like the wrong example to follow. If
> your system has more than one device supported by the driver, it
> doesn't even reliably guarantee fixed I2C bus numbers (especially if
> some can be hot-plugged.)

I'm aware that this is more than less a workaround to the current problem which arose from the change to i2c_add_numbered_adapter.
The sitation before that where i2c-eg20t just used i2c_add_adapter wasn't perfect either.

> > > > The reason we need a fixed number is it is easier for platform code
> > > > which needs to register dozens of i2c devices to different controllers
> > > > with i2c_register_board_info, and they need provide a bus number for
> > > > each i2c device, this _binding_ info is not detectable but have to
> > > > be fixed.
> 
> Whenever you call i2c_register_board_info(), every I2C bus number
> referenced in the I2C device list passed as a parameter is reserved for
> static I2C bus numbers, dynamic I2C bus numbers will never overlap.
> 
> So in the quoted example, if i2c-isch is able to dynamically pick I2C
> bus number 0 while i2c-eg20t want it statically, it means that either
> no device was declared on bus 0 with i2c_register_board_info(), or
> i2c_register_board_info() was called too late in the game.

In my case i2c_register_board_info is never called due to a non-existant platform setup (see below).

> Note that there was an assumption at the time the code was written,
> that there was no need or reason to reserve a static I2C bus number if
> no slave device was declared on said I2C bus. I never much liked it but
> it never caused problems so far. This means that either:
> * you call i2c_register_board_info() to register your slave I2C devices
>   and all the affected I2C bus drivers call i2c_add_numbered_adapter();
>   or
> * you don't call i2c_register_board_info() and all I2C bus drivers call
>   i2c_add_adapter().
> You can't mix, i.e. if you don't register any slave device on a bus but
> the bus driver still calls i2c_add_numbered_adapter(), it may fail.
> 
> If this is a problem now on some systems, it should be easy enough to
> work around by adding a specific function to reserve an I2C bus number
> for static allocation, even without declaring any slave device on it.
> This function would be called at the same time
> i2c_register_board_info() typically is.

IMO the i2c_register_board_info only works in quite static setups. Especially with I2C-Busses attached to hotplugable PCI devices this way doesn't work reliable any more.
The device come and go dynamically so you can't assume fixed mapping.

> > > Yes, I'm aware of that. With "Why use a fixed one?" I meant why hard-code it into the driver. I should be changeable.
> > > Because this is/was not possible in general to use i2c_register_board_info, so we used an echo to /sys/bus/i2c/devices/i2c-0/new_device or /sys/bus/i2c/devices/i2c-1/new_device.
> 
> Please elaborate on "this is/was not possible in general to use
> i2c_register_board_info." You are supposed to call it as part of your
> platform setup, so if it is not possible for you, whatever the problem
> is needs to be addressed.

The problem here is that AFAIK on x86 there is no platform setup to e.g. register platform devices. So you depend on the order the drivers and devices are bound.
In 3.0.x we get a static numbering due to this order. As there is no platform setup we register our I2C devices with /sys/bus/i2c/devices/i2c-[01]/new_device as some of our sensors can't be auto-detected.

> > Yeah, our EG20T kernel used to use the same "echo /sys/bus/i2c/devices/i2c-x/new_device"
> > way, but we found out it is not convenient for:
> > 1. needs extra user space script, why not make it just work in kernel after
> > boot? We have several i2c devices like touchscreen/radio which we wants them
> > just work without depending user space action.
> 
> It should indeed be handled all in kernel space, using
> i2c_register_board_info().

I know this mechanism for ARM, but how can this be done on x86 architecture?
But even with this, how does this address the random occurance of hotplugable bus masters?

> > 2. The i2c bus number is not fixed, which make the user space script even
> > harder, as that number depends whether we compile into kernel all the i2c
> > controllers (eg20t and isch) and whether these driver are compiled as
> > modules and their loading order.
> 
> You can always look-up the right I2C bus number based on its name,
> assuming your driver properly names them. There is some code doing that
> at:
> http://www.lm-sensors.org/browser/i2c-tools/trunk/tools/i2cbusses.c#L297
> 
> Ideally this code should move to libi2c and/or i2cdetect should offer
> an interface to it, so it can easily be called from custom tools and
> scripts.

You either need this get the current (maybe non-fixed) bus number and attach the devices by new_device or there is some in-kernel or udev related mechanism which returns the current bus number from some unique deivce path or description.

Best regards,
Alexander

