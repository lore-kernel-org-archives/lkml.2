Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab1DETW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 15:22:26 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:34071 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752972Ab1DETV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 15:21:58 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: [RFC][PATCH 2/5] signals: Introduce per-thread siglock and action rwlock
Date: Tue,  5 Apr 2011 20:21:47 +0100
Message-Id: <1302031310-1765-3-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1302031310-1765-1-git-send-email-matt@console-pimps.org>
References: <1302031310-1765-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@linux.intel.com>

Try to reduce the amount of time we hold the shared siglock by
introducing a per-thread siglock that protects each thread's 'pending'
queue. Currently, the shared siglock protects both the shared and
private signal queues. As such, it is a huge point of contention when
generating and delivering signals to single threads in a multithreaded
process. For example, even if a thread is delivering a signal to
itself (thereby putting a signal on its private signal queue) it must
acquire the shared siglock.

To improve signal generation scalability we only acquire the shared
siglock when generating a shared signal. If we're generating a private
signal which will be delivered to a specific thread (and that signal
does not affect an entire thread group) then we can optimise that case
by only taking the per-thread siglock. However, the case where we're
sending a fatal signal to a specific thread is special because we need
to modify tsk->signal->flags, so we need to be holding the shared
siglock.

Note that we now hold both the shared and per-thread siglock when
delivering a private signal. That will be fixed in the next patch so
that signal delivery scales with signal generation.

Also, because we now run signal code paths without holding the shared
siglock at all, it can no longer be used to protect tsk->sighand->action.
So we introduce a rwlock for protecting tsk->sighand->action. A rwlock
is better than a spinlock in this case because there are many more
readers than writers and a rwlock allows us to scale much better than
a spinlock.

Move the the majority of the shared signal code into a helper function
to make the code in dequeue_signal() easier to read.

Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
---
 fs/autofs4/waitq.c        |    2 +
 fs/exec.c                 |    2 +
 fs/signalfd.c             |    2 +
 include/linux/init_task.h |    2 +
 include/linux/sched.h     |    4 +
 include/linux/signal.h    |    5 +
 kernel/exit.c             |   12 ++-
 kernel/fork.c             |    2 +
 kernel/kmod.c             |    8 +-
 kernel/ptrace.c           |    4 +-
 kernel/signal.c           |  189 ++++++++++++++++++++++++++++++++++++++-------
 security/selinux/hooks.c  |    6 +-
 12 files changed, 199 insertions(+), 39 deletions(-)

diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index 5601005..a7adbf8 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -83,7 +83,9 @@ static int autofs4_write(struct file *file, const void *addr, int bytes)
 	   SIGPIPE unless it was already supposed to get one */
 	if (wr == -EPIPE && !sigpipe) {
 		spin_lock_irqsave(&current->sighand->siglock, flags);
+		spin_lock(&current->siglock);
 		sigdelset(&current->pending.signal, SIGPIPE);
+		spin_unlock(&current->siglock);
 		recalc_sigpending();
 		spin_unlock_irqrestore(&current->sighand->siglock, flags);
 	}
diff --git a/fs/exec.c b/fs/exec.c
index 8328beb..5cc4a6c 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1661,8 +1661,10 @@ static int zap_process(struct task_struct *start, int exit_code)
 	do {
 		task_clear_group_stop_pending(t);
 		if (t != current && t->mm) {
+			spin_lock(&t->siglock);
 			sigaddset(&t->pending.signal, SIGKILL);
 			signal_wake_up(t, 1);
+			spin_unlock(&t->siglock);
 			nr++;
 		}
 	} while_each_thread(start, t);
diff --git a/fs/signalfd.c b/fs/signalfd.c
index 492465b..ed49c40 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -48,10 +48,12 @@ static unsigned int signalfd_poll(struct file *file, poll_table *wait)
 	poll_wait(file, &current->sighand->signalfd_wqh, wait);
 
 	spin_lock_irq(&current->sighand->siglock);
+	spin_lock(&current->siglock);
 	if (next_signal(&current->pending, &ctx->sigmask) ||
 	    next_signal(&current->signal->shared_pending,
 			&ctx->sigmask))
 		events |= POLLIN;
+	spin_unlock(&current->siglock);
 	spin_unlock_irq(&current->sighand->siglock);
 
 	return events;
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index caa151f..a948d24 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -47,6 +47,7 @@ extern struct nsproxy init_nsproxy;
 	.action		= { { { .sa_handler = SIG_DFL, } }, },		\
 	.siglock	= __SPIN_LOCK_UNLOCKED(sighand.siglock),	\
 	.signalfd_wqh	= __WAIT_QUEUE_HEAD_INITIALIZER(sighand.signalfd_wqh),	\
+	.action_lock	= __RW_LOCK_UNLOCKED(sighand.action_lock),	\
 }
 
 extern struct group_info init_groups;
@@ -168,6 +169,7 @@ extern struct cred init_cred;
 	.signal		= &init_signals,				\
 	.sighand	= &init_sighand,				\
 	.nsproxy	= &init_nsproxy,				\
+	.siglock	= __SPIN_LOCK_UNLOCKED(tsk.siglock),		\
 	.pending	= {						\
 		.list = LIST_HEAD_INIT(tsk.pending.list),		\
 		.signal = {{0}}},					\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8cef82d..7b2ea86 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -443,6 +443,9 @@ struct sighand_struct {
 	struct k_sigaction	action[_NSIG];
 	spinlock_t		siglock;
 	wait_queue_head_t	signalfd_wqh;
+
+	/* protects action */
+	rwlock_t		action_lock;
 };
 
 struct pacct_struct {
@@ -1358,6 +1361,7 @@ struct task_struct {
 
 	sigset_t blocked, real_blocked;
 	sigset_t saved_sigmask;	/* restored if set_restore_sigmask() was used */
+	spinlock_t siglock;	/* protects pending */
 	struct sigpending pending;
 
 	unsigned long sas_ss_sp;
diff --git a/include/linux/signal.h b/include/linux/signal.h
index fcd2b14..9aad2b0 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -376,6 +376,11 @@ int unhandled_signal(struct task_struct *tsk, int sig);
 	(!siginmask(signr, SIG_KERNEL_IGNORE_MASK|SIG_KERNEL_STOP_MASK) && \
 	 (t)->sighand->action[(signr)-1].sa.sa_handler == SIG_DFL)
 
+/* Should the signal be placed on shared_pending? */
+#define sig_shared(sig)	\
+	(((sig) < SIGRTMIN) && \
+	 siginmask(sig, SIG_KERNEL_STOP_MASK | rt_sigmask(SIGCONT)))
+
 void signals_init(void);
 
 #endif /* __KERNEL__ */
diff --git a/kernel/exit.c b/kernel/exit.c
index 1a0f10f..7774126 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -142,7 +142,9 @@ static void __exit_signal(struct task_struct *tsk)
 	 * Do this under ->siglock, we can race with another thread
 	 * doing sigqueue_free() if we have SIGQUEUE_PREALLOC signals.
 	 */
+	spin_lock(&tsk->siglock);
 	flush_sigqueue(&tsk->pending);
+	spin_unlock(&tsk->siglock);
 	tsk->sighand = NULL;
 	spin_unlock(&sighand->siglock);
 
@@ -386,7 +388,8 @@ int allow_signal(int sig)
 	if (!valid_signal(sig) || sig < 1)
 		return -EINVAL;
 
-	spin_lock_irq(&current->sighand->siglock);
+	write_lock_irq(&current->sighand->action_lock);
+	spin_lock(&current->sighand->siglock);
 	/* This is only needed for daemonize()'ed kthreads */
 	sigdelset(&current->blocked, sig);
 	/*
@@ -396,7 +399,8 @@ int allow_signal(int sig)
 	 */
 	current->sighand->action[(sig)-1].sa.sa_handler = (void __user *)2;
 	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	spin_unlock(&current->sighand->siglock);
+	write_unlock_irq(&current->sighand->action_lock);
 	return 0;
 }
 
@@ -407,10 +411,10 @@ int disallow_signal(int sig)
 	if (!valid_signal(sig) || sig < 1)
 		return -EINVAL;
 
-	spin_lock_irq(&current->sighand->siglock);
+	write_lock_irq(&current->sighand->action_lock);
 	current->sighand->action[(sig)-1].sa.sa_handler = SIG_IGN;
 	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	write_unlock_irq(&current->sighand->action_lock);
 	return 0;
 }
 
diff --git a/kernel/fork.c b/kernel/fork.c
index f2b494d..50fa84f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1081,6 +1081,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->vfork_done = NULL;
 	spin_lock_init(&p->alloc_lock);
 
+	spin_lock_init(&p->siglock);
 	init_sigpending(&p->pending);
 
 	p->utime = cputime_zero;
@@ -1494,6 +1495,7 @@ static void sighand_ctor(void *data)
 
 	spin_lock_init(&sighand->siglock);
 	init_waitqueue_head(&sighand->signalfd_wqh);
+	rwlock_init(&sighand->action_lock);
 }
 
 void __init proc_caches_init(void)
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 9cd0591..551a6e9 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -134,9 +134,9 @@ static int ____call_usermodehelper(void *data)
 	struct subprocess_info *sub_info = data;
 	int retval;
 
-	spin_lock_irq(&current->sighand->siglock);
+	write_lock_irq(&current->sighand->action_lock);
 	flush_signal_handlers(current, 1);
-	spin_unlock_irq(&current->sighand->siglock);
+	write_unlock_irq(&current->sighand->action_lock);
 
 	/* We can run anywhere, unlike our parent keventd(). */
 	set_cpus_allowed_ptr(current, cpu_all_mask);
@@ -178,9 +178,9 @@ static int wait_for_helper(void *data)
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
index 20d5efd..c72d40d 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -294,10 +294,10 @@ static int ptrace_traceme(void)
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
index 9595d86..c67f27a 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -38,6 +38,45 @@
 #include "audit.h"	/* audit_signal_info() */
 
 /*
+ * Signal locking.
+ *
+ * There are three locks to consider when manipulating signal queues,
+ *
+ *	- tsk->sighand->action_lock	(sighand action rwlock)
+ *	- tsk->sighand->siglock		(shared siglock)
+ *	- tsk->siglock			(per-thread siglock)
+ *
+ * The sighand action rwlock needs to be acquired when modifying
+ * tsk->sighand->action or when you need to prevent modifications.
+ *
+ * When modifying the shared signal queue (signal->shared_pending),
+ * modifying tsk->blocked or handling stop signals (see
+ * do_signal_stop), you need to be holding the shared siglock.
+ *
+ * When modifying the per-thread pending signal queue (tsk->pending)
+ * you need to be holding the per-thread siglock.
+ *
+ * You MUST NOT acquire the shared siglock if already holding the
+ * per-thread siglock because various places iterate over the threads
+ * in a thread group and acquire their per-thread siglocks while
+ * holding the shared siglock - see zap_process().
+ *
+ * You MUST NOT acquire the sighand action lock if already holding the
+ * per-thread siglock.
+ *
+ * So the locking order is...
+ *
+ * tsk->sighand->action_lock
+ *   tsk->sighand->siglock
+ *     tsk->siglock
+ *
+ * OR..
+ *
+ * tsk->sighand->action_lock
+ *   tsk->siglock
+ */
+
+/*
  * SLAB caches for signal bits.
  */
 
@@ -367,7 +406,9 @@ void flush_sigqueue(struct sigpending *queue)
 void __flush_signals(struct task_struct *t)
 {
 	clear_tsk_thread_flag(t, TIF_SIGPENDING);
+	spin_lock(&t->siglock);
 	flush_sigqueue(&t->pending);
+	spin_unlock(&t->siglock);
 	flush_sigqueue(&t->signal->shared_pending);
 }
 
@@ -409,7 +450,9 @@ void flush_itimer_signals(void)
 	unsigned long flags;
 
 	spin_lock_irqsave(&tsk->sighand->siglock, flags);
+	spin_lock(&tsk->siglock);
 	__flush_itimer_signals(&tsk->pending);
+	spin_unlock(&tsk->siglock);
 	__flush_itimer_signals(&tsk->signal->shared_pending);
 	spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
 }
@@ -622,8 +665,11 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 	/* We only dequeue private signals from ourselves, we don't let
 	 * signalfd steal them
 	 */
-	if (!signr)
+	if (!signr) {
+		spin_lock(&tsk->siglock);
 		signr = __dequeue_signal(&tsk->pending, mask, info);
+		spin_unlock(&tsk->siglock);
+	}
 
 	recalc_sigpending();
 	if (!signr)
@@ -931,7 +977,9 @@ static void complete_signal(int sig, struct task_struct *p, int group)
 			t = p;
 			do {
 				task_clear_group_stop_pending(t);
+				spin_lock(&t->siglock);
 				sigaddset(&t->pending.signal, SIGKILL);
+				spin_unlock(&t->siglock);
 				signal_wake_up(t, 1);
 			} while_each_thread(p, t);
 			return;
@@ -960,8 +1008,6 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 
 	trace_signal_generate(sig, info, t);
 
-	assert_spin_locked(&t->sighand->siglock);
-
 	if (!prepare_signal(sig, t, from_ancestor_ns))
 		return 0;
 
@@ -976,7 +1022,12 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 	 * (and therefore avoid the locking that would be necessary to
 	 * do that safely).
 	 */
-	if (group || sig_kernel_stop(sig) || sig == SIGCONT)
+	if (group || sig_shared(sig) || sig_fatal(t, sig))
+		assert_spin_locked(&t->sighand->siglock);
+	else
+		assert_spin_locked(&t->siglock);
+
+	if (group || sig_shared(sig))
 		pending = &t->signal->shared_pending;
 	else
 		pending = &t->pending;
@@ -988,6 +1039,7 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 	 */
 	if (legacy_queue(pending, sig))
 		return 0;
+
 	/*
 	 * fast-pathed signals for kernel-internal things like SIGSTOP
 	 * or SIGKILL.
@@ -1123,11 +1175,34 @@ int do_send_sig_info(int sig, struct siginfo *info, struct task_struct *p,
 	unsigned long flags;
 	int ret = -ESRCH;
 
-	if (lock_task_sighand(p, &flags)) {
+	read_lock_irqsave(&p->sighand->action_lock, flags);
+
+	/*
+	 * We can optimize for the case where we're sending a signal
+	 * to a specific thread. If we're only sending a signal to one
+	 * thread we only need to acquire that thread's siglock and
+	 * not the global siglock.
+	 *
+	 * Fatal signals have the potential to tear down an entire
+	 * thread group, even if we're only sending the signal to a
+	 * specific thread! If we're killing an entire thread group we
+	 * need the shared siglock. Note that we can't check if the
+	 * signal is fatal until we're holding 'action_lock', because
+	 * someone could modify the handler for the signal (some
+	 * signals are only fatal when the handler is SIG_DFL).
+	 */
+	if (!group && !sig_shared(sig) && !sig_fatal(p, sig)) {
+		spin_lock(&p->siglock);
 		ret = send_signal(sig, info, p, group);
-		unlock_task_sighand(p, &flags);
+		spin_unlock(&p->siglock);
+	} else {
+		if (lock_task_sighand(p, &flags)) {
+			ret = send_signal(sig, info, p, group);
+			unlock_task_sighand(p, &flags);
+		}
 	}
 
+	read_unlock_irqrestore(&p->sighand->action_lock, flags);
 	return ret;
 }
 
@@ -1148,8 +1223,10 @@ force_sig_info(int sig, struct siginfo *info, struct task_struct *t)
 	unsigned long int flags;
 	int ret, blocked, ignored;
 	struct k_sigaction *action;
+	int shared_siglock;
 
-	spin_lock_irqsave(&t->sighand->siglock, flags);
+	write_lock_irqsave(&t->sighand->action_lock, flags);
+	spin_lock(&t->sighand->siglock);
 	action = &t->sighand->action[sig-1];
 	ignored = action->sa.sa_handler == SIG_IGN;
 	blocked = sigismember(&t->blocked, sig);
@@ -1162,9 +1239,21 @@ force_sig_info(int sig, struct siginfo *info, struct task_struct *t)
 	}
 	if (action->sa.sa_handler == SIG_DFL)
 		t->signal->flags &= ~SIGNAL_UNKILLABLE;
+
+	shared_siglock = sig_shared(sig) || sig_fatal(t, sig);
+	if (!shared_siglock) {
+		spin_unlock(&t->sighand->siglock);
+		spin_lock(&t->siglock);
+	}
+
 	ret = specific_send_sig_info(sig, info, t);
-	spin_unlock_irqrestore(&t->sighand->siglock, flags);
 
+	if (!shared_siglock)
+		spin_unlock(&t->siglock);
+	else
+		spin_unlock(&t->sighand->siglock);
+
+	write_unlock_irqrestore(&t->sighand->action_lock, flags);
 	return ret;
 }
 
@@ -1185,7 +1274,9 @@ int zap_other_threads(struct task_struct *p)
 		/* Don't bother with already dead threads */
 		if (t->exit_state)
 			continue;
+		spin_lock(&t->siglock);
 		sigaddset(&t->pending.signal, SIGKILL);
+		spin_unlock(&t->siglock);
 		signal_wake_up(t, 1);
 	}
 
@@ -1314,11 +1405,15 @@ int kill_pid_info_as_uid(int sig, struct siginfo *info, struct pid *pid,
 		goto out_unlock;
 
 	if (sig) {
-		if (lock_task_sighand(p, &flags)) {
+		unsigned long _flags;
+
+		read_lock_irqsave(&p->sighand->action_lock, flags);
+		if (lock_task_sighand(p, &_flags)) {
 			ret = __send_signal(sig, info, p, 1, 0);
-			unlock_task_sighand(p, &flags);
+			unlock_task_sighand(p, &_flags);
 		} else
 			ret = -ESRCH;
+		read_unlock_irqrestore(&p->sighand->action_lock, flags);
 	}
 out_unlock:
 	rcu_read_unlock();
@@ -1411,9 +1506,9 @@ force_sigsegv(int sig, struct task_struct *p)
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
@@ -1485,14 +1580,24 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
 {
 	int sig = q->info.si_signo;
 	struct sigpending *pending;
-	unsigned long flags;
+	unsigned long flags, _flags;
+	int shared_siglock;
 	int ret;
 
 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
 
 	ret = -1;
-	if (!likely(lock_task_sighand(t, &flags)))
-		goto ret;
+	read_lock_irqsave(&t->sighand->action_lock, flags);
+	shared_siglock = group || sig_shared(sig) || sig_fatal(t, sig);
+	if (!shared_siglock) {
+		spin_lock(&t->siglock);
+		pending = &t->pending;
+	} else {
+		if (!likely(lock_task_sighand(t, &_flags)))
+			goto ret;
+
+		pending = &t->signal->shared_pending;
+	}
 
 	ret = 1; /* the signal is ignored */
 	if (!prepare_signal(sig, t, 0))
@@ -1511,12 +1616,18 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
 	q->info.si_overrun = 0;
 
 	signalfd_notify(t, sig);
-	pending = group ? &t->signal->shared_pending : &t->pending;
+
 	list_add_tail(&q->list, &pending->list);
 	sigaddset(&pending->signal, sig);
 	complete_signal(sig, t, group);
+
 out:
-	unlock_task_sighand(t, &flags);
+	if (shared_siglock)
+		unlock_task_sighand(t, &_flags);
+	else
+		spin_unlock(&t->siglock);
+
+	read_unlock_irqrestore(&t->sighand->action_lock, flags);
 ret:
 	return ret;
 }
@@ -1578,7 +1689,8 @@ int do_notify_parent(struct task_struct *tsk, int sig)
 	}
 
 	psig = tsk->parent->sighand;
-	spin_lock_irqsave(&psig->siglock, flags);
+	read_lock_irqsave(&psig->action_lock, flags);
+	spin_lock(&psig->siglock);
 	if (!task_ptrace(tsk) && sig == SIGCHLD &&
 	    (psig->action[SIGCHLD-1].sa.sa_handler == SIG_IGN ||
 	     (psig->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT))) {
@@ -1604,7 +1716,8 @@ int do_notify_parent(struct task_struct *tsk, int sig)
 	if (valid_signal(sig) && sig > 0)
 		__group_send_sig_info(sig, &info, tsk->parent);
 	__wake_up_parent(tsk, tsk->parent);
-	spin_unlock_irqrestore(&psig->siglock, flags);
+	spin_unlock(&psig->siglock);
+	read_unlock_irqrestore(&psig->action_lock, flags);
 
 	return ret;
 }
@@ -1666,7 +1779,8 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
  	}
 
 	sighand = parent->sighand;
-	spin_lock_irqsave(&sighand->siglock, flags);
+	read_lock_irqsave(&sighand->action_lock, flags);
+	spin_lock(&sighand->siglock);
 	if (sighand->action[SIGCHLD-1].sa.sa_handler != SIG_IGN &&
 	    !(sighand->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDSTOP))
 		__group_send_sig_info(SIGCHLD, &info, parent);
@@ -1674,7 +1788,8 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
 	 * Even if SIGCHLD is not generated, we must wake up wait4 calls.
 	 */
 	__wake_up_parent(tsk, parent);
-	spin_unlock_irqrestore(&sighand->siglock, flags);
+	spin_unlock(&sighand->siglock);
+	read_unlock_irqrestore(&sighand->action_lock, flags);
 }
 
 static inline int may_ptrace_stop(void)
@@ -2021,7 +2136,19 @@ static int ptrace_signal(int signr, siginfo_t *info,
 
 	/* If the (new) signal is now blocked, requeue it.  */
 	if (sigismember(&current->blocked, signr)) {
+		/*
+		 * We're called with the shared siglock held but if
+		 * we're going to modify the private signal queue we
+		 * also need to acquire the per-thread siglock.
+		 */
+		if (!sig_shared(signr) && !sig_fatal(current, signr))
+			spin_lock(&current->siglock);
+
 		specific_send_sig_info(signr, info, current);
+
+		if (!sig_shared(signr) && !sig_fatal(current, signr))
+			spin_unlock(&current->siglock);
+
 		signr = 0;
 	}
 
@@ -2126,8 +2253,11 @@ relock:
 			/* Run the handler.  */
 			*return_ka = *ka;
 
-			if (ka->sa.sa_flags & SA_ONESHOT)
+			if (ka->sa.sa_flags & SA_ONESHOT) {
+				write_lock(&sighand->action_lock);
 				ka->sa.sa_handler = SIG_DFL;
+				write_unlock(&sighand->action_lock);
+			}
 
 			break; /* will return non-zero "signr" value */
 		}
@@ -2157,9 +2287,8 @@ relock:
 			 * The default action is to stop all threads in
 			 * the thread group.  The job control signals
 			 * do nothing in an orphaned pgrp, but SIGSTOP
-			 * always works.  Note that siglock needs to be
-			 * dropped during the call to is_orphaned_pgrp()
-			 * because of lock ordering with tasklist_lock.
+			 * always works.  Note that we are not holding
+			 * siglock during the call to is_orphaned_pgrp().
 			 * This allows an intervening SIGCONT to be posted.
 			 * We need to check for that and bail out if necessary.
 			 */
@@ -2374,8 +2503,10 @@ long do_sigpending(void __user *set, unsigned long sigsetsize)
 		goto out;
 
 	spin_lock_irq(&current->sighand->siglock);
+	spin_lock(&current->siglock);
 	sigorsets(&pending, &current->pending.signal,
 		  &current->signal->shared_pending.signal);
+	spin_unlock(&current->siglock);
 	spin_unlock_irq(&current->sighand->siglock);
 
 	/* Outside the lock because only this thread touches it.  */
@@ -2691,9 +2822,10 @@ int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
 	if (!valid_signal(sig) || sig < 1 || (act && sig_kernel_only(sig)))
 		return -EINVAL;
 
+	read_lock_irq(&t->sighand->action_lock);
 	k = &t->sighand->action[sig-1];
 
-	spin_lock_irq(&current->sighand->siglock);
+	spin_lock(&current->sighand->siglock);
 	if (oact)
 		*oact = *k;
 
@@ -2717,13 +2849,16 @@ int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
 			sigaddset(&mask, sig);
 			rm_from_queue_full(&mask, &t->signal->shared_pending);
 			do {
+				spin_lock(&t->siglock);
 				rm_from_queue_full(&mask, &t->pending);
+				spin_unlock(&t->siglock);
 				t = next_thread(t);
 			} while (t != current);
 		}
 	}
 
-	spin_unlock_irq(&current->sighand->siglock);
+	spin_unlock(&current->sighand->siglock);
+	read_unlock_irq(&t->sighand->action_lock);
 	return 0;
 }
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 6475e1f..91e2450 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2244,13 +2244,15 @@ static void selinux_bprm_committed_creds(struct linux_binprm *bprm)
 		memset(&itimer, 0, sizeof itimer);
 		for (i = 0; i < 3; i++)
 			do_setitimer(i, &itimer, NULL);
-		spin_lock_irq(&current->sighand->siglock);
+		write_lock_irq(&current->sighand->action_lock);
+		spin_lock(&current->sighand->siglock);
 		if (!(current->signal->flags & SIGNAL_GROUP_EXIT)) {
 			__flush_signals(current);
 			flush_signal_handlers(current, 1);
 			sigemptyset(&current->blocked);
 		}
-		spin_unlock_irq(&current->sighand->siglock);
+		spin_unlock(&current->sighand->siglock);
+		write_unlock_irq(&current->sighand->action_lock);
 	}
 
 	/* Wake up the parent if it is waiting so that it can recheck
-- 
1.7.4

