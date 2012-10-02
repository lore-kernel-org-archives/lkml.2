Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab2JBMjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 08:39:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968Ab2JBMjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 08:39:53 -0400
Date: Tue, 2 Oct 2012 14:39:22 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf cgroups: Fix perf_cgroup_switch schedule in warning
Message-ID: <20121002123921.GB6379@krava.brq.redhat.com>
References: <20121002114218.GA5891@krava.brq.redhat.com>
 <1349178781.7780.29.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349178781.7780.29.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 01:53:01PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-10-02 at 13:42 +0200, Jiri Olsa wrote:
> > +++ b/kernel/events/core.c
> > @@ -394,7 +394,8 @@ void perf_cgroup_switch(struct task_struct *task, int mode)
> >                         }
> >  
> >                         if (mode & PERF_CGROUP_SWIN) {
> > -                               WARN_ON_ONCE(cpuctx->cgrp);
> > +                               WARN_ON_ONCE(cpuctx->cgrp && !cpuctx->ctx.is_active);
> > +
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
>  	list_for_each_entry_rcu(pmu, &pmus, entry) {
>  		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
> +		if (cpuctx->active_pmu != pmu)
> +			continue;
>  
>  		/*
>  		 * perf_cgroup_events says at least one
> 

this passed my test

jirka
