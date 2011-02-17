Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab1BQOpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 09:45:13 -0500
Received: from smtp-out.google.com ([74.125.121.67]:30903 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab1BQOpI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 09:45:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KQtM2m8ESPEhxZ+oHUbVUK9h6DtuEg4tx9uTQgCKBB2E6wcLF9JJcfypXRxkYHdMz8
         8gfhfdRYx7ZVfPvTMgJA==
MIME-Version: 1.0
In-Reply-To: <1297942560.2413.1639.camel@twins>
References: <4d590250.114ddf0a.689e.4482@mx.google.com>
	<tip-e5d1367f17ba6a6fed5fd8b74e4d5720923e0c25@git.kernel.org>
	<1297875452.2413.453.camel@twins>
	<AANLkTimM6+gBWGZmbV9VFq76KR-UtsW==HmSEPZmSRyG@mail.gmail.com>
	<1297942560.2413.1639.camel@twins>
Date: Thu, 17 Feb 2011 15:45:05 +0100
Message-ID: <AANLkTi=0psOuX7kd=GH80+dEpziaTghQxjUTW82DhCC6@mail.gmail.com>
Subject: Re: [tip:perf/core] perf: Add cgroup support
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 12:36 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2011-02-17 at 12:16 +0100, Stephane Eranian wrote:
>> Peter,
>>
>> On Wed, Feb 16, 2011 at 5:57 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> > On Wed, 2011-02-16 at 13:46 +0000, tip-bot for Stephane Eranian wrote:
>> >> +static inline struct perf_cgroup *
>> >> +perf_cgroup_from_task(struct task_struct *task)
>> >> +{
>> >> +       return container_of(task_subsys_state(task, perf_subsys_id),
>> >> +                       struct perf_cgroup, css);
>> >> +}
>> >
>> > ===================================================
>> > [ INFO: suspicious rcu_dereference_check() usage. ]
>> > ---------------------------------------------------
>> > include/linux/cgroup.h:547 invoked rcu_dereference_check() without protection!
>> > other info that might help us debug this:
>> > rcu_scheduler_active = 1, debug_locks = 1
>> > 1 lock held by perf/1774:
>> >  #0:  (&ctx->lock){......}, at: [<ffffffff810afb91>] ctx_sched_in+0x2a/0x37b
>> > stack backtrace:
>> > Pid: 1774, comm: perf Not tainted 2.6.38-rc5-tip+ #94017
>> > Call Trace:
>> >  [<ffffffff81070932>] ? lockdep_rcu_dereference+0x9d/0xa5
>> >  [<ffffffff810afc4e>] ? ctx_sched_in+0xe7/0x37b
>> >  [<ffffffff810aff37>] ? perf_event_context_sched_in+0x55/0xa3
>> >  [<ffffffff810b0203>] ? __perf_event_task_sched_in+0x20/0x5b
>> >  [<ffffffff81035714>] ? finish_task_switch+0x49/0xf4
>> >  [<ffffffff81340d60>] ? schedule+0x9cc/0xa85
>> >  [<ffffffff8110a84c>] ? vfsmount_lock_global_unlock_online+0x9e/0xb0
>> >  [<ffffffff8110b556>] ? mntput_no_expire+0x4e/0xc1
>> >  [<ffffffff8110b5ef>] ? mntput+0x26/0x28
>> >  [<ffffffff810f2add>] ? fput+0x1a0/0x1af
>> >  [<ffffffff81002eb9>] ? int_careful+0xb/0x2c
>> >  [<ffffffff813432bf>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>> >  [<ffffffff81002ec7>] ? int_careful+0x19/0x2c
>> >
>> >
>> I have lockedp enabled in my kernel and during all my tests
>> I never saw this warning. How did you trigger this?
>
> CONFIG_PROVE_RCU=y, its a bit of a shiny feature but most of the false
> positives are gone these days I think.
>
I have this one enabled, yet no message.

>> > The simple fix seemed to be to add:
>> >
>> > diff --git a/kernel/perf_event.c b/kernel/perf_event.c
>> > index a0a6987..e739e6f 100644
>> > --- a/kernel/perf_event.c
>> > +++ b/kernel/perf_event.c
>> > @@ -204,7 +204,8 @@ __get_cpu_context(struct perf_event_context *ctx)
>> >  static inline struct perf_cgroup *
>> >  perf_cgroup_from_task(struct task_struct *task)
>> >  {
>> > -       return container_of(task_subsys_state(task, perf_subsys_id),
>> > +       return container_of(task_subsys_state_check(task, perf_subsys_id,
>> > +                               lockdep_is_held(&ctx->lock)),
>> >                        struct perf_cgroup, css);
>> >  }
>> >
>> > For all callers _should_ hold ctx->lock and ctx->lock is acquired during
>> > ->attach/->exit so holding that lock will pin the cgroup.
>> >
>> I am not sure I follow you here. Are you talking about cgroup_attach()
>> and cgroup_exit()? perf_cgroup_switch() does eventually grab ctx->lock
>> when it gets to the actual save and restore functions. But
>> perf_cgroup_from_task()
>> is called outside of those sections in perf_cgroup_switch().
>
> Right, but there we hold rcu_read_lock().
>
> So what we're saying here is that its ok to dereference the variable
> provided we hold either:
>  - rcu_read_lock
>  - task->alloc_lock
>  - cgroup_lock
>
> or
>
>  - ctx->lock
>
> task->alloc_lock and cgroup_lock both avoid any changes to the current
> task's cgroup due to kernel/cgroup.c locking. ctx->lock avoids this due
> to us taking that lock in perf_cgroup_attach() and perf_cgroup_exit()
> when this task is active.
>
We do not take ctx->lock in those functions (at least not directly).
Both functions end up in perf_cgroup_switch() which does rcu_read_lock()
for all its operations. ctx->lock becomes held once you get into ctx_sched_out()
or ctx_sched_in(). But according to what you're saying above, that should
cover it.

>> > However, not all update_context_time()/update_cgrp_time_from_event()
>> > callers actually hold ctx->lock, which is a bug because that lock also
>> > serializes the timestamps.
>> >
>> > Most notably, task_clock_event_read(), which leads us to:
>> >
>>
>> If the warning comes from invoking perf_cgroup_from_task(), then there is also
>> perf_cgroup_switch(). that one is not grabbing any ctx->lock either, but maybe
>> not on all paths.
>>
>> > @@ -5794,9 +5795,14 @@ static void task_clock_event_read(struct perf_event *event)
>> >        u64 time;
>> >
>> >        if (!in_nmi()) {
>> > -               update_context_time(event->ctx);
>> > +               struct perf_event_context *ctx = event->ctx;
>> > +               unsigned long flags;
>> > +
>> > +               spin_lock_irqsave(&ctx->lock, flags);
>> > +               update_context_time(ctx);
>> >                update_cgrp_time_from_event(event);
>> > -               time = event->ctx->time;
>> > +               time = ctx->time;
>> > +               spin_unlock_irqrestore(&ctx->lock, flags);
>> >        } else {
>> >                u64 now = perf_clock();
>> >                u64 delta = now - event->ctx->timestamp;
>
> I just thought we should probably kill the !in_nmi branch, I'm not quite
> sure why that exists..

I don't quite understand what this event is supposed to count in system-wide
mode. This function adds a time delta. It may be using the wrong time source
in cgroup mode.

Having said that, it seems to me like we may not even need the call to
update_cgrp_time_from_event() there. It is not even used to compute
the time delta in that function. Yet, we do get correct timings in cgroup
mode. Thus, I suspect the timing is taken care by callers already whenever
needed. I looked at the pmu->read() callers, and it seems they do exactly
that. In summary, I believe we may be able to drop this call.

>
>> > I then realized that the events themselves pin the cgroup, so its all
>> > cosmetic at best, but then I already had the below patch...
>> >
>> I assume by 'pin the group' you mean the cgroup cannot disappear
>> while there is at least one event pointing to it. That's is indeed true
>> thanks to refcounting (css_get()).
>
> Right, that's what I was thinking, but now I think that's not
> sufficient, we can have cgroups without events but with tasks in for
> which the races are still valid.
>
But in that case, no perf_event code should be fiddling with cgroups.
I think there are guards for that, either is_cgroup_event() or ctx->nr_cgroups.

But it seems perf_cgroup_from_event() is the one exception. So maybe
we could rewrite it:

static inline void update_cgrp_time_from_event(struct perf_event *event)
{
        struct perf_cgroup *cgrp;

        if (!is_cgroup_event(event))
                return;

        cgrp = perf_cgroup_from_task(current);
        /*
         * do not update time when cgroup is not active
         */
        if (cgrp != event->cgrp)
                return;

        __update_cgrp_time(event->cgrp);
}


> Also:
>
> ---
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index a0a6987..ab28e56 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -7330,12 +7330,10 @@ static struct cgroup_subsys_state *perf_cgroup_create(
>        struct perf_cgroup_info *t;
>        int c;
>
> -       jc = kmalloc(sizeof(*jc), GFP_KERNEL);
> +       jc = kzalloc(sizeof(*jc), GFP_KERNEL);
>        if (!jc)
>                return ERR_PTR(-ENOMEM);
>
> -       memset(jc, 0, sizeof(*jc));
> -
>        jc->info = alloc_percpu(struct perf_cgroup_info);
>        if (!jc->info) {
>                kfree(jc);
>
Yep.
