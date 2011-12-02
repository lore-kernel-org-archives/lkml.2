Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab1LBBKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 20:10:14 -0500
Received: from mga14.intel.com ([143.182.124.37]:55150 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382Ab1LBBKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 20:10:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,281,1320652800"; 
   d="scan'208";a="43122723"
Message-Id: <20111202010832.499438999@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 01 Dec 2011 17:07:32 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>, alex.shi@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch v3 1/6] sched, nohz: introduce nohz_flags in the struct rq
References: <20111202010731.344451602@sbsiddha-desk.sc.intel.com>
Content-Disposition: inline; filename=introduce_rq_nohz_flags.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce nohz_flags in the struct rq, which will track these two flags
for now.

NOHZ_TICK_STOPPED keeps track of the tick stopped status that gets set when
the tick is stopped. It will be used to update the nohz idle load balancer data
structures during the first busy tick after the tick is restarted. At this
first busy tick after tickless idle, NOHZ_TICK_STOPPED flag will be reset.
This will minimize the nohz idle load balancer status updates that currently
happen for every tickless exit, making it more scalable when there
are many logical cpu's that enter and exit idle often.

NOHZ_BALANCE_KICK will track the need for nohz idle load balance
on this rq. This will replace the nohz_balance_kick in the rq, which was
not being updated atomically.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com> 
---
 kernel/sched/core.c  |    5 +++--
 kernel/sched/fair.c  |   48 +++++++++++++++++++++++++++---------------------
 kernel/sched/sched.h |   11 ++++++++++-
 3 files changed, 40 insertions(+), 24 deletions(-)

Index: tip/kernel/sched/core.c
===================================================================
--- tip.orig/kernel/sched/core.c
+++ tip/kernel/sched/core.c
@@ -575,7 +575,8 @@ void wake_up_idle_cpu(int cpu)
 
 static inline bool got_nohz_idle_kick(void)
 {
-	return idle_cpu(smp_processor_id()) && this_rq()->nohz_balance_kick;
+	int cpu = smp_processor_id();
+	return idle_cpu(cpu) && test_bit(NOHZ_BALANCE_KICK, nohz_flags(cpu));
 }
 
 #else /* CONFIG_NO_HZ */
@@ -6833,7 +6834,7 @@ void __init sched_init(void)
 		rq->avg_idle = 2*sysctl_sched_migration_cost;
 		rq_attach_root(rq, &def_root_domain);
 #ifdef CONFIG_NO_HZ
-		rq->nohz_balance_kick = 0;
+		rq->nohz_flags = 0;
 #endif
 #endif
 		init_rq_hrtick(rq);
Index: tip/kernel/sched/fair.c
===================================================================
--- tip.orig/kernel/sched/fair.c
+++ tip/kernel/sched/fair.c
@@ -4866,18 +4866,15 @@ static void nohz_balancer_kick(int cpu)
 			return;
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
+	if (test_and_set_bit(NOHZ_BALANCE_KICK, nohz_flags(cpu)))
+		return;
+	/*
+	 * Use smp_send_reschedule() instead of resched_cpu().
+	 * This way we generate a sched IPI on the target cpu which
+	 * is idle. And the softirq performing nohz idle load balance
+	 * will be run before returning from the IPI.
+	 */
+	smp_send_reschedule(ilb_cpu);
 	return;
 }
 
@@ -4941,6 +4938,8 @@ void select_nohz_load_balancer(int stop_
 			}
 			return;
 		}
+
+		set_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
 	} else {
 		if (!cpumask_test_cpu(cpu, nohz.idle_cpus_mask))
 			return;
@@ -5056,8 +5055,9 @@ static void nohz_idle_balance(int this_c
 	struct rq *rq;
 	int balance_cpu;
 
-	if (idle != CPU_IDLE || !this_rq->nohz_balance_kick)
-		return;
+	if (idle != CPU_IDLE ||
+	    !test_bit(NOHZ_BALANCE_KICK, nohz_flags(this_cpu)))
+		goto end;
 
 	for_each_cpu(balance_cpu, nohz.idle_cpus_mask) {
 		if (balance_cpu == this_cpu)
@@ -5068,10 +5068,8 @@ static void nohz_idle_balance(int this_c
 		 * work being done for other cpus. Next load
 		 * balancing owner will pick it up.
 		 */
-		if (need_resched()) {
-			this_rq->nohz_balance_kick = 0;
+		if (need_resched())
 			break;
-		}
 
 		raw_spin_lock_irq(&this_rq->lock);
 		update_rq_clock(this_rq);
@@ -5085,7 +5083,8 @@ static void nohz_idle_balance(int this_c
 			this_rq->next_balance = rq->next_balance;
 	}
 	nohz.next_balance = this_rq->next_balance;
-	this_rq->nohz_balance_kick = 0;
+end:
+	clear_bit(NOHZ_BALANCE_KICK, nohz_flags(this_cpu));
 }
 
 /*
@@ -5106,10 +5105,17 @@ static inline int nohz_kick_needed(struc
 	int ret;
 	int first_pick_cpu, second_pick_cpu;
 
-	if (time_before(now, nohz.next_balance))
+	if (unlikely(idle_cpu(cpu)))
 		return 0;
 
-	if (idle_cpu(cpu))
+       /*
+	* We may be recently in ticked or tickless idle mode. At the first
+	* busy tick after returning from idle, we will update the busy stats.
+	*/
+	if (unlikely(test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu))))
+		clear_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
+
+	if (time_before(now, nohz.next_balance))
 		return 0;
 
 	first_pick_cpu = atomic_read(&nohz.first_pick_cpu);
@@ -5173,7 +5179,7 @@ void trigger_load_balance(struct rq *rq,
 	    likely(!on_null_domain(cpu)))
 		raise_softirq(SCHED_SOFTIRQ);
 #ifdef CONFIG_NO_HZ
-	else if (nohz_kick_needed(rq, cpu) && likely(!on_null_domain(cpu)))
+	if (nohz_kick_needed(rq, cpu) && likely(!on_null_domain(cpu)))
 		nohz_balancer_kick(cpu);
 #endif
 }
Index: tip/kernel/sched/sched.h
===================================================================
--- tip.orig/kernel/sched/sched.h
+++ tip/kernel/sched/sched.h
@@ -371,7 +371,7 @@ struct rq {
 	unsigned long last_load_update_tick;
 #ifdef CONFIG_NO_HZ
 	u64 nohz_stamp;
-	unsigned char nohz_balance_kick;
+	unsigned long nohz_flags;
 #endif
 	int skip_clock_update;
 
@@ -1062,3 +1062,12 @@ extern void init_rt_rq(struct rt_rq *rt_
 extern void unthrottle_offline_cfs_rqs(struct rq *rq);
 
 extern void account_cfs_bandwidth_used(int enabled, int was_enabled);
+
+#ifdef CONFIG_NO_HZ
+enum rq_nohz_flag_bits {
+	NOHZ_TICK_STOPPED,
+	NOHZ_BALANCE_KICK,
+};
+
+#define nohz_flags(cpu)	(&cpu_rq(cpu)->nohz_flags)
+#endif


