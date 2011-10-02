Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab1JBTXm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 15:23:42 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:25203 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183Ab1JBTWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 15:22:34 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH 06/10] per-cgroup boot time
Date: Sun,  2 Oct 2011 23:21:23 +0400
Message-Id: <1317583287-18300-7-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.2
In-Reply-To: <1317583287-18300-1-git-send-email-glommer@parallels.com>
References: <1317583287-18300-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Record the time in which the cgroup was created. This can be
used to provide a more accurate boottime information in
cpuacct.proc.stat.

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 kernel/sched.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 5a8181e..a2554b7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -279,6 +279,7 @@ struct task_group {
 	struct autogroup *autogroup;
 #endif
 	struct kernel_stat __percpu *cpustat;
+	struct timespec start_time;
 };
 
 /* task_group_lock serializes the addition/removal of task groups */
@@ -8127,6 +8128,7 @@ void __init sched_init(void)
 	INIT_LIST_HEAD(&root_task_group.siblings);
 	autogroup_init(&init_task);
 
+	root_task_group.start_time = (struct timespec){0, 0};
 	root_task_group.cpustat = alloc_percpu(struct kernel_stat);
 	/* Failing that early an allocation means we're screwed anyway */
 	BUG_ON(!root_task_group.cpustat);
@@ -8598,6 +8600,8 @@ struct task_group *sched_create_group(struct task_group *parent)
 		kstat->cpustat[IOWAIT_BASE] = root_kstat->cpustat[IOWAIT];
 	}
 
+	get_monotonic_boottime(&tg->start_time);
+
 	spin_lock_irqsave(&task_group_lock, flags);
 	list_add_rcu(&tg->list, &task_groups);
 
@@ -9182,6 +9186,9 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
 		irq = softirq = steal = 0;
 	guest = guest_nice = 0;
 	getboottime(&boottime);
+#ifdef CONFIG_CGROUP_SCHED
+	boottime = timespec_add(boottime, tg->start_time);
+#endif
 	jif = boottime.tv_sec;
 
 	for_each_possible_cpu(i) {
-- 
1.7.6

