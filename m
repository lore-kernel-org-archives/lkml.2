Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab1GHFCG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:02:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41780 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980Ab1GHFCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:02:00 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:55 2011
Message-Id: <20110708001655.914680297@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [033/107] clocksource: Make watchdog robust vs. interruption
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

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
@@ -192,6 +192,7 @@ struct clocksource {
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
 	/* Watchdog related data, used by the framework */
 	struct list_head wd_list;
+	cycle_t cs_last;
 	cycle_t wd_last;
 #endif
 };
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -185,7 +185,6 @@ static struct clocksource *watchdog;
 static struct timer_list watchdog_timer;
 static DECLARE_WORK(watchdog_work, clocksource_watchdog_work);
 static DEFINE_SPINLOCK(watchdog_lock);
-static cycle_t watchdog_last;
 static int watchdog_running;
 
 static int clocksource_watchdog_kthread(void *data);
@@ -254,11 +253,6 @@ static void clocksource_watchdog(unsigne
 	if (!watchdog_running)
 		goto out;
 
-	wdnow = watchdog->read(watchdog);
-	wd_nsec = clocksource_cyc2ns((wdnow - watchdog_last) & watchdog->mask,
-				     watchdog->mult, watchdog->shift);
-	watchdog_last = wdnow;
-
 	list_for_each_entry(cs, &watchdog_list, wd_list) {
 
 		/* Clocksource already marked unstable? */
@@ -268,19 +262,28 @@ static void clocksource_watchdog(unsigne
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
@@ -318,7 +321,6 @@ static inline void clocksource_start_wat
 		return;
 	init_timer(&watchdog_timer);
 	watchdog_timer.function = clocksource_watchdog;
-	watchdog_last = watchdog->read(watchdog);
 	watchdog_timer.expires = jiffies + WATCHDOG_INTERVAL;
 	add_timer_on(&watchdog_timer, cpumask_first(cpu_online_mask));
 	watchdog_running = 1;


