Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778Ab0FBMEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 08:04:10 -0400
Received: from trinity.fluff.org ([89.16.178.74]:39027 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab0FBMEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 08:04:08 -0400
Date: Wed, 2 Jun 2010 13:03:56 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Ben Herrenchmidt <benh@kernel.crashing.org>
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
Message-ID: <20100602120356.GQ7248@trinity.fluff.org>
References: <1275479804.137633.565764505843.0.gpush@pororo> <1275479804.138101.137592675542.1.gpush@pororo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275479804.138101.137592675542.1.gpush@pororo>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 07:56:44PM +0800, Jeremy Kerr wrote:
> We currently have 21 definitions of struct clk in the ARM architecture,
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
> 	struct clk_operations *ops;
> 	atomic_t enable_count;
> };
> 
> And a set of clock operations (defined per type of clock):
> 
> struct clk_operations {
>        int             (*enable)(struct clk *);

I'd rather the enable/disable calls where simply a set
and a bool on/off, very rarelyt is the enable and disable
operartions different.

an aside, you might want to just clal these clk_ops to get into the
spirit of the original naming.

>        void            (*disable)(struct clk *);
>        unsigned long   (*get_rate)(struct clk *);
>        [...]
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
> struct clk_operations clk_foo_ops = {
> 	.get_rate = clk_foo_get_rate,
> };
> 
> The common clock definitions are based on a development patch from Ben
> Herrenschmidt <benh@kernel.crashing.org>.
> 
> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
> 
> ---
>  arch/Kconfig        |    3 
>  include/linux/clk.h |  148 +++++++++++++++++++++++++++++++++++---------
>  2 files changed, 124 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index acda512..2458b5e 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -151,4 +151,7 @@ config HAVE_MIXED_BREAKPOINTS_REGS
>  config HAVE_USER_RETURN_NOTIFIER
>  	bool
>  
> +config USE_COMMON_STRUCT_CLK
> +	bool
> +
>  source "kernel/gcov/Kconfig"
> diff --git a/include/linux/clk.h b/include/linux/clk.h
> index 1d37f42..f70137a 100644
> --- a/include/linux/clk.h
> +++ b/include/linux/clk.h
> @@ -3,6 +3,7 @@
>   *
>   *  Copyright (C) 2004 ARM Limited.
>   *  Written by Deep Blue Solutions Limited.
> + *  Copyright (c) 2010 Jeremy Kerr <jeremy.kerr@canonical.com>
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -11,36 +12,114 @@
>  #ifndef __LINUX_CLK_H
>  #define __LINUX_CLK_H
>  
> -struct device;
> +#include <linux/err.h>
> +#include <asm/atomic.h>
>  
> -/*
> - * The base API.
> +#ifdef CONFIG_USE_COMMON_STRUCT_CLK
> +
> +/* If we're using the common struct clk, we define the base clk object here,
> + * which will be 'subclassed' by device-specific implementations. For example:
> + *
> + *  struct clk_foo {
> + *      struct clk;
> + *      [device specific fields]
> + *  };
> + *
> + * We define the common clock API through a set of static inlines that call the
> + * corresponding clk_operations. The API is exactly the same as that documented
> + * in the !CONFIG_USE_COMMON_STRUCT_CLK case.
>   */
>  
> +struct clk {
> +	const struct clk_operations *ops;
> +	atomic_t enable_count;
> +};
> +
> +#define DEFINE_CLK(o) \
> +	{ .ops = &o, .enable_count = ATOMIC_INIT(0) }
> +
> +struct clk_operations {
> +       int             (*enable)(struct clk *);
> +       void            (*disable)(struct clk *);
> +       unsigned long   (*get_rate)(struct clk *);
> +       void            (*put)(struct clk *);
> +       long            (*round_rate)(struct clk *, unsigned long);
> +       int             (*set_rate)(struct clk *, unsigned long);
> +       int             (*set_parent)(struct clk *, struct clk *);
> +       struct clk*     (*get_parent)(struct clk *);
> +};
> +
> +static inline int clk_enable(struct clk *clk)
> +{
> +	if (!clk->ops->enable)
> +		return 0;
> +
> +	if (atomic_inc_return(&clk->enable_count) != 1)
> +		return 0;
> +
> +	return clk->ops->enable(clk);
> +}
> +
> +static inline void clk_disable(struct clk *clk)
> +{
> +	if (!clk->ops->disable)
> +		return;
> +
> +	if (atomic_dec_return(&clk->enable_count) != 0)
> +		return;
> +
> +	clk->ops->disable(clk);
> +}
> +
> +static inline unsigned long clk_get_rate(struct clk *clk)
> +{
> +	if (clk->ops->get_rate)
> +		return clk->ops->get_rate(clk);
> +	return 0;
> +}
> +
> +static inline void clk_put(struct clk *clk)
> +{
> +	if (clk->ops->put)
> +		clk->ops->put(clk);
> +}
> +
> +static inline long clk_round_rate(struct clk *clk, unsigned long rate)
> +{
> +	if (clk->ops->round_rate)
> +		return clk->ops->round_rate(clk, rate);
> +	return -ENOSYS;
> +}
> +
> +static inline int clk_set_rate(struct clk *clk, unsigned long rate)
> +{
> +	if (clk->ops->set_rate)
> +		return clk->ops->set_rate(clk, rate);
> +	return -ENOSYS;
> +}
> +
> +static inline int clk_set_parent(struct clk *clk, struct clk *parent)
> +{
> +	if (clk->ops->set_parent)
> +		return clk->ops->set_parent(clk, parent);
> +	return -ENOSYS;
> +}
> +
> +static inline struct clk *clk_get_parent(struct clk *clk)
> +{
> +	if (clk->ops->get_parent)
> +		return clk->ops->get_parent(clk);
> +	return ERR_PTR(-ENOSYS);
> +}
> +
> +#else /* !CONFIG_USE_COMMON_STRUCT_CLK */
>  
>  /*
> - * struct clk - an machine class defined object / cookie.
> + * Global clock object, actual structure is declared per-machine
>   */
>  struct clk;
>  
>  /**
> - * clk_get - lookup and obtain a reference to a clock producer.
> - * @dev: device for clock "consumer"
> - * @id: clock comsumer ID
> - *
> - * Returns a struct clk corresponding to the clock producer, or
> - * valid IS_ERR() condition containing errno.  The implementation
> - * uses @dev and @id to determine the clock consumer, and thereby
> - * the clock producer.  (IOW, @id may be identical strings, but
> - * clk_get may return different clock producers depending on @dev.)
> - *
> - * Drivers must assume that the clock source is not enabled.
> - *
> - * clk_get should not be called from within interrupt context.
> - */
> -struct clk *clk_get(struct device *dev, const char *id);
> -
> -/**
>   * clk_enable - inform the system when the clock source should be running.
>   * @clk: clock source
>   *
> @@ -83,12 +162,6 @@ unsigned long clk_get_rate(struct clk *clk);
>   */
>  void clk_put(struct clk *clk);
>  
> -
> -/*
> - * The remaining APIs are optional for machine class support.
> - */
> -
> -
>  /**
>   * clk_round_rate - adjust a rate to the exact rate a clock can provide
>   * @clk: clock source
> @@ -125,6 +198,27 @@ int clk_set_parent(struct clk *clk, struct clk *parent);
>   */
>  struct clk *clk_get_parent(struct clk *clk);
>  
> +#endif /* !CONFIG_USE_COMMON_STRUCT_CLK */
> +
> +struct device;
> +
> +/**
> + * clk_get - lookup and obtain a reference to a clock producer.
> + * @dev: device for clock "consumer"
> + * @id: clock comsumer ID
> + *
> + * Returns a struct clk corresponding to the clock producer, or
> + * valid IS_ERR() condition containing errno.  The implementation
> + * uses @dev and @id to determine the clock consumer, and thereby
> + * the clock producer.  (IOW, @id may be identical strings, but
> + * clk_get may return different clock producers depending on @dev.)
> + *
> + * Drivers must assume that the clock source is not enabled.
> + *
> + * clk_get should not be called from within interrupt context.
> + */
> +struct clk *clk_get(struct device *dev, const char *id);
> +
>  /**
>   * clk_get_sys - get a clock based upon the device name
>   * @dev_id: device name
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

