Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965332Ab2CBHNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 02:13:33 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:46806 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964867Ab2CBHNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 02:13:30 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 3/9] time: Split timekeeper lock into separate reader/writer locks
Date: Thu,  1 Mar 2012 23:12:42 -0800
Message-Id: <1330672368-32290-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1330672368-32290-1-git-send-email-john.stultz@linaro.org>
References: <1330672368-32290-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030207-3352-0000-0000-0000030CF66C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to reduce the lock hold time, split the timekeeper lock
into a writer lock, which serializes updates to the timekeeper
structure, and a reader sequence counter, which ensures readers
see a consistent version of the timekeeper.

This will allow us to reduce the lock wait time for readers, by
doing updates on a shadow copy of the timekeeper.

This patch also has been reworked to move the split locks out
of the timekeeper structure, so that we don't break lockdep
when updating from the shadow copy

CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |  116 +++++++++++++++++++++++++++-----------------
 1 files changed, 71 insertions(+), 45 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 74568ca..f9ee96c 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -71,12 +71,16 @@ struct timekeeper {
 	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
 	struct timespec raw_time;
 
-	/* Seqlock for all timekeeper values */
-	seqlock_t lock;
 };
 
 static struct timekeeper timekeeper;
 
+/* Locks for timekeeper variable: */
+/* This seqcount serializes readers from updates */
+static seqcount_t timekeeper_rlock;
+/* This spinlock serializes updaters */
+static spinlock_t timekeeper_wlock;
+
 /*
  * This read-write spinlock protects us from races in SMP while
  * playing with xtime.
@@ -212,7 +216,7 @@ static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
 	return clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
 }
 
-/* must hold write on timekeeper.lock */
+/* must hold write on timekeeper_wlock */
 static void timekeeping_update(struct timekeeper *tk, bool clearntp)
 {
 	struct timespec xt;
@@ -229,11 +233,13 @@ void timekeeping_leap_insert(int leapsecond)
 {
 	unsigned long flags;
 
-	write_seqlock_irqsave(&timekeeper.lock, flags);
+	spin_lock_irqsave(&timekeeper_wlock, flags);
+	write_seqcount_begin(&timekeeper_rlock);
 	timekeeper.xtime_sec += leapsecond;
 	timekeeper.wall_to_monotonic.tv_sec -= leapsecond;
 	timekeeping_update(&timekeeper, false);
-	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+	write_seqcount_end(&timekeeper_rlock);
+	spin_unlock_irqrestore(&timekeeper_wlock, flags);
 
 }
 
@@ -280,7 +286,7 @@ void getnstimeofday(struct timespec *ts)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&timekeeper.lock);
+		seq = read_seqcount_begin(&timekeeper_rlock);
 
 		ts->tv_sec = timekeeper.xtime_sec;
 		ts->tv_nsec = timekeeping_get_ns(&timekeeper);
@@ -288,7 +294,7 @@ void getnstimeofday(struct timespec *ts)
 		/* If arch requires, add in gettimeoffset() */
 		nsecs += arch_gettimeoffset();
 
-	} while (read_seqretry(&timekeeper.lock, seq));
+	} while (read_seqcount_retry(&timekeeper_rlock, seq));
 
 	timespec_add_ns(ts, nsecs);
 }
@@ -303,7 +309,7 @@ ktime_t ktime_get(void)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&timekeeper.lock);
+		seq = read_seqcount_begin(&timekeeper_rlock);
 		secs = timekeeper.xtime_sec +
 				timekeeper.wall_to_monotonic.tv_sec;
 		nsecs = timekeeping_get_ns(&timekeeper) +
@@ -311,7 +317,7 @@ ktime_t ktime_get(void)
 		/* If arch requires, add in gettimeoffset() */
 		nsecs += arch_gettimeoffset();
 
-	} while (read_seqretry(&timekeeper.lock, seq));
+	} while (read_seqcount_retry(&timekeeper_rlock, seq));
 	/*
 	 * Use ktime_set/ktime_add_ns to create a proper ktime on
 	 * 32-bit architectures without CONFIG_KTIME_SCALAR.
@@ -336,14 +342,14 @@ void ktime_get_ts(struct timespec *ts)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&timekeeper.lock);
+		seq = read_seqcount_begin(&timekeeper_rlock);
 		ts->tv_sec = timekeeper.xtime_sec;
 		ts->tv_nsec = timekeeping_get_ns(&timekeeper);
 		tomono = timekeeper.wall_to_monotonic;
 		/* If arch requires, add in gettimeoffset() */
 		ts->tv_nsec += arch_gettimeoffset();
 
-	} while (read_seqretry(&timekeeper.lock, seq));
+	} while (read_seqcount_retry(&timekeeper_rlock, seq));
 
 	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec,
 				ts->tv_nsec + tomono.tv_nsec);
@@ -371,7 +377,7 @@ void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 	do {
 		u32 arch_offset;
 
-		seq = read_seqbegin(&timekeeper.lock);
+		seq = read_seqcount_begin(&timekeeper_rlock);
 
 		*ts_raw = timekeeper.raw_time;
 		ts_real->tv_sec = timekeeper.xtime_sec;
@@ -385,7 +391,7 @@ void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 		nsecs_raw += arch_offset;
 		nsecs_real += arch_offset;
 
-	} while (read_seqretry(&timekeeper.lock, seq));
+	} while (read_seqcount_retry(&timekeeper_rlock, seq));
 
 	timespec_add_ns(ts_raw, nsecs_raw);
 	timespec_add_ns(ts_real, nsecs_real);
@@ -424,7 +430,8 @@ int do_settimeofday(const struct timespec *tv)
 	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
-	write_seqlock_irqsave(&timekeeper.lock, flags);
+	spin_lock_irqsave(&timekeeper_wlock, flags);
+	write_seqcount_begin(&timekeeper_rlock);
 
 	timekeeping_forward_now(&timekeeper);
 
@@ -439,7 +446,8 @@ int do_settimeofday(const struct timespec *tv)
 
 	timekeeping_update(&timekeeper, true);
 
-	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+	write_seqcount_end(&timekeeper_rlock);
+	spin_unlock_irqrestore(&timekeeper_wlock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -463,7 +471,8 @@ int timekeeping_inject_offset(struct timespec *ts)
 	if ((unsigned long)ts->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
-	write_seqlock_irqsave(&timekeeper.lock, flags);
+	spin_lock_irqsave(&timekeeper_wlock, flags);
+	write_seqcount_begin(&timekeeper_rlock);
 
 	timekeeping_forward_now(&timekeeper);
 
@@ -474,7 +483,8 @@ int timekeeping_inject_offset(struct timespec *ts)
 
 	timekeeping_update(&timekeeper, true);
 
-	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+	write_seqcount_end(&timekeeper_rlock);
+	spin_unlock_irqrestore(&timekeeper_wlock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -546,11 +556,11 @@ void getrawmonotonic(struct timespec *ts)
 	s64 nsecs;
 
 	do {
-		seq = read_seqbegin(&timekeeper.lock);
+		seq = read_seqcount_begin(&timekeeper_rlock);
 		nsecs = timekeeping_get_ns_raw(&timekeeper);
 		*ts = timekeeper.raw_time;
 
-	} while (read_seqretry(&timekeeper.lock, seq));
+	} while (read_seqcount_retry(&timekeeper_rlock, seq));
 
 	timespec_add_ns(ts, nsecs);
 }
@@ -566,11 +576,11 @@ int timekeeping_valid_for_hres(void)
 	int ret;
 
 	do {
-		seq = read_seqbegin(&timekeeper.lock);
+		seq = read_seqcount_begin(&timekeeper_rlock);
 
 		ret = timekeeper.clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
 
-	} while (read_seqretry(&timekeeper.lock, seq));
+	} while (read_seqcount_retry(&timekeeper_rlock, seq));
 
 	return ret;
 }
@@ -583,11 +593,11 @@ u64 timekeeping_max_deferment(void)
 	unsigned long seq;
 	u64 ret;
 	do {
-		seq = read_seqbegin(&timekeeper.lock);
+		seq = read_seqcount_begin(&timekeeper_rlock);
 
 		ret = timekeeper.clock->max_idle_ns;
 
-	} while (read_seqretry(&timekeeper.lock, seq));
+	} while (read_seqcount_retry(&timekeeper_rlock, seq));
 
 	return ret;
 }
@@ -634,11 +644,13 @@ void __init timekeeping_init(void)
 	read_persistent_clock(&now);
 	read_boot_clock(&boot);
 
-	seqlock_init(&timekeeper.lock);
-
+	seqcount_init(&timekeeper_rlock);
+	spin_lock_init(&timekeeper_wlock);
 	ntp_init();
 
-	write_seqlock_irqsave(&timekeeper.lock, flags);
+	spin_lock_irqsave(&timekeeper_wlock, flags);
+	write_seqcount_begin(&timekeeper_rlock);
+
 	clock = clocksource_default_clock();
 	if (clock->enable)
 		clock->enable(clock);
@@ -654,7 +666,10 @@ void __init timekeeping_init(void)
 				-boot.tv_sec, -boot.tv_nsec);
 	timekeeper.total_sleep_time.tv_sec = 0;
 	timekeeper.total_sleep_time.tv_nsec = 0;
-	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+
+	write_seqcount_end(&timekeeper_rlock);
+	spin_unlock_irqrestore(&timekeeper_wlock, flags);
+
 }
 
 /* time in seconds when suspend began */
@@ -703,7 +718,8 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 	if (!(ts.tv_sec == 0 && ts.tv_nsec == 0))
 		return;
 
-	write_seqlock_irqsave(&timekeeper.lock, flags);
+	spin_lock_irqsave(&timekeeper_wlock, flags);
+	write_seqcount_begin(&timekeeper_rlock);
 
 	timekeeping_forward_now(&timekeeper);
 
@@ -711,7 +727,8 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 
 	timekeeping_update(&timekeeper, true);
 
-	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+	write_seqcount_end(&timekeeper_rlock);
+	spin_unlock_irqrestore(&timekeeper_wlock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -734,7 +751,8 @@ static void timekeeping_resume(void)
 
 	clocksource_resume();
 
-	write_seqlock_irqsave(&timekeeper.lock, flags);
+	spin_lock_irqsave(&timekeeper_wlock, flags);
+	write_seqcount_begin(&timekeeper_rlock);
 
 	if (timespec_compare(&ts, &timekeeping_suspend_time) > 0) {
 		ts = timespec_sub(ts, timekeeping_suspend_time);
@@ -744,7 +762,9 @@ static void timekeeping_resume(void)
 	timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
 	timekeeper.ntp_error = 0;
 	timekeeping_suspended = 0;
-	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+
+	write_seqcount_end(&timekeeper_rlock);
+	spin_unlock_irqrestore(&timekeeper_wlock, flags);
 
 	touch_softlockup_watchdog();
 
@@ -762,7 +782,9 @@ static int timekeeping_suspend(void)
 
 	read_persistent_clock(&timekeeping_suspend_time);
 
-	write_seqlock_irqsave(&timekeeper.lock, flags);
+	spin_lock_irqsave(&timekeeper_wlock, flags);
+	write_seqcount_begin(&timekeeper_rlock);
+
 	timekeeping_forward_now(&timekeeper);
 	timekeeping_suspended = 1;
 
@@ -785,7 +807,9 @@ static int timekeeping_suspend(void)
 		timekeeping_suspend_time =
 			timespec_add(timekeeping_suspend_time, delta_delta);
 	}
-	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+
+	write_seqcount_end(&timekeeper_rlock);
+	spin_unlock_irqrestore(&timekeeper_wlock, flags);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
 	clocksource_suspend();
@@ -1041,7 +1065,8 @@ static void update_wall_time(void)
 	unsigned long flags;
 	s64 remainder;
 
-	write_seqlock_irqsave(&timekeeper.lock, flags);
+	spin_lock_irqsave(&timekeeper_wlock, flags);
+	write_seqcount_begin(&timekeeper_rlock);
 
 	/* Make sure we're fully resumed: */
 	if (unlikely(timekeeping_suspended))
@@ -1128,7 +1153,8 @@ static void update_wall_time(void)
 	timekeeping_update(&timekeeper, false);
 
 out:
-	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+	write_seqcount_end(&timekeeper_rlock);
+	spin_unlock_irqrestore(&timekeeper_wlock, flags);
 
 }
 
@@ -1174,13 +1200,13 @@ void get_monotonic_boottime(struct timespec *ts)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&timekeeper.lock);
+		seq = read_seqcount_begin(&timekeeper_rlock);
 		ts->tv_sec = timekeeper.xtime_sec;
 		ts->tv_nsec = timekeeping_get_ns(&timekeeper);
 		tomono = timekeeper.wall_to_monotonic;
 		sleep = timekeeper.total_sleep_time;
 
-	} while (read_seqretry(&timekeeper.lock, seq));
+	} while (read_seqcount_retry(&timekeeper_rlock, seq));
 
 	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec + sleep.tv_sec,
 			ts->tv_nsec + tomono.tv_nsec + sleep.tv_nsec);
@@ -1231,10 +1257,10 @@ struct timespec current_kernel_time(void)
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&timekeeper.lock);
+		seq = read_seqcount_begin(&timekeeper_rlock);
 
 		now = tk_xtime(&timekeeper);
-	} while (read_seqretry(&timekeeper.lock, seq));
+	} while (read_seqcount_retry(&timekeeper_rlock, seq));
 
 	return now;
 }
@@ -1246,11 +1272,11 @@ struct timespec get_monotonic_coarse(void)
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&timekeeper.lock);
+		seq = read_seqcount_begin(&timekeeper_rlock);
 
 		now = tk_xtime(&timekeeper);
 		mono = timekeeper.wall_to_monotonic;
-	} while (read_seqretry(&timekeeper.lock, seq));
+	} while (read_seqcount_retry(&timekeeper_rlock, seq));
 
 	set_normalized_timespec(&now, now.tv_sec + mono.tv_sec,
 				now.tv_nsec + mono.tv_nsec);
@@ -1282,11 +1308,11 @@ void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&timekeeper.lock);
+		seq = read_seqcount_begin(&timekeeper_rlock);
 		*xtim = tk_xtime(&timekeeper);
 		*wtom = timekeeper.wall_to_monotonic;
 		*sleep = timekeeper.total_sleep_time;
-	} while (read_seqretry(&timekeeper.lock, seq));
+	} while (read_seqcount_retry(&timekeeper_rlock, seq));
 }
 
 /**
@@ -1298,9 +1324,9 @@ ktime_t ktime_get_monotonic_offset(void)
 	struct timespec wtom;
 
 	do {
-		seq = read_seqbegin(&timekeeper.lock);
+		seq = read_seqcount_begin(&timekeeper_rlock);
 		wtom = timekeeper.wall_to_monotonic;
-	} while (read_seqretry(&timekeeper.lock, seq));
+	} while (read_seqcount_retry(&timekeeper_rlock, seq));
 
 	return timespec_to_ktime(wtom);
 }
-- 
1.7.3.2.146.gca209

