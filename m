Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab1KQMeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 07:34:04 -0500
Received: from mga14.intel.com ([143.182.124.37]:49426 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757193Ab1KQMeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 07:34:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,526,1315206000"; 
   d="scan'208";a="76159791"
Date: Thu, 17 Nov 2011 20:33:24 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH RFC] lib: Implement proportions with flexible period
Message-ID: <20111117123324.GA32546@localhost>
References: <1321297904-17633-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321297904-17633-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan,

On Tue, Nov 15, 2011 at 03:11:44AM +0800, Jan Kara wrote:
> Implement code computing proportions of events of different type (like code in
> lib/proportions.c) but allowing periods to have different lengths. This allows
> us to have aging periods of fixed wallclock time which gives better proportion
> estimates given the hugely varying throughput of different devices - previous
> measuring of aging period by number of events has the problem that a reasonable
> period length for a system with low-end USB stick is not a reasonable period
> length for a system with high-end storage array resulting either in too slow
> proportion updates or too fluctuating proportion updates.

I'd very much appreciate the work if it can eventually fix the dilemma
of slow-rampup at one end and large-fluctuaions at the other.

I cannot speak much on the algorithm at this moment, but I'm more than
willing to test it out in various workloads when you completed the
feature with another patch to call into the algorithms.

Keep up with the good work! :-)

Thanks,
Fengguang

> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  include/linux/flex_proportions.h |   56 +++++++++++++++
>  lib/flex_proportions.c           |  140 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 196 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/flex_proportions.h
>  create mode 100644 lib/flex_proportions.c
> 
>  This is just a POC patch, I didn't even try to compile the code. But I'd like
> to hear what people think about this? Do you also think it is worthwhile to
> have a facility like this (namely for BDI proportion estimates)? Any objections
> on the algorithm?
> 
> diff --git a/include/linux/flex_proportions.h b/include/linux/flex_proportions.h
> new file mode 100644
> index 0000000..619d20d
> --- /dev/null
> +++ b/include/linux/flex_proportions.h
> @@ -0,0 +1,56 @@
> +/*
> + * Floating proportions with flexible aging period
> + *
> + *  Copyright (C) 2011, SUSE, Jan Kara <jack@suse.cz>
> + */
> +
> +#ifndef _LINUX_FLEX_PROPORTIONS_H
> +#define _LINUX_FLEX_PROPORTIONS_H
> +
> +#include <linux/percpu_counter.h>
> +#include <linux/spinlock.h>
> +#include <linux/mutex.h>
> +
> +struct flex_prop_global {
> +	/* Number of events in last periods... */
> +	unsigned long *period_len;
> +	/* Number of events in the current period */
> +	struct percpu_counter events;
> +	/* Current period */
> +	unsigned int period;
> +	/* Log2 of denominator of reported proportions */
> +	unsigned int proportion_bits;
> +	/* Lock synchronyzing period transitions */
> +	spinloct_t lock;
> +};
> +
> +struct flex_prop_local_single {
> +	/* the local events counter */
> +	unsigned long events;
> +	/* Period in which we last updated events */
> +	unsigned int period;
> +	/*
> +	 * Numerator of a fraction computed from periods upto 'period'.
> +	 * Denominator is fixed to 2^proportion_bits
> +	 */
> +	unsigned int numerator;
> +	raw_spinlock_t lock;	/* Protect period and numerator */
> +};
> +
> +void __fprop_inc_single(struct flex_prop_global *p,
> +	struct flex_prop_local_single *pl);
> +void fprop_new_period(struct flex_prop_global *p);
> +void fprop_fraction_single(struct flex_prop_global *p,
> +	struct flex_prop_local_single *pl, long *numerator, long *denominator);
> +
> +void fprop_inc_single(struct flex_prop_global *p,
> +		      struct flex_prop_local_single *pl)
> +{
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	__fprop_inc_single(p, pl);
> +	local_irq_restore(flags);
> +}
> +
> +#endif
> diff --git a/lib/flex_proportions.c b/lib/flex_proportions.c
> new file mode 100644
> index 0000000..5311bcd
> --- /dev/null
> +++ b/lib/flex_proportions.c
> @@ -0,0 +1,140 @@
> +/*
> + *  Floating proportions with flexible aging period
> + *
> + *   Copyright (C) 2011, SUSE, Jan Kara <jack@suse.cz>
> + *
> + * The goal of this code is: Given different types of event, measure proportion
> + * of each type of event over time. The proportions are measured with
> + * exponentially decaying history to give smooth transitions thus a formula
> + * expressing proportion of event of type 'j' is:
> + *
> + *   p_{j} = \Sum_{i=0} (x_{i,j}/x_i) / 2^(1+i)
> + *
> + * Where x_{i,j} is j's number of events in i-th last time period and x_i is
> + * total number of events in i-th last time period.
> + *
> + * The denominator is 2^(1+i) because we want the series to be normalised, ie.
> + *
> + *   \Sum_{i=0} 1/2^(1+i) = 1
> + *
> + * Note that we also have
> + *
> + *   \Sum_{j} p_{j} = 1
> + *
> + * For computing the p_{j}'s efficiently, we use the fact that proportions are
> + * needed only with rather limited accuracy (say 20 bits in numerator &
> + * denominator). Thus given the exponential decay of history, it is enough to
> + * sum the first several periods (the number of periods needed is equal to the
> + * used precision of proportions) since sum of the remaining members of the sum
> + * will be smaller than the precision of our representation.
> + */
> +#include <linux/flex_proportions.h>
> +
> +int fprop_global_init(struct flex_prop_global *p, int proportion_bits)
> +{
> +	int err;
> +
> +	p->period = 0;
> +	p->proportion_bits = proportion_bits;
> +	p->period_len = kmalloc(sizeof(unsigned long) * proportion_bits);
> +	if (!p->period_len)
> +		return -ENOMEM;
> +	/* Initialize to 1 to avoid division by 0 (in fact 0/0) */
> +	p->period_len[0] = 1;
> +	err = percpu_counter_init(&p->events, 0);
> +	if (err) {
> +		kfree(p->period_len);
> +		return err;
> +	}
> +	spinlock_init(&p->lock);
> +	return 0;
> +}
> +
> +void fprop_global_destroy(struct flex_prop_global *p)
> +{
> +	percpu_counter_destroy(&p->events);
> +	kfree(p->period_len);
> +}
> +
> +int fprop_local_init_single(struct flex_prop_local_single *pl)
> +{
> +	pl->events = 0;
> +	pl->period = 0;
> +	pl->numerator = 0;
> +	raw_spin_lock_init(&pl->lock);
> +	return 0;
> +}
> +
> +void fprop_local_destroy_single(struct flex_prop_local_single *pl)
> +{
> +}
> +
> +static int period_idx(struct flex_prop_global *p, unsigned long period)
> +{
> +	return period % p->proportion_bits;
> +}
> +
> +static void fprop_reflect_period(struct flex_prop_global *p,
> +				 struct flex_prop_local_single *pl)
> +{
> +	/* Use ACCESS_ONCE to have 'period' constant for the whole function */
> +	unsigned int period = ACCESS_ONCE(p->period);
> +	unsigned long flags;
> +
> +	/* Fast path - period didn't change */
> +	if (pl->period == period)
> +		return;
> +	raw_spin_lock_irqsave(&pl->lock, flags);
> +	/* Aging zeroed our fraction? */
> +	if (period - pl->period >= p->proportion_bits) {
> +		pl->numerator = 0;
> +		goto next_period;
> +	}
> +
> +	/* Reflect events in the passed period into fraction */
> +	pl->numerator += div_u64(
> +			((u64)pl->events) << p->proportion_bits,
> +			p->period_len[period_idx(p, pl->period)]);
> +	pl->numerator >>= period - pl->period;
> +next_period:
> +	pl->events = 0;
> +	pl->period = period;
> +	raw_spin_unlock_irqsave(&pl->lock, flags);
> +}
> +
> +
> +/* Event of type pl happened */
> +void __fprop_inc_single(struct flex_prop_global *p,
> +			struct flex_prop_local_single *pl)
> +{
> +	fprop_reflect_period(p, pl);
> +	pl->events++;
> +	percpu_counter_add(&p->events, 1);
> +}
> +
> +/* Return fraction of events of type pl */
> +void fprop_fraction_single(struct flex_prop_global *p,
> +			   struct flex_prop_local_single *pl,
> +			   long *numerator, long *denominator)
> +{
> +	fprop_reflect_period(p, pl);
> +	*numerator = div_u64(((u64)pl->events) << p->proportion_bits,
> +			percpu_counter_read(&p->events));
> +	*numerator = (*numerator + pl->numerator) / 2;
> +	*denominator = (1 << p->proportion_bits);
> +}
> +
> +/* Declare new period */
> +void fprop_new_period(struct flex_prop_global *p)
> +{
> +	unsigned long events;
> +
> +	spin_lock(&p->lock);
> +	events = percpu_counter_sum(&p->events);
> +	/* Our math can overflow if there are too many events in one period */
> +	WARN_ON_ONCE(events >= (1 << (BITS_PER_LONG - p->proportion_bits)));
> +	p->period_len[period_idx(p, p->period)] = events;
> +	percpu_counter_set(&p->events, 0);
> +	p->period++;
> +	spin_unlock(&p->lock);
> +}
> -- 
> 1.7.1
