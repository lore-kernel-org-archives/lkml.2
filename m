Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758983Ab2CAMXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 07:23:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37610 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758028Ab2CAMXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:23:43 -0500
Date: Thu, 1 Mar 2012 04:23:06 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-0yvgms8t8x962drpvl0fu0kk@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Rename load-balancing fields
Git-Commit-ID: ddcdf6e7d9919d139031fa2a6addd9544a9a833e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 01 Mar 2012 04:23:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ddcdf6e7d9919d139031fa2a6addd9544a9a833e
Gitweb:     http://git.kernel.org/tip/ddcdf6e7d9919d139031fa2a6addd9544a9a833e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 22 Feb 2012 19:27:40 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 1 Mar 2012 10:51:23 +0100

sched: Rename load-balancing fields

 s/env->this_/env->dst_/g
 s/env->busiest_/env->src_/g
 s/pull_task/move_task/g

Makes everything clearer.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: pjt@google.com
Link: http://lkml.kernel.org/n/tip-0yvgms8t8x962drpvl0fu0kk@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/fair.c |  118 ++++++++++++++++++++++++++-------------------------
 1 files changed, 60 insertions(+), 58 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 55b1f11..233d051 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2918,7 +2918,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 		return;
 
 	/*
-	 * This is possible from callers such as pull_task(), in which we
+	 * This is possible from callers such as move_task(), in which we
 	 * unconditionally check_prempt_curr() after an enqueue (which may have
 	 * lead to a throttle).  This both saves work and prevents false
 	 * next-buddy nomination below.
@@ -3084,17 +3084,37 @@ static bool yield_to_task_fair(struct rq *rq, struct task_struct *p, bool preemp
 
 static unsigned long __read_mostly max_load_balance_interval = HZ/10;
 
+#define LBF_ALL_PINNED	0x01
+#define LBF_NEED_BREAK	0x02	/* clears into HAD_BREAK */
+#define LBF_HAD_BREAK	0x04
+#define LBF_HAD_BREAKS	0x0C	/* count HAD_BREAKs overflows into ABORT */
+#define LBF_ABORT	0x10
+
+struct lb_env {
+	struct sched_domain	*sd;
+
+	int			src_cpu;
+	struct rq		*src_rq;
+	struct cfs_rq		*src_cfs_rq;
+
+	int			dst_cpu;
+	struct rq		*dst_rq;
+
+	enum cpu_idle_type	idle;
+	unsigned long		max_load_move;
+	unsigned int		flags;
+};
+
 /*
- * pull_task - move a task from a remote runqueue to the local runqueue.
+ * move_task - move a task from one runqueue to another runqueue.
  * Both runqueues must be locked.
  */
-static void pull_task(struct rq *src_rq, struct task_struct *p,
-		      struct rq *this_rq, int this_cpu)
+static void move_task(struct task_struct *p, struct lb_env *env)
 {
-	deactivate_task(src_rq, p, 0);
-	set_task_cpu(p, this_cpu);
-	activate_task(this_rq, p, 0);
-	check_preempt_curr(this_rq, p, 0);
+	deactivate_task(env->src_rq, p, 0);
+	set_task_cpu(p, env->dst_cpu);
+	activate_task(env->dst_rq, p, 0);
+	check_preempt_curr(env->dst_rq, p, 0);
 }
 
 /*
@@ -3129,26 +3149,6 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 	return delta < (s64)sysctl_sched_migration_cost;
 }
 
-#define LBF_ALL_PINNED	0x01
-#define LBF_NEED_BREAK	0x02	/* clears into HAD_BREAK */
-#define LBF_HAD_BREAK	0x04
-#define LBF_HAD_BREAKS	0x0C	/* count HAD_BREAKs overflows into ABORT */
-#define LBF_ABORT	0x10
-
-struct lb_env {
-	struct sched_domain	*sd;
-
-	int			this_cpu;
-	struct rq		*this_rq;
-
-	struct rq		*busiest_rq;
-	struct cfs_rq		*busiest_cfs_rq;
-
-	enum cpu_idle_type	idle;
-	unsigned long		max_load_move;
-	unsigned int		flags;
-};
-
 /*
  * can_migrate_task - may task p from runqueue rq be migrated to this_cpu?
  */
@@ -3162,13 +3162,13 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	 * 2) cannot be migrated to this CPU due to cpus_allowed, or
 	 * 3) are cache-hot on their current CPU.
 	 */
-	if (!cpumask_test_cpu(env->this_cpu, tsk_cpus_allowed(p))) {
+	if (!cpumask_test_cpu(env->dst_cpu, tsk_cpus_allowed(p))) {
 		schedstat_inc(p, se.statistics.nr_failed_migrations_affine);
 		return 0;
 	}
 	env->flags &= ~LBF_ALL_PINNED;
 
-	if (task_running(env->busiest_rq, p)) {
+	if (task_running(env->src_rq, p)) {
 		schedstat_inc(p, se.statistics.nr_failed_migrations_running);
 		return 0;
 	}
@@ -3179,7 +3179,7 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	 * 2) too many balance attempts have failed.
 	 */
 
-	tsk_cache_hot = task_hot(p, env->busiest_rq->clock_task, env->sd);
+	tsk_cache_hot = task_hot(p, env->src_rq->clock_task, env->sd);
 	if (!tsk_cache_hot ||
 		env->sd->nr_balance_failed > env->sd->cache_nice_tries) {
 #ifdef CONFIG_SCHEDSTATS
@@ -3210,20 +3210,20 @@ static int move_one_task(struct lb_env *env)
 	struct task_struct *p, *n;
 	struct cfs_rq *cfs_rq;
 
-	for_each_leaf_cfs_rq(env->busiest_rq, cfs_rq) {
+	for_each_leaf_cfs_rq(env->src_rq, cfs_rq) {
 		list_for_each_entry_safe(p, n, &cfs_rq->tasks, se.group_node) {
 			if (throttled_lb_pair(task_group(p),
-					      env->busiest_rq->cpu, env->this_cpu))
+					      env->src_cpu, env->dst_cpu))
 				break;
 
 			if (!can_migrate_task(p, env))
 				continue;
 
-			pull_task(env->busiest_rq, p, env->this_rq, env->this_cpu);
+			move_task(p, env);
 			/*
-			 * Right now, this is only the second place pull_task()
-			 * is called, so we can safely collect pull_task()
-			 * stats here rather than inside pull_task().
+			 * Right now, this is only the second place move_task()
+			 * is called, so we can safely collect move_task()
+			 * stats here rather than inside move_task().
 			 */
 			schedstat_inc(env->sd, lb_gained[env->idle]);
 			return 1;
@@ -3242,7 +3242,7 @@ static unsigned long balance_tasks(struct lb_env *env)
 	if (env->max_load_move == 0)
 		goto out;
 
-	list_for_each_entry_safe(p, n, &env->busiest_cfs_rq->tasks, se.group_node) {
+	list_for_each_entry_safe(p, n, &env->src_cfs_rq->tasks, se.group_node) {
 		if (loops++ > sysctl_sched_nr_migrate) {
 			env->flags |= LBF_NEED_BREAK;
 			break;
@@ -3252,7 +3252,7 @@ static unsigned long balance_tasks(struct lb_env *env)
 		    !can_migrate_task(p, env))
 			continue;
 
-		pull_task(env->busiest_rq, p, env->this_rq, env->this_cpu);
+		move_task(p, env);
 		pulled++;
 		rem_load_move -= p->se.load.weight;
 
@@ -3277,9 +3277,9 @@ static unsigned long balance_tasks(struct lb_env *env)
 	}
 out:
 	/*
-	 * Right now, this is one of only two places pull_task() is called,
-	 * so we can safely collect pull_task() stats here rather than
-	 * inside pull_task().
+	 * Right now, this is one of only two places move_task() is called,
+	 * so we can safely collect move_task() stats here rather than
+	 * inside move_task().
 	 */
 	schedstat_add(env->sd, lb_gained[env->idle], pulled);
 
@@ -3372,11 +3372,11 @@ static unsigned long load_balance_fair(struct lb_env *env)
 	long rem_load_move = env->max_load_move;
 
 	rcu_read_lock();
-	update_h_load(cpu_of(env->busiest_rq));
+	update_h_load(cpu_of(env->src_rq));
 
-	for_each_leaf_cfs_rq(env->busiest_rq, env->busiest_cfs_rq) {
-		unsigned long busiest_h_load = env->busiest_cfs_rq->h_load;
-		unsigned long busiest_weight = env->busiest_cfs_rq->load.weight;
+	for_each_leaf_cfs_rq(env->src_rq, env->src_cfs_rq) {
+		unsigned long busiest_h_load = env->src_cfs_rq->h_load;
+		unsigned long busiest_weight = env->src_cfs_rq->load.weight;
 		u64 rem_load, moved_load;
 
 		if (env->flags & (LBF_NEED_BREAK|LBF_ABORT))
@@ -3385,12 +3385,12 @@ static unsigned long load_balance_fair(struct lb_env *env)
 		/*
 		 * empty group or part of a throttled hierarchy
 		 */
-		if (!env->busiest_cfs_rq->task_weight)
+		if (!env->src_cfs_rq->task_weight)
 			continue;
 
-		if (throttled_lb_pair(env->busiest_cfs_rq->tg,
-				      cpu_of(env->busiest_rq),
-				      env->this_cpu))
+		if (throttled_lb_pair(env->src_cfs_rq->tg,
+				      cpu_of(env->src_rq),
+				      env->dst_cpu))
 			continue;
 
 		rem_load = (u64)rem_load_move * busiest_weight;
@@ -3420,7 +3420,7 @@ static inline void update_shares(int cpu)
 
 static unsigned long load_balance_fair(struct lb_env *env)
 {
-	env->busiest_cfs_rq = &env->busiest_rq->cfs;
+	env->src_cfs_rq = &env->src_rq->cfs;
 	return balance_tasks(env);
 }
 #endif
@@ -3451,7 +3451,7 @@ static int move_tasks(struct lb_env *env)
 		 * kernels will stop after the first task is pulled to minimize
 		 * the critical section.
 		 */
-		if (env->idle == CPU_NEWLY_IDLE && env->this_rq->nr_running) {
+		if (env->idle == CPU_NEWLY_IDLE && env->dst_rq->nr_running) {
 			env->flags |= LBF_ABORT;
 			break;
 		}
@@ -4461,8 +4461,8 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 
 	struct lb_env env = {
 		.sd		= sd,
-		.this_cpu	= this_cpu,
-		.this_rq	= this_rq,
+		.dst_cpu	= this_cpu,
+		.dst_rq		= this_rq,
 		.idle		= idle,
 	};
 
@@ -4502,7 +4502,8 @@ redo:
 		 */
 		env.flags |= LBF_ALL_PINNED;
 		env.max_load_move = imbalance;
-		env.busiest_rq = busiest;
+		env.src_cpu = busiest->cpu;
+		env.src_rq = busiest;
 
 		local_irq_save(flags);
 		double_rq_lock(this_rq, busiest);
@@ -4722,9 +4723,10 @@ static int active_load_balance_cpu_stop(void *data)
 	if (likely(sd)) {
 		struct lb_env env = {
 			.sd		= sd,
-			.this_cpu	= target_cpu,
-			.this_rq	= target_rq,
-			.busiest_rq	= busiest_rq,
+			.dst_cpu	= target_cpu,
+			.dst_rq		= target_rq,
+			.src_cpu	= busiest_rq->cpu,
+			.src_rq		= busiest_rq,
 			.idle		= CPU_IDLE,
 		};
 
