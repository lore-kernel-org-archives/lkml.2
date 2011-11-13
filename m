Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab1KMXV1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 18:21:27 -0500
Received: from www.linutronix.de ([62.245.132.108]:45127 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab1KMXTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 18:19:48 -0500
Message-Id: <20111113231341.458893511@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 13 Nov 2011 23:19:47 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [patch 1/7] timekeeping: Split xtime lock into lock and seqcount
References: <20111113230921.728083714@linutronix.de>
Content-Disposition: inline; filename=xtime-split-lock-and-seqcount.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to shorten the sequence sections to the small sections
which actually update the timekeeping data structures, so the reader
blocked section becomes minimal.

Scripted conversion. No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/jiffies.c       |    4 -
 kernel/time/ntp.c           |   24 +++++++----
 kernel/time/tick-common.c   |   10 ++--
 kernel/time/tick-internal.h |    3 -
 kernel/time/tick-sched.c    |   16 ++++---
 kernel/time/timekeeping.c   |   95 +++++++++++++++++++++++++-------------------
 6 files changed, 91 insertions(+), 61 deletions(-)

Index: linux-2.6/kernel/time/jiffies.c
===================================================================
--- linux-2.6.orig/kernel/time/jiffies.c
+++ linux-2.6/kernel/time/jiffies.c
@@ -74,9 +74,9 @@ u64 get_jiffies_64(void)
 	u64 ret;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqcount_begin(&xtime_seq);
 		ret = jiffies_64;
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
 	return ret;
 }
 EXPORT_SYMBOL(get_jiffies_64);
Index: linux-2.6/kernel/time/ntp.c
===================================================================
--- linux-2.6.orig/kernel/time/ntp.c
+++ linux-2.6/kernel/time/ntp.c
@@ -358,7 +358,8 @@ static enum hrtimer_restart ntp_leap_sec
 {
 	enum hrtimer_restart res = HRTIMER_NORESTART;
 
-	write_seqlock(&xtime_lock);
+	raw_spin_lock(&xtime_lock);
+	write_seqcount_begin(&xtime_seq);
 
 	switch (time_state) {
 	case TIME_OK:
@@ -388,7 +389,8 @@ static enum hrtimer_restart ntp_leap_sec
 		break;
 	}
 
-	write_sequnlock(&xtime_lock);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock(&xtime_lock);
 
 	return res;
 }
@@ -663,7 +665,8 @@ int do_adjtimex(struct timex *txc)
 
 	getnstimeofday(&ts);
 
-	write_seqlock_irq(&xtime_lock);
+	raw_spin_lock_irq(&xtime_lock);
+	write_seqcount_begin(&xtime_seq);
 
 	if (txc->modes & ADJ_ADJTIME) {
 		long save_adjust = time_adjust;
@@ -705,7 +708,8 @@ int do_adjtimex(struct timex *txc)
 	/* fill PPS status fields */
 	pps_fill_timex(txc);
 
-	write_sequnlock_irq(&xtime_lock);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock_irq(&xtime_lock);
 
 	txc->time.tv_sec = ts.tv_sec;
 	txc->time.tv_usec = ts.tv_nsec;
@@ -903,7 +907,8 @@ void hardpps(const struct timespec *phas
 
 	pts_norm = pps_normalize_ts(*phase_ts);
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	raw_spin_lock_irqsave(&xtime_lock, flags);
+	write_seqcount_begin(&xtime_seq);
 
 	/* clear the error bits, they will be set again if needed */
 	time_status &= ~(STA_PPSJITTER | STA_PPSWANDER | STA_PPSERROR);
@@ -916,7 +921,8 @@ void hardpps(const struct timespec *phas
 	 * just start the frequency interval */
 	if (unlikely(pps_fbase.tv_sec == 0)) {
 		pps_fbase = *raw_ts;
-		write_sequnlock_irqrestore(&xtime_lock, flags);
+		write_seqcount_end(&xtime_seq);
+		raw_spin_unlock_irqrestore(&xtime_lock, flags);
 		return;
 	}
 
@@ -931,7 +937,8 @@ void hardpps(const struct timespec *phas
 		time_status |= STA_PPSJITTER;
 		/* restart the frequency calibration interval */
 		pps_fbase = *raw_ts;
-		write_sequnlock_irqrestore(&xtime_lock, flags);
+		write_seqcount_end(&xtime_seq);
+		raw_spin_unlock_irqrestore(&xtime_lock, flags);
 		pr_err("hardpps: PPSJITTER: bad pulse\n");
 		return;
 	}
@@ -948,7 +955,8 @@ void hardpps(const struct timespec *phas
 
 	hardpps_update_phase(pts_norm.nsec);
 
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock_irqrestore(&xtime_lock, flags);
 }
 EXPORT_SYMBOL(hardpps);
 
Index: linux-2.6/kernel/time/tick-common.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-common.c
+++ linux-2.6/kernel/time/tick-common.c
@@ -63,13 +63,15 @@ int tick_is_oneshot_available(void)
 static void tick_periodic(int cpu)
 {
 	if (tick_do_timer_cpu == cpu) {
-		write_seqlock(&xtime_lock);
+		raw_spin_lock(&xtime_lock);
+		write_seqcount_begin(&xtime_seq);
 
 		/* Keep track of the next tick event */
 		tick_next_period = ktime_add(tick_next_period, tick_period);
 
 		do_timer(1);
-		write_sequnlock(&xtime_lock);
+		write_seqcount_end(&xtime_seq);
+		raw_spin_unlock(&xtime_lock);
 	}
 
 	update_process_times(user_mode(get_irq_regs()));
@@ -130,9 +132,9 @@ void tick_setup_periodic(struct clock_ev
 		ktime_t next;
 
 		do {
-			seq = read_seqbegin(&xtime_lock);
+			seq = read_seqcount_begin(&xtime_seq);
 			next = tick_next_period;
-		} while (read_seqretry(&xtime_lock, seq));
+		} while (read_seqcount_retry(&xtime_seq, seq));
 
 		clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
 
Index: linux-2.6/kernel/time/tick-internal.h
===================================================================
--- linux-2.6.orig/kernel/time/tick-internal.h
+++ linux-2.6/kernel/time/tick-internal.h
@@ -141,4 +141,5 @@ static inline int tick_device_is_functio
 #endif
 
 extern void do_timer(unsigned long ticks);
-extern seqlock_t xtime_lock;
+extern raw_spinlock_t xtime_lock;
+extern seqcount_t xtime_seq;
Index: linux-2.6/kernel/time/tick-sched.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-sched.c
+++ linux-2.6/kernel/time/tick-sched.c
@@ -56,7 +56,8 @@ static void tick_do_update_jiffies64(kti
 		return;
 
 	/* Reevalute with xtime_lock held */
-	write_seqlock(&xtime_lock);
+	raw_spin_lock(&xtime_lock);
+	write_seqcount_begin(&xtime_seq);
 
 	delta = ktime_sub(now, last_jiffies_update);
 	if (delta.tv64 >= tick_period.tv64) {
@@ -79,7 +80,8 @@ static void tick_do_update_jiffies64(kti
 		/* Keep the tick_next_period variable up to date */
 		tick_next_period = ktime_add(last_jiffies_update, tick_period);
 	}
-	write_sequnlock(&xtime_lock);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock(&xtime_lock);
 }
 
 /*
@@ -89,12 +91,14 @@ static ktime_t tick_init_jiffy_update(vo
 {
 	ktime_t period;
 
-	write_seqlock(&xtime_lock);
+	raw_spin_lock(&xtime_lock);
+	write_seqcount_begin(&xtime_seq);
 	/* Did we start the jiffies update yet ? */
 	if (last_jiffies_update.tv64 == 0)
 		last_jiffies_update = tick_next_period;
 	period = last_jiffies_update;
-	write_sequnlock(&xtime_lock);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock(&xtime_lock);
 	return period;
 }
 
@@ -345,11 +349,11 @@ void tick_nohz_stop_sched_tick(int inidl
 	ts->idle_calls++;
 	/* Read jiffies and the time when jiffies were updated last */
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqcount_begin(&xtime_seq);
 		last_update = last_jiffies_update;
 		last_jiffies = jiffies;
 		time_delta = timekeeping_max_deferment();
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
 
 	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
 	    arch_needs_cpu(cpu)) {
Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -136,10 +136,11 @@ static inline s64 timekeeping_get_ns_raw
 }
 
 /*
- * This read-write spinlock protects us from races in SMP while
- * playing with xtime.
+ * xtime_seq  allows lockless readers to observe updates
+ * xtime_lock protects the time keeping code
  */
-__cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
+__cacheline_aligned_in_smp seqcount_t xtime_seq;
+DEFINE_RAW_SPINLOCK(xtime_lock);
 
 
 /*
@@ -222,7 +223,7 @@ void getnstimeofday(struct timespec *ts)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqcount_begin(&xtime_seq);
 
 		*ts = xtime;
 		nsecs = timekeeping_get_ns();
@@ -230,7 +231,7 @@ void getnstimeofday(struct timespec *ts)
 		/* If arch requires, add in gettimeoffset() */
 		nsecs += arch_gettimeoffset();
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
 
 	timespec_add_ns(ts, nsecs);
 }
@@ -245,12 +246,12 @@ ktime_t ktime_get(void)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqcount_begin(&xtime_seq);
 		secs = xtime.tv_sec + wall_to_monotonic.tv_sec;
 		nsecs = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
 		nsecs += timekeeping_get_ns();
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
 	/*
 	 * Use ktime_set/ktime_add_ns to create a proper ktime on
 	 * 32-bit architectures without CONFIG_KTIME_SCALAR.
@@ -276,12 +277,12 @@ void ktime_get_ts(struct timespec *ts)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqcount_begin(&xtime_seq);
 		*ts = xtime;
 		tomono = wall_to_monotonic;
 		nsecs = timekeeping_get_ns();
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
 
 	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec,
 				ts->tv_nsec + tomono.tv_nsec + nsecs);
@@ -309,7 +310,7 @@ void getnstime_raw_and_real(struct times
 	do {
 		u32 arch_offset;
 
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqcount_begin(&xtime_seq);
 
 		*ts_raw = raw_time;
 		*ts_real = xtime;
@@ -322,7 +323,7 @@ void getnstime_raw_and_real(struct times
 		nsecs_raw += arch_offset;
 		nsecs_real += arch_offset;
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
 
 	timespec_add_ns(ts_raw, nsecs_raw);
 	timespec_add_ns(ts_real, nsecs_real);
@@ -361,7 +362,8 @@ int do_settimeofday(const struct timespe
 	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	raw_spin_lock_irqsave(&xtime_lock, flags);
+	write_seqcount_begin(&xtime_seq);
 
 	timekeeping_forward_now();
 
@@ -377,7 +379,8 @@ int do_settimeofday(const struct timespe
 	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
 				timekeeper.mult);
 
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock_irqrestore(&xtime_lock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -401,7 +404,8 @@ int timekeeping_inject_offset(struct tim
 	if ((unsigned long)ts->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	raw_spin_lock_irqsave(&xtime_lock, flags);
+	write_seqcount_begin(&xtime_seq);
 
 	timekeeping_forward_now();
 
@@ -414,7 +418,8 @@ int timekeeping_inject_offset(struct tim
 	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
 				timekeeper.mult);
 
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock_irqrestore(&xtime_lock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -486,11 +491,11 @@ void getrawmonotonic(struct timespec *ts
 	s64 nsecs;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqcount_begin(&xtime_seq);
 		nsecs = timekeeping_get_ns_raw();
 		*ts = raw_time;
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
 
 	timespec_add_ns(ts, nsecs);
 }
@@ -506,11 +511,11 @@ int timekeeping_valid_for_hres(void)
 	int ret;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqcount_begin(&xtime_seq);
 
 		ret = timekeeper.clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
 
 	return ret;
 }
@@ -518,7 +523,7 @@ int timekeeping_valid_for_hres(void)
 /**
  * timekeeping_max_deferment - Returns max time the clocksource can be deferred
  *
- * Caller must observe xtime_lock via read_seqbegin/read_seqretry to
+ * Caller must observe xtime_seq via read_seqcount_begin/req_seqcount_retry to
  * ensure that the clocksource does not change!
  */
 u64 timekeeping_max_deferment(void)
@@ -568,7 +573,8 @@ void __init timekeeping_init(void)
 	read_persistent_clock(&now);
 	read_boot_clock(&boot);
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	raw_spin_lock_irqsave(&xtime_lock, flags);
+	write_seqcount_begin(&xtime_seq);
 
 	ntp_init();
 
@@ -589,7 +595,8 @@ void __init timekeeping_init(void)
 				-boot.tv_sec, -boot.tv_nsec);
 	total_sleep_time.tv_sec = 0;
 	total_sleep_time.tv_nsec = 0;
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock_irqrestore(&xtime_lock, flags);
 }
 
 /* time in seconds when suspend began */
@@ -636,7 +643,8 @@ void timekeeping_inject_sleeptime(struct
 	if (!(ts.tv_sec == 0 && ts.tv_nsec == 0))
 		return;
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	raw_spin_lock_irqsave(&xtime_lock, flags);
+	write_seqcount_begin(&xtime_seq);
 	timekeeping_forward_now();
 
 	__timekeeping_inject_sleeptime(delta);
@@ -646,7 +654,8 @@ void timekeeping_inject_sleeptime(struct
 	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
 				timekeeper.mult);
 
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock_irqrestore(&xtime_lock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -669,7 +678,8 @@ static void timekeeping_resume(void)
 
 	clocksource_resume();
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	raw_spin_lock_irqsave(&xtime_lock, flags);
+	write_seqcount_begin(&xtime_seq);
 
 	if (timespec_compare(&ts, &timekeeping_suspend_time) > 0) {
 		ts = timespec_sub(ts, timekeeping_suspend_time);
@@ -679,7 +689,8 @@ static void timekeeping_resume(void)
 	timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
 	timekeeper.ntp_error = 0;
 	timekeeping_suspended = 0;
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock_irqrestore(&xtime_lock, flags);
 
 	touch_softlockup_watchdog();
 
@@ -697,7 +708,8 @@ static int timekeeping_suspend(void)
 
 	read_persistent_clock(&timekeeping_suspend_time);
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	raw_spin_lock_irqsave(&xtime_lock, flags);
+	write_seqcount_begin(&xtime_seq);
 	timekeeping_forward_now();
 	timekeeping_suspended = 1;
 
@@ -720,7 +732,8 @@ static int timekeeping_suspend(void)
 		timekeeping_suspend_time =
 			timespec_add(timekeeping_suspend_time, delta_delta);
 	}
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock_irqrestore(&xtime_lock, flags);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
 	clocksource_suspend();
@@ -1011,13 +1024,13 @@ void get_monotonic_boottime(struct times
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqcount_begin(&xtime_seq);
 		*ts = xtime;
 		tomono = wall_to_monotonic;
 		sleep = total_sleep_time;
 		nsecs = timekeeping_get_ns();
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
 
 	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec + sleep.tv_sec,
 			ts->tv_nsec + tomono.tv_nsec + sleep.tv_nsec + nsecs);
@@ -1068,10 +1081,10 @@ struct timespec current_kernel_time(void
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqcount_begin(&xtime_seq);
 
 		now = xtime;
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
 
 	return now;
 }
@@ -1083,11 +1096,11 @@ struct timespec get_monotonic_coarse(voi
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqcount_begin(&xtime_seq);
 
 		now = xtime;
 		mono = wall_to_monotonic;
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
 
 	set_normalized_timespec(&now, now.tv_sec + mono.tv_sec,
 				now.tv_nsec + mono.tv_nsec);
@@ -1119,11 +1132,11 @@ void get_xtime_and_monotonic_and_sleep_o
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqcount_begin(&xtime_seq);
 		*xtim = xtime;
 		*wtom = wall_to_monotonic;
 		*sleep = total_sleep_time;
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
 }
 
 /**
@@ -1135,9 +1148,9 @@ ktime_t ktime_get_monotonic_offset(void)
 	struct timespec wtom;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqcount_begin(&xtime_seq);
 		wtom = wall_to_monotonic;
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
 	return timespec_to_ktime(wtom);
 }
 
@@ -1149,7 +1162,9 @@ ktime_t ktime_get_monotonic_offset(void)
  */
 void xtime_update(unsigned long ticks)
 {
-	write_seqlock(&xtime_lock);
+	raw_spin_lock(&xtime_lock);
+	write_seqcount_begin(&xtime_seq);
 	do_timer(ticks);
-	write_sequnlock(&xtime_lock);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock(&xtime_lock);
 }


