Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab2GOI61 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 04:58:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53410 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab2GOI6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 04:58:18 -0400
Date: Sun, 15 Jul 2012 01:57:55 -0700
From: tip-bot for John Stultz <john.stultz@linaro.org>
Message-ID: <tip-1e75fa8be9fb61e1af46b5b3b176347a4c958ca1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, prarit@redhat.com
Reply-To: john.stultz@linaro.org, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        richardcochran@gmail.com, tglx@linutronix.de, prarit@redhat.com
In-Reply-To: <1342156917-25092-5-git-send-email-john.stultz@linaro.org>
References: <1342156917-25092-5-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] time: Condense timekeeper.xtime into xtime_sec
Git-Commit-ID: 1e75fa8be9fb61e1af46b5b3b176347a4c958ca1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 15 Jul 2012 01:58:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1e75fa8be9fb61e1af46b5b3b176347a4c958ca1
Gitweb:     http://git.kernel.org/tip/1e75fa8be9fb61e1af46b5b3b176347a4c958ca1
Author:     John Stultz <john.stultz@linaro.org>
AuthorDate: Fri, 13 Jul 2012 01:21:53 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 15 Jul 2012 10:39:06 +0200

time: Condense timekeeper.xtime into xtime_sec

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

Signed-off-by: John Stultz <john.stultz@linaro.org>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1342156917-25092-5-git-send-email-john.stultz@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c |  181 +++++++++++++++++++++++++++------------------
 1 files changed, 110 insertions(+), 71 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 4fd83df..b98d9bd 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -38,8 +38,11 @@ struct timekeeper {
 	/* Raw nano seconds accumulated per NTP interval. */
 	u32			raw_interval;
 
-	/* Clock shifted nano seconds remainder not stored in xtime.tv_nsec. */
+	/* Current CLOCK_REALTIME time in seconds */
+	u64			xtime_sec;
+	/* Clock shifted nano seconds */
 	u64			xtime_nsec;
+
 	/* Difference between accumulated time and NTP time in ntp
 	 * shifted nano seconds. */
 	s64			ntp_error;
@@ -47,8 +50,6 @@ struct timekeeper {
 	 * ntp shifted nano seconds. */
 	u32			ntp_error_shift;
 
-	/* The current time */
-	struct timespec 	xtime;
 	/*
 	 * wall_to_monotonic is what we need to add to xtime (or xtime corrected
 	 * for sub jiffie times) to get to monotonic time.  Monotonic is pegged
@@ -84,11 +85,37 @@ static struct timekeeper timekeeper;
  */
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
 
-
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
 
+static inline void tk_normalize_xtime(struct timekeeper *tk)
+{
+	while (tk->xtime_nsec >= ((u64)NSEC_PER_SEC << tk->shift)) {
+		tk->xtime_nsec -= (u64)NSEC_PER_SEC << tk->shift;
+		tk->xtime_sec++;
+	}
+}
+
+static struct timespec tk_xtime(struct timekeeper *tk)
+{
+	struct timespec ts;
+
+	ts.tv_sec = tk->xtime_sec;
+	ts.tv_nsec = (long)(tk->xtime_nsec >> tk->shift);
+	return ts;
+}
 
+static void tk_set_xtime(struct timekeeper *tk, const struct timespec *ts)
+{
+	tk->xtime_sec = ts->tv_sec;
+	tk->xtime_nsec = ts->tv_nsec << tk->shift;
+}
+
+static void tk_xtime_add(struct timekeeper *tk, const struct timespec *ts)
+{
+	tk->xtime_sec += ts->tv_sec;
+	tk->xtime_nsec += ts->tv_nsec << tk->shift;
+}
 
 /**
  * timekeeper_setup_internals - Set up internals to use clocksource clock.
@@ -104,7 +131,9 @@ static void timekeeper_setup_internals(struct clocksource *clock)
 {
 	cycle_t interval;
 	u64 tmp, ntpinterval;
+	struct clocksource *old_clock;
 
+	old_clock = timekeeper.clock;
 	timekeeper.clock = clock;
 	clock->cycle_last = clock->read(clock);
 
@@ -126,7 +155,14 @@ static void timekeeper_setup_internals(struct clocksource *clock)
 	timekeeper.raw_interval =
 		((u64) interval * clock->mult) >> clock->shift;
 
-	timekeeper.xtime_nsec = 0;
+	 /* if changing clocks, convert xtime_nsec shift units */
+	if (old_clock) {
+		int shift_change = clock->shift - old_clock->shift;
+		if (shift_change < 0)
+			timekeeper.xtime_nsec >>= -shift_change;
+		else
+			timekeeper.xtime_nsec <<= shift_change;
+	}
 	timekeeper.shift = clock->shift;
 
 	timekeeper.ntp_error = 0;
@@ -145,6 +181,7 @@ static inline s64 timekeeping_get_ns(void)
 {
 	cycle_t cycle_now, cycle_delta;
 	struct clocksource *clock;
+	s64 nsec;
 
 	/* read clocksource: */
 	clock = timekeeper.clock;
@@ -153,9 +190,8 @@ static inline s64 timekeeping_get_ns(void)
 	/* calculate the delta since the last update_wall_time: */
 	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 
-	/* return delta convert to nanoseconds using ntp adjusted mult. */
-	return clocksource_cyc2ns(cycle_delta, timekeeper.mult,
-				  timekeeper.shift);
+	nsec = cycle_delta * timekeeper.mult + timekeeper.xtime_nsec;
+	return nsec >> timekeeper.shift;
 }
 
 static inline s64 timekeeping_get_ns_raw(void)
@@ -185,12 +221,15 @@ static void update_rt_offset(void)
 /* must hold write on timekeeper.lock */
 static void timekeeping_update(bool clearntp)
 {
+	struct timespec xt;
+
 	if (clearntp) {
 		timekeeper.ntp_error = 0;
 		ntp_clear();
 	}
 	update_rt_offset();
-	update_vsyscall(&timekeeper.xtime, &timekeeper.wall_to_monotonic,
+	xt = tk_xtime(&timekeeper);
+	update_vsyscall(&xt, &timekeeper.wall_to_monotonic,
 			 timekeeper.clock, timekeeper.mult);
 }
 
@@ -213,13 +252,12 @@ static void timekeeping_forward_now(void)
 	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 	clock->cycle_last = cycle_now;
 
-	nsec = clocksource_cyc2ns(cycle_delta, timekeeper.mult,
-				  timekeeper.shift);
+	timekeeper.xtime_nsec += cycle_delta * timekeeper.mult;
 
 	/* If arch requires, add in gettimeoffset() */
-	nsec += arch_gettimeoffset();
+	timekeeper.xtime_nsec += arch_gettimeoffset() << timekeeper.shift;
 
-	timespec_add_ns(&timekeeper.xtime, nsec);
+	tk_normalize_xtime(&timekeeper);
 
 	nsec = clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
 	timespec_add_ns(&timekeeper.raw_time, nsec);
@@ -234,15 +272,15 @@ static void timekeeping_forward_now(void)
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
@@ -262,11 +300,10 @@ ktime_t ktime_get(void)
 
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
 
@@ -291,22 +328,21 @@ void ktime_get_ts(struct timespec *ts)
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
 
@@ -334,7 +370,8 @@ void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 		seq = read_seqbegin(&timekeeper.lock);
 
 		*ts_raw = timekeeper.raw_time;
-		*ts_real = timekeeper.xtime;
+		ts_real->tv_sec = timekeeper.xtime_sec;
+		ts_real->tv_nsec = 0;
 
 		nsecs_raw = timekeeping_get_ns_raw();
 		nsecs_real = timekeeping_get_ns();
@@ -377,7 +414,7 @@ EXPORT_SYMBOL(do_gettimeofday);
  */
 int do_settimeofday(const struct timespec *tv)
 {
-	struct timespec ts_delta;
+	struct timespec ts_delta, xt;
 	unsigned long flags;
 
 	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
@@ -387,12 +424,15 @@ int do_settimeofday(const struct timespec *tv)
 
 	timekeeping_forward_now();
 
-	ts_delta.tv_sec = tv->tv_sec - timekeeper.xtime.tv_sec;
-	ts_delta.tv_nsec = tv->tv_nsec - timekeeper.xtime.tv_nsec;
+	xt = tk_xtime(&timekeeper);
+	ts_delta.tv_sec = tv->tv_sec - xt.tv_sec;
+	ts_delta.tv_nsec = tv->tv_nsec - xt.tv_nsec;
+
 	timekeeper.wall_to_monotonic =
 			timespec_sub(timekeeper.wall_to_monotonic, ts_delta);
 
-	timekeeper.xtime = *tv;
+	tk_set_xtime(&timekeeper, tv);
+
 	timekeeping_update(true);
 
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
@@ -422,7 +462,8 @@ int timekeeping_inject_offset(struct timespec *ts)
 
 	timekeeping_forward_now();
 
-	timekeeper.xtime = timespec_add(timekeeper.xtime, *ts);
+
+	tk_xtime_add(&timekeeper, ts);
 	timekeeper.wall_to_monotonic =
 				timespec_sub(timekeeper.wall_to_monotonic, *ts);
 
@@ -606,14 +647,12 @@ void __init timekeeping_init(void)
 		clock->enable(clock);
 	timekeeper_setup_internals(clock);
 
-	timekeeper.xtime.tv_sec = now.tv_sec;
-	timekeeper.xtime.tv_nsec = now.tv_nsec;
+	tk_set_xtime(&timekeeper, &now);
 	timekeeper.raw_time.tv_sec = 0;
 	timekeeper.raw_time.tv_nsec = 0;
-	if (boot.tv_sec == 0 && boot.tv_nsec == 0) {
-		boot.tv_sec = timekeeper.xtime.tv_sec;
-		boot.tv_nsec = timekeeper.xtime.tv_nsec;
-	}
+	if (boot.tv_sec == 0 && boot.tv_nsec == 0)
+		boot = tk_xtime(&timekeeper);
+
 	set_normalized_timespec(&timekeeper.wall_to_monotonic,
 				-boot.tv_sec, -boot.tv_nsec);
 	update_rt_offset();
@@ -646,7 +685,7 @@ static void __timekeeping_inject_sleeptime(struct timespec *delta)
 		return;
 	}
 
-	timekeeper.xtime = timespec_add(timekeeper.xtime, *delta);
+	tk_xtime_add(&timekeeper, delta);
 	timekeeper.wall_to_monotonic =
 			timespec_sub(timekeeper.wall_to_monotonic, *delta);
 	update_sleep_time(timespec_add(timekeeper.total_sleep_time, *delta));
@@ -742,7 +781,7 @@ static int timekeeping_suspend(void)
 	 * try to compensate so the difference in system time
 	 * and persistent_clock time stays close to constant.
 	 */
-	delta = timespec_sub(timekeeper.xtime, timekeeping_suspend_time);
+	delta = timespec_sub(tk_xtime(&timekeeper), timekeeping_suspend_time);
 	delta_delta = timespec_sub(delta, old_delta);
 	if (abs(delta_delta.tv_sec)  >= 2) {
 		/*
@@ -977,9 +1016,9 @@ static cycle_t logarithmic_accumulation(cycle_t offset, u32 shift)
 	while (timekeeper.xtime_nsec >= nsecps) {
 		int leap;
 		timekeeper.xtime_nsec -= nsecps;
-		timekeeper.xtime.tv_sec++;
-		leap = second_overflow(timekeeper.xtime.tv_sec);
-		timekeeper.xtime.tv_sec += leap;
+		timekeeper.xtime_sec++;
+		leap = second_overflow(timekeeper.xtime_sec);
+		timekeeper.xtime_sec += leap;
 		timekeeper.wall_to_monotonic.tv_sec -= leap;
 		if (leap)
 			clock_was_set_delayed();
@@ -1015,6 +1054,7 @@ static void update_wall_time(void)
 	cycle_t offset;
 	int shift = 0, maxshift;
 	unsigned long flags;
+	s64 remainder;
 
 	write_seqlock_irqsave(&timekeeper.lock, flags);
 
@@ -1029,8 +1069,6 @@ static void update_wall_time(void)
 #else
 	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
 #endif
-	timekeeper.xtime_nsec = (s64)timekeeper.xtime.tv_nsec <<
-						timekeeper.shift;
 
 	/*
 	 * With NO_HZ we may have to accumulate many cycle_intervals
@@ -1076,28 +1114,31 @@ static void update_wall_time(void)
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
+	remainder = timekeeper.xtime_nsec & ((1 << timekeeper.shift) - 1);
+	timekeeper.xtime_nsec -= remainder;
+	timekeeper.xtime_nsec += 1 << timekeeper.shift;
+	timekeeper.ntp_error += remainder << timekeeper.ntp_error_shift;
 
 	/*
 	 * Finally, make sure that after the rounding
-	 * xtime.tv_nsec isn't larger than NSEC_PER_SEC
+	 * xtime_nsec isn't larger than NSEC_PER_SEC
 	 */
-	if (unlikely(timekeeper.xtime.tv_nsec >= NSEC_PER_SEC)) {
+	if (unlikely(timekeeper.xtime_nsec >=
+			((u64)NSEC_PER_SEC << timekeeper.shift))) {
 		int leap;
-		timekeeper.xtime.tv_nsec -= NSEC_PER_SEC;
-		timekeeper.xtime.tv_sec++;
-		leap = second_overflow(timekeeper.xtime.tv_sec);
-		timekeeper.xtime.tv_sec += leap;
+		timekeeper.xtime_nsec -= (u64)NSEC_PER_SEC << timekeeper.shift;
+		timekeeper.xtime_sec++;
+		leap = second_overflow(timekeeper.xtime_sec);
+		timekeeper.xtime_sec += leap;
 		timekeeper.wall_to_monotonic.tv_sec -= leap;
 		if (leap)
 			clock_was_set_delayed();
@@ -1148,21 +1189,20 @@ void get_monotonic_boottime(struct timespec *ts)
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
 
@@ -1195,13 +1235,13 @@ EXPORT_SYMBOL_GPL(monotonic_to_bootbased);
 
 unsigned long get_seconds(void)
 {
-	return timekeeper.xtime.tv_sec;
+	return timekeeper.xtime_sec;
 }
 EXPORT_SYMBOL(get_seconds);
 
 struct timespec __current_kernel_time(void)
 {
-	return timekeeper.xtime;
+	return tk_xtime(&timekeeper);
 }
 
 struct timespec current_kernel_time(void)
@@ -1212,7 +1252,7 @@ struct timespec current_kernel_time(void)
 	do {
 		seq = read_seqbegin(&timekeeper.lock);
 
-		now = timekeeper.xtime;
+		now = tk_xtime(&timekeeper);
 	} while (read_seqretry(&timekeeper.lock, seq));
 
 	return now;
@@ -1227,7 +1267,7 @@ struct timespec get_monotonic_coarse(void)
 	do {
 		seq = read_seqbegin(&timekeeper.lock);
 
-		now = timekeeper.xtime;
+		now = tk_xtime(&timekeeper);
 		mono = timekeeper.wall_to_monotonic;
 	} while (read_seqretry(&timekeeper.lock, seq));
 
@@ -1262,7 +1302,7 @@ void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
 
 	do {
 		seq = read_seqbegin(&timekeeper.lock);
-		*xtim = timekeeper.xtime;
+		*xtim = tk_xtime(&timekeeper);
 		*wtom = timekeeper.wall_to_monotonic;
 		*sleep = timekeeper.total_sleep_time;
 	} while (read_seqretry(&timekeeper.lock, seq));
@@ -1286,9 +1326,8 @@ ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot)
 	do {
 		seq = read_seqbegin(&timekeeper.lock);
 
-		secs = timekeeper.xtime.tv_sec;
-		nsecs = timekeeper.xtime.tv_nsec;
-		nsecs += timekeeping_get_ns();
+		secs = timekeeper.xtime_sec;
+		nsecs = timekeeping_get_ns();
 		/* If arch requires, add in gettimeoffset() */
 		nsecs += arch_gettimeoffset();
 
