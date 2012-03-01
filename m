Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970Ab2CAMYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 07:24:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37626 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab2CAMYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:24:42 -0500
Date: Thu, 1 Mar 2012 04:23:54 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-tx8yqydc7eimgq7i4rkc3a4g@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Ditch per cgroup task lists for load-balancing
Git-Commit-ID: a15a53d4b8ef2fefb64cddb63924aa424464dde1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 01 Mar 2012 04:24:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a15a53d4b8ef2fefb64cddb63924aa424464dde1
Gitweb:     http://git.kernel.org/tip/a15a53d4b8ef2fefb64cddb63924aa424464dde1
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 20 Feb 2012 21:49:09 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 1 Mar 2012 10:51:24 +0100

sched: Ditch per cgroup task lists for load-balancing

Per cgroup load-balance has numerous problems, chief amongst them that
there is no real sane order in them. So stop pretending it makes sense
and enqueue all tasks on a single list.

This also allows us to more easily fix the fwd progress issue
uncovered by the lock-break stuff. Rotate the list on failure to
migreate and limit the total iterations to nr_running (which with
releasing the lock isn't strictly accurate but close enough).

Also add a filter that skips very light tasks on the first attempt
around the list, this attempts to avoid shooting whole cgroups around
without affecting over balance.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: pjt@google.com
Link: http://lkml.kernel.org/n/tip-tx8yqydc7eimgq7i4rkc3a4g@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/core.c  |    3 +
 kernel/sched/fair.c  |  174 +++++++++++++++++++++-----------------------------
 kernel/sched/sched.h |   10 +--
 3 files changed, 78 insertions(+), 109 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 25e06a5..9554512 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6959,6 +6959,9 @@ void __init sched_init(void)
 		rq->online = 0;
 		rq->idle_stamp = 0;
 		rq->avg_idle = 2*sysctl_sched_migration_cost;
+
+		INIT_LIST_HEAD(&rq->cfs_tasks);
+
 		rq_attach_root(rq, &def_root_domain);
 #ifdef CONFIG_NO_HZ
 		rq->nohz_flags = 0;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 233d051..65cfa35 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -776,29 +776,14 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
  * Scheduling class queueing methods:
  */
 
-#if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
-static void
-add_cfs_task_weight(struct cfs_rq *cfs_rq, unsigned long weight)
-{
-	cfs_rq->task_weight += weight;
-}
-#else
-static inline void
-add_cfs_task_weight(struct cfs_rq *cfs_rq, unsigned long weight)
-{
-}
-#endif
-
 static void
 account_entity_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	update_load_add(&cfs_rq->load, se->load.weight);
 	if (!parent_entity(se))
 		update_load_add(&rq_of(cfs_rq)->load, se->load.weight);
-	if (entity_is_task(se)) {
-		add_cfs_task_weight(cfs_rq, se->load.weight);
-		list_add(&se->group_node, &cfs_rq->tasks);
-	}
+	if (entity_is_task(se))
+		list_add(&se->group_node, &rq_of(cfs_rq)->cfs_tasks);
 	cfs_rq->nr_running++;
 }
 
@@ -808,10 +793,8 @@ account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	update_load_sub(&cfs_rq->load, se->load.weight);
 	if (!parent_entity(se))
 		update_load_sub(&rq_of(cfs_rq)->load, se->load.weight);
-	if (entity_is_task(se)) {
-		add_cfs_task_weight(cfs_rq, -se->load.weight);
+	if (entity_is_task(se))
 		list_del_init(&se->group_node);
-	}
 	cfs_rq->nr_running--;
 }
 
@@ -3085,17 +3068,14 @@ static bool yield_to_task_fair(struct rq *rq, struct task_struct *p, bool preemp
 static unsigned long __read_mostly max_load_balance_interval = HZ/10;
 
 #define LBF_ALL_PINNED	0x01
-#define LBF_NEED_BREAK	0x02	/* clears into HAD_BREAK */
-#define LBF_HAD_BREAK	0x04
-#define LBF_HAD_BREAKS	0x0C	/* count HAD_BREAKs overflows into ABORT */
-#define LBF_ABORT	0x10
+#define LBF_NEED_BREAK	0x02
+#define LBF_ABORT	0x04
 
 struct lb_env {
 	struct sched_domain	*sd;
 
 	int			src_cpu;
 	struct rq		*src_rq;
-	struct cfs_rq		*src_cfs_rq;
 
 	int			dst_cpu;
 	struct rq		*dst_rq;
@@ -3103,6 +3083,10 @@ struct lb_env {
 	enum cpu_idle_type	idle;
 	unsigned long		max_load_move;
 	unsigned int		flags;
+
+	unsigned int		loop;
+	unsigned int		loop_break;
+	unsigned int		loop_max;
 };
 
 /*
@@ -3208,53 +3192,69 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 static int move_one_task(struct lb_env *env)
 {
 	struct task_struct *p, *n;
-	struct cfs_rq *cfs_rq;
 
-	for_each_leaf_cfs_rq(env->src_rq, cfs_rq) {
-		list_for_each_entry_safe(p, n, &cfs_rq->tasks, se.group_node) {
-			if (throttled_lb_pair(task_group(p),
-					      env->src_cpu, env->dst_cpu))
-				break;
+	list_for_each_entry_safe(p, n, &env->src_rq->cfs_tasks, se.group_node) {
+		if (throttled_lb_pair(task_group(p), env->src_rq->cpu, env->dst_cpu))
+			continue;
 
-			if (!can_migrate_task(p, env))
-				continue;
+		if (!can_migrate_task(p, env))
+			continue;
 
-			move_task(p, env);
-			/*
-			 * Right now, this is only the second place move_task()
-			 * is called, so we can safely collect move_task()
-			 * stats here rather than inside move_task().
-			 */
-			schedstat_inc(env->sd, lb_gained[env->idle]);
-			return 1;
-		}
+		move_task(p, env);
+		/*
+		 * Right now, this is only the second place move_task()
+		 * is called, so we can safely collect move_task()
+		 * stats here rather than inside move_task().
+		 */
+		schedstat_inc(env->sd, lb_gained[env->idle]);
+		return 1;
 	}
-
 	return 0;
 }
 
+static unsigned long task_h_load(struct task_struct *p);
+
 static unsigned long balance_tasks(struct lb_env *env)
 {
-	int loops = 0, pulled = 0;
 	long rem_load_move = env->max_load_move;
 	struct task_struct *p, *n;
+	unsigned long load;
+	int pulled = 0;
 
 	if (env->max_load_move == 0)
 		goto out;
 
-	list_for_each_entry_safe(p, n, &env->src_cfs_rq->tasks, se.group_node) {
-		if (loops++ > sysctl_sched_nr_migrate) {
+	list_for_each_entry_safe(p, n, &env->src_rq->cfs_tasks, se.group_node) {
+		env->loop++;
+		/* We've more or less seen every task there is, call it quits */
+		if (env->loop > env->loop_max) {
+			env->flags |= LBF_ABORT;
+			break;
+		}
+		/* take a beather every nr_migrate tasks */
+		if (env->loop > env->loop_break) {
+			env->loop_break += sysctl_sched_nr_migrate;
 			env->flags |= LBF_NEED_BREAK;
 			break;
 		}
 
-		if ((p->se.load.weight >> 1) > rem_load_move ||
-		    !can_migrate_task(p, env))
-			continue;
+		if (throttled_lb_pair(task_group(p), env->src_rq->cpu,
+					env->dst_cpu))
+			goto next;
+
+		load = task_h_load(p);
+		if (load < 16 && !env->sd->nr_balance_failed)
+			goto next;
+
+		if ((load * 2) > rem_load_move)
+			goto next;
+
+		if (!can_migrate_task(p, env))
+			goto next;
 
 		move_task(p, env);
 		pulled++;
-		rem_load_move -= p->se.load.weight;
+		rem_load_move -= load;
 
 #ifdef CONFIG_PREEMPT
 		/*
@@ -3274,6 +3274,10 @@ static unsigned long balance_tasks(struct lb_env *env)
 		 */
 		if (rem_load_move <= 0)
 			break;
+
+		continue;
+next:
+		list_move_tail(&p->se.group_node, &env->src_rq->cfs_tasks);
 	}
 out:
 	/*
@@ -3363,65 +3367,33 @@ static int tg_load_down(struct task_group *tg, void *data)
 
 static void update_h_load(long cpu)
 {
+	rcu_read_lock();
 	walk_tg_tree(tg_load_down, tg_nop, (void *)cpu);
+	rcu_read_unlock();
 }
 
-static unsigned long load_balance_fair(struct lb_env *env)
+static unsigned long task_h_load(struct task_struct *p)
 {
-	unsigned long max_load_move = env->max_load_move;
-	long rem_load_move = env->max_load_move;
-
-	rcu_read_lock();
-	update_h_load(cpu_of(env->src_rq));
-
-	for_each_leaf_cfs_rq(env->src_rq, env->src_cfs_rq) {
-		unsigned long busiest_h_load = env->src_cfs_rq->h_load;
-		unsigned long busiest_weight = env->src_cfs_rq->load.weight;
-		u64 rem_load, moved_load;
-
-		if (env->flags & (LBF_NEED_BREAK|LBF_ABORT))
-			break;
-
-		/*
-		 * empty group or part of a throttled hierarchy
-		 */
-		if (!env->src_cfs_rq->task_weight)
-			continue;
-
-		if (throttled_lb_pair(env->src_cfs_rq->tg,
-				      cpu_of(env->src_rq),
-				      env->dst_cpu))
-			continue;
-
-		rem_load = (u64)rem_load_move * busiest_weight;
-		rem_load = div_u64(rem_load, busiest_h_load + 1);
-
-		env->max_load_move = rem_load;
-
-		moved_load = balance_tasks(env);
-		if (!moved_load)
-			continue;
-
-		moved_load *= busiest_h_load;
-		moved_load = div_u64(moved_load, busiest_weight + 1);
+	struct cfs_rq *cfs_rq = task_cfs_rq(p);
+	unsigned long load;
 
-		rem_load_move -= moved_load;
-		if (rem_load_move < 0)
-			break;
-	}
-	rcu_read_unlock();
+	load = p->se.load.weight;
+	load = div_u64(load * cfs_rq->h_load, cfs_rq->load.weight + 1);
 
-	return max_load_move - rem_load_move;
+	return load;
 }
 #else
 static inline void update_shares(int cpu)
 {
 }
 
-static unsigned long load_balance_fair(struct lb_env *env)
+static inline void update_h_load(long cpu)
 {
-	env->src_cfs_rq = &env->src_rq->cfs;
-	return balance_tasks(env);
+}
+
+static unsigned long task_h_load(struct task_struct *p)
+{
+	return p->se.load.weight;
 }
 #endif
 
@@ -3437,9 +3409,10 @@ static int move_tasks(struct lb_env *env)
 	unsigned long max_load_move = env->max_load_move;
 	unsigned long total_load_moved = 0, load_moved;
 
+	update_h_load(cpu_of(env->src_rq));
 	do {
 		env->max_load_move = max_load_move - total_load_moved;
-		load_moved = load_balance_fair(env);
+		load_moved = balance_tasks(env);
 		total_load_moved += load_moved;
 
 		if (env->flags & (LBF_NEED_BREAK|LBF_ABORT))
@@ -4464,6 +4437,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.dst_cpu	= this_cpu,
 		.dst_rq		= this_rq,
 		.idle		= idle,
+		.loop_break	= sysctl_sched_nr_migrate,
 	};
 
 	cpumask_copy(cpus, cpu_active_mask);
@@ -4504,6 +4478,7 @@ redo:
 		env.max_load_move = imbalance;
 		env.src_cpu = busiest->cpu;
 		env.src_rq = busiest;
+		env.loop_max = busiest->nr_running;
 
 		local_irq_save(flags);
 		double_rq_lock(this_rq, busiest);
@@ -4521,9 +4496,7 @@ redo:
 			goto out_balanced;
 
 		if (env.flags & LBF_NEED_BREAK) {
-			env.flags += LBF_HAD_BREAK - LBF_NEED_BREAK;
-			if (env.flags & LBF_ABORT)
-				goto out_balanced;
+			env.flags &= ~LBF_NEED_BREAK;
 			goto redo;
 		}
 
@@ -5357,7 +5330,6 @@ static void set_curr_task_fair(struct rq *rq)
 void init_cfs_rq(struct cfs_rq *cfs_rq)
 {
 	cfs_rq->tasks_timeline = RB_ROOT;
-	INIT_LIST_HEAD(&cfs_rq->tasks);
 	cfs_rq->min_vruntime = (u64)(-(1LL << 20));
 #ifndef CONFIG_64BIT
 	cfs_rq->min_vruntime_copy = cfs_rq->min_vruntime;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c0660a1..753bdd5 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -212,9 +212,6 @@ struct cfs_rq {
 	struct rb_root tasks_timeline;
 	struct rb_node *rb_leftmost;
 
-	struct list_head tasks;
-	struct list_head *balance_iterator;
-
 	/*
 	 * 'curr' points to currently running entity on this cfs_rq.
 	 * It is set to NULL otherwise (i.e when none are currently running).
@@ -242,11 +239,6 @@ struct cfs_rq {
 
 #ifdef CONFIG_SMP
 	/*
-	 * the part of load.weight contributed by tasks
-	 */
-	unsigned long task_weight;
-
-	/*
 	 *   h_load = weight * f(tg)
 	 *
 	 * Where f(tg) is the recursive weight fraction assigned to
@@ -420,6 +412,8 @@ struct rq {
 	int cpu;
 	int online;
 
+	struct list_head cfs_tasks;
+
 	u64 rt_avg;
 	u64 age_stamp;
 	u64 idle_stamp;
