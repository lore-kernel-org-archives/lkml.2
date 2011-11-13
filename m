Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab1KMXUA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 18:20:00 -0500
Received: from www.linutronix.de ([62.245.132.108]:45152 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab1KMXTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 18:19:51 -0500
Message-Id: <20111113231341.811597588@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 13 Nov 2011 23:19:49 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [patch 6/7] timekeeping: Add extra timekeeper/xtime structs for
 calculation
References: <20111113230921.728083714@linutronix.de>
Content-Disposition: inline; filename=timekeeping-add-calc-struct.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timekeeping/xtime is directly changed by the update_wall_time()
code which requires that the seqcount protection has to spawn the full
region. Create shadow structs which are used for calculation and then
update the real ones after the calculation finished.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c |   95 ++++++++++++++++++++++++++--------------------
 1 file changed, 55 insertions(+), 40 deletions(-)

Index: linux-2.6-tip/kernel/time/timekeeping.c
===================================================================
--- linux-2.6-tip.orig/kernel/time/timekeeping.c
+++ linux-2.6-tip/kernel/time/timekeeping.c
@@ -51,6 +51,11 @@ struct timekeeper {
 
 static struct timekeeper timekeeper;
 
+/* Used to decouple calculations from timekeeper/xtime */
+static struct timekeeper tk_calc;
+static struct timespec xtime_calc;
+static void timekeeping_update_calc(void);
+
 /**
  * timekeeper_setup_internals - Set up internals to use clocksource clock.
  *
@@ -99,6 +104,7 @@ static void timekeeper_setup_internals(s
 	 * to counteract clock drifting.
 	 */
 	timekeeper.mult = clock->mult;
+	timekeeping_update_calc();
 }
 
 /* Timekeeper helper functions. */
@@ -170,6 +176,12 @@ static struct timespec raw_time;
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
 
+static void timekeeping_update_calc(void)
+{
+	xtime_calc = xtime;
+	tk_calc = timekeeper;
+}
+
 static void timekeeping_update(bool clearntp)
 {
 	if (clearntp) {
@@ -178,6 +190,7 @@ static void timekeeping_update(bool clea
 	}
 	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
 			timekeeper.mult);
+	timekeeping_update_calc();
 }
 
 /* must hold xtime_lock */
@@ -596,6 +609,7 @@ void __init timekeeping_init(void)
 				-boot.tv_sec, -boot.tv_nsec);
 	total_sleep_time.tv_sec = 0;
 	total_sleep_time.tv_nsec = 0;
+	timekeeping_update_calc();
 	write_seqcount_end(&xtime_seq);
 	raw_spin_unlock_irqrestore(&xtime_lock, flags);
 }
@@ -772,7 +786,7 @@ static __always_inline int timekeeping_b
 	 * here.  This is tuned so that an error of about 1 msec is adjusted
 	 * within about 1 sec (or 2^20 nsec in 2^SHIFT_HZ ticks).
 	 */
-	error2 = timekeeper.ntp_error >> (NTP_SCALE_SHIFT + 22 - 2 * SHIFT_HZ);
+	error2 = tk_calc.ntp_error >> (NTP_SCALE_SHIFT + 22 - 2 * SHIFT_HZ);
 	error2 = abs(error2);
 	for (look_ahead = 0; error2 > 0; look_ahead++)
 		error2 >>= 2;
@@ -781,8 +795,8 @@ static __always_inline int timekeeping_b
 	 * Now calculate the error in (1 << look_ahead) ticks, but first
 	 * remove the single look ahead already included in the error.
 	 */
-	tick_error = tick_length >> (timekeeper.ntp_error_shift + 1);
-	tick_error -= timekeeper.xtime_interval >> 1;
+	tick_error = tick_length >> (tk_calc.ntp_error_shift + 1);
+	tick_error -= tk_calc.xtime_interval >> 1;
 	error = ((error - tick_error) >> look_ahead) + tick_error;
 
 	/* Finally calculate the adjustment shift value.  */
@@ -809,10 +823,10 @@ static __always_inline int timekeeping_b
  */
 static void timekeeping_adjust(s64 offset)
 {
-	s64 error, interval = timekeeper.cycle_interval;
+	s64 error, interval = tk_calc.cycle_interval;
 	int adj;
 
-	error = timekeeper.ntp_error >> (timekeeper.ntp_error_shift - 1);
+	error = tk_calc.ntp_error >> (tk_calc.ntp_error_shift - 1);
 	if (error > interval) {
 		error >>= 2;
 		if (likely(error <= interval))
@@ -830,11 +844,10 @@ static void timekeeping_adjust(s64 offse
 	} else
 		return;
 
-	timekeeper.mult += adj;
-	timekeeper.xtime_interval += interval;
-	timekeeper.xtime_nsec -= offset;
-	timekeeper.ntp_error -= (interval - offset) <<
-				timekeeper.ntp_error_shift;
+	tk_calc.mult += adj;
+	tk_calc.xtime_interval += interval;
+	tk_calc.xtime_nsec -= offset;
+	tk_calc.ntp_error -= (interval - offset) << tk_calc.ntp_error_shift;
 }
 
 
@@ -849,26 +862,26 @@ static void timekeeping_adjust(s64 offse
  */
 static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 {
-	u64 nsecps = (u64)NSEC_PER_SEC << timekeeper.shift;
+	u64 nsecps = (u64)NSEC_PER_SEC << tk_calc.shift;
 	u64 raw_nsecs;
 
 	/* If the offset is smaller then a shifted interval, do nothing */
-	if (offset < timekeeper.cycle_interval<<shift)
+	if (offset < tk_calc.cycle_interval<<shift)
 		return offset;
 
 	/* Accumulate one shifted interval */
-	offset -= timekeeper.cycle_interval << shift;
-	timekeeper.clock->cycle_last += timekeeper.cycle_interval << shift;
+	offset -= tk_calc.cycle_interval << shift;
+	tk_calc.clock->cycle_last += tk_calc.cycle_interval << shift;
 
-	timekeeper.xtime_nsec += timekeeper.xtime_interval << shift;
-	while (timekeeper.xtime_nsec >= nsecps) {
-		timekeeper.xtime_nsec -= nsecps;
-		xtime.tv_sec++;
+	tk_calc.xtime_nsec += tk_calc.xtime_interval << shift;
+	while (tk_calc.xtime_nsec >= nsecps) {
+		tk_calc.xtime_nsec -= nsecps;
+		xtime_calc.tv_sec++;
 		second_overflow();
 	}
 
 	/* Accumulate raw time */
-	raw_nsecs = timekeeper.raw_interval << shift;
+	raw_nsecs = tk_calc.raw_interval << shift;
 	raw_nsecs += raw_time.tv_nsec;
 	if (raw_nsecs >= NSEC_PER_SEC) {
 		u64 raw_secs = raw_nsecs;
@@ -878,10 +891,10 @@ static cycle_t logarithmic_accumulation(
 	raw_time.tv_nsec = raw_nsecs;
 
 	/* Accumulate error between NTP and clock interval */
-	timekeeper.ntp_error += tick_length << shift;
-	timekeeper.ntp_error -=
-	    (timekeeper.xtime_interval + timekeeper.xtime_remainder) <<
-				(timekeeper.ntp_error_shift + shift);
+	tk_calc.ntp_error += tick_length << shift;
+	tk_calc.ntp_error -=
+	    (tk_calc.xtime_interval + tk_calc.xtime_remainder) <<
+				(tk_calc.ntp_error_shift + shift);
 
 	return offset;
 }
@@ -902,14 +915,14 @@ static void update_wall_time(void)
 	if (unlikely(timekeeping_suspended))
 		return;
 
-	clock = timekeeper.clock;
+	clock = tk_calc.clock;
 
 #ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
-	offset = timekeeper.cycle_interval;
+	offset = tk_calc.cycle_interval;
 #else
 	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
 #endif
-	timekeeper.xtime_nsec = (s64)xtime.tv_nsec << timekeeper.shift;
+	tk_calc.xtime_nsec = (s64)xtime.tv_nsec << tk_calc.shift;
 
 	/*
 	 * With NO_HZ we may have to accumulate many cycle_intervals
@@ -919,14 +932,14 @@ static void update_wall_time(void)
 	 * chunk in one go, and then try to consume the next smaller
 	 * doubled multiple.
 	 */
-	shift = ilog2(offset) - ilog2(timekeeper.cycle_interval);
+	shift = ilog2(offset) - ilog2(tk_calc.cycle_interval);
 	shift = max(0, shift);
 	/* Bound shift to one less then what overflows tick_length */
 	maxshift = (8*sizeof(tick_length) - (ilog2(tick_length)+1)) - 1;
 	shift = min(shift, maxshift);
-	while (offset >= timekeeper.cycle_interval) {
+	while (offset >= tk_calc.cycle_interval) {
 		offset = logarithmic_accumulation(offset, shift);
-		if(offset < timekeeper.cycle_interval<<shift)
+		if(offset < tk_calc.cycle_interval<<shift)
 			shift--;
 	}
 
@@ -949,10 +962,10 @@ static void update_wall_time(void)
 	 * We'll correct this error next time through this function, when
 	 * xtime_nsec is not as small.
 	 */
-	if (unlikely((s64)timekeeper.xtime_nsec < 0)) {
-		s64 neg = -(s64)timekeeper.xtime_nsec;
-		timekeeper.xtime_nsec = 0;
-		timekeeper.ntp_error += neg << timekeeper.ntp_error_shift;
+	if (unlikely((s64)tk_calc.xtime_nsec < 0)) {
+		s64 neg = -(s64)tk_calc.xtime_nsec;
+		tk_calc.xtime_nsec = 0;
+		tk_calc.ntp_error += neg << tk_calc.ntp_error_shift;
 	}
 
 
@@ -960,21 +973,23 @@ static void update_wall_time(void)
 	 * Store full nanoseconds into xtime after rounding it up and
 	 * add the remainder to the error difference.
 	 */
-	xtime.tv_nsec =	((s64) timekeeper.xtime_nsec >> timekeeper.shift) + 1;
-	timekeeper.xtime_nsec -= (s64) xtime.tv_nsec << timekeeper.shift;
-	timekeeper.ntp_error +=	timekeeper.xtime_nsec <<
-				timekeeper.ntp_error_shift;
+	xtime_calc.tv_nsec = ((s64) tk_calc.xtime_nsec >> tk_calc.shift) + 1;
+	tk_calc.xtime_nsec -= (s64) xtime_calc.tv_nsec << tk_calc.shift;
+	tk_calc.ntp_error += tk_calc.xtime_nsec << tk_calc.ntp_error_shift;
 
 	/*
 	 * Finally, make sure that after the rounding
 	 * xtime.tv_nsec isn't larger then NSEC_PER_SEC
 	 */
-	if (unlikely(xtime.tv_nsec >= NSEC_PER_SEC)) {
-		xtime.tv_nsec -= NSEC_PER_SEC;
-		xtime.tv_sec++;
+	if (unlikely(xtime_calc.tv_nsec >= NSEC_PER_SEC)) {
+		xtime_calc.tv_nsec -= NSEC_PER_SEC;
+		xtime_calc.tv_sec++;
 		second_overflow();
 	}
 
+	timekeeper = tk_calc;
+	xtime = xtime_calc;
+
 	/* check to see if there is a new clocksource to use */
 	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
 				timekeeper.mult);


