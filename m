Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab1DTUzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:55:46 -0400
Received: from smtp-out.google.com ([74.125.121.67]:47384 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650Ab1DTUwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:52:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=EO9tpMx3SHCFrs5ckUDKDdJUmLmJVzkbfeQGodBZvgj00K4SzAvWQ4aSZOS3cWXne
	8FJRbfZKnQTMEuomK4Haw==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org, Nikhil Rao <ncrao@google.com>
Subject: [RFC][Patch 01/18] sched: introduce SCHED_POWER_SCALE to scale cpu_power calculations
Date: Wed, 20 Apr 2011 13:51:20 -0700
Message-Id: <1303332697-16426-2-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1303332697-16426-1-git-send-email-ncrao@google.com>
References: <1303332697-16426-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SCHED_LOAD_SCALE is used to increase nice resolution and to scale cpu_power
calculations in the scheduler. This patch introduces SCHED_POWER_SCALE and
converts all uses of SCHED_LOAD_SCALE for scaling cpu_power to use
SCHED_POWER_SCALE instead.

This is a preparatory patch for increasing the resolution of SCHED_LOAD_SCALE,
and there is no need to increase resolution for cpu_power calculations.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 include/linux/sched.h |   13 ++++++++-----
 kernel/sched.c        |    6 +++---
 kernel/sched_fair.c   |   44 +++++++++++++++++++++++---------------------
 3 files changed, 34 insertions(+), 29 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 18d63ce..8d1ff2b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -792,17 +792,20 @@ enum cpu_idle_type {
 };
 
 /*
- * sched-domains (multiprocessor balancing) declarations:
- */
-
-/*
  * Increase resolution of nice-level calculations:
  */
 #define SCHED_LOAD_SHIFT	10
 #define SCHED_LOAD_SCALE	(1L << SCHED_LOAD_SHIFT)
 
-#define SCHED_LOAD_SCALE_FUZZ	SCHED_LOAD_SCALE
+/*
+ * Increase resolution of cpu_power calculations
+ */
+#define SCHED_POWER_SHIFT	10
+#define SCHED_POWER_SCALE	(1L << SCHED_POWER_SHIFT)
 
+/*
+ * sched-domains (multiprocessor balancing) declarations:
+ */
 #ifdef CONFIG_SMP
 #define SD_LOAD_BALANCE		0x0001	/* Do load balancing on this domain. */
 #define SD_BALANCE_NEWIDLE	0x0002	/* Balance when about to become idle */
diff --git a/kernel/sched.c b/kernel/sched.c
index 312f8b9..50f97cc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6468,7 +6468,7 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 		cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
 
 		printk(KERN_CONT " %s", str);
-		if (group->cpu_power != SCHED_LOAD_SCALE) {
+		if (group->cpu_power != SCHED_POWER_SCALE) {
 			printk(KERN_CONT " (cpu_power = %d)",
 				group->cpu_power);
 		}
@@ -7176,7 +7176,7 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 	sd->groups->cpu_power = 0;
 
 	if (!child) {
-		power = SCHED_LOAD_SCALE;
+		power = SCHED_POWER_SCALE;
 		weight = cpumask_weight(sched_domain_span(sd));
 		/*
 		 * SMT siblings share the power of a single core.
@@ -8224,7 +8224,7 @@ void __init sched_init(void)
 #ifdef CONFIG_SMP
 		rq->sd = NULL;
 		rq->rd = NULL;
-		rq->cpu_power = SCHED_LOAD_SCALE;
+		rq->cpu_power = SCHED_POWER_SCALE;
 		rq->post_schedule = 0;
 		rq->active_balance = 0;
 		rq->next_balance = jiffies;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 6fa833a..8d8d11c 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1557,7 +1557,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 		}
 
 		/* Adjust by relative CPU power of the group */
-		avg_load = (avg_load * SCHED_LOAD_SCALE) / group->cpu_power;
+		avg_load = (avg_load * SCHED_POWER_SCALE) / group->cpu_power;
 
 		if (local_group) {
 			this_load = avg_load;
@@ -1692,7 +1692,7 @@ select_task_rq_fair(struct rq *rq, struct task_struct *p, int sd_flag, int wake_
 				nr_running += cpu_rq(i)->cfs.nr_running;
 			}
 
-			capacity = DIV_ROUND_CLOSEST(power, SCHED_LOAD_SCALE);
+			capacity = DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE);
 
 			if (tmp->flags & SD_POWERSAVINGS_BALANCE)
 				nr_running /= 2;
@@ -2534,7 +2534,7 @@ static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
 
 unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu)
 {
-	return SCHED_LOAD_SCALE;
+	return SCHED_POWER_SCALE;
 }
 
 unsigned long __weak arch_scale_freq_power(struct sched_domain *sd, int cpu)
@@ -2571,8 +2571,8 @@ unsigned long scale_rt_power(int cpu)
 		available = total - rq->rt_avg;
 	}
 
-	if (unlikely((s64)total < SCHED_LOAD_SCALE))
-		total = SCHED_LOAD_SCALE;
+	if (unlikely((s64)total < SCHED_POWER_SCALE))
+		total = SCHED_POWER_SCALE;
 
 	total >>= SCHED_LOAD_SHIFT;
 
@@ -2582,7 +2582,7 @@ unsigned long scale_rt_power(int cpu)
 static void update_cpu_power(struct sched_domain *sd, int cpu)
 {
 	unsigned long weight = sd->span_weight;
-	unsigned long power = SCHED_LOAD_SCALE;
+	unsigned long power = SCHED_POWER_SCALE;
 	struct sched_group *sdg = sd->groups;
 
 	if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
@@ -2646,7 +2646,7 @@ static inline int
 fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
 {
 	/*
-	 * Only siblings can have significantly less than SCHED_LOAD_SCALE
+	 * Only siblings can have significantly less than SCHED_POWER_SCALE
 	 */
 	if (sd->level != SD_LV_SIBLING)
 		return 0;
@@ -2734,7 +2734,7 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	}
 
 	/* Adjust by relative CPU power of the group */
-	sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE) / group->cpu_power;
+	sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / group->cpu_power;
 
 	/*
 	 * Consider the group unbalanced when the imbalance is larger
@@ -2751,7 +2751,8 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	if ((max_cpu_load - min_cpu_load) >= avg_load_per_task && max_nr_running > 1)
 		sgs->group_imb = 1;
 
-	sgs->group_capacity = DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
+	sgs->group_capacity = DIV_ROUND_CLOSEST(group->cpu_power,
+						SCHED_POWER_SCALE);
 	if (!sgs->group_capacity)
 		sgs->group_capacity = fix_small_capacity(sd, group);
 	sgs->group_weight = group->group_weight;
@@ -2925,7 +2926,7 @@ static int check_asym_packing(struct sched_domain *sd,
 		return 0;
 
 	*imbalance = DIV_ROUND_CLOSEST(sds->max_load * sds->busiest->cpu_power,
-				       SCHED_LOAD_SCALE);
+				       SCHED_POWER_SCALE);
 	return 1;
 }
 
@@ -2954,7 +2955,7 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
 			cpu_avg_load_per_task(this_cpu);
 
 	scaled_busy_load_per_task = sds->busiest_load_per_task
-						 * SCHED_LOAD_SCALE;
+					 * SCHED_POWER_SCALE;
 	scaled_busy_load_per_task /= sds->busiest->cpu_power;
 
 	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >=
@@ -2973,10 +2974,10 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
 			min(sds->busiest_load_per_task, sds->max_load);
 	pwr_now += sds->this->cpu_power *
 			min(sds->this_load_per_task, sds->this_load);
-	pwr_now /= SCHED_LOAD_SCALE;
+	pwr_now /= SCHED_POWER_SCALE;
 
 	/* Amount of load we'd subtract */
-	tmp = (sds->busiest_load_per_task * SCHED_LOAD_SCALE) /
+	tmp = (sds->busiest_load_per_task * SCHED_POWER_SCALE) /
 		sds->busiest->cpu_power;
 	if (sds->max_load > tmp)
 		pwr_move += sds->busiest->cpu_power *
@@ -2984,15 +2985,15 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
 
 	/* Amount of load we'd add */
 	if (sds->max_load * sds->busiest->cpu_power <
-		sds->busiest_load_per_task * SCHED_LOAD_SCALE)
+		sds->busiest_load_per_task * SCHED_POWER_SCALE)
 		tmp = (sds->max_load * sds->busiest->cpu_power) /
 			sds->this->cpu_power;
 	else
-		tmp = (sds->busiest_load_per_task * SCHED_LOAD_SCALE) /
+		tmp = (sds->busiest_load_per_task * SCHED_POWER_SCALE) /
 			sds->this->cpu_power;
 	pwr_move += sds->this->cpu_power *
 			min(sds->this_load_per_task, sds->this_load + tmp);
-	pwr_move /= SCHED_LOAD_SCALE;
+	pwr_move /= SCHED_POWER_SCALE;
 
 	/* Move if we gain throughput */
 	if (pwr_move > pwr_now)
@@ -3034,7 +3035,7 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 		load_above_capacity = (sds->busiest_nr_running -
 						sds->busiest_group_capacity);
 
-		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_LOAD_SCALE);
+		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_POWER_SCALE);
 
 		load_above_capacity /= sds->busiest->cpu_power;
 	}
@@ -3054,7 +3055,7 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 	/* How much load to actually move to equalise the imbalance */
 	*imbalance = min(max_pull * sds->busiest->cpu_power,
 		(sds->avg_load - sds->this_load) * sds->this->cpu_power)
-			/ SCHED_LOAD_SCALE;
+			/ SCHED_POWER_SCALE;
 
 	/*
 	 * if *imbalance is less than the average load per runnable task
@@ -3123,7 +3124,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (!sds.busiest || sds.busiest_nr_running == 0)
 		goto out_balanced;
 
-	sds.avg_load = (SCHED_LOAD_SCALE * sds.total_load) / sds.total_pwr;
+	sds.avg_load = (SCHED_POWER_SCALE * sds.total_load) / sds.total_pwr;
 
 	/*
 	 * If the busiest group is imbalanced the below checks don't
@@ -3202,7 +3203,8 @@ find_busiest_queue(struct sched_domain *sd, struct sched_group *group,
 
 	for_each_cpu(i, sched_group_cpus(group)) {
 		unsigned long power = power_of(i);
-		unsigned long capacity = DIV_ROUND_CLOSEST(power, SCHED_LOAD_SCALE);
+		unsigned long capacity = DIV_ROUND_CLOSEST(power,
+							   SCHED_POWER_SCALE);
 		unsigned long wl;
 
 		if (!capacity)
@@ -3227,7 +3229,7 @@ find_busiest_queue(struct sched_domain *sd, struct sched_group *group,
 		 * the load can be moved away from the cpu that is potentially
 		 * running at a lower capacity.
 		 */
-		wl = (wl * SCHED_LOAD_SCALE) / power;
+		wl = (wl * SCHED_POWER_SCALE) / power;
 
 		if (wl > max_load) {
 			max_load = wl;
-- 
1.7.3.1

