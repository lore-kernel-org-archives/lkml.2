Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab1KOEIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 23:08:06 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46496 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766Ab1KOEEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 23:04:23 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 04/16] time: Move raw_time into timekeeper structure
Date: Mon, 14 Nov 2011 20:03:54 -0800
Message-Id: <1321329846-14755-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
References: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
x-cbid: 11111504-7182-0000-0000-00000030B807
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for locking cleanups, move raw_time into
timekeeper structure.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6c64931..19d160a 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -67,7 +67,8 @@ struct timekeeper {
 	struct timespec wall_to_monotonic;
 	/* time spent in suspend */
 	struct timespec total_sleep_time;
-
+	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
+	struct timespec raw_time;
 };
 
 static struct timekeeper timekeeper;
@@ -164,10 +165,6 @@ __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
 
 
 
-/*
- * The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock.
- */
-static struct timespec raw_time;
 
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
@@ -208,7 +205,7 @@ static void timekeeping_forward_now(void)
 	timespec_add_ns(&timekeeper.xtime, nsec);
 
 	nsec = clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
-	timespec_add_ns(&raw_time, nsec);
+	timespec_add_ns(&timekeeper.raw_time, nsec);
 }
 
 /**
@@ -316,7 +313,7 @@ void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 
 		seq = read_seqbegin(&xtime_lock);
 
-		*ts_raw = raw_time;
+		*ts_raw = timekeeper.raw_time;
 		*ts_real = timekeeper.xtime;
 
 		nsecs_raw = timekeeping_get_ns_raw();
@@ -495,7 +492,7 @@ void getrawmonotonic(struct timespec *ts)
 	do {
 		seq = read_seqbegin(&xtime_lock);
 		nsecs = timekeeping_get_ns_raw();
-		*ts = raw_time;
+		*ts = timekeeper.raw_time;
 
 	} while (read_seqretry(&xtime_lock, seq));
 
@@ -586,8 +583,8 @@ void __init timekeeping_init(void)
 
 	timekeeper.xtime.tv_sec = now.tv_sec;
 	timekeeper.xtime.tv_nsec = now.tv_nsec;
-	raw_time.tv_sec = 0;
-	raw_time.tv_nsec = 0;
+	timekeeper.raw_time.tv_sec = 0;
+	timekeeper.raw_time.tv_nsec = 0;
 	if (boot.tv_sec == 0 && boot.tv_nsec == 0) {
 		boot.tv_sec = timekeeper.xtime.tv_sec;
 		boot.tv_nsec = timekeeper.xtime.tv_nsec;
@@ -868,13 +865,13 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 
 	/* Accumulate raw time */
 	raw_nsecs = timekeeper.raw_interval << shift;
-	raw_nsecs += raw_time.tv_nsec;
+	raw_nsecs += timekeeper.raw_time.tv_nsec;
 	if (raw_nsecs >= NSEC_PER_SEC) {
 		u64 raw_secs = raw_nsecs;
 		raw_nsecs = do_div(raw_secs, NSEC_PER_SEC);
-		raw_time.tv_sec += raw_secs;
+		timekeeper.raw_time.tv_sec += raw_secs;
 	}
-	raw_time.tv_nsec = raw_nsecs;
+	timekeeper.raw_time.tv_nsec = raw_nsecs;
 
 	/* Accumulate error between NTP and clock interval */
 	timekeeper.ntp_error += tick_length << shift;
-- 
1.7.3.2.146.gca209

