Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab1AUOeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 09:34:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab1AUOeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 09:34:09 -0500
Date: Fri, 21 Jan 2011 15:26:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
Message-ID: <20110121142616.GA31165@redhat.com>
References: <20101108145647.GA3426@redhat.com> <20101108145725.GA3434@redhat.com> <20110119182141.GA12183@redhat.com> <20110120193033.GA13924@redhat.com> <1295611905.28776.269.camel@laptop> <20110121130323.GA12900@elte.hu> <1295617185.28776.273.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295617185.28776.273.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21, Peter Zijlstra wrote:
>
> On Fri, 2011-01-21 at 14:03 +0100, Ingo Molnar wrote:
> > > > But, it seems, there is another problem. Forget about the exiting,
> > > > I can't understand why we can trust current in the code above.
> > > > With __ARCH_WANT_INTERRUPTS_ON_CTXSW schedule() does:
> > > >
> > > >     // sets cpuctx->task_ctx = NULL
> > > >     perf_event_task_sched_out();
> > > >
> > > >     // enables irqs
> > > >     prepare_lock_switch();
> > > >
> > > >
> > > >     // updates current_task
> > > >     switch_to();
> > > >
> > > > What if IPI comes in the window before switch_to() ?
> > > >
> > > > (the same questions for __perf_event_enable).
> > >
> > > Ingo, do you have any insights in that, I think you wrote all that
> > > initially?
> >
> > Not sure. Can an IPI come there - we have irqs disabled usually, dont we?

__ARCH_WANT_INTERRUPTS_ON_CTXSW enables irqs during prepare_task_switch()

> Ah, I think I see how that works:

Hmm. I don't...

>
>   __perf_event_task_sched_out()
>     perf_event_context_sched_out()
>       if (do_switch)
>         cpuctx->task_ctx = NULL;

exactly, this clears ->task_ctx

> vs
>
>   __perf_install_in_context()
>    if (cpu_ctx->task_ctx != ctx)

And then __perf_install_in_context() sets cpuctx->task_ctx = ctx,
because ctx->task == current && cpuctx->task_ctx == NULL.

Oleg.

