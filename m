Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab1C2OrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:47:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54738 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab1C2OrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:47:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Hnq0vdY7BkBWIzo9Mh01aMwhbyFVx3AJPlZ/wtBO40DBTqZMKRWSii4nRXhDBqC8FX
         Gc6BXZXqiSGIJRF9R0fQ9xaCMX2NECgYk/jb7dFO16Hdpl4CUahTTn0FHLzHmhKbyzfC
         e9GeSvpB22SZ02qvmOnuuOlGSmkPN/5P7ik9g=
Date: Tue, 29 Mar 2011 16:47:10 +0200
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com
Subject: [PATCH 3/3] signal, ptrace: Fix delayed CONTINUED notification
 when ptraced
Message-ID: <20110329144710.GC29865@htj.dyndns.org>
References: <20110329144603.GA29865@htj.dyndns.org>
 <20110329144648.GB29865@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110329144648.GB29865@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When SIGCONT is resuming a process from a in-progress or completed
group stop, it is guaranteed that at least one task of the target
group will travel signal delivery path and thus will notice
SIGNAL_CLD_MASK set by prepare_signal() and deliver it.  This is why
prepare_signal() could use wake_up_state() instead of
signal_wake_up().

However, because a ptraced task in group stopped process is allowed to
escape the group stop and execute beneath it, the task may not notice
SIGNAL_CLD_MASK until the next signal delivery.

Fix it by making job control continuation path use signal_wake_up()
instead of wake_up_state() and recalc_sigpending_tsk() consider
SIGNAL_CLD_MASK.  This makes pending CONTINUED notification treated
similarly to pending signals and ensures that the target task is
brought into signal delivery path regardless of its current state.

After this patch, TIF_SIGPENDING is set for cases where it isn't
strictly necessary; however, the only case which it makes any
difference is when the SIGCONT is received while group stop is still
in progress, which hardly is a case to optimize for.  Just use
signal_wake_up() unconditionally for simplicity's sake.

This problem has been identified and the solution suggested by Oleg
Nesterov.

Test case follows.

  #include <stdio.h>
  #include <unistd.h>
  #include <time.h>
  #include <signal.h>
  #include <sys/types.h>
  #include <sys/ptrace.h>
  #include <sys/wait.h>

  static const struct timespec ts100ms = { .tv_nsec = 100000000 };

  static void sigchld_sigaction(int signo, siginfo_t *si, void *ucxt)
  {
	  printf("SIG  status=%02d code=%02d\n", si->si_status, si->si_code);
  }

  int main(void)
  {
	  const struct sigaction chld_sa = { .sa_sigaction = sigchld_sigaction,
					     .sa_flags = SA_SIGINFO|SA_RESTART };
	  pid_t tracee;
	  siginfo_t si;

	  tracee = fork();
	  if (tracee == 0) {
		  sigset_t sigset;
		  sigemptyset(&sigset);
		  sigaddset(&sigset, SIGCONT);
		  while (1)
			  sigprocmask(SIG_BLOCK, &sigset, NULL);
	  }

	  if (!fork()) {
		  ptrace(PTRACE_ATTACH, tracee, NULL, NULL);
		  waitid(P_PID, tracee, &si, WSTOPPED);
		  ptrace(PTRACE_CONT, tracee, NULL, (void *)(long)si.si_status);
		  waitid(P_PID, tracee, &si, WSTOPPED);
		  ptrace(PTRACE_CONT, tracee, NULL, (void *)(long)si.si_status);
		  while (1)
			  pause();
	  }

	  waitid(P_ALL, 0, &si, WSTOPPED);
	  nanosleep(&ts100ms, NULL);
	  sigaction(SIGCHLD, &chld_sa, NULL);
	  kill(tracee, SIGCONT);
	  while (1)
		  pause();
	  return 0;
  }

The sigprocmask() loop in tracee is there to make it continuously
re-evaluate TIF_SIGPENDING such that it doesn't stay set from previous
events.  Before the patch, as the SIGCONT doesn't call in the tracee
into signal delivery path, SIGCHLD is never generated and there's no
output.

After the patch, the tracee is forced into signal delivery path and
SIGCHLD is properly generated.

  SIG  status=18 code=06
  ^C

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/signal.c |   44 +++++++++++++++++++++-----------------------
 1 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index ff63459..fcab849 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -125,6 +125,7 @@ static inline int has_pending_signals(sigset_t *signal, sigset_t *blocked)
 static int recalc_sigpending_tsk(struct task_struct *t)
 {
 	if ((t->group_stop & GROUP_STOP_PENDING) ||
+	    (t->signal->flags & SIGNAL_CLD_MASK) ||
 	    PENDING(&t->pending, &t->blocked) ||
 	    PENDING(&t->signal->shared_pending, &t->blocked)) {
 		set_tsk_thread_flag(t, TIF_SIGPENDING);
@@ -631,6 +632,10 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
  *		should be brought in to deliver the signal.  When @t is in
  *		kernel, wake it up iff it's in interruptible sleep.
  *
+ * %SIGCONT	@t is being resumed from job control stop.  Wake up if
+ *		%__TASK_STOPPED.  If there's a custom signal handler to
+ *		%run, interrupt %TASK_INTERRUPTIBLE sleeps too.
+ *
  * %SIGTRAP	Used by ptrace.  In addition to the usual kicking,
  *		interrupt STOPPED and TRACED sleeps.
  *
@@ -652,6 +657,21 @@ void signal_wake_up(struct task_struct *t, int sig_type)
 		mask = TASK_INTERRUPTIBLE;
 		break;
 
+	case SIGCONT:
+		/*
+		 * If there is a handler for SIGCONT, we must make sure
+		 * that no thread returns to user mode before we post the
+		 * signal, in case it was the only thread eligible to run
+		 * the signal handler--then it must not do anything between
+		 * resuming and running the handler.  This is ensured by
+		 * setting TIF_SIGPENDING before waking up.
+		 */
+		mask = __TASK_STOPPED;
+		if (sig_user_defined(t, SIGCONT) &&
+		    !sigismember(&t->blocked, SIGCONT))
+			mask |= TASK_INTERRUPTIBLE;
+		break;
+
 	case SIGTRAP:
 		mask = TASK_INTERRUPTIBLE | __TASK_STOPPED | __TASK_TRACED;
 		break;
@@ -821,31 +841,9 @@ static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
 		rm_from_queue(SIG_KERNEL_STOP_MASK, &signal->shared_pending);
 		t = p;
 		do {
-			unsigned int state;
-
 			task_clear_group_stop_pending(t);
-
 			rm_from_queue(SIG_KERNEL_STOP_MASK, &t->pending);
-			/*
-			 * If there is a handler for SIGCONT, we must make
-			 * sure that no thread returns to user mode before
-			 * we post the signal, in case it was the only
-			 * thread eligible to run the signal handler--then
-			 * it must not do anything between resuming and
-			 * running the handler.  With the TIF_SIGPENDING
-			 * flag set, the thread will pause and acquire the
-			 * siglock that we hold now and until we've queued
-			 * the pending signal.
-			 *
-			 * Wake up the stopped thread _after_ setting
-			 * TIF_SIGPENDING
-			 */
-			state = __TASK_STOPPED;
-			if (sig_user_defined(t, SIGCONT) && !sigismember(&t->blocked, SIGCONT)) {
-				set_tsk_thread_flag(t, TIF_SIGPENDING);
-				state |= TASK_INTERRUPTIBLE;
-			}
-			wake_up_state(t, state);
+			signal_wake_up(t, SIGCONT);
 		} while_each_thread(p, t);
 
 		/*
-- 
1.7.1

