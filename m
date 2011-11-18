Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710Ab1KRXKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:10:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:51581 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757156Ab1KRXKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:10:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,535,1315206000"; 
   d="scan'208";a="87049037"
Message-Id: <20111118230553.995756330@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 18 Nov 2011 15:03:26 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>, alex.shi@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 3/6] sched, nohz: sched group, domain aware nohz idle load balancing
References: <20111118230323.592022417@sbsiddha-desk.sc.intel.com>
Content-Disposition: inline; filename=simplify_ilb_using_grp_nr_busy_cpus.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make nohz idle load balancing more scalabale by using the nr_busy_cpus in
the struct sched_group_power.

Idle load balance is kicked on one of the idle cpu's when there is atleast
one idle cpu and

 - a busy rq having more than one task or

 - a busy scheduler group having multiple busy cpus that exceed the sched group
   power or

 - for the SD_ASYM_PACKING domain, if the lower numbered cpu's in that
   domain are idle compared to the busy ones.

This will help in kicking the idle load balancing request only when
there is a real imbalance. And once it is mostly balanced, these kicks will
be minimized.

These changes helped improve the workload that is context switch intensive
between number of task pairs by 2x on a 8 socket NHM-EX based system.

Reported-by: Tim Chen <tim.c.chen@intel.com>
Tested-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 kernel/sched/fair.c |  161 ++++++++++++++--------------------------------------
 1 file changed, 46 insertions(+), 115 deletions(-)

Index: tip/kernel/sched/fair.c
===================================================================
--- tip.orig/kernel/sched/fair.c
+++ tip/kernel/sched/fair.c
@@ -4704,28 +4704,17 @@ out_unlock:
 #ifdef CONFIG_NO_HZ
 /*
  * idle load balancing details
- * - One of the idle CPUs nominates itself as idle load_balancer, while
- *   entering idle.
- * - This idle load balancer CPU will also go into tickless mode when
- *   it is idle, just like all other idle CPUs
  * - When one of the busy CPUs notice that there may be an idle rebalancing
  *   needed, they will kick the idle load balancer, which then does idle
  *   load balancing for all the idle CPUs.
  */
 static struct {
-	atomic_t load_balancer;
-	atomic_t first_pick_cpu;
-	atomic_t second_pick_cpu;
 	cpumask_var_t idle_cpus_mask;
 	cpumask_var_t grp_idle_mask;
+	atomic_t nr_cpus;
 	unsigned long next_balance;     /* in jiffy units */
 } nohz ____cacheline_aligned;
 
-int get_nohz_load_balancer(void)
-{
-	return atomic_read(&nohz.load_balancer);
-}
-
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
 /**
  * lowest_flag_domain - Return lowest sched_domain containing flag.
@@ -4802,9 +4791,9 @@ static inline int is_semi_idle_group(str
  */
 static int find_new_ilb(int cpu)
 {
+	int ilb = cpumask_first(nohz.idle_cpus_mask);
 	struct sched_domain *sd;
 	struct sched_group *ilb_group;
-	int ilb = nr_cpu_ids;
 
 	/*
 	 * Have idle load balancer selection from semi-idle packages only
@@ -4858,13 +4847,10 @@ static void nohz_balancer_kick(int cpu)
 
 	nohz.next_balance++;
 
-	ilb_cpu = get_nohz_load_balancer();
+	ilb_cpu = find_new_ilb(cpu);
 
-	if (ilb_cpu >= nr_cpu_ids) {
-		ilb_cpu = cpumask_first(nohz.idle_cpus_mask);
-		if (ilb_cpu >= nr_cpu_ids)
-			return;
-	}
+	if (ilb_cpu >= nr_cpu_ids)
+		return;
 
 	if (test_and_set_bit(NOHZ_BALANCE_KICK, nohz_flags(cpu)))
 		return;
@@ -4879,17 +4865,8 @@ static void nohz_balancer_kick(int cpu)
 }
 
 /*
- * This routine will try to nominate the ilb (idle load balancing)
- * owner among the cpus whose ticks are stopped. ilb owner will do the idle
- * load balancing on behalf of all those cpus.
- *
- * When the ilb owner becomes busy, we will not have new ilb owner until some
- * idle CPU wakes up and goes back to idle or some busy CPU tries to kick
- * idle load balancing by kicking one of the idle CPUs.
- *
- * Ticks are stopped for the ilb owner as well, with busy CPU kicking this
- * ilb owner CPU in future (when there is a need for idle load balancing on
- * behalf of all idle CPUs).
+ * This routine will record that this cpu is going idle with tick stopped.
+ * This info will be used in performing idle load balancing in the future.
  */
 void select_nohz_load_balancer(int stop_tick)
 {
@@ -4897,49 +4874,11 @@ void select_nohz_load_balancer(int stop_
 	struct sched_domain *sd;
 
 	if (stop_tick) {
-		if (!cpu_active(cpu)) {
-			if (atomic_read(&nohz.load_balancer) != cpu)
-				return;
-
-			/*
-			 * If we are going offline and still the leader,
-			 * give up!
-			 */
-			if (atomic_cmpxchg(&nohz.load_balancer, cpu,
-					   nr_cpu_ids) != cpu)
-				BUG();
-
+		if (test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))
 			return;
-		}
 
 		cpumask_set_cpu(cpu, nohz.idle_cpus_mask);
-
-		if (atomic_read(&nohz.first_pick_cpu) == cpu)
-			atomic_cmpxchg(&nohz.first_pick_cpu, cpu, nr_cpu_ids);
-		if (atomic_read(&nohz.second_pick_cpu) == cpu)
-			atomic_cmpxchg(&nohz.second_pick_cpu, cpu, nr_cpu_ids);
-
-		if (atomic_read(&nohz.load_balancer) >= nr_cpu_ids) {
-			int new_ilb;
-
-			/* make me the ilb owner */
-			if (atomic_cmpxchg(&nohz.load_balancer, nr_cpu_ids,
-					   cpu) != nr_cpu_ids)
-				return;
-
-			/*
-			 * Check to see if there is a more power-efficient
-			 * ilb.
-			 */
-			new_ilb = find_new_ilb(cpu);
-			if (new_ilb < nr_cpu_ids && new_ilb != cpu) {
-				atomic_set(&nohz.load_balancer, nr_cpu_ids);
-				resched_cpu(new_ilb);
-				return;
-			}
-			return;
-		}
-
+		atomic_inc(&nohz.nr_cpus);
 		set_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
 		/*
 		 * Indicate the idle state to all the scheduler groups that
@@ -4947,16 +4886,6 @@ void select_nohz_load_balancer(int stop_
 		 */
 		for_each_domain(cpu, sd)
 			atomic_dec(&sd->groups->sgp->nr_busy_cpus);
-	} else {
-		if (!cpumask_test_cpu(cpu, nohz.idle_cpus_mask))
-			return;
-
-		cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
-
-		if (atomic_read(&nohz.load_balancer) == cpu)
-			if (atomic_cmpxchg(&nohz.load_balancer, cpu,
-					   nr_cpu_ids) != cpu)
-				BUG();
 	}
 	return;
 }
@@ -5067,7 +4996,7 @@ static void nohz_idle_balance(int this_c
 		goto end;
 
 	for_each_cpu(balance_cpu, nohz.idle_cpus_mask) {
-		if (balance_cpu == this_cpu)
+		if (balance_cpu == this_cpu || !idle_cpu(this_cpu))
 			continue;
 
 		/*
@@ -5095,24 +5024,22 @@ end:
 }
 
 /*
- * Current heuristic for kicking the idle load balancer
- * - first_pick_cpu is the one of the busy CPUs. It will kick
- *   idle load balancer when it has more than one process active. This
- *   eliminates the need for idle load balancing altogether when we have
- *   only one running process in the system (common case).
- * - If there are more than one busy CPU, idle load balancer may have
- *   to run for active_load_balance to happen (i.e., two busy CPUs are
- *   SMT or core siblings and can run better if they move to different
- *   physical CPUs). So, second_pick_cpu is the second of the busy CPUs
- *   which will kick idle load balancer as soon as it has any load.
+ * Current heuristic for kicking the idle load balancer in the presence
+ * of an idle cpu is the system.
+ *  - This rq has more than one task.
+ *  - At any scheduler domain level, this cpu's scheduler group has multiple
+ *    busy cpu's exceeding the group's power.
+ *  - For SD_ASYM_PACKING, if the lower numbered cpu's in the scheduler
+ *    domain span are idle.
  */
 static inline int nohz_kick_needed(struct rq *rq, int cpu)
 {
 	unsigned long now = jiffies;
-	int ret;
-	int first_pick_cpu, second_pick_cpu;
 	struct sched_domain *sd;
 
+	if (unlikely(idle_cpu(cpu)))
+		return 0;
+
 	/*
 	 * We were recently in tickless idle mode. At the first busy tick
 	 * after returning from idle, we will update the busy stats.
@@ -5120,36 +5047,43 @@ static inline int nohz_kick_needed(struc
 	if (unlikely(test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))) {
 		clear_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
 
+		cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
+		atomic_dec(&nohz.nr_cpus);
+
 		for_each_domain(cpu, sd)
 			atomic_inc(&sd->groups->sgp->nr_busy_cpus);
 	}
 
-	if (time_before(now, nohz.next_balance))
+	/*
+	 * None are in tickless mode and hence no need for NOHZ idle load
+	 * balancing.
+	 */
+	if (likely(!atomic_read(&nohz.nr_cpus)))
 		return 0;
 
-	if (idle_cpu(cpu))
+	if (time_before(now, nohz.next_balance))
 		return 0;
 
-	first_pick_cpu = atomic_read(&nohz.first_pick_cpu);
-	second_pick_cpu = atomic_read(&nohz.second_pick_cpu);
-
-	if (first_pick_cpu < nr_cpu_ids && first_pick_cpu != cpu &&
-	    second_pick_cpu < nr_cpu_ids && second_pick_cpu != cpu)
-		return 0;
+	if (rq->nr_running >= 2)
+		goto need_kick;
 
-	ret = atomic_cmpxchg(&nohz.first_pick_cpu, nr_cpu_ids, cpu);
-	if (ret == nr_cpu_ids || ret == cpu) {
-		atomic_cmpxchg(&nohz.second_pick_cpu, cpu, nr_cpu_ids);
-		if (rq->nr_running > 1)
-			return 1;
-	} else {
-		ret = atomic_cmpxchg(&nohz.second_pick_cpu, nr_cpu_ids, cpu);
-		if (ret == nr_cpu_ids || ret == cpu) {
-			if (rq->nr_running)
-				return 1;
-		}
+	for_each_domain(cpu, sd) {
+		struct sched_group *sg = sd->groups;
+		struct sched_group_power *sgp = sg->sgp;
+		int nr_busy = atomic_read(&sgp->nr_busy_cpus);
+
+		if (nr_busy > 1 && (nr_busy * SCHED_LOAD_SCALE > sgp->power))
+			goto need_kick;
+
+		if (sd->flags & SD_ASYM_PACKING && nr_busy != sg->group_weight
+		    && (cpumask_first_and(nohz.idle_cpus_mask,
+					  sched_domain_span(sd)) < cpu))
+			goto need_kick;
 	}
+
 	return 0;
+need_kick:
+	return 1;
 }
 #else
 static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle) { }
@@ -5610,9 +5544,6 @@ __init void init_sched_fair_class(void)
 #ifdef CONFIG_NO_HZ
 	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
 	alloc_cpumask_var(&nohz.grp_idle_mask, GFP_NOWAIT);
-	atomic_set(&nohz.load_balancer, nr_cpu_ids);
-	atomic_set(&nohz.first_pick_cpu, nr_cpu_ids);
-	atomic_set(&nohz.second_pick_cpu, nr_cpu_ids);
 #endif
 #endif /* SMP */
 


