Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab0KTCKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 21:10:06 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49946 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756564Ab0KTCJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 21:09:22 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Mike Chan <mike@android.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 3/5] scheduler: cpuacct: Enable platform hooks to track cpuusage for CPU frequencies
Date: Fri, 19 Nov 2010 18:08:52 -0800
Message-Id: <1290218934-8544-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1290218934-8544-1-git-send-email-john.stultz@linaro.org>
References: <1290218934-8544-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Chan <mike@android.com>

Introduce new platform callback hooks for cpuacct for tracking CPU frequencies

Not all platforms / architectures have a set CPU_FREQ_TABLE defined
for CPU transition speeds. In order to track time spent in at various
CPU frequencies, we enable platform callbacks from cpuacct for this accounting.

Architectures that support overclock boosting, or don't have pre-defined
frequency tables can implement their own bucketing system that makes sense
given their cpufreq scaling abilities.

New file:
cpuacct.cpufreq reports the CPU time (in nanoseconds) spent at each CPU
frequency.

CC: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>
Change-Id: I10a80b3162e6fff3a8a2f74dd6bb37e88b12ba96
Signed-off-by: Mike Chan <mike@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 Documentation/cgroups/cpuacct.txt |    4 +++
 include/linux/cpuacct.h           |   41 +++++++++++++++++++++++++++++++
 kernel/sched.c                    |   49 +++++++++++++++++++++++++++++++++++++
 3 files changed, 94 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/cpuacct.h

diff --git a/Documentation/cgroups/cpuacct.txt b/Documentation/cgroups/cpuacct.txt
index 8b93094..600d2d0 100644
--- a/Documentation/cgroups/cpuacct.txt
+++ b/Documentation/cgroups/cpuacct.txt
@@ -40,6 +40,10 @@ system: Time spent by tasks of the cgroup in kernel mode.
 
 user and system are in USER_HZ unit.
 
+cpuacct.cpufreq file gives CPU time (in nanoseconds) spent at each CPU
+frequency. Platform hooks must be implemented inorder to properly track
+time at each CPU frequency.
+
 cpuacct controller uses percpu_counter interface to collect user and
 system times. This has two side effects:
 
diff --git a/include/linux/cpuacct.h b/include/linux/cpuacct.h
new file mode 100644
index 0000000..560df02
--- /dev/null
+++ b/include/linux/cpuacct.h
@@ -0,0 +1,41 @@
+/* include/linux/cpuacct.h
+ *
+ * Copyright (C) 2010 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _CPUACCT_H_
+#define _CPUACCT_H_
+
+#include <linux/cgroup.h>
+
+#ifdef CONFIG_CGROUP_CPUACCT
+
+/*
+ * Platform specific CPU frequency hooks for cpuacct. These functions are
+ * called from the scheduler.
+ */
+struct cpuacct_charge_calls {
+	/*
+	 * Platforms can take advantage of this data and use
+	 * per-cpu allocations if necessary.
+	 */
+	void (*init) (void **cpuacct_data);
+	void (*charge) (void *cpuacct_data,  u64 cputime, unsigned int cpu);
+	void (*show) (void *cpuacct_data, struct cgroup_map_cb *cb);
+};
+
+int cpuacct_charge_register(struct cpuacct_charge_calls *fn);
+
+#endif /* CONFIG_CGROUP_CPUACCT */
+
+#endif // _CPUACCT_H_
diff --git a/kernel/sched.c b/kernel/sched.c
index c99bbb2..35055fc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -72,6 +72,7 @@
 #include <linux/ctype.h>
 #include <linux/ftrace.h>
 #include <linux/slab.h>
+#include <linux/cpuacct.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -9082,8 +9083,30 @@ struct cpuacct {
 	u64 __percpu *cpuusage;
 	struct percpu_counter cpustat[CPUACCT_STAT_NSTATS];
 	struct cpuacct *parent;
+	struct cpuacct_charge_calls *cpufreq_fn;
+	void *cpuacct_data;
 };
 
+static struct cpuacct *cpuacct_root;
+
+/* Default calls for cpufreq accounting */
+static struct cpuacct_charge_calls *cpuacct_cpufreq;
+int cpuacct_register_cpufreq(struct cpuacct_charge_calls *fn)
+{
+	cpuacct_cpufreq = fn;
+
+	/*
+	 * Root node is created before platform can register callbacks,
+	 * initalize here.
+	 */
+	if (cpuacct_root && fn) {
+		cpuacct_root->cpufreq_fn = fn;
+		if (fn->init)
+			fn->init(&cpuacct_root->cpuacct_data);
+	}
+	return 0;
+}
+
 struct cgroup_subsys cpuacct_subsys;
 
 /* return cpu accounting group corresponding to this container */
@@ -9118,8 +9141,16 @@ static struct cgroup_subsys_state *cpuacct_create(
 		if (percpu_counter_init(&ca->cpustat[i], 0))
 			goto out_free_counters;
 
+	ca->cpufreq_fn = cpuacct_cpufreq;
+
+	/* If available, have platform code initalize cpu frequency table */
+	if (ca->cpufreq_fn && ca->cpufreq_fn->init)
+		ca->cpufreq_fn->init(&ca->cpuacct_data);
+
 	if (cgrp->parent)
 		ca->parent = cgroup_ca(cgrp->parent);
+	else
+		cpuacct_root = ca;
 
 	return &ca->css;
 
@@ -9247,6 +9278,16 @@ static int cpuacct_stats_show(struct cgroup *cgrp, struct cftype *cft,
 	return 0;
 }
 
+static int cpuacct_cpufreq_show(struct cgroup *cgrp, struct cftype *cft,
+		struct cgroup_map_cb *cb)
+{
+	struct cpuacct *ca = cgroup_ca(cgrp);
+	if (ca->cpufreq_fn && ca->cpufreq_fn->show)
+		ca->cpufreq_fn->show(ca->cpuacct_data, cb);
+
+	return 0;
+}
+
 static struct cftype files[] = {
 	{
 		.name = "usage",
@@ -9261,6 +9302,10 @@ static struct cftype files[] = {
 		.name = "stat",
 		.read_map = cpuacct_stats_show,
 	},
+	{
+		.name =  "cpufreq",
+		.read_map = cpuacct_cpufreq_show,
+	},
 };
 
 static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
@@ -9290,6 +9335,10 @@ static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 	for (; ca; ca = ca->parent) {
 		u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
 		*cpuusage += cputime;
+
+		/* Call back into platform code to account for CPU speeds */
+		if (ca->cpufreq_fn && ca->cpufreq_fn->charge)
+			ca->cpufreq_fn->charge(ca->cpuacct_data, cputime, cpu);
 	}
 
 	rcu_read_unlock();
-- 
1.7.3.2.146.gca209

