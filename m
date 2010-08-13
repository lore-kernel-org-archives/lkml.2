Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761631Ab0HMNKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 09:10:33 -0400
Received: from king.tilera.com ([72.1.168.226]:13968 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761578Ab0HMNJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 09:09:48 -0400
Message-Id: <201008131309.o7DD9kZ1005838@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 13 Aug 2010 08:24:22 -0400
Subject: [PATCH] arch/tile: Use separate, better minsec values for clocksource and sched_clock.
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
X-OriginalArrivalTime: 13 Aug 2010 13:09:47.0250 (UTC) FILETIME=[CDF68520:01CB3AE8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We were using the same 5-sec minsec for the clocksource and sched_clock
that we were using for the clock_event_device.  For the clock_event_device
that's exactly right since it has a short maximum countdown time.
But for sched_clock we want to avoid wraparound when converting from
ticks to nsec over a much longer window, so we force a shift of 10.
And for clocksource it seems dodgy to use a 5-sec minsec as well, so we
copy some other platforms and force a shift of 22.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/time.c |   33 +++++++++++++++++++--------------
 1 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/arch/tile/kernel/time.c b/arch/tile/kernel/time.c
index b9ab25a..6bed820 100644
--- a/arch/tile/kernel/time.c
+++ b/arch/tile/kernel/time.c
@@ -36,16 +36,6 @@
 /* How many cycles per second we are running at. */
 static cycles_t cycles_per_sec __write_once;
 
-/*
- * We set up shift and multiply values with a minsec of five seconds,
- * since our timer counter counts down 31 bits at a frequency of
- * no less than 500 MHz.  See @minsec for clocks_calc_mult_shift().
- * We could use a different value for the 64-bit free-running
- * cycle counter, but we use the same one for consistency, and since
- * we will be reasonably precise with this value anyway.
- */
-#define TILE_MINSEC 5
-
 cycles_t get_clock_rate(void)
 {
 	return cycles_per_sec;
@@ -68,6 +58,14 @@ cycles_t get_cycles(void)
 }
 #endif
 
+/*
+ * We use a relatively small shift value so that sched_clock()
+ * won't wrap around very often.
+ */
+#define SCHED_CLOCK_SHIFT 10
+
+static unsigned long sched_clock_mult __write_once;
+
 static cycles_t clocksource_get_cycles(struct clocksource *cs)
 {
 	return get_cycles();
@@ -78,6 +76,7 @@ static struct clocksource cycle_counter_cs = {
 	.rating = 300,
 	.read = clocksource_get_cycles,
 	.mask = CLOCKSOURCE_MASK(64),
+	.shift = 22,   /* typical value, e.g. x86 tsc uses this */
 	.flags = CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -88,8 +87,10 @@ static struct clocksource cycle_counter_cs = {
 void __init setup_clock(void)
 {
 	cycles_per_sec = hv_sysconf(HV_SYSCONF_CPU_SPEED);
-	clocksource_calc_mult_shift(&cycle_counter_cs, cycles_per_sec,
-				    TILE_MINSEC);
+	sched_clock_mult =
+		clocksource_hz2mult(cycles_per_sec, SCHED_CLOCK_SHIFT);
+	cycle_counter_cs.mult =
+		clocksource_hz2mult(cycles_per_sec, cycle_counter_cs.shift);
 }
 
 void __init calibrate_delay(void)
@@ -117,9 +118,14 @@ void __init time_init(void)
  * counter, plus bit 31, which signifies that the counter has wrapped
  * from zero to (2**31) - 1.  The INT_TILE_TIMER interrupt will be
  * raised as long as bit 31 is set.
+ *
+ * The TILE_MINSEC value represents the largest range of real-time
+ * we can possibly cover with the timer, based on MAX_TICK combined
+ * with the slowest reasonable clock rate we might run at.
  */
 
 #define MAX_TICK 0x7fffffff   /* we have 31 bits of countdown timer */
+#define TILE_MINSEC 5         /* timer covers no more than 5 seconds */
 
 static int tile_timer_set_next_event(unsigned long ticks,
 				     struct clock_event_device *evt)
@@ -211,8 +217,7 @@ void do_timer_interrupt(struct pt_regs *regs, int fault_num)
 unsigned long long sched_clock(void)
 {
 	return clocksource_cyc2ns(get_cycles(),
-				  cycle_counter_cs.mult,
-				  cycle_counter_cs.shift);
+				  sched_clock_mult, SCHED_CLOCK_SHIFT);
 }
 
 int setup_profiling_timer(unsigned int multiplier)
-- 
1.6.5.2

