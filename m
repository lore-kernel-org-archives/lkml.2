Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab1I3PNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 11:13:19 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60242 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755091Ab1I3PNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 11:13:14 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Anirudh Badam <abadam@cs.princeton.edu>
Subject: [RFC][PATCH 4/5] signal: Add signal->ctrl_lock for job control
Date: Fri, 30 Sep 2011 16:12:56 +0100
Message-Id: <1317395577-14091-5-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Instead of using sighand->siglock to synchronise access to job control
data structures provide a new lock 'ctrl_lock'. This helps to reduce
contention on the per-process siglock.

Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Anirudh Badam <abadam@cs.princeton.edu>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 fs/exec.c                 |   17 +++---
 include/linux/init_task.h |    1 +
 include/linux/sched.h     |    4 +-
 kernel/exit.c             |   19 ++++---
 kernel/fork.c             |    1 +
 kernel/ptrace.c           |   64 +++++++++++------------
 kernel/signal.c           |  128 ++++++++++++++++++++++++++++++++------------
 security/selinux/hooks.c  |    2 +
 8 files changed, 150 insertions(+), 86 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 8433e5d..367d3df 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -868,7 +868,6 @@ static int de_thread(struct task_struct *tsk)
 {
 	struct signal_struct *sig = tsk->signal;
 	struct sighand_struct *oldsighand = tsk->sighand;
-	spinlock_t *lock = &oldsighand->siglock;
 
 	if (thread_group_empty(tsk))
 		goto no_thread_group;
@@ -876,13 +875,13 @@ static int de_thread(struct task_struct *tsk)
 	/*
 	 * Kill all other threads in the thread group.
 	 */
-	spin_lock_irq(lock);
+	spin_lock_irq(&sig->ctrl_lock);
 	if (signal_group_exit(sig)) {
 		/*
 		 * Another group action in progress, just
 		 * return so that the signal is processed.
 		 */
-		spin_unlock_irq(lock);
+		spin_unlock_irq(&sig->ctrl_lock);
 		return -EAGAIN;
 	}
 
@@ -893,11 +892,11 @@ static int de_thread(struct task_struct *tsk)
 
 	while (sig->notify_count) {
 		__set_current_state(TASK_UNINTERRUPTIBLE);
-		spin_unlock_irq(lock);
+		spin_unlock_irq(&sig->ctrl_lock);
 		schedule();
-		spin_lock_irq(lock);
+		spin_lock_irq(&sig->ctrl_lock);
 	}
-	spin_unlock_irq(lock);
+	spin_unlock_irq(&sig->ctrl_lock);
 
 	/*
 	 * At this point all other threads have exited, all we have to
@@ -1845,12 +1844,12 @@ static inline int zap_threads(struct task_struct *tsk, struct mm_struct *mm,
 	unsigned long flags;
 	int nr = -EAGAIN;
 
-	spin_lock_irq(&tsk->sighand->siglock);
+	spin_lock_irq(&tsk->signal->ctrl_lock);
 	if (!signal_group_exit(tsk->signal)) {
 		mm->core_state = core_state;
 		nr = zap_process(tsk, exit_code);
 	}
-	spin_unlock_irq(&tsk->sighand->siglock);
+	spin_unlock_irq(&tsk->signal->ctrl_lock);
 	if (unlikely(nr < 0))
 		return nr;
 
@@ -1897,7 +1896,9 @@ static inline int zap_threads(struct task_struct *tsk, struct mm_struct *mm,
 			if (p->mm) {
 				if (unlikely(p->mm == mm)) {
 					lock_task_sighand(p, &flags);
+					spin_lock(&p->signal->ctrl_lock);
 					nr += zap_process(p, exit_code);
+					spin_unlock(&p->signal->ctrl_lock);
 					unlock_task_sighand(p, &flags);
 				}
 				break;
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 1a66552..80baa1d 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -33,6 +33,7 @@ extern struct fs_struct init_fs;
 #define INIT_SIGNALS(sig) {						\
 	.nr_threads	= 1,						\
 	.wait_chldexit	= __WAIT_QUEUE_HEAD_INITIALIZER(sig.wait_chldexit),\
+	.ctrl_lock	= __SPIN_LOCK_UNLOCKED(sig.ctrl_lock),		\
 	.shared_pending	= { 						\
 		.list = LIST_HEAD_INIT(sig.shared_pending.list),	\
 		.signal =  {{0}}},					\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e4cd6bb..e35ce4a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -537,6 +537,8 @@ struct signal_struct {
 	/* shared signal handling: */
 	struct sigpending	shared_pending;
 
+	spinlock_t		ctrl_lock;
+
 	/* thread group exit support */
 	int			group_exit_code;
 	/* overloaded:
@@ -1293,7 +1295,7 @@ struct task_struct {
 	int exit_state;
 	int exit_code, exit_signal;
 	int pdeath_signal;  /*  The signal sent when the parent dies  */
-	unsigned int jobctl;	/* JOBCTL_*, siglock protected */
+	unsigned int jobctl;	/* JOBCTL_*, ctrl_lock protected */
 	/* ??? */
 	unsigned int personality;
 	unsigned did_exec:1;
diff --git a/kernel/exit.c b/kernel/exit.c
index a8a83ac..379a13d 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -106,8 +106,10 @@ static void __exit_signal(struct task_struct *tsk)
 		 * If there is any task waiting for the group exit
 		 * then notify it:
 		 */
+		spin_lock(&sig->ctrl_lock);
 		if (sig->notify_count > 0 && !--sig->notify_count)
 			wake_up_process(sig->group_exit_task);
+		spin_unlock(&sig->ctrl_lock);
 
 		if (tsk == sig->curr_target)
 			sig->curr_target = next_thread(tsk);
@@ -1086,8 +1088,7 @@ do_group_exit(int exit_code)
 	if (signal_group_exit(sig))
 		exit_code = sig->group_exit_code;
 	else if (!thread_group_empty(current)) {
-		struct sighand_struct *const sighand = current->sighand;
-		spin_lock_irq(&sighand->siglock);
+		spin_lock_irq(&sig->ctrl_lock);
 		if (signal_group_exit(sig))
 			/* Another thread got here before we took the lock.  */
 			exit_code = sig->group_exit_code;
@@ -1096,7 +1097,7 @@ do_group_exit(int exit_code)
 			sig->flags = SIGNAL_GROUP_EXIT;
 			zap_other_threads(current);
 		}
-		spin_unlock_irq(&sighand->siglock);
+		spin_unlock_irq(&sig->ctrl_lock);
 	}
 
 	do_exit(exit_code);
@@ -1381,7 +1382,7 @@ static int *task_stopped_code(struct task_struct *p, bool ptrace)
  *
  * CONTEXT:
  * read_lock(&tasklist_lock), which is released if return value is
- * non-zero.  Also, grabs and releases @p->sighand->siglock.
+ * non-zero.  Also, grabs and releases @p->signal->ctrl_lock.
  *
  * RETURNS:
  * 0 if wait condition didn't exist and search for other wait conditions
@@ -1407,7 +1408,7 @@ static int wait_task_stopped(struct wait_opts *wo,
 		return 0;
 
 	exit_code = 0;
-	spin_lock_irq(&p->sighand->siglock);
+	spin_lock_irq(&p->signal->ctrl_lock);
 
 	p_code = task_stopped_code(p, ptrace);
 	if (unlikely(!p_code))
@@ -1422,7 +1423,7 @@ static int wait_task_stopped(struct wait_opts *wo,
 
 	uid = task_uid(p);
 unlock_sig:
-	spin_unlock_irq(&p->sighand->siglock);
+	spin_unlock_irq(&p->signal->ctrl_lock);
 	if (!exit_code)
 		return 0;
 
@@ -1485,16 +1486,16 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
 	if (!(p->signal->flags & SIGNAL_STOP_CONTINUED))
 		return 0;
 
-	spin_lock_irq(&p->sighand->siglock);
+	spin_lock_irq(&p->signal->ctrl_lock);
 	/* Re-check with the lock held.  */
 	if (!(p->signal->flags & SIGNAL_STOP_CONTINUED)) {
-		spin_unlock_irq(&p->sighand->siglock);
+		spin_unlock_irq(&p->signal->ctrl_lock);
 		return 0;
 	}
 	if (!unlikely(wo->wo_flags & WNOWAIT))
 		p->signal->flags &= ~SIGNAL_STOP_CONTINUED;
 	uid = task_uid(p);
-	spin_unlock_irq(&p->sighand->siglock);
+	spin_unlock_irq(&p->signal->ctrl_lock);
 
 	pid = task_pid_vnr(p);
 	get_task_struct(p);
diff --git a/kernel/fork.c b/kernel/fork.c
index 8871ae8..8c5cf19 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -993,6 +993,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 		sig->flags |= SIGNAL_UNKILLABLE;
 	sig->curr_target = tsk;
 	init_sigpending(&sig->shared_pending);
+	spin_lock_init(&sig->ctrl_lock);
 	INIT_LIST_HEAD(&sig->posix_timers);
 
 	hrtimer_init(&sig->real_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index eb46323..e4966b0 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -81,7 +81,7 @@ void __ptrace_unlink(struct task_struct *child)
 	child->parent = child->real_parent;
 	list_del_init(&child->ptrace_entry);
 
-	spin_lock(&child->sighand->siglock);
+	spin_lock(&child->signal->ctrl_lock);
 
 	/*
 	 * Clear all pending traps and TRAPPING.  TRAPPING should be
@@ -108,7 +108,7 @@ void __ptrace_unlink(struct task_struct *child)
 	if (child->jobctl & JOBCTL_STOP_PENDING || task_is_traced(child))
 		signal_wake_up(child, task_is_traced(child));
 
-	spin_unlock(&child->sighand->siglock);
+	spin_unlock(&child->signal->ctrl_lock);
 }
 
 /**
@@ -123,7 +123,7 @@ void __ptrace_unlink(struct task_struct *child)
  * state.
  *
  * CONTEXT:
- * Grabs and releases tasklist_lock and @child->sighand->siglock.
+ * Grabs and releases tasklist_lock and @child->signal->ctrl_lock.
  *
  * RETURNS:
  * 0 on success, -ESRCH if %child is not ready.
@@ -141,16 +141,12 @@ int ptrace_check_attach(struct task_struct *child, bool ignore_state)
 	 */
 	read_lock(&tasklist_lock);
 	if ((child->ptrace & PT_PTRACED) && child->parent == current) {
-		/*
-		 * child->sighand can't be NULL, release_task()
-		 * does ptrace_unlink() before __exit_signal().
-		 */
-		spin_lock_irq(&child->sighand->siglock);
+		spin_lock_irq(&child->signal->ctrl_lock);
 		WARN_ON_ONCE(task_is_stopped(child));
 		if (ignore_state || (task_is_traced(child) &&
 				     !(child->jobctl & JOBCTL_LISTENING)))
 			ret = 0;
-		spin_unlock_irq(&child->sighand->siglock);
+		spin_unlock_irq(&child->signal->ctrl_lock);
 	}
 	read_unlock(&tasklist_lock);
 
@@ -275,7 +271,7 @@ static int ptrace_attach(struct task_struct *task, long request,
 	if (!seize)
 		send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
 
-	spin_lock(&task->sighand->siglock);
+	spin_lock(&task->signal->ctrl_lock);
 
 	/*
 	 * If the task is already STOPPED, set JOBCTL_TRAP_STOP and
@@ -292,13 +288,13 @@ static int ptrace_attach(struct task_struct *task, long request,
 	 * ATTACH, the wait(2) may fail due to the transient RUNNING.
 	 *
 	 * The following task_is_stopped() test is safe as both transitions
-	 * in and out of STOPPED are protected by siglock.
+	 * in and out of STOPPED are protected by ctrl_lock.
 	 */
 	if (task_is_stopped(task) &&
 	    task_set_jobctl_pending(task, JOBCTL_TRAP_STOP | JOBCTL_TRAPPING))
 		signal_wake_up(task, 1);
 
-	spin_unlock(&task->sighand->siglock);
+	spin_unlock(&task->signal->ctrl_lock);
 
 	retval = 0;
 unlock_tasklist:
@@ -538,32 +534,30 @@ static int ptrace_setoptions(struct task_struct *child, unsigned long data)
 static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
 {
 	unsigned long flags;
-	int error = -ESRCH;
+	int error = -EINVAL;
 
-	if (lock_task_sighand(child, &flags)) {
-		error = -EINVAL;
-		if (likely(child->last_siginfo != NULL)) {
-			*info = *child->last_siginfo;
-			error = 0;
-		}
-		unlock_task_sighand(child, &flags);
+	spin_lock_irqsave(&child->signal->ctrl_lock, flags);
+	if (likely(child->last_siginfo != NULL)) {
+		*info = *child->last_siginfo;
+		error = 0;
 	}
+	spin_unlock_irqrestore(&child->signal->ctrl_lock, flags);
+
 	return error;
 }
 
 static int ptrace_setsiginfo(struct task_struct *child, const siginfo_t *info)
 {
 	unsigned long flags;
-	int error = -ESRCH;
+	int error = -EINVAL;
 
-	if (lock_task_sighand(child, &flags)) {
-		error = -EINVAL;
-		if (likely(child->last_siginfo != NULL)) {
-			*child->last_siginfo = *info;
-			error = 0;
-		}
-		unlock_task_sighand(child, &flags);
+	spin_lock_irqsave(&child->signal->ctrl_lock, flags);
+	if (likely(child->last_siginfo != NULL)) {
+		*child->last_siginfo = *info;
+		error = 0;
 	}
+	spin_unlock_irqrestore(&child->signal->ctrl_lock, flags);
+
 	return error;
 }
 
@@ -715,7 +709,7 @@ int ptrace_request(struct task_struct *child, long request,
 		 * The actual trap might not be PTRACE_EVENT_STOP trap but
 		 * the pending condition is cleared regardless.
 		 */
-		if (unlikely(!seized || !lock_task_sighand(child, &flags)))
+		if (unlikely(!seized))
 			break;
 
 		/*
@@ -724,10 +718,11 @@ int ptrace_request(struct task_struct *child, long request,
 		 * STOP, this INTERRUPT should clear LISTEN and re-trap
 		 * tracee into STOP.
 		 */
+		spin_lock_irqsave(&child->signal->ctrl_lock, flags);
 		if (likely(task_set_jobctl_pending(child, JOBCTL_TRAP_STOP)))
 			signal_wake_up(child, child->jobctl & JOBCTL_LISTENING);
 
-		unlock_task_sighand(child, &flags);
+		spin_unlock_irqrestore(&child->signal->ctrl_lock, flags);
 		ret = 0;
 		break;
 
@@ -740,12 +735,15 @@ int ptrace_request(struct task_struct *child, long request,
 		 * again.  Alternatively, ptracer can issue INTERRUPT to
 		 * finish listening and re-trap tracee into STOP.
 		 */
-		if (unlikely(!seized || !lock_task_sighand(child, &flags)))
+		if (unlikely(!seized))
 			break;
 
+		spin_lock_irqsave(&child->signal->ctrl_lock, flags);
 		si = child->last_siginfo;
-		if (unlikely(!si || si->si_code >> 8 != PTRACE_EVENT_STOP))
+		if (unlikely(!si || si->si_code >> 8 != PTRACE_EVENT_STOP)) {
+			spin_unlock_irqrestore(&child->signal->ctrl_lock, flags);
 			break;
+		}
 
 		child->jobctl |= JOBCTL_LISTENING;
 
@@ -756,7 +754,7 @@ int ptrace_request(struct task_struct *child, long request,
 		if (child->jobctl & JOBCTL_TRAP_NOTIFY)
 			signal_wake_up(child, true);
 
-		unlock_task_sighand(child, &flags);
+		spin_unlock_irqrestore(&child->signal->ctrl_lock, flags);
 		ret = 0;
 		break;
 
diff --git a/kernel/signal.c b/kernel/signal.c
index b69c5a9..ca99c2d 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -50,13 +50,7 @@
  *        * most things under tsk->signal
  *
  *        * tsk->last_siginfo
- *        * tsk->group_stop
  *        * tsk->pending
- *        * tsk->jobctl
- *
- *        * the atomic operation of checking tsk->jobctl, tsk->pending and
- *          tsk->signal->shared_pending and setting/clearing TIF_SIGPENDING,
- *          see recalc_sigpending().
  *
  *        * tsk->cpu_timers
  *
@@ -66,6 +60,19 @@
  *          for reading, see lock_action() for when the write-lock is
  *          necessary.
  *
+ *   - signal->ctrl_lock (spinlock) protects,
+ *
+ *        * tsk->signal->group_exit_code
+ *        * tsk->signal->group_exit_task
+ *        * tsk->signal->notify_count
+ *        * tsk->signal->group_stop
+ *        * tsk->signal->flags
+ *        * tsk->group_stop
+ *        * tsk->jobctl
+ *
+ *        * the atomic operation of checking tsk->jobctl, tsk->pending and
+ *          tsk->signal->shared_pending and setting/clearing TIF_SIGPENDING,
+ *          see recalc_sigpending().
  */
 
 /*
@@ -157,8 +164,23 @@ static inline int has_pending_signals(sigset_t *signal, sigset_t *blocked)
 
 #define PENDING(p,b) has_pending_signals(&(p)->signal, (b))
 
+/**
+ * recalc_sigpending_tsk - check for pending signals
+ * @t: task to calculate pending signals for
+ *
+ * CONTEXT:
+ * Must be called with both t->signal->ctrl_lock and t->sighand->siglock held,
+ * because TIF_SIGPENDING can be set by a task holding either of them.
+ *
+ * RETURNS:
+ * 0 if there are no pending signals. Otherwise we return 1 and set
+ * TIF_SIGPENDING.
+ */
 static int recalc_sigpending_tsk(struct task_struct *t)
 {
+	assert_spin_locked(&t->sighand->siglock);
+	assert_spin_locked(&t->signal->ctrl_lock);
+
 	if ((t->jobctl & JOBCTL_PENDING_MASK) ||
 	    PENDING(&t->pending, &t->blocked) ||
 	    PENDING(&t->signal->shared_pending, &t->blocked)) {
@@ -179,15 +201,22 @@ static int recalc_sigpending_tsk(struct task_struct *t)
  */
 void recalc_sigpending_and_wake(struct task_struct *t)
 {
+	struct signal_struct *sig = t->signal;
+
+	spin_lock(&sig->ctrl_lock);
 	if (recalc_sigpending_tsk(t))
 		signal_wake_up(t, 0);
+	spin_unlock(&sig->ctrl_lock);
 }
 
 void recalc_sigpending(void)
 {
+	struct signal_struct *sig = current->signal;
+
+	spin_lock(&sig->ctrl_lock);
 	if (!recalc_sigpending_tsk(current) && !freezing(current))
 		clear_thread_flag(TIF_SIGPENDING);
-
+	spin_unlock(&sig->ctrl_lock);
 }
 
 /* Given the mask, find the first available signal that should be serviced. */
@@ -268,7 +297,7 @@ static inline void print_dropped_signal(int sig)
  * becomes noop.
  *
  * CONTEXT:
- * Must be called with @task->sighand->siglock held.
+ * Must be called with @task->signal->ctrl_lock held.
  *
  * RETURNS:
  * %true if @mask is set, %false if made noop because @task was dying.
@@ -278,6 +307,7 @@ bool task_set_jobctl_pending(struct task_struct *task, unsigned int mask)
 	BUG_ON(mask & ~(JOBCTL_PENDING_MASK | JOBCTL_STOP_CONSUME |
 			JOBCTL_STOP_SIGMASK | JOBCTL_TRAPPING));
 	BUG_ON((mask & JOBCTL_TRAPPING) && !(mask & JOBCTL_PENDING_MASK));
+	assert_spin_locked(&task->signal->ctrl_lock);
 
 	if (unlikely(fatal_signal_pending(task) || (task->flags & PF_EXITING)))
 		return false;
@@ -299,10 +329,12 @@ bool task_set_jobctl_pending(struct task_struct *task, unsigned int mask)
  * ptracer.
  *
  * CONTEXT:
- * Must be called with @task->sighand->siglock held.
+ * Must be called with @task->signal->ctrl_lock held.
  */
 void task_clear_jobctl_trapping(struct task_struct *task)
 {
+	assert_spin_locked(&task->signal->ctrl_lock);
+
 	if (unlikely(task->jobctl & JOBCTL_TRAPPING)) {
 		task->jobctl &= ~JOBCTL_TRAPPING;
 		wake_up_bit(&task->jobctl, JOBCTL_TRAPPING_BIT);
@@ -322,11 +354,12 @@ void task_clear_jobctl_trapping(struct task_struct *task)
  * task_clear_jobctl_trapping().
  *
  * CONTEXT:
- * Must be called with @task->sighand->siglock held.
+ * Must be called with @task->signal->ctrl_lock held.
  */
 void task_clear_jobctl_pending(struct task_struct *task, unsigned int mask)
 {
 	BUG_ON(mask & ~JOBCTL_PENDING_MASK);
+	assert_spin_locked(&task->signal->ctrl_lock);
 
 	if (mask & JOBCTL_STOP_PENDING)
 		mask |= JOBCTL_STOP_CONSUME | JOBCTL_STOP_DEQUEUED;
@@ -347,7 +380,7 @@ void task_clear_jobctl_pending(struct task_struct *task, unsigned int mask)
  * stop, the appropriate %SIGNAL_* flags are set.
  *
  * CONTEXT:
- * Must be called with @task->sighand->siglock held.
+ * Must be called with @task->signal->ctrl_lock held.
  *
  * RETURNS:
  * %true if group stop completion should be notified to the parent, %false
@@ -359,6 +392,7 @@ static bool task_participate_group_stop(struct task_struct *task)
 	bool consume = task->jobctl & JOBCTL_STOP_CONSUME;
 
 	WARN_ON_ONCE(!(task->jobctl & JOBCTL_STOP_PENDING));
+	assert_spin_locked(&sig->ctrl_lock);
 
 	task_clear_jobctl_pending(task, JOBCTL_STOP_PENDING);
 
@@ -672,8 +706,10 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 		}
 	}
 
+	spin_lock(&current->signal->ctrl_lock);
 	recalc_sigpending();
 	if (!signr) {
+		spin_unlock(&current->signal->ctrl_lock);
 		spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
 		return 0;
 	}
@@ -694,6 +730,7 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 		current->jobctl |= JOBCTL_STOP_DEQUEUED;
 	}
 
+	spin_unlock(&current->signal->ctrl_lock);
 	spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
 
 	if ((info->si_code & __SI_MASK) == __SI_TIMER && info->si_sys_private)
@@ -706,8 +743,8 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
  * Tell a process that it has a new active signal..
  *
  * NOTE! we rely on the previous spin_lock to
- * lock interrupts for us! We can only be called with
- * "siglock" held, and the local interrupt must
+ * lock interrupts for us! We can only be called with either
+ * "siglock"  or "ctrl_lock" held, and the local interrupt must
  * have been disabled when that got acquired!
  *
  * No need to set need_resched since signal event passing
@@ -870,12 +907,12 @@ static int check_kill_permission(int sig, struct siginfo *info,
  * are finished by PTRACE_CONT.
  *
  * CONTEXT:
- * Must be called with @task->sighand->siglock held.
+ * Must be called with @task->signal->ctrl_lock held.
  */
 static void ptrace_trap_notify(struct task_struct *t)
 {
 	WARN_ON_ONCE(!(t->ptrace & PT_SEIZED));
-	assert_spin_locked(&t->sighand->siglock);
+	assert_spin_locked(&t->signal->ctrl_lock);
 
 	task_set_jobctl_pending(t, JOBCTL_TRAP_NOTIFY);
 	signal_wake_up(t, t->jobctl & JOBCTL_LISTENING);
@@ -896,6 +933,7 @@ static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
 	struct signal_struct *signal = p->signal;
 	struct task_struct *t;
 
+	spin_lock(&signal->ctrl_lock);
 	if (unlikely(signal->flags & SIGNAL_GROUP_EXIT)) {
 		/*
 		 * The process is in the middle of dying, nothing to do.
@@ -950,6 +988,7 @@ static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
 			signal->group_exit_code = 0;
 		}
 	}
+	spin_unlock(&signal->ctrl_lock);
 
 	return !sig_ignored(p, sig, from_ancestor_ns);
 }
@@ -1016,6 +1055,7 @@ static void complete_signal(int sig, struct task_struct *p, int group)
 	 * Found a killable thread.  If the signal will be fatal,
 	 * then start taking the whole group down immediately.
 	 */
+	spin_lock(&signal->ctrl_lock);
 	if (sig_fatal(p, sig) &&
 	    !(signal->flags & (SIGNAL_UNKILLABLE | SIGNAL_GROUP_EXIT)) &&
 	    !sigismember(&t->real_blocked, sig) &&
@@ -1039,6 +1079,7 @@ static void complete_signal(int sig, struct task_struct *p, int group)
 				sigaddset(&t->pending.signal, SIGKILL);
 				signal_wake_up(t, 1);
 			} while_each_thread(p, t);
+			spin_unlock(&signal->ctrl_lock);
 			return;
 		}
 	}
@@ -1048,6 +1089,7 @@ static void complete_signal(int sig, struct task_struct *p, int group)
 	 * Tell the chosen thread to wake up and dequeue it.
 	 */
 	signal_wake_up(t, sig == SIGKILL);
+	spin_unlock(&signal->ctrl_lock);
 	return;
 }
 
@@ -1840,7 +1882,10 @@ static int sigkill_pending(struct task_struct *tsk)
 static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	__releases(&current->sighand->siglock)
 	__acquires(&current->sighand->siglock)
+	__releases(&current->signal->ctrl_lock)
+	__acquires(&current->signal->ctrl_lock)
 {
+	struct signal_struct *sig = current->signal;
 	bool gstop_done = false;
 
 	if (arch_ptrace_stop_needed(exit_code, info)) {
@@ -1855,9 +1900,11 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 		 * siglock.  That must prevent us from sleeping in TASK_TRACED.
 		 * So after regaining the lock, we must check for SIGKILL.
 		 */
+		spin_unlock(&sig->ctrl_lock);
 		spin_unlock_irq(&current->sighand->siglock);
 		arch_ptrace_stop(exit_code, info);
 		spin_lock_irq(&current->sighand->siglock);
+		spin_lock(&sig->ctrl_lock);
 		if (sigkill_pending(current))
 			return;
 	}
@@ -1892,6 +1939,7 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	/* entering a trap, clear TRAPPING */
 	task_clear_jobctl_trapping(current);
 
+	spin_unlock(&sig->ctrl_lock);
 	spin_unlock_irq(&current->sighand->siglock);
 	read_lock(&tasklist_lock);
 	if (may_ptrace_stop()) {
@@ -1947,11 +1995,12 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	try_to_freeze();
 
 	/*
-	 * We are back.  Now reacquire the siglock before touching
+	 * We are back.  Now reacquire the ctrl_lock before touching
 	 * last_siginfo, so that we are sure to have synchronized with
 	 * any signal-sending on another CPU that wants to examine it.
 	 */
 	spin_lock_irq(&current->sighand->siglock);
+	spin_lock(&sig->ctrl_lock);
 	current->last_siginfo = NULL;
 
 	/* LISTENING can be set only during STOP traps, clear it */
@@ -2002,7 +2051,7 @@ void ptrace_notify(int exit_code)
  * must ensure that INTERRUPT trap handling takes places afterwards.
  *
  * CONTEXT:
- * Must be called with @current->sighand->siglock held, which may be
+ * Must be called with @current->signal->ctrl_lock held, which may be
  * released and re-acquired before returning with intervening sleep.
  *
  * RETURNS:
@@ -2010,8 +2059,8 @@ void ptrace_notify(int exit_code)
  * %true if participated in group stop.
  */
 static bool do_signal_stop(int signr)
-	__releases(&current->sighand->siglock)
-	__acquires(&current->sighand->siglock)
+	__releases(&current->signal->ctrl_lock)
+	__acquires(&current->signal->ctrl_lock)
 {
 	struct signal_struct *sig = current->signal;
 
@@ -2084,7 +2133,7 @@ static bool do_signal_stop(int signr)
 			notify = CLD_STOPPED;
 
 		__set_current_state(TASK_STOPPED);
-		spin_unlock_irq(&current->sighand->siglock);
+		spin_unlock_irq(&sig->ctrl_lock);
 
 		/*
 		 * Notify the parent of the group stop completion.  Because
@@ -2104,7 +2153,7 @@ static bool do_signal_stop(int signr)
 		/* Now we don't run again until woken by SIGCONT or SIGKILL */
 		schedule();
 
-		spin_lock_irq(&current->sighand->siglock);
+		spin_lock_irq(&sig->ctrl_lock);
 		return true;
 	} else {
 		/*
@@ -2128,7 +2177,7 @@ static bool do_signal_stop(int signr)
  * number as exit_code and no siginfo.
  *
  * CONTEXT:
- * Must be called with @current->sighand->siglock held, which may be
+ * Must be called with @current->signal->ctrl_lock held, which may be
  * released and re-acquired before returning with intervening sleep.
  */
 static void do_jobctl_trap(void)
@@ -2153,6 +2202,8 @@ static void do_jobctl_trap(void)
 static int ptrace_signal(int signr, siginfo_t *info,
 			 struct pt_regs *regs, void *cookie)
 {
+	assert_spin_locked(&current->signal->ctrl_lock);
+
 	ptrace_signal_deliver(regs, cookie);
 	/*
 	 * We do not check sig_kernel_stop(signr) but set this marker
@@ -2189,9 +2240,11 @@ static int ptrace_signal(int signr, siginfo_t *info,
 
 	/* If the (new) signal is now blocked, requeue it.  */
 	if (sigismember(&current->blocked, signr)) {
+		spin_unlock_irq(&current->signal->ctrl_lock);
 		read_lock(&current->sighand->action_lock);
 		specific_send_sig_info(signr, info, current);
 		read_unlock(&current->sighand->action_lock);
+		spin_lock_irq(&current->signal->ctrl_lock);
 		signr = 0;
 	}
 
@@ -2254,11 +2307,10 @@ static void unlock_action(struct sighand_struct *sighand, bool write_locked)
  */
 static inline bool __notify_parent(struct task_struct *task)
 {
-	struct sighand_struct *sighand = task->sighand;
 	struct signal_struct *signal = task->signal;
 	int why;
 
-	spin_lock_irq(&sighand->siglock);
+	spin_lock_irq(&signal->ctrl_lock);
 
 	if (signal->flags & SIGNAL_CLD_MASK) {
 		if (signal->flags & SIGNAL_CLD_CONTINUED)
@@ -2268,7 +2320,7 @@ static inline bool __notify_parent(struct task_struct *task)
 
 		signal->flags &= ~SIGNAL_CLD_MASK;
 
-		spin_unlock_irq(&sighand->siglock);
+		spin_unlock_irq(&signal->ctrl_lock);
 
 		/*
 		 * Notify the parent that we're continuing.  This event is
@@ -2289,7 +2341,7 @@ static inline bool __notify_parent(struct task_struct *task)
 		return true;
 	}
 
-	spin_unlock_irq(&sighand->siglock);
+	spin_unlock_irq(&signal->ctrl_lock);
 	return false;
 }
 
@@ -2324,23 +2376,23 @@ freeze:
 		if (unlikely(current->jobctl & JOBCTL_STOP_PENDING)) {
 			bool stopped = false;
 
-			spin_lock_irq(&sighand->siglock);
+			spin_lock_irq(&signal->ctrl_lock);
 			if (current->jobctl & JOBCTL_STOP_PENDING)
 				stopped = do_signal_stop(0);
-			spin_unlock_irq(&sighand->siglock);
+			spin_unlock_irq(&signal->ctrl_lock);
 
 			if (stopped)
 				goto freeze;
 		}
 
 		if (unlikely(current->jobctl & JOBCTL_TRAP_MASK)) {
-			spin_lock_irq(&sighand->siglock);
+			spin_lock_irq(&signal->ctrl_lock);
 			if (current->jobctl & JOBCTL_TRAP_MASK) {
 				do_jobctl_trap();
-				spin_unlock_irq(&sighand->siglock);
+				spin_unlock_irq(&signal->ctrl_lock);
 				goto freeze;
 			}
-			spin_unlock_irq(&sighand->siglock);
+			spin_unlock_irq(&signal->ctrl_lock);
 		}
 
 		signr = dequeue_signal(current, &current->blocked, info);
@@ -2349,10 +2401,10 @@ freeze:
 			break; /* will return 0 */
 
 		if (unlikely(current->ptrace) && signr != SIGKILL) {
-			spin_lock_irq(&sighand->siglock);
+			spin_lock_irq(&signal->ctrl_lock);
 			signr = ptrace_signal(signr, info,
 					      regs, cookie);
-			spin_unlock_irq(&sighand->siglock);
+			spin_unlock_irq(&signal->ctrl_lock);
 			if (!signr)
 				continue;
 		}
@@ -2423,9 +2475,9 @@ freeze:
 					goto freeze;
 			}
 
-			spin_lock_irq(&sighand->siglock);
+			spin_lock_irq(&signal->ctrl_lock);
 			stopped = do_signal_stop(info->si_signo);
-			spin_unlock_irq(&sighand->siglock);
+			spin_unlock_irq(&signal->ctrl_lock);
 
 			if (likely(stopped))
 				goto freeze;
@@ -2538,6 +2590,7 @@ void exit_signals(struct task_struct *tsk)
 	if (!signal_pending(tsk))
 		goto out;
 
+	spin_lock(&tsk->signal->ctrl_lock);
 	unblocked = tsk->blocked;
 	signotset(&unblocked);
 	retarget_shared_pending(tsk, &unblocked);
@@ -2545,6 +2598,7 @@ void exit_signals(struct task_struct *tsk)
 	if (unlikely(tsk->jobctl & JOBCTL_STOP_PENDING) &&
 	    task_participate_group_stop(tsk))
 		group_stop = CLD_STOPPED;
+	spin_unlock(&tsk->signal->ctrl_lock);
 out:
 	spin_unlock_irq(&tsk->sighand->siglock);
 
@@ -2612,7 +2666,9 @@ void set_current_blocked(const sigset_t *newset)
 	struct task_struct *tsk = current;
 
 	spin_lock_irq(&tsk->sighand->siglock);
+	spin_lock(&tsk->signal->ctrl_lock);
 	__set_task_blocked(tsk, newset);
+	spin_unlock(&tsk->signal->ctrl_lock);
 	spin_unlock_irq(&tsk->sighand->siglock);
 }
 EXPORT_SYMBOL(set_current_blocked);
@@ -2847,8 +2903,10 @@ int do_sigtimedwait(const sigset_t *which, siginfo_t *info,
 		timeout = schedule_timeout_interruptible(timeout);
 
 		spin_lock_irq(&tsk->sighand->siglock);
+		spin_lock(&tsk->signal->ctrl_lock);
 		__set_task_blocked(tsk, &tsk->real_blocked);
 		siginitset(&tsk->real_blocked, 0);
+		spin_unlock(&tsk->signal->ctrl_lock);
 		spin_unlock_irq(&tsk->sighand->siglock);
 		sig = dequeue_signal(tsk, &mask, info);
 	}
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 574956c..47f278f 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2272,6 +2272,7 @@ static void selinux_bprm_committed_creds(struct linux_binprm *bprm)
 		for (i = 0; i < 3; i++)
 			do_setitimer(i, &itimer, NULL);
 		spin_lock_irq(&current->sighand->siglock);
+		spin_lock(&current->signal->ctrl_lock);
 		if (!(current->signal->flags & SIGNAL_GROUP_EXIT)) {
 			__flush_signals(current);
 			write_lock(&current->sighand->action_lock);
@@ -2279,6 +2280,7 @@ static void selinux_bprm_committed_creds(struct linux_binprm *bprm)
 			write_unlock(&current->sighand->action_lock);
 			sigemptyset(&current->blocked);
 		}
+		spin_unlock(&current->signal->ctrl_lock);
 		spin_unlock_irq(&current->sighand->siglock);
 	}
 
-- 
1.7.4.4

