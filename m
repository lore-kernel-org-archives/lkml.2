Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab1BQLgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 06:36:18 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43858 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab1BQLgR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 06:36:17 -0500
Subject: Re: [tip:perf/core] perf: Add cgroup support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <AANLkTimM6+gBWGZmbV9VFq76KR-UtsW==HmSEPZmSRyG@mail.gmail.com>
References: <4d590250.114ddf0a.689e.4482@mx.google.com>
	 <tip-e5d1367f17ba6a6fed5fd8b74e4d5720923e0c25@git.kernel.org>
	 <1297875452.2413.453.camel@twins>
	 <AANLkTimM6+gBWGZmbV9VFq76KR-UtsW==HmSEPZmSRyG@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 17 Feb 2011 12:36:00 +0100
Message-ID: <1297942560.2413.1639.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 12:16 +0100, Stephane Eranian wrote:
> Peter,
> 
> On Wed, Feb 16, 2011 at 5:57 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Wed, 2011-02-16 at 13:46 +0000, tip-bot for Stephane Eranian wrote:
> >> +static inline struct perf_cgroup *
> >> +perf_cgroup_from_task(struct task_struct *task)
> >> +{
> >> +       return container_of(task_subsys_state(task, perf_subsys_id),
> >> +                       struct perf_cgroup, css);
> >> +}
> >
> > ===================================================
> > [ INFO: suspicious rcu_dereference_check() usage. ]
> > ---------------------------------------------------
> > include/linux/cgroup.h:547 invoked rcu_dereference_check() without protection!
> > other info that might help us debug this:
> > rcu_scheduler_active = 1, debug_locks = 1
> > 1 lock held by perf/1774:
> >  #0:  (&ctx->lock){......}, at: [<ffffffff810afb91>] ctx_sched_in+0x2a/0x37b
> > stack backtrace:
> > Pid: 1774, comm: perf Not tainted 2.6.38-rc5-tip+ #94017
> > Call Trace:
> >  [<ffffffff81070932>] ? lockdep_rcu_dereference+0x9d/0xa5
> >  [<ffffffff810afc4e>] ? ctx_sched_in+0xe7/0x37b
> >  [<ffffffff810aff37>] ? perf_event_context_sched_in+0x55/0xa3
> >  [<ffffffff810b0203>] ? __perf_event_task_sched_in+0x20/0x5b
> >  [<ffffffff81035714>] ? finish_task_switch+0x49/0xf4
> >  [<ffffffff81340d60>] ? schedule+0x9cc/0xa85
> >  [<ffffffff8110a84c>] ? vfsmount_lock_global_unlock_online+0x9e/0xb0
> >  [<ffffffff8110b556>] ? mntput_no_expire+0x4e/0xc1
> >  [<ffffffff8110b5ef>] ? mntput+0x26/0x28
> >  [<ffffffff810f2add>] ? fput+0x1a0/0x1af
> >  [<ffffffff81002eb9>] ? int_careful+0xb/0x2c
> >  [<ffffffff813432bf>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> >  [<ffffffff81002ec7>] ? int_careful+0x19/0x2c
> >
> >
> I have lockedp enabled in my kernel and during all my tests
> I never saw this warning. How did you trigger this?

CONFIG_PROVE_RCU=y, its a bit of a shiny feature but most of the false
positives are gone these days I think.

> > The simple fix seemed to be to add:
> >
> > diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> > index a0a6987..e739e6f 100644
> > --- a/kernel/perf_event.c
> > +++ b/kernel/perf_event.c
> > @@ -204,7 +204,8 @@ __get_cpu_context(struct perf_event_context *ctx)
> >  static inline struct perf_cgroup *
> >  perf_cgroup_from_task(struct task_struct *task)
> >  {
> > -       return container_of(task_subsys_state(task, perf_subsys_id),
> > +       return container_of(task_subsys_state_check(task, perf_subsys_id,
> > +                               lockdep_is_held(&ctx->lock)),
> >                        struct perf_cgroup, css);
> >  }
> >
> > For all callers _should_ hold ctx->lock and ctx->lock is acquired during
> > ->attach/->exit so holding that lock will pin the cgroup.
> >
> I am not sure I follow you here. Are you talking about cgroup_attach()
> and cgroup_exit()? perf_cgroup_switch() does eventually grab ctx->lock
> when it gets to the actual save and restore functions. But
> perf_cgroup_from_task()
> is called outside of those sections in perf_cgroup_switch().

Right, but there we hold rcu_read_lock().

So what we're saying here is that its ok to dereference the variable
provided we hold either:
  - rcu_read_lock
  - task->alloc_lock
  - cgroup_lock

or

  - ctx->lock

task->alloc_lock and cgroup_lock both avoid any changes to the current
task's cgroup due to kernel/cgroup.c locking. ctx->lock avoids this due
to us taking that lock in perf_cgroup_attach() and perf_cgroup_exit()
when this task is active.

> > However, not all update_context_time()/update_cgrp_time_from_event()
> > callers actually hold ctx->lock, which is a bug because that lock also
> > serializes the timestamps.
> >
> > Most notably, task_clock_event_read(), which leads us to:
> >
> 
> If the warning comes from invoking perf_cgroup_from_task(), then there is also
> perf_cgroup_switch(). that one is not grabbing any ctx->lock either, but maybe
> not on all paths.
> 
> > @@ -5794,9 +5795,14 @@ static void task_clock_event_read(struct perf_event *event)
> >        u64 time;
> >
> >        if (!in_nmi()) {
> > -               update_context_time(event->ctx);
> > +               struct perf_event_context *ctx = event->ctx;
> > +               unsigned long flags;
> > +
> > +               spin_lock_irqsave(&ctx->lock, flags);
> > +               update_context_time(ctx);
> >                update_cgrp_time_from_event(event);
> > -               time = event->ctx->time;
> > +               time = ctx->time;
> > +               spin_unlock_irqrestore(&ctx->lock, flags);
> >        } else {
> >                u64 now = perf_clock();
> >                u64 delta = now - event->ctx->timestamp;

I just thought we should probably kill the !in_nmi branch, I'm not quite
sure why that exists..

> > I then realized that the events themselves pin the cgroup, so its all
> > cosmetic at best, but then I already had the below patch...
> >
> I assume by 'pin the group' you mean the cgroup cannot disappear
> while there is at least one event pointing to it. That's is indeed true
> thanks to refcounting (css_get()).

Right, that's what I was thinking, but now I think that's not
sufficient, we can have cgroups without events but with tasks in for
which the races are still valid.

Also:

---
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a0a6987..ab28e56 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -7330,12 +7330,10 @@ static struct cgroup_subsys_state *perf_cgroup_create(
 	struct perf_cgroup_info *t;
 	int c;
 
-	jc = kmalloc(sizeof(*jc), GFP_KERNEL);
+	jc = kzalloc(sizeof(*jc), GFP_KERNEL);
 	if (!jc)
 		return ERR_PTR(-ENOMEM);
 
-	memset(jc, 0, sizeof(*jc));
-
 	jc->info = alloc_percpu(struct perf_cgroup_info);
 	if (!jc->info) {
 		kfree(jc);

