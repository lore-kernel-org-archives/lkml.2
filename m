Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab2B1A3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:29:55 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45812 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932166Ab2B1A3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:29:52 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 3/7] time: Split timekeeper lock into separate reader/writer locks
Date: Mon, 27 Feb 2012 16:29:30 -0800
Message-Id: <1330388974-27793-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1330388974-27793-1-git-send-email-john.stultz@linaro.org>
References: <1330388974-27793-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022800-9360-0000-0000-00000409021D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to reduce the lock hold time, split the timekeeper lock
into a writer lock, which serializes updates to the timekeeper
structure, and a reader sequence counter, which ensures readers
see a consistent version of the timekeeper.

This will allow us to reduce the lock wait time for readers, by
doing updates on a shadow copy of the timekeeper.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |  113 +++++++++++++++++++++++++++------------------
 1 files changed, 68 insertions(+), 45 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 9e6b28e..4962284 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -71,8 +71,9 @@ struct timekeeper {
 	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
 	struct timespec raw_time;
 
-	/* Seqlock for all timekeeper values */
-	seqlock_t lock;
+	/* locks for timekeeper structure */
+	seqcount_t rlock;   /* This seqcount serializes readers from updates */
+	spinlock_t wlock;	/* This spinlock serializes updaters */
 };
 
 static struct timekeeper timekeeper;
@@ -205,7 +206,7 @@ static inline s64 timekeeping_get_ns_raw(void)
 	return clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
 }
 
-/* must hold write on timekeeper.lock */
+/* must hold write on timekeeper.wlock */
 static void timekeeping_update(struct timekeeper *tk, bool clearntp)
 {
 	struct timespec xt;
@@ -222,11 +223,13 @@ void timekeeping_leap_insert(int leapsecond)
 {
 	unsigned long flags;
 
-	write_seqlock_irqsave(&timekeeper.lock, flags);
+	spin_lock_irqsave(&timekeeper.wlock, flags);
+	write_seqcount_begin(&timekeeper.rlock);
 	timekeeper.xtime_sec += leapsecond;
 	timekeeper.wall_to_monotonic.tv_sec -= leapsecond;
 	timekeeping_update(&timekeeper, false);
-	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+	write_seqcount_end(&timekeeper.rlock);
+	spin_unlock_irqrestore(&timekeeper.wlock, flags);
 
 }
 
@@ -273,7 +276,7 @@ void getnstimeofday(struct timespec *ts)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&timekeeper.lock);
+		seq = read_seqcount_begin(&timekeeper.rlock);
 
 		ts->tv_sec = timekeeper.xtime_sec;
 		ts->tv_nsec = timekeeping_get_ns();
@@ -281,7 +284,7 @@ void getnstimeofday(struct timespec *ts)
 		/* If arch requires, add in gettimeoffset() */
 		nsecs += arch_gettimeoffset();
 
-	} while (read_seqretry(&timekeeper.lock, seq));
+	} while (read_seqcount_retry(&timekeeper.rlock, seq));
 
 	timespec_add_ns(ts, nsecs);
 }
@@ -296,7 +299,7 @@ ktime_t ktime_get(void)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&timekeeper.lock);
+		seq = read_seqcount_begin(&timekeeper.rlock);
 		secs = timekeeper.xtime_sec +
 				timekeeper.wall_to_monotonic.tv_sec;
 		nsecs = timekeeping_get_ns() +
@@ -304,7 +307,7 @@ ktime_t ktime_get(void)
 		/* If arch requires, add in gettimeoffset() */
 		nsecs += arch_gettimeoffset();
 
-	} while (read_seqretry(&timekeeper.lock, seq));
+	} while (read_seqcount_retry(&timekeeper.rlock, seq));
 	/*
 	 * Use ktime_set/ktime_add_ns to create a proper ktime on
 	 * 32-bit architectures without CONFIG_KTIME_SCALAR.
@@ -329,14 +332,14 @@ void ktime_get_ts(struct timespec *ts)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&timekeeper.lock);
+		seq = read_seqcount_begin(&timekeeper.rlock);
 		ts->tv_sec = timekeeper.xtime_sec;
 		ts->tv_nsec = timekeeping_get_ns();
 		tomono = timekeeper.wall_to_monotonic;
 		/* If arch requires, add in gettimeoffset() */
 		ts->tv_nsec += arch_gettimeoffset();
 
-	} while (read_seqretry(&timekeeper.lock, seq));
+	} while (read_seqcount_retry(&timekeeper.rlock, seq));
 
 	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec,
 				ts->tv_nsec + tomono.tv_nsec);
@@ -364,7 +367,7 @@ void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 	do {
 		u32 arch_offset;
 
-		seq = read_seqbegin(&timekeeper.lock);
+		seq = read_seqcount_begin(&timekeeper.rlock);
 
 		*ts_raw = timekeeper.raw_time;
 		ts_real->tv_sec = timekeeper.xtime_sec;
@@ -378,7 +381,7 @@ void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 		nsecs_raw += arch_offset;
 		nsecs_real += arch_offset;
 
-	} while (read_seqretry(&timekeeper.lock, seq));
+	} while (read_seqcount_retry(&timekeeper.rlock, seq));
 
 	timespec_add_ns(ts_raw, nsecs_raw);
 	timespec_add_ns(ts_real, nsecs_real);
@@ -417,7 +420,8 @@ int do_settimeofday(const struct timespec *tv)
 	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
-	write_seqlock_irqsave(&timekeeper.lock, flags);
+	spin_lock_irqsave(&timekeeper.wlock, flags);
+	write_seqcount_begin(&timekeeper.rlock);
 
 	timekeeping_forward_now();
 
@@ -432,7 +436,8 @@ int do_settimeofday(const struct timespec *tv)
 
 	timekeeping_update(&timekeeper, true);
 
-	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+	write_seqcount_end(&timekeeper.rlock);
+	spin_unlock_irqrestore(&timekeeper.wlock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -456,7 +461,8 @@ int timekeeping_inject_offset(struct timespec *ts)
 	if ((unsigned long)ts->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
-	write_seqlock_irqsave(&timekeeper.lock, flags);
+	spin_lock_irqsave(&timekeeper.wlock, flags);
+	write_seqcount_begin(&timekeeper.rlock);
 
 	timekeeping_forward_now();
 
@@ -467,7 +473,8 @@ int timekeeping_inject_offset(struct timespec *ts)
 
 	timekeeping_update(&timekeeper, true);
 
-	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+	write_seqcount_end(&timekeeper.rlock);
+	spin_unlock_irqrestore(&timekeeper.wlock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -539,11 +546,11 @@ void getrawmonotonic(struct timespec *ts)
 	s64 nsecs;
 
 	do {
-		seq = read_seqbegin(&timekeeper.lock);
+		seq = read_seqcount_begin(&timekeeper.rlock);
 		nsecs = timekeeping_get_ns_raw();
 		*ts = timekeeper.raw_time;
 
-	} while (read_seqretry(&timekeeper.lock, seq));
+	} while (read_seqcount_retry(&timekeeper.rlock, seq));
 
 	timespec_add_ns(ts, nsecs);
 }
@@ -559,11 +566,11 @@ int timekeeping_valid_for_hres(void)
 	int ret;
 
 	do {
-		seq = read_seqbegin(&timekeeper.lock);
+		seq = read_seqcount_begin(&timekeeper.rlock);
 
 		ret = timekeeper.clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
 
-	} while (read_seqretry(&timekeeper.lock, seq));
+	} while (read_seqcount_retry(&timekeeper.rlock, seq));
 
 	return ret;
 }
@@ -576,11 +583,11 @@ u64 timekeeping_max_deferment(void)
 	unsigned long seq;
 	u64 ret;
 	do {
-		seq = read_seqbegin(&timekeeper.lock);
+		seq = read_seqcount_begin(&timekeeper.rlock);
 
 		ret = timekeeper.clock->max_idle_ns;
 
-	} while (read_seqretry(&timekeeper.lock, seq));
+	} while (read_seqcount_retry(&timekeeper.rlock, seq));
 
 	return ret;
 }
@@ -627,11 +634,13 @@ void __init timekeeping_init(void)
 	read_persistent_clock(&now);
 	read_boot_clock(&boot);
 
-	seqlock_init(&timekeeper.lock);
-
+	seqcount_init(&timekeeper.rlock);
+	spin_lock_init(&timekeeper.wlock);
 	ntp_init();
 
-	write_seqlock_irqsave(&timekeeper.lock, flags);
+	spin_lock_irqsave(&timekeeper.wlock, flags);
+	write_seqcount_begin(&timekeeper.rlock);
+
 	clock = clocksource_default_clock();
 	if (clock->enable)
 		clock->enable(clock);
@@ -647,7 +656,10 @@ void __init timekeeping_init(void)
 				-boot.tv_sec, -boot.tv_nsec);
 	timekeeper.total_sleep_time.tv_sec = 0;
 	timekeeper.total_sleep_time.tv_nsec = 0;
-	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+
+	write_seqcount_end(&timekeeper.rlock);
+	spin_unlock_irqrestore(&timekeeper.wlock, flags);
+
 }
 
 /* time in seconds when suspend began */
@@ -696,7 +708,8 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 	if (!(ts.tv_sec == 0 && ts.tv_nsec == 0))
 		return;
 
-	write_seqlock_irqsave(&timekeeper.lock, flags);
+	spin_lock_irqsave(&timekeeper.wlock, flags);
+	write_seqcount_begin(&timekeeper.rlock);
 
 	timekeeping_forward_now();
 
@@ -704,7 +717,8 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 
 	timekeeping_update(&timekeeper, true);
 
-	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+	write_seqcount_end(&timekeeper.rlock);
+	spin_unlock_irqrestore(&timekeeper.wlock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -727,7 +741,8 @@ static void timekeeping_resume(void)
 
 	clocksource_resume();
 
-	write_seqlock_irqsave(&timekeeper.lock, flags);
+	spin_lock_irqsave(&timekeeper.wlock, flags);
+	write_seqcount_begin(&timekeeper.rlock);
 
 	if (timespec_compare(&ts, &timekeeping_suspend_time) > 0) {
 		ts = timespec_sub(ts, timekeeping_suspend_time);
@@ -737,7 +752,9 @@ static void timekeeping_resume(void)
 	timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
 	timekeeper.ntp_error = 0;
 	timekeeping_suspended = 0;
-	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+
+	write_seqcount_end(&timekeeper.rlock);
+	spin_unlock_irqrestore(&timekeeper.wlock, flags);
 
 	touch_softlockup_watchdog();
 
@@ -755,7 +772,9 @@ static int timekeeping_suspend(void)
 
 	read_persistent_clock(&timekeeping_suspend_time);
 
-	write_seqlock_irqsave(&timekeeper.lock, flags);
+	spin_lock_irqsave(&timekeeper.wlock, flags);
+	write_seqcount_begin(&timekeeper.rlock);
+
 	timekeeping_forward_now();
 	timekeeping_suspended = 1;
 
@@ -779,7 +798,9 @@ static int timekeeping_suspend(void)
 		timekeeping_suspend_time =
 			timespec_add(timekeeping_suspend_time, delta_delta);
 	}
-	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+
+	write_seqcount_end(&timekeeper.rlock);
+	spin_unlock_irqrestore(&timekeeper.wlock, flags);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
 	clocksource_suspend();
@@ -1035,7 +1056,8 @@ static void update_wall_time(void)
 	unsigned long flags;
 	s64 remainder;
 
-	write_seqlock_irqsave(&timekeeper.lock, flags);
+	spin_lock_irqsave(&timekeeper.wlock, flags);
+	write_seqcount_begin(&timekeeper.rlock);
 
 	/* Make sure we're fully resumed: */
 	if (unlikely(timekeeping_suspended))
@@ -1122,7 +1144,8 @@ static void update_wall_time(void)
 	timekeeping_update(&timekeeper, false);
 
 out:
-	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+	write_seqcount_end(&timekeeper.rlock);
+	spin_unlock_irqrestore(&timekeeper.wlock, flags);
 
 }
 
@@ -1168,13 +1191,13 @@ void get_monotonic_boottime(struct timespec *ts)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&timekeeper.lock);
+		seq = read_seqcount_begin(&timekeeper.rlock);
 		ts->tv_sec = timekeeper.xtime_sec;
 		ts->tv_nsec = timekeeping_get_ns();
 		tomono = timekeeper.wall_to_monotonic;
 		sleep = timekeeper.total_sleep_time;
 
-	} while (read_seqretry(&timekeeper.lock, seq));
+	} while (read_seqcount_retry(&timekeeper.rlock, seq));
 
 	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec + sleep.tv_sec,
 			ts->tv_nsec + tomono.tv_nsec + sleep.tv_nsec);
@@ -1225,10 +1248,10 @@ struct timespec current_kernel_time(void)
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&timekeeper.lock);
+		seq = read_seqcount_begin(&timekeeper.rlock);
 
 		now = timekeeper_xtime(&timekeeper);
-	} while (read_seqretry(&timekeeper.lock, seq));
+	} while (read_seqcount_retry(&timekeeper.rlock, seq));
 
 	return now;
 }
@@ -1240,11 +1263,11 @@ struct timespec get_monotonic_coarse(void)
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&timekeeper.lock);
+		seq = read_seqcount_begin(&timekeeper.rlock);
 
 		now = timekeeper_xtime(&timekeeper);
 		mono = timekeeper.wall_to_monotonic;
-	} while (read_seqretry(&timekeeper.lock, seq));
+	} while (read_seqcount_retry(&timekeeper.rlock, seq));
 
 	set_normalized_timespec(&now, now.tv_sec + mono.tv_sec,
 				now.tv_nsec + mono.tv_nsec);
@@ -1276,11 +1299,11 @@ void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&timekeeper.lock);
+		seq = read_seqcount_begin(&timekeeper.rlock);
 		*xtim = timekeeper_xtime(&timekeeper);
 		*wtom = timekeeper.wall_to_monotonic;
 		*sleep = timekeeper.total_sleep_time;
-	} while (read_seqretry(&timekeeper.lock, seq));
+	} while (read_seqcount_retry(&timekeeper.rlock, seq));
 }
 
 /**
@@ -1292,9 +1315,9 @@ ktime_t ktime_get_monotonic_offset(void)
 	struct timespec wtom;
 
 	do {
-		seq = read_seqbegin(&timekeeper.lock);
+		seq = read_seqcount_begin(&timekeeper.rlock);
 		wtom = timekeeper.wall_to_monotonic;
-	} while (read_seqretry(&timekeeper.lock, seq));
+	} while (read_seqcount_retry(&timekeeper.rlock, seq));
 
 	return timespec_to_ktime(wtom);
 }
-- 
1.7.3.2.146.gca209

