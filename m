Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab1KOEGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 23:06:33 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:46441 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab1KOEEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 23:04:23 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 06/16] time: Add timekeeper lock
Date: Mon, 14 Nov 2011 20:03:56 -0800
Message-Id: <1321329846-14755-7-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
References: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
x-cbid: 11111504-3352-0000-0000-000000C2BE54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all the timekeeping variables are stored in
the timekeeper structure, add a new lock to protect the
structure.

For now, this lock nests under the xtime_lock for writes.

For readers, we don't need to take xtime_lock anymore.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |  126 +++++++++++++++++++++++++++++----------------
 1 files changed, 82 insertions(+), 44 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 78872ba..8f54200 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -69,6 +69,9 @@ struct timekeeper {
 	struct timespec total_sleep_time;
 	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
 	struct timespec raw_time;
+
+	/* Seqlock for all timekeeper values */
+	seqlock_t lock;
 };
 
 static struct timekeeper timekeeper;
@@ -172,10 +175,17 @@ static inline s64 timekeeping_get_ns_raw(void)
 /* must hold xtime_lock */
 void timekeeping_leap_insert(int leapsecond)
 {
+	unsigned long flags;
+
+	write_seqlock_irqsave(&timekeeper.lock, flags);
+
 	timekeeper.xtime.tv_sec += leapsecond;
 	timekeeper.wall_to_monotonic.tv_sec -= leapsecond;
 	update_vsyscall(&timekeeper.xtime, &timekeeper.wall_to_monotonic,
 			 timekeeper.clock, timekeeper.mult);
+
+	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+
 }
 
 /**
@@ -222,7 +232,7 @@ void getnstimeofday(struct timespec *ts)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqbegin(&timekeeper.lock);
 
 		*ts = timekeeper.xtime;
 		nsecs = timekeeping_get_ns();
@@ -230,7 +240,7 @@ void getnstimeofday(struct timespec *ts)
 		/* If arch requires, add in gettimeoffset() */
 		nsecs += arch_gettimeoffset();
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqretry(&timekeeper.lock, seq));
 
 	timespec_add_ns(ts, nsecs);
 }
@@ -245,14 +255,14 @@ ktime_t ktime_get(void)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqbegin(&timekeeper.lock);
 		secs = timekeeper.xtime.tv_sec +
 				timekeeper.wall_to_monotonic.tv_sec;
 		nsecs = timekeeper.xtime.tv_nsec +
 				timekeeper.wall_to_monotonic.tv_nsec;
 		nsecs += timekeeping_get_ns();
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqretry(&timekeeper.lock, seq));
 	/*
 	 * Use ktime_set/ktime_add_ns to create a proper ktime on
 	 * 32-bit architectures without CONFIG_KTIME_SCALAR.
@@ -278,12 +288,12 @@ void ktime_get_ts(struct timespec *ts)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqbegin(&timekeeper.lock);
 		*ts = timekeeper.xtime;
 		tomono = timekeeper.wall_to_monotonic;
 		nsecs = timekeeping_get_ns();
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqretry(&timekeeper.lock, seq));
 
 	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec,
 				ts->tv_nsec + tomono.tv_nsec + nsecs);
@@ -311,7 +321,7 @@ void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 	do {
 		u32 arch_offset;
 
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqbegin(&timekeeper.lock);
 
 		*ts_raw = timekeeper.raw_time;
 		*ts_real = timekeeper.xtime;
@@ -324,7 +334,7 @@ void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 		nsecs_raw += arch_offset;
 		nsecs_real += arch_offset;
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqretry(&timekeeper.lock, seq));
 
 	timespec_add_ns(ts_raw, nsecs_raw);
 	timespec_add_ns(ts_real, nsecs_real);
@@ -358,12 +368,13 @@ EXPORT_SYMBOL(do_gettimeofday);
 int do_settimeofday(const struct timespec *tv)
 {
 	struct timespec ts_delta;
-	unsigned long flags;
+	unsigned long flags1,flags2;
 
 	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	write_seqlock_irqsave(&xtime_lock, flags1);
+	write_seqlock_irqsave(&timekeeper.lock, flags2);
 
 	timekeeping_forward_now();
 
@@ -380,7 +391,8 @@ int do_settimeofday(const struct timespec *tv)
 	update_vsyscall(&timekeeper.xtime, &timekeeper.wall_to_monotonic,
 			timekeeper.clock, timekeeper.mult);
 
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_sequnlock_irqrestore(&timekeeper.lock, flags2);
+	write_sequnlock_irqrestore(&xtime_lock, flags1);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -399,12 +411,13 @@ EXPORT_SYMBOL(do_settimeofday);
  */
 int timekeeping_inject_offset(struct timespec *ts)
 {
-	unsigned long flags;
+	unsigned long flags1,flags2;
 
 	if ((unsigned long)ts->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	write_seqlock_irqsave(&xtime_lock, flags1);
+	write_seqlock_irqsave(&timekeeper.lock, flags2);
 
 	timekeeping_forward_now();
 
@@ -418,7 +431,8 @@ int timekeeping_inject_offset(struct timespec *ts)
 	update_vsyscall(&timekeeper.xtime, &timekeeper.wall_to_monotonic,
 			timekeeper.clock, timekeeper.mult);
 
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_sequnlock_irqrestore(&timekeeper.lock, flags2);
+	write_sequnlock_irqrestore(&xtime_lock, flags1);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -490,11 +504,11 @@ void getrawmonotonic(struct timespec *ts)
 	s64 nsecs;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqbegin(&timekeeper.lock);
 		nsecs = timekeeping_get_ns_raw();
 		*ts = timekeeper.raw_time;
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqretry(&timekeeper.lock, seq));
 
 	timespec_add_ns(ts, nsecs);
 }
@@ -510,24 +524,30 @@ int timekeeping_valid_for_hres(void)
 	int ret;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqbegin(&timekeeper.lock);
 
 		ret = timekeeper.clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqretry(&timekeeper.lock, seq));
 
 	return ret;
 }
 
 /**
  * timekeeping_max_deferment - Returns max time the clocksource can be deferred
- *
- * Caller must observe xtime_lock via read_seqbegin/read_seqretry to
- * ensure that the clocksource does not change!
  */
 u64 timekeeping_max_deferment(void)
 {
-	return timekeeper.clock->max_idle_ns;
+	unsigned long seq;
+	u64 ret;
+	do {
+		seq = read_seqbegin(&timekeeper.lock);
+
+		ret = timekeeper.clock->max_idle_ns;
+
+	} while (read_seqretry(&timekeeper.lock, seq));
+
+	return ret;
 }
 
 /**
@@ -572,10 +592,13 @@ void __init timekeeping_init(void)
 	read_persistent_clock(&now);
 	read_boot_clock(&boot);
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	seqlock_init(&timekeeper.lock);
 
+	write_seqlock_irqsave(&xtime_lock, flags);
 	ntp_init();
+	write_sequnlock_irqrestore(&xtime_lock, flags);
 
+	write_seqlock_irqsave(&timekeeper.lock, flags);
 	clock = clocksource_default_clock();
 	if (clock->enable)
 		clock->enable(clock);
@@ -593,7 +616,7 @@ void __init timekeeping_init(void)
 				-boot.tv_sec, -boot.tv_nsec);
 	timekeeper.total_sleep_time.tv_sec = 0;
 	timekeeper.total_sleep_time.tv_nsec = 0;
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 }
 
 /* time in seconds when suspend began */
@@ -634,7 +657,7 @@ static void __timekeeping_inject_sleeptime(struct timespec *delta)
  */
 void timekeeping_inject_sleeptime(struct timespec *delta)
 {
-	unsigned long flags;
+	unsigned long flags1,flags2;
 	struct timespec ts;
 
 	/* Make sure we don't set the clock twice */
@@ -642,7 +665,9 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 	if (!(ts.tv_sec == 0 && ts.tv_nsec == 0))
 		return;
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	write_seqlock_irqsave(&xtime_lock, flags1);
+	write_seqlock_irqsave(&timekeeper.lock, flags2);
+
 	timekeeping_forward_now();
 
 	__timekeeping_inject_sleeptime(delta);
@@ -652,7 +677,8 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 	update_vsyscall(&timekeeper.xtime, &timekeeper.wall_to_monotonic,
 			timekeeper.clock, timekeeper.mult);
 
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_sequnlock_irqrestore(&timekeeper.lock, flags2);
+	write_sequnlock_irqrestore(&xtime_lock, flags1);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -668,14 +694,15 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
  */
 static void timekeeping_resume(void)
 {
-	unsigned long flags;
+	unsigned long flags1,flags2;
 	struct timespec ts;
 
 	read_persistent_clock(&ts);
 
 	clocksource_resume();
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	write_seqlock_irqsave(&xtime_lock, flags1);
+	write_seqlock_irqsave(&timekeeper.lock, flags2);
 
 	if (timespec_compare(&ts, &timekeeping_suspend_time) > 0) {
 		ts = timespec_sub(ts, timekeeping_suspend_time);
@@ -685,7 +712,8 @@ static void timekeeping_resume(void)
 	timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
 	timekeeper.ntp_error = 0;
 	timekeeping_suspended = 0;
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_sequnlock_irqrestore(&timekeeper.lock, flags2);
+	write_sequnlock_irqrestore(&xtime_lock, flags1);
 
 	touch_softlockup_watchdog();
 
@@ -697,13 +725,14 @@ static void timekeeping_resume(void)
 
 static int timekeeping_suspend(void)
 {
-	unsigned long flags;
+	unsigned long flags1,flags2;
 	struct timespec		delta, delta_delta;
 	static struct timespec	old_delta;
 
 	read_persistent_clock(&timekeeping_suspend_time);
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	write_seqlock_irqsave(&xtime_lock, flags1);
+	write_seqlock_irqsave(&timekeeper.lock, flags2);
 	timekeeping_forward_now();
 	timekeeping_suspended = 1;
 
@@ -726,7 +755,8 @@ static int timekeeping_suspend(void)
 		timekeeping_suspend_time =
 			timespec_add(timekeeping_suspend_time, delta_delta);
 	}
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_sequnlock_irqrestore(&timekeeper.lock, flags2);
+	write_sequnlock_irqrestore(&xtime_lock, flags1);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
 	clocksource_suspend();
@@ -893,10 +923,13 @@ static void update_wall_time(void)
 	struct clocksource *clock;
 	cycle_t offset;
 	int shift = 0, maxshift;
+	unsigned long flags;
+
+	write_seqlock_irqsave(&timekeeper.lock, flags);
 
 	/* Make sure we're fully resumed: */
 	if (unlikely(timekeeping_suspended))
-		return;
+		goto out;
 
 	clock = timekeeper.clock;
 
@@ -977,6 +1010,10 @@ static void update_wall_time(void)
 	/* check to see if there is a new clocksource to use */
 	update_vsyscall(&timekeeper.xtime, &timekeeper.wall_to_monotonic,
 			timekeeper.clock, timekeeper.mult);
+
+out:
+	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+
 }
 
 /**
@@ -1022,13 +1059,13 @@ void get_monotonic_boottime(struct timespec *ts)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqbegin(&timekeeper.lock);
 		*ts = timekeeper.xtime;
 		tomono = timekeeper.wall_to_monotonic;
 		sleep = timekeeper.total_sleep_time;
 		nsecs = timekeeping_get_ns();
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqretry(&timekeeper.lock, seq));
 
 	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec + sleep.tv_sec,
 			ts->tv_nsec + tomono.tv_nsec + sleep.tv_nsec + nsecs);
@@ -1079,10 +1116,10 @@ struct timespec current_kernel_time(void)
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqbegin(&timekeeper.lock);
 
 		now = timekeeper.xtime;
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqretry(&timekeeper.lock, seq));
 
 	return now;
 }
@@ -1094,11 +1131,11 @@ struct timespec get_monotonic_coarse(void)
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqbegin(&timekeeper.lock);
 
 		now = timekeeper.xtime;
 		mono = timekeeper.wall_to_monotonic;
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqretry(&timekeeper.lock, seq));
 
 	set_normalized_timespec(&now, now.tv_sec + mono.tv_sec,
 				now.tv_nsec + mono.tv_nsec);
@@ -1130,11 +1167,11 @@ void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqbegin(&timekeeper.lock);
 		*xtim = timekeeper.xtime;
 		*wtom = timekeeper.wall_to_monotonic;
 		*sleep = timekeeper.total_sleep_time;
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqretry(&timekeeper.lock, seq));
 }
 
 /**
@@ -1146,9 +1183,10 @@ ktime_t ktime_get_monotonic_offset(void)
 	struct timespec wtom;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqbegin(&timekeeper.lock);
 		wtom = timekeeper.wall_to_monotonic;
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqretry(&timekeeper.lock, seq));
+
 	return timespec_to_ktime(wtom);
 }
 
-- 
1.7.3.2.146.gca209

