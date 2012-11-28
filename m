Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab2K1Rwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:52:40 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57921 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520Ab2K1Rwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:52:33 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 2/4] cputime: Rename thread_group_times to thread_group_cputime_adjusted
Date: Wed, 28 Nov 2012 18:52:18 +0100
Message-Id: <1354125140-9294-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1354125140-9294-1-git-send-email-fweisbec@gmail.com>
References: <1354125140-9294-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have thread_group_cputime() and thread_group_times(). The naming
doesn't provide enough information about the difference between
these two APIs.

To lower the confusion, rename thread_group_times() to
thread_group_cputime_adjusted(). This name better suggests that
it's a version of thread_group_cputime() that does some stabilization
on the raw cputime values. ie here: scale on top of CFS runtime
stats and bound lower value for monotonicity.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/proc/array.c        |    4 ++--
 include/linux/sched.h  |    4 ++--
 kernel/exit.c          |    4 ++--
 kernel/sched/cputime.c |    8 ++++----
 kernel/sys.c           |    6 +++---
 5 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index c1c207c..d369670 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -438,7 +438,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
-			thread_group_times(task, &utime, &stime);
+			thread_group_cputime_adjusted(task, &utime, &stime);
 			gtime += sig->gtime;
 		}
 
@@ -454,7 +454,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	if (!whole) {
 		min_flt = task->min_flt;
 		maj_flt = task->maj_flt;
-		task_times(task, &utime, &stime);
+		task_cputime_adjusted(task, &utime, &stime);
 		gtime = task->gtime;
 	}
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e1581a0..e75cab5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1751,8 +1751,8 @@ static inline void put_task_struct(struct task_struct *t)
 		__put_task_struct(t);
 }
 
-extern void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st);
-extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st);
+extern void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st);
+extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st);
 
 /*
  * Per process flags
diff --git a/kernel/exit.c b/kernel/exit.c
index 346616c..618f7ee 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1186,11 +1186,11 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		 * as other threads in the parent group can be right
 		 * here reaping other children at the same time.
 		 *
-		 * We use thread_group_times() to get times for the thread
+		 * We use thread_group_cputime_adjusted() to get times for the thread
 		 * group, which consolidates times for all threads in the
 		 * group including the group leader.
 		 */
-		thread_group_times(p, &tgutime, &tgstime);
+		thread_group_cputime_adjusted(p, &tgutime, &tgstime);
 		spin_lock_irq(&p->real_parent->sighand->siglock);
 		psig = p->real_parent->signal;
 		sig = p->signal;
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index e56f138..7dc1553 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -445,13 +445,13 @@ void account_idle_ticks(unsigned long ticks)
  * Use precise platform statistics if available:
  */
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
-void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
+void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
 	*ut = p->utime;
 	*st = p->stime;
 }
 
-void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
+void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
 	struct task_cputime cputime;
 
@@ -516,7 +516,7 @@ static cputime_t scale_utime(cputime_t utime, cputime_t rtime, cputime_t total)
 	return (__force cputime_t) temp;
 }
 
-void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
+void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
 	cputime_t rtime, utime = p->utime, total = utime + p->stime;
 
@@ -543,7 +543,7 @@ void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 /*
  * Must be called with siglock held.
  */
-void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
+void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
 	struct signal_struct *sig = p->signal;
 	struct task_cputime cputime;
diff --git a/kernel/sys.c b/kernel/sys.c
index e6e0ece..265b376 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1046,7 +1046,7 @@ void do_sys_times(struct tms *tms)
 	cputime_t tgutime, tgstime, cutime, cstime;
 
 	spin_lock_irq(&current->sighand->siglock);
-	thread_group_times(current, &tgutime, &tgstime);
+	thread_group_cputime_adjusted(current, &tgutime, &tgstime);
 	cutime = current->signal->cutime;
 	cstime = current->signal->cstime;
 	spin_unlock_irq(&current->sighand->siglock);
@@ -1704,7 +1704,7 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 	utime = stime = 0;
 
 	if (who == RUSAGE_THREAD) {
-		task_times(current, &utime, &stime);
+		task_cputime_adjusted(current, &utime, &stime);
 		accumulate_thread_rusage(p, r);
 		maxrss = p->signal->maxrss;
 		goto out;
@@ -1730,7 +1730,7 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 				break;
 
 		case RUSAGE_SELF:
-			thread_group_times(p, &tgutime, &tgstime);
+			thread_group_cputime_adjusted(p, &tgutime, &tgstime);
 			utime += tgutime;
 			stime += tgstime;
 			r->ru_nvcsw += p->signal->nvcsw;
-- 
1.7.5.4

