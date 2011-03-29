Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab1C2RiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 13:38:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab1C2RiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 13:38:24 -0400
Date: Tue, 29 Mar 2011 18:28:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
	value
Message-ID: <20110329162851.GA6317@redhat.com>
References: <20110326161346.GA18272@redhat.com> <1301157483.2250.366.camel@laptop> <20110326170922.GA20329@redhat.com> <20110326173545.GA22919@redhat.com> <1301164168.2250.370.camel@laptop> <20110328133033.GA8254@redhat.com> <1301324275.4859.25.camel@twins> <1301327368.4859.28.camel@twins> <20110328165648.GA9304@redhat.com> <1301387532.4859.54.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301387532.4859.54.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29, Peter Zijlstra wrote:
>
> On Mon, 2011-03-28 at 18:56 +0200, Oleg Nesterov wrote:
> >
> > jump_label_dec:
> >
> > 	if (atomic_dec_and_test(key))
> > 		jump_label_disable(key);
> >
> > Another thread can create the PERF_ATTACH_TASK event in between
> > and call jump_label_update(JUMP_LABEL_ENABLE) first. Looks like,
> > jump_label_update() should ensure that "type" matches the state
> > of the "*key" under jump_label_lock().
>
> No I think you're right, and I think we fixed that but it looks like
> Ingo still didn't merge the new jump-label patches :/

OK. To remind, we have another problem, perf_install can race with exit.
But lets ignore this for now...

You know, I honestly tried to convince myself I can understand your
patch. All I can say, I'll try to read it again ;) But the main idea
is clear, we give more respect to ->nr_events and once it is zero
task_ctx must not be active.

> @@ -2114,8 +2107,19 @@ static void perf_event_context_sched_in(
>  	struct perf_cpu_context *cpuctx;
>
>  	cpuctx = __get_cpu_context(ctx);
> -	if (cpuctx->task_ctx == ctx)
> +	raw_spin_lock(&ctx->lock);
> +	/*
> +	 * Serialize against perf_install_in_context(), the interesting case
> +	 * is where perf_install_in_context() finds the context inactive and
> +	 * another cpu is just about to schedule the task in. In that case
> +	 * we need to avoid observing a stale ctx->nr_events.

I don't understand the comment... We can't race __perf_install_in_context,
it can only run on the same CPU but we are called with irqs disabled.

> +	ctx->is_active = 1;
> +	if (cpuctx->task_ctx == ctx || !ctx->nr_events) {
> +		raw_spin_lock(&ctx->lock);
>  		return;

I guess you meant _unlock.

But now I don't understand what ->is_active means. We make it true,
but doesn't set cpuctx->task_ctx = ctx. Why __perf_event_release()
clears ->is_active then?

This looks wrong at first glance. Suppose we have the same problem,
this task misses perf_event_context_sched_out() after that. OK,
->task_ctx == NULL.

But, suppose that after that this task sleeps "forever" and we create
another counter and call perf_install_in_context() again. Now we hang
in "retry" loop.

It seems to me, instead we should change ctx_sched_in() to check
nr_events and do nothing if it is zero.

> +	}
> +	raw_spin_lock(&ctx->lock);

Again, s/lock/unlock/

> +	cpuctx->task_ctx = ctx;
> +
>  	ctx_sched_in(ctx, cpuctx, EVENT_PINNED, task);

But we already dropped ctx->lock, __perf_event_release() can remove
the last event before ctx_sched_in() takes it again.

This should be moved into ctx_sched_in() afaics, but this is not simple.

So, perhaps we can take ctx->lock and check nr_events after the 2nd
ctx_sched_in(). If it is zero, we should clear task_ctx/is_active.

Perhaps. Right now I got lost.

Oleg.

