Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab2JJMCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 08:02:51 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45742 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab2JJMCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 08:02:50 -0400
Message-ID: <507563C3.2000305@ti.com>
Date: Wed, 10 Oct 2012 17:32:11 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>
CC: <mturquette@linaro.org>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <rob.herring@calxeda.com>,
        <linus.walleij@linaro.org>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <khilman@ti.com>,
        <linux@arm.linux.org.uk>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-keystone@list.ti.com>,
        <linux-c6x-dev@linux-c6x.org>, <cyril@ti.com>
Subject: Re: [PATCH 01/13] clk: davinci - add Main PLL clock driver
References: <1348682889-9509-1-git-send-email-m-karicheri2@ti.com> <1348682889-9509-2-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1348682889-9509-2-git-send-email-m-karicheri2@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Murali,

On 9/26/2012 11:37 PM, Murali Karicheri wrote:
> This is the driver for the main PLL clock hardware found on DM SoCs.
> This driver borrowed code from arch/arm/mach-davinci/clock.c and
> implemented the driver as per common clock provider API. The main PLL
> hardware typically has a multiplier, a pre-divider and a post-divider.
> Some of the SoCs has the divider fixed meaning they can not be
> configured through a register. HAS_PREDIV and HAS_POSTDIV flags are used
> to tell the driver if a hardware has these dividers present or not.
> Driver is configured through the structure clk_davinci_pll_data
> that has the platform data for the driver.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

Are you using git-format-patch to generate the patches? It should have
added a diffstat here by default which is very useful in quickly
understanding what the patch is touching.
> 
> diff --git a/drivers/clk/davinci/clk-davinci-pll.c b/drivers/clk/davinci/clk-davinci-pll.c
> new file mode 100644
> index 0000000..13e1690
> --- /dev/null
> +++ b/drivers/clk/davinci/clk-davinci-pll.c
> @@ -0,0 +1,128 @@
> +/*
> + * PLL clk driver DaVinci devices
> + *
> + * Copyright (C) 2006-2012 Texas Instruments.
> + * Copyright (C) 2008-2009 Deep Root Systems, LLC
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + * TODO - Add set_parent_rate()
> + */
> +#include <linux/clk.h>
> +#include <linux/clk-provider.h>
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/slab.h>
> +#include <linux/platform_data/clk-davinci-pll.h>

It will be nice to keep these sorted in alphabetical order. You got it
almost right, except the last one. Keeping it sorted keeps out duplicates.

> +
> +#include <mach/cputype.h>

Hmm, why is this needed? mach/ includes in driver files make it tough to
use this on other architectures/machines. You have plan to use this on
driver on keystone and c6x as well, right? It will also break
multi-platform ARM build.

> +
> +#define PLLM		0x110
> +#define PLLM_PLLM_MASK  0xff
> +#define PREDIV          0x114
> +#define POSTDIV         0x128
> +#define PLLDIV_EN       BIT(15)

Can you use tabs for indentation?

> +
> +/**
> + * struct clk_davinci_pll - DaVinci Main pll clock

no capitalization on 'M' needed, I think.

> + * @hw: clk_hw for the pll
> + * @pll_data: PLL driver specific data
> + */
> +struct clk_davinci_pll {
> +	struct clk_hw hw;
> +	struct clk_davinci_pll_data *pll_data;
> +};
> +
> +#define to_clk_pll(_hw) container_of(_hw, struct clk_davinci_pll, hw)
> +
> +static unsigned long clk_pllclk_recalc(struct clk_hw *hw,
> +					unsigned long parent_rate)
> +{
> +	struct clk_davinci_pll *pll = to_clk_pll(hw);
> +	struct clk_davinci_pll_data *pll_data = pll->pll_data;
> +	u32 mult = 1, prediv = 1, postdiv = 1;

No need to initialize mult here since you are doing it right away below.

> +	unsigned long rate = parent_rate;
> +
> +	/* If there is a device specific recalc defined invoke it. Otherwise
> +	 * fallback to default one
> +	 */

This is not following the multi-line comment style defined in
Documentation/CodingStyle.

> +	mult = __raw_readl(pll_data->pllm);

Do not use __raw_ variants since they are not safe on ARMv7. Use
readl/writel instead.

> +	if (pll_data->pllm_multiplier)
> +		mult =  pll_data->pllm_multiplier *
> +				(mult & pll_data->pllm_mask);
> +	else
> +		mult = (mult & pll_data->pllm_mask) + 1;
> +
> +	if (pll_data->flags & CLK_DAVINCI_PLL_HAS_PREDIV) {
> +		/* pre-divider is fixed, take prediv value from pll_data  */
> +		if (pll_data->fixed_prediv)
> +			prediv = pll_data->fixed_prediv;

Since else is multi-line, if needs braces as well.

> +		else {
> +			prediv = __raw_readl(pll_data->prediv);
> +			if (prediv & PLLDIV_EN)
> +				prediv = (prediv & pll_data->prediv_mask) + 1;
> +			else
> +				prediv = 1;
> +		}
> +	}
> +
> +	if (pll_data->flags & CLK_DAVINCI_PLL_HAS_POSTDIV) {
> +		postdiv = __raw_readl(pll_data->postdiv);
> +		if (postdiv & PLLDIV_EN)
> +			postdiv = (postdiv & pll_data->postdiv_mask) + 1;
> +		else
> +			postdiv = 1;
> +	}
> +
> +	rate /= prediv;
> +	rate *= mult;
> +	rate /= postdiv;
> +
> +	pr_debug("PLL%d: input = %lu MHz [ ",
> +		 pll_data->num, parent_rate / 1000000);
> +	if (prediv > 1)
> +		pr_debug("/ %d ", prediv);
> +	if (mult > 1)
> +		pr_debug("* %d ", mult);
> +	if (postdiv > 1)
> +		pr_debug("/ %d ", postdiv);
> +	pr_debug("] --> %lu MHz output.\n", rate / 1000000);
> +	return rate;

Have a blank like before the return, its easier to read that way.

> +}
> +
> +static const struct clk_ops clk_pll_ops = {
> +	.recalc_rate = clk_pllclk_recalc,
> +};
> +
> +struct clk *clk_register_davinci_pll(struct device *dev, const char *name,
> +			const char *parent_name,
> +			struct clk_davinci_pll_data *pll_data)
> +{
> +	struct clk_init_data init;
> +	struct clk_davinci_pll *pll;
> +	struct clk *clk;
> +
> +	if (!pll_data)
> +		return ERR_PTR(-ENODEV);
> +
> +	pll = kzalloc(sizeof(*pll), GFP_KERNEL);
> +	if (!pll)
> +		return ERR_PTR(-ENOMEM);
> +	init.name = name;
> +	init.ops = &clk_pll_ops;
> +	init.flags = pll_data->flags;
> +	init.parent_names = (parent_name ? &parent_name : NULL);
> +	init.num_parents = (parent_name ? 1 : 0);
> +
> +	pll->pll_data	= pll_data;
> +	pll->hw.init = &init;
> +
> +	clk = clk_register(NULL, &pll->hw);
> +	if (IS_ERR(clk))
> +		kfree(pll);
> +
> +	return clk;
> +}

I guess there is an an "unregister" required as well which will free the
pll memory allocated above and unregister the clock? Not sure if you
would ever unregister a PLL, but providing this will probably help symmetry.

Thanks,
Sekhar
