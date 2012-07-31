Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab2GaSCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 14:02:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59355 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab2GaSCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 14:02:20 -0400
Date: Tue, 31 Jul 2012 11:02:02 -0700
From: tip-bot for John Stultz <john.stultz@linaro.org>
Message-ID: <tip-6d0ef903e2bda70da124c10d8ad89f2382c87991@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, prarit@redhat.com
Reply-To: john.stultz@linaro.org, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        richardcochran@gmail.com, tglx@linutronix.de, prarit@redhat.com
In-Reply-To: <1343414893-45779-5-git-send-email-john.stultz@linaro.org>
References: <1343414893-45779-5-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] time: Clean up offs_real/
 wall_to_mono and offs_boot/total_sleep_time updates
Git-Commit-ID: 6d0ef903e2bda70da124c10d8ad89f2382c87991
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 31 Jul 2012 11:02:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6d0ef903e2bda70da124c10d8ad89f2382c87991
Gitweb:     http://git.kernel.org/tip/6d0ef903e2bda70da124c10d8ad89f2382c87991
Author:     John Stultz <john.stultz@linaro.org>
AuthorDate: Fri, 27 Jul 2012 14:48:12 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 31 Jul 2012 17:09:14 +0200

time: Clean up offs_real/wall_to_mono and offs_boot/total_sleep_time updates

For performance reasons, we maintain ktime_t based duplicates of
wall_to_monotonic (offs_real) and total_sleep_time (offs_boot).

Since large problems could occur (such as the resume regression
on 3.5-rc7, or the leapsecond hrtimer issue) if these value
pairs were to be inconsistently updated, this patch this cleans
up how we modify these value pairs to ensure we are always
consistent.

As a side-effect this is also more efficient as we only
caulculate the duplicate values when they are changed,
rather then every update_wall_time call.

This also provides WARN_ONs to detect if future changes break
the invariants.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1343414893-45779-5-git-send-email-john.stultz@linaro.org
[ Cleaned up minor style issues. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/time/timekeeping.c |   90 +++++++++++++++++++++++++++------------------
 1 files changed, 54 insertions(+), 36 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 05b37a5..4da6559 100644
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
@@ -117,6 +117,31 @@ static void tk_xtime_add(struct timekeeper *tk, const struct timespec *ts)
 	tk->xtime_nsec += (u64)ts->tv_nsec << tk->shift;
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
+	WARN_ON_ONCE(tk->offs_boot.tv64 != timespec_to_ktime(tk->total_sleep_time).tv64);
+
+	tk->total_sleep_time	= t;
+	tk->offs_boot		= timespec_to_ktime(t);
+}
+
 /**
  * timekeeper_setup_internals - Set up internals to use clocksource clock.
  *
@@ -217,14 +242,6 @@ static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
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
@@ -234,7 +251,6 @@ static void timekeeping_update(struct timekeeper *tk, bool clearntp)
 		tk->ntp_error = 0;
 		ntp_clear();
 	}
-	update_rt_offset(tk);
 	xt = tk_xtime(tk);
 	update_vsyscall(&xt, &tk->wall_to_monotonic, tk->clock, tk->mult);
 }
@@ -419,8 +435,8 @@ int do_settimeofday(const struct timespec *tv)
 	ts_delta.tv_sec = tv->tv_sec - xt.tv_sec;
 	ts_delta.tv_nsec = tv->tv_nsec - xt.tv_nsec;
 
-	timekeeper.wall_to_monotonic =
-			timespec_sub(timekeeper.wall_to_monotonic, ts_delta);
+	tk_set_wall_to_mono(&timekeeper,
+			timespec_sub(timekeeper.wall_to_monotonic, ts_delta));
 
 	tk_set_xtime(&timekeeper, tv);
 
@@ -454,8 +470,8 @@ int timekeeping_inject_offset(struct timespec *ts)
 
 
 	tk_xtime_add(&timekeeper, ts);
-	timekeeper.wall_to_monotonic =
-				timespec_sub(timekeeper.wall_to_monotonic, *ts);
+	tk_set_wall_to_mono(&timekeeper,
+			timespec_sub(timekeeper.wall_to_monotonic, *ts));
 
 	timekeeping_update(&timekeeper, true);
 
@@ -621,7 +637,7 @@ void __init timekeeping_init(void)
 {
 	struct clocksource *clock;
 	unsigned long flags;
-	struct timespec now, boot;
+	struct timespec now, boot, tmp;
 
 	read_persistent_clock(&now);
 	read_boot_clock(&boot);
@@ -642,23 +658,19 @@ void __init timekeeping_init(void)
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
@@ -674,10 +686,9 @@ static void __timekeeping_inject_sleeptime(struct timekeeper *tk,
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
@@ -1018,11 +1029,18 @@ static inline void accumulate_nsecs_to_secs(struct timekeeper *tk)
 
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
 
