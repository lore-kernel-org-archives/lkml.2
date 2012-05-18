Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762697Ab2ERKer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:34:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42492 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab2ERKep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:34:45 -0400
Date: Fri, 18 May 2012 03:33:58 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-qg63apu64i9i4slg4bor4oww@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, pjt@google.com,
        cl@linux.com, riel@redhat.com, akpm@linux-foundation.org,
        bharata.rao@gmail.com, aarcange@redhat.com, Lee.Schermerhorn@hp.com,
        suresh.b.siddha@intel.com, danms@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        cl@linux.com, riel@redhat.com, bharata.rao@gmail.com,
        akpm@linux-foundation.org, Lee.Schermerhorn@hp.com,
        aarcange@redhat.com, danms@us.ibm.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] sched, mm: Rework sched_{fork,
 exec} node assignment
Git-Commit-ID: 0ea86208345b9a41863c3929c69b7ccfbfa6275e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:34:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0ea86208345b9a41863c3929c69b7ccfbfa6275e
Gitweb:     http://git.kernel.org/tip/0ea86208345b9a41863c3929c69b7ccfbfa6275e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 3 Mar 2012 16:54:42 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 08:16:22 +0200

sched, mm: Rework sched_{fork,exec} node assignment

Rework the scheduler fork,exec hooks to allow home-node assignment.

In particular:

  - call sched_fork() after the mm is set up and the thread
    group list is initialized (such that we can iterate the mm_owner
    thread group).
  - call sched_exec() after we've got our fresh mm.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Paul Turner <pjt@google.com>
Cc: Dan Smith <danms@us.ibm.com>
Cc: Bharata B Rao <bharata.rao@gmail.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-qg63apu64i9i4slg4bor4oww@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 fs/exec.c             |    4 ++--
 include/linux/sched.h |    4 ++--
 kernel/fork.c         |    9 +++++----
 kernel/sched/core.c   |    7 +++++--
 kernel/sched/sched.h  |    5 +++++
 5 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index b1fd202..8a12a7f 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1506,8 +1506,6 @@ static int do_execve_common(const char *filename,
 	if (IS_ERR(file))
 		goto out_unmark;
 
-	sched_exec();
-
 	bprm->file = file;
 	bprm->filename = filename;
 	bprm->interp = filename;
@@ -1516,6 +1514,8 @@ static int do_execve_common(const char *filename,
 	if (retval)
 		goto out_file;
 
+	sched_exec(bprm->mm);
+
 	bprm->argc = count(argv, MAX_ARG_STRINGS);
 	if ((retval = bprm->argc) < 0)
 		goto out;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 49378f0..8bb49f6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1966,9 +1966,9 @@ task_sched_runtime(struct task_struct *task);
 
 /* sched_exec is called by processes performing an exec */
 #ifdef CONFIG_SMP
-extern void sched_exec(void);
+extern void sched_exec(struct mm_struct *mm);
 #else
-#define sched_exec()   {}
+#define sched_exec(mm)   {}
 #endif
 
 extern void sched_clock_idle_sleep_event(void);
diff --git a/kernel/fork.c b/kernel/fork.c
index f01be7f..7acf6ae 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1302,9 +1302,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->memcg_batch.memcg = NULL;
 #endif
 
-	/* Perform scheduler related setup. Assign this task to a CPU. */
-	sched_fork(p);
-
 	retval = perf_event_init_task(p);
 	if (retval)
 		goto bad_fork_cleanup_policy;
@@ -1357,6 +1354,11 @@ static struct task_struct *copy_process(unsigned long clone_flags,
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
@@ -1405,7 +1407,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	 * We dont wake it up yet.
 	 */
 	p->group_leader = p;
-	INIT_LIST_HEAD(&p->thread_group);
 
 	/* Now that the task is set up, run cgroup callbacks if
 	 * necessary. We need to run them before the task is visible
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 8fd0325..9c9c0ee 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1798,8 +1798,9 @@ void sched_fork(struct task_struct *p)
 #ifdef CONFIG_SMP
 	plist_node_init(&p->pushable_tasks, MAX_PRIO);
 #endif
-
 	put_cpu();
+
+	select_task_node(p, p->mm, SD_BALANCE_FORK);
 }
 
 /*
@@ -2565,12 +2566,14 @@ static void update_cpu_load_active(struct rq *this_rq)
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
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ba9dccf..8f93e91 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1156,3 +1156,8 @@ enum rq_nohz_flag_bits {
 
 #define nohz_flags(cpu)	(&cpu_rq(cpu)->nohz_flags)
 #endif
+
+/*
+ * Macro to avoid argument evaluation
+ */
+#define select_task_node(p, mm, sd_flags) do { } while (0)
