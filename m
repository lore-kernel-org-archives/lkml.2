Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab1FSIvZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 04:51:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56366 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab1FSIvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 04:51:23 -0400
Date: Sun, 19 Jun 2011 10:51:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer fixes
Message-ID: <20110619085118.GA24512@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-urgent-for-linus

 Thanks,

	Ingo

------------------>
Max Asbock (1):
      timerfd: Fix wakeup of processes when timer is cancelled on clock change

Thomas Gleixner (1):
      clocksource: Make watchdog robust vs. interruption


 fs/timerfd.c                |    5 ++++-
 include/linux/clocksource.h |    1 +
 kernel/time/clocksource.c   |   24 +++++++++++++-----------
 3 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index f67acbd..dffeb37 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -61,7 +61,9 @@ static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr)
 
 /*
  * Called when the clock was set to cancel the timers in the cancel
- * list.
+ * list. This will wake up processes waiting on these timers. The
+ * wake-up requires ctx->ticks to be non zero, therefore we increment
+ * it before calling wake_up_locked().
  */
 void timerfd_clock_was_set(void)
 {
@@ -76,6 +78,7 @@ void timerfd_clock_was_set(void)
 		spin_lock_irqsave(&ctx->wqh.lock, flags);
 		if (ctx->moffs.tv64 != moffs.tv64) {
 			ctx->moffs.tv64 = KTIME_MAX;
+			ctx->ticks++;
 			wake_up_locked(&ctx->wqh);
 		}
 		spin_unlock_irqrestore(&ctx->wqh.lock, flags);
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index d4646b4..18a1baf 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -188,6 +188,7 @@ struct clocksource {
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
 	/* Watchdog related data, used by the framework */
 	struct list_head wd_list;
+	cycle_t cs_last;
 	cycle_t wd_last;
 #endif
 } ____cacheline_aligned;
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 1c95fd6..e0980f0 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -185,7 +185,6 @@ static struct clocksource *watchdog;
 static struct timer_list watchdog_timer;
 static DECLARE_WORK(watchdog_work, clocksource_watchdog_work);
 static DEFINE_SPINLOCK(watchdog_lock);
-static cycle_t watchdog_last;
 static int watchdog_running;
 
 static int clocksource_watchdog_kthread(void *data);
@@ -254,11 +253,6 @@ static void clocksource_watchdog(unsigned long data)
 	if (!watchdog_running)
 		goto out;
 
-	wdnow = watchdog->read(watchdog);
-	wd_nsec = clocksource_cyc2ns((wdnow - watchdog_last) & watchdog->mask,
-				     watchdog->mult, watchdog->shift);
-	watchdog_last = wdnow;
-
 	list_for_each_entry(cs, &watchdog_list, wd_list) {
 
 		/* Clocksource already marked unstable? */
@@ -268,19 +262,28 @@ static void clocksource_watchdog(unsigned long data)
 			continue;
 		}
 
+		local_irq_disable();
 		csnow = cs->read(cs);
+		wdnow = watchdog->read(watchdog);
+		local_irq_enable();
 
 		/* Clocksource initialized ? */
 		if (!(cs->flags & CLOCK_SOURCE_WATCHDOG)) {
 			cs->flags |= CLOCK_SOURCE_WATCHDOG;
-			cs->wd_last = csnow;
+			cs->wd_last = wdnow;
+			cs->cs_last = csnow;
 			continue;
 		}
 
-		/* Check the deviation from the watchdog clocksource. */
-		cs_nsec = clocksource_cyc2ns((csnow - cs->wd_last) &
+		wd_nsec = clocksource_cyc2ns((wdnow - cs->wd_last) & watchdog->mask,
+					     watchdog->mult, watchdog->shift);
+
+		cs_nsec = clocksource_cyc2ns((csnow - cs->cs_last) &
 					     cs->mask, cs->mult, cs->shift);
-		cs->wd_last = csnow;
+		cs->cs_last = csnow;
+		cs->wd_last = wdnow;
+
+		/* Check the deviation from the watchdog clocksource. */
 		if (abs(cs_nsec - wd_nsec) > WATCHDOG_THRESHOLD) {
 			clocksource_unstable(cs, cs_nsec - wd_nsec);
 			continue;
@@ -318,7 +321,6 @@ static inline void clocksource_start_watchdog(void)
 		return;
 	init_timer(&watchdog_timer);
 	watchdog_timer.function = clocksource_watchdog;
-	watchdog_last = watchdog->read(watchdog);
 	watchdog_timer.expires = jiffies + WATCHDOG_INTERVAL;
 	add_timer_on(&watchdog_timer, cpumask_first(cpu_online_mask));
 	watchdog_running = 1;
