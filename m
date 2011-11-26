Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1KZNgD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 08:36:03 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:28563
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754664Ab1KZNf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 08:35:57 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Sat, 26 Nov 2011 21:48:08 +0800
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
Subject: Re: [PATCH v3 4/5] clk: basic gateable and fixed-rate clks
Message-ID: <20111126134807.GD19025@S2100-06.ap.freescale.net>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
 <1321926047-14211-5-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1321926047-14211-5-git-send-email-mturquette@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 05:40:46PM -0800, Mike Turquette wrote:
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
What I have seen is drivers/clk/clk-basic.c.

> TODO: add support for a simple divider, simple mux and a dummy clk for
> stubbing out platform support.
> 
> Based on original patch by Jeremy Kerr contribution by Jamie Iles.
> 
> Signed-off-by: Mike Turquette <mturquette@linaro.org>
> ---
>  drivers/clk/Kconfig     |    7 ++
>  drivers/clk/Makefile    |    5 +-
>  drivers/clk/clk-basic.c |  208 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/clk.h     |   35 ++++++++
>  4 files changed, 253 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/clk/clk-basic.c

[...]

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
> +
> +	clk_init(NULL, clk);
> +
> +	return 0;

The device tree support needs to get this 'struct clk *', so we may
want to have all these registering functions return the 'clk'.

> +}

-- 
Regards,
Shawn

