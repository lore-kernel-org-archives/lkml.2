Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab2CFQVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:21:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20400 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab2CFQTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:19:54 -0500
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=zPvmZijt5ZIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=K3oCeB7wdPGJZoTpy5gA:9 a=crtL2PAs5UzddyhCsG8A:7 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=WNbrPvvvTLj88_dF:21 a=0LJthlg06ZcWZ_It:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120306161950.104624977@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 06 Mar 2012 11:16:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, stable-rt@vger.kernel.org
Subject: [PATCH RT 15/25][RFC 3.0.23-rt39-rc1] timekeeping: Split xtime_lock
References: <20120306161636.491172179@goodmis.org>
Content-Disposition: inline; filename=0015-timekeeping-Split-xtime_lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

xtime_lock is going to be split apart in mainline, so we can shorten
the seqcount protected regions and avoid updating seqcount in some
code pathes. This is a straight forward split, so we can avoid the
whole mess with raw seqlocks for RT.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/time/jiffies.c       |    4 +-
 kernel/time/ntp.c           |   24 ++++++++----
 kernel/time/tick-common.c   |   10 +++--
 kernel/time/tick-internal.h |    3 +-
 kernel/time/tick-sched.c    |   16 +++++---
 kernel/time/timekeeping.c   |   90 +++++++++++++++++++++++++------------------
 6 files changed, 88 insertions(+), 59 deletions(-)

diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index a470154..21940eb 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
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
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index f6117a4..c465e88 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -358,7 +358,8 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 {
 	enum hrtimer_restart res = HRTIMER_NORESTART;
 
-	write_seqlock(&xtime_lock);
+	raw_spin_lock(&xtime_lock);
+	write_seqcount_begin(&xtime_seq);
 
 	switch (time_state) {
 	case TIME_OK:
@@ -388,7 +389,8 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
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
@@ -903,7 +907,8 @@ void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 
 	pts_norm = pps_normalize_ts(*phase_ts);
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	raw_spin_lock_irqsave(&xtime_lock, flags);
+	write_seqcount_begin(&xtime_seq);
 
 	/* clear the error bits, they will be set again if needed */
 	time_status &= ~(STA_PPSJITTER | STA_PPSWANDER | STA_PPSERROR);
@@ -916,7 +921,8 @@ void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 	 * just start the frequency interval */
 	if (unlikely(pps_fbase.tv_sec == 0)) {
 		pps_fbase = *raw_ts;
-		write_sequnlock_irqrestore(&xtime_lock, flags);
+		write_seqcount_end(&xtime_seq);
+		raw_spin_unlock_irqrestore(&xtime_lock, flags);
 		return;
 	}
 
@@ -931,7 +937,8 @@ void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 		time_status |= STA_PPSJITTER;
 		/* restart the frequency calibration interval */
 		pps_fbase = *raw_ts;
-		write_sequnlock_irqrestore(&xtime_lock, flags);
+		write_seqcount_end(&xtime_seq);
+		raw_spin_unlock_irqrestore(&xtime_lock, flags);
 		pr_err("hardpps: PPSJITTER: bad pulse\n");
 		return;
 	}
@@ -948,7 +955,8 @@ void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 
 	hardpps_update_phase(pts_norm.nsec);
 
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock_irqrestore(&xtime_lock, flags);
 }
 EXPORT_SYMBOL(hardpps);
 
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 119528d..25fb6ad 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
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
@@ -130,9 +132,9 @@ void tick_setup_periodic(struct clock_event_device *dev, int broadcast)
 		ktime_t next;
 
 		do {
-			seq = read_seqbegin(&xtime_lock);
+			seq = read_seqcount_begin(&xtime_seq);
 			next = tick_next_period;
-		} while (read_seqretry(&xtime_lock, seq));
+		} while (read_seqcount_retry(&xtime_seq, seq));
 
 		clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
 
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 1009b06..116e861 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -143,4 +143,5 @@ static inline int tick_device_is_functional(struct clock_event_device *dev)
 #endif
 
 extern void do_timer(unsigned long ticks);
-extern seqlock_t xtime_lock;
+extern raw_spinlock_t xtime_lock;
+extern seqcount_t xtime_seq;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 2a6e13c..5f620b0 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -56,7 +56,8 @@ static void tick_do_update_jiffies64(ktime_t now)
 		return;
 
 	/* Reevalute with xtime_lock held */
-	write_seqlock(&xtime_lock);
+	raw_spin_lock(&xtime_lock);
+	write_seqcount_begin(&xtime_seq);
 
 	delta = ktime_sub(now, last_jiffies_update);
 	if (delta.tv64 >= tick_period.tv64) {
@@ -79,7 +80,8 @@ static void tick_do_update_jiffies64(ktime_t now)
 		/* Keep the tick_next_period variable up to date */
 		tick_next_period = ktime_add(last_jiffies_update, tick_period);
 	}
-	write_sequnlock(&xtime_lock);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock(&xtime_lock);
 }
 
 /*
@@ -89,12 +91,14 @@ static ktime_t tick_init_jiffy_update(void)
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
 
@@ -311,11 +315,11 @@ void tick_nohz_stop_sched_tick(int inidle)
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
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 5f45831..6ac6438 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -139,8 +139,8 @@ static inline s64 timekeeping_get_ns_raw(void)
  * This read-write spinlock protects us from races in SMP while
  * playing with xtime.
  */
-__cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
-
+__cacheline_aligned_in_smp DEFINE_RAW_SPINLOCK(xtime_lock);
+seqcount_t xtime_seq;
 
 /*
  * The current time
@@ -222,7 +222,7 @@ void getnstimeofday(struct timespec *ts)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqcount_begin(&xtime_seq);
 
 		*ts = xtime;
 		nsecs = timekeeping_get_ns();
@@ -230,7 +230,7 @@ void getnstimeofday(struct timespec *ts)
 		/* If arch requires, add in gettimeoffset() */
 		nsecs += arch_gettimeoffset();
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
 
 	timespec_add_ns(ts, nsecs);
 }
@@ -245,14 +245,14 @@ ktime_t ktime_get(void)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqcount_begin(&xtime_seq);
 		secs = xtime.tv_sec + wall_to_monotonic.tv_sec;
 		nsecs = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
 		nsecs += timekeeping_get_ns();
 		/* If arch requires, add in gettimeoffset() */
 		nsecs += arch_gettimeoffset();
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
 	/*
 	 * Use ktime_set/ktime_add_ns to create a proper ktime on
 	 * 32-bit architectures without CONFIG_KTIME_SCALAR.
@@ -278,14 +278,14 @@ void ktime_get_ts(struct timespec *ts)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqcount_begin(&xtime_seq);
 		*ts = xtime;
 		tomono = wall_to_monotonic;
 		nsecs = timekeeping_get_ns();
 		/* If arch requires, add in gettimeoffset() */
 		nsecs += arch_gettimeoffset();
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
 
 	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec,
 				ts->tv_nsec + tomono.tv_nsec + nsecs);
@@ -313,7 +313,7 @@ void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 	do {
 		u32 arch_offset;
 
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqcount_begin(&xtime_seq);
 
 		*ts_raw = raw_time;
 		*ts_real = xtime;
@@ -326,7 +326,7 @@ void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 		nsecs_raw += arch_offset;
 		nsecs_real += arch_offset;
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
 
 	timespec_add_ns(ts_raw, nsecs_raw);
 	timespec_add_ns(ts_real, nsecs_real);
@@ -365,7 +365,8 @@ int do_settimeofday(const struct timespec *tv)
 	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	raw_spin_lock_irqsave(&xtime_lock, flags);
+	write_seqcount_begin(&xtime_seq);
 
 	timekeeping_forward_now();
 
@@ -381,7 +382,8 @@ int do_settimeofday(const struct timespec *tv)
 	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
 				timekeeper.mult);
 
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock_irqrestore(&xtime_lock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -405,7 +407,8 @@ int timekeeping_inject_offset(struct timespec *ts)
 	if ((unsigned long)ts->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	raw_spin_lock_irqsave(&xtime_lock, flags);
+	write_seqcount_begin(&xtime_seq);
 
 	timekeeping_forward_now();
 
@@ -418,7 +421,8 @@ int timekeeping_inject_offset(struct timespec *ts)
 	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
 				timekeeper.mult);
 
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock_irqrestore(&xtime_lock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -490,11 +494,11 @@ void getrawmonotonic(struct timespec *ts)
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
@@ -510,11 +514,11 @@ int timekeeping_valid_for_hres(void)
 	int ret;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqcount_begin(&xtime_seq);
 
 		ret = timekeeper.clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
 
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
 
 	return ret;
 }
@@ -572,7 +576,8 @@ void __init timekeeping_init(void)
 	read_persistent_clock(&now);
 	read_boot_clock(&boot);
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	raw_spin_lock_irqsave(&xtime_lock, flags);
+	write_seqcount_begin(&xtime_seq);
 
 	ntp_init();
 
@@ -593,7 +598,8 @@ void __init timekeeping_init(void)
 				-boot.tv_sec, -boot.tv_nsec);
 	total_sleep_time.tv_sec = 0;
 	total_sleep_time.tv_nsec = 0;
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock_irqrestore(&xtime_lock, flags);
 }
 
 /* time in seconds when suspend began */
@@ -634,7 +640,8 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 	if (!(ts.tv_sec == 0 && ts.tv_nsec == 0))
 		return;
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	raw_spin_lock_irqsave(&xtime_lock, flags);
+	write_seqcount_begin(&xtime_seq);
 	timekeeping_forward_now();
 
 	__timekeeping_inject_sleeptime(delta);
@@ -644,7 +651,8 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
 				timekeeper.mult);
 
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock_irqrestore(&xtime_lock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -667,7 +675,8 @@ static void timekeeping_resume(void)
 
 	clocksource_resume();
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	raw_spin_lock_irqsave(&xtime_lock, flags);
+	write_seqcount_begin(&xtime_seq);
 
 	if (timespec_compare(&ts, &timekeeping_suspend_time) > 0) {
 		ts = timespec_sub(ts, timekeeping_suspend_time);
@@ -677,7 +686,8 @@ static void timekeeping_resume(void)
 	timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
 	timekeeper.ntp_error = 0;
 	timekeeping_suspended = 0;
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock_irqrestore(&xtime_lock, flags);
 
 	touch_softlockup_watchdog();
 
@@ -693,10 +703,12 @@ static int timekeeping_suspend(void)
 
 	read_persistent_clock(&timekeeping_suspend_time);
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	raw_spin_lock_irqsave(&xtime_lock, flags);
+	write_seqcount_begin(&xtime_seq);
 	timekeeping_forward_now();
 	timekeeping_suspended = 1;
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_seqcount_end(&xtime_seq);
+	raw_spin_unlock_irqrestore(&xtime_lock, flags);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
 	clocksource_suspend();
@@ -987,13 +999,13 @@ void get_monotonic_boottime(struct timespec *ts)
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
@@ -1044,10 +1056,10 @@ struct timespec current_kernel_time(void)
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqcount_begin(&xtime_seq);
 
 		now = xtime;
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
 
 	return now;
 }
@@ -1059,11 +1071,11 @@ struct timespec get_monotonic_coarse(void)
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
@@ -1095,11 +1107,11 @@ void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
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
@@ -1111,9 +1123,9 @@ ktime_t ktime_get_monotonic_offset(void)
 	struct timespec wtom;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqcount_begin(&xtime_seq);
 		wtom = wall_to_monotonic;
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqcount_retry(&xtime_seq, seq));
 	return timespec_to_ktime(wtom);
 }
 
@@ -1125,7 +1137,9 @@ ktime_t ktime_get_monotonic_offset(void)
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
-- 
1.7.8.3


