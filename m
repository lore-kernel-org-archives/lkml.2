Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab1A1PJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 10:09:16 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60587 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab1A1PJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 10:09:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=NaLRuhg7rE4Ta7iqIE0/vaxpKChOaU0HKvo3bqpMM2hLP7gmGJf75yFrsWF+91eMin
         bvfHdAKvk7v8gbueblrTEhF1R65rLBfgdV1tI2yZAlydAatczusrDCUCqXAAyozJUzPO
         YRDlbDDg4DSrWtHbfy5yxlrAFxAv6yiln9Dyg=
From: Tejun Heo <tj@kernel.org>
To: roland@redhat.com, oleg@redhat.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/10] signal: fix premature completion of group stop when interfered by ptrace
Date: Fri, 28 Jan 2011 16:08:40 +0100
Message-Id: <1296227324-25295-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296227324-25295-1-git-send-email-tj@kernel.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task->signal->group_stop_count is used to track the progress of group
stop.  It's initialized to the number of tasks which need to stop for
group stop to finish and each stopping or trapping task decrements.
However, each task doesn't keep track of whether it decremented the
counter or not and if woken up before the group stop is complete and
stops again, it can decrement the counter multiple times.

Please consider the following example code.

 static void *worker(void *arg)
 {
	 while (1) ;
	 return NULL;
 }

 int main(void)
 {
	 pthread_t thread;
	 pid_t pid;
	 int i;

	 pid = fork();
	 if (!pid) {
		 for (i = 0; i < 5; i++)
			 pthread_create(&thread, NULL, worker, NULL);
		 while (1) ;
		 return 0;
	 }

	 ptrace(PTRACE_ATTACH, pid, NULL, NULL);
	 while (1) {
		 waitid(P_PID, pid, NULL, WSTOPPED);
		 ptrace(PTRACE_SINGLESTEP, pid, NULL, (void *)(long)SIGSTOP);
	 }
	 return 0;
 }

The child creates five threads and the parent continuously traps the
first thread and whenever the child gets a signal, SIGSTOP is
delivered.  If an external process sends SIGSTOP to the child, all
other threads in the process should reliably stop.  However, due to
the above bug, the first thread will often end up consuming
group_stop_count multiple times and SIGSTOP often ends up stopping
none or part of the other four threads.

This patch adds a new field task->group_stop which is protected by
siglock and uses GROUP_STOP_CONSUME flag to track which task is still
to consume group_stop_count to fix this bug.

task_clear_group_stop_pending() and task_participate_group_stop() are
added to help manipulating group stop states.  As ptrace_stop() now
also uses task_participate_group_stop(), it will set
SIGNAL_STOP_STOPPED if it completes a group stop.

There still are many issues regarding the interaction between group
stop and ptrace.  Patches to address them will follow.

- Oleg spotted duplicate GROUP_STOP_CONSUME.  Dropped.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---
 include/linux/sched.h |    6 ++++
 kernel/signal.c       |   62 ++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 60 insertions(+), 8 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d747f94..58df43d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1261,6 +1261,7 @@ struct task_struct {
 	int exit_state;
 	int exit_code, exit_signal;
 	int pdeath_signal;  /*  The signal sent when the parent dies  */
+	unsigned int group_stop;	/* GROUP_STOP_*, siglock protected */
 	/* ??? */
 	unsigned int personality;
 	unsigned did_exec:1;
@@ -1772,6 +1773,11 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define tsk_used_math(p) ((p)->flags & PF_USED_MATH)
 #define used_math() tsk_used_math(current)
 
+/*
+ * task->group_stop flags
+ */
+#define GROUP_STOP_CONSUME	(1 << 17) /* consume group stop count */
+
 #ifdef CONFIG_PREEMPT_RCU
 
 #define RCU_READ_UNLOCK_BLOCKED (1 << 0) /* blocked while in RCU read-side. */
diff --git a/kernel/signal.c b/kernel/signal.c
index 4569801..238eeba 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -223,6 +223,52 @@ static inline void print_dropped_signal(int sig)
 				current->comm, current->pid, sig);
 }
 
+/**
+ * task_clear_group_stop_pending - clear pending group stop
+ * @task: target task
+ *
+ * Clear group stop states for @task.
+ *
+ * CONTEXT:
+ * Must be called with @task->sighand->siglock held.
+ */
+static void task_clear_group_stop_pending(struct task_struct *task)
+{
+	task->group_stop &= ~GROUP_STOP_CONSUME;
+}
+
+/**
+ * task_participate_group_stop - participate in a group stop
+ * @task: task participating in a group stop
+ *
+ * @task is participating in a group stop.  Group stop states are cleared
+ * and the group stop count is consumed if %GROUP_STOP_CONSUME was set.  If
+ * the consumption completes the group stop, the appropriate %SIGNAL_*
+ * flags are set.
+ *
+ * CONTEXT:
+ * Must be called with @task->sighand->siglock held.
+ */
+static bool task_participate_group_stop(struct task_struct *task)
+{
+	struct signal_struct *sig = task->signal;
+	bool consume = task->group_stop & GROUP_STOP_CONSUME;
+
+	task_clear_group_stop_pending(task);
+
+	if (!consume)
+		return false;
+
+	if (!WARN_ON_ONCE(sig->group_stop_count == 0))
+		sig->group_stop_count--;
+
+	if (!sig->group_stop_count) {
+		sig->flags = SIGNAL_STOP_STOPPED;
+		return true;
+	}
+	return false;
+}
+
 /*
  * allocate a new signal queue record
  * - this may be called without locks if and only if t == current, otherwise an
@@ -1645,7 +1691,7 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	 * we must participate in the bookkeeping.
 	 */
 	if (current->signal->group_stop_count > 0)
-		--current->signal->group_stop_count;
+		task_participate_group_stop(current);
 
 	current->last_siginfo = info;
 	current->exit_code = exit_code;
@@ -1730,6 +1776,7 @@ static int do_signal_stop(int signr)
 	int notify = 0;
 
 	if (!sig->group_stop_count) {
+		unsigned int gstop = GROUP_STOP_CONSUME;
 		struct task_struct *t;
 
 		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED) ||
@@ -1741,6 +1788,7 @@ static int do_signal_stop(int signr)
 		 */
 		sig->group_exit_code = signr;
 
+		current->group_stop = gstop;
 		sig->group_stop_count = 1;
 		for (t = next_thread(current); t != current; t = next_thread(t))
 			/*
@@ -1750,19 +1798,19 @@ static int do_signal_stop(int signr)
 			 */
 			if (!(t->flags & PF_EXITING) &&
 			    !task_is_stopped_or_traced(t)) {
+				t->group_stop = gstop;
 				sig->group_stop_count++;
 				signal_wake_up(t, 0);
-			}
+			} else
+				task_clear_group_stop_pending(t);
 	}
 	/*
 	 * If there are no other threads in the group, or if there is
 	 * a group stop in progress and we are the last to stop, report
 	 * to the parent.  When ptraced, every thread reports itself.
 	 */
-	if (!--sig->group_stop_count) {
-		sig->flags = SIGNAL_STOP_STOPPED;
+	if (task_participate_group_stop(current))
 		notify = CLD_STOPPED;
-	}
 	if (task_ptrace(current))
 		notify = CLD_STOPPED;
 
@@ -2026,10 +2074,8 @@ void exit_signals(struct task_struct *tsk)
 			recalc_sigpending_and_wake(t);
 
 	if (unlikely(tsk->signal->group_stop_count) &&
-			!--tsk->signal->group_stop_count) {
-		tsk->signal->flags = SIGNAL_STOP_STOPPED;
+	    task_participate_group_stop(tsk))
 		group_stop = CLD_STOPPED;
-	}
 out:
 	spin_unlock_irq(&tsk->sighand->siglock);
 
-- 
1.7.1

