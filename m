Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab2I1IBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:01:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38084 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab2I1IA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:00:58 -0400
Date: Fri, 28 Sep 2012 01:00:27 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-g0gzzzjrvrzxl6kgwnil1e97@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, pjt@google.com,
        cl@linux.com, riel@redhat.com, akpm@linux-foundation.org,
        Lee.Schermerhorn@hp.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        cl@linux.com, riel@redhat.com, akpm@linux-foundation.org,
        Lee.Schermerhorn@hp.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] sched: Implement home-node awareness
Git-Commit-ID: fc2fbef0374693278a767a3d31ef18293e68f6be
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 28 Sep 2012 01:00:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc2fbef0374693278a767a3d31ef18293e68f6be
Gitweb:     http://git.kernel.org/tip/fc2fbef0374693278a767a3d31ef18293e68f6be
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 3 Mar 2012 16:56:25 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Sep 2012 17:04:44 +0200

sched: Implement home-node awareness

Implement home node preference in the scheduler's load-balancer.

This is done in four pieces:

 - task_numa_hot(); make it harder to migrate tasks away from their
   home-node, controlled using the NUMA_HOT feature flag.

 - select_task_rq_fair(); prefer placing the task in their home-node,
   controlled using the NUMA_BIAS feature flag.

 - load_balance(); during the regular pull load-balance pass, try
   pulling tasks that are on the wrong node first with a preference
   of moving them nearer to their home-node through task_numa_hot(),
   controlled through the NUMA_PULL feature flag.

 - load_balance(); when the balancer finds no imbalance, introduce
   some such that it still prefers to move tasks towards their
   home-node, using active load-balance if needed, controlled through
   the NUMA_PULL_BIAS feature flag.

In order to easily find off-node tasks, split the per-cpu task list
into two parts.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-g0gzzzjrvrzxl6kgwnil1e97@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h   |    1 +
 kernel/sched/core.c     |   21 ++++-
 kernel/sched/debug.c    |    3 +
 kernel/sched/fair.c     |  248 +++++++++++++++++++++++++++++++++++++++++++++--
 kernel/sched/features.h |    8 ++
 kernel/sched/sched.h    |   16 +++
 6 files changed, 286 insertions(+), 11 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d28ff49..8755ef1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -861,6 +861,7 @@ enum cpu_idle_type {
 #define SD_ASYM_PACKING		0x0800  /* Place busy groups earlier in the domain */
 #define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
 #define SD_OVERLAP		0x2000	/* sched_domains of this level overlap */
+#define SD_NUMA			0x4000	/* cross-node balancing */
 
 extern int __weak arch_sd_sibiling_asym_packing(void);
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a64c43b..f7e7432 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5472,7 +5472,9 @@ static void destroy_sched_domains(struct sched_domain *sd, int cpu)
 DEFINE_PER_CPU(struct sched_domain *, sd_llc);
 DEFINE_PER_CPU(int, sd_llc_id);
 
-static void update_top_cache_domain(int cpu)
+DEFINE_PER_CPU(struct sched_domain *, sd_node);
+
+static void update_domain_cache(int cpu)
 {
 	struct sched_domain *sd;
 	int id = cpu;
@@ -5515,6 +5517,15 @@ static void update_top_cache_domain(int cpu)
 
 	rcu_assign_pointer(per_cpu(sd_llc, cpu), sd);
 	per_cpu(sd_llc_id, cpu) = id;
+
+	for_each_domain(cpu, sd) {
+		if (cpumask_equal(sched_domain_span(sd),
+				  cpumask_of_node(cpu_to_node(cpu))))
+			goto got_node;
+	}
+	sd = NULL;
+got_node:
+	rcu_assign_pointer(per_cpu(sd_node, cpu), sd);
 }
 
 /*
@@ -5557,7 +5568,7 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 	rcu_assign_pointer(rq->sd, sd);
 	destroy_sched_domains(tmp, cpu);
 
-	update_top_cache_domain(cpu);
+	update_domain_cache(cpu);
 }
 
 /* cpus with isolated domains */
@@ -6060,6 +6071,7 @@ sd_numa_init(struct sched_domain_topology_level *tl, int cpu)
 					| 0*SD_SHARE_PKG_RESOURCES
 					| 1*SD_SERIALIZE
 					| 0*SD_PREFER_SIBLING
+					| 1*SD_NUMA
 					| sd_local_flags(level)
 					,
 		.last_balance		= jiffies,
@@ -6852,6 +6864,11 @@ void __init sched_init(void)
 		rq->avg_idle = 2*sysctl_sched_migration_cost;
 
 		INIT_LIST_HEAD(&rq->cfs_tasks);
+#ifdef CONFIG_SCHED_NUMA
+		INIT_LIST_HEAD(&rq->offnode_tasks);
+		rq->offnode_running = 0;
+		rq->offnode_weight = 0;
+#endif
 
 		rq_attach_root(rq, &def_root_domain);
 #ifdef CONFIG_NO_HZ
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 6f79596..c9a5f75 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -132,6 +132,9 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 	SEQ_printf(m, "%15Ld %15Ld %15Ld.%06ld %15Ld.%06ld %15Ld.%06ld",
 		0LL, 0LL, 0LL, 0L, 0LL, 0L, 0LL, 0L);
 #endif
+#ifdef CONFIG_SCHED_NUMA
+	SEQ_printf(m, " %d/%d", p->node, cpu_to_node(task_cpu(p)));
+#endif
 #ifdef CONFIG_CGROUP_SCHED
 	SEQ_printf(m, " %s", task_group_path(task_group(p)));
 #endif
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ffa10d6..29c4704 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/profile.h>
 #include <linux/interrupt.h>
+#include <linux/random.h>
 
 #include <trace/events/sched.h>
 
@@ -2667,6 +2668,35 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	return target;
 }
 
+#ifdef CONFIG_SCHED_NUMA
+static inline bool pick_numa_rand(int n)
+{
+	return !(get_random_int() % n);
+}
+
+/*
+ * Pick a random elegible CPU in the target node, hopefully faster
+ * than doing a least-loaded scan.
+ */
+static int numa_select_node_cpu(struct task_struct *p, int node)
+{
+	int weight = cpumask_weight(cpumask_of_node(node));
+	int i, cpu = -1;
+
+	for_each_cpu_and(i, cpumask_of_node(node), tsk_cpus_allowed(p)) {
+		if (cpu < 0 || pick_numa_rand(weight))
+			cpu = i;
+	}
+
+	return cpu;
+}
+#else
+static int numa_select_node_cpu(struct task_struct *p, int node)
+{
+	return -1;
+}
+#endif /* CONFIG_SCHED_NUMA */
+
 /*
  * sched_balance_self: balance the current task (running on cpu) in domains
  * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
@@ -2687,6 +2717,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 	int new_cpu = cpu;
 	int want_affine = 0;
 	int sync = wake_flags & WF_SYNC;
+	int node = tsk_home_node(p);
 
 	if (p->nr_cpus_allowed == 1)
 		return prev_cpu;
@@ -2698,6 +2729,33 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 	}
 
 	rcu_read_lock();
+	if (sched_feat_numa(NUMA_BIAS) && node != -1) {
+		/*
+		 * For fork,exec find the idlest cpu in the home-node.
+		 */
+		if (sd_flag & (SD_BALANCE_FORK|SD_BALANCE_EXEC)) {
+			int node_cpu = numa_select_node_cpu(p, node);
+			if (node_cpu < 0)
+				goto find_sd;
+
+			new_cpu = cpu = node_cpu;
+			sd = per_cpu(sd_node, cpu);
+			goto pick_idlest;
+		}
+
+		/*
+		 * For wake, pretend we were running in the home-node.
+		 */
+		if (cpu_to_node(prev_cpu) != node) {
+			int node_cpu = numa_select_node_cpu(p, node);
+			if (node_cpu < 0)
+				goto find_sd;
+
+			prev_cpu = node_cpu;
+		}
+	}
+
+find_sd:
 	for_each_domain(cpu, tmp) {
 		if (!(tmp->flags & SD_LOAD_BALANCE))
 			continue;
@@ -2724,6 +2782,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 		goto unlock;
 	}
 
+pick_idlest:
 	while (sd) {
 		int load_idx = sd->forkexec_idx;
 		struct sched_group *group;
@@ -3046,6 +3105,8 @@ struct lb_env {
 
 	unsigned int		flags;
 
+	struct list_head	*tasks;
+
 	unsigned int		loop;
 	unsigned int		loop_break;
 	unsigned int		loop_max;
@@ -3066,6 +3127,23 @@ static void move_task(struct task_struct *p, struct lb_env *env)
 	check_preempt_curr(env->dst_rq, p, 0);
 }
 
+static int task_numa_hot(struct task_struct *p, int from_cpu, int to_cpu)
+{
+	int from_dist, to_dist;
+	int node = tsk_home_node(p);
+
+	if (!sched_feat_numa(NUMA_HOT) || node == -1)
+		return 0; /* no node preference */
+
+	from_dist = node_distance(cpu_to_node(from_cpu), node);
+	to_dist = node_distance(cpu_to_node(to_cpu), node);
+
+	if (to_dist < from_dist)
+		return 0; /* getting closer is ok */
+
+	return 1; /* stick to where we are */
+}
+
 /*
  * Is this task likely cache-hot:
  */
@@ -3151,6 +3229,7 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	 */
 
 	tsk_cache_hot = task_hot(p, env->src_rq->clock_task, env->sd);
+	tsk_cache_hot |= task_numa_hot(p, env->src_cpu, env->dst_cpu);
 	if (!tsk_cache_hot ||
 		env->sd->nr_balance_failed > env->sd->cache_nice_tries) {
 #ifdef CONFIG_SCHEDSTATS
@@ -3176,11 +3255,11 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
  *
  * Called with both runqueues locked.
  */
-static int move_one_task(struct lb_env *env)
+static int __move_one_task(struct lb_env *env)
 {
 	struct task_struct *p, *n;
 
-	list_for_each_entry_safe(p, n, &env->src_rq->cfs_tasks, se.group_node) {
+	list_for_each_entry_safe(p, n, env->tasks, se.group_node) {
 		if (throttled_lb_pair(task_group(p), env->src_rq->cpu, env->dst_cpu))
 			continue;
 
@@ -3199,6 +3278,21 @@ static int move_one_task(struct lb_env *env)
 	return 0;
 }
 
+static int move_one_task(struct lb_env *env)
+{
+	if (sched_feat_numa(NUMA_PULL)) {
+		env->tasks = offnode_tasks(env->src_rq);
+		if (__move_one_task(env))
+			return 1;
+	}
+
+	env->tasks = &env->src_rq->cfs_tasks;
+	if (__move_one_task(env))
+		return 1;
+
+	return 0;
+}
+
 static unsigned long task_h_load(struct task_struct *p);
 
 static const unsigned int sched_nr_migrate_break = 32;
@@ -3212,7 +3306,6 @@ static const unsigned int sched_nr_migrate_break = 32;
  */
 static int move_tasks(struct lb_env *env)
 {
-	struct list_head *tasks = &env->src_rq->cfs_tasks;
 	struct task_struct *p;
 	unsigned long load;
 	int pulled = 0;
@@ -3220,8 +3313,9 @@ static int move_tasks(struct lb_env *env)
 	if (env->imbalance <= 0)
 		return 0;
 
-	while (!list_empty(tasks)) {
-		p = list_first_entry(tasks, struct task_struct, se.group_node);
+again:
+	while (!list_empty(env->tasks)) {
+		p = list_first_entry(env->tasks, struct task_struct, se.group_node);
 
 		env->loop++;
 		/* We've more or less seen every task there is, call it quits */
@@ -3232,7 +3326,7 @@ static int move_tasks(struct lb_env *env)
 		if (env->loop > env->loop_break) {
 			env->loop_break += sched_nr_migrate_break;
 			env->flags |= LBF_NEED_BREAK;
-			break;
+			goto out;
 		}
 
 		if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
@@ -3260,7 +3354,7 @@ static int move_tasks(struct lb_env *env)
 		 * the critical section.
 		 */
 		if (env->idle == CPU_NEWLY_IDLE)
-			break;
+			goto out;
 #endif
 
 		/*
@@ -3268,13 +3362,20 @@ static int move_tasks(struct lb_env *env)
 		 * weighted load.
 		 */
 		if (env->imbalance <= 0)
-			break;
+			goto out;
 
 		continue;
 next:
-		list_move_tail(&p->se.group_node, tasks);
+		list_move_tail(&p->se.group_node, env->tasks);
+	}
+
+	if (env->tasks == offnode_tasks(env->src_rq)) {
+		env->tasks = &env->src_rq->cfs_tasks;
+		env->loop = 0;
+		goto again;
 	}
 
+out:
 	/*
 	 * Right now, this is one of only two places move_task() is called,
 	 * so we can safely collect move_task() stats here rather than
@@ -3429,6 +3530,11 @@ struct sd_lb_stats {
 	unsigned int  busiest_group_weight;
 
 	int group_imb; /* Is there imbalance in this sd */
+#ifdef CONFIG_SCHED_NUMA
+	struct sched_group *numa_group; /* group which has offnode_tasks */
+	unsigned long numa_group_weight;
+	unsigned long numa_group_running;
+#endif
 };
 
 /*
@@ -3444,6 +3550,10 @@ struct sg_lb_stats {
 	unsigned long group_weight;
 	int group_imb; /* Is there an imbalance in the group ? */
 	int group_has_capacity; /* Is there extra capacity in the group? */
+#ifdef CONFIG_SCHED_NUMA
+	unsigned long numa_weight;
+	unsigned long numa_running;
+#endif
 };
 
 /**
@@ -3472,6 +3582,110 @@ static inline int get_sd_load_idx(struct sched_domain *sd,
 	return load_idx;
 }
 
+#ifdef CONFIG_SCHED_NUMA
+static inline void update_sg_numa_stats(struct sg_lb_stats *sgs, struct rq *rq)
+{
+	sgs->numa_weight += rq->offnode_weight;
+	sgs->numa_running += rq->offnode_running;
+}
+
+/*
+ * Since the offnode lists are indiscriminate (they contain tasks for all other
+ * nodes) it is impossible to say if there's any task on there that wants to
+ * move towards the pulling cpu. Therefore select a random offnode list to pull
+ * from such that eventually we'll try them all.
+ *
+ * Select a random group that has offnode tasks as sds->numa_group
+ */
+static inline void update_sd_numa_stats(struct sched_domain *sd,
+		struct sched_group *group, struct sd_lb_stats *sds,
+		int local_group, struct sg_lb_stats *sgs)
+{
+	if (!(sd->flags & SD_NUMA))
+		return;
+
+	if (local_group)
+		return;
+
+	if (!sgs->numa_running)
+		return;
+
+	if (!sds->numa_group || pick_numa_rand(sd->span_weight / group->group_weight)) {
+		sds->numa_group = group;
+		sds->numa_group_weight = sgs->numa_weight;
+		sds->numa_group_running = sgs->numa_running;
+	}
+}
+
+/*
+ * Pick a random queue from the group that has offnode tasks.
+ */
+static struct rq *find_busiest_numa_queue(struct lb_env *env,
+					  struct sched_group *group)
+{
+	struct rq *busiest = NULL, *rq;
+	int cpu;
+
+	for_each_cpu_and(cpu, sched_group_cpus(group), env->cpus) {
+		rq = cpu_rq(cpu);
+		if (!rq->offnode_running)
+			continue;
+		if (!busiest || pick_numa_rand(group->group_weight))
+			busiest = rq;
+	}
+
+	return busiest;
+}
+
+/*
+ * Called in case of no other imbalance, if there is a queue running offnode
+ * tasksk we'll say we're imbalanced anyway to nudge these tasks towards their
+ * proper node.
+ */
+static inline int check_numa_busiest_group(struct lb_env *env, struct sd_lb_stats *sds)
+{
+	if (!sched_feat(NUMA_PULL_BIAS))
+		return 0;
+
+	if (!sds->numa_group)
+		return 0;
+
+	env->imbalance = sds->numa_group_weight / sds->numa_group_running;
+	sds->busiest = sds->numa_group;
+	env->find_busiest_queue = find_busiest_numa_queue;
+	return 1;
+}
+
+static inline bool need_active_numa_balance(struct lb_env *env)
+{
+	return env->find_busiest_queue == find_busiest_numa_queue &&
+			env->src_rq->offnode_running == 1 &&
+			env->src_rq->nr_running == 1;
+}
+
+#else /* CONFIG_SCHED_NUMA */
+
+static inline void update_sg_numa_stats(struct sg_lb_stats *sgs, struct rq *rq)
+{
+}
+
+static inline void update_sd_numa_stats(struct sched_domain *sd,
+		struct sched_group *group, struct sd_lb_stats *sds,
+		int local_group, struct sg_lb_stats *sgs)
+{
+}
+
+static inline int check_numa_busiest_group(struct lb_env *env, struct sd_lb_stats *sds)
+{
+	return 0;
+}
+
+static inline bool need_active_numa_balance(struct lb_env *env)
+{
+	return false;
+}
+#endif /* CONFIG_SCHED_NUMA */
+
 unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu)
 {
 	return SCHED_POWER_SCALE;
@@ -3687,6 +3901,8 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		sgs->sum_weighted_load += weighted_cpuload(i);
 		if (idle_cpu(i))
 			sgs->idle_cpus++;
+
+		update_sg_numa_stats(sgs, rq);
 	}
 
 	/*
@@ -3840,6 +4056,8 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 			sds->group_imb = sgs.group_imb;
 		}
 
+		update_sd_numa_stats(env->sd, sg, sds, local_group, &sgs);
+
 		sg = sg->next;
 	} while (sg != env->sd->groups);
 }
@@ -4126,6 +4344,9 @@ force_balance:
 	return sds.busiest;
 
 out_balanced:
+	if (check_numa_busiest_group(env, &sds))
+		return sds.busiest;
+
 ret:
 	env->imbalance = 0;
 	return NULL;
@@ -4204,6 +4425,9 @@ static int need_active_balance(struct lb_env *env)
 			return 1;
 	}
 
+	if (need_active_numa_balance(env))
+		return 1;
+
 	return unlikely(sd->nr_balance_failed > sd->cache_nice_tries+2);
 }
 
@@ -4256,6 +4480,8 @@ redo:
 		schedstat_inc(sd, lb_nobusyq[idle]);
 		goto out_balanced;
 	}
+	env.src_rq  = busiest;
+	env.src_cpu = busiest->cpu;
 
 	BUG_ON(busiest == env.dst_rq);
 
@@ -4274,6 +4500,10 @@ redo:
 		env.src_cpu   = busiest->cpu;
 		env.src_rq    = busiest;
 		env.loop_max  = min(sysctl_sched_nr_migrate, busiest->nr_running);
+		if (sched_feat_numa(NUMA_PULL))
+			env.tasks = offnode_tasks(busiest);
+		else
+			env.tasks = &busiest->cfs_tasks;
 
 		update_h_load(env.src_cpu);
 more_balance:
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index eebefca..a5cc07b 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -61,3 +61,11 @@ SCHED_FEAT(TTWU_QUEUE, true)
 SCHED_FEAT(FORCE_SD_OVERLAP, false)
 SCHED_FEAT(RT_RUNTIME_SHARE, true)
 SCHED_FEAT(LB_MIN, false)
+
+#ifdef CONFIG_SCHED_NUMA
+SCHED_FEAT(NUMA_HOT,       true)
+SCHED_FEAT(NUMA_BIAS,      true)
+SCHED_FEAT(NUMA_PULL,      true)
+SCHED_FEAT(NUMA_PULL_BIAS, true)
+#endif
+
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 741272e..74c37e6 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -418,6 +418,12 @@ struct rq {
 
 	struct list_head cfs_tasks;
 
+#ifdef CONFIG_SCHED_NUMA
+	unsigned long    offnode_running;
+	unsigned long	 offnode_weight;
+	struct list_head offnode_tasks;
+#endif
+
 	u64 rt_avg;
 	u64 age_stamp;
 	u64 idle_stamp;
@@ -469,6 +475,15 @@ struct rq {
 #endif
 };
 
+static inline struct list_head *offnode_tasks(struct rq *rq)
+{
+#ifdef CONFIG_SCHED_NUMA
+	return &rq->offnode_tasks;
+#else
+	return NULL;
+#endif
+}
+
 static inline int cpu_of(struct rq *rq)
 {
 #ifdef CONFIG_SMP
@@ -529,6 +544,7 @@ static inline struct sched_domain *highest_flag_domain(int cpu, int flag)
 
 DECLARE_PER_CPU(struct sched_domain *, sd_llc);
 DECLARE_PER_CPU(int, sd_llc_id);
+DECLARE_PER_CPU(struct sched_domain *, sd_node);
 
 extern int group_balance_cpu(struct sched_group *sg);
 
