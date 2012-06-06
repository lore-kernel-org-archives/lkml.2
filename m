Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab2FFL7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 07:59:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37970 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2FFL7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 07:59:50 -0400
Date: Wed, 6 Jun 2012 04:59:32 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-facbb4a7efbd658046bf615f03cd97a1504785d8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fweisbec@gmail.com, peterz@infradead.org, tglx@linutronix.de,
        gilad@benyossef.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, peterz@infradead.org, tglx@linutronix.de,
        gilad@benyossef.com
In-Reply-To: <20120525214819.189946224@linutronix.de>
References: <20120525214819.189946224@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timers: Consolidate base->next_timer update
Git-Commit-ID: facbb4a7efbd658046bf615f03cd97a1504785d8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 04:59:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  facbb4a7efbd658046bf615f03cd97a1504785d8
Gitweb:     http://git.kernel.org/tip/facbb4a7efbd658046bf615f03cd97a1504785d8
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 25 May 2012 22:08:57 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 6 Jun 2012 13:49:01 +0200

timers: Consolidate base->next_timer update

Another bunch of mindlessly copied code. All callers of
internal_add_timer() except the recascading code updates
base->next_timer.

Move this into internal_add_timer() and let the cascading code call
__internal_add_timer().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/20120525214819.189946224@linutronix.de
---
 kernel/timer.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 0f70deb..7207690 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -330,7 +330,8 @@ void set_timer_slack(struct timer_list *timer, int slack_hz)
 }
 EXPORT_SYMBOL_GPL(set_timer_slack);
 
-static void internal_add_timer(struct tvec_base *base, struct timer_list *timer)
+static void
+__internal_add_timer(struct tvec_base *base, struct timer_list *timer)
 {
 	unsigned long expires = timer->expires;
 	unsigned long idx = expires - base->timer_jiffies;
@@ -372,6 +373,17 @@ static void internal_add_timer(struct tvec_base *base, struct timer_list *timer)
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
@@ -757,9 +769,6 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 	}
 
 	timer->expires = expires;
-	if (time_before(timer->expires, base->next_timer) &&
-	    !tbase_get_deferrable(timer->base))
-		base->next_timer = timer->expires;
 	internal_add_timer(base, timer);
 
 out_unlock:
@@ -925,9 +934,6 @@ void add_timer_on(struct timer_list *timer, int cpu)
 	spin_lock_irqsave(&base->lock, flags);
 	timer_set_base(timer, base);
 	debug_activate(timer, timer->expires);
-	if (time_before(timer->expires, base->next_timer) &&
-	    !tbase_get_deferrable(timer->base))
-		base->next_timer = timer->expires;
 	internal_add_timer(base, timer);
 	/*
 	 * Check whether the other CPU is idle and needs to be
@@ -1079,7 +1085,8 @@ static int cascade(struct tvec_base *base, struct tvec *tv, int index)
 	 */
 	list_for_each_entry_safe(timer, tmp, &tv_list, entry) {
 		BUG_ON(tbase_get_base(timer->base) != base);
-		internal_add_timer(base, timer);
+		/* No accounting, while moving them */
+		__internal_add_timer(base, timer);
 	}
 
 	return index;
@@ -1706,9 +1713,6 @@ static void migrate_timer_list(struct tvec_base *new_base, struct list_head *hea
 		timer = list_first_entry(head, struct timer_list, entry);
 		detach_timer(timer, false);
 		timer_set_base(timer, new_base);
-		if (time_before(timer->expires, new_base->next_timer) &&
-		    !tbase_get_deferrable(timer->base))
-			new_base->next_timer = timer->expires;
 		internal_add_timer(new_base, timer);
 	}
 }
