Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab1KOEEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 23:04:23 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:33517 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455Ab1KOEEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 23:04:22 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 01/16] time: Move total_sleep_time into the timekeeper structure
Date: Mon, 14 Nov 2011 20:03:51 -0800
Message-Id: <1321329846-14755-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
References: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
x-cbid: 11111504-8974-0000-0000-000002145753
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move total_sleep_time into the timekeeper structure in preparation
for locking cleanups

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 2b021b0e..bd8e7fd 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -47,6 +47,10 @@ struct timekeeper {
 	int	ntp_error_shift;
 	/* NTP adjusted clock multiplier */
 	u32	mult;
+
+	/* time spent in suspend */
+	struct timespec total_sleep_time;
+
 };
 
 static struct timekeeper timekeeper;
@@ -159,7 +163,6 @@ __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
  */
 static struct timespec xtime __attribute__ ((aligned (16)));
 static struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
-static struct timespec total_sleep_time;
 
 /*
  * The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock.
@@ -587,8 +590,8 @@ void __init timekeeping_init(void)
 	}
 	set_normalized_timespec(&wall_to_monotonic,
 				-boot.tv_sec, -boot.tv_nsec);
-	total_sleep_time.tv_sec = 0;
-	total_sleep_time.tv_nsec = 0;
+	timekeeper.total_sleep_time.tv_sec = 0;
+	timekeeper.total_sleep_time.tv_nsec = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 }
 
@@ -612,7 +615,8 @@ static void __timekeeping_inject_sleeptime(struct timespec *delta)
 
 	xtime = timespec_add(xtime, *delta);
 	wall_to_monotonic = timespec_sub(wall_to_monotonic, *delta);
-	total_sleep_time = timespec_add(total_sleep_time, *delta);
+	timekeeper.total_sleep_time = timespec_add(
+					timekeeper.total_sleep_time, *delta);
 }
 
 
@@ -984,8 +988,10 @@ static void update_wall_time(void)
 void getboottime(struct timespec *ts)
 {
 	struct timespec boottime = {
-		.tv_sec = wall_to_monotonic.tv_sec + total_sleep_time.tv_sec,
-		.tv_nsec = wall_to_monotonic.tv_nsec + total_sleep_time.tv_nsec
+		.tv_sec = wall_to_monotonic.tv_sec +
+				timekeeper.total_sleep_time.tv_sec,
+		.tv_nsec = wall_to_monotonic.tv_nsec +
+				timekeeper.total_sleep_time.tv_nsec
 	};
 
 	set_normalized_timespec(ts, -boottime.tv_sec, -boottime.tv_nsec);
@@ -1014,7 +1020,7 @@ void get_monotonic_boottime(struct timespec *ts)
 		seq = read_seqbegin(&xtime_lock);
 		*ts = xtime;
 		tomono = wall_to_monotonic;
-		sleep = total_sleep_time;
+		sleep = timekeeper.total_sleep_time;
 		nsecs = timekeeping_get_ns();
 
 	} while (read_seqretry(&xtime_lock, seq));
@@ -1047,7 +1053,7 @@ EXPORT_SYMBOL_GPL(ktime_get_boottime);
  */
 void monotonic_to_bootbased(struct timespec *ts)
 {
-	*ts = timespec_add(*ts, total_sleep_time);
+	*ts = timespec_add(*ts, timekeeper.total_sleep_time);
 }
 EXPORT_SYMBOL_GPL(monotonic_to_bootbased);
 
@@ -1122,7 +1128,7 @@ void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
 		seq = read_seqbegin(&xtime_lock);
 		*xtim = xtime;
 		*wtom = wall_to_monotonic;
-		*sleep = total_sleep_time;
+		*sleep = timekeeper.total_sleep_time;
 	} while (read_seqretry(&xtime_lock, seq));
 }
 
-- 
1.7.3.2.146.gca209

