Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab1BCONL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 09:13:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:35817 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113Ab1BCONI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 09:13:08 -0500
Date: Thu, 3 Feb 2011 14:12:39 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, riel@redhat.com,
        mtosatti@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: riel@redhat.com, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        mtosatti@redhat.com, efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110201095051.4ddb7738@annuminas.surriel.com>
References: <20110201095051.4ddb7738@annuminas.surriel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Add yield_to(task, preempt) functionality
Message-ID: <tip-d95f412200652694e63e64bfd49f0ae274a54479@git.kernel.org>
Git-Commit-ID: d95f412200652694e63e64bfd49f0ae274a54479
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 03 Feb 2011 14:12:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d95f412200652694e63e64bfd49f0ae274a54479
Gitweb:     http://git.kernel.org/tip/d95f412200652694e63e64bfd49f0ae274a54479
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Tue, 1 Feb 2011 09:50:51 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 3 Feb 2011 14:20:33 +0100

sched: Add yield_to(task, preempt) functionality

Currently only implemented for fair class tasks.

Add a yield_to_task method() to the fair scheduling class. allowing the
caller of yield_to() to accelerate another thread in it's thread group,
task group.

Implemented via a scheduler hint, using cfs_rq->next to encourage the
target being selected.  We can rely on pick_next_entity to keep things
fair, so noone can accelerate a thread that has already used its fair
share of CPU time.

This also means callers should only call yield_to when they really
mean it.  Calling it too often can result in the scheduler just
ignoring the hint.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20110201095051.4ddb7738@annuminas.surriel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    2 +
 kernel/sched.c        |   85 +++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_fair.c   |   20 +++++++++++
 3 files changed, 107 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4e9fad2..c88b3bf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1058,6 +1058,7 @@ struct sched_class {
 	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int flags);
 	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int flags);
 	void (*yield_task) (struct rq *rq);
+	bool (*yield_to_task) (struct rq *rq, struct task_struct *p, bool preempt);
 
 	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int flags);
 
@@ -1972,6 +1973,7 @@ static inline int rt_mutex_getprio(struct task_struct *p)
 # define rt_mutex_adjust_pi(p)		do { } while (0)
 #endif
 
+extern bool yield_to(struct task_struct *p, bool preempt);
 extern void set_user_nice(struct task_struct *p, long nice);
 extern int task_prio(const struct task_struct *p);
 extern int task_nice(const struct task_struct *p);
diff --git a/kernel/sched.c b/kernel/sched.c
index ae5e1a1..2effcb7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1686,6 +1686,39 @@ static void double_rq_unlock(struct rq *rq1, struct rq *rq2)
 		__release(rq2->lock);
 }
 
+#else /* CONFIG_SMP */
+
+/*
+ * double_rq_lock - safely lock two runqueues
+ *
+ * Note this does not disable interrupts like task_rq_lock,
+ * you need to do so manually before calling.
+ */
+static void double_rq_lock(struct rq *rq1, struct rq *rq2)
+	__acquires(rq1->lock)
+	__acquires(rq2->lock)
+{
+	BUG_ON(!irqs_disabled());
+	BUG_ON(rq1 != rq2);
+	raw_spin_lock(&rq1->lock);
+	__acquire(rq2->lock);	/* Fake it out ;) */
+}
+
+/*
+ * double_rq_unlock - safely unlock two runqueues
+ *
+ * Note this does not restore interrupts like task_rq_unlock,
+ * you need to do so manually after calling.
+ */
+static void double_rq_unlock(struct rq *rq1, struct rq *rq2)
+	__releases(rq1->lock)
+	__releases(rq2->lock)
+{
+	BUG_ON(rq1 != rq2);
+	raw_spin_unlock(&rq1->lock);
+	__release(rq2->lock);
+}
+
 #endif
 
 static void calc_load_account_idle(struct rq *this_rq);
@@ -5448,6 +5481,58 @@ void __sched yield(void)
 }
 EXPORT_SYMBOL(yield);
 
+/**
+ * yield_to - yield the current processor to another thread in
+ * your thread group, or accelerate that thread toward the
+ * processor it's on.
+ *
+ * It's the caller's job to ensure that the target task struct
+ * can't go away on us before we can do any checks.
+ *
+ * Returns true if we indeed boosted the target task.
+ */
+bool __sched yield_to(struct task_struct *p, bool preempt)
+{
+	struct task_struct *curr = current;
+	struct rq *rq, *p_rq;
+	unsigned long flags;
+	bool yielded = 0;
+
+	local_irq_save(flags);
+	rq = this_rq();
+
+again:
+	p_rq = task_rq(p);
+	double_rq_lock(rq, p_rq);
+	while (task_rq(p) != p_rq) {
+		double_rq_unlock(rq, p_rq);
+		goto again;
+	}
+
+	if (!curr->sched_class->yield_to_task)
+		goto out;
+
+	if (curr->sched_class != p->sched_class)
+		goto out;
+
+	if (task_running(p_rq, p) || p->state)
+		goto out;
+
+	yielded = curr->sched_class->yield_to_task(rq, p, preempt);
+	if (yielded)
+		schedstat_inc(rq, yld_count);
+
+out:
+	double_rq_unlock(rq, p_rq);
+	local_irq_restore(flags);
+
+	if (yielded)
+		schedule();
+
+	return yielded;
+}
+EXPORT_SYMBOL_GPL(yield_to);
+
 /*
  * This task is about to go to sleep on IO. Increment rq->nr_iowait so
  * that process accounting knows that this is a task in IO wait state.
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c0fbeb9..0270246 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1975,6 +1975,25 @@ static void yield_task_fair(struct rq *rq)
 	set_skip_buddy(se);
 }
 
+static bool yield_to_task_fair(struct rq *rq, struct task_struct *p, bool preempt)
+{
+	struct sched_entity *se = &p->se;
+
+	if (!se->on_rq)
+		return false;
+
+	/* Tell the scheduler that we'd really like pse to run next. */
+	set_next_buddy(se);
+
+	/* Make p's CPU reschedule; pick_next_entity takes care of fairness. */
+	if (preempt)
+		resched_task(rq->curr);
+
+	yield_task_fair(rq);
+
+	return true;
+}
+
 #ifdef CONFIG_SMP
 /**************************************************
  * Fair scheduling class load-balancing methods:
@@ -4243,6 +4262,7 @@ static const struct sched_class fair_sched_class = {
 	.enqueue_task		= enqueue_task_fair,
 	.dequeue_task		= dequeue_task_fair,
 	.yield_task		= yield_task_fair,
+	.yield_to_task		= yield_to_task_fair,
 
 	.check_preempt_curr	= check_preempt_wakeup,
 
