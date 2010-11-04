Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab0KDUB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 16:01:59 -0400
Received: from moh2-ve3.go2.pl ([193.17.41.208]:36945 "EHLO moh2-ve3.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385Ab0KDUB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 16:01:57 -0400
Message-ID: <4CD3112D.2010700@o2.pl>
Date: Thu, 04 Nov 2010 21:01:49 +0100
From: Maciej Szmigiero <mhej@o2.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101024 Lightning/1.0b3pre Thunderbird/3.1.5
MIME-Version: 1.0
To: Ben Nizette <bn@niasdigital.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>, johnpol@2ka.mipt.ru,
        linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [W1] a driver for DS2405 chip
References: <4CC9E2A5.2010400@o2.pl> <4CCEB42F.8000102@cam.ac.uk> <4CD06C22.20204@o2.pl> <6B41915B-1667-4CA1-A73A-45B043ED8C11@niasdigital.com>
In-Reply-To: <6B41915B-1667-4CA1-A73A-45B043ED8C11@niasdigital.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-O2-Trust: 2, 63
X-O2-SPF: neutral
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 03.11.2010 11:54, Ben Nizette pisze:
> 
> On 03/11/2010, at 6:53 AM, Maciej Szmigiero wrote:
> 
>> W dniu 01.11.2010 13:35, Jonathan Cameron pisze:
>>> On 10/28/10 21:52, Maciej Szmigiero wrote:
>>>> [W1] a driver for DS2405 chip
>>>>
>>>> This is a driver for DS2405 1-wire single-channel addressable switch / PIO.
>>>> DS2405 can also work as single-channel binary remote sensor.
>>> Perhaps handle this as a gpio chip? (be it a fairly limited one)
>>> To my mind it would make it more generally useful...
>>
>> I think the GPIO infrastructure is meant for on-system GPIOs, where 1-wire devices are mostly 
>> used for remote data acquisition.
> 
> Nope!  The contents of drivers/gpio is split roughly 50/50 between on- and off-chip gpio expanders. 
> 
>> That's probably why w1_therm (for 1-wire thermometers) is not integrated with HWMON subsystem.
> 
> Don't know why this is but kinda sounds like it should be looked at more closely - conceptually 1-W is just another bus like, eg, SPI.
> 
> 	--Ben.


Looking at GPIO subsystem I think it's not a best solution for this device. One reason is that GPIOs are
identified by integer which is either #defined by platform (as Documentation/gpio.txt says) or assigned randomly.

First approach obviously doesn't fit, as I'm yet to find anybody using ds2405 for anything platform-related.
Second leads to problems in locating particular device (numbers will depend on order of detection/plugging).
In contrast with that, 1W subsystem provides clear and unique identification for every device as it appears under
its hardware address.

In addition to that the chip removal code (gpiochip_remove() function) does not sleep when removal fails due
to chip being in use, returning EBUSY instead. 
This leads to inefficient unplugging (like trying to remove chip in loop hoping that finally somebody releases it).
Probably this loop will also have to check if device reappeared, so the driver doesn't try to register new instance of chip
while there is still one in existence.
Note that Documentation/gpio.txt says "Removing a GPIO controller should be rare; use gpiochip_remove() when it is unavoidable".
Characteristics of long W1 buses cause devices to disappear and reappear from time to time so it won't be a "rare" operation here.

And all this added complexity for what? - to replace two tiny attributes under device sysfs directory?

Maciej Szmigiero
