Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab1JBTXx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 15:23:53 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:14414 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093Ab1JBTWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 15:22:32 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com,
        Glauber Costa <glommer@parallels.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: [PATCH 08/10] provide a version of cpuacct statistics inside cpu cgroup
Date: Sun,  2 Oct 2011 23:21:25 +0400
Message-Id: <1317583287-18300-9-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.2
In-Reply-To: <1317583287-18300-1-git-send-email-glommer@parallels.com>
References: <1317583287-18300-1-git-send-email-glommer@parallels.com>
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
index dec73c4..3f7c1fd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9106,6 +9106,40 @@ static u64 cpu_rt_period_read_uint(struct cgroup *cgrp, struct cftype *cft)
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
 
+static const char *cpuacct_stat_desc[] = {
+	[CPUACCT_STAT_USER] = "user",
+	[CPUACCT_STAT_SYSTEM] = "system",
+};
+
+static int cpu_cgroup_stats_show(struct cgroup *cgrp, struct cftype *cft,
+		struct cgroup_map_cb *cb)
+{
+	struct task_group *tg = cgroup_tg(cgrp);
+	int cpu;
+	s64 val = 0;
+
+	for_each_online_cpu(cpu) {
+		struct kernel_stat *kstat = per_cpu_ptr(tg->cpustat, cpu);
+		val += kstat->cpustat[USER];
+		val += kstat->cpustat[NICE];
+	}
+	val = cputime64_to_clock_t(val);
+	cb->fill(cb, cpuacct_stat_desc[CPUACCT_STAT_USER], val);
+
+	val = 0;
+	for_each_online_cpu(cpu) {
+		struct kernel_stat *kstat = per_cpu_ptr(tg->cpustat, cpu);
+		val += kstat->cpustat[SYSTEM];
+		val += kstat->cpustat[IRQ];
+		val += kstat->cpustat[SOFTIRQ];
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
@@ -9130,6 +9164,10 @@ static struct cftype cpu_files[] = {
 		.name = "proc.stat",
 		.read_seq_string = cpu_cgroup_proc_stat,
 	},
+	{
+		.name = "stat",
+		.read_map = cpu_cgroup_stats_show,
+	},
 };
 
 static int cpu_cgroup_populate(struct cgroup_subsys *ss, struct cgroup *cont)
@@ -9494,11 +9532,6 @@ static int cpuacct_percpu_seq_read(struct cgroup *cgroup, struct cftype *cft,
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
1.7.6

