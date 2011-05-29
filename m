Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab1E2XNm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 19:13:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54798 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab1E2XNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 19:13:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=s+SKIeu83LBFNhBSOaK5C0WLAz1vOOKxZdarR/oLt3FL1cv7ZldNP5qeX51U9KXUt4
         tUZLyox1tFnkkBx55S4eGwsi+IbGJHJw+Tr6wpNyzTYquqMoZx7NqvOCFNuGjfHSXCnK
         pDQnXy6/RBnwn4YDe/wnihvj9ztRT5v6ywA+0=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 17/17] ptrace: implement PTRACE_LISTEN
Date: Mon, 30 May 2011 01:12:40 +0200
Message-Id: <1306710760-16440-18-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1306710760-16440-1-git-send-email-tj@kernel.org>
References: <1306710760-16440-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous patch implemented async notification for ptrace but it
only worked while trace is running.  This patch introduces
PTRACE_LISTEN which is suggested by Oleg Nestrov.

It's allowed iff tracee is in STOP trap and puts tracee into
quasi-running state - tracee never really runs but wait(2) and
ptrace(2) consider it to be running.  While ptracer is listening,
tracee is allowed to re-enter STOP to notify an async event.
Listening state is cleared on the first notification.  Ptracer can
also clear it by issuing INTERRUPT - tracee will re-trap into STOP
with listening state cleared.

This allows ptracer to monitor group stop state without running tracee
- use INTERRUPT to put tracee into STOP trap, issue LISTEN and then
wait(2) to wait for the next group stop event.  When it happens,
PTRACE_GETSIGINFO provides information to determine the current state.

Test program follows.

  #define PTRACE_SEIZE		0x4206
  #define PTRACE_INTERRUPT	0x4207
  #define PTRACE_LISTEN		0x4208

  #define PTRACE_SEIZE_DEVEL	0x80000000

  static const struct timespec ts1s = { .tv_sec = 1 };

  int main(int argc, char **argv)
  {
	  pid_t tracee, tracer;
	  int i;

	  tracee = fork();
	  if (!tracee)
		  while (1)
			  pause();

	  tracer = fork();
	  if (!tracer) {
		  int stopped;
		  siginfo_t si;

		  ptrace(PTRACE_SEIZE, tracee, NULL,
			 (void *)(unsigned long)PTRACE_SEIZE_DEVEL);
		  ptrace(PTRACE_INTERRUPT, tracee, NULL, NULL);
	  repeat:
		  waitid(P_PID, tracee, NULL, WSTOPPED);

		  ptrace(PTRACE_GETSIGINFO, tracee, NULL, &si);
		  if (!si.si_code) {
			  printf("tracer: SIG %d\n", si.si_signo);
			  ptrace(PTRACE_CONT, tracee, NULL,
				 (void *)(unsigned long)si.si_signo);
			  goto repeat;
		  }
		  stopped = !!si.si_status;
		  printf("tracer: stopped=%d signo=%d\n", stopped, si.si_signo);
		  if (stopped)
			  ptrace(PTRACE_LISTEN, tracee, NULL, NULL);
		  else
			  ptrace(PTRACE_CONT, tracee, NULL, NULL);
		  goto repeat;
	  }

	  for (i = 0; i < 3; i++) {
		  nanosleep(&ts1s, NULL);
		  printf("mother: SIGSTOP\n");
		  kill(tracee, SIGSTOP);
		  nanosleep(&ts1s, NULL);
		  printf("mother: SIGCONT\n");
		  kill(tracee, SIGCONT);
	  }
	  nanosleep(&ts1s, NULL);

	  kill(tracer, SIGKILL);
	  kill(tracee, SIGKILL);
	  return 0;
  }

This is identical to the program to test TRAP_NOTIFY except that
tracee is PTRACE_LISTEN'd instead of PTRACE_CONT'd when group stopped.
This allows ptracer to monitor when group stop ends without running
tracee.

  # ./test-listen
  tracer: stopped=0 signo=5
  mother: SIGSTOP
  tracer: SIG 19
  tracer: stopped=1 signo=19
  mother: SIGCONT
  tracer: stopped=0 signo=5
  tracer: SIG 18
  mother: SIGSTOP
  tracer: SIG 19
  tracer: stopped=1 signo=19
  mother: SIGCONT
  tracer: stopped=0 signo=5
  tracer: SIG 18
  mother: SIGSTOP
  tracer: SIG 19
  tracer: stopped=1 signo=19
  mother: SIGCONT
  tracer: stopped=0 signo=5
  tracer: SIG 18

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/ptrace.h |    1 +
 include/linux/sched.h  |    2 ++
 kernel/exit.c          |    2 +-
 kernel/ptrace.c        |   42 +++++++++++++++++++++++++++++++++++++++---
 kernel/signal.c        |   13 +++++++++----
 5 files changed, 52 insertions(+), 8 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 43f762d..abcfb2b 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -49,6 +49,7 @@
 
 #define PTRACE_SEIZE		0x4206
 #define PTRACE_INTERRUPT	0x4207
+#define PTRACE_LISTEN		0x4208
 
 /* flags in @data for PTRACE_SEIZE */
 #define PTRACE_SEIZE_DEVEL	0x80000000 /* temp flag for development */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 161658f..58ee03e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1813,6 +1813,7 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define JOBCTL_TRAP_STOP_BIT	19	/* trap for STOP */
 #define JOBCTL_TRAP_NOTIFY_BIT	20	/* trap for NOTIFY */
 #define JOBCTL_TRAPPING_BIT	21	/* switching to TRACED */
+#define JOBCTL_LISTENING_BIT	22	/* ptracer is listening for events */
 
 #define JOBCTL_STOP_DEQUEUED	(1 << JOBCTL_STOP_DEQUEUED_BIT)
 #define JOBCTL_STOP_PENDING	(1 << JOBCTL_STOP_PENDING_BIT)
@@ -1820,6 +1821,7 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define JOBCTL_TRAP_STOP	(1 << JOBCTL_TRAP_STOP_BIT)
 #define JOBCTL_TRAP_NOTIFY	(1 << JOBCTL_TRAP_NOTIFY_BIT)
 #define JOBCTL_TRAPPING		(1 << JOBCTL_TRAPPING_BIT)
+#define JOBCTL_LISTENING	(1 << JOBCTL_LISTENING_BIT)
 
 #define JOBCTL_TRAP_MASK	(JOBCTL_TRAP_STOP | JOBCTL_TRAP_NOTIFY)
 #define JOBCTL_PENDING_MASK	(JOBCTL_STOP_PENDING | JOBCTL_TRAP_MASK)
diff --git a/kernel/exit.c b/kernel/exit.c
index 20a4064..b3bb3c2 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1416,7 +1416,7 @@ static int wait_task_stopped(struct wait_opts *wo,
 	spin_lock_irq(&p->sighand->siglock);
 
 	p_code = task_stopped_code(p, ptrace);
-	if (unlikely(!p_code))
+	if (unlikely(!p_code) || p->jobctl & JOBCTL_LISTENING)
 		goto unlock_sig;
 
 	exit_code = *p_code;
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index f1efe07..3862142 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -146,7 +146,8 @@ int ptrace_check_attach(struct task_struct *child, bool ignore_state)
 		 */
 		spin_lock_irq(&child->sighand->siglock);
 		WARN_ON_ONCE(task_is_stopped(child));
-		if (task_is_traced(child) || ignore_state)
+		if (ignore_state || (task_is_traced(child) &&
+				     !(child->jobctl & JOBCTL_LISTENING)))
 			ret = 0;
 		spin_unlock_irq(&child->sighand->siglock);
 	}
@@ -672,7 +673,7 @@ int ptrace_request(struct task_struct *child, long request,
 {
 	bool seized = child->ptrace & PT_SEIZED;
 	int ret = -EIO;
-	siginfo_t siginfo;
+	siginfo_t siginfo, *si;
 	void __user *datavp = (void __user *) data;
 	unsigned long __user *datalp = datavp;
 	unsigned long flags;
@@ -722,8 +723,43 @@ int ptrace_request(struct task_struct *child, long request,
 		if (unlikely(!seized || !lock_task_sighand(child, &flags)))
 			break;
 
+		/*
+		 * INTERRUPT doesn't disturb existing trap sans one
+		 * exception.  If ptracer issued LISTEN for the current
+		 * STOP, this INTERRUPT should clear LISTEN and re-trap
+		 * tracee into STOP.
+		 */
 		if (likely(task_set_jobctl_pending(child, JOBCTL_TRAP_STOP)))
-			signal_wake_up(child, 0);
+			signal_wake_up(child, child->jobctl & JOBCTL_LISTENING);
+
+		unlock_task_sighand(child, &flags);
+		ret = 0;
+		break;
+
+	case PTRACE_LISTEN:
+		/*
+		 * Listen for events.  Tracee must be in STOP.  It's not
+		 * resumed per-se but is not considered to be in TRACED by
+		 * wait(2) or ptrace(2).  If an async event (e.g. group
+		 * stop state change) happens, tracee will enter STOP trap
+		 * again.  Alternatively, ptracer can issue INTERRUPT to
+		 * finish listening and re-trap tracee into STOP.
+		 */
+		if (unlikely(!seized || !lock_task_sighand(child, &flags)))
+			break;
+
+		si = child->last_siginfo;
+		if (unlikely(!si || si->si_code != PTRACE_STOP_SI_CODE))
+			break;
+
+		child->jobctl |= JOBCTL_LISTENING;
+
+		/*
+		 * If NOTIFY is set, it means event happened between start
+		 * of this trap and now.  Trigger re-trap immediately.
+		 */
+		if (child->jobctl & JOBCTL_TRAP_NOTIFY)
+			signal_wake_up(child, true);
 
 		unlock_task_sighand(child, &flags);
 		ret = 0;
diff --git a/kernel/signal.c b/kernel/signal.c
index 5a72324..2ec1d08 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -825,9 +825,11 @@ static int check_kill_permission(int sig, struct siginfo *info,
  * TRAP_STOP to notify ptracer of an event.  @t must have been seized by
  * ptracer.
  *
- * If @t is running, STOP trap will be taken.  If already trapped, STOP
- * trap will be eventually taken without returning to userland after the
- * existing traps are finished by PTRACE_CONT.
+ * If @t is running, STOP trap will be taken.  If trapped for STOP and
+ * ptracer is listening for events, tracee is woken up so that it can
+ * re-trap for the new event.  If trapped otherwise, STOP trap will be
+ * eventually taken without returning to userland after the existing traps
+ * are finished by PTRACE_CONT.
  *
  * CONTEXT:
  * Must be called with @task->sighand->siglock held.
@@ -838,7 +840,7 @@ static void ptrace_trap_notify(struct task_struct *t)
 	assert_spin_locked(&t->sighand->siglock);
 
 	task_set_jobctl_pending(t, JOBCTL_TRAP_NOTIFY);
-	signal_wake_up(t, 0);
+	signal_wake_up(t, t->jobctl & JOBCTL_LISTENING);
 }
 
 /*
@@ -1894,6 +1896,9 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	spin_lock_irq(&current->sighand->siglock);
 	current->last_siginfo = NULL;
 
+	/* LISTENING can be set only during STOP traps, clear it */
+	current->jobctl &= ~JOBCTL_LISTENING;
+
 	/*
 	 * Queued signals ignored us while we were stopped for tracing.
 	 * So check for any that we should take before resuming user mode.
-- 
1.7.5.2

