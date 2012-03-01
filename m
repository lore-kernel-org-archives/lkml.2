Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944Ab2CAMXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 07:23:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37596 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758006Ab2CAMXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:23:07 -0500
Date: Thu, 1 Mar 2012 04:22:18 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-5slqz0vhsdzewrfk9eza1aon@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Move load-balancing arguments into helper struct
Git-Commit-ID: 8e45cb545d98bc58e75b7de89ec8d3e5c8459ee6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 01 Mar 2012 04:22:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e45cb545d98bc58e75b7de89ec8d3e5c8459ee6
Gitweb:     http://git.kernel.org/tip/8e45cb545d98bc58e75b7de89ec8d3e5c8459ee6
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 22 Feb 2012 12:47:19 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 1 Mar 2012 10:51:22 +0100

sched: Move load-balancing arguments into helper struct

Passing large sets of similar arguments all around the load-balancer
gets tiresom when you want to modify something. Stick them all in a
helper structure and pass the structure around.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: pjt@google.com
Link: http://lkml.kernel.org/n/tip-5slqz0vhsdzewrfk9eza1aon@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/fair.c |  177 +++++++++++++++++++++++++++------------------------
 1 files changed, 93 insertions(+), 84 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 79e9e13..55b1f11 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3135,13 +3135,25 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 #define LBF_HAD_BREAKS	0x0C	/* count HAD_BREAKs overflows into ABORT */
 #define LBF_ABORT	0x10
 
+struct lb_env {
+	struct sched_domain	*sd;
+
+	int			this_cpu;
+	struct rq		*this_rq;
+
+	struct rq		*busiest_rq;
+	struct cfs_rq		*busiest_cfs_rq;
+
+	enum cpu_idle_type	idle;
+	unsigned long		max_load_move;
+	unsigned int		flags;
+};
+
 /*
  * can_migrate_task - may task p from runqueue rq be migrated to this_cpu?
  */
 static
-int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
-		     struct sched_domain *sd, enum cpu_idle_type idle,
-		     int *lb_flags)
+int can_migrate_task(struct task_struct *p, struct lb_env *env)
 {
 	int tsk_cache_hot = 0;
 	/*
@@ -3150,13 +3162,13 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
 	 * 2) cannot be migrated to this CPU due to cpus_allowed, or
 	 * 3) are cache-hot on their current CPU.
 	 */
-	if (!cpumask_test_cpu(this_cpu, tsk_cpus_allowed(p))) {
+	if (!cpumask_test_cpu(env->this_cpu, tsk_cpus_allowed(p))) {
 		schedstat_inc(p, se.statistics.nr_failed_migrations_affine);
 		return 0;
 	}
-	*lb_flags &= ~LBF_ALL_PINNED;
+	env->flags &= ~LBF_ALL_PINNED;
 
-	if (task_running(rq, p)) {
+	if (task_running(env->busiest_rq, p)) {
 		schedstat_inc(p, se.statistics.nr_failed_migrations_running);
 		return 0;
 	}
@@ -3167,12 +3179,12 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
 	 * 2) too many balance attempts have failed.
 	 */
 
-	tsk_cache_hot = task_hot(p, rq->clock_task, sd);
+	tsk_cache_hot = task_hot(p, env->busiest_rq->clock_task, env->sd);
 	if (!tsk_cache_hot ||
-		sd->nr_balance_failed > sd->cache_nice_tries) {
+		env->sd->nr_balance_failed > env->sd->cache_nice_tries) {
 #ifdef CONFIG_SCHEDSTATS
 		if (tsk_cache_hot) {
-			schedstat_inc(sd, lb_hot_gained[idle]);
+			schedstat_inc(env->sd, lb_hot_gained[env->idle]);
 			schedstat_inc(p, se.statistics.nr_forced_migrations);
 		}
 #endif
@@ -3193,31 +3205,27 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
  *
  * Called with both runqueues locked.
  */
-static int
-move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
-	      struct sched_domain *sd, enum cpu_idle_type idle)
+static int move_one_task(struct lb_env *env)
 {
 	struct task_struct *p, *n;
 	struct cfs_rq *cfs_rq;
-	int pinned = 0;
 
-	for_each_leaf_cfs_rq(busiest, cfs_rq) {
+	for_each_leaf_cfs_rq(env->busiest_rq, cfs_rq) {
 		list_for_each_entry_safe(p, n, &cfs_rq->tasks, se.group_node) {
 			if (throttled_lb_pair(task_group(p),
-					      busiest->cpu, this_cpu))
+					      env->busiest_rq->cpu, env->this_cpu))
 				break;
 
-			if (!can_migrate_task(p, busiest, this_cpu,
-						sd, idle, &pinned))
+			if (!can_migrate_task(p, env))
 				continue;
 
-			pull_task(busiest, p, this_rq, this_cpu);
+			pull_task(env->busiest_rq, p, env->this_rq, env->this_cpu);
 			/*
 			 * Right now, this is only the second place pull_task()
 			 * is called, so we can safely collect pull_task()
 			 * stats here rather than inside pull_task().
 			 */
-			schedstat_inc(sd, lb_gained[idle]);
+			schedstat_inc(env->sd, lb_gained[env->idle]);
 			return 1;
 		}
 	}
@@ -3225,31 +3233,26 @@ move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	return 0;
 }
 
-static unsigned long
-balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
-	      unsigned long max_load_move, struct sched_domain *sd,
-	      enum cpu_idle_type idle, int *lb_flags,
-	      struct cfs_rq *busiest_cfs_rq)
+static unsigned long balance_tasks(struct lb_env *env)
 {
 	int loops = 0, pulled = 0;
-	long rem_load_move = max_load_move;
+	long rem_load_move = env->max_load_move;
 	struct task_struct *p, *n;
 
-	if (max_load_move == 0)
+	if (env->max_load_move == 0)
 		goto out;
 
-	list_for_each_entry_safe(p, n, &busiest_cfs_rq->tasks, se.group_node) {
+	list_for_each_entry_safe(p, n, &env->busiest_cfs_rq->tasks, se.group_node) {
 		if (loops++ > sysctl_sched_nr_migrate) {
-			*lb_flags |= LBF_NEED_BREAK;
+			env->flags |= LBF_NEED_BREAK;
 			break;
 		}
 
 		if ((p->se.load.weight >> 1) > rem_load_move ||
-		    !can_migrate_task(p, busiest, this_cpu, sd, idle,
-				      lb_flags))
+		    !can_migrate_task(p, env))
 			continue;
 
-		pull_task(busiest, p, this_rq, this_cpu);
+		pull_task(env->busiest_rq, p, env->this_rq, env->this_cpu);
 		pulled++;
 		rem_load_move -= p->se.load.weight;
 
@@ -3259,8 +3262,8 @@ balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		 * kernels will stop after the first task is pulled to minimize
 		 * the critical section.
 		 */
-		if (idle == CPU_NEWLY_IDLE) {
-			*lb_flags |= LBF_ABORT;
+		if (env->idle == CPU_NEWLY_IDLE) {
+			env->flags |= LBF_ABORT;
 			break;
 		}
 #endif
@@ -3278,9 +3281,9 @@ out:
 	 * so we can safely collect pull_task() stats here rather than
 	 * inside pull_task().
 	 */
-	schedstat_add(sd, lb_gained[idle], pulled);
+	schedstat_add(env->sd, lb_gained[env->idle], pulled);
 
-	return max_load_move - rem_load_move;
+	return env->max_load_move - rem_load_move;
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -3363,40 +3366,39 @@ static void update_h_load(long cpu)
 	walk_tg_tree(tg_load_down, tg_nop, (void *)cpu);
 }
 
-static unsigned long
-load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		  unsigned long max_load_move,
-		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *lb_flags)
+static unsigned long load_balance_fair(struct lb_env *env)
 {
-	long rem_load_move = max_load_move;
-	struct cfs_rq *busiest_cfs_rq;
+	unsigned long max_load_move = env->max_load_move;
+	long rem_load_move = env->max_load_move;
 
 	rcu_read_lock();
-	update_h_load(cpu_of(busiest));
+	update_h_load(cpu_of(env->busiest_rq));
 
-	for_each_leaf_cfs_rq(busiest, busiest_cfs_rq) {
-		unsigned long busiest_h_load = busiest_cfs_rq->h_load;
-		unsigned long busiest_weight = busiest_cfs_rq->load.weight;
+	for_each_leaf_cfs_rq(env->busiest_rq, env->busiest_cfs_rq) {
+		unsigned long busiest_h_load = env->busiest_cfs_rq->h_load;
+		unsigned long busiest_weight = env->busiest_cfs_rq->load.weight;
 		u64 rem_load, moved_load;
 
-		if (*lb_flags & (LBF_NEED_BREAK|LBF_ABORT))
+		if (env->flags & (LBF_NEED_BREAK|LBF_ABORT))
 			break;
 
 		/*
 		 * empty group or part of a throttled hierarchy
 		 */
-		if (!busiest_cfs_rq->task_weight ||
-		    throttled_lb_pair(busiest_cfs_rq->tg, cpu_of(busiest), this_cpu))
+		if (!env->busiest_cfs_rq->task_weight)
+			continue;
+
+		if (throttled_lb_pair(env->busiest_cfs_rq->tg,
+				      cpu_of(env->busiest_rq),
+				      env->this_cpu))
 			continue;
 
 		rem_load = (u64)rem_load_move * busiest_weight;
 		rem_load = div_u64(rem_load, busiest_h_load + 1);
 
-		moved_load = balance_tasks(this_rq, this_cpu, busiest,
-				rem_load, sd, idle, lb_flags,
-				busiest_cfs_rq);
+		env->max_load_move = rem_load;
 
+		moved_load = balance_tasks(env);
 		if (!moved_load)
 			continue;
 
@@ -3416,15 +3418,10 @@ static inline void update_shares(int cpu)
 {
 }
 
-static unsigned long
-load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		  unsigned long max_load_move,
-		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *lb_flags)
+static unsigned long load_balance_fair(struct lb_env *env)
 {
-	return balance_tasks(this_rq, this_cpu, busiest,
-			max_load_move, sd, idle, lb_flags,
-			&busiest->cfs);
+	env->busiest_cfs_rq = &env->busiest_rq->cfs;
+	return balance_tasks(env);
 }
 #endif
 
@@ -3435,21 +3432,17 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
  *
  * Called with both runqueues locked.
  */
-static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		      unsigned long max_load_move,
-		      struct sched_domain *sd, enum cpu_idle_type idle,
-		      int *lb_flags)
+static int move_tasks(struct lb_env *env)
 {
+	unsigned long max_load_move = env->max_load_move;
 	unsigned long total_load_moved = 0, load_moved;
 
 	do {
-		load_moved = load_balance_fair(this_rq, this_cpu, busiest,
-				max_load_move - total_load_moved,
-				sd, idle, lb_flags);
-
+		env->max_load_move = max_load_move - total_load_moved;
+		load_moved = load_balance_fair(env);
 		total_load_moved += load_moved;
 
-		if (*lb_flags & (LBF_NEED_BREAK|LBF_ABORT))
+		if (env->flags & (LBF_NEED_BREAK|LBF_ABORT))
 			break;
 
 #ifdef CONFIG_PREEMPT
@@ -3458,8 +3451,8 @@ static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		 * kernels will stop after the first task is pulled to minimize
 		 * the critical section.
 		 */
-		if (idle == CPU_NEWLY_IDLE && this_rq->nr_running) {
-			*lb_flags |= LBF_ABORT;
+		if (env->idle == CPU_NEWLY_IDLE && env->this_rq->nr_running) {
+			env->flags |= LBF_ABORT;
 			break;
 		}
 #endif
@@ -4459,13 +4452,20 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 			struct sched_domain *sd, enum cpu_idle_type idle,
 			int *balance)
 {
-	int ld_moved, lb_flags = 0, active_balance = 0;
+	int ld_moved, active_balance = 0;
 	struct sched_group *group;
 	unsigned long imbalance;
 	struct rq *busiest;
 	unsigned long flags;
 	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
 
+	struct lb_env env = {
+		.sd		= sd,
+		.this_cpu	= this_cpu,
+		.this_rq	= this_rq,
+		.idle		= idle,
+	};
+
 	cpumask_copy(cpus, cpu_active_mask);
 
 	schedstat_inc(sd, lb_count[idle]);
@@ -4500,11 +4500,13 @@ redo:
 		 * still unbalanced. ld_moved simply stays zero, so it is
 		 * correctly treated as an imbalance.
 		 */
-		lb_flags |= LBF_ALL_PINNED;
+		env.flags |= LBF_ALL_PINNED;
+		env.max_load_move = imbalance;
+		env.busiest_rq = busiest;
+
 		local_irq_save(flags);
 		double_rq_lock(this_rq, busiest);
-		ld_moved = move_tasks(this_rq, this_cpu, busiest,
-				      imbalance, sd, idle, &lb_flags);
+		ld_moved = move_tasks(&env);
 		double_rq_unlock(this_rq, busiest);
 		local_irq_restore(flags);
 
@@ -4514,18 +4516,18 @@ redo:
 		if (ld_moved && this_cpu != smp_processor_id())
 			resched_cpu(this_cpu);
 
-		if (lb_flags & LBF_ABORT)
+		if (env.flags & LBF_ABORT)
 			goto out_balanced;
 
-		if (lb_flags & LBF_NEED_BREAK) {
-			lb_flags += LBF_HAD_BREAK - LBF_NEED_BREAK;
-			if (lb_flags & LBF_ABORT)
+		if (env.flags & LBF_NEED_BREAK) {
+			env.flags += LBF_HAD_BREAK - LBF_NEED_BREAK;
+			if (env.flags & LBF_ABORT)
 				goto out_balanced;
 			goto redo;
 		}
 
 		/* All tasks on this runqueue were pinned by CPU affinity */
-		if (unlikely(lb_flags & LBF_ALL_PINNED)) {
+		if (unlikely(env.flags & LBF_ALL_PINNED)) {
 			cpumask_clear_cpu(cpu_of(busiest), cpus);
 			if (!cpumask_empty(cpus))
 				goto redo;
@@ -4555,7 +4557,7 @@ redo:
 					tsk_cpus_allowed(busiest->curr))) {
 				raw_spin_unlock_irqrestore(&busiest->lock,
 							    flags);
-				lb_flags |= LBF_ALL_PINNED;
+				env.flags |= LBF_ALL_PINNED;
 				goto out_one_pinned;
 			}
 
@@ -4608,7 +4610,7 @@ out_balanced:
 
 out_one_pinned:
 	/* tune up the balancing interval */
-	if (((lb_flags & LBF_ALL_PINNED) &&
+	if (((env.flags & LBF_ALL_PINNED) &&
 			sd->balance_interval < MAX_PINNED_INTERVAL) ||
 			(sd->balance_interval < sd->max_interval))
 		sd->balance_interval *= 2;
@@ -4718,10 +4720,17 @@ static int active_load_balance_cpu_stop(void *data)
 	}
 
 	if (likely(sd)) {
+		struct lb_env env = {
+			.sd		= sd,
+			.this_cpu	= target_cpu,
+			.this_rq	= target_rq,
+			.busiest_rq	= busiest_rq,
+			.idle		= CPU_IDLE,
+		};
+
 		schedstat_inc(sd, alb_count);
 
-		if (move_one_task(target_rq, target_cpu, busiest_rq,
-				  sd, CPU_IDLE))
+		if (move_one_task(&env))
 			schedstat_inc(sd, alb_pushed);
 		else
 			schedstat_inc(sd, alb_failed);
