Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732Ab1LNEwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 23:52:20 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54972 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab1LNEwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 23:52:19 -0500
Message-ID: <4EE82B76.2000204@gmail.com>
Date: Wed, 14 Dec 2011 15:52:06 +1100
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
        andrew@lunn.ch
Subject: Re: [PATCH v4 3/6] clk: introduce the common clock framework
References: <1323834838-2206-1-git-send-email-mturquette@linaro.org> <1323834838-2206-4-git-send-email-mturquette@linaro.org>
In-Reply-To: <1323834838-2206-4-git-send-email-mturquette@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/12/11 14:53, Mike Turquette wrote:

> The common clk framework is an attempt to define a common struct clk
> which can be used by most platforms, and an API that drivers can always
> use safely for managing clks.
> 
> The net result is consolidation of many different struct clk definitions
> and platform-specific clk framework implementations.
> 
> This patch introduces the common struct clk, struct clk_ops and
> definitions for the long-standing clk API in include/clk/clk.h.
> Platforms may define their own hardware-specific clk structure, so long
> as it wraps an instance of the common struct clk which is passed to
> clk_init at initialization time.  From this point on all of the usual
> clk APIs should be supported, so long as the platform supports them
> through hardware-specific callbacks in struct clk_ops.
> 
> See Documentation/clk.txt for more details.
> 
> This patch is based on the work of Jeremy Kerr, which in turn was based
> on the work of Ben Herrenschmidt.  Big thanks to both of them for
> kickstarting this effort.
> 
> Signed-off-by: Mike Turquette <mturquette@linaro.org>
> Cc: Jeremy Kerr <jeremy.kerr@canonical.com>


Hi Mike,

Some comments below,

~Ryan

> ---
>  drivers/clk/Kconfig  |    4 +
>  drivers/clk/Makefile |    1 +
>  drivers/clk/clk.c    |  564 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/clk.h  |  130 +++++++++++-
>  4 files changed, 695 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/clk/clk.c
> 
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index 7a9899bd..adc0586 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -8,3 +8,7 @@ config HAVE_MACH_CLKDEV
>  
>  config HAVE_CLK_PREPARE
>  	bool
> +
> +config GENERIC_CLK
> +	bool
> +	select HAVE_CLK_PREPARE
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
> index 0000000..8cadadd
> --- /dev/null
> +++ b/drivers/clk/clk.c
> @@ -0,0 +1,564 @@
> +/*
> + * Copyright (C) 2010-2011 Canonical Ltd <jeremy.kerr@canonical.com>
> + * Copyright (C) 2011 Linaro Ltd <mturquette@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Standard functionality for the common clock API.  See Documentation/clk.txt
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/spinlock.h>
> +#include <linux/err.h>
> +#include <linux/list.h>
> +
> +static DEFINE_SPINLOCK(enable_lock);
> +static DEFINE_MUTEX(prepare_lock);
> +
> +static HLIST_HEAD(clk_root_list);
> +
> +/***        clk API        ***/
> +
> +void __clk_unprepare(struct clk *clk)
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
> +		clk->ops->unprepare(clk);
> +
> +	__clk_unprepare(clk->parent);
> +}


I think you can rewrite this to get rid of the recursion as below:

	while (clk) {
		if (WARN_ON(clk->prepare_count == 0))
			return;

		if (--clk->prepare_count > 0)
			return;

		WARN_ON(clk->enable_count > 0)

		if (clk->ops->unprepare)
			clk->ops->unprepare(clk);

		clk = clk->parent;
	}

Also, should this function be static?

> +
> +/**
> + * clk_unprepare - perform the slow part of a clk gate
> + * @clk: the clk being gated
> + *
> + * clk_unprepare may sleep, which differentiates it from clk_disable.  In a
> + * simple case, clk_unprepare can be used instead of clk_disable to gate a clk
> + * if the operation may sleep.  One example is a clk which is accessed over
> + * I2c.  In the complex case a clk gate operation may require a fast and a slow
> + * part.  It is this reason that clk_unprepare and clk_disable are not mutually
> + * exclusive.  In fact clk_disable must be called before clk_unprepare.
> + */
> +void clk_unprepare(struct clk *clk)
> +{
> +	mutex_lock(&prepare_lock);
> +	__clk_unprepare(clk);
> +	mutex_unlock(&prepare_lock);
> +}
> +EXPORT_SYMBOL_GPL(clk_unprepare);
> +
> +int __clk_prepare(struct clk *clk)
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
> +			ret = clk->ops->prepare(clk);
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


This is unfortunately a bit tricky to remove the recursion from without
keeping a local stack of the clocks leading up to first unprepared
client :-/.

Again, should this be static? What outside this file needs to
prepare/unprepare clocks without the lock held?

> +

> +/**
> + * clk_prepare - perform the slow part of a clk ungate
> + * @clk: the clk being ungated
> + *
> + * clk_prepare may sleep, which differentiates it from clk_enable.  In a simple
> + * case, clk_prepare can be used instead of clk_enable to ungate a clk if the
> + * operation may sleep.  One example is a clk which is accessed over I2c.  In
> + * the complex case a clk ungate operation may require a fast and a slow part.
> + * It is this reason that clk_prepare and clk_enable are not mutually
> + * exclusive.  In fact clk_prepare must be called before clk_enable.
> + * Returns 0 on success, -EERROR otherwise.
> + */
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
> +void __clk_disable(struct clk *clk)
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
> +		clk->ops->disable(clk);
> +
> +	if (clk->parent)
> +		__clk_disable(clk->parent);


Easy to get rid of the recursion here. Also should be static?

> +}
> +
> +/**
> + * clk_disable - perform the fast part of a clk gate
> + * @clk: the clk being gated
> + *
> + * clk_disable must not sleep, which differentiates it from clk_unprepare.  In
> + * a simple case, clk_disable can be used instead of clk_unprepare to gate a
> + * clk if the operation is fast and will never sleep.  One example is a
> + * SoC-internal clk which is controlled via simple register writes.  In the
> + * complex case a clk gate operation may require a fast and a slow part.  It is
> + * this reason that clk_unprepare and clk_disable are not mutually exclusive.
> + * In fact clk_disable must be called before clk_unprepare.
> + */
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
> +int __clk_enable(struct clk *clk)
> +{
> +	int ret = 0;
> +
> +	if (!clk)
> +		return 0;
> +
> +	if (WARN_ON(clk->prepare_count == 0))
> +		return -ESHUTDOWN;
> +
> +	if (clk->enable_count == 0) {
> +		if (clk->parent)
> +			ret = __clk_enable(clk->parent);
> +
> +		if (ret)
> +			return ret;
> +
> +		if (clk->ops->enable) {
> +			ret = clk->ops->enable(clk);
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
> +/**
> + * clk_enable - perform the fast part of a clk ungate
> + * @clk: the clk being ungated
> + *
> + * clk_enable must not sleep, which differentiates it from clk_prepare.  In a
> + * simple case, clk_enable can be used instead of clk_prepare to ungate a clk
> + * if the operation will never sleep.  One example is a SoC-internal clk which
> + * is controlled via simple register writes.  In the complex case a clk ungate
> + * operation may require a fast and a slow part.  It is this reason that
> + * clk_enable and clk_prepare are not mutually exclusive.  In fact clk_prepare
> + * must be called before clk_enable.  Returns 0 on success, -EERROR
> + * otherwise.
> + */
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
> +/**
> + * clk_get_rate - return the rate of clk
> + * @clk: the clk whose rate is being returned
> + *
> + * Simply returns the cached rate of the clk.  Does not query the hardware.  If
> + * clk is NULL then returns 0.
> + */
> +unsigned long clk_get_rate(struct clk *clk)
> +{
> +	unsigned long rate;
> +
> +	if (!clk)
> +		return 0;
> +
> +	mutex_lock(&prepare_lock);
> +	rate = clk->rate;
> +	mutex_unlock(&prepare_lock);
> +
> +	return rate;
> +}
> +EXPORT_SYMBOL_GPL(clk_get_rate);
> +
> +/**
> + * clk_round_rate - round the given rate for a clk
> + * @clk: the clk for which we are rounding a rate
> + * @rate: the rate which is to be rounded
> + *
> + * Takes in a rate as input and rounds it to a rate that the clk can actually
> + * use which is then returned.  If clk doesn't support round_rate operation
> + * then the rate passed in is returned.
> + */
> +long clk_round_rate(struct clk *clk, unsigned long rate)
> +{
> +	if (clk && clk->ops->round_rate)
> +		return clk->ops->round_rate(clk, rate, NULL);
> +
> +	return rate;
> +}
> +EXPORT_SYMBOL_GPL(clk_round_rate);


If the clock doesn't provide a round rate function then shouldn't we
return an error to the caller? Telling the caller that the rate is
perfect might lead to odd driver bugs?

> +
> +/**
> + * __clk_recalc_rates
> + * @clk: first clk in the subtree
> + *
> + * Walks the subtree of clks starting with clk and recalculates rates as it
> + * goes.  Note that if a clk does not implement the recalc_rate operation then
> + * propagation of that subtree stops and all of that clks children will not
> + * have their rates updated.  Caller must hold prepare_lock.
> + */
> +static void __clk_recalc_rates(struct clk *clk)
> +{
> +	struct hlist_node *tmp;
> +	struct clk *child;
> +
> +	if (!clk->ops->recalc_rate) {
> +		pr_debug("%s: no .recalc_rate for clk %s\n",
> +				__func__, clk->name);
> +		return;
> +	}
> +
> +	clk->rate = clk->ops->recalc_rate(clk);
> +
> +	/* FIXME add post-rate change notification here */
> +
> +	hlist_for_each_entry(child, tmp, &clk->children, child_node)
> +		__clk_recalc_rates(child);
> +}
> +
> +/**
> + * DOC: Using the CLK_PARENT_SET_RATE flag
> + *
> + * __clk_set_rate changes the child's rate before the parent's to more
> + * easily handle failure conditions.
> + *
> + * This means clk might run out of spec for a short time if its rate is
> + * increased before the parent's rate is updated.
> + *
> + * To prevent this consider setting the CLK_GATE_SET_RATE flag on any
> + * clk where you also set the CLK_PARENT_SET_RATE flag
> + */


Is this standard kerneldoc format?

> +struct clk *__clk_set_rate(struct clk *clk, unsigned long rate)


static?

> +{
> +	struct clk *fail_clk = NULL;
> +	int ret = 0;
> +	unsigned long old_rate = clk->rate;
> +	unsigned long new_rate;
> +	unsigned long parent_old_rate;
> +	unsigned long parent_new_rate = 0;
> +	struct clk *child;
> +	struct hlist_node *tmp;
> +
> +	/* bail early if we can't change rate while clk is enabled */
> +	if ((clk->flags & CLK_GATE_SET_RATE) && clk->enable_count)
> +		return clk;
> +
> +	/* find the new rate and see if parent rate should change too */
> +	WARN_ON(!clk->ops->round_rate);
> +
> +	new_rate = clk->ops->round_rate(clk, rate, &parent_new_rate);
> +
> +	/* FIXME propagate pre-rate change notification here */
> +	/* XXX note that pre-rate change notifications will stack */
> +
> +	/* change the rate of this clk */
> +	if (clk->ops->set_rate)
> +		ret = clk->ops->set_rate(clk, new_rate);
> +
> +	if (ret)
> +		return clk;


Is there are reason to write it this way and not:

	if (clk->ops->set_rate) {
		ret = clk->ops->set_rate(clk, new_rate);
		if (ret)
			return clk;
	}

If !clk->ops->set_rate then ret is always zero right? Note, making this
change means that you don't need to init ret to zero at the top of this
function.

> +
> +	/*
> +	 * change the rate of the parent clk if necessary
> +	 *
> +	 * hitting the nested 'if' path implies we have hit a .set_rate
> +	 * failure somewhere upstream while propagating __clk_set_rate
> +	 * up the clk tree.  roll back the clk rates one by one and
> +	 * return the pointer to the clk that failed.  clk_set_rate will
> +	 * use the pointer to propagate a rate-change abort notifier
> +	 * from the "highest" point.
> +	 */
> +	if ((clk->flags & CLK_PARENT_SET_RATE) && parent_new_rate) {
> +		parent_old_rate = clk->parent->rate;
> +		fail_clk = __clk_set_rate(clk->parent, parent_new_rate);
> +
> +		/* roll back changes if parent rate change failed */
> +		if (fail_clk) {
> +			pr_warn("%s: failed to set parent %s rate to %lu\n",
> +					__func__, fail_clk->name,
> +					parent_new_rate);
> +			clk->ops->set_rate(clk, old_rate);
> +		}
> +		return fail_clk;
> +	}
> +
> +	/*
> +	 * set clk's rate & recalculate the rates of clk's children
> +	 *
> +	 * hitting this path implies we have successfully finished
> +	 * propagating recursive calls to __clk_set_rate up the clk tree
> +	 * (if necessary) and it is safe to propagate __clk_recalc_rates
> +	 * and post-rate change notifiers down the clk tree from this
> +	 * point.
> +	 */
> +	/* FIXME propagate post-rate change notifier starting with this clk */
> +	__clk_recalc_rates(clk);
> +
> +	return NULL;
> +}
> +
> +/**
> + * clk_set_rate - specify a new rate for clk
> + * @clk: the clk whose rate is being changed
> + * @rate: the new rate for clk
> + *
> + * In the simplest case clk_set_rate will only change the rate of clk.
> + *
> + * If clk has the CLK_GATE_SET_RATE flag set and it is enabled this call
> + * will fail; only when the clk is disabled will it be able to change
> + * its rate.
> + *
> + * Setting the CLK_PARENT_SET_RATE flag allows clk_set_rate to
> + * recursively propagate up to clk's parent; whether or not this happens
> + * depends on the outcome of clk's .round_rate implementation.  If
> + * *parent_rate is 0 after calling .round_rate then upstream parent
> + * propagation is ignored.  If *parent_rate comes back with a new rate
> + * for clk's parent then we propagate up to clk's parent and set it's
> + * rate.  Upward propagation will continue until either a clk does not
> + * support the CLK_PARENT_SET_RATE flag or .round_rate stops requesting
> + * changes to clk's parent_rate.  If there is a failure during upstream
> + * propagation then clk_set_rate will unwind and restore each clk's rate
> + * that had been successfully changed.  Afterwards a rate change abort
> + * notification will be propagated downstream, starting from the clk
> + * that failed.
> + *
> + * At the end of all of the rate setting, clk_set_rate internally calls
> + * __clk_recalc_rates and propagates the rate changes downstream,
> + * starting from the highest clk whose rate was changed.  This has the
> + * added benefit of propagating post-rate change notifiers.
> + *
> + * Note that while post-rate change and rate change abort notifications
> + * are guaranteed to be sent to a clk only once per call to
> + * clk_set_rate, pre-change notifications will be sent for every clk
> + * whose rate is changed.  Stacking pre-change notifications is noisy
> + * for the drivers subscribed to them, but this allows drivers to react
> + * to intermediate clk rate changes up until the point where the final
> + * rate is achieved at the end of upstream propagation.
> + *
> + * Returns 0 on success, -EERROR otherwise.
> + */
> +int clk_set_rate(struct clk *clk, unsigned long rate)
> +{
> +	struct clk *fail_clk;
> +	int ret = 0;
> +
> +	/* prevent racing with updates to the clock topology */
> +	mutex_lock(&prepare_lock);
> +
> +	/* bail early if nothing to do */
> +	if (rate == clk->rate)
> +		goto out;

> +
> +	fail_clk = __clk_set_rate(clk, rate);
> +	if (fail_clk) {
> +		pr_warn("%s: failed to set %s rate\n", __func__,
> +				fail_clk->name);
> +		/* FIXME propagate rate change abort notification here */
> +		ret = -EIO;


Why does __clk_set_rate return a struct clk if you don't do anything
with it? You can move the pr_warn into __clk_set_rate and have it return
a proper errno value instead so that you get a reason why it failed to
set the rate.

> +	}
> +out:
> +	mutex_unlock(&prepare_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(clk_set_rate);
> +
> +/**
> + * clk_get_parent - return the parent of a clk
> + * @clk: the clk whose parent gets returned
> + *
> + * Simply returns clk->parent.  It is up to the caller to hold the
> + * prepare_lock, if desired.  Returns NULL if clk is NULL.
> + */
> +struct clk *clk_get_parent(struct clk *clk)
> +{
> +	struct clk *parent;
> +
> +	if (!clk)
> +		return NULL;
> +
> +	mutex_lock(&prepare_lock);
> +	parent = clk->parent;
> +	mutex_unlock(&prepare_lock);
> +
> +	return parent;
> +}
> +EXPORT_SYMBOL_GPL(clk_get_parent);
> +
> +void __clk_reparent(struct clk *clk, struct clk *new_parent)
> +{

> +	if (!clk || !new_parent)
> +		return;


clk_reparent already checks for !clk, shouldn't it also check for
!new_parent and remove the check from here?

> +
> +	hlist_del(&clk->child_node);
> +	hlist_add_head(&clk->child_node, &new_parent->children);
> +
> +	clk->parent = new_parent;
> +
> +	/* FIXME update sysfs clock topology */
> +}
> +
> +/**
> + * clk_set_parent - switch the parent of a mux clk
> + * @clk: the mux clk whose input we are switching
> + * @parent: the new input to clk
> + *
> + * Re-parent clk to use parent as it's new input source.  If clk has the
> + * CLK_GATE_SET_PARENT flag set then clk must be gated for this
> + * operation to succeed.  After successfully changing clk's parent
> + * clk_set_parent will update the clk topology, sysfs topology and
> + * propagate rate recalculation via __clk_recalc_rates.  Returns 0 on
> + * success, -EERROR otherwise.
> + */
> +int clk_set_parent(struct clk *clk, struct clk *parent)
> +{
> +	int ret = 0;
> +
> +	if (!clk || !clk->ops)
> +		return -EINVAL;
> +
> +	if (!clk->ops->set_parent)
> +		return -ENOSYS;
> +
> +	/* prevent racing with updates to the clock topology */
> +	mutex_lock(&prepare_lock);
> +
> +	if (clk->parent == parent)
> +		goto out;
> +
> +	/* FIXME add pre-rate change notification here */
> +
> +	/* only re-parent if the clock is not in use */
> +	if ((clk->flags & CLK_GATE_SET_PARENT) && clk->prepare_count)
> +		ret = -EBUSY;
> +	else
> +		ret = clk->ops->set_parent(clk, parent);
> +
> +	if (ret < 0)
> +		/* FIXME add rate change abort notification here */
> +		goto out;
> +
> +	/* update tree topology */
> +	__clk_reparent(clk, parent);
> +
> +	/*
> +	 * If successful recalculate the rates of the clock, including
> +	 * children.
> +	 */
> +	__clk_recalc_rates(clk);
> +
> +out:
> +	mutex_unlock(&prepare_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(clk_set_parent);
> +
> +/**
> + * clk_init - initialize the data structures in a struct clk
> + * @dev: device initializing this clk, placeholder for now
> + * @clk: clk being initialized
> + *
> + * Initializes the lists in struct clk, queries the hardware for the
> + * parent and rate and sets them both.  Adds the clk to the sysfs tree
> + * topology.
> + *
> + * Caller must populate clk->name and clk->flags before calling
> + * clk_init.  A key assumption in the call to .get_parent is that clks
> + * are being initialized in-order.
> + */
> +void clk_init(struct device *dev, struct clk *clk)
> +{
> +	if (!clk)
> +		return;
> +
> +	INIT_HLIST_HEAD(&clk->children);
> +	INIT_HLIST_NODE(&clk->child_node);
> +
> +	mutex_lock(&prepare_lock);
> +
> +	/*
> +	 * .get_parent is mandatory for populating .parent for clks with
> +	 * multiple possible parents.  For clks with a fixed parent
> +	 * .get_parent is not mandatory and .parent can be statically
> +	 * initialized
> +	 */
> +	if (clk->ops->get_parent)

> +		clk->parent = clk->ops->get_parent(clk);
> +
> +	/* clks without a parent are considered root clks */
> +	if (clk->parent)
> +		hlist_add_head(&clk->child_node,
> +				&clk->parent->children);
> +	else
> +		hlist_add_head(&clk->child_node, &clk_root_list);
> +
> +	if (clk->ops->recalc_rate)
> +		clk->rate = clk->ops->recalc_rate(clk);
> +	else
> +		clk->rate = 0;
> +
> +	mutex_unlock(&prepare_lock);
> +
> +	return;
> +}
> +EXPORT_SYMBOL_GPL(clk_init);
> diff --git a/include/linux/clk.h b/include/linux/clk.h
> index 7213b52..9cb8d72 100644
> --- a/include/linux/clk.h
> +++ b/include/linux/clk.h
> @@ -3,6 +3,8 @@
>   *
>   *  Copyright (C) 2004 ARM Limited.
>   *  Written by Deep Blue Solutions Limited.
> + *  Copyright (c) 2010-2011 Jeremy Kerr <jeremy.kerr@canonical.com>
> + *  Copyright (C) 2011 Linaro Ltd <mturquette@linaro.org>
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -12,18 +14,137 @@
>  #define __LINUX_CLK_H
>  
>  #include <linux/kernel.h>
> +#include <linux/errno.h>
>  
>  struct device;
>  
> +struct clk;
> +
> +#ifdef CONFIG_GENERIC_CLK
> +
>  /*
> - * The base API.
> + * flags used across common struct clk.  these flags should only affect the
> + * top-level framework.  custom flags for dealing with hardware specifics
> + * belong in struct clk_hw_your_unique_device
>   */
> +#define CLK_GATE_SET_RATE	BIT(0) /* must be gated across rate change */
> +#define CLK_GATE_SET_PARENT	BIT(1) /* must be gated across re-parent */
> +#define CLK_PARENT_SET_RATE	BIT(2) /* propagate rate change up one level */
> +#define CLK_IGNORE_UNUSED	BIT(3) /* do not gate even if unused */
>  
> +#define CLK_GATE_RATE_CHANGE	(CLK_GATE_SET_RATE | CLK_GATE_SET_PARENT)
>  
> -/*
> - * struct clk - an machine class defined object / cookie.
> +struct clk {
> +	const char		*name;
> +	const struct clk_hw_ops	*ops;
> +	struct clk		*parent;
> +	unsigned long		rate;
> +	unsigned long		flags;
> +	unsigned int		enable_count;
> +	unsigned int		prepare_count;
> +	struct hlist_head	children;
> +	struct hlist_node	child_node;
> +};
> +
> +/**
> + * struct clk_hw_ops -  Callback operations for hardware clocks; these are to
> + * be provided by the clock implementation, and will be called by drivers
> + * through the clk_* API.
> + *
> + * @prepare:	Prepare the clock for enabling. This must not return until
> + * 		the clock is fully prepared, and it's safe to call clk_enable.
> + * 		This callback is intended to allow clock implementations to
> + * 		do any initialisation that may sleep. Called with
> + * 		prepare_lock held.
> + *
> + * @unprepare:	Release the clock from its prepared state. This will typically
> + * 		undo any work done in the @prepare callback. Called with
> + * 		prepare_lock held.
> + *
> + * @enable:	Enable the clock atomically. This must not return until the
> + * 		clock is generating a valid clock signal, usable by consumer
> + * 		devices. Called with enable_lock held. This function must not
> + * 		sleep.
> + *
> + * @disable:	Disable the clock atomically. Called with enable_lock held.
> + * 		This function must not sleep.
> + *
> + * @recalc_rate	Recalculate the rate of this clock, by quering hardware
> + * 		and/or the clock's parent. It is up to the caller to insure
> + * 		that the prepare_mutex is held across this call.  Returns the
> + * 		calculated rate.  Optional, but recommended - if this op is not
> + * 		set then clock rate will be initialized to 0.
> + *
> + * @round_rate	XXX FIXME
> + *
> + * @get_parent	Return the parent of this clock; for clocks with multiple
> + * 		possible parents, query the hardware for the current parent.
> + * 		Clocks with fixed parents should still implement this and
> + * 		return something like struct clk *fixed_parent from their
> + * 		respective struct clk_hw_* data.  Currently called only when
> + * 		the clock is initialized.  Clocks that do not implement this
> + * 		will have their parent set to NULL.
> + *
> + * @set_parent	Change the input source of this clock; for clocks with multiple
> + * 		possible parents specify a new parent by passing in a struct
> + * 		clk *parent.  Returns 0 on success, -EERROR otherwise.
> + *
> + * @set_rate	Change the rate of this clock. If this callback returns
> + * 		CLK_PARENT_SET_RATE, the rate change will be propagated to the
> + * 		parent clock (which may propagate again if the parent clock
> + * 		also sets this flag). The requested rate of the parent is
> + * 		passed back from the callback in the second 'unsigned long *'
> + * 		argument.  Note that it is up to the hardware clock's set_rate
> + * 		implementation to insure that clocks do not run out of spec
> + * 		when propgating the call to set_rate up to the parent.  One way
> + * 		to do this is to gate the clock (via clk_disable and/or
> + * 		clk_unprepare) before calling clk_set_rate, then ungating it
> + * 		afterward.  If your clock also has the CLK_GATE_SET_RATE flag
> + * 		set then this will insure safety.  Returns 0 on success,
> + * 		-EERROR otherwise.
> + *
> + * The clk_enable/clk_disable and clk_prepare/clk_unprepare pairs allow
> + * implementations to split any work between atomic (enable) and sleepable
> + * (prepare) contexts.  If enabling a clock requires code that might sleep,
> + * this must be done in clk_prepare.  Clock enable code that will never be
> + * called in a sleepable context may be implement in clk_enable.
> + *
> + * Typically, drivers will call clk_prepare when a clock may be needed later
> + * (eg. when a device is opened), and clk_enable when the clock is actually
> + * required (eg. from an interrupt). Note that clk_prepare MUST have been
> + * called before clk_enable.
>   */
> -struct clk;
> +struct clk_hw_ops {
> +	int		(*prepare)(struct clk *clk);
> +	void		(*unprepare)(struct clk *clk);
> +	int		(*enable)(struct clk *clk);
> +	void		(*disable)(struct clk *clk);
> +	unsigned long	(*recalc_rate)(struct clk *clk);
> +	long		(*round_rate)(struct clk *clk, unsigned long,
> +					unsigned long *);
> +	int		(*set_parent)(struct clk *clk, struct clk *);
> +	struct clk *	(*get_parent)(struct clk *clk);
> +	int		(*set_rate)(struct clk *clk, unsigned long);
> +};
> +
> +/**
> + * clk_init - initialize the data structures in a struct clk
> + * @dev: device initializing this clk, placeholder for now
> + * @clk: clk being initialized
> + *
> + * Initializes the lists in struct clk, queries the hardware for the
> + * parent and rate and sets them both.  Adds the clk to the sysfs tree
> + * topology.
> + *
> + * Caller must populate .name, .flags and .ops before calling clk_init.
> + */
> +void clk_init(struct device *dev, struct clk *clk);
> +
> +int __clk_prepare(struct clk *clk);
> +void __clk_unprepare(struct clk *clk);
> +void __clk_reparent(struct clk *clk, struct clk *new_parent);
> +
> +#endif /* !CONFIG_GENERIC_CLK */
>  
>  /**
>   * clk_get - lookup and obtain a reference to a clock producer.
> @@ -110,6 +231,7 @@ static inline void clk_unprepare(struct clk *clk)
>  /**
>   * clk_get_rate - obtain the current clock rate (in Hz) for a clock source.
>   *		  This is only valid once the clock source has been enabled.
> + *		  Returns zero if the clock rate is unknown.
>   * @clk: clock source
>   */
>  unsigned long clk_get_rate(struct clk *clk);


