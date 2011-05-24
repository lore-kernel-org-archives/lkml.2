Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175Ab1EXSix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:38:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45008 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933073Ab1EXSiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:38:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=TUsl0/0ZKVhygQtXjGRfGKHDmy7JzdK3fjXSn5sdiaro+xkBOfFpHWavHSnu0R/ib6
         63BH9ez5uzFz0juufqjjcH3Uvr2b6K5jYX4BOV7WkKgM7qtigIzzC6WvfYCYcV33myvX
         6iYe9TzUmFe/AehzfpeKSY7P7yeygX2GVsbnM=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/19] signal: remove three noop tracehooks
Date: Tue, 24 May 2011 20:37:30 +0200
Message-Id: <1306262259-7285-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1306262259-7285-1-git-send-email-tj@kernel.org>
References: <1306262259-7285-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the following three noop tracehooks in signals.c.

* tracehook_force_sigpending()
* tracehook_get_signal()
* tracehook_finish_jctl()

The code area is about to be updated and these hooks don't do anything
other than obfuscating the logic.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/tracehook.h |   52 ---------------------------------------------
 kernel/signal.c           |   44 ++++++++++++--------------------------
 2 files changed, 14 insertions(+), 82 deletions(-)

diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index e95f523..15745cd 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -425,58 +425,6 @@ static inline int tracehook_consider_fatal_signal(struct task_struct *task,
 	return (task_ptrace(task) & PT_PTRACED) != 0;
 }
 
-/**
- * tracehook_force_sigpending - let tracing force signal_pending(current) on
- *
- * Called when recomputing our signal_pending() flag.  Return nonzero
- * to force the signal_pending() flag on, so that tracehook_get_signal()
- * will be called before the next return to user mode.
- *
- * Called with @current->sighand->siglock held.
- */
-static inline int tracehook_force_sigpending(void)
-{
-	return 0;
-}
-
-/**
- * tracehook_get_signal - deliver synthetic signal to traced task
- * @task:		@current
- * @regs:		task_pt_regs(@current)
- * @info:		details of synthetic signal
- * @return_ka:		sigaction for synthetic signal
- *
- * Return zero to check for a real pending signal normally.
- * Return -1 after releasing the siglock to repeat the check.
- * Return a signal number to induce an artificial signal delivery,
- * setting *@info and *@return_ka to specify its details and behavior.
- *
- * The @return_ka->sa_handler value controls the disposition of the
- * signal, no matter the signal number.  For %SIG_DFL, the return value
- * is a representative signal to indicate the behavior (e.g. %SIGTERM
- * for death, %SIGQUIT for core dump, %SIGSTOP for job control stop,
- * %SIGTSTP for stop unless in an orphaned pgrp), but the signal number
- * reported will be @info->si_signo instead.
- *
- * Called with @task->sighand->siglock held, before dequeuing pending signals.
- */
-static inline int tracehook_get_signal(struct task_struct *task,
-				       struct pt_regs *regs,
-				       siginfo_t *info,
-				       struct k_sigaction *return_ka)
-{
-	return 0;
-}
-
-/**
- * tracehook_finish_jctl - report about return from job control stop
- *
- * This is called by do_signal_stop() after wakeup.
- */
-static inline void tracehook_finish_jctl(void)
-{
-}
-
 #define DEATH_REAP			-1
 #define DEATH_DELAYED_GROUP_LEADER	-2
 
diff --git a/kernel/signal.c b/kernel/signal.c
index 106b47e..85df25e 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -150,9 +150,7 @@ void recalc_sigpending_and_wake(struct task_struct *t)
 
 void recalc_sigpending(void)
 {
-	if (unlikely(tracehook_force_sigpending()))
-		set_thread_flag(TIF_SIGPENDING);
-	else if (!recalc_sigpending_tsk(current) && !freezing(current))
+	if (!recalc_sigpending_tsk(current) && !freezing(current))
 		clear_thread_flag(TIF_SIGPENDING);
 
 }
@@ -2005,8 +2003,6 @@ retry:
 
 	spin_unlock_irq(&current->sighand->siglock);
 
-	tracehook_finish_jctl();
-
 	return 1;
 }
 
@@ -2109,37 +2105,25 @@ relock:
 
 	for (;;) {
 		struct k_sigaction *ka;
-		/*
-		 * Tracing can induce an artificial signal and choose sigaction.
-		 * The return value in @signr determines the default action,
-		 * but @info->si_signo is the signal number we will report.
-		 */
-		signr = tracehook_get_signal(current, regs, info, return_ka);
-		if (unlikely(signr < 0))
+
+		if (unlikely(current->jobctl & JOBCTL_STOP_PENDING) &&
+		    do_signal_stop(0))
 			goto relock;
-		if (unlikely(signr != 0))
-			ka = return_ka;
-		else {
-			if (unlikely(current->jobctl & JOBCTL_STOP_PENDING) &&
-			    do_signal_stop(0))
-				goto relock;
 
-			signr = dequeue_signal(current, &current->blocked,
-					       info);
+		signr = dequeue_signal(current, &current->blocked, info);
 
-			if (!signr)
-				break; /* will return 0 */
+		if (!signr)
+			break; /* will return 0 */
 
-			if (signr != SIGKILL) {
-				signr = ptrace_signal(signr, info,
-						      regs, cookie);
-				if (!signr)
-					continue;
-			}
-
-			ka = &sighand->action[signr-1];
+		if (signr != SIGKILL) {
+			signr = ptrace_signal(signr, info,
+					      regs, cookie);
+			if (!signr)
+				continue;
 		}
 
+		ka = &sighand->action[signr-1];
+
 		/* Trace actually delivered signals. */
 		trace_signal_deliver(signr, info, ka);
 
-- 
1.7.1

