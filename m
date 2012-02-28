Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab2B1AbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:31:08 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60328 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756320Ab2B1A3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:29:49 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 1/7] time: Condense timekeeper.xtime into xtime_sec
Date: Mon, 27 Feb 2012 16:29:28 -0800
Message-Id: <1330388974-27793-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1330388974-27793-1-git-send-email-john.stultz@linaro.org>
References: <1330388974-27793-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022800-5112-0000-0000-000005A9FC06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timekeeper struct has a xtime_nsec, which keeps the
sub-nanosecond remainder.  This ends up being somewhat
duplicative of the timekeeper.xtime.tv_nsec value, and we
have to do extra work to keep them apart, copying the full
nsec portion out and back in over and over.

This patch simplifies some of the logic by taking the timekeeper
xtime value and splitting it into timekeeper.xtime_sec and
reuses the timekeeper.xtime_nsec for the sub-second portion
(stored in higher res shifted nanoseconds).

This simplifies some of the accumulation logic. And will
allow for more accurate timekeeping once the vsyscall code
is updated to use the shifted nanosecond remainder.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |  162 ++++++++++++++++++++++++++++-----------------
 1 files changed, 100 insertions(+), 62 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 403c2a0..325086a 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -39,8 +39,11 @@ struct timekeeper {
 	/* Raw nano seconds accumulated per NTP interval. */
 	u32	raw_interval;
 
-	/* Clock shifted nano seconds remainder not stored in xtime.tv_nsec. */
+	/* Current CLOCK_REALTIME time in seconds */
+	u64	xtime_sec;
+	/* Clock shifted nano seconds */
 	u64	xtime_nsec;
+
 	/* Difference between accumulated time and NTP time in ntp
 	 * shifted nano seconds. */
 	s64	ntp_error;
@@ -48,8 +51,6 @@ struct timekeeper {
 	 * ntp shifted nano seconds. */
 	int	ntp_error_shift;
 
-	/* The current time */
-	struct timespec xtime;
 	/*
 	 * wall_to_monotonic is what we need to add to xtime (or xtime corrected
 	 * for sub jiffie times) to get to monotonic time.  Monotonic is pegged
@@ -87,6 +88,38 @@ __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
 int __read_mostly timekeeping_suspended;
 
 
+static inline void timekeeper_normalize_xtime(struct timekeeper *tk)
+{
+	while (tk->xtime_nsec >= (NSEC_PER_SEC << tk->shift)) {
+		tk->xtime_nsec -= NSEC_PER_SEC << tk->shift;
+		tk->xtime_sec++;
+	}
+}
+
+static struct timespec timekeeper_xtime(struct timekeeper *tk)
+{
+	struct timespec ts;
+
+	ts.tv_sec = tk->xtime_sec;
+	ts.tv_nsec = (long)(tk->xtime_nsec >> tk->shift);
+	return ts;
+}
+
+static void timekeeper_set_xtime(struct timekeeper *tk,
+					const struct timespec *ts)
+{
+	tk->xtime_sec = ts->tv_sec;
+	tk->xtime_nsec = ts->tv_nsec << tk->shift;
+}
+
+
+static void timekeeper_xtime_add(struct timekeeper *tk,
+					const struct timespec *ts)
+{
+	tk->xtime_sec += ts->tv_sec;
+	tk->xtime_nsec += ts->tv_nsec << tk->shift;
+}
+
 
 /**
  * timekeeper_setup_internals - Set up internals to use clocksource clock.
@@ -143,6 +176,7 @@ static inline s64 timekeeping_get_ns(void)
 {
 	cycle_t cycle_now, cycle_delta;
 	struct clocksource *clock;
+	s64 nsec;
 
 	/* read clocksource: */
 	clock = timekeeper.clock;
@@ -151,9 +185,8 @@ static inline s64 timekeeping_get_ns(void)
 	/* calculate the delta since the last update_wall_time: */
 	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 
-	/* return delta convert to nanoseconds using ntp adjusted mult. */
-	return clocksource_cyc2ns(cycle_delta, timekeeper.mult,
-				  timekeeper.shift);
+	nsec = cycle_delta * timekeeper.mult + timekeeper.xtime_nsec;
+	return nsec >> timekeeper.shift;
 }
 
 static inline s64 timekeeping_get_ns_raw(void)
@@ -175,11 +208,13 @@ static inline s64 timekeeping_get_ns_raw(void)
 /* must hold write on timekeeper.lock */
 static void timekeeping_update(bool clearntp)
 {
+	struct timespec xt;
 	if (clearntp) {
 		timekeeper.ntp_error = 0;
 		ntp_clear();
 	}
-	update_vsyscall(&timekeeper.xtime, &timekeeper.wall_to_monotonic,
+	xt = timekeeper_xtime(&timekeeper);
+	update_vsyscall(&xt, &timekeeper.wall_to_monotonic,
 			 timekeeper.clock, timekeeper.mult);
 }
 
@@ -189,7 +224,7 @@ void timekeeping_leap_insert(int leapsecond)
 	unsigned long flags;
 
 	write_seqlock_irqsave(&timekeeper.lock, flags);
-	timekeeper.xtime.tv_sec += leapsecond;
+	timekeeper.xtime_sec += leapsecond;
 	timekeeper.wall_to_monotonic.tv_sec -= leapsecond;
 	timekeeping_update(false);
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
@@ -214,13 +249,12 @@ static void timekeeping_forward_now(void)
 	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 	clock->cycle_last = cycle_now;
 
-	nsec = clocksource_cyc2ns(cycle_delta, timekeeper.mult,
-				  timekeeper.shift);
+	timekeeper.xtime_nsec += cycle_delta * timekeeper.mult;
 
 	/* If arch requires, add in gettimeoffset() */
-	nsec += arch_gettimeoffset();
+	timekeeper.xtime_nsec += arch_gettimeoffset() << timekeeper.shift;
 
-	timespec_add_ns(&timekeeper.xtime, nsec);
+	timekeeper_normalize_xtime(&timekeeper);
 
 	nsec = clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
 	timespec_add_ns(&timekeeper.raw_time, nsec);
@@ -235,15 +269,15 @@ static void timekeeping_forward_now(void)
 void getnstimeofday(struct timespec *ts)
 {
 	unsigned long seq;
-	s64 nsecs;
+	s64 nsecs = 0;
 
 	WARN_ON(timekeeping_suspended);
 
 	do {
 		seq = read_seqbegin(&timekeeper.lock);
 
-		*ts = timekeeper.xtime;
-		nsecs = timekeeping_get_ns();
+		ts->tv_sec = timekeeper.xtime_sec;
+		ts->tv_nsec = timekeeping_get_ns();
 
 		/* If arch requires, add in gettimeoffset() */
 		nsecs += arch_gettimeoffset();
@@ -264,11 +298,10 @@ ktime_t ktime_get(void)
 
 	do {
 		seq = read_seqbegin(&timekeeper.lock);
-		secs = timekeeper.xtime.tv_sec +
+		secs = timekeeper.xtime_sec +
 				timekeeper.wall_to_monotonic.tv_sec;
-		nsecs = timekeeper.xtime.tv_nsec +
+		nsecs = timekeeping_get_ns() +
 				timekeeper.wall_to_monotonic.tv_nsec;
-		nsecs += timekeeping_get_ns();
 		/* If arch requires, add in gettimeoffset() */
 		nsecs += arch_gettimeoffset();
 
@@ -293,22 +326,21 @@ void ktime_get_ts(struct timespec *ts)
 {
 	struct timespec tomono;
 	unsigned int seq;
-	s64 nsecs;
 
 	WARN_ON(timekeeping_suspended);
 
 	do {
 		seq = read_seqbegin(&timekeeper.lock);
-		*ts = timekeeper.xtime;
+		ts->tv_sec = timekeeper.xtime_sec;
+		ts->tv_nsec = timekeeping_get_ns();
 		tomono = timekeeper.wall_to_monotonic;
-		nsecs = timekeeping_get_ns();
 		/* If arch requires, add in gettimeoffset() */
-		nsecs += arch_gettimeoffset();
+		ts->tv_nsec += arch_gettimeoffset();
 
 	} while (read_seqretry(&timekeeper.lock, seq));
 
 	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec,
-				ts->tv_nsec + tomono.tv_nsec + nsecs);
+				ts->tv_nsec + tomono.tv_nsec);
 }
 EXPORT_SYMBOL_GPL(ktime_get_ts);
 
@@ -336,7 +368,8 @@ void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 		seq = read_seqbegin(&timekeeper.lock);
 
 		*ts_raw = timekeeper.raw_time;
-		*ts_real = timekeeper.xtime;
+		ts_real->tv_sec = timekeeper.xtime_sec;
+		ts_real->tv_nsec = 0;
 
 		nsecs_raw = timekeeping_get_ns_raw();
 		nsecs_real = timekeeping_get_ns();
@@ -379,7 +412,7 @@ EXPORT_SYMBOL(do_gettimeofday);
  */
 int do_settimeofday(const struct timespec *tv)
 {
-	struct timespec ts_delta;
+	struct timespec ts_delta, xt;
 	unsigned long flags;
 
 	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
@@ -389,12 +422,15 @@ int do_settimeofday(const struct timespec *tv)
 
 	timekeeping_forward_now();
 
-	ts_delta.tv_sec = tv->tv_sec - timekeeper.xtime.tv_sec;
-	ts_delta.tv_nsec = tv->tv_nsec - timekeeper.xtime.tv_nsec;
+	xt = timekeeper_xtime(&timekeeper);
+	ts_delta.tv_sec = tv->tv_sec - xt.tv_sec;
+	ts_delta.tv_nsec = tv->tv_nsec - xt.tv_nsec;
+
 	timekeeper.wall_to_monotonic =
 			timespec_sub(timekeeper.wall_to_monotonic, ts_delta);
 
-	timekeeper.xtime = *tv;
+	timekeeper_set_xtime(&timekeeper, tv);
+
 	timekeeping_update(true);
 
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
@@ -425,7 +461,8 @@ int timekeeping_inject_offset(struct timespec *ts)
 
 	timekeeping_forward_now();
 
-	timekeeper.xtime = timespec_add(timekeeper.xtime, *ts);
+
+	timekeeper_xtime_add(&timekeeper, ts);
 	timekeeper.wall_to_monotonic =
 				timespec_sub(timekeeper.wall_to_monotonic, *ts);
 
@@ -601,14 +638,12 @@ void __init timekeeping_init(void)
 		clock->enable(clock);
 	timekeeper_setup_internals(clock);
 
-	timekeeper.xtime.tv_sec = now.tv_sec;
-	timekeeper.xtime.tv_nsec = now.tv_nsec;
+	timekeeper_set_xtime(&timekeeper, &now);
 	timekeeper.raw_time.tv_sec = 0;
 	timekeeper.raw_time.tv_nsec = 0;
-	if (boot.tv_sec == 0 && boot.tv_nsec == 0) {
-		boot.tv_sec = timekeeper.xtime.tv_sec;
-		boot.tv_nsec = timekeeper.xtime.tv_nsec;
-	}
+	if (boot.tv_sec == 0 && boot.tv_nsec == 0)
+		boot = timekeeper_xtime(&timekeeper);
+
 	set_normalized_timespec(&timekeeper.wall_to_monotonic,
 				-boot.tv_sec, -boot.tv_nsec);
 	timekeeper.total_sleep_time.tv_sec = 0;
@@ -634,7 +669,7 @@ static void __timekeeping_inject_sleeptime(struct timespec *delta)
 		return;
 	}
 
-	timekeeper.xtime = timespec_add(timekeeper.xtime, *delta);
+	timekeeper_xtime_add(&timekeeper, delta);
 	timekeeper.wall_to_monotonic =
 			timespec_sub(timekeeper.wall_to_monotonic, *delta);
 	timekeeper.total_sleep_time = timespec_add(
@@ -731,7 +766,8 @@ static int timekeeping_suspend(void)
 	 * try to compensate so the difference in system time
 	 * and persistent_clock time stays close to constant.
 	 */
-	delta = timespec_sub(timekeeper.xtime, timekeeping_suspend_time);
+	delta = timespec_sub(timekeeper_xtime(&timekeeper),
+				timekeeping_suspend_time);
 	delta_delta = timespec_sub(delta, old_delta);
 	if (abs(delta_delta.tv_sec)  >= 2) {
 		/*
@@ -963,7 +999,7 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 	timekeeper.xtime_nsec += timekeeper.xtime_interval << shift;
 	while (timekeeper.xtime_nsec >= nsecps) {
 		timekeeper.xtime_nsec -= nsecps;
-		timekeeper.xtime.tv_sec++;
+		timekeeper.xtime_sec++;
 		second_overflow();
 	}
 
@@ -997,6 +1033,7 @@ static void update_wall_time(void)
 	cycle_t offset;
 	int shift = 0, maxshift;
 	unsigned long flags;
+	s64 remainder;
 
 	write_seqlock_irqsave(&timekeeper.lock, flags);
 
@@ -1011,8 +1048,6 @@ static void update_wall_time(void)
 #else
 	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
 #endif
-	timekeeper.xtime_nsec = (s64)timekeeper.xtime.tv_nsec <<
-						timekeeper.shift;
 
 	/*
 	 * With NO_HZ we may have to accumulate many cycle_intervals
@@ -1058,25 +1093,29 @@ static void update_wall_time(void)
 		timekeeper.ntp_error += neg << timekeeper.ntp_error_shift;
 	}
 
-
 	/*
-	 * Store full nanoseconds into xtime after rounding it up and
-	 * add the remainder to the error difference.
-	 */
-	timekeeper.xtime.tv_nsec = ((s64)timekeeper.xtime_nsec >>
-						timekeeper.shift) + 1;
-	timekeeper.xtime_nsec -= (s64)timekeeper.xtime.tv_nsec <<
-						timekeeper.shift;
-	timekeeper.ntp_error +=	timekeeper.xtime_nsec <<
-				timekeeper.ntp_error_shift;
+	* Store only full nanoseconds into xtime_nsec after rounding
+	* it up and add the remainder to the error difference.
+	* XXX - This is necessary to avoid small 1ns inconsistnecies caused
+	* by truncating the remainder in vsyscalls. However, it causes
+	* additional work to be done in timekeeping_adjust(). Once
+	* the vsyscall implementations are converted to use xtime_nsec
+	* (shifted nanoseconds), this can be killed.
+	*/
+	remainder = timekeeper.xtime_nsec & ((1<<timekeeper.shift)-1);
+	timekeeper.xtime_nsec -= remainder;
+	timekeeper.xtime_nsec += 1<<timekeeper.shift;
+	timekeeper.ntp_error += remainder <<
+					timekeeper.ntp_error_shift;
 
 	/*
 	 * Finally, make sure that after the rounding
 	 * xtime.tv_nsec isn't larger then NSEC_PER_SEC
 	 */
-	if (unlikely(timekeeper.xtime.tv_nsec >= NSEC_PER_SEC)) {
-		timekeeper.xtime.tv_nsec -= NSEC_PER_SEC;
-		timekeeper.xtime.tv_sec++;
+	if (unlikely(timekeeper.xtime_nsec >=
+			(NSEC_PER_SEC << timekeeper.shift))) {
+		timekeeper.xtime_nsec -= NSEC_PER_SEC << timekeeper.shift;
+		timekeeper.xtime_sec++;
 		second_overflow();
 	}
 
@@ -1125,21 +1164,20 @@ void get_monotonic_boottime(struct timespec *ts)
 {
 	struct timespec tomono, sleep;
 	unsigned int seq;
-	s64 nsecs;
 
 	WARN_ON(timekeeping_suspended);
 
 	do {
 		seq = read_seqbegin(&timekeeper.lock);
-		*ts = timekeeper.xtime;
+		ts->tv_sec = timekeeper.xtime_sec;
+		ts->tv_nsec = timekeeping_get_ns();
 		tomono = timekeeper.wall_to_monotonic;
 		sleep = timekeeper.total_sleep_time;
-		nsecs = timekeeping_get_ns();
 
 	} while (read_seqretry(&timekeeper.lock, seq));
 
 	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec + sleep.tv_sec,
-			ts->tv_nsec + tomono.tv_nsec + sleep.tv_nsec + nsecs);
+			ts->tv_nsec + tomono.tv_nsec + sleep.tv_nsec);
 }
 EXPORT_SYMBOL_GPL(get_monotonic_boottime);
 
@@ -1172,13 +1210,13 @@ EXPORT_SYMBOL_GPL(monotonic_to_bootbased);
 
 unsigned long get_seconds(void)
 {
-	return timekeeper.xtime.tv_sec;
+	return timekeeper.xtime_sec;
 }
 EXPORT_SYMBOL(get_seconds);
 
 struct timespec __current_kernel_time(void)
 {
-	return timekeeper.xtime;
+	return timekeeper_xtime(&timekeeper);
 }
 
 struct timespec current_kernel_time(void)
@@ -1189,7 +1227,7 @@ struct timespec current_kernel_time(void)
 	do {
 		seq = read_seqbegin(&timekeeper.lock);
 
-		now = timekeeper.xtime;
+		now = timekeeper_xtime(&timekeeper);
 	} while (read_seqretry(&timekeeper.lock, seq));
 
 	return now;
@@ -1204,7 +1242,7 @@ struct timespec get_monotonic_coarse(void)
 	do {
 		seq = read_seqbegin(&timekeeper.lock);
 
-		now = timekeeper.xtime;
+		now = timekeeper_xtime(&timekeeper);
 		mono = timekeeper.wall_to_monotonic;
 	} while (read_seqretry(&timekeeper.lock, seq));
 
@@ -1239,7 +1277,7 @@ void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
 
 	do {
 		seq = read_seqbegin(&timekeeper.lock);
-		*xtim = timekeeper.xtime;
+		*xtim = timekeeper_xtime(&timekeeper);
 		*wtom = timekeeper.wall_to_monotonic;
 		*sleep = timekeeper.total_sleep_time;
 	} while (read_seqretry(&timekeeper.lock, seq));
-- 
1.7.3.2.146.gca209

