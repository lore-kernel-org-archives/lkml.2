Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab1JaVk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 17:40:59 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:57244 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab1JaVk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 17:40:58 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Yong Zhang <yong.zhang0@gmail.com>,
        David Daney <ddaney.cavm@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC][PATCH] clocksource: Avoid selecting mult values that might overflow when adjusted
Date: Mon, 31 Oct 2011 14:40:28 -0700
Message-Id: <1320097228-3612-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
x-cbid: 11103121-5518-0000-0000-000000269295
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's another rev of my earlier patch. Let me know if it helps.
-john

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

UNTESTED! NOT FOR INCLUSION (YET)!

CC: Yong Zhang <yong.zhang0@gmail.com>
CC: David Daney <ddaney.cavm@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Chen Jie <chenj@lemote.com>
Reported-by: zhangfx <zhangfx@lemote.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/clocksource.h |    3 ++-
 kernel/time/clocksource.c   |   37 +++++++++++++++++++++++++++----------
 kernel/time/timekeeping.c   |    3 +++
 3 files changed, 32 insertions(+), 11 deletions(-)

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
index cf52fda..2982996 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -503,25 +503,26 @@ static u64 clocksource_max_deferment(struct clocksource *cs)
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
 	 */
 	max_cycles = min_t(u64, max_cycles, (u64) cs->mask);
-	max_nsecs = clocksource_cyc2ns(max_cycles, cs->mult, cs->shift);
+	max_nsecs = clocksource_cyc2ns(max_cycles, cs->mult+cs->maxadj,
+					cs->shift);
 
 	/*
 	 * To ensure that the clocksource does not wrap whilst we are idle,
@@ -640,7 +641,6 @@ static void clocksource_enqueue(struct clocksource *cs)
 void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
 {
 	u64 sec;
-
 	/*
 	 * Calc the maximum number of seconds which we can run before
 	 * wrapping around. For clocksources which have a mask > 32bit
@@ -661,6 +661,23 @@ void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
 
 	clocks_calc_mult_shift(&cs->mult, &cs->shift, freq,
 			       NSEC_PER_SEC / scale, sec * scale);
+
+	/*
+	 * for clocksources that have large mults, to avoid overflow.
+	 * Since mult may be adjusted by ntp, add an safety extra margin
+	 *
+	 * We won't try to correct for more then 11% adjustments (110,000 ppm),
+	 * which approximates to 1/8 or 1/2^3. Thus 1 << (shift - 3) is the
+	 * largest mult adjustment we'll support.
+	 */
+	cs->maxadj = 1 << (cs->shift-3);
+	while ((cs->mult + cs->maxadj < cs->mult)
+		|| (cs->mult - cs->maxadj > cs->mult)) {
+		cs->mult >>= 1;
+		cs->shift--;
+		cs->maxadj = 1 << (cs->shift-3);
+	}
+
 	cs->max_idle_ns = clocksource_max_deferment(cs);
 }
 EXPORT_SYMBOL_GPL(__clocksource_updatefreq_scale);
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

