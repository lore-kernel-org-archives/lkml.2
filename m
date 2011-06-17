Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab1FQOxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:53:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56083 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759280Ab1FQOuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:50:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=HJ9WpAXczqFVsgbfq5jFD1Wb1JT/aRCFNbCP3J4ZhucL7NSDNQFB2DSAbNW8f4oTOI
         l4P/VtPUoEP08B31B/6FP48zv1GeXnVkRpF43MhTMeqKpaWYA8NZj7sO9J2sm/QJoxTU
         wLjQ4wiLHq3aSeAZtGhREYa+IVPCGdN9ORl3U=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, oleg@redhat.com
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        hch@infradead.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/7] ptrace: kill task_ptrace()
Date: Fri, 17 Jun 2011 16:50:34 +0200
Message-Id: <1308322240-8247-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1308322240-8247-1-git-send-email-tj@kernel.org>
References: <1308322240-8247-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task_ptrace(task) simply dereferences task->ptrace and isn't even used
consistently only adding confusion.  Kill it and directly access
->ptrace instead.

This doesn't introduce any behavior change.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/ptrace.h    |   11 -----------
 include/linux/tracehook.h |   16 ++++++++--------
 kernel/exit.c             |    8 ++++----
 kernel/signal.c           |   14 +++++++-------
 mm/oom_kill.c             |    3 +--
 5 files changed, 20 insertions(+), 32 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 4f224f1..3ff20b3 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -146,17 +146,6 @@ int generic_ptrace_pokedata(struct task_struct *tsk, unsigned long addr,
 			    unsigned long data);
 
 /**
- * task_ptrace - return %PT_* flags that apply to a task
- * @task:	pointer to &task_struct in question
- *
- * Returns the %PT_* flags that apply to @task.
- */
-static inline int task_ptrace(struct task_struct *task)
-{
-	return task->ptrace;
-}
-
-/**
  * ptrace_event - possibly stop for a ptrace event notification
  * @mask:	%PT_* bit to check in @current->ptrace
  * @event:	%PTRACE_EVENT_* value to report if @mask is set
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 15745cd..a3e8387 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -63,7 +63,7 @@ struct linux_binprm;
  */
 static inline int tracehook_expect_breakpoints(struct task_struct *task)
 {
-	return (task_ptrace(task) & PT_PTRACED) != 0;
+	return (task->ptrace & PT_PTRACED) != 0;
 }
 
 /*
@@ -71,7 +71,7 @@ static inline int tracehook_expect_breakpoints(struct task_struct *task)
  */
 static inline void ptrace_report_syscall(struct pt_regs *regs)
 {
-	int ptrace = task_ptrace(current);
+	int ptrace = current->ptrace;
 
 	if (!(ptrace & PT_PTRACED))
 		return;
@@ -155,7 +155,7 @@ static inline void tracehook_report_syscall_exit(struct pt_regs *regs, int step)
 static inline int tracehook_unsafe_exec(struct task_struct *task)
 {
 	int unsafe = 0;
-	int ptrace = task_ptrace(task);
+	int ptrace = task->ptrace;
 	if (ptrace & PT_PTRACED) {
 		if (ptrace & PT_PTRACE_CAP)
 			unsafe |= LSM_UNSAFE_PTRACE_CAP;
@@ -178,7 +178,7 @@ static inline int tracehook_unsafe_exec(struct task_struct *task)
  */
 static inline struct task_struct *tracehook_tracer_task(struct task_struct *tsk)
 {
-	if (task_ptrace(tsk) & PT_PTRACED)
+	if (tsk->ptrace & PT_PTRACED)
 		return rcu_dereference(tsk->parent);
 	return NULL;
 }
@@ -202,7 +202,7 @@ static inline void tracehook_report_exec(struct linux_binfmt *fmt,
 					 struct pt_regs *regs)
 {
 	if (!ptrace_event(PT_TRACE_EXEC, PTRACE_EVENT_EXEC, 0) &&
-	    unlikely(task_ptrace(current) & PT_PTRACED))
+	    unlikely(current->ptrace & PT_PTRACED))
 		send_sig(SIGTRAP, current, 0);
 }
 
@@ -285,7 +285,7 @@ static inline void tracehook_report_clone(struct pt_regs *regs,
 					  unsigned long clone_flags,
 					  pid_t pid, struct task_struct *child)
 {
-	if (unlikely(task_ptrace(child))) {
+	if (unlikely(child->ptrace)) {
 		/*
 		 * It doesn't matter who attached/attaching to this
 		 * task, the pending SIGSTOP is right in any case.
@@ -403,7 +403,7 @@ static inline void tracehook_signal_handler(int sig, siginfo_t *info,
 static inline int tracehook_consider_ignored_signal(struct task_struct *task,
 						    int sig)
 {
-	return (task_ptrace(task) & PT_PTRACED) != 0;
+	return (task->ptrace & PT_PTRACED) != 0;
 }
 
 /**
@@ -422,7 +422,7 @@ static inline int tracehook_consider_ignored_signal(struct task_struct *task,
 static inline int tracehook_consider_fatal_signal(struct task_struct *task,
 						  int sig)
 {
-	return (task_ptrace(task) & PT_PTRACED) != 0;
+	return (task->ptrace & PT_PTRACED) != 0;
 }
 
 #define DEATH_REAP			-1
diff --git a/kernel/exit.c b/kernel/exit.c
index 289f59d..e5cc056 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -765,7 +765,7 @@ static void reparent_leader(struct task_struct *father, struct task_struct *p,
 	p->exit_signal = SIGCHLD;
 
 	/* If it has exited notify the new parent about this child's death. */
-	if (!task_ptrace(p) &&
+	if (!p->ptrace &&
 	    p->exit_state == EXIT_ZOMBIE && thread_group_empty(p)) {
 		do_notify_parent(p, p->exit_signal);
 		if (task_detached(p)) {
@@ -795,7 +795,7 @@ static void forget_original_parent(struct task_struct *father)
 		do {
 			t->real_parent = reaper;
 			if (t->parent == father) {
-				BUG_ON(task_ptrace(t));
+				BUG_ON(t->ptrace);
 				t->parent = t->real_parent;
 			}
 			if (t->pdeath_signal)
@@ -1565,7 +1565,7 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 		 * Notification and reaping will be cascaded to the real
 		 * parent when the ptracer detaches.
 		 */
-		if (likely(!ptrace) && unlikely(task_ptrace(p))) {
+		if (likely(!ptrace) && unlikely(p->ptrace)) {
 			/* it will become visible, clear notask_error */
 			wo->notask_error = 0;
 			return 0;
@@ -1608,7 +1608,7 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 		 * own children, it should create a separate process which
 		 * takes the role of real parent.
 		 */
-		if (likely(!ptrace) && task_ptrace(p) &&
+		if (likely(!ptrace) && p->ptrace &&
 		    same_thread_group(p->parent, p->real_parent))
 			return 0;
 
diff --git a/kernel/signal.c b/kernel/signal.c
index 97e575a..0f33708 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1592,7 +1592,7 @@ int do_notify_parent(struct task_struct *tsk, int sig)
  	/* do_notify_parent_cldstop should have been called instead.  */
  	BUG_ON(task_is_stopped_or_traced(tsk));
 
-	BUG_ON(!task_ptrace(tsk) &&
+	BUG_ON(!tsk->ptrace &&
 	       (tsk->group_leader != tsk || !thread_group_empty(tsk)));
 
 	info.si_signo = sig;
@@ -1631,7 +1631,7 @@ int do_notify_parent(struct task_struct *tsk, int sig)
 
 	psig = tsk->parent->sighand;
 	spin_lock_irqsave(&psig->siglock, flags);
-	if (!task_ptrace(tsk) && sig == SIGCHLD &&
+	if (!tsk->ptrace && sig == SIGCHLD &&
 	    (psig->action[SIGCHLD-1].sa.sa_handler == SIG_IGN ||
 	     (psig->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT))) {
 		/*
@@ -1731,7 +1731,7 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
 
 static inline int may_ptrace_stop(void)
 {
-	if (!likely(task_ptrace(current)))
+	if (!likely(current->ptrace))
 		return 0;
 	/*
 	 * Are we in the middle of do_coredump?
@@ -1989,7 +1989,7 @@ static bool do_signal_stop(int signr)
 		if (!(sig->flags & SIGNAL_STOP_STOPPED))
 			sig->group_exit_code = signr;
 		else
-			WARN_ON_ONCE(!task_ptrace(current));
+			WARN_ON_ONCE(!current->ptrace);
 
 		sig->group_stop_count = 0;
 
@@ -2014,7 +2014,7 @@ static bool do_signal_stop(int signr)
 		}
 	}
 
-	if (likely(!task_ptrace(current))) {
+	if (likely(!current->ptrace)) {
 		int notify = 0;
 
 		/*
@@ -2093,7 +2093,7 @@ static void do_jobctl_trap(void)
 static int ptrace_signal(int signr, siginfo_t *info,
 			 struct pt_regs *regs, void *cookie)
 {
-	if (!task_ptrace(current))
+	if (!current->ptrace)
 		return signr;
 
 	ptrace_signal_deliver(regs, cookie);
@@ -2179,7 +2179,7 @@ relock:
 		do_notify_parent_cldstop(current, false, why);
 
 		leader = current->group_leader;
-		if (task_ptrace(leader) && !real_parent_is_ptracer(leader))
+		if (leader->ptrace && !real_parent_is_ptracer(leader))
 			do_notify_parent_cldstop(leader, true, why);
 
 		read_unlock(&tasklist_lock);
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index e4b0991..b0be989 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -339,8 +339,7 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
 				 * then wait for it to finish before killing
 				 * some other task unnecessarily.
 				 */
-				if (!(task_ptrace(p->group_leader) &
-							PT_TRACE_EXIT))
+				if (!(p->group_leader->ptrace & PT_TRACE_EXIT))
 					return ERR_PTR(-1UL);
 			}
 		}
-- 
1.7.5.4

