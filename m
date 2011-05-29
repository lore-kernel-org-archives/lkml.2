Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab1E2XOP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 19:14:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54798 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab1E2XNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 19:13:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=wudJKTPzn8iTFc3YD8GvoN64mbWFTNP1TkyBjYJKbronM2yUrxLejYtdIcF6qR5LVQ
         bylk7/H27z8gorBsa2oC7ueNy+FnG+PHhpeXJOgc9yqe8BVoVu5O79b7mEmW9Luq7MlQ
         StknRAmzPzNXtkpxJY14e7Bmw79zaOF0CysRA=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/17] ptrace: make group stop state visible via PTRACE_GETSIGINFO
Date: Mon, 30 May 2011 01:12:37 +0200
Message-Id: <1306710760-16440-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1306710760-16440-1-git-send-email-tj@kernel.org>
References: <1306710760-16440-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If tracee is SEIZED, PTRACE_EVENT_STOP trap is used for group stop;
however, there currently is no way to find out which signal initiated
the group stop or if the group stop is still in effect.

This patch updates ptrace_do_notify() such that it reports group stop
information via si.si_signo and si.si_pt_flags - both are stored in
siginfo on trap.  Note that it's only available if tracee was seized.

This doesn't address notification and tracer has to repeatedly put the
tracee into trap and poll the flag.  Later patches will deal with
notification and trap transition.

Test program follows.

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
			  nanosleep(&ts1s, NULL);

	  tracer = fork();
	  if (!tracer) {
		  int last_stopped = 0, stopped;
		  siginfo_t si;

		  ptrace(PTRACE_SEIZE, tracee, NULL,
			 (void *)(unsigned long)PTRACE_SEIZE_DEVEL);
	  repeat:
		  ptrace(PTRACE_INTERRUPT, tracee, NULL, NULL);
		  waitid(P_PID, tracee, NULL, WSTOPPED);

		  ptrace(PTRACE_GETSIGINFO, tracee, NULL, &si);
		  if (si.si_code) {
			  stopped = !!si.si_status;
			  if (stopped != last_stopped)
				  printf("tracer: stopped=%d signo=%d\n",
					 stopped, si.si_signo);
			  last_stopped = stopped;
			  ptrace(PTRACE_CONT, tracee, NULL, NULL);
		  } else {
			  printf("tracer: SIG %d\n", si.si_signo);
			  ptrace(PTRACE_CONT, tracee, NULL,
				 (void *)(unsigned long)si.si_signo);
		  }
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

Tracer delivers signal, resumes group stop, induces INTERRUPT traps
and reports group stop state change in busy loop.  Mother sends
SIGSTOP or CONT to tracee on each second.  Note that si_pt_flags and
flag testing are replaced with si_status testing.  si_status occupies
the same offset as si_pt_flags and PTRACE_SI_STOPPED is the only flag
defined, so I took a dirty short cut.

  # ./test-stopped
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
  tracer: SIG 18
  tracer: stopped=0 signo=5

-v2: Local variable sig defined inside if() block it's used in as
     suggested by Oleg.

-v3: siginfo is filled in on trap rather than on PTRACE_GETSIGINFO as
     suggested by Oleg.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/ptrace.h |    3 +++
 kernel/signal.c        |    8 ++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index ad754d1..f16a63f 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -73,6 +73,9 @@
 #define PTRACE_EVENT_EXIT	6
 #define PTRACE_EVENT_STOP	7
 
+/* flags in siginfo.si_pt_flags from PTRACE_GETSIGINFO */
+#define PTRACE_SI_STOPPED	0x00000001 /* tracee is job control stopped */
+
 #include <asm/ptrace.h>
 
 #ifdef __KERNEL__
diff --git a/kernel/signal.c b/kernel/signal.c
index 3f131be..c6ebdfe 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1875,6 +1875,7 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 
 static void ptrace_do_notify(int exit_code, int why)
 {
+	struct signal_struct *sig = current->signal;
 	siginfo_t info;
 
 	BUG_ON((exit_code & (0x7f | ~0xffff)) != SIGTRAP);
@@ -1885,6 +1886,13 @@ static void ptrace_do_notify(int exit_code, int why)
 	info.si_pid = task_pid_vnr(current);
 	info.si_uid = current_uid();
 
+	if ((current->ptrace & PT_SEIZED) &&
+	    (sig->group_stop_count || sig->flags & SIGNAL_STOP_STOPPED)) {
+		info.si_pt_flags |= PTRACE_SI_STOPPED;
+		info.si_signo = current->jobctl & JOBCTL_STOP_SIGMASK;
+		WARN_ON_ONCE(!info.si_signo);
+	}
+
 	/* Let the debugger run.  */
 	ptrace_stop(exit_code, why, 1, &info);
 }
-- 
1.7.5.2

