Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab0LIAPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 19:15:31 -0500
Received: from smtp-out.google.com ([74.125.121.35]:30758 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab0LIAP3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 19:15:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jGaL3I3k+seHsUiATaSI4T4MXBDbhbRFlnp29d6cT2IU9P0AiVCBJz+V7Erwh8hhKn
         lSVP/QGgmBa6R3R9HRxQ==
MIME-Version: 1.0
In-Reply-To: <1291212007.32004.1529.camel@laptop>
References: <4cf540d1.5d1be30a.7c7b.577d@mx.google.com>
	<1291212007.32004.1529.camel@laptop>
Date: Thu, 9 Dec 2010 01:15:25 +0100
Message-ID: <AANLkTimBQqq3iQaqXfchXoA+A5m_VdnS=_Q96wWAm1Tm@mail.gmail.com>
Subject: Re: [PATCH 4/5] perf_events: add cgroup support (v6)
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

On Wed, Dec 1, 2010 at 3:00 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-11-30 at 19:20 +0200, Stephane Eranian wrote:
>
>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index 66a416b..1c8bee8 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -4790,6 +4790,29 @@ css_get_next(struct cgroup_subsys *ss, int id,
>>       return ret;
>>  }
>>
>> +/*
>> + * get corresponding css from file open on cgroupfs directory
>> + */
>> +struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id)
>> +{
>> +     struct cgroup *cgrp;
>> +     struct inode *inode;
>> +     struct cgroup_subsys_state *css;
>> +
>> +     inode = f->f_dentry->d_inode;
>> +     /* check in cgroup filesystem dir */
>> +     if (inode->i_op != &cgroup_dir_inode_operations)
>> +             return ERR_PTR(-EBADF);
>> +
>> +     if (id < 0 || id >= CGROUP_SUBSYS_COUNT)
>> +             return ERR_PTR(-EINVAL);
>> +
>> +     /* get cgroup */
>> +     cgrp = __d_cgrp(f->f_dentry);
>> +     css = cgrp->subsys[id];
>> +     return css ? css : ERR_PTR(-ENOENT);
>> +}
>
> Since this paradigm was already in use it surprises me you have to add
> this function.. ?
>

Well, I could not find one. If anybody knows of one, I'll be able to
check it out.

>> +#ifdef CONFIG_PERF_CGROUPS
>> +static inline struct perf_cgroup *
>> +perf_cgroup_from_task(struct task_struct *task)
>> +{
>> +     if (!task)
>> +             return NULL;
>> +     return container_of(task_subsys_state(task, perf_subsys_id),
>> +                     struct perf_cgroup, css);
>> +}
>
> Wouldn't it be nicer if the caller ensured to not call it for !task?
>
>
>> +static struct perf_cgroup *perf_get_cgroup(int fd)
>> +{
>> +     struct cgroup_subsys_state *css;
>> +     struct file *file;
>> +     int fput_needed;
>> +
>> +     file = fget_light(fd, &fput_needed);
>> +     if (!file)
>> +             return ERR_PTR(-EBADF);
>> +
>> +     css = cgroup_css_from_dir(file, perf_subsys_id);
>> +     if (!IS_ERR(css))
>> +             css_get(css);
>> +
>> +     fput_light(file, fput_needed);
>> +
>> +     return container_of(css, struct perf_cgroup, css);
>> +}
>> +
>> +static inline void perf_put_cgroup(struct perf_event *event)
>> +{
>> +     if (event->cgrp)
>> +             css_put(&event->cgrp->css);
>> +}
>
> Bit asymmetric, you get a perf_cgroup, but you put a perf_event.
>
Ok, I made this symmetrical now.

>
>> +static inline void __update_css_time(struct perf_cgroup *cgrp)
>> +{
>> +     struct perf_cgroup_info *t;
>> +     u64 now;
>> +     int cpu = smp_processor_id();
>> +
>> +     if (!cgrp)
>> +             return;
>> +
>> +     now = perf_clock();
>> +
>> +     t = per_cpu_ptr(cgrp->info, cpu);
>> +
>> +     t->time += now - t->timestamp;
>> +     t->timestamp = now;
>> +}
>
> Most callers seem to already check for !cgrp, make that all and avoid
> the second conditional?
>
Done.

>> +/*
>> + * called from perf_event_ask_sched_out() conditional to jump label
>> + */
>> +void
>> +perf_cgroup_switch(struct task_struct *task, struct task_struct *next)
>> +{
>> +     struct perf_cgroup *cgrp_out = perf_cgroup_from_task(task);
>> +     struct perf_cgroup *cgrp_in = perf_cgroup_from_task(next);
>> +     struct perf_cpu_context *cpuctx;
>> +     struct pmu *pmu;
>> +     /*
>> +      * if task is DEAD, then css_out is irrelevant, it has
>> +      * been changed to init_css in cgroup_exit() from do_exit().
>> +      * Furthermore, perf_cgroup_exit_task(), has scheduled out
>> +      * all css constrained events, only unconstrained events
>> +      * remain. Therefore we need to reschedule based on css_in.
>> +      */
>> +     if (task->state != TASK_DEAD && cgrp_out == cgrp_in)
>> +             return;
>> +
>> +     rcu_read_lock();
>> +
>> +     list_for_each_entry_rcu(pmu, &pmus, entry) {
>> +
>> +             cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
>> +
>> +             perf_pmu_disable(cpuctx->ctx.pmu);
>> +
>> +             /*
>> +              * perf_cgroup_events says at least one
>> +              * context on this CPU has cgroup events.
>> +              *
>> +              * ctx->nr_cgroups reports the number of cgroup
>> +              * events for a context. Given there can be multiple
>> +              * PMUs, there can be multiple contexts.
>> +              */
>> +             if (cpuctx->ctx.nr_cgroups > 0) {
>> +                     /*
>> +                      * schedule out everything we have
>> +                      * task == DEAD: only unconstrained events
>> +                      * task != DEAD: css constrained + unconstrained events
>> +                      *
>> +                      * We kick out all events (even if unconstrained)
>> +                      * to allow the constrained events to be scheduled
>> +                      * based on their position in the event list (fairness)
>> +                      */
>> +                     cpu_ctx_sched_out(cpuctx, EVENT_ALL);
>> +                     /*
>> +                      * reschedule css_in constrained + unconstrained events
>> +                      */
>> +                     cpu_ctx_sched_in(cpuctx, EVENT_ALL, next, 1);
>> +             }
>> +
>> +             perf_pmu_enable(cpuctx->ctx.pmu);
>
> Do you leak a preemption count here? No matching put_cpu_ptr().
>
> Since we're in the middle of a context switch, preemption is already
> disabled and it might be best to use this_cpu_ptr() instead of
> get_cpu_ptr(). That avoids the preemption bits.
>
Done.

>> +static inline void
>> +perf_cgroup_exit_task(struct task_struct *task)
>> +{
>> +     struct perf_cpu_context *cpuctx;
>> +     struct pmu *pmu;
>> +     unsigned long flags;
>> +
>> +     local_irq_save(flags);
>> +
>> +     rcu_read_lock();
>> +
>> +     list_for_each_entry_rcu(pmu, &pmus, entry) {
>> +
>> +             cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
>> +
>> +             perf_pmu_disable(cpuctx->ctx.pmu);
>> +
>> +             if (cpuctx->ctx.nr_cgroups > 0) {
>> +                     /*
>> +                      * task is going to be detached from css.
>> +                      * We cannot keep a reference on the css
>> +                      * as it may disappear before we get to
>> +                      * perf_cgroup_switch(). Thus, we remove
>> +                      * all css constrained events.
>> +                      *
>> +                      * We do this by scheduling out everything
>> +                      * we have, and then only rescheduling only
>> +                      * the unconstrained events. Those can keep
>> +                      * on counting.
>> +                      *
>> +                      * We re-examine the situation in the final
>> +                      * perf_cgroup_switch() call for this task
>> +                      * once we know the next task.
>> +                      */
>> +                     cpu_ctx_sched_out(cpuctx, EVENT_ALL);
>> +                     /*
>> +                      * task = NULL causes perf_cgroup_match()
>> +                      * to match only unconstrained events
>> +                      */
>> +                     cpu_ctx_sched_in(cpuctx, EVENT_ALL, NULL, 1);
>> +             }
>> +
>> +             perf_pmu_enable(cpuctx->ctx.pmu);
>
> Another preemption leak?
>
Done.

>
>> @@ -246,6 +581,10 @@ static void update_context_time(struct perf_event_context *ctx)
>>  static u64 perf_event_time(struct perf_event *event)
>>  {
>>       struct perf_event_context *ctx = event->ctx;
>> +
>> +     if (is_cgroup_event(event))
>> +             return perf_cgroup_event_css_time(event);
>> +
>>       return ctx ? ctx->time : 0;
>>  }
>>
>> @@ -261,8 +600,10 @@ static void update_event_times(struct perf_event *event)
>>           event->group_leader->state < PERF_EVENT_STATE_INACTIVE)
>>               return;
>>
>> -     if (ctx->is_active)
>> -             run_end = perf_event_time(event);
>> +     if (is_cgroup_event(event))
>> +             run_end = perf_cgroup_event_css_time(event);
>> +     else if (ctx->is_active)
>> +             run_end = ctx->time;
>>       else
>>               run_end = event->tstamp_stopped;
>
> So I guess the difference is that we want perf_cgroup_event_css_time()
> even when !active?
>
The difference is in the way time_enabled in accounted for in cgroup mode.
time_enabled represent the time the event is enabled AND the monitored
threads were active of the monitored CPU. Thus it is independent of the
state of the context. A context may have cgroup and non-cgroup events
attached to it. I have added a comment to explain that.

>> @@ -322,6 +663,17 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
>>               list_add_tail(&event->group_entry, list);
>>       }
>>
>> +     if (is_cgroup_event(event)) {
>> +             ctx->nr_cgroups++;
>> +             /*
>> +              * one more event:
>> +              * - that has cgroup constraint on event->cpu
>> +              * - that may need work on context switch
>> +              */
>> +             atomic_inc(&per_cpu(perf_cgroup_events, event->cpu));
>> +             jump_label_inc(&perf_sched_events);
>> +     }
>
> Ah, I guess this is why you're still using atomics, since another cpu
> can install the counters on the target cpu,. ok I guess that makes
> sense.
>

YES!

>> -     event->shadow_ctx_time = tstamp - ctx->timestamp;
>> +     /*
>> +      * use the correct time source for the time snapshot
>> +      *
>> +      * We could get by without this by leveraging the
>> +      * fact that to get to this function, the caller
>> +      * has most likely already called update_context_time()
>> +      * and update_css_time_xx() and thus both timestamp
>> +      * are identical (or very close). Given that tstamp is,
>> +      * already adjusted for cgroup, we could say that:
>> +      *    tstamp - ctx->timestamp
>> +      * is equivalent to
>> +      *    tstamp - cgrp->timestamp.
>> +      *
>> +      * Then, in perf_output_read(), the calculation would
>> +      * work with no changes because:
>> +      * - event is guaranteed scheduled in
>> +      * - no scheduled out in between
>> +      * - thus the timestamp would be the same
>> +      *
>> +      * But this is a bit hairy.
>> +      *
>> +      * So instead, we have an explicit cgroup call to remain
>> +      * within the time time source all along. We believe it
>> +      * is cleaner and simpler to understand.
>> +      */
>> +     if (is_cgroup_event(event))
>> +             perf_cgroup_set_shadow_time(event, tstamp);
>> +     else
>> +             event->shadow_ctx_time = tstamp - ctx->timestamp;
>
> How about we make perf_set_shadow_time() and hide all this in there?
>
>
Done.

>> @@ -5289,6 +5719,7 @@ unlock:
>>  static struct perf_event *
>>  perf_event_alloc(struct perf_event_attr *attr, int cpu,
>>                struct task_struct *task,
>> +              int cgrp_fd, int flags,
>>                struct perf_event *group_leader,
>>                struct perf_event *parent_event,
>>                perf_overflow_handler_t overflow_handler)
>> @@ -5302,6 +5733,14 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
>>       if (!event)
>>               return ERR_PTR(-ENOMEM);
>>
>> +     if (flags & PERF_FLAG_PID_CGROUP) {
>> +             err = perf_connect_cgroup(cgrp_fd, event, attr, group_leader);
>> +             if (err) {
>> +                     kfree(event);
>> +                     return ERR_PTR(err);
>> +             }
>> +     }
>> +
>>       /*
>>        * Single events are their own group leaders, with an
>>        * empty sibling list:
>
>
> Hrm,. that isn't particularly pretty,.. why do we have to do this in
> perf_event_alloc()? Can't we do this in the syscall after
> perf_event_alloc() returns?
>
Done.

Will be posting an updated version soon.
I also realized, I need to check how cgroup is handled for the SW events.
