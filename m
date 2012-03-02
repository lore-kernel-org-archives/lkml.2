Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965374Ab2CBHNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 02:13:46 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:45100 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964867Ab2CBHNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 02:13:44 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 7/9] time: Convert the timekeeper's wlock to a raw_spin_lock
Date: Thu,  1 Mar 2012 23:12:46 -0800
Message-Id: <1330672368-32290-8-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1330672368-32290-1-git-send-email-john.stultz@linaro.org>
References: <1330672368-32290-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030207-3270-0000-0000-0000047DAD7E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the wlock to raw spin lock.

CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 97982b1..2ceee24 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -81,7 +81,7 @@ static struct timekeeper shadow_tk;
 /* This seqcount serializes readers from updates */
 static seqcount_t timekeeper_rlock;
 /* This spinlock serializes updaters */
-static spinlock_t timekeeper_wlock;
+static raw_spinlock_t timekeeper_wlock;
 
 /*
  * This read-write spinlock protects us from races in SMP while
@@ -236,13 +236,13 @@ void timekeeping_leap_insert(int leapsecond)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&timekeeper_wlock, flags);
+	raw_spin_lock_irqsave(&timekeeper_wlock, flags);
 	write_seqcount_begin(&timekeeper_rlock);
 	timekeeper.xtime_sec += leapsecond;
 	timekeeper.wall_to_monotonic.tv_sec -= leapsecond;
 	timekeeping_update(&timekeeper, false);
 	write_seqcount_end(&timekeeper_rlock);
-	spin_unlock_irqrestore(&timekeeper_wlock, flags);
+	raw_spin_unlock_irqrestore(&timekeeper_wlock, flags);
 
 }
 
@@ -434,7 +434,7 @@ int do_settimeofday(const struct timespec *tv)
 	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
-	spin_lock_irqsave(&timekeeper_wlock, flags);
+	raw_spin_lock_irqsave(&timekeeper_wlock, flags);
 	write_seqcount_begin(&timekeeper_rlock);
 
 	timekeeping_forward_now(&timekeeper);
@@ -451,7 +451,7 @@ int do_settimeofday(const struct timespec *tv)
 	timekeeping_update(&timekeeper, true);
 
 	write_seqcount_end(&timekeeper_rlock);
-	spin_unlock_irqrestore(&timekeeper_wlock, flags);
+	raw_spin_unlock_irqrestore(&timekeeper_wlock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -475,7 +475,7 @@ int timekeeping_inject_offset(struct timespec *ts)
 	if ((unsigned long)ts->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
-	spin_lock_irqsave(&timekeeper_wlock, flags);
+	raw_spin_lock_irqsave(&timekeeper_wlock, flags);
 	write_seqcount_begin(&timekeeper_rlock);
 
 	timekeeping_forward_now(&timekeeper);
@@ -488,7 +488,7 @@ int timekeeping_inject_offset(struct timespec *ts)
 	timekeeping_update(&timekeeper, true);
 
 	write_seqcount_end(&timekeeper_rlock);
-	spin_unlock_irqrestore(&timekeeper_wlock, flags);
+	raw_spin_unlock_irqrestore(&timekeeper_wlock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -649,10 +649,10 @@ void __init timekeeping_init(void)
 	read_boot_clock(&boot);
 
 	seqcount_init(&timekeeper_rlock);
-	spin_lock_init(&timekeeper_wlock);
+	raw_spin_lock_init(&timekeeper_wlock);
 	ntp_init();
 
-	spin_lock_irqsave(&timekeeper_wlock, flags);
+	raw_spin_lock_irqsave(&timekeeper_wlock, flags);
 	write_seqcount_begin(&timekeeper_rlock);
 
 	clock = clocksource_default_clock();
@@ -672,7 +672,7 @@ void __init timekeeping_init(void)
 	timekeeper.total_sleep_time.tv_nsec = 0;
 
 	write_seqcount_end(&timekeeper_rlock);
-	spin_unlock_irqrestore(&timekeeper_wlock, flags);
+	raw_spin_unlock_irqrestore(&timekeeper_wlock, flags);
 
 }
 
@@ -722,7 +722,7 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 	if (!(ts.tv_sec == 0 && ts.tv_nsec == 0))
 		return;
 
-	spin_lock_irqsave(&timekeeper_wlock, flags);
+	raw_spin_lock_irqsave(&timekeeper_wlock, flags);
 	write_seqcount_begin(&timekeeper_rlock);
 
 	timekeeping_forward_now(&timekeeper);
@@ -732,7 +732,7 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 	timekeeping_update(&timekeeper, true);
 
 	write_seqcount_end(&timekeeper_rlock);
-	spin_unlock_irqrestore(&timekeeper_wlock, flags);
+	raw_spin_unlock_irqrestore(&timekeeper_wlock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -755,7 +755,7 @@ static void timekeeping_resume(void)
 
 	clocksource_resume();
 
-	spin_lock_irqsave(&timekeeper_wlock, flags);
+	raw_spin_lock_irqsave(&timekeeper_wlock, flags);
 	write_seqcount_begin(&timekeeper_rlock);
 
 	if (timespec_compare(&ts, &timekeeping_suspend_time) > 0) {
@@ -769,7 +769,7 @@ static void timekeeping_resume(void)
 	timekeeping_suspended = 0;
 
 	write_seqcount_end(&timekeeper_rlock);
-	spin_unlock_irqrestore(&timekeeper_wlock, flags);
+	raw_spin_unlock_irqrestore(&timekeeper_wlock, flags);
 
 	touch_softlockup_watchdog();
 
@@ -787,7 +787,7 @@ static int timekeeping_suspend(void)
 
 	read_persistent_clock(&timekeeping_suspend_time);
 
-	spin_lock_irqsave(&timekeeper_wlock, flags);
+	raw_spin_lock_irqsave(&timekeeper_wlock, flags);
 	write_seqcount_begin(&timekeeper_rlock);
 
 	timekeeping_forward_now(&timekeeper);
@@ -814,7 +814,7 @@ static int timekeeping_suspend(void)
 	}
 
 	write_seqcount_end(&timekeeper_rlock);
-	spin_unlock_irqrestore(&timekeeper_wlock, flags);
+	raw_spin_unlock_irqrestore(&timekeeper_wlock, flags);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
 	clocksource_suspend();
@@ -1070,7 +1070,7 @@ static void update_wall_time(void)
 	unsigned long flags;
 	s64 remainder;
 
-	spin_lock_irqsave(&timekeeper_wlock, flags);
+	raw_spin_lock_irqsave(&timekeeper_wlock, flags);
 
 	/* Make sure we're fully resumed: */
 	if (unlikely(timekeeping_suspended))
@@ -1161,7 +1161,7 @@ static void update_wall_time(void)
 	write_seqcount_end(&timekeeper_rlock);
 
 out:
-	spin_unlock_irqrestore(&timekeeper_wlock, flags);
+	raw_spin_unlock_irqrestore(&timekeeper_wlock, flags);
 
 }
 
-- 
1.7.3.2.146.gca209

