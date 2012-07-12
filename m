Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161471Ab2GLRbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:31:36 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:60832 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755397Ab2GLRbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:31:34 -0400
To: John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 33/36] AArch64: Generic timers support
X-PHP-Originating-Script: 0:func.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 12 Jul 2012 19:31:30 +0200
From: Marc Zyngier <marc.zyngier@arm.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>,
        Mike Turquette <mike.turquette@linaro.org>,
        Marc Zyngier <maz@misterjones.org>
Organization: ARM Ltd
In-Reply-To: <4FFF01FD.4050005@linaro.org>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <1341608777-12982-34-git-send-email-catalin.marinas@arm.com> <CAKnu2MrHibKWezjEK+6oOnamkjxWnWwKfoVYRDBURZ3VkaoxEQ@mail.gmail.com> <12a7f9b8e6d0b4dc3e3f6fcf91ad2a18@localhost> <CACRpkdbMjRzTVo6o-+z6mNNkKWp1mFL76ptKd8PFV8orgFLeOg@mail.gmail.com> <4FFF01FD.4050005@linaro.org>
Message-ID: <62038bf130381e2b55cedec5f3c44760@localhost>
User-Agent: RoundCube Webmail/0.3.1
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: john.stultz@linaro.org, linus.walleij@linaro.org, dsaxena@linaro.org, tglx@linutronix.de, linus.ml.walleij@gmail.com, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, arnd@arndb.de, will.deacon@arm.com, mike.turquette@linaro.org, maz@misterjones.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2012 09:57:33 -0700, John Stultz <john.stultz@linaro.org>
wrote:
> On 07/12/2012 03:56 AM, Linus Walleij wrote:
>> On Thu, Jul 12, 2012 at 12:09 PM, Marc Zyngier <marc.zyngier@arm.com>
>> wrote:
>>
>>> On Thu, 12 Jul 2012 02:18:42 +0200, Linus Walleij
>>> <linus.ml.walleij@gmail.com> wrote:
>>>
>>> Hi Linus,
>>>
>>>> I'm reviewing the only patch I really understand...
>>>>
>>>> 2012/7/6 Catalin Marinas <catalin.marinas@arm.com>:
>>>>
>>>>> +/* This isn't really used any more */
>>>>> +#define CLOCK_TICK_RATE 1000
>>>> Is it still necessary to even have it there?
>>> It is used as part of the LATCH/TICK_* computation in
>>> include/linux/jiffies.h. It seems that any value could do, actually,
>>> and it
>>> only seem to be used in kernel/time/ntp.c. Any guidance on this much
>>> appreciated.
>>>
>>> By the way, there is a very interesting comment about this in
>>> arch/ia64/include/asm/timex.h.
>> Hmmmm paging John Stultz, TGLX, Deepak Saxena who have been in
>> this area...
> 
> Yea, its definitely crufty, but CLOCK_TICK_RATE is still important if 
> you use the jiffies clocksource (usually in the case of hardware that 
> does not support clocksources).
> 
> Basically its just trying to handle the cases where the time interval 
> 1sec/HZ  (for the various values of HZ) can not be accurately computed 
> due to the granularity of the tick device.  In those cases we use 
> CLOCK_TICK_RATE to figure out the granularity error and modify the 
> length of a jiffie,  just slightly, so it matches the hardware.
> 
> Most architectures have some sort of copy-pasted version of i386's 
> CLOCK_TICK_RATE (although I guess its possible some non-x86 systems 
> might actually have an 8253 or similar timer) and since the move to 
> GENERIC_TIME and clocksources, any incorrectly calculated error has very

> little effect on most hardware since its not used to track time.

Aarch64 mandates the ARM generic timers, and the corresponding driver
provides a (hardware based) clocksource unconditionally. This should allow
us not to use the jiffies clocksource except in very early boot.

> So following ia64's method is probably better then copying the 8253's 
> rate if you're not concerned about tick-granularity error.

The 8253 is completely meaningless in our case (though I'm sure someone
could try and bold one on the side of an Aarch64 CPU...), so going the ia64
way is probably best (erm... this last bit doesn't sound quite right,
doesn't it?).


Thanks for the detailed explanation! :)

        M.
-- 
Fast, cheap, reliable. Pick two.
