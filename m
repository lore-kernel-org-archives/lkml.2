Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab0FIKPB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:15:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:41331 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757449Ab0FIKOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:14:54 -0400
Date: Wed, 9 Jun 2010 10:14:15 GMT
From: tip-bot for Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, arjan@linux.intel.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu, mikey@neuling.org
Reply-To: mingo@redhat.com, hpa@zytor.com, vatsa@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       arjan@linux.intel.com, tglx@linutronix.de, mingo@elte.hu,
       mikey@neuling.org
In-Reply-To: <20100608045702.21D03CC895@localhost.localdomain>
References: <20100608045702.21D03CC895@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix capacity calculations for SMT4
Message-ID: <tip-9d5efe05eb0c904545a28b19c18b949f23334de0@git.kernel.org>
Git-Commit-ID: 9d5efe05eb0c904545a28b19c18b949f23334de0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Jun 2010 10:14:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9d5efe05eb0c904545a28b19c18b949f23334de0
Gitweb:     http://git.kernel.org/tip/9d5efe05eb0c904545a28b19c18b949f23334de0
Author:     Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
AuthorDate: Tue, 8 Jun 2010 14:57:02 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Jun 2010 10:34:54 +0200

sched: Fix capacity calculations for SMT4

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arjan van de Ven <arjan@linux.intel.com>
LKML-Reference: <20100608045702.21D03CC895@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    2 +-
 kernel/sched_fair.c   |   53 +++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 44 insertions(+), 11 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a3e5b1c..c731296 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -857,7 +857,7 @@ struct sched_group {
 	 * CPU power of this group, SCHED_LOAD_SCALE being max power for a
 	 * single CPU.
 	 */
-	unsigned int cpu_power;
+	unsigned int cpu_power, cpu_power_orig;
 
 	/*
 	 * The CPUs this group covers.
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 6ee2e0a..b9b3462 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2285,13 +2285,6 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
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
@@ -2301,6 +2294,15 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
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
 
@@ -2333,6 +2335,31 @@ static void update_group_power(struct sched_domain *sd, int cpu)
 	sdg->cpu_power = power;
 }
 
+/*
+ * Try and fix up capacity for tiny siblings, this is needed when
+ * things like SD_ASYM_PACKING need f_b_g to select another sibling
+ * which on its own isn't powerful enough.
+ *
+ * See update_sd_pick_busiest() and check_asym_packing().
+ */
+static inline int
+fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
+{
+	/*
+	 * Only siblings can have significantly less than SCHED_LOAD_SCALE
+	 */
+	if (sd->level != SD_LV_SIBLING)
+		return 0;
+
+	/*
+	 * If ~90% of the cpu_power is still there, we're good.
+	 */
+	if (group->cpu_power * 32 < group->cpu_power_orig * 29)
+		return 1;
+
+	return 0;
+}
+
 /**
  * update_sg_lb_stats - Update sched_group's statistics for load balancing.
  * @sd: The sched_domain whose statistics are to be updated.
@@ -2426,6 +2453,8 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 
 	sgs->group_capacity =
 		DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
+	if (!sgs->group_capacity)
+		sgs->group_capacity = fix_small_capacity(sd, group);
 }
 
 /**
@@ -2724,8 +2753,9 @@ ret:
  * find_busiest_queue - find the busiest runqueue among the cpus in group.
  */
 static struct rq *
-find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
-		   unsigned long imbalance, const struct cpumask *cpus)
+find_busiest_queue(struct sched_domain *sd, struct sched_group *group,
+		   enum cpu_idle_type idle, unsigned long imbalance,
+		   const struct cpumask *cpus)
 {
 	struct rq *busiest = NULL, *rq;
 	unsigned long max_load = 0;
@@ -2736,6 +2766,9 @@ find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
 		unsigned long capacity = DIV_ROUND_CLOSEST(power, SCHED_LOAD_SCALE);
 		unsigned long wl;
 
+		if (!capacity)
+			capacity = fix_small_capacity(sd, group);
+
 		if (!cpumask_test_cpu(i, cpus))
 			continue;
 
@@ -2852,7 +2885,7 @@ redo:
 		goto out_balanced;
 	}
 
-	busiest = find_busiest_queue(group, idle, imbalance, cpus);
+	busiest = find_busiest_queue(sd, group, idle, imbalance, cpus);
 	if (!busiest) {
 		schedstat_inc(sd, lb_nobusyq[idle]);
 		goto out_balanced;
