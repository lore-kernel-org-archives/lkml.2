Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab1KAXuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 19:50:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:48112 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755991Ab1KAXt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 19:49:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,440,1315206000"; 
   d="scan'208";a="85010459"
Subject: Re: [Patch] Idle balancer: cache align nohz structure to improve
 idle load balancing scalability
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Venki Pallipadi <venki@google.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Tim Chen <tim.c.chen@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 01 Nov 2011 16:52:38 -0700
In-Reply-To: <4FF5AC937153B0459463C1A88EB478F20135D6ECB5@orsmsx505.amr.corp.intel.com>
References: <1319060737.2604.38.camel@schen9-DESK>
	 <m2wrc0xpbg.fsf@firstfloor.org>
	 <CABeCy1a20npBt=4ee38zLH+6Fi7nfASd0dL3od6pOccV=LJDkA@mail.gmail.com>
	 <4FF5AC937153B0459463C1A88EB478F20135D6ECB5@orsmsx505.amr.corp.intel.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1320191558.28097.44.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-20 at 10:31 -0700, Suresh Siddha wrote:
> On Thu, 2011-10-20 at 05:26 -0700, Venki Pallipadi wrote:
> > An alternate approach is to split this struct per node/socket and do
> > the nohz idle balancing logic at that level. That should be more
> > scalable in terms of nohz balancing (ensure one CPU wont be doing nohz
> > balancing for huge number of idle CPUs). I had looked at that approach
> > couple of years earlier and couldn't measure that much of a gain. May
> > be it is time to revisit that with increased core count.

On Thu, 2011-10-20 at 10:38 -0700, Peter Zijlstra wrote:
> Yeah, that would be best, although I remember there was a problem with
> your approach back then, a fully idle node would not balance at all or
> something like that.

That is correct. So to minimize the global updates I did two things.

1. Track nr of busy cpus in each scheduler group for each scheduler
domain.

2. delay the update of nohz.idle_cpus_mask (And to the above mentioned
new sched group specific busy stat)  when coming out of idle to the
first busy tick. And added idle_cpu() checks at couple of places in idle
load balancing code to ensure that the cpu is really idle.

The kicked cpu will still do the idle load balancing on behalf of all
the cpu's. We are kicking only when it is really needed.

If we add more smarts then we can split this also into multiple idle
load balances in the future or kick the active load balance directly for
the HT/MC cases where we want to spread busy cores/threads. This is open
for future though.

> 
> I am actually looking at it. This is a quick fix for the meantime.
> 
> Even with this cacheline aligned, the first_pick_cpu and second_pick_cpu
> cacheline bouncing is still causing ~8% more performance impact on this
> synthetic lat_ctx heavy workload. For this experiment to measure the
> potential scope we have here, We left the cacheline bouncing associated
> with the  nohz.idle_cpus_mask update in place.

Appended patch helped improve that workload by 100%. We haven't
completed the testing of this patch but thought of getting quick
feedback. Also I may have to split this into multiple patches (removing
of nohz_stamp etc are not related). Thanks.
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: RFC: sched, nohz: sched group, domain aware nohz idle load balancing 

Make nohz idle load balancing more scalabale by making it aware of sched group/
sched domains.

Introduce nr_busy_cpus in the struct sched_group_power [Not in sched_group
because sched groups are duplicated for the SD_OVERLAP scheduler domain]
and for each cpu that enters and exits tickless, this parameter will
be updated in each scheduler group of the scheduler domain that this cpu
belongs to.

To avoid the frequent update of this tickless state (global nohz data aswell
as some what local nr_busy_cpus in the sched_group's) when the cpu enters
and exits tickless idle often, the update of the exit state is delayed
to the first timer tick that happens after the cpu becomes busy.

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
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

 include/linux/sched.h |    4 +
 kernel/sched.c        |   27 +++--
 kernel/sched_fair.c   |  264 ++++++++++++++++++-------------------------------
 3 files changed, 116 insertions(+), 179 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9c7a7a4..61e9980 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -901,6 +901,10 @@ struct sched_group_power {
 	 * single CPU.
 	 */
 	unsigned int power, power_orig;
+	/*
+	 * Number of busy cpus in this group.
+	 */
+	atomic_t nr_busy_cpus;
 };
 
 struct sched_group {
diff --git a/kernel/sched.c b/kernel/sched.c
index cf7f696..a8da213 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -600,8 +600,7 @@ struct rq {
 	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
 	unsigned long last_load_update_tick;
 #ifdef CONFIG_NO_HZ
-	u64 nohz_stamp;
-	unsigned char nohz_balance_kick;
+	unsigned int tick_stopped:1;
 #endif
 	int skip_clock_update;
 
@@ -1337,6 +1336,20 @@ static void resched_cpu(int cpu)
 }
 
 #ifdef CONFIG_NO_HZ
+#define NOHZ_BALANCE_KICK	0
+#define NOHZ_NEED_BALANCING	1
+/*
+ * idle load balancing details
+ * - When one of the busy CPUs notice that there may be an idle rebalancing
+ *   needed, they will kick the idle load balancer, which then does idle
+ *   load balancing for all the idle CPUs.
+ */
+static struct {
+	cpumask_var_t idle_cpus_mask;
+	unsigned long next_balance;     /* in jiffy units */
+	unsigned long bits;
+} nohz ____cacheline_aligned;
+
 /*
  * In the semi idle case, use the nearest busy cpu for migrating timers
  * from an idle cpu.  This is good for power-savings.
@@ -1406,7 +1419,8 @@ void wake_up_idle_cpu(int cpu)
 
 static inline bool got_nohz_idle_kick(void)
 {
-	return idle_cpu(smp_processor_id()) && this_rq()->nohz_balance_kick;
+	return idle_cpu(smp_processor_id()) &&
+	       test_bit(NOHZ_BALANCE_KICK, &nohz.bits);
 }
 
 #else /* CONFIG_NO_HZ */
@@ -8297,9 +8311,6 @@ void __init sched_init(void)
 		rq->idle_stamp = 0;
 		rq->avg_idle = 2*sysctl_sched_migration_cost;
 		rq_attach_root(rq, &def_root_domain);
-#ifdef CONFIG_NO_HZ
-		rq->nohz_balance_kick = 0;
-#endif
 #endif
 		init_rq_hrtick(rq);
 		atomic_set(&rq->nr_iowait, 0);
@@ -8344,10 +8355,6 @@ void __init sched_init(void)
 	zalloc_cpumask_var(&sched_domains_tmpmask, GFP_NOWAIT);
 #ifdef CONFIG_NO_HZ
 	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
-	alloc_cpumask_var(&nohz.grp_idle_mask, GFP_NOWAIT);
-	atomic_set(&nohz.load_balancer, nr_cpu_ids);
-	atomic_set(&nohz.first_pick_cpu, nr_cpu_ids);
-	atomic_set(&nohz.second_pick_cpu, nr_cpu_ids);
 #endif
 	/* May be allocated at isolcpus cmdline parse time */
 	if (cpu_isolated_map == NULL)
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5c9e679..d18a1de 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3317,6 +3317,7 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
 
 	cpu_rq(cpu)->cpu_power = power;
 	sdg->sgp->power = power;
+	atomic_set(&sdg->sgp->nr_busy_cpus, sdg->group_weight);
 }
 
 static void update_group_power(struct sched_domain *sd, int cpu)
@@ -3339,6 +3340,7 @@ static void update_group_power(struct sched_domain *sd, int cpu)
 	} while (group != child->groups);
 
 	sdg->sgp->power = power;
+	atomic_set(&sdg->sgp->nr_busy_cpus, sdg->group_weight);
 }
 
 /*
@@ -4269,30 +4271,6 @@ out_unlock:
 }
 
 #ifdef CONFIG_NO_HZ
-/*
- * idle load balancing details
- * - One of the idle CPUs nominates itself as idle load_balancer, while
- *   entering idle.
- * - This idle load balancer CPU will also go into tickless mode when
- *   it is idle, just like all other idle CPUs
- * - When one of the busy CPUs notice that there may be an idle rebalancing
- *   needed, they will kick the idle load balancer, which then does idle
- *   load balancing for all the idle CPUs.
- */
-static struct {
-	atomic_t load_balancer;
-	atomic_t first_pick_cpu;
-	atomic_t second_pick_cpu;
-	cpumask_var_t idle_cpus_mask;
-	cpumask_var_t grp_idle_mask;
-	unsigned long next_balance;     /* in jiffy units */
-} nohz ____cacheline_aligned;
-
-int get_nohz_load_balancer(void)
-{
-	return atomic_read(&nohz.load_balancer);
-}
-
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
 /**
  * lowest_flag_domain - Return lowest sched_domain containing flag.
@@ -4329,33 +4307,6 @@ static inline struct sched_domain *lowest_flag_domain(int cpu, int flag)
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
@@ -4369,9 +4320,9 @@ static inline int is_semi_idle_group(struct sched_group *ilb_group)
  */
 static int find_new_ilb(int cpu)
 {
+	int ilb = cpumask_first(nohz.idle_cpus_mask);
+	struct sched_group *ilbg;
 	struct sched_domain *sd;
-	struct sched_group *ilb_group;
-	int ilb = nr_cpu_ids;
 
 	/*
 	 * Have idle load balancer selection from semi-idle packages only
@@ -4389,23 +4340,28 @@ static int find_new_ilb(int cpu)
 
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
@@ -4423,102 +4379,52 @@ static void nohz_balancer_kick(int cpu)
 {
 	int ilb_cpu;
 
-	nohz.next_balance++;
-
-	ilb_cpu = get_nohz_load_balancer();
+	ilb_cpu = find_new_ilb(cpu);
 
 	if (ilb_cpu >= nr_cpu_ids) {
-		ilb_cpu = cpumask_first(nohz.idle_cpus_mask);
-		if (ilb_cpu >= nr_cpu_ids)
-			return;
+		clear_bit(NOHZ_BALANCE_KICK, &nohz.bits);
+		return;
 	}
 
-	if (!cpu_rq(ilb_cpu)->nohz_balance_kick) {
-		cpu_rq(ilb_cpu)->nohz_balance_kick = 1;
-
-		smp_mb();
-		/*
-		 * Use smp_send_reschedule() instead of resched_cpu().
-		 * This way we generate a sched IPI on the target cpu which
-		 * is idle. And the softirq performing nohz idle load balance
-		 * will be run before returning from the IPI.
-		 */
-		smp_send_reschedule(ilb_cpu);
-	}
+	/*
+	 * Use smp_send_reschedule() instead of resched_cpu().
+	 * This way we generate a sched IPI on the target cpu which
+	 * is idle. And the softirq performing nohz idle load balance
+	 * will be run before returning from the IPI.
+	 */
+	smp_send_reschedule(ilb_cpu);
 	return;
 }
 
-/*
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
- */
 void select_nohz_load_balancer(int stop_tick)
 {
 	int cpu = smp_processor_id();
+	struct sched_domain *sd;
 
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
+		if (this_rq()->tick_stopped)
 			return;
-		}
-
 		cpumask_set_cpu(cpu, nohz.idle_cpus_mask);
 
-		if (atomic_read(&nohz.first_pick_cpu) == cpu)
-			atomic_cmpxchg(&nohz.first_pick_cpu, cpu, nr_cpu_ids);
-		if (atomic_read(&nohz.second_pick_cpu) == cpu)
-			atomic_cmpxchg(&nohz.second_pick_cpu, cpu, nr_cpu_ids);
-
-		if (atomic_read(&nohz.load_balancer) >= nr_cpu_ids) {
-			int new_ilb;
+		this_rq()->tick_stopped = 1;
 
-			/* make me the ilb owner */
-			if (atomic_cmpxchg(&nohz.load_balancer, nr_cpu_ids,
-					   cpu) != nr_cpu_ids)
-				return;
+		/*
+		 * Indicate the idle state to all the scheduler groups that
+		 * this cpu is part of.
+		 */
+		for_each_domain(cpu, sd)
+			atomic_dec(&sd->groups->sgp->nr_busy_cpus);
 
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
-	} else {
-		if (!cpumask_test_cpu(cpu, nohz.idle_cpus_mask))
+		if (test_bit(NOHZ_NEED_BALANCING, &nohz.bits))
 			return;
 
-		cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
-
-		if (atomic_read(&nohz.load_balancer) == cpu)
-			if (atomic_cmpxchg(&nohz.load_balancer, cpu,
-					   nr_cpu_ids) != cpu)
-				BUG();
+		/*
+		 * Indicate that there is atleast one cpu in tickless mode
+		 * and hence the possible need for NOHZ idle load balancing.
+		 */
+		set_bit(NOHZ_NEED_BALANCING, &nohz.bits);
 	}
+
 	return;
 }
 #endif
@@ -4623,11 +4529,11 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
 	struct rq *rq;
 	int balance_cpu;
 
-	if (idle != CPU_IDLE || !this_rq->nohz_balance_kick)
+	if (idle != CPU_IDLE || !(test_bit(NOHZ_BALANCE_KICK, &nohz.bits)))
 		return;
 
 	for_each_cpu(balance_cpu, nohz.idle_cpus_mask) {
-		if (balance_cpu == this_cpu)
+		if (balance_cpu == this_cpu || !idle_cpu(balance_cpu))
 			continue;
 
 		/*
@@ -4636,7 +4542,7 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
 		 * balancing owner will pick it up.
 		 */
 		if (need_resched()) {
-			this_rq->nohz_balance_kick = 0;
+			clear_bit(NOHZ_BALANCE_KICK, &nohz.bits);
 			break;
 		}
 
@@ -4652,53 +4558,73 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
 			this_rq->next_balance = rq->next_balance;
 	}
 	nohz.next_balance = this_rq->next_balance;
-	this_rq->nohz_balance_kick = 0;
+	clear_bit(NOHZ_BALANCE_KICK, &nohz.bits);
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
+ * - This rq has more than one task.
+ * - At any scheduler domain level, this cpu's scheduler group has multiple
+ *   busy cpu's exceeding the group's power.
+ * - For SD_ASYM_PACKING, if the lower numbered cpu's in the scheduler
+ *   domain span are idle.
  */
 static inline int nohz_kick_needed(struct rq *rq, int cpu)
 {
 	unsigned long now = jiffies;
-	int ret;
-	int first_pick_cpu, second_pick_cpu;
-
-	if (time_before(now, nohz.next_balance))
-		return 0;
+	struct sched_domain *sd;
 
 	if (idle_cpu(cpu))
 		return 0;
 
-	first_pick_cpu = atomic_read(&nohz.first_pick_cpu);
-	second_pick_cpu = atomic_read(&nohz.second_pick_cpu);
+	/*
+	 * We were recently in tickless idle mode. We will do the delayed
+	 * update of busy mode now (first busy tick after returning from idle).
+	 */
+	if (unlikely(rq->tick_stopped)) {
+		cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
+
+		if (cpumask_bits(nohz.idle_cpus_mask)[BIT_WORD(cpu)] == 0 &&
+		    cpumask_empty(nohz.idle_cpus_mask))
+			clear_bit(NOHZ_NEED_BALANCING, &nohz.bits);
+
+		rq->tick_stopped = 0;
+		for_each_domain(cpu, sd)
+			atomic_inc(&sd->groups->sgp->nr_busy_cpus);
+	}
 
-	if (first_pick_cpu < nr_cpu_ids && first_pick_cpu != cpu &&
-	    second_pick_cpu < nr_cpu_ids && second_pick_cpu != cpu)
+	if (likely(!test_bit(NOHZ_NEED_BALANCING, &nohz.bits)))
 		return 0;
 
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
+	if (rq->nr_running >= 2)
+		goto need_kick;
+
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
+
+need_kick:
+	if (time_before(now, nohz.next_balance) ||
+	    test_bit(NOHZ_BALANCE_KICK, &nohz.bits))
+		return 0;
+
+	if (test_and_set_bit(NOHZ_BALANCE_KICK, &nohz.bits))
+		return 0;
+
+	return 1;
 }
 #else
 static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle) { }


