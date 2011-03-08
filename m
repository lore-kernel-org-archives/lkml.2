Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab1CHT5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 14:57:25 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54056 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab1CHT5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 14:57:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ZSG0f7v5Q20hV1JcM8/V8zVooeSLK0nMo0E9zJozCPEPyR24FA6sV2nLDZFDs1KCw8
         rEx4uKtIXtMEGcvsN4D4EpHon8NUr705UMveqrf1KGTlxWsTW4Wual9iWXvFM9eipyNz
         PdjyDLGjfa9pkEmOFQmtf+gBC7UqSMXi4gnVE=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, jan.kratochvil@redhat.com,
        vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, Tejun Heo <tj@kernel.org>
Subject: [PATCH 8/8] job control: Don't send duplicate job control stop notification while ptraced
Date: Tue,  8 Mar 2011 20:56:39 +0100
Message-Id: <1299614199-25142-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299614199-25142-1-git-send-email-tj@kernel.org>
References: <1299614199-25142-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just as group_exit_code shouldn't be generated when a PTRACE_CONT'd
task re-enters job control stop, notifiction for the event should be
suppressed too.  The logic is the same as the group_exit_code
generation suppression in do_signal_stop(), if SIGNAL_STOP_STOPPED is
already set, the task is re-entering job control stop without
intervening SIGCONT and the notifications should be suppressed.

Test case follows.

  #include <stdio.h>
  #include <unistd.h>
  #include <signal.h>
  #include <time.h>
  #include <sys/ptrace.h>
  #include <sys/wait.h>

  static const struct timespec ts100ms = { .tv_nsec = 100000000 };
  static pid_t tracee, tracer;

  static const char *pid_who(pid_t pid)
  {
	  return pid == tracee ? "tracee" : (pid == tracer ? "tracer" : "mommy ");
  }

  static void sigchld_sigaction(int signo, siginfo_t *si, void *ucxt)
  {
	  printf("%s: SIG status=%02d code=%02d (%s)\n",
		 pid_who(getpid()), si->si_status, si->si_code,
		 pid_who(si->si_pid));
  }

  int main(void)
  {
	  const struct sigaction chld_sa = { .sa_sigaction = sigchld_sigaction,
					     .sa_flags = SA_SIGINFO|SA_RESTART };
	  siginfo_t si;

	  sigaction(SIGCHLD, &chld_sa, NULL);

	  tracee = fork();
	  if (!tracee) {
		  tracee = getpid();
		  while (1)
			  pause();
	  }

	  kill(tracee, SIGSTOP);
	  waitid(P_PID, tracee, &si, WSTOPPED);

	  tracer = fork();
	  if (!tracer) {
		  tracer = getpid();
		  ptrace(PTRACE_ATTACH, tracee, NULL, NULL);
		  waitid(P_PID, tracee, &si, WSTOPPED);
		  ptrace(PTRACE_CONT, tracee, NULL, (void *)(long)si.si_status);
		  waitid(P_PID, tracee, &si, WSTOPPED);
		  ptrace(PTRACE_CONT, tracee, NULL, (void *)(long)si.si_status);
		  waitid(P_PID, tracee, &si, WSTOPPED);
		  printf("tracer: detaching\n");
		  ptrace(PTRACE_DETACH, tracee, NULL, NULL);
		  return 0;
	  }

	  while (1)
		  pause();
	  return 0;
  }

Before the patch, the parent gets the second notification for the
tracee after the tracer detaches.  si_status is zero because
group_exit_code is not set by the group stop completion which
triggered this notification.

  mommy : SIG status=19 code=05 (tracee)
  tracer: SIG status=00 code=05 (tracee)
  tracer: SIG status=19 code=04 (tracee)
  tracer: SIG status=00 code=05 (tracee)
  tracer: detaching
  mommy : SIG status=00 code=05 (tracee)
  mommy : SIG status=00 code=01 (tracer)
  ^C

After the patch, the duplicate notification is gone.

  mommy : SIG status=19 code=05 (tracee)
  tracer: SIG status=00 code=05 (tracee)
  tracer: SIG status=19 code=04 (tracee)
  tracer: SIG status=00 code=05 (tracee)
  tracer: detaching
  mommy : SIG status=00 code=01 (tracer)
  ^C

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/signal.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 74f097c..8304563 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -268,6 +268,10 @@ void task_clear_group_stop_pending(struct task_struct *task)
  *
  * CONTEXT:
  * Must be called with @task->sighand->siglock held.
+ *
+ * RETURNS:
+ * %true if group stop completion should be notified to the parent, %false
+ * otherwise.
  */
 static bool task_participate_group_stop(struct task_struct *task)
 {
@@ -284,7 +288,11 @@ static bool task_participate_group_stop(struct task_struct *task)
 	if (!WARN_ON_ONCE(sig->group_stop_count == 0))
 		sig->group_stop_count--;
 
-	if (!sig->group_stop_count) {
+	/*
+	 * Tell the caller to notify completion iff we are entering into a
+	 * fresh group stop.  Read comment in do_signal_stop() for details.
+	 */
+	if (!sig->group_stop_count && !(sig->flags & SIGNAL_STOP_STOPPED)) {
 		sig->flags = SIGNAL_STOP_STOPPED;
 		return true;
 	}
-- 
1.7.1

