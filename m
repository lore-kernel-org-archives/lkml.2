Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab2KNJlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 04:41:04 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:41548 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932776Ab2KNJk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 04:40:58 -0500
Date: Wed, 14 Nov 2012 10:40:50 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Till Harbaum <till@harbaum.org>
Subject: Re: [PATCH 1/2] i2c: Add possibility for user-defined (i2c-)devices
  for bus-drivers.
Message-ID: <20121114104050.79df8cd9@endymion.delvare>
In-Reply-To: <50A2DA0C.3090507@ahsoftware.de>
References: <1352829968-4908-1-git-send-email-holler@ahsoftware.de>
	<20121113195533.6db71716@endymion.delvare>
	<50A2AC28.7050304@ahsoftware.de>
	<20121113220835.111a178a@endymion.delvare>
	<50A2BAA2.6090009@ahsoftware.de>
	<20121113224246.768bf734@endymion.delvare>
	<50A2DA0C.3090507@ahsoftware.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012 00:38:52 +0100, Alexander Holler wrote:
> Am 13.11.2012 22:42, schrieb Jean Delvare:
> > Question is, what will you do the day someone wants to instantiate a
> > device for which the default probing mechanism doesn't work?
> 
> Do you solve all problems you and others might have in the future 
> already now?

Not all. But at least I try to avoid artificial limitations when
writing new code and to anticipate misbehavior in use cases other than
my own. I also try to learn from our past collective mistakes (starting
with my own.)

For clarity: it doesn't matter if new code doesn't cover all possible
present and future use cases, but it should not allow users to screw up
their system, and it should be possible to extend it to other
foreseeable use cases without breaking compatibility or making the code
unmaintainable or the interface ugly and confusing.

> > Plus you don't address the main issues. Your syntax gives you no way to
> > support two i2c-tiny-usb adapters with different chips at a specific
> > address. The sysfs interface supports such a setup. Also instantiating
> 
> It isn't possible to do such, because the only ID available for 
> i2c-busses is given them at runtime. So people have to live with that 
> imho artificially problem, if they use my patch. I don't have any other 
> solution until the numbering is predictable. But I assume you already 
> know all that, otherwise you wouldn't have mentioned it.

The problem is inherent to external, hot-plug I2C adapters. You can't
predict their bus number, and actually you can't even always predict
their name. In the case of usb-tiny-i2c, you may be able to look-up the
bus number from the adapter name, but you won't be able to always
differentiate between two adapters, if they are connected to paired USB
ports.

This is a design issue with the i2c-tiny-usb hardware in the first
place. If it is needed to differentiate between adapters, their would
need to be a locally unique ID in every adapter, which the kernel can
query. I suppose this was not deemed necessary at design time, as most
people will only connect one such adapter at a time to their system.

So I would agree that the problem I pointed out probably doesn't exist
in practice. Still, the limitation should at least be documented.

> > the wrong devices is worse than instating a device that doesn't exist
> > at all. So the use of i2c_new_probed_device() here will randomly help
> > in a limited number of cases and randomly be problematic in others.
> > Hard to justify...
> 
> So would you be satisfied if I would make the syntax more complicated by 
> adding something which would allow them to define if the devices gets 
> probed? E.g. dev1@addr1,dev2@addr2.noprobe,... ?

No. I would be more satisfied (although still not thinking your code
should make it into the kernel - but I am no longer the one to decide)
if you did use i2c_new_device() instead of i2c_new_probed_device(). You
said yourself that this module parameter was for users who knew what
they were doing.

> > I am not familiar with RTC constraints. What is so important about it
> > that it can't wait for user-space? It'll have to wait for the USB and
> > I2C stacks to initialize anyway, so it won't be available at the very
> > early stages of the boot.
> 
> Try playing with a system which does have the wrong time. There is so 
> much stuff which depends on the correct time, it is just a pain if the 
> time is wrong or even the same across multiple system starts. And even 
> if you know that, you might e.g. forget it and will use git to send some 
> email and patches with erroneous times. But that is just an example.

I have already experienced this and yes, it is a pain. But I would
think that a system designed without a RTC in the first place has
another way of getting its time correct at boot time, for example NTP.
As I understand it the RTC chip is only there to set the system time at
boot, right, the actual timekeeping during run-time is still done by the
CPU?

> And as I said, there might some other devices you might want or need in 
> the future before usespace starts, so it solves a problem as the one 
> above which I didn't have solved. ;)

Or maybe this will never happen.

-- 
Jean Delvare
