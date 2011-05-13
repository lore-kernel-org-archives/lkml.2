Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458Ab1EMPq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 11:46:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47953 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933060Ab1EMPqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 11:46:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=N8KKGIVvKnp6nk2WvfhwFhJzo89I9MdMX+gpn8KZ68QrTv8dk8sfVYrBMH1oPYWz3z
         7Lat5Q0dNDoQDb4f6UORn/vtKd53G1LmnXGxL8DGC7QXYmIqi2EsIJWSySKKXsyal4Dx
         0t/I+i2Jim1F1nL9J4X4eGbAPzm8LxRPQdK00=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 8/9] ptrace: move JOBCTL_TRAPPING wait to wait(2) and ptrace_check_attach()
Date: Fri, 13 May 2011 17:46:19 +0200
Message-Id: <1305301580-9924-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1305301580-9924-1-git-send-email-tj@kernel.org>
References: <1305301580-9924-1-git-send-email-tj@kernel.org>
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

TRAPPING will also be used to implement ptrace notification re-traps,
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

Both ptrace(2) and wait(2) use restart_syscall() to retry after
waiting for TRAPPING.  This simplifies the implementation and will be
useful when TRAPPING sleep is converted to be interruptible.

Note that, after this change, PTRACE_ATTACH may return before the
transition completes and the ptracer might see the tracee in transient
TASK_RUNNING state via /proc/PID/stat; however, wait(2) and the
following ptrace requests would behave correctly regardless.  This is
userland visible behavior change.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/ptrace.h |    1 +
 kernel/exit.c          |   18 ++++++++++++++++--
 kernel/ptrace.c        |   48 +++++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 60 insertions(+), 7 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 974e187..6b359cd 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -105,6 +105,7 @@ extern long arch_ptrace(struct task_struct *child, long request,
 extern int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len);
 extern int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long dst, int len);
 extern void ptrace_disable(struct task_struct *);
+extern bool ptrace_wait_trapping(struct task_struct *child);
 extern int ptrace_check_attach(struct task_struct *task, bool ignore_state);
 extern int ptrace_request(struct task_struct *child, long request,
 			  unsigned long addr, unsigned long data);
diff --git a/kernel/exit.c b/kernel/exit.c
index 3383793..b57cb14 100644
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
+	 * Note that we can avoid unconditionally grabbing siglock by
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
+			return restart_syscall();
 		goto unlock_sig;
+	}
 
 	exit_code = *p_code;
 	if (!exit_code)
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 41fd45e..03349b5 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -30,6 +30,47 @@ static int ptrace_trapping_sleep_fn(void *flags)
 	return 0;
 }
 
+/**
+ * ptrace_wait_trapping - wait ptracee to finish %TASK_TRACED/STOPPED transition
+ * @child: child to wait for
+ *
+ * There are cases where ptracer needs to ask the ptracee to [re]enter
+ * %TASK_TRACED which involves the tracee going through %TASK_RUNNING
+ * briefly, which could affect operation of ptrace(2) and wait(2).
+ *
+ * %JOBCTL_TRAPPING is used to hide such transitions from the ptracer.
+ * It's set when such transition is initiated by the ptracer and cleared on
+ * completion.  Operations which may be affected should call this function
+ * to make sure no transition is in progress before proceeding.
+ *
+ * This function checks whether @child is TRAPPING and, if so, waits for
+ * the transition to complete.
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
+	wait_on_bit(&child->jobctl, ilog2(JOBCTL_TRAPPING),
+		    ptrace_trapping_sleep_fn, TASK_UNINTERRUPTIBLE);
+	put_task_struct(child);
+	return true;
+}
+
 /*
  * ptrace a task: make the debugger its new parent and
  * move it to the ptrace list.
@@ -140,6 +181,8 @@ int ptrace_check_attach(struct task_struct *child, bool ignore_state)
 		WARN_ON_ONCE(task_is_stopped(child));
 		if (task_is_traced(child) || ignore_state)
 			ret = 0;
+		else if (ptrace_wait_trapping(child))
+			return restart_syscall();
 		spin_unlock_irq(&child->sighand->siglock);
 	}
 	read_unlock(&tasklist_lock);
@@ -203,7 +246,6 @@ bool ptrace_may_access(struct task_struct *task, unsigned int mode)
 
 static int ptrace_attach(struct task_struct *task)
 {
-	bool wait_trap = false;
 	int retval;
 
 	audit_ptrace(task);
@@ -265,7 +307,6 @@ static int ptrace_attach(struct task_struct *task)
 	if (task_is_stopped(task)) {
 		task->jobctl |= JOBCTL_STOP_PENDING | JOBCTL_TRAPPING;
 		signal_wake_up(task, 1);
-		wait_trap = true;
 	}
 
 	spin_unlock(&task->sighand->siglock);
@@ -276,9 +317,6 @@ unlock_tasklist:
 unlock_creds:
 	mutex_unlock(&task->signal->cred_guard_mutex);
 out:
-	if (wait_trap)
-		wait_on_bit(&task->jobctl, ilog2(JOBCTL_TRAPPING),
-			    ptrace_trapping_sleep_fn, TASK_UNINTERRUPTIBLE);
 	return retval;
 }
 
-- 
1.7.1

