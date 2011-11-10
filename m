Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab1KJSDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 13:03:38 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:1952
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708Ab1KJSDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 13:03:36 -0500
X-SpamScore: -11
X-BigFish: VPS-11(zz146fK1432N98dKzz1202hzz8275dhz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LUGI5O-02-S49-02
X-M-MSG: 
Date: Thu, 10 Nov 2011 19:03:08 +0100
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH] perf_events: fix and improve x86 event scheduling
Message-ID: <20111110180308.GD15738@erda.amd.com>
References: <20111107110149.GA5177@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111107110149.GA5177@quad>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.11.11 06:01:49, Stephane Eranian wrote:
> 
> Major rewrite of the x86 event scheduling routine.
> The routine is shared between AMD and Intel.
> 
> The existing code had an issue with certain combinations
> of constraints. As Robert Richter @ AMD demonstrated on
> AMD Bulldozer:
> 
> e0 [3,0]
> e1 [2:0]
> e2 [2:0]
> e3 [2:0]
> 
> With this list of events, the existing scheduling algorithm
> would never schedule e3. That's because it would always choose
> counter 0 for e0:
>   e0 -> 0
>   e1 -> 1
>   e2 -> 2
>   e3 -> X
> 
> Robert Richter proposed a fix to the algorithm which was based
> on tagging constraints that overlap. He was using rollbacks to
> simulate recursion.
> 
> We propose an alternate solution which is simpler, faster. This
> is a small modification to the existing algorithm. It adds some
> smart in how a counter is chosen for a given event. The first

Posting a link to my patch set for reference:

 https://lkml.org/lkml/2011/9/10/51

What are the reasons to your alternate solution? Is it recursion, code
complexity, or a use case it does not fit in? I see recursion as the
main concern with my patch set, but its impact is known and limited.
Anyway, a algorithm without recursion would be generally better.

> available counter is not systemtically selected. Instead, the
> algorithm checks how the constraints between the events overlap.
> For each counter, it assigns a weight which is the number of events
> which it can count for the event set. For each event, the algorithm
> assigns the counter with the smallest weight first.

But this algorithm does not work for all cases and does not solve the
problem in general. Your idea to have weights for counters might be
the right approach.

E.g. the algorithm fails with (all weights are the same):

    c0 c1 c2
 e0 x     x
 e1    x  x
 e2 x  x

... leading to:

 e0 -> c0
 e1 -> C1
 e3 -> X

You basically have to recalculate the weights after you had assigned a
counter.

But even if we do this, I am still not sure if that would cover all
cases.

> 
> In the example above, the new algoritm assigns:
>   e0 -> 3
>   e1 -> 0
>   e2 -> 1
>   e3 -> 2
> 
> Because:
>   counter 0, weight = 4
>   counter 1, weight = 3
>   counter 2, weight = 3
>   counter 3, weight = 1
> 
> We maximize PMU usage and ensure all events are measured.
> 
> The patch also restructures the code to separate scheduling of
> constrained vs. unconstrained events. An unconstrained event is
> one that can be programmed into any of the generic counters. For
> those, we now use the simplest algorihtm possible: use next free
> counter. There is now a fast path which is beneficial on
> processors such as AMD64 Fam10h.

I don't see the need for a differentiation between constraint and
unconstraint events. If loops are optimized in the constraint path
there is not much overhead anymore. This could be done by specifying
min and max limits for ranges. Special cases (unconstraint events,
fixed counter, etc.) make the code more complex. I don't think a good
algorithm will need this.

> @@ -553,42 +530,179 @@ int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
>  	if (x86_pmu.num_counters_fixed)
>  		wmax++;
>  
> -	for (w = 1, num = n; num && w <= wmax; w++) {
> -		/* for each event */
> -		for (i = 0; num && i < n; i++) {
> -			c = constraints[i];
> -			hwc = &cpuc->event_list[i]->hw;
> +	/*
> +	 * assign from most constrained to least constrained
> +	 */
> +	for (w = 1, num = num_c; num && w <= wmax; w++) {
> +		/* for each constrained event */
> +		for (i = 0, e = c_events; i < num_c; i++, e++) {
> +
> +			map_idx = (*e)->hw.map_idx;
> +			c = constraints[map_idx];
>  
>  			if (c->weight != w)
>  				continue;
>  
> +			min_wcnt = INT_MAX;

Should be X86_PMC_IDX_MAX.

> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 1e9ebe5..2605244 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -564,6 +564,7 @@ struct hw_perf_event {
>  			int		idx;
>  			int		last_cpu;
>  			struct hw_perf_event_extra extra_reg;
> +			int		map_idx;

This is not the right place. It is for all architectures but actually
locally only used. A local array in x86_schedule_events() would work
too.

-Robert

>  		};
>  		struct { /* software */
>  			struct hrtimer	hrtimer;
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

