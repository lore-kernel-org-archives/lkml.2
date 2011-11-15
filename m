Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab1KOEH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 23:07:29 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58210 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755799Ab1KOEEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 23:04:23 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 14/16] time: Rework timekeeping functions to take timekeeper ptr as argument
Date: Mon, 14 Nov 2011 20:04:04 -0800
Message-Id: <1321329846-14755-15-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
References: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
x-cbid: 11111504-6078-0000-0000-000004657EF2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of cleaning up the timekeeping code, this patch converts
a number of internal functions to takea  timekeeper ptr as an
argument, so that the internal functions don't access the global
timekeeper structure directly. This allows for further optimizations
later.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   87 +++++++++++++++++++++++----------------------
 1 files changed, 44 insertions(+), 43 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6ca50b5..7870a0e 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -206,16 +206,15 @@ static inline s64 timekeeping_get_ns_raw(void)
 }
 
 /* must hold write on timekeeper.lock */
-static void timekeeping_update(bool clearntp)
+static void timekeeping_update(struct timekeeper *tk, bool clearntp)
 {
 	struct timespec xt;
 	if (clearntp) {
-		timekeeper.ntp_error = 0;
+		tk->ntp_error = 0;
 		ntp_clear();
 	}
-	xt = timekeeper_xtime(&timekeeper);
-	update_vsyscall(&xt, &timekeeper.wall_to_monotonic,
-			 timekeeper.clock, timekeeper.mult);
+	xt = timekeeper_xtime(tk);
+	update_vsyscall(&xt, &tk->wall_to_monotonic, tk->clock, tk->mult);
 }
 
 
@@ -226,7 +225,7 @@ void timekeeping_leap_insert(int leapsecond)
 	write_seqlock_irqsave(&timekeeper.lock, flags);
 	timekeeper.xtime_sec += leapsecond;
 	timekeeper.wall_to_monotonic.tv_sec -= leapsecond;
-	timekeeping_update(false);
+	timekeeping_update(&timekeeper, false);
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 
 }
@@ -426,7 +425,7 @@ int do_settimeofday(const struct timespec *tv)
 
 	timekeeper_set_xtime(&timekeeper, tv);
 
-	timekeeping_update(true);
+	timekeeping_update(&timekeeper, true);
 
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 
@@ -461,7 +460,7 @@ int timekeeping_inject_offset(struct timespec *ts)
 	timekeeper.wall_to_monotonic =
 				timespec_sub(timekeeper.wall_to_monotonic, *ts);
 
-	timekeeping_update(true);
+	timekeeping_update(&timekeeper, true);
 
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 
@@ -698,7 +697,7 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 
 	__timekeeping_inject_sleeptime(delta);
 
-	timekeeping_update(true);
+	timekeeping_update(&timekeeper, true);
 
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 
@@ -801,7 +800,8 @@ device_initcall(timekeeping_init_ops);
  * If the error is already larger, we look ahead even further
  * to compensate for late or lost adjustments.
  */
-static __always_inline int timekeeping_bigadjust(s64 error, s64 *interval,
+static __always_inline int timekeeping_bigadjust(struct timekeeper *tk,
+						 s64 error, s64 *interval,
 						 s64 *offset)
 {
 	s64 tick_error, i;
@@ -817,7 +817,7 @@ static __always_inline int timekeeping_bigadjust(s64 error, s64 *interval,
 	 * here.  This is tuned so that an error of about 1 msec is adjusted
 	 * within about 1 sec (or 2^20 nsec in 2^SHIFT_HZ ticks).
 	 */
-	error2 = timekeeper.ntp_error >> (NTP_SCALE_SHIFT + 22 - 2 * SHIFT_HZ);
+	error2 = tk->ntp_error >> (NTP_SCALE_SHIFT + 22 - 2 * SHIFT_HZ);
 	error2 = abs(error2);
 	for (look_ahead = 0; error2 > 0; look_ahead++)
 		error2 >>= 2;
@@ -826,8 +826,8 @@ static __always_inline int timekeeping_bigadjust(s64 error, s64 *interval,
 	 * Now calculate the error in (1 << look_ahead) ticks, but first
 	 * remove the single look ahead already included in the error.
 	 */
-	tick_error = ntp_tick_length() >> (timekeeper.ntp_error_shift + 1);
-	tick_error -= timekeeper.xtime_interval >> 1;
+	tick_error = ntp_tick_length() >> (tk->ntp_error_shift + 1);
+	tick_error -= tk->xtime_interval >> 1;
 	error = ((error - tick_error) >> look_ahead) + tick_error;
 
 	/* Finally calculate the adjustment shift value.  */
@@ -852,18 +852,19 @@ static __always_inline int timekeeping_bigadjust(s64 error, s64 *interval,
  * this is optimized for the most common adjustments of -1,0,1,
  * for other values we can do a bit more work.
  */
-static void timekeeping_adjust(s64 offset)
+static void timekeeping_adjust(struct timekeeper *tk, s64 offset)
 {
-	s64 error, interval = timekeeper.cycle_interval;
+	s64 error, interval = tk->cycle_interval;
 	int adj;
 
-	error = timekeeper.ntp_error >> (timekeeper.ntp_error_shift - 1);
+	error = tk->ntp_error >> (tk->ntp_error_shift - 1);
 	if (error > interval) {
 		error >>= 2;
 		if (likely(error <= interval))
 			adj = 1;
 		else
-			adj = timekeeping_bigadjust(error, &interval, &offset);
+			adj = timekeeping_bigadjust(tk, error, &interval,
+							&offset);
 	} else if (error < -interval) {
 		error >>= 2;
 		if (likely(error >= -interval)) {
@@ -871,15 +872,15 @@ static void timekeeping_adjust(s64 offset)
 			interval = -interval;
 			offset = -offset;
 		} else
-			adj = timekeeping_bigadjust(error, &interval, &offset);
+			adj = timekeeping_bigadjust(tk, error, &interval,
+							&offset);
 	} else
 		return;
 
-	timekeeper.mult += adj;
-	timekeeper.xtime_interval += interval;
-	timekeeper.xtime_nsec -= offset;
-	timekeeper.ntp_error -= (interval - offset) <<
-				timekeeper.ntp_error_shift;
+	tk->mult += adj;
+	tk->xtime_interval += interval;
+	tk->xtime_nsec -= offset;
+	tk->ntp_error -= (interval - offset) << tk->ntp_error_shift;
 }
 
 
@@ -892,41 +893,41 @@ static void timekeeping_adjust(s64 offset)
  *
  * Returns the unconsumed cycles.
  */
-static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
+static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
+						int shift)
 {
-	u64 nsecps = (u64)NSEC_PER_SEC << timekeeper.shift;
+	u64 nsecps = (u64)NSEC_PER_SEC << tk->shift;
 	u64 raw_nsecs;
 
 	/* If the offset is smaller then a shifted interval, do nothing */
-	if (offset < timekeeper.cycle_interval<<shift)
+	if (offset < tk->cycle_interval<<shift)
 		return offset;
 
 	/* Accumulate one shifted interval */
-	offset -= timekeeper.cycle_interval << shift;
-	timekeeper.clock->cycle_last += timekeeper.cycle_interval << shift;
+	offset -= tk->cycle_interval << shift;
+	tk->clock->cycle_last += tk->cycle_interval << shift;
 
-	timekeeper.xtime_nsec += timekeeper.xtime_interval << shift;
-	while (timekeeper.xtime_nsec >= nsecps) {
-		timekeeper.xtime_nsec -= nsecps;
-		timekeeper.xtime_sec++;
+	tk->xtime_nsec += tk->xtime_interval << shift;
+	while (tk->xtime_nsec >= nsecps) {
+		tk->xtime_nsec -= nsecps;
+		tk->xtime_sec++;
 		second_overflow();
 	}
 
 	/* Accumulate raw time */
-	raw_nsecs = timekeeper.raw_interval << shift;
-	raw_nsecs += timekeeper.raw_time.tv_nsec;
+	raw_nsecs = tk->raw_interval << shift;
+	raw_nsecs += tk->raw_time.tv_nsec;
 	if (raw_nsecs >= NSEC_PER_SEC) {
 		u64 raw_secs = raw_nsecs;
 		raw_nsecs = do_div(raw_secs, NSEC_PER_SEC);
-		timekeeper.raw_time.tv_sec += raw_secs;
+		tk->raw_time.tv_sec += raw_secs;
 	}
-	timekeeper.raw_time.tv_nsec = raw_nsecs;
+	tk->raw_time.tv_nsec = raw_nsecs;
 
 	/* Accumulate error between NTP and clock interval */
-	timekeeper.ntp_error += ntp_tick_length() << shift;
-	timekeeper.ntp_error -=
-	    (timekeeper.xtime_interval + timekeeper.xtime_remainder) <<
-				(timekeeper.ntp_error_shift + shift);
+	tk->ntp_error += ntp_tick_length() << shift;
+	tk->ntp_error -= (tk->xtime_interval + tk->xtime_remainder) <<
+						(tk->ntp_error_shift + shift);
 
 	return offset;
 }
@@ -972,13 +973,13 @@ static void update_wall_time(void)
 	maxshift = (64 - (ilog2(ntp_tick_length())+1)) - 1;
 	shift = min(shift, maxshift);
 	while (offset >= timekeeper.cycle_interval) {
-		offset = logarithmic_accumulation(offset, shift);
+		offset = logarithmic_accumulation(&timekeeper, offset, shift);
 		if(offset < timekeeper.cycle_interval<<shift)
 			shift--;
 	}
 
 	/* correct the clock when NTP error is too big */
-	timekeeping_adjust(offset);
+	timekeeping_adjust(&timekeeper, offset);
 
 	/*
 	 * Since in the loop above, we accumulate any amount of time
@@ -1028,7 +1029,7 @@ static void update_wall_time(void)
 		second_overflow();
 	}
 
-	timekeeping_update(false);
+	timekeeping_update(&timekeeper, false);
 
 out:
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
-- 
1.7.3.2.146.gca209

