Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab2KFNMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 08:12:16 -0500
Received: from mga14.intel.com ([143.182.124.37]:55294 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283Ab2KFNML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 08:12:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,722,1344236400"; 
   d="scan'208";a="165055874"
From: Alex Shi <alex.shi@intel.com>
To: rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com,
        vincent.guittot@linaro.org, tglx@linutronix.de
Cc: gregkh@linuxfoundation.org, andre.przywara@amd.com, alex.shi@intel.com,
        rjw@sisk.pl, paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, cl@linux.com,
        pjt@google.com
Subject: [RFC PATCH 3/3] sched: add power aware scheduling in fork/exec/wake
Date: Tue,  6 Nov 2012 21:09:59 +0800
Message-Id: <1352207399-29497-4-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1352207399-29497-1-git-send-email-alex.shi@intel.com>
References: <1352207399-29497-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add power aware scheduling in fork/exec/wake. It try to
select cpu from the busiest but has capcaity group. The trade off is
adding power aware statistics collection for the group seeking. But
since the collection just happened in power scheduling eligible
condition. So no munch performance impact.

hackbench testing results has no clear dropping even with powersaving
policy.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 233 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 159 insertions(+), 74 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index acc8b41..902ef5a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3370,12 +3370,149 @@ static int numa_select_node_cpu(struct task_struct *p, int node)
 #endif /* CONFIG_SCHED_NUMA */
 
 /*
- * sched_balance_self: balance the current task (running on cpu) in domains
+ * sd_lb_stats - Structure to store the statistics of a sched_domain
+ * during load balancing.
+ */
+struct sd_lb_stats {
+	struct sched_group *busiest; /* Busiest group in this sd */
+	struct sched_group *this;  /* Local group in this sd */
+	unsigned long total_load;  /* Total load of all groups in sd */
+	unsigned long total_pwr;   /*	Total power of all groups in sd */
+	unsigned long avg_load;	   /* Average load across all groups in sd */
+
+	/** Statistics of this group */
+	unsigned long this_load;
+	unsigned long this_load_per_task;
+	unsigned long this_nr_running;
+	unsigned long this_has_capacity;
+	unsigned int  this_idle_cpus;
+
+	/* Statistics of the busiest group */
+	unsigned int  busiest_idle_cpus;
+	unsigned long max_load;
+	unsigned long busiest_load_per_task;
+	unsigned long busiest_nr_running;
+	unsigned long busiest_group_capacity;
+	unsigned long busiest_has_capacity;
+	unsigned int  busiest_group_weight;
+
+	int group_imb; /* Is there imbalance in this sd */
+
+	/* Varibles of power awaring scheduling */
+	unsigned long	sd_capacity;	/* capacity of this domain */
+	unsigned long	sd_nr_running;	/* Nr running of this domain */
+	struct sched_group *group_min; /* Least loaded group in sd */
+	struct sched_group *group_leader; /* Group which relieves group_min */
+	unsigned long min_load_per_task; /* load_per_task in group_min */
+	unsigned long leader_nr_running; /* Nr running of group_leader */
+	unsigned long min_nr_running; /* Nr running of group_min */
+#ifdef CONFIG_SCHED_NUMA
+	struct sched_group *numa_group; /* group which has offnode_tasks */
+	unsigned long numa_group_weight;
+	unsigned long numa_group_running;
+
+	unsigned long this_offnode_running;
+	unsigned long this_onnode_running;
+#endif
+};
+
+/*
+ * sg_lb_stats - stats of a sched_group required for load_balancing
+ * and task rq selection
+ */
+struct sg_lb_stats {
+	unsigned long avg_load; /*Avg load across the CPUs of the group */
+	unsigned long group_load; /* Total load over the CPUs of the group */
+	unsigned long sum_nr_running; /* Nr tasks running in the group */
+	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
+	unsigned long group_capacity;
+	unsigned long idle_cpus;
+	unsigned long group_weight;
+	int group_imb; /* Is there an imbalance in the group ? */
+	int group_has_capacity; /* Is there extra capacity in the group? */
+#ifdef CONFIG_SCHED_NUMA
+	unsigned long numa_offnode_weight;
+	unsigned long numa_offnode_running;
+	unsigned long numa_onnode_running;
+#endif
+};
+
+static inline int
+fix_small_capacity(struct sched_domain *sd, struct sched_group *group);
+
+static void get_sg_power_stats(struct sched_group *group,
+			struct sched_domain *sd, struct sg_lb_stats *sgs)
+{
+	int i;
+
+
+	for_each_cpu(i, sched_group_cpus(group)) {
+		struct rq *rq = cpu_rq(i);
+
+		sgs->sum_nr_running += rq->nr_running;
+	}
+
+	sgs->group_capacity = DIV_ROUND_CLOSEST(group->sgp->power,
+						SCHED_POWER_SCALE);
+	if (!sgs->group_capacity)
+		sgs->group_capacity = fix_small_capacity(sd, group);
+	sgs->group_weight = group->group_weight;
+}
+
+static void get_sd_power_stats(struct sched_domain *sd,
+					struct sd_lb_stats *sds)
+{
+	struct sched_group *group;
+	struct sg_lb_stats sgs;
+	long sd_min_delta = LONG_MAX;
+
+	group = sd->groups;
+	do {
+		long g_delta;
+		unsigned long threshold;
+
+		memset(&sgs, 0, sizeof(sgs));
+		get_sg_power_stats(group, sd, &sgs);
+
+		if (sched_policy == SCHED_POLICY_POWERSAVING)
+			threshold = sgs.group_weight;
+		else
+			threshold = sgs.group_capacity;
+		g_delta = threshold - sgs.sum_nr_running;
+
+		if (g_delta > 0 && g_delta < sd_min_delta) {
+			sd_min_delta = g_delta;
+			sds->group_leader = group;
+		}
+
+		sds->sd_nr_running += sgs.sum_nr_running;
+		sds->total_pwr += group->sgp->power;
+	} while  (group = group->next, group != sd->groups);
+
+	sds->sd_capacity = DIV_ROUND_CLOSEST(sds->total_pwr,
+						SCHED_POWER_SCALE);
+}
+
+static inline int get_sd_sched_policy(struct sched_domain *sd,
+					struct sd_lb_stats *sds)
+{
+	int policy = SCHED_POLICY_PERFORMANCE;
+
+	if (sched_policy != SCHED_POLICY_PERFORMANCE) {
+		memset(sds, 0, sizeof(*sds));
+		get_sd_power_stats(sd, sds);
+
+		if (sd->span_weight > sds->sd_nr_running)
+			policy = SCHED_POLICY_POWERSAVING;
+	}
+	return policy;
+}
+
+/*
+ * select_task_rq_fair: balance the current task (running on cpu) in domains
  * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
  * SD_BALANCE_EXEC.
  *
- * Balance, ie. select the least loaded group.
- *
  * Returns the target CPU number, or the same CPU if no balancing is needed.
  *
  * preempt must be disabled.
@@ -3384,12 +3521,14 @@ static int
 select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 {
 	struct sched_domain *tmp, *affine_sd = NULL, *sd = NULL;
+	struct sd_lb_stats sds;
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	int new_cpu = cpu;
 	int want_affine = 0;
 	int sync = wake_flags & WF_SYNC;
 	int node = tsk_home_node(p);
+	int policy = sched_policy;
 
 	if (p->nr_cpus_allowed == 1)
 		return prev_cpu;
@@ -3412,6 +3551,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 
 			new_cpu = cpu = node_cpu;
 			sd = per_cpu(sd_node, cpu);
+			policy = get_sd_sched_policy(sd, &sds);
 			goto pick_idlest;
 		}
 
@@ -3445,8 +3585,12 @@ find_sd:
 			break;
 		}
 
-		if (tmp->flags & sd_flag)
+		if (tmp->flags & sd_flag) {
 			sd = tmp;
+			policy = get_sd_sched_policy(sd, &sds);
+			if (policy != SCHED_POLICY_PERFORMANCE)
+				break;
+		}
 	}
 
 	if (affine_sd) {
@@ -3460,7 +3604,7 @@ find_sd:
 pick_idlest:
 	while (sd) {
 		int load_idx = sd->forkexec_idx;
-		struct sched_group *group;
+		struct sched_group *group = NULL;
 		int weight;
 
 		if (!(sd->flags & sd_flag)) {
@@ -3471,7 +3615,12 @@ pick_idlest:
 		if (sd_flag & SD_BALANCE_WAKE)
 			load_idx = sd->wake_idx;
 
-		group = find_idlest_group(sd, p, cpu, load_idx);
+		if (policy != SCHED_POLICY_PERFORMANCE)
+			group = sds.group_leader;
+
+		if (!group)
+			group = find_idlest_group(sd, p, cpu, load_idx);
+
 		if (!group) {
 			sd = sd->child;
 			continue;
@@ -3491,8 +3640,11 @@ pick_idlest:
 		for_each_domain(cpu, tmp) {
 			if (weight <= tmp->span_weight)
 				break;
-			if (tmp->flags & sd_flag)
+			if (tmp->flags & sd_flag) {
 				sd = tmp;
+				if (policy != SCHED_POLICY_PERFORMANCE)
+					policy = get_sd_sched_policy(sd, &sds);
+			}
 		}
 		/* while loop will break here if sd == NULL */
 	}
@@ -4330,73 +4482,6 @@ static unsigned long task_h_load(struct task_struct *p)
 #endif
 
 /********** Helpers for find_busiest_group ************************/
-/*
- * sd_lb_stats - Structure to store the statistics of a sched_domain
- * 		during load balancing.
- */
-struct sd_lb_stats {
-	struct sched_group *busiest; /* Busiest group in this sd */
-	struct sched_group *this;  /* Local group in this sd */
-	unsigned long total_load;  /* Total load of all groups in sd */
-	unsigned long total_pwr;   /*	Total power of all groups in sd */
-	unsigned long avg_load;	   /* Average load across all groups in sd */
-
-	/** Statistics of this group */
-	unsigned long this_load;
-	unsigned long this_load_per_task;
-	unsigned long this_nr_running;
-	unsigned long this_has_capacity;
-	unsigned int  this_idle_cpus;
-
-	/* Statistics of the busiest group */
-	unsigned int  busiest_idle_cpus;
-	unsigned long max_load;
-	unsigned long busiest_load_per_task;
-	unsigned long busiest_nr_running;
-	unsigned long busiest_group_capacity;
-	unsigned long busiest_has_capacity;
-	unsigned int  busiest_group_weight;
-
-	int group_imb; /* Is there imbalance in this sd */
-
-	/* Varibles of power awaring scheduling */
-	unsigned long	sd_capacity;	/* capacity of this domain */
-	unsigned long	sd_nr_running;	/* Nr running of this domain */
-	struct sched_group *group_min; /* Least loaded group in sd */
-	struct sched_group *group_leader; /* Group which relieves group_min */
-	unsigned long min_load_per_task; /* load_per_task in group_min */
-	unsigned long leader_nr_running; /* Nr running of group_leader */
-	unsigned long min_nr_running; /* Nr running of group_min */
-
-#ifdef CONFIG_SCHED_NUMA
-	struct sched_group *numa_group; /* group which has offnode_tasks */
-	unsigned long numa_group_weight;
-	unsigned long numa_group_running;
-
-	unsigned long this_offnode_running;
-	unsigned long this_onnode_running;
-#endif
-};
-
-/*
- * sg_lb_stats - stats of a sched_group required for load_balancing
- */
-struct sg_lb_stats {
-	unsigned long avg_load; /*Avg load across the CPUs of the group */
-	unsigned long group_load; /* Total load over the CPUs of the group */
-	unsigned long sum_nr_running; /* Nr tasks running in the group */
-	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
-	unsigned long group_capacity;
-	unsigned long idle_cpus;
-	unsigned long group_weight;
-	int group_imb; /* Is there an imbalance in the group ? */
-	int group_has_capacity; /* Is there extra capacity in the group? */
-#ifdef CONFIG_SCHED_NUMA
-	unsigned long numa_offnode_weight;
-	unsigned long numa_offnode_running;
-	unsigned long numa_onnode_running;
-#endif
-};
 
 /**
  * init_sd_lb_power_stats - Initialize power savings statistics for
-- 
1.7.12

