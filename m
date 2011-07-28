Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab1G1GzC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 02:55:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:15377 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384Ab1G1Gyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 02:54:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,280,1309762800"; 
   d="scan'208";a="31080651"
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, pzijlstr@redhat.com
Cc: seakeel@gmail.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, tim.c.chen@intel.com
Subject: [PATCH] nohz:remove nohz_cpu_mask
Date: Thu, 28 Jul 2011 14:56:12 +0800
Message-Id: <1311836172-10278-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shi, Alex <alex.shi@intel.com>

The rcu didn't use this global variable now. Currently no user on it.
Since no clear usage of this variable, why not remove it? That can save
a cache-line in all cpus and reduce atomic variable sync contention.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/sched.h    |    1 -
 kernel/sched.c           |   11 -----------
 kernel/time/tick-sched.c |    6 ------
 3 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ed766ad..28da5c2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -270,7 +270,6 @@ extern void init_idle_bootup_task(struct task_struct *idle);
 
 extern int runqueue_is_locked(int cpu);
 
-extern cpumask_var_t nohz_cpu_mask;
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
 extern void select_nohz_load_balancer(int stop_tick);
 extern int get_nohz_timer_target(void);
diff --git a/kernel/sched.c b/kernel/sched.c
index 751a7cc..7936fb8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5970,15 +5970,6 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 }
 
 /*
- * In a system that switches off the HZ timer nohz_cpu_mask
- * indicates which cpus entered this state. This is used
- * in the rcu update to wait only for active cpus. For system
- * which do not switch off the HZ timer nohz_cpu_mask should
- * always be CPU_BITS_NONE.
- */
-cpumask_var_t nohz_cpu_mask;
-
-/*
  * Increase the granularity value when there are more CPUs,
  * because with more CPUs the 'effective latency' as visible
  * to users decreases. But the relationship is not linear,
@@ -8189,8 +8180,6 @@ void __init sched_init(void)
 	 */
 	current->sched_class = &fair_sched_class;
 
-	/* Allocate the nohz_cpu_mask if CONFIG_CPUMASK_OFFSTACK */
-	zalloc_cpumask_var(&nohz_cpu_mask, GFP_NOWAIT);
 #ifdef CONFIG_SMP
 	zalloc_cpumask_var(&sched_domains_tmpmask, GFP_NOWAIT);
 #ifdef CONFIG_NO_HZ
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d5097c4..eb98e55 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -139,7 +139,6 @@ static void tick_nohz_update_jiffies(ktime_t now)
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	unsigned long flags;
 
-	cpumask_clear_cpu(cpu, nohz_cpu_mask);
 	ts->idle_waketime = now;
 
 	local_irq_save(flags);
@@ -389,9 +388,6 @@ void tick_nohz_stop_sched_tick(int inidle)
 		else
 			expires.tv64 = KTIME_MAX;
 
-		if (delta_jiffies > 1)
-			cpumask_set_cpu(cpu, nohz_cpu_mask);
-
 		/* Skip reprogram of event if its not changed */
 		if (ts->tick_stopped && ktime_equal(expires, dev->next_event))
 			goto out;
@@ -441,7 +437,6 @@ void tick_nohz_stop_sched_tick(int inidle)
 		 * softirq.
 		 */
 		tick_do_update_jiffies64(ktime_get());
-		cpumask_clear_cpu(cpu, nohz_cpu_mask);
 	}
 	raise_softirq_irqoff(TIMER_SOFTIRQ);
 out:
@@ -524,7 +519,6 @@ void tick_nohz_restart_sched_tick(void)
 	/* Update jiffies first */
 	select_nohz_load_balancer(0);
 	tick_do_update_jiffies64(now);
-	cpumask_clear_cpu(cpu, nohz_cpu_mask);
 
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	/*
-- 
1.6.3.3

