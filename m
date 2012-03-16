Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422907Ab2CPOxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 10:53:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45542 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032850Ab2CPOxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 10:53:37 -0400
Message-Id: <20120316144240.889278872@chello.nl>
User-Agent: quilt/0.48-1
Date: Fri, 16 Mar 2012 15:40:40 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 12/26] sched, mm: sched_{fork,exec} node assignment
References: <20120316144028.036474157@chello.nl>
Content-Disposition: inline; filename=numa-foo-4.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rework the scheduler fork,exec hooks to allow home-node assignment.

In particular:
  - call sched_fork() after the mm is set up and the thread
    group list is initialized (such that we can iterate the mm_owner
    thread group).
  - call sched_exec() after we've got our fresh mm.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/exec.c             |    4 ++--
 include/linux/sched.h |    4 ++--
 kernel/fork.c         |    9 +++++----
 kernel/sched/core.c   |    7 +++++--
 kernel/sched/sched.h  |    2 ++
 5 files changed, 16 insertions(+), 10 deletions(-)
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1505,8 +1505,6 @@ static int do_execve_common(const char *
 	if (IS_ERR(file))
 		goto out_unmark;
 
-	sched_exec();
-
 	bprm->file = file;
 	bprm->filename = filename;
 	bprm->interp = filename;
@@ -1515,6 +1513,8 @@ static int do_execve_common(const char *
 	if (retval)
 		goto out_file;
 
+	sched_exec(bprm->mm);
+
 	bprm->argc = count(argv, MAX_ARG_STRINGS);
 	if ((retval = bprm->argc) < 0)
 		goto out;
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1999,9 +1999,9 @@ task_sched_runtime(struct task_struct *t
 
 /* sched_exec is called by processes performing an exec */
 #ifdef CONFIG_SMP
-extern void sched_exec(void);
+extern void sched_exec(struct mm_struct *mm);
 #else
-#define sched_exec()   {}
+#define sched_exec(mm)   {}
 #endif
 
 extern void sched_clock_idle_sleep_event(void);
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1229,9 +1229,6 @@ static struct task_struct *copy_process(
 	p->memcg_batch.memcg = NULL;
 #endif
 
-	/* Perform scheduler related setup. Assign this task to a CPU. */
-	sched_fork(p);
-
 	retval = perf_event_init_task(p);
 	if (retval)
 		goto bad_fork_cleanup_policy;
@@ -1284,6 +1281,11 @@ static struct task_struct *copy_process(
 	 * Clear TID on mm_release()?
 	 */
 	p->clear_child_tid = (clone_flags & CLONE_CHILD_CLEARTID) ? child_tidptr : NULL;
+
+	INIT_LIST_HEAD(&p->thread_group);
+	/* Perform scheduler related setup. Assign this task to a CPU. */
+	sched_fork(p);
+
 #ifdef CONFIG_BLOCK
 	p->plug = NULL;
 #endif
@@ -1326,7 +1328,6 @@ static struct task_struct *copy_process(
 	 * We dont wake it up yet.
 	 */
 	p->group_leader = p;
-	INIT_LIST_HEAD(&p->thread_group);
 
 	/* Now that the task is set up, run cgroup callbacks if
 	 * necessary. We need to run them before the task is visible
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1767,8 +1767,9 @@ void sched_fork(struct task_struct *p)
 #ifdef CONFIG_SMP
 	plist_node_init(&p->pushable_tasks, MAX_PRIO);
 #endif
-
 	put_cpu();
+
+	select_task_node(p, p->mm, SD_BALANCE_FORK);
 }
 
 /*
@@ -2507,12 +2508,14 @@ static void update_cpu_load_active(struc
  * sched_exec - execve() is a valuable balancing opportunity, because at
  * this point the task has the smallest effective memory and cache footprint.
  */
-void sched_exec(void)
+void sched_exec(struct mm_struct *mm)
 {
 	struct task_struct *p = current;
 	unsigned long flags;
 	int dest_cpu;
 
+	select_task_node(p, mm, SD_BALANCE_EXEC);
+
 	raw_spin_lock_irqsave(&p->pi_lock, flags);
 	dest_cpu = p->sched_class->select_task_rq(p, SD_BALANCE_EXEC, 0);
 	if (dest_cpu == smp_processor_id())
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1153,3 +1153,5 @@ enum rq_nohz_flag_bits {
 
 #define nohz_flags(cpu)	(&cpu_rq(cpu)->nohz_flags)
 #endif
+
+static inline void select_task_node(struct task_struct *p, struct mm_struct *mm, int sd_flags) { }


