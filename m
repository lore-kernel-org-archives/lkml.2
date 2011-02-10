Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750972Ab1BJFQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 00:16:13 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22568 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1BJFQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 00:16:11 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6252"; a="73658340"
Message-ID: <4D53749B.6010102@codeaurora.org>
Date: Wed, 09 Feb 2011 21:16:11 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jeremy Kerr <jeremy.kerr@canonical.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, Dima Zavin <dmitriyz@google.com>,
        Ben Dooks <ben-linux@fluff.org>,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [RFC,PATCH 1/3] Add a common struct clk
References: <1297233693.242364.862698430999.1.gpush@pororo>
In-Reply-To: <1297233693.242364.862698430999.1.gpush@pororo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2011 10:41 PM, Jeremy Kerr wrote:

[snip]

> +
> +int clk_set_rate(struct clk *clk, unsigned long rate)
> +{

Shouldn't you be grabbing the prepare_lock here? Set rate and 
prepare/unprepare would be working on the same shared resource (say, 
PLL). That was the reason we are making set_rate() sleepable too.

As a nice side effect, it will also enforce the "might sleep" nature of 
this API.

You should probably rename the lock to something else since it's not 
limited to prepare/unprepare. How about resource_lock?

> +	if (clk->ops->set_rate)
> +		return clk->ops->set_rate(clk, rate);
> +	return -ENOSYS;
> +}
> +EXPORT_SYMBOL_GPL(clk_set_rate);
> +
> +int clk_set_parent(struct clk *clk, struct clk *parent)
> +{
> +	if (clk->ops->set_parent)
> +		return clk->ops->set_parent(clk, parent);

I'm not sure on this one. If the prepare ops for a clock also calls the 
prepare ops on the parent, shouldn't we prevent changing the parent 
while the prepare/unprepare is going on?


> +	return -ENOSYS;
> +}
> +EXPORT_SYMBOL_GPL(clk_set_parent);
> +

> diff --git a/include/linux/clk.h b/include/linux/clk.h
> index 1d37f42..fe806b7 100644
> --- a/include/linux/clk.h
> +++ b/include/linux/clk.h
> @@ -3,6 +3,7 @@

[snip]

> +
> +/* static initialiser for clocks */
> +#define INIT_CLK(name, o) {						\
> +	.ops		=&o,						\
> +	.enable_count	= 0,						\
> +	.prepare_count	= 0,						\

Do we need these inits? Doesn't check patch complain about initing 
static/global to 0? If it's generally frowned upon, why the exception 
here. I realize that checkpatch won't catch this, but still...

> +	.enable_lock	= __SPIN_LOCK_UNLOCKED(name.enable_lock),	\
> +	.prepare_lock	= __MUTEX_INITIALIZER(name.prepare_lock),	\

After a long day, I'm not able to wrap my head around this. Probably a 
stupid question, but will this name.xxx thing prevent using this 
INIT_CLK macro to initialize an array of clocks? More specifically, 
prevent the sub class macro (like INIT_CLK_FIXED) from being used to 
initialize an array of clocks?

> +}
> +
> +/**
> + * struct clk_ops -  Callback operations for clocks; these are to be provided
> + * by the clock implementation, and will be called by drivers through the clk_*
> + * API.
> + *
> + * @prepare:	Prepare the clock for enabling. This must not return until
> + *		the clock is fully prepared, and it's safe to call clk_enable.
> + *		This callback is intended to allow clock implementations to
> + *		do any initialisation that may block. Called with
> + *		clk->prepare_lock held.
> + *
> + * @unprepare:	Release the clock from its prepared state. This will typically
> + *		undo any work done in the @prepare callback. Called with
> + *		clk->prepare_lock held.
> + *
> + * @enable:	Enable the clock atomically. This must not return until the
> + *		clock is generating a valid clock signal, usable by consumer
> + *		devices. Called with clk->enable_lock held. This function
> + *		must not sleep.
> + *
> + * @disable:	Disable the clock atomically. Called with clk->enable_lock held.
> + *		This function must not sleep.
> + *
> + * @get:	Called by the core clock code when a device driver acquires a
> + *		clock via clk_get(). Optional.
> + *
> + * @put:	Called by the core clock code when a devices driver releases a
> + *		clock via clk_put(). Optional.
> + *
> + * The clk_enable/clk_disable and clk_prepare/clk_unprepare pairs allow
> + * implementations to split any work between atomic (enable) and sleepable
> + * (prepare) contexts.  If a clock requires blocking code to be turned on, this

Aren't all locks blocking? Shouldn't it be, "If turning on a clock 
requires code that might sleep, it should be done in clk_prepare"? 
Replace all "blocking" with "sleepable" or "sleeping" in the comments?

> + * should be done in clk_prepare. Switching that will not block should be done
> + * in clk_enable.
> + *
> + * Typically, drivers will call clk_prepare when a clock may be needed later
> + * (eg. when a device is opened), and clk_enable when the clock is actually
> + * required (eg. from an interrupt). Note that clk_prepare *must* have been
> + * called before clk_enable.
> + *
> + * For other callbacks, see the corresponding clk_* functions. Parameters and
> + * return values are passed directly from/to these API functions, or
> + * -ENOSYS (or zero, in the case of clk_get_rate) is returned if the callback
> + * is NULL, see kernel/clk.c for implementation details. All are optional.

is NULL. See kernel... ?
> + */
> +struct clk_ops {
> +	int		(*prepare)(struct clk *);
> +	void		(*unprepare)(struct clk *);
> +	int		(*enable)(struct clk *);
> +	void		(*disable)(struct clk *);
> +	int		(*get)(struct clk *);
> +	void		(*put)(struct clk *);
> +	unsigned long	(*get_rate)(struct clk *);
> +	long		(*round_rate)(struct clk *, unsigned long);
> +	int		(*set_rate)(struct clk *, unsigned long);
> +	int		(*set_parent)(struct clk *, struct clk *);
> +	struct clk *	(*get_parent)(struct clk *);
> +};
> +

Thanks,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
