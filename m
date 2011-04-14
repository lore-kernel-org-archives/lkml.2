Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758425Ab1DNIfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:35:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:49568 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758352Ab1DNIe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:34:57 -0400
Date: Thu, 14 Apr 2011 08:33:45 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-fd2f4419b4cbe8fe90796df9617c355762afd6a4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        frank.rowand@am.sony.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110405152728.949545047@chello.nl>
References: <20110405152728.949545047@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/locking] sched: Provide p->on_rq
Git-Commit-ID: fd2f4419b4cbe8fe90796df9617c355762afd6a4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Apr 2011 08:33:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd2f4419b4cbe8fe90796df9617c355762afd6a4
Gitweb:     http://git.kernel.org/tip/fd2f4419b4cbe8fe90796df9617c355762afd6a4
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 Apr 2011 17:23:44 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Apr 2011 08:52:35 +0200

sched: Provide p->on_rq

Provide a generic p->on_rq because the p->se.on_rq semantics are
unfavourable for lockless wakeups but needed for sched_fair.

In particular, p->on_rq is only cleared when we actually dequeue the
task in schedule() and not on any random dequeue as done by things
like __migrate_task() and __sched_setscheduler().

This also allows us to remove p->se usage from !sched_fair code.

Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110405152728.949545047@chello.nl
---
 include/linux/sched.h   |    1 +
 kernel/sched.c          |   38 ++++++++++++++++++++------------------
 kernel/sched_debug.c    |    2 +-
 kernel/sched_rt.c       |   16 ++++++++--------
 kernel/sched_stoptask.c |    2 +-
 5 files changed, 31 insertions(+), 28 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1738504..b33a700 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1202,6 +1202,7 @@ struct task_struct {
 #ifdef CONFIG_SMP
 	int on_cpu;
 #endif
+	int on_rq;
 
 	int prio, static_prio, normal_prio;
 	unsigned int rt_priority;
diff --git a/kernel/sched.c b/kernel/sched.c
index 4481638..dece28e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1785,7 +1785,6 @@ static void enqueue_task(struct rq *rq, struct task_struct *p, int flags)
 	update_rq_clock(rq);
 	sched_info_queued(p);
 	p->sched_class->enqueue_task(rq, p, flags);
-	p->se.on_rq = 1;
 }
 
 static void dequeue_task(struct rq *rq, struct task_struct *p, int flags)
@@ -1793,7 +1792,6 @@ static void dequeue_task(struct rq *rq, struct task_struct *p, int flags)
 	update_rq_clock(rq);
 	sched_info_dequeued(p);
 	p->sched_class->dequeue_task(rq, p, flags);
-	p->se.on_rq = 0;
 }
 
 /*
@@ -2128,7 +2126,7 @@ static void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
 	 * A queue event has occurred, and we're going to schedule.  In
 	 * this case, we can save a useless back to back clock update.
 	 */
-	if (rq->curr->se.on_rq && test_tsk_need_resched(rq->curr))
+	if (rq->curr->on_rq && test_tsk_need_resched(rq->curr))
 		rq->skip_clock_update = 1;
 }
 
@@ -2203,7 +2201,7 @@ static bool migrate_task(struct task_struct *p, struct rq *rq)
 	 * If the task is not on a runqueue (and not running), then
 	 * the next wake-up will properly place the task.
 	 */
-	return p->se.on_rq || task_running(rq, p);
+	return p->on_rq || task_running(rq, p);
 }
 
 /*
@@ -2263,7 +2261,7 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		rq = task_rq_lock(p, &flags);
 		trace_sched_wait_task(p);
 		running = task_running(rq, p);
-		on_rq = p->se.on_rq;
+		on_rq = p->on_rq;
 		ncsw = 0;
 		if (!match_state || p->state == match_state)
 			ncsw = p->nvcsw | LONG_MIN; /* sets MSB */
@@ -2444,6 +2442,7 @@ ttwu_stat(struct rq *rq, struct task_struct *p, int cpu, int wake_flags)
 static void ttwu_activate(struct rq *rq, struct task_struct *p, int en_flags)
 {
 	activate_task(rq, p, en_flags);
+	p->on_rq = 1;
 
 	/* if a worker is waking up, notify workqueue */
 	if (p->flags & PF_WQ_WORKER)
@@ -2506,7 +2505,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 
 	cpu = task_cpu(p);
 
-	if (p->se.on_rq)
+	if (p->on_rq)
 		goto out_running;
 
 	orig_cpu = cpu;
@@ -2583,7 +2582,7 @@ static void try_to_wake_up_local(struct task_struct *p)
 	if (!(p->state & TASK_NORMAL))
 		return;
 
-	if (!p->se.on_rq)
+	if (!p->on_rq)
 		ttwu_activate(rq, p, ENQUEUE_WAKEUP);
 
 	ttwu_post_activation(p, rq, 0);
@@ -2620,19 +2619,21 @@ int wake_up_state(struct task_struct *p, unsigned int state)
  */
 static void __sched_fork(struct task_struct *p)
 {
+	p->on_rq			= 0;
+
+	p->se.on_rq			= 0;
 	p->se.exec_start		= 0;
 	p->se.sum_exec_runtime		= 0;
 	p->se.prev_sum_exec_runtime	= 0;
 	p->se.nr_migrations		= 0;
 	p->se.vruntime			= 0;
+	INIT_LIST_HEAD(&p->se.group_node);
 
 #ifdef CONFIG_SCHEDSTATS
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
 #endif
 
 	INIT_LIST_HEAD(&p->rt.run_list);
-	p->se.on_rq = 0;
-	INIT_LIST_HEAD(&p->se.group_node);
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	INIT_HLIST_HEAD(&p->preempt_notifiers);
@@ -2750,6 +2751,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 
 	rq = task_rq_lock(p, &flags);
 	activate_task(rq, p, 0);
+	p->on_rq = 1;
 	trace_sched_wakeup_new(p, true);
 	check_preempt_curr(rq, p, WF_FORK);
 #ifdef CONFIG_SMP
@@ -4051,7 +4053,7 @@ static inline void schedule_debug(struct task_struct *prev)
 
 static void put_prev_task(struct rq *rq, struct task_struct *prev)
 {
-	if (prev->se.on_rq)
+	if (prev->on_rq)
 		update_rq_clock(rq);
 	prev->sched_class->put_prev_task(rq, prev);
 }
@@ -4126,7 +4128,9 @@ need_resched:
 				if (to_wakeup)
 					try_to_wake_up_local(to_wakeup);
 			}
+
 			deactivate_task(rq, prev, DEQUEUE_SLEEP);
+			prev->on_rq = 0;
 
 			/*
 			 * If we are going to sleep and we have plugged IO queued, make
@@ -4695,7 +4699,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	trace_sched_pi_setprio(p, prio);
 	oldprio = p->prio;
 	prev_class = p->sched_class;
-	on_rq = p->se.on_rq;
+	on_rq = p->on_rq;
 	running = task_current(rq, p);
 	if (on_rq)
 		dequeue_task(rq, p, 0);
@@ -4743,7 +4747,7 @@ void set_user_nice(struct task_struct *p, long nice)
 		p->static_prio = NICE_TO_PRIO(nice);
 		goto out_unlock;
 	}
-	on_rq = p->se.on_rq;
+	on_rq = p->on_rq;
 	if (on_rq)
 		dequeue_task(rq, p, 0);
 
@@ -4877,8 +4881,6 @@ static struct task_struct *find_process_by_pid(pid_t pid)
 static void
 __setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
 {
-	BUG_ON(p->se.on_rq);
-
 	p->policy = policy;
 	p->rt_priority = prio;
 	p->normal_prio = normal_prio(p);
@@ -5044,7 +5046,7 @@ recheck:
 		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 		goto recheck;
 	}
-	on_rq = p->se.on_rq;
+	on_rq = p->on_rq;
 	running = task_current(rq, p);
 	if (on_rq)
 		deactivate_task(rq, p, 0);
@@ -5965,7 +5967,7 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 	 * If we're not on a rq, the next wake-up will ensure we're
 	 * placed properly.
 	 */
-	if (p->se.on_rq) {
+	if (p->on_rq) {
 		deactivate_task(rq_src, p, 0);
 		set_task_cpu(p, dest_cpu);
 		activate_task(rq_dest, p, 0);
@@ -8339,7 +8341,7 @@ static void normalize_task(struct rq *rq, struct task_struct *p)
 	int old_prio = p->prio;
 	int on_rq;
 
-	on_rq = p->se.on_rq;
+	on_rq = p->on_rq;
 	if (on_rq)
 		deactivate_task(rq, p, 0);
 	__setscheduler(rq, p, SCHED_NORMAL, 0);
@@ -8682,7 +8684,7 @@ void sched_move_task(struct task_struct *tsk)
 	rq = task_rq_lock(tsk, &flags);
 
 	running = task_current(rq, tsk);
-	on_rq = tsk->se.on_rq;
+	on_rq = tsk->on_rq;
 
 	if (on_rq)
 		dequeue_task(rq, tsk, 0);
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 7bacd83..3669bec6 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -152,7 +152,7 @@ static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
 	read_lock_irqsave(&tasklist_lock, flags);
 
 	do_each_thread(g, p) {
-		if (!p->se.on_rq || task_cpu(p) != rq_cpu)
+		if (!p->on_rq || task_cpu(p) != rq_cpu)
 			continue;
 
 		print_task(m, rq, p);
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index e7cebdc..9ca4f5f 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1136,7 +1136,7 @@ static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
 	 * The previous task needs to be made eligible for pushing
 	 * if it is still active
 	 */
-	if (p->se.on_rq && p->rt.nr_cpus_allowed > 1)
+	if (on_rt_rq(&p->rt) && p->rt.nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
 }
 
@@ -1287,7 +1287,7 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
 				     !cpumask_test_cpu(lowest_rq->cpu,
 						       &task->cpus_allowed) ||
 				     task_running(rq, task) ||
-				     !task->se.on_rq)) {
+				     !task->on_rq)) {
 
 				raw_spin_unlock(&lowest_rq->lock);
 				lowest_rq = NULL;
@@ -1321,7 +1321,7 @@ static struct task_struct *pick_next_pushable_task(struct rq *rq)
 	BUG_ON(task_current(rq, p));
 	BUG_ON(p->rt.nr_cpus_allowed <= 1);
 
-	BUG_ON(!p->se.on_rq);
+	BUG_ON(!p->on_rq);
 	BUG_ON(!rt_task(p));
 
 	return p;
@@ -1467,7 +1467,7 @@ static int pull_rt_task(struct rq *this_rq)
 		 */
 		if (p && (p->prio < this_rq->rt.highest_prio.curr)) {
 			WARN_ON(p == src_rq->curr);
-			WARN_ON(!p->se.on_rq);
+			WARN_ON(!p->on_rq);
 
 			/*
 			 * There's a chance that p is higher in priority
@@ -1538,7 +1538,7 @@ static void set_cpus_allowed_rt(struct task_struct *p,
 	 * Update the migration status of the RQ if we have an RT task
 	 * which is running AND changing its weight value.
 	 */
-	if (p->se.on_rq && (weight != p->rt.nr_cpus_allowed)) {
+	if (p->on_rq && (weight != p->rt.nr_cpus_allowed)) {
 		struct rq *rq = task_rq(p);
 
 		if (!task_current(rq, p)) {
@@ -1608,7 +1608,7 @@ static void switched_from_rt(struct rq *rq, struct task_struct *p)
 	 * we may need to handle the pulling of RT tasks
 	 * now.
 	 */
-	if (p->se.on_rq && !rq->rt.rt_nr_running)
+	if (p->on_rq && !rq->rt.rt_nr_running)
 		pull_rt_task(rq);
 }
 
@@ -1638,7 +1638,7 @@ static void switched_to_rt(struct rq *rq, struct task_struct *p)
 	 * If that current running task is also an RT task
 	 * then see if we can move to another run queue.
 	 */
-	if (p->se.on_rq && rq->curr != p) {
+	if (p->on_rq && rq->curr != p) {
 #ifdef CONFIG_SMP
 		if (rq->rt.overloaded && push_rt_task(rq) &&
 		    /* Don't resched if we changed runqueues */
@@ -1657,7 +1657,7 @@ static void switched_to_rt(struct rq *rq, struct task_struct *p)
 static void
 prio_changed_rt(struct rq *rq, struct task_struct *p, int oldprio)
 {
-	if (!p->se.on_rq)
+	if (!p->on_rq)
 		return;
 
 	if (rq->curr == p) {
diff --git a/kernel/sched_stoptask.c b/kernel/sched_stoptask.c
index 1ba2bd4..f607de4 100644
--- a/kernel/sched_stoptask.c
+++ b/kernel/sched_stoptask.c
@@ -26,7 +26,7 @@ static struct task_struct *pick_next_task_stop(struct rq *rq)
 {
 	struct task_struct *stop = rq->stop;
 
-	if (stop && stop->se.on_rq)
+	if (stop && stop->on_rq)
 		return stop;
 
 	return NULL;
