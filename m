Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab1IZSdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 14:33:15 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44649 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab1IZSdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 14:33:13 -0400
Message-ID: <4E80C564.3050004@gmail.com>
Date: Mon, 26 Sep 2011 13:33:08 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110918 Thunderbird/7.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@ti.com>
CC: linux-kernel@vger.kernel.org, paul@pwsan.com, linaro-dev@lists.linaro.org,
        linus.walleij@stericsson.com, patches@linaro.org, eric.miao@linaro.org,
        broonie@opensource.wolfsonmicro.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, Jamie Iles <jamie@jamieiles.com>,
        skannan@quicinc.com, linux@arm.linux.org.uk, jeremy.kerr@canonical.com,
        tglx@linutronix.de, linux-arm-kernel@lists.infradead.org,
        sboyd@quiinc.com
Subject: Re: [PATCH v2 4/7] clk: Add simple gated clock
References: <1316730422-20027-1-git-send-email-mturquette@ti.com> <1316730422-20027-5-git-send-email-mturquette@ti.com>
In-Reply-To: <1316730422-20027-5-git-send-email-mturquette@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

On 09/22/2011 05:26 PM, Mike Turquette wrote:
> From: Jeremy Kerr <jeremy.kerr@canonical.com>
> 
> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> Signed-off-by: Mike Turquette <mturquette@ti.com>
> ---
> Changes since v1:
> Add copyright header
> Fold in Jamie's patch for set-to-disable clks
> Use BIT macro instead of shift
> 
>  drivers/clk/Kconfig    |    4 ++
>  drivers/clk/Makefile   |    1 +
>  drivers/clk/clk-gate.c |   78 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/clk.h    |   13 ++++++++
>  4 files changed, 96 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/clk/clk-gate.c
> 
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index d8313d7..a78967c 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -12,3 +12,7 @@ config GENERIC_CLK
>  config GENERIC_CLK_FIXED
>  	bool
>  	depends on GENERIC_CLK
> +
> +config GENERIC_CLK_GATE
> +	bool
> +	depends on GENERIC_CLK
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index 9a3325a..d186446 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -2,3 +2,4 @@
>  obj-$(CONFIG_CLKDEV_LOOKUP)	+= clkdev.o
>  obj-$(CONFIG_GENERIC_CLK)	+= clk.o
>  obj-$(CONFIG_GENERIC_CLK_FIXED)	+= clk-fixed.o
> +obj-$(CONFIG_GENERIC_CLK_GATE)	+= clk-gate.o
> diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
> new file mode 100644
> index 0000000..a1d8e79
> --- /dev/null
> +++ b/drivers/clk/clk-gate.c
> @@ -0,0 +1,78 @@
> +/*
> + * Copyright (C) 2010-2011 Canonical Ltd <jeremy.kerr@canonical.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Simple clk gate implementation
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/module.h>
> +#include <asm/io.h>

use linux/io.h

> +
> +#define to_clk_gate(clk) container_of(clk, struct clk_gate, hw)
> +
> +static unsigned long clk_gate_get_rate(struct clk_hw *clk)
> +{
> +	return clk_get_rate(clk_get_parent(clk->clk));
> +}
> +
> +static void clk_gate_set_bit(struct clk_hw *clk)
> +{
> +	struct clk_gate *gate = to_clk_gate(clk);
> +	u32 reg;
> +
> +	reg = __raw_readl(gate->reg);
> +	reg |= BIT(gate->bit_idx);
> +	__raw_writel(reg, gate->reg);

Don't these read-mod-writes need a spinlock around it?

It's possible to have an enable bits and dividers in the same register.
If you did a set_rate and while doing an enable/disable, there would be
a problem. Also, it may be 2 different clocks in the same register, so
the spinlock needs to be shared and not per clock.

> +}
> +
> +static void clk_gate_clear_bit(struct clk_hw *clk)
> +{
> +	struct clk_gate *gate = to_clk_gate(clk);
> +	u32 reg;
> +
> +	reg = __raw_readl(gate->reg);
> +	reg &= ~BIT(gate->bit_idx);
> +	__raw_writel(reg, gate->reg);
> +}
> +
> +static int clk_gate_enable_set(struct clk_hw *clk)
> +{
> +	clk_gate_set_bit(clk);
> +
> +	return 0;
> +}
> +
> +static void clk_gate_disable_clear(struct clk_hw *clk)
> +{
> +	clk_gate_clear_bit(clk);
> +}
> +
> +struct clk_hw_ops clk_gate_set_enable_ops = {

const?

> +	.recalc_rate = clk_gate_get_rate,
> +	.enable = clk_gate_enable_set,
> +	.disable = clk_gate_disable_clear,
> +};
> +EXPORT_SYMBOL_GPL(clk_gate_set_enable_ops);
> +
> +static int clk_gate_enable_clear(struct clk_hw *clk)
> +{
> +	clk_gate_clear_bit(clk);
> +
> +	return 0;
> +}
> +
> +static void clk_gate_disable_set(struct clk_hw *clk)
> +{
> +	clk_gate_set_bit(clk);
> +}

Are these wrapper functions really needed? Just assign set_bit and
clear_bit functions directly to the ops structs. Only the ops struct
name is exposed to the user.

> +
> +struct clk_hw_ops clk_gate_set_disable_ops = {

const?

Rob

