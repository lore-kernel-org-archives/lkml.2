Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab1FQOwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:52:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64473 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759291Ab1FQOuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:50:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=G4E0aDu31RuEioIkTmCC76bqzIzvSl1e5wbwdPTLe5LhJVdaIMf7mSU7UTHyHYAyH4
         TvVYOUTiH2Jv656RjOU0LMv/KIECV5RVu5BHx3FmDsOKqHWObMy4Ur3CIfSsSnn1K7ob
         uUUgexWqmQsRbU5W6sTCbENdm7YKnXo0BMVLQ=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, oleg@redhat.com
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        hch@infradead.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/7] ptrace: kill clone/exec tracehooks
Date: Fri, 17 Jun 2011 16:50:38 +0200
Message-Id: <1308322240-8247-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1308322240-8247-1-git-send-email-tj@kernel.org>
References: <1308322240-8247-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At this point, tracehooks aren't useful to mainline kernel and mostly
just add an extra layer of obfuscation.  Although they have comments,
without actual in-kernel users, it is difficult to tell what are their
assumptions and they're actually trying to achieve.  To mainline
kernel, they just aren't worth keeping around.

This patch kills the following clone and exec related tracehooks.

	tracehook_prepare_clone()
	tracehook_finish_clone()
	tracehook_report_clone()
	tracehook_report_clone_complete()
	tracehook_unsafe_exec()

The changes are mostly trivial - logic is moved to the caller and
comments are merged and adjusted appropriately.

The only exception is in check_unsafe_exec() where LSM_UNSAFE_PTRACE*
are OR'd to bprm->unsafe instead of setting it, which produces the
same result as the field is always zero on entry.  It also tests
p->ptrace instead of (p->ptrace & PT_PTRACED) for consistency, which
also gives the same result.

This doesn't introduce any behavior change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
---
 fs/exec.c                 |    7 ++-
 include/linux/tracehook.h |  121 ---------------------------------------------
 kernel/fork.c             |   41 ++++++++++++---
 3 files changed, 38 insertions(+), 131 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index b37030d..8dca45b 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1224,7 +1224,12 @@ int check_unsafe_exec(struct linux_binprm *bprm)
 	unsigned n_fs;
 	int res = 0;
 
-	bprm->unsafe = tracehook_unsafe_exec(p);
+	if (p->ptrace) {
+		if (p->ptrace & PT_PTRACE_CAP)
+			bprm->unsafe |= LSM_UNSAFE_PTRACE_CAP;
+		else
+			bprm->unsafe |= LSM_UNSAFE_PTRACE;
+	}
 
 	n_fs = 1;
 	spin_lock(&p->fs->lock);
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 8b06d4f..bcc4ca7 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -130,27 +130,6 @@ static inline void tracehook_report_syscall_exit(struct pt_regs *regs, int step)
 }
 
 /**
- * tracehook_unsafe_exec - check for exec declared unsafe due to tracing
- * @task:		current task doing exec
- *
- * Return %LSM_UNSAFE_* bits applied to an exec because of tracing.
- *
- * @task->signal->cred_guard_mutex is held by the caller through the do_execve().
- */
-static inline int tracehook_unsafe_exec(struct task_struct *task)
-{
-	int unsafe = 0;
-	int ptrace = task->ptrace;
-	if (ptrace & PT_PTRACED) {
-		if (ptrace & PT_PTRACE_CAP)
-			unsafe |= LSM_UNSAFE_PTRACE_CAP;
-		else
-			unsafe |= LSM_UNSAFE_PTRACE;
-	}
-	return unsafe;
-}
-
-/**
  * tracehook_tracer_task - return the task that is tracing the given task
  * @tsk:		task to consider
  *
@@ -169,106 +148,6 @@ static inline struct task_struct *tracehook_tracer_task(struct task_struct *tsk)
 }
 
 /**
- * tracehook_prepare_clone - prepare for new child to be cloned
- * @clone_flags:	%CLONE_* flags from clone/fork/vfork system call
- *
- * This is called before a new user task is to be cloned.
- * Its return value will be passed to tracehook_finish_clone().
- *
- * Called with no locks held.
- */
-static inline int tracehook_prepare_clone(unsigned clone_flags)
-{
-	int event = 0;
-
-	if (clone_flags & CLONE_UNTRACED)
-		return 0;
-
-	if (clone_flags & CLONE_VFORK)
-		event = PTRACE_EVENT_VFORK;
-	else if ((clone_flags & CSIGNAL) != SIGCHLD)
-		event = PTRACE_EVENT_CLONE;
-	else
-		event = PTRACE_EVENT_FORK;
-
-	return ptrace_event_enabled(current, event) ? event : 0;
-}
-
-/**
- * tracehook_finish_clone - new child created and being attached
- * @child:		new child task
- * @clone_flags:	%CLONE_* flags from clone/fork/vfork system call
- * @trace:		return value from tracehook_prepare_clone()
- *
- * This is called immediately after adding @child to its parent's children list.
- * The @trace value is that returned by tracehook_prepare_clone().
- *
- * Called with current's siglock and write_lock_irq(&tasklist_lock) held.
- */
-static inline void tracehook_finish_clone(struct task_struct *child,
-					  unsigned long clone_flags, int trace)
-{
-	ptrace_init_task(child, (clone_flags & CLONE_PTRACE) || trace);
-}
-
-/**
- * tracehook_report_clone - in parent, new child is about to start running
- * @regs:		parent's user register state
- * @clone_flags:	flags from parent's system call
- * @pid:		new child's PID in the parent's namespace
- * @child:		new child task
- *
- * Called after a child is set up, but before it has been started running.
- * This is not a good place to block, because the child has not started
- * yet.  Suspend the child here if desired, and then block in
- * tracehook_report_clone_complete().  This must prevent the child from
- * self-reaping if tracehook_report_clone_complete() uses the @child
- * pointer; otherwise it might have died and been released by the time
- * tracehook_report_clone_complete() is called.
- *
- * Called with no locks held, but the child cannot run until this returns.
- */
-static inline void tracehook_report_clone(struct pt_regs *regs,
-					  unsigned long clone_flags,
-					  pid_t pid, struct task_struct *child)
-{
-	if (unlikely(child->ptrace)) {
-		/*
-		 * It doesn't matter who attached/attaching to this
-		 * task, the pending SIGSTOP is right in any case.
-		 */
-		sigaddset(&child->pending.signal, SIGSTOP);
-		set_tsk_thread_flag(child, TIF_SIGPENDING);
-	}
-}
-
-/**
- * tracehook_report_clone_complete - new child is running
- * @trace:		return value from tracehook_prepare_clone()
- * @regs:		parent's user register state
- * @clone_flags:	flags from parent's system call
- * @pid:		new child's PID in the parent's namespace
- * @child:		child task, already running
- *
- * This is called just after the child has started running.  This is
- * just before the clone/fork syscall returns, or blocks for vfork
- * child completion if @clone_flags has the %CLONE_VFORK bit set.
- * The @child pointer may be invalid if a self-reaping child died and
- * tracehook_report_clone() took no action to prevent it from self-reaping.
- *
- * Called with no locks held.
- */
-static inline void tracehook_report_clone_complete(int trace,
-						   struct pt_regs *regs,
-						   unsigned long clone_flags,
-						   pid_t pid,
-						   struct task_struct *child)
-{
-	if (unlikely(trace))
-		ptrace_event(trace, pid);
-}
-
-/**
  * tracehook_signal_handler - signal handler setup is complete
  * @sig:		number of signal being delivered
  * @info:		siginfo_t of signal being delivered
diff --git a/kernel/fork.c b/kernel/fork.c
index d4f0dff..3c72a5b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1340,7 +1340,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	}
 
 	if (likely(p->pid)) {
-		tracehook_finish_clone(p, clone_flags, trace);
+		ptrace_init_task(p, (clone_flags & CLONE_PTRACE) || trace);
 
 		if (thread_group_leader(p)) {
 			if (is_child_reaper(pid))
@@ -1481,10 +1481,22 @@ long do_fork(unsigned long clone_flags,
 	}
 
 	/*
-	 * When called from kernel_thread, don't do user tracing stuff.
+	 * Determine whether and which event to report to ptracer.  When
+	 * called from kernel_thread or CLONE_UNTRACED is explicitly
+	 * requested, no event is reported; otherwise, report if the event
+	 * for the type of forking is enabled.
 	 */
-	if (likely(user_mode(regs)))
-		trace = tracehook_prepare_clone(clone_flags);
+	if (likely(user_mode(regs)) && !(clone_flags & CLONE_UNTRACED)) {
+		if (clone_flags & CLONE_VFORK)
+			trace = PTRACE_EVENT_VFORK;
+		else if ((clone_flags & CSIGNAL) != SIGCHLD)
+			trace = PTRACE_EVENT_CLONE;
+		else
+			trace = PTRACE_EVENT_FORK;
+
+		if (likely(!ptrace_event_enabled(current, trace)))
+			trace = 0;
+	}
 
 	p = copy_process(clone_flags, stack_start, regs, stack_size,
 			 child_tidptr, NULL, trace);
@@ -1508,20 +1520,31 @@ long do_fork(unsigned long clone_flags,
 		}
 
 		audit_finish_fork(p);
-		tracehook_report_clone(regs, clone_flags, nr, p);
+
+		/*
+		 * Child is ready but hasn't started running yet.  Queue
+		 * SIGSTOP if it's gonna be ptraced - it doesn't matter who
+		 * attached/attaching to this task, the pending SIGSTOP is
+		 * right in any case.
+		 */
+		if (unlikely(p->ptrace)) {
+			sigaddset(&p->pending.signal, SIGSTOP);
+			set_tsk_thread_flag(p, TIF_SIGPENDING);
+		}
 
 		/*
 		 * We set PF_STARTING at creation in case tracing wants to
 		 * use this to distinguish a fully live task from one that
-		 * hasn't gotten to tracehook_report_clone() yet.  Now we
-		 * clear it and set the child going.
+		 * hasn't finished SIGSTOP raising yet.  Now we clear it
+		 * and set the child going.
 		 */
 		p->flags &= ~PF_STARTING;
 
 		wake_up_new_task(p);
 
-		tracehook_report_clone_complete(trace, regs,
-						clone_flags, nr, p);
+		/* forking complete and child started to run, tell ptracer */
+		if (unlikely(trace))
+			ptrace_event(trace, nr);
 
 		if (clone_flags & CLONE_VFORK) {
 			freezer_do_not_count();
-- 
1.7.5.4

