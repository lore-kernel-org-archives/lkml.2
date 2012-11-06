Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296Ab2KFKwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 05:52:07 -0500
Received: from service87.mimecast.com ([91.220.42.44]:38201 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab2KFKwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 05:52:04 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org
Cc: Arvind.Chauhan@arm.com, linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 Resend 4/4] timer: Migrate running timer
Date: Tue,  6 Nov 2012 16:08:46 +0530
Message-Id: <d12b25130db5a8b645929eb93d1cf4ddc2d68826.1352196505.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1352196505.git.viresh.kumar@linaro.org>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1352196505.git.viresh.kumar@linaro.org>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 06 Nov 2012 10:39:00.0389 (UTC) FILETIME=[EEB11550:01CDBC0A]
X-MC-Unique: 112110610390431501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id qA6AqE9Y014413

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

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/timer.h |  2 ++
 kernel/timer.c        | 42 +++++++++++++++++++++++++-----------------
 2 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index 8c5a197..6aa720f 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -22,6 +22,7 @@ struct timer_list {
 	unsigned long data;
 
 	int slack;
+	int sched_del;
 
 #ifdef CONFIG_TIMER_STATS
 	int start_pid;
@@ -77,6 +78,7 @@ extern struct tvec_base boot_tvec_bases;
 		.data = (_data),				\
 		.base = (void *)((unsigned long)&boot_tvec_bases + (_flags)), \
 		.slack = -1,					\
+		.sched_del = 0,					\
 		__TIMER_LOCKDEP_MAP_INITIALIZER(		\
 			__FILE__ ":" __stringify(__LINE__))	\
 	}
diff --git a/kernel/timer.c b/kernel/timer.c
index 1170ece..14e1f76 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -622,6 +622,7 @@ static void do_init_timer(struct timer_list *timer, unsigned int flags,
 	timer->entry.next = NULL;
 	timer->base = (void *)((unsigned long)base | flags);
 	timer->slack = -1;
+	timer->sched_del = 0;
 #ifdef CONFIG_TIMER_STATS
 	timer->start_site = NULL;
 	timer->start_pid = -1;
@@ -729,6 +730,12 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 
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
@@ -746,21 +753,12 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 	new_base = per_cpu(tvec_bases, cpu);
 
 	if (base != new_base) {
-		/*
-		 * We are trying to schedule the timer on the local CPU.
-		 * However we can't change timer's base while it is running,
-		 * otherwise del_timer_sync() can't detect that the timer's
-		 * handler yet has not finished. This also guarantees that
-		 * the timer is serialized wrt itself.
-		 */
-		if (likely(base->running_timer != timer)) {
-			/* See the comment in lock_timer_base() */
-			timer_set_base(timer, NULL);
-			spin_unlock(&base->lock);
-			base = new_base;
-			spin_lock(&base->lock);
-			timer_set_base(timer, base);
-		}
+		/* See the comment in lock_timer_base() */
+		timer_set_base(timer, NULL);
+		spin_unlock(&base->lock);
+		base = new_base;
+		spin_lock(&base->lock);
+		timer_set_base(timer, base);
 	}
 
 	timer->expires = expires;
@@ -1039,9 +1037,11 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
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
@@ -1051,6 +1051,12 @@ int del_timer_sync(struct timer_list *timer)
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
@@ -1058,8 +1064,10 @@ int del_timer_sync(struct timer_list *timer)
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


