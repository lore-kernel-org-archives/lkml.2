Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab1BQPvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:51:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:55270 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632Ab1BQPu6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:50:58 -0500
Subject: Re: [tip:perf/core] perf: Add cgroup support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <AANLkTi=0psOuX7kd=GH80+dEpziaTghQxjUTW82DhCC6@mail.gmail.com>
References: <4d590250.114ddf0a.689e.4482@mx.google.com>
	 <tip-e5d1367f17ba6a6fed5fd8b74e4d5720923e0c25@git.kernel.org>
	 <1297875452.2413.453.camel@twins>
	 <AANLkTimM6+gBWGZmbV9VFq76KR-UtsW==HmSEPZmSRyG@mail.gmail.com>
	 <1297942560.2413.1639.camel@twins>
	 <AANLkTi=0psOuX7kd=GH80+dEpziaTghQxjUTW82DhCC6@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 17 Feb 2011 16:50:43 +0100
Message-ID: <1297957843.2413.1911.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 15:45 +0100, Stephane Eranian wrote:

> > CONFIG_PROVE_RCU=y, its a bit of a shiny feature but most of the false
> > positives are gone these days I think.
> >
> I have this one enabled, yet no message.

Hmm, Ingo triggered it, not sure what he did.


> >> > @@ -5794,9 +5795,14 @@ static void task_clock_event_read(struct perf_event *event)
> >> >        u64 time;
> >> >
> >> >        if (!in_nmi()) {
> >> > -               update_context_time(event->ctx);
> >> > +               struct perf_event_context *ctx = event->ctx;
> >> > +               unsigned long flags;
> >> > +
> >> > +               spin_lock_irqsave(&ctx->lock, flags);
> >> > +               update_context_time(ctx);
> >> >                update_cgrp_time_from_event(event);
> >> > -               time = event->ctx->time;
> >> > +               time = ctx->time;
> >> > +               spin_unlock_irqrestore(&ctx->lock, flags);
> >> >        } else {
> >> >                u64 now = perf_clock();
> >> >                u64 delta = now - event->ctx->timestamp;
> >
> > I just thought we should probably kill the !in_nmi branch, I'm not quite
> > sure why that exists..
> 
> I don't quite understand what this event is supposed to count in system-wide
> mode. This function adds a time delta. It may be using the wrong time source
> in cgroup mode.
> 
> Having said that, it seems to me like we may not even need the call to
> update_cgrp_time_from_event() there. It is not even used to compute
> the time delta in that function. Yet, we do get correct timings in cgroup
> mode. Thus, I suspect the timing is taken care by callers already whenever
> needed. I looked at the pmu->read() callers, and it seems they do exactly
> that. In summary, I believe we may be able to drop this call.

ok, nice!

> >> > I then realized that the events themselves pin the cgroup, so its all
> >> > cosmetic at best, but then I already had the below patch...
> >> >
> >> I assume by 'pin the group' you mean the cgroup cannot disappear
> >> while there is at least one event pointing to it. That's is indeed true
> >> thanks to refcounting (css_get()).
> >
> > Right, that's what I was thinking, but now I think that's not
> > sufficient, we can have cgroups without events but with tasks in for
> > which the races are still valid.
> >
> But in that case, no perf_event code should be fiddling with cgroups.
> I think there are guards for that, either is_cgroup_event() or ctx->nr_cgroups.
> 
> But it seems perf_cgroup_from_event() is the one exception. So maybe
> we could rewrite it:
> 
> static inline void update_cgrp_time_from_event(struct perf_event *event)
> {
>         struct perf_cgroup *cgrp;
> 
>         if (!is_cgroup_event(event))
>                 return;
> 
>         cgrp = perf_cgroup_from_task(current);
>         /*
>          * do not update time when cgroup is not active
>          */
>         if (cgrp != event->cgrp)
>                 return;
> 
>         __update_cgrp_time(event->cgrp);
> }

That might indeed work. We'd still need to shut up that RCU warning
though, we can do that by annotating it away by using
task_subsys_state(.c=1), and put a comment in explaining things.

> @@ -1613,7 +1614,7 @@ static int __perf_event_enable(void *info)
>        /*
>         * set current task's cgroup time reference point
>         */
> -       perf_cgroup_set_timestamp(current, perf_clock());
> +       perf_cgroup_set_timestamp(current, ctx);

That part ended up avoiding a perf_clock() call, we could write that as:

  perf_cgroup_set_timestamp(current, ctx->timestamp);

since ctx->timestamp has just been set to perf_clock().

Could you send a nice set of patches addressing all concerns?
