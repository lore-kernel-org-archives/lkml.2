Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab1EXSkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:40:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45008 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932938Ab1EXSiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:38:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=VFnwOZusOViwmu+WmqWBX4uVXsKy1rBhxmYcPIk5PWkS9cERWwscqlXuj4yMitCIMC
         jARrTIXZou82qu6KH9hfs+GjDqkjQxBHopDbZNXWv1DLfaSQBycryuNLpvaUeJkhSTMX
         Zpdvqp342UR21YlSrWSpJhQyR0jcj+6JX65Ik=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/19] ptrace: implement PTRACE_INTERRUPT
Date: Tue, 24 May 2011 20:37:33 +0200
Message-Id: <1306262259-7285-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1306262259-7285-1-git-send-email-tj@kernel.org>
References: <1306262259-7285-1-git-send-email-tj@kernel.org>
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
	  if (argc > 1) {
		  waitid(P_PID, tracee, NULL, WSTOPPED);
		  ptrace(PTRACE_CONT, tracee, NULL, NULL);
	  }
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
interrupted and then detached back to running state.

  # ./test-interrupt
  tracee: alive pid=4546
  tracee: alive pid=4546
  tracee: alive pid=4546
  tracer: INTERRUPT and DETACH
  tracee: alive pid=4546
  tracee: alive pid=4546
  tracee: alive pid=4546
  tracer: exiting

When called with argument, tracee is seized from stopped state,
continued, interrupted and then detached back to stopped state.

  # ./test-interrupt  1
  tracee: alive pid=4548
  tracee: alive pid=4548
  tracee: alive pid=4548
  tracer: INTERRUPT and DETACH
  tracer: exiting

Before PTRACE_INTERRUPT, once the tracee was running, there was no way
to trap tracee and do PTRACE_DETACH without causing side effect.

-v2: Updated to use task_set_jobctl_pending() so that it doesn't end
     up scheduling TRAP_STOP if child is dying which may make the
     child unkillable.  Spotted by Oleg.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/ptrace.h |    1 +
 kernel/ptrace.c        |   27 +++++++++++++++++++++++++--
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index cfb6c97..8c45eb0 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -48,6 +48,7 @@
 #define PTRACE_SETREGSET	0x4205
 
 #define PTRACE_SEIZE		0x4206
+#define PTRACE_INTERRUPT	0x4207
 
 /* flags in @data for PTRACE_SEIZE */
 #define PTRACE_SEIZE_DEVEL	0x80000000 /* temp flag for development */
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 132857a..3911567 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -704,6 +704,7 @@ int ptrace_request(struct task_struct *child, long request,
 	siginfo_t siginfo;
 	void __user *datavp = (void __user *) data;
 	unsigned long __user *datalp = datavp;
+	unsigned long flags;
 
 	switch (request) {
 	case PTRACE_PEEKTEXT:
@@ -736,6 +737,26 @@ int ptrace_request(struct task_struct *child, long request,
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
+			if (task_set_jobctl_pending(child, JOBCTL_TRAP_STOP))
+				signal_wake_up(child, 0);
+			unlock_task_sighand(child, &flags);
+			ret = 0;
+		}
+		break;
+
 	case PTRACE_DETACH:	 /* detach a process that was attached. */
 		ret = ptrace_detach(child, data);
 		break;
@@ -861,7 +882,8 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, unsigned long, addr,
 		goto out_put_task_struct;
 	}
 
-	ret = ptrace_check_attach(child, request == PTRACE_KILL);
+	ret = ptrace_check_attach(child, request == PTRACE_KILL ||
+				  request == PTRACE_INTERRUPT);
 	if (ret < 0)
 		goto out_put_task_struct;
 
@@ -1003,7 +1025,8 @@ asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
 		goto out_put_task_struct;
 	}
 
-	ret = ptrace_check_attach(child, request == PTRACE_KILL);
+	ret = ptrace_check_attach(child, request == PTRACE_KILL ||
+				  request == PTRACE_INTERRUPT);
 	if (!ret)
 		ret = compat_arch_ptrace(child, request, addr, data);
 
-- 
1.7.1

