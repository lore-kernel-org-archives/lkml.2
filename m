Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999Ab1LGQiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:38:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34263 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933787Ab1LGQXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:23:36 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:17 2011
Message-Id: <20111207161217.902679888@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:40 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Yong Zhang <yong.zhang0@gmail.com>,
        David Daney <ddaney.cavm@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Chen Jie <chenj@lemote.com>,
        zhangfx <zhangfx@lemote.com>, John Stultz <john.stultz@linaro.org>
Subject: [038/104] clocksource: Avoid selecting mult values that might overflow when adjusted
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <john.stultz@linaro.org>

commit d65670a78cdbfae94f20a9e05ec705871d7cdf2b upstream.

For some frequencies, the clocks_calc_mult_shift() function will
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

v3: Don't warn before maxadj has actually been set

CC: Yong Zhang <yong.zhang0@gmail.com>
CC: David Daney <ddaney.cavm@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Chen Jie <chenj@lemote.com>
CC: zhangfx <zhangfx@lemote.com>
Reported-by: Chen Jie <chenj@lemote.com>
Reported-by: zhangfx <zhangfx@lemote.com>
Tested-by: Yong Zhang <yong.zhang0@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/clocksource.h |    3 +-
 kernel/time/clocksource.c   |   58 ++++++++++++++++++++++++++++++++++++--------
 kernel/time/timekeeping.c   |    7 +++++
 3 files changed, 57 insertions(+), 11 deletions(-)

--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -156,6 +156,7 @@ extern u64 timecounter_cyc2time(struct t
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
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -494,6 +494,22 @@ void clocksource_touch_watchdog(void)
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
@@ -505,25 +521,28 @@ static u64 clocksource_max_deferment(str
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
@@ -642,7 +661,6 @@ static void clocksource_enqueue(struct c
 void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
 {
 	u64 sec;
-
 	/*
 	 * Calc the maximum number of seconds which we can run before
 	 * wrapping around. For clocksources which have a mask > 32bit
@@ -663,6 +681,20 @@ void __clocksource_updatefreq_scale(stru
 
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
@@ -703,6 +735,12 @@ EXPORT_SYMBOL_GPL(__clocksource_register
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
 
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -824,6 +824,13 @@ static void timekeeping_adjust(s64 offse
 	} else
 		return;
 
+	WARN_ONCE(timekeeper.clock->maxadj &&
+			(timekeeper.mult + adj > timekeeper.clock->mult +
+						timekeeper.clock->maxadj),
+			"Adjusting %s more then 11%% (%ld vs %ld)\n",
+			timekeeper.clock->name, (long)timekeeper.mult + adj,
+			(long)timekeeper.clock->mult +
+				timekeeper.clock->maxadj);
 	timekeeper.mult += adj;
 	timekeeper.xtime_interval += interval;
 	timekeeper.xtime_nsec -= offset;


