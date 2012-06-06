Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab2FFMAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 08:00:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37994 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2FFMAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 08:00:40 -0400
Date: Wed, 6 Jun 2012 05:00:24 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-99d5f3aac674fe081ffddd2dbb8946ccbc14c410@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fweisbec@gmail.com, peterz@infradead.org, tglx@linutronix.de,
        gilad@benyossef.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, peterz@infradead.org, tglx@linutronix.de,
        gilad@benyossef.com
In-Reply-To: <20120525214819.236377028@linutronix.de>
References: <20120525214819.236377028@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timers: Add accounting of non deferrable timers
Git-Commit-ID: 99d5f3aac674fe081ffddd2dbb8946ccbc14c410
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 05:00:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  99d5f3aac674fe081ffddd2dbb8946ccbc14c410
Gitweb:     http://git.kernel.org/tip/99d5f3aac674fe081ffddd2dbb8946ccbc14c410
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 25 May 2012 22:08:58 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 6 Jun 2012 13:49:01 +0200

timers: Add accounting of non deferrable timers

The code in get_next_timer_interrupt() is suboptimal as it has to run
through the cascade to find the next expiring timer. On a completely
idle core we should only do that when there is an active timer
enqueued and base->next_timer does not give us a fast answer.

Add accounting of the active timers to the now consolidated
attach/detach code. I deliberately avoided sanity checks because the
code is fully symetric and any fiddling with timers w/o using the API
functions will lead to cute explosions anyway. ulong is big enough
even on 32bit and if we really run into the situation to have more
than 1<<32 timers enqueued there, then we are definitely not in a
state to go idle and run through that code.

This allows us to fix another shortcoming of get_next_timer_interrupt().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/20120525214819.236377028@linutronix.de
---
 kernel/timer.c |   31 +++++++++++++++++++++++--------
 1 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 7207690..7fada69 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -77,6 +77,7 @@ struct tvec_base {
 	struct timer_list *running_timer;
 	unsigned long timer_jiffies;
 	unsigned long next_timer;
+	unsigned long active_timers;
 	struct tvec_root tv1;
 	struct tvec tv2;
 	struct tvec tv3;
@@ -377,11 +378,13 @@ static void internal_add_timer(struct tvec_base *base, struct timer_list *timer)
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
@@ -678,6 +681,14 @@ static inline void detach_timer(struct timer_list *timer, bool clear_pending)
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
@@ -685,9 +696,11 @@ static int detach_if_pending(struct timer_list *timer, struct tvec_base *base,
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
 
@@ -1175,7 +1188,7 @@ static inline void __run_timers(struct tvec_base *base)
 			timer_stats_account_timer(timer);
 
 			base->running_timer = timer;
-			detach_timer(timer, true);
+			detach_expired_timer(timer, base);
 
 			spin_unlock_irq(&base->lock);
 			call_timer_fn(timer, fn, data);
@@ -1701,6 +1714,7 @@ static int __cpuinit init_timers_cpu(int cpu)
 
 	base->timer_jiffies = jiffies;
 	base->next_timer = base->timer_jiffies;
+	base->active_timers = 0;
 	return 0;
 }
 
@@ -1711,6 +1725,7 @@ static void migrate_timer_list(struct tvec_base *new_base, struct list_head *hea
 
 	while (!list_empty(head)) {
 		timer = list_first_entry(head, struct timer_list, entry);
+		/* We ignore the accounting on the dying cpu */
 		detach_timer(timer, false);
 		timer_set_base(timer, new_base);
 		internal_add_timer(new_base, timer);
