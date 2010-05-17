Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab0EQTCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:02:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:7101 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755668Ab0EQTCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:02:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,248,1272870000"; 
   d="scan'208";a="278095805"
Message-Id: <20100517184027.862696498@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 17 May 2010 11:27:30 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.jf.intel.com>
Cc: Venkatesh Pallipadi <venki@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, ego@in.ibm.com,
       LKML <linux-kernel@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 4/7] sched: Change nohz ilb logic from pull to push model
References: <20100517182726.089700767@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=sched-nohz-ilb-logic-from-pull-to-push.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Venkatesh Pallipadi <venki@google.com>
Subject: sched: Change nohz ilb logic from pull to push model

In the new push model, all idle CPUs indeed go into nohz mode. There is
still the concept of idle load balancer. Busy CPU kicks the nohz
balancer when any of the nohz CPUs need idle load balancing.
The kickee CPU does the idle load balancing on behalf of all idle CPUs
instead of the normal idle balance.

This addresses the below two problems with the current nohz ilb logic:
* the balancer will continue to have periodic ticks and wakeup
  frequently, even though it may not have any rebalancing to do on
  behalf of any of the idle CPUs.
* On x86 and CPUs that have APIC timer stoppage on idle CPUs, this
  periodic wakeup can result in an additional interrupt on a CPU
  doing the timer broadcast.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 kernel/sched.c      |   13 +-
 kernel/sched_fair.c |  283 ++++++++++++++++++++++++++++++----------------------
 2 files changed, 177 insertions(+), 119 deletions(-)

Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -3081,10 +3081,26 @@ out_unlock:
 }
 
 #ifdef CONFIG_NO_HZ
+
+static DEFINE_PER_CPU(struct call_single_data, remote_sched_softirq_cb);
+
+/*
+ * idle load balancing details
+ * - One of the idle CPUs nominates itself as idle load_balancer, while
+ *   entering idle.
+ * - This idle load balancer CPU will also go into tickless mode when
+ *   it is idle, just like all other idle CPUs
+ * - When one of the busy CPUs notice that there may be an idle rebalancing
+ *   needed, they will kick the idle load balancer, which then does idle
+ *   load balancing for all the idle CPUs.
+ */
 static struct {
 	atomic_t load_balancer;
-	cpumask_var_t cpu_mask;
-	cpumask_var_t ilb_grp_nohz_mask;
+	atomic_t first_pick_cpu;
+	atomic_t second_pick_cpu;
+	cpumask_var_t idle_cpus_mask;
+	cpumask_var_t grp_idle_mask;
+	unsigned long next_balance;     /* in jiffy units */
 } nohz ____cacheline_aligned = {
 	.load_balancer = ATOMIC_INIT(-1),
 };
@@ -3141,17 +3157,17 @@ static inline struct sched_domain *lowes
  */
 static inline int is_semi_idle_group(struct sched_group *ilb_group)
 {
-	cpumask_and(nohz.ilb_grp_nohz_mask, nohz.cpu_mask,
+	cpumask_and(nohz.grp_idle_mask, nohz.idle_cpus_mask,
 					sched_group_cpus(ilb_group));
 
 	/*
 	 * A sched_group is semi-idle when it has atleast one busy cpu
 	 * and atleast one idle cpu.
 	 */
-	if (cpumask_empty(nohz.ilb_grp_nohz_mask))
+	if (cpumask_empty(nohz.grp_idle_mask))
 		return 0;
 
-	if (cpumask_equal(nohz.ilb_grp_nohz_mask, sched_group_cpus(ilb_group)))
+	if (cpumask_equal(nohz.grp_idle_mask, sched_group_cpus(ilb_group)))
 		return 0;
 
 	return 1;
@@ -3184,7 +3200,7 @@ static int find_new_ilb(int cpu)
 	 * Optimize for the case when we have no idle CPUs or only one
 	 * idle CPU. Don't walk the sched_domain hierarchy in such cases
 	 */
-	if (cpumask_weight(nohz.cpu_mask) < 2)
+	if (cpumask_weight(nohz.idle_cpus_mask) < 2)
 		goto out_done;
 
 	for_each_flag_domain(cpu, sd, SD_POWERSAVINGS_BALANCE) {
@@ -3192,7 +3208,7 @@ static int find_new_ilb(int cpu)
 
 		do {
 			if (is_semi_idle_group(ilb_group))
-				return cpumask_first(nohz.ilb_grp_nohz_mask);
+				return cpumask_first(nohz.grp_idle_mask);
 
 			ilb_group = ilb_group->next;
 
@@ -3200,42 +3216,61 @@ static int find_new_ilb(int cpu)
 	}
 
 out_done:
-	return cpumask_first(nohz.cpu_mask);
+	return nr_cpu_ids;
 }
 #else /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
 static inline int find_new_ilb(int call_cpu)
 {
-	return cpumask_first(nohz.cpu_mask);
+	return nr_cpu_ids;
 }
 #endif
 
 /*
+ * Kick a CPU to do the nohz balancing, if it is time for it. We pick the
+ * nohz_load_balancer CPU (if there is one) otherwise fallback to any idle
+ * CPU (if there is one).
+ */
+static void nohz_balancer_kick(int cpu)
+{
+	int ilb_cpu;
+
+	nohz.next_balance++;
+
+	ilb_cpu = get_nohz_load_balancer();
+	if (ilb_cpu < 0) {
+		ilb_cpu = cpumask_first(nohz.idle_cpus_mask);
+		if (ilb_cpu >= nr_cpu_ids)
+			return;
+	}
+
+	if (!cpu_rq(ilb_cpu)->nohz_balance_kick) {
+		struct call_single_data *cp;
+
+		cpu_rq(ilb_cpu)->nohz_balance_kick = 1;
+		cp = &per_cpu(remote_sched_softirq_cb, cpu);
+		send_remote_softirq(cp, ilb_cpu, 0);
+	}
+	return;
+}
+
+/*
  * This routine will try to nominate the ilb (idle load balancing)
  * owner among the cpus whose ticks are stopped. ilb owner will do the idle
- * load balancing on behalf of all those cpus. If all the cpus in the system
- * go into this tickless mode, then there will be no ilb owner (as there is
- * no need for one) and all the cpus will sleep till the next wakeup event
- * arrives...
- *
- * For the ilb owner, tick is not stopped. And this tick will be used
- * for idle load balancing. ilb owner will still be part of
- * nohz.cpu_mask..
+ * load balancing on behalf of all those cpus.
  *
- * While stopping the tick, this cpu will become the ilb owner if there
- * is no other owner. And will be the owner till that cpu becomes busy
- * or if all cpus in the system stop their ticks at which point
- * there is no need for ilb owner.
- *
- * When the ilb owner becomes busy, it nominates another owner, during the
- * next busy scheduler_tick()
+ * When the ilb owner becomes busy, we will not have new ilb owner until some
+ * idle CPU wakes up and goes back to idle or some busy CPU tries to kick
+ * idle load balancing by kicking one of the idle CPUs.
+ *
+ * Ticks are stopped for the ilb owner as well, with busy CPU kicking this
+ * ilb owner CPU in future (when there is a need for idle load balancing on
+ * behalf of all idle CPUs).
  */
 int select_nohz_load_balancer(int stop_tick)
 {
 	int cpu = smp_processor_id();
 
 	if (stop_tick) {
-		cpu_rq(cpu)->in_nohz_recently = 1;
-
 		if (!cpu_active(cpu)) {
 			if (atomic_read(&nohz.load_balancer) != cpu)
 				return 0;
@@ -3250,25 +3285,20 @@ int select_nohz_load_balancer(int stop_t
 			return 0;
 		}
 
-		cpumask_set_cpu(cpu, nohz.cpu_mask);
+		cpumask_set_cpu(cpu, nohz.idle_cpus_mask);
 
-		/* time for ilb owner also to sleep */
-		if (cpumask_weight(nohz.cpu_mask) == num_active_cpus()) {
-			if (atomic_read(&nohz.load_balancer) == cpu)
-				atomic_set(&nohz.load_balancer, -1);
-			return 0;
-		}
+		if (atomic_read(&nohz.first_pick_cpu) == cpu)
+			atomic_cmpxchg(&nohz.first_pick_cpu, cpu, nr_cpu_ids);
+		if (atomic_read(&nohz.second_pick_cpu) == cpu)
+			atomic_cmpxchg(&nohz.second_pick_cpu, cpu, nr_cpu_ids);
 
 		if (atomic_read(&nohz.load_balancer) == -1) {
-			/* make me the ilb owner */
-			if (atomic_cmpxchg(&nohz.load_balancer, -1, cpu) == -1)
-				return 1;
-		} else if (atomic_read(&nohz.load_balancer) == cpu) {
 			int new_ilb;
 
-			if (!(sched_smt_power_savings ||
-						sched_mc_power_savings))
-				return 1;
+			/* make me the ilb owner */
+			if (atomic_cmpxchg(&nohz.load_balancer, -1, cpu) != -1)
+				return 0;
+
 			/*
 			 * Check to see if there is a more power-efficient
 			 * ilb.
@@ -3279,13 +3309,13 @@ int select_nohz_load_balancer(int stop_t
 				resched_cpu(new_ilb);
 				return 0;
 			}
-			return 1;
+			return 0;
 		}
 	} else {
-		if (!cpumask_test_cpu(cpu, nohz.cpu_mask))
+		if (!cpumask_test_cpu(cpu, nohz.idle_cpus_mask))
 			return 0;
 
-		cpumask_clear_cpu(cpu, nohz.cpu_mask);
+		cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
 
 		if (atomic_read(&nohz.load_balancer) == cpu)
 			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
@@ -3373,11 +3403,97 @@ out:
 		rq->next_balance = next_balance;
 }
 
+#ifdef CONFIG_NO_HZ
 /*
- * run_rebalance_domains is triggered when needed from the scheduler tick.
- * In CONFIG_NO_HZ case, the idle load balance owner will do the
+ * In CONFIG_NO_HZ case, the idle balance kickee will do the
  * rebalancing for all the cpus for whom scheduler ticks are stopped.
  */
+static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
+{
+	struct rq *this_rq = cpu_rq(this_cpu);
+	struct rq *rq;
+	int balance_cpu;
+
+	if (idle != CPU_IDLE || !this_rq->nohz_balance_kick)
+		return;
+
+	for_each_cpu(balance_cpu, nohz.idle_cpus_mask) {
+		if (balance_cpu == this_cpu)
+			continue;
+
+		/*
+		 * If this cpu gets work to do, stop the load balancing
+		 * work being done for other cpus. Next load
+		 * balancing owner will pick it up.
+		 */
+		if (need_resched()) {
+			this_rq->nohz_balance_kick = 0;
+			break;
+		}
+
+		rebalance_domains(balance_cpu, CPU_IDLE);
+
+		rq = cpu_rq(balance_cpu);
+		if (time_after(this_rq->next_balance, rq->next_balance))
+			this_rq->next_balance = rq->next_balance;
+	}
+	nohz.next_balance = this_rq->next_balance;
+	this_rq->nohz_balance_kick = 0;
+}
+
+/*
+ * Current heuristic for kicking the idle load balancer
+ * - first_pick_cpu is the one of the busy CPUs. It will kick
+ *   idle load balancer when it has more than one process active. This
+ *   eliminates the need for idle load balancing altogether when we have
+ *   only one running process in the system (common case).
+ * - If there are more than one busy CPU, idle load balancer may have
+ *   to run for active_load_balance to happen (i.e., two busy CPUs are
+ *   SMT or core siblings and can run better if they move to different
+ *   physical CPUs). So, second_pick_cpu is the second of the busy CPUs
+ *   which will kick idle load balancer as soon as it has any load.
+ */
+static inline int nohz_kick_needed(struct rq *rq, int cpu)
+{
+	unsigned long now = jiffies;
+	int ret;
+	int first_pick_cpu, second_pick_cpu;
+
+	if (time_before(now, nohz.next_balance))
+		return 0;
+
+	if (!rq->nr_running)
+		return 0;
+
+	first_pick_cpu = atomic_read(&nohz.first_pick_cpu);
+	second_pick_cpu = atomic_read(&nohz.second_pick_cpu);
+
+	if (first_pick_cpu < nr_cpu_ids && first_pick_cpu != cpu &&
+	    second_pick_cpu < nr_cpu_ids && second_pick_cpu != cpu)
+		return 0;
+
+	ret = atomic_cmpxchg(&nohz.first_pick_cpu, nr_cpu_ids, cpu);
+	if (ret == nr_cpu_ids || ret == cpu) {
+		atomic_cmpxchg(&nohz.second_pick_cpu, cpu, nr_cpu_ids);
+		if (rq->nr_running > 1)
+			return 1;
+	} else {
+		ret = atomic_cmpxchg(&nohz.second_pick_cpu, nr_cpu_ids, cpu);
+		if (ret == nr_cpu_ids || ret == cpu) {
+			if (rq->nr_running)
+				return 1;
+		}
+	}
+	return 0;
+}
+#else
+static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle) { }
+#endif
+
+/*
+ * run_rebalance_domains is triggered when needed from the scheduler tick.
+ * Also triggered for nohz idle balancing (with nohz_balancing_kick set).
+ */
 static void run_rebalance_domains(struct softirq_action *h)
 {
 	int this_cpu = smp_processor_id();
@@ -3387,37 +3503,12 @@ static void run_rebalance_domains(struct
 
 	rebalance_domains(this_cpu, idle);
 
-#ifdef CONFIG_NO_HZ
 	/*
-	 * If this cpu is the owner for idle load balancing, then do the
+	 * If this cpu has a pending nohz_balance_kick, then do the
 	 * balancing on behalf of the other idle cpus whose ticks are
 	 * stopped.
 	 */
-	if (this_rq->idle_at_tick &&
-	    atomic_read(&nohz.load_balancer) == this_cpu) {
-		struct rq *rq;
-		int balance_cpu;
-
-		for_each_cpu(balance_cpu, nohz.cpu_mask) {
-			if (balance_cpu == this_cpu)
-				continue;
-
-			/*
-			 * If this cpu gets work to do, stop the load balancing
-			 * work being done for other cpus. Next load
-			 * balancing owner will pick it up.
-			 */
-			if (need_resched())
-				break;
-
-			rebalance_domains(balance_cpu, CPU_IDLE);
-
-			rq = cpu_rq(balance_cpu);
-			if (time_after(this_rq->next_balance, rq->next_balance))
-				this_rq->next_balance = rq->next_balance;
-		}
-	}
-#endif
+	nohz_idle_balance(this_cpu, idle);
 }
 
 static inline int on_null_domain(int cpu)
@@ -3427,57 +3518,17 @@ static inline int on_null_domain(int cpu
 
 /*
  * Trigger the SCHED_SOFTIRQ if it is time to do periodic load balancing.
- *
- * In case of CONFIG_NO_HZ, this is the place where we nominate a new
- * idle load balancing owner or decide to stop the periodic load balancing,
- * if the whole system is idle.
  */
 static inline void trigger_load_balance(struct rq *rq, int cpu)
 {
-#ifdef CONFIG_NO_HZ
-	/*
-	 * If we were in the nohz mode recently and busy at the current
-	 * scheduler tick, then check if we need to nominate new idle
-	 * load balancer.
-	 */
-	if (rq->in_nohz_recently && !rq->idle_at_tick) {
-		rq->in_nohz_recently = 0;
-
-		if (atomic_read(&nohz.load_balancer) == cpu) {
-			cpumask_clear_cpu(cpu, nohz.cpu_mask);
-			atomic_set(&nohz.load_balancer, -1);
-		}
-
-		if (atomic_read(&nohz.load_balancer) == -1) {
-			int ilb = find_new_ilb(cpu);
-
-			if (ilb < nr_cpu_ids)
-				resched_cpu(ilb);
-		}
-	}
-
-	/*
-	 * If this cpu is idle and doing idle load balancing for all the
-	 * cpus with ticks stopped, is it time for that to stop?
-	 */
-	if (rq->idle_at_tick && atomic_read(&nohz.load_balancer) == cpu &&
-	    cpumask_weight(nohz.cpu_mask) == num_online_cpus()) {
-		resched_cpu(cpu);
-		return;
-	}
-
-	/*
-	 * If this cpu is idle and the idle load balancing is done by
-	 * someone else, then no need raise the SCHED_SOFTIRQ
-	 */
-	if (rq->idle_at_tick && atomic_read(&nohz.load_balancer) != cpu &&
-	    cpumask_test_cpu(cpu, nohz.cpu_mask))
-		return;
-#endif
 	/* Don't need to rebalance while attached to NULL domain */
 	if (time_after_eq(jiffies, rq->next_balance) &&
 	    likely(!on_null_domain(cpu)))
 		raise_softirq(SCHED_SOFTIRQ);
+#ifdef CONFIG_NO_HZ
+	else if (nohz_kick_needed(rq, cpu) && likely(!on_null_domain(cpu)))
+		nohz_balancer_kick(cpu);
+#endif
 }
 
 static void rq_online_fair(struct rq *rq)
Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -504,7 +504,7 @@ struct rq {
 	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
 #ifdef CONFIG_NO_HZ
 	u64 nohz_stamp;
-	unsigned char in_nohz_recently;
+	unsigned char nohz_balance_kick;
 #endif
 	unsigned int skip_clock_update;
 
@@ -7605,6 +7605,11 @@ void __init sched_init(void)
 		rq->idle_stamp = 0;
 		rq->avg_idle = 2*sysctl_sched_migration_cost;
 		rq_attach_root(rq, &def_root_domain);
+#ifdef CONFIG_NO_HZ
+		rq->nohz_balance_kick = 0;
+		init_remote_softirq_csd(&per_cpu(remote_sched_softirq_cb, i),
+					SCHED_SOFTIRQ);
+#endif
 #endif
 		init_rq_hrtick(rq);
 		atomic_set(&rq->nr_iowait, 0);
@@ -7649,8 +7654,10 @@ void __init sched_init(void)
 	zalloc_cpumask_var(&nohz_cpu_mask, GFP_NOWAIT);
 #ifdef CONFIG_SMP
 #ifdef CONFIG_NO_HZ
-	zalloc_cpumask_var(&nohz.cpu_mask, GFP_NOWAIT);
-	alloc_cpumask_var(&nohz.ilb_grp_nohz_mask, GFP_NOWAIT);
+	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
+	alloc_cpumask_var(&nohz.grp_idle_mask, GFP_NOWAIT);
+	atomic_set(&nohz.first_pick_cpu, nr_cpu_ids);
+	atomic_set(&nohz.second_pick_cpu, nr_cpu_ids);
 #endif
 	/* May be allocated at isolcpus cmdline parse time */
 	if (cpu_isolated_map == NULL)


