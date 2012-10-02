Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab2JBMBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 08:01:03 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62828 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab2JBMBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 08:01:01 -0400
MIME-Version: 1.0
In-Reply-To: <1349178781.7780.29.camel@twins>
References: <20121002114218.GA5891@krava.brq.redhat.com>
	<1349178781.7780.29.camel@twins>
Date: Tue, 2 Oct 2012 14:01:00 +0200
Message-ID: <CABPqkBSzgEjM9s3i5kQ-BSP-q6F3=8MwXfZ6B31UyJpEJ1Q9JA@mail.gmail.com>
Subject: Re: [PATCH] perf cgroups: Fix perf_cgroup_switch schedule in warning
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 1:53 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> On Tue, 2012-10-02 at 13:42 +0200, Jiri Olsa wrote:
> > +++ b/kernel/events/core.c
> > @@ -394,7 +394,8 @@ void perf_cgroup_switch(struct task_struct *task, int mode)
> >                         }
> >
> >                         if (mode & PERF_CGROUP_SWIN) {
> > -                               WARN_ON_ONCE(cpuctx->cgrp);
> > +                               WARN_ON_ONCE(cpuctx->cgrp && !cpuctx->ctx.is_active);
> > +

Wait a minute, I thought we had fixed that problem which was caused by
the AMD IBS
pmu not having the task_ctx_nr set properly or something like that. We
were wrongfully
sharing the cpuctx between PMUs.



>
> >                                 /* set cgrp before ctxsw in to
> >                                  * allow event_filter_match() to not
> >                                  * have to pass task around
>
> OK, like you mentioned this is the result of multiple PMU being able to
> share a cpuctx, shouldn't we in that case avoid the second loop over the
> cpuctx as a whole?
>
> Would something like the below do? IIRC I introduced that active_pmu for
> exactly such reasons..
>
> ---
>  kernel/events/core.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 7b9df35..e98f014 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -372,6 +372,8 @@ void perf_cgroup_switch(struct task_struct *task, int mode)
>
>         list_for_each_entry_rcu(pmu, &pmus, entry) {
>                 cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
> +               if (cpuctx->active_pmu != pmu)
> +                       continue;
>
>                 /*
>                  * perf_cgroup_events says at least one
>
