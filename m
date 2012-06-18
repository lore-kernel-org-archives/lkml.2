Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab2FRHNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 03:13:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34451 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab2FRHNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 03:13:24 -0400
From: Charles Wang <muming.wq@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Charles Wang <muming.wq@taobao.com>, Peter Zijlstra <peterz@infradead.org>,
        Doug Smythies <dsmythies@telus.net>, Ingo Molnar <mingo@redhat.com>,
        Tao Ma <tm@tao.ma>, Sha Zhengju <handai.szj@gmail.com>
Subject: [PATCHv2 1/2] sched: Folding nohz load accounting more accurate
Date: Mon, 18 Jun 2012 15:12:49 +0800
Message-Id: <1340003570-7193-1-git-send-email-muming.wq@taobao.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V1-->V2 Use per-cpu variable instead of cpumask to avoid lock.

After patch 453494c3d4 (sched: Fix nohz load accounting -- again!), we can fold
the idle into calc_load_tasks_idle between the last cpu load calculating and
calc_global_load calling. However problem still exits between the first cpu
load calculating and the last cpu load calculating. Every time when we do load
calculating, calc_load_tasks_idle will be added into calc_load_tasks, even if
the idle load is caused by calculated cpus. Consider following case:
5HZ+1
| cpu0_load     cpu1    cpu2    cpu3    calc_load_tasks    tasks_idle
|    1           1       1       1
|  -->calc_load                             1                  0
|    1           1       1       1
|                    -->calc_load           2                  0
|    0           0       1       0
|                    -->calc_load           2+1-3=0            -3
|    1           1       0       1
|                            -->calc_load   1-1=0              -1
V
5HZ+11     -->calc_global_load              0                  0

actually the load should be around 3, but shows nearly 0.

This can be found in our work load. The average running processes number
is about 15, but the load only shows about 4.

We provides a solution, by taking those load not calculated cpus' idle out from
global idle as calc_unmask_cpu_load_idle. Then when calc_load execute on every
cpu, we only fold calc_unmask_cpu_load_idle. After this patch, case above 
should be as follow:
5HZ+1
| cpu0_load     cpu1    cpu2    cpu3   calc_load_tasks tasks_idle  unmask_idle
|    1           1       1       1
|  -->calc_load                             1              0           0
|    1           1       1       1
|              -->calc_load                 2              0           0
|    0           0       1       0
|                    -->calc_load           2+1-1=2        -3          -1
|    1           1       0       1
|                            -->calc_load   2+1=3          -2-1=-3     0
V
5HZ+11     -->calc_global_load              3              -3          0

CC: Peter Zijlstra <peterz@infradead.org>
CC: Doug Smythies <dsmythies@telus.net>
CC: Ingo Molnar <mingo@redhat.com>
CC: Tao Ma <tm@tao.ma>
CC: Sha Zhengju <handai.szj@gmail.com>
Reported-by: Sha Zhengju <handai.szj@gmail.com>
Signed-off-by: Charles Wang <muming.wq@taobao.com>

diff --git a/include/linux/sched.h b/include/linux/sched.h
index db4c715..8de2608 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -146,6 +146,7 @@ extern unsigned long this_cpu_load(void);
 
 
 extern void calc_global_load(void);
+extern void prepare_calc_load(void);
 extern void update_cpu_load_nohz(void);
 
 extern unsigned long get_parent_ip(unsigned long addr);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ca07ee0..691e7ec 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2165,6 +2165,7 @@ unsigned long this_cpu_load(void)
 /* Variables and functions for calc_load */
 static atomic_long_t calc_load_tasks;
 static unsigned long calc_load_update;
+static unsigned long calc_mask_update;
 unsigned long avenrun[3];
 EXPORT_SYMBOL(avenrun);
 
@@ -2193,6 +2194,60 @@ calc_load(unsigned long load, unsigned long exp, unsigned long active)
 }
 
 #ifdef CONFIG_NO_HZ
+static DEFINE_PER_CPU(int, cpu_load_update_mask);
+
+/*
+ * Test if this cpu alread calculated its load
+ *
+ * Ret:
+ * 1 -- load updating finish
+ * 0 -- not finish
+ */
+static int test_cpu_load_update_mask(void)
+{
+	if (__get_cpu_var(cpu_load_update_mask))
+		return 1;
+	return 0;
+}
+
+/*
+ * No protection here for race, so take care outside
+ *
+ * Ret:
+ * 1 -- empty mask
+ * 0 -- not empty
+ */
+static int cpu_load_update_mask_empty(void)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		if (per_cpu(cpu_load_update_mask, cpu))
+			return 0;
+	}
+	return 1;
+}
+
+static void clear_all_cpu_load_update_mask(void)
+{
+	int cpu;
+	
+	for_each_online_cpu(cpu) {
+		per_cpu(cpu_load_update_mask, cpu) = 0;
+	}
+}
+
+static void set_cpu_load_update_mask(void)
+{
+	int cpu = smp_processor_id();
+	
+	/* mask this cpu as load updating finished */
+	per_cpu(cpu_load_update_mask, cpu) = 1;
+}
+
+/* fold those not update cpus' idle */
+static atomic_long_t calc_unmask_cpu_load_idle;
+
 /*
  * For NO_HZ we delay the active fold to the next LOAD_FREQ update.
  *
@@ -2205,8 +2260,17 @@ void calc_load_account_idle(struct rq *this_rq)
 	long delta;
 
 	delta = calc_load_fold_active(this_rq);
-	if (delta)
+	if (delta) {
 		atomic_long_add(delta, &calc_load_tasks_idle);
+		/*
+		 * calc_unmask_cpu_load_idle only used between first cpu load
+		 * accounting and final cpu load accounting (5HZ+1), and only
+		 * record idle on those not updating their load's cpus
+		 */
+		if (!cpu_load_update_mask_empty() 
+		    && !test_cpu_load_update_mask()) 
+			atomic_long_add(delta, &calc_unmask_cpu_load_idle);
+	}
 }
 
 static long calc_load_fold_idle(void)
@@ -2222,6 +2286,18 @@ static long calc_load_fold_idle(void)
 	return delta;
 }
 
+static long calc_load_fold_unmask_idle(void)
+{
+	long delta = 0;
+	
+	if (atomic_long_read(&calc_unmask_cpu_load_idle)) {
+		delta = atomic_long_xchg(&calc_unmask_cpu_load_idle, 0);
+		atomic_long_sub(delta, &calc_load_tasks_idle);
+	}
+	
+	return delta;
+}
+
 /**
  * fixed_power_int - compute: x^n, in O(log n) time
  *
@@ -2395,6 +2471,27 @@ void calc_global_load(void)
 	calc_global_nohz();
 }
 
+void prepare_calc_load(void)
+{
+	long delta;
+	
+	if (time_before(jiffies, calc_mask_update - 10))
+		return;
+	
+	/* clear all cpu update mask */
+	clear_all_cpu_load_update_mask();
+	/* drop unmask cpus' idle */
+	atomic_long_xchg(&calc_unmask_cpu_load_idle, 0);
+	
+	/* fold global idle */
+	delta = calc_load_fold_idle();
+	if (delta)
+		atomic_long_add(delta, &calc_load_tasks);
+	
+	calc_mask_update += LOAD_FREQ;
+}
+
+
 /*
  * Called from update_cpu_load_active() to periodically update this CPU's
  * active count.
@@ -2406,8 +2503,17 @@ static void calc_load_account_active(struct rq *this_rq)
 	if (time_before(jiffies, this_rq->calc_load_update))
 		return;
 
+	if (cpu_load_update_mask_empty()) {
+		/* The first cpu doing load calculating in this period */
+		atomic_long_xchg(&calc_unmask_cpu_load_idle, 0);
+		delta = atomic_long_xchg(&calc_load_tasks_idle, 0);
+		atomic_long_add(delta, &calc_load_tasks);
+	}
+	/* mark this cpu as load calculated */
+	set_cpu_load_update_mask();
+
 	delta  = calc_load_fold_active(this_rq);
-	delta += calc_load_fold_idle();
+	delta += calc_load_fold_unmask_idle();
 	if (delta)
 		atomic_long_add(delta, &calc_load_tasks);
 
@@ -7269,6 +7375,8 @@ void __init sched_init(void)
 
 	calc_load_update = jiffies + LOAD_FREQ;
 
+	calc_mask_update = jiffies + LOAD_FREQ;
+
 	/*
 	 * During early bootup we pretend to be a normal task:
 	 */
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 87be8c2..d5f913f 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1223,6 +1223,7 @@ void do_timer(unsigned long ticks)
 {
 	jiffies_64 += ticks;
 	update_wall_time();
+	prepare_calc_load();
 	calc_global_load();
 }
 
-- 
1.7.9.5

