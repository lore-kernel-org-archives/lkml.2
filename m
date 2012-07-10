Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab2GJWnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 18:43:52 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:55116 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689Ab2GJWnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 18:43:49 -0400
From: John Stultz <johnstul@us.ibm.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>, stable@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>
Subject: [PATCH 3/6] timekeeping: Maintain ktime_t based offsets for hrtimers
Date: Tue, 10 Jul 2012 18:43:21 -0400
Message-Id: <1341960205-56738-4-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com>
References: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071022-7606-0000-0000-000001E69AC7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

We need to update the hrtimer clock offsets from the hrtimer interrupt
context. To avoid conversions from timespec to ktime_t maintain a
ktime_t based representation of those offsets in the timekeeper. This
puts the conversion overhead into the code which updates the
underlying offsets and provides fast accessible values in the hrtimer
interrupt.

CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Prarit Bhargava <prarit@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 kernel/time/timekeeping.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index a413e59..1c038da 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -70,6 +70,12 @@ struct timekeeper {
 	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
 	struct timespec raw_time;
 
+	/* Offset clock monotonic -> clock realtime */
+	ktime_t offs_real;
+
+	/* Offset clock monotonic -> clock boottime */
+	ktime_t offs_boot;
+
 	/* Seqlock for all timekeeper values */
 	seqlock_t lock;
 };
@@ -172,6 +178,14 @@ static inline s64 timekeeping_get_ns_raw(void)
 	return clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
 }
 
+static void update_rt_offset(void)
+{
+	struct timespec tmp, *wtm = &timekeeper.wall_to_monotonic;
+
+	set_normalized_timespec(&tmp, -wtm->tv_sec, -wtm->tv_nsec);
+	timekeeper.offs_real = timespec_to_ktime(tmp);
+}
+
 /* must hold write on timekeeper.lock */
 static void timekeeping_update(bool clearntp)
 {
@@ -179,6 +193,7 @@ static void timekeeping_update(bool clearntp)
 		timekeeper.ntp_error = 0;
 		ntp_clear();
 	}
+	update_rt_offset();
 	update_vsyscall(&timekeeper.xtime, &timekeeper.wall_to_monotonic,
 			 timekeeper.clock, timekeeper.mult);
 }
@@ -604,6 +619,7 @@ void __init timekeeping_init(void)
 	}
 	set_normalized_timespec(&timekeeper.wall_to_monotonic,
 				-boot.tv_sec, -boot.tv_nsec);
+	update_rt_offset();
 	timekeeper.total_sleep_time.tv_sec = 0;
 	timekeeper.total_sleep_time.tv_nsec = 0;
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
@@ -612,6 +628,12 @@ void __init timekeeping_init(void)
 /* time in seconds when suspend began */
 static struct timespec timekeeping_suspend_time;
 
+static void update_sleep_time(struct timespec t)
+{
+	timekeeper.total_sleep_time = t;
+	timekeeper.offs_boot = timespec_to_ktime(t);
+}
+
 /**
  * __timekeeping_inject_sleeptime - Internal function to add sleep interval
  * @delta: pointer to a timespec delta value
@@ -630,8 +652,7 @@ static void __timekeeping_inject_sleeptime(struct timespec *delta)
 	timekeeper.xtime = timespec_add(timekeeper.xtime, *delta);
 	timekeeper.wall_to_monotonic =
 			timespec_sub(timekeeper.wall_to_monotonic, *delta);
-	timekeeper.total_sleep_time = timespec_add(
-					timekeeper.total_sleep_time, *delta);
+	update_sleep_time(timespec_add(timekeeper.total_sleep_time, *delta));
 }
 
 
-- 
1.7.9.5

