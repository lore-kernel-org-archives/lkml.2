Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935670Ab1JFBRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 21:17:53 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13904 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935275Ab1JFBRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 21:17:51 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6490"; a="125004598"
Message-ID: <4E8D01BE.3020202@codeaurora.org>
Date: Wed, 05 Oct 2011 18:17:50 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@ti.com>, paul@pwsan.com,
        grant.likely@secretlab.ca, arnd.bergmann@linaro.org,
        tglx@linutronix.de, Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        linus.walleij@stericsson.com, patches@linaro.org, eric.miao@linaro.org,
        broonie@opensource.wolfsonmicro.com, magnus.damm@gmail.com,
        amit.kucheria@linaro.org, richard.zhao@linaro.org, dsaxena@linaro.org,
        shawn.guo@freescale.com, Saravana Kannan <skannan@codeaurora.org>,
        linux@arm.linux.org.uk, jeremy.kerr@canonical.com,
        linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v2 1/7] clk: Add a generic clock infrastructure
References: <1316730422-20027-1-git-send-email-mturquette@ti.com> <1316730422-20027-2-git-send-email-mturquette@ti.com>
In-Reply-To: <1316730422-20027-2-git-send-email-mturquette@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2011 03:26 PM, Mike Turquette wrote:
> diff --git a/include/linux/clk.h b/include/linux/clk.h
> index 1d37f42..d6ae10b 100644
> --- a/include/linux/clk.h
> +++ b/include/linux/clk.h
> +#ifdef CONFIG_GENERIC_CLK
> +
> +struct clk_hw {
> +	struct clk *clk;
> +};
> +
> +/**
> + * struct clk_hw_ops -  Callback operations for hardware clocks; these are to
> + * be provided by the clock implementation, and will be called by drivers
> + * through the clk_* API.
> + *
> + * @prepare:	Prepare the clock for enabling. This must not return until
> + *		the clock is fully prepared, and it's safe to call clk_enable.
> + *		This callback is intended to allow clock implementations to
> + *		do any initialisation that may sleep. Called with
> + *		prepare_lock held.
> + *
> + * @unprepare:	Release the clock from its prepared state. This will typically
> + *		undo any work done in the @prepare callback. Called with
> + *		prepare_lock held.
> + *
> + * @enable:	Enable the clock atomically. This must not return until the
> + *		clock is generating a valid clock signal, usable by consumer
> + *		devices. Called with enable_lock held. This function must not
> + *		sleep.
> + *
> + * @disable:	Disable the clock atomically. Called with enable_lock held.
> + *		This function must not sleep.
> + *
> + * @recalc_rate	Recalculate the rate of this clock, by quering hardware
> + *		and/or the clock's parent. Called with the global clock mutex
> + *		held. Optional, but recommended - if this op is not set,
> + *		clk_get_rate will return 0.
> + *
> + * @get_parent	Query the parent of this clock; for clocks with multiple
> + *		possible parents, query the hardware for the current
> + *		parent. Currently only called when the clock is first
> + *		registered.
> + *
> + * The clk_enable/clk_disable and clk_prepare/clk_unprepare pairs allow
> + * implementations to split any work between atomic (enable) and sleepable
> + * (prepare) contexts.  If a clock requires sleeping code to be turned on, this
> + * should be done in clk_prepare. Switching that will not sleep should be done
> + * in clk_enable.
> + *
> + * Typically, drivers will call clk_prepare when a clock may be needed later
> + * (eg. when a device is opened), and clk_enable when the clock is actually
> + * required (eg. from an interrupt). Note that clk_prepare *must* have been
> + * called before clk_enable.
>    */
> +struct clk_hw_ops {
> +	int		(*prepare)(struct clk_hw *);
> +	void		(*unprepare)(struct clk_hw *);
> +	int		(*enable)(struct clk_hw *);
> +	void		(*disable)(struct clk_hw *);
> +	unsigned long	(*recalc_rate)(struct clk_hw *);
> +	long		(*round_rate)(struct clk_hw *, unsigned long);
> +	struct clk *	(*get_parent)(struct clk_hw *);
> +};

I would like to understand the need for recalc rate if that's something 
that we want to go into the common framework (even if it's optional). I 
have mostly heard only second hand explanations of the need for 
recalc_rate(), so I might not have the full picture. But for all the 
cases that I can think of, recalc_rate seems like a paradox.

If recalc_rate() is used to make sure the "current rate" of a "clock A" 
is always known even if it's parent "clock B"'s rate is changed, then it 
also means that the rate of "clock A" can change without 
clk_set_rate(clock A, new rate). That in turn means that the 
clk_get_rate() just gives the instantaneous snapshot of the rate. So, 
any use of clk_get_rate(clock A) for anything other than 
printing/logging the return value is broken code. In which case, do we 
really care for recalc_rate()? We could just return the rate that it was 
set to when clk_set_rate() was called and call it a day or return 0 for 
such clocks to indicate that the clock rate is "unknown".

The whole concept of trying to recalculate the rate for a clock makes me 
feel uneasy since it promotes misunderstanding the behavior of the clock 
and writing bad code based on that misunderstanding.

I would like to hear to real usecases before I propose some alternatives 
that I have in mind.

Thanks,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
