Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab1BGIIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 03:08:52 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35579 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab1BGIIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 03:08:51 -0500
Date: Mon, 7 Feb 2011 09:08:32 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>
Subject: Re: [RFC,PATCH 1/3] Add a common struct clk
Message-ID: <20110207080832.GD27982@pengutronix.de>
References: <201102011711.31258.jeremy.kerr@canonical.com>
 <1297058877.800158.458894385837.1.gpush@pororo>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1297058877.800158.458894385837.1.gpush@pororo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 02:07:57PM +0800, Jeremy Kerr wrote:
> We currently have ~21 definitions of struct clk in the ARM architecture,
> each defined on a per-platform basis. This makes it difficult to define
> platform- (or architecture-) independent clock sources without making
> assumptions about struct clk, and impossible to compile two
> platforms with different struct clks into a single image.
> 
> This change is an effort to unify struct clk where possible, by defining
> a common struct clk, containing a set of clock operations. Different
> clock implementations can set their own operations, and have a standard
> interface for generic code. The callback interface is exposed to the
> kernel proper, while the clock implementations only need to be seen by
> the platform internals.
> 
> This allows us to share clock code among platforms, and makes it
> possible to dynamically create clock devices in platform-independent
> code.
> 
> Platforms can enable the generic struct clock through
> CONFIG_USE_COMMON_STRUCT_CLK. In this case, the clock infrastructure
> consists of a common struct clk:
> 
> struct clk {
> 	const struct clk_ops	*ops;
> 	unsigned int		enable_count;
> 	unsigned int		prepare_count;
> 	spinlock_t		enable_lock;
> 	struct mutex		prepare_lock;
> };
> 
> And a set of clock operations (defined per type of clock):
> 
> struct clk_ops {
> 	int             (*enable)(struct clk *);
> 	void            (*disable)(struct clk *);
> 	unsigned long   (*get_rate)(struct clk *);
> 	[...]
> };
> 
> To define a hardware-specific clock, machine code can "subclass" the
> struct clock into a new struct (adding any device-specific data), and
> provide a set of operations:
> 
> struct clk_foo {
> 	struct clk	clk;
> 	void __iomem	*some_register;
> };
> 
> struct clk_ops clk_foo_ops = {
> 	.get_rate = clk_foo_get_rate,
> };
> 
> The common clock definitions are based on a development patch from Ben
> Herrenschmidt <benh@kernel.crashing.org>.
> 
> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
> 
> ---
>  drivers/clk/Kconfig  |    3 
>  drivers/clk/Makefile |    1 
>  drivers/clk/clk.c    |  134 +++++++++++++++++++++++++++++++
>  drivers/clk/clkdev.c |    5 +
>  include/linux/clk.h  |  184 ++++++++++++++++++++++++++++++++++++++++---
>  5 files changed, 318 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index 4168c88..6e3ae54 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -2,3 +2,6 @@
>  config CLKDEV_LOOKUP
>  	bool
>  	select HAVE_CLK
> +
> +config USE_COMMON_STRUCT_CLK
> +	bool
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index 07613fa..a1a06d3 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -1,2 +1,3 @@
>  
>  obj-$(CONFIG_CLKDEV_LOOKUP)	+= clkdev.o
> +obj-$(CONFIG_USE_COMMON_STRUCT_CLK) += clk.o
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> new file mode 100644
> index 0000000..12e0daf
> --- /dev/null
> +++ b/drivers/clk/clk.c
> @@ -0,0 +1,134 @@
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
> +
> +int clk_prepare(struct clk *clk)
> +{
> +	int ret = 0;
> +
> +	if (!clk->ops->prepare)
> +		return 0;
> +
> +	mutex_lock(&clk->prepare_lock);
> +	if (clk->prepare_count == 0)
> +		ret = clk->ops->prepare(clk);
> +
> +	if (!ret)
> +		clk->prepare_count++;
> +	mutex_unlock(&clk->prepare_lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(clk_prepare);
> +
> +void clk_unprepare(struct clk *clk)
> +{
> +	if (!clk->ops->unprepare)
> +		return;
> +
> +	mutex_lock(&clk->prepare_lock);
> +	if (--clk->prepare_count == 0)
> +		clk->ops->unprepare(clk);
> +
> +	mutex_unlock(&clk->prepare_lock);
> +}
> +EXPORT_SYMBOL_GPL(clk_unprepare);
> +
> +int clk_enable(struct clk *clk)
> +{
> +	int ret = 0;
> +
> +	if (!clk->ops->enable)
> +		return 0;
> +
> +	spin_lock(&clk->enable_lock);
> +	if (!clk->enable_count)
> +		ret = clk->ops->enable(clk);
> +
> +	if (!ret)
> +		clk->enable_count++;
> +	spin_unlock(&clk->enable_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(clk_enable);
> +
> +void clk_disable(struct clk *clk)
> +{
> +	if (!clk->ops->disable)
> +		return;
> +
> +	spin_lock(&clk->enable_lock);
> +
> +	WARN_ON(!clk->enable_count);
> +
> +	if (!--clk->enable_count)
> +		clk->ops->disable(clk);
> +
> +	spin_unlock(&clk->enable_lock);
> +}
> +EXPORT_SYMBOL_GPL(clk_disable);
> +
> +unsigned long clk_get_rate(struct clk *clk)
> +{
> +	if (clk->ops->get_rate)
> +		return clk->ops->get_rate(clk);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(clk_get_rate);
> +
> +int __clk_get(struct clk *clk)
> +{
> +	if (clk->ops->get)
> +		return clk->ops->get(clk);
> +	return 1;
> +}
> +EXPORT_SYMBOL_GPL(__clk_get);
> +
> +void clk_put(struct clk *clk)
> +{
> +	if (clk->ops->put)
> +		clk->ops->put(clk);
> +}
> +EXPORT_SYMBOL_GPL(clk_put);
> +
> +long clk_round_rate(struct clk *clk, unsigned long rate)
> +{
> +	if (clk->ops->round_rate)
> +		return clk->ops->round_rate(clk, rate);
> +	return -ENOSYS;
> +}
> +EXPORT_SYMBOL_GPL(clk_round_rate);
> +
> +int clk_set_rate(struct clk *clk, unsigned long rate)
> +{
> +	if (clk->ops->set_rate)
> +		return clk->ops->set_rate(clk, rate);
> +	return -ENOSYS;
> +}
> +EXPORT_SYMBOL_GPL(clk_set_rate);
> +
> +int clk_set_parent(struct clk *clk, struct clk *parent)
> +{
> +	if (clk->ops->set_parent)
> +		return clk->ops->set_parent(clk, parent);
> +	return -ENOSYS;
> +}
> +EXPORT_SYMBOL_GPL(clk_set_parent);
> +
> +struct clk *clk_get_parent(struct clk *clk)
> +{
> +	if (clk->ops->get_parent)
> +		return clk->ops->get_parent(clk);
> +	return ERR_PTR(-ENOSYS);
> +}
> +EXPORT_SYMBOL_GPL(clk_get_parent);
> diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
> index 0fc0a79..17619c7 100644
> --- a/drivers/clk/clkdev.c
> +++ b/drivers/clk/clkdev.c
> @@ -84,12 +84,17 @@ struct clk *clk_get(struct device *dev, const char *con_id)
>  }
>  EXPORT_SYMBOL(clk_get);
>  
> +#ifndef CONFIG_USE_COMMON_STRUCT_CLK
> +/* For the common struct clk case, clk_put is provided by clk.c */
> +
>  void clk_put(struct clk *clk)
>  {
>  	__clk_put(clk);
>  }
>  EXPORT_SYMBOL(clk_put);
>  
> +#endif
> +
>  void clkdev_add(struct clk_lookup *cl)
>  {
>  	mutex_lock(&clocks_mutex);
> diff --git a/include/linux/clk.h b/include/linux/clk.h
> index 1d37f42..e081ca1 100644
> --- a/include/linux/clk.h
> +++ b/include/linux/clk.h
> @@ -3,6 +3,7 @@
>   *
>   *  Copyright (C) 2004 ARM Limited.
>   *  Written by Deep Blue Solutions Limited.
> + *  Copyright (c) 2010-2011 Jeremy Kerr <jeremy.kerr@canonical.com>
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -11,18 +12,189 @@
>  #ifndef __LINUX_CLK_H
>  #define __LINUX_CLK_H
>  
> +#include <linux/err.h>
> +#include <linux/mutex.h>
> +#include <linux/spinlock.h>
> +
>  struct device;
>  
> -/*
> - * The base API.
> +#ifdef CONFIG_USE_COMMON_STRUCT_CLK
> +
> +/* If we're using the common struct clk, we define the base clk object here */
> +
> +/**
> + * struct clk - hardware independent clock structure
> + * @ops:		implementation-specific ops for this clock
> + * @enable_count:	count of clk_enable() calls active on this clock
> + * @flags:		platform-independent flags
> + * @lock:		lock for enable/disable or other HW-specific ops
> + *
> + * The base clock object, used by drivers for hardware-independent manipulation
> + * of clock lines. This will be 'subclassed' by device-specific implementations,
> + * which add device-specific data to struct clk. For example:
> + *
> + *  struct clk_foo {
> + *      struct clk;
> + *      [device specific fields]
> + *  };
> + *
> + * The clock driver code will manage the device-specific data, and pass
> + * clk_foo.clk to the common clock code. The clock driver will be called
> + * through the @ops callbacks.
> + *
> + * The @lock member provides either a spinlock or a mutex to protect (at least)
> + * @enable_count. The type of lock used will depend on @flags; if CLK_ATOMIC is
> + * set, then the core clock code will use a spinlock, otherwise a mutex. This
> + * lock will be acquired during clk_enable and clk_disable, so for atomic
> + * clocks, these ops callbacks must not sleep.
> + *
> + * The choice of atomic or non-atomic clock depends on how the clock is enabled.
> + * Typically, you'll want to use a non-atomic clock. For clocks that need to be
> + * enabled/disabled in interrupt context, use CLK_ATOMIC. Note that atomic
> + * clocks with parents will typically cascade enable/disable operations to
> + * their parent, so the parent of an atomic clock *must* be atomic too.
>   */
This comment needs a general overhaul.

(I had this comment already in my first mail, but I must have deleted it
when removing the unrealted quotes.)

> +struct clk {
> +	const struct clk_ops	*ops;
> +	unsigned int		enable_count;
> +	unsigned int		prepare_count;
> +	spinlock_t		enable_lock;
> +	struct mutex		prepare_lock;
> +};

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
