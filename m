Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967945Ab2ERKgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:36:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42538 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762338Ab2ERKgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:36:51 -0400
Date: Fri, 18 May 2012 03:36:16 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-3n9wqw2rdmhtu7qjhpoegh7u@git.kernel.org>
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
Subject: [tip:sched/numa] sched: Make find_busiest_queue a method
Git-Commit-ID: 2a7910b97834876332e58713674cd8194b5c082c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:36:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2a7910b97834876332e58713674cd8194b5c082c
Gitweb:     http://git.kernel.org/tip/2a7910b97834876332e58713674cd8194b5c082c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 3 Mar 2012 16:56:25 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 08:16:23 +0200

sched: Make find_busiest_queue a method

Its a bit awkward but it was the least painful means of modifying the
queue selection. Used in a later patch to conditionally use a random
queue.

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
Link: http://lkml.kernel.org/n/tip-3n9wqw2rdmhtu7qjhpoegh7u@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mm_types.h |    8 +
 include/linux/sched.h    |   14 +
 init/Kconfig             |    2 +-
 kernel/fork.c            |    2 +
 kernel/sched/Makefile    |    1 +
 kernel/sched/core.c      |   22 ++-
 kernel/sched/debug.c     |    3 +
 kernel/sched/fair.c      |  257 +++++++++++++++--
 kernel/sched/features.h  |   12 +
 kernel/sched/numa.c      |  741 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h     |   34 +++
 mm/init-mm.c             |   10 +
 12 files changed, 1079 insertions(+), 27 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 3cc3062..6a85ad7 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -285,6 +285,13 @@ struct mm_rss_stat {
 	atomic_long_t count[NR_MM_COUNTERS];
 };
 
+struct numa_entity {
+#ifdef CONFIG_NUMA
+	int		 node;		/* home node */
+	struct list_head numa_entry;	/* balance list */
+#endif
+};
+
 struct mm_struct {
 	struct vm_area_struct * mmap;		/* list of VMAs */
 	struct rb_root mm_rb;
@@ -388,6 +395,7 @@ struct mm_struct {
 #ifdef CONFIG_CPUMASK_OFFSTACK
 	struct cpumask cpumask_allocation;
 #endif
+	struct numa_entity numa;
 };
 
 static inline void mm_init_cpumask(struct mm_struct *mm)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8bb49f6..fe6e535 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -860,6 +860,7 @@ enum cpu_idle_type {
 #define SD_ASYM_PACKING		0x0800  /* Place busy groups earlier in the domain */
 #define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
 #define SD_OVERLAP		0x2000	/* sched_domains of this level overlap */
+#define SD_NUMA			0x4000	/* cross-node balancing */
 
 extern int __weak arch_sd_sibiling_asym_packing(void);
 
@@ -1233,6 +1234,11 @@ struct task_struct {
 	struct sched_entity se;
 	struct sched_rt_entity rt;
 
+#ifdef CONFIG_NUMA
+	unsigned long	 numa_contrib;
+	int		 numa_remote;
+#endif
+
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	/* list of struct preempt_notifier: */
 	struct hlist_head preempt_notifiers;
@@ -2781,6 +2787,14 @@ static inline unsigned long rlimit_max(unsigned int limit)
 	return task_rlimit_max(current, limit);
 }
 
+#ifdef CONFIG_NUMA
+void mm_init_numa(struct mm_struct *mm);
+void exit_numa(struct mm_struct *mm);
+#else
+static inline void mm_init_numa(struct mm_struct *mm) { }
+static inline void exit_numa(struct mm_struct *mm) { }
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif
diff --git a/init/Kconfig b/init/Kconfig
index 6cfd71d..e4e84f2 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -866,7 +866,7 @@ config SCHED_AUTOGROUP
 	  upon task session.
 
 config MM_OWNER
-	bool
+	def_bool NUMA
 
 config SYSFS_DEPRECATED
 	bool "Enable deprecated sysfs features to support old userspace tools"
diff --git a/kernel/fork.c b/kernel/fork.c
index 7acf6ae..89deafa 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -527,6 +527,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
 	mm->cached_hole_size = ~0UL;
 	mm_init_aio(mm);
 	mm_init_owner(mm, p);
+	mm_init_numa(mm);
 
 	if (likely(!mm_alloc_pgd(mm))) {
 		mm->def_flags = 0;
@@ -595,6 +596,7 @@ void mmput(struct mm_struct *mm)
 	might_sleep();
 
 	if (atomic_dec_and_test(&mm->mm_users)) {
+		exit_numa(mm);
 		exit_aio(mm);
 		ksm_exit(mm);
 		khugepaged_exit(mm); /* must run before exit_mmap */
diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index 173ea52..19026ba 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -16,3 +16,4 @@ obj-$(CONFIG_SMP) += cpupri.o
 obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
 obj-$(CONFIG_SCHEDSTATS) += stats.o
 obj-$(CONFIG_SCHED_DEBUG) += debug.o
+obj-$(CONFIG_NUMA) += numa.o
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9c9c0ee..60edb52 100644
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
@@ -7115,6 +7132,7 @@ void __init sched_init(void)
 	idle_thread_set_boot_cpu();
 #endif
 	init_sched_fair_class();
+	init_sched_numa();
 
 	scheduler_running = 1;
 }
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
index 940e6d1..de49ed5 100644
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
@@ -3082,9 +3112,15 @@ struct lb_env {
 	long			imbalance;
 	unsigned int		flags;
 
+	struct list_head	*tasks;
+
 	unsigned int		loop;
 	unsigned int		loop_break;
 	unsigned int		loop_max;
+
+	struct rq *		(*find_busiest_queue)(struct lb_env *,
+						      struct sched_group *,
+						      const struct cpumask *);
 };
 
 /*
@@ -3099,6 +3135,23 @@ static void move_task(struct task_struct *p, struct lb_env *env)
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
@@ -3162,6 +3215,7 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	 */
 
 	tsk_cache_hot = task_hot(p, env->src_rq->clock_task, env->sd);
+	tsk_cache_hot |= task_numa_hot(p, env->src_cpu, env->dst_cpu);
 	if (!tsk_cache_hot ||
 		env->sd->nr_balance_failed > env->sd->cache_nice_tries) {
 #ifdef CONFIG_SCHEDSTATS
@@ -3187,11 +3241,11 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
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
 
@@ -3210,7 +3264,20 @@ static int move_one_task(struct lb_env *env)
 	return 0;
 }
 
-static unsigned long task_h_load(struct task_struct *p);
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
 
 static const unsigned int sched_nr_migrate_break = 32;
 
@@ -3223,7 +3290,6 @@ static const unsigned int sched_nr_migrate_break = 32;
  */
 static int move_tasks(struct lb_env *env)
 {
-	struct list_head *tasks = &env->src_rq->cfs_tasks;
 	struct task_struct *p;
 	unsigned long load;
 	int pulled = 0;
@@ -3231,8 +3297,9 @@ static int move_tasks(struct lb_env *env)
 	if (env->imbalance <= 0)
 		return 0;
 
-	while (!list_empty(tasks)) {
-		p = list_first_entry(tasks, struct task_struct, se.group_node);
+again:
+	while (!list_empty(env->tasks)) {
+		p = list_first_entry(env->tasks, struct task_struct, se.group_node);
 
 		env->loop++;
 		/* We've more or less seen every task there is, call it quits */
@@ -3243,7 +3310,7 @@ static int move_tasks(struct lb_env *env)
 		if (env->loop > env->loop_break) {
 			env->loop_break += sched_nr_migrate_break;
 			env->flags |= LBF_NEED_BREAK;
-			break;
+			goto out;
 		}
 
 		if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
@@ -3271,7 +3338,7 @@ static int move_tasks(struct lb_env *env)
 		 * the critical section.
 		 */
 		if (env->idle == CPU_NEWLY_IDLE)
-			break;
+			goto out;
 #endif
 
 		/*
@@ -3279,13 +3346,20 @@ static int move_tasks(struct lb_env *env)
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
@@ -3378,7 +3452,7 @@ static void update_h_load(long cpu)
 	rcu_read_unlock();
 }
 
-static unsigned long task_h_load(struct task_struct *p)
+unsigned long task_h_load(struct task_struct *p)
 {
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
 	unsigned long load;
@@ -3397,7 +3471,7 @@ static inline void update_h_load(long cpu)
 {
 }
 
-static unsigned long task_h_load(struct task_struct *p)
+unsigned long task_h_load(struct task_struct *p)
 {
 	return p->se.load.weight;
 }
@@ -3432,6 +3506,11 @@ struct sd_lb_stats {
 	unsigned int  busiest_group_weight;
 
 	int group_imb; /* Is there imbalance in this sd */
+#ifdef CONFIG_NUMA
+	struct sched_group *numa_group; /* group which has offnode_tasks */
+	unsigned long numa_group_weight;
+	unsigned long numa_group_running;
+#endif
 };
 
 /*
@@ -3447,6 +3526,10 @@ struct sg_lb_stats {
 	unsigned long group_weight;
 	int group_imb; /* Is there an imbalance in the group ? */
 	int group_has_capacity; /* Is there extra capacity in the group? */
+#ifdef CONFIG_NUMA
+	unsigned long numa_weight;
+	unsigned long numa_running;
+#endif
 };
 
 /**
@@ -3475,6 +3558,117 @@ static inline int get_sd_load_idx(struct sched_domain *sd,
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
@@ -3669,6 +3863,8 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		sgs->sum_weighted_load += weighted_cpuload(i);
 		if (idle_cpu(i))
 			sgs->idle_cpus++;
+
+		update_sg_numa_stats(sgs, rq);
 	}
 
 	/*
@@ -3828,6 +4024,8 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 			sds->group_imb = sgs.group_imb;
 		}
 
+		update_sd_numa_stats(env->sd, sg, sds, local_group, &sgs);
+
 		sg = sg->next;
 	} while (sg != env->sd->groups);
 }
@@ -4122,6 +4320,9 @@ force_balance:
 	return sds.busiest;
 
 out_balanced:
+	if (check_numa_busiest_group(env, &sds))
+		return sds.busiest;
+
 ret:
 	env->imbalance = 0;
 	return NULL;
@@ -4201,6 +4402,9 @@ static int need_active_balance(struct lb_env *env)
 			return 1;
 	}
 
+	if (need_active_numa_balance(env))
+		return 1;
+
 	return unlikely(sd->nr_balance_failed > sd->cache_nice_tries+2);
 }
 
@@ -4221,11 +4425,12 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
 
 	struct lb_env env = {
-		.sd		= sd,
-		.dst_cpu	= this_cpu,
-		.dst_rq		= this_rq,
-		.idle		= idle,
-		.loop_break	= sched_nr_migrate_break,
+		.sd		    = sd,
+		.dst_cpu	    = this_cpu,
+		.dst_rq		    = this_rq,
+		.idle		    = idle,
+		.loop_break	    = sched_nr_migrate_break,
+		.find_busiest_queue = find_busiest_queue,
 	};
 
 	cpumask_copy(cpus, cpu_active_mask);
@@ -4243,11 +4448,13 @@ redo:
 		goto out_balanced;
 	}
 
-	busiest = find_busiest_queue(&env, group, cpus);
+	busiest = env.find_busiest_queue(&env, group, cpus);
 	if (!busiest) {
 		schedstat_inc(sd, lb_nobusyq[idle]);
 		goto out_balanced;
 	}
+	env.src_rq  = busiest;
+	env.src_cpu = busiest->cpu;
 
 	BUG_ON(busiest == this_rq);
 
@@ -4262,9 +4469,11 @@ redo:
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
index de00a48..dc65178 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -69,3 +69,15 @@ SCHED_FEAT(TTWU_QUEUE, true)
 SCHED_FEAT(FORCE_SD_OVERLAP, false)
 SCHED_FEAT(RT_RUNTIME_SHARE, true)
 SCHED_FEAT(LB_MIN, false)
+
+#ifdef CONFIG_NUMA
+SCHED_FEAT(NUMA_HOT,       true)
+SCHED_FEAT(NUMA_BIAS,      true)
+SCHED_FEAT(NUMA_PULL,      true)
+SCHED_FEAT(NUMA_PULL_BIAS, true)
+SCHED_FEAT(NUMA_BALANCE,   true)
+SCHED_FEAT(NUMA_SELECT,    true)
+SCHED_FEAT(NUMA_SLOW,      false)
+SCHED_FEAT(NUMA_BALANCE_FILTER, false)
+#endif
+
diff --git a/kernel/sched/numa.c b/kernel/sched/numa.c
new file mode 100644
index 0000000..c9ec90d
--- /dev/null
+++ b/kernel/sched/numa.c
@@ -0,0 +1,741 @@
+/*
+ * NUMA scheduler
+ *
+ *  Copyright (C) 2011-2012 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *
+ * With input and fixes from:
+ *
+ *  Ingo Molnar <mingo@elte.hu>
+ *  Bharata B Rao <bharata@linux.vnet.ibm.com>
+ *  Dan Smith <danms@us.ibm.com>
+ *
+ * For licensing details see kernel-base/COPYING
+ */
+
+#include <linux/mempolicy.h>
+#include <linux/kthread.h>
+
+#include "sched.h"
+
+
+static const int numa_balance_interval = 2 * HZ; /* 2 seconds */
+
+struct numa_cpu_load {
+	unsigned long	remote; /* load of tasks running away from their home node */
+	unsigned long	all;	/* load of tasks that should be running on this node */
+};
+
+static struct numa_cpu_load **numa_load_array;
+
+static struct {
+	spinlock_t		lock;
+	unsigned long		load;
+} max_mem_load = {
+	.lock = __SPIN_LOCK_UNLOCKED(max_mem_load.lock),
+	.load = 0,
+};
+
+/*
+ * Assumes symmetric NUMA -- that is, each node is of equal size.
+ */
+static void set_max_mem_load(unsigned long load)
+{
+	unsigned long old_load;
+
+	spin_lock(&max_mem_load.lock);
+	old_load = max_mem_load.load;
+	if (!old_load)
+		old_load = load;
+	max_mem_load.load = (old_load + load) >> 1;
+	spin_unlock(&max_mem_load.lock);
+}
+
+static unsigned long get_max_mem_load(void)
+{
+	return max_mem_load.load;
+}
+
+struct node_queue {
+	struct task_struct	*numad;
+
+	unsigned long		remote_cpu_load;
+	unsigned long		cpu_load;
+
+	unsigned long		prev_numa_foreign;
+	unsigned long		remote_mem_load;
+
+	spinlock_t		lock;
+	struct list_head	entity_list;
+	int			nr_processes;
+
+	unsigned long		next_schedule;
+	int			node;
+};
+
+static struct node_queue **nqs;
+
+static inline struct node_queue *nq_of(int node)
+{
+	return nqs[node];
+}
+
+static inline struct node_queue *this_nq(void)
+{
+	return nq_of(numa_node_id());
+}
+
+bool account_numa_enqueue(struct task_struct *p)
+{
+	int home_node = tsk_home_node(p);
+	int cpu = task_cpu(p);
+	int node = cpu_to_node(cpu);
+	struct rq *rq = cpu_rq(cpu);
+	struct numa_cpu_load *nl;
+	unsigned long load;
+
+	/*
+	 * not actually an auto-numa task, ignore
+	 */
+	if (home_node == -1)
+		return false;
+
+	load = task_h_load(p);
+	nl = this_cpu_ptr(numa_load_array[home_node]);
+	p->numa_remote = (node != home_node);
+	p->numa_contrib = load;
+	nl->all += load;
+	if (p->numa_remote)
+		nl->remote += load;
+
+	/*
+	 * the task is on its home-node, we're done, the rest is offnode
+	 * accounting.
+	 */
+	if (!p->numa_remote)
+		return false;
+
+	list_add_tail(&p->se.group_node, &rq->offnode_tasks);
+	rq->offnode_running++;
+	rq->offnode_weight += load;
+
+	return true;
+}
+
+void account_numa_dequeue(struct task_struct *p)
+{
+	int home_node = tsk_home_node(p);
+	struct numa_cpu_load *nl;
+	struct rq *rq;
+
+	/*
+	 * not actually an auto-numa task, ignore
+	 */
+	if (home_node == -1)
+		return;
+
+	nl = this_cpu_ptr(numa_load_array[home_node]);
+	nl->all -= p->numa_contrib;
+	if (p->numa_remote)
+		nl->remote -= p->numa_contrib;
+
+	/*
+	 * the task is on its home-node, we're done, the rest is offnode
+	 * accounting.
+	 */
+	if (!p->numa_remote)
+		return;
+
+	rq = task_rq(p);
+	rq->offnode_running--;
+	rq->offnode_weight -= p->numa_contrib;
+}
+
+static inline struct mm_struct *ne_mm(struct numa_entity *ne)
+{
+	return container_of(ne, struct mm_struct, numa);
+}
+
+static inline struct task_struct *ne_owner(struct numa_entity *ne)
+{
+	return rcu_dereference(ne_mm(ne)->owner);
+}
+
+static void process_cpu_migrate(struct numa_entity *ne, int node)
+{
+	struct task_struct *p, *t;
+
+	rcu_read_lock();
+	t = p = ne_owner(ne);
+	if (p) do {
+		sched_setnode(t, node);
+	} while ((t = next_thread(t)) != p);
+	rcu_read_unlock();
+}
+
+static void process_mem_migrate(struct numa_entity *ne, int node)
+{
+	lazy_migrate_process(ne_mm(ne), node);
+}
+
+static int process_tryget(struct numa_entity *ne)
+{
+	/*
+	 * This is possible when we hold &nq_of(ne->node)->lock since then
+	 * numa_exit() will block on that lock, we can't however write an
+	 * assertion to check this, since if we don't hold the lock that
+	 * expression isn't safe to evaluate.
+	 */
+	return atomic_inc_not_zero(&ne_mm(ne)->mm_users);
+}
+
+static void process_put(struct numa_entity *ne)
+{
+	mmput(ne_mm(ne));
+}
+
+static struct node_queue *lock_ne_nq(struct numa_entity *ne)
+{
+	struct node_queue *nq;
+	int node;
+
+	for (;;) {
+		node = ACCESS_ONCE(ne->node);
+		BUG_ON(node == -1);
+		nq = nq_of(node);
+
+		spin_lock(&nq->lock);
+		if (likely(ne->node == node))
+			break;
+		spin_unlock(&nq->lock);
+	}
+
+	return nq;
+}
+
+static void double_lock_nq(struct node_queue *nq1, struct node_queue *nq2)
+{
+	if (nq1 > nq2)
+		swap(nq1, nq2);
+
+	spin_lock(&nq1->lock);
+	if (nq2 != nq1)
+		spin_lock_nested(&nq2->lock, SINGLE_DEPTH_NESTING);
+}
+
+static void double_unlock_nq(struct node_queue *nq1, struct node_queue *nq2)
+{
+	if (nq1 > nq2)
+		swap(nq1, nq2);
+
+	if (nq2 != nq1)
+		spin_unlock(&nq2->lock);
+	spin_unlock(&nq1->lock);
+}
+
+static void __enqueue_ne(struct node_queue *nq, struct numa_entity *ne)
+{
+	ne->node = nq->node;
+	list_add_tail(&ne->numa_entry, &nq->entity_list);
+	nq->nr_processes++;
+}
+
+static void __dequeue_ne(struct node_queue *nq, struct numa_entity *ne)
+{
+	list_del(&ne->numa_entry);
+	nq->nr_processes--;
+	BUG_ON(nq->nr_processes < 0);
+}
+
+static void enqueue_ne(struct numa_entity *ne, int node)
+{
+	struct node_queue *nq = nq_of(node);
+
+	BUG_ON(ne->node != -1);
+
+	process_cpu_migrate(ne, node);
+	process_mem_migrate(ne, node);
+
+	spin_lock(&nq->lock);
+	__enqueue_ne(nq, ne);
+	spin_unlock(&nq->lock);
+}
+
+static void dequeue_ne(struct numa_entity *ne)
+{
+	struct node_queue *nq;
+
+	if (ne->node == -1) // XXX serialization
+		return;
+
+	nq = lock_ne_nq(ne);
+	ne->node = -1;
+	__dequeue_ne(nq, ne);
+	spin_unlock(&nq->lock);
+}
+
+static void init_ne(struct numa_entity *ne)
+{
+	ne->node = -1;
+}
+
+void mm_init_numa(struct mm_struct *mm)
+{
+	init_ne(&mm->numa);
+}
+
+void exit_numa(struct mm_struct *mm)
+{
+	dequeue_ne(&mm->numa);
+}
+
+static inline unsigned long node_pages_load(int node)
+{
+	unsigned long pages = 0;
+
+	pages += node_page_state(node, NR_ANON_PAGES);
+	pages += node_page_state(node, NR_ACTIVE_FILE);
+
+	return pages;
+}
+
+static int find_idlest_node(int this_node)
+{
+	unsigned long mem_load, cpu_load;
+	unsigned long min_cpu_load;
+	unsigned long this_cpu_load;
+	int min_node;
+	int node, cpu;
+
+	min_node = -1;
+	this_cpu_load = min_cpu_load = ULONG_MAX;
+
+	// XXX should be sched_domain aware
+	for_each_online_node(node) {
+		struct node_queue *nq = nq_of(node);
+		/*
+		 * Pick the node that has least cpu load provided there's no
+		 * foreign memory load.
+		 *
+		 * XXX if all nodes were to have foreign allocations we'd OOM,
+		 *     however check the low-pass filter in update_node_load().
+		 */
+		mem_load = nq->remote_mem_load;
+		if (mem_load)
+			continue;
+
+		cpu_load = 0;
+		for_each_cpu_mask(cpu, *cpumask_of_node(node))
+			cpu_load += cpu_rq(cpu)->load.weight;
+		cpu_load += nq->remote_cpu_load;
+
+		if (this_node == node)
+			this_cpu_load = cpu_load;
+
+		if (cpu_load < min_cpu_load) {
+			min_cpu_load = cpu_load;
+			min_node = node;
+		}
+	}
+
+	/*
+	 * If there's no choice, stick to where we are.
+	 */
+	if (min_node == -1)
+		return this_node;
+
+	/*
+	 * Add a little hysteresis so we don't hard-interleave over nodes
+	 * scattering workloads.
+	 */
+	if (this_cpu_load != ULONG_MAX && this_node != min_node) {
+		if (this_cpu_load * 100 < min_cpu_load * 110)
+			return this_node;
+	}
+
+	return min_node;
+}
+
+void select_task_node(struct task_struct *p, struct mm_struct *mm, int sd_flags)
+{
+	int node;
+
+	if (!sched_feat(NUMA_SELECT)) {
+		p->node = -1;
+		return;
+	}
+
+	if (!mm)
+		return;
+
+	/*
+	 * If there's an explicit task policy set, bail.
+	 */
+	if (p->flags & PF_MEMPOLICY) {
+		p->node = -1;
+		return;
+	}
+
+	if (sd_flags & SD_BALANCE_FORK) {
+		/* For new threads, set the home-node. */
+		if (mm == current->mm) {
+			p->node = mm->numa.node;
+			return;
+		}
+	}
+
+	node = find_idlest_node(p->node);
+	if (node == -1)
+		node = numa_node_id();
+	enqueue_ne(&mm->numa, node);
+}
+
+__init void init_sched_numa(void)
+{
+	int node;
+
+	numa_load_array = kzalloc(sizeof(struct numa_cpu_load *) * nr_node_ids, GFP_KERNEL);
+	BUG_ON(!numa_load_array);
+
+	for_each_node(node) {
+		numa_load_array[node] = alloc_percpu(struct numa_cpu_load);
+		BUG_ON(!numa_load_array[node]);
+	}
+}
+
+static void add_load(unsigned long *load, unsigned long new_load)
+{
+	if (sched_feat(NUMA_SLOW)) {
+		*load = (*load + new_load) >> 1;
+		return;
+	}
+
+	*load = new_load;
+}
+
+/*
+ * Called every @numa_balance_interval to update current node state.
+ */
+static void update_node_load(struct node_queue *nq)
+{
+	unsigned long pages, delta;
+	struct numa_cpu_load l;
+	int cpu;
+
+	memset(&l, 0, sizeof(l));
+
+	/*
+	 * Aggregate per-cpu cpu-load values for this node as per
+	 * account_numa_{en,de}queue().
+	 *
+	 * XXX limit to max balance sched_domain
+	 */
+	for_each_online_cpu(cpu) {
+		struct numa_cpu_load *nl = per_cpu_ptr(numa_load_array[nq->node], cpu);
+
+		l.remote += nl->remote;
+		l.all += nl->all;
+	}
+
+	add_load(&nq->remote_cpu_load, l.remote);
+	add_load(&nq->cpu_load, l.all);
+
+	/*
+	 * Fold regular samples of NUMA_FOREIGN into a memory load measure.
+	 */
+	pages = node_page_state(nq->node, NUMA_FOREIGN);
+	delta = pages - nq->prev_numa_foreign;
+	nq->prev_numa_foreign = pages;
+	add_load(&nq->remote_mem_load, delta);
+
+	/*
+	 * If there was NUMA_FOREIGN load, that means this node was at its
+	 * maximum memory capacity, record that.
+	 */
+	set_max_mem_load(node_pages_load(nq->node));
+}
+
+enum numa_balance_type {
+	NUMA_BALANCE_NONE = 0,
+	NUMA_BALANCE_CPU  = 1,
+	NUMA_BALANCE_MEM  = 2,
+	NUMA_BALANCE_ALL  = 3,
+};
+
+struct numa_imbalance {
+	long cpu, mem;
+	long mem_load;
+	enum numa_balance_type type;
+};
+
+static unsigned long process_cpu_load(struct numa_entity *ne)
+{
+	unsigned long load = 0;
+	struct task_struct *t, *p;
+
+	rcu_read_lock();
+	t = p = ne_owner(ne);
+	if (p) do {
+		load += t->numa_contrib;
+	} while ((t = next_thread(t)) != p);
+	rcu_read_unlock();
+
+	return load;
+}
+
+static unsigned long process_mem_load(struct numa_entity *ne)
+{
+	return get_mm_counter(ne_mm(ne), MM_ANONPAGES);
+}
+
+static int find_busiest_node(int this_node, struct numa_imbalance *imb)
+{
+	unsigned long cpu_load, mem_load;
+	unsigned long max_cpu_load, max_mem_load;
+	unsigned long sum_cpu_load, sum_mem_load;
+	unsigned long mem_cpu_load, cpu_mem_load;
+	int cpu_node, mem_node;
+	struct node_queue *nq;
+	int node;
+
+	sum_cpu_load = sum_mem_load = 0;
+	max_cpu_load = max_mem_load = 0;
+	mem_cpu_load = cpu_mem_load = 0;
+	cpu_node = mem_node = -1;
+
+	/* XXX scalability -- sched_domain */
+	for_each_online_node(node) {
+		nq = nq_of(node);
+
+		cpu_load = nq->remote_cpu_load;
+		mem_load = nq->remote_mem_load;
+
+		/*
+		 * If this node is overloaded on memory, we don't want more
+		 * tasks, bail!
+		 */
+		if (node == this_node) {
+			if (mem_load)
+				return -1;
+		}
+
+		sum_cpu_load += cpu_load;
+		if (cpu_load > max_cpu_load) {
+			max_cpu_load = cpu_load;
+			cpu_mem_load = mem_load;
+			cpu_node = node;
+		}
+
+		sum_mem_load += mem_load;
+		if (mem_load > max_mem_load) {
+			max_mem_load = mem_load;
+			mem_cpu_load = cpu_load;
+			mem_node = node;
+		}
+	}
+
+	/*
+	 * Nobody had overload of any kind, cool we're done!
+	 */
+	if (cpu_node == -1 && mem_node == -1)
+		return -1;
+
+	if (mem_node == -1) {
+set_cpu_node:
+		node = cpu_node;
+		cpu_load = max_cpu_load;
+		mem_load = cpu_mem_load;
+		goto calc_imb;
+	}
+
+	if (cpu_node == -1) {
+set_mem_node:
+		node = mem_node;
+		cpu_load = mem_cpu_load;
+		mem_load = max_mem_load;
+		goto calc_imb;
+	}
+
+	/*
+	 * We have both cpu and mem overload, oh my! pick whichever is most
+	 * overloaded wrt the average.
+	 */
+	if ((u64)max_mem_load * sum_cpu_load > (u64)max_cpu_load * sum_mem_load)
+		goto set_mem_node;
+
+	goto set_cpu_node;
+
+calc_imb:
+	memset(imb, 0, sizeof(*imb));
+
+	if (cpu_node != -1) {
+		imb->type |= NUMA_BALANCE_CPU;
+		imb->cpu = (long)(nq_of(node)->cpu_load -
+				  nq_of(this_node)->cpu_load) / 2;
+	}
+
+	if (mem_node != -1) {
+		imb->type |= NUMA_BALANCE_MEM;
+		imb->mem_load = node_pages_load(this_node);
+		imb->mem = (long)(node_pages_load(node) - imb->mem_load) / 2;
+	}
+
+	return node;
+}
+
+static bool can_move_ne(struct numa_entity *ne)
+{
+	/*
+	 * XXX: consider mems_allowed, stinking cpusets has mems_allowed
+	 * per task and it can actually differ over a whole process, la-la-la.
+	 */
+	return true;
+}
+
+static void move_processes(struct node_queue *busiest_nq,
+			   struct node_queue *this_nq,
+			   struct numa_imbalance *imb)
+{
+	unsigned long max_mem_load = get_max_mem_load();
+	long cpu_moved = 0, mem_moved = 0;
+	struct numa_entity *ne;
+	long ne_mem, ne_cpu;
+	int loops;
+
+	double_lock_nq(this_nq, busiest_nq);
+	loops = busiest_nq->nr_processes;
+	while (!list_empty(&busiest_nq->entity_list) && loops--) {
+		ne = list_first_entry(&busiest_nq->entity_list,
+				     struct numa_entity,
+				     numa_entry);
+
+		ne_cpu = process_cpu_load(ne);
+		ne_mem = process_mem_load(ne);
+
+		if (sched_feat(NUMA_BALANCE_FILTER)) {
+			/*
+			 * Avoid moving ne's when we create a larger imbalance
+			 * on the other end.
+			 */
+			if ((imb->type & NUMA_BALANCE_CPU) &&
+			    imb->cpu - cpu_moved < ne_cpu / 2)
+				goto next;
+
+			/*
+			 * Avoid migrating ne's when we'll know we'll push our
+			 * node over the memory limit.
+			 */
+			if (max_mem_load &&
+			    imb->mem_load + mem_moved + ne_mem > max_mem_load)
+				goto next;
+		}
+
+		if (!can_move_ne(ne))
+			goto next;
+
+		__dequeue_ne(busiest_nq, ne);
+		__enqueue_ne(this_nq, ne);
+		if (process_tryget(ne)) {
+			double_unlock_nq(this_nq, busiest_nq);
+
+			process_cpu_migrate(ne, this_nq->node);
+			process_mem_migrate(ne, this_nq->node);
+
+			process_put(ne);
+			double_lock_nq(this_nq, busiest_nq);
+		}
+
+		cpu_moved += ne_cpu;
+		mem_moved += ne_mem;
+
+		if (imb->cpu - cpu_moved <= 0 &&
+		    imb->mem - mem_moved <= 0)
+			break;
+
+		continue;
+
+next:
+		list_move_tail(&ne->numa_entry, &busiest_nq->entity_list);
+	}
+	double_unlock_nq(this_nq, busiest_nq);
+}
+
+static void numa_balance(struct node_queue *this_nq)
+{
+	struct numa_imbalance imb;
+	int busiest;
+
+	busiest = find_busiest_node(this_nq->node, &imb);
+	if (busiest == -1)
+		return;
+
+	if (imb.cpu <= 0 && imb.mem <= 0)
+		return;
+
+	move_processes(nq_of(busiest), this_nq, &imb);
+}
+
+static int wait_for_next_balance(struct node_queue *nq)
+{
+	set_current_state(TASK_INTERRUPTIBLE);
+	while (!kthread_should_stop()) {
+		long timeout = nq->next_schedule - jiffies;
+		if (timeout <= 0) {
+			__set_current_state(TASK_RUNNING);
+			return 1;
+		}
+		schedule_timeout(timeout);
+	}
+	__set_current_state(TASK_RUNNING);
+	return 0;
+}
+
+static int numad_thread(void *data)
+{
+	struct node_queue *nq = data;
+	struct task_struct *p = nq->numad;
+
+	set_cpus_allowed_ptr(p, cpumask_of_node(nq->node));
+
+	while (wait_for_next_balance(nq)) {
+
+		get_online_cpus();
+		update_node_load(nq);
+		if (sched_feat(NUMA_BALANCE))
+			numa_balance(nq);
+		put_online_cpus();
+
+		nq->next_schedule += numa_balance_interval;
+	}
+
+	return 0;
+}
+
+static __init int numa_init(void)
+{
+	int node;
+
+	nqs = kzalloc(sizeof(struct node_queue*) * nr_node_ids, GFP_KERNEL);
+	BUG_ON(!nqs);
+
+	for_each_node(node) { // XXX hotplug
+		struct node_queue *nq = kmalloc_node(sizeof(*nq),
+				GFP_KERNEL | __GFP_ZERO, node);
+		BUG_ON(!nq);
+
+		nq->numad = kthread_create_on_node(numad_thread,
+				nq, node, "numad/%d", node);
+		BUG_ON(IS_ERR(nq->numad));
+
+		spin_lock_init(&nq->lock);
+		INIT_LIST_HEAD(&nq->entity_list);
+
+		nq->next_schedule = jiffies + HZ;
+		nq->node = node;
+		nqs[node] = nq;
+
+		wake_up_process(nq->numad);
+	}
+
+	return 0;
+}
+early_initcall(numa_init);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 0d6d1c0..0a5dd21 100644
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
 
@@ -1163,7 +1179,25 @@ enum rq_nohz_flag_bits {
 #define nohz_flags(cpu)	(&cpu_rq(cpu)->nohz_flags)
 #endif
 
+unsigned long task_h_load(struct task_struct *p);
+
+#ifdef CONFIG_NUMA
+
+void sched_setnode(struct task_struct *p, int node);
+void select_task_node(struct task_struct *p, struct mm_struct *mm, int sd_flags);
+bool account_numa_enqueue(struct task_struct *p);
+void account_numa_dequeue(struct task_struct *p);
+void init_sched_numa(void);
+
+#else /* CONFIG_NUMA */
+
 /*
  * Macro to avoid argument evaluation
  */
 #define select_task_node(p, mm, sd_flags) do { } while (0)
+static inline bool account_numa_enqueue(struct task_struct *p) { return false; }
+static inline void account_numa_dequeue(struct task_struct *p) { }
+static inline void init_sched_numa(void) { }
+
+#endif /* CONFIG_NUMA */
+
diff --git a/mm/init-mm.c b/mm/init-mm.c
index a56a851..4649c40 100644
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -13,6 +13,15 @@
 #define INIT_MM_CONTEXT(name)
 #endif
 
+#ifdef CONFIG_NUMA
+# define INIT_MM_NUMA(mm)						\
+	.numa = {							\
+		.node = -1,						\
+	},
+#else
+# define INIT_MM_NUMA(mm)
+#endif
+
 struct mm_struct init_mm = {
 	.mm_rb		= RB_ROOT,
 	.pgd		= swapper_pg_dir,
@@ -22,4 +31,5 @@ struct mm_struct init_mm = {
 	.page_table_lock =  __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),
 	.mmlist		= LIST_HEAD_INIT(init_mm.mmlist),
 	INIT_MM_CONTEXT(init_mm)
+	INIT_MM_NUMA(init_mm)
 };
