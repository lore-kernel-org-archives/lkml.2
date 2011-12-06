Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172Ab1LFJzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:55:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34975 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932955Ab1LFJzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:55:17 -0500
Date: Tue, 6 Dec 2011 01:54:59 -0800
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-0b005cf54eac170a8f22540ab096a6e07bf49e7c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, tim.c.chen@intel.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, tim.c.chen@intel.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20111202010832.602203411@sbsiddha-desk.sc.intel.com>
References: <20111202010832.602203411@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, nohz: Implement sched group, domain aware nohz idle load balancing
Git-Commit-ID: 0b005cf54eac170a8f22540ab096a6e07bf49e7c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 01:55:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0b005cf54eac170a8f22540ab096a6e07bf49e7c
Gitweb:     http://git.kernel.org/tip/0b005cf54eac170a8f22540ab096a6e07bf49e7c
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Thu, 1 Dec 2011 17:07:34 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 09:06:34 +0100

sched, nohz: Implement sched group, domain aware nohz idle load balancing

When there are many logical cpu's that enter and exit idle often, members of
the global nohz data structure are getting modified very frequently causing
lot of cache-line contention.

Make the nohz idle load balancing more scalabale by using the sched domain
topology and 'nr_busy_cpu's in the struct sched_group_power.

Idle load balance is kicked on one of the idle cpu's when there is atleast
one idle cpu and:

 - a busy rq having more than one task or

 - a busy rq's scheduler group that share package resources (like HT/MC
   siblings) and has more than one member in that group busy or

 - for the SD_ASYM_PACKING domain, if the lower numbered cpu's in that
   domain are idle compared to the busy ones.

This will help in kicking the idle load balancing request only when
there is a potential imbalance. And once it is mostly balanced, these kicks will
be minimized.

These changes helped improve the workload that is context switch intensive
between number of task pairs by 2x on a 8 socket NHM-EX based system.

Reported-by: Tim Chen <tim.c.chen@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20111202010832.602203411@sbsiddha-desk.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/fair.c |  160 +++++++++++++++------------------------------------
 1 files changed, 47 insertions(+), 113 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e050563..821af14 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4727,28 +4727,17 @@ out_unlock:
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
@@ -4825,9 +4814,9 @@ static inline int is_semi_idle_group(struct sched_group *ilb_group)
  */
 static int find_new_ilb(int cpu)
 {
+	int ilb = cpumask_first(nohz.idle_cpus_mask);
 	struct sched_domain *sd;
 	struct sched_group *ilb_group;
-	int ilb = nr_cpu_ids;
 
 	/*
 	 * Have idle load balancer selection from semi-idle packages only
@@ -4881,13 +4870,10 @@ static void nohz_balancer_kick(int cpu)
 
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
@@ -4932,77 +4918,20 @@ void set_cpu_sd_state_idle(void)
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
 	int cpu = smp_processor_id();
 
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
@@ -5113,7 +5042,7 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
 		goto end;
 
 	for_each_cpu(balance_cpu, nohz.idle_cpus_mask) {
-		if (balance_cpu == this_cpu)
+		if (balance_cpu == this_cpu || !idle_cpu(this_cpu))
 			continue;
 
 		/*
@@ -5141,22 +5070,18 @@ end:
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
+ *   - This rq has more than one task.
+ *   - At any scheduler domain level, this cpu's scheduler group has multiple
+ *     busy cpu's exceeding the group's power.
+ *   - For SD_ASYM_PACKING, if the lower numbered cpu's in the scheduler
+ *     domain span are idle.
  */
 static inline int nohz_kick_needed(struct rq *rq, int cpu)
 {
 	unsigned long now = jiffies;
-	int ret;
-	int first_pick_cpu, second_pick_cpu;
+	struct sched_domain *sd;
 
 	if (unlikely(idle_cpu(cpu)))
 		return 0;
@@ -5166,32 +5091,44 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
 	* busy tick after returning from idle, we will update the busy stats.
 	*/
 	set_cpu_sd_state_busy();
-	if (unlikely(test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu))))
+	if (unlikely(test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))) {
 		clear_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
+		cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
+		atomic_dec(&nohz.nr_cpus);
+	}
+
+	/*
+	 * None are in tickless mode and hence no need for NOHZ idle load
+	 * balancing.
+	 */
+	if (likely(!atomic_read(&nohz.nr_cpus)))
+		return 0;
 
 	if (time_before(now, nohz.next_balance))
 		return 0;
 
-	first_pick_cpu = atomic_read(&nohz.first_pick_cpu);
-	second_pick_cpu = atomic_read(&nohz.second_pick_cpu);
+	if (rq->nr_running >= 2)
+		goto need_kick;
 
-	if (first_pick_cpu < nr_cpu_ids && first_pick_cpu != cpu &&
-	    second_pick_cpu < nr_cpu_ids && second_pick_cpu != cpu)
-		return 0;
+	for_each_domain(cpu, sd) {
+		struct sched_group *sg = sd->groups;
+		struct sched_group_power *sgp = sg->sgp;
+		int nr_busy = atomic_read(&sgp->nr_busy_cpus);
 
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
+		if (sd->flags & SD_SHARE_PKG_RESOURCES && nr_busy > 1)
+			goto need_kick;
+
+		if (sd->flags & SD_ASYM_PACKING && nr_busy != sg->group_weight
+		    && (cpumask_first_and(nohz.idle_cpus_mask,
+					  sched_domain_span(sd)) < cpu))
+			goto need_kick;
+
+		if (!(sd->flags & (SD_SHARE_PKG_RESOURCES | SD_ASYM_PACKING)))
+			break;
 	}
 	return 0;
+need_kick:
+	return 1;
 }
 #else
 static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle) { }
@@ -5652,9 +5589,6 @@ __init void init_sched_fair_class(void)
 #ifdef CONFIG_NO_HZ
 	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
 	alloc_cpumask_var(&nohz.grp_idle_mask, GFP_NOWAIT);
-	atomic_set(&nohz.load_balancer, nr_cpu_ids);
-	atomic_set(&nohz.first_pick_cpu, nr_cpu_ids);
-	atomic_set(&nohz.second_pick_cpu, nr_cpu_ids);
 #endif
 #endif /* SMP */
 
