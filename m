Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378Ab0JVQxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 12:53:36 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:39475 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab0JVQxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 12:53:34 -0400
Subject: Re: [RFC][PATCH 09/10] taskstats: Fix exit CPU time accounting
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
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
In-Reply-To: <20101019141725.GA32361@redhat.com>
References: <20100929191916.21E1840038@magilla.sf.frob.com>
	 <1285854460.1856.14.camel@holzheu-laptop>
	 <20101005085751.4490A401B2@magilla.sf.frob.com>
	 <1286357350.1888.25.camel@holzheu-laptop>
	 <20101006152609.GA21169@redhat.com>
	 <1286464017.1849.120.camel@holzheu-laptop>
	 <20101011123704.GA3519@redhat.com>
	 <1286889057.1932.77.camel@holzheu-laptop>
	 <20101014134716.GA5187@redhat.com>
	 <1287153246.1896.231.camel@holzheu-laptop>
	 <20101019141725.GA32361@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Fri, 22 Oct 2010 18:53:29 +0200
Message-ID: <1287766409.1998.27.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Oleg,

On Tue, 2010-10-19 at 16:17 +0200, Oleg Nesterov wrote:
> On 10/15, Michael Holzheu wrote:
> >
> > On Thu, 2010-10-14 at 15:47 +0200, Oleg Nesterov wrote:
> >
> > > Yes. But __account_to_parent() always sets p->exit_accounting_done = 1.
> > > And __exit_signal() calls __account_to_parent() only if it is not set.
> > >
> > > This means that we update either cdata_wait (if the child was reaped
> > > by parent) or cdata_acct (the process auto-reaps itself).
> >
> > No. The accounting of cdata_acct is done unconditionally in
> > __account_to_parent(). It is done for both cases wait=0 and wait=1,
> > therefore no CPU time gets lost. Accounting of cdata_wait is done only
> > on the sys_wait() path, where "wait" is "1".
> 
> Ah, got it, I didn't notice this detail.
> 
> Thanks.
> 
> > I think it works as it currently is. But as already said, this probably
> > could be done better. At least your confusion seems to prove that :-)
> 
> Perhaps ;)
> 
> To me, it would be cleaner and simpler if you kill ->exit_accounting_done.
> Both wait_task_zombie() and __exit_signal() could just call
> __account_to_parent(parent_for_accounting) unconditionally passing
> either real_parent or acct_parent as an argument. This also saves a
> word in task_struct.

Yes, this works and is better than using the exit_accounting_done flag.
I changed my patch accordingly, see below!

> > de_thread() is also a very interesting spot for accounting. The thread
> > that calls exec() gets a bit of the identity of the old thread group
> > leader e.g. PID and start time, but it keeps the old CPU times. This
> > looks strange to me.
> 
> Well, the main thread represents the whole process for ps/etc, that
> is why we update ->start_time.
> 
> But,
> 
> > Wouldn't it be better to either exchange the accounting data between old
> > and new leader
> 
> I dunno. The exiting old leader will update sig->utime/etc, so we do not
> lose this info from the "whole process" pov. But yes, if user-space
> looks at the single thread with that TGID it can notice that, say, utime
> goes backward.

I think it would be an improvement, if we exchange the accounting data
between the old and the new leader. After that, for user space
accounting will look consistent again. I will try to make a patch as
proposal for that.

> > or add the current accounting data of the new leader to
> > the signal struct and initialize them with zero again?
> 
> Sorry, I don't understand this "initialize them with zero". What
> is "them" ?

Sorry, I meant that the accounting fields of the new leader could be set
to zero. The semantics would then be that at exec() with the new binary
also task accounting is started from the beginning.

[snip]

> I am not sure this really makes sense, but in fact you can move
> ->acct_sibling and ->acct_childen from task_struct to signal_struct
> as well, note that you can trivially find the group leader looking
> at signal->leader_pid.

And I use pid_task() to get the leader task_struct via leader_pid?

> (actually, ->group_leader should be moved
> to signal_struct, but this is another story).

Then we would not need pid_task()...

> In this case de_thread()
> needs no changes, and we save the space in task_struct.

Below I attached a patch that implements your proposal. I moved
everything to the signal struct and instead of creating a task_struct
accounting tree, I now create a signal_struct tree which represents the
processes (in contrast to threads).

Probably some locking is missing in the patch, but it should show the
principle.

Michael
---
 fs/binfmt_elf.c           |    4 -
 fs/proc/array.c           |   10 +--
 fs/proc/base.c            |    3 
 include/linux/init_task.h |    2 
 include/linux/sched.h     |   35 ++++++++--
 kernel/exit.c             |  150 +++++++++++++++++++++++++++-------------------
 kernel/fork.c             |    7 ++
 kernel/sys.c              |   24 +++----
 8 files changed, 149 insertions(+), 86 deletions(-)

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
@@ -29,6 +29,8 @@ extern struct fs_struct init_fs;
 		.running = 0,						\
 		.lock = __SPIN_LOCK_UNLOCKED(sig.cputimer.lock),	\
 	},								\
+	.acct_sibling	= LIST_HEAD_INIT(sig.acct_sibling),		\
+	.acct_children	= LIST_HEAD_INIT(sig.acct_children),		\
 }
 
 extern struct nsproxy init_nsproxy;
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
@@ -579,17 +593,24 @@ struct signal_struct {
 	 * Live threads maintain their own counters and add to these
 	 * in __exit_signal, except for the group leader.
 	 */
-	cputime_t utime, stime, cutime, cstime;
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
-	struct task_io_accounting ioac;
+	unsigned long nvcsw, nivcsw;
+	unsigned long min_flt, maj_flt;
+	unsigned long inblock, oublock;
+	unsigned long maxrss;
+
+	/* Cumulative resource counters for all dead child processes */
+	struct cdata cdata_wait; /* parents have done sys_wait() */
+	struct cdata cdata_acct; /* complete cumulative data from acct tree */
+
+	/* Parallel accounting tree */
+	struct signal_struct *acct_parent; /* accounting parent process */
+	struct list_head acct_children;    /* list of my accounting children */
+	struct list_head acct_sibling;     /* linkage in my parent's list */
 
 	/*
 	 * Cumulative ns of schedule CPU time fo dead threads in the
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -50,6 +50,7 @@
 #include <linux/perf_event.h>
 #include <trace/events/sched.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/kernel_stat.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -73,6 +74,60 @@ static void __unhash_process(struct task
 	list_del_rcu(&p->thread_group);
 }
 
+static void __account_ctime(struct task_struct *p, struct cdata *pcd,
+			    struct cdata *ccd)
+{
+	struct signal_struct *sig = p->signal;
+	cputime_t tgutime, tgstime;
+	unsigned long maxrss;
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
 /*
  * This function expects the tasklist_lock write-locked.
  */
@@ -83,6 +138,21 @@ static void __exit_signal(struct task_st
 	struct sighand_struct *sighand;
 	struct tty_struct *uninitialized_var(tty);
 
+	if (group_dead) {
+		struct task_struct *acct_parent =
+			pid_task(sig->acct_parent->leader_pid, PIDTYPE_PID);
+		/*
+		 * FIXME: This somehow has to be moved to
+		 * finish_task_switch(), because otherwise
+		 * if the process accounts itself, the CPU time
+		 * that is used for this code will be lost.
+		 */
+		spin_lock(&acct_parent->sighand->siglock);
+		__account_ctime(tsk, &sig->acct_parent->cdata_acct,
+				&sig->cdata_acct);
+		spin_unlock(&acct_parent->sighand->siglock);
+		list_del_init(&sig->acct_sibling);
+	}
 	sighand = rcu_dereference_check(tsk->sighand,
 					rcu_read_lock_held() ||
 					lockdep_tasklist_lock_is_held());
@@ -122,7 +192,8 @@ static void __exit_signal(struct task_st
 		sig->nivcsw += tsk->nivcsw;
 		sig->inblock += task_io_get_inblock(tsk);
 		sig->oublock += task_io_get_oublock(tsk);
-		task_io_accounting_add(&sig->ioac, &tsk->ioac);
+		task_io_accounting_add(&sig->cdata_wait.ioac,
+				       &tsk->ioac);
 		sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
 	}
 
@@ -731,6 +802,17 @@ static struct task_struct *find_new_reap
 	return pid_ns->child_reaper;
 }
 
+static void reparent_acct(struct signal_struct *father)
+{
+	struct signal_struct *c, *n, *new_parent;
+
+	new_parent = father->acct_parent;
+	list_for_each_entry_safe(c, n, &father->acct_children, acct_sibling) {
+		c->acct_parent = new_parent;
+		list_move_tail(&c->acct_sibling, &new_parent->acct_children);
+	}
+}
+
 /*
 * Any that need to be release_task'd are put on the @dead list.
  */
@@ -748,6 +830,11 @@ static void reparent_leader(struct task_
 	if (same_thread_group(p->real_parent, father))
 		return;
 
+	/*
+	 * Father is thread group leader
+	 */
+	reparent_acct(father->signal);
+
 	/* We don't want people slaying init.  */
 	p->exit_signal = SIGCHLD;
 
@@ -1212,66 +1299,9 @@ static int wait_task_zombie(struct wait_
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
+		__account_ctime(p, &p->real_parent->signal->cdata_wait,
+				&p->signal->cdata_wait);
 		spin_unlock_irq(&p->real_parent->sighand->siglock);
 	}
 
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1282,6 +1282,13 @@ static struct task_struct *copy_process(
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


