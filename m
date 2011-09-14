Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab1INOnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 10:43:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55948 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab1INOnj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 10:43:39 -0400
Subject: Re: [PATCH 1/2] perf, x86: Implement event scheduler helper
 functions
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 14 Sep 2011 16:43:28 +0200
In-Reply-To: <1315666143-7106-2-git-send-email-robert.richter@amd.com>
References: <1315666143-7106-1-git-send-email-robert.richter@amd.com>
	 <1315666143-7106-2-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316011408.5040.20.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-09-10 at 16:49 +0200, Robert Richter wrote:
> This patch introduces x86 perf scheduler code helper functions. We
> need this to later add more complex functionality to support
> overlapping counter constraints (next patch).
> 
> The algorithm is modified so that the range of weight values is now
> generated from the constraints. There shouldn't be other functional
> changes.
> 
> With the helper functions the scheduler is controlled. There are
> functions to initialize, traverse the event list, find unused counters
> etc. The scheduler keeps its own state.
> 
> Cc: Stephane Eranian <eranian@google.com>
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c |  158 +++++++++++++++++++++++++-------------
>  1 files changed, 105 insertions(+), 53 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 594d425..44ec767 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -790,18 +790,118 @@ static inline int is_x86_event(struct perf_event *event)
>  	return event->pmu == &pmu;
>  }
>  
> +struct sched_state {
> +	int	weight;
> +	int	event;
> +	int	counter;
> +	int	unassigned;
> +	unsigned long used[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
> +};

Maybe add a few comments here? Took me a while to figure out unassigned
is the number of unassigned events.

> +static struct sched_state *perf_sched_find_counter(struct perf_sched *sched)
> +{
> +	struct event_constraint *c;
> +	int idx;
> +
> +	if (!sched->state.unassigned)
> +		return NULL;

So bail when we're done and there's nothing left to assign.

> +	c = sched->constraints[sched->state.event];
> +
> +	idx = sched->state.counter;

Which is typically 0, but this could be a restart, at which point we
continue looking where we left off.

> +	/* for each bit in idxmsk starting from idx */
> +	while (idx < X86_PMC_IDX_MAX) {
> +		idx = find_next_bit(c->idxmsk, X86_PMC_IDX_MAX, idx);
> +		if (idx == X86_PMC_IDX_MAX)
> +			break;
> +		if (!__test_and_set_bit(idx, sched->state.used))
> +			break;
> +		idx++;
> +	}

#define for_each_set_bit_continue(bit, addr, size) 	\
	for( ; (bit) < (size);				\
	       (bit) = find_next_bit((addr), (size), (bit) + 1))

	for_each_set_bit_continue(idx, c->idxmask, X86_PMC_IDX_MAX) {
		if (!__test_and_set_bit(idx, sched->state.used))
			break;
	}

> +	sched->state.counter = idx;
> +
> +	if (idx >= X86_PMC_IDX_MAX)
> +		return NULL;

OK, so its important to assign idx to counter even if we're too big,
because of the restart, right? That wants a comment.

> +
> +	return &sched->state;
> +}
> +
> +static int perf_sched_next_event(struct perf_sched *sched)
> +{
> +	struct event_constraint *c;
> +
> +	if (!sched->state.unassigned || !--sched->state.unassigned)
> +		return 0;

Shouldn't we avoid getting here if there's nothing to do? I get
the !--unassigned case, but am a bit puzzled by the !unassigned case.

> +	do {
> +		/* next event */
> +		sched->state.event++;
> +		if (sched->state.event >= sched->max_events) {
> +			/* next weight */
> +			sched->state.event = 0;
> +			sched->state.weight++;
> +			if (sched->state.weight > sched->max_weight)
> +				return 0;
> +		}
> +		c = sched->constraints[sched->state.event];
> +	} while (c->weight != sched->state.weight);
> +
> +	sched->state.counter = 0;	/* start with first counter */
> +
> +	return 1;
> +}

fair enough..

Looks ok otherwise, just a tad hard to grok in one go.. a few comments
could go a long way. I'm sure I'll have forgotten how it works in a few
weeks.

