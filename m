Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965406Ab2CBHNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 02:13:52 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:37128 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964867Ab2CBHNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 02:13:49 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 2/9] time: Rework timekeeping functions to take timekeeper ptr as argument
Date: Thu,  1 Mar 2012 23:12:41 -0800
Message-Id: <1330672368-32290-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1330672368-32290-1-git-send-email-john.stultz@linaro.org>
References: <1330672368-32290-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030207-1780-0000-0000-000003A5AA97
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000254; HX=3.00000184; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00118432; UDB=6.00028773; UTC=2012-03-02
 07:13:44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of cleaning up the timekeeping code, this patch converts
a number of internal functions to takea  timekeeper ptr as an
argument, so that the internal functions don't access the global
timekeeper structure directly. This allows for further optimizations
later.

This patch has been updated to include more consistent usage of the
timekeeper value, by making sure it is always passed as a argument
to non top-level functions.

CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |  180 ++++++++++++++++++++++----------------------
 1 files changed, 90 insertions(+), 90 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 5434c6e..74568ca 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -120,7 +120,7 @@ static void tk_xtime_add(struct timekeeper *tk, const struct timespec *ts)
 
 
 /**
- * timekeeper_setup_internals - Set up internals to use clocksource clock.
+ * tk_setup_internals - Set up internals to use clocksource clock.
  *
  * @clock:		Pointer to clocksource.
  *
@@ -129,14 +129,14 @@ static void tk_xtime_add(struct timekeeper *tk, const struct timespec *ts)
  *
  * Unless you're the timekeeping code, you should not be using this!
  */
-static void timekeeper_setup_internals(struct clocksource *clock)
+static void tk_setup_internals(struct timekeeper *tk, struct clocksource *clock)
 {
 	cycle_t interval;
 	u64 tmp, ntpinterval;
 	struct clocksource *old_clock;
 
-	old_clock = timekeeper.clock;
-	timekeeper.clock = clock;
+	old_clock = tk->clock;
+	tk->clock = clock;
 	clock->cycle_last = clock->read(clock);
 
 	/* Do the ns -> cycle conversion first, using original mult */
@@ -149,60 +149,60 @@ static void timekeeper_setup_internals(struct clocksource *clock)
 		tmp = 1;
 
 	interval = (cycle_t) tmp;
-	timekeeper.cycle_interval = interval;
+	tk->cycle_interval = interval;
 
 	/* Go back from cycles -> shifted ns */
-	timekeeper.xtime_interval = (u64) interval * clock->mult;
-	timekeeper.xtime_remainder = ntpinterval - timekeeper.xtime_interval;
-	timekeeper.raw_interval =
+	tk->xtime_interval = (u64) interval * clock->mult;
+	tk->xtime_remainder = ntpinterval - tk->xtime_interval;
+	tk->raw_interval =
 		((u64) interval * clock->mult) >> clock->shift;
 
 	 /* if changing clocks, convert xtime_nsec shift units */
 	if (old_clock) {
 		int shift_change = clock->shift - old_clock->shift;
 		if (shift_change < 0)
-			timekeeper.xtime_nsec >>= -shift_change;
+			tk->xtime_nsec >>= -shift_change;
 		else
-			timekeeper.xtime_nsec <<= shift_change;
+			tk->xtime_nsec <<= shift_change;
 	}
-	timekeeper.shift = clock->shift;
+	tk->shift = clock->shift;
 
-	timekeeper.ntp_error = 0;
-	timekeeper.ntp_error_shift = NTP_SCALE_SHIFT - clock->shift;
+	tk->ntp_error = 0;
+	tk->ntp_error_shift = NTP_SCALE_SHIFT - clock->shift;
 
 	/*
 	 * The timekeeper keeps its own mult values for the currently
 	 * active clocksource. These value will be adjusted via NTP
 	 * to counteract clock drifting.
 	 */
-	timekeeper.mult = clock->mult;
+	tk->mult = clock->mult;
 }
 
 /* Timekeeper helper functions. */
-static inline s64 timekeeping_get_ns(void)
+static inline s64 timekeeping_get_ns(struct timekeeper *tk)
 {
 	cycle_t cycle_now, cycle_delta;
 	struct clocksource *clock;
 	s64 nsec;
 
 	/* read clocksource: */
-	clock = timekeeper.clock;
+	clock = tk->clock;
 	cycle_now = clock->read(clock);
 
 	/* calculate the delta since the last update_wall_time: */
 	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 
-	nsec = cycle_delta * timekeeper.mult + timekeeper.xtime_nsec;
-	return nsec >> timekeeper.shift;
+	nsec = cycle_delta * tk->mult + tk->xtime_nsec;
+	return nsec >> tk->shift;
 }
 
-static inline s64 timekeeping_get_ns_raw(void)
+static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
 {
 	cycle_t cycle_now, cycle_delta;
 	struct clocksource *clock;
 
 	/* read clocksource: */
-	clock = timekeeper.clock;
+	clock = tk->clock;
 	cycle_now = clock->read(clock);
 
 	/* calculate the delta since the last update_wall_time: */
@@ -213,16 +213,15 @@ static inline s64 timekeeping_get_ns_raw(void)
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
-	xt = tk_xtime(&timekeeper);
-	update_vsyscall(&xt, &timekeeper.wall_to_monotonic,
-			 timekeeper.clock, timekeeper.mult);
+	xt = tk_xtime(tk);
+	update_vsyscall(&xt, &tk->wall_to_monotonic, tk->clock, tk->mult);
 }
 
 
@@ -233,7 +232,7 @@ void timekeeping_leap_insert(int leapsecond)
 	write_seqlock_irqsave(&timekeeper.lock, flags);
 	timekeeper.xtime_sec += leapsecond;
 	timekeeper.wall_to_monotonic.tv_sec -= leapsecond;
-	timekeeping_update(false);
+	timekeeping_update(&timekeeper, false);
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 
 }
@@ -245,26 +244,26 @@ void timekeeping_leap_insert(int leapsecond)
  * update_wall_time(). This is useful before significant clock changes,
  * as it avoids having to deal with this time offset explicitly.
  */
-static void timekeeping_forward_now(void)
+static void timekeeping_forward_now(struct timekeeper *tk)
 {
 	cycle_t cycle_now, cycle_delta;
 	struct clocksource *clock;
 	s64 nsec;
 
-	clock = timekeeper.clock;
+	clock = tk->clock;
 	cycle_now = clock->read(clock);
 	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 	clock->cycle_last = cycle_now;
 
-	timekeeper.xtime_nsec += cycle_delta * timekeeper.mult;
+	tk->xtime_nsec += cycle_delta * tk->mult;
 
 	/* If arch requires, add in gettimeoffset() */
-	timekeeper.xtime_nsec += arch_gettimeoffset() << timekeeper.shift;
+	tk->xtime_nsec += arch_gettimeoffset() << tk->shift;
 
-	tk_normalize_xtime(&timekeeper);
+	tk_normalize_xtime(tk);
 
 	nsec = clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
-	timespec_add_ns(&timekeeper.raw_time, nsec);
+	timespec_add_ns(&tk->raw_time, nsec);
 }
 
 /**
@@ -284,7 +283,7 @@ void getnstimeofday(struct timespec *ts)
 		seq = read_seqbegin(&timekeeper.lock);
 
 		ts->tv_sec = timekeeper.xtime_sec;
-		ts->tv_nsec = timekeeping_get_ns();
+		ts->tv_nsec = timekeeping_get_ns(&timekeeper);
 
 		/* If arch requires, add in gettimeoffset() */
 		nsecs += arch_gettimeoffset();
@@ -307,7 +306,7 @@ ktime_t ktime_get(void)
 		seq = read_seqbegin(&timekeeper.lock);
 		secs = timekeeper.xtime_sec +
 				timekeeper.wall_to_monotonic.tv_sec;
-		nsecs = timekeeping_get_ns() +
+		nsecs = timekeeping_get_ns(&timekeeper) +
 				timekeeper.wall_to_monotonic.tv_nsec;
 		/* If arch requires, add in gettimeoffset() */
 		nsecs += arch_gettimeoffset();
@@ -339,7 +338,7 @@ void ktime_get_ts(struct timespec *ts)
 	do {
 		seq = read_seqbegin(&timekeeper.lock);
 		ts->tv_sec = timekeeper.xtime_sec;
-		ts->tv_nsec = timekeeping_get_ns();
+		ts->tv_nsec = timekeeping_get_ns(&timekeeper);
 		tomono = timekeeper.wall_to_monotonic;
 		/* If arch requires, add in gettimeoffset() */
 		ts->tv_nsec += arch_gettimeoffset();
@@ -378,8 +377,8 @@ void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 		ts_real->tv_sec = timekeeper.xtime_sec;
 		ts_real->tv_nsec = 0;
 
-		nsecs_raw = timekeeping_get_ns_raw();
-		nsecs_real = timekeeping_get_ns();
+		nsecs_raw = timekeeping_get_ns_raw(&timekeeper);
+		nsecs_real = timekeeping_get_ns(&timekeeper);
 
 		/* If arch requires, add in gettimeoffset() */
 		arch_offset = arch_gettimeoffset();
@@ -427,7 +426,7 @@ int do_settimeofday(const struct timespec *tv)
 
 	write_seqlock_irqsave(&timekeeper.lock, flags);
 
-	timekeeping_forward_now();
+	timekeeping_forward_now(&timekeeper);
 
 	xt = tk_xtime(&timekeeper);
 	ts_delta.tv_sec = tv->tv_sec - xt.tv_sec;
@@ -438,7 +437,7 @@ int do_settimeofday(const struct timespec *tv)
 
 	tk_set_xtime(&timekeeper, tv);
 
-	timekeeping_update(true);
+	timekeeping_update(&timekeeper, true);
 
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 
@@ -466,14 +465,14 @@ int timekeeping_inject_offset(struct timespec *ts)
 
 	write_seqlock_irqsave(&timekeeper.lock, flags);
 
-	timekeeping_forward_now();
+	timekeeping_forward_now(&timekeeper);
 
 
 	tk_xtime_add(&timekeeper, ts);
 	timekeeper.wall_to_monotonic =
 				timespec_sub(timekeeper.wall_to_monotonic, *ts);
 
-	timekeeping_update(true);
+	timekeeping_update(&timekeeper, true);
 
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 
@@ -495,10 +494,10 @@ static int change_clocksource(void *data)
 
 	new = (struct clocksource *) data;
 
-	timekeeping_forward_now();
+	timekeeping_forward_now(&timekeeper);
 	if (!new->enable || new->enable(new) == 0) {
 		old = timekeeper.clock;
-		timekeeper_setup_internals(new);
+		tk_setup_internals(&timekeeper, new);
 		if (old->disable)
 			old->disable(old);
 	}
@@ -548,7 +547,7 @@ void getrawmonotonic(struct timespec *ts)
 
 	do {
 		seq = read_seqbegin(&timekeeper.lock);
-		nsecs = timekeeping_get_ns_raw();
+		nsecs = timekeeping_get_ns_raw(&timekeeper);
 		*ts = timekeeper.raw_time;
 
 	} while (read_seqretry(&timekeeper.lock, seq));
@@ -643,7 +642,7 @@ void __init timekeeping_init(void)
 	clock = clocksource_default_clock();
 	if (clock->enable)
 		clock->enable(clock);
-	timekeeper_setup_internals(clock);
+	tk_setup_internals(&timekeeper, clock);
 
 	tk_set_xtime(&timekeeper, &now);
 	timekeeper.raw_time.tv_sec = 0;
@@ -706,11 +705,11 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 
 	write_seqlock_irqsave(&timekeeper.lock, flags);
 
-	timekeeping_forward_now();
+	timekeeping_forward_now(&timekeeper);
 
 	__timekeeping_inject_sleeptime(delta);
 
-	timekeeping_update(true);
+	timekeeping_update(&timekeeper, true);
 
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 
@@ -764,7 +763,7 @@ static int timekeeping_suspend(void)
 	read_persistent_clock(&timekeeping_suspend_time);
 
 	write_seqlock_irqsave(&timekeeper.lock, flags);
-	timekeeping_forward_now();
+	timekeeping_forward_now(&timekeeper);
 	timekeeping_suspended = 1;
 
 	/*
@@ -812,7 +811,8 @@ device_initcall(timekeeping_init_ops);
  * If the error is already larger, we look ahead even further
  * to compensate for late or lost adjustments.
  */
-static __always_inline int timekeeping_bigadjust(s64 error, s64 *interval,
+static __always_inline int timekeeping_bigadjust(struct timekeeper *tk,
+						 s64 error, s64 *interval,
 						 s64 *offset)
 {
 	s64 tick_error, i;
@@ -828,7 +828,7 @@ static __always_inline int timekeeping_bigadjust(s64 error, s64 *interval,
 	 * here.  This is tuned so that an error of about 1 msec is adjusted
 	 * within about 1 sec (or 2^20 nsec in 2^SHIFT_HZ ticks).
 	 */
-	error2 = timekeeper.ntp_error >> (NTP_SCALE_SHIFT + 22 - 2 * SHIFT_HZ);
+	error2 = tk->ntp_error >> (NTP_SCALE_SHIFT + 22 - 2 * SHIFT_HZ);
 	error2 = abs(error2);
 	for (look_ahead = 0; error2 > 0; look_ahead++)
 		error2 >>= 2;
@@ -837,8 +837,8 @@ static __always_inline int timekeeping_bigadjust(s64 error, s64 *interval,
 	 * Now calculate the error in (1 << look_ahead) ticks, but first
 	 * remove the single look ahead already included in the error.
 	 */
-	tick_error = ntp_tick_length() >> (timekeeper.ntp_error_shift + 1);
-	tick_error -= timekeeper.xtime_interval >> 1;
+	tick_error = ntp_tick_length() >> (tk->ntp_error_shift + 1);
+	tick_error -= tk->xtime_interval >> 1;
 	error = ((error - tick_error) >> look_ahead) + tick_error;
 
 	/* Finally calculate the adjustment shift value.  */
@@ -863,9 +863,9 @@ static __always_inline int timekeeping_bigadjust(s64 error, s64 *interval,
  * this is optimized for the most common adjustments of -1,0,1,
  * for other values we can do a bit more work.
  */
-static void timekeeping_adjust(s64 offset)
+static void timekeeping_adjust(struct timekeeper *tk, s64 offset)
 {
-	s64 error, interval = timekeeper.cycle_interval;
+	s64 error, interval = tk->cycle_interval;
 	int adj;
 
 	/*
@@ -881,7 +881,7 @@ static void timekeeping_adjust(s64 offset)
 	 *
 	 * Note: It does not "save" on aggravation when reading the code.
 	 */
-	error = timekeeper.ntp_error >> (timekeeper.ntp_error_shift - 1);
+	error = tk->ntp_error >> (tk->ntp_error_shift - 1);
 	if (error > interval) {
 		/*
 		 * We now divide error by 4(via shift), which checks if
@@ -903,7 +903,8 @@ static void timekeeping_adjust(s64 offset)
 		if (likely(error <= interval))
 			adj = 1;
 		else
-			adj = timekeeping_bigadjust(error, &interval, &offset);
+			adj = timekeeping_bigadjust(tk, error, &interval,
+							&offset);
 	} else if (error < -interval) {
 		/* See comment above, this is just switched for the negative */
 		error >>= 2;
@@ -912,17 +913,17 @@ static void timekeeping_adjust(s64 offset)
 			interval = -interval;
 			offset = -offset;
 		} else
-			adj = timekeeping_bigadjust(error, &interval, &offset);
-	} else /* No adjustment needed */
+			adj = timekeeping_bigadjust(tk, error, &interval,
+							&offset);
+	} else
 		return;
 
-	WARN_ONCE(timekeeper.clock->maxadj &&
-			(timekeeper.mult + adj > timekeeper.clock->mult +
-						timekeeper.clock->maxadj),
+	WARN_ONCE(tk->clock->maxadj &&
+			(tk->mult + adj > tk->clock->mult + tk->clock->maxadj),
 			"Adjusting %s more then 11%% (%ld vs %ld)\n",
-			timekeeper.clock->name, (long)timekeeper.mult + adj,
-			(long)timekeeper.clock->mult +
-				timekeeper.clock->maxadj);
+			tk->clock->name, (long)tk->mult + adj,
+			(long)tk->clock->mult + tk->clock->maxadj);
+
 	/*
 	 * So the following can be confusing.
 	 *
@@ -972,11 +973,10 @@ static void timekeeping_adjust(s64 offset)
 	 *
 	 * XXX - TODO: Doc ntp_error calculation.
 	 */
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
 
 
@@ -989,41 +989,41 @@ static void timekeeping_adjust(s64 offset)
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
@@ -1069,13 +1069,13 @@ static void update_wall_time(void)
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
@@ -1125,7 +1125,7 @@ static void update_wall_time(void)
 		second_overflow();
 	}
 
-	timekeeping_update(false);
+	timekeeping_update(&timekeeper, false);
 
 out:
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
@@ -1176,7 +1176,7 @@ void get_monotonic_boottime(struct timespec *ts)
 	do {
 		seq = read_seqbegin(&timekeeper.lock);
 		ts->tv_sec = timekeeper.xtime_sec;
-		ts->tv_nsec = timekeeping_get_ns();
+		ts->tv_nsec = timekeeping_get_ns(&timekeeper);
 		tomono = timekeeper.wall_to_monotonic;
 		sleep = timekeeper.total_sleep_time;
 
-- 
1.7.3.2.146.gca209

