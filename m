Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab0KKRJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 12:09:13 -0500
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:58693 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab0KKRIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 12:08:19 -0500
Message-Id: <20101111170815.404670062@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Thu, 11 Nov 2010 18:03:57 +0100
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>, John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [RFC][PATCH v2 5/7] taskstats: Improve cumulative CPU time accounting
References: <20101111170352.732381138@linux.vnet.ibm.com>
Content-Disposition: inline; filename=05-taskstats-top-improve-ctime.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

CHANGE HISTORY OF THIS PATCH
----------------------------
Version 2
---------
* Add cumulative dead thread CPU times to taskstats
* Introduce parallel accounting process hierarchy (based on discussions
  with Oleg Nesterov and Roland McGrath)

DESCRIPTION
-----------
Currently the cumulative time accounting in Linux has two major drawbacks
for tools like the top command:

* Due to POSIX POSIX.1-2001, the CPU time of processes is not accounted
  to the cumulative time of the parents, if the parents ignore SIGCHLD
  or have set SA_NOCLDWAIT. This behaviour has the major drawback that
  it is not possible to calculate all consumed CPU time of a system by
  looking at the current tasks. CPU time can be lost.

* When a parent process dies, its children get the init process as
  new parent. For accounting this is suboptimal, because then init
  gets the CPU time of the tasks. For accounting it would be better,
  if the CPU time is passed along the relationship tree using the
  cumulative time counters as would have happened if the child had died
  before the parent. The main benefit of that approach is that between
  two tasks snapshots it is always clear which parent got the CPU time
  of dead tasks. Otherwise there are situations, where we can't
  determine if either init or an older relative of a dead task has
  inherited the CPU time.

  Another benefit would be that then e.g. it would be possible to look
  at the login shell process cumulative times to get all CPU time that has
  been consumed by it's children, grandchildren, etc. This would allow
  accounting without the need of exit events for all dead processes.
  Note that this has a small fault because processes can use
  daemonize to detach themselfes from their parents.

This patch adds a new set of cumulative time counters. We then have two
cumulative counter sets:

* cdata_wait: Traditional cumulative time used e.g. by getrusage.
* cdata_acct: Cumulative time that also includes dead processes with
              parents that ignore SIGCHLD or have set SA_NOCLDWAIT.
              cdata_acct will be exported by taskstats.

Besides of that the patch adds an "acct_parent" pointer next to the parent
pointer and a "children_acct" list next to the children list to the
signal_struct in order to remember the accounting process relationship.

With this patch and the following time fields it is now possible to
calculate all the consumed CPU time of a system in an interval by looking at
the tasks of two taskstats snapshots:

* task->(u/s/st/g-time):
  Time that has been consumed by task itself

* task->signal->cdata_acct.(c-u/s/st/g-time):
  All time that has been consumed by dead children of process. Includes
  also time from processes that reaped themselves, because the parent
  ignored SIGCHLD or has set SA_NOCLDWAIT

* task->signal->(u/s/st/g-time):
  Time that has been consumed by dead threads of thread group of process

Having this is prerequisite for the following use cases:

USE CASE I: A top command that shows exactly 100% of all consumed CPU time
between two task snapshots without using task exit events. Exit events are not
necessary, because if tasks die between the two snapshots all time can be
found in the cumulative counters of the parent processes or thread group
leaders.

To provide a consistent view, the top tool could show the following fields
(all values are per interval):
 * user:  task utime
 * sys:   task stime
 * ste:   task sttime
 * cuser: utime of exited children
 * csys:  stime of exited children
 * cste:  sttime of exited children
 * xuser: utime of exited threads in thread group
 * xsys:  stime of exited threads in thread group
 * xste:  sttime of exited threads in thread group
 * total: Sum of all above fields

If the top command notices that a pid disappeared between snapshot 1
and snapshot 2, it has to find its accounting parent and subtract the CPU
times from snapshot 1 of the dead child from the parents cumulative times.

Example:
--------
                  CPU time of dead tasks in last interval
                         VVVVV  VVVV VVVV
pid     user   sys  ste  cuser  csys cste xuser xsys xste total  Name
(#)      (%)   (%)  (%)    (%)   (%)  (%)   (%)  (%)  (%)   (%)  (str)
17944   0.10  0.01 0.00  54.29 14.36 0.22   0.0  0.0  0.0 68.98  make
18006   0.10  0.01 0.00  55.79 12.23 0.12   0.0  0.0  0.0 68.26  make
18041  48.18  1.51 0.29   0.00  0.00 0.00   0.0  0.0  0.0 49.98  cc1
...

The sum of all "total" CPU counters on a system that is 100% busy should
be exactly the number CPUs multiplied by the interval time. A good tescase
for this is to start a loop program for each CPU and then in parallel
starting a kernel build with "-j 5".

USE CASE II: Implement precise replacement for "time" command and get all
consumed CPU time of children tree without using exit events.

Example:
--------
# cd linux-2.6
# tstime make -j 3
Cumulative CPU times:
---------------------
user..: 1000266540
system: 121721391
steal.: 3480230

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 fs/binfmt_elf.c           |    4 -
 fs/proc/array.c           |   10 +-
 fs/proc/base.c            |    3 
 include/linux/init_task.h |    2 
 include/linux/sched.h     |   39 +++++++---
 include/linux/taskstats.h |    6 +
 kernel/exit.c             |  175 ++++++++++++++++++++++++++++------------------
 kernel/fork.c             |    7 +
 kernel/sys.c              |   24 +++---
 kernel/tsacct.c           |   33 ++++++++
 10 files changed, 205 insertions(+), 98 deletions(-)

--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1296,8 +1296,8 @@ static void fill_prstatus(struct elf_prs
 		cputime_to_timeval(p->utime, &prstatus->pr_utime);
 		cputime_to_timeval(p->stime, &prstatus->pr_stime);
 	}
-	cputime_to_timeval(p->signal->cutime, &prstatus->pr_cutime);
-	cputime_to_timeval(p->signal->cstime, &prstatus->pr_cstime);
+	cputime_to_timeval(p->signal->cdata_wait.cutime, &prstatus->pr_cutime);
+	cputime_to_timeval(p->signal->cdata_wait.cstime, &prstatus->pr_cstime);
 }
 
 static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -413,11 +413,11 @@ static int do_task_stat(struct seq_file
 		num_threads = get_nr_threads(task);
 		collect_sigign_sigcatch(task, &sigign, &sigcatch);
 
-		cmin_flt = sig->cmin_flt;
-		cmaj_flt = sig->cmaj_flt;
-		cutime = sig->cutime;
-		cstime = sig->cstime;
-		cgtime = sig->cgtime;
+		cmin_flt = sig->cdata_wait.cmin_flt;
+		cmaj_flt = sig->cdata_wait.cmaj_flt;
+		cutime = sig->cdata_wait.cutime;
+		cstime = sig->cdata_wait.cstime;
+		cgtime = sig->cdata_wait.cgtime;
 		rsslim = ACCESS_ONCE(sig->rlim[RLIMIT_RSS].rlim_cur);
 
 		/* add up live thread stats at the group level */
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2671,7 +2671,8 @@ static int do_io_accounting(struct task_
 	if (whole && lock_task_sighand(task, &flags)) {
 		struct task_struct *t = task;
 
-		task_io_accounting_add(&acct, &task->signal->ioac);
+		task_io_accounting_add(&acct,
+				       &task->signal->cdata_wait.ioac);
 		while_each_thread(task, t)
 			task_io_accounting_add(&acct, &t->ioac);
 
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -31,6 +31,8 @@ extern struct fs_struct init_fs;
 	},								\
 	.cred_guard_mutex =						\
 		 __MUTEX_INITIALIZER(sig.cred_guard_mutex),		\
+	.acct_parent	= NULL,						\
+	.acct_children	= LIST_HEAD_INIT(sig.acct_children),		\
 }
 
 extern struct nsproxy init_nsproxy;
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -512,6 +512,20 @@ struct thread_group_cputimer {
 };
 
 /*
+ * Cumulative resource counters for reaped dead child processes.
+ * Live threads maintain their own counters and add to these
+ * in __exit_signal, except for the group leader.
+ */
+struct cdata {
+	cputime_t cutime, cstime, csttime, cgtime;
+	unsigned long cnvcsw, cnivcsw;
+	unsigned long cmin_flt, cmaj_flt;
+	unsigned long cinblock, coublock;
+	unsigned long cmaxrss;
+	struct task_io_accounting ioac;
+};
+
+/*
  * NOTE! "signal_struct" does not have it's own
  * locking, because a shared signal_struct always
  * implies a shared sighand_struct, so locking
@@ -578,23 +592,28 @@ struct signal_struct {
 
 	struct tty_struct *tty; /* NULL if no tty */
 
+	/* Cumulative resource counters for all dead child processes */
+	struct cdata cdata_wait; /* parents have done sys_wait() */
+	struct cdata cdata_acct; /* complete cumulative data from acct tree */
+
+	/* Parallel accounting tree */
+	struct signal_struct *acct_parent; /* accounting parent process */
+	struct list_head acct_children;    /* list of my accounting children */
+	struct list_head acct_sibling;     /* linkage in my parent's list */
+
 	/*
 	 * Cumulative resource counters for dead threads in the group,
-	 * and for reaped dead child processes forked by this group.
-	 * Live threads maintain their own counters and add to these
-	 * in __exit_signal, except for the group leader.
 	 */
-	cputime_t utime, stime, sttime, cutime, cstime, csttime;
+	cputime_t utime, stime, sttime;
+
 	cputime_t gtime;
-	cputime_t cgtime;
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	cputime_t prev_utime, prev_stime, prev_sttime;
 #endif
-	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
-	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
-	unsigned long inblock, oublock, cinblock, coublock;
-	unsigned long maxrss, cmaxrss;
-	struct task_io_accounting ioac;
+	unsigned long nvcsw, nivcsw;
+	unsigned long min_flt, maj_flt;
+	unsigned long inblock, oublock;
+	unsigned long maxrss;
 
 	/*
 	 * Cumulative ns of schedule CPU time fo dead threads in the
--- a/include/linux/taskstats.h
+++ b/include/linux/taskstats.h
@@ -169,6 +169,12 @@ struct taskstats {
 	__u64	time_ns;
 	__u32	ac_tgid;		/* Thread group ID */
 	__u64	ac_sttime;		/* Steal CPU time [usec] */
+	__u64	ac_cutime;		/* User CPU time of children [usec] */
+	__u64	ac_cstime;		/* System CPU time of children [usec] */
+	__u64	ac_csttime;		/* Steal CPU time of children [usec] */
+	__u64	ac_tutime;		/* User CPU time of threads [usec] */
+	__u64	ac_tstime;		/* System CPU time of threads [usec] */
+	__u64	ac_tsttime;		/* Steal CPU time of threads [usec] */
 };
 
 
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -51,6 +51,7 @@
 #include <trace/events/sched.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/oom.h>
+#include <linux/kernel_stat.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -74,6 +75,85 @@ static void __unhash_process(struct task
 	list_del_rcu(&p->thread_group);
 }
 
+static void __account_ctime(struct task_struct *p, struct task_struct *parent,
+			    struct cdata *pcd, struct cdata *ccd)
+{
+	struct signal_struct *sig = p->signal;
+	cputime_t tgutime, tgstime, tgsttime;
+	unsigned long maxrss, flags;
+
+	/*
+	 * The resource counters for the group leader are in its
+	 * own task_struct.  Those for dead threads in the group
+	 * are in its signal_struct, as are those for the child
+	 * processes it has previously reaped.  All these
+	 * accumulate in the parent's signal_struct c* fields.
+	 *
+	 * We don't bother to take a lock here to protect these
+	 * p->signal fields, because they are only touched by
+	 * __exit_signal, which runs with tasklist_lock
+	 * write-locked anyway, and so is excluded here.  We do
+	 * need to protect the access to parent->signal fields,
+	 * as other threads in the parent group can be right
+	 * here reaping other children at the same time.
+	 *
+	 * We use thread_group_times() to get times for the thread
+	 * group, which consolidates times for all threads in the
+	 * group including the group leader.
+	 */
+	thread_group_times(p, &tgutime, &tgstime, &tgsttime);
+
+	spin_lock_irqsave(&parent->sighand->siglock, flags);
+	pcd->cutime = cputime_add(pcd->cutime,
+				  cputime_add(tgutime, ccd->cutime));
+	pcd->cstime = cputime_add(pcd->cstime,
+				  cputime_add(tgstime, ccd->cstime));
+	pcd->csttime = cputime_add(pcd->csttime,
+				   cputime_add(tgsttime, ccd->csttime));
+	pcd->cgtime = cputime_add(pcd->cgtime, cputime_add(p->gtime,
+			   cputime_add(sig->gtime, ccd->cgtime)));
+
+	pcd->cmin_flt += p->min_flt + sig->min_flt + ccd->cmin_flt;
+	pcd->cmaj_flt += p->maj_flt + sig->maj_flt + ccd->cmaj_flt;
+	pcd->cnvcsw += p->nvcsw + sig->nvcsw + ccd->cnvcsw;
+	pcd->cnivcsw += p->nivcsw + sig->nivcsw + ccd->cnivcsw;
+	pcd->cinblock += task_io_get_inblock(p) + sig->inblock + ccd->cinblock;
+	pcd->coublock += task_io_get_oublock(p) + sig->oublock + ccd->coublock;
+	maxrss = max(sig->maxrss, ccd->cmaxrss);
+	if (pcd->cmaxrss < maxrss)
+		pcd->cmaxrss = maxrss;
+
+	maxrss = max(sig->maxrss, ccd->cmaxrss);
+	if (pcd->cmaxrss < maxrss)
+		pcd->cmaxrss = maxrss;
+
+	task_io_accounting_add(&pcd->ioac, &p->ioac);
+	task_io_accounting_add(&pcd->ioac, &ccd->ioac);
+	task_io_accounting_add(&pcd->ioac, &ccd->ioac);
+	spin_unlock_irqrestore(&parent->sighand->siglock, flags);
+}
+
+static void reparent_acct(struct signal_struct *father)
+{
+	struct signal_struct *c, *n, *new_parent;
+	struct task_struct *tsk;
+
+	rcu_read_lock();
+	tsk = pid_task(father->leader_pid, PIDTYPE_PID);
+	if (!list_empty(&father->acct_children))
+		printk("XXX forget: %i (%s)\n", tsk->pid, tsk->comm);
+	new_parent = father->acct_parent;
+	list_for_each_entry_safe(c, n, &father->acct_children, acct_sibling) {
+		struct task_struct *ctsk = pid_task(c->leader_pid, PIDTYPE_PID);
+		struct task_struct *ptsk = pid_task(new_parent->leader_pid, PIDTYPE_PID);
+		printk("  XXX move: %i (%s) to %i (%s) %p\n",
+		       ctsk->pid, ctsk->comm, ptsk->pid, ptsk->comm, new_parent);
+		c->acct_parent = new_parent;
+		list_move_tail(&c->acct_sibling, &new_parent->acct_children);
+	}
+	rcu_read_unlock();
+}
+
 /*
  * This function expects the tasklist_lock write-locked.
  */
@@ -84,6 +164,29 @@ static void __exit_signal(struct task_st
 	struct sighand_struct *sighand;
 	struct tty_struct *uninitialized_var(tty);
 
+#ifdef __s390x__
+	/*
+	 * FIXME: On s390 we can call account_process_tick to update
+	 * CPU time information. This is probably not valid on other
+	 * architectures.
+	 */
+	if (current == tsk)
+		account_process_tick(current, 1);
+#endif
+	if (group_dead) {
+		struct task_struct *acct_parent =
+			pid_task(sig->acct_parent->leader_pid, PIDTYPE_PID);
+		/*
+		 * FIXME: This somehow has to be moved to
+		 * finish_task_switch(), because otherwise
+		 * if the process accounts itself, the CPU time
+		 * that is used for this code will be lost.
+		 */
+		__account_ctime(tsk, acct_parent, &sig->acct_parent->cdata_acct,
+				&sig->cdata_acct);
+		reparent_acct(sig);
+		list_del_init(&sig->acct_sibling);
+	}
 	sighand = rcu_dereference_check(tsk->sighand,
 					rcu_read_lock_held() ||
 					lockdep_tasklist_lock_is_held());
@@ -132,7 +235,8 @@ static void __exit_signal(struct task_st
 		sig->nivcsw += tsk->nivcsw;
 		sig->inblock += task_io_get_inblock(tsk);
 		sig->oublock += task_io_get_oublock(tsk);
-		task_io_accounting_add(&sig->ioac, &tsk->ioac);
+		task_io_accounting_add(&sig->cdata_wait.ioac,
+				       &tsk->ioac);
 		sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
 	}
 
@@ -1226,73 +1330,10 @@ static int wait_task_zombie(struct wait_
 	 * !task_detached() to filter out sub-threads.
 	 */
 	if (likely(!traced) && likely(!task_detached(p))) {
-		struct signal_struct *psig;
-		struct signal_struct *sig;
-		unsigned long maxrss;
-		cputime_t tgutime, tgstime, tgsttime;
-
-		/*
-		 * The resource counters for the group leader are in its
-		 * own task_struct.  Those for dead threads in the group
-		 * are in its signal_struct, as are those for the child
-		 * processes it has previously reaped.  All these
-		 * accumulate in the parent's signal_struct c* fields.
-		 *
-		 * We don't bother to take a lock here to protect these
-		 * p->signal fields, because they are only touched by
-		 * __exit_signal, which runs with tasklist_lock
-		 * write-locked anyway, and so is excluded here.  We do
-		 * need to protect the access to parent->signal fields,
-		 * as other threads in the parent group can be right
-		 * here reaping other children at the same time.
-		 *
-		 * We use thread_group_times() to get times for the thread
-		 * group, which consolidates times for all threads in the
-		 * group including the group leader.
-		 */
-		thread_group_times(p, &tgutime, &tgstime, &tgsttime);
-		spin_lock_irq(&p->real_parent->sighand->siglock);
-		psig = p->real_parent->signal;
-		sig = p->signal;
-		psig->cutime =
-			cputime_add(psig->cutime,
-			cputime_add(tgutime,
-				    sig->cutime));
-		psig->cstime =
-			cputime_add(psig->cstime,
-			cputime_add(tgstime,
-				    sig->cstime));
-		psig->csttime =
-			cputime_add(psig->csttime,
-			cputime_add(tgsttime,
-				    sig->csttime));
-		psig->cgtime =
-			cputime_add(psig->cgtime,
-			cputime_add(p->gtime,
-			cputime_add(sig->gtime,
-				    sig->cgtime)));
-		psig->cmin_flt +=
-			p->min_flt + sig->min_flt + sig->cmin_flt;
-		psig->cmaj_flt +=
-			p->maj_flt + sig->maj_flt + sig->cmaj_flt;
-		psig->cnvcsw +=
-			p->nvcsw + sig->nvcsw + sig->cnvcsw;
-		psig->cnivcsw +=
-			p->nivcsw + sig->nivcsw + sig->cnivcsw;
-		psig->cinblock +=
-			task_io_get_inblock(p) +
-			sig->inblock + sig->cinblock;
-		psig->coublock +=
-			task_io_get_oublock(p) +
-			sig->oublock + sig->coublock;
-		maxrss = max(sig->maxrss, sig->cmaxrss);
-		if (psig->cmaxrss < maxrss)
-			psig->cmaxrss = maxrss;
-		task_io_accounting_add(&psig->ioac, &p->ioac);
-		task_io_accounting_add(&psig->ioac, &sig->ioac);
-		spin_unlock_irq(&p->real_parent->sighand->siglock);
+		__account_ctime(p, p->real_parent,
+				&p->real_parent->signal->cdata_wait,
+				&p->signal->cdata_wait);
 	}
-
 	/*
 	 * Now we are sure this task is interesting, and no other
 	 * thread can reap it because we set its state to EXIT_DEAD.
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1289,6 +1289,13 @@ static struct task_struct *copy_process(
 		nr_threads++;
 	}
 
+	if (!(clone_flags & CLONE_THREAD)) {
+		p->signal->acct_parent = current->signal;
+		INIT_LIST_HEAD(&p->signal->acct_children);
+		INIT_LIST_HEAD(&p->signal->acct_sibling);
+		list_add_tail(&p->signal->acct_sibling,
+			      &current->signal->acct_children);
+	}
 	total_forks++;
 	spin_unlock(&current->sighand->siglock);
 	write_unlock_irq(&tasklist_lock);
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -884,8 +884,8 @@ void do_sys_times(struct tms *tms)
 
 	spin_lock_irq(&current->sighand->siglock);
 	thread_group_times(current, &tgutime, &tgstime, &tgsttime);
-	cutime = current->signal->cutime;
-	cstime = current->signal->cstime;
+	cutime = current->signal->cdata_wait.cutime;
+	cstime = current->signal->cdata_wait.cstime;
 	spin_unlock_irq(&current->sighand->siglock);
 	tms->tms_utime = cputime_to_clock_t(tgutime);
 	tms->tms_stime = cputime_to_clock_t(tgstime);
@@ -1490,6 +1490,7 @@ static void k_getrusage(struct task_stru
 	unsigned long flags;
 	cputime_t tgutime, tgstime, tgsttime, utime, stime, sttime;
 	unsigned long maxrss = 0;
+	struct cdata *cd;
 
 	memset((char *) r, 0, sizeof *r);
 	utime = stime = cputime_zero;
@@ -1507,15 +1508,16 @@ static void k_getrusage(struct task_stru
 	switch (who) {
 		case RUSAGE_BOTH:
 		case RUSAGE_CHILDREN:
-			utime = p->signal->cutime;
-			stime = p->signal->cstime;
-			r->ru_nvcsw = p->signal->cnvcsw;
-			r->ru_nivcsw = p->signal->cnivcsw;
-			r->ru_minflt = p->signal->cmin_flt;
-			r->ru_majflt = p->signal->cmaj_flt;
-			r->ru_inblock = p->signal->cinblock;
-			r->ru_oublock = p->signal->coublock;
-			maxrss = p->signal->cmaxrss;
+			cd = &p->signal->cdata_wait;
+			utime = cd->cutime;
+			stime = cd->cstime;
+			r->ru_nvcsw = cd->cnvcsw;
+			r->ru_nivcsw = cd->cnivcsw;
+			r->ru_minflt = cd->cmin_flt;
+			r->ru_majflt = cd->cmaj_flt;
+			r->ru_inblock = cd->cinblock;
+			r->ru_oublock = cd->coublock;
+			maxrss = cd->cmaxrss;
 
 			if (who == RUSAGE_CHILDREN)
 				break;
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -61,8 +61,37 @@ void bacct_add_tsk(struct taskstats *sta
 	tcred = __task_cred(tsk);
 	stats->ac_uid	 = tcred->uid;
 	stats->ac_gid	 = tcred->gid;
-	stats->ac_ppid	 = pid_alive(tsk) ?
-				rcu_dereference(tsk->real_parent)->tgid : 0;
+	/*
+	 * FIXME: Add new field "ac_acct_ppid" and "ac_acct_ctime" to
+	 * taskstats
+	 */
+	if (pid_alive(tsk) && tsk->signal) {
+		struct signal_struct *acct_parent = tsk->signal->acct_parent;
+		if (acct_parent && acct_parent->leader_pid)
+			stats->ac_ppid = pid_task(acct_parent->leader_pid,
+						  PIDTYPE_PID)->tgid;
+		else
+			stats->ac_ppid = 0;
+	} else {
+		stats->ac_ppid = 0;
+	}
+	if (tsk->signal && tsk->tgid == tsk->pid) {
+		struct cdata *cd = &tsk->signal->cdata_acct;
+
+		stats->ac_cutime = cputime_to_usecs(cd->cutime);
+		stats->ac_cstime = cputime_to_usecs(cd->cstime);
+		stats->ac_csttime = cputime_to_usecs(cd->csttime);
+		stats->ac_tutime = cputime_to_usecs(tsk->signal->utime);
+		stats->ac_tstime = cputime_to_usecs(tsk->signal->stime);
+		stats->ac_tsttime = cputime_to_usecs(tsk->signal->sttime);
+	} else {
+		stats->ac_cutime = 0;
+		stats->ac_cstime = 0;
+		stats->ac_csttime = 0;
+		stats->ac_tutime = 0;
+		stats->ac_tstime = 0;
+		stats->ac_tsttime = 0;
+	}
 	rcu_read_unlock();
 	stats->ac_utime = cputime_to_usecs(tsk->utime);
 	stats->ac_stime = cputime_to_usecs(tsk->stime);

