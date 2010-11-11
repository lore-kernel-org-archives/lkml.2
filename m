Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab0KKRIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 12:08:24 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:49968 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab0KKRIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 12:08:19 -0500
Message-Id: <20101111170815.024542355@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Thu, 11 Nov 2010 18:03:56 +0100
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
Subject: [RFC][PATCH v2 4/7] taskstats: Add per task steal time accounting
References: <20101111170352.732381138@linux.vnet.ibm.com>
Content-Disposition: inline; filename=04-taskstats-top-add-sttime.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

Currently steal time is only accounted for the whole system. With this
patch we add steal time to the per task CPU time accounting.
The triplet "user time", "system time" and "steal time" represents
all consumed CPU time on hypervisor based systems.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 arch/s390/kernel/vtime.c    |   19 +++++++++++--------
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
 11 files changed, 61 insertions(+), 31 deletions(-)

--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -56,31 +56,34 @@ static void do_account_vtime(struct task
 {
 	struct thread_info *ti = task_thread_info(tsk);
 	__u64 timer, clock, user, system, steal;
+	unsigned char clk[16];
 
 	timer = S390_lowcore.last_update_timer;
 	clock = S390_lowcore.last_update_clock;
 	asm volatile ("  STPT %0\n"    /* Store current cpu timer value */
-		      "  STCK %1"      /* Store current tod clock value */
+		      "  STCKE 0(%2)"  /* Store current tod clock value */
 		      : "=m" (S390_lowcore.last_update_timer),
-		        "=m" (S390_lowcore.last_update_clock) );
+		        "=m" (clk) : "a" (clk));
+	S390_lowcore.last_update_clock = *(__u64 *) &clk[1];
+	tsk->acct_time = ((clock - sched_clock_base_cc) * 125) >> 9;
 	S390_lowcore.system_timer += timer - S390_lowcore.last_update_timer;
 	S390_lowcore.steal_timer += S390_lowcore.last_update_clock - clock;
 
 	user = S390_lowcore.user_timer - ti->user_timer;
-	S390_lowcore.steal_timer -= user;
 	ti->user_timer = S390_lowcore.user_timer;
 	account_user_time(tsk, user, user);
 
 	system = S390_lowcore.system_timer - ti->system_timer;
-	S390_lowcore.steal_timer -= system;
 	ti->system_timer = S390_lowcore.system_timer;
 	account_system_time(tsk, hardirq_offset, system, system);
 
 	steal = S390_lowcore.steal_timer;
-	if ((s64) steal > 0) {
-		S390_lowcore.steal_timer = 0;
-		account_steal_time(steal);
-	}
+	S390_lowcore.steal_timer = 0;
+	if (steal >= user + system)
+		steal -= user + system;
+	else
+		steal = 0;
+	account_steal_time(tsk, steal);
 }
 
 void account_vtime(struct task_struct *prev, struct task_struct *next)
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -375,7 +375,7 @@ static int do_task_stat(struct seq_file
 	unsigned long long start_time;
 	unsigned long cmin_flt = 0, cmaj_flt = 0;
 	unsigned long  min_flt = 0,  maj_flt = 0;
-	cputime_t cutime, cstime, utime, stime;
+	cputime_t cutime, cstime, utime, stime, sttime;
 	cputime_t cgtime, gtime;
 	unsigned long rsslim = 0;
 	char tcomm[sizeof(task->comm)];
@@ -432,7 +432,7 @@ static int do_task_stat(struct seq_file
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
-			thread_group_times(task, &utime, &stime);
+			thread_group_times(task, &utime, &stime, &sttime);
 			gtime = cputime_add(gtime, sig->gtime);
 		}
 
@@ -448,7 +448,7 @@ static int do_task_stat(struct seq_file
 	if (!whole) {
 		min_flt = task->min_flt;
 		maj_flt = task->maj_flt;
-		task_times(task, &utime, &stime);
+		task_times(task, &utime, &stime, &sttime);
 		gtime = task->gtime;
 	}
 
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -116,7 +116,7 @@ extern unsigned long long task_delta_exe
 
 extern void account_user_time(struct task_struct *, cputime_t, cputime_t);
 extern void account_system_time(struct task_struct *, int, cputime_t, cputime_t);
-extern void account_steal_time(cputime_t);
+extern void account_steal_time(struct task_struct *, cputime_t);
 extern void account_idle_time(cputime_t);
 
 extern void account_process_tick(struct task_struct *, int user);
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -470,6 +470,7 @@ struct cpu_itimer {
 struct task_cputime {
 	cputime_t utime;
 	cputime_t stime;
+	cputime_t sttime;
 	unsigned long long sum_exec_runtime;
 };
 /* Alternate field names when used to cache expirations. */
@@ -481,6 +482,7 @@ struct task_cputime {
 	(struct task_cputime) {					\
 		.utime = cputime_zero,				\
 		.stime = cputime_zero,				\
+		.sttime = cputime_zero,				\
 		.sum_exec_runtime = 0,				\
 	}
 
@@ -582,11 +584,11 @@ struct signal_struct {
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
@@ -1294,10 +1296,10 @@ struct task_struct {
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
@@ -1694,8 +1696,8 @@ static inline void put_task_struct(struc
 		__put_task_struct(t);
 }
 
-extern void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st);
-extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st);
+extern void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st, cputime_t *stt);
+extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st, cputime_t *stt);
 
 /*
  * Per process flags
--- a/include/linux/taskstats.h
+++ b/include/linux/taskstats.h
@@ -168,6 +168,7 @@ struct taskstats {
 	/* Timestamp where data has been collected in ns since boot time */
 	__u64	time_ns;
 	__u32	ac_tgid;		/* Thread group ID */
+	__u64	ac_sttime;		/* Steal CPU time [usec] */
 };
 
 
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -124,6 +124,7 @@ static void __exit_signal(struct task_st
 		 */
 		sig->utime = cputime_add(sig->utime, tsk->utime);
 		sig->stime = cputime_add(sig->stime, tsk->stime);
+		sig->sttime = cputime_add(sig->sttime, tsk->sttime);
 		sig->gtime = cputime_add(sig->gtime, tsk->gtime);
 		sig->min_flt += tsk->min_flt;
 		sig->maj_flt += tsk->maj_flt;
@@ -1228,7 +1229,7 @@ static int wait_task_zombie(struct wait_
 		struct signal_struct *psig;
 		struct signal_struct *sig;
 		unsigned long maxrss;
-		cputime_t tgutime, tgstime;
+		cputime_t tgutime, tgstime, tgsttime;
 
 		/*
 		 * The resource counters for the group leader are in its
@@ -1249,7 +1250,7 @@ static int wait_task_zombie(struct wait_
 		 * group, which consolidates times for all threads in the
 		 * group including the group leader.
 		 */
-		thread_group_times(p, &tgutime, &tgstime);
+		thread_group_times(p, &tgutime, &tgstime, &tgsttime);
 		spin_lock_irq(&p->real_parent->sighand->siglock);
 		psig = p->real_parent->signal;
 		sig = p->signal;
@@ -1261,6 +1262,10 @@ static int wait_task_zombie(struct wait_
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
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1062,6 +1062,7 @@ static struct task_struct *copy_process(
 
 	p->utime = cputime_zero;
 	p->stime = cputime_zero;
+	p->sttime = cputime_zero;
 	p->gtime = cputime_zero;
 	p->utimescaled = cputime_zero;
 	p->stimescaled = cputime_zero;
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -237,6 +237,7 @@ void thread_group_cputime(struct task_st
 
 	times->utime = sig->utime;
 	times->stime = sig->stime;
+	times->sttime = sig->sttime;
 	times->sum_exec_runtime = sig->sum_sched_runtime;
 
 	rcu_read_lock();
@@ -248,6 +249,7 @@ void thread_group_cputime(struct task_st
 	do {
 		times->utime = cputime_add(times->utime, t->utime);
 		times->stime = cputime_add(times->stime, t->stime);
+		times->sttime = cputime_add(times->sttime, t->sttime);
 		times->sum_exec_runtime += t->se.sum_exec_runtime;
 	} while_each_thread(tsk, t);
 out:
@@ -1276,6 +1278,7 @@ static inline int fastpath_timer_check(s
 		struct task_cputime task_sample = {
 			.utime = tsk->utime,
 			.stime = tsk->stime,
+			.sttime = tsk->sttime,
 			.sum_exec_runtime = tsk->se.sum_exec_runtime
 		};
 
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3542,11 +3542,15 @@ void account_system_time(struct task_str
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
 
@@ -3594,7 +3598,7 @@ void account_process_tick(struct task_st
  */
 void account_steal_ticks(unsigned long ticks)
 {
-	account_steal_time(jiffies_to_cputime(ticks));
+	account_steal_time(current, jiffies_to_cputime(ticks));
 }
 
 /*
@@ -3612,13 +3616,16 @@ void account_idle_ticks(unsigned long ti
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
 
@@ -3626,6 +3633,7 @@ void thread_group_times(struct task_stru
 
 	*ut = cputime.utime;
 	*st = cputime.stime;
+	*stt = cputime.sttime;
 }
 #else
 
@@ -3633,7 +3641,8 @@ void thread_group_times(struct task_stru
 # define nsecs_to_cputime(__nsecs)	nsecs_to_jiffies(__nsecs)
 #endif
 
-void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
+void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st,
+		cputime_t *stt)
 {
 	cputime_t rtime, utime = p->utime, total = cputime_add(utime, p->stime);
 
@@ -3656,15 +3665,18 @@ void task_times(struct task_struct *p, c
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
@@ -3687,9 +3699,11 @@ void thread_group_times(struct task_stru
 	sig->prev_utime = max(sig->prev_utime, utime);
 	sig->prev_stime = max(sig->prev_stime,
 			      cputime_sub(rtime, sig->prev_utime));
+	sig->prev_sttime = cputime_zero;
 
 	*ut = sig->prev_utime;
 	*st = sig->prev_stime;
+	*stt = sig->prev_sttime;
 }
 #endif
 
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -880,10 +880,10 @@ change_okay:
 
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
@@ -1488,14 +1488,14 @@ static void k_getrusage(struct task_stru
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
@@ -1521,7 +1521,7 @@ static void k_getrusage(struct task_stru
 				break;
 
 		case RUSAGE_SELF:
-			thread_group_times(p, &tgutime, &tgstime);
+			thread_group_times(p, &tgutime, &tgstime, &tgsttime);
 			utime = cputime_add(utime, tgutime);
 			stime = cputime_add(stime, tgstime);
 			r->ru_nvcsw += p->signal->nvcsw;
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -66,6 +66,7 @@ void bacct_add_tsk(struct taskstats *sta
 	rcu_read_unlock();
 	stats->ac_utime = cputime_to_usecs(tsk->utime);
 	stats->ac_stime = cputime_to_usecs(tsk->stime);
+	stats->ac_sttime = cputime_to_usecs(tsk->sttime);
 	stats->ac_utimescaled = cputime_to_usecs(tsk->utimescaled);
 	stats->ac_stimescaled = cputime_to_usecs(tsk->stimescaled);
 	stats->ac_minflt = tsk->min_flt;

