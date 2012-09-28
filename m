Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331Ab2I1Roo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 13:44:44 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37681 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab2I1Ron (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 13:44:43 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de, linux-kernel@vger.kernel.org
Cc: pjt@google.com, paul.mckenney@linaro.org, tj@kernel.org,
        suresh.b.siddha@intel.com, venki@google.com, mingo@redhat.com,
        peterz@infradead.org, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Arvind.Chauhan@arm.com, amit.kucheria@linaro.org,
        vincent.guittot@linaro.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [RFC] timer: Migrate running timer
Date: Fri, 28 Sep 2012 23:14:29 +0530
Message-Id: <72a0df374d6e1da3b55071030e38354f7d64b604.1348854133.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

I haven't tested it much till now. I am sending this patch just to check if the
initial idea looks fine to you guys or not.

Till now, we weren't migrating a running timer because with migration
del_timer_sync() can't detect that the timer's handler yet has not finished.

Now, when can we actually to reach to the code (inside __mod_timer()) where

base->running_timer == timer ? i.e. We are trying to migrate current timer

I can see only following case:
- Timer re-armed itself. i.e. Currently we are running interrupt handler of a
  timer and it rearmed itself from there. At this time user might have called
  del_timer_sync() or not. If not, then there is no harm in re-arming the timer?

Now, when somebody tries to delete a timer, obviously he doesn't want to run it
any more for now. So, why should we ever re-arm a timer, which is scheduled for
deletion?

This patch tries to fix "migration of running timer", assuming above theory is
correct :)

So, now when we get a call to del_timer_sync(), we will mark it scheduled for
deletion in an additional variable. This would be checked whenever we try to
modify/arm it again. If it was currently scheduled for deletion, we must not
modify/arm it.

And so, whenever we reach to the situation where:
base->running_timer == timer

We are sure, nobody is waiting in del_timer_sync().

We will clear this flag as soon as the timer is deleted, so that it can be
started again after deleting it successfully.

Waiting for initial comments on it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/timer.h |  1 +
 kernel/timer.c        | 58 +++++++++++++++++++++++++++++----------------------
 2 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index 8c5a197..ea36ce9 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -22,6 +22,7 @@ struct timer_list {
 	unsigned long data;
 
 	int slack;
+	int sched_del;
 
 #ifdef CONFIG_TIMER_STATS
 	int start_pid;
diff --git a/kernel/timer.c b/kernel/timer.c
index 1cf8a91..536e7a3 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -620,6 +620,7 @@ static void do_init_timer(struct timer_list *timer, unsigned int flags,
 	timer->entry.next = NULL;
 	timer->base = (void *)((unsigned long)base | flags);
 	timer->slack = -1;
+	timer->sched_del = 0;
 #ifdef CONFIG_TIMER_STATS
 	timer->start_site = NULL;
 	timer->start_pid = -1;
@@ -727,38 +728,35 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 
 	base = lock_timer_base(timer, &flags);
 
+	if (timer->sched_del) {
+		/* Don't schedule it again, as it is getting deleted */
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
 	ret = detach_if_pending(timer, base, false);
 	if (!ret && pending_only)
 		goto out_unlock;
 
 	debug_activate(timer, expires);
 
-	/*
-	 * Should we try to migrate timer?
-	 * However we can't change timer's base while it is running, otherwise
-	 * del_timer_sync() can't detect that the timer's handler yet has not
-	 * finished. This also guarantees that the timer is serialized wrt
-	 * itself.
-	 */
-	if (likely(base->running_timer != timer)) {
 #if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
-		if (!pinned && get_sysctl_timer_migration())
-			cpu = get_nohz_timer_target();
-		else
-			cpu = smp_processor_id();
-#else
+	if (!pinned && get_sysctl_timer_migration())
+		cpu = get_nohz_timer_target();
+	else
 		cpu = smp_processor_id();
+#else
+	cpu = smp_processor_id();
 #endif
-		new_base = per_cpu(tvec_bases, cpu);
-
-		if (base != new_base) {
-			/* See the comment in lock_timer_base() */
-			timer_set_base(timer, NULL);
-			spin_unlock(&base->lock);
-			base = new_base;
-			spin_lock(&base->lock);
-			timer_set_base(timer, base);
-		}
+	new_base = per_cpu(tvec_bases, cpu);
+
+	if (base != new_base) {
+		/* See the comment in lock_timer_base() */
+		timer_set_base(timer, NULL);
+		spin_unlock(&base->lock);
+		base = new_base;
+		spin_lock(&base->lock);
+		timer_set_base(timer, base);
 	}
 
 	timer->expires = expires;
@@ -1037,9 +1035,11 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
  */
 int del_timer_sync(struct timer_list *timer)
 {
-#ifdef CONFIG_LOCKDEP
+	struct tvec_base *base;
 	unsigned long flags;
 
+#ifdef CONFIG_LOCKDEP
+
 	/*
 	 * If lockdep gives a backtrace here, please reference
 	 * the synchronization rules above.
@@ -1049,6 +1049,12 @@ int del_timer_sync(struct timer_list *timer)
 	lock_map_release(&timer->lockdep_map);
 	local_irq_restore(flags);
 #endif
+
+	/* Timer is scheduled for deletion, don't let it re-arm itself */
+	base = lock_timer_base(timer, &flags);
+	timer->sched_del = 1;
+	spin_unlock_irqrestore(&base->lock, flags);
+
 	/*
 	 * don't use it in hardirq context, because it
 	 * could lead to deadlock.
@@ -1056,8 +1062,10 @@ int del_timer_sync(struct timer_list *timer)
 	WARN_ON(in_irq() && !tbase_get_irqsafe(timer->base));
 	for (;;) {
 		int ret = try_to_del_timer_sync(timer);
-		if (ret >= 0)
+		if (ret >= 0) {
+			timer->sched_del = 0;
 			return ret;
+		}
 		cpu_relax();
 	}
 }
-- 
1.7.12.rc2.18.g61b472e

