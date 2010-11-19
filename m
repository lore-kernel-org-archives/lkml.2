Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab0KSUMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 15:12:07 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:47820 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab0KSULv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 15:11:51 -0500
Message-Id: <20101119201143.787050299@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Fri, 19 Nov 2010 21:11:09 +0100
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>, Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 1/4] taskstats: Introduce "struct cdata"
References: <20101119201108.269346583@linux.vnet.ibm.com>
Content-Disposition: inline; filename=01-taskstats-top-improve-ctime-add-cdata-struct.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

This patch introduces a new structure "struct cdata" that is used to
store cumulative resource counters for dead child processes and threads.

Note that there is one asymmetry:
For "struct task_io_accounting" (ioc) there is no extra accounting field for
dead threads. One field is used for both, dead processes and threads.

This patch introduces no functional change.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 fs/binfmt_elf.c           |    4 +-
 fs/exec.c                 |    2 -
 fs/proc/array.c           |   16 ++++----
 include/linux/sched.h     |   22 +++++++----
 kernel/exit.c             |   86 ++++++++++++++++++++++++----------------------
 kernel/posix-cpu-timers.c |   12 +++---
 kernel/sys.c              |   44 ++++++++++++-----------
 7 files changed, 100 insertions(+), 86 deletions(-)

--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1296,8 +1296,8 @@ static void fill_prstatus(struct elf_prs
 		cputime_to_timeval(p->utime, &prstatus->pr_utime);
 		cputime_to_timeval(p->stime, &prstatus->pr_stime);
 	}
-	cputime_to_timeval(p->signal->cutime, &prstatus->pr_cutime);
-	cputime_to_timeval(p->signal->cstime, &prstatus->pr_cstime);
+	cputime_to_timeval(p->signal->cdata_wait.utime, &prstatus->pr_cutime);
+	cputime_to_timeval(p->signal->cdata_wait.stime, &prstatus->pr_cstime);
 }
 
 static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -894,7 +894,7 @@ static int de_thread(struct task_struct
 
 no_thread_group:
 	if (current->mm)
-		setmax_mm_hiwater_rss(&sig->maxrss, current->mm);
+		setmax_mm_hiwater_rss(&sig->cdata_threads.maxrss, current->mm);
 
 	exit_itimers(sig);
 	flush_itimer_signals();
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
+		cmin_flt = sig->cdata_wait.min_flt;
+		cmaj_flt = sig->cdata_wait.maj_flt;
+		cutime = sig->cdata_wait.utime;
+		cstime = sig->cdata_wait.stime;
+		cgtime = sig->cdata_wait.gtime;
 		rsslim = ACCESS_ONCE(sig->rlim[RLIMIT_RSS].rlim_cur);
 
 		/* add up live thread stats at the group level */
@@ -430,10 +430,10 @@ static int do_task_stat(struct seq_file
 				t = next_thread(t);
 			} while (t != task);
 
-			min_flt += sig->min_flt;
-			maj_flt += sig->maj_flt;
+			min_flt += sig->cdata_threads.min_flt;
+			maj_flt += sig->cdata_threads.maj_flt;
 			thread_group_times(task, &utime, &stime);
-			gtime = cputime_add(gtime, sig->gtime);
+			gtime = cputime_add(gtime, sig->cdata_threads.gtime);
 		}
 
 		sid = task_session_nr_ns(task, ns);
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -510,6 +510,17 @@ struct thread_group_cputimer {
 };
 
 /*
+ * Cumulative resource counters
+ */
+struct cdata {
+	cputime_t utime, stime, gtime;
+	unsigned long nvcsw, nivcsw;
+	unsigned long min_flt, maj_flt;
+	unsigned long inblock, oublock;
+	unsigned long maxrss;
+};
+
+/*
  * NOTE! "signal_struct" does not have it's own
  * locking, because a shared signal_struct always
  * implies a shared sighand_struct, so locking
@@ -582,17 +593,12 @@ struct signal_struct {
 	 * Live threads maintain their own counters and add to these
 	 * in __exit_signal, except for the group leader.
 	 */
-	cputime_t utime, stime, cutime, cstime;
-	cputime_t gtime;
-	cputime_t cgtime;
+	struct cdata cdata_wait;
+	struct cdata cdata_threads;
+	struct task_io_accounting ioac;
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	cputime_t prev_utime, prev_stime;
 #endif
-	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
-	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
-	unsigned long inblock, oublock, cinblock, coublock;
-	unsigned long maxrss, cmaxrss;
-	struct task_io_accounting ioac;
 
 	/*
 	 * Cumulative ns of schedule CPU time fo dead threads in the
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -95,6 +95,7 @@ static void __exit_signal(struct task_st
 		tty = sig->tty;
 		sig->tty = NULL;
 	} else {
+		struct cdata *tcd = &sig->cdata_threads;
 		/*
 		 * This can only happen if the caller is de_thread().
 		 * FIXME: this is the temporary hack, we should teach
@@ -122,15 +123,15 @@ static void __exit_signal(struct task_st
 		 * We won't ever get here for the group leader, since it
 		 * will have been the last reference on the signal_struct.
 		 */
-		sig->utime = cputime_add(sig->utime, tsk->utime);
-		sig->stime = cputime_add(sig->stime, tsk->stime);
-		sig->gtime = cputime_add(sig->gtime, tsk->gtime);
-		sig->min_flt += tsk->min_flt;
-		sig->maj_flt += tsk->maj_flt;
-		sig->nvcsw += tsk->nvcsw;
-		sig->nivcsw += tsk->nivcsw;
-		sig->inblock += task_io_get_inblock(tsk);
-		sig->oublock += task_io_get_oublock(tsk);
+		tcd->utime = cputime_add(tcd->utime, tsk->utime);
+		tcd->stime = cputime_add(tcd->stime, tsk->stime);
+		tcd->gtime = cputime_add(tcd->gtime, tsk->gtime);
+		tcd->min_flt += tsk->min_flt;
+		tcd->maj_flt += tsk->maj_flt;
+		tcd->nvcsw += tsk->nvcsw;
+		tcd->nivcsw += tsk->nivcsw;
+		tcd->inblock += task_io_get_inblock(tsk);
+		tcd->oublock += task_io_get_oublock(tsk);
 		task_io_accounting_add(&sig->ioac, &tsk->ioac);
 		sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
 	}
@@ -960,10 +961,11 @@ NORET_TYPE void do_exit(long code)
 		sync_mm_rss(tsk, tsk->mm);
 	group_dead = atomic_dec_and_test(&tsk->signal->live);
 	if (group_dead) {
+		struct cdata *tcd = &tsk->signal->cdata_threads;
 		hrtimer_cancel(&tsk->signal->real_timer);
 		exit_itimers(tsk->signal);
 		if (tsk->mm)
-			setmax_mm_hiwater_rss(&tsk->signal->maxrss, tsk->mm);
+			setmax_mm_hiwater_rss(&tcd->maxrss, tsk->mm);
 	}
 	acct_collect(code, group_dead);
 	if (group_dead)
@@ -1225,8 +1227,7 @@ static int wait_task_zombie(struct wait_
 	 * !task_detached() to filter out sub-threads.
 	 */
 	if (likely(!traced) && likely(!task_detached(p))) {
-		struct signal_struct *psig;
-		struct signal_struct *sig;
+		struct cdata *cd, *pcd, *tcd;
 		unsigned long maxrss;
 		cputime_t tgutime, tgstime;
 
@@ -1251,40 +1252,43 @@ static int wait_task_zombie(struct wait_
 		 */
 		thread_group_times(p, &tgutime, &tgstime);
 		spin_lock_irq(&p->real_parent->sighand->siglock);
-		psig = p->real_parent->signal;
-		sig = p->signal;
-		psig->cutime =
-			cputime_add(psig->cutime,
+		pcd = &p->real_parent->signal->cdata_wait;
+		tcd = &p->signal->cdata_threads;
+		cd = &p->signal->cdata_wait;
+
+		pcd->utime =
+			cputime_add(pcd->utime,
 			cputime_add(tgutime,
-				    sig->cutime));
-		psig->cstime =
-			cputime_add(psig->cstime,
+				    cd->utime));
+		pcd->stime =
+			cputime_add(pcd->stime,
 			cputime_add(tgstime,
-				    sig->cstime));
-		psig->cgtime =
-			cputime_add(psig->cgtime,
+				    cd->stime));
+		pcd->gtime =
+			cputime_add(pcd->gtime,
 			cputime_add(p->gtime,
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
+			cputime_add(tcd->gtime,
+				    cd->gtime)));
+		pcd->min_flt +=
+			p->min_flt + tcd->min_flt + cd->min_flt;
+		pcd->maj_flt +=
+			p->maj_flt + tcd->maj_flt + cd->maj_flt;
+		pcd->nvcsw +=
+			p->nvcsw + tcd->nvcsw + cd->nvcsw;
+		pcd->nivcsw +=
+			p->nivcsw + tcd->nivcsw + cd->nivcsw;
+		pcd->inblock +=
 			task_io_get_inblock(p) +
-			sig->inblock + sig->cinblock;
-		psig->coublock +=
+			tcd->inblock + cd->inblock;
+		pcd->oublock +=
 			task_io_get_oublock(p) +
-			sig->oublock + sig->coublock;
-		maxrss = max(sig->maxrss, sig->cmaxrss);
-		if (psig->cmaxrss < maxrss)
-			psig->cmaxrss = maxrss;
-		task_io_accounting_add(&psig->ioac, &p->ioac);
-		task_io_accounting_add(&psig->ioac, &sig->ioac);
+			tcd->oublock + cd->oublock;
+		maxrss = max(tcd->maxrss, cd->maxrss);
+		if (pcd->maxrss < maxrss)
+			pcd->maxrss = maxrss;
+		task_io_accounting_add(&p->real_parent->signal->ioac, &p->ioac);
+		task_io_accounting_add(&p->real_parent->signal->ioac,
+				       &p->signal->ioac);
 		spin_unlock_irq(&p->real_parent->sighand->siglock);
 	}
 
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -232,12 +232,12 @@ static int cpu_clock_sample(const clocki
 
 void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 {
-	struct signal_struct *sig = tsk->signal;
+	struct cdata *tcd = &tsk->signal->cdata_threads;
 	struct task_struct *t;
 
-	times->utime = sig->utime;
-	times->stime = sig->stime;
-	times->sum_exec_runtime = sig->sum_sched_runtime;
+	times->utime = tcd->utime;
+	times->stime = tcd->stime;
+	times->sum_exec_runtime = tsk->signal->sum_sched_runtime;
 
 	rcu_read_lock();
 	/* make sure we can trust tsk->thread_group list */
@@ -516,8 +516,8 @@ void posix_cpu_timers_exit_group(struct
 	struct signal_struct *const sig = tsk->signal;
 
 	cleanup_timers(tsk->signal->cpu_timers,
-		       cputime_add(tsk->utime, sig->utime),
-		       cputime_add(tsk->stime, sig->stime),
+		       cputime_add(tsk->utime, sig->cdata_threads.utime),
+		       cputime_add(tsk->stime, sig->cdata_threads.stime),
 		       tsk->se.sum_exec_runtime + sig->sum_sched_runtime);
 }
 
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -884,8 +884,8 @@ void do_sys_times(struct tms *tms)
 
 	spin_lock_irq(&current->sighand->siglock);
 	thread_group_times(current, &tgutime, &tgstime);
-	cutime = current->signal->cutime;
-	cstime = current->signal->cstime;
+	cutime = current->signal->cdata_wait.utime;
+	cstime = current->signal->cdata_wait.stime;
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
@@ -1497,7 +1498,7 @@ static void k_getrusage(struct task_stru
 	if (who == RUSAGE_THREAD) {
 		task_times(current, &utime, &stime);
 		accumulate_thread_rusage(p, r);
-		maxrss = p->signal->maxrss;
+		maxrss = p->signal->cdata_threads.maxrss;
 		goto out;
 	}
 
@@ -1507,31 +1508,34 @@ static void k_getrusage(struct task_stru
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
+			utime = cd->utime;
+			stime = cd->stime;
+			r->ru_nvcsw = cd->nvcsw;
+			r->ru_nivcsw = cd->nivcsw;
+			r->ru_minflt = cd->min_flt;
+			r->ru_majflt = cd->maj_flt;
+			r->ru_inblock = cd->inblock;
+			r->ru_oublock = cd->oublock;
+			maxrss = cd->maxrss;
 
 			if (who == RUSAGE_CHILDREN)
 				break;
 
 		case RUSAGE_SELF:
+			cd = &p->signal->cdata_threads;
 			thread_group_times(p, &tgutime, &tgstime);
 			utime = cputime_add(utime, tgutime);
 			stime = cputime_add(stime, tgstime);
-			r->ru_nvcsw += p->signal->nvcsw;
-			r->ru_nivcsw += p->signal->nivcsw;
-			r->ru_minflt += p->signal->min_flt;
-			r->ru_majflt += p->signal->maj_flt;
-			r->ru_inblock += p->signal->inblock;
-			r->ru_oublock += p->signal->oublock;
-			if (maxrss < p->signal->maxrss)
-				maxrss = p->signal->maxrss;
+			r->ru_nvcsw += cd->nvcsw;
+			r->ru_nivcsw += cd->nivcsw;
+			r->ru_minflt += cd->min_flt;
+			r->ru_majflt += cd->maj_flt;
+			r->ru_inblock += cd->inblock;
+			r->ru_oublock += cd->oublock;
+			if (maxrss < cd->maxrss)
+				maxrss = cd->maxrss;
+
 			t = p;
 			do {
 				accumulate_thread_rusage(t, r);

