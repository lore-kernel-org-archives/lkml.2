Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab0EJIMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 04:12:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:51213 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463Ab0EJIMU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 04:12:20 -0400
Subject: Re: [tip:perf/core] perf: Add group scheduling transactional APIs
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, davem@davemloft.net, fweisbec@gmail.com,
       ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20100508102841.GA10650@brick.ozlabs.ibm.com>
References: <1272002160.5707.60.camel@minggr.sh.intel.com>
	 <tip-6bde9b6ce0127e2a56228a2071536d422be31336@git.kernel.org>
	 <1273269355.1642.383.camel@laptop>
	 <20100508102841.GA10650@brick.ozlabs.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 10 May 2010 10:11:55 +0200
Message-ID: <1273479115.5605.3329.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-08 at 20:28 +1000, Paul Mackerras wrote:

> Here's the patch I ended up with.

Ok, I'll take this one. Thanks Paul!

One small question on the patch below:

> --------------
> Subject: perf, powerpc: Implement group scheduling transactional APIs
> From: Lin Ming <ming.m.lin@intel.com>
> 
> [paulus@samba.org: Set cpuhw->event[i]->hw.config in
> power_pmu_commit_txn.]
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
> diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
> index 08460a2..43b83c3 100644
> --- a/arch/powerpc/kernel/perf_event.c
> +++ b/arch/powerpc/kernel/perf_event.c
> @@ -35,6 +35,9 @@ struct cpu_hw_events {
>  	u64 alternatives[MAX_HWEVENTS][MAX_EVENT_ALTERNATIVES];
>  	unsigned long amasks[MAX_HWEVENTS][MAX_EVENT_ALTERNATIVES];
>  	unsigned long avalues[MAX_HWEVENTS][MAX_EVENT_ALTERNATIVES];
> +
> +	unsigned int group_flag;
> +	int n_txn_start;
>  };
>  DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events);
>  
> @@ -805,12 +748,22 @@ static int power_pmu_enable(struct perf_event *event)
>  	cpuhw->event[n0] = event;
>  	cpuhw->events[n0] = event->hw.config;
>  	cpuhw->flags[n0] = event->hw.event_base;
> +
> +	/*
> +	 * If group events scheduling transaction was started,
> +	 * skip the schedulability test here, it will be peformed
> +	 * at commit time(->commit_txn) as a whole
> +	 */
> +	if (cpuhw->group_flag & PERF_EVENT_TXN_STARTED)
> +		goto nocheck;
> +
>  	if (check_excludes(cpuhw->event, cpuhw->flags, n0, 1))
>  		goto out;
>  	if (power_check_constraints(cpuhw, cpuhw->events, cpuhw->flags, n0 + 1))
>  		goto out;
>  	event->hw.config = cpuhw->events[n0];
> +
> +nocheck:
>  	++cpuhw->n_events;
>  	++cpuhw->n_added;
>  
> @@ -896,11 +849,65 @@ static void power_pmu_unthrottle(struct perf_event *event)
>  	local_irq_restore(flags);
>  }
>  
> +/*
> + * Start group events scheduling transaction
> + * Set the flag to make pmu::enable() not perform the
> + * schedulability test, it will be performed at commit time
> + */
> +void power_pmu_start_txn(const struct pmu *pmu)
> +{
> +	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
> +
> +	cpuhw->group_flag |= PERF_EVENT_TXN_STARTED;
> +	cpuhw->n_txn_start = cpuhw->n_events;
> +}
> +
> +/*
> + * Stop group events scheduling transaction
> + * Clear the flag and pmu::enable() will perform the
> + * schedulability test.
> + */
> +void power_pmu_cancel_txn(const struct pmu *pmu)
> +{
> +	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
> +
> +	cpuhw->group_flag &= ~PERF_EVENT_TXN_STARTED;
> +}
> +
> +/*
> + * Commit group events scheduling transaction
> + * Perform the group schedulability test as a whole
> + * Return 0 if success
> + */
> +int power_pmu_commit_txn(const struct pmu *pmu)
> +{
> +	struct cpu_hw_events *cpuhw;
> +	long i, n;
> +
> +	if (!ppmu)
> +		return -EAGAIN;
> +	cpuhw = &__get_cpu_var(cpu_hw_events);
> +	n = cpuhw->n_events;
> +	if (check_excludes(cpuhw->event, cpuhw->flags, 0, n))
> +		return -EAGAIN;
> +	i = power_check_constraints(cpuhw, cpuhw->events, cpuhw->flags, n);
> +	if (i < 0)
> +		return -EAGAIN;
> +
> +	for (i = cpuhw->n_txn_start; i < n; ++i)
> +		cpuhw->event[i]->hw.config = cpuhw->events[i];
> +
> +	return 0;
> +}

Can't you compute n_txn_start by subtracting n_added from n_events ?
