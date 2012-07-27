Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2G0Ste (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 14:49:34 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:37188 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab2G0Ss7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 14:48:59 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4/5] time: Cleanup offs_real/wall_to_mono and offs_boot/total_sleep_time updates
Date: Fri, 27 Jul 2012 14:48:12 -0400
Message-Id: <1343414893-45779-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343414893-45779-1-git-send-email-john.stultz@linaro.org>
References: <1343414893-45779-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072718-6148-0000-0000-00000813FD2D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For performance reasons, we maintain ktime_t based duplicates of
wall_to_monotonic (offs_real) and total_sleep_time (offs_boot).

Since large problems could occur (such as the resume regression
on 3.5-rc7, or the leapsecond hrtimer issue) if these value pairs
were to be inconsistently updated, this patch this cleans up how
we modify these value pairs to ensure we are always consistent.

As a side-effect this is also more efficient as we only
caulculate the duplicate values when they are changed,
rather then every update_wall_time call.

This also provides WARN_ONs to detect if future changes break
the invariants.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   91 +++++++++++++++++++++++++++------------------
 1 file changed, 55 insertions(+), 36 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 8d8636f..c4061f5 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -65,14 +65,14 @@ struct timekeeper {
 	 * used instead.
 	 */
 	struct timespec		wall_to_monotonic;
-	/* time spent in suspend */
-	struct timespec		total_sleep_time;
-	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
-	struct timespec		raw_time;
 	/* Offset clock monotonic -> clock realtime */
 	ktime_t			offs_real;
+	/* time spent in suspend */
+	struct timespec		total_sleep_time;
 	/* Offset clock monotonic -> clock boottime */
 	ktime_t			offs_boot;
+	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
+	struct timespec		raw_time;
 	/* Seqlock for all timekeeper values */
 	seqlock_t		lock;
 };
@@ -117,6 +117,32 @@ static void tk_xtime_add(struct timekeeper *tk, const struct timespec *ts)
 	tk->xtime_nsec += ts->tv_nsec << tk->shift;
 }
 
+static void tk_set_wall_to_mono(struct timekeeper *tk, struct timespec wtm)
+{
+	struct timespec tmp;
+
+	/*
+	 * Verify consistency of: offset_real = -wall_to_monotonic
+	 * before modifying anything
+	 */
+	set_normalized_timespec(&tmp, -tk->wall_to_monotonic.tv_sec,
+					-tk->wall_to_monotonic.tv_nsec);
+	WARN_ON_ONCE(tk->offs_real.tv64 != timespec_to_ktime(tmp).tv64);
+	tk->wall_to_monotonic = wtm;
+	set_normalized_timespec(&tmp, -wtm.tv_sec, -wtm.tv_nsec);
+	tk->offs_real = timespec_to_ktime(tmp);
+}
+
+static void tk_set_sleep_time(struct timekeeper *tk, struct timespec t)
+{
+	/* Verify consistency before modifying */
+	WARN_ON_ONCE(tk->offs_boot.tv64 !=
+				timespec_to_ktime(tk->total_sleep_time).tv64);
+
+	tk->total_sleep_time = t;
+	tk->offs_boot = timespec_to_ktime(t);
+}
+
 /**
  * timekeeper_setup_internals - Set up internals to use clocksource clock.
  *
@@ -217,14 +243,6 @@ static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
 	return nsec + arch_gettimeoffset();
 }
 
-static void update_rt_offset(struct timekeeper *tk)
-{
-	struct timespec tmp, *wtm = &tk->wall_to_monotonic;
-
-	set_normalized_timespec(&tmp, -wtm->tv_sec, -wtm->tv_nsec);
-	tk->offs_real = timespec_to_ktime(tmp);
-}
-
 /* must hold write on timekeeper.lock */
 static void timekeeping_update(struct timekeeper *tk, bool clearntp)
 {
@@ -234,7 +252,6 @@ static void timekeeping_update(struct timekeeper *tk, bool clearntp)
 		tk->ntp_error = 0;
 		ntp_clear();
 	}
-	update_rt_offset(tk);
 	xt = tk_xtime(tk);
 	update_vsyscall(&xt, &tk->wall_to_monotonic, tk->clock, tk->mult);
 }
@@ -419,8 +436,8 @@ int do_settimeofday(const struct timespec *tv)
 	ts_delta.tv_sec = tv->tv_sec - xt.tv_sec;
 	ts_delta.tv_nsec = tv->tv_nsec - xt.tv_nsec;
 
-	timekeeper.wall_to_monotonic =
-			timespec_sub(timekeeper.wall_to_monotonic, ts_delta);
+	tk_set_wall_to_mono(&timekeeper,
+			timespec_sub(timekeeper.wall_to_monotonic, ts_delta));
 
 	tk_set_xtime(&timekeeper, tv);
 
@@ -454,8 +471,8 @@ int timekeeping_inject_offset(struct timespec *ts)
 
 
 	tk_xtime_add(&timekeeper, ts);
-	timekeeper.wall_to_monotonic =
-				timespec_sub(timekeeper.wall_to_monotonic, *ts);
+	tk_set_wall_to_mono(&timekeeper,
+			timespec_sub(timekeeper.wall_to_monotonic, *ts));
 
 	timekeeping_update(&timekeeper, true);
 
@@ -621,7 +638,7 @@ void __init timekeeping_init(void)
 {
 	struct clocksource *clock;
 	unsigned long flags;
-	struct timespec now, boot;
+	struct timespec now, boot, tmp;
 
 	read_persistent_clock(&now);
 	read_boot_clock(&boot);
@@ -642,23 +659,19 @@ void __init timekeeping_init(void)
 	if (boot.tv_sec == 0 && boot.tv_nsec == 0)
 		boot = tk_xtime(&timekeeper);
 
-	set_normalized_timespec(&timekeeper.wall_to_monotonic,
-				-boot.tv_sec, -boot.tv_nsec);
-	update_rt_offset(&timekeeper);
-	timekeeper.total_sleep_time.tv_sec = 0;
-	timekeeper.total_sleep_time.tv_nsec = 0;
+	set_normalized_timespec(&tmp, -boot.tv_sec, -boot.tv_nsec);
+	tk_set_wall_to_mono(&timekeeper, tmp);
+
+	tmp.tv_sec = 0;
+	tmp.tv_nsec = 0;
+	tk_set_sleep_time(&timekeeper, tmp);
+
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 }
 
 /* time in seconds when suspend began */
 static struct timespec timekeeping_suspend_time;
 
-static void update_sleep_time(struct timespec t)
-{
-	timekeeper.total_sleep_time = t;
-	timekeeper.offs_boot = timespec_to_ktime(t);
-}
-
 /**
  * __timekeeping_inject_sleeptime - Internal function to add sleep interval
  * @delta: pointer to a timespec delta value
@@ -674,10 +687,9 @@ static void __timekeeping_inject_sleeptime(struct timekeeper *tk,
 					"sleep delta value!\n");
 		return;
 	}
-
 	tk_xtime_add(tk, delta);
-	tk->wall_to_monotonic = timespec_sub(tk->wall_to_monotonic, *delta);
-	update_sleep_time(timespec_add(tk->total_sleep_time, *delta));
+	tk_set_wall_to_mono(tk, timespec_sub(tk->wall_to_monotonic, *delta));
+	tk_set_sleep_time(tk, timespec_add(tk->total_sleep_time, *delta));
 }
 
 /**
@@ -1018,11 +1030,18 @@ static inline void accumulate_nsecs_to_secs(struct timekeeper *tk)
 
 		/* Figure out if its a leap sec and apply if needed */
 		leap = second_overflow(tk->xtime_sec);
-		tk->xtime_sec += leap;
-		tk->wall_to_monotonic.tv_sec -= leap;
-		if (leap)
-			clock_was_set_delayed();
+		if (unlikely(leap)) {
+			struct timespec ts;
+
+			tk->xtime_sec += leap;
 
+			ts.tv_sec = leap;
+			ts.tv_nsec = 0;
+			tk_set_wall_to_mono(tk,
+				timespec_sub(tk->wall_to_monotonic, ts));
+
+			clock_was_set_delayed();
+		}
 	}
 }
 
-- 
1.7.9.5

