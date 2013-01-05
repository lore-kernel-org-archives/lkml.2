Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab3AEIib (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 03:38:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:44979 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755687Ab3AEIhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 03:37:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,415,1355126400"; 
   d="scan'208";a="270210184"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        alex.shi@intel.com
Subject: [PATCH v3 21/22] sched: power aware load balance,
Date: Sat,  5 Jan 2013 16:37:50 +0800
Message-Id: <1357375071-11793-22-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
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

This patch reuse some of Suresh's power saving load balance code.
The enabling logical summary here:
1, Collect power aware scheduler statistics during performance load
balance statistics collection.
2, if the balance cpu is eligible for power load balance, just do it
and forget performance load balance. but if the domain is suitable for
power balance, while the cpu is not appropriate, stop both
power/performance balance, else do performance load balance.

A test can show the effort on different policy:
for ((i = 0; i < I; i++)) ; do while true; do :; done  &   done

On my SNB laptop with 4core* HT: the data is Watts
        powersaving     balance         performance
i = 2   40              54              54
i = 4   57              64*             68
i = 8   68              68              68

Note:
When i = 4 with balance policy, the power may change in 57~68Watt,
since the HT capacity and core capacity are both 1.

on SNB EP machine with 2 sockets * 8 cores * HT:
        powersaving     balance         performance
i = 4   190             201             238
i = 8   205             241             268
i = 16  271             348             376

If system has few continued tasks, use power policy can get
the performance/power gain. Like sysbench fileio randrw test with 16
thread on the SNB EP box,

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 127 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 124 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index cf4955c..c82536f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3355,6 +3355,7 @@ struct sd_lb_stats {
 	unsigned int  sd_utils;	/* sum utilizations of this domain */
 	unsigned long sd_capacity;	/* capacity of this domain */
 	struct sched_group *group_leader; /* Group which relieves group_min */
+	struct sched_group *group_min;	/* Least loaded group in sd */
 	unsigned long min_load_per_task; /* load_per_task in group_min */
 	unsigned int  leader_util;	/* sum utilizations of group_leader */
 	unsigned int  min_util;		/* sum utilizations of group_min */
@@ -4395,6 +4396,106 @@ static unsigned long task_h_load(struct task_struct *p)
 #endif
 
 /********** Helpers for find_busiest_group ************************/
+
+/**
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
+	sds->min_util = UINT_MAX;
+	sds->leader_util = 0;
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
+	unsigned long threshold, threshold_util;
+
+	if (!env->power_lb)
+		return;
+
+	if (sched_policy == SCHED_POLICY_POWERSAVING)
+		threshold = sgs->group_weight;
+	else
+		threshold = sgs->group_capacity;
+	threshold_util = threshold * FULL_UTIL;
+
+	/*
+	 * If the local group is idle or full loaded
+	 * no need to do power savings balance at this domain
+	 */
+	if (local_group && (!sgs->sum_nr_running ||
+		sgs->group_utils + FULL_UTIL > threshold_util))
+		env->power_lb = 0;
+
+	/* Do performance load balance if any group overload */
+	if (sgs->group_utils > threshold_util) {
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
+	/*
+	 * Calculate the group which has the least non-idle load.
+	 * This is the group from where we need to pick up the load
+	 * for saving power
+	 */
+	if ((sgs->group_utils < sds->min_util) ||
+	    (sgs->group_utils == sds->min_util &&
+	     group_first_cpu(group) > group_first_cpu(sds->group_min))) {
+		sds->group_min = group;
+		sds->min_util = sgs->group_utils;
+		sds->min_load_per_task = sgs->sum_weighted_load /
+						sgs->sum_nr_running;
+	}
+
+	/*
+	 * Calculate the group which is almost near its
+	 * capacity but still has some space to pick up some load
+	 * from other group and save more power
+	 */
+	if (sgs->group_utils + FULL_UTIL > threshold_util)
+		return;
+
+	if (sgs->group_utils > sds->leader_util ||
+	    (sgs->group_utils == sds->leader_util && sds->group_leader &&
+	     group_first_cpu(group) < group_first_cpu(sds->group_leader))) {
+		sds->group_leader = group;
+		sds->leader_util = sgs->group_utils;
+	}
+}
+
 /**
  * get_sd_load_idx - Obtain the load index for a given sched domain.
  * @sd: The sched_domain whose load_idx is to be obtained.
@@ -4634,6 +4735,12 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		sgs->group_load += load;
 		sgs->sum_nr_running += nr_running;
 		sgs->sum_weighted_load += weighted_cpuload(i);
+
+		/* accumulate the maximum potential util */
+		if (!nr_running)
+			nr_running = 1;
+		sgs->group_utils += rq->util * nr_running;
+
 		if (idle_cpu(i))
 			sgs->idle_cpus++;
 	}
@@ -4742,6 +4849,7 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 	if (child && child->flags & SD_PREFER_SIBLING)
 		prefer_sibling = 1;
 
+	init_sd_lb_power_stats(env, sds);
 	load_idx = get_sd_load_idx(env->sd, env->idle);
 
 	do {
@@ -4793,6 +4901,7 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 			sds->group_imb = sgs.group_imb;
 		}
 
+		update_sd_lb_power_stats(env, sg, sds, local_group, &sgs);
 		sg = sg->next;
 	} while (sg != env->sd->groups);
 }
@@ -5010,6 +5119,19 @@ find_busiest_group(struct lb_env *env, int *balance)
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
@@ -5187,8 +5309,8 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.idle		= idle,
 		.loop_break	= sched_nr_migrate_break,
 		.cpus		= cpus,
-		.power_lb	= 0,
-		.perf_lb	= 1,
+		.power_lb	= 1,
+		.perf_lb	= 0,
 	};
 
 	cpumask_copy(cpus, cpu_active_mask);
@@ -6266,7 +6388,6 @@ void unregister_fair_sched_group(struct task_group *tg, int cpu) { }
 
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
-
 static unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task)
 {
 	struct sched_entity *se = &task->se;
-- 
1.7.12

