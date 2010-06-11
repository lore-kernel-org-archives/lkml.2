Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593Ab0FKEUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 00:20:50 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:26736 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750760Ab0FKEUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 00:20:49 -0400
Date: Fri, 11 Jun 2010 05:20:46 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Ben Herrenchmidt <benh@kernel.crashing.org>
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
Message-ID: <20100611042046.GA31045@fluff.org.uk>
References: <1275636608.606606.450179637764.0.gpush@pororo>
 <1275636608.607067.417709988883.1.gpush@pororo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275636608.607067.417709988883.1.gpush@pororo>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 03:30:08PM +0800, Jeremy Kerr wrote:
> We currently have 21 definitions of struct clk in the ARM architecture,
> each defined on a per-platform basis. This makes it difficult to define
> platform- (or architecture-) independent clock sources without making
> assumptions about struct clk, and impossible to compile two
> platforms with different struct clks into a single image.

Whilst I agree that this is a useful thing to do, I'd like to ensure
we get a good base for our work before we get another reason for Linus
to complain about churn.
 
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

What do people think of just changing everyone who is currently using
clk support to using this new implementation?
 
> struct clk {
> 	const struct clk_ops	*ops;
> 	unsigned int		enable_count;
> 	struct mutex		mutex;

I'm a little worried about the size of struct clk if all of them
have a mutex in them. If i'm right, this is 40 bytes of data each
clock has to take on board.

Doing the following:

find arch/arm -type f -name "*.c" | xargs grep -c -E "struct.*clk.*=.*{" | grep -v ":0" | awk 'BEGIN { count=0; FS=":" }
count += $2; END { print count }'

indicates that there's approximately 2241 clocks under arch/arm at the
moment. That's about 87KiB of mutexes if all are being compiled at
once.

~> };
> 
> And a set of clock operations (defined per type of clock):
> 
> struct clk_operations {
>        int             (*enable)(struct clk *);
still think that not passing an bool as a second argument is silly.

>        void            (*disable)(struct clk *);
~>        unsigned long   (*get_rate)(struct clk *);
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
>  include/linux/clk.h |  159 ++++++++++++++++++++++++++++++++++++--------
>  2 files changed, 135 insertions(+), 27 deletions(-)
~~~~> 
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
> index 1d37f42..bb6957a 100644
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
> @@ -11,36 +12,125 @@
>  #ifndef __LINUX_CLK_H
>  #define __LINUX_CLK_H
>  
> -struct device;
> +#include <linux/err.h>
> +#include <linux/mutex.h>
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
> +	const struct clk_ops	*ops;
> +	unsigned int		enable_count;
> +	struct mutex		mutex;
> +};

how about defining a nice kerneldoc for this.

> +#define INIT_CLK(name, o) \
> +	{ .ops = &o, .enable_count = 0, \
> +		.mutex = __MUTEX_INITIALIZER(name.mutex) }

how about doing the mutex initinitialisation at registration
time, will save a pile of non-zero code in the image to mess up
the compression.

~> +struct clk_ops {
> +       int             (*enable)(struct clk *);
> +       void            (*disable)(struct clk *);
> +       unsigned long   (*get_rate)(struct clk *);
> +       void            (*put)(struct clk *);
> +       long            (*round_rate)(struct clk *, unsigned long);
> +       int             (*set_rate)(struct clk *, unsigned long);
> +       int             (*set_parent)(struct clk *, struct clk *);
> +       struct clk*     (*get_parent)(struct clk *);

should each clock carry a parent field and the this is returned by
the get parent call.~~

> +};
> +
> +static inline int clk_enable(struct clk *clk)
> +{
> +	int ret = 0;
> +
> +	if (!clk->ops->enable)
> +		return 0;
> +
> +	mutex_lock(&clk->mutex);
> +	if (!clk->enable_count)
> +		ret = clk->ops->enable(clk);
> +
> +	if (!ret)
> +		clk->enable_count++;
> +	mutex_unlock(&clk->mutex);
> +
> +	return ret;
> +}

So we're leaving the enable parent code now to each implementation?

I think this is a really bad decision, it leaves so much open to bad
code repetition, as well as something the core should really be doing
if it had a parent clock field.

~> +static inline void clk_disable(struct clk *clk)
> +{
> +	if (!clk->ops->enable)
> +		return;

so if we've no enable call we ignore disable too?

also, we don't keep an enable count if this fields are in use,
could people rely on this being correct even if the clock has
no enable/disable fields.

Would much rather see the enable_count being kept up-to-date
no matter what, given it may be watched by other parts of the
implementation, useful for debug info, and possibly useful if
later in the start sequence the clk_ops get changed to have this
field.~

> +~	mutex_lock(&clk->mutex);
> +
> +	if (!--clk->enable_count)
> +		clk->ops->disable(clk);
> +
> +	mutex_unlock(&clk->mutex);
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

I'm beginging to wonder if we don't just have a set of default ops
that get set into the clk+ops at registration time if these do
not have an implementation.
~
> +static inline long clk_round_rate(struct clk *clk, unsigned long rate)
> +{
> +	if (clk->ops->round_rate)
> +		return clk->ops->round_rate(clk, rate);
> +	return -ENOSYS;
> +}
> +
> +static inline int clk_set_rate(struct clk *clk, unsigned long rate)
>~ +{
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

We have an interesting problem here which I belive should be dealt
with, what happens when the clock's parent is changed with respect
to the enable count of the parent.

With the following instance:

	we have clocks a, b, c;
	a and b are possible parents for c;
	c starts off with a as parent

then the driver comes along:

	1) gets clocks a, b, c;
	2) clk_enable(c);
	3) clk_set_parent(c, b);
	
now we have the following:

	A) clk a now has an enable count of non-zero
	B) clk b may not be enabled
	C) even though clk a may now be unused, it is still running
	D) even though clk c was enabled, it isn't running since step3

this means that either any driver that is using a multi-parent clock
has to deal with the proper enable/disable of the parents (this is
is going to lead to code repetition, and I bet people will get it
badly wrong).

I belive the core of the clock code should deal with this, since
otherwise we end up with the situation of the same code being
repeated throughout the kernel.

> +static inline struct clk *clk_get_parent(struct clk *clk)
> +{
> +	if (clk->ops->get_parent)
> +		return clk->ops->get_parent(clk);
> +	return ERR_PTR(-ENOSYS);
> +}
>
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
~> - * the clock producer.  (IOW, @id may be identical strings, but
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
> @@ -83,12 +173,6 @@ unsigned long clk_get_rate(struct clk *clk);
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
> @@ -125,6 +209,27 @@ int clk_set_parent(struct clk *clk, struct clk *parent);
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
~~> + */
> +struct clk *clk_get(struct device *dev, const char *id);
> +
>  /**
>   * clk_get_sys - get a clock based upon the device name
>   * @dev_id: device name
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
