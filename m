Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab1AGRAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 12:00:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48431 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399Ab1AGRAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 12:00:46 -0500
Date: Fri, 7 Jan 2011 18:00:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20110107170034.GA8736@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.3 required=5.9 tests=BAYES_00,FUZZY_VPILL autolearn=no SpamAssassin version=3.2.5
	0.7 FUZZY_VPILL            BODY: Attempt to obfuscate words in spam
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

This also includes a commit to fix the function-local statics you noticed yesterday.

 Thanks,

	Ingo

------------------>
Hillf Danton (1):
      sched: Fix strncmp operation

Mike Galbraith (2):
      sched: Fix struct autogroup memory leak
      sched: Move sched_autogroup_exit() to free_signal_struct()

Peter Zijlstra (1):
      sched: Constify function scope static struct sched_param usage

Yong Zhang (2):
      sched: Consolidate the name of root_task_group and init_task_group
      sched: Mark autogroup_init() __init


 include/linux/sched.h         |    2 +-
 kernel/fork.c                 |    7 ++---
 kernel/irq/manage.c           |    2 +-
 kernel/kthread.c              |    2 +-
 kernel/sched.c                |   45 ++++++++++++++++++++---------------------
 kernel/sched_autogroup.c      |    8 +++---
 kernel/softirq.c              |    2 +-
 kernel/trace/trace_selftest.c |    2 +-
 8 files changed, 34 insertions(+), 36 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 777cd01..341acbb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2511,7 +2511,7 @@ extern void normalize_rt_tasks(void);
 
 #ifdef CONFIG_CGROUP_SCHED
 
-extern struct task_group init_task_group;
+extern struct task_group root_task_group;
 
 extern struct task_group *sched_create_group(struct task_group *parent);
 extern void sched_destroy_group(struct task_group *tg);
diff --git a/kernel/fork.c b/kernel/fork.c
index 7d164e2..dc1a8bb 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -169,15 +169,14 @@ EXPORT_SYMBOL(free_task);
 static inline void free_signal_struct(struct signal_struct *sig)
 {
 	taskstats_tgid_free(sig);
+	sched_autogroup_exit(sig);
 	kmem_cache_free(signal_cachep, sig);
 }
 
 static inline void put_signal_struct(struct signal_struct *sig)
 {
-	if (atomic_dec_and_test(&sig->sigcnt)) {
-		sched_autogroup_exit(sig);
+	if (atomic_dec_and_test(&sig->sigcnt))
 		free_signal_struct(sig);
-	}
 }
 
 void __put_task_struct(struct task_struct *tsk)
@@ -1318,7 +1317,7 @@ bad_fork_cleanup_mm:
 	}
 bad_fork_cleanup_signal:
 	if (!(clone_flags & CLONE_THREAD))
-		put_signal_struct(p->signal);
+		free_signal_struct(p->signal);
 bad_fork_cleanup_sighand:
 	__cleanup_sighand(p->sighand);
 bad_fork_cleanup_fs:
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 91a5fa2..0caa59f 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -577,7 +577,7 @@ irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action) { }
  */
 static int irq_thread(void *data)
 {
-	static struct sched_param param = {
+	static const struct sched_param param = {
 		.sched_priority = MAX_USER_RT_PRIO/2,
 	};
 	struct irqaction *action = data;
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 5355cfd..c55afba 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -148,7 +148,7 @@ struct task_struct *kthread_create(int (*threadfn)(void *data),
 	wait_for_completion(&create.done);
 
 	if (!IS_ERR(create.result)) {
-		static struct sched_param param = { .sched_priority = 0 };
+		static const struct sched_param param = { .sched_priority = 0 };
 		va_list args;
 
 		va_start(args, namefmt);
diff --git a/kernel/sched.c b/kernel/sched.c
index 0494908..a0eb094 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -278,14 +278,12 @@ struct task_group {
 #endif
 };
 
-#define root_task_group init_task_group
-
 /* task_group_lock serializes the addition/removal of task groups */
 static DEFINE_SPINLOCK(task_group_lock);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
-# define INIT_TASK_GROUP_LOAD	NICE_0_LOAD
+# define ROOT_TASK_GROUP_LOAD	NICE_0_LOAD
 
 /*
  * A weight of 0 or 1 can cause arithmetics problems.
@@ -298,13 +296,13 @@ static DEFINE_SPINLOCK(task_group_lock);
 #define MIN_SHARES	2
 #define MAX_SHARES	(1UL << 18)
 
-static int init_task_group_load = INIT_TASK_GROUP_LOAD;
+static int root_task_group_load = ROOT_TASK_GROUP_LOAD;
 #endif
 
 /* Default task group.
  *	Every task in system belong to this group at bootup.
  */
-struct task_group init_task_group;
+struct task_group root_task_group;
 
 #endif	/* CONFIG_CGROUP_SCHED */
 
@@ -743,7 +741,7 @@ sched_feat_write(struct file *filp, const char __user *ubuf,
 	buf[cnt] = 0;
 	cmp = strstrip(buf);
 
-	if (strncmp(buf, "NO_", 3) == 0) {
+	if (strncmp(cmp, "NO_", 3) == 0) {
 		neg = 1;
 		cmp += 3;
 	}
@@ -7848,7 +7846,7 @@ static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 	cfs_rq->tg = tg;
 
 	tg->se[cpu] = se;
-	/* se could be NULL for init_task_group */
+	/* se could be NULL for root_task_group */
 	if (!se)
 		return;
 
@@ -7908,18 +7906,18 @@ void __init sched_init(void)
 		ptr = (unsigned long)kzalloc(alloc_size, GFP_NOWAIT);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-		init_task_group.se = (struct sched_entity **)ptr;
+		root_task_group.se = (struct sched_entity **)ptr;
 		ptr += nr_cpu_ids * sizeof(void **);
 
-		init_task_group.cfs_rq = (struct cfs_rq **)ptr;
+		root_task_group.cfs_rq = (struct cfs_rq **)ptr;
 		ptr += nr_cpu_ids * sizeof(void **);
 
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 #ifdef CONFIG_RT_GROUP_SCHED
-		init_task_group.rt_se = (struct sched_rt_entity **)ptr;
+		root_task_group.rt_se = (struct sched_rt_entity **)ptr;
 		ptr += nr_cpu_ids * sizeof(void **);
 
-		init_task_group.rt_rq = (struct rt_rq **)ptr;
+		root_task_group.rt_rq = (struct rt_rq **)ptr;
 		ptr += nr_cpu_ids * sizeof(void **);
 
 #endif /* CONFIG_RT_GROUP_SCHED */
@@ -7939,13 +7937,13 @@ void __init sched_init(void)
 			global_rt_period(), global_rt_runtime());
 
 #ifdef CONFIG_RT_GROUP_SCHED
-	init_rt_bandwidth(&init_task_group.rt_bandwidth,
+	init_rt_bandwidth(&root_task_group.rt_bandwidth,
 			global_rt_period(), global_rt_runtime());
 #endif /* CONFIG_RT_GROUP_SCHED */
 
 #ifdef CONFIG_CGROUP_SCHED
-	list_add(&init_task_group.list, &task_groups);
-	INIT_LIST_HEAD(&init_task_group.children);
+	list_add(&root_task_group.list, &task_groups);
+	INIT_LIST_HEAD(&root_task_group.children);
 	autogroup_init(&init_task);
 #endif /* CONFIG_CGROUP_SCHED */
 
@@ -7960,34 +7958,34 @@ void __init sched_init(void)
 		init_cfs_rq(&rq->cfs, rq);
 		init_rt_rq(&rq->rt, rq);
 #ifdef CONFIG_FAIR_GROUP_SCHED
-		init_task_group.shares = init_task_group_load;
+		root_task_group.shares = root_task_group_load;
 		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
 		/*
-		 * How much cpu bandwidth does init_task_group get?
+		 * How much cpu bandwidth does root_task_group get?
 		 *
 		 * In case of task-groups formed thr' the cgroup filesystem, it
 		 * gets 100% of the cpu resources in the system. This overall
 		 * system cpu resource is divided among the tasks of
-		 * init_task_group and its child task-groups in a fair manner,
+		 * root_task_group and its child task-groups in a fair manner,
 		 * based on each entity's (task or task-group's) weight
 		 * (se->load.weight).
 		 *
-		 * In other words, if init_task_group has 10 tasks of weight
+		 * In other words, if root_task_group has 10 tasks of weight
 		 * 1024) and two child groups A0 and A1 (of weight 1024 each),
 		 * then A0's share of the cpu resource is:
 		 *
 		 *	A0's bandwidth = 1024 / (10*1024 + 1024 + 1024) = 8.33%
 		 *
-		 * We achieve this by letting init_task_group's tasks sit
-		 * directly in rq->cfs (i.e init_task_group->se[] = NULL).
+		 * We achieve this by letting root_task_group's tasks sit
+		 * directly in rq->cfs (i.e root_task_group->se[] = NULL).
 		 */
-		init_tg_cfs_entry(&init_task_group, &rq->cfs, NULL, i, NULL);
+		init_tg_cfs_entry(&root_task_group, &rq->cfs, NULL, i, NULL);
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 		rq->rt.rt_runtime = def_rt_bandwidth.rt_runtime;
 #ifdef CONFIG_RT_GROUP_SCHED
 		INIT_LIST_HEAD(&rq->leaf_rt_rq_list);
-		init_tg_rt_entry(&init_task_group, &rq->rt, NULL, i, NULL);
+		init_tg_rt_entry(&root_task_group, &rq->rt, NULL, i, NULL);
 #endif
 
 		for (j = 0; j < CPU_LOAD_IDX_MAX; j++)
@@ -8379,6 +8377,7 @@ static void free_sched_group(struct task_group *tg)
 {
 	free_fair_sched_group(tg);
 	free_rt_sched_group(tg);
+	autogroup_free(tg);
 	kfree(tg);
 }
 
@@ -8812,7 +8811,7 @@ cpu_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cgrp)
 
 	if (!cgrp->parent) {
 		/* This is early initialization for the top cgroup */
-		return &init_task_group.css;
+		return &root_task_group.css;
 	}
 
 	parent = cgroup_tg(cgrp->parent);
diff --git a/kernel/sched_autogroup.c b/kernel/sched_autogroup.c
index c80fedc..32a723b 100644
--- a/kernel/sched_autogroup.c
+++ b/kernel/sched_autogroup.c
@@ -9,10 +9,10 @@ unsigned int __read_mostly sysctl_sched_autogroup_enabled = 1;
 static struct autogroup autogroup_default;
 static atomic_t autogroup_seq_nr;
 
-static void autogroup_init(struct task_struct *init_task)
+static void __init autogroup_init(struct task_struct *init_task)
 {
-	autogroup_default.tg = &init_task_group;
-	init_task_group.autogroup = &autogroup_default;
+	autogroup_default.tg = &root_task_group;
+	root_task_group.autogroup = &autogroup_default;
 	kref_init(&autogroup_default.kref);
 	init_rwsem(&autogroup_default.lock);
 	init_task->signal->autogroup = &autogroup_default;
@@ -63,7 +63,7 @@ static inline struct autogroup *autogroup_create(void)
 	if (!ag)
 		goto out_fail;
 
-	tg = sched_create_group(&init_task_group);
+	tg = sched_create_group(&root_task_group);
 
 	if (IS_ERR(tg))
 		goto out_free;
diff --git a/kernel/softirq.c b/kernel/softirq.c
index d4d918a..c10150c 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -853,7 +853,7 @@ static int __cpuinit cpu_callback(struct notifier_block *nfb,
 			     cpumask_any(cpu_online_mask));
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN: {
-		static struct sched_param param = {
+		static const struct sched_param param = {
 			.sched_priority = MAX_RT_PRIO-1
 		};
 
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 562c56e..659732e 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -558,7 +558,7 @@ trace_selftest_startup_nop(struct tracer *trace, struct trace_array *tr)
 static int trace_wakeup_test_thread(void *data)
 {
 	/* Make this a RT thread, doesn't need to be too high */
-	static struct sched_param param = { .sched_priority = 5 };
+	static const struct sched_param param = { .sched_priority = 5 };
 	struct completion *x = data;
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
