Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab1KZNKY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 08:10:24 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:30450 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab1KZNKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 08:10:19 -0500
X-SpamScore: -3
X-BigFish: VS-3(zz1432N98dK853kc8kzz1202hzz8275bh8275dhz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Sat, 26 Nov 2011 21:22:33 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Mike Turquette <mturquette@ti.com>
CC: <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <jeremy.kerr@canonical.com>, <broonie@opensource.wolfsonmicro.com>,
        <tglx@linutronix.de>, <linus.walleij@stericsson.com>,
        <amit.kucheria@linaro.org>, <dsaxena@linaro.org>, <patches@linaro.org>,
        <linaro-dev@lists.linaro.org>, <aul@pwsan.com>,
        <grant.likely@secretlab.ca>, <sboyd@quicinc.com>,
        <skannan@quicinc.com>, <magnus.damm@gmail.com>,
        <arnd.bergmann@linaro.org>, <eric.miao@linaro.org>,
        <richard.zhao@linaro.org>, Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH v3 3/5] clk: introduce the common clock framework
Message-ID: <20111126132232.GC19025@S2100-06.ap.freescale.net>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
 <1321926047-14211-4-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1321926047-14211-4-git-send-email-mturquette@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 05:40:45PM -0800, Mike Turquette wrote:
[...]
> +/**
> + * DOC: Using the CLK_PARENT_SET_RATE flag
> + *
> + * __clk_set_rate changes the child's rate before the parent's to more
> + * easily handle failure conditions.
> + *
> + * This means clk might run out of spec for a short time if its rate is
> + * increased before the parent's rate is updated.
> + *
> + * To prevent this consider setting the CLK_GATE_SET_RATE flag on any
> + * clk where you also set the CLK_PARENT_SET_RATE flag

Eh, this is how flag CLK_GATE_SET_RATE is born?  Does that mean to make
the call succeed all the clocks on the propagating path need to be gated
before clk_set_rate gets called?

> + */
> +struct clk *__clk_set_rate(struct clk *clk, unsigned long rate)
> +{
> +	struct clk *fail_clk = NULL;
> +	int ret;
> +	unsigned long old_rate = clk->rate;
> +	unsigned long new_rate;
> +	unsigned long parent_old_rate;
> +	unsigned long parent_new_rate = 0;
> +	struct clk *child;
> +	struct hlist_node *tmp;
> +
> +	/* bail early if we can't change rate while clk is enabled */
> +	if ((clk->flags & CLK_GATE_SET_RATE) && clk->enable_count)
> +		return clk;
> +
> +	/* find the new rate and see if parent rate should change too */
> +	WARN_ON(!clk->ops->round_rate);
> +
> +	new_rate = clk->ops->round_rate(clk, rate, &parent_new_rate);
> +
> +	/* FIXME propagate pre-rate change notification here */
> +	/* XXX note that pre-rate change notifications will stack */
> +
> +	/* change the rate of this clk */
> +	ret = clk->ops->set_rate(clk, new_rate);

Yes, right here, the clock gets set to some unexpected rate, since the
parent clock has not been set to the target rate yet at this point.

> +	if (ret)
> +		return clk;
> +
> +	/*
> +	 * change the rate of the parent clk if necessary
> +	 *
> +	 * hitting the nested 'if' path implies we have hit a .set_rate
> +	 * failure somewhere upstream while propagating __clk_set_rate
> +	 * up the clk tree.  roll back the clk rates one by one and
> +	 * return the pointer to the clk that failed.  clk_set_rate will
> +	 * use the pointer to propagate a rate-change abort notifier
> +	 * from the "highest" point.
> +	 */
> +	if ((clk->flags & CLK_PARENT_SET_RATE) && parent_new_rate) {
> +		parent_old_rate = clk->parent->rate;
> +		fail_clk = __clk_set_rate(clk->parent, parent_new_rate);
> +
> +		/* roll back changes if parent rate change failed */
> +		if (fail_clk) {
> +			pr_warn("%s: failed to set parent %s rate to %lu\n",
> +					__func__, fail_clk->name,
> +					parent_new_rate);
> +			clk->ops->set_rate(clk, old_rate);
> +		}
> +		return fail_clk;
> +	}
> +
> +	/*
> +	 * set clk's rate & recalculate the rates of clk's children
> +	 *
> +	 * hitting this path implies we have successfully finished
> +	 * propagating recursive calls to __clk_set_rate up the clk tree
> +	 * (if necessary) and it is safe to propagate clk_recalc_rates and
> +	 * post-rate change notifiers down the clk tree from this point.
> +	 */
> +	clk->rate = new_rate;
> +	/* FIXME propagate post-rate change notifier for only this clk */
> +	hlist_for_each_entry(child, tmp, &clk->children, child_node)
> +		clk_recalc_rates(child);
> +
> +	return fail_clk;
> +}

[...]

> diff --git a/include/linux/clk.h b/include/linux/clk.h
> index 7213b52..3b0eb3f 100644
> --- a/include/linux/clk.h
> +++ b/include/linux/clk.h
> @@ -3,6 +3,8 @@
>   *
>   *  Copyright (C) 2004 ARM Limited.
>   *  Written by Deep Blue Solutions Limited.
> + *  Copyright (c) 2010-2011 Jeremy Kerr <jeremy.kerr@canonical.com>
> + *  Copyright (C) 2011 Linaro Ltd <mturquette@linaro.org>
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -13,17 +15,134 @@
>  
>  #include <linux/kernel.h>
>  
> +#include <linux/kernel.h>

Eh, why adding a duplication?

> +#include <linux/errno.h>
> +
>  struct device;
>  
> +struct clk;

Do you really need this?

[...]

> +struct clk_hw_ops {
> +	int		(*prepare)(struct clk *clk);
> +	void		(*unprepare)(struct clk *clk);
> +	int		(*enable)(struct clk *clk);
> +	void		(*disable)(struct clk *clk);
> +	unsigned long	(*recalc_rate)(struct clk *clk);
> +	long		(*round_rate)(struct clk *clk, unsigned long,

The return type seems interesting.  If we intend to return a rate, it
should be 'unsigned long' rather than 'long'.  I'm just curious about
the possible reason behind that.

> +					unsigned long *);
> +	int		(*set_parent)(struct clk *clk, struct clk *);
> +	struct clk *	(*get_parent)(struct clk *clk);
> +	int		(*set_rate)(struct clk *clk, unsigned long);

Nit: would it be reasonable to put set_rate after round_rate to group
*_rate functions together?

> +};
> +
> +/**
> + * clk_init - initialize the data structures in a struct clk
> + * @dev: device initializing this clk, placeholder for now
> + * @clk: clk being initialized
> + *
> + * Initializes the lists in struct clk, queries the hardware for the
> + * parent and rate and sets them both.  Adds the clk to the sysfs tree
> + * topology.
> + *
> + * Caller must populate .name, .flags and .ops before calling clk_init.
> + */
> +void clk_init(struct device *dev, struct clk *clk);
> +
> +#endif /* !CONFIG_GENERIC_CLK */
>  
>  /**
>   * clk_get - lookup and obtain a reference to a clock producer.
> @@ -107,9 +226,16 @@ static inline void clk_unprepare(struct clk *clk)
>  }
>  #endif
>  
> +int __clk_enable(struct clk *clk);
> +void __clk_disable(struct clk *clk);
> +int __clk_prepare(struct clk *clk);
> +void __clk_unprepare(struct clk *clk);
> +void __clk_reparent(struct clk *clk, struct clk *new_parent);
> +
Do we really need to export all these common clk internal functions?

Regards,
Shawn

>  /**
>   * clk_get_rate - obtain the current clock rate (in Hz) for a clock source.
>   *		  This is only valid once the clock source has been enabled.
> + *		  Returns zero if the clock rate is unknown.
>   * @clk: clock source
>   */
>  unsigned long clk_get_rate(struct clk *clk);
> -- 
> 1.7.4.1
> 
> 

