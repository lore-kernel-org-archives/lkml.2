Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934204Ab2EYWJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:09:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:40140 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934069Ab2EYWI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:08:58 -0400
Message-Id: <20120525214819.131246037@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 May 2012 22:08:57 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [patch 1/4] timers: Create detach_if_pending() and use it
References: <20120525214617.051888729@linutronix.de>
Content-Disposition: inline; filename=timers-create-detach-if-pending.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most callers of detach_timer() have the same pattern around
them. Check whether the timer is pending and eventually updating
base->next_timer.

Create detach_if_pending() and replace the duplicated code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/timer.c |   56 +++++++++++++++++++++++---------------------------------
 1 file changed, 23 insertions(+), 33 deletions(-)

Index: tip/kernel/timer.c
===================================================================
--- tip.orig/kernel/timer.c
+++ tip/kernel/timer.c
@@ -654,8 +654,7 @@ void init_timer_deferrable_key(struct ti
 }
 EXPORT_SYMBOL(init_timer_deferrable_key);
 
-static inline void detach_timer(struct timer_list *timer,
-				int clear_pending)
+static inline void detach_timer(struct timer_list *timer, bool clear_pending)
 {
 	struct list_head *entry = &timer->entry;
 
@@ -667,6 +666,19 @@ static inline void detach_timer(struct t
 	entry->prev = LIST_POISON2;
 }
 
+static int detach_if_pending(struct timer_list *timer, struct tvec_base *base,
+			     bool clear_pending)
+{
+	if (!timer_pending(timer))
+		return 0;
+
+	detach_timer(timer, clear_pending);
+	if (timer->expires == base->next_timer &&
+	    !tbase_get_deferrable(timer->base))
+		base->next_timer = base->timer_jiffies;
+	return 1;
+}
+
 /*
  * We are using hashed locking: holding per_cpu(tvec_bases).lock
  * means that all timers which are tied to this base via timer->base are
@@ -712,16 +724,9 @@ __mod_timer(struct timer_list *timer, un
 
 	base = lock_timer_base(timer, &flags);
 
-	if (timer_pending(timer)) {
-		detach_timer(timer, 0);
-		if (timer->expires == base->next_timer &&
-		    !tbase_get_deferrable(timer->base))
-			base->next_timer = base->timer_jiffies;
-		ret = 1;
-	} else {
-		if (pending_only)
-			goto out_unlock;
-	}
+	ret = detach_if_pending(timer, base, false);
+	if (!ret && pending_only)
+		goto out_unlock;
 
 	debug_activate(timer, expires);
 
@@ -959,13 +964,7 @@ int del_timer(struct timer_list *timer)
 	timer_stats_timer_clear_start_info(timer);
 	if (timer_pending(timer)) {
 		base = lock_timer_base(timer, &flags);
-		if (timer_pending(timer)) {
-			detach_timer(timer, 1);
-			if (timer->expires == base->next_timer &&
-			    !tbase_get_deferrable(timer->base))
-				base->next_timer = base->timer_jiffies;
-			ret = 1;
-		}
+		ret = detach_if_pending(timer, base, true);
 		spin_unlock_irqrestore(&base->lock, flags);
 	}
 
@@ -990,19 +989,10 @@ int try_to_del_timer_sync(struct timer_l
 
 	base = lock_timer_base(timer, &flags);
 
-	if (base->running_timer == timer)
-		goto out;
-
-	timer_stats_timer_clear_start_info(timer);
-	ret = 0;
-	if (timer_pending(timer)) {
-		detach_timer(timer, 1);
-		if (timer->expires == base->next_timer &&
-		    !tbase_get_deferrable(timer->base))
-			base->next_timer = base->timer_jiffies;
-		ret = 1;
+	if (base->running_timer != timer) {
+		timer_stats_timer_clear_start_info(timer);
+		ret = detach_if_pending(timer, base, true);
 	}
-out:
 	spin_unlock_irqrestore(&base->lock, flags);
 
 	return ret;
@@ -1178,7 +1168,7 @@ static inline void __run_timers(struct t
 			timer_stats_account_timer(timer);
 
 			base->running_timer = timer;
-			detach_timer(timer, 1);
+			detach_timer(timer, true);
 
 			spin_unlock_irq(&base->lock);
 			call_timer_fn(timer, fn, data);
@@ -1714,7 +1704,7 @@ static void migrate_timer_list(struct tv
 
 	while (!list_empty(head)) {
 		timer = list_first_entry(head, struct timer_list, entry);
-		detach_timer(timer, 0);
+		detach_timer(timer, false);
 		timer_set_base(timer, new_base);
 		if (time_before(timer->expires, new_base->next_timer) &&
 		    !tbase_get_deferrable(timer->base))


