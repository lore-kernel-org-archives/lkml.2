Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab2DCJIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 05:08:31 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:53513 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751769Ab2DCJIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 05:08:30 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX185fCxnW1Y5yNik73BiU1usLhyQG5CZBNiKUThD2W
	woSkgaQQSCgL3s
Message-ID: <1333444106.9072.4.camel@marge.simpson.net>
Subject: [patch] sched,rt: non-isolated cores lift isolcpus throttle for
 CONFIG_RT_GROUP_SCHED
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 03 Apr 2012 11:08:26 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/patch/hack.  Better ideas?

When CONFIG_RT_GROUP_SCHED is enabled, isolcpus have no replentishment timer
running, and unlike !CONFIG_RT_GROUP_SCHED, are not in rd->span of the cpu
running replentishment.  If you trigger the throttle, you're rewarded with a
dead box.  Should the user reassign cpus to a domain, they become sane again,
replentishment starts/stops as usual. 

Signed-off-by: Mike Galbraith <efault@gmx.de>
---
 kernel/sched/core.c  |   15 ++++++++++++++-
 kernel/sched/rt.c    |   16 ++++++++++++++--
 kernel/sched/sched.h |    5 +++++
 3 files changed, 33 insertions(+), 3 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5877,6 +5877,14 @@ cpu_attach_domain(struct sched_domain *s
 
 	sched_domain_debug(sd, cpu);
 
+#ifdef CONFIG_RT_GROUP_SCHED
+	/* If the cpu was an isolcpu, it no longer is. */
+	if (sd) {
+		cpumask_clear_cpu(cpu, cpu_isolated_map);
+		nr_isolated_cpus = cpumask_weight(cpu_isolated_map);
+	}
+#endif
+
 	rq_attach_root(rq, rd);
 	tmp = rq->sd;
 	rcu_assign_pointer(rq->sd, sd);
@@ -5886,13 +5894,18 @@ cpu_attach_domain(struct sched_domain *s
 }
 
 /* cpus with isolated domains */
-static cpumask_var_t cpu_isolated_map;
+cpumask_var_t cpu_isolated_map;
+
+__read_mostly int nr_isolated_cpus;
 
 /* Setup the mask of cpus configured for isolated domains */
 static int __init isolated_cpu_setup(char *str)
 {
 	alloc_bootmem_cpumask_var(&cpu_isolated_map);
 	cpulist_parse(str, cpu_isolated_map);
+#ifdef CONFIG_RT_GROUP_SCHED
+	nr_isolated_cpus = cpumask_weight(cpu_isolated_map);
+#endif
 	return 1;
 }
 
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -778,10 +778,11 @@ static inline int balance_runtime(struct
 
 static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 {
-	int i, idle = 1, throttled = 0;
+	int i, idle = 1, throttled = 0, isol_cpus = nr_isolated_cpus;
 	const struct cpumask *span;
 
 	span = sched_rt_period_mask();
+do_isolcpus:
 	for_each_cpu(i, span) {
 		int enqueue = 0;
 		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);
@@ -792,7 +793,7 @@ static int do_sched_rt_period_timer(stru
 			u64 runtime;
 
 			raw_spin_lock(&rt_rq->rt_runtime_lock);
-			if (rt_rq->rt_throttled)
+			if (rt_rq->rt_throttled && span != cpu_isolated_map)
 				balance_runtime(rt_rq);
 			runtime = rt_rq->rt_runtime;
 			rt_rq->rt_time -= min(rt_rq->rt_time, overrun*runtime);
@@ -823,6 +824,17 @@ static int do_sched_rt_period_timer(stru
 		raw_spin_unlock(&rq->lock);
 	}
 
+	/*
+	 * Hack: unthrottle isolcpus for RT_GROUP_SCHED.  No replentishment
+	 * timer is running on isolcpus, and unlike !RT_GROUP_SCHED, they're
+	 * not in the rd->span of the cpu running the timer.
+	 */
+	if (isol_cpus) {
+		span = cpu_isolated_map;
+		isol_cpus = 0;
+		goto do_isolcpus;
+	}
+
 	if (!throttled && (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF))
 		return 1;
 
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -572,6 +572,11 @@ static inline void set_task_rq(struct ta
 #endif
 }
 
+/* cpus with isolated domains */
+extern  cpumask_var_t cpu_isolated_map;
+
+extern __read_mostly int nr_isolated_cpus;
+
 #else /* CONFIG_CGROUP_SCHED */
 
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu) { }


