Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab1AaSWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 13:22:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:37673 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab1AaSWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 13:22:31 -0500
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110131172626.GA5407@redhat.com>
References: <20110124114234.GA12166@redhat.com>
	 <20110126175322.GA28617@redhat.com> <1296134077.15234.161.camel@laptop>
	 <20110127165712.GC25060@redhat.com> <1296148294.15234.242.camel@laptop>
	 <20110127221856.GA10539@redhat.com> <1296215577.15234.333.camel@laptop>
	 <1296226667.15234.337.camel@laptop> <20110128162847.GA25088@redhat.com>
	 <1296238278.15234.340.camel@laptop>  <20110131172626.GA5407@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 19:23:25 +0100
Message-ID: <1296498205.26581.54.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-31 at 18:26 +0100, Oleg Nesterov wrote:
> On 01/28, Peter Zijlstra wrote:
> >
> > Just to give you more food for through, I couldn't help myself..
> 
> Hmm. So far I am only trying to understand the perf_install_in_context()
> paths. And, after I spent almost 2 hours, I am starting to believe this
> change is probably good ;)
 
phew ;-)

> I do not understand the point of cpu_function_call() though, it looks
> equal to smp_call_function_single() ?

Very nearly so, except it takes a function that returns an int..

> > -static void __perf_install_in_context(void *info)
> > +static int  __perf_install_in_context(void *info)
> >  {
> >  	struct perf_event *event = info;
> >  	struct perf_event_context *ctx = event->ctx;
> > @@ -942,20 +1015,15 @@ static void __perf_install_in_context(void *info)
> >  	int err;
> >
> >  	/*
> > -	 * If this is a task context, we need to check whether it is
> > -	 * the current task context of this cpu. If not it has been
> > -	 * scheduled out before the smp call arrived.
> > -	 * Or possibly this is the right context but it isn't
> > -	 * on this cpu because it had no events.
> > +	 * In case we're installing a new context to an already running task,
> > +	 * could also happen before perf_event_task_sched_in() on architectures
> > +	 * which do context switches with IRQs enabled.
> >  	 */
> > -	if (ctx->task && cpuctx->task_ctx != ctx) {
> > -		if (cpuctx->task_ctx || ctx->task != current)
> > -			return;
> > -		cpuctx->task_ctx = ctx;
> > -	}
> > +	if (ctx->task && !cpuctx->task_ctx)
> > +		perf_event_context_sched_in(ctx);
> 
> OK... This eliminates the 2nd race with __ARCH_WANT_INTERRUPTS_ON_CTXSW
> (we must not set "cpuctx->task_ctx = ctx" in case "next" is going to
>  do perf_event_context_sched_in() later). So it is enough to check
> rq->curr in remote_function().

Right, but since I moved those functions into perf_event.c (they were
getting rather specific) I can no longer deref (or even obtain) a rq
structure. So it implements rq->curr == p in a somewhat round-about
fashion but it should be identical.

> 
> >  	raw_spin_lock(&ctx->lock);
> > -	ctx->is_active = 1;
> > +	WARN_ON_ONCE(!ctx->is_active);
> 
> This looks wrong if ctx->task == NULL.

cpuctx->ctx should still have ->is_active = 1 I think.

> 
> So. With this patch it is possible that perf_event_context_sched_in()
> is called right after prepare_lock_switch(). Stupid question, why
> can't we always do this then? I mean, what if we change
> prepare_task_switch() to do
> 
> 	perf_event_task_sched_out();
> 	perf_event_task_sched_in();
> 
> ?
> 
> Probably we can unify the COND_STMT(perf_task_events) check and simplify
> the things further.

That might work, Ingo any reason we have a pre and post hook around the
context switch and not a single function?

