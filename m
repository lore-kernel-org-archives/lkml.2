Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab1CRWs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 18:48:27 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46996 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab1CRWsV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 18:48:21 -0400
MIME-Version: 1.0
In-Reply-To: <4D83A535.4090806@wildgooses.com>
References: <20110317181757.GM9597@angua.secretlab.ca> <1300471949-29366-1-git-send-email-kernel@wildgooses.com>
 <4D83A535.4090806@wildgooses.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 18 Mar 2011 16:48:01 -0600
X-Google-Sender-Auth: 0pXWoQPGa0aHsLu1uFslqzv1YqI
Message-ID: <AANLkTinJNFZ-c_+Cuan5ebuRadrOvdfivxQjnN9GZPt=@mail.gmail.com>
Subject: Re: [PATCH] leds: New PCEngines Alix LED driver using gpio interface
To: Ed W <lists@wildgooses.com>
Cc: dilinger@queued.net, linux-geode@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 12:32 PM, Ed W <lists@wildgooses.com> wrote:
> Hi, Thanks for "mentoring" me over this.  I appreciate that this
> consumes your valuable time
>
> I have reposted what I hope is close to the correct code for this new
> driver.  I'm somewhat apprehensive, so to draw attention to the things I
> have most likely "done wrong":
>
>
>> :000000 100644 0000000... bc1b3b3... A        arch/x86/platform/geode/alix_leds.c
>
> ...
>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index d5ed94d..b16ab56 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -2094,6 +2094,15 @@ config OLPC_OPENFIRMWARE_DT
>>       default y if OLPC_OPENFIRMWARE && PROC_DEVICETREE
>>       select OF_PROMTREE
>>
>> +config ALIX_LEDS
>> +     bool "PCEngines ALIX.2/.3 LED Support"
>> +     select GPIOLIB
>> +     depends on LEDS_CLASS
>> +     depends on LEDS_GPIO_PLATFORM && GPIO_CS5535
>> +     ---help---
>> +       This option enables support for the PCEngines ALIX.2 and ALIX.3 LEDs.
>> +       You have to set alix-leds.force=1 for boards with Award BIOS.
>> +
>>  endif # X86_32
>
>
> Driver and KConfig show this being specifically a driver for the Alix
> LEDs rather than being a general Alix plaform initialisation module?
>
> I was unsure if the trend was to have one module which initialised all
> Alix platform stuff (whatever it needs), or to split by function?
> Looking at other platform modules they seem to be somewhat fine grained
> so I went with a specific "ALIX Led Module" approach?

That's very much up to the board maintainer.  Because it is just
device registrations, I would lump them all into one file.  If they
were actual drivers then I tend to split them up.

> Additionally I am unsure how strictly to set dependencies for my module?
>  It clearly requires all the LED_GPIO_PLATFORM, GPIO_CS5535 dependencies
> to do anything, but equally it doesn't seem to *break* anything if those
> dependencies aren't compiled in?  Listing all the dependencies seems to
> make it hard for users to find the option to enable it since it's not
> even listed in menuconfig until your deps are met?  Please correct me as
> to what level of deps should be listed?

Correct, you don't need to depend on the driver because this is just a
device registration.  Who cares if it never gets bound to the driver?
The device registration will happily sit in the device model
unregistered.

> On the topic of dependencies, Andres has changed cs5535-gpio.c to depend
> on a new module cs5535-mfd - however, apart from the commit log message
> this is not obvious to see?  OK, I'm an idiot, but it took me most of
> this afternoon to understand why my GPIOs stopped working after moving
> to 2.6.38?  Q: Should the new -mfd module be listed as a dep of -gpio?
> Or perhaps -gpio should "select" -mfd? At least it would be helpful to
> list the dependency in the Kconfig message?

select is a little touchy because selecting another symbol bypasses
and dependences the other symbol has.  In this case, it could skip
CONFIG_MFD_CORE which may be bad.  -gpio should be a dependancy of
-mfd in this case I think.

g.
