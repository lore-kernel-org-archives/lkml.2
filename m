Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab1FMUfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 16:35:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab1FMUfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 16:35:45 -0400
Date: Mon, 13 Jun 2011 22:33:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
Subject: Re: [PATCH 17/17] ptrace: implement PTRACE_LISTEN
Message-ID: <20110613203341.GA15695@redhat.com>
References: <1306710760-16440-1-git-send-email-tj@kernel.org> <1306710760-16440-18-git-send-email-tj@kernel.org> <20110602173330.GA20384@redhat.com> <20110613141023.GA8141@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110613141023.GA8141@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun,

On 06/13, Tejun Heo wrote:
>
> On Thu, Jun 02, 2011 at 07:33:30PM +0200, Oleg Nesterov wrote:
> > > +		/*
> > > +		 * If NOTIFY is set, it means event happened between start
> > > +		 * of this trap and now.  Trigger re-trap immediately.
> > > +		 */
> > > +		if (child->jobctl & JOBCTL_TRAP_NOTIFY)
> > > +			signal_wake_up(child, true);
> >
> > Again, I won't insist if you prefer signal_wake_up(), but afaics
> > wake_up_state(__TASK_TRACED) should be enough.
>
> Re-trapping from attach/detach paths are already using
> signal_wake_up()

because attach sets TRAP_STOP which contributes to recalc_sigpending().

If JOBCTL_TRAP_NOTIFY is set, TIF_SIGPENDING should be already set as
well by the same reason. And in any case ptrace_stop() does
recalc_sigpending_tsk() before return, TIF_SIGPENDING is never really
needed when we are going to wake up the TASK_TRACED task.

However,

> and I think it would be better to keep it consistent.

OK, I don't really mind, up to you.

> > OK. The only thing I can't understand is why prepare_signal(SIGCONT)
> > calls ptrace_trap_notify() unconditionally. How about
> >
> > 		if (likely(!(t->ptrace & PT_SEIZED)))
> > 			wake_up_state(t, __TASK_STOPPED);
> > 	-	else
> > 	+	else if (why)
> > 			ptrace_trap_notify(t);
> >
> > ?
>
> I'm having a Deja Vu.

Me too...

> Did I reply to this already?  Anyways, here are
> my rationales.
>
> * Tracer should be able to handle seemingly spurious notifications.
> ...
> SIGCONT always generating notification is correct

Yes, I didn't say this is wrong.

>   and I don't see
>   good reasons to optimize it.  Moreover, I think it doesn't hurt to
>   have a way to reliably trigger spurious notification.

Well. I don't really understand why, but OK. Let's keep it this way.

> * If we're gonna optimize out SIGCONT processing if the target process
>   doesn't need it, the proper way would be testing stopped state and
>   exit before walking through the group list.

We can't, at least we need rm_from_queue(SIG_KERNEL_STOP_MASK) and
task_clear_jobctl_pending().


> However, I think it's
>   done the current way for a reason - always trying to wake up on
>   SIGCONT is more robust in case something went out of sync

Hmm. I am wondering if we can ever see why == 0 && __TASK_STOPPED with
the recent fixes...

> So, I'd like to keep this one as it currently is.

OK.

Oleg.

