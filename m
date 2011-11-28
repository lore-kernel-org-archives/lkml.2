Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab1K1OUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:20:16 -0500
Received: from www.linutronix.de ([62.245.132.108]:58579 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab1K1OUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:20:11 -0500
Date: Mon, 28 Nov 2011 15:20:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] timer fixes for 3.2
Message-ID: <alpine.LFD.2.02.1111281519280.2735@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

Thanks,

	tglx

------------------>
Hector Palacios (1):
      timekeeping: add arch_offset hook to ktime_get functions

Jeff Ohlstein (1):
      hrtimer: Fix extra wakeups from __remove_hrtimer()

John Stultz (2):
      time: Improve documentation of timekeeeping_adjust()
      clocksource: Avoid selecting mult values that might overflow when adjusted


 include/linux/clocksource.h |    3 +-
 kernel/hrtimer.c            |    6 ++-
 kernel/time/clocksource.c   |   58 ++++++++++++++++++++++-----
 kernel/time/timekeeping.c   |   92 ++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 145 insertions(+), 14 deletions(-)

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
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index a9205e3..2043c08 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -885,10 +885,13 @@ static void __remove_hrtimer(struct hrtimer *timer,
 			     struct hrtimer_clock_base *base,
 			     unsigned long newstate, int reprogram)
 {
+	struct timerqueue_node *next_timer;
 	if (!(timer->state & HRTIMER_STATE_ENQUEUED))
 		goto out;
 
-	if (&timer->node == timerqueue_getnext(&base->active)) {
+	next_timer = timerqueue_getnext(&base->active);
+	timerqueue_del(&base->active, &timer->node);
+	if (&timer->node == next_timer) {
 #ifdef CONFIG_HIGH_RES_TIMERS
 		/* Reprogram the clock event device. if enabled */
 		if (reprogram && hrtimer_hres_active()) {
@@ -901,7 +904,6 @@ static void __remove_hrtimer(struct hrtimer *timer,
 		}
 #endif
 	}
-	timerqueue_del(&base->active, &timer->node);
 	if (!timerqueue_getnext(&base->active))
 		base->cpu_base->active_bases &= ~(1 << base->index);
 out:
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
index 2b021b0e..2378413 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -249,6 +249,8 @@ ktime_t ktime_get(void)
 		secs = xtime.tv_sec + wall_to_monotonic.tv_sec;
 		nsecs = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
 		nsecs += timekeeping_get_ns();
+		/* If arch requires, add in gettimeoffset() */
+		nsecs += arch_gettimeoffset();
 
 	} while (read_seqretry(&xtime_lock, seq));
 	/*
@@ -280,6 +282,8 @@ void ktime_get_ts(struct timespec *ts)
 		*ts = xtime;
 		tomono = wall_to_monotonic;
 		nsecs = timekeeping_get_ns();
+		/* If arch requires, add in gettimeoffset() */
+		nsecs += arch_gettimeoffset();
 
 	} while (read_seqretry(&xtime_lock, seq));
 
@@ -802,14 +806,44 @@ static void timekeeping_adjust(s64 offset)
 	s64 error, interval = timekeeper.cycle_interval;
 	int adj;
 
+	/*
+	 * The point of this is to check if the error is greater then half
+	 * an interval.
+	 *
+	 * First we shift it down from NTP_SHIFT to clocksource->shifted nsecs.
+	 *
+	 * Note we subtract one in the shift, so that error is really error*2.
+	 * This "saves" dividing(shifting) intererval twice, but keeps the
+	 * (error > interval) comparision as still measuring if error is
+	 * larger then half an interval.
+	 *
+	 * Note: It does not "save" on aggrivation when reading the code.
+	 */
 	error = timekeeper.ntp_error >> (timekeeper.ntp_error_shift - 1);
 	if (error > interval) {
+		/*
+		 * We now divide error by 4(via shift), which checks if
+		 * the error is greater then twice the interval.
+		 * If it is greater, we need a bigadjust, if its smaller,
+		 * we can adjust by 1.
+		 */
 		error >>= 2;
+		/*
+		 * XXX - In update_wall_time, we round up to the next
+		 * nanosecond, and store the amount rounded up into
+		 * the error. This causes the likely below to be unlikely.
+		 *
+		 * The properfix is to avoid rounding up by using
+		 * the high precision timekeeper.xtime_nsec instead of
+		 * xtime.tv_nsec everywhere. Fixing this will take some
+		 * time.
+		 */
 		if (likely(error <= interval))
 			adj = 1;
 		else
 			adj = timekeeping_bigadjust(error, &interval, &offset);
 	} else if (error < -interval) {
+		/* See comment above, this is just switched for the negative */
 		error >>= 2;
 		if (likely(error >= -interval)) {
 			adj = -1;
@@ -817,9 +851,65 @@ static void timekeeping_adjust(s64 offset)
 			offset = -offset;
 		} else
 			adj = timekeeping_bigadjust(error, &interval, &offset);
-	} else
+	} else /* No adjustment needed */
 		return;
 
+	WARN_ONCE(timekeeper.clock->maxadj &&
+			(timekeeper.mult + adj > timekeeper.clock->mult +
+						timekeeper.clock->maxadj),
+			"Adjusting %s more then 11%% (%ld vs %ld)\n",
+			timekeeper.clock->name, (long)timekeeper.mult + adj,
+			(long)timekeeper.clock->mult +
+				timekeeper.clock->maxadj);
+	/*
+	 * So the following can be confusing.
+	 *
+	 * To keep things simple, lets assume adj == 1 for now.
+	 *
+	 * When adj != 1, remember that the interval and offset values
+	 * have been appropriately scaled so the math is the same.
+	 *
+	 * The basic idea here is that we're increasing the multiplier
+	 * by one, this causes the xtime_interval to be incremented by
+	 * one cycle_interval. This is because:
+	 *	xtime_interval = cycle_interval * mult
+	 * So if mult is being incremented by one:
+	 *	xtime_interval = cycle_interval * (mult + 1)
+	 * Its the same as:
+	 *	xtime_interval = (cycle_interval * mult) + cycle_interval
+	 * Which can be shortened to:
+	 *	xtime_interval += cycle_interval
+	 *
+	 * So offset stores the non-accumulated cycles. Thus the current
+	 * time (in shifted nanoseconds) is:
+	 *	now = (offset * adj) + xtime_nsec
+	 * Now, even though we're adjusting the clock frequency, we have
+	 * to keep time consistent. In other words, we can't jump back
+	 * in time, and we also want to avoid jumping forward in time.
+	 *
+	 * So given the same offset value, we need the time to be the same
+	 * both before and after the freq adjustment.
+	 *	now = (offset * adj_1) + xtime_nsec_1
+	 *	now = (offset * adj_2) + xtime_nsec_2
+	 * So:
+	 *	(offset * adj_1) + xtime_nsec_1 =
+	 *		(offset * adj_2) + xtime_nsec_2
+	 * And we know:
+	 *	adj_2 = adj_1 + 1
+	 * So:
+	 *	(offset * adj_1) + xtime_nsec_1 =
+	 *		(offset * (adj_1+1)) + xtime_nsec_2
+	 *	(offset * adj_1) + xtime_nsec_1 =
+	 *		(offset * adj_1) + offset + xtime_nsec_2
+	 * Canceling the sides:
+	 *	xtime_nsec_1 = offset + xtime_nsec_2
+	 * Which gives us:
+	 *	xtime_nsec_2 = xtime_nsec_1 - offset
+	 * Which simplfies to:
+	 *	xtime_nsec -= offset
+	 *
+	 * XXX - TODO: Doc ntp_error calculation.
+	 */
 	timekeeper.mult += adj;
 	timekeeper.xtime_interval += interval;
 	timekeeper.xtime_nsec -= offset;
