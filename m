Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab1G0V4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:56:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:57368 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755691Ab1G0VtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32274775"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: tglx@linutronix.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [68/99] clocksource: Make watchdog robust vs. interruption
Message-Id: <20110727214907.859122403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/clocksource.h |    1 +
 kernel/time/clocksource.c   |   24 +++++++++++++-----------
 2 files changed, 14 insertions(+), 11 deletions(-)

Index: linux-2.6.35.y/include/linux/clocksource.h
===================================================================
--- linux-2.6.35.y.orig/include/linux/clocksource.h
+++ linux-2.6.35.y/include/linux/clocksource.h
@@ -192,6 +192,7 @@ struct clocksource {
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
 	/* Watchdog related data, used by the framework */
 	struct list_head wd_list;
+	cycle_t cs_last;
 	cycle_t wd_last;
 #endif
 };
Index: linux-2.6.35.y/kernel/time/clocksource.c
===================================================================
--- linux-2.6.35.y.orig/kernel/time/clocksource.c
+++ linux-2.6.35.y/kernel/time/clocksource.c
@@ -184,7 +184,6 @@ static struct clocksource *watchdog;
 static struct timer_list watchdog_timer;
 static DECLARE_WORK(watchdog_work, clocksource_watchdog_work);
 static DEFINE_SPINLOCK(watchdog_lock);
-static cycle_t watchdog_last;
 static int watchdog_running;
 
 static int clocksource_watchdog_kthread(void *data);
@@ -253,11 +252,6 @@ static void clocksource_watchdog(unsigne
 	if (!watchdog_running)
 		goto out;
 
-	wdnow = watchdog->read(watchdog);
-	wd_nsec = clocksource_cyc2ns((wdnow - watchdog_last) & watchdog->mask,
-				     watchdog->mult, watchdog->shift);
-	watchdog_last = wdnow;
-
 	list_for_each_entry(cs, &watchdog_list, wd_list) {
 
 		/* Clocksource already marked unstable? */
@@ -267,19 +261,28 @@ static void clocksource_watchdog(unsigne
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
@@ -317,7 +320,6 @@ static inline void clocksource_start_wat
 		return;
 	init_timer(&watchdog_timer);
 	watchdog_timer.function = clocksource_watchdog;
-	watchdog_last = watchdog->read(watchdog);
 	watchdog_timer.expires = jiffies + WATCHDOG_INTERVAL;
 	add_timer_on(&watchdog_timer, cpumask_first(cpu_online_mask));
 	watchdog_running = 1;
