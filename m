Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab1KBUFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:05:40 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55823 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab1KBUFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:05:34 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Yong Zhang <yong.zhang0@gmail.com>,
        David Daney <ddaney.cavm@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] clocksource: Avoid selecting mult values that might overflow when adjusted
Date: Wed,  2 Nov 2011 13:01:27 -0700
Message-Id: <1320264087-3413-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
x-cbid: 11110220-5112-0000-0000-0000019E712D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

CC: Yong Zhang <yong.zhang0@gmail.com>
CC: David Daney <ddaney.cavm@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Chen Jie <chenj@lemote.com>
Reported-by: zhangfx <zhangfx@lemote.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/clocksource.h |    3 +-
 kernel/time/clocksource.c   |   53 ++++++++++++++++++++++++++++++++++--------
 kernel/time/timekeeping.c   |    3 ++
 3 files changed, 48 insertions(+), 11 deletions(-)

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
index cf52fda..d49b7ba 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -492,6 +492,21 @@ void clocksource_touch_watchdog(void)
 }
 
 /**
+ * clocksource_max_adjustment- Returns max adjustment amount
+ * @cs:         Pointer to clocksource
+ *
+ */
+static u32 clocksource_max_adjustment(struct clocksource *cs)
+{
+	/*
+	 * We won't try to correct for more then 11% adjustments (110,000 ppm),
+	 * which approximates to 1/8 or 1/2^3. Thus 1 << (shift - 3) is the
+	 * largest mult adjustment we'll support.
+	 */
+	return 1 << (cs->shift-3);
+}
+
+/**
  * clocksource_max_deferment - Returns max time the clocksource can be deferred
  * @cs:         Pointer to clocksource
  *
@@ -503,25 +518,28 @@ static u64 clocksource_max_deferment(struct clocksource *cs)
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
@@ -640,7 +658,6 @@ static void clocksource_enqueue(struct clocksource *cs)
 void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
 {
 	u64 sec;
-
 	/*
 	 * Calc the maximum number of seconds which we can run before
 	 * wrapping around. For clocksources which have a mask > 32bit
@@ -661,6 +678,20 @@ void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
 
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
@@ -701,6 +732,8 @@ EXPORT_SYMBOL_GPL(__clocksource_register_scale);
  */
 int clocksource_register(struct clocksource *cs)
 {
+	/* calculate max adjustment for given mult/shift */
+	cs->maxadj = clocksource_max_adjustment(cs);
 	/* calculate max idle time permitted for this clocksource */
 	cs->max_idle_ns = clocksource_max_deferment(cs);
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 2b021b0e..d37c9e3 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -820,6 +820,9 @@ static void timekeeping_adjust(s64 offset)
 	} else
 		return;
 
+	WARN_ONCE(timekeeper.mult+adj >
+			timekeeper.clock->mult + timekeeper.clock->maxadj,
+			"Adjusting more then 11%%");
 	timekeeper.mult += adj;
 	timekeeper.xtime_interval += interval;
 	timekeeper.xtime_nsec -= offset;
-- 
1.7.3.2.146.gca209

