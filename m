Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab2L2Qna (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 11:43:30 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:42567 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab2L2QnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 11:43:24 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 04/27] cputime: Use accessors to read task cputime stats
Date: Sat, 29 Dec 2012 17:42:43 +0100
Message-Id: <1356799386-4212-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
References: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation for the full dynticks feature. While
remotely reading the cputime of a task running in a full
dynticks CPU, we'll need to do some extra-computation. This
way we can account the time it spent tickless in userspace
since its last cputime snapshot.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/alpha/kernel/osf_sys.c |    6 ++++--
 arch/x86/kernel/apm_32.c    |   11 ++++++-----
 drivers/isdn/mISDN/stack.c  |    7 ++++++-
 fs/binfmt_elf.c             |    8 ++++++--
 fs/binfmt_elf_fdpic.c       |    7 +++++--
 include/linux/sched.h       |   18 ++++++++++++++++++
 kernel/acct.c               |    6 ++++--
 kernel/cpu.c                |    4 +++-
 kernel/delayacct.c          |    7 +++++--
 kernel/exit.c               |    6 ++++--
 kernel/posix-cpu-timers.c   |   28 ++++++++++++++++++++++------
 kernel/sched/cputime.c      |    9 +++++----
 kernel/signal.c             |   12 ++++++++----
 kernel/tsacct.c             |   19 +++++++++++++------
 14 files changed, 109 insertions(+), 39 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 14db93e..dbc1760 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -1139,6 +1139,7 @@ struct rusage32 {
 SYSCALL_DEFINE2(osf_getrusage, int, who, struct rusage32 __user *, ru)
 {
 	struct rusage32 r;
+	cputime_t utime, stime;
 
 	if (who != RUSAGE_SELF && who != RUSAGE_CHILDREN)
 		return -EINVAL;
@@ -1146,8 +1147,9 @@ SYSCALL_DEFINE2(osf_getrusage, int, who, struct rusage32 __user *, ru)
 	memset(&r, 0, sizeof(r));
 	switch (who) {
 	case RUSAGE_SELF:
-		jiffies_to_timeval32(current->utime, &r.ru_utime);
-		jiffies_to_timeval32(current->stime, &r.ru_stime);
+		task_cputime(current, &utime, &stime);
+		jiffies_to_timeval32(utime, &r.ru_utime);
+		jiffies_to_timeval32(stime, &r.ru_stime);
 		r.ru_minflt = current->min_flt;
 		r.ru_majflt = current->maj_flt;
 		break;
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index d65464e..8d7012b 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -899,6 +899,7 @@ static void apm_cpu_idle(void)
 	static int use_apm_idle; /* = 0 */
 	static unsigned int last_jiffies; /* = 0 */
 	static unsigned int last_stime; /* = 0 */
+	cputime_t stime;
 
 	int apm_idle_done = 0;
 	unsigned int jiffies_since_last_check = jiffies - last_jiffies;
@@ -906,23 +907,23 @@ static void apm_cpu_idle(void)
 
 	WARN_ONCE(1, "deprecated apm_cpu_idle will be deleted in 2012");
 recalc:
+	task_cputime(current, NULL, &stime);
 	if (jiffies_since_last_check > IDLE_CALC_LIMIT) {
 		use_apm_idle = 0;
-		last_jiffies = jiffies;
-		last_stime = current->stime;
 	} else if (jiffies_since_last_check > idle_period) {
 		unsigned int idle_percentage;
 
-		idle_percentage = current->stime - last_stime;
+		idle_percentage = stime - last_stime;
 		idle_percentage *= 100;
 		idle_percentage /= jiffies_since_last_check;
 		use_apm_idle = (idle_percentage > idle_threshold);
 		if (apm_info.forbid_idle)
 			use_apm_idle = 0;
-		last_jiffies = jiffies;
-		last_stime = current->stime;
 	}
 
+	last_jiffies = jiffies;
+	last_stime = stime;
+
 	bucket = IDLE_LEAKY_MAX;
 
 	while (!need_resched()) {
diff --git a/drivers/isdn/mISDN/stack.c b/drivers/isdn/mISDN/stack.c
index 5f21f62..deda591 100644
--- a/drivers/isdn/mISDN/stack.c
+++ b/drivers/isdn/mISDN/stack.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/mISDNif.h>
 #include <linux/kthread.h>
+#include <linux/sched.h>
 #include "core.h"
 
 static u_int	*debug;
@@ -202,6 +203,9 @@ static int
 mISDNStackd(void *data)
 {
 	struct mISDNstack *st = data;
+#ifdef MISDN_MSG_STATS
+	cputime_t utime, stime;
+#endif
 	int err = 0;
 
 	sigfillset(&current->blocked);
@@ -303,9 +307,10 @@ mISDNStackd(void *data)
 	       "msg %d sleep %d stopped\n",
 	       dev_name(&st->dev->dev), st->msg_cnt, st->sleep_cnt,
 	       st->stopped_cnt);
+	task_cputime(st->thread, &utime, &stime);
 	printk(KERN_DEBUG
 	       "mISDNStackd daemon for %s utime(%ld) stime(%ld)\n",
-	       dev_name(&st->dev->dev), st->thread->utime, st->thread->stime);
+	       dev_name(&st->dev->dev), utime, stime);
 	printk(KERN_DEBUG
 	       "mISDNStackd daemon for %s nvcsw(%ld) nivcsw(%ld)\n",
 	       dev_name(&st->dev->dev), st->thread->nvcsw, st->thread->nivcsw);
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 0c42cdb..49d0b43 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -33,6 +33,7 @@
 #include <linux/elf.h>
 #include <linux/utsname.h>
 #include <linux/coredump.h>
+#include <linux/sched.h>
 #include <asm/uaccess.h>
 #include <asm/param.h>
 #include <asm/page.h>
@@ -1320,8 +1321,11 @@ static void fill_prstatus(struct elf_prstatus *prstatus,
 		cputime_to_timeval(cputime.utime, &prstatus->pr_utime);
 		cputime_to_timeval(cputime.stime, &prstatus->pr_stime);
 	} else {
-		cputime_to_timeval(p->utime, &prstatus->pr_utime);
-		cputime_to_timeval(p->stime, &prstatus->pr_stime);
+		cputime_t utime, stime;
+
+		task_cputime(p, &utime, &stime);
+		cputime_to_timeval(utime, &prstatus->pr_utime);
+		cputime_to_timeval(stime, &prstatus->pr_stime);
 	}
 	cputime_to_timeval(p->signal->cutime, &prstatus->pr_cutime);
 	cputime_to_timeval(p->signal->cstime, &prstatus->pr_cstime);
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index dc84732..cb240dd 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1375,8 +1375,11 @@ static void fill_prstatus(struct elf_prstatus *prstatus,
 		cputime_to_timeval(cputime.utime, &prstatus->pr_utime);
 		cputime_to_timeval(cputime.stime, &prstatus->pr_stime);
 	} else {
-		cputime_to_timeval(p->utime, &prstatus->pr_utime);
-		cputime_to_timeval(p->stime, &prstatus->pr_stime);
+		cputime_t utime, stime;
+
+		task_cputime(p, &utime, &stime);
+		cputime_to_timeval(utime, &prstatus->pr_utime);
+		cputime_to_timeval(stime, &prstatus->pr_stime);
 	}
 	cputime_to_timeval(p->signal->cutime, &prstatus->pr_cutime);
 	cputime_to_timeval(p->signal->cstime, &prstatus->pr_cstime);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 66b2344..d57e20f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1792,6 +1792,24 @@ static inline void put_task_struct(struct task_struct *t)
 		__put_task_struct(t);
 }
 
+static inline void task_cputime(struct task_struct *t,
+				cputime_t *utime, cputime_t *stime)
+{
+	if (utime)
+		*utime = t->utime;
+	if (stime)
+		*stime = t->stime;
+}
+
+static inline void task_cputime_scaled(struct task_struct *t,
+				       cputime_t *utimescaled,
+				       cputime_t *stimescaled)
+{
+	if (utimescaled)
+		*utimescaled = t->utimescaled;
+	if (stimescaled)
+		*stimescaled = t->stimescaled;
+}
 extern void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st);
 extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st);
 
diff --git a/kernel/acct.c b/kernel/acct.c
index 051e071..e8b1627 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -566,6 +566,7 @@ out:
 void acct_collect(long exitcode, int group_dead)
 {
 	struct pacct_struct *pacct = &current->signal->pacct;
+	cputime_t utime, stime;
 	unsigned long vsize = 0;
 
 	if (group_dead && current->mm) {
@@ -593,8 +594,9 @@ void acct_collect(long exitcode, int group_dead)
 		pacct->ac_flag |= ACORE;
 	if (current->flags & PF_SIGNALED)
 		pacct->ac_flag |= AXSIG;
-	pacct->ac_utime += current->utime;
-	pacct->ac_stime += current->stime;
+	task_cputime(current, &utime, &stime);
+	pacct->ac_utime += utime;
+	pacct->ac_stime += stime;
 	pacct->ac_minflt += current->min_flt;
 	pacct->ac_majflt += current->maj_flt;
 	spin_unlock_irq(&current->sighand->siglock);
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 3046a50..e5d5e8e 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -224,11 +224,13 @@ void clear_tasks_mm_cpumask(int cpu)
 static inline void check_for_tasks(int cpu)
 {
 	struct task_struct *p;
+	cputime_t utime, stime;
 
 	write_lock_irq(&tasklist_lock);
 	for_each_process(p) {
+		task_cputime(p, &utime, &stime);
 		if (task_cpu(p) == cpu && p->state == TASK_RUNNING &&
-		    (p->utime || p->stime))
+		    (utime || stime))
 			printk(KERN_WARNING "Task %s (pid = %d) is on cpu %d "
 				"(state = %ld, flags = %x)\n",
 				p->comm, task_pid_nr(p), cpu,
diff --git a/kernel/delayacct.c b/kernel/delayacct.c
index 418b3f7..d473988 100644
--- a/kernel/delayacct.c
+++ b/kernel/delayacct.c
@@ -106,6 +106,7 @@ int __delayacct_add_tsk(struct taskstats *d, struct task_struct *tsk)
 	unsigned long long t2, t3;
 	unsigned long flags;
 	struct timespec ts;
+	cputime_t utime, stime, stimescaled, utimescaled;
 
 	/* Though tsk->delays accessed later, early exit avoids
 	 * unnecessary returning of other data
@@ -114,12 +115,14 @@ int __delayacct_add_tsk(struct taskstats *d, struct task_struct *tsk)
 		goto done;
 
 	tmp = (s64)d->cpu_run_real_total;
-	cputime_to_timespec(tsk->utime + tsk->stime, &ts);
+	task_cputime(tsk, &utime, &stime);
+	cputime_to_timespec(utime + stime, &ts);
 	tmp += timespec_to_ns(&ts);
 	d->cpu_run_real_total = (tmp < (s64)d->cpu_run_real_total) ? 0 : tmp;
 
 	tmp = (s64)d->cpu_scaled_run_real_total;
-	cputime_to_timespec(tsk->utimescaled + tsk->stimescaled, &ts);
+	task_cputime_scaled(tsk, &utimescaled, &stimescaled);
+	cputime_to_timespec(utimescaled + stimescaled, &ts);
 	tmp += timespec_to_ns(&ts);
 	d->cpu_scaled_run_real_total =
 		(tmp < (s64)d->cpu_scaled_run_real_total) ? 0 : tmp;
diff --git a/kernel/exit.c b/kernel/exit.c
index b4df219..5d1b0ff 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -85,6 +85,7 @@ static void __exit_signal(struct task_struct *tsk)
 	bool group_dead = thread_group_leader(tsk);
 	struct sighand_struct *sighand;
 	struct tty_struct *uninitialized_var(tty);
+	cputime_t utime, stime;
 
 	sighand = rcu_dereference_check(tsk->sighand,
 					lockdep_tasklist_lock_is_held());
@@ -123,8 +124,9 @@ static void __exit_signal(struct task_struct *tsk)
 		 * We won't ever get here for the group leader, since it
 		 * will have been the last reference on the signal_struct.
 		 */
-		sig->utime += tsk->utime;
-		sig->stime += tsk->stime;
+		task_cputime(tsk, &utime, &stime);
+		sig->utime += utime;
+		sig->stime += stime;
 		sig->gtime += tsk->gtime;
 		sig->min_flt += tsk->min_flt;
 		sig->maj_flt += tsk->maj_flt;
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index a278cad..165d476 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -155,11 +155,19 @@ static void bump_cpu_timer(struct k_itimer *timer,
 
 static inline cputime_t prof_ticks(struct task_struct *p)
 {
-	return p->utime + p->stime;
+	cputime_t utime, stime;
+
+	task_cputime(p, &utime, &stime);
+
+	return utime + stime;
 }
 static inline cputime_t virt_ticks(struct task_struct *p)
 {
-	return p->utime;
+	cputime_t utime;
+
+	task_cputime(p, &utime, NULL);
+
+	return utime;
 }
 
 static int
@@ -471,18 +479,23 @@ static void cleanup_timers(struct list_head *head,
  */
 void posix_cpu_timers_exit(struct task_struct *tsk)
 {
+	cputime_t utime, stime;
+
 	add_device_randomness((const void*) &tsk->se.sum_exec_runtime,
 						sizeof(unsigned long long));
+	task_cputime(tsk, &utime, &stime);
 	cleanup_timers(tsk->cpu_timers,
-		       tsk->utime, tsk->stime, tsk->se.sum_exec_runtime);
+		       utime, stime, tsk->se.sum_exec_runtime);
 
 }
 void posix_cpu_timers_exit_group(struct task_struct *tsk)
 {
 	struct signal_struct *const sig = tsk->signal;
+	cputime_t utime, stime;
 
+	task_cputime(tsk, &utime, &stime);
 	cleanup_timers(tsk->signal->cpu_timers,
-		       tsk->utime + sig->utime, tsk->stime + sig->stime,
+		       utime + sig->utime, stime + sig->stime,
 		       tsk->se.sum_exec_runtime + sig->sum_sched_runtime);
 }
 
@@ -1226,11 +1239,14 @@ static inline int task_cputime_expired(const struct task_cputime *sample,
 static inline int fastpath_timer_check(struct task_struct *tsk)
 {
 	struct signal_struct *sig;
+	cputime_t utime, stime;
+
+	task_cputime(tsk, &utime, &stime);
 
 	if (!task_cputime_zero(&tsk->cputime_expires)) {
 		struct task_cputime task_sample = {
-			.utime = tsk->utime,
-			.stime = tsk->stime,
+			.utime = utime,
+			.stime = stime,
 			.sum_exec_runtime = tsk->se.sum_exec_runtime
 		};
 
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index e1fcab4..0603671 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -296,6 +296,7 @@ static __always_inline bool steal_account_process_tick(void)
 void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 {
 	struct signal_struct *sig = tsk->signal;
+	cputime_t utime, stime;
 	struct task_struct *t;
 
 	times->utime = sig->utime;
@@ -309,8 +310,9 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 
 	t = tsk;
 	do {
-		times->utime += t->utime;
-		times->stime += t->stime;
+		task_cputime(tsk, &utime, &stime);
+		times->utime += utime;
+		times->stime += stime;
 		times->sum_exec_runtime += task_sched_runtime(t);
 	} while_each_thread(tsk, t);
 out:
@@ -594,11 +596,10 @@ static void cputime_adjust(struct task_cputime *curr,
 void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
 	struct task_cputime cputime = {
-		.utime = p->utime,
-		.stime = p->stime,
 		.sum_exec_runtime = p->se.sum_exec_runtime,
 	};
 
+	task_cputime(p, &cputime.utime, &cputime.stime);
 	cputime_adjust(&cputime, &p->prev_cputime, ut, st);
 }
 
diff --git a/kernel/signal.c b/kernel/signal.c
index 7aaa51d..9b3e319 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1638,6 +1638,7 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 	unsigned long flags;
 	struct sighand_struct *psig;
 	bool autoreap = false;
+	cputime_t utime, stime;
 
 	BUG_ON(sig == -1);
 
@@ -1675,8 +1676,9 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 				       task_uid(tsk));
 	rcu_read_unlock();
 
-	info.si_utime = cputime_to_clock_t(tsk->utime + tsk->signal->utime);
-	info.si_stime = cputime_to_clock_t(tsk->stime + tsk->signal->stime);
+	task_cputime(tsk, &utime, &stime);
+	info.si_utime = cputime_to_clock_t(utime + tsk->signal->utime);
+	info.si_stime = cputime_to_clock_t(stime + tsk->signal->stime);
 
 	info.si_status = tsk->exit_code & 0x7f;
 	if (tsk->exit_code & 0x80)
@@ -1740,6 +1742,7 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
 	unsigned long flags;
 	struct task_struct *parent;
 	struct sighand_struct *sighand;
+	cputime_t utime, stime;
 
 	if (for_ptracer) {
 		parent = tsk->parent;
@@ -1758,8 +1761,9 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
 	info.si_uid = from_kuid_munged(task_cred_xxx(parent, user_ns), task_uid(tsk));
 	rcu_read_unlock();
 
-	info.si_utime = cputime_to_clock_t(tsk->utime);
-	info.si_stime = cputime_to_clock_t(tsk->stime);
+	task_cputime(tsk, &utime, &stime);
+	info.si_utime = cputime_to_clock_t(utime);
+	info.si_stime = cputime_to_clock_t(stime);
 
  	info.si_code = why;
  	switch (why) {
diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index 625df0b..017181f 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -32,6 +32,7 @@ void bacct_add_tsk(struct user_namespace *user_ns,
 {
 	const struct cred *tcred;
 	struct timespec uptime, ts;
+	cputime_t utime, stime, utimescaled, stimescaled;
 	u64 ac_etime;
 
 	BUILD_BUG_ON(TS_COMM_LEN < TASK_COMM_LEN);
@@ -65,10 +66,15 @@ void bacct_add_tsk(struct user_namespace *user_ns,
 	stats->ac_ppid	 = pid_alive(tsk) ?
 		task_tgid_nr_ns(rcu_dereference(tsk->real_parent), pid_ns) : 0;
 	rcu_read_unlock();
-	stats->ac_utime = cputime_to_usecs(tsk->utime);
-	stats->ac_stime = cputime_to_usecs(tsk->stime);
-	stats->ac_utimescaled = cputime_to_usecs(tsk->utimescaled);
-	stats->ac_stimescaled = cputime_to_usecs(tsk->stimescaled);
+
+	task_cputime(tsk, &utime, &stime);
+	stats->ac_utime = cputime_to_usecs(utime);
+	stats->ac_stime = cputime_to_usecs(stime);
+
+	task_cputime_scaled(tsk, &utimescaled, &stimescaled);
+	stats->ac_utimescaled = cputime_to_usecs(utimescaled);
+	stats->ac_stimescaled = cputime_to_usecs(stimescaled);
+
 	stats->ac_minflt = tsk->min_flt;
 	stats->ac_majflt = tsk->maj_flt;
 
@@ -122,13 +128,14 @@ void xacct_add_tsk(struct taskstats *stats, struct task_struct *p)
 void acct_update_integrals(struct task_struct *tsk)
 {
 	if (likely(tsk->mm)) {
-		cputime_t time, dtime;
+		cputime_t time, dtime, stime, utime;
 		struct timeval value;
 		unsigned long flags;
 		u64 delta;
 
 		local_irq_save(flags);
-		time = tsk->stime + tsk->utime;
+		task_cputime(tsk, &utime, &stime);
+		time = stime + utime;
 		dtime = time - tsk->acct_timexpd;
 		jiffies_to_timeval(cputime_to_jiffies(dtime), &value);
 		delta = value.tv_sec;
-- 
1.7.5.4

