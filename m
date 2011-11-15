Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab1KOEE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 23:04:27 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:51557 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833Ab1KOEEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 23:04:24 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 03/16] time: Move xtime into timekeeeper structure
Date: Mon, 14 Nov 2011 20:03:53 -0800
Message-Id: <1321329846-14755-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
References: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
x-cbid: 11111504-6148-0000-0000-000001338187
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for locking cleanups, move xtime into
timekeeper structure.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   91 +++++++++++++++++++++++----------------------
 1 files changed, 47 insertions(+), 44 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 15740b5..6c64931 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -48,6 +48,8 @@ struct timekeeper {
 	/* NTP adjusted clock multiplier */
 	u32	mult;
 
+	/* The current time */
+	struct timespec xtime;
 	/*
 	 * wall_to_monotonic is what we need to add to xtime (or xtime corrected
 	 * for sub jiffie times) to get to monotonic time.  Monotonic is pegged
@@ -161,10 +163,6 @@ static inline s64 timekeeping_get_ns_raw(void)
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
 
 
-/*
- * The current time
- */
-static struct timespec xtime __attribute__ ((aligned (16)));
 
 /*
  * The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock.
@@ -177,10 +175,10 @@ int __read_mostly timekeeping_suspended;
 /* must hold xtime_lock */
 void timekeeping_leap_insert(int leapsecond)
 {
-	xtime.tv_sec += leapsecond;
+	timekeeper.xtime.tv_sec += leapsecond;
 	timekeeper.wall_to_monotonic.tv_sec -= leapsecond;
-	update_vsyscall(&xtime, &timekeeper.wall_to_monotonic, timekeeper.clock,
-			timekeeper.mult);
+	update_vsyscall(&timekeeper.xtime, &timekeeper.wall_to_monotonic,
+			 timekeeper.clock, timekeeper.mult);
 }
 
 /**
@@ -207,7 +205,7 @@ static void timekeeping_forward_now(void)
 	/* If arch requires, add in gettimeoffset() */
 	nsec += arch_gettimeoffset();
 
-	timespec_add_ns(&xtime, nsec);
+	timespec_add_ns(&timekeeper.xtime, nsec);
 
 	nsec = clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
 	timespec_add_ns(&raw_time, nsec);
@@ -229,7 +227,7 @@ void getnstimeofday(struct timespec *ts)
 	do {
 		seq = read_seqbegin(&xtime_lock);
 
-		*ts = xtime;
+		*ts = timekeeper.xtime;
 		nsecs = timekeeping_get_ns();
 
 		/* If arch requires, add in gettimeoffset() */
@@ -251,8 +249,10 @@ ktime_t ktime_get(void)
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
-		secs = xtime.tv_sec + timekeeper.wall_to_monotonic.tv_sec;
-		nsecs = xtime.tv_nsec + timekeeper.wall_to_monotonic.tv_nsec;
+		secs = timekeeper.xtime.tv_sec +
+				timekeeper.wall_to_monotonic.tv_sec;
+		nsecs = timekeeper.xtime.tv_nsec +
+				timekeeper.wall_to_monotonic.tv_nsec;
 		nsecs += timekeeping_get_ns();
 
 	} while (read_seqretry(&xtime_lock, seq));
@@ -282,7 +282,7 @@ void ktime_get_ts(struct timespec *ts)
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
-		*ts = xtime;
+		*ts = timekeeper.xtime;
 		tomono = timekeeper.wall_to_monotonic;
 		nsecs = timekeeping_get_ns();
 
@@ -317,7 +317,7 @@ void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 		seq = read_seqbegin(&xtime_lock);
 
 		*ts_raw = raw_time;
-		*ts_real = xtime;
+		*ts_real = timekeeper.xtime;
 
 		nsecs_raw = timekeeping_get_ns_raw();
 		nsecs_real = timekeeping_get_ns();
@@ -370,18 +370,18 @@ int do_settimeofday(const struct timespec *tv)
 
 	timekeeping_forward_now();
 
-	ts_delta.tv_sec = tv->tv_sec - xtime.tv_sec;
-	ts_delta.tv_nsec = tv->tv_nsec - xtime.tv_nsec;
+	ts_delta.tv_sec = tv->tv_sec - timekeeper.xtime.tv_sec;
+	ts_delta.tv_nsec = tv->tv_nsec - timekeeper.xtime.tv_nsec;
 	timekeeper.wall_to_monotonic =
 			timespec_sub(timekeeper.wall_to_monotonic, ts_delta);
 
-	xtime = *tv;
+	timekeeper.xtime = *tv;
 
 	timekeeper.ntp_error = 0;
 	ntp_clear();
 
-	update_vsyscall(&xtime, &timekeeper.wall_to_monotonic, timekeeper.clock,
-				timekeeper.mult);
+	update_vsyscall(&timekeeper.xtime, &timekeeper.wall_to_monotonic,
+			timekeeper.clock, timekeeper.mult);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -411,15 +411,15 @@ int timekeeping_inject_offset(struct timespec *ts)
 
 	timekeeping_forward_now();
 
-	xtime = timespec_add(xtime, *ts);
+	timekeeper.xtime = timespec_add(timekeeper.xtime, *ts);
 	timekeeper.wall_to_monotonic =
 				timespec_sub(timekeeper.wall_to_monotonic, *ts);
 
 	timekeeper.ntp_error = 0;
 	ntp_clear();
 
-	update_vsyscall(&xtime, &timekeeper.wall_to_monotonic, timekeeper.clock,
-				timekeeper.mult);
+	update_vsyscall(&timekeeper.xtime, &timekeeper.wall_to_monotonic,
+			timekeeper.clock, timekeeper.mult);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -584,13 +584,13 @@ void __init timekeeping_init(void)
 		clock->enable(clock);
 	timekeeper_setup_internals(clock);
 
-	xtime.tv_sec = now.tv_sec;
-	xtime.tv_nsec = now.tv_nsec;
+	timekeeper.xtime.tv_sec = now.tv_sec;
+	timekeeper.xtime.tv_nsec = now.tv_nsec;
 	raw_time.tv_sec = 0;
 	raw_time.tv_nsec = 0;
 	if (boot.tv_sec == 0 && boot.tv_nsec == 0) {
-		boot.tv_sec = xtime.tv_sec;
-		boot.tv_nsec = xtime.tv_nsec;
+		boot.tv_sec = timekeeper.xtime.tv_sec;
+		boot.tv_nsec = timekeeper.xtime.tv_nsec;
 	}
 	set_normalized_timespec(&timekeeper.wall_to_monotonic,
 				-boot.tv_sec, -boot.tv_nsec);
@@ -617,7 +617,7 @@ static void __timekeeping_inject_sleeptime(struct timespec *delta)
 		return;
 	}
 
-	xtime = timespec_add(xtime, *delta);
+	timekeeper.xtime = timespec_add(timekeeper.xtime, *delta);
 	timekeeper.wall_to_monotonic =
 			timespec_sub(timekeeper.wall_to_monotonic, *delta);
 	timekeeper.total_sleep_time = timespec_add(
@@ -652,8 +652,8 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 
 	timekeeper.ntp_error = 0;
 	ntp_clear();
-	update_vsyscall(&xtime, &timekeeper.wall_to_monotonic, timekeeper.clock,
-				timekeeper.mult);
+	update_vsyscall(&timekeeper.xtime, &timekeeper.wall_to_monotonic,
+			timekeeper.clock, timekeeper.mult);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -716,7 +716,7 @@ static int timekeeping_suspend(void)
 	 * try to compensate so the difference in system time
 	 * and persistent_clock time stays close to constant.
 	 */
-	delta = timespec_sub(xtime, timekeeping_suspend_time);
+	delta = timespec_sub(timekeeper.xtime, timekeeping_suspend_time);
 	delta_delta = timespec_sub(delta, old_delta);
 	if (abs(delta_delta.tv_sec)  >= 2) {
 		/*
@@ -862,7 +862,7 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 	timekeeper.xtime_nsec += timekeeper.xtime_interval << shift;
 	while (timekeeper.xtime_nsec >= nsecps) {
 		timekeeper.xtime_nsec -= nsecps;
-		xtime.tv_sec++;
+		timekeeper.xtime.tv_sec++;
 		second_overflow();
 	}
 
@@ -908,7 +908,8 @@ static void update_wall_time(void)
 #else
 	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
 #endif
-	timekeeper.xtime_nsec = (s64)xtime.tv_nsec << timekeeper.shift;
+	timekeeper.xtime_nsec = (s64)timekeeper.xtime.tv_nsec <<
+						timekeeper.shift;
 
 	/*
 	 * With NO_HZ we may have to accumulate many cycle_intervals
@@ -959,8 +960,10 @@ static void update_wall_time(void)
 	 * Store full nanoseconds into xtime after rounding it up and
 	 * add the remainder to the error difference.
 	 */
-	xtime.tv_nsec =	((s64) timekeeper.xtime_nsec >> timekeeper.shift) + 1;
-	timekeeper.xtime_nsec -= (s64) xtime.tv_nsec << timekeeper.shift;
+	timekeeper.xtime.tv_nsec = ((s64)timekeeper.xtime_nsec >>
+						timekeeper.shift) + 1;
+	timekeeper.xtime_nsec -= (s64)timekeeper.xtime.tv_nsec <<
+						timekeeper.shift;
 	timekeeper.ntp_error +=	timekeeper.xtime_nsec <<
 				timekeeper.ntp_error_shift;
 
@@ -968,15 +971,15 @@ static void update_wall_time(void)
 	 * Finally, make sure that after the rounding
 	 * xtime.tv_nsec isn't larger then NSEC_PER_SEC
 	 */
-	if (unlikely(xtime.tv_nsec >= NSEC_PER_SEC)) {
-		xtime.tv_nsec -= NSEC_PER_SEC;
-		xtime.tv_sec++;
+	if (unlikely(timekeeper.xtime.tv_nsec >= NSEC_PER_SEC)) {
+		timekeeper.xtime.tv_nsec -= NSEC_PER_SEC;
+		timekeeper.xtime.tv_sec++;
 		second_overflow();
 	}
 
 	/* check to see if there is a new clocksource to use */
-	update_vsyscall(&xtime, &timekeeper.wall_to_monotonic, timekeeper.clock,
-				timekeeper.mult);
+	update_vsyscall(&timekeeper.xtime, &timekeeper.wall_to_monotonic,
+			timekeeper.clock, timekeeper.mult);
 }
 
 /**
@@ -1023,7 +1026,7 @@ void get_monotonic_boottime(struct timespec *ts)
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
-		*ts = xtime;
+		*ts = timekeeper.xtime;
 		tomono = timekeeper.wall_to_monotonic;
 		sleep = timekeeper.total_sleep_time;
 		nsecs = timekeeping_get_ns();
@@ -1064,13 +1067,13 @@ EXPORT_SYMBOL_GPL(monotonic_to_bootbased);
 
 unsigned long get_seconds(void)
 {
-	return xtime.tv_sec;
+	return timekeeper.xtime.tv_sec;
 }
 EXPORT_SYMBOL(get_seconds);
 
 struct timespec __current_kernel_time(void)
 {
-	return xtime;
+	return timekeeper.xtime;
 }
 
 struct timespec current_kernel_time(void)
@@ -1081,7 +1084,7 @@ struct timespec current_kernel_time(void)
 	do {
 		seq = read_seqbegin(&xtime_lock);
 
-		now = xtime;
+		now = timekeeper.xtime;
 	} while (read_seqretry(&xtime_lock, seq));
 
 	return now;
@@ -1096,7 +1099,7 @@ struct timespec get_monotonic_coarse(void)
 	do {
 		seq = read_seqbegin(&xtime_lock);
 
-		now = xtime;
+		now = timekeeper.xtime;
 		mono = timekeeper.wall_to_monotonic;
 	} while (read_seqretry(&xtime_lock, seq));
 
@@ -1131,7 +1134,7 @@ void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
-		*xtim = xtime;
+		*xtim = timekeeper.xtime;
 		*wtom = timekeeper.wall_to_monotonic;
 		*sleep = timekeeper.total_sleep_time;
 	} while (read_seqretry(&xtime_lock, seq));
-- 
1.7.3.2.146.gca209

