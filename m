Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab0DGBWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 21:22:21 -0400
Received: from smtp-out.google.com ([74.125.121.35]:47435 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361Ab0DGBWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 21:22:15 -0400
From: Mike Chan <mike@android.com>
Cc: menage@google.com, balbir@linux.vnet.ibm.com, dwalker@fifo99.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Chan <mike@android.com>
Subject: [PATCH] sched: cpuacct: Track cpuusage for CPU frequencies
Date: Tue,  6 Apr 2010 18:21:59 -0700
Message-Id: <1270603319-28907-1-git-send-email-mike@android.com>
X-Mailer: git-send-email 1.7.0.1
X-System-Of-Record: true
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New file: cpuacct.cpufreq when CONFIG_CPU_FREQ_STATS is enabled.

cpuacct.cpufreq reports the CPU time (nanoseconds) spent at each CPU frequency

Maximum number of frequencies supported is 32. As future architectures are
added that support more than 32 frequency levels, CPUFREQ_TABLE_MAX in sched.c
needs to be updated.

Signed-off-by: Mike Chan <mike@android.com>
---
 Documentation/cgroups/cpuacct.txt |    3 +
 kernel/sched.c                    |  112 +++++++++++++++++++++++++++++++++++++
 2 files changed, 115 insertions(+), 0 deletions(-)

diff --git a/Documentation/cgroups/cpuacct.txt b/Documentation/cgroups/cpuacct.txt
index 8b93094..61c2bce 100644
--- a/Documentation/cgroups/cpuacct.txt
+++ b/Documentation/cgroups/cpuacct.txt
@@ -40,6 +40,9 @@ system: Time spent by tasks of the cgroup in kernel mode.
 
 user and system are in USER_HZ unit.
 
+cpuacct.cpufreq file gives the CPU time (in nanoseconds) spent at each CPU
+frequency.
+
 cpuacct controller uses percpu_counter interface to collect user and
 system times. This has two side effects:
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 528a105..96a214d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -71,6 +71,7 @@
 #include <linux/debugfs.h>
 #include <linux/ctype.h>
 #include <linux/ftrace.h>
+#include <linux/cpufreq.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -8817,6 +8818,12 @@ struct cgroup_subsys cpu_cgroup_subsys = {
  * (balbir@in.ibm.com).
  */
 
+#ifdef CONFIG_CPU_FREQ_STAT
+#define CPUFREQ_TABLE_MAX 32
+/* Table that represents cpu frequencies available */
+struct cpufreq_table { u64 freq[CPUFREQ_TABLE_MAX]; };
+#endif
+
 /* track cpu usage of a group of tasks and its child groups */
 struct cpuacct {
 	struct cgroup_subsys_state css;
@@ -8824,6 +8831,9 @@ struct cpuacct {
 	u64 __percpu *cpuusage;
 	struct percpu_counter cpustat[CPUACCT_STAT_NSTATS];
 	struct cpuacct *parent;
+#ifdef CONFIG_CPU_FREQ_STAT
+	struct cpufreq_table *cpufreq_table;
+#endif
 };
 
 struct cgroup_subsys cpuacct_subsys;
@@ -8856,6 +8866,10 @@ static struct cgroup_subsys_state *cpuacct_create(
 	if (!ca->cpuusage)
 		goto out_free_ca;
 
+#ifdef CONFIG_CPU_FREQ_STAT
+	ca->cpufreq_table = alloc_percpu(struct cpufreq_table);
+#endif
+
 	for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
 		if (percpu_counter_init(&ca->cpustat[i], 0))
 			goto out_free_counters;
@@ -8888,6 +8902,87 @@ cpuacct_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
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
+	policy = cpufreq_cpu_get(freq->cpu);
+	table = cpufreq_frequency_get_table(freq->cpu);
+	/*
+	 * Get the index of the frequency in the freq_table for this cpu.
+	 * The choic of which relation to use
+	 * CPUFREQ_RELATION_L (lowest frequency at or above target) or
+	 * CPUFREQ_RELATION_H (highest frequency below or at target)
+	 * is arbitrary. Reason being, the current speed is guaranteed to
+	 * exist within the table so we will always match exactly.
+	 */
+	ret = cpufreq_frequency_table_target(policy, table, policy->cur,
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
+		/*
+		 * Include all present cpus, even ones that are currently
+		 * offline. Otherwise statistics could be incorrect if a cpu
+		 * consistently cycles between on and offline for the lifetime
+		 * of the system.
+		 */
+		for_each_present_cpu(cpu) {
+			struct cpufreq_table *cpufreq_table;
+
+			cpufreq_table = per_cpu_ptr(ca->cpufreq_table, cpu);
+			table = cpufreq_frequency_get_table(cpu);
+
+			total += cpufreq_table->freq[i];
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
@@ -9003,6 +9098,12 @@ static struct cftype files[] = {
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
@@ -9031,6 +9132,17 @@ static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 
 	for (; ca; ca = ca->parent) {
 		u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
+#ifdef CONFIG_CPU_FREQ_STAT
+		struct cpufreq_table *cpufreq_table =
+			per_cpu_ptr(ca->cpufreq_table, cpu);
+
+		if (cpufreq_index > CPUFREQ_TABLE_MAX)
+			printk_once(KERN_WARNING "cpuacct_charge: "
+					"cpufreq_index: %d exceeds max table "
+					"size\n", cpufreq_index);
+		else
+			cpufreq_table->freq[cpufreq_index] += cputime;
+#endif
 		*cpuusage += cputime;
 	}
 
-- 
1.7.0.1

