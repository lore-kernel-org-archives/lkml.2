Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab1JNIKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 04:10:42 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:23470
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751442Ab1JNIKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 04:10:39 -0400
X-SpamScore: -2
X-BigFish: VS-2(z1039oz1432N98dKzz1202hzz8275bh8275dhz2dh87h2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 14 Oct 2011 16:10:26 +0800
From: Richard Zhao <richard.zhao@linaro.org>
To: Mike Turquette <mturquette@ti.com>
CC: <linux-kernel@vger.kernel.org>, <paul@pwsan.com>,
        <linaro-dev@lists.linaro.org>, <linus.walleij@stericsson.com>,
        <patches@linaro.org>, <eric.miao@linaro.org>,
        <broonie@opensource.wolfsonmicro.com>, <magnus.damm@gmail.com>,
        <amit.kucheria@linaro.org>, <grant.likely@secretlab.ca>,
        <dsaxena@linaro.org>, <arnd.bergmann@linaro.org>,
        <shawn.guo@freescale.com>, <skannan@quicinc.com>,
        <linux@arm.linux.org.uk>, <jeremy.kerr@canonical.com>,
        <tglx@linutronix.de>, <linux-arm-kernel@lists.infradead.org>,
        <sboyd@quiinc.com>
Subject: Re: [PATCH v2 1/7] clk: Add a generic clock infrastructure
Message-ID: <20111014081024.GA9485@b20223-02.ap.freescale.net>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-2-git-send-email-mturquette@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1316730422-20027-2-git-send-email-mturquette@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Thu, Sep 22, 2011 at 03:26:56PM -0700, Mike Turquette wrote:
> From: Jeremy Kerr <jeremy.kerr@canonical.com>
> 
> We currently have ~21 definitions of struct clk in the ARM architecture,
> each defined on a per-platform basis. This makes it difficult to define
> platform- (or architecture-) independent clock sources without making
> assumptions about struct clk, and impossible to compile two
> platforms with different struct clks into a single image.
> 
> This change is an effort to unify struct clk where possible, by defining
> a common struct clk, and a set of clock operations. Different clock
> implementations can set their own operations, and have a standard
> interface for generic code. The callback interface is exposed to the
> kernel proper, while the clock implementations only need to be seen by
> the platform internals.
> 
> The interface is split into two halves:
> 
>  * struct clk, which is the generic-device-driver interface. This
>    provides a set of functions which drivers may use to request
>    enable/disable, query or manipulate in a hardware-independent manner.
> 
>  * struct clk_hw and struct clk_hw_ops, which is the hardware-specific
>    interface. Clock drivers implement the ops, which allow the core
>    clock code to implement the generic 'struct clk' API.
> 
> This allows us to share clock code among platforms, and makes it
> possible to dynamically create clock devices in platform-independent
> code.
> 
> Platforms can enable the generic struct clock through
> CONFIG_GENERIC_CLK. In this case, the clock infrastructure consists of a
> common, opaque struct clk, and a set of clock operations (defined per
> type of clock):
> 
>   struct clk_hw_ops {
>   	int		(*prepare)(struct clk_hw *);
>   	void		(*unprepare)(struct clk_hw *);
>   	int		(*enable)(struct clk_hw *);
>   	void		(*disable)(struct clk_hw *);
>   	unsigned long	(*recalc_rate)(struct clk_hw *);
>   	int		(*set_rate)(struct clk_hw *,
>   					unsigned long, unsigned long *);
>   	long		(*round_rate)(struct clk_hw *, unsigned long);
>   	int		(*set_parent)(struct clk_hw *, struct clk *);
>   	struct clk *	(*get_parent)(struct clk_hw *);
>   };
> 
> Platform clock code can register a clock through clk_register, passing a
> set of operations, and a pointer to hardware-specific data:
> 
>   struct clk_hw_foo {
>   	struct clk_hw clk;
>   	void __iomem *enable_reg;
>   };
> 
>   #define to_clk_foo(c) offsetof(c, clk_hw_foo, clk)
> 
>   static int clk_foo_enable(struct clk_hw *clk)
>   {
>   	struct clk_foo *foo = to_clk_foo(clk);
>   	raw_writeb(foo->enable_reg, 1);
>   	return 0;
>   }
> 
>   struct clk_hw_ops clk_foo_ops = {
>   	.enable = clk_foo_enable,
>   };
> 
> And in the platform initialisation code:
> 
>   struct clk_foo my_clk_foo;
> 
>   void init_clocks(void)
>   {
>   	my_clk_foo.enable_reg = ioremap(...);
> 
>   	clk_register(&clk_foo_ops, &my_clk_foo, NULL);
>   }
> 
> Changes from Thomas Gleixner <tglx@linutronix.de>.
> 
> The common clock definitions are based on a development patch from Ben
> Herrenschmidt <benh@kernel.crashing.org>.
> 
> TODO:
> 
>  * We don't keep any internal reference to the clock topology at present.
> 
> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Signed-off-by: Mike Turquette <mturquette@ti.com>
> ---
> Changes since v1:
> Create a dummy clk_unregister and prototype/document it and clk_register
> Constify struct clk_hw_ops
> Remove spinlock.h header, include kernel.h
> Use EOPNOTSUPP instead of ENOTSUPP
> Add might_sleep to clk_prepare/clk_unprepare stubs
> Properly init children hlist and child_node
> Whitespace and typo fixes
> 
>  drivers/clk/Kconfig  |    3 +
>  drivers/clk/Makefile |    1 +
>  drivers/clk/clk.c    |  232 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/clk/clkdev.c |    7 ++
>  include/linux/clk.h  |  140 +++++++++++++++++++++++++++---
>  5 files changed, 371 insertions(+), 12 deletions(-)
>  create mode 100644 drivers/clk/clk.c
> 
[...]
> +static void __clk_disable(struct clk *clk)
> +{
> +	if (!clk)
> +		return;
> +
> +	if (WARN_ON(clk->enable_count == 0))
> +		return;
> +
> +	if (--clk->enable_count > 0)
> +		return;
> +
> +	if (clk->ops->disable)
> +		clk->ops->disable(clk->hw);
> +	__clk_disable(clk->parent);
> +}
> +
> +void clk_disable(struct clk *clk)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&enable_lock, flags);
> +	__clk_disable(clk);
> +	spin_unlock_irqrestore(&enable_lock, flags);
> +}
> +EXPORT_SYMBOL_GPL(clk_disable);
> +
> +static int __clk_enable(struct clk *clk)
> +{
> +	int ret;
> +
> +	if (!clk)
> +		return 0;
> +
> +	if (WARN_ON(clk->prepare_count == 0))
> +		return -ESHUTDOWN;
> +
> +
> +	if (clk->enable_count == 0) {
> +		ret = __clk_enable(clk->parent);
> +		if (ret)
> +			return ret;
> +
> +		if (clk->ops->enable) {
> +			ret = clk->ops->enable(clk->hw);
> +			if (ret) {
> +				__clk_disable(clk->parent);
> +				return ret;
> +			}
> +		}
> +	}
> +
> +	clk->enable_count++;
> +	return 0;
> +}
Could you expose __clk_enable/__clk_disable? I find it hard to implement
clk group. clk group means, when a major clk enable/disable, it want a set
of other clks enable/disable accordingly.
> +
> +int clk_enable(struct clk *clk)
> +{
> +	unsigned long flags;
> +	int ret;
> +
> +	spin_lock_irqsave(&enable_lock, flags);
> +	ret = __clk_enable(clk);
> +	spin_unlock_irqrestore(&enable_lock, flags);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(clk_enable);
> +
[...]

Thanks
Richard 

