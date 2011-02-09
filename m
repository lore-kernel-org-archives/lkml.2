Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab1BIJqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 04:46:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:60030 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab1BIJqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 04:46:20 -0500
Subject: Re: [PATCH 1/2] perf_events: add cgroup support (v8)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
In-Reply-To: <AANLkTi=abaUN6m9ZWQuri_Y-487YZzjnTujQMP61QdmW@mail.gmail.com>
References: <4d384700.2308e30a.70bc.ffffd532@mx.google.com>
	 <1297095037.13327.47.camel@laptop>
	 <AANLkTi=abaUN6m9ZWQuri_Y-487YZzjnTujQMP61QdmW@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Feb 2011 10:47:24 +0100
Message-ID: <1297244844.13327.155.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-08 at 23:31 +0100, Stephane Eranian wrote:
> Peter,
> 
> See comments below.
> 
> 
> On Mon, Feb 7, 2011 at 5:10 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > Compile tested only, depends on the cgroup::exit patch
> >
> > --- linux-2.6.orig/include/linux/perf_event.h
> > +++ linux-2.6/include/linux/perf_event.h
> > @@ -905,6 +929,9 @@ struct perf_cpu_context {
> >        struct list_head                rotation_list;
> >        int                             jiffies_interval;
> >        struct pmu                      *active_pmu;
> > +#ifdef CONFIG_CGROUP_PERF
> > +       struct perf_cgroup              *cgrp;
> > +#endif
> >  };
> >
> I don't quite understand the motivation for adding cgrp to cpuctx.
> 
> > --- linux-2.6.orig/kernel/perf_event.c
> > +++ linux-2.6/kernel/perf_event.c
> > +static inline void update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx)
> > +{
> > +       struct perf_cgroup *cgrp_out = cpuctx->cgrp;
> > +       if (cgrp_out)
> > +               __update_cgrp_time(cgrp_out);
> > +}
> > +
> What's the benefit of this form compared to the original from_task() version?

Answering both questions, I did this so we could still do the
sched_out() while the task has already been flipped to a new cgroup.
Note that both attach and the new exit cgroup_subsys methods are called
after they update the task's cgroup. While they do provide the old
cgroup as an argument, making use of that requires passing that along
which would have been a much more invasive change.


> > +                       if (mode & PERF_CGROUP_SWOUT)
> > +                               cpu_ctx_sched_out(cpuctx, EVENT_ALL);
> > +
> > +                       if (mode & PERF_CGROUP_SWIN) {
> > +                               cpu_ctx_sched_in(cpuctx, EVENT_ALL, task, 1);
> > +                               cpuctx->cgrp = perf_cgroup_from_task(task);
> > +                       }
> > +               }
> I think there is a risk on cpuctx->cgrp pointing to stale cgrp information.
> Shouldn't we also set cpuctx->cgrp = NULL on SWOUT?

Yeah, we probably should.

> > +static int __perf_cgroup_move(void *info)
> > +{
> > +       struct task_struct *task = info;
> > +       perf_cgroup_switch(task, PERF_CGROUP_SWOUT | PERF_CGROUP_SWIN);
> > +       return 0;
> > +}
> > +
> > +static void perf_cgroup_move(struct task_struct *task)
> > +{
> > +       task_function_call(task, __perf_cgroup_move, task);
> > +}
> > +
> > +static void perf_cgroup_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
> > +               struct cgroup *old_cgrp, struct task_struct *task,
> > +               bool threadgroup)
> > +{
> > +       perf_cgroup_move(task);
> > +       if (threadgroup) {
> > +               struct task_struct *c;
> > +               rcu_read_lock();
> > +               list_for_each_entry_rcu(c, &task->thread_group, thread_group) {
> > +                       perf_cgroup_move(c);
> > +               }
> > +               rcu_read_unlock();
> > +       }
> > +}
> > +
> I suspect my original patch was not necessarily handling the attach completely
> when you move an existing task into a cgroup which was already monitored.
> I think you may have had to wait until a ctxsw. Looks like this callback handles
> this better.

Right, this deals with moving a task into a cgroup that isn't currently
being monitored and its converse, moving it out of a cgroup that is
being monitored.

> Let me make sure I understand the threadgroup iteration, though. I suspect
> this handles the situation where a multi-threaded app is moved into a cgroup

Indeed.

> while there is already cgroup monitoring active. In that case and if we do not
> want to wait until there is at least one ctxsw on all CPUs, then we have to
> check if the other threads are not already running on the other CPUs.If so,
> we need to do a cgroup switch on those CPUs. Otherwise, we have nothing to
> do. Am I getting this right?

Right, so if any of those tasks is currently running, that cpu will be
monitoring their old cgroup, hence we send an IPI to flip cgroups.

> > +static void perf_cgroup_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
> > +               struct cgroup *old_cgrp, struct task_struct *task)
> > +{
> > +       /*
> > +        * cgroup_exit() is called in the copy_process() failure path.
> > +        * Ignore this case since the task hasn't ran yet, this avoids
> > +        * trying to poke a half freed task state from generic code.
> > +        */
> > +       if (!(task->flags & PF_EXITING))
> > +               return;
> > +
> > +       perf_cgroup_move(task);
> > +}
> > +
> Those callbacks looks good to me. They certainly alleviate the need for the
> hack in cgorup_exit().
> 
> Thanks for fixing this.

n/p, now all we need to do is get this cgroup_subsys::exit stuff
sorted ;-)



