Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab1BAT7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 14:59:38 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:33581 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab1BAT7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 14:59:36 -0500
Subject: [Patch RFC -RT ] Convert clocksource to High Res Timer
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Reply-To: will_schmidt@vnet.ibm.com
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        john stultz <jstultz@us.ibm.com>
Cc: pacman <pacman@us.ibm.com>, Will Schmidt <willschm@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Tue, 01 Feb 2011 13:59:32 -0600
Message-ID: <1296590372.3008.202.camel@lexx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Update the clocksource code to use (higher priority) high-res-timers
instead of a (lower priority) jiffies based timer.  

This addresses some of the problems seen in Real-Time environments where
a high priority user-space application consumes CPU time such that the
TSC clocksource is starved and ultimately disabled due to "unstable
clocksource" conditions being met.  Converting the clocksource code to
use hrtimers moves the dependence on lower priority softirqs to higher
priority hrtimers, allowing the clocksource better stability.

This patch has been tested against 2.6.33.7-rt* patch series.  

Signed-off-by: Will Schmidt <will_schmidt@vnet.ibm.com>
CC: John Stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Paul Clarke <pacman@us.ibm.com>

--


diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 0e98497..eb188a6 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -181,7 +181,7 @@ static void clocksource_watchdog_work(struct work_struct *work);
 
 static LIST_HEAD(watchdog_list);
 static struct clocksource *watchdog;
-static struct timer_list watchdog_timer;
+static struct hrtimer hr_watchdog_timer;
 static DECLARE_WORK(watchdog_work, clocksource_watchdog_work);
 static DEFINE_SPINLOCK(watchdog_lock);
 static cycle_t watchdog_last;
@@ -195,6 +195,7 @@ static void __clocksource_change_rating(struct clocksource *cs, int rating);
  */
 #define WATCHDOG_INTERVAL (HZ >> 1)
 #define WATCHDOG_THRESHOLD (NSEC_PER_SEC >> 4)
+#define HR_WATCHDOG_INTERVAL (NSEC_PER_SEC/2)
 
 static void clocksource_watchdog_work(struct work_struct *work)
 {
@@ -242,8 +243,9 @@ void clocksource_mark_unstable(struct clocksource *cs)
 	spin_unlock_irqrestore(&watchdog_lock, flags);
 }
 
-static void clocksource_watchdog(unsigned long data)
+static enum hrtimer_restart clocksource_watchdog(unsigned long data)
 {
+	enum hrtimer_restart ret = HRTIMER_NORESTART;
 	struct clocksource *cs;
 	cycle_t csnow, wdnow;
 	int64_t wd_nsec, cs_nsec;
@@ -305,21 +307,26 @@ static void clocksource_watchdog(unsigned long data)
 	next_cpu = cpumask_next(raw_smp_processor_id(), cpu_online_mask);
 	if (next_cpu >= nr_cpu_ids)
 		next_cpu = cpumask_first(cpu_online_mask);
-	watchdog_timer.expires += WATCHDOG_INTERVAL;
-	add_timer_on(&watchdog_timer, next_cpu);
+	hrtimer_add_expires(&hr_watchdog_timer, ktime_set(0,HR_WATCHDOG_INTERVAL));
+	ret = HRTIMER_RESTART;
 out:
 	spin_unlock(&watchdog_lock);
+	return ret;
 }
 
 static inline void clocksource_start_watchdog(void)
 {
+	ktime_t delta;
+
 	if (watchdog_running || !watchdog || list_empty(&watchdog_list))
 		return;
-	init_timer(&watchdog_timer);
-	watchdog_timer.function = clocksource_watchdog;
+	hrtimer_init(&hr_watchdog_timer,
+		CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+	hr_watchdog_timer.function = clocksource_watchdog;
 	watchdog_last = watchdog->read(watchdog);
-	watchdog_timer.expires = jiffies + WATCHDOG_INTERVAL;
-	add_timer_on(&watchdog_timer, cpumask_first(cpu_online_mask));
+	delta = ktime_set(0, HR_WATCHDOG_INTERVAL);
+	hrtimer_start(&hr_watchdog_timer, ktime_add(
+		ktime_get(), delta), HRTIMER_MODE_ABS);
 	watchdog_running = 1;
 }
 
@@ -327,7 +334,7 @@ static inline void clocksource_stop_watchdog(void)
 {
 	if (!watchdog_running || (watchdog && !list_empty(&watchdog_list)))
 		return;
-	del_timer(&watchdog_timer);
+	hrtimer_cancel(&hr_watchdog_timer);
 	watchdog_running = 0;
 }
 



