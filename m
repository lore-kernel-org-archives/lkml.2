Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab1A0QSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 11:18:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216Ab1A0QSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 11:18:52 -0500
Date: Thu, 27 Jan 2011 17:10:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
Message-ID: <20110127161047.GB25060@redhat.com>
References: <20110121204014.GA2870@nowhere> <20110124114234.GA12166@redhat.com> <20110126175322.GA28617@redhat.com> <20110126184957.GA32578@redhat.com> <1296068731.15234.6.camel@laptop> <1296070383.15234.10.camel@laptop> <20110126211931.GA6778@redhat.com> <20110126213317.GA7403@redhat.com> <1296124337.15234.71.camel@laptop> <1296131387.15234.142.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296131387.15234.142.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27, Peter Zijlstra wrote:
>
> +void task_function_trampoline(void *data)
> +{
> +	struct task_function_call *tfc = data;
> +	struct task_struct *p = tfc->p;
> +	struct rq *rq = this_rq();
> +
> +#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
> +	if (rq->in_ctxsw)
> +		return;
> +#endif
> +
> +	if (rq->curr != p)
> +		return;

Yes, I think this should solve the problem.

>  prepare_task_switch(struct rq *rq, struct task_struct *prev,
>  		    struct task_struct *next)
>  {
> +#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
> +	rq->in_ctxsw = 1;
> +#endif
> +	sched_info_switch(prev, next);
> +	perf_event_task_sched_out(prev, next);
>  	fire_sched_out_preempt_notifiers(prev, next);
>  	prepare_lock_switch(rq, next);
>  	prepare_arch_switch(next);
> +	trace_sched_switch(prev, next);
>  }

Yes, I was wondering why schedule() calls perf_event_task_sched_out().
This way the code looks more symmetrical/understandable.

>  /**
> @@ -2823,6 +2860,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
>  	perf_event_task_sched_in(current);
>  #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
>  	local_irq_enable();
> +	rq->in_ctxsw = 0;

If we think that context_switch finishes here, probably it would be
more clean to clear ->in_ctxsw before local_irq_enable().

>  #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
>  	finish_lock_switch(rq, prev);

But, otoh, maybe finish_lock_switch() can clear in_ctxsw, it already
checks __ARCH_WANT_INTERRUPTS_ON_CTXSW. Likewise, perhaps it can be
set in prepare_lock_switch() which enables irqs.

But this is cosmetic and up to you.

Oleg.

