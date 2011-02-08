Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab1BHWbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 17:31:08 -0500
Received: from smtp-out.google.com ([74.125.121.67]:10311 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab1BHWbF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 17:31:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ERgKVrfqb9VxHaaJ2x3Q2DUNeaFqbHd5oS6vxOAqITHJb3AprHwXVX9gTTxLVyCTdO
         Hizdmtne/Fb9sVXORVtg==
MIME-Version: 1.0
In-Reply-To: <1297095037.13327.47.camel@laptop>
References: <4d384700.2308e30a.70bc.ffffd532@mx.google.com>
	<1297095037.13327.47.camel@laptop>
Date: Tue, 8 Feb 2011 23:31:02 +0100
Message-ID: <AANLkTi=abaUN6m9ZWQuri_Y-487YZzjnTujQMP61QdmW@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf_events: add cgroup support (v8)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

See comments below.


On Mon, Feb 7, 2011 at 5:10 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> Compile tested only, depends on the cgroup::exit patch
>
> --- linux-2.6.orig/include/linux/perf_event.h
> +++ linux-2.6/include/linux/perf_event.h
> @@ -905,6 +929,9 @@ struct perf_cpu_context {
>        struct list_head                rotation_list;
>        int                             jiffies_interval;
>        struct pmu                      *active_pmu;
> +#ifdef CONFIG_CGROUP_PERF
> +       struct perf_cgroup              *cgrp;
> +#endif
>  };
>
I don't quite understand the motivation for adding cgrp to cpuctx.

> --- linux-2.6.orig/kernel/perf_event.c
> +++ linux-2.6/kernel/perf_event.c
> +static inline void update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx)
> +{
> +       struct perf_cgroup *cgrp_out = cpuctx->cgrp;
> +       if (cgrp_out)
> +               __update_cgrp_time(cgrp_out);
> +}
> +
What's the benefit of this form compared to the original from_task() version?

> +void perf_cgroup_switch(struct task_struct *task, int mode)
> +{
> +       struct perf_cpu_context *cpuctx;
> +       struct pmu *pmu;
> +       unsigned long flags;
> +
> +       /*
> +        * disable interrupts to avoid geting nr_cgroup
> +        * changes via __perf_event_disable(). Also
> +        * avoids preemption.
> +        */
> +       local_irq_save(flags);
> +
> +       /*
> +        * we reschedule only in the presence of cgroup
> +        * constrained events.
> +        */
> +       rcu_read_lock();
> +
> +       list_for_each_entry_rcu(pmu, &pmus, entry) {
> +
> +               cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
> +
> +               perf_pmu_disable(cpuctx->ctx.pmu);
> +
> +               /*
> +                * perf_cgroup_events says at least one
> +                * context on this CPU has cgroup events.
> +                *
> +                * ctx->nr_cgroups reports the number of cgroup
> +                * events for a context.
> +                */
> +               if (cpuctx->ctx.nr_cgroups > 0) {
> +
> +                       if (mode & PERF_CGROUP_SWOUT)
> +                               cpu_ctx_sched_out(cpuctx, EVENT_ALL);
> +
> +                       if (mode & PERF_CGROUP_SWIN) {
> +                               cpu_ctx_sched_in(cpuctx, EVENT_ALL, task, 1);
> +                               cpuctx->cgrp = perf_cgroup_from_task(task);
> +                       }
> +               }
I think there is a risk on cpuctx->cgrp pointing to stale cgrp information.
Shouldn't we also set cpuctx->cgrp = NULL on SWOUT?

> +static int __perf_cgroup_move(void *info)
> +{
> +       struct task_struct *task = info;
> +       perf_cgroup_switch(task, PERF_CGROUP_SWOUT | PERF_CGROUP_SWIN);
> +       return 0;
> +}
> +
> +static void perf_cgroup_move(struct task_struct *task)
> +{
> +       task_function_call(task, __perf_cgroup_move, task);
> +}
> +
> +static void perf_cgroup_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
> +               struct cgroup *old_cgrp, struct task_struct *task,
> +               bool threadgroup)
> +{
> +       perf_cgroup_move(task);
> +       if (threadgroup) {
> +               struct task_struct *c;
> +               rcu_read_lock();
> +               list_for_each_entry_rcu(c, &task->thread_group, thread_group) {
> +                       perf_cgroup_move(c);
> +               }
> +               rcu_read_unlock();
> +       }
> +}
> +
I suspect my original patch was not necessarily handling the attach completely
when you move an existing task into a cgroup which was already monitored.
I think you may have had to wait until a ctxsw. Looks like this callback handles
this better.

Let me make sure I understand the threadgroup iteration, though. I suspect
this handles the situation where a multi-threaded app is moved into a cgroup
while there is already cgroup monitoring active. In that case and if we do not
want to wait until there is at least one ctxsw on all CPUs, then we have to
check if the other threads are not already running on the other CPUs.If so,
we need to do a cgroup switch on those CPUs. Otherwise, we have nothing to
do. Am I getting this right?

> +static void perf_cgroup_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
> +               struct cgroup *old_cgrp, struct task_struct *task)
> +{
> +       /*
> +        * cgroup_exit() is called in the copy_process() failure path.
> +        * Ignore this case since the task hasn't ran yet, this avoids
> +        * trying to poke a half freed task state from generic code.
> +        */
> +       if (!(task->flags & PF_EXITING))
> +               return;
> +
> +       perf_cgroup_move(task);
> +}
> +
Those callbacks looks good to me. They certainly alleviate the need for the
hack in cgorup_exit().

Thanks for fixing this.

> +struct cgroup_subsys perf_subsys = {
> +       .name = "perf_event",
> +       .subsys_id = perf_subsys_id,
> +       .create = perf_cgroup_create,
> +       .destroy = perf_cgroup_destroy,
> +       .exit = perf_cgroup_exit,
> +       .attach = perf_cgroup_attach,
> +};
> +#endif /* CONFIG_CGROUP_PERF */
>
>
>
