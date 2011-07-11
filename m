Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab1GKArN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 20:47:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:43945 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756882Ab1GKArM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 20:47:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,510,1304319600"; 
   d="scan'208";a="26026478"
Subject: nohz: remove nohz_cpu_mask
From: "Alex,Shi" <alex.shi@intel.com>
To: tglx@linutronix.de, mingo@redhat.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fu, Michael" <michael.fu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jul 2011 08:47:05 +0800
Message-ID: <1310345225.28599.10.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RCU didn't use this global variable now. Currently no user on it.

Since the ts->do_timer_last is not the real last periodic tick cpu in
most of time. I once want to compare the cpu_online_mask and
nohz_cpu_mask to get a real one, and than only let that cpu sleep
shorter, other cpu will try to sleep KTIME_MAX, that need a extra lock
for nohz_cpu_mask. But I checked my all platforms, from NHM-EX server to
laptops, all of them are waked up a few times per second. So, the
advantage is only in theory. 

Since no clear usage of this variable, why not remove it? That can save
a cache-line in all cpus and reduce atomic sync contention.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
diff --git a/include/linux/sched.h b/include/linux/sched.h
index a837b20..6f5cfb3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -270,7 +270,6 @@ extern void init_idle_bootup_task(struct task_struct *idle);
 
 extern int runqueue_is_locked(int cpu);
 
-extern cpumask_var_t nohz_cpu_mask;
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
 extern void select_nohz_load_balancer(int stop_tick);
 extern int get_nohz_timer_target(void);
diff --git a/kernel/sched.c b/kernel/sched.c
index 3f2e502..a48343c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5907,15 +5907,6 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
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
@@ -8010,8 +8001,6 @@ void __init sched_init(void)
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


