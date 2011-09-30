Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab1I3PNL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 11:13:11 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60229 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754817Ab1I3PNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 11:13:07 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Anirudh Badam <abadam@cs.princeton.edu>
Subject: [RFC][PATCH 2/5] signal: Add rwlock to protect sighand->action
Date: Fri, 30 Sep 2011 16:12:54 +0100
Message-Id: <1317395577-14091-3-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

In a future patch sighand->siglock will no longer serialise access to
sighand->action. Therefore, we need provide a new lock to protect it.

As sighand->action is read much more frequently than written a rwlock
makes the most sense here.

Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Anirudh Badam <abadam@cs.princeton.edu>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/ia64/kernel/signal.c |    4 +-
 fs/ncpfs/sock.c           |    2 +
 fs/proc/array.c           |    2 +
 include/linux/init_task.h |    1 +
 include/linux/sched.h     |    1 +
 kernel/exit.c             |    6 ++
 kernel/fork.c             |    1 +
 kernel/kmod.c             |    8 ++--
 kernel/ptrace.c           |    4 +-
 kernel/signal.c           |  117 ++++++++++++++++++++++++++++++++++++++++-----
 security/selinux/hooks.c  |    2 +
 11 files changed, 128 insertions(+), 20 deletions(-)

diff --git a/arch/ia64/kernel/signal.c b/arch/ia64/kernel/signal.c
index 7523501..c77c845 100644
--- a/arch/ia64/kernel/signal.c
+++ b/arch/ia64/kernel/signal.c
@@ -311,9 +311,9 @@ force_sigsegv_info (int sig, void __user *addr)
 		 * no longer safe to modify sa_handler without holding the
 		 * lock.
 		 */
-		spin_lock_irqsave(&current->sighand->siglock, flags);
+		write_lock_irqsave(&current->sighand->action_lock, flags);
 		current->sighand->action[sig - 1].sa.sa_handler = SIG_DFL;
-		spin_unlock_irqrestore(&current->sighand->siglock, flags);
+		write_unlock_irqrestore(&current->sighand->action_lock, flags);
 	}
 	si.si_signo = SIGSEGV;
 	si.si_errno = 0;
diff --git a/fs/ncpfs/sock.c b/fs/ncpfs/sock.c
index 850768a..3e69aec 100644
--- a/fs/ncpfs/sock.c
+++ b/fs/ncpfs/sock.c
@@ -763,10 +763,12 @@ static int ncp_do_request(struct ncp_server *server, int size,
 			   What if we've blocked it ourselves?  What about
 			   alarms?  Why, in fact, are we mucking with the
 			   sigmask at all? -- r~ */
+			read_lock(&current->sighand->action_lock);
 			if (current->sighand->action[SIGINT - 1].sa.sa_handler == SIG_DFL)
 				mask |= sigmask(SIGINT);
 			if (current->sighand->action[SIGQUIT - 1].sa.sa_handler == SIG_DFL)
 				mask |= sigmask(SIGQUIT);
+			read_unlock(&current->sighand->action_lock);
 		}
 		siginitsetinv(&blocked, mask);
 		set_current_blocked(&blocked);
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 3a1dafd..0322ac9 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -239,6 +239,7 @@ static void collect_sigign_sigcatch(struct task_struct *p, sigset_t *ign,
 	struct k_sigaction *k;
 	int i;
 
+	read_lock(&p->sighand->action_lock);
 	k = p->sighand->action;
 	for (i = 1; i <= _NSIG; ++i, ++k) {
 		if (k->sa.sa_handler == SIG_IGN)
@@ -246,6 +247,7 @@ static void collect_sigign_sigcatch(struct task_struct *p, sigset_t *ign,
 		else if (k->sa.sa_handler != SIG_DFL)
 			sigaddset(catch, i);
 	}
+	read_unlock(&p->sighand->action_lock);
 }
 
 static inline void task_sig(struct seq_file *m, struct task_struct *p)
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index d14e058..1a66552 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -56,6 +56,7 @@ extern struct nsproxy init_nsproxy;
 	.action		= { { { .sa_handler = SIG_DFL, } }, },		\
 	.siglock	= __SPIN_LOCK_UNLOCKED(sighand.siglock),	\
 	.signalfd_wqh	= __WAIT_QUEUE_HEAD_INITIALIZER(sighand.signalfd_wqh),	\
+	.action_lock	= __RW_LOCK_UNLOCKED(sighand.action_lock),	\
 }
 
 extern struct group_info init_groups;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index dcacb26..f067bbc 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -443,6 +443,7 @@ struct sighand_struct {
 	struct k_sigaction	action[_NSIG];
 	spinlock_t		siglock;
 	wait_queue_head_t	signalfd_wqh;
+	rwlock_t		action_lock;
 };
 
 struct pacct_struct {
diff --git a/kernel/exit.c b/kernel/exit.c
index 2913b35..a8a83ac 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -380,7 +380,10 @@ int allow_signal(int sig)
 	 * know it'll be handled, so that they don't get converted to
 	 * SIGKILL or just silently dropped.
 	 */
+	write_lock(&current->sighand->action_lock);
 	current->sighand->action[(sig)-1].sa.sa_handler = (void __user *)2;
+	write_unlock(&current->sighand->action_lock);
+
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 	return 0;
@@ -394,7 +397,10 @@ int disallow_signal(int sig)
 		return -EINVAL;
 
 	spin_lock_irq(&current->sighand->siglock);
+	write_lock(&current->sighand->action_lock);
 	current->sighand->action[(sig)-1].sa.sa_handler = SIG_IGN;
+	write_unlock(&current->sighand->action_lock);
+
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 	return 0;
diff --git a/kernel/fork.c b/kernel/fork.c
index 8104ace..8871ae8 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1588,6 +1588,7 @@ static void sighand_ctor(void *data)
 
 	spin_lock_init(&sighand->siglock);
 	init_waitqueue_head(&sighand->signalfd_wqh);
+	rwlock_init(&sighand->action_lock);
 }
 
 void __init proc_caches_init(void)
diff --git a/kernel/kmod.c b/kernel/kmod.c
index ddc7644..30be456 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -143,9 +143,9 @@ static int ____call_usermodehelper(void *data)
 	struct cred *new;
 	int retval;
 
-	spin_lock_irq(&current->sighand->siglock);
+	write_lock_irq(&current->sighand->action_lock);
 	flush_signal_handlers(current, 1);
-	spin_unlock_irq(&current->sighand->siglock);
+	write_unlock_irq(&current->sighand->action_lock);
 
 	/* We can run anywhere, unlike our parent keventd(). */
 	set_cpus_allowed_ptr(current, cpu_all_mask);
@@ -202,9 +202,9 @@ static int wait_for_helper(void *data)
 	pid_t pid;
 
 	/* If SIGCLD is ignored sys_wait4 won't populate the status. */
-	spin_lock_irq(&current->sighand->siglock);
+	write_lock_irq(&current->sighand->action_lock);
 	current->sighand->action[SIGCHLD-1].sa.sa_handler = SIG_DFL;
-	spin_unlock_irq(&current->sighand->siglock);
+	write_unlock_irq(&current->sighand->action_lock);
 
 	pid = kernel_thread(____call_usermodehelper, sub_info, SIGCHLD);
 	if (pid < 0) {
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 9de3ecf..eb46323 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -350,10 +350,10 @@ static int ptrace_traceme(void)
 static int ignoring_children(struct sighand_struct *sigh)
 {
 	int ret;
-	spin_lock(&sigh->siglock);
+	read_lock(&sigh->action_lock);
 	ret = (sigh->action[SIGCHLD-1].sa.sa_handler == SIG_IGN) ||
 	      (sigh->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT);
-	spin_unlock(&sigh->siglock);
+	read_unlock(&sigh->action_lock);
 	return ret;
 }
 
diff --git a/kernel/signal.c b/kernel/signal.c
index 54fc552..7f2de6d 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -38,7 +38,7 @@
 #include "audit.h"	/* audit_signal_info() */
 
 /*
- * signal locking rules:
+ * signal locking rules (and locking order):
  *
  *   - sighand->siglock (spinlock) protects,
  *
@@ -49,8 +49,6 @@
  *
  *        * most things under tsk->signal
  *
- *        * tsk->sighand->action[]
- *
  *        * tsk->last_siginfo
  *        * tsk->group_stop
  *        * tsk->pending
@@ -62,6 +60,12 @@
  *
  *        * tsk->cpu_timers
  *
+ *   - sighand->action_lock (rwlock) protects,
+ *
+ *        * sighand->action[]. Most callers only need to acquire action_lock
+ *          for reading, see lock_action() for when the write-lock is
+ *          necessary.
+ *
  */
 
 /*
@@ -72,6 +76,10 @@ static struct kmem_cache *sigqueue_cachep;
 
 int print_fatal_signals __read_mostly;
 
+/*
+ * Must be called with t->sighand->action_lock at least held for
+ * reading.
+ */
 static void __user *sig_handler(struct task_struct *t, int sig)
 {
 	return t->sighand->action[sig - 1].sa.sa_handler;
@@ -485,6 +493,9 @@ void flush_itimer_signals(void)
 	spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
 }
 
+/*
+ * Must be called with t->sighand->action_lock held for writing.
+ */
 void ignore_signals(struct task_struct *t)
 {
 	int i;
@@ -497,8 +508,9 @@ void ignore_signals(struct task_struct *t)
 
 /*
  * Flush all handlers for a task.
+ *
+ * Must be called with t->sighand->action_lock write-locked.
  */
-
 void
 flush_signal_handlers(struct task_struct *t, int force_default)
 {
@@ -1186,10 +1198,23 @@ static int __init setup_print_fatal_signals(char *str)
 
 __setup("print-fatal-signals=", setup_print_fatal_signals);
 
+static int
+__group_send_sig_info_locked(int sig, struct siginfo *info,
+			     struct task_struct *p)
+{
+	return send_signal(sig, info, p, 1);
+}
+
 int
 __group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 {
-	return send_signal(sig, info, p, 1);
+	int ret;
+
+	read_lock(&p->sighand->action_lock);
+	ret = send_signal(sig, info, p, 1);
+	read_unlock(&p->sighand->action_lock);
+
+	return ret;
 }
 
 static int
@@ -1205,7 +1230,9 @@ int do_send_sig_info(int sig, struct siginfo *info, struct task_struct *p,
 	int ret = -ESRCH;
 
 	if (lock_task_sighand(p, &flags)) {
+		read_lock(&p->sighand->action_lock);
 		ret = send_signal(sig, info, p, group);
+		read_unlock(&p->sighand->action_lock);
 		unlock_task_sighand(p, &flags);
 	}
 
@@ -1231,6 +1258,7 @@ force_sig_info(int sig, struct siginfo *info, struct task_struct *t)
 	struct k_sigaction *action;
 
 	spin_lock_irqsave(&t->sighand->siglock, flags);
+	write_lock(&t->sighand->action_lock);
 	action = &t->sighand->action[sig-1];
 	ignored = action->sa.sa_handler == SIG_IGN;
 	blocked = sigismember(&t->blocked, sig);
@@ -1244,6 +1272,7 @@ force_sig_info(int sig, struct siginfo *info, struct task_struct *t)
 	if (action->sa.sa_handler == SIG_DFL)
 		t->signal->flags &= ~SIGNAL_UNKILLABLE;
 	ret = specific_send_sig_info(sig, info, t);
+	write_unlock(&t->sighand->action_lock);
 	spin_unlock_irqrestore(&t->sighand->siglock, flags);
 
 	return ret;
@@ -1402,7 +1431,9 @@ int kill_pid_info_as_uid(int sig, struct siginfo *info, struct pid *pid,
 
 	if (sig) {
 		if (lock_task_sighand(p, &flags)) {
+			read_lock(&p->sighand->action_lock);
 			ret = __send_signal(sig, info, p, 1, 0);
+			read_unlock(&p->sighand->action_lock);
 			unlock_task_sighand(p, &flags);
 		} else
 			ret = -ESRCH;
@@ -1497,9 +1528,9 @@ force_sigsegv(int sig, struct task_struct *p)
 {
 	if (sig == SIGSEGV) {
 		unsigned long flags;
-		spin_lock_irqsave(&p->sighand->siglock, flags);
+		write_lock_irqsave(&p->sighand->action_lock, flags);
 		p->sighand->action[sig - 1].sa.sa_handler = SIG_DFL;
-		spin_unlock_irqrestore(&p->sighand->siglock, flags);
+		write_unlock_irqrestore(&p->sighand->action_lock, flags);
 	}
 	force_sig(SIGSEGV, p);
 	return 0;
@@ -1665,6 +1696,7 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 
 	psig = tsk->parent->sighand;
 	spin_lock_irqsave(&psig->siglock, flags);
+	read_lock(&psig->action_lock);
 	if (!tsk->ptrace && sig == SIGCHLD &&
 	    (psig->action[SIGCHLD-1].sa.sa_handler == SIG_IGN ||
 	     (psig->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT))) {
@@ -1688,8 +1720,9 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 			sig = 0;
 	}
 	if (valid_signal(sig) && sig)
-		__group_send_sig_info(sig, &info, tsk->parent);
+		__group_send_sig_info_locked(sig, &info, tsk->parent);
 	__wake_up_parent(tsk, tsk->parent);
+	read_unlock(&psig->action_lock);
 	spin_unlock_irqrestore(&psig->siglock, flags);
 
 	return autoreap;
@@ -1753,13 +1786,15 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
 
 	sighand = parent->sighand;
 	spin_lock_irqsave(&sighand->siglock, flags);
+	read_lock(&sighand->action_lock);
 	if (sighand->action[SIGCHLD-1].sa.sa_handler != SIG_IGN &&
 	    !(sighand->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDSTOP))
-		__group_send_sig_info(SIGCHLD, &info, parent);
+		__group_send_sig_info_locked(SIGCHLD, &info, parent);
 	/*
 	 * Even if SIGCHLD is not generated, we must wake up wait4 calls.
 	 */
 	__wake_up_parent(tsk, parent);
+	read_unlock(&sighand->action_lock);
 	spin_unlock_irqrestore(&sighand->siglock, flags);
 }
 
@@ -2154,13 +2189,58 @@ static int ptrace_signal(int signr, siginfo_t *info,
 
 	/* If the (new) signal is now blocked, requeue it.  */
 	if (sigismember(&current->blocked, signr)) {
+		read_lock(&current->sighand->action_lock);
 		specific_send_sig_info(signr, info, current);
+		read_unlock(&current->sighand->action_lock);
 		signr = 0;
 	}
 
 	return signr;
 }
 
+/**
+ * lock_action - acquire @sighand->action_lock for read/write
+ * @sighand: the signal handler struct to protect
+ * @signr: the signal being delivered
+ *
+ * If the caller needs to modify @sighand->action[] then we need to acquire
+ * @sighand->action_lock for writing, which only happens when %SA_ONESHOT is
+ * set in sa.sa_flags. Otherwise we can just acquire the read lock to prevent
+ * writers changing things under our feet.
+ *
+ * RETURNS:
+ * %false if @sighand->action_lock is read-locked
+ * %true if @sighand->action_lock is write-locked
+ */
+static bool lock_action(struct sighand_struct *sighand, int signr)
+{
+	struct k_sigaction *ka;
+
+	read_lock(&sighand->action_lock);
+	ka = &sighand->action[signr-1];
+
+	/*
+	 * Take the read lock in the hope that we don't need to modify the
+	 * action, but if we do need to update the action we must take the
+	 * write lock to prevent readers from reading a stale signal handler.
+	 */
+	if (ka->sa.sa_flags & SA_ONESHOT) {
+		read_unlock(&sighand->action_lock);
+		write_lock(&sighand->action_lock);
+		return true;
+	}
+
+	return false;
+}
+
+static void unlock_action(struct sighand_struct *sighand, bool write_locked)
+{
+	if (write_locked)
+		write_unlock(&sighand->action_lock);
+	else
+		read_unlock(&sighand->action_lock);
+}
+
 int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
 			  struct pt_regs *regs, void *cookie)
 {
@@ -2216,6 +2296,7 @@ relock:
 
 	for (;;) {
 		struct k_sigaction *ka;
+		bool write_locked;
 
 		if (unlikely(current->jobctl & JOBCTL_STOP_PENDING) &&
 		    do_signal_stop(0))
@@ -2239,13 +2320,17 @@ relock:
 				continue;
 		}
 
+		write_locked = lock_action(sighand, signr);
 		ka = &sighand->action[signr-1];
 
 		/* Trace actually delivered signals. */
 		trace_signal_deliver(signr, info, ka);
 
-		if (ka->sa.sa_handler == SIG_IGN) /* Do nothing.  */
+		if (ka->sa.sa_handler == SIG_IGN) { /* Do nothing.  */
+			unlock_action(sighand, write_locked);
 			continue;
+		}
+
 		if (ka->sa.sa_handler != SIG_DFL) {
 			/* Run the handler.  */
 			*return_ka = *ka;
@@ -2253,14 +2338,19 @@ relock:
 			if (ka->sa.sa_flags & SA_ONESHOT)
 				ka->sa.sa_handler = SIG_DFL;
 
+			unlock_action(sighand, write_locked);
 			break; /* will return non-zero "signr" value */
 		}
 
 		/*
 		 * Now we are doing the default action for this signal.
 		 */
-		if (sig_kernel_ignore(signr)) /* Default is nothing. */
+		if (sig_kernel_ignore(signr)) { /* Default is nothing. */
+			unlock_action(sighand, write_locked);
 			continue;
+		}
+
+		unlock_action(sighand, write_locked);
 
 		/*
 		 * Global init gets no signals it doesn't want.
@@ -2935,9 +3025,11 @@ int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
 	if (!valid_signal(sig) || sig < 1 || (act && sig_kernel_only(sig)))
 		return -EINVAL;
 
+	spin_lock_irq(&current->sighand->siglock);
+	read_lock(&current->sighand->action_lock);
+
 	k = &t->sighand->action[sig-1];
 
-	spin_lock_irq(&current->sighand->siglock);
 	if (oact)
 		*oact = *k;
 
@@ -2967,6 +3059,7 @@ int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
 		}
 	}
 
+	read_unlock(&current->sighand->action_lock);
 	spin_unlock_irq(&current->sighand->siglock);
 	return 0;
 }
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 266a229..574956c 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2274,7 +2274,9 @@ static void selinux_bprm_committed_creds(struct linux_binprm *bprm)
 		spin_lock_irq(&current->sighand->siglock);
 		if (!(current->signal->flags & SIGNAL_GROUP_EXIT)) {
 			__flush_signals(current);
+			write_lock(&current->sighand->action_lock);
 			flush_signal_handlers(current, 1);
+			write_unlock(&current->sighand->action_lock);
 			sigemptyset(&current->blocked);
 		}
 		spin_unlock_irq(&current->sighand->siglock);
-- 
1.7.4.4

