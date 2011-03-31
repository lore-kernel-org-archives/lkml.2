Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab1CaPQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:16:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265Ab1CaPQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:16:27 -0400
Date: Thu, 31 Mar 2011 17:15:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com
Subject: Re: [PATCH 3/3] signal, ptrace: Fix delayed CONTINUED notification
	when ptraced
Message-ID: <20110331151549.GA8458@redhat.com>
References: <20110329144603.GA29865@htj.dyndns.org> <20110329144648.GB29865@htj.dyndns.org> <20110329144710.GC29865@htj.dyndns.org> <20110330192918.GA14861@redhat.com> <20110331072942.GB3385@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331072942.GB3385@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31, Tejun Heo wrote:
>
> On Wed, Mar 30, 2011 at 09:29:18PM +0200, Oleg Nesterov wrote:
> > I don't think this logic should be moved into signal_wake_up(). Simply
> > because it is wrong.
> >
> > Forget about SIGSTOP. Suppose that the thread group is running, and we
> > are doing tkill(SIGCONT). Now, why every thread gets TIF_SIGPENDING +
> > wakeup? This is not correct.
>
> Right, while running, it generates spurious TIF_SIGPENDINGs.  It can
> be trivially worked around by testing if (group_stop_count ||
> STOP_STOPPED) before calling signal_wake_up().

Please look at the patch below. I can't believe it is that simple, I'll
recheck and rediff against your tree. But, it seems, this code is simply
bogus nowadays and can be removed. Or I missed something...

> > Even the kill(SIGCONT) case is not exactly right. This should be
> > handled by complete_signal(). I think we had to set TIF_SIGPENDING
> > before, now the locking is different. I'll try to make the patch.
>
> The wake up is for continuation from group stop, which should be
> handled simiarly to signal delivery but isn't exactly the same thing.
> Maybe moving it to complete_signal() is cleaner but I don't think it's
> a problem of being right or wrong.

No, sorry, I was unclear. I meant, complete_signal() should take care and
set TIF_SIGPENDING properly. But, unless I missed something, it already
does all we need.

> > What do you think?
>
> I think it's good but I don't think it necessarily changes a lot about
> this patch.  We'll be calling signal_wake_up() for that trap from
> prepare_signal() after all, right?

No, I think prepare_signal(SIGCONT) should do this, but only if the
thread is ptraced.

My main objection was, signal_wake_up() shouldn't play with
sig_user_defined/blocked at all. And, we shouldn't blindly set
TIF_SIGPENDING as the current code does.

So. IMHO we need the patch below first, then we should think about the
further changes.

What do you think?

Oleg.

---------------------------------------------------------------------

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

It is not clear what this means. But in any case, even if this SIGCONT
is not private, only one thread can dequeue SIGCONT, other threads can
happily return to user mode before before that thread handles this signal.

Note also that wake_up_state(t, __TASK_STOPPED) can't race with the
task which changes its state, TASK_STOPPED state is protected by
->siglock as well.

--- x/kernel/signal.c
+++ x/kernel/signal.c
@@ -726,34 +726,13 @@ static int prepare_signal(int sig, struc
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

