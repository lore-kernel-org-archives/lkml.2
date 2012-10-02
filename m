Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab2JBOS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 10:18:26 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61411 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab2JBOSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 10:18:25 -0400
MIME-Version: 1.0
In-Reply-To: <1349185609.7780.34.camel@twins>
References: <20121002114218.GA5891@krava.brq.redhat.com>
	<1349178781.7780.29.camel@twins>
	<20121002123921.GB6379@krava.brq.redhat.com>
	<CABPqkBQvhUk=3OU4brv0LefZnRn2xSALA2-cVmE3A1wazDT=XA@mail.gmail.com>
	<1349183446.7780.32.camel@twins>
	<CABPqkBSRTDbN7Sq9Pg0GOUFNiKGpVgOBY82ZMK--4Tgy9=iZDA@mail.gmail.com>
	<1349185609.7780.34.camel@twins>
Date: Tue, 2 Oct 2012 16:18:23 +0200
Message-ID: <CABPqkBQDHAjWRWfWdayKiLL3rwk_iefZCXRr-1Qk8GJO2x2+AQ@mail.gmail.com>
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

Cool. Thanks.

On Tue, Oct 2, 2012 at 3:46 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2012-10-02 at 15:34 +0200, Stephane Eranian wrote:
>> And adding a comment in cgroup_switch()
>>
>> +               /* ensure we process each cpuctx only once */
>> +               if (cpuctx->active_pmu != pmu)
>> +                       continue;
>>
> ---
> Subject: perf: Fix perf_cgroup_switch for sw-events
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Tue Oct 02 15:41:23 CEST 2012
>
> Jiri reported that he could trigger the WARN_ON_ONCE() in
> perf_cgroup_switch() using sw-events. This is because sw-events share
> a cpuctx with multiple PMUs.
>
> Use the ->unique_pmu pointer to limit the pmu iteration to unique
> cpuctx instances.
>
> Reported-and-Tested-by: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/events/core.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -372,6 +372,8 @@ void perf_cgroup_switch(struct task_stru
>
>         list_for_each_entry_rcu(pmu, &pmus, entry) {
>                 cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
> +               if (cpuctx->unique_pmu != pmu)
> +                       continue; /* ensure we process each cpuctx once */
>
>                 /*
>                  * perf_cgroup_events says at least one
> @@ -395,9 +397,10 @@ void perf_cgroup_switch(struct task_stru
>
>                         if (mode & PERF_CGROUP_SWIN) {
>                                 WARN_ON_ONCE(cpuctx->cgrp);
> -                               /* set cgrp before ctxsw in to
> -                                * allow event_filter_match() to not
> -                                * have to pass task around
> +                               /*
> +                                * set cgrp before ctxsw in to allow
> +                                * event_filter_match() to not have to pass
> +                                * task around
>                                  */
>                                 cpuctx->cgrp = perf_cgroup_from_task(task);
>                                 cpu_ctx_sched_in(cpuctx, EVENT_ALL, task);
>
