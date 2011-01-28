Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab1A1Qg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 11:36:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905Ab1A1Qg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 11:36:56 -0500
Date: Fri, 28 Jan 2011 17:28:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
Message-ID: <20110128162847.GA25088@redhat.com>
References: <1295622304.28776.293.camel@laptop> <20110121204014.GA2870@nowhere> <20110124114234.GA12166@redhat.com> <20110126175322.GA28617@redhat.com> <1296134077.15234.161.camel@laptop> <20110127165712.GC25060@redhat.com> <1296148294.15234.242.camel@laptop> <20110127221856.GA10539@redhat.com> <1296215577.15234.333.camel@laptop> <1296226667.15234.337.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296226667.15234.337.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28, Peter Zijlstra wrote:
>
> On Fri, 2011-01-28 at 12:52 +0100, Peter Zijlstra wrote:
> > Right, so in case the perf_event_task_sched_in() missed the assignment
> > of ->perf_event_ctxp[n], then our above story falls flat on its face.
> >
> > Because then we can not rely on ->in_active being set for running tasks.
> >
> > So we need a task_curr() test under that lock, which would need
> > perf_event_task_sched_out() to be done _before_ we set rq->curr = next,
> > I _think_.
>
> Ok, so how about something like this:
>
> if task_oncpu_function_call() managed to execute the function proper,
> we're done. Otherwise, if while holding the lock, task_curr() is true,
> it means the task is now current and we should try again, if its not, it
> cannot become current because us holding ctx->lock blocks
> perf_event_task_sched_in().
>
> Hmm?

I _feel_ this patch should be right. To me, this even makes the code
more understandable. But I'll try to re-read it once again, somehow
I can't concentrace today.

> @@ -1031,25 +1032,29 @@ perf_install_in_context(struct perf_event_context *ctx,
>  	}
>
>  retry:
> -	task_oncpu_function_call(task, __perf_install_in_context,
> -				 event);
> +	ret = task_oncpu_function_call(task,
> +			__perf_install_in_context, event);
> +
> +	if (!ret)
> +		return;
>
>  	raw_spin_lock_irq(&ctx->lock);
> +
>  	/*
> -	 * we need to retry the smp call.
> +	 * If the task_oncpu_function_call() failed, re-check task_curr() now
> +	 * that we hold ctx->lock(), if it is running retry the IPI.
>  	 */
> -	if (ctx->is_active && list_empty(&event->group_entry)) {
> +	if (task_curr(task)) {

Yes, but task_curr() should be exported.

One note. If this patch is correct (I think it is), then this check
in __perf_install_in_context() and __perf_event_enable()

		if (cpuctx->task_ctx || ctx->task != current)
			return;

should become unneeded. It should be removed or turned into WARN_ON()
imho, otherwise it looks confusing.

Oleg.

