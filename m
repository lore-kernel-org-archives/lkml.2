Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab1IWWZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 18:25:42 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:19180 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610Ab1IWWZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 18:25:41 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com,
        Glauber Costa <glommer@parallels.com>
Subject: [RFD 5/9] per-cgroup boot time
Date: Fri, 23 Sep 2011 19:20:28 -0300
Message-Id: <1316816432-9237-6-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1316816432-9237-1-git-send-email-glommer@parallels.com>
References: <1316816432-9237-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Record the time in which the cgroup was created. This can be
used to provide a more accurate boottime information in
cpuacct.proc.stat.

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 kernel/sched.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 9c6e44e..7612410 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -280,6 +280,7 @@ struct task_group {
 #endif
 	unsigned long total_forks;
 	struct kernel_stat __percpu *cpustat;
+	struct timespec start_time;
 };
 
 /* task_group_lock serializes the addition/removal of task groups */
@@ -8141,6 +8142,7 @@ void __init sched_init(void)
 	INIT_LIST_HEAD(&root_task_group.siblings);
 	autogroup_init(&init_task);
 
+	root_task_group.start_time = (struct timespec){0, 0};
 	root_task_group.cpustat = alloc_percpu(struct kernel_stat);
 	/* Failing that early an allocation means we're screwed anyway */
 	BUG_ON(!root_task_group.cpustat);
@@ -8619,6 +8621,8 @@ struct task_group *sched_create_group(struct task_group *parent)
 		kstat->cpustat[IOWAIT_BASE] = root_kstat->cpustat[IOWAIT];
 	}
 
+	get_monotonic_boottime(&tg->start_time);
+
 	spin_lock_irqsave(&task_group_lock, flags);
 	list_add_rcu(&tg->list, &task_groups);
 
@@ -9154,6 +9158,7 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft, struct seq_fil
 		irq = softirq = steal = cputime64_zero;
 	guest = guest_nice = cputime64_zero;
 	getboottime(&boottime);
+	boottime = timespec_add(boottime, tg->start_time);
 	jif = boottime.tv_sec;
 
 	for_each_possible_cpu(i) {
-- 
1.7.6

