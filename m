Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559Ab2KCMfp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 08:35:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58415 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153Ab2KCMfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 08:35:44 -0400
Message-ID: <50950F7E.2080309@ti.com>
Date: Sat, 3 Nov 2012 18:05:10 +0530
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
Subject: Re: [PATCH v3 03/11] clk: davinci - common clk utilities to init
 clk driver
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com> <1351181518-11882-4-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1351181518-11882-4-git-send-email-m-karicheri2@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2012 9:41 PM, Murali Karicheri wrote:
> This is the common clk driver initialization functions for DaVinci
> SoCs and other SoCs that uses similar hardware architecture.
> clock.h also defines struct types for clock definitions in a SoC
> and clock data type for configuring clk-mux. The initialization
> functions are used by clock initialization code in a specific
> platform/SoC.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> ---
>  drivers/clk/davinci/clock.c |  112 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/clk/davinci/clock.h |   80 +++++++++++++++++++++++++++++++
>  2 files changed, 192 insertions(+)
>  create mode 100644 drivers/clk/davinci/clock.c
>  create mode 100644 drivers/clk/davinci/clock.h
> 
> diff --git a/drivers/clk/davinci/clock.c b/drivers/clk/davinci/clock.c
> new file mode 100644
> index 0000000..ad02149
> --- /dev/null
> +++ b/drivers/clk/davinci/clock.c
> @@ -0,0 +1,112 @@
> +/*
> + * clock.c - davinci clock initialization functions for various clocks
> + *
> + * Copyright (C) 2006-2012 Texas Instruments.
> + * Copyright (C) 2008-2009 Deep Root Systems, LLC
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#include <linux/init.h>
> +#include <linux/clk-provider.h>
> +#include <linux/clkdev.h>
> +#include <linux/io.h>
> +#include <linux/slab.h>
> +
> +#include "clk-pll.h"
> +#include "clk-psc.h"
> +#include "clk-div.h"
> +#include "clock.h"
> +
> +static DEFINE_SPINLOCK(_lock);
> +
> +#ifdef	CONFIG_CLK_DAVINCI_PLL
> +struct clk *davinci_pll_clk(const char *name, const char *parent,
> +		u32 phys_pllm, u32 phys_prediv, u32 phys_postdiv,
> +		struct clk_pll_data *pll_data)
> +{
> +	struct clk *clkp = NULL;
> +
> +	pll_data->reg_pllm = ioremap(phys_pllm, 4);
> +	if (WARN_ON(!pll_data->reg_pllm))
> +		return clkp;

I would prefer ERR_PTR(-ENOMEM) here. Same comment applies to other
instances elsewhere in the patch.

> diff --git a/drivers/clk/davinci/clock.h b/drivers/clk/davinci/clock.h
> new file mode 100644
> index 0000000..73204b8
> --- /dev/null
> +++ b/drivers/clk/davinci/clock.h
> @@ -0,0 +1,80 @@
> +/*
> + * TI DaVinci Clock definitions -  Contains Macros and Types used for
> + * defining various clocks on a DaVinci SoC
> + *
> + * Copyright (C) 2012 Texas Instruments
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +#ifndef __DAVINCI_CLOCK_H
> +#define __DAVINCI_CLOCK_H
> +
> +#include <linux/types.h>
> +
> +/* general flags: */
> +#define ALWAYS_ENABLED		BIT(0)

This is not used in this patch. Can you add the define along with its
usage so it is immediately clear why you need it?

> +/**
> + * struct davinci_clk - struct for defining DaVinci clocks for a SoC.
> + *
> + * @name: name of the clock
> + * @parent: name of parent clock
> + * @flags: General flags for all drivers used by platform clock init code
> + * @data: data specific to a clock used by the driver
> + * @dev_id: dev_id used to look up this clock. If this is NULL
> + *	clock name is used for lookup.
> + */
> +struct davinci_clk {
> +	const char			*name;
> +	const char			*parent;
> +	u32				flags;
> +	void				*data;
> +	char				*dev_id;

Similarly dont see this being used as well.

Thanks,
Sekhar
