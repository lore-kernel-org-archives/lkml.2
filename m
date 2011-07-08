Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab1GIGBc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 02:01:32 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:51523 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752958Ab1GIGB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 02:01:26 -0400
X-Sasl-enc: 80rpa3cocpSF8OK+gcxzNL6E+akasWT3SeN6ei+C4MP/ 1310191285
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Jul  8 16:01:10 2011
Message-Id: <20110708230109.921435561@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 08 Jul 2011 16:00:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [04/35] clocksource: Make watchdog robust vs. interruption
In-Reply-To: <20110708230122.GA18807@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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

---
 include/linux/clocksource.h |    1 +
 kernel/time/clocksource.c   |   24 +++++++++++++-----------
 2 files changed, 14 insertions(+), 11 deletions(-)

--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -190,6 +190,7 @@ struct clocksource {
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
 	/* Watchdog related data, used by the framework */
 	struct list_head wd_list;
+	cycle_t cs_last;
 	cycle_t wd_last;
 #endif
 };
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
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


