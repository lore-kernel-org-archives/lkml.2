Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab0CSQzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 12:55:20 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54624 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab0CSQzT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 12:55:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IMrltgYKcLj3uOT49UBs0MLSpKJwBjcwsL6BRWAjVK19U4oYuvKuIdh2EQuR9YZS0H
         FcD8dvwjyKotzd4Kh6216j876e5hwgalTEDgG4IROnCXKJQOP4oALkVsPLS9C9AjZ5SJ
         P1spvX7/DTPZh/DFzYD1sC+Sp2hRq2Tg6nzKU=
MIME-Version: 1.0
In-Reply-To: <1268950758.4171.51.camel@localhost.localdomain>
References: <1268877702-2236-1-git-send-email-johnstul@us.ibm.com>
	 <4BA23974.5030503@twiddle.net> <1268934923.1855.8.camel@work-vm>
	 <20100318214030.GA8934@jurassic.park.msu.ru>
	 <1268950758.4171.51.camel@localhost.localdomain>
Date: Fri, 19 Mar 2010 12:47:48 -0400
Message-ID: <b4198de61003190947o2a045524h4ed9c228427430cb@mail.gmail.com>
Subject: Re: [RFC][PATCH] Convert alpha to use clocksource
From: Matt Turner <mattst88@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 6:19 PM, john stultz <johnstul@us.ibm.com> wrote:
> On Fri, 2010-03-19 at 00:40 +0300, Ivan Kokshaysky wrote:
>> On Thu, Mar 18, 2010 at 10:55:23AM -0700, john stultz wrote:
>> > On Thu, 2010-03-18 at 07:32 -0700, Richard Henderson wrote:
>> > > On 03/17/2010 07:01 PM, John Stultz wrote:
>> > > > Alpha has a tsc like rpcc counter that it uses to manage time.
>> > > > This can be converted to an actual clocksource instead of utilizing
>> > > > the arch_gettimeoffset method that is really only there for legacy
>> > > > systems with no continuous counter.
>> > >
>> > > With 8 seconds or less between roll-overs, do you actually consider
>> > > this a continuous counter?  I don't.  I suggest this be left alone.
>> >
>> > The timekeeping code handles this (although the shift value I picked may
>> > need some adjustment - what is the expected counter freq range on
>> > alpha?). The ACPI PM counter which is very common on x86 is only 24 bits
>> > and rolls over in ~5 seconds. It works fine.
>>
>> Yeah, that looks cool. I'm typing this on the 800MHz UP1500 running
>> 2.6.34-rc1 plus your patch, and the timekeeping works fine so far.
>
> Nice! Thanks for testing! Another benefit that I forgot to mention, is
> that NTP adjustments will be made directly against the counter, instead
> of being made against the tick. This avoids possible small errors at
> tick time if the intertick interval doesn't match the actual tick
> length.
>
>
>> Though, even after a glance over the clocksource code, I've not
>> gotten yet to how one could estimate the "shift" value...
>> Any hints?
>
> Yea, selecting a good shift is obnoxious. You want to pick the largest
> value of shift, so that it can be finely adjusted by ntp, but that
> creates large mult values, which can cause overflows for large cycle
> intervals.
>
> A function to solve this was actually recently added, but simply I
> forgot to use it. :P
>
> I actually should rework the register function so you just give it a
> clocksource and a freq and it sets up both mult and shift for you.
>
>
>> And if I recall correctly, production alphas have been clocked
>> in the range of 60-1250 MHz.
>
> Cool. The shift value I picked should be ok then. But below is an
> updated version that uses the self-calculated method.
>
> thanks
> -john
>
>
>
> >From 078e91d14cb5e82a3fab00cf74faf45f44336590 Mon Sep 17 00:00:00 2001
> From: John Stultz <johnstul@us.ibm.com>
> Date: Wed, 17 Mar 2010 12:43:11 -0700
> Subject: [PATCH] Convert alpha to use clocksources instead of arch_gettimeoffset
>
> Alpha has a tsc like rpcc counter that it uses to manage time.
> This can be converted to an actual clocksource instead of utilizing
> the arch_gettimeoffset method that is really only there for legacy
> systems with no continuous counter.
>
> Further cleanups could be made if alpha converted to the clockevent model.
>
> I've not tested or compiled this code. Any help from the maintainers would
> be greatly appreciated
>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Richard Henderson <rth@twiddle.net>
> CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> CC: Matt Turner <mattst88@gmail.com>
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> ---
>  arch/alpha/Kconfig       |    4 --
>  arch/alpha/kernel/time.c |   69 ++++++++++++++++++++-------------------------
>  2 files changed, 31 insertions(+), 42 deletions(-)
>
> diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
> index 75291fd..793c269 100644
> --- a/arch/alpha/Kconfig
> +++ b/arch/alpha/Kconfig
> @@ -51,10 +51,6 @@ config GENERIC_TIME
>        bool
>        default y
>
> -config ARCH_USES_GETTIMEOFFSET
> -       bool
> -       default y
> -
>  config ZONE_DMA
>        bool
>        default y
> diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
> index 5d08266..a2be26b 100644
> --- a/arch/alpha/kernel/time.c
> +++ b/arch/alpha/kernel/time.c
> @@ -51,6 +51,7 @@
>  #include <linux/mc146818rtc.h>
>  #include <linux/time.h>
>  #include <linux/timex.h>
> +#include <linux/clocksource.h>
>
>  #include "proto.h"
>  #include "irq_impl.h"
> @@ -301,6 +302,34 @@ rpcc_after_update_in_progress(void)
>        return rpcc();
>  }
>
> +#ifndef CONFIG_SMP
> +/* Until and unless we figure out how to get cpu cycle counters
> +   in sync and keep them there, we can't use the rpcc.  */
> +static cycle_t read_rpcc(struct clocksource *cs)
> +{
> +       cycle_t ret = (cycle_t)rpcc();
> +       return ret;
> +}
> +
> +static struct clocksource clocksource_rpcc = {
> +       .name                   = "rpcc",
> +       .rating                 = 300,
> +       .read                   = read_rpcc,
> +       .mask                   = CLOCKSOURCE_MASK(32),
> +       .flags                  = CLOCK_SOURCE_IS_CONTINUOUS
> +};
> +
> +static inline void register_rpcc_clocksource(long cycle_freq)
> +{
> +       clocksource_calc_mult_shift(&clocksource_rpcc, cycle_freq, 4);
> +       clocksource_register(&clocksource_rpcc);
> +}
> +#else /* !CONFIG_SMP */
> +static inline void register_rpcc_clocksource(long cycle_freq)
> +{
> +}
> +#endif /* !CONFIG_SMP */
> +
>  void __init
>  time_init(void)
>  {
> @@ -391,6 +420,8 @@ time_init(void)
>                __you_loose();
>        }
>
> +       register_rpcc_clocksource(cycle_freq);
> +
>        state.last_time = cc1;
>        state.scaled_ticks_per_cycle
>                = ((unsigned long) HZ << FIX_SHIFT) / cycle_freq;
> @@ -402,44 +433,6 @@ time_init(void)
>  }
>
>  /*
> - * Use the cycle counter to estimate an displacement from the last time
> - * tick.  Unfortunately the Alpha designers made only the low 32-bits of
> - * the cycle counter active, so we overflow on 8.2 seconds on a 500MHz
> - * part.  So we can't do the "find absolute time in terms of cycles" thing
> - * that the other ports do.
> - */
> -u32 arch_gettimeoffset(void)
> -{
> -#ifdef CONFIG_SMP
> -       /* Until and unless we figure out how to get cpu cycle counters
> -          in sync and keep them there, we can't use the rpcc tricks.  */
> -       return 0;
> -#else
> -       unsigned long delta_cycles, delta_usec, partial_tick;
> -
> -       delta_cycles = rpcc() - state.last_time;
> -       partial_tick = state.partial_tick;
> -       /*
> -        * usec = cycles * ticks_per_cycle * 2**48 * 1e6 / (2**48 * ticks)
> -        *      = cycles * (s_t_p_c) * 1e6 / (2**48 * ticks)
> -        *      = cycles * (s_t_p_c) * 15625 / (2**42 * ticks)
> -        *
> -        * which, given a 600MHz cycle and a 1024Hz tick, has a
> -        * dynamic range of about 1.7e17, which is less than the
> -        * 1.8e19 in an unsigned long, so we are safe from overflow.
> -        *
> -        * Round, but with .5 up always, since .5 to even is harder
> -        * with no clear gain.
> -        */
> -
> -       delta_usec = (delta_cycles * state.scaled_ticks_per_cycle
> -                     + partial_tick) * 15625;
> -       delta_usec = ((delta_usec / ((1UL << (FIX_SHIFT-6-1)) * HZ)) + 1) / 2;
> -       return delta_usec * 1000;
> -#endif
> -}
> -
> -/*
>  * In order to set the CMOS clock precisely, set_rtc_mmss has to be
>  * called 500 ms after the second nowtime has started, because when
>  * nowtime is written into the registers of the CMOS clock, it will
> --
> 1.6.0.4

Thanks a lot for the patch, John.

Richard, if your concerns are met, I'll get this into my tree.

Matt
