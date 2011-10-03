Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab1JCORt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 10:17:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62477 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab1JCORl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 10:17:41 -0400
Message-ID: <4E89C3FA.9020206@gmail.com>
Date: Mon, 03 Oct 2011 09:17:30 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@ti.com>
CC: linux-kernel@vger.kernel.org, paul@pwsan.com, linaro-dev@lists.linaro.org,
        linus.walleij@stericsson.com, patches@linaro.org, eric.miao@linaro.org,
        broonie@opensource.wolfsonmicro.com, magnus.damm@gmail.com,
        amit.kucheria@linaro.org, richard.zhao@linaro.org,
        grant.likely@secretlab.ca, dsaxena@linaro.org,
        arnd.bergmann@linaro.org, shawn.guo@freescale.com, skannan@quicinc.com,
        linux@arm.linux.org.uk, jeremy.kerr@canonical.com, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, sboyd@quiinc.com
Subject: Re: [PATCH v2 1/7] clk: Add a generic clock infrastructure
References: <1316730422-20027-1-git-send-email-mturquette@ti.com> <1316730422-20027-2-git-send-email-mturquette@ti.com>
In-Reply-To: <1316730422-20027-2-git-send-email-mturquette@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2011 05:26 PM, Mike Turquette wrote:
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
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index 3530927..c53ed59 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -5,3 +5,6 @@ config CLKDEV_LOOKUP
>  
>  config HAVE_MACH_CLKDEV
>  	bool
> +
> +config GENERIC_CLK
> +	bool
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index 07613fa..570d5b9 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -1,2 +1,3 @@
>  
>  obj-$(CONFIG_CLKDEV_LOOKUP)	+= clkdev.o
> +obj-$(CONFIG_GENERIC_CLK)	+= clk.o
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> new file mode 100644
> index 0000000..1cd7315
> --- /dev/null
> +++ b/drivers/clk/clk.c
> @@ -0,0 +1,232 @@
> +/*
> + * Copyright (C) 2010-2011 Canonical Ltd <jeremy.kerr@canonical.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Standard functionality for the common clock API.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +
> +struct clk {
> +	const char		*name;
> +	const struct clk_hw_ops	*ops;
> +	struct clk_hw		*hw;
> +	unsigned int		enable_count;
> +	unsigned int		prepare_count;
> +	struct clk		*parent;
> +	unsigned long		rate;
> +};
> +
> +static DEFINE_SPINLOCK(enable_lock);
> +static DEFINE_MUTEX(prepare_lock);
> +
> +static void __clk_unprepare(struct clk *clk)
> +{
> +	if (!clk)
> +		return;
> +
> +	if (WARN_ON(clk->prepare_count == 0))
> +		return;
> +
> +	if (--clk->prepare_count > 0)
> +		return;
> +
> +	WARN_ON(clk->enable_count > 0);
> +
> +	if (clk->ops->unprepare)
> +		clk->ops->unprepare(clk->hw);
> +
> +	__clk_unprepare(clk->parent);
> +}
> +
> +void clk_unprepare(struct clk *clk)
> +{
> +	mutex_lock(&prepare_lock);
> +	__clk_unprepare(clk);
> +	mutex_unlock(&prepare_lock);
> +}
> +EXPORT_SYMBOL_GPL(clk_unprepare);
> +
> +static int __clk_prepare(struct clk *clk)
> +{
> +	int ret = 0;
> +
> +	if (!clk)
> +		return 0;
> +
> +	if (clk->prepare_count == 0) {
> +		ret = __clk_prepare(clk->parent);
> +		if (ret)
> +			return ret;
> +
> +		if (clk->ops->prepare) {
> +			ret = clk->ops->prepare(clk->hw);
> +			if (ret) {
> +				__clk_unprepare(clk->parent);
> +				return ret;
> +			}
> +		}
> +	}
> +
> +	clk->prepare_count++;
> +
> +	return 0;
> +}
> +
> +int clk_prepare(struct clk *clk)
> +{
> +	int ret;
> +
> +	mutex_lock(&prepare_lock);
> +	ret = __clk_prepare(clk);
> +	mutex_unlock(&prepare_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(clk_prepare);
> +
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
> +unsigned long clk_get_rate(struct clk *clk)
> +{
> +	if (!clk)
> +		return 0;
> +	return clk->rate;
> +}
> +EXPORT_SYMBOL_GPL(clk_get_rate);
> +
> +long clk_round_rate(struct clk *clk, unsigned long rate)
> +{
> +	if (clk && clk->ops->round_rate)
> +		return clk->ops->round_rate(clk->hw, rate);
> +	return rate;
> +}
> +EXPORT_SYMBOL_GPL(clk_round_rate);
> +
> +int clk_set_rate(struct clk *clk, unsigned long rate)
> +{
> +	/* not yet implemented */
> +	return -ENOSYS;
> +}
> +EXPORT_SYMBOL_GPL(clk_set_rate);
> +
> +struct clk *clk_get_parent(struct clk *clk)
> +{
> +	if (!clk)
> +		return NULL;
> +
> +	return clk->parent;
> +}
> +EXPORT_SYMBOL_GPL(clk_get_parent);
> +
> +int clk_set_parent(struct clk *clk, struct clk *parent)
> +{
> +	/* not yet implemented */
> +	return -ENOSYS;
> +}
> +EXPORT_SYMBOL_GPL(clk_set_parent);
> +
> +struct clk *clk_register(const struct clk_hw_ops *ops, struct clk_hw *hw,
> +		const char *name)
> +{
> +	struct clk *clk;
> +
> +	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
> +	if (!clk)
> +		return NULL;
> +
> +	INIT_HLIST_HEAD(&clk->children);
> +	INIT_HLIST_NODE(&clk->child_node);
> +
> +	clk->name = name;
> +	clk->ops = ops;
> +	clk->hw = hw;
> +	hw->clk = clk;
> +
> +	/* Query the hardware for parent and initial rate */
> +
> +	if (clk->ops->get_parent)
> +		/* We don't to lock against prepare/enable here, as
> +		 * the clock is not yet accessible from anywhere */
> +		clk->parent = clk->ops->get_parent(clk->hw);

I don't think this is going to work. This implies that the parent clock
is already registered. For simple clk trees, that's probably not an
issue, but for chips with lots of muxing it will be impossible to get
the order correct for all cases. This is not an issue today as most
clocks are statically created.

I think what is needed is a 2 stage init. The 1st stage to create all
the clocks and a 2nd stage to build the tree once all clocks are created.

Tracking the parents using struct clk_hw instead would help as long as
clocks are still statically allocated. However, that won't help for
devicetree.

Rob
