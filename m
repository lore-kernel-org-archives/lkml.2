Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab2HMMxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 08:53:21 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:57172 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751109Ab2HMMxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 08:53:19 -0400
MIME-Version: 1.0
In-Reply-To: <1344853682.31459.20.camel@twins>
References: <CABPqkBRWLcP_9WOL_VvucnY7A2AcpzuvsUt4_ZUgYMREo-65dA@mail.gmail.com>
	<50235ED0.5010107@intel.com>
	<CABPqkBT-pvmhyOHfMXs7dXsJXpEVmaSST1xFFHzCu4CDBf7baw@mail.gmail.com>
	<1344535707.20277.20.camel@twins>
	<CABPqkBRzyrmL_yiKnYWU4qaSZXbD=JJVnm5py4PUcgAYvT=hcA@mail.gmail.com>
	<1344853682.31459.20.camel@twins>
Date: Mon, 13 Aug 2012 14:53:18 +0200
Message-ID: <CABPqkBREO7GE8qYqVoeyfFyC+gdn+TOf8f9sp_Yu0_O1Eds55A@mail.gmail.com>
Subject: Re: [BUG] perf: sharing of cpuctx between core and ibs PMU causes problems
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

Ok, that should fix the problem that IBS would not work correctly in
per-thread mode.
I realized I was looking at an older kernel which did not have the
split between ibs
op and fetch. And there, the .task_nr_context was not initialized at all.

Your proposal solves the problem, though it is not that pretty because
you're exposing
IBS stuff in sched.h aside for the 2 new iterations. But I don't see
another way around
this at this point.

Thanks.

On Mon, Aug 13, 2012 at 12:28 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> OK,.. so the AMD IBS PMUs actually have perf_invalid_context.
>
> Lemme have a proper look...
>
>
> Weirdness.. perf_pmu_register() will allocate a pmu->pmu_cpu_context for
> each PMU. find_pmu_context() even special cases the perf_invalid_context
> to return NULL to force the allocation instead of sharing it.
>
> So both IBS PMUs should have their own cpuctx.
>
>
>
> In any case, I was talking about something like the below.. I hate
> growing the per-task ctx array with two entries, esp. since we'll mostly
> add two NULL pointer checks on every perf operation for everybody not
> using IBS.
>
> ---
> --- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
> +++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
> @@ -436,7 +436,7 @@ static void perf_ibs_read(struct perf_ev
>
>  static struct perf_ibs perf_ibs_fetch = {
>         .pmu = {
> -               .task_ctx_nr    = perf_invalid_context,
> +               .task_ctx_nr    = perf_hw2_context,
>
>                 .event_init     = perf_ibs_init,
>                 .add            = perf_ibs_add,
> @@ -459,7 +459,7 @@ static struct perf_ibs perf_ibs_fetch =
>
>  static struct perf_ibs perf_ibs_op = {
>         .pmu = {
> -               .task_ctx_nr    = perf_invalid_context,
> +               .task_ctx_nr    = perf_hw3_context,
>
>                 .event_init     = perf_ibs_init,
>                 .add            = perf_ibs_add,
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1237,6 +1237,8 @@ enum perf_event_task_context {
>         perf_invalid_context = -1,
>         perf_hw_context = 0,
>         perf_sw_context,
> +       perf_hw2_context, /* AMD IBS (fetch) */
> +       perf_hw3_context, /* AMD IBS (ops)   */
>         perf_nr_task_contexts,
>  };
>
>
