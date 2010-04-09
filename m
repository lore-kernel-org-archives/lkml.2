Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab0DIGVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 02:21:24 -0400
Received: from ozlabs.org ([203.10.76.45]:46438 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061Ab0DIGVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 02:21:21 -0400
To: Peter Zijlstra <peterz@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
From: Michael Neuling <mikey@neuling.org>
Date: Fri, 09 Apr 2010 16:21:18 +1000
Subject: [PATCH 2/5] sched: add asymmetric packing option for sibling domain
In-Reply-To: <1270794078.794237.347827867455.qpush@pale>
CC: <linuxppc-dev@ozlabs.org>, <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Message-Id: <20100409062118.DDF38CBB6E@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some CPUs perform better when tasks are run on lower thread numbers.
In the case of POWER7, when higher threads are idled, the core can run
in lower SMT modes and hence perform better.

This creates a new sd flag to prefer lower threads. 

Based heavily on patch from Peter Zijlstra.  

Signed-off-by: Michael Neuling <mikey@neuling.org>
---
Peter: Since this is based mainly off your initial patch, it should
have your signed-off-by too, but I didn't want to add without your
permission.  Can I add it?

---

 include/linux/sched.h    |    4 ++
 include/linux/topology.h |    1 
 kernel/sched_fair.c      |   64 ++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 65 insertions(+), 4 deletions(-)

Index: linux-2.6-ozlabs/include/linux/sched.h
===================================================================
--- linux-2.6-ozlabs.orig/include/linux/sched.h
+++ linux-2.6-ozlabs/include/linux/sched.h
@@ -799,7 +799,7 @@ enum cpu_idle_type {
 #define SD_POWERSAVINGS_BALANCE	0x0100	/* Balance for power savings */
 #define SD_SHARE_PKG_RESOURCES	0x0200	/* Domain members share cpu pkg resources */
 #define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
-
+#define SD_ASYM_PACKING		0x0800  /* Place busy groups earlier in the domain */
 #define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
 
 enum powersavings_balance_level {
@@ -834,6 +834,8 @@ static inline int sd_balance_for_package
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
@@ -102,6 +102,7 @@ int arch_update_cpu_topology(void);
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
@@ -2493,6 +2493,31 @@ static inline void update_sg_lb_stats(st
 }
 
 /**
+ * update_sd_pick_busiest - return 1 on busiest
+ */
+static int update_sd_pick_busiest(struct sched_domain *sd,
+				  struct sd_lb_stats *sds,
+				  struct sched_group *sg,
+				  struct sg_lb_stats *sgs)
+{
+	if (sgs->sum_nr_running > sgs->group_capacity)
+		return 1;
+
+	if (sgs->group_imb)
+		return 1;
+
+	if ((sd->flags & SD_ASYM_PACKING) && sgs->sum_nr_running) {
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
@@ -2546,9 +2571,8 @@ static inline void update_sd_lb_stats(st
 			sds->this = group;
 			sds->this_nr_running = sgs.sum_nr_running;
 			sds->this_load_per_task = sgs.sum_weighted_load;
-		} else if (sgs.avg_load > sds->max_load &&
-			   (sgs.sum_nr_running > sgs.group_capacity ||
-				sgs.group_imb)) {
+		} else if (sgs.avg_load >= sds->max_load &&
+			   update_sd_pick_busiest(sd, sds, group, &sgs)) {
 			sds->max_load = sgs.avg_load;
 			sds->busiest = group;
 			sds->busiest_nr_running = sgs.sum_nr_running;
@@ -2562,6 +2586,36 @@ static inline void update_sd_lb_stats(st
 	} while (group != sd->groups);
 }
 
+int __weak arch_sd_sibiling_asym_packing(void)
+{
+       return 0*SD_ASYM_PACKING;
+}
+
+/**
+ * check_asym_packing - Check to see if we the group is packed into
+ *			the sched doman
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
@@ -2754,6 +2808,10 @@ find_busiest_group(struct sched_domain *
 	if (!(*balance))
 		goto ret;
 
+	if ((idle == CPU_IDLE || idle == CPU_NEWLY_IDLE) &&
+	    check_asym_packing(sd, &sds, this_cpu, imbalance))
+		return sds.busiest;
+
 	if (!sds.busiest || sds.busiest_nr_running == 0)
 		goto out_balanced;
 
