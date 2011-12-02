Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab1LBBK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 20:10:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:3642 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756244Ab1LBBKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 20:10:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="82332022"
Message-Id: <20111202010832.555984323@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 01 Dec 2011 17:07:33 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>, alex.shi@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch v3 2/6] sched, nohz: track nr_busy_cpus in the sched_group_power
References: <20111202010731.344451602@sbsiddha-desk.sc.intel.com>
Content-Disposition: inline; filename=track_nr_busy_cpus_in_sched_group.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce nr_busy_cpus in the struct sched_group_power [Not in sched_group
because sched groups are duplicated for the SD_OVERLAP scheduler domain]
and for each cpu that enters and exits idle, this parameter will
be updated in each scheduler group of the scheduler domain that this cpu
belongs to.

To avoid the frequent update of this state as the cpu enters
and exits idle, the update of the stat during idle exit is
delayed to the first timer tick that happens after the cpu becomes busy.
This is done using NOHZ_IDLE flag in the struct rq's nohz_flags.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 include/linux/sched.h    |    6 ++++++
 kernel/sched/core.c      |    1 +
 kernel/sched/fair.c      |   31 +++++++++++++++++++++++++++++++
 kernel/sched/sched.h     |    1 +
 kernel/time/tick-sched.c |    9 +++++++++
 5 files changed, 48 insertions(+)

Index: tip/include/linux/sched.h
===================================================================
--- tip.orig/include/linux/sched.h
+++ tip/include/linux/sched.h
@@ -273,9 +273,11 @@ extern int runqueue_is_locked(int cpu);
 
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
 extern void select_nohz_load_balancer(int stop_tick);
+extern void set_cpu_sd_state_idle(void);
 extern int get_nohz_timer_target(void);
 #else
 static inline void select_nohz_load_balancer(int stop_tick) { }
+static inline void set_cpu_sd_state_idle(void);
 #endif
 
 /*
@@ -901,6 +903,10 @@ struct sched_group_power {
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
@@ -4878,6 +4878,36 @@ static void nohz_balancer_kick(int cpu)
 	return;
 }
 
+static inline void set_cpu_sd_state_busy(void)
+{
+	struct sched_domain *sd;
+	int cpu = smp_processor_id();
+
+	if (!test_bit(NOHZ_IDLE, nohz_flags(cpu)))
+		return;
+	clear_bit(NOHZ_IDLE, nohz_flags(cpu));
+
+	rcu_read_lock();
+	for_each_domain(cpu, sd)
+		atomic_inc(&sd->groups->sgp->nr_busy_cpus);
+	rcu_read_unlock();
+}
+
+void set_cpu_sd_state_idle(void)
+{
+	struct sched_domain *sd;
+	int cpu = smp_processor_id();
+
+	if (test_bit(NOHZ_IDLE, nohz_flags(cpu)))
+		return;
+	set_bit(NOHZ_IDLE, nohz_flags(cpu));
+
+	rcu_read_lock();
+	for_each_domain(cpu, sd)
+		atomic_dec(&sd->groups->sgp->nr_busy_cpus);
+	rcu_read_unlock();
+}
+
 /*
  * This routine will try to nominate the ilb (idle load balancing)
  * owner among the cpus whose ticks are stopped. ilb owner will do the idle
@@ -5112,6 +5142,7 @@ static inline int nohz_kick_needed(struc
 	* We may be recently in ticked or tickless idle mode. At the first
 	* busy tick after returning from idle, we will update the busy stats.
 	*/
+	set_cpu_sd_state_busy();
 	if (unlikely(test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu))))
 		clear_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
 
Index: tip/kernel/time/tick-sched.c
===================================================================
--- tip.orig/kernel/time/tick-sched.c
+++ tip/kernel/time/tick-sched.c
@@ -297,6 +297,15 @@ void tick_nohz_stop_sched_tick(int inidl
 	ts = &per_cpu(tick_cpu_sched, cpu);
 
 	/*
+ 	 * Update the idle state in the scheduler domain hierarchy
+ 	 * when tick_nohz_stop_sched_tick() is called from the idle loop.
+ 	 * State will be updated to busy during the first busy tick after
+ 	 * exiting idle.
+ 	 */
+	if (inidle)
+		set_cpu_sd_state_idle();
+
+	/*
 	 * Call to tick_nohz_start_idle stops the last_update_time from being
 	 * updated. Thus, it must not be called in the event we are called from
 	 * irq_exit() with the prior state different than idle.
Index: tip/kernel/sched/sched.h
===================================================================
--- tip.orig/kernel/sched/sched.h
+++ tip/kernel/sched/sched.h
@@ -1067,6 +1067,7 @@ extern void account_cfs_bandwidth_used(i
 enum rq_nohz_flag_bits {
 	NOHZ_TICK_STOPPED,
 	NOHZ_BALANCE_KICK,
+	NOHZ_IDLE,
 };
 
 #define nohz_flags(cpu)	(&cpu_rq(cpu)->nohz_flags)


