Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab1KGL4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 06:56:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:52171 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab1KGL4y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 06:56:54 -0500
Subject: Re: [PATCH] perf_events: fix and improve x86 event scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, robert.richter@amd.com, mingo@elte.hu,
        ming.m.lin@intel.com, ak@linux.intel.com
Date: Mon, 07 Nov 2011 12:55:48 +0100
In-Reply-To: <20111107110149.GA5177@quad>
References: <20111107110149.GA5177@quad>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320666948.18053.17.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-07 at 12:01 +0100, Stephane Eranian wrote:
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
> available counter is not systemtically selected. Instead, the

systematically

> algorithm checks how the constraints between the events overlap.
> For each counter, it assigns a weight which is the number of events
> which it can count for the event set. For each event, the algorithm
> assigns the counter with the smallest weight first.
> 
> In the example above, the new algoritm assigns:

algorithm

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

Might be good to mention this is O(n^3) in time; also is there still a
case where this algorithm will fail and the O(n!) one will succeed?

The complexities seem to suggest there is, and I suspect it would be
where there is a tie in constraint weight. Please think about this and
tell us why we don't care ;-)

Few nits on the code:

> +int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
> +{
> +	struct event_constraint **c;
> +	struct event_constraint *constraints[X86_PMC_IDX_MAX];
> +	struct perf_event *events[X86_PMC_IDX_MAX];
> +	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
> +	int i;
> +	int num_c = 0, num_u = 0;
> +	struct hw_perf_event *hwc;
> +
> +	/*
> +	 * collect event constraints
> +	 * separate constrained vs. unconstrained events
> +	 *
> +	 * map_idx = actual index in event_list and assign arrays
> +	 *
> +	 * we add constrained events from index 0 to n
> +	 * we add unconstrained events from index n - 1 to 0
> +	 * that way we save stack memory by not defining two arrays
> +	 */
> +	for (i = 0; i < n; i++) {
> +		constraints[i] =
> +		    x86_pmu.get_event_constraints(cpuc, cpuc->event_list[i]);
> +		if (constraints[i] != &unconstrained) {
> +			events[num_c] = cpuc->event_list[i];
> +			events[num_c]->hw.map_idx = i;
> +			num_c++;
> +		} else {
> +			events[n - num_u - 1] = cpuc->event_list[i];
> +			events[n - num_u - 1]->hw.map_idx = i;
> +			num_u++;
>  		}
>  	}
> +	/*
> +	 * fastpath: try to reuse previous assignments
> +	 */
> +	for (i = 0, c = constraints; i < n; i++, c++) {
> +		hwc = &cpuc->event_list[i]->hw;
> +
> +		/* never assigned, must go to slow path */
> +		if (hwc->idx == -1)
> +			break;
> +
> +		/* constraint still honored */
> +		if (!test_bit(hwc->idx, (*c)->idxmsk))
> +			break;
> +
> +		/* counter not already used */
> +		if (test_bit(hwc->idx, used_mask))
> +			break;
> +
> +		__set_bit(hwc->idx, used_mask);
> +		if (assign)
> +			assign[i] = hwc->idx;
> +	}
> +	/* was able to reuse every counter, we're done */
> +	if (i == n) {
> +		num_u = num_c = 0;
> +		goto done;
> +	}
> +
> +	/*
> +	 * begin slow path
> +	 */
> +	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
> +
> +	/* schedule constrained events */
> +	if (num_c)
> +		num_c = x86_sched_constrained(events,
> +					      num_c,
> +					      constraints,
> +					      n, used_mask, assign);
> +
> +	/* schedule unconstrained events */
> +	if (num_u)
> +		num_u = x86_sched_unconstrained(events,
> +						num_u,
> +						n, used_mask, assign);

For both branches, please wrap in (superfluous) curly braces.

>  done:
>  	/*
>  	 * scheduling failed or is just a simulation,
>  	 * free resources if necessary
>  	 */
> -	if (!assign || num) {
> +	if (!assign || num_u || num_c) {
>  		for (i = 0; i < n; i++) {
>  			if (x86_pmu.put_event_constraints)
>  				x86_pmu.put_event_constraints(cpuc, cpuc->event_list[i]);
>  		}
>  	}
> -	return num ? -ENOSPC : 0;
> +	return num_c || num_u ? -ENOSPC : 0;
>  }

We really should change that -ENOSPC... :-)

>  
>  /*
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 1e9ebe5..2605244 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -564,6 +564,7 @@ struct hw_perf_event {
>  			int		idx;
>  			int		last_cpu;
>  			struct hw_perf_event_extra extra_reg;
> +			int		map_idx;
>  		};
>  		struct { /* software */
>  			struct hrtimer	hrtimer;

Somewhat sad we need to add a field there, I think its ok we the
software side of things is still the largest so it doesn't matter but do
check.
