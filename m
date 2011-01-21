Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab1AUNDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 08:03:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48925 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403Ab1AUNDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 08:03:51 -0500
Date: Fri, 21 Jan 2011 14:03:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
Message-ID: <20110121130323.GA12900@elte.hu>
References: <20101108145647.GA3426@redhat.com>
 <20101108145725.GA3434@redhat.com>
 <20110119182141.GA12183@redhat.com>
 <20110120193033.GA13924@redhat.com>
 <1295611905.28776.269.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295611905.28776.269.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2011-01-20 at 20:30 +0100, Oleg Nesterov wrote:
> > On 01/19, Oleg Nesterov wrote:
> > >
> > > Also. I believe there are more problems in perf_install_event(), but
> > > I need to recheck.
> > 
> > Help! I can't believe it can be so trivially wrong, but otoh I can't
> > understand how this can be correct.
> > 
> > So, ignoring details and !task case, __perf_install_in_context() does:
> > 
> > 	if (cpuctx->task_ctx || ctx->task != current)
> > 		return;
> > 
> > 	cpuctx->task_ctx = ctx;
> > 	event_sched_in(event);
> > 
> > Stupid question, what if this task has already passed
> > perf_event_exit_task() and thus it doesn't have ->perf_event_ctxp[] ?
> > Given that perf_event_context_sched_out() does nothing if !ctx, who
> > will event_sched_out() this event?
> > 
> > OK, even if I am right this is trivial, we just need the additional
> > check.
> 
> Indeed (or do the cleanup from put_ctx(), but that's too complex a
> change I think).
> 
> > But, it seems, there is another problem. Forget about the exiting,
> > I can't understand why we can trust current in the code above.
> > With __ARCH_WANT_INTERRUPTS_ON_CTXSW schedule() does:
> > 
> > 	// sets cpuctx->task_ctx = NULL
> > 	perf_event_task_sched_out();
> > 
> > 	// enables irqs
> > 	prepare_lock_switch();
> > 
> > 
> > 	// updates current_task
> > 	switch_to();
> > 
> > What if IPI comes in the window before switch_to() ?
> > 
> > (the same questions for __perf_event_enable).
> 
> Ingo, do you have any insights in that, I think you wrote all that
> initially?

Not sure. Can an IPI come there - we have irqs disabled usually, dont we?

Thanks,

	Ingo
