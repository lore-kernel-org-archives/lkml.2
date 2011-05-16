Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab1EPSRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 14:17:43 -0400
Received: from mail-bw0-f52.google.com ([209.85.214.52]:37249 "EHLO
	mail-bw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab1EPSRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 14:17:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=qHjr0UX6SbwL31LuK3a4uHcwWGzk0LdJ2mYIQDVSuwr+57dad5dHGM+s2LDkUI0co8
         st1wg2v90VKCAnvpWtXadIx0K1zErVIffzQevpjbxTpClO4Di3oMjlzJWaaeoKuzljnK
         4Rcm06mgGQ8LUSdT2ynxhW4skNddn7PwHqEjU=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/10] ptrace: implement PTRACE_INTERRUPT
Date: Mon, 16 May 2011 20:17:23 +0200
Message-Id: <1305569849-10448-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1305569849-10448-1-git-send-email-tj@kernel.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, there's no way to trap a running ptracee short of sending a
signal which has various side effects.  This patch implements
PTRACE_INTERRUPT which traps ptracee without any signal or job control
related side effect.

The implementation is almost trivial.  It uses the group stop trap -
SIGTRAP | PTRACE_EVENT_STOP << 8.  A new trap flag
JOBCTL_TRAP_INTERRUPT is added, which is set on PTRACE_INTERRUPT and
cleared when any trap happens.  As INTERRUPT should be useable
regardless of the current state of tracee, task_is_traced() test in
ptrace_check_attach() is skipped for INTERRUPT.

PTRACE_INTERRUPT is available iff tracee is attached with
PTRACE_SEIZE.

Test program follows.

  #define PTRACE_SEIZE		0x4206
  #define PTRACE_INTERRUPT	0x4207

  #define PTRACE_SEIZE_DEVEL	0x80000000

  static const struct timespec ts100ms = { .tv_nsec = 100000000 };
  static const struct timespec ts1s = { .tv_sec = 1 };
  static const struct timespec ts3s = { .tv_sec = 3 };

  int main(int argc, char **argv)
  {
	  pid_t tracee;

	  tracee = fork();
	  if (tracee == 0) {
		  nanosleep(&ts100ms, NULL);
		  while (1) {
			  printf("tracee: alive pid=%d\n", getpid());
			  nanosleep(&ts1s, NULL);
		  }
	  }

	  if (argc > 1)
		  kill(tracee, SIGSTOP);

	  nanosleep(&ts100ms, NULL);

	  ptrace(PTRACE_SEIZE, tracee, NULL,
		 (void *)(unsigned long)PTRACE_SEIZE_DEVEL);
	  waitid(P_PID, tracee, NULL, WSTOPPED);
	  ptrace(PTRACE_CONT, tracee, NULL, NULL);
	  nanosleep(&ts3s, NULL);

	  printf("tracer: INTERRUPT and DETACH\n");
	  ptrace(PTRACE_INTERRUPT, tracee, NULL, NULL);
	  waitid(P_PID, tracee, NULL, WSTOPPED);
	  ptrace(PTRACE_DETACH, tracee, NULL, NULL);
	  nanosleep(&ts3s, NULL);

	  printf("tracer: exiting\n");
	  kill(tracee, SIGKILL);
	  return 0;
  }

When called without argument, tracee is seized from running state,
continued, interrupted and then detached back to running state.

  # ./test-interrupt
  tracee: alive pid=4546
  tracee: alive pid=4546
  tracee: alive pid=4546
  tracer: INTERRUPT and DETACH
  tracee: alive pid=4546
  tracee: alive pid=4546
  tracee: alive pid=4546
  tracer: exiting

When called with argument, it's the same but tracee is detached back
to stopped state.

  # ./test-interrupt  1
  tracee: alive pid=4548
  tracee: alive pid=4548
  tracee: alive pid=4548
  tracer: INTERRUPT and DETACH
  tracer: exiting

Before PTRACE_INTERRUPT, once the tracee was continued, there was no
easy way to do PTRACE_DETACH without causing side effect as tracee
couldn't be trapped without side effect.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/ptrace.h |    1 +
 kernel/ptrace.c        |   27 +++++++++++++++++++++++++--
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 3fd389d..b07b9e3 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -48,6 +48,7 @@
 #define PTRACE_SETREGSET	0x4205
 
 #define PTRACE_SEIZE		0x4206
+#define PTRACE_INTERRUPT	0x4207
 
 /* flags in @data for PTRACE_SEIZE */
 #define PTRACE_SEIZE_DEVEL	0x80000000 /* temp flag for development */
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 7aefd43..351db7c 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -706,6 +706,7 @@ int ptrace_request(struct task_struct *child, long request,
 	siginfo_t siginfo;
 	void __user *datavp = (void __user *) data;
 	unsigned long __user *datalp = datavp;
+	unsigned long flags;
 
 	switch (request) {
 	case PTRACE_PEEKTEXT:
@@ -738,6 +739,26 @@ int ptrace_request(struct task_struct *child, long request,
 			ret = ptrace_setsiginfo(child, &siginfo);
 		break;
 
+	case PTRACE_INTERRUPT:
+		/*
+		 * Stop tracee without any side-effect on signal or job
+		 * control.  At least one trap is guaranteed to happen
+		 * after this request.  If @child is already trapped, the
+		 * current trap is not disturbed and another trap will
+		 * happen after the current trap is ended with PTRACE_CONT.
+		 *
+		 * The actual trap might not be PTRACE_EVENT_STOP trap but
+		 * the pending condition is cleared regardless.
+		 */
+		if (likely(child->ptrace & PT_SEIZED) &&
+		    lock_task_sighand(child, &flags)) {
+			child->jobctl |= JOBCTL_TRAP_STOP;
+			signal_wake_up(child, 0);
+			unlock_task_sighand(child, &flags);
+			ret = 0;
+		}
+		break;
+
 	case PTRACE_DETACH:	 /* detach a process that was attached. */
 		ret = ptrace_detach(child, data);
 		break;
@@ -863,7 +884,8 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, unsigned long, addr,
 		goto out_put_task_struct;
 	}
 
-	ret = ptrace_check_attach(child, request == PTRACE_KILL);
+	ret = ptrace_check_attach(child, request == PTRACE_KILL ||
+				  request == PTRACE_INTERRUPT);
 	if (ret < 0)
 		goto out_put_task_struct;
 
@@ -1005,7 +1027,8 @@ asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
 		goto out_put_task_struct;
 	}
 
-	ret = ptrace_check_attach(child, request == PTRACE_KILL);
+	ret = ptrace_check_attach(child, request == PTRACE_KILL ||
+				  request == PTRACE_INTERRUPT);
 	if (!ret)
 		ret = compat_arch_ptrace(child, request, addr, data);
 
-- 
1.7.1

