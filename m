Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab0KZKvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 05:51:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:42322 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856Ab0KZKu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 05:50:27 -0500
From: Tejun Heo <tj@kernel.org>
To: roland@redhat.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        "rjw@sisk.plpavel"@ucw.cz
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/14] signal: fix premature completion of group stop when interfered by ptrace
Date: Fri, 26 Nov 2010 11:49:20 +0100
Message-Id: <1290768569-16224-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290768569-16224-1-git-send-email-tj@kernel.org>
References: <1290768569-16224-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 10:49:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task->signal->group_stop_count is used to tracke the progress of group
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
the above described bug, the first thread will often end up consuming
group_stop_count multiple times and SIGSTOP often ends up stopping
none or part of the other four threads.

This patch adds a new field task->group_stop which is protected by
siglock and uses GROUP_STOP_CONSUME flag to track which task is still
to consume group_stop_count to fix this bug.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---
 include/linux/sched.h |    6 ++++++
 kernel/signal.c       |   32 +++++++++++++++++++++++++-------
 2 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2c79e92..93157a4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1245,6 +1245,7 @@ struct task_struct {
 	int exit_state;
 	int exit_code, exit_signal;
 	int pdeath_signal;  /*  The signal sent when the parent dies  */
+	unsigned int group_stop;	/* GROUP_STOP_*, siglock protected */
 	/* ??? */
 	unsigned int personality;
 	unsigned did_exec:1;
@@ -1756,6 +1757,11 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
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
index 6f7407d..7e2da0d 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -223,6 +223,19 @@ static inline void print_dropped_signal(int sig)
 				current->comm, current->pid, sig);
 }
 
+static bool consume_group_stop(void)
+{
+	if (!(current->group_stop & GROUP_STOP_CONSUME))
+		return false;
+
+	current->group_stop &= ~GROUP_STOP_CONSUME;
+
+	if (!WARN_ON_ONCE(current->signal->group_stop_count == 0))
+		current->signal->group_stop_count--;
+
+	return current->signal->group_stop_count == 0;
+}
+
 /*
  * allocate a new signal queue record
  * - this may be called without locks if and only if t == current, otherwise an
@@ -1645,7 +1658,7 @@ static void ptrace_stop(int exit_code, int clear_code, siginfo_t *info)
 	 * we must participate in the bookkeeping.
 	 */
 	if (current->signal->group_stop_count > 0)
-		--current->signal->group_stop_count;
+		consume_group_stop();
 
 	current->last_siginfo = info;
 	current->exit_code = exit_code;
@@ -1727,9 +1740,10 @@ void ptrace_notify(int exit_code)
 static int do_signal_stop(int signr)
 {
 	struct signal_struct *sig = current->signal;
-	int notify;
+	int notify = 0;
 
 	if (!sig->group_stop_count) {
+		unsigned int gstop = GROUP_STOP_CONSUME;
 		struct task_struct *t;
 
 		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED) ||
@@ -1741,6 +1755,7 @@ static int do_signal_stop(int signr)
 		 */
 		sig->group_exit_code = signr;
 
+		current->group_stop = gstop;
 		sig->group_stop_count = 1;
 		for (t = next_thread(current); t != current; t = next_thread(t))
 			/*
@@ -1750,16 +1765,20 @@ static int do_signal_stop(int signr)
 			 */
 			if (!(t->flags & PF_EXITING) &&
 			    !task_is_stopped_or_traced(t)) {
+				t->group_stop = gstop;
 				sig->group_stop_count++;
 				signal_wake_up(t, 0);
-			}
+			} else
+				t->group_stop = 0;
 	}
 	/*
 	 * If there are no other threads in the group, or if there is
 	 * a group stop in progress and we are the last to stop, report
 	 * to the parent.  When ptraced, every thread reports itself.
 	 */
-	notify = sig->group_stop_count == 1 ? CLD_STOPPED : 0;
+	if (sig->group_stop_count == 1 &&
+	    (current->group_stop & GROUP_STOP_CONSUME))
+		notify = CLD_STOPPED;
 	notify = tracehook_notify_jctl(notify, CLD_STOPPED);
 	/*
 	 * tracehook_notify_jctl() can drop and reacquire siglock, so
@@ -1771,7 +1790,7 @@ static int do_signal_stop(int signr)
 		goto out;
 	}
 
-	if (!--sig->group_stop_count)
+	if (consume_group_stop())
 		sig->flags = SIGNAL_STOP_STOPPED;
 
 	current->exit_code = sig->group_exit_code;
@@ -2036,8 +2055,7 @@ void exit_signals(struct task_struct *tsk)
 		if (!signal_pending(t) && !(t->flags & PF_EXITING))
 			recalc_sigpending_and_wake(t);
 
-	if (unlikely(tsk->signal->group_stop_count) &&
-			!--tsk->signal->group_stop_count) {
+	if (unlikely(tsk->signal->group_stop_count) && consume_group_stop()) {
 		tsk->signal->flags = SIGNAL_STOP_STOPPED;
 		group_stop = tracehook_notify_jctl(CLD_STOPPED, CLD_STOPPED);
 	}
-- 
1.7.1

