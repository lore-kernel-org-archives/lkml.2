Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881Ab1EXSh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:37:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45008 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932797Ab1EXShv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:37:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=sBP5po6kRrpm/bqOPQTF6KEUs28SL5VsGdAqvKPDoua+CECJZ9QydfMhCfPDwQwSNS
         6fRTfz38D6FAwhslS7e2LAZmgdSCwxNY4dNMxC/OGT9JxAbxelu8ZFZnW8DwPCFEHiHr
         2In5yYM3hqf1i2KleNLlCvOLz9Ez8qbn5kHoA=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/19] job control: rename signal->group_stop and flags to jobctl and rearrange flags
Date: Tue, 24 May 2011 20:37:21 +0200
Message-Id: <1306262259-7285-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1306262259-7285-1-git-send-email-tj@kernel.org>
References: <1306262259-7285-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

signal->group_stop currently hosts mostly group stop related flags;
however, it's gonna be used for wider purposes and the GROUP_STOP_
flag prefix becomes confusing.  Rename signal->group_stop to
signal->jobctl and rename all GROUP_STOP_* flags to JOBCTL_*.

Also, reassign JOBCTL_TRAPPING to bit 22 to better accomodate future
additions.

This doesn't cause any functional change.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/exec.c             |    2 +-
 include/linux/sched.h |   16 ++++----
 kernel/ptrace.c       |   12 +++---
 kernel/signal.c       |   91 +++++++++++++++++++++++++------------------------
 4 files changed, 61 insertions(+), 60 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index c1cf372..223e3b2 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1735,7 +1735,7 @@ static int zap_process(struct task_struct *start, int exit_code)
 
 	t = start;
 	do {
-		task_clear_group_stop_pending(t);
+		task_clear_jobctl_stop_pending(t);
 		if (t != current && t->mm) {
 			sigaddset(&t->pending.signal, SIGKILL);
 			signal_wake_up(t, 1);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index aaf71e0..01178e6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1271,7 +1271,7 @@ struct task_struct {
 	int exit_state;
 	int exit_code, exit_signal;
 	int pdeath_signal;  /*  The signal sent when the parent dies  */
-	unsigned int group_stop;	/* GROUP_STOP_*, siglock protected */
+	unsigned int jobctl;	/* JOBCTL_*, siglock protected */
 	/* ??? */
 	unsigned int personality;
 	unsigned did_exec:1;
@@ -1793,15 +1793,15 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define used_math() tsk_used_math(current)
 
 /*
- * task->group_stop flags
+ * task->jobctl flags
  */
-#define GROUP_STOP_SIGMASK	0xffff    /* signr of the last group stop */
-#define GROUP_STOP_PENDING	(1 << 16) /* task should stop for group stop */
-#define GROUP_STOP_CONSUME	(1 << 17) /* consume group stop count */
-#define GROUP_STOP_TRAPPING	(1 << 18) /* switching from STOPPED to TRACED */
-#define GROUP_STOP_DEQUEUED	(1 << 19) /* stop signal dequeued */
+#define JOBCTL_STOP_SIGMASK	0xffff    /* signr of the last group stop */
+#define JOBCTL_STOP_DEQUEUED	(1 << 16) /* stop signal dequeued */
+#define JOBCTL_STOP_PENDING	(1 << 17) /* task should stop for group stop */
+#define JOBCTL_STOP_CONSUME	(1 << 18) /* consume group stop count */
+#define JOBCTL_TRAPPING		(1 << 21) /* switching to TRACED */
 
-extern void task_clear_group_stop_pending(struct task_struct *task);
+extern void task_clear_jobctl_stop_pending(struct task_struct *task);
 
 #ifdef CONFIG_PREEMPT_RCU
 
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 7a81fc0..c7044d3 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -77,13 +77,13 @@ void __ptrace_unlink(struct task_struct *child)
 	spin_lock(&child->sighand->siglock);
 
 	/*
-	 * Reinstate GROUP_STOP_PENDING if group stop is in effect and
+	 * Reinstate JOBCTL_STOP_PENDING if group stop is in effect and
 	 * @child isn't dead.
 	 */
 	if (!(child->flags & PF_EXITING) &&
 	    (child->signal->flags & SIGNAL_STOP_STOPPED ||
 	     child->signal->group_stop_count))
-		child->group_stop |= GROUP_STOP_PENDING;
+		child->jobctl |= JOBCTL_STOP_PENDING;
 
 	/*
 	 * If transition to TASK_STOPPED is pending or in TASK_TRACED, kick
@@ -91,7 +91,7 @@ void __ptrace_unlink(struct task_struct *child)
 	 * is in TASK_TRACED; otherwise, we might unduly disrupt
 	 * TASK_KILLABLE sleeps.
 	 */
-	if (child->group_stop & GROUP_STOP_PENDING || task_is_traced(child))
+	if (child->jobctl & JOBCTL_STOP_PENDING || task_is_traced(child))
 		signal_wake_up(child, task_is_traced(child));
 
 	spin_unlock(&child->sighand->siglock);
@@ -227,7 +227,7 @@ static int ptrace_attach(struct task_struct *task)
 	spin_lock(&task->sighand->siglock);
 
 	/*
-	 * If the task is already STOPPED, set GROUP_STOP_PENDING and
+	 * If the task is already STOPPED, set JOBCTL_STOP_PENDING and
 	 * TRAPPING, and kick it so that it transits to TRACED.  TRAPPING
 	 * will be cleared if the child completes the transition or any
 	 * event which clears the group stop states happens.  We'll wait
@@ -244,7 +244,7 @@ static int ptrace_attach(struct task_struct *task)
 	 * in and out of STOPPED are protected by siglock.
 	 */
 	if (task_is_stopped(task)) {
-		task->group_stop |= GROUP_STOP_PENDING | GROUP_STOP_TRAPPING;
+		task->jobctl |= JOBCTL_STOP_PENDING | JOBCTL_TRAPPING;
 		signal_wake_up(task, 1);
 		wait_trap = true;
 	}
@@ -259,7 +259,7 @@ unlock_creds:
 out:
 	if (wait_trap)
 		wait_event(current->signal->wait_chldexit,
-			   !(task->group_stop & GROUP_STOP_TRAPPING));
+			   !(task->jobctl & JOBCTL_TRAPPING));
 	return retval;
 }
 
diff --git a/kernel/signal.c b/kernel/signal.c
index ad5e818..42d9bbd 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -124,7 +124,7 @@ static inline int has_pending_signals(sigset_t *signal, sigset_t *blocked)
 
 static int recalc_sigpending_tsk(struct task_struct *t)
 {
-	if ((t->group_stop & GROUP_STOP_PENDING) ||
+	if ((t->jobctl & JOBCTL_STOP_PENDING) ||
 	    PENDING(&t->pending, &t->blocked) ||
 	    PENDING(&t->signal->shared_pending, &t->blocked)) {
 		set_tsk_thread_flag(t, TIF_SIGPENDING);
@@ -224,27 +224,28 @@ static inline void print_dropped_signal(int sig)
 }
 
 /**
- * task_clear_group_stop_trapping - clear group stop trapping bit
+ * task_clear_jobctl_trapping - clear jobctl trapping bit
  * @task: target task
  *
- * If GROUP_STOP_TRAPPING is set, a ptracer is waiting for us.  Clear it
- * and wake up the ptracer.  Note that we don't need any further locking.
- * @task->siglock guarantees that @task->parent points to the ptracer.
+ * If JOBCTL_TRAPPING is set, a ptracer is waiting for us to enter TRACED.
+ * Clear it and wake up the ptracer.  Note that we don't need any further
+ * locking.  @task->siglock guarantees that @task->parent points to the
+ * ptracer.
  *
  * CONTEXT:
  * Must be called with @task->sighand->siglock held.
  */
-static void task_clear_group_stop_trapping(struct task_struct *task)
+static void task_clear_jobctl_trapping(struct task_struct *task)
 {
-	if (unlikely(task->group_stop & GROUP_STOP_TRAPPING)) {
-		task->group_stop &= ~GROUP_STOP_TRAPPING;
+	if (unlikely(task->jobctl & JOBCTL_TRAPPING)) {
+		task->jobctl &= ~JOBCTL_TRAPPING;
 		__wake_up_sync_key(&task->parent->signal->wait_chldexit,
 				   TASK_UNINTERRUPTIBLE, 1, task);
 	}
 }
 
 /**
- * task_clear_group_stop_pending - clear pending group stop
+ * task_clear_jobctl_stop_pending - clear pending group stop
  * @task: target task
  *
  * Clear group stop states for @task.
@@ -252,19 +253,19 @@ static void task_clear_group_stop_trapping(struct task_struct *task)
  * CONTEXT:
  * Must be called with @task->sighand->siglock held.
  */
-void task_clear_group_stop_pending(struct task_struct *task)
+void task_clear_jobctl_stop_pending(struct task_struct *task)
 {
-	task->group_stop &= ~(GROUP_STOP_PENDING | GROUP_STOP_CONSUME |
-			      GROUP_STOP_DEQUEUED);
+	task->jobctl &= ~(JOBCTL_STOP_PENDING | JOBCTL_STOP_CONSUME |
+			  JOBCTL_STOP_DEQUEUED);
 }
 
 /**
  * task_participate_group_stop - participate in a group stop
  * @task: task participating in a group stop
  *
- * @task has GROUP_STOP_PENDING set and is participating in a group stop.
+ * @task has %JOBCTL_STOP_PENDING set and is participating in a group stop.
  * Group stop states are cleared and the group stop count is consumed if
- * %GROUP_STOP_CONSUME was set.  If the consumption completes the group
+ * %JOBCTL_STOP_CONSUME was set.  If the consumption completes the group
  * stop, the appropriate %SIGNAL_* flags are set.
  *
  * CONTEXT:
@@ -277,11 +278,11 @@ void task_clear_group_stop_pending(struct task_struct *task)
 static bool task_participate_group_stop(struct task_struct *task)
 {
 	struct signal_struct *sig = task->signal;
-	bool consume = task->group_stop & GROUP_STOP_CONSUME;
+	bool consume = task->jobctl & JOBCTL_STOP_CONSUME;
 
-	WARN_ON_ONCE(!(task->group_stop & GROUP_STOP_PENDING));
+	WARN_ON_ONCE(!(task->jobctl & JOBCTL_STOP_PENDING));
 
-	task_clear_group_stop_pending(task);
+	task_clear_jobctl_stop_pending(task);
 
 	if (!consume)
 		return false;
@@ -604,7 +605,7 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 		 * is to alert stop-signal processing code when another
 		 * processor has come along and cleared the flag.
 		 */
-		current->group_stop |= GROUP_STOP_DEQUEUED;
+		current->jobctl |= JOBCTL_STOP_DEQUEUED;
 	}
 	if ((info->si_code & __SI_MASK) == __SI_TIMER && info->si_sys_private) {
 		/*
@@ -809,7 +810,7 @@ static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
 		rm_from_queue(SIG_KERNEL_STOP_MASK, &signal->shared_pending);
 		t = p;
 		do {
-			task_clear_group_stop_pending(t);
+			task_clear_jobctl_stop_pending(t);
 			rm_from_queue(SIG_KERNEL_STOP_MASK, &t->pending);
 			wake_up_state(t, __TASK_STOPPED);
 		} while_each_thread(p, t);
@@ -925,7 +926,7 @@ static void complete_signal(int sig, struct task_struct *p, int group)
 			signal->group_stop_count = 0;
 			t = p;
 			do {
-				task_clear_group_stop_pending(t);
+				task_clear_jobctl_stop_pending(t);
 				sigaddset(&t->pending.signal, SIGKILL);
 				signal_wake_up(t, 1);
 			} while_each_thread(p, t);
@@ -1160,7 +1161,7 @@ int zap_other_threads(struct task_struct *p)
 	p->signal->group_stop_count = 0;
 
 	while_each_thread(p, t) {
-		task_clear_group_stop_pending(t);
+		task_clear_jobctl_stop_pending(t);
 		count++;
 
 		/* Don't bother with already dead threads */
@@ -1738,7 +1739,7 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	 * clear now.  We act as if SIGCONT is received after TASK_TRACED
 	 * is entered - ignore it.
 	 */
-	if (why == CLD_STOPPED && (current->group_stop & GROUP_STOP_PENDING))
+	if (why == CLD_STOPPED && (current->jobctl & JOBCTL_STOP_PENDING))
 		gstop_done = task_participate_group_stop(current);
 
 	current->last_siginfo = info;
@@ -1751,12 +1752,12 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	set_current_state(TASK_TRACED);
 
 	/*
-	 * We're committing to trapping.  Clearing GROUP_STOP_TRAPPING and
+	 * We're committing to trapping.  Clearing JOBCTL_TRAPPING and
 	 * transition to TASK_TRACED should be atomic with respect to
-	 * siglock.  This hsould be done after the arch hook as siglock is
+	 * siglock.  This should be done after the arch hook as siglock is
 	 * released and regrabbed across it.
 	 */
-	task_clear_group_stop_trapping(current);
+	task_clear_jobctl_trapping(current);
 
 	spin_unlock_irq(&current->sighand->siglock);
 	read_lock(&tasklist_lock);
@@ -1792,9 +1793,9 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 		 *
 		 * If @gstop_done, the ptracer went away between group stop
 		 * completion and here.  During detach, it would have set
-		 * GROUP_STOP_PENDING on us and we'll re-enter TASK_STOPPED
-		 * in do_signal_stop() on return, so notifying the real
-		 * parent of the group stop completion is enough.
+		 * JOBCTL_STOP_PENDING on us and we'll re-enter
+		 * TASK_STOPPED in do_signal_stop() on return, so notifying
+		 * the real parent of the group stop completion is enough.
 		 */
 		if (gstop_done)
 			do_notify_parent_cldstop(current, false, why);
@@ -1856,14 +1857,14 @@ static int do_signal_stop(int signr)
 {
 	struct signal_struct *sig = current->signal;
 
-	if (!(current->group_stop & GROUP_STOP_PENDING)) {
-		unsigned int gstop = GROUP_STOP_PENDING | GROUP_STOP_CONSUME;
+	if (!(current->jobctl & JOBCTL_STOP_PENDING)) {
+		unsigned int gstop = JOBCTL_STOP_PENDING | JOBCTL_STOP_CONSUME;
 		struct task_struct *t;
 
-		/* signr will be recorded in task->group_stop for retries */
-		WARN_ON_ONCE(signr & ~GROUP_STOP_SIGMASK);
+		/* signr will be recorded in task->jobctl for retries */
+		WARN_ON_ONCE(signr & ~JOBCTL_STOP_SIGMASK);
 
-		if (!likely(current->group_stop & GROUP_STOP_DEQUEUED) ||
+		if (!likely(current->jobctl & JOBCTL_STOP_DEQUEUED) ||
 		    unlikely(signal_group_exit(sig)))
 			return 0;
 		/*
@@ -1890,19 +1891,19 @@ static int do_signal_stop(int signr)
 		else
 			WARN_ON_ONCE(!task_ptrace(current));
 
-		current->group_stop &= ~GROUP_STOP_SIGMASK;
-		current->group_stop |= signr | gstop;
+		current->jobctl &= ~JOBCTL_STOP_SIGMASK;
+		current->jobctl |= signr | gstop;
 		sig->group_stop_count = 1;
 		for (t = next_thread(current); t != current;
 		     t = next_thread(t)) {
-			t->group_stop &= ~GROUP_STOP_SIGMASK;
+			t->jobctl &= ~JOBCTL_STOP_SIGMASK;
 			/*
 			 * Setting state to TASK_STOPPED for a group
 			 * stop is always done with the siglock held,
 			 * so this check has no races.
 			 */
 			if (!(t->flags & PF_EXITING) && !task_is_stopped(t)) {
-				t->group_stop |= signr | gstop;
+				t->jobctl |= signr | gstop;
 				sig->group_stop_count++;
 				signal_wake_up(t, 0);
 			}
@@ -1943,23 +1944,23 @@ retry:
 
 		spin_lock_irq(&current->sighand->siglock);
 	} else {
-		ptrace_stop(current->group_stop & GROUP_STOP_SIGMASK,
+		ptrace_stop(current->jobctl & JOBCTL_STOP_SIGMASK,
 			    CLD_STOPPED, 0, NULL);
 		current->exit_code = 0;
 	}
 
 	/*
-	 * GROUP_STOP_PENDING could be set if another group stop has
+	 * JOBCTL_STOP_PENDING could be set if another group stop has
 	 * started since being woken up or ptrace wants us to transit
 	 * between TASK_STOPPED and TRACED.  Retry group stop.
 	 */
-	if (current->group_stop & GROUP_STOP_PENDING) {
-		WARN_ON_ONCE(!(current->group_stop & GROUP_STOP_SIGMASK));
+	if (current->jobctl & JOBCTL_STOP_PENDING) {
+		WARN_ON_ONCE(!(current->jobctl & JOBCTL_STOP_SIGMASK));
 		goto retry;
 	}
 
 	/* PTRACE_ATTACH might have raced with task killing, clear trapping */
-	task_clear_group_stop_trapping(current);
+	task_clear_jobctl_trapping(current);
 
 	spin_unlock_irq(&current->sighand->siglock);
 
@@ -2078,8 +2079,8 @@ relock:
 		if (unlikely(signr != 0))
 			ka = return_ka;
 		else {
-			if (unlikely(current->group_stop &
-				     GROUP_STOP_PENDING) && do_signal_stop(0))
+			if (unlikely(current->jobctl & JOBCTL_STOP_PENDING) &&
+			    do_signal_stop(0))
 				goto relock;
 
 			signr = dequeue_signal(current, &current->blocked,
@@ -2253,7 +2254,7 @@ void exit_signals(struct task_struct *tsk)
 	signotset(&unblocked);
 	retarget_shared_pending(tsk, &unblocked);
 
-	if (unlikely(tsk->group_stop & GROUP_STOP_PENDING) &&
+	if (unlikely(tsk->jobctl & JOBCTL_STOP_PENDING) &&
 	    task_participate_group_stop(tsk))
 		group_stop = CLD_STOPPED;
 out:
-- 
1.7.1

