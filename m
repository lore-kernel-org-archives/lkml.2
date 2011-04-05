Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab1DETWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 15:22:00 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:34057 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753442Ab1DETVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 15:21:55 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: [RFC][PATCH 1/5] signals: Always place SIGCONT and SIGSTOP on 'shared_pending'
Date: Tue,  5 Apr 2011 20:21:46 +0100
Message-Id: <1302031310-1765-2-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1302031310-1765-1-git-send-email-matt@console-pimps.org>
References: <1302031310-1765-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@linux.intel.com>

Because SIGCONT and SIGSTOP affect an entire thread group, we can
place them on the 'shared_pending' queue. This means that we no longer
have to iterate over every thread in a thread group to remove
SIGCONT/SIGSTOP signals from their private 'pending' queues.

SIGCONT and SIGSTOP signals are now only placed on the shared queue
and not on the private so queue we need to prevent them from being
starved of service. We need to prioritize signals on the shared queue
over signals on the private queue. For example, if we don't do this
there's potential for a task to keep handling private signals even
though they were delivered _after_ a SIGSTOP. Note that POSIX does not
mandate any kind of priority between signals to a thread group or a
specific thread, so this change in behaviour should be safe.

This is an optimization to reduce the amount of code that we execute
while holding ->siglock, and is preparation for introducing a
per-thread siglock for modifying the private signal queue.

Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
---
 kernel/signal.c |  123 +++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 79 insertions(+), 44 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 4f7312b..9595d86 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -545,51 +545,41 @@ static int __dequeue_signal(struct sigpending *pending, sigset_t *mask,
 }
 
 /*
- * Dequeue a signal and return the element to the caller, which is 
- * expected to free it.
- *
- * All callers have to hold the siglock.
+ * All callers must hold tsk->sighand->siglock.
  */
-int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
+static int __dequeue_shared_signal(struct task_struct *tsk,
+				   sigset_t *mask, siginfo_t *info)
 {
 	int signr;
 
-	/* We only dequeue private signals from ourselves, we don't let
-	 * signalfd steal them
+	assert_spin_locked(&tsk->sighand->siglock);
+
+	signr = __dequeue_signal(&tsk->signal->shared_pending,
+				 mask, info);
+	/*
+	 * itimer signal ?
+	 *
+	 * itimers are process shared and we restart periodic
+	 * itimers in the signal delivery path to prevent DoS
+	 * attacks in the high resolution timer case. This is
+	 * compliant with the old way of self restarting
+	 * itimers, as the SIGALRM is a legacy signal and only
+	 * queued once. Changing the restart behaviour to
+	 * restart the timer in the signal dequeue path is
+	 * reducing the timer noise on heavy loaded !highres
+	 * systems too.
 	 */
-	signr = __dequeue_signal(&tsk->pending, mask, info);
-	if (!signr) {
-		signr = __dequeue_signal(&tsk->signal->shared_pending,
-					 mask, info);
-		/*
-		 * itimer signal ?
-		 *
-		 * itimers are process shared and we restart periodic
-		 * itimers in the signal delivery path to prevent DoS
-		 * attacks in the high resolution timer case. This is
-		 * compliant with the old way of self restarting
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
+	if (unlikely(signr == SIGALRM)) {
+		struct hrtimer *tmr = &tsk->signal->real_timer;
+
+		if (!hrtimer_is_queued(tmr) &&
+		    tsk->signal->it_real_incr.tv64 != 0) {
+			hrtimer_forward(tmr, tmr->base->get_time(),
+					tsk->signal->it_real_incr);
+			hrtimer_restart(tmr);
 		}
 	}
 
-	recalc_sigpending();
-	if (!signr)
-		return 0;
-
 	if (unlikely(sig_kernel_stop(signr))) {
 		/*
 		 * Set a marker that we have dequeued a stop signal.  Our
@@ -605,6 +595,40 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 		 */
 		current->group_stop |= GROUP_STOP_DEQUEUED;
 	}
+
+	return signr;
+}
+
+/*
+ * Dequeue a signal and return the element to the caller, which is 
+ * expected to free it.
+ *
+ * All callers have to hold the siglock.
+ */
+int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
+{
+	int signr;
+
+	/*
+	 * Dequeue shared signals first since this is where SIGSTOP
+	 * and SIGCONTs will be. If we don't dequeue these first
+	 * there's a chance that we could keep handling private
+	 * signals even when there are SIGSTOPs or SIGCONTs pending in
+	 * the shared queue, e.g. we'd starve shared signals from
+	 * being serviced.
+	 */
+	signr = __dequeue_shared_signal(tsk, mask, info);
+
+	/* We only dequeue private signals from ourselves, we don't let
+	 * signalfd steal them
+	 */
+	if (!signr)
+		signr = __dequeue_signal(&tsk->pending, mask, info);
+
+	recalc_sigpending();
+	if (!signr)
+		return 0;
+
 	if ((info->si_code & __SI_MASK) == __SI_TIMER && info->si_sys_private) {
 		/*
 		 * Release the siglock to ensure proper locking order
@@ -779,13 +803,10 @@ static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
 		 */
 	} else if (sig_kernel_stop(sig)) {
 		/*
-		 * This is a stop signal.  Remove SIGCONT from all queues.
+		 * This is a stop signal.  Remove SIGCONT from the
+		 * shared queue.
 		 */
 		rm_from_queue(sigmask(SIGCONT), &signal->shared_pending);
-		t = p;
-		do {
-			rm_from_queue(sigmask(SIGCONT), &t->pending);
-		} while_each_thread(p, t);
 	} else if (sig == SIGCONT) {
 		unsigned int why;
 		/*
@@ -795,7 +816,6 @@ static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
 		t = p;
 		do {
 			task_clear_group_stop_pending(t);
-			rm_from_queue(SIG_KERNEL_STOP_MASK, &t->pending);
 			wake_up_state(t, __TASK_STOPPED);
 		} while_each_thread(p, t);
 
@@ -945,7 +965,22 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 	if (!prepare_signal(sig, t, from_ancestor_ns))
 		return 0;
 
-	pending = group ? &t->signal->shared_pending : &t->pending;
+	/*
+	 * We always enqueue SIGSTOP or SIGCONT signals on the shared
+	 * queue. This means that a SIGSTOP or SIGCONT signal _cannot_
+	 * be present on a thread's private pending queue.
+	 *
+	 * This makes prepare_signal() more optimal as we do not have
+	 * to remove signals from each thread's pending queue and so
+	 * can avoid iterating over all threads in the thread group
+	 * (and therefore avoid the locking that would be necessary to
+	 * do that safely).
+	 */
+	if (group || sig_kernel_stop(sig) || sig == SIGCONT)
+		pending = &t->signal->shared_pending;
+	else
+		pending = &t->pending;
+
 	/*
 	 * Short-circuit ignored signals and support queuing
 	 * exactly one non-rt signal, so that we can get more
-- 
1.7.4

