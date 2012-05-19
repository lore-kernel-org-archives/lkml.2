Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760141Ab2ESLaj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 07:30:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52555 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab2ESLaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 07:30:14 -0400
Date: Sat, 19 May 2012 04:29:39 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-m3pwe9zrkx6ms7wz2ld7b02c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, pjt@google.com,
        cl@linux.com, riel@redhat.com, akpm@linux-foundation.org,
        bharata.rao@gmail.com, aarcange@redhat.com, Lee.Schermerhorn@hp.com,
        suresh.b.siddha@intel.com, danms@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        cl@linux.com, riel@redhat.com, bharata.rao@gmail.com,
        akpm@linux-foundation.org, Lee.Schermerhorn@hp.com,
        aarcange@redhat.com, danms@us.ibm.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] sched: Implement home-node awareness
Git-Commit-ID: a722b115ba8461858e26ba9cf899e98a694e5c72
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 19 May 2012 04:29:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a722b115ba8461858e26ba9cf899e98a694e5c72
Gitweb:     http://git.kernel.org/tip/a722b115ba8461858e26ba9cf899e98a694e5c72
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 3 Mar 2012 16:56:25 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 19 May 2012 12:52:20 +0200

sched: Implement home-node awareness

Implement home node preference in the load-balancer.

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
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Paul Turner <pjt@google.com>
Cc: Dan Smith <danms@us.ibm.com>
Cc: Bharata B Rao <bharata.rao@gmail.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-m3pwe9zrkx6ms7wz2ld7b02c@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h   |    1 +
 kernel/sched/core.c     |   21 ++++-
 kernel/sched/debug.c    |    3 +
 kernel/sched/fair.c     |  236 ++++++++++++++++++++++++++++++++++++++++++++---
 kernel/sched/features.h |    8 ++
 kernel/sched/sched.h    |   18 ++++
 6 files changed, 270 insertions(+), 17 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8bb49f6..89443a4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -860,6 +860,7 @@ enum cpu_idle_type {
 #define SD_ASYM_PACKING		0x0800  /* Place busy groups earlier in the domain */
 #define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
 #define SD_OVERLAP		0x2000	/* sched_domains of this level overlap */
+#define SD_NUMA			0x4000	/* cross-node balancing */
 
 extern int __weak arch_sd_sibiling_asym_packing(void);
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9c9c0ee..aa09403 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5859,7 +5859,9 @@ static void destroy_sched_domains(struct sched_domain *sd, int cpu)
 DEFINE_PER_CPU(struct sched_domain *, sd_llc);
 DEFINE_PER_CPU(int, sd_llc_id);
 
-static void update_top_cache_domain(int cpu)
+DEFINE_PER_CPU(struct sched_domain *, sd_node);
+
+static void update_domain_cache(int cpu)
 {
 	struct sched_domain *sd;
 	int id = cpu;
@@ -5870,6 +5872,15 @@ static void update_top_cache_domain(int cpu)
 
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
@@ -5912,7 +5923,7 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 	rcu_assign_pointer(rq->sd, sd);
 	destroy_sched_domains(tmp, cpu);
 
-	update_top_cache_domain(cpu);
+	update_domain_cache(cpu);
 }
 
 /* cpus with isolated domains */
@@ -6359,6 +6370,7 @@ sd_numa_init(struct sched_domain_topology_level *tl, int cpu)
 					| 0*SD_SHARE_PKG_RESOURCES
 					| 1*SD_SERIALIZE
 					| 0*SD_PREFER_SIBLING
+					| 1*SD_NUMA
 					| sd_local_flags(level)
 					,
 		.last_balance		= jiffies,
@@ -7066,6 +7078,11 @@ void __init sched_init(void)
 		rq->avg_idle = 2*sysctl_sched_migration_cost;
 
 		INIT_LIST_HEAD(&rq->cfs_tasks);
+#ifdef CONFIG_NUMA
+		INIT_LIST_HEAD(&rq->offnode_tasks);
+		rq->offnode_running = 0;
+		rq->offnode_weight = 0;
+#endif
 
 		rq_attach_root(rq, &def_root_domain);
 #ifdef CONFIG_NO_HZ
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 6f79596..c09a4e7 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -132,6 +132,9 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 	SEQ_printf(m, "%15Ld %15Ld %15Ld.%06ld %15Ld.%06ld %15Ld.%06ld",
 		0LL, 0LL, 0LL, 0L, 0LL, 0L, 0LL, 0L);
 #endif
+#ifdef CONFIG_NUMA
+	SEQ_printf(m, " %d/%d", p->node, cpu_to_node(task_cpu(p)));
+#endif
 #ifdef CONFIG_CGROUP_SCHED
 	SEQ_printf(m, " %s", task_group_path(task_group(p)));
 #endif
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 34a221c..3b12b48 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/profile.h>
 #include <linux/interrupt.h>
+#include <linux/random.h>
 
 #include <trace/events/sched.h>
 
@@ -783,8 +784,10 @@ account_entity_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	if (!parent_entity(se))
 		update_load_add(&rq_of(cfs_rq)->load, se->load.weight);
 #ifdef CONFIG_SMP
-	if (entity_is_task(se))
-		list_add(&se->group_node, &rq_of(cfs_rq)->cfs_tasks);
+	if (entity_is_task(se)) {
+		if (!account_numa_enqueue(task_of(se)))
+			list_add(&se->group_node, &rq_of(cfs_rq)->cfs_tasks);
+	}
 #endif
 	cfs_rq->nr_running++;
 }
@@ -795,8 +798,10 @@ account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	update_load_sub(&cfs_rq->load, se->load.weight);
 	if (!parent_entity(se))
 		update_load_sub(&rq_of(cfs_rq)->load, se->load.weight);
-	if (entity_is_task(se))
+	if (entity_is_task(se)) {
 		list_del_init(&se->group_node);
+		account_numa_dequeue(task_of(se));
+	}
 	cfs_rq->nr_running--;
 }
 
@@ -2702,6 +2707,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 	int want_affine = 0;
 	int want_sd = 1;
 	int sync = wake_flags & WF_SYNC;
+	int node = tsk_home_node(p);
 
 	if (p->rt.nr_cpus_allowed == 1)
 		return prev_cpu;
@@ -2713,6 +2719,29 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 	}
 
 	rcu_read_lock();
+	if (sched_feat_numa(NUMA_BIAS) && node != -1) {
+		int node_cpu;
+
+		node_cpu = cpumask_any_and(tsk_cpus_allowed(p), cpumask_of_node(node));
+		if (node_cpu >= nr_cpu_ids)
+			goto find_sd;
+
+		/*
+		 * For fork,exec find the idlest cpu in the home-node.
+		 */
+		if (sd_flag & (SD_BALANCE_FORK|SD_BALANCE_EXEC)) {
+			new_cpu = cpu = node_cpu;
+			sd = per_cpu(sd_node, cpu);
+			goto pick_idlest;
+		}
+
+		/*
+		 * For wake, pretend we were running in the home-node.
+		 */
+		prev_cpu = node_cpu;
+	}
+
+find_sd:
 	for_each_domain(cpu, tmp) {
 		if (!(tmp->flags & SD_LOAD_BALANCE))
 			continue;
@@ -2766,6 +2795,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 		goto unlock;
 	}
 
+pick_idlest:
 	while (sd) {
 		int load_idx = sd->forkexec_idx;
 		struct sched_group *group;
@@ -3082,6 +3112,8 @@ struct lb_env {
 	long			imbalance;
 	unsigned int		flags;
 
+	struct list_head	*tasks;
+
 	unsigned int		loop;
 	unsigned int		loop_break;
 	unsigned int		loop_max;
@@ -3103,6 +3135,23 @@ static void move_task(struct task_struct *p, struct lb_env *env)
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
@@ -3166,6 +3215,7 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	 */
 
 	tsk_cache_hot = task_hot(p, env->src_rq->clock_task, env->sd);
+	tsk_cache_hot |= task_numa_hot(p, env->src_cpu, env->dst_cpu);
 	if (!tsk_cache_hot ||
 		env->sd->nr_balance_failed > env->sd->cache_nice_tries) {
 #ifdef CONFIG_SCHEDSTATS
@@ -3191,11 +3241,11 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
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
 
@@ -3214,6 +3264,21 @@ static int move_one_task(struct lb_env *env)
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
@@ -3227,7 +3292,6 @@ static const unsigned int sched_nr_migrate_break = 32;
  */
 static int move_tasks(struct lb_env *env)
 {
-	struct list_head *tasks = &env->src_rq->cfs_tasks;
 	struct task_struct *p;
 	unsigned long load;
 	int pulled = 0;
@@ -3235,8 +3299,9 @@ static int move_tasks(struct lb_env *env)
 	if (env->imbalance <= 0)
 		return 0;
 
-	while (!list_empty(tasks)) {
-		p = list_first_entry(tasks, struct task_struct, se.group_node);
+again:
+	while (!list_empty(env->tasks)) {
+		p = list_first_entry(env->tasks, struct task_struct, se.group_node);
 
 		env->loop++;
 		/* We've more or less seen every task there is, call it quits */
@@ -3247,7 +3312,7 @@ static int move_tasks(struct lb_env *env)
 		if (env->loop > env->loop_break) {
 			env->loop_break += sched_nr_migrate_break;
 			env->flags |= LBF_NEED_BREAK;
-			break;
+			goto out;
 		}
 
 		if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
@@ -3275,7 +3340,7 @@ static int move_tasks(struct lb_env *env)
 		 * the critical section.
 		 */
 		if (env->idle == CPU_NEWLY_IDLE)
-			break;
+			goto out;
 #endif
 
 		/*
@@ -3283,13 +3348,20 @@ static int move_tasks(struct lb_env *env)
 		 * weighted load.
 		 */
 		if (env->imbalance <= 0)
-			break;
+			goto out;
 
 		continue;
 next:
-		list_move_tail(&p->se.group_node, tasks);
+		list_move_tail(&p->se.group_node, env->tasks);
 	}
 
+	if (env->tasks == offnode_tasks(env->src_rq)) {
+		env->tasks = &env->src_rq->cfs_tasks;
+		env->loop = 0;
+		goto again;
+	}
+
+out:
 	/*
 	 * Right now, this is one of only two places move_task() is called,
 	 * so we can safely collect move_task() stats here rather than
@@ -3436,6 +3508,11 @@ struct sd_lb_stats {
 	unsigned int  busiest_group_weight;
 
 	int group_imb; /* Is there imbalance in this sd */
+#ifdef CONFIG_NUMA
+	struct sched_group *numa_group; /* group which has offnode_tasks */
+	unsigned long numa_group_weight;
+	unsigned long numa_group_running;
+#endif
 };
 
 /*
@@ -3451,6 +3528,10 @@ struct sg_lb_stats {
 	unsigned long group_weight;
 	int group_imb; /* Is there an imbalance in the group ? */
 	int group_has_capacity; /* Is there extra capacity in the group? */
+#ifdef CONFIG_NUMA
+	unsigned long numa_weight;
+	unsigned long numa_running;
+#endif
 };
 
 /**
@@ -3479,6 +3560,117 @@ static inline int get_sd_load_idx(struct sched_domain *sd,
 	return load_idx;
 }
 
+#ifdef CONFIG_NUMA
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
+ */
+static inline bool pick_numa_rand(void)
+{
+	return get_random_int() & 1;
+}
+
+/*
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
+	if (!sds->numa_group || pick_numa_rand()) {
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
+					  struct sched_group *group,
+					  const struct cpumask *cpus)
+{
+	struct rq *busiest = NULL, *rq;
+	int cpu;
+
+	for_each_cpu_and(cpu, sched_group_cpus(group), cpus) {
+		rq = cpu_rq(cpu);
+		if (!rq->offnode_running)
+			continue;
+		if (!busiest || pick_numa_rand())
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
+#else /* CONFIG_NUMA */
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
+#endif /* CONFIG_NUMA */
+
 unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu)
 {
 	return SCHED_POWER_SCALE;
@@ -3673,6 +3865,8 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		sgs->sum_weighted_load += weighted_cpuload(i);
 		if (idle_cpu(i))
 			sgs->idle_cpus++;
+
+		update_sg_numa_stats(sgs, rq);
 	}
 
 	/*
@@ -3832,6 +4026,8 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 			sds->group_imb = sgs.group_imb;
 		}
 
+		update_sd_numa_stats(env->sd, sg, sds, local_group, &sgs);
+
 		sg = sg->next;
 	} while (sg != env->sd->groups);
 }
@@ -4126,6 +4322,9 @@ force_balance:
 	return sds.busiest;
 
 out_balanced:
+	if (check_numa_busiest_group(env, &sds))
+		return sds.busiest;
+
 ret:
 	env->imbalance = 0;
 	return NULL;
@@ -4205,6 +4404,9 @@ static int need_active_balance(struct lb_env *env)
 			return 1;
 	}
 
+	if (need_active_numa_balance(env))
+		return 1;
+
 	return unlikely(sd->nr_balance_failed > sd->cache_nice_tries+2);
 }
 
@@ -4253,6 +4455,8 @@ redo:
 		schedstat_inc(sd, lb_nobusyq[idle]);
 		goto out_balanced;
 	}
+	env.src_rq  = busiest;
+	env.src_cpu = busiest->cpu;
 
 	BUG_ON(busiest == this_rq);
 
@@ -4267,9 +4471,11 @@ redo:
 		 * correctly treated as an imbalance.
 		 */
 		env.flags |= LBF_ALL_PINNED;
-		env.src_cpu   = busiest->cpu;
-		env.src_rq    = busiest;
-		env.loop_max  = min(sysctl_sched_nr_migrate, busiest->nr_running);
+		env.loop_max = min(sysctl_sched_nr_migrate, busiest->nr_running);
+		if (sched_feat_numa(NUMA_PULL))
+			env.tasks = offnode_tasks(busiest);
+		else
+			env.tasks = &busiest->cfs_tasks;
 
 more_balance:
 		local_irq_save(flags);
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index de00a48..17e38e0 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -69,3 +69,11 @@ SCHED_FEAT(TTWU_QUEUE, true)
 SCHED_FEAT(FORCE_SD_OVERLAP, false)
 SCHED_FEAT(RT_RUNTIME_SHARE, true)
 SCHED_FEAT(LB_MIN, false)
+
+#ifdef CONFIG_NUMA
+SCHED_FEAT(NUMA_HOT,       true)
+SCHED_FEAT(NUMA_BIAS,      true)
+SCHED_FEAT(NUMA_PULL,      true)
+SCHED_FEAT(NUMA_PULL_BIAS, true)
+#endif
+
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 0d6d1c0..8bf3c72 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -414,6 +414,12 @@ struct rq {
 
 	struct list_head cfs_tasks;
 
+#ifdef CONFIG_NUMA
+	unsigned long    offnode_running;
+	unsigned long	 offnode_weight;
+	struct list_head offnode_tasks;
+#endif
+
 	u64 rt_avg;
 	u64 age_stamp;
 	u64 idle_stamp;
@@ -465,6 +471,15 @@ struct rq {
 #endif
 };
 
+static inline struct list_head *offnode_tasks(struct rq *rq)
+{
+#ifdef CONFIG_NUMA
+	return &rq->offnode_tasks;
+#else
+	return NULL;
+#endif
+}
+
 static inline int cpu_of(struct rq *rq)
 {
 #ifdef CONFIG_SMP
@@ -525,6 +540,7 @@ static inline struct sched_domain *highest_flag_domain(int cpu, int flag)
 
 DECLARE_PER_CPU(struct sched_domain *, sd_llc);
 DECLARE_PER_CPU(int, sd_llc_id);
+DECLARE_PER_CPU(struct sched_domain *, sd_node);
 
 #endif /* CONFIG_SMP */
 
@@ -1167,3 +1183,5 @@ enum rq_nohz_flag_bits {
  * Macro to avoid argument evaluation
  */
 #define select_task_node(p, mm, sd_flags) do { } while (0)
+static inline bool account_numa_enqueue(struct task_struct *p) { return false; }
+static inline void account_numa_dequeue(struct task_struct *p) { }
