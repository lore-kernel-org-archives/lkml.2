Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab1KRXLe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:11:34 -0500
Received: from mga14.intel.com ([143.182.124.37]:43923 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757360Ab1KRXKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:10:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,535,1315206000"; 
   d="scan'208";a="76848903"
Message-Id: <20111118230554.047877809@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 18 Nov 2011 15:03:27 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>, alex.shi@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 4/6] sched, nohz: cleanup the find_new_ilb() using sched groups nr_busy_cpus
References: <20111118230323.592022417@sbsiddha-desk.sc.intel.com>
Content-Disposition: inline; filename=cleanup_find_ilb.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nr_busy_cpus in the sched_group_power indicates whether the group
is semi idle or not. This helps remove the is_semi_idle_group() and simplify
the find_new_ilb() in the context of finding an optimal cpu that can do
idle load balancing.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 kernel/sched/fair.c |   48 ++++++++++++------------------------------------
 1 file changed, 12 insertions(+), 36 deletions(-)

Index: tip/kernel/sched/fair.c
===================================================================
--- tip.orig/kernel/sched/fair.c
+++ tip/kernel/sched/fair.c
@@ -4710,7 +4710,6 @@ out_unlock:
  */
 static struct {
 	cpumask_var_t idle_cpus_mask;
-	cpumask_var_t grp_idle_mask;
 	atomic_t nr_cpus;
 	unsigned long next_balance;     /* in jiffy units */
 } nohz ____cacheline_aligned;
@@ -4751,33 +4750,6 @@ static inline struct sched_domain *lowes
 		(sd && (sd->flags & flag)); sd = sd->parent)
 
 /**
- * is_semi_idle_group - Checks if the given sched_group is semi-idle.
- * @ilb_group:	group to be checked for semi-idleness
- *
- * Returns:	1 if the group is semi-idle. 0 otherwise.
- *
- * We define a sched_group to be semi idle if it has atleast one idle-CPU
- * and atleast one non-idle CPU. This helper function checks if the given
- * sched_group is semi-idle or not.
- */
-static inline int is_semi_idle_group(struct sched_group *ilb_group)
-{
-	cpumask_and(nohz.grp_idle_mask, nohz.idle_cpus_mask,
-					sched_group_cpus(ilb_group));
-
-	/*
-	 * A sched_group is semi-idle when it has atleast one busy cpu
-	 * and atleast one idle cpu.
-	 */
-	if (cpumask_empty(nohz.grp_idle_mask))
-		return 0;
-
-	if (cpumask_equal(nohz.grp_idle_mask, sched_group_cpus(ilb_group)))
-		return 0;
-
-	return 1;
-}
-/**
  * find_new_ilb - Finds the optimum idle load balancer for nomination.
  * @cpu:	The cpu which is nominating a new idle_load_balancer.
  *
@@ -4792,8 +4764,8 @@ static inline int is_semi_idle_group(str
 static int find_new_ilb(int cpu)
 {
 	int ilb = cpumask_first(nohz.idle_cpus_mask);
+	struct sched_group *ilbg;
 	struct sched_domain *sd;
-	struct sched_group *ilb_group;
 
 	/*
 	 * Have idle load balancer selection from semi-idle packages only
@@ -4811,23 +4783,28 @@ static int find_new_ilb(int cpu)
 
 	rcu_read_lock();
 	for_each_flag_domain(cpu, sd, SD_POWERSAVINGS_BALANCE) {
-		ilb_group = sd->groups;
+		ilbg = sd->groups;
 
 		do {
-			if (is_semi_idle_group(ilb_group)) {
-				ilb = cpumask_first(nohz.grp_idle_mask);
+			if (ilbg->group_weight !=
+				atomic_read(&ilbg->sgp->nr_busy_cpus)) {
+				ilb = cpumask_first_and(nohz.idle_cpus_mask,
+							sched_group_cpus(ilbg));
 				goto unlock;
 			}
 
-			ilb_group = ilb_group->next;
+			ilbg = ilbg->next;
 
-		} while (ilb_group != sd->groups);
+		} while (ilbg != sd->groups);
 	}
 unlock:
 	rcu_read_unlock();
 
 out_done:
-	return ilb;
+	if (ilb < nr_cpu_ids && idle_cpu(ilb))
+		return ilb;
+
+	return nr_cpu_ids;
 }
 #else /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
 static inline int find_new_ilb(int call_cpu)
@@ -5543,7 +5520,6 @@ __init void init_sched_fair_class(void)
 
 #ifdef CONFIG_NO_HZ
 	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
-	alloc_cpumask_var(&nohz.grp_idle_mask, GFP_NOWAIT);
 #endif
 #endif /* SMP */
 


