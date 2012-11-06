Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab2KFNMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 08:12:09 -0500
Received: from mga14.intel.com ([143.182.124.37]:55294 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005Ab2KFNMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 08:12:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,722,1344236400"; 
   d="scan'208";a="165055855"
From: Alex Shi <alex.shi@intel.com>
To: rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com,
        vincent.guittot@linaro.org, tglx@linutronix.de
Cc: gregkh@linuxfoundation.org, andre.przywara@amd.com, alex.shi@intel.com,
        rjw@sisk.pl, paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, cl@linux.com,
        pjt@google.com
Subject: [RFC PATCH 2/3] sched: power aware load balance,
Date: Tue,  6 Nov 2012 21:09:58 +0800
Message-Id: <1352207399-29497-3-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1352207399-29497-1-git-send-email-alex.shi@intel.com>
References: <1352207399-29497-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enabled the power aware consideration in load balance.

As mentioned in the power aware scheduler proposal, Power aware
scheduling has 2 assumptions:
1, race to idle is helpful for power saving
2, shrink tasks on less sched_groups will reduce power consumption

The first assumption make performance policy take over scheduling when
system busy.
The second assumption make power aware scheduling try to move
disperse tasks into fewer groups until that groups are full of tasks.

This patch reuse lots of Suresh's power saving load balance code.
Now the general enabling logical is:
1, Collect power aware scheduler statistics with performance load
balance statistics collection.
2, if domain is eligible for power load balance do it and forget
performance load balance, else do performance load balance.

Has tried on my 2 sockets * 4 cores * HT NHM EP machine.
and 2 sockets * 8 cores * HT SNB EP machine.
In the following checking, when I is 2/4/8/16, all tasks are
shrank to run on single core or single socket.

$for ((i=0; i < I; i++)) ; do while true; do : ; done & done

Checking the power consuming with a powermeter on the NHM EP.
	powersaving     performance
I = 2   148w            160w
I = 4   175w            181w
I = 8   207w            224w
I = 16  324w            324w

On a SNB laptop(4 cores *HT)
	powersaving     performance
I = 2   28w             35w
I = 4   38w             52w
I = 6   44w             54w
I = 8   56w             56w

On the SNB EP machine, when I = 16, power saved more than 100 Watts.

Also tested the specjbb2005 with jrockit, kbuild, their peak performance
has no clear change with powersaving policy on all machines. Just
specjbb2005 with openjdk has about 2% drop on NHM EP machine with
powersaving policy.

This patch seems a bit long, but seems hard to split smaller.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 155 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 153 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index dedc576..acc8b41 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3930,6 +3930,8 @@ struct lb_env {
 	unsigned int		loop;
 	unsigned int		loop_break;
 	unsigned int		loop_max;
+	int			power_lb;  /* if powersaving lb needed */
+	int			perf_lb;   /* if performance lb needed */
 
 	struct rq *		(*find_busiest_queue)(struct lb_env *,
 						      struct sched_group *);
@@ -4356,6 +4358,16 @@ struct sd_lb_stats {
 	unsigned int  busiest_group_weight;
 
 	int group_imb; /* Is there imbalance in this sd */
+
+	/* Varibles of power awaring scheduling */
+	unsigned long	sd_capacity;	/* capacity of this domain */
+	unsigned long	sd_nr_running;	/* Nr running of this domain */
+	struct sched_group *group_min; /* Least loaded group in sd */
+	struct sched_group *group_leader; /* Group which relieves group_min */
+	unsigned long min_load_per_task; /* load_per_task in group_min */
+	unsigned long leader_nr_running; /* Nr running of group_leader */
+	unsigned long min_nr_running; /* Nr running of group_min */
+
 #ifdef CONFIG_SCHED_NUMA
 	struct sched_group *numa_group; /* group which has offnode_tasks */
 	unsigned long numa_group_weight;
@@ -4387,6 +4399,123 @@ struct sg_lb_stats {
 };
 
 /**
+ * init_sd_lb_power_stats - Initialize power savings statistics for
+ * the given sched_domain, during load balancing.
+ *
+ * @env: The load balancing environment.
+ * @sds: Variable containing the statistics for sd.
+ */
+static inline void init_sd_lb_power_stats(struct lb_env *env,
+						struct sd_lb_stats *sds)
+{
+	if (sched_policy == SCHED_POLICY_PERFORMANCE ||
+				env->idle == CPU_NOT_IDLE) {
+		env->power_lb = 0;
+		env->perf_lb = 1;
+		return;
+	}
+	env->perf_lb = 0;
+	env->power_lb = 1;
+	sds->min_nr_running = ULONG_MAX;
+	sds->leader_nr_running = 0;
+}
+
+/**
+ * update_sd_lb_power_stats - Update the power saving stats for a
+ * sched_domain while performing load balancing.
+ *
+ * @env: The load balancing environment.
+ * @group: sched_group belonging to the sched_domain under consideration.
+ * @sds: Variable containing the statistics of the sched_domain
+ * @local_group: Does group contain the CPU for which we're performing
+ * load balancing?
+ * @sgs: Variable containing the statistics of the group.
+ */
+static inline void update_sd_lb_power_stats(struct lb_env *env,
+			struct sched_group *group, struct sd_lb_stats *sds,
+			int local_group, struct sg_lb_stats *sgs)
+{
+	unsigned long threshold;
+
+	if (!env->power_lb)
+		return;
+
+	threshold = sgs->group_weight;
+
+	/*
+	 * If the local group is idle or full loaded
+	 * no need to do power savings balance at this domain
+	 */
+	if (local_group && (sds->this_nr_running == threshold ||
+				!sds->this_nr_running))
+		env->power_lb = 0;
+
+	/* Do performance load balance if any group overload */
+	if (sgs->sum_nr_running > threshold) {
+		env->perf_lb = 1;
+		env->power_lb = 0;
+	}
+
+	/*
+	 * If a group is idle,
+	 * don't include that group in power savings calculations
+	 */
+	if (!env->power_lb || !sgs->sum_nr_running)
+		return;
+
+	sds->sd_nr_running += sgs->sum_nr_running;
+	/*
+	 * Calculate the group which has the least non-idle load.
+	 * This is the group from where we need to pick up the load
+	 * for saving power
+	 */
+	if ((sgs->sum_nr_running < sds->min_nr_running) ||
+	    (sgs->sum_nr_running == sds->min_nr_running &&
+	     group_first_cpu(group) > group_first_cpu(sds->group_min))) {
+		sds->group_min = group;
+		sds->min_nr_running = sgs->sum_nr_running;
+		sds->min_load_per_task = sgs->sum_weighted_load /
+						sgs->sum_nr_running;
+	}
+
+	/*
+	 * Calculate the group which is almost near its
+	 * capacity but still has some space to pick up some load
+	 * from other group and save more power
+	 */
+	if (sgs->sum_nr_running + 1 > threshold)
+		return;
+
+	if (sgs->sum_nr_running > sds->leader_nr_running ||
+	    (sgs->sum_nr_running == sds->leader_nr_running &&
+	     group_first_cpu(group) < group_first_cpu(sds->group_leader))) {
+		sds->group_leader = group;
+		sds->leader_nr_running = sgs->sum_nr_running;
+	}
+}
+
+/**
+ * check_sd_power_lb_needed - Check if the power awaring load balance needed
+ * in the sched_domain.
+ *
+ * @env: The load balancing environment.
+ * @sds: Variable containing the statistics of the sched_domain
+ */
+
+static inline void check_sd_power_lb_needed(struct lb_env *env,
+					struct sd_lb_stats *sds)
+{
+	unsigned long threshold = env->sd->span_weight;
+	if (!env->power_lb)
+		return;
+
+	if (sds->sd_nr_running > threshold) {
+		env->power_lb = 0;
+		env->perf_lb = 1;
+	}
+}
+
+/**
  * get_sd_load_idx - Obtain the load index for a given sched domain.
  * @sd: The sched_domain whose load_idx is to be obtained.
  * @idle: The Idle status of the CPU for whose sd load_icx is obtained.
@@ -4850,6 +4979,7 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 	if (child && child->flags & SD_PREFER_SIBLING)
 		prefer_sibling = 1;
 
+	init_sd_lb_power_stats(env, sds);
 	load_idx = get_sd_load_idx(env->sd, env->idle);
 
 	do {
@@ -4899,8 +5029,11 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 
 		update_sd_numa_stats(env->sd, sg, sds, local_group, &sgs);
 
+		update_sd_lb_power_stats(env, sg, sds, local_group, &sgs);
 		sg = sg->next;
 	} while (sg != env->sd->groups);
+
+	check_sd_power_lb_needed(env, sds);
 }
 
 /**
@@ -5116,6 +5249,19 @@ find_busiest_group(struct lb_env *env, int *balance)
 	 */
 	update_sd_lb_stats(env, balance, &sds);
 
+	if (!env->perf_lb && !env->power_lb)
+		return  NULL;
+
+	if (env->power_lb) {
+		if (sds.this == sds.group_leader &&
+				sds.group_leader != sds.group_min) {
+			env->imbalance = sds.min_load_per_task;
+			return sds.group_min;
+		}
+		env->power_lb = 0;
+		return NULL;
+	}
+
 	/*
 	 * this_cpu is not the appropriate cpu to perform load balancing at
 	 * this level.
@@ -5222,7 +5368,9 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 		 * When comparing with imbalance, use weighted_cpuload()
 		 * which is not scaled with the cpu power.
 		 */
-		if (capacity && rq->nr_running == 1 && wl > env->imbalance)
+		if (rq->nr_running == 0 ||
+			(!env->power_lb && capacity &&
+				rq->nr_running == 1 && wl > env->imbalance))
 			continue;
 
 		/*
@@ -5298,6 +5446,8 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.loop_break	    = sched_nr_migrate_break,
 		.cpus		    = cpus,
 		.find_busiest_queue = find_busiest_queue,
+		.power_lb	    = 1,
+		.perf_lb	    = 0,
 	};
 
 	cpumask_copy(cpus, cpu_active_mask);
@@ -5330,7 +5480,8 @@ redo:
 
 	ld_moved = 0;
 	lb_iterations = 1;
-	if (busiest->nr_running > 1) {
+	if (busiest->nr_running > 1 ||
+		(busiest->nr_running == 1 && env.power_lb)) {
 		/*
 		 * Attempt to move tasks. If find_busiest_group has found
 		 * an imbalance but busiest->nr_running <= 1, the group is
-- 
1.7.12

