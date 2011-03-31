Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab1CaRa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 13:30:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab1CaRa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 13:30:26 -0400
Date: Thu, 31 Mar 2011 19:29:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com
Subject: Re: [PATCH 3/3] signal, ptrace: Fix delayed CONTINUED notification
	when ptraced
Message-ID: <20110331172946.GA14934@redhat.com>
References: <20110329144603.GA29865@htj.dyndns.org> <20110329144648.GB29865@htj.dyndns.org> <20110329144710.GC29865@htj.dyndns.org> <20110330192918.GA14861@redhat.com> <20110331072942.GB3385@htj.dyndns.org> <20110331151549.GA8458@redhat.com> <20110331163441.GF3385@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331163441.GF3385@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31, Tejun Heo wrote:
>
> Hello,
>
> On Thu, Mar 31, 2011 at 05:15:49PM +0200, Oleg Nesterov wrote:
> >
> > The comment says:
> >
> > 	* If there is a handler for SIGCONT, we must make
> > 	* sure that no thread returns to user mode before
> > 	* we post the signal
>
> I interpreted it as "when there's only single thread, it should not
> return to userland before executing the signal handler".

Yes... probably.

> >  		rm_from_queue(SIG_KERNEL_STOP_MASK, &signal->shared_pending);
> >  		t = p;
> >  		do {
> > -			unsigned int state;
> >  			rm_from_queue(SIG_KERNEL_STOP_MASK, &t->pending);
> > -			/*
> > -			 * If there is a handler for SIGCONT, we must make
> > -			 * sure that no thread returns to user mode before
> > -			 * we post the signal, in case it was the only
> > -			 * thread eligible to run the signal handler--then
> > -			 * it must not do anything between resuming and
> > -			 * running the handler.  With the TIF_SIGPENDING
> > -			 * flag set, the thread will pause and acquire the
> > -			 * siglock that we hold now and until we've queued
> > -			 * the pending signal.
> > -			 *
> > -			 * Wake up the stopped thread _after_ setting
> > -			 * TIF_SIGPENDING
> > -			 */
> > -			state = __TASK_STOPPED;
> > -			if (sig_user_defined(t, SIGCONT) && !sigismember(&t->blocked, SIGCONT)) {
> > -				set_tsk_thread_flag(t, TIF_SIGPENDING);
> > -				state |= TASK_INTERRUPTIBLE;
> > -			}
> > -			wake_up_state(t, state);
> > +			wake_up_state(t, __TASK_STOPPED);
> >  		} while_each_thread(p, t);
>
> This is awesome and, at the first glance, yeah, this seems to be the
> right thing to do.  That part is pure signal delivery after all.

Great.

> * As wants_signal() doesn't take uninterruptible sleeps into
>   consideration,

Yes! And I already thought about this before (regardless of this change).
This is not really good imho, we can improve the ->curr_target logic a
bit, this looks simple.

> the signal might get delivered later with the change
>   but I don't think it's problematic in any way.

Agreed,

> * Interruptible sleeps won't be disturbed on SIGCONT generation, which
>   is a visible behavior change, but, I agree, this is more of a bug
>   fix.

Yes, agreed. I'll try to make the test-case which shows the difference.

> I'll mull over it a bit more but please go ahead and create a proper
> patch.

Yes, will do tomorrow (and it needs the trivial re-diff against your tree).

I spent too many time today trying to understand what was the original
reason for this code. Looks like, it could die a loooooong ago. Perhaps
the only reason was: handle_stop_signal() could drop ->siglock to notify
the parent. I am not sure, that is why I am a bit nervous and want to
recheck once again.

> I'll apply it to the ptrace branch with the previous two
> patches.  (Can I add your Acked-by's there?)

Yes, thanks Tejun.

Oleg.

