Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab1KOEFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 23:05:09 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:46476 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab1KOEFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 23:05:06 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 02/16] time: Move wall_to_monotonic into the timekeeper structure
Date: Mon, 14 Nov 2011 20:03:52 -0800
Message-Id: <1321329846-14755-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
References: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
x-cbid: 11111504-2398-0000-0000-000001F0E452
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for locking cleanups, move wall_to_monotonic
into the timekeeper structure.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   69 ++++++++++++++++++++++++---------------------
 1 files changed, 37 insertions(+), 32 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index bd8e7fd..15740b5 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -48,6 +48,21 @@ struct timekeeper {
 	/* NTP adjusted clock multiplier */
 	u32	mult;
 
+	/*
+	 * wall_to_monotonic is what we need to add to xtime (or xtime corrected
+	 * for sub jiffie times) to get to monotonic time.  Monotonic is pegged
+	 * at zero at system boot time, so wall_to_monotonic will be negative,
+	 * however, we will ALWAYS keep the tv_nsec part positive so we can use
+	 * the usual normalization.
+	 *
+	 * wall_to_monotonic is moved after resume from suspend for the
+	 * monotonic time not to jump. We need to add total_sleep_time to
+	 * wall_to_monotonic to get the real boot based time offset.
+	 *
+	 * - wall_to_monotonic is no longer the boot time, getboottime must be
+	 * used instead.
+	 */
+	struct timespec wall_to_monotonic;
 	/* time spent in suspend */
 	struct timespec total_sleep_time;
 
@@ -148,21 +163,8 @@ __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
 
 /*
  * The current time
- * wall_to_monotonic is what we need to add to xtime (or xtime corrected
- * for sub jiffie times) to get to monotonic time.  Monotonic is pegged
- * at zero at system boot time, so wall_to_monotonic will be negative,
- * however, we will ALWAYS keep the tv_nsec part positive so we can use
- * the usual normalization.
- *
- * wall_to_monotonic is moved after resume from suspend for the monotonic
- * time not to jump. We need to add total_sleep_time to wall_to_monotonic
- * to get the real boot based time offset.
- *
- * - wall_to_monotonic is no longer the boot time, getboottime must be
- * used instead.
  */
 static struct timespec xtime __attribute__ ((aligned (16)));
-static struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
 
 /*
  * The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock.
@@ -176,8 +178,8 @@ int __read_mostly timekeeping_suspended;
 void timekeeping_leap_insert(int leapsecond)
 {
 	xtime.tv_sec += leapsecond;
-	wall_to_monotonic.tv_sec -= leapsecond;
-	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
+	timekeeper.wall_to_monotonic.tv_sec -= leapsecond;
+	update_vsyscall(&xtime, &timekeeper.wall_to_monotonic, timekeeper.clock,
 			timekeeper.mult);
 }
 
@@ -249,8 +251,8 @@ ktime_t ktime_get(void)
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
-		secs = xtime.tv_sec + wall_to_monotonic.tv_sec;
-		nsecs = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
+		secs = xtime.tv_sec + timekeeper.wall_to_monotonic.tv_sec;
+		nsecs = xtime.tv_nsec + timekeeper.wall_to_monotonic.tv_nsec;
 		nsecs += timekeeping_get_ns();
 
 	} while (read_seqretry(&xtime_lock, seq));
@@ -281,7 +283,7 @@ void ktime_get_ts(struct timespec *ts)
 	do {
 		seq = read_seqbegin(&xtime_lock);
 		*ts = xtime;
-		tomono = wall_to_monotonic;
+		tomono = timekeeper.wall_to_monotonic;
 		nsecs = timekeeping_get_ns();
 
 	} while (read_seqretry(&xtime_lock, seq));
@@ -370,14 +372,15 @@ int do_settimeofday(const struct timespec *tv)
 
 	ts_delta.tv_sec = tv->tv_sec - xtime.tv_sec;
 	ts_delta.tv_nsec = tv->tv_nsec - xtime.tv_nsec;
-	wall_to_monotonic = timespec_sub(wall_to_monotonic, ts_delta);
+	timekeeper.wall_to_monotonic =
+			timespec_sub(timekeeper.wall_to_monotonic, ts_delta);
 
 	xtime = *tv;
 
 	timekeeper.ntp_error = 0;
 	ntp_clear();
 
-	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
+	update_vsyscall(&xtime, &timekeeper.wall_to_monotonic, timekeeper.clock,
 				timekeeper.mult);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
@@ -409,12 +412,13 @@ int timekeeping_inject_offset(struct timespec *ts)
 	timekeeping_forward_now();
 
 	xtime = timespec_add(xtime, *ts);
-	wall_to_monotonic = timespec_sub(wall_to_monotonic, *ts);
+	timekeeper.wall_to_monotonic =
+				timespec_sub(timekeeper.wall_to_monotonic, *ts);
 
 	timekeeper.ntp_error = 0;
 	ntp_clear();
 
-	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
+	update_vsyscall(&xtime, &timekeeper.wall_to_monotonic, timekeeper.clock,
 				timekeeper.mult);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
@@ -588,7 +592,7 @@ void __init timekeeping_init(void)
 		boot.tv_sec = xtime.tv_sec;
 		boot.tv_nsec = xtime.tv_nsec;
 	}
-	set_normalized_timespec(&wall_to_monotonic,
+	set_normalized_timespec(&timekeeper.wall_to_monotonic,
 				-boot.tv_sec, -boot.tv_nsec);
 	timekeeper.total_sleep_time.tv_sec = 0;
 	timekeeper.total_sleep_time.tv_nsec = 0;
@@ -614,7 +618,8 @@ static void __timekeeping_inject_sleeptime(struct timespec *delta)
 	}
 
 	xtime = timespec_add(xtime, *delta);
-	wall_to_monotonic = timespec_sub(wall_to_monotonic, *delta);
+	timekeeper.wall_to_monotonic =
+			timespec_sub(timekeeper.wall_to_monotonic, *delta);
 	timekeeper.total_sleep_time = timespec_add(
 					timekeeper.total_sleep_time, *delta);
 }
@@ -647,7 +652,7 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 
 	timekeeper.ntp_error = 0;
 	ntp_clear();
-	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
+	update_vsyscall(&xtime, &timekeeper.wall_to_monotonic, timekeeper.clock,
 				timekeeper.mult);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
@@ -970,7 +975,7 @@ static void update_wall_time(void)
 	}
 
 	/* check to see if there is a new clocksource to use */
-	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
+	update_vsyscall(&xtime, &timekeeper.wall_to_monotonic, timekeeper.clock,
 				timekeeper.mult);
 }
 
@@ -988,9 +993,9 @@ static void update_wall_time(void)
 void getboottime(struct timespec *ts)
 {
 	struct timespec boottime = {
-		.tv_sec = wall_to_monotonic.tv_sec +
+		.tv_sec = timekeeper.wall_to_monotonic.tv_sec +
 				timekeeper.total_sleep_time.tv_sec,
-		.tv_nsec = wall_to_monotonic.tv_nsec +
+		.tv_nsec = timekeeper.wall_to_monotonic.tv_nsec +
 				timekeeper.total_sleep_time.tv_nsec
 	};
 
@@ -1019,7 +1024,7 @@ void get_monotonic_boottime(struct timespec *ts)
 	do {
 		seq = read_seqbegin(&xtime_lock);
 		*ts = xtime;
-		tomono = wall_to_monotonic;
+		tomono = timekeeper.wall_to_monotonic;
 		sleep = timekeeper.total_sleep_time;
 		nsecs = timekeeping_get_ns();
 
@@ -1092,7 +1097,7 @@ struct timespec get_monotonic_coarse(void)
 		seq = read_seqbegin(&xtime_lock);
 
 		now = xtime;
-		mono = wall_to_monotonic;
+		mono = timekeeper.wall_to_monotonic;
 	} while (read_seqretry(&xtime_lock, seq));
 
 	set_normalized_timespec(&now, now.tv_sec + mono.tv_sec,
@@ -1127,7 +1132,7 @@ void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
 	do {
 		seq = read_seqbegin(&xtime_lock);
 		*xtim = xtime;
-		*wtom = wall_to_monotonic;
+		*wtom = timekeeper.wall_to_monotonic;
 		*sleep = timekeeper.total_sleep_time;
 	} while (read_seqretry(&xtime_lock, seq));
 }
@@ -1142,7 +1147,7 @@ ktime_t ktime_get_monotonic_offset(void)
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
-		wtom = wall_to_monotonic;
+		wtom = timekeeper.wall_to_monotonic;
 	} while (read_seqretry(&xtime_lock, seq));
 	return timespec_to_ktime(wtom);
 }
-- 
1.7.3.2.146.gca209

