Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857Ab2EYWJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:09:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:40148 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934116Ab2EYWI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:08:59 -0400
Message-Id: <20120525214819.236377028@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 May 2012 22:08:58 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [patch 3/4] timers: Add accounting of non deferrable timers
References: <20120525214617.051888729@linutronix.de>
Content-Disposition: inline; filename=timers-add-accounting.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code in get_next_timer_interrupt() is suboptimal as it has to run
through the cascade to find the next expiring timer. On a completely
idle core we should only do that when there is an active timer
enqueued and base->next_timer does not give us an fast answer.

Add accounting of the active timers to the now consolidated
attach/detach code. I deliberately avoided sanity checks because the
code is fully symetric and any fiddling with timers w/o using the API
functions will lead to cute explosions anyway. ulong is big enough
even on 32bit and if we really run into the situation to have more
than 1<<32 timers enqueued there, then we are definitely not in a
state to go idle and run through that code.

This allows us to fix another shortcoming of get_next_timer_interrupt().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/timer.c |   31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

Index: tip/kernel/timer.c
===================================================================
--- tip.orig/kernel/timer.c
+++ tip/kernel/timer.c
@@ -77,6 +77,7 @@ struct tvec_base {
 	struct timer_list *running_timer;
 	unsigned long timer_jiffies;
 	unsigned long next_timer;
+	unsigned long active_timers;
 	struct tvec_root tv1;
 	struct tvec tv2;
 	struct tvec tv3;
@@ -377,11 +378,13 @@ static void internal_add_timer(struct tv
 {
 	__internal_add_timer(base, timer);
 	/*
-	 * Update base->next_timer if this is the earliest one.
+	 * Update base->active_timers and base->next_timer
 	 */
-	if (time_before(timer->expires, base->next_timer) &&
-	    !tbase_get_deferrable(timer->base))
-		base->next_timer = timer->expires;
+	if (!tbase_get_deferrable(timer->base)) {
+		if (time_before(timer->expires, base->next_timer))
+			base->next_timer = timer->expires;
+		base->active_timers++;
+	}
 }
 
 #ifdef CONFIG_TIMER_STATS
@@ -678,6 +681,14 @@ static inline void detach_timer(struct t
 	entry->prev = LIST_POISON2;
 }
 
+static inline void
+detach_expired_timer(struct timer_list *timer, struct tvec_base *base)
+{
+	detach_timer(timer, true);
+	if (!tbase_get_deferrable(timer->base))
+		timer->base->active_timers--;
+}
+
 static int detach_if_pending(struct timer_list *timer, struct tvec_base *base,
 			     bool clear_pending)
 {
@@ -685,9 +696,11 @@ static int detach_if_pending(struct time
 		return 0;
 
 	detach_timer(timer, clear_pending);
-	if (timer->expires == base->next_timer &&
-	    !tbase_get_deferrable(timer->base))
-		base->next_timer = base->timer_jiffies;
+	if (!tbase_get_deferrable(timer->base)) {
+		timer->base->active_timers--;
+		if (timer->expires == base->next_timer)
+			base->next_timer = base->timer_jiffies;
+	}
 	return 1;
 }
 
@@ -1175,7 +1188,7 @@ static inline void __run_timers(struct t
 			timer_stats_account_timer(timer);
 
 			base->running_timer = timer;
-			detach_timer(timer, true);
+			detach_expired_timer(timer, base);
 
 			spin_unlock_irq(&base->lock);
 			call_timer_fn(timer, fn, data);
@@ -1701,6 +1714,7 @@ static int __cpuinit init_timers_cpu(int
 
 	base->timer_jiffies = jiffies;
 	base->next_timer = base->timer_jiffies;
+	base->active_timers = 0;
 	return 0;
 }
 
@@ -1711,6 +1725,7 @@ static void migrate_timer_list(struct tv
 
 	while (!list_empty(head)) {
 		timer = list_first_entry(head, struct timer_list, entry);
+		/* We ignore the accounting on the dying cpu */
 		detach_timer(timer, false);
 		timer_set_base(timer, new_base);
 		internal_add_timer(new_base, timer);


