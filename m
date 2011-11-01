Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab1KAAiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 20:38:06 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:53434 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab1KAAiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 20:38:03 -0400
Date: Mon, 31 Oct 2011 17:37:58 -0700
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH pm 2/2] freezer: kill unused set_freezable_with_signal()
Message-ID: <20111101003758.GN18855@google.com>
References: <20111101003726.GM18855@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111101003726.GM18855@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no in-kernel user of set_freezable_with_signal() left.  Mixing
TIF_SIGPENDING with kernel threads can lead to nasty corner cases as
kernel threads never travel signal delivery path on their own.

e.g. the current implementation is buggy in the cancelation path of
__thaw_task().  It calls recalc_sigpending_and_wake() in an attempt to
clear TIF_SIGPENDING but the function never clears it regardless of
sigpending state.  This means that signallable freezable kthreads may
continue executing with !freezing() && stuck TIF_SIGPENDING, which can
be troublesome.

This patch removes set_freezable_with_signal() along with
PF_FREEZER_NOSIG and recalc_sigpending*() calls in freezer.  User
tasks get TIF_SIGPENDING, kernel tasks get woken up and the spurious
sigpending is dealt with in the usual signal delivery path.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/freezer.h |   20 +-------------------
 include/linux/sched.h   |    1 -
 kernel/freezer.c        |   27 ++++++---------------------
 kernel/kthread.c        |    2 +-
 4 files changed, 8 insertions(+), 42 deletions(-)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index 4b3dc4c..5f32321 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -49,7 +49,7 @@ static inline bool try_to_freeze(void)
 }
 
 extern bool freeze_task(struct task_struct *p);
-extern bool __set_freezable(bool with_signal);
+extern bool set_freezable(void);
 
 #ifdef CONFIG_CGROUP_FREEZER
 extern bool cgroup_freezing(struct task_struct *task);
@@ -105,23 +105,6 @@ static inline int freezer_should_skip(struct task_struct *p)
 }
 
 /*
- * Tell the freezer that the current task should be frozen by it
- */
-static inline bool set_freezable(void)
-{
-	return __set_freezable(false);
-}
-
-/*
- * Tell the freezer that the current task should be frozen by it and that it
- * should send a fake signal to the task to freeze it.
- */
-static inline bool set_freezable_with_signal(void)
-{
-	return __set_freezable(true);
-}
-
-/*
  * Freezer-friendly wrappers around wait_event_interruptible(),
  * wait_event_killable() and wait_event_interruptible_timeout(), originally
  * defined in <linux/wait.h>
@@ -181,7 +164,6 @@ static inline void freezer_do_not_count(void) {}
 static inline void freezer_count(void) {}
 static inline int freezer_should_skip(struct task_struct *p) { return 0; }
 static inline void set_freezable(void) {}
-static inline void set_freezable_with_signal(void) {}
 
 #define wait_event_freezable(wq, condition)				\
 		wait_event_interruptible(wq, condition)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 57f916d..84fd546 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1781,7 +1781,6 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
 #define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezable */
-#define PF_FREEZER_NOSIG 0x80000000	/* Freezer won't send signals to it */
 
 /*
  * Only the _current_ task can read/write to tsk->flags, but other
diff --git a/kernel/freezer.c b/kernel/freezer.c
index 0845321..128c5aa 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -39,7 +39,7 @@ bool freezing_slow_path(struct task_struct *p)
 	if (pm_nosig_freezing || cgroup_freezing(p))
 		return true;
 
-	if (pm_freezing && !(p->flags & PF_FREEZER_NOSIG))
+	if (pm_freezing && !(p->flags & PF_KTHREAD))
 		return true;
 
 	return false;
@@ -72,10 +72,6 @@ bool __refrigerator(bool check_kthr_stop)
 		schedule();
 	}
 
-	spin_lock_irq(&current->sighand->siglock);
-	recalc_sigpending(); /* We sent fake signal, clean it up */
-	spin_unlock_irq(&current->sighand->siglock);
-
 	pr_debug("%s left refrigerator\n", current->comm);
 
 	/*
@@ -120,7 +116,7 @@ bool freeze_task(struct task_struct *p)
 		return false;
 	}
 
-	if (!(p->flags & PF_FREEZER_NOSIG)) {
+	if (!(p->flags & PF_KTHREAD)) {
 		fake_signal_wake_up(p);
 		/*
 		 * fake_signal_wake_up() goes through p's scheduler
@@ -145,28 +141,19 @@ void __thaw_task(struct task_struct *p)
 	 * be visible to @p as waking up implies wmb.  Waking up inside
 	 * freezer_lock also prevents wakeups from leaking outside
 	 * refrigerator.
-	 *
-	 * If !FROZEN, @p hasn't reached refrigerator, recalc sigpending to
-	 * avoid leaving dangling TIF_SIGPENDING behind.
 	 */
 	spin_lock_irqsave(&freezer_lock, flags);
-	if (frozen(p)) {
+	if (frozen(p))
 		wake_up_process(p);
-	} else {
-		spin_lock(&p->sighand->siglock);
-		recalc_sigpending_and_wake(p);
-		spin_unlock(&p->sighand->siglock);
-	}
 	spin_unlock_irqrestore(&freezer_lock, flags);
 }
 
 /**
- * __set_freezable - make %current freezable
- * @with_signal: do we want %TIF_SIGPENDING for notification too?
+ * set_freezable - make %current freezable
  *
  * Mark %current freezable and enter refrigerator if necessary.
  */
-bool __set_freezable(bool with_signal)
+bool set_freezable(void)
 {
 	might_sleep();
 
@@ -177,10 +164,8 @@ bool __set_freezable(bool with_signal)
 	 */
 	spin_lock_irq(&freezer_lock);
 	current->flags &= ~PF_NOFREEZE;
-	if (with_signal)
-		current->flags &= ~PF_FREEZER_NOSIG;
 	spin_unlock_irq(&freezer_lock);
 
 	return try_to_freeze();
 }
-EXPORT_SYMBOL(__set_freezable);
+EXPORT_SYMBOL(set_freezable);
diff --git a/kernel/kthread.c b/kernel/kthread.c
index a6cbeea..7a4c862 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -282,7 +282,7 @@ int kthreadd(void *unused)
 	set_cpus_allowed_ptr(tsk, cpu_all_mask);
 	set_mems_allowed(node_states[N_HIGH_MEMORY]);
 
-	current->flags |= PF_NOFREEZE | PF_FREEZER_NOSIG;
+	current->flags |= PF_NOFREEZE;
 
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
-- 
1.7.3.1

