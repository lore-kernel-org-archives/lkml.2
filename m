Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab1C2Krk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 06:47:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:51143 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab1C2Krj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 06:47:39 -0400
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
 value
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <1301387532.4859.54.camel@twins>
References: <20110324164436.GC1930@jolsa.brq.redhat.com>
	 <1301153868.2250.359.camel@laptop> <20110326161346.GA18272@redhat.com>
	 <1301157483.2250.366.camel@laptop> <20110326170922.GA20329@redhat.com>
	 <20110326173545.GA22919@redhat.com> <1301164168.2250.370.camel@laptop>
	 <20110328133033.GA8254@redhat.com> <1301324275.4859.25.camel@twins>
	 <1301327368.4859.28.camel@twins>  <20110328165648.GA9304@redhat.com>
	 <1301387532.4859.54.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Mar 2011 12:49:49 +0200
Message-ID: <1301395789.2250.376.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-29 at 10:32 +0200, Peter Zijlstra wrote:
> @@ -2922,15 +2926,40 @@ static void free_event(struct perf_event
>         call_rcu(&event->rcu_head, free_event_rcu);
>  }
>  
> -int perf_event_release_kernel(struct perf_event *event)
> +static int __perf_event_release(void *info)
>  {
> +       struct perf_event *event = info;
>         struct perf_event_context *ctx = event->ctx;
> +       struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
> +       int ret;
>  
>         /*
> -        * Remove from the PMU, can't get re-enabled since we got
> -        * here because the last ref went.
> +        * Disable the event if its still running, we're shutting down.
>          */
> -       perf_event_disable(event);
> +       ret = __perf_event_disable(info);
> +       if (ret)
> +               return ret;
> +
> +       raw_spin_lock_irq(&ctx->lock);
> +       perf_group_detach(event);
> +       list_del_event(event, ctx);
> +       /*
> +        * In case we removed the last event from an active task_ctx
> +        * deactivate the task_ctx because this event being freed might
> +        * lead to the perf_sched_events jump_label being disabled
> +        * which avoids the task sched-out hook from being called.
> +        */
> +       if (!ctx->nr_events && cpuctx->task_ctx == ctx) {
> +               ctx->is_active = 0;
> +               cpuctx->task_ctx = NULL;
> +       }
> +       raw_spin_unlock_irq(&ctx->lock);
> +}
> +
> +int perf_event_release_kernel(struct perf_event *event)
> +{
> +       struct perf_event_context *ctx = event->ctx;
> +       struct task_struct *task = ctx->task;
>  
>         WARN_ON_ONCE(ctx->parent_ctx);
>         /*
> @@ -2946,10 +2975,28 @@ int perf_event_release_kernel(struct per
>          *     to trigger the AB-BA case.
>          */
>         mutex_lock_nested(&ctx->mutex, SINGLE_DEPTH_NESTING);
> +       if (!task) {
> +               cpu_function_call(event->cpu, __perf_event_release, event);
> +               goto unlock;
> +       }
> +
> +retry:
> +       if (!task_function_call(task, __perf_event_release, event))
> +               goto unlock;
> +
>         raw_spin_lock_irq(&ctx->lock);
> +       if (ctx->is_active) {
> +               raw_spin_unlock_irq(&ctx->lock);
> +               goto retry;
> +       }
> +
> +       WARN_ON_ONCE(event->state == PERF_EVENT_STATE_ACTIVE);
> +
>         perf_group_detach(event);
>         list_del_event(event, ctx);
>         raw_spin_unlock_irq(&ctx->lock);
> +
> +unlock:
>         mutex_unlock(&ctx->mutex);
>  
>         free_event(event);

we can simplify that and use perf_remove_from_context(), except that
changes the close() semantics slightly for grouped events, the current
code will I think deschedule the complete group when you close the
leader, when using pref_remote_from_context() we'll promote the siblings
to individual events and let them run when you close the leader.

I'm fairly sure no-one _should_ rely on that, but they _might_..

