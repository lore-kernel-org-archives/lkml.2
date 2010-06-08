Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab0FHE5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 00:57:07 -0400
Received: from ozlabs.org ([203.10.76.45]:55334 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab0FHE5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 00:57:03 -0400
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <peterz@infradead.org>
From: Michael Neuling <mikey@neuling.org>
Date: Tue, 08 Jun 2010 14:57:02 +1000
Subject: [PATCH 1/3] sched: fix capacity calculations for SMT4
In-Reply-To: <1275973022.91203.586435002889.qpush@pale>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Message-Id: <20100608045702.21D03CC895@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

Handle cpu capacity being reported as 0 on cores with more number of
hardware threads. For example on a Power7 core with 4 hardware
threads, core power is 1177 and thus power of each hardware thread is
1177/4 = 294. This low power can lead to capacity for each hardware
thread being calculated as 0, which leads to tasks bouncing within the
core madly! 

Fix this by reporting capacity for hardware threads as 1, provided
their power is not scaled down significantly because of frequency
scaling or real-time tasks usage of cpu.

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>

---

 include/linux/sched.h |    2 -
 kernel/sched_fair.c   |   56 +++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 48 insertions(+), 10 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -860,7 +860,7 @@ struct sched_group {
 	 * CPU power of this group, SCHED_LOAD_SCALE being max power for a
 	 * single CPU.
 	 */
-	unsigned int cpu_power;
+	unsigned int cpu_power, cpu_power_orig;
 
 	/*
 	 * The CPUs this group covers.
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -2285,13 +2285,6 @@ static void update_cpu_power(struct sche
 	unsigned long power = SCHED_LOAD_SCALE;
 	struct sched_group *sdg = sd->groups;
 
-	if (sched_feat(ARCH_POWER))
-		power *= arch_scale_freq_power(sd, cpu);
-	else
-		power *= default_scale_freq_power(sd, cpu);
-
-	power >>= SCHED_LOAD_SHIFT;
-
 	if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
 		if (sched_feat(ARCH_POWER))
 			power *= arch_scale_smt_power(sd, cpu);
@@ -2301,6 +2294,15 @@ static void update_cpu_power(struct sche
 		power >>= SCHED_LOAD_SHIFT;
 	}
 
+	sdg->cpu_power_orig = power;
+
+	if (sched_feat(ARCH_POWER))
+		power *= arch_scale_freq_power(sd, cpu);
+	else
+		power *= default_scale_freq_power(sd, cpu);
+
+	power >>= SCHED_LOAD_SHIFT;
+
 	power *= scale_rt_power(cpu);
 	power >>= SCHED_LOAD_SHIFT;
 
@@ -2333,6 +2335,36 @@ static void update_group_power(struct sc
 	sdg->cpu_power = power;
 }
 
+/*
+ * What's the influence of freq. scaling or real-time tasks on a cpu's power?
+ *
+ * Return 1 (influence exists) if power was scaled by more than 10% due to
+ * either factor, else return 0 (i.e no influence exists).
+ *
+ * This is specifically needed to handle capacity being reported as 0 for
+ * hardware threads within a Power7-like core (that have 4 or more hardware
+ * threads/core).
+ */
+static inline int
+rt_freq_influence(struct sched_group *group, struct sched_domain *sd)
+{
+	/* We need this test only at SMT domain level */
+	if (sd->child)
+		return 1;
+
+	/*
+	 * Check to see if the final cpu power was reduced by more than 10% due
+	 * to frequency scaling or real-time task's cpu usage. Note that
+	 * cpu_power could be different from cpu_power_orig even in the absence
+	 * of either factors - this is due to rounding issues in
+	 * update_cpu_power()
+	 */
+	if (group->cpu_power * 100 < group->cpu_power_orig * 90)
+		return 1;
+
+	return 0;
+}
+
 /**
  * update_sg_lb_stats - Update sched_group's statistics for load balancing.
  * @sd: The sched_domain whose statistics are to be updated.
@@ -2426,6 +2458,8 @@ static inline void update_sg_lb_stats(st
 
 	sgs->group_capacity =
 		DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
+	if (!sgs->group_capacity && !rt_freq_influence(group, sd))
+		sgs->group_capacity = 1;
 }
 
 /**
@@ -2725,7 +2759,8 @@ ret:
  */
 static struct rq *
 find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
-		   unsigned long imbalance, const struct cpumask *cpus)
+		   unsigned long imbalance, const struct cpumask *cpus,
+		   struct sched_domain *sd)
 {
 	struct rq *busiest = NULL, *rq;
 	unsigned long max_load = 0;
@@ -2736,6 +2771,9 @@ find_busiest_queue(struct sched_group *g
 		unsigned long capacity = DIV_ROUND_CLOSEST(power, SCHED_LOAD_SCALE);
 		unsigned long wl;
 
+		if (!capacity && !rt_freq_influence(group, sd))
+			capacity = 1;
+
 		if (!cpumask_test_cpu(i, cpus))
 			continue;
 
@@ -2852,7 +2890,7 @@ redo:
 		goto out_balanced;
 	}
 
-	busiest = find_busiest_queue(group, idle, imbalance, cpus);
+	busiest = find_busiest_queue(group, idle, imbalance, cpus, sd);
 	if (!busiest) {
 		schedstat_inc(sd, lb_nobusyq[idle]);
 		goto out_balanced;
