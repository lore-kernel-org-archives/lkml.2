Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab1KAVUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 17:20:52 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:7851 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932395Ab1KAVUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 17:20:47 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com, pjt@google.com,
        fweisbec@gmail.com, Glauber Costa <glommer@parallels.com>
Subject: [PATCH v2 07/14] per-cgroup boot time
Date: Tue,  1 Nov 2011 19:19:13 -0200
Message-Id: <1320182360-20043-8-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320182360-20043-1-git-send-email-glommer@parallels.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Record the time in which the cgroup was created. This can be
used to provide a more accurate boottime information in
cpuacct.proc.stat.

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 kernel/sched.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index df0c4de..7dd4dea 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -303,6 +303,7 @@ struct task_group {
 
 	struct cfs_bandwidth cfs_bandwidth;
 	struct kernel_cpustat __percpu *cpustat;
+	struct timespec start_time;
 };
 
 /* task_group_lock serializes the addition/removal of task groups */
@@ -8293,6 +8294,7 @@ void __init sched_init(void)
 	INIT_LIST_HEAD(&root_task_group.siblings);
 	autogroup_init(&init_task);
 
+	root_task_group.start_time = (struct timespec){0, 0};
 	root_task_group.cpustat = &kernel_cpustat;
 #endif /* CONFIG_CGROUP_SCHED */
 
@@ -8767,6 +8769,8 @@ struct task_group *sched_create_group(struct task_group *parent)
 		kstat_unlock();
 	}
 
+	get_monotonic_boottime(&tg->start_time);
+
 	spin_lock_irqsave(&task_group_lock, flags);
 	list_add_rcu(&tg->list, &task_groups);
 
@@ -9669,6 +9673,10 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
 		irq = softirq = steal = 0;
 	guest = guest_nice = 0;
 	getboottime(&boottime);
+#ifdef CONFIG_CGROUP_SCHED
+	if (static_branch(&sched_cgroup_enabled))
+		boottime = timespec_add(boottime, tg->start_time);
+#endif
 	jif = boottime.tv_sec;
 
 	for_each_possible_cpu(i) {
-- 
1.7.6.4

