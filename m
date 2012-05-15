Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965046Ab2EOC5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:57:10 -0400
Received: from mail.windriver.com ([147.11.1.11]:49551 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965001Ab2EOCRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:04 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 079/179] clocksource: Make watchdog robust vs. interruption
Date: Mon, 14 May 2012 22:12:55 -0400
Message-ID: <1337048075-6132-80-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit b5199515c25cca622495eb9c6a8a1d275e775088 upstream.

The clocksource watchdog code is interruptible and it has been
observed that this can trigger false positives which disable the TSC.

The reason is that an interrupt storm or a long running interrupt
handler between the read of the watchdog source and the read of the
TSC brings the two far enough apart that the delta is larger than the
unstable treshold. Move both reads into a short interrupt disabled
region to avoid that.

Reported-and-tested-by: Vernon Mauery <vernux@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/clocksource.h |    1 +
 kernel/time/clocksource.c   |   24 +++++++++++++-----------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 4bca8b6..f99e32b 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -192,6 +192,7 @@ struct clocksource {
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
 	/* Watchdog related data, used by the framework */
 	struct list_head wd_list;
+	cycle_t cs_last;
 	cycle_t wd_last;
 #endif
 };
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index db24c5c..8569f91 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -184,7 +184,6 @@ static struct clocksource *watchdog;
 static struct timer_list watchdog_timer;
 static DECLARE_WORK(watchdog_work, clocksource_watchdog_work);
 static DEFINE_SPINLOCK(watchdog_lock);
-static cycle_t watchdog_last;
 static int watchdog_running;
 
 static int clocksource_watchdog_kthread(void *data);
@@ -253,11 +252,6 @@ static void clocksource_watchdog(unsigned long data)
 	if (!watchdog_running)
 		goto out;
 
-	wdnow = watchdog->read(watchdog);
-	wd_nsec = clocksource_cyc2ns((wdnow - watchdog_last) & watchdog->mask,
-				     watchdog->mult, watchdog->shift);
-	watchdog_last = wdnow;
-
 	list_for_each_entry(cs, &watchdog_list, wd_list) {
 
 		/* Clocksource already marked unstable? */
@@ -267,19 +261,28 @@ static void clocksource_watchdog(unsigned long data)
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
@@ -317,7 +320,6 @@ static inline void clocksource_start_watchdog(void)
 		return;
 	init_timer(&watchdog_timer);
 	watchdog_timer.function = clocksource_watchdog;
-	watchdog_last = watchdog->read(watchdog);
 	watchdog_timer.expires = jiffies + WATCHDOG_INTERVAL;
 	add_timer_on(&watchdog_timer, cpumask_first(cpu_online_mask));
 	watchdog_running = 1;
-- 
1.7.9.6

