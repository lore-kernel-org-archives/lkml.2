Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab1DASMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 14:12:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757991Ab1DASMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 14:12:16 -0400
Date: Fri, 1 Apr 2011 20:11:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com
Subject: [PATCH 1/4] signal: prepare_signal(SIGCONT) shouldn't play with
	TIF_SIGPENDING
Message-ID: <20110401181150.GB9010@redhat.com>
References: <20110329144603.GA29865@htj.dyndns.org> <20110329144648.GB29865@htj.dyndns.org> <20110329144710.GC29865@htj.dyndns.org> <20110330192918.GA14861@redhat.com> <20110331072942.GB3385@htj.dyndns.org> <20110331151549.GA8458@redhat.com> <20110331163441.GF3385@htj.dyndns.org> <20110331172946.GA14934@redhat.com> <20110401181123.GA9010@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110401181123.GA9010@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prepare_signal(SIGCONT) should never set TIF_SIGPENDING or wake up
the TASK_INTERRUPTIBLE threads. We are going to call complete_signal()
which should pick the right thread correctly. All we need is to wake
up the TASK_STOPPED threads.

If the task was stopped, it can't return to usermode without taking
->siglock. Otherwise we don't care, and the spurious TIF_SIGPENDING
can't be useful.

The comment says:

	* If there is a handler for SIGCONT, we must make
	* sure that no thread returns to user mode before
	* we post the signal

It is not clear what this means. Probably, "when there's only a single
thread" and this continues to be true. Otherwise, even if this SIGCONT
is not private, with or without this change only one thread can dequeue
SIGCONT, other threads can happily return to user mode before before
that thread handles this signal.

Note also that wake_up_state(t, __TASK_STOPPED) can't race with the task
which changes its state, TASK_STOPPED state is protected by ->siglock as
well.

In short: when it comes to signal delivery, SIGCONT is the normal signal
and does not need any special support.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/signal.c |   27 ++-------------------------
 1 file changed, 2 insertions(+), 25 deletions(-)

--- ptrace/kernel/signal.c~1_cont_remove_sigwake	2011-04-01 16:36:29.000000000 +0200
+++ ptrace/kernel/signal.c	2011-04-01 17:12:07.000000000 +0200
@@ -788,37 +788,14 @@ static int prepare_signal(int sig, struc
 	} else if (sig == SIGCONT) {
 		unsigned int why;
 		/*
-		 * Remove all stop signals from all queues,
-		 * and wake all threads.
+		 * Remove all stop signals from all queues, wake all threads.
 		 */
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
+			wake_up_state(t, __TASK_STOPPED);
 		} while_each_thread(p, t);
 
 		/*

