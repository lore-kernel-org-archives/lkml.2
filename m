Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab0FHE53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 00:57:29 -0400
Received: from ozlabs.org ([203.10.76.45]:55341 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843Ab0FHE5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 00:57:05 -0400
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <peterz@infradead.org>
From: Michael Neuling <mikey@neuling.org>
Date: Tue, 08 Jun 2010 14:57:02 +1000
Subject: [PATCH 2/3] sched: add asymmetric group packing option for sibling domain
In-Reply-To: <1275973022.91203.586435002889.qpush@pale>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Message-Id: <20100608045702.2936CCC897@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Signed-off-by: Peter Zijlstra <peterz@infradead.org>

---

 include/linux/sched.h    |    4 +
 include/linux/topology.h |    1 
 kernel/sched_fair.c      |  104 +++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 104 insertions(+), 5 deletions(-)

Index: linux-2.6-ozlabs/include/linux/sched.h
===================================================================
--- linux-2.6-ozlabs.orig/include/linux/sched.h
+++ linux-2.6-ozlabs/include/linux/sched.h
@@ -804,7 +804,7 @@ enum cpu_idle_type {
 #define SD_POWERSAVINGS_BALANCE	0x0100	/* Balance for power savings */
 #define SD_SHARE_PKG_RESOURCES	0x0200	/* Domain members share cpu pkg resources */
 #define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
-
+#define SD_ASYM_PACKING		0x0800  /* Place busy groups earlier in the domain */
 #define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
 
 enum powersavings_balance_level {
@@ -839,6 +839,8 @@ static inline int sd_balance_for_package
 	return SD_PREFER_SIBLING;
 }
 
+extern int __weak arch_sd_sibiling_asym_packing(void);
+
 /*
  * Optimise SD flags for power savings:
  * SD_BALANCE_NEWIDLE helps agressive task consolidation and power savings.
Index: linux-2.6-ozlabs/include/linux/topology.h
===================================================================
--- linux-2.6-ozlabs.orig/include/linux/topology.h
+++ linux-2.6-ozlabs/include/linux/topology.h
@@ -103,6 +103,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
 				| 0*SD_PREFER_SIBLING			\
+				| arch_sd_sibiling_asym_packing()	\
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
Index: linux-2.6-ozlabs/kernel/sched_fair.c
===================================================================
--- linux-2.6-ozlabs.orig/kernel/sched_fair.c
+++ linux-2.6-ozlabs/kernel/sched_fair.c
@@ -2463,6 +2463,41 @@ static inline void update_sg_lb_stats(st
 }
 
 /**
+ * update_sd_pick_busiest - return 1 on busiest group
+ * @sd: sched_domain whose statistics are to be checked
+ * @sds: sched_domain statistics
+ * @sg: sched_group candidate to be checked for being the busiest
+ * @sds: sched_group statistics
+ *
+ * This returns 1 for the busiest group. If asymmetric packing is
+ * enabled and we already have a busiest, but this candidate group has
+ * a higher cpu number than the current busiest, pick this sg.
+ */
+static int update_sd_pick_busiest(struct sched_domain *sd,
+				  struct sd_lb_stats *sds,
+				  struct sched_group *sg,
+				  struct sg_lb_stats *sgs,
+				  int this_cpu)
+{
+	if (sgs->sum_nr_running > sgs->group_capacity)
+		return 1;
+
+	if (sgs->group_imb)
+		return 1;
+
+	if ((sd->flags & SD_ASYM_PACKING) && sgs->sum_nr_running &&
+	    this_cpu < group_first_cpu(sg)) {
+		if (!sds->busiest)
+			return 1;
+
+		if (group_first_cpu(sds->busiest) > group_first_cpu(sg))
+			return 1;
+	}
+
+	return 0;
+}
+
+/**
  * update_sd_lb_stats - Update sched_group's statistics for load balancing.
  * @sd: sched_domain whose statistics are to be updated.
  * @this_cpu: Cpu for which load balance is currently performed.
@@ -2517,8 +2552,8 @@ static inline void update_sd_lb_stats(st
 			sds->this_nr_running = sgs.sum_nr_running;
 			sds->this_load_per_task = sgs.sum_weighted_load;
 		} else if (sgs.avg_load > sds->max_load &&
-			   (sgs.sum_nr_running > sgs.group_capacity ||
-				sgs.group_imb)) {
+			   update_sd_pick_busiest(sd, sds, group, &sgs,
+						  this_cpu)) {
 			sds->max_load = sgs.avg_load;
 			sds->busiest = group;
 			sds->busiest_nr_running = sgs.sum_nr_running;
@@ -2532,6 +2567,57 @@ static inline void update_sd_lb_stats(st
 	} while (group != sd->groups);
 }
 
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
+}
+
 /**
  * fix_small_imbalance - Calculate the minor imbalance that exists
  *			amongst the groups of a sched_domain, during
@@ -2724,6 +2810,10 @@ find_busiest_group(struct sched_domain *
 	if (!(*balance))
 		goto ret;
 
+	if ((idle == CPU_IDLE || idle == CPU_NEWLY_IDLE) &&
+	    check_asym_packing(sd, &sds, this_cpu, imbalance))
+		return sds.busiest;
+
 	if (!sds.busiest || sds.busiest_nr_running == 0)
 		goto out_balanced;
 
@@ -2813,9 +2903,14 @@ find_busiest_queue(struct sched_group *g
 /* Working cpumask for load_balance and load_balance_newidle. */
 static DEFINE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
 
-static int need_active_balance(struct sched_domain *sd, int sd_idle, int idle)
+static int need_active_balance(struct sched_domain *sd, int sd_idle, int idle,
+			       int busiest_cpu, int this_cpu)
 {
 	if (idle == CPU_NEWLY_IDLE) {
+
+		if (sd->flags & SD_ASYM_PACKING && busiest_cpu > this_cpu)
+			return 1;
+
 		/*
 		 * The only task running in a non-idle cpu can be moved to this
 		 * cpu in an attempt to completely freeup the other CPU
@@ -2934,7 +3029,8 @@ redo:
 		schedstat_inc(sd, lb_failed[idle]);
 		sd->nr_balance_failed++;
 
-		if (need_active_balance(sd, sd_idle, idle)) {
+		if (need_active_balance(sd, sd_idle, idle, cpu_of(busiest),
+					this_cpu)) {
 			raw_spin_lock_irqsave(&busiest->lock, flags);
 
 			/* don't kick the active_load_balance_cpu_stop,
