Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab1KOQA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 11:00:58 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:45366 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463Ab1KOQAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 11:00:55 -0500
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com, pjt@google.com,
        cgroups@vger.kernel.org, Glauber Costa <glommer@parallels.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: [PATCH 4/4] provide a version of cpuacct statistics inside cpu cgroup
Date: Tue, 15 Nov 2011 13:59:17 -0200
Message-Id: <1321372757-1581-5-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1321372757-1581-1-git-send-email-glommer@parallels.com>
References: <1321372757-1581-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For users interested in using the information currently displayed
at cpuacct.stat, we provide it inside the cpu cgroup.

This have the advantage of accounting this information only once,
instead of twice, when there is no need to have an independent group
of tasks for controlling and accounting, leading to a lot less overhead.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Balbir Singh <bsingharora@gmail.com>
---
 kernel/sched.c |   43 ++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 934f631..99e806b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9151,6 +9151,11 @@ int sched_rt_handler(struct ctl_table *table, int write,
 	return ret;
 }
 
+static const char *cpuacct_stat_desc[] = {
+	[CPUACCT_STAT_USER] = "user",
+	[CPUACCT_STAT_SYSTEM] = "system",
+};
+
 #ifdef CONFIG_CGROUP_SCHED
 
 /* return corresponding task_group object of a cgroup */
@@ -9509,6 +9514,35 @@ static int cpu_set_sched_stats(struct cgroup *cgrp, struct cftype *cft, u64 val)
 	return 0;
 }
 
+static int cpu_cgroup_stats_show(struct cgroup *cgrp, struct cftype *cft,
+		struct cgroup_map_cb *cb)
+{
+	struct task_group *tg = cgroup_tg(cgrp);
+	int cpu;
+	s64 val = 0;
+
+	for_each_present_cpu(cpu) {
+		struct kernel_cpustat *kcpustat = per_cpu_ptr(tg->cpustat, cpu);
+		val += kcpustat->cpustat[USER];
+		val += kcpustat->cpustat[NICE];
+	}
+	val = cputime64_to_clock_t(val);
+	cb->fill(cb, cpuacct_stat_desc[CPUACCT_STAT_USER], val);
+
+	val = 0;
+	for_each_online_cpu(cpu) {
+		struct kernel_cpustat *kcpustat = per_cpu_ptr(tg->cpustat, cpu);
+		val += kcpustat->cpustat[SYSTEM];
+		val += kcpustat->cpustat[IRQ];
+		val += kcpustat->cpustat[SOFTIRQ];
+	}
+
+	val = cputime64_to_clock_t(val);
+	cb->fill(cb, cpuacct_stat_desc[CPUACCT_STAT_SYSTEM], val);
+
+	return 0;
+}
+
 static struct cftype cpu_files[] = {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	{
@@ -9545,6 +9579,10 @@ static struct cftype cpu_files[] = {
 		.write_u64 = cpu_rt_period_write_uint,
 	},
 #endif
+	{
+		.name = "acct_stat",
+		.read_map = cpu_cgroup_stats_show,
+	},
 };
 
 /*
@@ -9746,11 +9784,6 @@ static int cpuacct_percpu_seq_read(struct cgroup *cgroup, struct cftype *cft,
 	return 0;
 }
 
-static const char *cpuacct_stat_desc[] = {
-	[CPUACCT_STAT_USER] = "user",
-	[CPUACCT_STAT_SYSTEM] = "system",
-};
-
 static int cpuacct_stats_show(struct cgroup *cgrp, struct cftype *cft,
 		struct cgroup_map_cb *cb)
 {
-- 
1.7.6.4

