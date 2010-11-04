Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab0KDVQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 17:16:31 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.106]:20226
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751849Ab0KDVQa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 17:16:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApEBADO/0kzL2THB/2dsb2JhbAAH4RyFRgSFD4hn
X-IronPort-AV: E=Sophos;i="4.58,298,1286121600"; 
   d="scan'208";a="729296279"
Subject: Re: [W1] a driver for DS2405 chip
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Ben Nizette <bn@niasdigital.com>
In-Reply-To: <4CD3112D.2010700@o2.pl>
Date: Fri, 5 Nov 2010 08:16:24 +1100
Cc: Jonathan Cameron <jic23@cam.ac.uk>, johnpol@2ka.mipt.ru,
        linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <6F19858A-1110-4B0C-9810-350567CE9A9A@niasdigital.com>
References: <4CC9E2A5.2010400@o2.pl> <4CCEB42F.8000102@cam.ac.uk> <4CD06C22.20204@o2.pl> <6B41915B-1667-4CA1-A73A-45B043ED8C11@niasdigital.com> <4CD3112D.2010700@o2.pl>
To: Maciej Szmigiero <mhej@o2.pl>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/11/2010, at 7:01 AM, Maciej Szmigiero wrote:

> W dniu 03.11.2010 11:54, Ben Nizette pisze:
>> 
>> On 03/11/2010, at 6:53 AM, Maciej Szmigiero wrote:
>> 
>>> W dniu 01.11.2010 13:35, Jonathan Cameron pisze:
>>>> On 10/28/10 21:52, Maciej Szmigiero wrote:
>>>>> [W1] a driver for DS2405 chip
>>>>> 
>>>>> This is a driver for DS2405 1-wire single-channel addressable switch / PIO.
>>>>> DS2405 can also work as single-channel binary remote sensor.
>>>> Perhaps handle this as a gpio chip? (be it a fairly limited one)
>>>> To my mind it would make it more generally useful...
>>> 
>>> I think the GPIO infrastructure is meant for on-system GPIOs, where 1-wire devices are mostly 
>>> used for remote data acquisition.
>> 
>> Nope!  The contents of drivers/gpio is split roughly 50/50 between on- and off-chip gpio expanders. 
>> 
>>> That's probably why w1_therm (for 1-wire thermometers) is not integrated with HWMON subsystem.
>> 
>> Don't know why this is but kinda sounds like it should be looked at more closely - conceptually 1-W is just another bus like, eg, SPI.
>> 
>> 	--Ben.
> 
> 
> Looking at GPIO subsystem I think it's not a best solution for this device. One reason is that GPIOs are
> identified by integer which is either #defined by platform (as Documentation/gpio.txt says) or assigned randomly.
> 
> First approach obviously doesn't fit, as I'm yet to find anybody using ds2405 for anything platform-related.
> Second leads to problems in locating particular device (numbers will depend on order of detection/plugging).
> In contrast with that, 1W subsystem provides clear and unique identification for every device as it appears under
> its hardware address.

Yeah I've never completely loved the randomness of this however it's hard to think of a better generic way to do this.  Note though that once a gpiochip is registered there are /sys/class/gpio/gpiochipN items that provide all the information required to work out what's going on.

> 
> In addition to that the chip removal code (gpiochip_remove() function) does not sleep when removal fails due
> to chip being in use, returning EBUSY instead. 
> This leads to inefficient unplugging (like trying to remove chip in loop hoping that finally somebody releases it).
> Probably this loop will also have to check if device reappeared, so the driver doesn't try to register new instance of chip
> while there is still one in existence.

Good point.  Sounds like it would be a good addition to gpiolib in general, would be useful for other hotpluggable busses too

> Note that Documentation/gpio.txt says "Removing a GPIO controller should be rare; use gpiochip_remove() when it is unavoidable".
> Characteristics of long W1 buses cause devices to disappear and reappear from time to time so it won't be a "rare" operation here.

I don't know the history of that statement, sounds more like an implementation detail than a 'feature'.  Maybe David has more detail?

> 
> And all this added complexity for what? - to replace two tiny attributes under device sysfs directory?

Well that and standardisation!  However it does seem that while conceptually your device should present a gpio interface it's on the fringe of what gpiolib was designed to do.  I'd understand if you don't feel like making gpiolib better support hotpluggable devices however it sounds like it'd be worth doing, not just for 1-W but also, eg, USB GPIO expanders.

	--Ben.

> 
> Maciej Szmigiero

