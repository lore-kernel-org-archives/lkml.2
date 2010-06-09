Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab0FIKPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:15:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:41367 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757449Ab0FIKPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:15:08 -0400
Date: Wed, 9 Jun 2010 10:14:34 GMT
From: tip-bot for Michael Neuling <mikey@neuling.org>
Cc: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, arjan@linux.intel.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu, mikey@neuling.org
Reply-To: mingo@redhat.com, hpa@zytor.com, vatsa@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       arjan@linux.intel.com, tglx@linutronix.de, mingo@elte.hu,
       mikey@neuling.org
In-Reply-To: <20100608045702.2936CCC897@localhost.localdomain>
References: <20100608045702.2936CCC897@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Add asymmetric group packing option for sibling domain
Message-ID: <tip-532cb4c401e225b084c14d6bd6a2f8ee561de2f1@git.kernel.org>
Git-Commit-ID: 532cb4c401e225b084c14d6bd6a2f8ee561de2f1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Jun 2010 10:14:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  532cb4c401e225b084c14d6bd6a2f8ee561de2f1
Gitweb:     http://git.kernel.org/tip/532cb4c401e225b084c14d6bd6a2f8ee561de2f1
Author:     Michael Neuling <mikey@neuling.org>
AuthorDate: Tue, 8 Jun 2010 14:57:02 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Jun 2010 10:34:55 +0200

sched: Add asymmetric group packing option for sibling domain

Check to see if the group is packed in a sched doman.

This is primarily intended to used at the sibling level.  Some cores
like POWER7 prefer to use lower numbered SMT threads.  In the case of
POWER7, it can move to lower SMT modes only when higher threads are
idle.  When in lower SMT modes, the threads will perform better since
they share less core resources.  Hence when we have idle threads, we
want them to be the higher ones.

This adds a hook into f_b_g() called check_asym_packing() to check the
packing.  This packing function is run on idle threads.  It checks to
see if the busiest CPU in this domain (core in the P7 case) has a
higher CPU number than what where the packing function is being run
on.  If it is, calculate the imbalance and return the higher busier
thread as the busiest group to f_b_g().  Here we are assuming a lower
CPU number will be equivalent to a lower SMT thread number.

It also creates a new SD_ASYM_PACKING flag to enable this feature at
any scheduler domain level.

It also creates an arch hook to enable this feature at the sibling
level.  The default function doesn't enable this feature.

Based heavily on patch from Peter Zijlstra.
Fixes from Srivatsa Vaddagiri.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <20100608045702.2936CCC897@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h    |    4 +-
 include/linux/topology.h |    1 +
 kernel/sched_fair.c      |  139 ++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 126 insertions(+), 18 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c731296..ff154e1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -801,7 +801,7 @@ enum cpu_idle_type {
 #define SD_POWERSAVINGS_BALANCE	0x0100	/* Balance for power savings */
 #define SD_SHARE_PKG_RESOURCES	0x0200	/* Domain members share cpu pkg resources */
 #define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
-
+#define SD_ASYM_PACKING		0x0800  /* Place busy groups earlier in the domain */
 #define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
 
 enum powersavings_balance_level {
@@ -836,6 +836,8 @@ static inline int sd_balance_for_package_power(void)
 	return SD_PREFER_SIBLING;
 }
 
+extern int __weak arch_sd_sibiling_asym_packing(void);
+
 /*
  * Optimise SD flags for power savings:
  * SD_BALANCE_NEWIDLE helps agressive task consolidation and power savings.
diff --git a/include/linux/topology.h b/include/linux/topology.h
index c44df50..cf57f30 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -103,6 +103,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
 				| 0*SD_PREFER_SIBLING			\
+				| arch_sd_sibiling_asym_packing()	\
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index b9b3462..593424f 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2458,11 +2458,53 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 }
 
 /**
+ * update_sd_pick_busiest - return 1 on busiest group
+ * @sd: sched_domain whose statistics are to be checked
+ * @sds: sched_domain statistics
+ * @sg: sched_group candidate to be checked for being the busiest
+ * @sds: sched_group statistics
+ *
+ * Determine if @sg is a busier group than the previously selected
+ * busiest group.
+ */
+static bool update_sd_pick_busiest(struct sched_domain *sd,
+				   struct sd_lb_stats *sds,
+				   struct sched_group *sg,
+				   struct sg_lb_stats *sgs,
+				   int this_cpu)
+{
+	if (sgs->avg_load <= sds->max_load)
+		return false;
+
+	if (sgs->sum_nr_running > sgs->group_capacity)
+		return true;
+
+	if (sgs->group_imb)
+		return true;
+
+	/*
+	 * ASYM_PACKING needs to move all the work to the lowest
+	 * numbered CPUs in the group, therefore mark all groups
+	 * higher than ourself as busy.
+	 */
+	if ((sd->flags & SD_ASYM_PACKING) && sgs->sum_nr_running &&
+	    this_cpu < group_first_cpu(sg)) {
+		if (!sds->busiest)
+			return true;
+
+		if (group_first_cpu(sds->busiest) > group_first_cpu(sg))
+			return true;
+	}
+
+	return false;
+}
+
+/**
  * update_sd_lb_stats - Update sched_group's statistics for load balancing.
  * @sd: sched_domain whose statistics are to be updated.
  * @this_cpu: Cpu for which load balance is currently performed.
  * @idle: Idle status of this_cpu
- * @sd_idle: Idle status of the sched_domain containing group.
+ * @sd_idle: Idle status of the sched_domain containing sg.
  * @cpus: Set of cpus considered for load balancing.
  * @balance: Should we balance.
  * @sds: variable to hold the statistics for this sched_domain.
@@ -2473,7 +2515,7 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 			struct sd_lb_stats *sds)
 {
 	struct sched_domain *child = sd->child;
-	struct sched_group *group = sd->groups;
+	struct sched_group *sg = sd->groups;
 	struct sg_lb_stats sgs;
 	int load_idx, prefer_sibling = 0;
 
@@ -2486,21 +2528,20 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 	do {
 		int local_group;
 
-		local_group = cpumask_test_cpu(this_cpu,
-					       sched_group_cpus(group));
+		local_group = cpumask_test_cpu(this_cpu, sched_group_cpus(sg));
 		memset(&sgs, 0, sizeof(sgs));
-		update_sg_lb_stats(sd, group, this_cpu, idle, load_idx, sd_idle,
+		update_sg_lb_stats(sd, sg, this_cpu, idle, load_idx, sd_idle,
 				local_group, cpus, balance, &sgs);
 
 		if (local_group && !(*balance))
 			return;
 
 		sds->total_load += sgs.group_load;
-		sds->total_pwr += group->cpu_power;
+		sds->total_pwr += sg->cpu_power;
 
 		/*
 		 * In case the child domain prefers tasks go to siblings
-		 * first, lower the group capacity to one so that we'll try
+		 * first, lower the sg capacity to one so that we'll try
 		 * and move all the excess tasks away.
 		 */
 		if (prefer_sibling)
@@ -2508,23 +2549,72 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 
 		if (local_group) {
 			sds->this_load = sgs.avg_load;
-			sds->this = group;
+			sds->this = sg;
 			sds->this_nr_running = sgs.sum_nr_running;
 			sds->this_load_per_task = sgs.sum_weighted_load;
-		} else if (sgs.avg_load > sds->max_load &&
-			   (sgs.sum_nr_running > sgs.group_capacity ||
-				sgs.group_imb)) {
+		} else if (update_sd_pick_busiest(sd, sds, sg, &sgs, this_cpu)) {
 			sds->max_load = sgs.avg_load;
-			sds->busiest = group;
+			sds->busiest = sg;
 			sds->busiest_nr_running = sgs.sum_nr_running;
 			sds->busiest_group_capacity = sgs.group_capacity;
 			sds->busiest_load_per_task = sgs.sum_weighted_load;
 			sds->group_imb = sgs.group_imb;
 		}
 
-		update_sd_power_savings_stats(group, sds, local_group, &sgs);
-		group = group->next;
-	} while (group != sd->groups);
+		update_sd_power_savings_stats(sg, sds, local_group, &sgs);
+		sg = sg->next;
+	} while (sg != sd->groups);
+}
+
+int __weak arch_sd_sibiling_asym_packing(void)
+{
+       return 0*SD_ASYM_PACKING;
+}
+
+/**
+ * check_asym_packing - Check to see if the group is packed into the
+ *			sched doman.
+ *
+ * This is primarily intended to used at the sibling level.  Some
+ * cores like POWER7 prefer to use lower numbered SMT threads.  In the
+ * case of POWER7, it can move to lower SMT modes only when higher
+ * threads are idle.  When in lower SMT modes, the threads will
+ * perform better since they share less core resources.  Hence when we
+ * have idle threads, we want them to be the higher ones.
+ *
+ * This packing function is run on idle threads.  It checks to see if
+ * the busiest CPU in this domain (core in the P7 case) has a higher
+ * CPU number than the packing function is being run on.  Here we are
+ * assuming lower CPU number will be equivalent to lower a SMT thread
+ * number.
+ *
+ * @sd: The sched_domain whose packing is to be checked.
+ * @sds: Statistics of the sched_domain which is to be packed
+ * @this_cpu: The cpu at whose sched_domain we're performing load-balance.
+ * @imbalance: returns amount of imbalanced due to packing.
+ *
+ * Returns 1 when packing is required and a task should be moved to
+ * this CPU.  The amount of the imbalance is returned in *imbalance.
+ */
+static int check_asym_packing(struct sched_domain *sd,
+			      struct sd_lb_stats *sds,
+			      int this_cpu, unsigned long *imbalance)
+{
+	int busiest_cpu;
+
+	if (!(sd->flags & SD_ASYM_PACKING))
+		return 0;
+
+	if (!sds->busiest)
+		return 0;
+
+	busiest_cpu = group_first_cpu(sds->busiest);
+	if (this_cpu > busiest_cpu)
+		return 0;
+
+	*imbalance = DIV_ROUND_CLOSEST(sds->max_load * sds->busiest->cpu_power,
+				       SCHED_LOAD_SCALE);
+	return 1;
 }
 
 /**
@@ -2719,6 +2809,10 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (!(*balance))
 		goto ret;
 
+	if ((idle == CPU_IDLE || idle == CPU_NEWLY_IDLE) &&
+	    check_asym_packing(sd, &sds, this_cpu, imbalance))
+		return sds.busiest;
+
 	if (!sds.busiest || sds.busiest_nr_running == 0)
 		goto out_balanced;
 
@@ -2808,9 +2902,19 @@ find_busiest_queue(struct sched_domain *sd, struct sched_group *group,
 /* Working cpumask for load_balance and load_balance_newidle. */
 static DEFINE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
 
-static int need_active_balance(struct sched_domain *sd, int sd_idle, int idle)
+static int need_active_balance(struct sched_domain *sd, int sd_idle, int idle,
+			       int busiest_cpu, int this_cpu)
 {
 	if (idle == CPU_NEWLY_IDLE) {
+
+		/*
+		 * ASYM_PACKING needs to force migrate tasks from busy but
+		 * higher numbered CPUs in order to pack all tasks in the
+		 * lowest numbered CPUs.
+		 */
+		if ((sd->flags & SD_ASYM_PACKING) && busiest_cpu > this_cpu)
+			return 1;
+
 		/*
 		 * The only task running in a non-idle cpu can be moved to this
 		 * cpu in an attempt to completely freeup the other CPU
@@ -2929,7 +3033,8 @@ redo:
 		schedstat_inc(sd, lb_failed[idle]);
 		sd->nr_balance_failed++;
 
-		if (need_active_balance(sd, sd_idle, idle)) {
+		if (need_active_balance(sd, sd_idle, idle, cpu_of(busiest),
+					this_cpu)) {
 			raw_spin_lock_irqsave(&busiest->lock, flags);
 
 			/* don't kick the active_load_balance_cpu_stop,
