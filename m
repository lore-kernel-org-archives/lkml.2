Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab1IWWZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 18:25:43 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:20296 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab1IWWZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 18:25:41 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com,
        Glauber Costa <glommer@parallels.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: [RFD 7/9] provide a version of cpuacct statistics inside cpu cgroup
Date: Fri, 23 Sep 2011 19:20:30 -0300
Message-Id: <1316816432-9237-8-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1316816432-9237-1-git-send-email-glommer@parallels.com>
References: <1316816432-9237-1-git-send-email-glommer@parallels.com>
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
 kernel/sched.c |   42 +++++++++++++++++++++++++++++++++++++-----
 1 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8a510ab..b687441 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9296,6 +9296,39 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft, struct seq_fil
 
 
 
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
 static struct cftype cpu_files[] = {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	{
@@ -9320,6 +9353,10 @@ static struct cftype cpu_files[] = {
 		.name = "proc.stat",
 		.read_seq_string = cpu_cgroup_proc_stat,
 	},
+	{
+		.name = "stat",
+		.read_map = cpu_cgroup_stats_show,
+	},
 };
 
 static int cpu_cgroup_populate(struct cgroup_subsys *ss, struct cgroup *cont)
@@ -9503,11 +9540,6 @@ static int cpuacct_percpu_seq_read(struct cgroup *cgroup, struct cftype *cft,
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

