Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab1E2XPk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 19:15:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56170 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab1E2XNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 19:13:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=UGwx7adJ+XH3dMO+7YJlUYng287shPOLrui62tAY9i3HgLJ2ppyo8GKe6eB17m3hb3
         Ycjd/vGCbHVNyv2QadknfAoRnZsMZx7E6zRYw4DM1EfWiBa3ArkuOuoTcu0USqwWzNkv
         zSWLom6buuJ7KUKNGt68fCWBGe9yCMt9oCf/A=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/17] job control: introduce JOBCTL_TRAP_STOP and use it for group stop trap
Date: Mon, 30 May 2011 01:12:33 +0200
Message-Id: <1306710760-16440-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1306710760-16440-1-git-send-email-tj@kernel.org>
References: <1306710760-16440-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_signal_stop() implemented both normal group stop and trap for group
stop while ptraced.  This approach has been enough but scheduled
changes require trap mechanism which can be used in more generic
manner and using group stop trap for generic trap site simplifies both
userland visible interface and implementation.

This patch adds a new jobctl flag - JOBCTL_TRAP_STOP.  When set, it
triggers a trap site, which behaves like group stop trap, in
get_signal_to_deliver() after checking for pending signals.  While
ptraced, do_signal_stop() doesn't stop itself.  It initiates group
stop if requested and schedules JOBCTL_TRAP_STOP and returns.  The
caller - get_signal_to_deliver() - is responsible for checking whether
TRAP_STOP is pending afterwards and handling it.

ptrace_attach() is updated to use JOBCTL_TRAP_STOP instead of
JOBCTL_STOP_PENDING and __ptrace_unlink() to clear all pending trap
bits and TRAPPING so that TRAP_STOP and future trap bits don't linger
after detach.

While at it, add proper function comment to do_signal_stop() and make
it return bool.

-v2: __ptrace_unlink() updated to clear JOBCTL_TRAP_MASK and TRAPPING
     instead of JOBCTL_PENDING_MASK.  This avoids accidentally
     clearing JOBCTL_STOP_CONSUME.  Spotted by Oleg.

-v3: do_signal_stop() updated to return %false without dropping
     siglock while ptraced and TRAP_STOP check moved inside for(;;)
     loop after group stop participation.  This avoids unnecessary
     relocking and also will help avoiding unnecessary traps by
     consuming group stop before handling pending traps.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/sched.h |    6 +++-
 kernel/ptrace.c       |   12 +++++--
 kernel/signal.c       |   83 ++++++++++++++++++++++++++++++------------------
 3 files changed, 66 insertions(+), 35 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index bc7a380..20f392b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1810,17 +1810,21 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define JOBCTL_STOP_DEQUEUED_BIT 16	/* stop signal dequeued */
 #define JOBCTL_STOP_PENDING_BIT	17	/* task should stop for group stop */
 #define JOBCTL_STOP_CONSUME_BIT	18	/* consume group stop count */
+#define JOBCTL_TRAP_STOP_BIT	19	/* trap for STOP */
 #define JOBCTL_TRAPPING_BIT	21	/* switching to TRACED */
 
 #define JOBCTL_STOP_DEQUEUED	(1 << JOBCTL_STOP_DEQUEUED_BIT)
 #define JOBCTL_STOP_PENDING	(1 << JOBCTL_STOP_PENDING_BIT)
 #define JOBCTL_STOP_CONSUME	(1 << JOBCTL_STOP_CONSUME_BIT)
+#define JOBCTL_TRAP_STOP	(1 << JOBCTL_TRAP_STOP_BIT)
 #define JOBCTL_TRAPPING		(1 << JOBCTL_TRAPPING_BIT)
 
-#define JOBCTL_PENDING_MASK	JOBCTL_STOP_PENDING
+#define JOBCTL_TRAP_MASK	JOBCTL_TRAP_STOP
+#define JOBCTL_PENDING_MASK	(JOBCTL_STOP_PENDING | JOBCTL_TRAP_MASK)
 
 extern bool task_set_jobctl_pending(struct task_struct *task,
 				    unsigned int mask);
+extern void task_clear_jobctl_trapping(struct task_struct *task);
 extern void task_clear_jobctl_pending(struct task_struct *task,
 				      unsigned int mask);
 
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 82f566b..2ac7260 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -83,6 +83,13 @@ void __ptrace_unlink(struct task_struct *child)
 	spin_lock(&child->sighand->siglock);
 
 	/*
+	 * Clear all pending traps and TRAPPING.  TRAPPING should be
+	 * cleared regardless of JOBCTL_STOP_PENDING.  Do it explicitly.
+	 */
+	task_clear_jobctl_pending(child, JOBCTL_TRAP_MASK);
+	task_clear_jobctl_trapping(child);
+
+	/*
 	 * Reinstate JOBCTL_STOP_PENDING if group stop is in effect and
 	 * @child isn't dead.
 	 */
@@ -246,7 +253,7 @@ static int ptrace_attach(struct task_struct *task)
 	spin_lock(&task->sighand->siglock);
 
 	/*
-	 * If the task is already STOPPED, set JOBCTL_STOP_PENDING and
+	 * If the task is already STOPPED, set JOBCTL_TRAP_STOP and
 	 * TRAPPING, and kick it so that it transits to TRACED.  TRAPPING
 	 * will be cleared if the child completes the transition or any
 	 * event which clears the group stop states happens.  We'll wait
@@ -263,8 +270,7 @@ static int ptrace_attach(struct task_struct *task)
 	 * in and out of STOPPED are protected by siglock.
 	 */
 	if (task_is_stopped(task) &&
-	    task_set_jobctl_pending(task,
-				    JOBCTL_STOP_PENDING | JOBCTL_TRAPPING))
+	    task_set_jobctl_pending(task, JOBCTL_TRAP_STOP | JOBCTL_TRAPPING))
 		signal_wake_up(task, 1);
 
 	spin_unlock(&task->sighand->siglock);
diff --git a/kernel/signal.c b/kernel/signal.c
index c99b8b5..262bb6c 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -266,7 +266,7 @@ bool task_set_jobctl_pending(struct task_struct *task, unsigned int mask)
  * CONTEXT:
  * Must be called with @task->sighand->siglock held.
  */
-static void task_clear_jobctl_trapping(struct task_struct *task)
+void task_clear_jobctl_trapping(struct task_struct *task)
 {
 	if (unlikely(task->jobctl & JOBCTL_TRAPPING)) {
 		task->jobctl &= ~JOBCTL_TRAPPING;
@@ -1790,13 +1790,16 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	/*
 	 * If @why is CLD_STOPPED, we're trapping to participate in a group
 	 * stop.  Do the bookkeeping.  Note that if SIGCONT was delievered
-	 * while siglock was released for the arch hook, PENDING could be
-	 * clear now.  We act as if SIGCONT is received after TASK_TRACED
-	 * is entered - ignore it.
+	 * across siglock relocks since INTERRUPT was scheduled, PENDING
+	 * could be clear now.  We act as if SIGCONT is received after
+	 * TASK_TRACED is entered - ignore it.
 	 */
 	if (why == CLD_STOPPED && (current->jobctl & JOBCTL_STOP_PENDING))
 		gstop_done = task_participate_group_stop(current);
 
+	/* any trap clears pending STOP trap */
+	task_clear_jobctl_pending(current, JOBCTL_TRAP_STOP);
+
 	/* entering a trap, clear TRAPPING */
 	task_clear_jobctl_trapping(current);
 
@@ -1888,13 +1891,30 @@ void ptrace_notify(int exit_code)
 	spin_unlock_irq(&current->sighand->siglock);
 }
 
-/*
- * This performs the stopping for SIGSTOP and other stop signals.
- * We have to stop all threads in the thread group.
- * Returns non-zero if we've actually stopped and released the siglock.
- * Returns zero if we didn't stop and still hold the siglock.
+/**
+ * do_signal_stop - handle group stop for SIGSTOP and other stop signals
+ * @signr: signr causing group stop if initiating
+ *
+ * If %JOBCTL_STOP_PENDING is not set yet, initiate group stop with @signr
+ * and participate in it.  If already set, participate in the existing
+ * group stop.  If participated in a group stop (and thus slept), %true is
+ * returned with siglock released.
+ *
+ * If ptraced, this function doesn't handle stop itself.  Instead,
+ * %JOBCTL_TRAP_STOP is scheduled and %false is returned with siglock
+ * untouched.  The caller must ensure that INTERRUPT trap handling takes
+ * places afterwards.
+ *
+ * CONTEXT:
+ * Must be called with @current->sighand->siglock held, which is released
+ * on %true return.
+ *
+ * RETURNS:
+ * %false if group stop is already cancelled or ptrace trap is scheduled.
+ * %true if participated in group stop.
  */
-static int do_signal_stop(int signr)
+static bool do_signal_stop(int signr)
+	__releases(&current->sighand->siglock)
 {
 	struct signal_struct *sig = current->signal;
 
@@ -1907,7 +1927,7 @@ static int do_signal_stop(int signr)
 
 		if (!likely(current->jobctl & JOBCTL_STOP_DEQUEUED) ||
 		    unlikely(signal_group_exit(sig)))
-			return 0;
+			return false;
 		/*
 		 * There is no group stop already in progress.  We must
 		 * initiate one now.
@@ -1951,7 +1971,7 @@ static int do_signal_stop(int signr)
 			}
 		}
 	}
-retry:
+
 	if (likely(!task_ptrace(current))) {
 		int notify = 0;
 
@@ -1983,27 +2003,15 @@ retry:
 
 		/* Now we don't run again until woken by SIGCONT or SIGKILL */
 		schedule();
-
-		spin_lock_irq(&current->sighand->siglock);
+		return true;
 	} else {
-		ptrace_stop(current->jobctl & JOBCTL_STOP_SIGMASK,
-			    CLD_STOPPED, 0, NULL);
-		current->exit_code = 0;
-	}
-
-	/*
-	 * JOBCTL_STOP_PENDING could be set if another group stop has
-	 * started since being woken up or ptrace wants us to transit
-	 * between TASK_STOPPED and TRACED.  Retry group stop.
-	 */
-	if (current->jobctl & JOBCTL_STOP_PENDING) {
-		WARN_ON_ONCE(!(current->jobctl & JOBCTL_STOP_SIGMASK));
-		goto retry;
+		/*
+		 * While ptraced, group stop is handled by STOP trap.
+		 * Schedule it and let the caller deal with it.
+		 */
+		task_set_jobctl_pending(current, JOBCTL_TRAP_STOP);
+		return false;
 	}
-
-	spin_unlock_irq(&current->sighand->siglock);
-
-	return 1;
 }
 
 static int ptrace_signal(int signr, siginfo_t *info,
@@ -2110,6 +2118,19 @@ relock:
 		    do_signal_stop(0))
 			goto relock;
 
+		/*
+		 * Take care of ptrace jobctl traps.  It is currently used
+		 * only to trap for group stop while ptraced.
+		 */
+		if (unlikely(current->jobctl & JOBCTL_TRAP_MASK)) {
+			signr = current->jobctl & JOBCTL_STOP_SIGMASK;
+			WARN_ON_ONCE(!signr);
+			ptrace_stop(signr, CLD_STOPPED, 0, NULL);
+			current->exit_code = 0;
+			spin_unlock_irq(&sighand->siglock);
+			goto relock;
+		}
+
 		signr = dequeue_signal(current, &current->blocked, info);
 
 		if (!signr)
-- 
1.7.5.2

