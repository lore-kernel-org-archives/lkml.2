Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab1E2XNb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 19:13:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56170 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab1E2XNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 19:13:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=R1HkHtQ1mCeTUJTtm5hZIsagMncdzY7l5hvZSJ7kBJRgGpu70zgsfrU8WSFWhIRMYG
         KkYnbh5sgIpJVFQMYfim/Lc0f0JwlI+jTqcDYBz//xdtFtqZGCB2nVR89JcafKYtW0vN
         z1LHHgmk45QuAGBq9pvXkOx7vWizpEgg4wMgM=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 16/17] ptrace: implement TRAP_NOTIFY and use it for group stop events
Date: Mon, 30 May 2011 01:12:39 +0200
Message-Id: <1306710760-16440-17-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1306710760-16440-1-git-send-email-tj@kernel.org>
References: <1306710760-16440-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there's no way for ptracer to find out whether group stop
finished other than polling with INTERRUPT - GETSIGINFO - CONT
sequence This patch implements group stop notification for ptracer
using STOP traps.

When group stop state of a seized tracee changes, JOBCTL_TRAP_NOTIFY
is set, which schedules a STOP trap which is sticky - it isn't cleared
by other traps and at least one STOP trap will happen eventually.
STOP trap is synchronization point for event notification and ptracer
is required to fetch group stop information with PTRACE_GETSIGINFO on
each STOP trap if it intends to keep track of group stop changes.

Notifications are generated both on start and end of group stops but,
because group stop participation always happens before STOP trap, this
doesn't cause an extra trap while tracee is participating in group
stop.  The symmetry will be useful later.

Note that this notification works iff tracee is not trapped.
Currently there is no way to be notified of group stop state changes
while tracee is trapped.  This will be addressed by a later patch.

An example program follows.

  #define PTRACE_SEIZE		0x4206
  #define PTRACE_INTERRUPT	0x4207

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

In the above program, tracer keeps tracee running and gets
notification of each group stop state changes.

  # ./test-notify
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
 include/linux/ptrace.h |    2 ++
 include/linux/sched.h  |    4 +++-
 kernel/signal.c        |   38 +++++++++++++++++++++++++++++++++++---
 3 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index f16a63f..43f762d 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -73,6 +73,8 @@
 #define PTRACE_EVENT_EXIT	6
 #define PTRACE_EVENT_STOP	7
 
+#define PTRACE_STOP_SI_CODE	(__SI_TRAP | SIGTRAP | PTRACE_EVENT_STOP << 8)
+
 /* flags in siginfo.si_pt_flags from PTRACE_GETSIGINFO */
 #define PTRACE_SI_STOPPED	0x00000001 /* tracee is job control stopped */
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 20f392b..161658f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1811,15 +1811,17 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define JOBCTL_STOP_PENDING_BIT	17	/* task should stop for group stop */
 #define JOBCTL_STOP_CONSUME_BIT	18	/* consume group stop count */
 #define JOBCTL_TRAP_STOP_BIT	19	/* trap for STOP */
+#define JOBCTL_TRAP_NOTIFY_BIT	20	/* trap for NOTIFY */
 #define JOBCTL_TRAPPING_BIT	21	/* switching to TRACED */
 
 #define JOBCTL_STOP_DEQUEUED	(1 << JOBCTL_STOP_DEQUEUED_BIT)
 #define JOBCTL_STOP_PENDING	(1 << JOBCTL_STOP_PENDING_BIT)
 #define JOBCTL_STOP_CONSUME	(1 << JOBCTL_STOP_CONSUME_BIT)
 #define JOBCTL_TRAP_STOP	(1 << JOBCTL_TRAP_STOP_BIT)
+#define JOBCTL_TRAP_NOTIFY	(1 << JOBCTL_TRAP_NOTIFY_BIT)
 #define JOBCTL_TRAPPING		(1 << JOBCTL_TRAPPING_BIT)
 
-#define JOBCTL_TRAP_MASK	JOBCTL_TRAP_STOP
+#define JOBCTL_TRAP_MASK	(JOBCTL_TRAP_STOP | JOBCTL_TRAP_NOTIFY)
 #define JOBCTL_PENDING_MASK	(JOBCTL_STOP_PENDING | JOBCTL_TRAP_MASK)
 
 extern bool task_set_jobctl_pending(struct task_struct *task,
diff --git a/kernel/signal.c b/kernel/signal.c
index c6ebdfe..5a72324 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -817,6 +817,30 @@ static int check_kill_permission(int sig, struct siginfo *info,
 	return security_task_kill(t, info, sig, 0);
 }
 
+/**
+ * ptrace_trap_notify - schedule trap to notify ptracer
+ * @t: tracee wanting to notify tracer
+ *
+ * This function schedules sticky ptrace trap which is cleared on the next
+ * TRAP_STOP to notify ptracer of an event.  @t must have been seized by
+ * ptracer.
+ *
+ * If @t is running, STOP trap will be taken.  If already trapped, STOP
+ * trap will be eventually taken without returning to userland after the
+ * existing traps are finished by PTRACE_CONT.
+ *
+ * CONTEXT:
+ * Must be called with @task->sighand->siglock held.
+ */
+static void ptrace_trap_notify(struct task_struct *t)
+{
+	WARN_ON_ONCE(!(t->ptrace & PT_SEIZED));
+	assert_spin_locked(&t->sighand->siglock);
+
+	task_set_jobctl_pending(t, JOBCTL_TRAP_NOTIFY);
+	signal_wake_up(t, 0);
+}
+
 /*
  * Handle magic process-wide effects of stop/continue signals. Unlike
  * the signal actions, these happen immediately at signal-generation
@@ -855,7 +879,10 @@ static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
 		do {
 			task_clear_jobctl_pending(t, JOBCTL_STOP_PENDING);
 			rm_from_queue(SIG_KERNEL_STOP_MASK, &t->pending);
-			wake_up_state(t, __TASK_STOPPED);
+			if (likely(!(t->ptrace & PT_SEIZED)))
+				wake_up_state(t, __TASK_STOPPED);
+			else
+				ptrace_trap_notify(t);
 		} while_each_thread(p, t);
 
 		/*
@@ -1797,8 +1824,10 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	if (why == CLD_STOPPED && (current->jobctl & JOBCTL_STOP_PENDING))
 		gstop_done = task_participate_group_stop(current);
 
-	/* any trap clears pending STOP trap */
+	/* any trap clears pending STOP trap, STOP trap clears NOTIFY */
 	task_clear_jobctl_pending(current, JOBCTL_TRAP_STOP);
+	if (info && info->si_code == PTRACE_STOP_SI_CODE)
+		task_clear_jobctl_pending(current, JOBCTL_TRAP_NOTIFY);
 
 	/* entering a trap, clear TRAPPING */
 	task_clear_jobctl_trapping(current);
@@ -1980,7 +2009,10 @@ static bool do_signal_stop(int signr)
 			if (!task_is_stopped(t) &&
 			    task_set_jobctl_pending(t, signr | gstop)) {
 				sig->group_stop_count++;
-				signal_wake_up(t, 0);
+				if (likely(!(t->ptrace & PT_SEIZED)))
+					signal_wake_up(t, 0);
+				else
+					ptrace_trap_notify(t);
 			}
 		}
 	}
-- 
1.7.5.2

