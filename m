Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab0IWOCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 10:02:05 -0400
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:42880 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab0IWOCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 10:02:00 -0400
Subject: [RFC][PATCH 07/10] taskstats: Add per task steal time accounting
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1285249681.1837.28.camel@holzheu-laptop>
References: <1285249681.1837.28.camel@holzheu-laptop>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Thu, 23 Sep 2010 16:01:55 +0200
Message-ID: <1285250515.1837.91.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] taskstats: Add per task steal time accounting

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

Currently steal time is only accounted for the whole system. With this
patch we add steal time to the per task CPU time accounting.
The triplet "user time", "system time" and "steal time" represents
all consumed CPU time on hypervisor based systems.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 arch/s390/kernel/vtime.c    |    2 +-
 fs/proc/array.c             |    6 +++---
 include/linux/kernel_stat.h |    2 +-
 include/linux/sched.h       |   14 ++++++++------
 include/linux/taskstats.h   |    1 +
 kernel/exit.c               |    9 +++++++--
 kernel/fork.c               |    1 +
 kernel/posix-cpu-timers.c   |    3 +++
 kernel/sched.c              |   26 ++++++++++++++++++++------
 kernel/sys.c                |   10 +++++-----
 kernel/tsacct.c             |    1 +
 11 files changed, 51 insertions(+), 24 deletions(-)

Index: git-linux-2.6/arch/s390/kernel/vtime.c
===================================================================
--- git-linux-2.6.orig/arch/s390/kernel/vtime.c	2010-09-23 14:16:17.000000000 +0200
+++ git-linux-2.6/arch/s390/kernel/vtime.c	2010-09-23 14:16:37.000000000 +0200
@@ -83,7 +83,7 @@
 		steal -= user + system;
 	else
 		steal = 0;
-	account_steal_time(steal);
+	account_steal_time(tsk, steal);
 }
 
 void account_vtime(struct task_struct *prev, struct task_struct *next)
Index: git-linux-2.6/fs/proc/array.c
===================================================================
--- git-linux-2.6.orig/fs/proc/array.c	2010-09-23 14:14:03.000000000 +0200
+++ git-linux-2.6/fs/proc/array.c	2010-09-23 14:16:37.000000000 +0200
@@ -375,7 +375,7 @@
 	unsigned long long start_time;
 	unsigned long cmin_flt = 0, cmaj_flt = 0;
 	unsigned long  min_flt = 0,  maj_flt = 0;
-	cputime_t cutime, cstime, utime, stime;
+	cputime_t cutime, cstime, utime, stime, sttime;
 	cputime_t cgtime, gtime;
 	unsigned long rsslim = 0;
 	char tcomm[sizeof(task->comm)];
@@ -432,7 +432,7 @@
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
-			thread_group_times(task, &utime, &stime);
+			thread_group_times(task, &utime, &stime, &sttime);
 			gtime = cputime_add(gtime, sig->gtime);
 		}
 
@@ -448,7 +448,7 @@
 	if (!whole) {
 		min_flt = task->min_flt;
 		maj_flt = task->maj_flt;
-		task_times(task, &utime, &stime);
+		task_times(task, &utime, &stime, &sttime);
 		gtime = task->gtime;
 	}
 
Index: git-linux-2.6/include/linux/kernel_stat.h
===================================================================
--- git-linux-2.6.orig/include/linux/kernel_stat.h	2010-09-23 14:14:03.000000000 +0200
+++ git-linux-2.6/include/linux/kernel_stat.h	2010-09-23 14:16:37.000000000 +0200
@@ -102,7 +102,7 @@
 
 extern void account_user_time(struct task_struct *, cputime_t, cputime_t);
 extern void account_system_time(struct task_struct *, int, cputime_t, cputime_t);
-extern void account_steal_time(cputime_t);
+extern void account_steal_time(struct task_struct *, cputime_t);
 extern void account_idle_time(cputime_t);
 
 extern void account_process_tick(struct task_struct *, int user);
Index: git-linux-2.6/include/linux/sched.h
===================================================================
--- git-linux-2.6.orig/include/linux/sched.h	2010-09-23 14:16:17.000000000 +0200
+++ git-linux-2.6/include/linux/sched.h	2010-09-23 14:16:37.000000000 +0200
@@ -467,6 +467,7 @@
 struct task_cputime {
 	cputime_t utime;
 	cputime_t stime;
+	cputime_t sttime;
 	unsigned long long sum_exec_runtime;
 };
 /* Alternate field names when used to cache expirations. */
@@ -478,6 +479,7 @@
 	(struct task_cputime) {					\
 		.utime = cputime_zero,				\
 		.stime = cputime_zero,				\
+		.sttime = cputime_zero,				\
 		.sum_exec_runtime = 0,				\
 	}
 
@@ -579,11 +581,11 @@
 	 * Live threads maintain their own counters and add to these
 	 * in __exit_signal, except for the group leader.
 	 */
-	cputime_t utime, stime, cutime, cstime;
+	cputime_t utime, stime, sttime, cutime, cstime, csttime;
 	cputime_t gtime;
 	cputime_t cgtime;
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
-	cputime_t prev_utime, prev_stime;
+	cputime_t prev_utime, prev_stime, prev_sttime;
 #endif
 	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
 	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
@@ -1274,10 +1276,10 @@
 	int __user *set_child_tid;		/* CLONE_CHILD_SETTID */
 	int __user *clear_child_tid;		/* CLONE_CHILD_CLEARTID */
 
-	cputime_t utime, stime, utimescaled, stimescaled;
+	cputime_t utime, stime, sttime, utimescaled, stimescaled;
 	cputime_t gtime;
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
-	cputime_t prev_utime, prev_stime;
+	cputime_t prev_utime, prev_stime, prev_sttime;
 #endif
 	unsigned long long acct_time;		/* Time for last accounting */
 	unsigned long nvcsw, nivcsw; /* context switch counts */
@@ -1677,8 +1679,8 @@
 		__put_task_struct(t);
 }
 
-extern void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st);
-extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st);
+extern void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st, cputime_t *stt);
+extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st, cputime_t *stt);
 
 /*
  * Per process flags
Index: git-linux-2.6/include/linux/taskstats.h
===================================================================
--- git-linux-2.6.orig/include/linux/taskstats.h	2010-09-23 14:16:26.000000000 +0200
+++ git-linux-2.6/include/linux/taskstats.h	2010-09-23 14:16:37.000000000 +0200
@@ -168,6 +168,7 @@
 	/* Timestamp where data has been collected in ns since boot time */
 	__u64	time_ns;
 	__u32	ac_tgid;		/* Thread group ID */
+	__u64	ac_sttime;		/* Steal CPU time [usec] */
 };
 
 
Index: git-linux-2.6/kernel/exit.c
===================================================================
--- git-linux-2.6.orig/kernel/exit.c	2010-09-23 14:14:03.000000000 +0200
+++ git-linux-2.6/kernel/exit.c	2010-09-23 14:16:37.000000000 +0200
@@ -115,6 +115,7 @@
 		 */
 		sig->utime = cputime_add(sig->utime, tsk->utime);
 		sig->stime = cputime_add(sig->stime, tsk->stime);
+		sig->sttime = cputime_add(sig->sttime, tsk->sttime);
 		sig->gtime = cputime_add(sig->gtime, tsk->gtime);
 		sig->min_flt += tsk->min_flt;
 		sig->maj_flt += tsk->maj_flt;
@@ -1217,7 +1218,7 @@
 		struct signal_struct *psig;
 		struct signal_struct *sig;
 		unsigned long maxrss;
-		cputime_t tgutime, tgstime;
+		cputime_t tgutime, tgstime, tgsttime;
 
 		/*
 		 * The resource counters for the group leader are in its
@@ -1238,7 +1239,7 @@
 		 * group, which consolidates times for all threads in the
 		 * group including the group leader.
 		 */
-		thread_group_times(p, &tgutime, &tgstime);
+		thread_group_times(p, &tgutime, &tgstime, &tgsttime);
 		spin_lock_irq(&p->real_parent->sighand->siglock);
 		psig = p->real_parent->signal;
 		sig = p->signal;
@@ -1250,6 +1251,10 @@
 			cputime_add(psig->cstime,
 			cputime_add(tgstime,
 				    sig->cstime));
+		psig->csttime =
+			cputime_add(psig->csttime,
+			cputime_add(tgsttime,
+				    sig->csttime));
 		psig->cgtime =
 			cputime_add(psig->cgtime,
 			cputime_add(p->gtime,
Index: git-linux-2.6/kernel/fork.c
===================================================================
--- git-linux-2.6.orig/kernel/fork.c	2010-09-23 14:14:03.000000000 +0200
+++ git-linux-2.6/kernel/fork.c	2010-09-23 14:16:37.000000000 +0200
@@ -1056,6 +1056,7 @@
 
 	p->utime = cputime_zero;
 	p->stime = cputime_zero;
+	p->sttime = cputime_zero;
 	p->gtime = cputime_zero;
 	p->utimescaled = cputime_zero;
 	p->stimescaled = cputime_zero;
Index: git-linux-2.6/kernel/posix-cpu-timers.c
===================================================================
--- git-linux-2.6.orig/kernel/posix-cpu-timers.c	2010-09-23 14:14:03.000000000 +0200
+++ git-linux-2.6/kernel/posix-cpu-timers.c	2010-09-23 14:17:15.000000000 +0200
@@ -237,6 +237,7 @@
 
 	times->utime = sig->utime;
 	times->stime = sig->stime;
+	times->sttime = sig->sttime;
 	times->sum_exec_runtime = sig->sum_sched_runtime;
 
 	rcu_read_lock();
@@ -248,6 +249,7 @@
 	do {
 		times->utime = cputime_add(times->utime, t->utime);
 		times->stime = cputime_add(times->stime, t->stime);
+		times->sttime = cputime_add(times->sttime, t->sttime);
 		times->sum_exec_runtime += t->se.sum_exec_runtime;
 	} while_each_thread(tsk, t);
 out:
@@ -1276,6 +1278,7 @@
 		struct task_cputime task_sample = {
 			.utime = tsk->utime,
 			.stime = tsk->stime,
+			.sttime = tsk->sttime,
 			.sum_exec_runtime = tsk->se.sum_exec_runtime
 		};
 
Index: git-linux-2.6/kernel/sched.c
===================================================================
--- git-linux-2.6.orig/kernel/sched.c	2010-09-23 14:16:17.000000000 +0200
+++ git-linux-2.6/kernel/sched.c	2010-09-23 14:16:37.000000000 +0200
@@ -3412,11 +3412,15 @@
  * Account for involuntary wait time.
  * @steal: the cpu time spent in involuntary wait
  */
-void account_steal_time(cputime_t cputime)
+void account_steal_time(struct task_struct *p, cputime_t cputime)
 {
 	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
 	cputime64_t cputime64 = cputime_to_cputime64(cputime);
 
+	/* Add steal time to process. */
+	p->sttime = cputime_add(p->sttime, cputime);
+
+	/* Add steal time to cpustat. */
 	cpustat->steal = cputime64_add(cpustat->steal, cputime64);
 }
 
@@ -3464,7 +3468,7 @@
  */
 void account_steal_ticks(unsigned long ticks)
 {
-	account_steal_time(jiffies_to_cputime(ticks));
+	account_steal_time(current, jiffies_to_cputime(ticks));
 }
 
 /*
@@ -3482,13 +3486,16 @@
  * Use precise platform statistics if available:
  */
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
-void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
+void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st,
+		cputime_t *stt)
 {
 	*ut = p->utime;
 	*st = p->stime;
+	*stt = p->sttime;
 }
 
-void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
+void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st,
+			cputime_t *stt)
 {
 	struct task_cputime cputime;
 
@@ -3496,6 +3503,7 @@
 
 	*ut = cputime.utime;
 	*st = cputime.stime;
+	*stt = cputime.sttime;
 }
 #else
 
@@ -3503,7 +3511,8 @@
 # define nsecs_to_cputime(__nsecs)	nsecs_to_jiffies(__nsecs)
 #endif
 
-void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
+void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st,
+		cputime_t *stt)
 {
 	cputime_t rtime, utime = p->utime, total = cputime_add(utime, p->stime);
 
@@ -3526,15 +3535,18 @@
 	 */
 	p->prev_utime = max(p->prev_utime, utime);
 	p->prev_stime = max(p->prev_stime, cputime_sub(rtime, p->prev_utime));
+	p->prev_sttime = cputime_zero;
 
 	*ut = p->prev_utime;
 	*st = p->prev_stime;
+	*stt = p->prev_sttime;
 }
 
 /*
  * Must be called with siglock held.
  */
-void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
+void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st,
+			cputime_t *stt)
 {
 	struct signal_struct *sig = p->signal;
 	struct task_cputime cputime;
@@ -3557,9 +3569,11 @@
 	sig->prev_utime = max(sig->prev_utime, utime);
 	sig->prev_stime = max(sig->prev_stime,
 			      cputime_sub(rtime, sig->prev_utime));
+	sig->prev_sttime = cputime_zero;
 
 	*ut = sig->prev_utime;
 	*st = sig->prev_stime;
+	*stt = sig->prev_sttime;
 }
 #endif
 
Index: git-linux-2.6/kernel/sys.c
===================================================================
--- git-linux-2.6.orig/kernel/sys.c	2010-09-23 14:14:03.000000000 +0200
+++ git-linux-2.6/kernel/sys.c	2010-09-23 14:16:37.000000000 +0200
@@ -880,10 +880,10 @@
 
 void do_sys_times(struct tms *tms)
 {
-	cputime_t tgutime, tgstime, cutime, cstime;
+	cputime_t tgutime, tgstime, tgsttime, cutime, cstime;
 
 	spin_lock_irq(&current->sighand->siglock);
-	thread_group_times(current, &tgutime, &tgstime);
+	thread_group_times(current, &tgutime, &tgstime, &tgsttime);
 	cutime = current->signal->cutime;
 	cstime = current->signal->cstime;
 	spin_unlock_irq(&current->sighand->siglock);
@@ -1488,14 +1488,14 @@
 {
 	struct task_struct *t;
 	unsigned long flags;
-	cputime_t tgutime, tgstime, utime, stime;
+	cputime_t tgutime, tgstime, tgsttime, utime, stime, sttime;
 	unsigned long maxrss = 0;
 
 	memset((char *) r, 0, sizeof *r);
 	utime = stime = cputime_zero;
 
 	if (who == RUSAGE_THREAD) {
-		task_times(current, &utime, &stime);
+		task_times(current, &utime, &stime, &sttime);
 		accumulate_thread_rusage(p, r);
 		maxrss = p->signal->maxrss;
 		goto out;
@@ -1521,7 +1521,7 @@
 				break;
 
 		case RUSAGE_SELF:
-			thread_group_times(p, &tgutime, &tgstime);
+			thread_group_times(p, &tgutime, &tgstime, &tgsttime);
 			utime = cputime_add(utime, tgutime);
 			stime = cputime_add(stime, tgstime);
 			r->ru_nvcsw += p->signal->nvcsw;
Index: git-linux-2.6/kernel/tsacct.c
===================================================================
--- git-linux-2.6.orig/kernel/tsacct.c	2010-09-23 14:16:26.000000000 +0200
+++ git-linux-2.6/kernel/tsacct.c	2010-09-23 14:16:37.000000000 +0200
@@ -66,6 +66,7 @@
 	rcu_read_unlock();
 	stats->ac_utime = cputime_to_usecs(tsk->utime);
 	stats->ac_stime = cputime_to_usecs(tsk->stime);
+	stats->ac_sttime = cputime_to_usecs(tsk->sttime);
 	stats->ac_utimescaled = cputime_to_usecs(tsk->utimescaled);
 	stats->ac_stimescaled = cputime_to_usecs(tsk->stimescaled);
 	stats->ac_minflt = tsk->min_flt;


