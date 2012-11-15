Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768536Ab2KOQz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 11:55:26 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:59979 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768440Ab2KOQzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 11:55:24 -0500
Subject: [RFC v2 PATCH 2/2] sched: Use Per-Entity-Load-Tracking metric for
 load balancing
To: paulmck@linux.vnet.ibm.com, vincent.guittot@linaro.org,
        a.p.zijlstra@chello.nl, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, amit.kucheria@linaro.org,
        Morten.Rasmussen@arm.com, paul.mckenney@linaro.org,
        akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com,
        arjan@linux.intel.com, mingo@kernel.org, pjt@google.com
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: venki@google.com, robin.randhawa@arm.com, linaro-dev@lists.linaro.org,
        suresh.b.siddha@intel.com, mjg59@srcf.ucam.org,
        deepthi@linux.vnet.ibm.com, srivatsa.bhat@linux.vnet.ibm.com,
        Arvind.Chauhan@arm.com, linux-arm-kernel@lists.infradead.org
Date: Thu, 15 Nov 2012 22:24:23 +0530
Message-ID: <20121115165422.17426.3978.stgit@preeti.in.ibm.com>
In-Reply-To: <20121115164730.17426.36051.stgit@preeti.in.ibm.com>
References: <20121115164730.17426.36051.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12111516-4790-0000-0000-000005927E11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the load balancer weighs a task based upon its priority,and this
weight consequently gets added up to the weight of the run queue that it is
on.It is this weight of the runqueue that sums up to a sched group's load
which is used to decide the busiest or the idlest group and the runqueue
thereof.

The Per-Entity-Load-Tracking metric however measures how long a task has
been runnable over the duration of its lifetime.This gives us a hint of
the amount of CPU time that the task can demand.This metric takes care of the
task priority as well.Therefore apart from the priority of a task we also
have an idea of the live behavior of the task.This seems to be a more
realistic metric to use to compute task weight which adds upto the run queue
weight and the weight of the sched group.Consequently they can be used for
load balancing.

The semantics of load balancing is left untouched.The two functions
load_balance() and select_task_rq_fair() perform the task of load
balancing.These two paths have been browsed through in this patch to make
necessary changes.

weighted_cpuload() and task_h_load() provide the run queue weight and the
weight of the task respectively.They have been modified to provide the
Per-Entity-Load-Tracking metric as relevant for each.
The rest of the modifications had to be made to suit these two changes.

Completely Fair Scheduler class is the only sched_class which contributes to
the run queue load.Therefore the rq->load.weight==cfs_rq->load.weight when
the cfs_rq is the root cfs_rq (rq->cfs) of the hierarchy.When replacing this
with Per-Entity-Load-Tracking metric,cfs_rq->runnable_load_avg needs to be
used as this is the right reflection of the run queue load when
the cfs_rq is the root cfs_rq (rq->cfs) of the hierarchy.This metric reflects
the percentage uptime of the tasks that are queued on it and hence that contribute
to the load.Thus cfs_rq->runnable_load_avg replaces the metric earlier used in
weighted_cpuload().

The task load is aptly captured by se.avg.load_avg_contrib which captures the
runnable time vs the alive time of the task against its priority.This metric
replaces the earlier metric used in task_h_load().

The consequent changes appear as data type changes for the helper variables;
they abound in number.Because cfs_rq->runnable_load_avg needs to be big enough
to capture the tasks' load often and accurately.

The following patch does not consider CONFIG_FAIR_GROUP_SCHED AND
CONFIG_SCHED_NUMA.This is done so as to evaluate this approach starting from the
simplest scenario.Earlier discussions can be found in the link below.

Link: https://lkml.org/lkml/2012/10/25/162
Signed-off-by: Preeti U Murthy<preeti@linux.vnet.ibm.com>
---
 include/linux/sched.h |    2 +-
 kernel/sched/core.c   |   12 +++++----
 kernel/sched/fair.c   |   64 +++++++++++++++++++++++++------------------------
 kernel/sched/sched.h  |    2 +-
 4 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 087dd20..302756e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -924,7 +924,7 @@ struct sched_domain {
 	unsigned int lb_count[CPU_MAX_IDLE_TYPES];
 	unsigned int lb_failed[CPU_MAX_IDLE_TYPES];
 	unsigned int lb_balanced[CPU_MAX_IDLE_TYPES];
-	unsigned int lb_imbalance[CPU_MAX_IDLE_TYPES];
+	u64 lb_imbalance[CPU_MAX_IDLE_TYPES];
 	unsigned int lb_gained[CPU_MAX_IDLE_TYPES];
 	unsigned int lb_hot_gained[CPU_MAX_IDLE_TYPES];
 	unsigned int lb_nobusyg[CPU_MAX_IDLE_TYPES];
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 24d8b9b..4dea057 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2415,8 +2415,8 @@ static const unsigned char
  * would be when CPU is idle and so we just decay the old load without
  * adding any new load.
  */
-static unsigned long
-decay_load_missed(unsigned long load, unsigned long missed_updates, int idx)
+static u64
+decay_load_missed(u64 load, unsigned long missed_updates, int idx)
 {
 	int j = 0;
 
@@ -2444,7 +2444,7 @@ decay_load_missed(unsigned long load, unsigned long missed_updates, int idx)
  * scheduler tick (TICK_NSEC). With tickless idle this will not be called
  * every tick. We fix it up based on jiffies.
  */
-static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
+static void __update_cpu_load(struct rq *this_rq, u64 this_load,
 			      unsigned long pending_updates)
 {
 	int i, scale;
@@ -2454,7 +2454,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
 	/* Update our load: */
 	this_rq->cpu_load[0] = this_load; /* Fasttrack for idx 0 */
 	for (i = 1, scale = 2; i < CPU_LOAD_IDX_MAX; i++, scale += scale) {
-		unsigned long old_load, new_load;
+		u64 old_load, new_load;
 
 		/* scale is effectively 1 << i now, and >> i divides by scale */
 
@@ -2496,7 +2496,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
 void update_idle_cpu_load(struct rq *this_rq)
 {
 	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
-	unsigned long load = this_rq->load.weight;
+	u64 load = this_rq->cfs.runnable_load_avg;
 	unsigned long pending_updates;
 
 	/*
@@ -2546,7 +2546,7 @@ static void update_cpu_load_active(struct rq *this_rq)
 	 * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
 	 */
 	this_rq->last_load_update_tick = jiffies;
-	__update_cpu_load(this_rq, this_rq->load.weight, 1);
+	__update_cpu_load(this_rq, this_rq->cfs.runnable_load_avg, 1);
 
 	calc_load_account_active(this_rq);
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a9cdc8f..f8f3a29 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2935,9 +2935,9 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 
 #ifdef CONFIG_SMP
 /* Used instead of source_load when we know the type == 0 */
-static unsigned long weighted_cpuload(const int cpu)
+static u64 weighted_cpuload(const int cpu)
 {
-	return cpu_rq(cpu)->load.weight;
+	return cpu_rq(cpu)->cfs.runnable_load_avg;
 }
 
 /*
@@ -2947,10 +2947,10 @@ static unsigned long weighted_cpuload(const int cpu)
  * We want to under-estimate the load of migration sources, to
  * balance conservatively.
  */
-static unsigned long source_load(int cpu, int type)
+static u64 source_load(int cpu, int type)
 {
 	struct rq *rq = cpu_rq(cpu);
-	unsigned long total = weighted_cpuload(cpu);
+	u64 total = weighted_cpuload(cpu);
 
 	if (type == 0 || !sched_feat(LB_BIAS))
 		return total;
@@ -2962,10 +2962,10 @@ static unsigned long source_load(int cpu, int type)
  * Return a high guess at the load of a migration-target cpu weighted
  * according to the scheduling class and "nice" value.
  */
-static unsigned long target_load(int cpu, int type)
+static u64 target_load(int cpu, int type)
 {
 	struct rq *rq = cpu_rq(cpu);
-	unsigned long total = weighted_cpuload(cpu);
+	u64 total = weighted_cpuload(cpu);
 
 	if (type == 0 || !sched_feat(LB_BIAS))
 		return total;
@@ -2978,13 +2978,13 @@ static unsigned long power_of(int cpu)
 	return cpu_rq(cpu)->cpu_power;
 }
 
-static unsigned long cpu_avg_load_per_task(int cpu)
+static u64 cpu_avg_load_per_task(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
 
 	if (nr_running)
-		return rq->load.weight / nr_running;
+		return rq->cfs.runnable_load_avg / nr_running;
 
 	return 0;
 }
@@ -3131,7 +3131,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 {
 	s64 this_load, load;
 	int idx, this_cpu, prev_cpu;
-	unsigned long tl_per_task;
+	u64 tl_per_task;
 	struct task_group *tg;
 	unsigned long weight;
 	int balanced;
@@ -3149,14 +3149,14 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	 */
 	if (sync) {
 		tg = task_group(current);
-		weight = current->se.load.weight;
+		weight = current->se.avg.load_avg_contrib;
 
 		this_load += effective_load(tg, this_cpu, -weight, -weight);
 		load += effective_load(tg, prev_cpu, 0, -weight);
 	}
 
 	tg = task_group(p);
-	weight = p->se.load.weight;
+	weight = p->se.avg.load_avg_contrib;
 
 	/*
 	 * In low-load situations, where prev_cpu is idle and this_cpu is idle
@@ -3219,11 +3219,11 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 		  int this_cpu, int load_idx)
 {
 	struct sched_group *idlest = NULL, *group = sd->groups;
-	unsigned long min_load = ULONG_MAX, this_load = 0;
+	u64 min_load = ~0ULL, this_load = 0;
 	int imbalance = 100 + (sd->imbalance_pct-100)/2;
 
 	do {
-		unsigned long load, avg_load;
+		u64 load, avg_load;
 		int local_group;
 		int i;
 
@@ -3270,7 +3270,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 static int
 find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 {
-	unsigned long load, min_load = ULONG_MAX;
+	u64 load, min_load = ~0ULL;
 	int idlest = -1;
 	int i;
 
@@ -3911,7 +3911,7 @@ struct lb_env {
 	struct cpumask		*dst_grpmask;
 	int			new_dst_cpu;
 	enum cpu_idle_type	idle;
-	long			imbalance;
+	long long		imbalance;
 	/* The set of CPUs under consideration for load-balancing */
 	struct cpumask		*cpus;
 
@@ -4314,7 +4314,7 @@ static inline void update_h_load(long cpu)
 #ifdef CONFIG_SMP
 static unsigned long task_h_load(struct task_struct *p)
 {
-	return p->se.load.weight;
+	return p->se.avg.load_avg_contrib;
 }
 #endif
 #endif
@@ -4327,21 +4327,21 @@ static unsigned long task_h_load(struct task_struct *p)
 struct sd_lb_stats {
 	struct sched_group *busiest; /* Busiest group in this sd */
 	struct sched_group *this;  /* Local group in this sd */
-	unsigned long total_load;  /* Total load of all groups in sd */
+	u64 total_load;  /* Total load of all groups in sd */
 	unsigned long total_pwr;   /*	Total power of all groups in sd */
-	unsigned long avg_load;	   /* Average load across all groups in sd */
+	u64 avg_load;	   /* Average load across all groups in sd */
 
 	/** Statistics of this group */
-	unsigned long this_load;
-	unsigned long this_load_per_task;
+	u64 this_load;
+	u64 this_load_per_task;
 	unsigned long this_nr_running;
 	unsigned long this_has_capacity;
 	unsigned int  this_idle_cpus;
 
 	/* Statistics of the busiest group */
 	unsigned int  busiest_idle_cpus;
-	unsigned long max_load;
-	unsigned long busiest_load_per_task;
+	u64 max_load;
+	u64 busiest_load_per_task;
 	unsigned long busiest_nr_running;
 	unsigned long busiest_group_capacity;
 	unsigned long busiest_has_capacity;
@@ -4363,9 +4363,9 @@ struct sd_lb_stats {
  */
 struct sg_lb_stats {
 	unsigned long avg_load; /*Avg load across the CPUs of the group */
-	unsigned long group_load; /* Total load over the CPUs of the group */
+	u64 group_load; /* Total load over the CPUs of the group */
 	unsigned long sum_nr_running; /* Nr tasks running in the group */
-	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
+	u64 sum_weighted_load; /* Weighted load of group's tasks */
 	unsigned long group_capacity;
 	unsigned long idle_cpus;
 	unsigned long group_weight;
@@ -4688,9 +4688,9 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			int local_group, int *balance, struct sg_lb_stats *sgs)
 {
 	unsigned long nr_running, max_nr_running, min_nr_running;
-	unsigned long load, max_cpu_load, min_cpu_load;
+	u64 load, max_cpu_load, min_cpu_load;
 	unsigned int balance_cpu = -1, first_idle_cpu = 0;
-	unsigned long avg_load_per_task = 0;
+	u64 avg_load_per_task = 0;
 	int i;
 
 	if (local_group)
@@ -4698,7 +4698,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 
 	/* Tally up the load of all CPUs in the group */
 	max_cpu_load = 0;
-	min_cpu_load = ~0UL;
+	min_cpu_load = ~0ULL;
 	max_nr_running = 0;
 	min_nr_running = ~0UL;
 
@@ -4948,9 +4948,9 @@ static int check_asym_packing(struct lb_env *env, struct sd_lb_stats *sds)
 static inline
 void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 {
-	unsigned long tmp, pwr_now = 0, pwr_move = 0;
+	u64 tmp, pwr_now = 0, pwr_move = 0;
 	unsigned int imbn = 2;
-	unsigned long scaled_busy_load_per_task;
+	u64 scaled_busy_load_per_task;
 
 	if (sds->this_nr_running) {
 		sds->this_load_per_task /= sds->this_nr_running;
@@ -5016,7 +5016,7 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
  */
 static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 {
-	unsigned long max_pull, load_above_capacity = ~0UL;
+	u64 max_pull, load_above_capacity = ~0ULL;
 
 	sds->busiest_load_per_task /= sds->busiest_nr_running;
 	if (sds->group_imb) {
@@ -5192,14 +5192,14 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 				     struct sched_group *group)
 {
 	struct rq *busiest = NULL, *rq;
-	unsigned long max_load = 0;
+	u64 max_load = 0;
 	int i;
 
 	for_each_cpu(i, sched_group_cpus(group)) {
 		unsigned long power = power_of(i);
 		unsigned long capacity = DIV_ROUND_CLOSEST(power,
 							   SCHED_POWER_SCALE);
-		unsigned long wl;
+		u64 wl;
 
 		if (!capacity)
 			capacity = fix_small_capacity(env->sd, group);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index bfd004a..cff1926 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -362,7 +362,7 @@ struct rq {
 	 */
 	unsigned int nr_running;
 	#define CPU_LOAD_IDX_MAX 5
-	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
+	u64 cpu_load[CPU_LOAD_IDX_MAX];
 	unsigned long last_load_update_tick;
 #ifdef CONFIG_NO_HZ
 	u64 nohz_stamp;

