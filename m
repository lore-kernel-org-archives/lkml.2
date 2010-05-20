Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab0ETSml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 14:42:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:25418 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900Ab0ETSmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 14:42:38 -0400
From: Mike Chan <mike@android.com>
Cc: menage@google.com, balbir@in.ibm.com, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org, trenn@suse.de,
       khilman@deeprootsystems.com, linux-omap@vger.kernel.org,
       Mike Chan <mike@android.com>
Subject: [PATCH v2 1/3] scheduler: cpuacct: Enable platform hooks to track cpuusage for CPU frequencies
Date: Thu, 20 May 2010 11:42:22 -0700
Message-Id: <1274380944-20947-2-git-send-email-mike@android.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1274380944-20947-1-git-send-email-mike@android.com>
References: <1274380944-20947-1-git-send-email-mike@android.com>
X-System-Of-Record: true
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V2:
- Rebased off of Thomas Renninger's cgroup_cpuacct refactoring.
- Renamed function struct to cpuacct_chrage_calls  from cpuacct_cpufreq_calls

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

Signed-off-by: Mike Chan <mike@android.com>
---
 Documentation/cgroups/cpuacct.txt |    4 +++
 include/linux/cpuacct.h           |   41 +++++++++++++++++++++++++++++++
 kernel/cgroup_cpuaccount.c        |   49 +++++++++++++++++++++++++++++++++++++
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
index 0000000..6205d29
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
+#ifdef CONFIG_CGROUP_CPUACCT
+
+#include <linux/cgroup.h>
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
+#endif /* CONFIG_CGROUPS */
+
+#endif /* _CPUACCT_H_ */
diff --git a/kernel/cgroup_cpuaccount.c b/kernel/cgroup_cpuaccount.c
index 0ad356a..11799a7 100644
--- a/kernel/cgroup_cpuaccount.c
+++ b/kernel/cgroup_cpuaccount.c
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 #include <linux/err.h>
+#include <linux/cpuacct.h>
 
 #include <asm/cputime.h>
 
@@ -26,8 +27,30 @@ struct cpuacct {
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
+int cpuacct_charge_register(struct cpuacct_charge_calls *fn)
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
@@ -62,8 +85,16 @@ static struct cgroup_subsys_state *cpuacct_create(
 		if (percpu_counter_init(&ca->cpustat[i], 0))
 			goto out_free_counters;
 
+	ca->cpufreq_fn = cpuacct_cpufreq;
+
+	/* If available, have platform code initalize cpu frequency data */
+	if (ca->cpufreq_fn && ca->cpufreq_fn->init)
+		ca->cpufreq_fn->init(&ca->cpuacct_data);
+
 	if (cgrp->parent)
 		ca->parent = cgroup_ca(cgrp->parent);
+	else
+		cpuacct_root = ca;
 
 	return &ca->css;
 
@@ -191,6 +222,16 @@ static int cpuacct_stats_show(struct cgroup *cgrp, struct cftype *cft,
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
@@ -205,6 +246,10 @@ static struct cftype files[] = {
 		.name = "stat",
 		.read_map = cpuacct_stats_show,
 	},
+	{
+		.name =  "cpufreq",
+		.read_map = cpuacct_cpufreq_show,
+	},
 };
 
 static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
@@ -234,6 +279,10 @@ void cpuacct_charge(struct task_struct *tsk, u64 cputime)
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
1.7.0.1

