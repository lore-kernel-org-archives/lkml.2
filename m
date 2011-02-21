Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab1BUPSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 10:18:10 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45720 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab1BUPSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 10:18:08 -0500
Date: Mon, 21 Feb 2011 15:17:52 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: John Linn <John.Linn@xilinx.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
        glikely@secretlab.ca, jamie@jamieiles.com
Subject: Re: [PATCH V4 3/4] ARM: Xilinx: base header files and assembly
	macros
Message-ID: <20110221151752.GR14495@n2100.arm.linux.org.uk>
References: <1298052881-14591-1-git-send-email-john.linn@xilinx.com> <201102210936.42098.arnd@arndb.de> <c3cdf33d-2163-4417-bc64-7637f5c211e0@VA3EHSMHS021.ehs.local> <201102211548.36296.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102211548.36296.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 03:48:36PM +0100, Arnd Bergmann wrote:
> On Monday 21 February 2011, John Linn wrote:
> > > It would be better if you could avoid introducing new uses of
> > > CLOCK_TICK_RATE, because that will have to be removed before we can
> > > move to a real multi-platform kernel. For instance, you can put
> > > PERIPHERAL_CLOCK_RATE in a hardware specific header and put a bogus
> > > definition for CLOCK_TICK_RATE into timex.h
> > 
> > Hi Arnd,
> > 
> > I can remove the use of it from my timer code, but I still see
> > CLOCK_TICK_RATE 
> > being used in linux/jiffies.h.
> > 
> > I tried removing it and got build errors.  Am I missing something there?
> > 
> 
> You still need to have some definition for CLOCK_TICK_RATE to make
> the jiffies code compile, but the actual value no longer matters.

This is what I said a while back:
| If you switch to clocksource/clockevents, then I think CLOCK_TICK_RATE
| is irrelevant as time advances according to the interval measured by
| the previous and current clocksource read, rather than 1/HZ intervals.
| 
| However, I'm never happy to say "just set CLOCK_TICK_RATE to some random
| value that's a multiple of HZ" because I can't convince myself that these
| don't have any effect when using clocksources.  The list of symbols which
| depend on CLOCK_TICK_RATE are:
| 
| ACTHZ
| LATCH
| TICK_NSEC
| TICK_USEC_TO_NSEC
| LOW_RES_NSEC
| MONOTONIC_RES_NSEC
| NSEC_PER_JIFFY
| KTIME_LOW_RES
| 
| and if you grep for those outside of arch/, you find them being used in
| a fair amount of code under kernel/, as well as the odd driver here and
| there.

Eg, LOW_RES_NSEC is exported to userspace via the posix clocks interface.

NSEC_PER_SEC and TICK_NSEC are used for cmos clock updates, so probably
don't matter too much there.  TICK_NSEC is also used by the scheduler,
time conversions (timespec/timeval to/from jiffies) and profiling code.

NSEC_PER_JIFFY is used by the jiffy clocksource code, which only matters
if you don't have your own clocksource.

So, I feel very uneasy about saying that CLOCK_TICK_RATE doesn't matter
anymore given all the places which reference something that's derived
from it.

Here's the result of grepping for the above symbols:

drivers/oprofile/timer_int.c:   hrtimer_forward_now(hrtimer, ns_to_ktime(TICK_NSEC));
drivers/oprofile/timer_int.c:   hrtimer_start(hrtimer, ns_to_ktime(TICK_NSEC),
include/linux/acct.h:#if (TICK_NSEC % (NSEC_PER_SEC / AHZ)) == 0
include/linux/acct.h:        u64 tmp = (u64)x * TICK_NSEC;
include/linux/hrtimer.h:# define MONOTONIC_RES_NSEC     HIGH_RES_NSEC
include/linux/hrtimer.h:# define MONOTONIC_RES_NSEC     LOW_RES_NSEC
include/linux/hrtimer.h:# define KTIME_MONOTONIC_RES    KTIME_LOW_RES
include/linux/jiffies.h:/* TICK_NSEC is the time between ticks in nsec assuming
real ACTHZ */
include/linux/jiffies.h:#define TICK_NSEC (SH_DIV (1000000UL * 1000, ACTHZ, 8))
include/linux/jiffies.h:/* TICK_USEC_TO_NSEC is the time between ticks in nsec assuming real ACTHZ and  */
include/linux/jiffies.h:#define TICK_USEC_TO_NSEC(TUSEC) (SH_DIV (TUSEC * USER_HZ * 1000, ACTHZ, 8))
include/linux/jiffies.h: * is: TICK_NSEC (which is defined in timex.h).  This
include/linux/jiffies.h:#if !((((NSEC_PER_SEC << 2) / TICK_NSEC) << (SEC_JIFFIE_SC - 2)) & 0x80000000)
include/linux/jiffies.h:                                TICK_NSEC -1) / (u64)TICK_NSEC))
include/linux/jiffies.h:                                        TICK_NSEC -1) /
(u64)TICK_NSEC))
include/linux/jiffies.h:                                        TICK_NSEC -1) /
(u64)TICK_NSEC))
include/linux/jiffies.h:        (long)((u64)((u64)MAX_JIFFY_OFFSET * TICK_NSEC)
/ NSEC_PER_SEC)
include/linux/jiffies.h:        (SH_DIV((MAX_JIFFY_OFFSET >> SEC_JIFFIE_SC) * TICK_NSEC, NSEC_PER_SEC, 1) - 1)
include/linux/ktime.h:#define LOW_RES_NSEC              TICK_NSEC
include/linux/ktime.h:#define KTIME_LOW_RES             (ktime_t){ .tv64 = LOW_RES_NSEC }
kernel/hrtimer.c:                       .resolution = KTIME_LOW_RES,
kernel/hrtimer.c:                       .resolution = KTIME_LOW_RES,
kernel/perf_event.c:    u64 interval = (u64)cpuctx->jiffies_interval * TICK_NSEC;
kernel/perf_event.c:            if (delta > 0 && delta < 2*TICK_NSEC)
kernel/posix-timers.c:  *tp = ktime_to_timespec(KTIME_LOW_RES);
kernel/sched.c: * scheduler tick (TICK_NSEC). With tickless idle this will not be called
kernel/sched_clock.c:    *                    scd->tick_gtod + TICK_NSEC);
kernel/sched_clock.c:   max_clock = wrap_max(old_clock, scd->tick_gtod + TICK_NSEC);
kernel/time.c: * The TICK_NSEC - 1 rounds up the value to the next resolution.
Note
kernel/time.c: * nsec -= nsec % TICK_NSEC; is NOT a correct resolution rounding.kernel/time.c:  long nsec = value->tv_nsec + TICK_NSEC - 1;
kernel/time.c:  value->tv_sec = div_u64_rem((u64)jiffies * TICK_NSEC,
kernel/time.c:  value->tv_sec = div_u64_rem((u64)jiffies * TICK_NSEC,
kernel/time.c:#if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) == 0
kernel/time.c:  return div_u64((u64)x * TICK_NSEC, NSEC_PER_SEC / USER_HZ);
kernel/time.c:#if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) == 0
kernel/time.c:  x = div_u64(x * TICK_NSEC, (NSEC_PER_SEC / USER_HZ));
kernel/time/jiffies.c:#define NSEC_PER_JIFFY    ((u32)((((u64)NSEC_PER_SEC)<<8)/ACTHZ))
kernel/time/jiffies.c:/* Since jiffies uses a simple NSEC_PER_JIFFY multiplier
kernel/time/jiffies.c: * larger can result in overflows. NSEC_PER_JIFFY grows askernel/time/jiffies.c:  .mult           = NSEC_PER_JIFFY << JIFFIES_SHIFT, /* details above */
kernel/time/ntp.c:      next.tv_nsec = (NSEC_PER_SEC / 2) - now.tv_nsec - (TICK_NSEC / 2);
