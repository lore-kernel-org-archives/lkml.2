Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934741Ab1ETNn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:43:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:36213 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934097Ab1ETNny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:43:54 -0400
Date: Fri, 20 May 2011 13:43:27 GMT
From: tip-bot for Nikhil Rao <ncrao@google.com>
Message-ID: <tip-1399fa7807a1a5998bbf147e80668e9950661dfa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@redhat.com, ncrao@google.com, efault@gmx.de,
        peterz@infradead.org, nikunj@linux.vnet.ibm.com,
        stephan.baerwolf@tu-ilmenau.de, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, ncrao@google.com, peterz@infradead.org,
        efault@gmx.de, nikunj@linux.vnet.ibm.com,
        stephan.baerwolf@tu-ilmenau.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1305738580-9924-3-git-send-email-ncrao@google.com>
References: <1305738580-9924-3-git-send-email-ncrao@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Introduce SCHED_POWER_SCALE to scale cpu_power calculations
Git-Commit-ID: 1399fa7807a1a5998bbf147e80668e9950661dfa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 20 May 2011 13:43:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1399fa7807a1a5998bbf147e80668e9950661dfa
Gitweb:     http://git.kernel.org/tip/1399fa7807a1a5998bbf147e80668e9950661dfa
Author:     Nikhil Rao <ncrao@google.com>
AuthorDate: Wed, 18 May 2011 10:09:39 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 May 2011 14:16:50 +0200

sched: Introduce SCHED_POWER_SCALE to scale cpu_power calculations

SCHED_LOAD_SCALE is used to increase nice resolution and to
scale cpu_power calculations in the scheduler. This patch
introduces SCHED_POWER_SCALE and converts all uses of
SCHED_LOAD_SCALE for scaling cpu_power to use SCHED_POWER_SCALE
instead.

This is a preparatory patch for increasing the resolution of
SCHED_LOAD_SCALE, and there is no need to increase resolution
for cpu_power calculations.

Signed-off-by: Nikhil Rao <ncrao@google.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>
Cc: Mike Galbraith <efault@gmx.de>
Link: http://lkml.kernel.org/r/1305738580-9924-3-git-send-email-ncrao@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |   13 +++++++----
 kernel/sched.c        |    4 +-
 kernel/sched_fair.c   |   52 +++++++++++++++++++++++++-----------------------
 3 files changed, 37 insertions(+), 32 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 12211e1..f2f4402 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -788,17 +788,20 @@ enum cpu_idle_type {
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
index d036048..375e9c6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6530,7 +6530,7 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 		cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
 
 		printk(KERN_CONT " %s", str);
-		if (group->cpu_power != SCHED_LOAD_SCALE) {
+		if (group->cpu_power != SCHED_POWER_SCALE) {
 			printk(KERN_CONT " (cpu_power = %d)",
 				group->cpu_power);
 		}
@@ -7905,7 +7905,7 @@ void __init sched_init(void)
 #ifdef CONFIG_SMP
 		rq->sd = NULL;
 		rq->rd = NULL;
-		rq->cpu_power = SCHED_LOAD_SCALE;
+		rq->cpu_power = SCHED_POWER_SCALE;
 		rq->post_schedule = 0;
 		rq->active_balance = 0;
 		rq->next_balance = jiffies;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 37f2262..e32a9b7 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1584,7 +1584,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 		}
 
 		/* Adjust by relative CPU power of the group */
-		avg_load = (avg_load * SCHED_LOAD_SCALE) / group->cpu_power;
+		avg_load = (avg_load * SCHED_POWER_SCALE) / group->cpu_power;
 
 		if (local_group) {
 			this_load = avg_load;
@@ -1722,7 +1722,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 				nr_running += cpu_rq(i)->cfs.nr_running;
 			}
 
-			capacity = DIV_ROUND_CLOSEST(power, SCHED_LOAD_SCALE);
+			capacity = DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE);
 
 			if (tmp->flags & SD_POWERSAVINGS_BALANCE)
 				nr_running /= 2;
@@ -2570,7 +2570,7 @@ static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
 
 unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu)
 {
-	return SCHED_LOAD_SCALE;
+	return SCHED_POWER_SCALE;
 }
 
 unsigned long __weak arch_scale_freq_power(struct sched_domain *sd, int cpu)
@@ -2607,10 +2607,10 @@ unsigned long scale_rt_power(int cpu)
 		available = total - rq->rt_avg;
 	}
 
-	if (unlikely((s64)total < SCHED_LOAD_SCALE))
-		total = SCHED_LOAD_SCALE;
+	if (unlikely((s64)total < SCHED_POWER_SCALE))
+		total = SCHED_POWER_SCALE;
 
-	total >>= SCHED_LOAD_SHIFT;
+	total >>= SCHED_POWER_SHIFT;
 
 	return div_u64(available, total);
 }
@@ -2618,7 +2618,7 @@ unsigned long scale_rt_power(int cpu)
 static void update_cpu_power(struct sched_domain *sd, int cpu)
 {
 	unsigned long weight = sd->span_weight;
-	unsigned long power = SCHED_LOAD_SCALE;
+	unsigned long power = SCHED_POWER_SCALE;
 	struct sched_group *sdg = sd->groups;
 
 	if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
@@ -2627,7 +2627,7 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
 		else
 			power *= default_scale_smt_power(sd, cpu);
 
-		power >>= SCHED_LOAD_SHIFT;
+		power >>= SCHED_POWER_SHIFT;
 	}
 
 	sdg->cpu_power_orig = power;
@@ -2637,10 +2637,10 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
 	else
 		power *= default_scale_freq_power(sd, cpu);
 
-	power >>= SCHED_LOAD_SHIFT;
+	power >>= SCHED_POWER_SHIFT;
 
 	power *= scale_rt_power(cpu);
-	power >>= SCHED_LOAD_SHIFT;
+	power >>= SCHED_POWER_SHIFT;
 
 	if (!power)
 		power = 1;
@@ -2682,7 +2682,7 @@ static inline int
 fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
 {
 	/*
-	 * Only siblings can have significantly less than SCHED_LOAD_SCALE
+	 * Only siblings can have significantly less than SCHED_POWER_SCALE
 	 */
 	if (!(sd->flags & SD_SHARE_CPUPOWER))
 		return 0;
@@ -2770,7 +2770,7 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	}
 
 	/* Adjust by relative CPU power of the group */
-	sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE) / group->cpu_power;
+	sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / group->cpu_power;
 
 	/*
 	 * Consider the group unbalanced when the imbalance is larger
@@ -2787,7 +2787,8 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	if ((max_cpu_load - min_cpu_load) >= avg_load_per_task && max_nr_running > 1)
 		sgs->group_imb = 1;
 
-	sgs->group_capacity = DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
+	sgs->group_capacity = DIV_ROUND_CLOSEST(group->cpu_power,
+						SCHED_POWER_SCALE);
 	if (!sgs->group_capacity)
 		sgs->group_capacity = fix_small_capacity(sd, group);
 	sgs->group_weight = group->group_weight;
@@ -2961,7 +2962,7 @@ static int check_asym_packing(struct sched_domain *sd,
 		return 0;
 
 	*imbalance = DIV_ROUND_CLOSEST(sds->max_load * sds->busiest->cpu_power,
-				       SCHED_LOAD_SCALE);
+				       SCHED_POWER_SCALE);
 	return 1;
 }
 
@@ -2990,7 +2991,7 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
 			cpu_avg_load_per_task(this_cpu);
 
 	scaled_busy_load_per_task = sds->busiest_load_per_task
-						 * SCHED_LOAD_SCALE;
+					 * SCHED_POWER_SCALE;
 	scaled_busy_load_per_task /= sds->busiest->cpu_power;
 
 	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >=
@@ -3009,10 +3010,10 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
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
@@ -3020,15 +3021,15 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
 
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
@@ -3070,7 +3071,7 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 		load_above_capacity = (sds->busiest_nr_running -
 						sds->busiest_group_capacity);
 
-		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_LOAD_SCALE);
+		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_POWER_SCALE);
 
 		load_above_capacity /= sds->busiest->cpu_power;
 	}
@@ -3090,7 +3091,7 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 	/* How much load to actually move to equalise the imbalance */
 	*imbalance = min(max_pull * sds->busiest->cpu_power,
 		(sds->avg_load - sds->this_load) * sds->this->cpu_power)
-			/ SCHED_LOAD_SCALE;
+			/ SCHED_POWER_SCALE;
 
 	/*
 	 * if *imbalance is less than the average load per runnable task
@@ -3159,7 +3160,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (!sds.busiest || sds.busiest_nr_running == 0)
 		goto out_balanced;
 
-	sds.avg_load = (SCHED_LOAD_SCALE * sds.total_load) / sds.total_pwr;
+	sds.avg_load = (SCHED_POWER_SCALE * sds.total_load) / sds.total_pwr;
 
 	/*
 	 * If the busiest group is imbalanced the below checks don't
@@ -3238,7 +3239,8 @@ find_busiest_queue(struct sched_domain *sd, struct sched_group *group,
 
 	for_each_cpu(i, sched_group_cpus(group)) {
 		unsigned long power = power_of(i);
-		unsigned long capacity = DIV_ROUND_CLOSEST(power, SCHED_LOAD_SCALE);
+		unsigned long capacity = DIV_ROUND_CLOSEST(power,
+							   SCHED_POWER_SCALE);
 		unsigned long wl;
 
 		if (!capacity)
@@ -3263,7 +3265,7 @@ find_busiest_queue(struct sched_domain *sd, struct sched_group *group,
 		 * the load can be moved away from the cpu that is potentially
 		 * running at a lower capacity.
 		 */
-		wl = (wl * SCHED_LOAD_SCALE) / power;
+		wl = (wl * SCHED_POWER_SCALE) / power;
 
 		if (wl > max_load) {
 			max_load = wl;
