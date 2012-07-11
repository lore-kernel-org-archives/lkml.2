Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307Ab2GKVmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 17:42:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50154 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102Ab2GKVmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 17:42:53 -0400
Date: Wed, 11 Jul 2012 14:42:32 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-5b9fe759a678e05be4937ddf03d50e950207c1c0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, johnstul@us.ibm.com, tglx@linutronix.de,
        prarit@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        prarit@redhat.com
In-Reply-To: <1341960205-56738-4-git-send-email-johnstul@us.ibm.com>
References: <1341960205-56738-4-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] timekeeping:
  Maintain ktime_t based offsets for hrtimers
Git-Commit-ID: 5b9fe759a678e05be4937ddf03d50e950207c1c0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 11 Jul 2012 14:42:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5b9fe759a678e05be4937ddf03d50e950207c1c0
Gitweb:     http://git.kernel.org/tip/5b9fe759a678e05be4937ddf03d50e950207c1c0
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 10 Jul 2012 18:43:21 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 11 Jul 2012 23:34:38 +0200

timekeeping: Maintain ktime_t based offsets for hrtimers

We need to update the hrtimer clock offsets from the hrtimer interrupt
context. To avoid conversions from timespec to ktime_t maintain a
ktime_t based representation of those offsets in the timekeeper. This
puts the conversion overhead into the code which updates the
underlying offsets and provides fast accessible values in the hrtimer
interrupt.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Prarit Bhargava <prarit@redhat.com>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1341960205-56738-4-git-send-email-johnstul@us.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

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
 
 
