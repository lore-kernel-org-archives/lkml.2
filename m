Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796Ab1KRXKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:10:19 -0500
Received: from mga14.intel.com ([143.182.124.37]:43923 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757187Ab1KRXKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:10:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,535,1315206000"; 
   d="scan'208";a="76848896"
Message-Id: <20111118230553.937264752@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 18 Nov 2011 15:03:25 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>, alex.shi@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/6] sched, nohz: track nr_busy_cpus in the sched_group_power
References: <20111118230323.592022417@sbsiddha-desk.sc.intel.com>
Content-Disposition: inline; filename=track_nr_busy_cpus_in_sched_group.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce nr_busy_cpus in the struct sched_group_power [Not in sched_group
because sched groups are duplicated for the SD_OVERLAP scheduler domain]
and for each cpu that enters and exits tickless, this parameter will
be updated in each scheduler group of the scheduler domain that this cpu
belongs to.

To avoid the frequent update of this state as the cpu enters
and exits tickless idle, the update of the stat during tickless exit is
delayed to the first timer tick that happens after the cpu becomes busy.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 include/linux/sched.h |    4 ++++
 kernel/sched/core.c   |    1 +
 kernel/sched/fair.c   |   18 +++++++++++++++++-
 3 files changed, 22 insertions(+), 1 deletion(-)

Index: tip/include/linux/sched.h
===================================================================
--- tip.orig/include/linux/sched.h
+++ tip/include/linux/sched.h
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
Index: tip/kernel/sched/core.c
===================================================================
--- tip.orig/kernel/sched/core.c
+++ tip/kernel/sched/core.c
@@ -6017,6 +6017,7 @@ static void init_sched_groups_power(int 
 		return;
 
 	update_group_power(sd, cpu);
+	atomic_set(&sg->sgp->nr_busy_cpus, sg->group_weight);
 }
 
 int __weak arch_sd_sibling_asym_packing(void)
Index: tip/kernel/sched/fair.c
===================================================================
--- tip.orig/kernel/sched/fair.c
+++ tip/kernel/sched/fair.c
@@ -4894,6 +4894,7 @@ static void nohz_balancer_kick(int cpu)
 void select_nohz_load_balancer(int stop_tick)
 {
 	int cpu = smp_processor_id();
+	struct sched_domain *sd;
 
 	if (stop_tick) {
 		if (!cpu_active(cpu)) {
@@ -4940,6 +4941,12 @@ void select_nohz_load_balancer(int stop_
 		}
 
 		set_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
+		/*
+		 * Indicate the idle state to all the scheduler groups that
+		 * this cpu is part of.
+		 */
+		for_each_domain(cpu, sd)
+			atomic_dec(&sd->groups->sgp->nr_busy_cpus);
 	} else {
 		if (!cpumask_test_cpu(cpu, nohz.idle_cpus_mask))
 			return;
@@ -5104,10 +5111,19 @@ static inline int nohz_kick_needed(struc
 	unsigned long now = jiffies;
 	int ret;
 	int first_pick_cpu, second_pick_cpu;
+	struct sched_domain *sd;
 
-	if (unlikely(test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu))))
+	/*
+	 * We were recently in tickless idle mode. At the first busy tick
+	 * after returning from idle, we will update the busy stats.
+	 */
+	if (unlikely(test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))) {
 		clear_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
 
+		for_each_domain(cpu, sd)
+			atomic_inc(&sd->groups->sgp->nr_busy_cpus);
+	}
+
 	if (time_before(now, nohz.next_balance))
 		return 0;
 


