Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab1IGGWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:22:25 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40320 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755847Ab1IGGWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:22:16 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Shi, Alex" <alex.shi@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 29/55] nohz: Remove nohz_cpu_mask
Date: Tue,  6 Sep 2011 11:00:23 -0700
Message-Id: <1315332049-2604-29-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shi, Alex <alex.shi@intel.com>

RCU no longer uses this global variable, nor does anyone else.  This
commit therefore removes this variable.  This reduces memory footprint
and also removes some atomic instructions and memory barriers from
the dyntick-idle path.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/sched.h    |    1 -
 kernel/sched.c           |   11 -----------
 kernel/time/tick-sched.c |    6 ------
 3 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 14a6c7b..d1a1533 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -270,7 +270,6 @@ extern void init_idle_bootup_task(struct task_struct *idle);
 
 extern int runqueue_is_locked(int cpu);
 
-extern cpumask_var_t nohz_cpu_mask;
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
 extern void select_nohz_load_balancer(int stop_tick);
 extern int get_nohz_timer_target(void);
diff --git a/kernel/sched.c b/kernel/sched.c
index 1c87917..313c0f6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5940,15 +5940,6 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
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
@@ -8167,8 +8158,6 @@ void __init sched_init(void)
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
1.7.3.2

