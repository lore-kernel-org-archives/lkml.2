Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab2JAM1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 08:27:46 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42441 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab2JAM1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 08:27:43 -0400
Date: Mon, 1 Oct 2012 14:27:37 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@ftp.linux.org.uk>
Subject: [GIT PULL] core kernel fixes for v3.7
Message-ID: <20121001122737.GA21793@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

   HEAD: f784e8a7989c0da3062d04bfea3db90f41e8f738 task_work: Simplify the usage in ptrace_notify() and get_signal_to_deliver()

This is a complex task_work series from Oleg that fixes the bug 
that this VFS commit tried to fix:

  d35abdb28824 hold task_lock around checks in keyctl

but solves the problem without the lockup regression that 
d35abdb28824 introduced in v3.6.

This series came late in v3.6 and I did not feel confident about 
it so late in the cycle. Might be worth backporting to -stable 
if it proves itself upstream.

 Thanks,

	Ingo

------------------>
Oleg Nesterov (4):
      task_work: Make task_work_add() lockless
      task_work: task_work_add() should not succeed after exit_task_work()
      task_work: Revert "hold task_lock around checks in keyctl"
      task_work: Simplify the usage in ptrace_notify() and get_signal_to_deliver()


 include/linux/task_work.h |   3 +-
 kernel/signal.c           |  18 ++------
 kernel/task_work.c        | 111 +++++++++++++++++++++++++---------------------
 security/keys/keyctl.c    |   2 -
 4 files changed, 66 insertions(+), 68 deletions(-)

diff --git a/include/linux/task_work.h b/include/linux/task_work.h
index fb46b03..ca5a1cf 100644
--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -18,8 +18,7 @@ void task_work_run(void);
 
 static inline void exit_task_work(struct task_struct *task)
 {
-	if (unlikely(task->task_works))
-		task_work_run();
+	task_work_run();
 }
 
 #endif	/* _LINUX_TASK_WORK_H */
diff --git a/kernel/signal.c b/kernel/signal.c
index be4f856..2c681f1 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1971,13 +1971,8 @@ static void ptrace_do_notify(int signr, int exit_code, int why)
 void ptrace_notify(int exit_code)
 {
 	BUG_ON((exit_code & (0x7f | ~0xffff)) != SIGTRAP);
-	if (unlikely(current->task_works)) {
-		if (test_and_clear_ti_thread_flag(current_thread_info(),
-						   TIF_NOTIFY_RESUME)) {
-			smp_mb__after_clear_bit();
-			task_work_run();
-		}
-	}
+	if (unlikely(current->task_works))
+		task_work_run();
 
 	spin_lock_irq(&current->sighand->siglock);
 	ptrace_do_notify(SIGTRAP, exit_code, CLD_TRAPPED);
@@ -2198,13 +2193,8 @@ int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
 	struct signal_struct *signal = current->signal;
 	int signr;
 
-	if (unlikely(current->task_works)) {
-		if (test_and_clear_ti_thread_flag(current_thread_info(),
-						   TIF_NOTIFY_RESUME)) {
-			smp_mb__after_clear_bit();
-			task_work_run();
-		}
-	}
+	if (unlikely(current->task_works))
+		task_work_run();
 
 	if (unlikely(uprobe_deny_signal()))
 		return 0;
diff --git a/kernel/task_work.c b/kernel/task_work.c
index d320d44..65bd3c9 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -2,26 +2,20 @@
 #include <linux/task_work.h>
 #include <linux/tracehook.h>
 
+static struct callback_head work_exited; /* all we need is ->next == NULL */
+
 int
-task_work_add(struct task_struct *task, struct callback_head *twork, bool notify)
+task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
 {
-	struct callback_head *last, *first;
-	unsigned long flags;
+	struct callback_head *head;
 
-	/*
-	 * Not inserting the new work if the task has already passed
-	 * exit_task_work() is the responisbility of callers.
-	 */
-	raw_spin_lock_irqsave(&task->pi_lock, flags);
-	last = task->task_works;
-	first = last ? last->next : twork;
-	twork->next = first;
-	if (last)
-		last->next = twork;
-	task->task_works = twork;
-	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+	do {
+		head = ACCESS_ONCE(task->task_works);
+		if (unlikely(head == &work_exited))
+			return -ESRCH;
+		work->next = head;
+	} while (cmpxchg(&task->task_works, head, work) != head);
 
-	/* test_and_set_bit() implies mb(), see tracehook_notify_resume(). */
 	if (notify)
 		set_notify_resume(task);
 	return 0;
@@ -30,52 +24,69 @@ task_work_add(struct task_struct *task, struct callback_head *twork, bool notify
 struct callback_head *
 task_work_cancel(struct task_struct *task, task_work_func_t func)
 {
+	struct callback_head **pprev = &task->task_works;
+	struct callback_head *work = NULL;
 	unsigned long flags;
-	struct callback_head *last, *res = NULL;
-
+	/*
+	 * If cmpxchg() fails we continue without updating pprev.
+	 * Either we raced with task_work_add() which added the
+	 * new entry before this work, we will find it again. Or
+	 * we raced with task_work_run(), *pprev == NULL/exited.
+	 */
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
-	last = task->task_works;
-	if (last) {
-		struct callback_head *q = last, *p = q->next;
-		while (1) {
-			if (p->func == func) {
-				q->next = p->next;
-				if (p == last)
-					task->task_works = q == p ? NULL : q;
-				res = p;
-				break;
-			}
-			if (p == last)
-				break;
-			q = p;
-			p = q->next;
-		}
+	while ((work = ACCESS_ONCE(*pprev))) {
+		read_barrier_depends();
+		if (work->func != func)
+			pprev = &work->next;
+		else if (cmpxchg(pprev, work, work->next) == work)
+			break;
 	}
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
-	return res;
+
+	return work;
 }
 
 void task_work_run(void)
 {
 	struct task_struct *task = current;
-	struct callback_head *p, *q;
+	struct callback_head *work, *head, *next;
+
+	for (;;) {
+		/*
+		 * work->func() can do task_work_add(), do not set
+		 * work_exited unless the list is empty.
+		 */
+		do {
+			work = ACCESS_ONCE(task->task_works);
+			head = !work && (task->flags & PF_EXITING) ?
+				&work_exited : NULL;
+		} while (cmpxchg(&task->task_works, work, head) != work);
 
-	while (1) {
-		raw_spin_lock_irq(&task->pi_lock);
-		p = task->task_works;
-		task->task_works = NULL;
-		raw_spin_unlock_irq(&task->pi_lock);
+		if (!work)
+			break;
+		/*
+		 * Synchronize with task_work_cancel(). It can't remove
+		 * the first entry == work, cmpxchg(task_works) should
+		 * fail, but it can play with *work and other entries.
+		 */
+		raw_spin_unlock_wait(&task->pi_lock);
+		smp_mb();
 
-		if (unlikely(!p))
-			return;
+		/* Reverse the list to run the works in fifo order */
+		head = NULL;
+		do {
+			next = work->next;
+			work->next = head;
+			head = work;
+			work = next;
+		} while (work);
 
-		q = p->next; /* head */
-		p->next = NULL; /* cut it */
-		while (q) {
-			p = q->next;
-			q->func(q);
-			q = p;
+		work = head;
+		do {
+			next = work->next;
+			work->func(work);
+			work = next;
 			cond_resched();
-		}
+		} while (work);
 	}
 }
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 3364fbf..6cfc647 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1486,7 +1486,6 @@ long keyctl_session_to_parent(void)
 	oldwork = NULL;
 	parent = me->real_parent;
 
-	task_lock(parent);
 	/* the parent mustn't be init and mustn't be a kernel thread */
 	if (parent->pid <= 1 || !parent->mm)
 		goto unlock;
@@ -1530,7 +1529,6 @@ long keyctl_session_to_parent(void)
 	if (!ret)
 		newwork = NULL;
 unlock:
-	task_unlock(parent);
 	write_unlock_irq(&tasklist_lock);
 	rcu_read_unlock();
 	if (oldwork)
