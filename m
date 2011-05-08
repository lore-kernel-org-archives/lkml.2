Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab1EHPtk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 11:49:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42994 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab1EHPte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 11:49:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ISfcQaK5zYdEMlU35vdYc7+KOFiUatz4lnbZtUUy8zgKCncweP69WrXAnzkY/VDFqs
         iakpSm9DZZuRKPTX3OLw4hqlqxS/VzbntDROc/tnTK+xvHEdlPleKmhpfffESFXPJApn
         qjs6oURXQj4+5OZNxcTLmLB5sc6FX5F92bzd0=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/11] ptrace: move JOBCTL_TRAPPING wait to wait(2) and ptrace_check_attach()
Date: Sun,  8 May 2011 17:49:04 +0200
Message-Id: <1304869745-1073-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304869745-1073-1-git-send-email-tj@kernel.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, JOBCTL_TRAPPING is used by PTRACE_ATTACH and SEIZE to hide
TASK_STOPPED -> TRACED transition from ptracer.  If tracee is in group
stop, TRAPPING is set, tracee is kicked and tracer waits for the
transition to complete before completing attach.  This prevents tracer
from seeing tracee during transition.

The transition is visible only through wait(2) and following ptrace(2)
requests.  Without TRAPPING, WNOHANG which should succeed right after
attach (when tracer knows tracee was stopped) might fail and likewise
for the following ptrace requests.

TRAPPING will also be used to implement end of group stop retrapping,
which can be initiated by tasks other than tracer.  To allow this,
this patch moves TRAPPING wait from attach completion path to
operations which are actually affected by the transition - wait(2) and
following ptrace(2) requests.

As reliably checking and modifying TASK_STOPPED/TRACED transition
together with JOBCTL_TRAPPING require siglock and both ptrace and wait
paths are holding tasklist_lock and siglock where TRAPPING check is
needed, ptrace_wait_trapping() assumes both locks to be held on entry
and releases them if it actually had to wait for TRAPPING.

Both wait and ptrace paths are updated to retry the operation after
TRAPPING wait.  Note that wait_task_stopped() now always grabs siglock
for ptrace waits.  This can be avoided with "task_stopped_code() ->
rmb() -> TRAPPING -> rmb() -> task_stopped_code()" sequence but given
that ptrace isn't particularly sensitive to performance or
scalability, choosing simpler implementation seems better.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/ptrace.h |    1 +
 include/linux/sched.h  |    2 +-
 kernel/exit.c          |   21 +++++++++++++++++++--
 kernel/ptrace.c        |   48 +++++++++++++++++++++++++++++++++++++++++++++---
 kernel/signal.c        |    5 +++--
 5 files changed, 69 insertions(+), 8 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 567e189..4b42a15 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -116,6 +116,7 @@ extern long arch_ptrace(struct task_struct *child, long request,
 extern int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len);
 extern int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long dst, int len);
 extern void ptrace_disable(struct task_struct *);
+extern bool ptrace_wait_trapping(struct task_struct *child);
 extern int ptrace_check_attach(struct task_struct *task, bool ignore_state);
 extern int ptrace_request(struct task_struct *child, long request,
 			  unsigned long addr, unsigned long data);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9d92444..972f1db 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1786,7 +1786,7 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define JOBCTL_STOP_CONSUME	(1 << 18) /* consume group stop count */
 #define JOBCTL_TRAP_SEIZE	(1 << 19) /* trap for seize */
 #define JOBCTL_TRAP_INTERRUPT	(1 << 20) /* trap for interrupt */
-#define JOBCTL_TRAPPING		(1 << 22) /* switching to TRACED */
+#define JOBCTL_TRAPPING		(1 << 22) /* switching to TRACED/STOPPED */
 #define JOBCTL_TRAPPED		(1 << 23) /* trapped for group stop */
 
 #define JOBCTL_TRAP_MASK	(JOBCTL_TRAP_SEIZE | JOBCTL_TRAP_INTERRUPT)
diff --git a/kernel/exit.c b/kernel/exit.c
index 3383793..a43af3a 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1409,15 +1409,29 @@ static int wait_task_stopped(struct wait_opts *wo,
 	if (!ptrace && !(wo->wo_flags & WUNTRACED))
 		return 0;
 
-	if (!task_stopped_code(p, ptrace))
+	/*
+	 * For ptrace waits, we can't reliably check whether wait condition
+	 * exists without grabbing siglock due to JOBCTL_TRAPPING
+	 * transitions.  A task might be temporarily in TASK_RUNNING while
+	 * trapping which should be transparent to the ptracer.
+	 *
+	 * Note that we can avoid unconditionally grabbing siglock with by
+	 * wrapping TRAPPING test with two rmb's; however, let's stick with
+	 * simpler implementation for now.
+	 */
+	if (!ptrace && !(p->signal->flags & SIGNAL_STOP_STOPPED))
 		return 0;
 
 	exit_code = 0;
 	spin_lock_irq(&p->sighand->siglock);
 
 	p_code = task_stopped_code(p, ptrace);
-	if (unlikely(!p_code))
+	if (unlikely(!p_code)) {
+		/* if trapping, wait for it and restart the whole process */
+		if (ptrace && ptrace_wait_trapping(p))
+			return -EAGAIN;
 		goto unlock_sig;
+	}
 
 	exit_code = *p_code;
 	if (!exit_code)
@@ -1740,6 +1754,9 @@ notask:
 		}
 	}
 end:
+	/* -EAGAIN if we hit trapping ptracee and slept - retry */
+	if (unlikely(retval == -EAGAIN))
+		goto repeat;
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
 	return retval;
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index b18a9b3..7411eb2 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -103,6 +103,48 @@ void __ptrace_unlink(struct task_struct *child)
 }
 
 /**
+ * ptrace_wait_trapping - wait ptracee to finish %TASK_TRACED/STOPPED transition
+ * @child: child to wait for
+ *
+ * There are cases where ptracer needs to ask the ptracee to [re]enter
+ * %TASK_TRACED or %TASK_STOPPED which involves the tracee going through
+ * %TASK_RUNNING briefly, which could affect operation of ptrace(2) and
+ * wait(2).
+ *
+ * %JOBCTL_TRAPPING is used to hide such transitions from the ptracer.
+ * It's set when such transition is initiated by the ptracer and cleared on
+ * completion.  Operations which may be affected should call this function
+ * to make sure no transition is in progress before proceeding.
+ *
+ * This function checks whether @child is trapping and if so waits for the
+ * transition to complete.
+ *
+ * CONTEXT:
+ * read_lock(&tasklist_lock) and spin_lock_irq(&child->sighand->siglock).
+ * On %true return, both locks are released and the function might have
+ * slept.
+ *
+ * RETURNS:
+ * %false if @child wasn't trapping and nothing happened.  %true if waited
+ * for trapping transition and released both locks.
+ */
+bool ptrace_wait_trapping(struct task_struct *child)
+	__releases(&child->sighand->siglock)
+	__releases(&tasklist_lock)
+{
+	if (likely(!(child->jobctl & JOBCTL_TRAPPING)))
+		return false;
+
+	spin_unlock_irq(&child->sighand->siglock);
+	get_task_struct(child);
+	read_unlock(&tasklist_lock);
+	wait_event(current->signal->wait_chldexit,
+		   !(child->jobctl & JOBCTL_TRAPPING));
+	put_task_struct(child);
+	return true;
+}
+
+/**
  * ptrace_check_attach - check whether ptracee is ready for ptrace operation
  * @child: ptracee to check for
  * @ignore_state: don't check whether @child is currently %TASK_TRACED
@@ -122,7 +164,7 @@ void __ptrace_unlink(struct task_struct *child)
 int ptrace_check_attach(struct task_struct *child, bool ignore_state)
 {
 	int ret = -ESRCH;
-
+retry:
 	/*
 	 * We take the read lock around doing both checks to close a
 	 * possible race where someone else was tracing our child and
@@ -140,6 +182,8 @@ int ptrace_check_attach(struct task_struct *child, bool ignore_state)
 		WARN_ON_ONCE(task_is_stopped(child));
 		if (task_is_traced(child) || ignore_state)
 			ret = 0;
+		else if (ptrace_wait_trapping(child))
+			goto retry;
 		spin_unlock_irq(&child->sighand->siglock);
 	}
 	read_unlock(&tasklist_lock);
@@ -304,8 +348,6 @@ unlock_tasklist:
 unlock_creds:
 	mutex_unlock(&task->signal->cred_guard_mutex);
 out:
-	wait_event(current->signal->wait_chldexit,
-			   !(task->jobctl & JOBCTL_TRAPPING));
 	return retval;
 }
 
diff --git a/kernel/signal.c b/kernel/signal.c
index a7f65a6..dce2961 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -228,8 +228,9 @@ static inline void print_dropped_signal(int sig)
  * @task: target task
  *
  * If %JOBCTL_TRAPPING is set, ptracer is waiting for us to enter
- * %TASK_TRACED.  It can be set only while we're inside do_signal_stop()
- * and must be cleared before leaving signal delivery path.
+ * %TASK_TRACED or %TASK_STOPPED.  It can be set only while we're inside
+ * do_signal_stop() and must be cleared before leaving signal delivery
+ * path.
  *
  * Clear it and wake up the ptracer.  Note that we don't need any further
  * locking.  @task->siglock guarantees that @task->parent points to the
-- 
1.7.1

