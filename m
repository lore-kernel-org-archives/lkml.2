Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab1CaQet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:34:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44579 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757958Ab1CaQes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:34:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IUSMCpkyX6RPNdmrycinbRqibixkest23dOrW9rFIrO8e4rCGy0ftqSQVRQ4zPgApB
         a0z8ThAeEWyWFVhxtPnYzC29WUKn2CPzBMHnJyea9trShyFLQ8lJ8rpMyuAgZLiMSOcC
         jY/fN6Ms1/rm9H9MRxOTbBM9bZJwIHY+0+0Y4=
Date: Thu, 31 Mar 2011 18:34:41 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com
Subject: Re: [PATCH 3/3] signal, ptrace: Fix delayed CONTINUED notification
 when ptraced
Message-ID: <20110331163441.GF3385@htj.dyndns.org>
References: <20110329144603.GA29865@htj.dyndns.org>
 <20110329144648.GB29865@htj.dyndns.org>
 <20110329144710.GC29865@htj.dyndns.org>
 <20110330192918.GA14861@redhat.com>
 <20110331072942.GB3385@htj.dyndns.org>
 <20110331151549.GA8458@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331151549.GA8458@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Mar 31, 2011 at 05:15:49PM +0200, Oleg Nesterov wrote:
> No, I think prepare_signal(SIGCONT) should do this, but only if the
> thread is ptraced.
> 
> My main objection was, signal_wake_up() shouldn't play with
> sig_user_defined/blocked at all. And, we shouldn't blindly set
> TIF_SIGPENDING as the current code does.

Hmmm... okay.

> prepare_signal(SIGCONT) should never set TIF_SIGPENDING or wake up
> the TASK_INTERRUPTIBLE threads. We are going to call complete_signal()
> which should pick the right thread correctly. All we need is to wake
> up the TASK_STOPPED threads.
> 
> If the task was stopped, it can't return to usermode without taking
> ->siglock. Otherwise we don't care, and the spurious TIF_SIGPENDING
> can't be useful.
> 
> The comment says:
> 
> 	* If there is a handler for SIGCONT, we must make
> 	* sure that no thread returns to user mode before
> 	* we post the signal

I interpreted it as "when there's only single thread, it should not
return to userland before executing the signal handler".

> It is not clear what this means. But in any case, even if this SIGCONT
> is not private, only one thread can dequeue SIGCONT, other threads can
> happily return to user mode before before that thread handles this signal.
> 
> Note also that wake_up_state(t, __TASK_STOPPED) can't race with the
> task which changes its state, TASK_STOPPED state is protected by
> ->siglock as well.
> 
> --- x/kernel/signal.c
> +++ x/kernel/signal.c
> @@ -726,34 +726,13 @@ static int prepare_signal(int sig, struc
>  	} else if (sig == SIGCONT) {
>  		unsigned int why;
>  		/*
> -		 * Remove all stop signals from all queues,
> -		 * and wake all threads.
> +		 * Remove all stop signals from all queues, wake all threads.
>  		 */
>  		rm_from_queue(SIG_KERNEL_STOP_MASK, &signal->shared_pending);
>  		t = p;
>  		do {
> -			unsigned int state;
>  			rm_from_queue(SIG_KERNEL_STOP_MASK, &t->pending);
> -			/*
> -			 * If there is a handler for SIGCONT, we must make
> -			 * sure that no thread returns to user mode before
> -			 * we post the signal, in case it was the only
> -			 * thread eligible to run the signal handler--then
> -			 * it must not do anything between resuming and
> -			 * running the handler.  With the TIF_SIGPENDING
> -			 * flag set, the thread will pause and acquire the
> -			 * siglock that we hold now and until we've queued
> -			 * the pending signal.
> -			 *
> -			 * Wake up the stopped thread _after_ setting
> -			 * TIF_SIGPENDING
> -			 */
> -			state = __TASK_STOPPED;
> -			if (sig_user_defined(t, SIGCONT) && !sigismember(&t->blocked, SIGCONT)) {
> -				set_tsk_thread_flag(t, TIF_SIGPENDING);
> -				state |= TASK_INTERRUPTIBLE;
> -			}
> -			wake_up_state(t, state);
> +			wake_up_state(t, __TASK_STOPPED);
>  		} while_each_thread(p, t);

This is awesome and, at the first glance, yeah, this seems to be the
right thing to do.  That part is pure signal delivery after all.

* As wants_signal() doesn't take uninterruptible sleeps into
  consideration, the signal might get delivered later with the change
  but I don't think it's problematic in any way.

* Interruptible sleeps won't be disturbed on SIGCONT generation, which
  is a visible behavior change, but, I agree, this is more of a bug
  fix.

I'll mull over it a bit more but please go ahead and create a proper
patch.  I'll apply it to the ptrace branch with the previous two
patches.  (Can I add your Acked-by's there?)

Thanks.

-- 
tejun
