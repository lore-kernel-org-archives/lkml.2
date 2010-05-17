Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab0EQTCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:02:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:32383 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755675Ab0EQTCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:02:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,248,1272870000"; 
   d="scan'208";a="278095809"
Message-Id: <20100517184027.948141391@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 17 May 2010 11:27:31 -0700
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
Subject: [patch 5/7] sched: Change select_nohz_load_balancer to return void
References: <20100517182726.089700767@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=sched_select_nohz_load_balancer_to_return_void.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Venkatesh Pallipadi <venki@google.com>
Subject: sched: Change select_nohz_load_balancer to return void

select_nohz_load_balancer used to return 1 when ticks are not to be
stopped (idle_balancer), 0 otherwise. With change to nohz idle_balancer logic,
all idle cpus can go to tickless mode and be woken up by a kick from one
of the busy cpus, if and when idle balancing is required. As a result,
select_nohz_load_balancer can return void.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 include/linux/sched.h    |    7 ++-----
 kernel/sched_fair.c      |   16 ++++++++--------
 kernel/time/tick-sched.c |    8 +-------
 3 files changed, 11 insertions(+), 20 deletions(-)

Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -3266,14 +3266,14 @@ static void nohz_balancer_kick(int cpu)
  * ilb owner CPU in future (when there is a need for idle load balancing on
  * behalf of all idle CPUs).
  */
-int select_nohz_load_balancer(int stop_tick)
+void select_nohz_load_balancer(int stop_tick)
 {
 	int cpu = smp_processor_id();
 
 	if (stop_tick) {
 		if (!cpu_active(cpu)) {
 			if (atomic_read(&nohz.load_balancer) != cpu)
-				return 0;
+				return;
 
 			/*
 			 * If we are going offline and still the leader,
@@ -3282,7 +3282,7 @@ int select_nohz_load_balancer(int stop_t
 			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
 				BUG();
 
-			return 0;
+			return;
 		}
 
 		cpumask_set_cpu(cpu, nohz.idle_cpus_mask);
@@ -3297,7 +3297,7 @@ int select_nohz_load_balancer(int stop_t
 
 			/* make me the ilb owner */
 			if (atomic_cmpxchg(&nohz.load_balancer, -1, cpu) != -1)
-				return 0;
+				return;
 
 			/*
 			 * Check to see if there is a more power-efficient
@@ -3307,13 +3307,13 @@ int select_nohz_load_balancer(int stop_t
 			if (new_ilb < nr_cpu_ids && new_ilb != cpu) {
 				atomic_set(&nohz.load_balancer, -1);
 				resched_cpu(new_ilb);
-				return 0;
+				return;
 			}
-			return 0;
+			return;
 		}
 	} else {
 		if (!cpumask_test_cpu(cpu, nohz.idle_cpus_mask))
-			return 0;
+			return;
 
 		cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
 
@@ -3321,7 +3321,7 @@ int select_nohz_load_balancer(int stop_t
 			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
 				BUG();
 	}
-	return 0;
+	return;
 }
 #endif
 
Index: tip/kernel/time/tick-sched.c
===================================================================
--- tip.orig/kernel/time/tick-sched.c
+++ tip/kernel/time/tick-sched.c
@@ -408,13 +408,7 @@ void tick_nohz_stop_sched_tick(int inidl
 		 * the scheduler tick in nohz_restart_sched_tick.
 		 */
 		if (!ts->tick_stopped) {
-			if (select_nohz_load_balancer(1)) {
-				/*
-				 * sched tick not stopped!
-				 */
-				cpumask_clear_cpu(cpu, nohz_cpu_mask);
-				goto out;
-			}
+			select_nohz_load_balancer(1);
 
 			ts->idle_tick = hrtimer_get_expires(&ts->sched_timer);
 			ts->tick_stopped = 1;
Index: tip/include/linux/sched.h
===================================================================
--- tip.orig/include/linux/sched.h
+++ tip/include/linux/sched.h
@@ -272,14 +272,11 @@ extern void task_rq_unlock_wait(struct t
 
 extern cpumask_var_t nohz_cpu_mask;
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
-extern int select_nohz_load_balancer(int cpu);
+extern void select_nohz_load_balancer(int stop_tick);
 extern int get_nohz_load_balancer(void);
 extern int nohz_ratelimit(int cpu);
 #else
-static inline int select_nohz_load_balancer(int cpu)
-{
-	return 0;
-}
+static inline void select_nohz_load_balancer(int stop_tick) { }
 
 static inline int nohz_ratelimit(int cpu)
 {


