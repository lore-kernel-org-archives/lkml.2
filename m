Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab0LNDss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 22:48:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483Ab0LNDsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 22:48:46 -0500
Date: Mon, 13 Dec 2010 22:46:57 -0500
From: Rik van Riel <riel@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [RFC -v2 PATCH 2/3] sched: add yield_to function
Message-ID: <20101213224657.7e141746@annuminas.surriel.com>
In-Reply-To: <20101213224434.7495edb2@annuminas.surriel.com>
References: <20101213224434.7495edb2@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a yield_to function to the scheduler code, allowing us to
give the remainder of our timeslice to another thread.

We may want to use this to provide a sys_yield_to system call
one day.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
- move to a per sched class yield_to
- fix the locking

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2c79e92..408326f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1086,6 +1086,8 @@ struct sched_class {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	void (*task_move_group) (struct task_struct *p, int on_rq);
 #endif
+
+	void (*yield_to) (struct rq *rq, struct task_struct *p);
 };
 
 struct load_weight {
@@ -1947,6 +1949,7 @@ extern void set_user_nice(struct task_struct *p, long nice);
 extern int task_prio(const struct task_struct *p);
 extern int task_nice(const struct task_struct *p);
 extern int can_nice(const struct task_struct *p, const int nice);
+extern void requeue_task(struct rq *rq, struct task_struct *p);
 extern int task_curr(const struct task_struct *p);
 extern int idle_cpu(int cpu);
 extern int sched_setscheduler(struct task_struct *, int, struct sched_param *);
@@ -2020,6 +2023,10 @@ extern int wake_up_state(struct task_struct *tsk, unsigned int state);
 extern int wake_up_process(struct task_struct *tsk);
 extern void wake_up_new_task(struct task_struct *tsk,
 				unsigned long clone_flags);
+
+extern u64 slice_remain(struct task_struct *);
+extern void yield_to(struct task_struct *);
+
 #ifdef CONFIG_SMP
  extern void kick_process(struct task_struct *tsk);
 #else
diff --git a/kernel/sched.c b/kernel/sched.c
index dc91a4d..6399641 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5166,6 +5166,46 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
 	return ret;
 }
 
+/*
+ * Yield the CPU, giving the remainder of our time slice to task p.
+ * Typically used to hand CPU time to another thread inside the same
+ * process, eg. when p holds a resource other threads are waiting for.
+ * Giving priority to p may help get that resource released sooner.
+ */
+void yield_to(struct task_struct *p)
+{
+	unsigned long flags;
+	struct rq *rq, *p_rq;
+
+	local_irq_save(flags);
+	rq = this_rq();
+again:
+	p_rq = task_rq(p);
+	double_rq_lock(rq, p_rq);
+	if (p_rq != task_rq(p)) {
+		double_rq_unlock(rq, p_rq);
+		goto again;
+	}
+
+	/* We can't yield to a process that doesn't want to run. */
+	if (!p->se.on_rq)
+		goto out;
+
+	/*
+	 * We can only yield to a runnable task, in the same schedule class
+	 * as the current task, if the schedule class implements yield_to_task.
+	 */
+	if (!task_running(rq, p) && current->sched_class == p->sched_class &&
+			current->sched_class->yield_to)
+		current->sched_class->yield_to(rq, p);
+
+out:
+	double_rq_unlock(rq, p_rq);
+	local_irq_restore(flags);
+	yield();
+}
+EXPORT_SYMBOL_GPL(yield_to);
+
 /**
  * sys_sched_yield - yield the current processor to other threads.
  *
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 00ebd76..d8c4116 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -980,6 +980,25 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
  * CFS operations on tasks:
  */
 
+u64 slice_remain(struct task_struct *p)
+{
+	unsigned long flags;
+	struct sched_entity *se = &p->se;
+	struct cfs_rq *cfs_rq;
+	struct rq *rq;
+	u64 slice, ran;
+	s64 delta;
+
+	rq = task_rq_lock(p, &flags);
+	cfs_rq = cfs_rq_of(se);
+	slice = sched_slice(cfs_rq, se);
+	ran = se->sum_exec_runtime - se->prev_sum_exec_runtime;
+	delta = slice - ran;
+	task_rq_unlock(rq, &flags);
+
+	return max(delta, 0LL);
+}
+
 #ifdef CONFIG_SCHED_HRTICK
 static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
 {
@@ -1126,6 +1145,20 @@ static void yield_task_fair(struct rq *rq)
 	se->vruntime = rightmost->vruntime + 1;
 }
 
+static void yield_to_fair(struct rq *rq, struct task_struct *p)
+{
+	struct sched_entity *se = &p->se;
+	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+	u64 remain = slice_remain(current);
+
+	dequeue_task(rq, p, 0);
+	se->vruntime -= remain;
+	if (se->vruntime < cfs_rq->min_vruntime)
+		se->vruntime = cfs_rq->min_vruntime;
+	enqueue_task(rq, p, 0);
+	check_preempt_curr(rq, p, 0);
+}
+
 #ifdef CONFIG_SMP
 
 static void task_waking_fair(struct rq *rq, struct task_struct *p)
@@ -3962,6 +3995,8 @@ static const struct sched_class fair_sched_class = {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	.task_move_group	= task_move_group_fair,
 #endif
+
+	.yield_to		= yield_to_fair,
 };
 
 #ifdef CONFIG_SCHED_DEBUG
