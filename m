Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574Ab2JCXHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 19:07:18 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:47087 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932265Ab2JCXHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 19:07:16 -0400
X-DKIM: OpenDKIM Filter v2.4.1 mail.betterlinux.com 3C04C8217D
From: Andrea Righi <andrea@betterlinux.com>
To: Paul Menage <paul@paulmenage.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrea Righi <andrea@betterlinux.com>
Subject: [PATCH RFC 1/3] sched: introduce distinct per-cpu load average
Date: Thu,  4 Oct 2012 01:05:10 +0200
Message-Id: <1349305512-3428-2-git-send-email-andrea@betterlinux.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349305512-3428-1-git-send-email-andrea@betterlinux.com>
References: <1349305512-3428-1-git-send-email-andrea@betterlinux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Account per-cpu load average, as well as nr_running and
nr_uninterruptible tasks.

The new element on_cpu_uninterruptible to task_struct is added to
properly keep track of the cpu where the task was set to the
uninterruptible sleep state.

This feature is required by the cpusets cgroup subsystem to report the
load average per-cpuset.

Signed-off-by: Andrea Righi <andrea@betterlinux.com>
---
 include/linux/sched.h |    7 +++++
 kernel/sched/core.c   |   78 ++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 81 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9d51e26..fb3df1b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -119,7 +119,10 @@ struct blk_plug;
  *    11 bit fractions.
  */
 extern unsigned long avenrun[];		/* Load averages */
+extern unsigned long cpu_avenrun[][NR_CPUS] /* Load averages per cpu */;
 extern void get_avenrun(unsigned long *loads, unsigned long offset, int shift);
+extern void get_cpu_avenrun(unsigned long *loads, int cpu,
+				unsigned long offset, int shift);
 
 #define FSHIFT		11		/* nr of bits of precision */
 #define FIXED_1		(1<<FSHIFT)	/* 1.0 as fixed-point */
@@ -138,7 +141,9 @@ extern int nr_threads;
 DECLARE_PER_CPU(unsigned long, process_counts);
 extern int nr_processes(void);
 extern unsigned long nr_running(void);
+extern unsigned long nr_running_cpu(int cpu);
 extern unsigned long nr_uninterruptible(void);
+extern unsigned long nr_uninterruptible_cpu(int cpu);
 extern unsigned long nr_iowait(void);
 extern unsigned long nr_iowait_cpu(int cpu);
 extern unsigned long this_cpu_load(void);
@@ -1239,6 +1244,8 @@ struct task_struct {
 #ifdef CONFIG_SMP
 	struct llist_node wake_entry;
 	int on_cpu;
+	/* Used to keep track of nr_uninterruptible tasks per-cpu */
+	int on_cpu_uninterruptible;
 #endif
 	int on_rq;
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c177472..87a8e62 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -727,15 +727,17 @@ static void dequeue_task(struct rq *rq, struct task_struct *p, int flags)
 void activate_task(struct rq *rq, struct task_struct *p, int flags)
 {
 	if (task_contributes_to_load(p))
-		rq->nr_uninterruptible--;
+		cpu_rq(p->on_cpu_uninterruptible)->nr_uninterruptible--;
 
 	enqueue_task(rq, p, flags);
 }
 
 void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
 {
-	if (task_contributes_to_load(p))
-		rq->nr_uninterruptible++;
+	if (task_contributes_to_load(p)) {
+		task_rq(p)->nr_uninterruptible++;
+		p->on_cpu_uninterruptible = task_cpu(p);
+	}
 
 	dequeue_task(rq, p, flags);
 }
@@ -1278,7 +1280,7 @@ ttwu_do_activate(struct rq *rq, struct task_struct *p, int wake_flags)
 {
 #ifdef CONFIG_SMP
 	if (p->sched_contributes_to_load)
-		rq->nr_uninterruptible--;
+		cpu_rq(p->on_cpu_uninterruptible)->nr_uninterruptible--;
 #endif
 
 	ttwu_activate(rq, p, ENQUEUE_WAKEUP | ENQUEUE_WAKING);
@@ -1916,6 +1918,11 @@ unsigned long nr_running(void)
 	return sum;
 }
 
+unsigned long nr_running_cpu(int cpu)
+{
+	return cpu_rq(cpu)->nr_running;
+}
+
 unsigned long nr_uninterruptible(void)
 {
 	unsigned long i, sum = 0;
@@ -1933,6 +1940,11 @@ unsigned long nr_uninterruptible(void)
 	return sum;
 }
 
+unsigned long nr_uninterruptible_cpu(int cpu)
+{
+	return cpu_rq(cpu)->nr_uninterruptible;
+}
+
 unsigned long long nr_context_switches(void)
 {
 	int i;
@@ -2035,6 +2047,9 @@ void get_avenrun(unsigned long *loads, unsigned long offset, int shift)
 	loads[2] = (avenrun[2] + offset) << shift;
 }
 
+unsigned long cpu_avenrun[3][NR_CPUS] __cacheline_aligned_in_smp;
+EXPORT_SYMBOL(cpu_avenrun);
+
 static long calc_load_fold_active(struct rq *this_rq)
 {
 	long nr_active, delta = 0;
@@ -2062,6 +2077,24 @@ calc_load(unsigned long load, unsigned long exp, unsigned long active)
 	return load >> FSHIFT;
 }
 
+static void calc_global_load_percpu(void)
+{
+	long active;
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		active = cpu_rq(cpu)->calc_load_active;
+		active = active > 0 ? active * FIXED_1 : 0;
+
+		cpu_avenrun[0][cpu] = calc_load(cpu_avenrun[0][cpu],
+							EXP_1, active);
+		cpu_avenrun[1][cpu] = calc_load(cpu_avenrun[1][cpu],
+							EXP_5, active);
+		cpu_avenrun[2][cpu] = calc_load(cpu_avenrun[2][cpu],
+							EXP_15, active);
+	}
+}
+
 #ifdef CONFIG_NO_HZ
 /*
  * Handle NO_HZ for the global load-average.
@@ -2248,6 +2281,23 @@ calc_load_n(unsigned long load, unsigned long exp,
 	return calc_load(load, fixed_power_int(exp, FSHIFT, n), active);
 }
 
+static void calc_global_load_n_percpu(unsigned int n)
+{
+	long active;
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		active = cpu_rq(cpu)->calc_load_active;
+		active = active > 0 ? active * FIXED_1 : 0;
+
+		cpu_avenrun[0][cpu] = calc_load_n(cpu_avenrun[0][cpu],
+							EXP_1, active, n);
+		cpu_avenrun[1][cpu] = calc_load_n(cpu_avenrun[1][cpu],
+							EXP_5, active, n);
+		cpu_avenrun[2][cpu] = calc_load_n(cpu_avenrun[2][cpu],
+							EXP_15, active, n);
+	}
+}
 /*
  * NO_HZ can leave us missing all per-cpu ticks calling
  * calc_load_account_active(), but since an idle CPU folds its delta into
@@ -2275,6 +2325,8 @@ static void calc_global_nohz(void)
 		avenrun[1] = calc_load_n(avenrun[1], EXP_5, active, n);
 		avenrun[2] = calc_load_n(avenrun[2], EXP_15, active, n);
 
+		calc_global_load_n_percpu(n);
+
 		calc_load_update += n * LOAD_FREQ;
 	}
 
@@ -2320,6 +2372,8 @@ void calc_global_load(unsigned long ticks)
 	avenrun[1] = calc_load(avenrun[1], EXP_5, active);
 	avenrun[2] = calc_load(avenrun[2], EXP_15, active);
 
+	calc_global_load_percpu();
+
 	calc_load_update += LOAD_FREQ;
 
 	/*
@@ -2328,6 +2382,22 @@ void calc_global_load(unsigned long ticks)
 	calc_global_nohz();
 }
 
+/**
+ * get_cpu_avenrun - get the load average array of a single cpu
+ * @loads:	pointer to dest load array
+ * @cpu:	the cpu to read the load average
+ * @offset:	offset to add
+ * @shift:	shift count to shift the result left
+ *
+ * These values are estimates at best, so no need for locking.
+ */
+void get_cpu_avenrun(unsigned long *loads, int cpu,
+			unsigned long offset, int shift)
+{
+	loads[0] = (cpu_avenrun[0][cpu] + offset) << shift;
+	loads[1] = (cpu_avenrun[1][cpu] + offset) << shift;
+	loads[2] = (cpu_avenrun[2][cpu] + offset) << shift;
+}
 /*
  * Called from update_cpu_load() to periodically update this CPU's
  * active count.
-- 
1.7.9.5

