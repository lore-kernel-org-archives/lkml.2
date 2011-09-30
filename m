Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab1I3PNr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 11:13:47 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60256 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755319Ab1I3PNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 11:13:35 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Anirudh Badam <abadam@cs.princeton.edu>
Subject: [RFC][PATCH 5/5] signal: Split siglock into shared_siglock and per-thread siglock
Date: Fri, 30 Sep 2011 16:12:57 +0100
Message-Id: <1317395577-14091-6-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Create two new locks specifically for synchronising access to
tsk->pending and tsk->signal->shared_pending. This helps to reduce
contention on the per-process siglock and improves scalability by
splitting signal delivery into a fastpath and slowpath.

The signal delivery fastpath dequeues a signal from the per-thread
queue (tsk->pending) which means it only has to acquire the per-thread
siglock. The slowpath on the other hand, must acquire the per-process
siglock (and potentially sighand->siglock if an itimer signal is
dequeued) and dequeue a signal from the shared queue.

Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Anirudh Badam <abadam@cs.princeton.edu>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 fs/autofs4/waitq.c        |    5 +-
 fs/signalfd.c             |    6 +-
 include/linux/init_task.h |    2 +
 include/linux/sched.h     |    6 +-
 kernel/exit.c             |   12 +-
 kernel/fork.c             |    2 +
 kernel/freezer.c          |   10 +-
 kernel/posix-timers.c     |    5 +-
 kernel/signal.c           |  428 ++++++++++++++++++++++++++++++++-------------
 net/9p/client.c           |    6 +-
 net/sunrpc/svc.c          |    3 -
 security/selinux/hooks.c  |   11 +-
 12 files changed, 338 insertions(+), 158 deletions(-)

diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index 58ba49a..d2fdcdc 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -82,10 +82,11 @@ static int autofs4_write(struct file *file, const void *addr, int bytes)
 	/* Keep the currently executing process from receiving a
 	   SIGPIPE unless it was already supposed to get one */
 	if (wr == -EPIPE && !sigpipe) {
-		spin_lock_irqsave(&current->sighand->siglock, flags);
+		spin_lock_irqsave(&current->siglock, flags);
 		sigdelset(&current->pending.signal, SIGPIPE);
+		spin_unlock_irqrestore(&current->siglock, flags);
+
 		recalc_sigpending();
-		spin_unlock_irqrestore(&current->sighand->siglock, flags);
 	}
 
 	return (bytes > 0);
diff --git a/fs/signalfd.c b/fs/signalfd.c
index 728681d..26ea662 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -47,12 +47,14 @@ static unsigned int signalfd_poll(struct file *file, poll_table *wait)
 
 	poll_wait(file, &current->sighand->signalfd_wqh, wait);
 
-	spin_lock_irq(&current->sighand->siglock);
+	spin_lock_irq(&current->siglock);
+	spin_lock(&current->signal->shared_siglock);
 	if (next_signal(&current->pending, &ctx->sigmask) ||
 	    next_signal(&current->signal->shared_pending,
 			&ctx->sigmask))
 		events |= POLLIN;
-	spin_unlock_irq(&current->sighand->siglock);
+	spin_unlock(&current->signal->shared_siglock);
+	spin_unlock_irq(&current->siglock);
 
 	return events;
 }
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 80baa1d..6448863 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -34,6 +34,7 @@ extern struct fs_struct init_fs;
 	.nr_threads	= 1,						\
 	.wait_chldexit	= __WAIT_QUEUE_HEAD_INITIALIZER(sig.wait_chldexit),\
 	.ctrl_lock	= __SPIN_LOCK_UNLOCKED(sig.ctrl_lock),		\
+	.shared_siglock	= __SPIN_LOCK_UNLOCKED(sig.shared_siglock),	\
 	.shared_pending	= { 						\
 		.list = LIST_HEAD_INIT(sig.shared_pending.list),	\
 		.signal =  {{0}}},					\
@@ -171,6 +172,7 @@ extern struct cred init_cred;
 	.signal		= &init_signals,				\
 	.sighand	= &init_sighand,				\
 	.nsproxy	= &init_nsproxy,				\
+	.siglock	= __SPIN_LOCK_UNLOCKED(tsk.siglock),		\
 	.pending	= {						\
 		.list = LIST_HEAD_INIT(tsk.pending.list),		\
 		.signal = {{0}}},					\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e35ce4a..c04048f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -534,6 +534,9 @@ struct signal_struct {
 	/* current thread group signal load-balancing target: */
 	struct task_struct	*curr_target;
 
+	/* protects shared_pending */
+	spinlock_t		shared_siglock;
+
 	/* shared signal handling: */
 	struct sigpending	shared_pending;
 
@@ -1395,6 +1398,7 @@ struct task_struct {
 
 	sigset_t blocked, real_blocked;
 	sigset_t saved_sigmask;	/* restored if set_restore_sigmask() was used */
+	spinlock_t siglock;	/* protects pending */
 	struct sigpending pending;
 
 	unsigned long sas_ss_sp;
@@ -2166,7 +2170,7 @@ extern void force_sig(int, struct task_struct *);
 extern int send_sig(int, struct task_struct *, int);
 extern int zap_other_threads(struct task_struct *p);
 extern struct sigqueue *sigqueue_alloc(void);
-extern void sigqueue_free(struct sigqueue *);
+extern void sigqueue_free(struct sigqueue *, int group);
 extern int send_sigqueue(struct sigqueue *,  struct task_struct *, int group);
 extern int do_sigaction(int, struct k_sigaction *, struct k_sigaction *);
 extern int do_sigaltstack(const stack_t __user *, stack_t __user *, unsigned long);
diff --git a/kernel/exit.c b/kernel/exit.c
index 379a13d..32775ca 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -374,7 +374,6 @@ int allow_signal(int sig)
 	if (!valid_signal(sig) || sig < 1)
 		return -EINVAL;
 
-	spin_lock_irq(&current->sighand->siglock);
 	/* This is only needed for daemonize()'ed kthreads */
 	sigdelset(&current->blocked, sig);
 	/*
@@ -382,12 +381,11 @@ int allow_signal(int sig)
 	 * know it'll be handled, so that they don't get converted to
 	 * SIGKILL or just silently dropped.
 	 */
-	write_lock(&current->sighand->action_lock);
+	write_lock_irq(&current->sighand->action_lock);
 	current->sighand->action[(sig)-1].sa.sa_handler = (void __user *)2;
-	write_unlock(&current->sighand->action_lock);
+	write_unlock_irq(&current->sighand->action_lock);
 
 	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
 	return 0;
 }
 
@@ -398,13 +396,11 @@ int disallow_signal(int sig)
 	if (!valid_signal(sig) || sig < 1)
 		return -EINVAL;
 
-	spin_lock_irq(&current->sighand->siglock);
-	write_lock(&current->sighand->action_lock);
+	write_lock_irq(&current->sighand->action_lock);
 	current->sighand->action[(sig)-1].sa.sa_handler = SIG_IGN;
-	write_unlock(&current->sighand->action_lock);
+	write_unlock_irq(&current->sighand->action_lock);
 
 	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
 	return 0;
 }
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 8c5cf19..606604a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -992,6 +992,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	if (clone_flags & CLONE_NEWPID)
 		sig->flags |= SIGNAL_UNKILLABLE;
 	sig->curr_target = tsk;
+	spin_lock_init(&sig->shared_siglock);
 	init_sigpending(&sig->shared_pending);
 	spin_lock_init(&sig->ctrl_lock);
 	INIT_LIST_HEAD(&sig->posix_timers);
@@ -1166,6 +1167,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->vfork_done = NULL;
 	spin_lock_init(&p->alloc_lock);
 
+	spin_lock_init(&p->siglock);
 	init_sigpending(&p->pending);
 
 	p->utime = cputime_zero;
diff --git a/kernel/freezer.c b/kernel/freezer.c
index 7b01de9..a990da8 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -40,9 +40,7 @@ void refrigerator(void)
 	save = current->state;
 	pr_debug("%s entered refrigerator\n", current->comm);
 
-	spin_lock_irq(&current->sighand->siglock);
 	recalc_sigpending(); /* We sent fake signal, clean it up */
-	spin_unlock_irq(&current->sighand->siglock);
 
 	/* prevent accounting of that task to load */
 	current->flags |= PF_FREEZING;
@@ -66,9 +64,9 @@ static void fake_signal_wake_up(struct task_struct *p)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&p->sighand->siglock, flags);
+	spin_lock_irqsave(&p->siglock, flags);
 	signal_wake_up(p, 0);
-	spin_unlock_irqrestore(&p->sighand->siglock, flags);
+	spin_unlock_irqrestore(&p->siglock, flags);
 }
 
 /**
@@ -122,14 +120,10 @@ bool freeze_task(struct task_struct *p, bool sig_only)
 
 void cancel_freezing(struct task_struct *p)
 {
-	unsigned long flags;
-
 	if (freezing(p)) {
 		pr_debug("  clean up: %s\n", p->comm);
 		clear_freeze_flag(p);
-		spin_lock_irqsave(&p->sighand->siglock, flags);
 		recalc_sigpending_and_wake(p);
-		spin_unlock_irqrestore(&p->sighand->siglock, flags);
 	}
 }
 
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 4556182..bb1b2c8 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -502,6 +502,8 @@ static void k_itimer_rcu_free(struct rcu_head *head)
 #define IT_ID_NOT_SET	0
 static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
 {
+	int shared;
+
 	if (it_id_set) {
 		unsigned long flags;
 		spin_lock_irqsave(&idr_lock, flags);
@@ -509,7 +511,8 @@ static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
 		spin_unlock_irqrestore(&idr_lock, flags);
 	}
 	put_pid(tmr->it_pid);
-	sigqueue_free(tmr->sigq);
+	shared = !(tmr->it_sigev_notify & SIGEV_THREAD_ID);
+	sigqueue_free(tmr->sigq, shared);
 	call_rcu(&tmr->it.rcu, k_itimer_rcu_free);
 }
 
diff --git a/kernel/signal.c b/kernel/signal.c
index ca99c2d..c8176ea 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -50,7 +50,6 @@
  *        * most things under tsk->signal
  *
  *        * tsk->last_siginfo
- *        * tsk->pending
  *
  *        * tsk->cpu_timers
  *
@@ -67,12 +66,24 @@
  *        * tsk->signal->notify_count
  *        * tsk->signal->group_stop
  *        * tsk->signal->flags
+ *        * tsk->real_blocked
  *        * tsk->group_stop
  *        * tsk->jobctl
  *
  *        * the atomic operation of checking tsk->jobctl, tsk->pending and
  *          tsk->signal->shared_pending and setting/clearing TIF_SIGPENDING,
  *          see recalc_sigpending().
+ *
+ *   - ->siglock (spinlock) protects,
+ *
+ *        * tsk->notifier_data
+ *        * tsk->notifier_mask
+ *        * tsk->notifier
+ *        * tsk->pending
+ *
+ *   - signal->shared_siglock (spinlock) protects,
+ *
+ *        * tsk->signal->shared_pending
  */
 
 /*
@@ -178,8 +189,8 @@ static inline int has_pending_signals(sigset_t *signal, sigset_t *blocked)
  */
 static int recalc_sigpending_tsk(struct task_struct *t)
 {
-	assert_spin_locked(&t->sighand->siglock);
 	assert_spin_locked(&t->signal->ctrl_lock);
+	assert_spin_locked(&t->siglock);
 
 	if ((t->jobctl & JOBCTL_PENDING_MASK) ||
 	    PENDING(&t->pending, &t->blocked) ||
@@ -202,21 +213,32 @@ static int recalc_sigpending_tsk(struct task_struct *t)
 void recalc_sigpending_and_wake(struct task_struct *t)
 {
 	struct signal_struct *sig = t->signal;
+	unsigned long flags;
 
-	spin_lock(&sig->ctrl_lock);
+	spin_lock_irqsave(&sig->ctrl_lock, flags);
+	spin_lock(&t->siglock);
 	if (recalc_sigpending_tsk(t))
 		signal_wake_up(t, 0);
-	spin_unlock(&sig->ctrl_lock);
+	spin_unlock(&t->siglock);
+	spin_unlock_irqrestore(&sig->ctrl_lock, flags);
+}
+
+static void __recalc_sigpending(void)
+{
+	if (!recalc_sigpending_tsk(current) && !freezing(current))
+		clear_thread_flag(TIF_SIGPENDING);
 }
 
 void recalc_sigpending(void)
 {
 	struct signal_struct *sig = current->signal;
+	unsigned long flags;
 
-	spin_lock(&sig->ctrl_lock);
-	if (!recalc_sigpending_tsk(current) && !freezing(current))
-		clear_thread_flag(TIF_SIGPENDING);
-	spin_unlock(&sig->ctrl_lock);
+	spin_lock_irqsave(&sig->ctrl_lock, flags);
+	spin_lock(&current->siglock);
+	__recalc_sigpending();
+	spin_unlock(&current->siglock);
+	spin_unlock_irqrestore(&sig->ctrl_lock, flags);
 }
 
 /* Given the mask, find the first available signal that should be serviced. */
@@ -479,6 +501,9 @@ void flush_sigqueue(struct sigpending *queue)
  */
 void __flush_signals(struct task_struct *t)
 {
+	assert_spin_locked(&t->siglock);
+	assert_spin_locked(&t->signal->shared_siglock);
+
 	clear_tsk_thread_flag(t, TIF_SIGPENDING);
 	flush_sigqueue(&t->pending);
 	flush_sigqueue(&t->signal->shared_pending);
@@ -488,9 +513,11 @@ void flush_signals(struct task_struct *t)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&t->sighand->siglock, flags);
+	spin_lock_irqsave(&t->siglock, flags);
+	spin_lock(&t->signal->shared_siglock);
 	__flush_signals(t);
-	spin_unlock_irqrestore(&t->sighand->siglock, flags);
+	spin_unlock(&t->signal->shared_siglock);
+	spin_unlock_irqrestore(&t->siglock, flags);
 }
 
 static void __flush_itimer_signals(struct sigpending *pending)
@@ -521,10 +548,12 @@ void flush_itimer_signals(void)
 	struct task_struct *tsk = current;
 	unsigned long flags;
 
-	spin_lock_irqsave(&tsk->sighand->siglock, flags);
+	spin_lock_irqsave(&tsk->siglock, flags);
+	spin_lock(&tsk->signal->shared_siglock);
 	__flush_itimer_signals(&tsk->pending);
 	__flush_itimer_signals(&tsk->signal->shared_pending);
-	spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
+	spin_unlock(&tsk->signal->shared_siglock);
+	spin_unlock_irqrestore(&tsk->siglock, flags);
 }
 
 /*
@@ -584,11 +613,11 @@ block_all_signals(int (*notifier)(void *priv), void *priv, sigset_t *mask)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&current->sighand->siglock, flags);
+	spin_lock_irqsave(&current->siglock, flags);
 	current->notifier_mask = mask;
 	current->notifier_data = priv;
 	current->notifier = notifier;
-	spin_unlock_irqrestore(&current->sighand->siglock, flags);
+	spin_unlock_irqrestore(&current->siglock, flags);
 }
 
 /* Notify the system that blocking has ended. */
@@ -598,11 +627,13 @@ unblock_all_signals(void)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&current->sighand->siglock, flags);
+	spin_lock_irqsave(&current->signal->ctrl_lock, flags);
+	spin_lock(&current->siglock);
 	current->notifier = NULL;
 	current->notifier_data = NULL;
-	recalc_sigpending();
-	spin_unlock_irqrestore(&current->sighand->siglock, flags);
+	__recalc_sigpending();
+	spin_unlock(&current->siglock);
+	spin_unlock_irqrestore(&current->signal->ctrl_lock, flags);
 }
 
 static void collect_signal(int sig, struct sigpending *list, siginfo_t *info)
@@ -664,6 +695,49 @@ static int __dequeue_signal(struct sigpending *pending, sigset_t *mask,
 }
 
 /*
+ * This is the slowpath because we need to acquire the heavily contended
+ * shared_siglock.
+ */
+static int dequeue_slowpath(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
+{
+	unsigned long flags;
+	int signr;
+
+	spin_lock_irqsave(&tsk->signal->shared_siglock, flags);
+	signr = __dequeue_signal(&tsk->signal->shared_pending,
+				 mask, info);
+	spin_unlock_irqrestore(&tsk->signal->shared_siglock, flags);
+
+	/*
+	 * itimer signal ?
+	 *
+	 * itimers are process shared and we restart periodic
+	 * itimers in the signal delivery path to prevent DoS
+	 * attacks in the high resolution timer case. This is
+	 * compliant with the old way of self-restarting
+	 * itimers, as the SIGALRM is a legacy signal and only
+	 * queued once. Changing the restart behaviour to
+	 * restart the timer in the signal dequeue path is
+	 * reducing the timer noise on heavy loaded !highres
+	 * systems too.
+	 */
+	if (unlikely(signr == SIGALRM)) {
+		struct hrtimer *tmr = &tsk->signal->real_timer;
+
+		spin_lock_irqsave(&tsk->sighand->siglock, flags);
+		if (!hrtimer_is_queued(tmr) &&
+		    tsk->signal->it_real_incr.tv64 != 0) {
+			hrtimer_forward(tmr, tmr->base->get_time(),
+					tsk->signal->it_real_incr);
+			hrtimer_restart(tmr);
+		}
+		spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
+	}
+
+	return signr;
+}
+
+/*
  * Dequeue a signal and return the element to the caller, which is
  * expected to free it.
  */
@@ -672,47 +746,19 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 	unsigned long flags;
 	int signr;
 
-	spin_lock_irqsave(&current->sighand->siglock, flags);
+	spin_lock_irqsave(&current->siglock, flags);
 
 	/* We only dequeue private signals from ourselves, we don't let
 	 * signalfd steal them
 	 */
 	signr = __dequeue_signal(&tsk->pending, mask, info);
-	if (!signr) {
-		signr = __dequeue_signal(&tsk->signal->shared_pending,
-					 mask, info);
-		/*
-		 * itimer signal ?
-		 *
-		 * itimers are process shared and we restart periodic
-		 * itimers in the signal delivery path to prevent DoS
-		 * attacks in the high resolution timer case. This is
-		 * compliant with the old way of self-restarting
-		 * itimers, as the SIGALRM is a legacy signal and only
-		 * queued once. Changing the restart behaviour to
-		 * restart the timer in the signal dequeue path is
-		 * reducing the timer noise on heavy loaded !highres
-		 * systems too.
-		 */
-		if (unlikely(signr == SIGALRM)) {
-			struct hrtimer *tmr = &tsk->signal->real_timer;
-
-			if (!hrtimer_is_queued(tmr) &&
-			    tsk->signal->it_real_incr.tv64 != 0) {
-				hrtimer_forward(tmr, tmr->base->get_time(),
-						tsk->signal->it_real_incr);
-				hrtimer_restart(tmr);
-			}
-		}
-	}
+	spin_unlock_irqrestore(&current->siglock, flags);
+	if (!signr)
+		signr = dequeue_slowpath(tsk, mask, info);
 
-	spin_lock(&current->signal->ctrl_lock);
 	recalc_sigpending();
-	if (!signr) {
-		spin_unlock(&current->signal->ctrl_lock);
-		spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
+	if (!signr)
 		return 0;
-	}
 
 	if (unlikely(sig_kernel_stop(signr))) {
 		/*
@@ -727,12 +773,11 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 		 * is to alert stop-signal processing code when another
 		 * processor has come along and cleared the flag.
 		 */
+		spin_lock_irqsave(&current->signal->ctrl_lock, flags);
 		current->jobctl |= JOBCTL_STOP_DEQUEUED;
+		spin_unlock_irqrestore(&current->signal->ctrl_lock, flags);
 	}
 
-	spin_unlock(&current->signal->ctrl_lock);
-	spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
-
 	if ((info->si_code & __SI_MASK) == __SI_TIMER && info->si_sys_private)
 		do_schedule_next_timer(info);
 
@@ -932,8 +977,8 @@ static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
 {
 	struct signal_struct *signal = p->signal;
 	struct task_struct *t;
+	unsigned long flags;
 
-	spin_lock(&signal->ctrl_lock);
 	if (unlikely(signal->flags & SIGNAL_GROUP_EXIT)) {
 		/*
 		 * The process is in the middle of dying, nothing to do.
@@ -942,21 +987,32 @@ static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
 		/*
 		 * This is a stop signal.  Remove SIGCONT from all queues.
 		 */
+		spin_lock(&signal->shared_siglock);
 		rm_from_queue(sigmask(SIGCONT), &signal->shared_pending);
+		spin_unlock(&signal->shared_siglock);
 		t = p;
 		do {
+			spin_lock(&t->siglock);
 			rm_from_queue(sigmask(SIGCONT), &t->pending);
+			spin_unlock(&t->siglock);
 		} while_each_thread(p, t);
 	} else if (sig == SIGCONT) {
 		unsigned int why;
+
+		spin_lock_irqsave(&signal->ctrl_lock, flags);
+
 		/*
 		 * Remove all stop signals from all queues, wake all threads.
 		 */
+		spin_lock(&signal->shared_siglock);
 		rm_from_queue(SIG_KERNEL_STOP_MASK, &signal->shared_pending);
+		spin_unlock(&signal->shared_siglock);
 		t = p;
 		do {
 			task_clear_jobctl_pending(t, JOBCTL_STOP_PENDING);
+			spin_lock(&t->siglock);
 			rm_from_queue(SIG_KERNEL_STOP_MASK, &t->pending);
+			spin_unlock(&t->siglock);
 			if (likely(!(t->ptrace & PT_SEIZED)))
 				wake_up_state(t, __TASK_STOPPED);
 			else
@@ -987,8 +1043,8 @@ static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
 			signal->group_stop_count = 0;
 			signal->group_exit_code = 0;
 		}
+		spin_unlock_irqrestore(&signal->ctrl_lock, flags);
 	}
-	spin_unlock(&signal->ctrl_lock);
 
 	return !sig_ignored(p, sig, from_ancestor_ns);
 }
@@ -1014,6 +1070,47 @@ static inline int wants_signal(int sig, struct task_struct *p)
 	return task_curr(p) || !signal_pending(p);
 }
 
+/**
+ * complete_fatal_signal - send a fatal signal to a task
+ * @p: task sending the fatal signal
+ * @t: target task receiving the fatal signal
+ * @sig: fatal signal number
+ *
+ * RETURNS:
+ * %true if a fatal signal was delivered, %false otherwise.
+ */
+static bool complete_fatal_signal(struct task_struct *p, struct task_struct *t,
+				  int sig)
+{
+	struct signal_struct *signal = p->signal;
+
+	assert_spin_locked(&signal->ctrl_lock);
+
+	if (!sig_kernel_coredump(sig) && !sigismember(&t->real_blocked, sig) &&
+	    !(signal->flags & (SIGNAL_UNKILLABLE | SIGNAL_GROUP_EXIT))) {
+		/*
+		 * Start a group exit and wake everybody up.
+		 * This way we don't have other threads
+		 * running and doing things after a slower
+		 * thread has the fatal signal pending.
+		 */
+		signal->flags = SIGNAL_GROUP_EXIT;
+		signal->group_exit_code = sig;
+		signal->group_stop_count = 0;
+		t = p;
+		do {
+			task_clear_jobctl_pending(t, JOBCTL_PENDING_MASK);
+			spin_lock(&t->siglock);
+			sigaddset(&t->pending.signal, SIGKILL);
+			spin_unlock(&t->siglock);
+			signal_wake_up(t, 1);
+		} while_each_thread(p, t);
+		return true;
+	}
+
+	return false;
+}
+
 static void complete_signal(int sig, struct task_struct *p, int group)
 {
 	struct signal_struct *signal = p->signal;
@@ -1055,33 +1152,32 @@ static void complete_signal(int sig, struct task_struct *p, int group)
 	 * Found a killable thread.  If the signal will be fatal,
 	 * then start taking the whole group down immediately.
 	 */
-	spin_lock(&signal->ctrl_lock);
-	if (sig_fatal(p, sig) &&
-	    !(signal->flags & (SIGNAL_UNKILLABLE | SIGNAL_GROUP_EXIT)) &&
-	    !sigismember(&t->real_blocked, sig) &&
-	    (sig == SIGKILL || !t->ptrace)) {
+	if (sig_fatal(p, sig) && (sig == SIGKILL || !t->ptrace)) {
+		bool fatal;
+
+		if (group)
+			spin_unlock(&signal->shared_siglock);
+		spin_unlock(&p->siglock);
+
 		/*
 		 * This signal will be fatal to the whole group.
 		 */
-		if (!sig_kernel_coredump(sig)) {
-			/*
-			 * Start a group exit and wake everybody up.
-			 * This way we don't have other threads
-			 * running and doing things after a slower
-			 * thread has the fatal signal pending.
-			 */
-			signal->flags = SIGNAL_GROUP_EXIT;
-			signal->group_exit_code = sig;
-			signal->group_stop_count = 0;
-			t = p;
-			do {
-				task_clear_jobctl_pending(t, JOBCTL_PENDING_MASK);
-				sigaddset(&t->pending.signal, SIGKILL);
-				signal_wake_up(t, 1);
-			} while_each_thread(p, t);
-			spin_unlock(&signal->ctrl_lock);
+		spin_lock(&signal->ctrl_lock);
+		fatal = complete_fatal_signal(p, t, sig);
+		spin_unlock(&signal->ctrl_lock);
+
+		/*
+		 * When we set TIF_SIGPENDING in signal_wake_up() the
+		 * task might get spurious wakeups if it has already
+		 * seen the pending signal after we unlocked
+		 * siglock. It's probably not a big deal.
+		 */
+		spin_lock(&p->siglock);
+		if (group)
+			spin_lock(&signal->shared_siglock);
+
+		if (fatal)
 			return;
-		}
 	}
 
 	/*
@@ -1089,7 +1185,6 @@ static void complete_signal(int sig, struct task_struct *p, int group)
 	 * Tell the chosen thread to wake up and dequeue it.
 	 */
 	signal_wake_up(t, sig == SIGKILL);
-	spin_unlock(&signal->ctrl_lock);
 	return;
 }
 
@@ -1098,21 +1193,36 @@ static inline int legacy_queue(struct sigpending *signals, int sig)
 	return (sig < SIGRTMIN) && sigismember(&signals->signal, sig);
 }
 
-static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
-			int group, int from_ancestor_ns)
+/**
+ * enqueue_signal - add a signal to a pending queue
+ * @t: task's pending queue
+ * @info: signal's siginfo
+ * @sig: signal number
+ * @group: does the signal affect the whole thread group?
+ * @from_ancestor_ns: ancestor namespace
+ *
+ * CONTEXT:
+ * Must be called with @t->siglock held. If @group is set then
+ * @t->signal->shared_siglock must also be held.
+ *
+ * RETURNS:
+ * < 0 if an error occurred
+ * 0 if no signal was enqueued
+ * > 0 if a signal was added to the pending queue.
+ */
+static int enqueue_signal(struct task_struct *t, struct siginfo *info,
+			  int sig, int group, int from_ancestor_ns)
 {
 	struct sigpending *pending;
 	struct sigqueue *q;
 	int override_rlimit;
 
-	trace_signal_generate(sig, info, t);
-
-	assert_spin_locked(&t->sighand->siglock);
-
-	if (!prepare_signal(sig, t, from_ancestor_ns))
-		return 0;
+	assert_spin_locked(&t->siglock);
+	if (group)
+		assert_spin_locked(&t->signal->shared_siglock);
 
 	pending = group ? &t->signal->shared_pending : &t->pending;
+
 	/*
 	 * Short-circuit ignored signals and support queuing
 	 * exactly one non-rt signal, so that we can get more
@@ -1188,8 +1298,35 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 out_set:
 	signalfd_notify(t, sig);
 	sigaddset(&pending->signal, sig);
-	complete_signal(sig, t, group);
-	return 0;
+	return 1;
+}
+
+static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
+			int group, int from_ancestor_ns)
+{
+	unsigned long flags;
+	int ret;
+
+	trace_signal_generate(sig, info, t);
+
+	if (!prepare_signal(sig, t, from_ancestor_ns))
+		return 0;
+
+	spin_lock_irqsave(&t->siglock, flags);
+	if (group)
+		spin_lock(&t->signal->shared_siglock);
+
+	ret = enqueue_signal(t, info, sig, group, from_ancestor_ns);
+	if (ret > 0) {
+		complete_signal(sig, t, group);
+		ret = 0;
+	}
+
+	if (group)
+		spin_unlock(&t->signal->shared_siglock);
+	spin_unlock_irqrestore(&t->siglock, flags);
+
+	return ret;
 }
 
 static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
@@ -1296,24 +1433,50 @@ force_sig_info(int sig, struct siginfo *info, struct task_struct *t)
 	unsigned long int flags;
 	int ret, blocked, ignored;
 	struct k_sigaction *action;
+	bool fatal;
+	int from_ancestor_ns = 0;
 
-	spin_lock_irqsave(&t->sighand->siglock, flags);
-	write_lock(&t->sighand->action_lock);
+	write_lock_irqsave(&t->sighand->action_lock, flags);
 	action = &t->sighand->action[sig-1];
 	ignored = action->sa.sa_handler == SIG_IGN;
+
+	spin_lock(&t->signal->ctrl_lock);
+	spin_lock(&t->siglock);
 	blocked = sigismember(&t->blocked, sig);
 	if (blocked || ignored) {
 		action->sa.sa_handler = SIG_DFL;
 		if (blocked) {
 			sigdelset(&t->blocked, sig);
-			recalc_sigpending_and_wake(t);
+			if (recalc_sigpending_tsk(t))
+				signal_wake_up(t, 0);
 		}
 	}
 	if (action->sa.sa_handler == SIG_DFL)
 		t->signal->flags &= ~SIGNAL_UNKILLABLE;
-	ret = specific_send_sig_info(sig, info, t);
-	write_unlock(&t->sighand->action_lock);
-	spin_unlock_irqrestore(&t->sighand->siglock, flags);
+
+#ifdef CONFIG_PID_NS
+	from_ancestor_ns = si_fromuser(info) &&
+			   !task_pid_nr_ns(current, task_active_pid_ns(t));
+#endif
+	ret = enqueue_signal(t, info, sig, 0, from_ancestor_ns);
+	spin_unlock(&t->siglock);
+
+	/*
+	 * There's no need to call wants_signal() like
+	 * complete_signal() becuase 't' doesn't get a choice.
+	 */
+	if (ret > 0) {
+		fatal = false;
+		if (sig_fatal(t, sig) && (sig == SIGKILL || !t->ptrace))
+			fatal = complete_fatal_signal(t, t, sig);
+
+		if (!fatal)
+			signal_wake_up(t, sig == SIGKILL);
+		ret = 0;
+	}
+
+	spin_unlock(&t->signal->ctrl_lock);
+	write_unlock_irqrestore(&t->sighand->action_lock, flags);
 
 	return ret;
 }
@@ -1335,7 +1498,9 @@ int zap_other_threads(struct task_struct *p)
 		/* Don't bother with already dead threads */
 		if (t->exit_state)
 			continue;
+		spin_lock(&t->siglock);
 		sigaddset(&t->pending.signal, SIGKILL);
+		spin_unlock(&t->siglock);
 		signal_wake_up(t, 1);
 	}
 
@@ -1613,17 +1778,23 @@ struct sigqueue *sigqueue_alloc(void)
 	return q;
 }
 
-void sigqueue_free(struct sigqueue *q)
+void sigqueue_free(struct sigqueue *q, int group)
 {
 	unsigned long flags;
-	spinlock_t *lock = &current->sighand->siglock;
+	spinlock_t *lock;
 
 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
 	/*
-	 * We must hold ->siglock while testing q->list
-	 * to serialize with collect_signal() or with
+	 * We must hold ->siglock or ->shared_siglock
+	 * while testing q->list to serialize with
+	 * collect_signal() or with
 	 * __exit_signal()->flush_sigqueue().
 	 */
+	if (group)
+		lock = &current->signal->shared_siglock;
+	else
+		lock = &current->siglock;
+
 	spin_lock_irqsave(lock, flags);
 	q->flags &= ~SIGQUEUE_PREALLOC;
 	/*
@@ -1655,6 +1826,10 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
 	if (!prepare_signal(sig, t, 0))
 		goto out;
 
+	spin_lock(&t->siglock);
+	if (group)
+		spin_lock(&t->signal->shared_siglock);
+
 	ret = 0;
 	if (unlikely(!list_empty(&q->list))) {
 		/*
@@ -1663,7 +1838,7 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
 		 */
 		BUG_ON(q->info.si_code != SI_TIMER);
 		q->info.si_overrun++;
-		goto out;
+		goto out_siglock;
 	}
 	q->info.si_overrun = 0;
 
@@ -1672,6 +1847,10 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
 	list_add_tail(&q->list, &pending->list);
 	sigaddset(&pending->signal, sig);
 	complete_signal(sig, t, group);
+out_siglock:
+	if (group)
+		spin_unlock(&t->signal->shared_siglock);
+	spin_unlock(&t->siglock);
 out:
 	unlock_task_sighand(t, &flags);
 ret:
@@ -1735,8 +1914,7 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 	}
 
 	psig = tsk->parent->sighand;
-	spin_lock_irqsave(&psig->siglock, flags);
-	read_lock(&psig->action_lock);
+	read_lock_irqsave(&psig->action_lock, flags);
 	if (!tsk->ptrace && sig == SIGCHLD &&
 	    (psig->action[SIGCHLD-1].sa.sa_handler == SIG_IGN ||
 	     (psig->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT))) {
@@ -1762,8 +1940,7 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 	if (valid_signal(sig) && sig)
 		__group_send_sig_info_locked(sig, &info, tsk->parent);
 	__wake_up_parent(tsk, tsk->parent);
-	read_unlock(&psig->action_lock);
-	spin_unlock_irqrestore(&psig->siglock, flags);
+	read_unlock_irqrestore(&psig->action_lock, flags);
 
 	return autoreap;
 }
@@ -2011,7 +2188,9 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	 * So check for any that we should take before resuming user mode.
 	 * This sets TIF_SIGPENDING, but never clears it.
 	 */
+	spin_lock(&current->siglock);
 	recalc_sigpending_tsk(current);
+	spin_unlock(&current->siglock);
 }
 
 static void ptrace_do_notify(int signr, int exit_code, int why)
@@ -2581,16 +2760,15 @@ void exit_signals(struct task_struct *tsk)
 		return;
 	}
 
-	spin_lock_irq(&tsk->sighand->siglock);
 	/*
 	 * From now this task is not visible for group-wide signals,
 	 * see wants_signal(), do_signal_stop().
 	 */
 	tsk->flags |= PF_EXITING;
 	if (!signal_pending(tsk))
-		goto out;
+		return;
 
-	spin_lock(&tsk->signal->ctrl_lock);
+	spin_lock_irq(&tsk->signal->ctrl_lock);
 	unblocked = tsk->blocked;
 	signotset(&unblocked);
 	retarget_shared_pending(tsk, &unblocked);
@@ -2598,9 +2776,7 @@ void exit_signals(struct task_struct *tsk)
 	if (unlikely(tsk->jobctl & JOBCTL_STOP_PENDING) &&
 	    task_participate_group_stop(tsk))
 		group_stop = CLD_STOPPED;
-	spin_unlock(&tsk->signal->ctrl_lock);
-out:
-	spin_unlock_irq(&tsk->sighand->siglock);
+	spin_unlock_irq(&tsk->signal->ctrl_lock);
 
 	/*
 	 * If group stop has completed, deliver the notification.  This
@@ -2651,7 +2827,7 @@ static void __set_task_blocked(struct task_struct *tsk, const sigset_t *newset)
 		retarget_shared_pending(tsk, &newblocked);
 	}
 	tsk->blocked = *newset;
-	recalc_sigpending();
+	__recalc_sigpending();
 }
 
 /**
@@ -2665,11 +2841,11 @@ void set_current_blocked(const sigset_t *newset)
 {
 	struct task_struct *tsk = current;
 
-	spin_lock_irq(&tsk->sighand->siglock);
-	spin_lock(&tsk->signal->ctrl_lock);
+	spin_lock_irq(&tsk->signal->ctrl_lock);
+	spin_lock(&tsk->siglock);
 	__set_task_blocked(tsk, newset);
-	spin_unlock(&tsk->signal->ctrl_lock);
-	spin_unlock_irq(&tsk->sighand->siglock);
+	spin_unlock(&tsk->siglock);
+	spin_unlock_irq(&tsk->signal->ctrl_lock);
 }
 EXPORT_SYMBOL(set_current_blocked);
 
@@ -2753,10 +2929,12 @@ long do_sigpending(void __user *set, unsigned long sigsetsize)
 	if (sigsetsize > sizeof(sigset_t))
 		goto out;
 
-	spin_lock_irq(&current->sighand->siglock);
+	spin_lock_irq(&current->siglock);
+	spin_lock(&current->signal->shared_siglock);
 	sigorsets(&pending, &current->pending.signal,
 		  &current->signal->shared_pending.signal);
-	spin_unlock_irq(&current->sighand->siglock);
+	spin_unlock(&current->signal->shared_siglock);
+	spin_unlock_irq(&current->siglock);
 
 	/* Outside the lock because only this thread touches it.  */
 	sigandsets(&pending, &current->blocked, &pending);
@@ -2894,20 +3072,22 @@ int do_sigtimedwait(const sigset_t *which, siginfo_t *info,
 		 * they arrive. Unblocking is always fine, we can avoid
 		 * set_current_blocked().
 		 */
-		spin_lock_irq(&tsk->sighand->siglock);
+		spin_lock_irq(&tsk->signal->ctrl_lock);
 		tsk->real_blocked = tsk->blocked;
 		sigandsets(&tsk->blocked, &tsk->blocked, &mask);
-		recalc_sigpending();
-		spin_unlock_irq(&tsk->sighand->siglock);
+		spin_lock(&tsk->siglock);
+		__recalc_sigpending();
+		spin_unlock(&tsk->siglock);
+		spin_unlock_irq(&tsk->signal->ctrl_lock);
 
 		timeout = schedule_timeout_interruptible(timeout);
 
-		spin_lock_irq(&tsk->sighand->siglock);
-		spin_lock(&tsk->signal->ctrl_lock);
+		spin_lock_irq(&tsk->signal->ctrl_lock);
+		spin_lock(&tsk->siglock);
 		__set_task_blocked(tsk, &tsk->real_blocked);
+		spin_unlock(&tsk->siglock);
 		siginitset(&tsk->real_blocked, 0);
-		spin_unlock(&tsk->signal->ctrl_lock);
-		spin_unlock_irq(&tsk->sighand->siglock);
+		spin_unlock_irq(&tsk->signal->ctrl_lock);
 		sig = dequeue_signal(tsk, &mask, info);
 	}
 
diff --git a/net/9p/client.c b/net/9p/client.c
index 0505a03..2ba5608 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -594,7 +594,6 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 	va_list ap;
 	int tag, err;
 	struct p9_req_t *req;
-	unsigned long flags;
 	int sigpending;
 
 	P9_DPRINTK(P9_DEBUG_MUX, "client %p op %d\n", c, type);
@@ -664,11 +663,8 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 			err = 0;
 	}
 
-	if (sigpending) {
-		spin_lock_irqsave(&current->sighand->siglock, flags);
+	if (sigpending)
 		recalc_sigpending();
-		spin_unlock_irqrestore(&current->sighand->siglock, flags);
-	}
 
 	if (err < 0)
 		goto reterr;
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 6a69a11..5532009 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -930,7 +930,6 @@ static void __svc_unregister(const u32 program, const u32 version,
 static void svc_unregister(const struct svc_serv *serv)
 {
 	struct svc_program *progp;
-	unsigned long flags;
 	unsigned int i;
 
 	clear_thread_flag(TIF_SIGPENDING);
@@ -948,9 +947,7 @@ static void svc_unregister(const struct svc_serv *serv)
 		}
 	}
 
-	spin_lock_irqsave(&current->sighand->siglock, flags);
 	recalc_sigpending();
-	spin_unlock_irqrestore(&current->sighand->siglock, flags);
 }
 
 /*
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 47f278f..391bb8e 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2271,17 +2271,20 @@ static void selinux_bprm_committed_creds(struct linux_binprm *bprm)
 		memset(&itimer, 0, sizeof itimer);
 		for (i = 0; i < 3; i++)
 			do_setitimer(i, &itimer, NULL);
-		spin_lock_irq(&current->sighand->siglock);
-		spin_lock(&current->signal->ctrl_lock);
+		spin_lock_irq(&current->signal->ctrl_lock);
 		if (!(current->signal->flags & SIGNAL_GROUP_EXIT)) {
+			spin_lock(&current->siglock);
+			spin_lock(&current->signal->shared_siglock);
 			__flush_signals(current);
+			spin_unlock(&current->signal->shared_siglock);
+			spin_unlock(&current->siglock);
+
 			write_lock(&current->sighand->action_lock);
 			flush_signal_handlers(current, 1);
 			write_unlock(&current->sighand->action_lock);
 			sigemptyset(&current->blocked);
 		}
-		spin_unlock(&current->signal->ctrl_lock);
-		spin_unlock_irq(&current->sighand->siglock);
+		spin_unlock_irq(&current->signal->ctrl_lock);
 	}
 
 	/* Wake up the parent if it is waiting so that it can recheck
-- 
1.7.4.4

