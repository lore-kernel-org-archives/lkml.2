Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934221Ab2EYWJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:09:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:40145 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932781Ab2EYWI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:08:59 -0400
Message-Id: <20120525214819.189946224@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 May 2012 22:08:57 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [patch 2/4] timers: Consolidate base->next_timer update
References: <20120525214617.051888729@linutronix.de>
Content-Disposition: inline;
 filename=timers-consolidate-base-next-timer-update.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another bunch of mindlessly copied code. All callers of
internal_add_timer() except the recascading code updates
base->next_timer.

Move this into internal_add_timer() and let the cascading code call
__internal_add_timer().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/timer.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

Index: tip/kernel/timer.c
===================================================================
--- tip.orig/kernel/timer.c
+++ tip/kernel/timer.c
@@ -330,7 +330,8 @@ void set_timer_slack(struct timer_list *
 }
 EXPORT_SYMBOL_GPL(set_timer_slack);
 
-static void internal_add_timer(struct tvec_base *base, struct timer_list *timer)
+static void
+__internal_add_timer(struct tvec_base *base, struct timer_list *timer)
 {
 	unsigned long expires = timer->expires;
 	unsigned long idx = expires - base->timer_jiffies;
@@ -372,6 +373,17 @@ static void internal_add_timer(struct tv
 	list_add_tail(&timer->entry, vec);
 }
 
+static void internal_add_timer(struct tvec_base *base, struct timer_list *timer)
+{
+	__internal_add_timer(base, timer);
+	/*
+	 * Update base->next_timer if this is the earliest one.
+	 */
+	if (time_before(timer->expires, base->next_timer) &&
+	    !tbase_get_deferrable(timer->base))
+		base->next_timer = timer->expires;
+}
+
 #ifdef CONFIG_TIMER_STATS
 void __timer_stats_timer_set_start_info(struct timer_list *timer, void *addr)
 {
@@ -757,9 +769,6 @@ __mod_timer(struct timer_list *timer, un
 	}
 
 	timer->expires = expires;
-	if (time_before(timer->expires, base->next_timer) &&
-	    !tbase_get_deferrable(timer->base))
-		base->next_timer = timer->expires;
 	internal_add_timer(base, timer);
 
 out_unlock:
@@ -925,9 +934,6 @@ void add_timer_on(struct timer_list *tim
 	spin_lock_irqsave(&base->lock, flags);
 	timer_set_base(timer, base);
 	debug_activate(timer, timer->expires);
-	if (time_before(timer->expires, base->next_timer) &&
-	    !tbase_get_deferrable(timer->base))
-		base->next_timer = timer->expires;
 	internal_add_timer(base, timer);
 	/*
 	 * Check whether the other CPU is idle and needs to be
@@ -1079,7 +1085,8 @@ static int cascade(struct tvec_base *bas
 	 */
 	list_for_each_entry_safe(timer, tmp, &tv_list, entry) {
 		BUG_ON(tbase_get_base(timer->base) != base);
-		internal_add_timer(base, timer);
+		/* No accounting, while moving them */
+		__internal_add_timer(base, timer);
 	}
 
 	return index;
@@ -1706,9 +1713,6 @@ static void migrate_timer_list(struct tv
 		timer = list_first_entry(head, struct timer_list, entry);
 		detach_timer(timer, false);
 		timer_set_base(timer, new_base);
-		if (time_before(timer->expires, new_base->next_timer) &&
-		    !tbase_get_deferrable(timer->base))
-			new_base->next_timer = timer->expires;
 		internal_add_timer(new_base, timer);
 	}
 }


