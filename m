Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab2FIKzp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 06:55:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35961 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab2FIKzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 06:55:43 -0400
From: Charles Wang <muming.wq@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Charles Wang <muming.wq@taobao.com>
Subject: [PATCH] sched: Folding nohz load accounting more accurate
Date: Sat,  9 Jun 2012 18:54:55 +0800
Message-Id: <1339239295-18591-1-git-send-email-muming.wq@taobao.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After patch 453494c3d4 (sched: Fix nohz load accounting -- again!), we can fold
the idle into calc_load_tasks_idle between the last cpu load calculating and
calc_global_load calling. However problem still exits between the first cpu 
load calculating and the last cpu load calculating. Every time when we do load 
calculating, calc_load_tasks_idle will be added into calc_load_tasks, even if
the idle load is caused by calculated cpus. This problem is also described in
the following link:

https://lkml.org/lkml/2012/5/24/419

This bug can be found in our work load. The average running processes number 
is about 15, but the load only shows about 4.

The patch provides a solution, by taking calculated load cpus' idle away from
 real effective idle. First adds a cpumask to record those cpus that alread 
calculated their load, and then adds a calc_unmask_cpu_load_idle to record 
thoses not marked cpus' go-idle load. Calc_unmask_cpu_load_idle takes place 
of calc_load_tasks_idle to be added into calc_load_tasks every 5HZ when cpu 
calculate its load. Go-idle load on those cpus which load alread has been calculated 
will only be added into calc_load_tasks_idle, no in calc_unmask_cpu_load_idle.
 
Reported-by: Sha Zhengju <handai.szj@gmail.com>
Signed-off-by: Charles Wang <muming.wq@taobao.com>

---
 include/linux/sched.h     |    1 +
 kernel/sched/core.c       |   83 ++++++++++++++++++++++++++++++++++++++++++++-
 kernel/time/timekeeping.c |    1 +
 3 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6029d8c..a2b8df2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -145,6 +145,7 @@ extern unsigned long this_cpu_load(void);
 
 
 extern void calc_global_load(unsigned long ticks);
+extern void prepare_idle_mask(unsigned long ticks);
 extern void update_cpu_load_nohz(void);
 
 extern unsigned long get_parent_ip(unsigned long addr);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c46958e..bdfe3c2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2164,6 +2164,7 @@ unsigned long this_cpu_load(void)
 /* Variables and functions for calc_load */
 static atomic_long_t calc_load_tasks;
 static unsigned long calc_load_update;
+static unsigned long idle_mask_update;
 unsigned long avenrun[3];
 EXPORT_SYMBOL(avenrun);
 
@@ -2199,13 +2200,38 @@ calc_load(unsigned long load, unsigned long exp, unsigned long active)
  */
 static atomic_long_t calc_load_tasks_idle;
 
+/* 
+ * Those cpus whose load alread has been calculated in this LOAD_FREQ 
+ * period will be masked.
+ */
+struct cpumask  cpu_load_update_mask;
+
+/* 
+ * Fold unmask cpus' idle load
+ */
+static atomic_long_t calc_unmask_cpu_load_idle;
+
+
 void calc_load_account_idle(struct rq *this_rq)
 {
 	long delta;
+	int cpu = smp_processor_id();
+
 
 	delta = calc_load_fold_active(this_rq);
 	if (delta)
+	{
 		atomic_long_add(delta, &calc_load_tasks_idle);
+		/*
+		 * calc_unmask_cpu_load_idle is only used between the first cpu load accounting
+		 * and the last cpu load accounting in every LOAD_FREQ period, and records idle load on
+		 * those unmask cpus.
+		 */
+		if (!cpumask_empty(&cpu_load_update_mask) && !cpumask_test_cpu(cpu, &cpu_load_update_mask))
+		{
+			atomic_long_add(delta, &calc_unmask_cpu_load_idle);
+		}
+       }
 }
 
 static long calc_load_fold_idle(void)
@@ -2221,6 +2247,20 @@ static long calc_load_fold_idle(void)
 	return delta;
 }
 
+static long calc_load_fold_unmask_idle(void)
+{
+	long delta = 0;
+	
+	if (atomic_long_read(&calc_unmask_cpu_load_idle))
+	{
+		delta = atomic_long_xchg(&calc_unmask_cpu_load_idle, 0);
+		atomic_long_sub(delta, &calc_load_tasks_idle);
+	}
+	
+	return delta;
+}
+
+
 /**
  * fixed_power_int - compute: x^n, in O(log n) time
  *
@@ -2312,6 +2352,9 @@ static void calc_global_nohz(void)
 	if (delta)
 		atomic_long_add(delta, &calc_load_tasks);
 
+	cpumask_clear(&cpu_load_update_mask);
+	atomic_long_xchg(&calc_unmask_cpu_load_idle, 0);
+
 	/*
 	 * It could be the one fold was all it took, we done!
 	 */
@@ -2395,18 +2438,54 @@ void calc_global_load(unsigned long ticks)
 }
 
 /*
+ * Prepare cpu_load_update_mask for the comming per-cpu load calculating
+ */
+void prepare_idle_mask(unsigned long ticks)
+{
+	if (time_before(jiffies, idle_mask_update - 10))
+		return;
+	
+	cpumask_clear(&cpu_load_update_mask);
+	/* 
+        * calc_unmask_cpu_load_idle is part of calc_load_tasks_idle,
+	 * and calc_load_tasks_ide will be folded into calc_load_tasks immediately.
+        * So no need to keep this now.
+        */
+	atomic_long_xchg(&calc_unmask_cpu_load_idle, 0);
+	
+	idle_mask_update += LOAD_FREQ;
+}
+
+/*
  * Called from update_cpu_load() to periodically update this CPU's
  * active count.
  */
 static void calc_load_account_active(struct rq *this_rq)
 {
 	long delta;
+	int cpu = smp_processor_id();
 
 	if (time_before(jiffies, this_rq->calc_load_update))
 		return;
 
+	/* 
+	 * cpu_load_update_mask empty means the first cpu
+	 * doing load calculating. Global idle should be
+	 * folded into calc_load_tasks, so we just push it
+	 * to calc_unmask_cpu_load_idle.
+	 */
+	if (cpumask_empty(&cpu_load_update_mask))
+		atomic_long_set(&calc_unmask_cpu_load_idle, atomic_long_read(&calc_load_tasks_idle));
+	/* 
+	 * Mask this cpu as load calculated,
+	 * then go-idle in this cpu won't take effect
+	 * to calc_load_tasks.
+	 */
+	cpumask_set_cpu(cpu, &cpu_load_update_mask);
+
 	delta  = calc_load_fold_active(this_rq);
-	delta += calc_load_fold_idle();
+	/* Fold unmask cpus' load into calc_load_tasks */
+	delta += calc_load_fold_unmask_idle();
 	if (delta)
 		atomic_long_add(delta, &calc_load_tasks);
 
@@ -7100,6 +7179,8 @@ void __init sched_init(void)
 
 	calc_load_update = jiffies + LOAD_FREQ;
 
+	idle_mask_update = jiffies + LOAD_FREQ;
+
 	/*
 	 * During early bootup we pretend to be a normal task:
 	 */
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6e46cac..afbc06a 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1222,6 +1222,7 @@ void do_timer(unsigned long ticks)
 	jiffies_64 += ticks;
 	update_wall_time();
 	calc_global_load(ticks);
+	prepare_idle_mask(ticks);
 }
 
 /**
-- 
1.7.9.5

