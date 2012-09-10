Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab2IJHLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 03:11:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:54476 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab2IJHLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 03:11:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,396,1344236400"; 
   d="scan'208";a="220137251"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] nohz: clean up select_nohz_load_balancer()
Date: Mon, 10 Sep 2012 15:10:58 +0800
Message-Id: <1347261059-24747-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no load_balancer to be selected now. It just set state of
nohz tick stopping.

So rename the function, pass the 'cpu' from parameter and then
remove the useless calling from tick_nohz_restart_sched_tick().

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/sched.h    |    4 ++--
 kernel/sched/fair.c      |   19 +++++++------------
 kernel/time/tick-sched.c |    3 +--
 3 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b8c8664..5cba49c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -273,11 +273,11 @@ extern void init_idle_bootup_task(struct task_struct *idle);
 extern int runqueue_is_locked(int cpu);
 
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
-extern void select_nohz_load_balancer(int stop_tick);
+extern void set_nohz_tick_stopped(int cpu);
 extern void set_cpu_sd_state_idle(void);
 extern int get_nohz_timer_target(void);
 #else
-static inline void select_nohz_load_balancer(int stop_tick) { }
+static inline void set_nohz_tick_stopped(int cpu) { }
 static inline void set_cpu_sd_state_idle(void) { }
 #endif
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c219bf8..5bbc4bf 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4674,28 +4674,23 @@ void set_cpu_sd_state_idle(void)
 }
 
 /*
- * This routine will record that this cpu is going idle with tick stopped.
+ * This routine will record that the cpu is going idle with tick stopped.
  * This info will be used in performing idle load balancing in the future.
  */
-void select_nohz_load_balancer(int stop_tick)
+void set_nohz_tick_stopped(int cpu)
 {
-	int cpu = smp_processor_id();
-
 	/*
 	 * If this cpu is going down, then nothing needs to be done.
 	 */
 	if (!cpu_active(cpu))
 		return;
 
-	if (stop_tick) {
-		if (test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))
-			return;
+	if (test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))
+		return;
 
-		cpumask_set_cpu(cpu, nohz.idle_cpus_mask);
-		atomic_inc(&nohz.nr_cpus);
-		set_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
-	}
-	return;
+	cpumask_set_cpu(cpu, nohz.idle_cpus_mask);
+	atomic_inc(&nohz.nr_cpus);
+	set_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
 }
 
 static int __cpuinit sched_ilb_notifier(struct notifier_block *nfb,
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 024540f..eacde97 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -372,7 +372,7 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 		 * the scheduler tick in nohz_restart_sched_tick.
 		 */
 		if (!ts->tick_stopped) {
-			select_nohz_load_balancer(1);
+			set_nohz_tick_stopped(cpu);
 			calc_load_enter_idle();
 
 			ts->last_tick = hrtimer_get_expires(&ts->sched_timer);
@@ -569,7 +569,6 @@ static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
 static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
 {
 	/* Update jiffies first */
-	select_nohz_load_balancer(0);
 	tick_do_update_jiffies64(now);
 	update_cpu_load_nohz();
 
-- 
1.7.5.4

