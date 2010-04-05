Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab0DETdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 15:33:44 -0400
Received: from smtp-out.google.com ([74.125.121.35]:39000 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114Ab0DETdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 15:33:38 -0400
From: Mike Chan <mike@android.com>
Cc: menage@google.com, balbir@in.ibm.com, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mike Chan <mike@android.com>
Subject: [RFC][PATCH] sched: cpuacct: Track cpuusage per cpu frequency
Date: Mon,  5 Apr 2010 12:33:24 -0700
Message-Id: <1270496004-9715-1-git-send-email-mike@android.com>
X-Mailer: git-send-email 1.7.0.1
X-System-Of-Record: true
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New file: cpuacct.cpufreq when CONFIG_CPU_FREQ_STATS is enabled.

cpuacct.cpufreq accounts for cpu time per-cpu frequency, time is exported
in nano-seconds

We do not know the cpufreq table size at compile time.
So a new config option CONFIG_CPUACCT_CPUFREQ_TABLE_MAX is intruduced,
to determine the cpufreq table per-cpu in the cpuacct struct.

Signed-off-by: Mike Chan <mike@android.com>
---
 init/Kconfig   |    5 +++
 kernel/sched.c |   99 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 104 insertions(+), 0 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index eb77e8c..e1e86df 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -534,6 +534,11 @@ config CGROUP_CPUACCT
 	  Provides a simple Resource Controller for monitoring the
 	  total CPU consumed by the tasks in a cgroup.
 
+config CPUACCT_CPUFREQ_TABLE_MAX
+	int "Max CPUFREQ table size"
+	depends on CGROUP_CPUACCT && CPU_FREQ_TABLE
+	default 32
+
 config RESOURCE_COUNTERS
 	bool "Resource counters"
 	help
diff --git a/kernel/sched.c b/kernel/sched.c
index 528a105..a0b56b5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -71,6 +71,7 @@
 #include <linux/debugfs.h>
 #include <linux/ctype.h>
 #include <linux/ftrace.h>
+#include <linux/cpufreq.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -8817,6 +8818,11 @@ struct cgroup_subsys cpu_cgroup_subsys = {
  * (balbir@in.ibm.com).
  */
 
+#ifdef CONFIG_CPU_FREQ_STAT
+/* The alloc_percpu macro uses typeof so we must define a type here. */
+typedef struct { u64 usage[CONFIG_CPUACCT_CPUFREQ_TABLE_MAX]; } cpufreq_usage_t;
+#endif
+
 /* track cpu usage of a group of tasks and its child groups */
 struct cpuacct {
 	struct cgroup_subsys_state css;
@@ -8824,6 +8830,10 @@ struct cpuacct {
 	u64 __percpu *cpuusage;
 	struct percpu_counter cpustat[CPUACCT_STAT_NSTATS];
 	struct cpuacct *parent;
+#ifdef CONFIG_CPU_FREQ_STAT
+	/* cpufreq_usage is a pointer to an array of u64-types on every cpu */
+	cpufreq_usage_t *cpufreq_usage;
+#endif
 };
 
 struct cgroup_subsys cpuacct_subsys;
@@ -8856,6 +8866,10 @@ static struct cgroup_subsys_state *cpuacct_create(
 	if (!ca->cpuusage)
 		goto out_free_ca;
 
+#ifdef CONFIG_CPU_FREQ_STAT
+	ca->cpufreq_usage = alloc_percpu(cpufreq_usage_t);
+#endif
+
 	for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
 		if (percpu_counter_init(&ca->cpustat[i], 0))
 			goto out_free_counters;
@@ -8888,6 +8902,74 @@ cpuacct_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
 	kfree(ca);
 }
 
+#ifdef CONFIG_CPU_FREQ_STAT
+static int cpufreq_index;
+static int cpuacct_cpufreq_notify(struct notifier_block *nb, unsigned long val,
+					void *data)
+{
+	int ret;
+	struct cpufreq_policy *policy;
+	struct cpufreq_freqs *freq = data;
+	struct cpufreq_frequency_table *table;
+
+	if (val != CPUFREQ_POSTCHANGE)
+		return 0;
+
+	/* Update cpufreq_index with current speed */
+	table = cpufreq_frequency_get_table(freq->cpu);
+	policy = cpufreq_cpu_get(freq->cpu);
+	ret = cpufreq_frequency_table_target(policy, table,
+			cpufreq_quick_get(freq->cpu),
+			CPUFREQ_RELATION_L, &cpufreq_index);
+	cpufreq_cpu_put(policy);
+	return ret;
+}
+
+static struct notifier_block cpufreq_notifier = {
+	.notifier_call = cpuacct_cpufreq_notify,
+};
+
+static __init int cpuacct_init(void)
+{
+	return cpufreq_register_notifier(&cpufreq_notifier,
+					CPUFREQ_TRANSITION_NOTIFIER);
+}
+
+module_init(cpuacct_init);
+
+static int cpuacct_cpufreq_show(struct cgroup *cgrp, struct cftype *cft,
+		struct cgroup_map_cb *cb)
+{
+	int i;
+	unsigned int cpu;
+	char buf[32];
+	struct cpuacct *ca = cgroup_ca(cgrp);
+	struct cpufreq_frequency_table *table =
+		cpufreq_frequency_get_table(smp_processor_id());
+
+	for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
+		u64 total = 0;
+
+		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
+			continue;
+
+		for_each_present_cpu(cpu) {
+			cpufreq_usage_t *cpufreq_usage;
+
+			cpufreq_usage = per_cpu_ptr(ca->cpufreq_usage, cpu);
+			table = cpufreq_frequency_get_table(cpu);
+
+			total += cpufreq_usage->usage[i];
+		}
+
+		snprintf(buf, sizeof(buf), "%d", table[i].frequency);
+		cb->fill(cb, buf, total);
+	}
+
+	return 0;
+}
+#endif
+
 static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu)
 {
 	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
@@ -9003,6 +9085,12 @@ static struct cftype files[] = {
 		.name = "stat",
 		.read_map = cpuacct_stats_show,
 	},
+#ifdef CONFIG_CPU_FREQ_STAT
+	{
+		.name = "cpufreq",
+		.read_map = cpuacct_cpufreq_show,
+	},
+#endif
 };
 
 static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
@@ -9031,6 +9119,17 @@ static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 
 	for (; ca; ca = ca->parent) {
 		u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
+#ifdef CONFIG_CPU_FREQ_STAT
+		cpufreq_usage_t *cpufreq_usage =
+			per_cpu_ptr(ca->cpufreq_usage, cpu);
+
+		if (cpufreq_index > CONFIG_CPUACCT_CPUFREQ_TABLE_MAX)
+			printk_once(KERN_WARNING "cpuacct_charge: "
+					"cpufreq_index: %d exceeds max table "
+					"size\n", cpufreq_index);
+		else
+			cpufreq_usage->usage[cpufreq_index] += cputime;
+#endif
 		*cpuusage += cputime;
 	}
 
-- 
1.7.0.1

