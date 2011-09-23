Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab1IWWZP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 18:25:15 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:29583 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567Ab1IWWZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 18:25:13 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com,
        Glauber Costa <glommer@parallels.com>
Subject: [RFD 4/9] Make total_forks per-cgroup
Date: Fri, 23 Sep 2011 19:20:27 -0300
Message-Id: <1316816432-9237-5-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1316816432-9237-1-git-send-email-glommer@parallels.com>
References: <1316816432-9237-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch counts the total number of forks per-cgroup.
The information is propagated to the parent, so the total
number of forks in the system, is the parent cgroup's one.

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 include/linux/sched.h |    1 +
 kernel/fork.c         |    9 ++++-----
 kernel/sched.c        |   35 +++++++++++++++++++++++++++++++++--
 3 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 64c5ba5..4ba9dde 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2716,6 +2716,7 @@ struct cgroup;
 struct cftype;
 int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
 			 struct seq_file *p);
+void task_group_new_fork(struct task_struct *p);
 #endif /* __KERNEL__ */
 
 #endif
diff --git a/kernel/fork.c b/kernel/fork.c
index 8e6b6f4..9e0d8a6 100644
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
@@ -1039,6 +1035,8 @@ static void posix_cpu_timers_init(struct task_struct *tsk)
 	INIT_LIST_HEAD(&tsk->cpu_timers[2]);
 }
 
+struct task_group *task_group(struct task_struct *p);
+
 /*
  * This creates a new process as a copy of the old one,
  * but does not actually start it yet.
@@ -1372,7 +1370,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		nr_threads++;
 	}
 
-	total_forks++;
+	task_group_new_fork(p);
+
 	spin_unlock(&current->sighand->siglock);
 	write_unlock_irq(&tasklist_lock);
 	proc_fork_connector(p);
diff --git a/kernel/sched.c b/kernel/sched.c
index a272257..9c6e44e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -278,6 +278,7 @@ struct task_group {
 #ifdef CONFIG_SCHED_AUTOGROUP
 	struct autogroup *autogroup;
 #endif
+	unsigned long total_forks;
 	struct kernel_stat __percpu *cpustat;
 };
 
@@ -641,6 +642,17 @@ struct kernel_stat *task_group_kstat(struct task_struct *p)
 
 	return tg->cpustat;
 }
+
+void task_group_new_fork(struct task_struct *p)
+{
+	struct task_group *tg = task_group(p);
+
+	do {
+		tg->total_forks++;
+		tg = tg->parent;
+	} while (tg);
+}
+
 /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 {
@@ -655,7 +667,17 @@ static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 #endif
 }
 
+static unsigned long task_group_total_forks(struct task_group *tg)
+{
+	return tg->total_forks;
+}
+
+
 #else /* CONFIG_CGROUP_SCHED */
+/*
+ * Protected counters by write_lock_irq(&tasklist_lock)
+ */
+unsigned long total_forks;	/* Handle normal Linux uptimes. */
 
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu) { }
 static inline struct task_group *task_group(struct task_struct *p)
@@ -663,6 +685,16 @@ static inline struct task_group *task_group(struct task_struct *p)
 	return NULL;
 }
 
+void task_group_new_fork(struct task_struct *p)
+{
+	total_forks++;
+}
+
+void task_group_total_forks(struct task_group *tg)
+{
+	return total_forks;
+}
+
 DEFINE_PER_CPU(struct kernel_stat, kstat);
 EXPORT_PER_CPU_SYMBOL(kstat);
 #endif /* CONFIG_CGROUP_SCHED */
@@ -8119,7 +8151,6 @@ void __init sched_init(void)
 		kstat->cpustat[IOWAIT_BASE] = 0;
 		kstat->cpustat[IOWAIT] = 0;
 	}
-
 #endif /* CONFIG_CGROUP_SCHED */
 
 	for_each_possible_cpu(i) {
@@ -9216,7 +9247,7 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft, struct seq_fil
 		"procs_blocked %lu\n",
 		nr_context_switches(),
 		(unsigned long)jif,
-		total_forks,
+		task_group_total_forks(tg),
 		nr_running(),
 		nr_iowait());
 
-- 
1.7.6

