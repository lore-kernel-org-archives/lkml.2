Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab2DZR0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 13:26:44 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41161 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab2DZR0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 13:26:42 -0400
Message-ID: <4F99854E.80102@gmail.com>
Date: Thu, 26 Apr 2012 11:26:38 -0600
From: Hakan Akkan <hakanakkan@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] nohz/cpuset: enable addition&removal of cpus while in adaptive
 nohz mode
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently modifying cpuset.cpus mask of a cgroup does not
update the reference counters for adaptive nohz mode if the
cpuset already had cpuset.adaptive_nohz == 1. Fix it so that
cpus can be added or removed from a adaptive_nohz cpuset.

Apply to Frederic's nohz/cpuset-v2 kernel 3.3.0-rc7nohz/cpuset-v2+
(commit abd48ecb412ff023582e97442a02a7cb162a1c4e)

Signed-off-by: Hakan Akkan <hakanakkan@gmail.com>
---
 kernel/cpuset.c |  107 ++++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 70 insertions(+), 37 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index aa8304d..1446210 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -862,6 +862,8 @@ static void update_tasks_cpumask(struct cpuset *cs, struct ptr_heap *heap)
 	cgroup_scan_tasks(&scan);
 }
 
+static void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs);
+
 /**
  * update_cpumask - update the cpus_allowed mask of a cpuset and all tasks in it
  * @cs: the cpuset to consider
@@ -902,6 +904,11 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	if (cpumask_equal(cs->cpus_allowed, trialcs->cpus_allowed))
 		return 0;
 
+	/*
+	 * Update adaptive nohz bits.
+	 */
+	update_nohz_cpus(cs,trialcs);
+
 	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
 	if (retval)
 		return retval;
@@ -1247,51 +1254,74 @@ static void cpu_exit_nohz(int cpu)
 	preempt_enable();
 }
 
-static void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
+static void update_cpu_nohz_flag(int cpu, int adjust)
+{
+	int ref = (per_cpu(cpu_adaptive_nohz_ref, cpu) += adjust);
+	printk("cpu %d, adjust %d, ref %d\n", cpu, adjust, ref);
+
+	if (ref == 1 && adjust > 0) {
+		cpumask_set_cpu(cpu, &nohz_cpuset_mask);
+		/*
+		 * The mask update needs to be visible right away
+		 * so that this CPU is part of the cputime IPI
+		 * update right now.
+		 */
+		 smp_mb();
+	} else if (!ref) {
+		/*
+		 * The update to cpu_adaptive_nohz_ref must be
+		 * visible right away. So that once we restart the tick
+		 * from the IPI, it won't be stopped again due to cache
+		 * update lag.
+		 * FIXME: We probably need more to ensure this value is really
+		 * visible right away.
+		 */
+		smp_mb();
+		cpu_exit_nohz(cpu);
+		/*
+		 * Now that the tick has been restarted and cputimes
+		 * flushed, we don't need anymore to be part of the
+		 * cputime flush IPI.
+		 */
+		cpumask_clear_cpu(cpu, &nohz_cpuset_mask);
+	}
+}
+
+static void update_nohz_flag(struct cpuset *old_cs, struct cpuset *cs)
 {
 	int cpu;
-	int val;
+	int adjust;
 
 	if (is_adaptive_nohz(old_cs) == is_adaptive_nohz(cs))
 		return;
 
+	adjust = is_adaptive_nohz(cs) ? 1 : -1;
 	for_each_cpu(cpu, cs->cpus_allowed) {
-		if (is_adaptive_nohz(cs))
-			per_cpu(cpu_adaptive_nohz_ref, cpu) += 1;
-		else
-			per_cpu(cpu_adaptive_nohz_ref, cpu) -= 1;
-
-		val = per_cpu(cpu_adaptive_nohz_ref, cpu);
-
-		if (val == 1) {
-			cpumask_set_cpu(cpu, &nohz_cpuset_mask);
-			/*
-			 * The mask update needs to be visible right away
-			 * so that this CPU is part of the cputime IPI
-			 * update right now.
-			 */
-			 smp_mb();
-		} else if (!val) {
-			/*
-			 * The update to cpu_adaptive_nohz_ref must be
-			 * visible right away. So that once we restart the tick
-			 * from the IPI, it won't be stopped again due to cache
-			 * update lag.
-			 * FIXME: We probably need more to ensure this value is really
-			 * visible right away.
-			 */
-			smp_mb();
-			cpu_exit_nohz(cpu);
-			/*
-			 * Now that the tick has been restarted and cputimes
-			 * flushed, we don't need anymore to be part of the
-			 * cputime flush IPI.
-			 */
-			cpumask_clear_cpu(cpu, &nohz_cpuset_mask);
-		}
+		update_cpu_nohz_flag(cpu, adjust);
 	}
 }
+
+static void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
+{
+	int cpu;
+	cpumask_t cpus;
+
+	/*
+	 * Only bother if the cpuset has adaptive nohz
+	 */
+	if (!is_adaptive_nohz(cs))
+		return;
+
+	cpumask_xor(&cpus, old_cs->cpus_allowed, cs->cpus_allowed);
+
+	for_each_cpu(cpu, &cpus)
+		update_cpu_nohz_flag(cpu,
+			cpumask_test_cpu(cpu, cs->cpus_allowed) ? 1 : -1);
+}
 #else
+static inline void update_nohz_flag(struct cpuset *old_cs, struct cpuset *cs)
+{
+}
 static inline void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
 {
 }
@@ -1362,7 +1392,7 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	spread_flag_changed = ((is_spread_slab(cs) != is_spread_slab(trialcs))
 			|| (is_spread_page(cs) != is_spread_page(trialcs)));
 
-	update_nohz_cpus(cs, trialcs);
+	update_nohz_flag(cs, trialcs);
 
 	mutex_lock(&callback_mutex);
 	cs->flags = trialcs->flags;
@@ -2006,7 +2036,8 @@ static struct cgroup_subsys_state *cpuset_create(
 /*
  * If the cpuset being removed has its flag 'sched_load_balance'
  * enabled, then simulate turning sched_load_balance off, which
- * will call async_rebuild_sched_domains().
+ * will call async_rebuild_sched_domains(). Also update adaptive
+ * nohz flag.
  */
 
 static void cpuset_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
@@ -2016,6 +2047,8 @@ static void cpuset_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
 	if (is_sched_load_balance(cs))
 		update_flag(CS_SCHED_LOAD_BALANCE, cs, 0);
 
+	update_flag(CS_ADAPTIVE_NOHZ, cs, 0);
+
 	number_of_cpusets--;
 	free_cpumask_var(cs->cpus_allowed);
 	kfree(cs);

