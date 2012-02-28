Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab2B1A3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:29:50 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:34241 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab2B1A3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:29:48 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 7/7] time: Convert the timekeeper's wlock to a raw_spin_lock
Date: Mon, 27 Feb 2012 16:29:34 -0800
Message-Id: <1330388974-27793-8-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1330388974-27793-1-git-send-email-john.stultz@linaro.org>
References: <1330388974-27793-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022800-3270-0000-0000-0000045FC4FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the wlock to raw spin lock.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 5a444b8..0a4decb 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -74,7 +74,7 @@ struct timekeeper {
 
 	/* locks for timekeeper structure */
 	seqcount_t rlock;   /* This seqcount serializes readers from updates */
-	spinlock_t wlock;	/* This spinlock serializes updaters */
+	raw_spinlock_t wlock;	/* This spinlock serializes updaters */
 };
 
 static struct timekeeper timekeeper;
@@ -225,13 +225,13 @@ void timekeeping_leap_insert(int leapsecond)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&timekeeper.wlock, flags);
+	raw_spin_lock_irqsave(&timekeeper.wlock, flags);
 	write_seqcount_begin(&timekeeper.rlock);
 	timekeeper.xtime_sec += leapsecond;
 	timekeeper.wall_to_monotonic.tv_sec -= leapsecond;
 	timekeeping_update(&timekeeper, false);
 	write_seqcount_end(&timekeeper.rlock);
-	spin_unlock_irqrestore(&timekeeper.wlock, flags);
+	raw_spin_unlock_irqrestore(&timekeeper.wlock, flags);
 
 }
 
@@ -423,7 +423,7 @@ int do_settimeofday(const struct timespec *tv)
 	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
-	spin_lock_irqsave(&timekeeper.wlock, flags);
+	raw_spin_lock_irqsave(&timekeeper.wlock, flags);
 	write_seqcount_begin(&timekeeper.rlock);
 
 	timekeeping_forward_now();
@@ -440,7 +440,7 @@ int do_settimeofday(const struct timespec *tv)
 	timekeeping_update(&timekeeper, true);
 
 	write_seqcount_end(&timekeeper.rlock);
-	spin_unlock_irqrestore(&timekeeper.wlock, flags);
+	raw_spin_unlock_irqrestore(&timekeeper.wlock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -464,7 +464,7 @@ int timekeeping_inject_offset(struct timespec *ts)
 	if ((unsigned long)ts->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
-	spin_lock_irqsave(&timekeeper.wlock, flags);
+	raw_spin_lock_irqsave(&timekeeper.wlock, flags);
 	write_seqcount_begin(&timekeeper.rlock);
 
 	timekeeping_forward_now();
@@ -477,7 +477,7 @@ int timekeeping_inject_offset(struct timespec *ts)
 	timekeeping_update(&timekeeper, true);
 
 	write_seqcount_end(&timekeeper.rlock);
-	spin_unlock_irqrestore(&timekeeper.wlock, flags);
+	raw_spin_unlock_irqrestore(&timekeeper.wlock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -638,10 +638,10 @@ void __init timekeeping_init(void)
 	read_boot_clock(&boot);
 
 	seqcount_init(&timekeeper.rlock);
-	spin_lock_init(&timekeeper.wlock);
+	raw_spin_lock_init(&timekeeper.wlock);
 	ntp_init();
 
-	spin_lock_irqsave(&timekeeper.wlock, flags);
+	raw_spin_lock_irqsave(&timekeeper.wlock, flags);
 	write_seqcount_begin(&timekeeper.rlock);
 
 	clock = clocksource_default_clock();
@@ -661,7 +661,7 @@ void __init timekeeping_init(void)
 	timekeeper.total_sleep_time.tv_nsec = 0;
 
 	write_seqcount_end(&timekeeper.rlock);
-	spin_unlock_irqrestore(&timekeeper.wlock, flags);
+	raw_spin_unlock_irqrestore(&timekeeper.wlock, flags);
 
 }
 
@@ -711,7 +711,7 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 	if (!(ts.tv_sec == 0 && ts.tv_nsec == 0))
 		return;
 
-	spin_lock_irqsave(&timekeeper.wlock, flags);
+	raw_spin_lock_irqsave(&timekeeper.wlock, flags);
 	write_seqcount_begin(&timekeeper.rlock);
 
 	timekeeping_forward_now();
@@ -721,7 +721,7 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 	timekeeping_update(&timekeeper, true);
 
 	write_seqcount_end(&timekeeper.rlock);
-	spin_unlock_irqrestore(&timekeeper.wlock, flags);
+	raw_spin_unlock_irqrestore(&timekeeper.wlock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -744,7 +744,7 @@ static void timekeeping_resume(void)
 
 	clocksource_resume();
 
-	spin_lock_irqsave(&timekeeper.wlock, flags);
+	raw_spin_lock_irqsave(&timekeeper.wlock, flags);
 	write_seqcount_begin(&timekeeper.rlock);
 
 	if (timespec_compare(&ts, &timekeeping_suspend_time) > 0) {
@@ -758,7 +758,7 @@ static void timekeeping_resume(void)
 	timekeeping_suspended = 0;
 
 	write_seqcount_end(&timekeeper.rlock);
-	spin_unlock_irqrestore(&timekeeper.wlock, flags);
+	raw_spin_unlock_irqrestore(&timekeeper.wlock, flags);
 
 	touch_softlockup_watchdog();
 
@@ -776,7 +776,7 @@ static int timekeeping_suspend(void)
 
 	read_persistent_clock(&timekeeping_suspend_time);
 
-	spin_lock_irqsave(&timekeeper.wlock, flags);
+	raw_spin_lock_irqsave(&timekeeper.wlock, flags);
 	write_seqcount_begin(&timekeeper.rlock);
 
 	timekeeping_forward_now();
@@ -804,7 +804,7 @@ static int timekeeping_suspend(void)
 	}
 
 	write_seqcount_end(&timekeeper.rlock);
-	spin_unlock_irqrestore(&timekeeper.wlock, flags);
+	raw_spin_unlock_irqrestore(&timekeeper.wlock, flags);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
 	clocksource_suspend();
@@ -1061,7 +1061,7 @@ static void update_wall_time(void)
 	unsigned long flags;
 	s64 remainder;
 
-	spin_lock_irqsave(&timekeeper.wlock, flags);
+	raw_spin_lock_irqsave(&timekeeper.wlock, flags);
 
 	/* Make sure we're fully resumed: */
 	if (unlikely(timekeeping_suspended))
@@ -1156,7 +1156,7 @@ static void update_wall_time(void)
 	write_seqcount_end(&timekeeper.rlock);
 
 out:
-	spin_unlock_irqrestore(&timekeeper.wlock, flags);
+	raw_spin_unlock_irqrestore(&timekeeper.wlock, flags);
 
 }
 
-- 
1.7.3.2.146.gca209

