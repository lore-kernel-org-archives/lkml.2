Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216Ab1LNFPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 00:15:16 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41177 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab1LNFPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 00:15:12 -0500
Message-ID: <4EE830D5.5070305@gmail.com>
Date: Wed, 14 Dec 2011 16:15:01 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jeremy.kerr@canonical.com, paul@pwsan.com,
        broonie@opensource.wolfsonmicro.com, tglx@linutronix.de,
        linus.walleij@stericsson.com, amit.kucheria@linaro.org,
        dsaxena@linaro.org, patches@linaro.org, linaro-dev@lists.linaro.org,
        grant.likely@secretlab.ca, sboyd@quicinc.com, shawn.guo@freescale.com,
        skannan@quicinc.com, magnus.damm@gmail.com, arnd.bergmann@linaro.org,
        eric.miao@linaro.org, richard.zhao@linaro.org, mturquette@ti.com,
        andrew@lunn.ch, Jamie Iles <jamie@jamieiles.com>
Subject: Re: [PATCH v4 5/6] clk: basic gateable and fixed-rate clks
References: <1323834838-2206-1-git-send-email-mturquette@linaro.org> <1323834838-2206-6-git-send-email-mturquette@linaro.org>
In-Reply-To: <1323834838-2206-6-git-send-email-mturquette@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/12/11 14:53, Mike Turquette wrote:

> Many platforms support simple gateable clks and fixed-rate clks that
> should not be re-implemented by every platform.
> 
> This patch introduces a gateable clk with a common programming model of
> gate control via a write of 1 bit to a register.  Both set-to-enable and
> clear-to-enable are supported.
> 
> Also introduced is a fixed-rate clk which has no reprogrammable aspects.
> 
> The purpose of both types of clks is documented in drivers/clk/basic.c.
> 
> TODO: add support for a simple divider, simple mux and a dummy clk for
> stubbing out platform support.
> 
> Based on original patch by Jeremy Kerr and contribution by Jamie Iles.
> 
> Signed-off-by: Mike Turquette <mturquette@linaro.org>
> Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
> Cc: Jamie Iles <jamie@jamieiles.com>

<snip>

> +int clk_register_gate(struct device *dev, const char *name, unsigned long flags,
> +		struct clk *fixed_parent, void __iomem *reg, u8 bit_idx,
> +		int set_to_enable)
> +{
> +	struct clk_hw_gate *gclk;
> +	struct clk *clk;
> +
> +	gclk = kmalloc(sizeof(struct clk_hw_gate), GFP_KERNEL);
> +
> +	if (!gclk) {
> +		pr_err("%s: could not allocate gated clk\n", __func__);
> +		return -ENOMEM;
> +	}
> +
> +	clk = &gclk->clk;
> +
> +	/* struct clk_hw_gate assignments */
> +	gclk->fixed_parent = fixed_parent;
> +	gclk->reg = reg;
> +	gclk->bit_idx = bit_idx;
> +
> +	/* struct clk assignments */
> +	clk->name = name;
> +	clk->flags = flags;
> +
> +	if (set_to_enable)
> +		clk->ops = &clk_hw_gate_set_enable_ops;
> +	else
> +		clk->ops = &clk_hw_gate_set_disable_ops;


You could avoid having two sets of operations if you stored the
set_to_enable value in struct clk_hw_gate. It might be useful to store
additional information in struct clk_hw_gate if you also want to extend
to supporting non-32bit registers (readb, etc), clocks with write only
registers, or support clocks which require more than one bit to be set
or cleared to enable them, etc. See the basic mmio gpio driver for a
similar case.

~Ryan

