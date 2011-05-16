Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab1EPSSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 14:18:37 -0400
Received: from mail-bw0-f52.google.com ([209.85.214.52]:60031 "EHLO
	mail-bw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab1EPSRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 14:17:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=IqrGtAuxARzN340BKcnORj9LHEZo9TaYYGGSBSHPQVoQsBpogTkgdO1fT3iUUmCTuW
         bSrqOv4eC7krD8NGadb9xt2j7eAddoLubb3vJaSBZjBibmGb5OxNMj7rhyIh0LQpheh/
         CKMFUAx7JrpSga0NayliT6SGgedbnIvE8wgbs=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/10] ptrace: make group stop state visible via PTRACE_GETSIGINFO
Date: Mon, 16 May 2011 20:17:26 +0200
Message-Id: <1305569849-10448-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1305569849-10448-1-git-send-email-tj@kernel.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If tracee is SEIZED, PTRACE_EVENT_STOP trap is used for group stop;
however, there currently is no way to find out which signal initiated
the group stop or if the group stop is still in effect.

This patch changes PTRACE_GET_SIGINFO on ptrace traps to report group
stop information via si.si_signo and si.si_pt_flags.  Note that it's
only available if tracee was seized.

This doesn't address notification and tracer has to put tracee in an
appropriate trap and poll the flag.  Later patches will deal with
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

		  ptrace(PTRACE_INTERRUPT, tracee, NULL, NULL);
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

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/ptrace.h |    3 +++
 kernel/ptrace.c        |   19 +++++++++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index b07b9e3..72b9150 100644
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
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 42037a4..30d2331 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -573,11 +573,13 @@ static int ptrace_setoptions(struct task_struct *child, unsigned long data)
 
 static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
 {
+	struct signal_struct *sig;
 	unsigned long flags;
 	int error;
 
 	if (!lock_task_sighand(child, &flags))
 		return -ESRCH;
+	sig = child->signal;
 
 	error = -EINVAL;
 	if (!child->last_siginfo)
@@ -585,6 +587,23 @@ static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
 
 	error = 0;
 	*info = *child->last_siginfo;
+
+	/*
+	 * If reporting ptrace trap for a seized tracee, enable reporting
+	 * of info->si_pt_flags.
+	 */
+	if ((child->ptrace & PT_SEIZED) &&
+	    (info->si_code & __SI_MASK) == __SI_TRAP) {
+		/*
+		 * Report whether group stop is in effect w/ SI_STOPPED and
+		 * if so which signal caused it.
+		 */
+		if (sig->group_stop_count || sig->flags & SIGNAL_STOP_STOPPED) {
+			info->si_pt_flags |= PTRACE_SI_STOPPED;
+			info->si_signo = child->jobctl & JOBCTL_STOP_SIGMASK;
+			WARN_ON_ONCE(!info->si_signo);
+		}
+	}
 out_unlock:
 	unlock_task_sighand(child, &flags);
 	return error;
-- 
1.7.1

