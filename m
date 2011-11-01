Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab1KAVVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 17:21:32 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:22602 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932327Ab1KAVV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 17:21:28 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com, pjt@google.com,
        fweisbec@gmail.com, Glauber Costa <glommer@parallels.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: [PATCH v2 13/14] provide a version of cpuusage statistics inside cpu cgroup
Date: Tue,  1 Nov 2011 19:19:19 -0200
Message-Id: <1320182360-20043-14-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320182360-20043-1-git-send-email-glommer@parallels.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For users interested in using the information currently displayed
at cpuacct.usage and cpuaact.usage_per_cpu, we provide them inside
the cpu cgroup.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Balbir Singh <bsingharora@gmail.com>
---
 kernel/sched.c      |   83 +++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_fair.c |   10 ++++++
 kernel/sched_rt.c   |    4 ++
 3 files changed, 97 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d93cfd4..b9296cd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -303,6 +303,7 @@ struct task_group {
 
 	struct cfs_bandwidth cfs_bandwidth;
 	struct kernel_cpustat __percpu *cpustat;
+	u64 __percpu *cpuusage;
 	struct timespec start_time;
 };
 
@@ -344,6 +345,8 @@ struct cfs_rq {
 #ifndef CONFIG_64BIT
 	u64 min_vruntime_copy;
 #endif
+	u64 sum_exec_runtime;
+	u64 prev_sum_exec_runtime;
 
 	struct rb_root tasks_timeline;
 	struct rb_node *rb_leftmost;
@@ -547,7 +550,10 @@ struct rt_rq {
 	struct rq *rq;
 	struct list_head leaf_rt_rq_list;
 	struct task_group *tg;
+
 #endif
+	u64 sum_exec_runtime;
+	u64 prev_sum_exec_runtime;
 };
 
 #ifdef CONFIG_SMP
@@ -8359,6 +8365,10 @@ void __init sched_init(void)
 
 	root_task_group.start_time = (struct timespec){0, 0};
 	root_task_group.cpustat = &kernel_cpustat;
+
+	root_task_group.cpuusage = alloc_percpu(u64);
+	/* Failing that early an allocation means we're screwed anyway */
+	BUG_ON(!root_task_group.cpuusage);
 #endif /* CONFIG_CGROUP_SCHED */
 
 	for_each_possible_cpu(i) {
@@ -8796,6 +8806,7 @@ static void free_sched_group(struct task_group *tg)
 	free_rt_sched_group(tg);
 	autogroup_free(tg);
 	free_percpu(tg->cpustat);
+	free_percpu(tg->cpuusage);
 	kfree(tg);
 }
 
@@ -8816,6 +8827,10 @@ struct task_group *sched_create_group(struct task_group *parent)
 	if (!alloc_rt_sched_group(tg, parent))
 		goto err;
 
+	tg->cpuusage = alloc_percpu(u64);
+	if (!tg->cpuusage)
+		goto err;
+
 	tg->cpustat = alloc_percpu(struct kernel_cpustat);
 	if (!tg->cpustat)
 		goto err;
@@ -9629,6 +9644,65 @@ static int cpu_cgroup_stats_show(struct cgroup *cgrp, struct cftype *cft,
 	return 0;
 }
 
+static u64 cpu_cgroup_usage_cpu(struct cgroup *cgrp, int i)
+{
+	struct task_group *tg = cgroup_tg(cgrp);
+	u64 ret = 0;
+
+	ret = tg->cfs_rq[i]->sum_exec_runtime;
+
+	return ret;
+}
+
+static u64 cpu_cgroup_cpuusage_read(struct cgroup *cgrp, struct cftype *cft)
+{
+	u64 totalcpuusage = 0;
+	int i;
+
+	for_each_present_cpu(i)
+		totalcpuusage += cpu_cgroup_usage_cpu(cgrp, i);
+
+	return totalcpuusage;
+}
+
+static int cpu_cgroup_cpuusage_write(struct cgroup *cgrp, struct cftype *cftype,
+								u64 reset)
+{
+	int err = 0;
+	int i;
+	struct task_group *tg = cgroup_tg(cgrp);
+
+	if (reset) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	for_each_present_cpu(i)
+		if (tg == &root_task_group)
+			cpu_rq(i)->cfs.prev_sum_exec_runtime =
+						cpu_rq(i)->cfs.sum_exec_runtime;
+		else
+			tg->se[i]->prev_sum_exec_runtime =
+						tg->se[i]->sum_exec_runtime;
+
+out:
+	return err;
+}
+
+static int cpu_cgroup_percpu_seq_read(struct cgroup *cgroup, struct cftype *cft,
+				      struct seq_file *m)
+{
+	u64 percpu;
+	int i;
+
+	for_each_present_cpu(i) {
+		percpu = cpu_cgroup_usage_cpu(cgroup, i);
+		seq_printf(m, "%llu ", (unsigned long long) percpu);
+	}
+	seq_printf(m, "\n");
+	return 0;
+}
+
 static struct cftype cpu_files[] = {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	{
@@ -9673,6 +9747,15 @@ static struct cftype cpu_files[] = {
 		.name = "stat",
 		.read_map = cpu_cgroup_stats_show,
 	},
+	{
+		.name = "usage",
+		.read_u64 = cpu_cgroup_cpuusage_read,
+		.write_u64 = cpu_cgroup_cpuusage_write,
+	},
+	{
+		.name = "usage_percpu",
+		.read_seq_string = cpu_cgroup_percpu_seq_read,
+	},
 };
 
 /*
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5c9e679..030b8eb 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -560,6 +560,16 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 		      max((u64)delta_exec, curr->statistics.exec_max));
 
 	curr->sum_exec_runtime += delta_exec;
+
+	/*
+	 * sched_entities are moved around runqueues and cpus at all times.
+	 * we want to record the total exec time of a particular entity (curr)
+	 * but we are also interested in the total time this particular runqueue
+	 * got. So we have to increase the total runtime in two different locations
+	 */
+	if (static_branch(&sched_cgroup_enabled))
+		cfs_rq->sum_exec_runtime += delta_exec;
+
 	schedstat_add(cfs_rq, exec_clock, delta_exec);
 	delta_exec_weighted = calc_delta_fair(delta_exec, curr);
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 056cbd2..2edaeb4 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -686,6 +686,10 @@ static void update_curr_rt(struct rq *rq)
 	schedstat_set(curr->se.statistics.exec_max, max(curr->se.statistics.exec_max, delta_exec));
 
 	curr->se.sum_exec_runtime += delta_exec;
+
+	if (static_branch(&sched_cgroup_enabled))
+		rq->rt.sum_exec_runtime += delta_exec;
+
 	account_group_exec_runtime(curr, delta_exec);
 
 	curr->se.exec_start = rq->clock_task;
-- 
1.7.6.4

