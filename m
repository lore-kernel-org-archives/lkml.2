Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab1CZQXA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 12:23:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab1CZQW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 12:22:59 -0400
Date: Sat, 26 Mar 2011 17:13:46 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
	value
Message-ID: <20110326161346.GA18272@redhat.com>
References: <20110324164436.GC1930@jolsa.brq.redhat.com> <1301153868.2250.359.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301153868.2250.359.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26, Peter Zijlstra wrote:
>
> On Thu, 2011-03-24 at 17:44 +0100, Jiri Olsa wrote:
> >
> > - close is called on event on CPU 0:
> >         - the task is scheduled on CPU 0
> >         - __perf_event_task_sched_in is called
> >         - cpuctx->task_ctx is set
> >         - perf_sched_events jump label is decremented and == 0
> >         - __perf_event_task_sched_out is not called
> >         - cpuctx->task_ctx on CPU 0 stays set
> >
> > - exit is called on CPU 1:
> >         - the task is scheduled on CPU 1
> >         - perf_event_exit_task is called
> >         - task_ctx_sched_out unsets cpuctx->task_ctx on CPU 1
> >         - put_ctx destroys the context
> >
> > - another call of perf_rotate_context on CPU 0 will use invalid
> >   task_ctx pointer, and eventualy panic
> >
> >
> > The attached workaround makes sure that the task_ctx is not set
> > when the context is being removed.  As I said it's not ment to be
> > fix.
>
> Still having somewhat of a cold, how does the below look?
>
> (completely untested so far, will have to bang on your testcase a bit to
> make it work).
>
> ---
>  kernel/perf_event.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index c75925c..2a03cc4 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -1112,6 +1112,8 @@ static int __perf_remove_from_context(void *info)
>  	raw_spin_lock(&ctx->lock);
>  	event_sched_out(event, cpuctx, ctx);
>  	list_del_event(event, ctx);
> +	if (cpuctx->task_ctx == event->ctx && !event->ctx->nr_active)
> +		cpuctx->task_ctx = NULL;

I don't think this is right.

It is too late to clear ->task_ctx when the task exits. It is simply
wrong that cpuctx->task_ctx != NULL after context_switch(). And, once
again ->is_active is still true.

Besides, you can trust __get_cpu_context(), it possible that another
CPU has cpuctx->task_ctx == event->ctx. Otherwise task_ctx_sched_out()
has already cleared cpuctx->task_ctx.

Finally, in this case there are no events attached to this context,
close(event_fd) removes the only one.


But there is one thing I can't understand. Jiri can trigger this bug
even with HAVE_JUMP_LABEL. How? OK, jump_label_dec/jump_label_inc are
obviously racy, but this test-case can't trigger the race.

So, we are doing free_event()->jump_label_dec()->jump_label_update(DISABLE)
and this implies __stop_machine(). This means we have at least one
context_switch() from the task with the active ->task_ctx to the
migration thread. And this happens before JUMP_LABEL() code was
actually changed, perf_event_task_sched_out() should call
__perf_event_task_sched_out() and clear task_ctx. perf_sched_events
is already zero, but this shouldn't matter.

Confused.

Oleg.

Oleg.

Oleg.

