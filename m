Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab1BARgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:36:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755840Ab1BARgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:36:07 -0500
Date: Tue, 1 Feb 2011 18:27:57 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Cure task_oncpu_function_call() races
Message-ID: <20110201172757.GA4586@redhat.com>
References: <20110127221856.GA10539@redhat.com> <1296215577.15234.333.camel@laptop> <1296226667.15234.337.camel@laptop> <20110128162847.GA25088@redhat.com> <1296238278.15234.340.camel@laptop> <20110131172626.GA5407@redhat.com> <1296498205.26581.54.camel@laptop> <20110131191109.GA10906@redhat.com> <1296502154.26581.72.camel@laptop> <1296569037.26581.194.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296569037.26581.194.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01, Peter Zijlstra wrote:
>
> Oleg, I've actually run-tested the below and all seems well (clearly
> I've never actually hit the races found before either, so in that
> respect its not a conclusive test).
>
> Can you agree with this patch?

You know, I already wrote the i-think-it-is-correct email. But then
I decided to read it once again.

> -static void __perf_event_remove_from_context(void *info)
> +static int __perf_remove_from_context(void *info)
>  {
>  	struct perf_event *event = info;
>  	struct perf_event_context *ctx = event->ctx;
>  	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
>
> -	/*
> -	 * If this is a task context, we need to check whether it is
> -	 * the current task context of this cpu. If not it has been
> -	 * scheduled out before the smp call arrived.
> -	 */
> -	if (ctx->task && cpuctx->task_ctx != ctx)
> -		return;

OK, I think this is right... event_sched_out() will see
PERF_EVENT_STATE_INACTIVE if perf_event_task_sched_in() was not
called yet.

But,

> -static void perf_event_remove_from_context(struct perf_event *event)
> +static void perf_remove_from_context(struct perf_event *event)
>  {
> ...
>  	raw_spin_lock_irq(&ctx->lock);
>  	/*
> -	 * If the context is active we need to retry the smp call.
> +	 * If we failed to find a running task, but find it running now that
> +	 * we've acquired the ctx->lock, retry.
>  	 */
> -	if (ctx->nr_active && !list_empty(&event->group_entry)) {
> +	if (task_curr(task)) {
>  		raw_spin_unlock_irq(&ctx->lock);
>  		goto retry;
>  	}
>
>  	/*
> -	 * The lock prevents that this context is scheduled in so we
> -	 * can remove the event safely, if the call above did not
> -	 * succeed.
> +	 * Since the task isn't running, its safe to remove the event, us
> +	 * holding the ctx->lock ensures the task won't get scheduled in.
>  	 */
> -	if (!list_empty(&event->group_entry))
> -		list_del_event(event, ctx);
> +	list_del_event(event, ctx);

this looks suspicious (the same for perf_install_in_context).

Unlike the IPI handler, this can see schedule-in-progress in any state.
In particular, we can see rq->curr == next (so that task_curr() == F),
but before "prev" has already called perf_event_task_sched_out().

So we have to check ctx->is_active, or schedule() should change rq->curr
after perf_event_task_sched_out().

> @@ -753,13 +819,13 @@ void perf_event_disable(struct perf_event *event)
> ...
>  	 */
>  	if (event->state == PERF_EVENT_STATE_ACTIVE) {
>  		raw_spin_unlock_irq(&ctx->lock);
> +		/*
> +		 * Reload the task pointer, it might have been changed by
> +		 * a concurrent perf_event_context_sched_out().
> +		 */
> +		task = ctx->task;
>  		goto retry;

I am wondering why only perf_event_disable() needs this...

Just curious, this is equally needed without this patch?

Oleg.

