Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab1I3POI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 11:14:08 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60236 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752330Ab1I3PNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 11:13:09 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Anirudh Badam <abadam@cs.princeton.edu>
Subject: [RFC][PATCH 3/5] signal: Reduce sighand->siglock hold time in get_signal_to_deliver()
Date: Fri, 30 Sep 2011 16:12:55 +0100
Message-Id: <1317395577-14091-4-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

We don't need to hold sighand->siglock across large chunks of code in
the signal delivery path. Instead we can just acquire the lock when
we're modifying a data structure that is protected by it. In other
words, we're pushing all the locking down into the functions that need
it, which allows us to get rid of dequeue_signal_lock() and stop
playing asymmetric locking games, e.g. in do_signal_stop() where we
may or may not return with the siglock held.

This patch greatly reduces the contention on the per-process siglock.

Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Anirudh Badam <abadam@cs.princeton.edu>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 drivers/block/nbd.c                 |    2 +-
 drivers/usb/gadget/f_mass_storage.c |    2 +-
 drivers/usb/gadget/file_storage.c   |    2 +-
 fs/jffs2/background.c               |    2 +-
 fs/signalfd.c                       |    5 -
 include/linux/sched.h               |   12 ---
 kernel/signal.c                     |  157 +++++++++++++++++++++--------------
 7 files changed, 100 insertions(+), 82 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index f533f33..06aa43e 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -199,7 +199,7 @@ static int sock_xmit(struct nbd_device *lo, int send, void *buf, int size,
 			siginfo_t info;
 			printk(KERN_WARNING "nbd (pid %d: %s) got signal %d\n",
 				task_pid_nr(current), current->comm,
-				dequeue_signal_lock(current, &current->blocked, &info));
+				dequeue_signal(current, &current->blocked, &info));
 			result = -EINTR;
 			sock_shutdown(lo, !send);
 			break;
diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 5b93395..8688de2 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2463,7 +2463,7 @@ static void handle_exception(struct fsg_common *common)
 	 */
 	for (;;) {
 		int sig =
-			dequeue_signal_lock(current, &current->blocked, &info);
+			dequeue_signal(current, &current->blocked, &info);
 		if (!sig)
 			break;
 		if (sig != SIGUSR1) {
diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index 639e14a..89206e5 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -2896,7 +2896,7 @@ static void handle_exception(struct fsg_dev *fsg)
 	/* Clear the existing signals.  Anything but SIGUSR1 is converted
 	 * into a high-priority EXIT exception. */
 	for (;;) {
-		sig = dequeue_signal_lock(current, &current->blocked, &info);
+		sig = dequeue_signal(current, &current->blocked, &info);
 		if (!sig)
 			break;
 		if (sig != SIGUSR1) {
diff --git a/fs/jffs2/background.c b/fs/jffs2/background.c
index 404111b..127f511 100644
--- a/fs/jffs2/background.c
+++ b/fs/jffs2/background.c
@@ -122,7 +122,7 @@ static int jffs2_garbage_collect_thread(void *_c)
 			if (try_to_freeze())
 				goto again;
 
-			signr = dequeue_signal_lock(current, &current->blocked, &info);
+			signr = dequeue_signal(current, &current->blocked, &info);
 
 			switch(signr) {
 			case SIGSTOP:
diff --git a/fs/signalfd.c b/fs/signalfd.c
index 492465b..728681d 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -144,7 +144,6 @@ static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, siginfo_t *info,
 	ssize_t ret;
 	DECLARE_WAITQUEUE(wait, current);
 
-	spin_lock_irq(&current->sighand->siglock);
 	ret = dequeue_signal(current, &ctx->sigmask, info);
 	switch (ret) {
 	case 0:
@@ -152,7 +151,6 @@ static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, siginfo_t *info,
 			break;
 		ret = -EAGAIN;
 	default:
-		spin_unlock_irq(&current->sighand->siglock);
 		return ret;
 	}
 
@@ -166,11 +164,8 @@ static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, siginfo_t *info,
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
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f067bbc..e4cd6bb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2145,18 +2145,6 @@ extern void ignore_signals(struct task_struct *);
 extern void flush_signal_handlers(struct task_struct *, int force_default);
 extern int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info);
 
-static inline int dequeue_signal_lock(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
-{
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(&tsk->sighand->siglock, flags);
-	ret = dequeue_signal(tsk, mask, info);
-	spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
-
-	return ret;
-}
-
 extern void block_all_signals(int (*notifier)(void *priv), void *priv,
 			      sigset_t *mask);
 extern void unblock_all_signals(void);
diff --git a/kernel/signal.c b/kernel/signal.c
index 7f2de6d..b69c5a9 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -632,13 +632,14 @@ static int __dequeue_signal(struct sigpending *pending, sigset_t *mask,
 /*
  * Dequeue a signal and return the element to the caller, which is
  * expected to free it.
- *
- * All callers have to hold the siglock.
  */
 int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 {
+	unsigned long flags;
 	int signr;
 
+	spin_lock_irqsave(&current->sighand->siglock, flags);
+
 	/* We only dequeue private signals from ourselves, we don't let
 	 * signalfd steal them
 	 */
@@ -672,8 +673,10 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 	}
 
 	recalc_sigpending();
-	if (!signr)
+	if (!signr) {
+		spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
 		return 0;
+	}
 
 	if (unlikely(sig_kernel_stop(signr))) {
 		/*
@@ -690,17 +693,12 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 		 */
 		current->jobctl |= JOBCTL_STOP_DEQUEUED;
 	}
-	if ((info->si_code & __SI_MASK) == __SI_TIMER && info->si_sys_private) {
-		/*
-		 * Release the siglock to ensure proper locking order
-		 * of timer locks outside of siglocks.  Note, we leave
-		 * irqs disabled here, since the posix-timers code is
-		 * about to disable them again anyway.
-		 */
-		spin_unlock(&tsk->sighand->siglock);
+
+	spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
+
+	if ((info->si_code & __SI_MASK) == __SI_TIMER && info->si_sys_private)
 		do_schedule_next_timer(info);
-		spin_lock(&tsk->sighand->siglock);
-	}
+
 	return signr;
 }
 
@@ -1997,16 +1995,15 @@ void ptrace_notify(int exit_code)
  * If %JOBCTL_STOP_PENDING is not set yet, initiate group stop with @signr
  * and participate in it.  If already set, participate in the existing
  * group stop.  If participated in a group stop (and thus slept), %true is
- * returned with siglock released.
+ * returned.
  *
  * If ptraced, this function doesn't handle stop itself.  Instead,
- * %JOBCTL_TRAP_STOP is scheduled and %false is returned with siglock
- * untouched.  The caller must ensure that INTERRUPT trap handling takes
- * places afterwards.
+ * %JOBCTL_TRAP_STOP is scheduled and %false is returned.  The caller
+ * must ensure that INTERRUPT trap handling takes places afterwards.
  *
  * CONTEXT:
- * Must be called with @current->sighand->siglock held, which is released
- * on %true return.
+ * Must be called with @current->sighand->siglock held, which may be
+ * released and re-acquired before returning with intervening sleep.
  *
  * RETURNS:
  * %false if group stop is already cancelled or ptrace trap is scheduled.
@@ -2014,6 +2011,7 @@ void ptrace_notify(int exit_code)
  */
 static bool do_signal_stop(int signr)
 	__releases(&current->sighand->siglock)
+	__acquires(&current->sighand->siglock)
 {
 	struct signal_struct *sig = current->signal;
 
@@ -2105,6 +2103,8 @@ static bool do_signal_stop(int signr)
 
 		/* Now we don't run again until woken by SIGCONT or SIGKILL */
 		schedule();
+
+		spin_lock_irq(&current->sighand->siglock);
 		return true;
 	} else {
 		/*
@@ -2241,31 +2241,26 @@ static void unlock_action(struct sighand_struct *sighand, bool write_locked)
 		read_unlock(&sighand->action_lock);
 }
 
-int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
-			  struct pt_regs *regs, void *cookie)
+/**
+ * __notify_parent - should we notify the parent of a stop/continue?
+ * @task: task that needs to notify parent
+ *
+ * Check to see if we should notify the parent, prepare_signal(SIGCONT)
+ * encodes the CLD_ si_code into %SIGNAL_CLD_MASK bits.
+ *
+ * RETURNS:
+ * %false if we didn't notify the parent
+ * %true if we did notify the parent
+ */
+static inline bool __notify_parent(struct task_struct *task)
 {
-	struct sighand_struct *sighand = current->sighand;
-	struct signal_struct *signal = current->signal;
-	int signr;
-
-relock:
-	/*
-	 * We'll jump back here after any time we were stopped in TASK_STOPPED.
-	 * While in TASK_STOPPED, we were considered "frozen enough".
-	 * Now that we woke up, it's crucial if we're supposed to be
-	 * frozen that we freeze now before running anything substantial.
-	 */
-	try_to_freeze();
+	struct sighand_struct *sighand = task->sighand;
+	struct signal_struct *signal = task->signal;
+	int why;
 
 	spin_lock_irq(&sighand->siglock);
-	/*
-	 * Every stopped thread goes here after wakeup. Check to see if
-	 * we should notify the parent, prepare_signal(SIGCONT) encodes
-	 * the CLD_ si_code into SIGNAL_CLD_MASK bits.
-	 */
-	if (unlikely(signal->flags & SIGNAL_CLD_MASK)) {
-		int why;
 
+	if (signal->flags & SIGNAL_CLD_MASK) {
 		if (signal->flags & SIGNAL_CLD_CONTINUED)
 			why = CLD_CONTINUED;
 		else
@@ -2288,24 +2283,64 @@ relock:
 
 		if (ptrace_reparented(current->group_leader))
 			do_notify_parent_cldstop(current->group_leader,
-						true, why);
+						 true, why);
 		read_unlock(&tasklist_lock);
 
-		goto relock;
+		return true;
+	}
+
+	spin_unlock_irq(&sighand->siglock);
+	return false;
+}
+
+int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
+			  struct pt_regs *regs, void *cookie)
+{
+	struct sighand_struct *sighand = current->sighand;
+	struct signal_struct *signal = current->signal;
+	int signr;
+
+freeze:
+	/*
+	 * We'll jump back here after any time we were stopped in TASK_STOPPED.
+	 * While in TASK_STOPPED, we were considered "frozen enough".
+	 * Now that we woke up, it's crucial if we're supposed to be
+	 * frozen that we freeze now before running anything substantial.
+	 */
+	try_to_freeze();
+
+	/*
+	 * Every stopped thread goes here after wakeup.
+	 */
+	if (unlikely(signal->flags & SIGNAL_CLD_MASK)) {
+		if (__notify_parent(current))
+			goto freeze;
 	}
 
 	for (;;) {
 		struct k_sigaction *ka;
 		bool write_locked;
 
-		if (unlikely(current->jobctl & JOBCTL_STOP_PENDING) &&
-		    do_signal_stop(0))
-			goto relock;
+		if (unlikely(current->jobctl & JOBCTL_STOP_PENDING)) {
+			bool stopped = false;
+
+			spin_lock_irq(&sighand->siglock);
+			if (current->jobctl & JOBCTL_STOP_PENDING)
+				stopped = do_signal_stop(0);
+			spin_unlock_irq(&sighand->siglock);
+
+			if (stopped)
+				goto freeze;
+		}
 
 		if (unlikely(current->jobctl & JOBCTL_TRAP_MASK)) {
-			do_jobctl_trap();
+			spin_lock_irq(&sighand->siglock);
+			if (current->jobctl & JOBCTL_TRAP_MASK) {
+				do_jobctl_trap();
+				spin_unlock_irq(&sighand->siglock);
+				goto freeze;
+			}
 			spin_unlock_irq(&sighand->siglock);
-			goto relock;
 		}
 
 		signr = dequeue_signal(current, &current->blocked, info);
@@ -2314,8 +2349,10 @@ relock:
 			break; /* will return 0 */
 
 		if (unlikely(current->ptrace) && signr != SIGKILL) {
+			spin_lock_irq(&sighand->siglock);
 			signr = ptrace_signal(signr, info,
 					      regs, cookie);
+			spin_unlock_irq(&sighand->siglock);
 			if (!signr)
 				continue;
 		}
@@ -2367,6 +2404,8 @@ relock:
 			continue;
 
 		if (sig_kernel_stop(signr)) {
+			bool stopped;
+
 			/*
 			 * The default action is to stop all threads in
 			 * the thread group.  The job control signals
@@ -2378,20 +2417,18 @@ relock:
 			 * We need to check for that and bail out if necessary.
 			 */
 			if (signr != SIGSTOP) {
-				spin_unlock_irq(&sighand->siglock);
-
 				/* signals can be posted during this window */
 
 				if (is_current_pgrp_orphaned())
-					goto relock;
-
-				spin_lock_irq(&sighand->siglock);
+					goto freeze;
 			}
 
-			if (likely(do_signal_stop(info->si_signo))) {
-				/* It released the siglock.  */
-				goto relock;
-			}
+			spin_lock_irq(&sighand->siglock);
+			stopped = do_signal_stop(info->si_signo);
+			spin_unlock_irq(&sighand->siglock);
+
+			if (likely(stopped))
+				goto freeze;
 
 			/*
 			 * We didn't actually stop, due to a race
@@ -2400,8 +2437,6 @@ relock:
 			continue;
 		}
 
-		spin_unlock_irq(&sighand->siglock);
-
 		/*
 		 * Anything else is fatal, maybe with a core dump.
 		 */
@@ -2427,7 +2462,7 @@ relock:
 		do_group_exit(info->si_signo);
 		/* NOTREACHED */
 	}
-	spin_unlock_irq(&sighand->siglock);
+
 	return signr;
 }
 
@@ -2795,7 +2830,6 @@ int do_sigtimedwait(const sigset_t *which, siginfo_t *info,
 	sigdelsetmask(&mask, sigmask(SIGKILL) | sigmask(SIGSTOP));
 	signotset(&mask);
 
-	spin_lock_irq(&tsk->sighand->siglock);
 	sig = dequeue_signal(tsk, &mask, info);
 	if (!sig && timeout) {
 		/*
@@ -2804,6 +2838,7 @@ int do_sigtimedwait(const sigset_t *which, siginfo_t *info,
 		 * they arrive. Unblocking is always fine, we can avoid
 		 * set_current_blocked().
 		 */
+		spin_lock_irq(&tsk->sighand->siglock);
 		tsk->real_blocked = tsk->blocked;
 		sigandsets(&tsk->blocked, &tsk->blocked, &mask);
 		recalc_sigpending();
@@ -2814,9 +2849,9 @@ int do_sigtimedwait(const sigset_t *which, siginfo_t *info,
 		spin_lock_irq(&tsk->sighand->siglock);
 		__set_task_blocked(tsk, &tsk->real_blocked);
 		siginitset(&tsk->real_blocked, 0);
+		spin_unlock_irq(&tsk->sighand->siglock);
 		sig = dequeue_signal(tsk, &mask, info);
 	}
-	spin_unlock_irq(&tsk->sighand->siglock);
 
 	if (sig)
 		return sig;
-- 
1.7.4.4

