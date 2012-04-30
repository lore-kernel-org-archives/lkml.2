Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab2EAADx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 20:03:53 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:51303 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab2EAADt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 20:03:49 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org
Cc: Hakan Akkan <hakanakkan@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 27/41] nohz/cpuset: enable addition&removal of cpus while in adaptive nohz mode
Date: Tue,  1 May 2012 01:55:01 +0200
Message-Id: <1335830115-14335-28-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hakan Akkan <hakanakkan@gmail.com>

Currently modifying cpuset.cpus mask of a cgroup does not
update the reference counters for adaptive nohz mode if the
cpuset already had cpuset.adaptive_nohz == 1. Fix it so that
cpus can be added or removed from a adaptive_nohz cpuset.

Signed-off-by: Hakan Akkan <hakanakkan@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/cpuset.c |  106 +++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 69 insertions(+), 37 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index aa8304d..148d138 100644
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
+	update_nohz_cpus(cs, trialcs);
+
 	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
 	if (retval)
 		return retval;
@@ -1247,51 +1254,73 @@ static void cpu_exit_nohz(int cpu)
 	preempt_enable();
 }
 
-static void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
+static void update_cpu_nohz_flag(int cpu, int adjust)
+{
+	int ref = (per_cpu(cpu_adaptive_nohz_ref, cpu) += adjust);
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
@@ -1362,7 +1391,7 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	spread_flag_changed = ((is_spread_slab(cs) != is_spread_slab(trialcs))
 			|| (is_spread_page(cs) != is_spread_page(trialcs)));
 
-	update_nohz_cpus(cs, trialcs);
+	update_nohz_flag(cs, trialcs);
 
 	mutex_lock(&callback_mutex);
 	cs->flags = trialcs->flags;
@@ -2006,7 +2035,8 @@ static struct cgroup_subsys_state *cpuset_create(
 /*
  * If the cpuset being removed has its flag 'sched_load_balance'
  * enabled, then simulate turning sched_load_balance off, which
- * will call async_rebuild_sched_domains().
+ * will call async_rebuild_sched_domains(). Also update adaptive
+ * nohz flag.
  */
 
 static void cpuset_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
@@ -2016,6 +2046,8 @@ static void cpuset_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
 	if (is_sched_load_balance(cs))
 		update_flag(CS_SCHED_LOAD_BALANCE, cs, 0);
 
+	update_flag(CS_ADAPTIVE_NOHZ, cs, 0);
+
 	number_of_cpusets--;
 	free_cpumask_var(cs->cpus_allowed);
 	kfree(cs);
-- 
1.7.5.4

