Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab1BPUeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 15:34:44 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16851 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab1BPUel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 15:34:41 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6259"; a="74833283"
Message-ID: <4D5C34E0.5000209@codeaurora.org>
Date: Wed, 16 Feb 2011 12:34:40 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: linux-tegra@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        konkers@android.com, linux-kernel@vger.kernel.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 12/21] ARM: tegra: clock: Add shared bus clock type
References: <1297590033-15035-1-git-send-email-ccross@android.com> <1297590033-15035-13-git-send-email-ccross@android.com>
In-Reply-To: <1297590033-15035-13-git-send-email-ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2011 01:40 AM, Colin Cross wrote:
> +/* shared bus ops */
> +/*
> + * Some clocks may have multiple downstream users that need to request a
> + * higher clock rate.  Shared bus clocks provide a unique shared_bus_user
> + * clock to each user.  The frequency of the bus is set to the highest
> + * enabled shared_bus_user clock, with a minimum value set by the
> + * shared bus.
> + */
> +static void tegra_clk_shared_bus_update(struct clk *bus)
> +{
> +	struct clk *c;
> +	unsigned long rate = bus->min_rate;
> +
> +	list_for_each_entry(c, &bus->shared_bus_list, u.shared_bus_user.node)
> +		if (c->u.shared_bus_user.enabled)
> +			rate = max(c->u.shared_bus_user.rate, rate);
> +
> +	if (rate != clk_get_rate(bus))
> +		clk_set_rate(bus, rate);

What do you do if clk_set_rate() fails? Should you unwind all the state
such as the rate and if it's enabled/disabled? Or is it safe to say
clk_set_rate() can't fail unless the kernel is buggy in which case why
aren't all those return -E* in the set rate functions just BUG_ONs?

> +};
> +
> +static void tegra_clk_shared_bus_init(struct clk *c)
> +{
> +	c->max_rate = c->parent->max_rate;
> +	c->u.shared_bus_user.rate = c->parent->max_rate;
> +	c->state = OFF;
> +#ifdef CONFIG_DEBUG_FS
> +	c->set = 1;
> +#endif
> +
> +	list_add_tail(&c->u.shared_bus_user.node,
> +		&c->parent->shared_bus_list);
> +}
> +
> +static int tegra_clk_shared_bus_set_rate(struct clk *c, unsigned long rate)
> +{
> +	c->u.shared_bus_user.rate = rate;
> +	tegra_clk_shared_bus_update(c->parent);
> +	return 0;
> +}
> +
> +static long tegra_clk_shared_bus_round_rate(struct clk *c, unsigned long rate)
> +{
> +	return clk_round_rate(c->parent, rate);
> +}
> +
> +static int tegra_clk_shared_bus_enable(struct clk *c)
> +{
> +	c->u.shared_bus_user.enabled = true;
> +	tegra_clk_shared_bus_update(c->parent);
> +	return 0;
> +}

Shouldn't you call clk_enable(c->parent)? And do you need to check for
errors from clk_enable()?

> +
> +static void tegra_clk_shared_bus_disable(struct clk *c)
> +{
> +	c->u.shared_bus_user.enabled = false;
> +	tegra_clk_shared_bus_update(c->parent);
> +}

And a similar clk_disable(c->parent) here.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

