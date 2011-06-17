Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab1FQOxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:53:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46616 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759307Ab1FQOuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:50:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=g0UEBVcefPWC7XWYHRyGJ/xhIelOGJ8PhQLRVPsOhWrqWGIYKRwHtPrPich5J8smZs
         4F7+7PdGp7G/YRm/zh2RhXZ3usRJOzA1TYgs1G+9vbmd71ly/tyundKDdK8DDKTHToT3
         Ek64oJTawvO8uqxbVJXLtdfP4r+9C6kOc/hWU=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, oleg@redhat.com
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        hch@infradead.org, Tejun Heo <tj@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 4/7] ptrace: kill trivial tracehooks
Date: Fri, 17 Jun 2011 16:50:37 +0200
Message-Id: <1308322240-8247-5-git-send-email-tj@kernel.org>
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

This patch kills the following trivial tracehooks.

* Ones testing whether task is ptraced.  Replace with ->ptrace test.

	tracehook_expect_breakpoints()
	tracehook_consider_ignored_signal()
	tracehook_consider_fatal_signal()

* ptrace_event() wrappers.  Call directly.

	tracehook_report_exec()
	tracehook_report_exit()
	tracehook_report_vfork_done()

* ptrace_release_task() wrapper.  Call directly.

	tracehook_finish_release_task()

* noop

	tracehook_prepare_release_task()
	tracehook_report_death()

This doesn't introduce any behavior change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/s390/kernel/traps.c  |    4 +-
 fs/exec.c                 |    2 +-
 include/linux/tracehook.h |  156 ---------------------------------------------
 kernel/exit.c             |    7 +--
 kernel/fork.c             |    2 +-
 kernel/signal.c           |    8 +-
 mm/nommu.c                |    3 +-
 7 files changed, 11 insertions(+), 171 deletions(-)

diff --git a/arch/s390/kernel/traps.c b/arch/s390/kernel/traps.c
index a65d2e8..a63d34c 100644
--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -331,7 +331,7 @@ void __kprobes do_per_trap(struct pt_regs *regs)
 {
 	if (notify_die(DIE_SSTEP, "sstep", regs, 0, 0, SIGTRAP) == NOTIFY_STOP)
 		return;
-	if (tracehook_consider_fatal_signal(current, SIGTRAP))
+	if (current->ptrace)
 		force_sig(SIGTRAP, current);
 }
 
@@ -425,7 +425,7 @@ static void __kprobes illegal_op(struct pt_regs *regs, long pgm_int_code,
 		if (get_user(*((__u16 *) opcode), (__u16 __user *) location))
 			return;
 		if (*((__u16 *) opcode) == S390_BREAKPOINT_U16) {
-			if (tracehook_consider_fatal_signal(current, SIGTRAP))
+			if (current->ptrace)
 				force_sig(SIGTRAP, current);
 			else
 				signal = SIGILL;
diff --git a/fs/exec.c b/fs/exec.c
index a9f2b36..b37030d 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1384,7 +1384,7 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 			bprm->recursion_depth = depth;
 			if (retval >= 0) {
 				if (depth == 0)
-					tracehook_report_exec(fmt, bprm, regs);
+					ptrace_event(PTRACE_EVENT_EXEC, 0);
 				put_binfmt(fmt);
 				allow_write_access(bprm->file);
 				if (bprm->file)
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 3b68aa8..8b06d4f 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -51,21 +51,6 @@
 #include <linux/security.h>
 struct linux_binprm;
 
-/**
- * tracehook_expect_breakpoints - guess if task memory might be touched
- * @task:		current task, making a new mapping
- *
- * Return nonzero if @task is expected to want breakpoint insertion in
- * its memory at some point.  A zero return is no guarantee it won't
- * be done, but this is a hint that it's known to be likely.
- *
- * May be called with @task->mm->mmap_sem held for writing.
- */
-static inline int tracehook_expect_breakpoints(struct task_struct *task)
-{
-	return (task->ptrace & PT_PTRACED) != 0;
-}
-
 /*
  * ptrace report for syscall entry and exit looks identical.
  */
@@ -184,42 +169,6 @@ static inline struct task_struct *tracehook_tracer_task(struct task_struct *tsk)
 }
 
 /**
- * tracehook_report_exec - a successful exec was completed
- * @fmt:		&struct linux_binfmt that performed the exec
- * @bprm:		&struct linux_binprm containing exec details
- * @regs:		user-mode register state
- *
- * An exec just completed, we are shortly going to return to user mode.
- * The freshly initialized register state can be seen and changed in @regs.
- * The name, file and other pointers in @bprm are still on hand to be
- * inspected, but will be freed as soon as this returns.
- *
- * Called with no locks, but with some kernel resources held live
- * and a reference on @fmt->module.
- */
-static inline void tracehook_report_exec(struct linux_binfmt *fmt,
-					 struct linux_binprm *bprm,
-					 struct pt_regs *regs)
-{
-	ptrace_event(PTRACE_EVENT_EXEC, 0);
-}
-
-/**
- * tracehook_report_exit - task has begun to exit
- * @exit_code:		pointer to value destined for @current->exit_code
- *
- * @exit_code points to the value passed to do_exit(), which tracing
- * might change here.  This is almost the first thing in do_exit(),
- * before freeing any resources or setting the %PF_EXITING flag.
- *
- * Called with no locks held.
- */
-static inline void tracehook_report_exit(long *exit_code)
-{
-	ptrace_event(PTRACE_EVENT_EXIT, *exit_code);
-}
-
-/**
  * tracehook_prepare_clone - prepare for new child to be cloned
  * @clone_flags:	%CLONE_* flags from clone/fork/vfork system call
  *
@@ -320,52 +269,6 @@ static inline void tracehook_report_clone_complete(int trace,
 }
 
 /**
- * tracehook_report_vfork_done - vfork parent's child has exited or exec'd
- * @child:		child task, already running
- * @pid:		new child's PID in the parent's namespace
- *
- * Called after a %CLONE_VFORK parent has waited for the child to complete.
- * The clone/vfork system call will return immediately after this.
- * The @child pointer may be invalid if a self-reaping child died and
- * tracehook_report_clone() took no action to prevent it from self-reaping.
- *
- * Called with no locks held.
- */
-static inline void tracehook_report_vfork_done(struct task_struct *child,
-					       pid_t pid)
-{
-	ptrace_event(PTRACE_EVENT_VFORK_DONE, pid);
-}
-
-/**
- * tracehook_prepare_release_task - task is being reaped, clean up tracing
- * @task:		task in %EXIT_DEAD state
- *
- * This is called in release_task() just before @task gets finally reaped
- * and freed.  This would be the ideal place to remove and clean up any
- * tracing-related state for @task.
- *
- * Called with no locks held.
- */
-static inline void tracehook_prepare_release_task(struct task_struct *task)
-{
-}
-
-/**
- * tracehook_finish_release_task - final tracing clean-up
- * @task:		task in %EXIT_DEAD state
- *
- * This is called in release_task() when @task is being in the middle of
- * being reaped.  After this, there must be no tracing entanglements.
- *
- * Called with write_lock_irq(&tasklist_lock) held.
- */
-static inline void tracehook_finish_release_task(struct task_struct *task)
-{
-	ptrace_release_task(task);
-}
-
-/**
  * tracehook_signal_handler - signal handler setup is complete
  * @sig:		number of signal being delivered
  * @info:		siginfo_t of signal being delivered
@@ -388,41 +291,6 @@ static inline void tracehook_signal_handler(int sig, siginfo_t *info,
 		ptrace_notify(SIGTRAP);
 }
 
-/**
- * tracehook_consider_ignored_signal - suppress short-circuit of ignored signal
- * @task:		task receiving the signal
- * @sig:		signal number being sent
- *
- * Return zero iff tracing doesn't care to examine this ignored signal,
- * so it can short-circuit normal delivery and never even get queued.
- *
- * Called with @task->sighand->siglock held.
- */
-static inline int tracehook_consider_ignored_signal(struct task_struct *task,
-						    int sig)
-{
-	return (task->ptrace & PT_PTRACED) != 0;
-}
-
-/**
- * tracehook_consider_fatal_signal - suppress special handling of fatal signal
- * @task:		task receiving the signal
- * @sig:		signal number being sent
- *
- * Return nonzero to prevent special handling of this termination signal.
- * Normally handler for signal is %SIG_DFL.  It can be %SIG_IGN if @sig is
- * ignored, in which case force_sig() is about to reset it to %SIG_DFL.
- * When this returns zero, this signal might cause a quick termination
- * that does not give the debugger a chance to intercept the signal.
- *
- * Called with or without @task->sighand->siglock held.
- */
-static inline int tracehook_consider_fatal_signal(struct task_struct *task,
-						  int sig)
-{
-	return (task->ptrace & PT_PTRACED) != 0;
-}
-
 #define DEATH_REAP			-1
 #define DEATH_DELAYED_GROUP_LEADER	-2
 
@@ -457,30 +325,6 @@ static inline int tracehook_notify_death(struct task_struct *task,
 	return task->ptrace ? SIGCHLD : DEATH_DELAYED_GROUP_LEADER;
 }
 
-/**
- * tracehook_report_death - task is dead and ready to be reaped
- * @task:		@current task now exiting
- * @signal:		return value from tracheook_notify_death()
- * @death_cookie:	value passed back from tracehook_notify_death()
- * @group_dead:		nonzero if this was the last thread in the group to die
- *
- * Thread has just become a zombie or is about to self-reap.  If positive,
- * @signal is the signal number just sent to the parent (usually %SIGCHLD).
- * If @signal is %DEATH_REAP, this thread will self-reap.  If @signal is
- * %DEATH_DELAYED_GROUP_LEADER, this is a delayed_group_leader() zombie.
- * The @death_cookie was passed back by tracehook_notify_death().
- *
- * If normal reaping is not inhibited, @task->exit_state might be changing
- * in parallel.
- *
- * Called without locks.
- */
-static inline void tracehook_report_death(struct task_struct *task,
-					  int signal, void *death_cookie,
-					  int group_dead)
-{
-}
-
 #ifdef TIF_NOTIFY_RESUME
 /**
  * set_notify_resume - cause tracehook_notify_resume() to be called
diff --git a/kernel/exit.c b/kernel/exit.c
index e5cc056..d49134a 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -169,7 +169,6 @@ void release_task(struct task_struct * p)
 	struct task_struct *leader;
 	int zap_leader;
 repeat:
-	tracehook_prepare_release_task(p);
 	/* don't need to get the RCU readlock here - the process is dead and
 	 * can't be modifying its own credentials. But shut RCU-lockdep up */
 	rcu_read_lock();
@@ -179,7 +178,7 @@ repeat:
 	proc_flush_task(p);
 
 	write_lock_irq(&tasklist_lock);
-	tracehook_finish_release_task(p);
+	ptrace_release_task(p);
 	__exit_signal(p);
 
 	/*
@@ -868,8 +867,6 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 		wake_up_process(tsk->signal->group_exit_task);
 	write_unlock_irq(&tasklist_lock);
 
-	tracehook_report_death(tsk, signal, cookie, group_dead);
-
 	/* If the process is dead, release it - nobody will wait for it */
 	if (signal == DEATH_REAP)
 		release_task(tsk);
@@ -924,7 +921,7 @@ NORET_TYPE void do_exit(long code)
 	 */
 	set_fs(USER_DS);
 
-	tracehook_report_exit(&code);
+	ptrace_event(PTRACE_EVENT_EXIT, code);
 
 	validate_creds_for_do_exit(tsk);
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 0276c30..d4f0dff 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1527,7 +1527,7 @@ long do_fork(unsigned long clone_flags,
 			freezer_do_not_count();
 			wait_for_completion(&vfork);
 			freezer_count();
-			tracehook_report_vfork_done(p, nr);
+			ptrace_event(PTRACE_EVENT_VFORK_DONE, nr);
 		}
 	} else {
 		nr = PTR_ERR(p);
diff --git a/kernel/signal.c b/kernel/signal.c
index 0f33708..1550aee 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -87,7 +87,7 @@ static int sig_ignored(struct task_struct *t, int sig, int from_ancestor_ns)
 	/*
 	 * Tracers may want to know about even ignored signals.
 	 */
-	return !tracehook_consider_ignored_signal(t, sig);
+	return !t->ptrace;
 }
 
 /*
@@ -493,7 +493,8 @@ int unhandled_signal(struct task_struct *tsk, int sig)
 		return 1;
 	if (handler != SIG_IGN && handler != SIG_DFL)
 		return 0;
-	return !tracehook_consider_fatal_signal(tsk, sig);
+	/* if ptraced, let the tracer determine */
+	return !tsk->ptrace;
 }
 
 /*
@@ -981,8 +982,7 @@ static void complete_signal(int sig, struct task_struct *p, int group)
 	if (sig_fatal(p, sig) &&
 	    !(signal->flags & (SIGNAL_UNKILLABLE | SIGNAL_GROUP_EXIT)) &&
 	    !sigismember(&t->real_blocked, sig) &&
-	    (sig == SIGKILL ||
-	     !tracehook_consider_fatal_signal(t, sig))) {
+	    (sig == SIGKILL || !t->ptrace)) {
 		/*
 		 * This signal will be fatal to the whole group.
 		 */
diff --git a/mm/nommu.c b/mm/nommu.c
index 1fd0c51..54ae707 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -22,7 +22,6 @@
 #include <linux/pagemap.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
-#include <linux/tracehook.h>
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/mount.h>
@@ -1087,7 +1086,7 @@ static unsigned long determine_vm_flags(struct file *file,
 	 * it's being traced - otherwise breakpoints set in it may interfere
 	 * with another untraced process
 	 */
-	if ((flags & MAP_PRIVATE) && tracehook_expect_breakpoints(current))
+	if ((flags & MAP_PRIVATE) && current->ptrace)
 		vm_flags &= ~VM_MAYSHARE;
 
 	return vm_flags;
-- 
1.7.5.4

