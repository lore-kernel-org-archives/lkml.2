Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030Ab0LBTpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 14:45:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757877Ab0LBTpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 14:45:42 -0500
Date: Thu, 2 Dec 2010 14:44:23 -0500
From: Rik van Riel <riel@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: [RFC PATCH 2/3] sched: add yield_to function
Message-ID: <20101202144423.3ad1908d@annuminas.surriel.com>
In-Reply-To: <20101202144129.4357fe00@annuminas.surriel.com>
References: <20101202144129.4357fe00@annuminas.surriel.com>
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

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c5f926c..4f3cce9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1985,6 +1985,7 @@ extern void set_user_nice(struct task_struct *p, long nice);
 extern int task_prio(const struct task_struct *p);
 extern int task_nice(const struct task_struct *p);
 extern int can_nice(const struct task_struct *p, const int nice);
+extern void requeue_task(struct rq *rq, struct task_struct *p);
 extern int task_curr(const struct task_struct *p);
 extern int idle_cpu(int cpu);
 extern int sched_setscheduler(struct task_struct *, int, struct sched_param *);
@@ -2058,6 +2059,14 @@ extern int wake_up_state(struct task_struct *tsk, unsigned int state);
 extern int wake_up_process(struct task_struct *tsk);
 extern void wake_up_new_task(struct task_struct *tsk,
 				unsigned long clone_flags);
+
+#ifdef CONFIG_SCHED_HRTICK
+extern u64 slice_remain(struct task_struct *);
+extern void yield_to(struct task_struct *);
+#else
+static inline void yield_to(struct task_struct *p) yield()
+#endif
+
 #ifdef CONFIG_SMP
  extern void kick_process(struct task_struct *tsk);
 #else
diff --git a/kernel/sched.c b/kernel/sched.c
index f8e5a25..ef088cd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1909,6 +1909,26 @@ static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
 	p->se.on_rq = 0;
 }
 
+/**
+ * requeue_task - requeue a task which priority got changed by yield_to
+ * @rq: the tasks's runqueue
+ * @p: the task in question
+ * Must be called with the runqueue lock held. Will cause the CPU to
+ * reschedule if p is now at the head of the runqueue.
+ */
+void requeue_task(struct rq *rq, struct task_struct *p)
+{
+	assert_spin_locked(&rq->lock);
+
+	if (!p->se.on_rq || task_running(rq, p) || task_has_rt_policy(p))
+		return;
+
+	dequeue_task(rq, p, 0);
+	enqueue_task(rq, p, 0);
+
+	resched_task(p);
+}
+
 /*
  * __normal_prio - return the priority that is based on the static prio
  */
@@ -6797,6 +6817,36 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
 	return ret;
 }
 
+#ifdef CONFIG_SCHED_HRTICK
+/*
+ * Yield the CPU, giving the remainder of our time slice to task p.
+ * Typically used to hand CPU time to another thread inside the same
+ * process, eg. when p holds a resource other threads are waiting for.
+ * Giving priority to p may help get that resource released sooner.
+ */
+void yield_to(struct task_struct *p)
+{
+	unsigned long flags;
+	struct sched_entity *se = &p->se;
+	struct rq *rq;
+	struct cfs_rq *cfs_rq;
+	u64 remain = slice_remain(current);
+
+	rq = task_rq_lock(p, &flags);
+	if (task_running(rq, p) || task_has_rt_policy(p))
+		goto out;
+	cfs_rq = cfs_rq_of(se);
+	se->vruntime -= remain;
+	if (se->vruntime < cfs_rq->min_vruntime)
+		se->vruntime = cfs_rq->min_vruntime;
+	requeue_task(rq, p);
+ out:
+	task_rq_unlock(rq, &flags);
+	yield();
+}
+EXPORT_SYMBOL(yield_to);
+#endif
+
 /**
  * sys_sched_yield - yield the current processor to other threads.
  *
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5119b08..2a0a595 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -974,6 +974,25 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
  */
 
 #ifdef CONFIG_SCHED_HRTICK
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
 static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
 {
 	struct sched_entity *se = &p->se;


-- 
All rights reversed.
