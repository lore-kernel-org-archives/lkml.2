Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546Ab0JFJ3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 05:29:19 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:39541 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341Ab0JFJ3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 05:29:16 -0400
Subject: Re: [RFC][PATCH 09/10] taskstats: Fix exit CPU time accounting
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101005085751.4490A401B2@magilla.sf.frob.com>
References: <1285249681.1837.28.camel@holzheu-laptop>
	 <1285250541.1837.95.camel@holzheu-laptop>
	 <20100923171025.GA26623@redhat.com>
	 <1285330688.2179.305.camel@holzheu-laptop>
	 <20100926181127.GA26985@redhat.com>
	 <20100927154257.7910cda3@mschwide.boeblingen.de.ibm.com>
	 <20100927165133.GA23535@redhat.com>
	 <20100929191916.21E1840038@magilla.sf.frob.com>
	 <1285854460.1856.14.camel@holzheu-laptop>
	 <20101005085751.4490A401B2@magilla.sf.frob.com>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Wed, 06 Oct 2010 11:29:10 +0200
Message-ID: <1286357350.1888.25.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Roland and Oleg,

On Tue, 2010-10-05 at 01:57 -0700, Roland McGrath wrote: 
> > Thanks! That information was missing! Although still for me it not seems
> > to be a good decision to do it that way. Because of that it currently is
> > not possible to evaluate all consumed CPU time by looking at the current
> > processes. Time can simply disappear.
> 
> I agree that it seems dubious.  I don't know why that decision was made in
> POSIX, but that's how it is.  Anyway, POSIX only constrains what we report
> in the POSIX calls, i.e. getrusage, times, waitid, SIGCHLD siginfo_t.
> Nothing says we can't track more information and make it accessible in
> other ways on Linux.

Yes, I think there would be a benefit for process time accounting, if we
would do that.

> > * task->signal->(cr-u/s/st-time):
> >   Time that has been consumed by dead children that reaped 
> >   themselves, because parent ignored SIGCHLD or has set SA_NOCLDWAIT
> >   - NEW: Fields have to be added to signal struct
> >   - NEW: Has to be exported via taskstats
> 
> Note that there are other stats aside from times that are treated the same
> way (c{min,maj}_flt, cn{v,iv}csw, c{in,ou}block, cmaxrss, and io accounting).
> 
> What probably makes sense is to move all those cfoo fields from
> signal_struct into foo fields in a new struct, and then signal_struct can
> have "struct child_stats reaped_children, ignored_children" or whatnot.

I created an experimental patch for that. There I defined a new
structure "cdata" and added two instances of it (cdata_wait and
cdata_acct) to the signal_struct. The cdata_acct member contains all CPU
time.

The patch also approaches another ugly Unix behavior regarding process
accounting. If a parent process dies before his children, the children
get the reaper process (init) as new parent. If we want to determine the
CPU usage of a process tree with cumulative time, this is very
suboptimal. To fix this I added a new process relationship tree for
accounting.

The following patch applies to git head on top of patch:
https://patchwork.kernel.org/patch/202022/

Michael
-------
Subject: [PATCH] taskstats: Improve cumulative resource accounting

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

Currently the cumulative time accounting in Linux has two major drawbacks:

* Due to POSIX POSIX.1-2001, the CPU time of processes is not accounted
  to the cumulative time of the parents, if the parents ignore SIGCHLD
  or have set SA_NOCLDWAIT. This behaviour has the major drawback that
  it is not possible to calculate all consumed CPU time of a system by
  looking at the current tasks. CPU time can be lost.

* When a parent process dies, its children get the init process as
  new parent. For accounting this is suboptimal, because then init
  gets the CPU time of the tasks. For accounting it would be much better,
  if the CPU time is passed along the relationship tree using the
  cumulative time counters as would have happened if the child had died
  before the parent. E.g. then it would be possible to look at the login
  shell process cumulative times to get all CPU time that has been consumed
  by it's children, grandchildren, etc. This would allow accounting without
  the need of exit events for all dead processes.

This patch adds a new set of cumulative time counters. We then have two
cumulative counter sets:

* cdata_wait: Traditional cumulative time used e.g. by getrusage.
* cdata_acct: Cumulative time that also includes dead processes with
              parents that ignore SIGCHLD or have set SA_NOCLDWAIT.
              cdata_acct will be exported by taskstats.

Besides of that the patch adds an "acct_parent" pointer next to the parent
pointer and a "children_acct" list next to the children list to the
task_struct in order to remember the correct accounting task relationship.

With this patch and the following time fields it is now possible to
calculate all the consumed CPU time of a system by looking at the current
tasks:

* task->(u/s/st/g-time):
  Time that has been consumed by task itself

* task->signal->cdata_acct.(c-u/s/st/g-time):
  All time that has been consumed by dead children of process. Includes
  also time from processes that reaped themselves, because the parent
  ignored SIGCHLD or has set SA_NOCLDWAIT

* task->signal->(u/s/st/g-time):
  Time that has been consumed by dead threads of thread group of process

Having this is prerequisite for the following use cases:

I. A top command that shows exactly 100% of all consumed CPU time between
two task snapshots without using task exit events. Exit events are not
necessary, because if tasks die between the two snapshots all time can be
found in the cumulative counters of the parent processes or thread group
leaders.

II. Do accounting by registering an exit event for each login shell. When
the shell exits, we get all CPU time of the shell's children by looking at
the cumulative data. No exit events for all tasks are required. To
implement that we also have to add a new taskstats feature to filter exit
events by PID.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 fs/binfmt_elf.c           |    4 -
 fs/proc/array.c           |   10 +-
 fs/proc/base.c            |    3 
 include/linux/init_task.h |    2 
 include/linux/sched.h     |   39 +++++++---
 include/linux/taskstats.h |    4 +
 kernel/exit.c             |  169 +++++++++++++++++++++++++++++-----------------
 kernel/fork.c             |    6 +
 kernel/sys.c              |   24 +++---
 kernel/tsacct.c           |   13 +++
 10 files changed, 183 insertions(+), 91 deletions(-)

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
@@ -2617,7 +2617,8 @@ static int do_io_accounting(struct task_
 	if (whole && lock_task_sighand(task, &flags)) {
 		struct task_struct *t = task;
 
-		task_io_accounting_add(&acct, &task->signal->ioac);
+		task_io_accounting_add(&acct,
+				       &task->signal->cdata_wait.ioac);
 		while_each_thread(task, t)
 			task_io_accounting_add(&acct, &t->ioac);
 
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -135,7 +135,9 @@ extern struct cred init_cred;
 	.real_parent	= &tsk,						\
 	.parent		= &tsk,						\
 	.children	= LIST_HEAD_INIT(tsk.children),			\
+	.children_acct	= LIST_HEAD_INIT(tsk.children_acct),		\
 	.sibling	= LIST_HEAD_INIT(tsk.sibling),			\
+	.sibling_acct	= LIST_HEAD_INIT(tsk.sibling_acct),		\
 	.group_leader	= &tsk,						\
 	.real_cred	= &init_cred,					\
 	.cred		= &init_cred,					\
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -507,6 +507,20 @@ struct thread_group_cputimer {
 };
 
 /*
+ * Cumulative resource counters for reaped dead child processes.
+ * Live threads maintain their own counters and add to these
+ * in __exit_signal, except for the group leader.
+ */
+struct cdata {
+	cputime_t cutime, cstime, cgtime;
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
@@ -573,22 +587,19 @@ struct signal_struct {
 
 	struct tty_struct *tty; /* NULL if no tty */
 
-	/*
-	 * Cumulative resource counters for dead threads in the group,
-	 * and for reaped dead child processes forked by this group.
-	 * Live threads maintain their own counters and add to these
-	 * in __exit_signal, except for the group leader.
-	 */
-	cputime_t utime, stime, cutime, cstime;
+	/* Cumulative resource counters for all dead child processes */
+	struct cdata cdata_wait; /* parents have done sys_wait() */
+	struct cdata cdata_acct; /* complete cumulative data from acct tree */
+
+	cputime_t utime, stime;
 	cputime_t gtime;
-	cputime_t cgtime;
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	cputime_t prev_utime, prev_stime;
 #endif
-	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
-	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
-	unsigned long inblock, oublock, cinblock, coublock;
-	unsigned long maxrss, cmaxrss;
+	unsigned long nvcsw, nivcsw;
+	unsigned long min_flt, maj_flt;
+	unsigned long inblock, oublock;
+	unsigned long maxrss;
 	struct task_io_accounting ioac;
 
 	/*
@@ -1248,6 +1259,7 @@ struct task_struct {
 	 * older sibling, respectively.  (p->father can be replaced with 
 	 * p->real_parent->pid)
 	 */
+	struct task_struct *acct_parent; /* accounting parent process */
 	struct task_struct *real_parent; /* real parent process */
 	struct task_struct *parent; /* recipient of SIGCHLD, wait4() reports */
 	/*
@@ -1255,6 +1267,8 @@ struct task_struct {
 	 */
 	struct list_head children;	/* list of my children */
 	struct list_head sibling;	/* linkage in my parent's children list */
+	struct list_head children_acct;	/* list of my accounting children */
+	struct list_head sibling_acct;	/* linkage in my parent's accounting children list */
 	struct task_struct *group_leader;	/* threadgroup leader */
 
 	/*
@@ -1273,6 +1287,7 @@ struct task_struct {
 	int __user *set_child_tid;		/* CLONE_CHILD_SETTID */
 	int __user *clear_child_tid;		/* CLONE_CHILD_CLEARTID */
 
+	int exit_accounting_done;
 	cputime_t utime, stime, utimescaled, stimescaled;
 	cputime_t gtime;
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
--- a/include/linux/taskstats.h
+++ b/include/linux/taskstats.h
@@ -163,6 +163,10 @@ struct taskstats {
 	/* Delay waiting for memory reclaim */
 	__u64	freepages_count;
 	__u64	freepages_delay_total;
+	__u64   ac_cutime;		/* User CPU time of childs [usec] */
+	__u64   ac_cstime;		/* System CPU time of childs [usec] */
+	__u64   ac_tutime;		/* User CPU time of threads [usec] */
+	__u64   ac_tstime;		/* System CPU time of threads [usec] */
 };
 
 
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -50,6 +50,7 @@
 #include <linux/perf_event.h>
 #include <trace/events/sched.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/kernel_stat.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -68,11 +69,76 @@ static void __unhash_process(struct task
 
 		list_del_rcu(&p->tasks);
 		list_del_init(&p->sibling);
+		list_del_init(&p->sibling_acct);
 		__get_cpu_var(process_counts)--;
 	}
 	list_del_rcu(&p->thread_group);
 }
 
+static void __account_ctime(struct task_struct *p, struct cdata *pcd,
+			    struct cdata *ccd)
+{
+	struct signal_struct *sig = p->signal;
+	cputime_t tgutime, tgstime;
+	unsigned long maxrss;
+
+	thread_group_times(p, &tgutime, &tgstime);
+
+	pcd->cutime = cputime_add(pcd->cutime,
+				  cputime_add(tgutime, ccd->cutime));
+	pcd->cstime = cputime_add(pcd->cstime,
+				  cputime_add(tgstime, ccd->cstime));
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
+}
+
+static void __account_to_parent(struct task_struct *p, int wait)
+{
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
+	if (wait)
+		__account_ctime(p, &p->real_parent->signal->cdata_wait,
+				&p->signal->cdata_wait);
+	__account_ctime(p, &p->acct_parent->signal->cdata_acct,
+			&p->signal->cdata_acct);
+	p->exit_accounting_done = 1;
+}
+
 /*
  * This function expects the tasklist_lock write-locked.
  */
@@ -90,6 +156,24 @@ static void __exit_signal(struct task_st
 
 	posix_cpu_timers_exit(tsk);
 	if (group_dead) {
+		if (!tsk->exit_accounting_done) {
+#ifdef __s390x__
+		/*
+		 * FIXME: On s390 we can call account_process_tick to update
+		 * CPU time information. This is probably not valid on other
+		 * architectures.
+		 */
+			if (current == tsk)
+				account_process_tick(current, 1);
+#endif
+			/*
+			 * FIXME: This somehow has to be moved to
+			 * finish_task_switch(), because otherwise
+			 * if the process accounts itself, the CPU time
+			 * that is used for this code will be lost.
+			 */
+			__account_to_parent(tsk, 0);
+		}
 		posix_cpu_timers_exit_group(tsk);
 		tty = sig->tty;
 		sig->tty = NULL;
@@ -103,6 +187,15 @@ static void __exit_signal(struct task_st
 
 		if (tsk == sig->curr_target)
 			sig->curr_target = next_thread(tsk);
+#ifdef __s390x__
+		/*
+		 * FIXME: On s390 we can call account_process_tick to update
+		 * CPU time information. This is probably not valid on other
+		 * architectures.
+		 */
+		if (current == tsk)
+			account_process_tick(current, 1);
+#endif
 		/*
 		 * Accumulate here the counters for all threads but the
 		 * group leader as they die, so they can be added into
@@ -122,7 +215,8 @@ static void __exit_signal(struct task_st
 		sig->nivcsw += tsk->nivcsw;
 		sig->inblock += task_io_get_inblock(tsk);
 		sig->oublock += task_io_get_oublock(tsk);
-		task_io_accounting_add(&sig->ioac, &tsk->ioac);
+		task_io_accounting_add(&sig->cdata_wait.ioac,
+				       &tsk->ioac);
 		sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
 	}
 
@@ -334,7 +428,10 @@ static void reparent_to_kthreadd(void)
 	ptrace_unlink(current);
 	/* Reparent to init */
 	current->real_parent = current->parent = kthreadd_task;
+	current->acct_parent = current->acct_parent->acct_parent;
 	list_move_tail(&current->sibling, &current->real_parent->children);
+	list_move_tail(&current->sibling_acct,
+		       &current->acct_parent->children_acct);
 
 	/* Set the exit signal to SIGCHLD so we signal init on exit */
 	current->exit_signal = SIGCHLD;
@@ -772,6 +869,15 @@ static void forget_original_parent(struc
 	LIST_HEAD(dead_children);
 
 	write_lock_irq(&tasklist_lock);
+	list_for_each_entry_safe(p, n, &father->children_acct, sibling_acct) {
+		struct task_struct *t = p;
+		do {
+			t->acct_parent = t->acct_parent->acct_parent;
+		} while_each_thread(p, t);
+		list_move_tail(&p->sibling_acct,
+			       &p->acct_parent->children_acct);
+	}
+
 	/*
 	 * Note that exit_ptrace() and find_new_reaper() might
 	 * drop tasklist_lock and reacquire it.
@@ -799,6 +905,7 @@ static void forget_original_parent(struc
 
 	list_for_each_entry_safe(p, n, &dead_children, sibling) {
 		list_del_init(&p->sibling);
+		list_del_init(&p->sibling_acct);
 		release_task(p);
 	}
 }
@@ -1214,66 +1321,8 @@ static int wait_task_zombie(struct wait_
 	 * !task_detached() to filter out sub-threads.
 	 */
 	if (likely(!traced) && likely(!task_detached(p))) {
-		struct signal_struct *psig;
-		struct signal_struct *sig;
-		unsigned long maxrss;
-		cputime_t tgutime, tgstime;
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
-		thread_group_times(p, &tgutime, &tgstime);
 		spin_lock_irq(&p->real_parent->sighand->siglock);
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
+		__account_to_parent(p, 1);
 		spin_unlock_irq(&p->real_parent->sighand->siglock);
 	}
 
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1047,7 +1047,9 @@ static struct task_struct *copy_process(
 	delayacct_tsk_init(p);	/* Must remain after dup_task_struct() */
 	copy_flags(clone_flags, p);
 	INIT_LIST_HEAD(&p->children);
+	INIT_LIST_HEAD(&p->children_acct);
 	INIT_LIST_HEAD(&p->sibling);
+	INIT_LIST_HEAD(&p->sibling_acct);
 	rcu_copy_process(p);
 	p->vfork_done = NULL;
 	spin_lock_init(&p->alloc_lock);
@@ -1231,8 +1233,10 @@ static struct task_struct *copy_process(
 	/* CLONE_PARENT re-uses the old parent */
 	if (clone_flags & (CLONE_PARENT|CLONE_THREAD)) {
 		p->real_parent = current->real_parent;
+		p->acct_parent = current->acct_parent;
 		p->parent_exec_id = current->parent_exec_id;
 	} else {
+		p->acct_parent = current;
 		p->real_parent = current;
 		p->parent_exec_id = current->self_exec_id;
 	}
@@ -1275,6 +1279,8 @@ static struct task_struct *copy_process(
 			attach_pid(p, PIDTYPE_PGID, task_pgrp(current));
 			attach_pid(p, PIDTYPE_SID, task_session(current));
 			list_add_tail(&p->sibling, &p->real_parent->children);
+			list_add_tail(&p->sibling_acct,
+				      &p->acct_parent->children_acct);
 			list_add_tail_rcu(&p->tasks, &init_task.tasks);
 			__get_cpu_var(process_counts)++;
 		}
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -884,8 +884,8 @@ void do_sys_times(struct tms *tms)
 
 	spin_lock_irq(&current->sighand->siglock);
 	thread_group_times(current, &tgutime, &tgstime);
-	cutime = current->signal->cutime;
-	cstime = current->signal->cstime;
+	cutime = current->signal->cdata_wait.cutime;
+	cstime = current->signal->cdata_wait.cstime;
 	spin_unlock_irq(&current->sighand->siglock);
 	tms->tms_utime = cputime_to_clock_t(tgutime);
 	tms->tms_stime = cputime_to_clock_t(tgstime);
@@ -1490,6 +1490,7 @@ static void k_getrusage(struct task_stru
 	unsigned long flags;
 	cputime_t tgutime, tgstime, utime, stime;
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
@@ -62,6 +62,19 @@ void bacct_add_tsk(struct taskstats *sta
 	stats->ac_gid	 = tcred->gid;
 	stats->ac_ppid	 = pid_alive(tsk) ?
 				rcu_dereference(tsk->real_parent)->tgid : 0;
+	if (tsk->signal && tsk->tgid == tsk->pid) {
+		struct cdata *cd = &tsk->signal->cdata_acct;
+
+		stats->ac_cutime = cputime_to_usecs(cd->cutime);
+		stats->ac_cstime = cputime_to_usecs(cd->cstime);
+		stats->ac_tutime = cputime_to_usecs(tsk->signal->utime);
+		stats->ac_tstime = cputime_to_usecs(tsk->signal->stime);
+	} else {
+		stats->ac_cutime = 0;
+		stats->ac_cstime = 0;
+		stats->ac_tutime = 0;
+		stats->ac_tstime = 0;
+	}
 	rcu_read_unlock();
 	stats->ac_utime = cputime_to_usecs(tsk->utime);
 	stats->ac_stime = cputime_to_usecs(tsk->stime);


