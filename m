Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab1CHT5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 14:57:06 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49360 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab1CHT5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 14:57:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=LBCusGZLOTSjCzQ04swDL4SEz/47GykmkfbYC9T6YUG0t6f09viO8FXw6GhVrYJR3M
         vwdEUMRwR/XkN8l3yttenFOA0StEhGCcgiXGhOouFecj9tF4yZm5qlpy9lDaicYHMfGB
         rTkRo6OK7UyBva2dcTlAFBZyounAIfUTNMof0=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, jan.kratochvil@redhat.com,
        vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/8] job control: Allow access to job control events through ptracees
Date: Tue,  8 Mar 2011 20:56:35 +0100
Message-Id: <1299614199-25142-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299614199-25142-1-git-send-email-tj@kernel.org>
References: <1299614199-25142-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently a real parent can't access job control stopped/continued
events through a ptraced child.  This utterly breaks job control when
the children are ptraced.

For example, if a program is run from an interactive and then
strace(1) attaches to it, pressing ^Z would send SIGTSTP and strace(1)
would notice it but the shell has no way to tell whether the child
entered job control stop and thus can't tell when to take over the
terminal - leading to awkward lone ^Z on the terminal.

Because the job control and ptrace stopped states are independent,
there is no reason to prevent real parents from accessing the stopped
state regardless of ptrace.  The continued state isn't separate but
ptracers don't have any use for them as ptracees can never resume
without explicit command from their ptracers, so as long as ptracers
don't consume it, it should be fine.

Although this is a behavior change, because the previous behavior is
utterly broken when viewed from real parents and the change is only
visible to real parents, I don't think it's necessary to make this
behavior optional.

One situation to be careful about is when the real parent is ptracing.
The parent is the recipient of both ptrace and job control stop events
and one stop can be reported as both job control and ptrace stops.  As
this can break the current ptrace users, suppress job control stopped
events for these cases.

If a real parent ptracer wants to know about both job control and
ptrace stops, it can create a separate task to serve the role as real
parent.

Note that this only updates wait(2) side of things.  The real parent
can access the states via wait(2) but still is not properly notified
(woken up and delivered signal).  Test case polls wait(2) with WNOHANG
to work around.  Notification will be updated by future patches.

Test case follows.

  #include <stdio.h>
  #include <unistd.h>
  #include <time.h>
  #include <errno.h>
  #include <sys/types.h>
  #include <sys/ptrace.h>
  #include <sys/wait.h>

  int main(void)
  {
	  const struct timespec ts100ms = { .tv_nsec = 100000000 };
	  pid_t tracee, tracer;
	  siginfo_t si;
	  int i;

	  tracee = fork();
	  if (tracee == 0) {
		  while (1) {
			  printf("tracee: SIGSTOP\n");
			  raise(SIGSTOP);
			  nanosleep(&ts100ms, NULL);
			  printf("tracee: SIGCONT\n");
			  raise(SIGCONT);
			  nanosleep(&ts100ms, NULL);
		  }
	  }

	  waitid(P_PID, tracee, &si, WSTOPPED | WNOHANG | WNOWAIT);

	  tracer = fork();
	  if (tracer == 0) {
		  nanosleep(&ts100ms, NULL);
		  ptrace(PTRACE_ATTACH, tracee, NULL, NULL);

		  for (i = 0; i < 11; i++) {
			  si.si_pid = 0;
			  waitid(P_PID, tracee, &si, WSTOPPED);
			  if (si.si_pid && si.si_code == CLD_TRAPPED)
				  ptrace(PTRACE_CONT, tracee, NULL,
					 (void *)(long)si.si_status);
		  }
		  printf("tracer: EXITING\n");
		  return 0;
	  }

	  while (1) {
		  si.si_pid = 0;
		  waitid(P_PID, tracee, &si,
			 WSTOPPED | WCONTINUED | WEXITED | WNOHANG);
		  if (si.si_pid)
			  printf("mommy : WAIT status=%02d code=%02d\n",
				 si.si_status, si.si_code);
		  nanosleep(&ts100ms, NULL);
	  }
	  return 0;
  }

Before the patch, while ptraced, the parent can't see any job control
events.

  tracee: SIGSTOP
  mommy : WAIT status=19 code=05
  tracee: SIGCONT
  tracee: SIGSTOP
  tracee: SIGCONT
  tracee: SIGSTOP
  tracee: SIGCONT
  tracee: SIGSTOP
  tracer: EXITING
  mommy : WAIT status=19 code=05
  ^C

After the patch,

  tracee: SIGSTOP
  mommy : WAIT status=19 code=05
  tracee: SIGCONT
  mommy : WAIT status=18 code=06
  tracee: SIGSTOP
  mommy : WAIT status=19 code=05
  tracee: SIGCONT
  mommy : WAIT status=18 code=06
  tracee: SIGSTOP
  mommy : WAIT status=19 code=05
  tracee: SIGCONT
  mommy : WAIT status=18 code=06
  tracee: SIGSTOP
  tracer: EXITING
  mommy : WAIT status=19 code=05
  ^C

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/exit.c |   40 ++++++++++++++++++++++++++++++++--------
 1 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 7171821..922e41d 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1541,17 +1541,19 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 	if (p->exit_state == EXIT_DEAD)
 		return 0;
 
-	if (likely(!ptrace) && unlikely(task_ptrace(p))) {
+	/* slay zombie? */
+	if (p->exit_state == EXIT_ZOMBIE) {
 		/*
-		 * This child is hidden by ptrace.
-		 * We aren't allowed to see it now, but eventually we will.
+		 * A zombie ptracee is only visible to its ptracer.
+		 * Notification and reaping will be cascaded to the real
+		 * parent when the ptracer detaches.
 		 */
-		wo->notask_error = 0;
-		return 0;
-	}
+		if (likely(!ptrace) && unlikely(task_ptrace(p))) {
+			/* it will become visible, clear notask_error */
+			wo->notask_error = 0;
+			return 0;
+		}
 
-	/* slay zombie? */
-	if (p->exit_state == EXIT_ZOMBIE) {
 		/* we don't reap group leaders with subthreads */
 		if (!delay_group_leader(p))
 			return wait_task_zombie(wo, p);
@@ -1580,15 +1582,37 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 			wo->notask_error = 0;
 	} else {
 		/*
+		 * If %current is ptracing @p, hide group stop/continued
+		 * state when looking at @p as the real parent; otherwise,
+		 * a single stop can be reported twice as group and ptrace
+		 * stops.
+		 *
+		 * If a ptracer wants to distinguish the two events for its
+		 * own children, it should create a separate task which
+		 * takes the role of real parent.
+		 */
+		if (likely(!ptrace) && task_ptrace(p) && p->parent == current)
+			return 0;
+
+		/*
 		 * @p is alive and it's gonna stop, continue or exit, so
 		 * there always is something to wait for.
 		 */
 		wo->notask_error = 0;
 	}
 
+	/*
+	 * Wait for stopped.  Depending on @ptrace, different stopped state
+	 * is used and the two don't interact with each other.
+	 */
 	if (task_stopped_code(p, ptrace))
 		return wait_task_stopped(wo, ptrace, p);
 
+	/*
+	 * Wait for continued.  There's only one continued state and the
+	 * ptracer can consume it which can confuse the real parent.  Don't
+	 * use WCONTINUED from ptracer.  You don't need or want it.
+	 */
 	return wait_task_continued(wo, p);
 }
 
-- 
1.7.1

