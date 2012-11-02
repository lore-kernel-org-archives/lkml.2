Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762758Ab2KBLeA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 07:34:00 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59420 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762395Ab2KBLd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 07:33:58 -0400
Message-ID: <5093AF8A.8000707@ti.com>
Date: Fri, 2 Nov 2012 17:03:30 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>
CC: <mturquette@linaro.org>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <rob.herring@calxeda.com>,
        <linus.walleij@linaro.org>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <khilman@ti.com>,
        <linux@arm.linux.org.uk>, <sshtylyov@mvista.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-keystone@list.ti.com>
Subject: Re: [PATCH v3 04/11] clk: davinci - add pll divider clock driver
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com> <1351181518-11882-5-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1351181518-11882-5-git-send-email-m-karicheri2@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2012 9:41 PM, Murali Karicheri wrote:

> pll dividers are present in the pll controller of DaVinci and Other
> SoCs that re-uses the same hardware IP. This has a enable bit for
> bypass the divider or enable the driver. This is a sub class of the
> clk-divider clock checks the enable bit to calculare the rate and
> invoke the recalculate() function of the clk-divider if enabled.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> ---
>  drivers/clk/davinci/clk-div.c |  124 +++++++++++++++++++++++++++++++++++++++++
>  drivers/clk/davinci/clk-div.h |   42 ++++++++++++++
>  2 files changed, 166 insertions(+)
>  create mode 100644 drivers/clk/davinci/clk-div.c
>  create mode 100644 drivers/clk/davinci/clk-div.h
> 
> diff --git a/drivers/clk/davinci/clk-div.c b/drivers/clk/davinci/clk-div.c
> new file mode 100644
> index 0000000..8147d99
> --- /dev/null
> +++ b/drivers/clk/davinci/clk-div.c
> @@ -0,0 +1,124 @@
> +/*
> + * Copyright 2012 Freescale Semiconductor, Inc.
> + * Copyright 2012 Texas instuments
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:

incomplete sentence.

> +/**
> + * clk_register_davinci_plldiv - register function for DaVinci PLL divider clk
> + *
> + * @dev: device ptr
> + * @name: name of the clock
> + * @parent_name: name of parent clock
> + * @plldiv_data: ptr to pll divider data
> + * @lock: ptr to spinlock passed to divider clock
> + */
> +struct clk *clk_register_davinci_plldiv(struct device *dev,

Why do you need a dev pointer here and which device does it point to? In
the only usage of this API in the series, you pass a NULL here. I should
have probably asked this question on one of the earlier patches itself.

> +			const char *name, const char *parent_name,
> +			struct clk_plldiv_data *plldiv_data,
> +			spinlock_t *lock)
> +{
> +	struct clk_div *div;
> +	struct clk *clk;
> +	struct clk_init_data init;
> +
> +	div = kzalloc(sizeof(*div), GFP_KERNEL);
> +	if (!div)
> +		return ERR_PTR(-ENOMEM);
> +
> +	init.name = name;
> +	init.ops = &clk_div_ops;
> +	init.flags = plldiv_data->flags;
> +	init.parent_names = (parent_name ? &parent_name : NULL);
> +	init.num_parents = (parent_name ? 1 : 0);
> +
> +	div->reg = plldiv_data->reg;
> +	div->en_id = plldiv_data->en_id;
> +
> +	div->divider.reg = plldiv_data->reg;
> +	div->divider.shift = plldiv_data->shift;
> +	div->divider.width = plldiv_data->width;
> +	div->divider.flags = plldiv_data->divider_flags;
> +	div->divider.lock = lock;
> +	div->divider.hw.init = &init;
> +	div->ops = &clk_divider_ops;
> +
> +	clk = clk_register(NULL, &div->divider.hw);

Shouldn't you be calling clk_register_divider() here which in turn will
do clk_register()?

Thanks,
Sekhar
