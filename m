Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab2HTJMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 05:12:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64947 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab2HTJM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 05:12:28 -0400
Date: Mon, 20 Aug 2012 11:12:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20120820091222.GA9486@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   HEAD: 8f6189684eb4e85e6c593cd710693f09c944450a sched: Fix migration thread runtime bogosity

 Thanks,

	Ingo

------------------>
Mike Galbraith (3):
      sched,cgroup: Fix up task_groups list
      sched,rt: fix isolated CPUs leaving root_task_group indefinitely throttled
      sched: Fix migration thread runtime bogosity

Peter Zijlstra (1):
      sched, cgroup: Reduce rq->lock hold times for large cgroup hierarchies

Stanislaw Gruszka (1):
      sched: fix divide by zero at {thread_group,task}_times


 kernel/sched/core.c      | 35 +++++++++++++++++++++--------------
 kernel/sched/fair.c      | 11 +++++++++--
 kernel/sched/rt.c        | 13 +++++++++++++
 kernel/sched/sched.h     |  8 ++++++--
 kernel/sched/stop_task.c | 22 +++++++++++++++++++++-
 5 files changed, 70 insertions(+), 19 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2cb4e77..6aa212f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3142,6 +3142,20 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 # define nsecs_to_cputime(__nsecs)	nsecs_to_jiffies(__nsecs)
 #endif
 
+static cputime_t scale_utime(cputime_t utime, cputime_t rtime, cputime_t total)
+{
+	u64 temp = (__force u64) rtime;
+
+	temp *= (__force u64) utime;
+
+	if (sizeof(cputime_t) == 4)
+		temp = div_u64(temp, (__force u32) total);
+	else
+		temp = div64_u64(temp, (__force u64) total);
+
+	return (__force cputime_t) temp;
+}
+
 void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
 	cputime_t rtime, utime = p->utime, total = utime + p->stime;
@@ -3151,13 +3165,9 @@ void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	 */
 	rtime = nsecs_to_cputime(p->se.sum_exec_runtime);
 
-	if (total) {
-		u64 temp = (__force u64) rtime;
-
-		temp *= (__force u64) utime;
-		do_div(temp, (__force u32) total);
-		utime = (__force cputime_t) temp;
-	} else
+	if (total)
+		utime = scale_utime(utime, rtime, total);
+	else
 		utime = rtime;
 
 	/*
@@ -3184,13 +3194,9 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	total = cputime.utime + cputime.stime;
 	rtime = nsecs_to_cputime(cputime.sum_exec_runtime);
 
-	if (total) {
-		u64 temp = (__force u64) rtime;
-
-		temp *= (__force u64) cputime.utime;
-		do_div(temp, (__force u32) total);
-		utime = (__force cputime_t) temp;
-	} else
+	if (total)
+		utime = scale_utime(cputime.utime, rtime, total);
+	else
 		utime = rtime;
 
 	sig->prev_utime = max(sig->prev_utime, utime);
@@ -7246,6 +7252,7 @@ int in_sched_functions(unsigned long addr)
 
 #ifdef CONFIG_CGROUP_SCHED
 struct task_group root_task_group;
+LIST_HEAD(task_groups);
 #endif
 
 DECLARE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d0cc03b..c219bf8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3387,6 +3387,14 @@ static int tg_load_down(struct task_group *tg, void *data)
 
 static void update_h_load(long cpu)
 {
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long now = jiffies;
+
+	if (rq->h_load_throttle == now)
+		return;
+
+	rq->h_load_throttle = now;
+
 	rcu_read_lock();
 	walk_tg_tree(tg_load_down, tg_nop, (void *)cpu);
 	rcu_read_unlock();
@@ -4293,11 +4301,10 @@ redo:
 		env.src_rq    = busiest;
 		env.loop_max  = min(sysctl_sched_nr_migrate, busiest->nr_running);
 
+		update_h_load(env.src_cpu);
 more_balance:
 		local_irq_save(flags);
 		double_rq_lock(this_rq, busiest);
-		if (!env.loop)
-			update_h_load(env.src_cpu);
 
 		/*
 		 * cur_ld_moved - load moved in current iteration
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 573e1ca..944cb68 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -788,6 +788,19 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 	const struct cpumask *span;
 
 	span = sched_rt_period_mask();
+#ifdef CONFIG_RT_GROUP_SCHED
+	/*
+	 * FIXME: isolated CPUs should really leave the root task group,
+	 * whether they are isolcpus or were isolated via cpusets, lest
+	 * the timer run on a CPU which does not service all runqueues,
+	 * potentially leaving other CPUs indefinitely throttled.  If
+	 * isolation is really required, the user will turn the throttle
+	 * off to kill the perturbations it causes anyway.  Meanwhile,
+	 * this maintains functionality for boot and/or troubleshooting.
+	 */
+	if (rt_b == &root_task_group.rt_bandwidth)
+		span = cpu_online_mask;
+#endif
 	for_each_cpu(i, span) {
 		int enqueue = 0;
 		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c35a1a7..f6714d0 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -80,7 +80,7 @@ extern struct mutex sched_domains_mutex;
 struct cfs_rq;
 struct rt_rq;
 
-static LIST_HEAD(task_groups);
+extern struct list_head task_groups;
 
 struct cfs_bandwidth {
 #ifdef CONFIG_CFS_BANDWIDTH
@@ -374,7 +374,11 @@ struct rq {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* list of leaf cfs_rq on this cpu: */
 	struct list_head leaf_cfs_rq_list;
-#endif
+#ifdef CONFIG_SMP
+	unsigned long h_load_throttle;
+#endif /* CONFIG_SMP */
+#endif /* CONFIG_FAIR_GROUP_SCHED */
+
 #ifdef CONFIG_RT_GROUP_SCHED
 	struct list_head leaf_rt_rq_list;
 #endif
diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index 7b386e8..da5eb5b 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -27,8 +27,10 @@ static struct task_struct *pick_next_task_stop(struct rq *rq)
 {
 	struct task_struct *stop = rq->stop;
 
-	if (stop && stop->on_rq)
+	if (stop && stop->on_rq) {
+		stop->se.exec_start = rq->clock_task;
 		return stop;
+	}
 
 	return NULL;
 }
@@ -52,6 +54,21 @@ static void yield_task_stop(struct rq *rq)
 
 static void put_prev_task_stop(struct rq *rq, struct task_struct *prev)
 {
+	struct task_struct *curr = rq->curr;
+	u64 delta_exec;
+
+	delta_exec = rq->clock_task - curr->se.exec_start;
+	if (unlikely((s64)delta_exec < 0))
+		delta_exec = 0;
+
+	schedstat_set(curr->se.statistics.exec_max,
+			max(curr->se.statistics.exec_max, delta_exec));
+
+	curr->se.sum_exec_runtime += delta_exec;
+	account_group_exec_runtime(curr, delta_exec);
+
+	curr->se.exec_start = rq->clock_task;
+	cpuacct_charge(curr, delta_exec);
 }
 
 static void task_tick_stop(struct rq *rq, struct task_struct *curr, int queued)
@@ -60,6 +77,9 @@ static void task_tick_stop(struct rq *rq, struct task_struct *curr, int queued)
 
 static void set_curr_task_stop(struct rq *rq)
 {
+	struct task_struct *stop = rq->stop;
+
+	stop->se.exec_start = rq->clock_task;
 }
 
 static void switched_to_stop(struct rq *rq, struct task_struct *p)
