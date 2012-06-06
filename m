Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab2FFL7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 07:59:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37960 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2FFL7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 07:59:10 -0400
Date: Wed, 6 Jun 2012 04:58:39 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-ec44bc7acc3687ba6ae8154b4b5a845b70279237@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fweisbec@gmail.com, peterz@infradead.org, tglx@linutronix.de,
        gilad@benyossef.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, peterz@infradead.org, tglx@linutronix.de,
        gilad@benyossef.com
In-Reply-To: <20120525214819.131246037@linutronix.de>
References: <20120525214819.131246037@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timers: Create detach_if_pending() and use it
Git-Commit-ID: ec44bc7acc3687ba6ae8154b4b5a845b70279237
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 04:58:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ec44bc7acc3687ba6ae8154b4b5a845b70279237
Gitweb:     http://git.kernel.org/tip/ec44bc7acc3687ba6ae8154b4b5a845b70279237
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 25 May 2012 22:08:57 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 6 Jun 2012 13:49:01 +0200

timers: Create detach_if_pending() and use it

Most callers of detach_timer() have the same pattern around
them. Check whether the timer is pending and eventually updating
base->next_timer.

Create detach_if_pending() and replace the duplicated code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/20120525214819.131246037@linutronix.de

---
 kernel/timer.c |   56 +++++++++++++++++++++++---------------------------------
 1 files changed, 23 insertions(+), 33 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 6ec7e7e..0f70deb 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -654,8 +654,7 @@ void init_timer_deferrable_key(struct timer_list *timer,
 }
 EXPORT_SYMBOL(init_timer_deferrable_key);
 
-static inline void detach_timer(struct timer_list *timer,
-				int clear_pending)
+static inline void detach_timer(struct timer_list *timer, bool clear_pending)
 {
 	struct list_head *entry = &timer->entry;
 
@@ -667,6 +666,19 @@ static inline void detach_timer(struct timer_list *timer,
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
@@ -712,16 +724,9 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 
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
 
@@ -990,19 +989,10 @@ int try_to_del_timer_sync(struct timer_list *timer)
 
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
@@ -1178,7 +1168,7 @@ static inline void __run_timers(struct tvec_base *base)
 			timer_stats_account_timer(timer);
 
 			base->running_timer = timer;
-			detach_timer(timer, 1);
+			detach_timer(timer, true);
 
 			spin_unlock_irq(&base->lock);
 			call_timer_fn(timer, fn, data);
@@ -1714,7 +1704,7 @@ static void migrate_timer_list(struct tvec_base *new_base, struct list_head *hea
 
 	while (!list_empty(head)) {
 		timer = list_first_entry(head, struct timer_list, entry);
-		detach_timer(timer, 0);
+		detach_timer(timer, false);
 		timer_set_base(timer, new_base);
 		if (time_before(timer->expires, new_base->next_timer) &&
 		    !tbase_get_deferrable(timer->base))
