Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab1KHDJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 22:09:32 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43707 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918Ab1KHDJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 22:09:30 -0500
Message-ID: <1320721740.10668.23.camel@work-vm>
Subject: Re: [PATCH] clocksource: Avoid selecting mult values that might
 overflow when adjusted
From: John Stultz <john.stultz@linaro.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Yong Zhang <yong.zhang0@gmail.com>,
        David Daney <ddaney.cavm@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 07 Nov 2011 19:09:00 -0800
In-Reply-To: <20111103211000.GA17895@elte.hu>
References: <1320264087-3413-1-git-send-email-john.stultz@linaro.org>
	 <20111103211000.GA17895@elte.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11110803-5806-0000-0000-0000027F3137
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 22:10 +0100, Ingo Molnar wrote:
> * John Stultz <john.stultz@linaro.org> wrote:
> 
> > For some frequqencies, the clocks_calc_mult_shift() function will
> > unfortunately select mult values very close to 0xffffffff.  This
> > has the potential to overflow when NTP adjusts the clock, adding
> > to the mult value.
> > 
> > This patch adds a clocksource.maxadj value, which provides
> > an approximation of an 11% adjustment(NTP limits adjustments to
> > 500ppm and the tick adjustment is limited to 10%), which could
> > be made to the clocksource.mult value. This is then used to both
> > check that the current mult value won't overflow/underflow, as
> > well as warning us if the timekeeping_adjust() code pushes over
> > that 11% boundary.
> > 
> > CC: Yong Zhang <yong.zhang0@gmail.com>
> > CC: David Daney <ddaney.cavm@gmail.com>
> > CC: Thomas Gleixner <tglx@linutronix.de>
> > Reported-by: Chen Jie <chenj@lemote.com>
> > Reported-by: zhangfx <zhangfx@lemote.com>
> > Signed-off-by: John Stultz <john.stultz@linaro.org>
> > ---
> >  include/linux/clocksource.h |    3 +-
> >  kernel/time/clocksource.c   |   53 ++++++++++++++++++++++++++++++++++--------
> >  kernel/time/timekeeping.c   |    3 ++
> >  3 files changed, 48 insertions(+), 11 deletions(-)
> 
> This patch (included in tip:timers/urgent) causes the following boot 
> warning x86:
> 
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at kernel/time/timekeeping.c:855 do_timer+0x47f/0x4c0()
> [    0.000000] Hardware name: System Product Name
> [    0.000000] Adjusting more then 11%
> [    0.000000] Modules linked in:
> [    0.000000] Pid: 0, comm: swapper Not tainted 3.1.0-tip+ #161792
> [    0.000000] Call Trace:
> [    0.000000]  <IRQ>  [<ffffffff81042d0a>] warn_slowpath_common+0x7a/0xb0
> [    0.000000]  [<ffffffff81042de1>] warn_slowpath_fmt+0x41/0x50
> [    0.000000]  [<ffffffff8106e78f>] do_timer+0x47f/0x4c0
> [    0.000000]  [<ffffffff81073953>] tick_periodic+0x63/0x80
> [    0.000000]  [<ffffffff810739f1>] tick_handle_periodic+0x21/0x70
> [    0.000000]  [<ffffffff810046d8>] timer_interrupt+0x18/0x20
> [    0.000000]  [<ffffffff8109ff9e>] handle_irq_event_percpu+0x5e/0x220
> [    0.000000]  [<ffffffff810a019b>] handle_irq_event+0x3b/0x60
> [    0.000000]  [<ffffffff810a295c>] handle_level_irq+0x6c/0xd0
> [    0.000000]  [<ffffffff81003f34>] handle_irq+0x44/0xa0
> 
> Full bootlog and config attached.
> 
> i've excluded it from tip:master for now.

Thanks again for the bug report. I was able to reproduce it using the
jiffies clocksource. Looking at the code after a weekend of decent
sleep, I see the max_adjustment calculation is simply wrong (it was
proportional to the shift, not the mult - but adjustments are made on
mult).

This version simplifies the calculation and improves warn-on messages so
we also catch any overflow potential on clocksources that don't use the
clocksource_register_hz/khz interfaces.

Ingo: could you give it a whirl on your test box and verify it doesn't
have any trouble? 

Yong: Can you also give this a test run to make sure you don't see any
problems?

thanks
-john

>From 82c5b70fc5074b6bb6e05514afb6e9c73c740422 Mon Sep 17 00:00:00 2001
From: John Stultz <john.stultz@linaro.org>
Date: Mon, 31 Oct 2011 17:06:35 -0400
Subject: [PATCH] clocksource: Avoid selecting mult values that might overflow when adjusted

For some frequqencies, the clocks_calc_mult_shift() function will
unfortunately select mult values very close to 0xffffffff.  This
has the potential to overflow when NTP adjusts the clock, adding
to the mult value.

This patch adds a clocksource.maxadj value, which provides
an approximation of an 11% adjustment(NTP limits adjustments to
500ppm and the tick adjustment is limited to 10%), which could
be made to the clocksource.mult value. This is then used to both
check that the current mult value won't overflow/underflow, as
well as warning us if the timekeeping_adjust() code pushes over
that 11% boundary.

v2: Fix max_adjustment calculation, and improve WARN_ONCE
messages.

CC: Yong Zhang <yong.zhang0@gmail.com>
CC: David Daney <ddaney.cavm@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Chen Jie <chenj@lemote.com>
Reported-by: zhangfx <zhangfx@lemote.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/clocksource.h |    3 +-
 kernel/time/clocksource.c   |   58 +++++++++++++++++++++++++++++++++++-------
 kernel/time/timekeeping.c   |    6 ++++
 3 files changed, 56 insertions(+), 11 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 139c4db..c86c940 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -156,6 +156,7 @@ extern u64 timecounter_cyc2time(struct timecounter *tc,
  * @mult:		cycle to nanosecond multiplier
  * @shift:		cycle to nanosecond divisor (power of two)
  * @max_idle_ns:	max idle time permitted by the clocksource (nsecs)
+ * @maxadj		maximum adjustment value to mult (~11%)
  * @flags:		flags describing special properties
  * @archdata:		arch-specific data
  * @suspend:		suspend function for the clocksource, if necessary
@@ -172,7 +173,7 @@ struct clocksource {
 	u32 mult;
 	u32 shift;
 	u64 max_idle_ns;
-
+	u32 maxadj;
 #ifdef CONFIG_ARCH_CLOCKSOURCE_DATA
 	struct arch_clocksource_data archdata;
 #endif
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index cf52fda..cfc65e1 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -492,6 +492,22 @@ void clocksource_touch_watchdog(void)
 }
 
 /**
+ * clocksource_max_adjustment- Returns max adjustment amount
+ * @cs:         Pointer to clocksource
+ *
+ */
+static u32 clocksource_max_adjustment(struct clocksource *cs)
+{
+	u64 ret;
+	/*
+	 * We won't try to correct for more then 11% adjustments (110,000 ppm),
+	 */
+	ret = (u64)cs->mult * 11;
+	do_div(ret,100);
+	return (u32)ret;
+}
+
+/**
  * clocksource_max_deferment - Returns max time the clocksource can be deferred
  * @cs:         Pointer to clocksource
  *
@@ -503,25 +519,28 @@ static u64 clocksource_max_deferment(struct clocksource *cs)
 	/*
 	 * Calculate the maximum number of cycles that we can pass to the
 	 * cyc2ns function without overflowing a 64-bit signed result. The
-	 * maximum number of cycles is equal to ULLONG_MAX/cs->mult which
-	 * is equivalent to the below.
-	 * max_cycles < (2^63)/cs->mult
-	 * max_cycles < 2^(log2((2^63)/cs->mult))
-	 * max_cycles < 2^(log2(2^63) - log2(cs->mult))
-	 * max_cycles < 2^(63 - log2(cs->mult))
-	 * max_cycles < 1 << (63 - log2(cs->mult))
+	 * maximum number of cycles is equal to ULLONG_MAX/(cs->mult+cs->maxadj)
+	 * which is equivalent to the below.
+	 * max_cycles < (2^63)/(cs->mult + cs->maxadj)
+	 * max_cycles < 2^(log2((2^63)/(cs->mult + cs->maxadj)))
+	 * max_cycles < 2^(log2(2^63) - log2(cs->mult + cs->maxadj))
+	 * max_cycles < 2^(63 - log2(cs->mult + cs->maxadj))
+	 * max_cycles < 1 << (63 - log2(cs->mult + cs->maxadj))
 	 * Please note that we add 1 to the result of the log2 to account for
 	 * any rounding errors, ensure the above inequality is satisfied and
 	 * no overflow will occur.
 	 */
-	max_cycles = 1ULL << (63 - (ilog2(cs->mult) + 1));
+	max_cycles = 1ULL << (63 - (ilog2(cs->mult + cs->maxadj) + 1));
 
 	/*
 	 * The actual maximum number of cycles we can defer the clocksource is
 	 * determined by the minimum of max_cycles and cs->mask.
+	 * Note: Here we subtract the maxadj to make sure we don't sleep for
+	 * too long if there's a large negative adjustment.
 	 */
 	max_cycles = min_t(u64, max_cycles, (u64) cs->mask);
-	max_nsecs = clocksource_cyc2ns(max_cycles, cs->mult, cs->shift);
+	max_nsecs = clocksource_cyc2ns(max_cycles, cs->mult - cs->maxadj,
+					cs->shift);
 
 	/*
 	 * To ensure that the clocksource does not wrap whilst we are idle,
@@ -640,7 +659,6 @@ static void clocksource_enqueue(struct clocksource *cs)
 void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
 {
 	u64 sec;
-
 	/*
 	 * Calc the maximum number of seconds which we can run before
 	 * wrapping around. For clocksources which have a mask > 32bit
@@ -661,6 +679,20 @@ void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
 
 	clocks_calc_mult_shift(&cs->mult, &cs->shift, freq,
 			       NSEC_PER_SEC / scale, sec * scale);
+
+	/*
+	 * for clocksources that have large mults, to avoid overflow.
+	 * Since mult may be adjusted by ntp, add an safety extra margin
+	 *
+	 */
+	cs->maxadj = clocksource_max_adjustment(cs);
+	while ((cs->mult + cs->maxadj < cs->mult)
+		|| (cs->mult - cs->maxadj > cs->mult)) {
+		cs->mult >>= 1;
+		cs->shift--;
+		cs->maxadj = clocksource_max_adjustment(cs);
+	}
+
 	cs->max_idle_ns = clocksource_max_deferment(cs);
 }
 EXPORT_SYMBOL_GPL(__clocksource_updatefreq_scale);
@@ -701,6 +733,12 @@ EXPORT_SYMBOL_GPL(__clocksource_register_scale);
  */
 int clocksource_register(struct clocksource *cs)
 {
+	/* calculate max adjustment for given mult/shift */
+	cs->maxadj = clocksource_max_adjustment(cs);
+	WARN_ONCE(cs->mult + cs->maxadj < cs->mult,
+		"Clocksource %s might overflow on 11%% adjustment\n",
+		cs->name);
+
 	/* calculate max idle time permitted for this clocksource */
 	cs->max_idle_ns = clocksource_max_deferment(cs);
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 2b021b0e..2c04610 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -820,6 +820,12 @@ static void timekeeping_adjust(s64 offset)
 	} else
 		return;
 
+	WARN_ONCE(timekeeper.mult+adj >
+			timekeeper.clock->mult + timekeeper.clock->maxadj,
+			"Adjusting %s more then 11%% (%ld vs %ld)\n",
+			timekeeper.clock->name, (long)timekeeper.mult+adj,
+			(long)timekeeper.clock->mult +
+				timekeeper.clock->maxadj);
 	timekeeper.mult += adj;
 	timekeeper.xtime_interval += interval;
 	timekeeper.xtime_nsec -= offset;
-- 
1.7.3.2.146.gca209



