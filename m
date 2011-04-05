Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab1DETWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 15:22:22 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:34078 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754095Ab1DETV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 15:21:58 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: [RFC][PATCH 5/5] signals: Don't hold shared siglock across signal delivery
Date: Tue,  5 Apr 2011 20:21:50 +0100
Message-Id: <1302031310-1765-6-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1302031310-1765-1-git-send-email-matt@console-pimps.org>
References: <1302031310-1765-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@linux.intel.com>

To reduce the contention on the shared siglock this patch pushes the
responsibility of acquiring and releasing the shared siglock down into
the functions that need it. That way, if we don't call a function that
needs to be run under the shared siglock, we can run without acquiring
it at all.

Note that this does not make signal delivery lockless. A signal must
still be dequeued from either the shared or private signal
queues. However, in the private signal case we can now get by with
just acquiring the per-thread siglock which massively reduces
contention on the shared siglock.

Also update tracehook.h to indicate it's not called with siglock held
anymore.

With this commit signal delivery now scales much better (though not
linearly with the number of threads) as can be seen in these two
graphs which execute the signal1 testcase from the Will It Scale
benchmark suite,

http://userweb.kernel.org/~mfleming/will-it-scale/signals-per-thread-siglock/

Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
---
 fs/signalfd.c             |    5 --
 include/linux/tracehook.h |    3 +-
 kernel/compat.c           |    7 ++-
 kernel/signal.c           |  124 +++++++++++++++++++++++++++------------------
 4 files changed, 79 insertions(+), 60 deletions(-)

diff --git a/fs/signalfd.c b/fs/signalfd.c
index ed49c40..a9d5c6f 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -146,7 +146,6 @@ static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, siginfo_t *info,
 	ssize_t ret;
 	DECLARE_WAITQUEUE(wait, current);
 
-	spin_lock_irq(&current->sighand->siglock);
 	ret = dequeue_signal(current, &ctx->sigmask, info);
 	switch (ret) {
 	case 0:
@@ -154,7 +153,6 @@ static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, siginfo_t *info,
 			break;
 		ret = -EAGAIN;
 	default:
-		spin_unlock_irq(&current->sighand->siglock);
 		return ret;
 	}
 
@@ -168,11 +166,8 @@ static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, siginfo_t *info,
 			ret = -ERESTARTSYS;
 			break;
 		}
-		spin_unlock_irq(&current->sighand->siglock);
 		schedule();
-		spin_lock_irq(&current->sighand->siglock);
 	}
-	spin_unlock_irq(&current->sighand->siglock);
 
 	remove_wait_queue(&current->sighand->signalfd_wqh, &wait);
 	__set_current_state(TASK_RUNNING);
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index b073f3c..849336d 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -447,7 +447,7 @@ static inline int tracehook_force_sigpending(void)
  * @return_ka:		sigaction for synthetic signal
  *
  * Return zero to check for a real pending signal normally.
- * Return -1 after releasing the siglock to repeat the check.
+ * Return -1 to repeat the check.
  * Return a signal number to induce an artifical signal delivery,
  * setting *@info and *@return_ka to specify its details and behavior.
  *
@@ -458,7 +458,6 @@ static inline int tracehook_force_sigpending(void)
  * %SIGTSTP for stop unless in an orphaned pgrp), but the signal number
  * reported will be @info->si_signo instead.
  *
- * Called with @task->sighand->siglock held, before dequeuing pending signals.
  */
 static inline int tracehook_get_signal(struct task_struct *task,
 				       struct pt_regs *regs,
diff --git a/kernel/compat.c b/kernel/compat.c
index 38b1d2c..c7c5f9f 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -912,7 +912,6 @@ compat_sys_rt_sigtimedwait (compat_sigset_t __user *uthese,
 			return -EINVAL;
 	}
 
-	spin_lock_irq(&current->sighand->siglock);
 	sig = dequeue_signal(current, &s, &info);
 	if (!sig) {
 		timeout = MAX_SCHEDULE_TIMEOUT;
@@ -920,6 +919,7 @@ compat_sys_rt_sigtimedwait (compat_sigset_t __user *uthese,
 			timeout = timespec_to_jiffies(&t)
 				+(t.tv_sec || t.tv_nsec);
 		if (timeout) {
+			spin_lock_irq(&current->sighand->siglock);
 			current->real_blocked = current->blocked;
 			sigandsets(&current->blocked, &current->blocked, &s);
 
@@ -928,14 +928,15 @@ compat_sys_rt_sigtimedwait (compat_sigset_t __user *uthese,
 
 			timeout = schedule_timeout_interruptible(timeout);
 
-			spin_lock_irq(&current->sighand->siglock);
 			sig = dequeue_signal(current, &s, &info);
+
+			spin_lock_irq(&current->sighand->siglock);
 			current->blocked = current->real_blocked;
 			siginitset(&current->real_blocked, 0);
 			recalc_sigpending();
+			spin_unlock_irq(&current->sighand->siglock);
 		}
 	}
-	spin_unlock_irq(&current->sighand->siglock);
 
 	if (sig) {
 		ret = sig;
diff --git a/kernel/signal.c b/kernel/signal.c
index db0ce0e..d31a97a 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -595,8 +595,7 @@ static int __dequeue_shared_signal(struct task_struct *tsk,
 {
 	int signr;
 
-	assert_spin_locked(&tsk->sighand->siglock);
-
+	spin_lock_irq(&tsk->sighand->siglock);
 	signr = __dequeue_signal(&tsk->signal->shared_pending,
 				 mask, info);
 	/*
@@ -639,6 +638,7 @@ static int __dequeue_shared_signal(struct task_struct *tsk,
 		current->group_stop |= GROUP_STOP_DEQUEUED;
 	}
 
+	spin_unlock_irq(&tsk->sighand->siglock);
 	return signr;
 }
 
@@ -657,12 +657,10 @@ static int __dequeue_private_signal(struct task_struct *tsk,
 /*
  * Dequeue a signal and return the element to the caller, which is 
  * expected to free it.
- *
- * All callers have to hold the siglock.
  */
 int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 {
-	int signr;
+	int signr = 0;
 
 	/*
 	 * Dequeue shared signals first since this is where SIGSTOP
@@ -672,7 +670,8 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 	 * the shared queue, e.g. we'd starve shared signals from
 	 * being serviced.
 	 */
-	signr = __dequeue_shared_signal(tsk, mask, info);
+	if (PENDING(&tsk->signal->shared_pending, &tsk->blocked))
+		signr = __dequeue_shared_signal(tsk, mask, info);
 
 	/* We only dequeue private signals from ourselves, we don't let
 	 * signalfd steal them
@@ -684,17 +683,9 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 	if (!signr)
 		return 0;
 
-	if ((info->si_code & __SI_MASK) == __SI_TIMER && info->si_sys_private) {
-		/*
-		 * Release the siglock to ensure proper locking order
-		 * of timer locks outside of siglocks.  Note, we leave
-		 * irqs disabled here, since the posix-timers code is
-		 * about to disable them again anyway.
-		 */
-		spin_unlock(&tsk->sighand->siglock);
+	if ((info->si_code & __SI_MASK) == __SI_TIMER && info->si_sys_private)
 		do_schedule_next_timer(info);
-		spin_lock(&tsk->sighand->siglock);
-	}
+
 	return signr;
 }
 
@@ -2119,6 +2110,7 @@ static int ptrace_signal(int signr, siginfo_t *info,
 	if (!task_ptrace(current))
 		return signr;
 
+	spin_lock_irq(&current->sighand->siglock);
 	ptrace_signal_deliver(regs, cookie);
 
 	/* Let the debugger run.  */
@@ -2127,7 +2119,7 @@ static int ptrace_signal(int signr, siginfo_t *info,
 	/* We're back.  Did the debugger cancel the sig?  */
 	signr = current->exit_code;
 	if (signr == 0)
-		return signr;
+		goto out;
 
 	current->exit_code = 0;
 
@@ -2161,35 +2153,36 @@ static int ptrace_signal(int signr, siginfo_t *info,
 		signr = 0;
 	}
 
+out:
+	spin_unlock_irq(&current->sighand->siglock);
 	return signr;
 }
 
-int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
-			  struct pt_regs *regs, void *cookie)
+static inline int __do_signal_stop(struct sighand_struct *sighand)
 {
-	struct sighand_struct *sighand = current->sighand;
-	struct signal_struct *signal = current->signal;
-	int signr;
+	int stopped = 0;
+	spin_lock_irq(&sighand->siglock);
+	if (current->group_stop & GROUP_STOP_PENDING)
+		stopped = do_signal_stop(0);
 
-relock:
-	/*
-	 * We'll jump back here after any time we were stopped in TASK_STOPPED.
-	 * While in TASK_STOPPED, we were considered "frozen enough".
-	 * Now that we woke up, it's crucial if we're supposed to be
-	 * frozen that we freeze now before running anything substantial.
-	 */
-	try_to_freeze();
+	if (!stopped)
+		spin_unlock_irq(&sighand->siglock);
+
+	return stopped;
+}
+
+static inline int __do_notify_parent(struct signal_struct *signal,
+				     struct sighand_struct *sighand)
+{
+	struct task_struct *leader;
+	int notified = 0;
+	int why;
 
-	spin_lock_irq(&sighand->siglock);
 	/*
-	 * Every stopped thread goes here after wakeup. Check to see if
-	 * we should notify the parent, prepare_signal(SIGCONT) encodes
-	 * the CLD_ si_code into SIGNAL_CLD_MASK bits.
+	 * We could have raced with another writer.
 	 */
-	if (unlikely(signal->flags & SIGNAL_CLD_MASK)) {
-		struct task_struct *leader;
-		int why;
-
+	spin_lock_irq(&sighand->siglock);
+	if (signal->flags & SIGNAL_CLD_MASK) {
 		if (signal->flags & SIGNAL_CLD_CONTINUED)
 			why = CLD_CONTINUED;
 		else
@@ -2216,8 +2209,39 @@ relock:
 			do_notify_parent_cldstop(leader, true, why);
 
 		read_unlock(&tasklist_lock);
+		notified = 1;
+	} else {
+		spin_unlock_irq(&sighand->siglock);
+		notified = 0;
+	}
+
+	return notified;
+}
+
+int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
+			  struct pt_regs *regs, void *cookie)
+{
+	struct sighand_struct *sighand = current->sighand;
+	struct signal_struct *signal = current->signal;
+	int signr;
+
+relock:
+	/*
+	 * We'll jump back here after any time we were stopped in TASK_STOPPED.
+	 * While in TASK_STOPPED, we were considered "frozen enough".
+	 * Now that we woke up, it's crucial if we're supposed to be
+	 * frozen that we freeze now before running anything substantial.
+	 */
+	try_to_freeze();
 
-		goto relock;
+	/*
+	 * Every stopped thread goes here after wakeup. Check to see if
+	 * we should notify the parent, prepare_signal(SIGCONT) encodes
+	 * the CLD_ si_code into SIGNAL_CLD_MASK bits.
+	 */
+	if (unlikely(signal->flags & SIGNAL_CLD_MASK)) {
+		if (__do_notify_parent(signal, sighand))
+			goto relock;
 	}
 
 	for (;;) {
@@ -2234,8 +2258,13 @@ relock:
 			ka = return_ka;
 		else {
 			if (unlikely(current->group_stop &
-				     GROUP_STOP_PENDING) && do_signal_stop(0))
-				goto relock;
+				     GROUP_STOP_PENDING)) {
+				int stopped;
+
+				stopped = __do_signal_stop(sighand);
+				if (stopped)
+					goto relock;
+			}
 
 			signr = dequeue_signal(current, &current->blocked,
 					       info);
@@ -2302,20 +2331,18 @@ relock:
 			 * We need to check for that and bail out if necessary.
 			 */
 			if (signr != SIGSTOP) {
-				spin_unlock_irq(&sighand->siglock);
-
 				/* signals can be posted during this window */
-
 				if (is_current_pgrp_orphaned())
 					goto relock;
 
-				spin_lock_irq(&sighand->siglock);
 			}
 
+			spin_lock_irq(&sighand->siglock);
 			if (likely(do_signal_stop(info->si_signo))) {
 				/* It released the siglock.  */
 				goto relock;
 			}
+			spin_unlock_irq(&sighand->siglock);
 
 			/*
 			 * We didn't actually stop, due to a race
@@ -2324,8 +2351,6 @@ relock:
 			continue;
 		}
 
-		spin_unlock_irq(&sighand->siglock);
-
 		/*
 		 * Anything else is fatal, maybe with a core dump.
 		 */
@@ -2351,7 +2376,6 @@ relock:
 		do_group_exit(info->si_signo);
 		/* NOTREACHED */
 	}
-	spin_unlock_irq(&sighand->siglock);
 	return signr;
 }
 
@@ -2640,7 +2664,6 @@ SYSCALL_DEFINE4(rt_sigtimedwait, const sigset_t __user *, uthese,
 			return -EINVAL;
 	}
 
-	spin_lock_irq(&current->sighand->siglock);
 	sig = dequeue_signal(current, &these, &info);
 	if (!sig) {
 		timeout = MAX_SCHEDULE_TIMEOUT;
@@ -2652,6 +2675,7 @@ SYSCALL_DEFINE4(rt_sigtimedwait, const sigset_t __user *, uthese,
 			/* None ready -- temporarily unblock those we're
 			 * interested while we are sleeping in so that we'll
 			 * be awakened when they arrive.  */
+			spin_lock_irq(&current->sighand->siglock);
 			current->real_blocked = current->blocked;
 			sigandsets(&current->blocked, &current->blocked, &these);
 			recalc_sigpending();
@@ -2664,9 +2688,9 @@ SYSCALL_DEFINE4(rt_sigtimedwait, const sigset_t __user *, uthese,
 			current->blocked = current->real_blocked;
 			siginitset(&current->real_blocked, 0);
 			recalc_sigpending();
+			spin_unlock_irq(&current->sighand->siglock);
 		}
 	}
-	spin_unlock_irq(&current->sighand->siglock);
 
 	if (sig) {
 		ret = sig;
-- 
1.7.4

