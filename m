Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab1KAVUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 17:20:45 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:40494 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932395Ab1KAVUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 17:20:41 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com, pjt@google.com,
        fweisbec@gmail.com, Glauber Costa <glommer@parallels.com>
Subject: [PATCH v2 06/14] Make total_forks per-cgroup
Date: Tue,  1 Nov 2011 19:19:12 -0200
Message-Id: <1320182360-20043-7-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320182360-20043-1-git-send-email-glommer@parallels.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch counts the total number of forks per-cgroup.
The information is propagated to the parent, so the total
number of forks in the system, is the parent cgroup's one.

To achieve that, total_forks is made per-cpu. There is no
particular reason to do that, but by doing this, we are
able to bundle it inside the cpustat structure already
present.

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 include/linux/kernel_stat.h |    1 +
 include/linux/sched.h       |    1 +
 kernel/fork.c               |    7 ++-----
 kernel/sched.c              |    9 ++++++++-
 4 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 9b7463f..a0f1182 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -29,6 +29,7 @@ enum cpu_usage_stat {
 	GUEST_NICE,
 	STEAL_BASE,
 	IDLE_BASE,
+	TOTAL_FORKS,
 	NR_STATS,
 };
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 16713ea..2195ac7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2717,6 +2717,7 @@ struct cgroup;
 struct cftype;
 int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
 			 struct seq_file *p);
+void task_group_new_fork(struct task_struct *p);
 #endif /* __KERNEL__ */
 
 #endif
diff --git a/kernel/fork.c b/kernel/fork.c
index 8e6b6f4..ec2b729 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -76,10 +76,6 @@
 
 #include <trace/events/sched.h>
 
-/*
- * Protected counters by write_lock_irq(&tasklist_lock)
- */
-unsigned long total_forks;	/* Handle normal Linux uptimes. */
 int nr_threads;			/* The idle threads do not count.. */
 
 int max_threads;		/* tunable limit on nr_threads */
@@ -1372,7 +1368,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		nr_threads++;
 	}
 
-	total_forks++;
+	task_group_new_fork(p);
+
 	spin_unlock(&current->sighand->siglock);
 	write_unlock_irq(&tasklist_lock);
 	proc_fork_connector(p);
diff --git a/kernel/sched.c b/kernel/sched.c
index 7ffafc0..df0c4de 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -836,6 +836,11 @@ static inline void task_group_account_field(struct task_struct *p,
 #endif
 }
 
+void task_group_new_fork(struct task_struct *p)
+{
+	task_group_account_field(p, 1, TOTAL_FORKS);
+}
+
 static void update_rq_clock_task(struct rq *rq, s64 delta);
 
 static void update_rq_clock(struct rq *rq)
@@ -9648,6 +9653,7 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
 	u64 guest, guest_nice;
 	u64 sum = 0;
 	u64 sum_softirq = 0;
+	u64 total_forks = 0;
 	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
 	struct timespec boottime;
 #ifdef CONFIG_CGROUP_SCHED
@@ -9685,6 +9691,7 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
 		steal -= kcpustat->cpustat[STEAL_BASE];
 		guest += kcpustat->cpustat[GUEST];
 		guest_nice += kcpustat->cpustat[GUEST_NICE];
+		total_forks += kcpustat->cpustat[TOTAL_FORKS];
 		kstat_unlock();
 
 		for (j = 0; j < NR_SOFTIRQS; j++) {
@@ -9754,7 +9761,7 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
 	seq_printf(p,
 		"\nctxt %llu\n"
 		"btime %lu\n"
-		"processes %lu\n"
+		"processes %llu\n"
 		"procs_running %lu\n"
 		"procs_blocked %lu\n",
 		nr_context_switches(),
-- 
1.7.6.4

