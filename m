Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab1BAOyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 09:54:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757213Ab1BAOyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 09:54:06 -0500
Date: Tue, 1 Feb 2011 09:50:51 -0500
From: Rik van Riel <riel@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: [PATCH -v8a 4/7] sched: Add yield_to(task, preempt) functionality
Message-ID: <20110201095051.4ddb7738@annuminas.surriel.com>
In-Reply-To: <20110201094433.72829892@annuminas.surriel.com>
References: <20110201094433.72829892@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Galbraith <efault@gmx.de>

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

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2c79e92..6c43fc4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1047,6 +1047,7 @@ struct sched_class {
 	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int flags);
 	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int flags);
 	void (*yield_task) (struct rq *rq);
+	bool (*yield_to_task) (struct rq *rq, struct task_struct *p, bool preempt);
 
 	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int flags);
 
@@ -1943,6 +1944,7 @@ static inline int rt_mutex_getprio(struct task_struct *p)
 # define rt_mutex_adjust_pi(p)		do { } while (0)
 #endif
 
+extern bool yield_to(struct task_struct *p, bool preempt);
 extern void set_user_nice(struct task_struct *p, long nice);
 extern int task_prio(const struct task_struct *p);
 extern int task_nice(const struct task_struct *p);
diff --git a/kernel/sched.c b/kernel/sched.c
index 7ff53e2..bcc1f65 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5270,6 +5270,61 @@ void __sched yield(void)
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
+
+	if (yielded) {
+		schedstat_inc(rq, yld_count);
+		current->sched_class->yield_task(rq);
+	}
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
index bd32d2a..728d3e8 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1794,6 +1794,23 @@ static void yield_task_fair(struct rq *rq)
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
+	return true;
+}
+
 #ifdef CONFIG_SMP
 /**************************************************
  * Fair scheduling class load-balancing methods:
@@ -3987,6 +4004,7 @@ static const struct sched_class fair_sched_class = {
 	.enqueue_task		= enqueue_task_fair,
 	.dequeue_task		= dequeue_task_fair,
 	.yield_task		= yield_task_fair,
+	.yield_to_task		= yield_to_task_fair,
 
 	.check_preempt_curr	= check_preempt_wakeup,
 

