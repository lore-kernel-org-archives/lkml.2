Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672Ab1DASNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 14:13:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757141Ab1DASND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 14:13:03 -0400
Date: Fri, 1 Apr 2011 20:12:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com
Subject: [PATCH 3/4] signal: turn SIGNAL_STOP_DEQUEUED into
	GROUP_STOP_DEQUEUED
Message-ID: <20110401181238.GD9010@redhat.com>
References: <20110329144603.GA29865@htj.dyndns.org> <20110329144648.GB29865@htj.dyndns.org> <20110329144710.GC29865@htj.dyndns.org> <20110330192918.GA14861@redhat.com> <20110331072942.GB3385@htj.dyndns.org> <20110331151549.GA8458@redhat.com> <20110331163441.GF3385@htj.dyndns.org> <20110331172946.GA14934@redhat.com> <20110401181123.GA9010@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110401181123.GA9010@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves SIGNAL_STOP_DEQUEUED from signal_struct->flags to
task_struct->group_stop, and thus makes it per-thread.

Like SIGNAL_STOP_DEQUEUED, GROUP_STOP_DEQUEUED can be false-positive
after return from get_signal_to_deliver, this is fine. The only purpose
of this bit is: we can drop ->siglock after __dequeue_signal() returns
the sig_kernel_stop() signal and before we call do_signal_stop(), in
this case we must not miss SIGCONT if it comes in between.

But, unlike SIGNAL_STOP_DEQUEUED, GROUP_STOP_DEQUEUED can not be
false-positive in do_signal_stop() if multiple threads dequeue the
sig_kernel_stop() signal at the same time.

Consider two threads T1 and T2, SIGTTIN has a hanlder.

	- T1 dequeues SIGTSTP and sets SIGNAL_STOP_DEQUEUED, then
	  it drops ->siglock

	- SIGCONT comes and clears SIGNAL_STOP_DEQUEUED, SIGTSTP
	  should be cancelled.

	- T2 dequeues SIGTTIN and sets SIGNAL_STOP_DEQUEUED again.
	  Since we have a handler we should not stop, T2 returns
	  to usermode to run the handler.

	- T1 continues, calls do_signal_stop() and wrongly starts
	  the group stop because SIGNAL_STOP_DEQUEUED was restored
	  in between.

With or without this change:

	- we need to do something with ptrace_signal() which can
	  return SIGSTOP, but this needs another discussion

	- SIGSTOP can be lost if it races with the mt exec, will
	  be fixed later.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/sched.h |    6 +++---
 kernel/signal.c       |   14 ++++----------
 2 files changed, 7 insertions(+), 13 deletions(-)

--- ptrace/include/linux/sched.h~3_make_stop_dequeued_per_thread	2011-04-01 16:36:29.000000000 +0200
+++ ptrace/include/linux/sched.h	2011-04-01 18:50:38.000000000 +0200
@@ -652,9 +652,8 @@ struct signal_struct {
  * Bits in flags field of signal_struct.
  */
 #define SIGNAL_STOP_STOPPED	0x00000001 /* job control stop in effect */
-#define SIGNAL_STOP_DEQUEUED	0x00000002 /* stop signal dequeued */
-#define SIGNAL_STOP_CONTINUED	0x00000004 /* SIGCONT since WCONTINUED reap */
-#define SIGNAL_GROUP_EXIT	0x00000008 /* group exit in progress */
+#define SIGNAL_STOP_CONTINUED	0x00000002 /* SIGCONT since WCONTINUED reap */
+#define SIGNAL_GROUP_EXIT	0x00000004 /* group exit in progress */
 /*
  * Pending notifications to parent.
  */
@@ -1779,6 +1778,7 @@ extern void thread_group_times(struct ta
 #define GROUP_STOP_PENDING	(1 << 16) /* task should stop for group stop */
 #define GROUP_STOP_CONSUME	(1 << 17) /* consume group stop count */
 #define GROUP_STOP_TRAPPING	(1 << 18) /* switching from STOPPED to TRACED */
+#define GROUP_STOP_DEQUEUED	(1 << 19) /* stop signal dequeued */
 
 extern void task_clear_group_stop_pending(struct task_struct *task);
 
--- ptrace/kernel/signal.c~3_make_stop_dequeued_per_thread	2011-04-01 18:10:18.000000000 +0200
+++ ptrace/kernel/signal.c	2011-04-01 18:58:41.000000000 +0200
@@ -254,7 +254,8 @@ static void task_clear_group_stop_trappi
  */
 void task_clear_group_stop_pending(struct task_struct *task)
 {
-	task->group_stop &= ~(GROUP_STOP_PENDING | GROUP_STOP_CONSUME);
+	task->group_stop &= ~(GROUP_STOP_PENDING | GROUP_STOP_CONSUME |
+				GROUP_STOP_DEQUEUED);
 }
 
 /**
@@ -602,7 +603,7 @@ int dequeue_signal(struct task_struct *t
 		 * is to alert stop-signal processing code when another
 		 * processor has come along and cleared the flag.
 		 */
-		tsk->signal->flags |= SIGNAL_STOP_DEQUEUED;
+		current->group_stop |= GROUP_STOP_DEQUEUED;
 	}
 	if ((info->si_code & __SI_MASK) == __SI_TIMER && info->si_sys_private) {
 		/*
@@ -821,13 +822,6 @@ static int prepare_signal(int sig, struc
 			signal->flags = why | SIGNAL_STOP_CONTINUED;
 			signal->group_stop_count = 0;
 			signal->group_exit_code = 0;
-		} else {
-			/*
-			 * We are not stopped, but there could be a stop
-			 * signal in the middle of being processed after
-			 * being removed from the queue.  Clear that too.
-			 */
-			signal->flags &= ~SIGNAL_STOP_DEQUEUED;
 		}
 	}
 
@@ -1855,7 +1849,7 @@ static int do_signal_stop(int signr)
 		/* signr will be recorded in task->group_stop for retries */
 		WARN_ON_ONCE(signr & ~GROUP_STOP_SIGMASK);
 
-		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED) ||
+		if (!likely(current->group_stop & GROUP_STOP_DEQUEUED) ||
 		    unlikely(signal_group_exit(sig)))
 			return 0;
 		/*

