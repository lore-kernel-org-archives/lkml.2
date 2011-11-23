Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab1KWDML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 22:12:11 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22975 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab1KWDMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 22:12:09 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6538"; a="137839970"
Message-ID: <4ECC6487.1060300@codeaurora.org>
Date: Tue, 22 Nov 2011 19:12:07 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@ti.com>
CC: linux@arm.linux.org.uk, linaro-dev@lists.linaro.org, eric.miao@linaro.org,
        grant.likely@secretlab.ca, aul@pwsan.com, jeremy.kerr@canonical.com,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, magnus.damm@gmail.com,
        dsaxena@linaro.org, linux-arm-kernel@lists.infradead.org,
        arnd.bergmann@linaro.org, patches@linaro.org, tglx@linutronix.de,
        linux-omap@vger.kernel.org, richard.zhao@linaro.org,
        shawn.guo@freescale.com, linus.walleij@stericsson.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        amit.kucheria@linaro.org, Saravana Kannan <skannan@codeaurora.org>
Subject: Re: [PATCH v3 3/5] clk: introduce the common clock framework
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org> <1321926047-14211-4-git-send-email-mturquette@linaro.org>
In-Reply-To: <1321926047-14211-4-git-send-email-mturquette@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2011 05:40 PM, Mike Turquette wrote:
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> new file mode 100644
> index 0000000..12c9994
> --- /dev/null
> +++ b/drivers/clk/clk.c
> @@ -0,0 +1,538 @@
> +/*
> + * Copyright (C) 2010-2011 Canonical Ltd<jeremy.kerr@canonical.com>
> + * Copyright (C) 2011 Linaro Ltd<mturquette@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Standard functionality for the common clock API.  See Documentation/clk.txt
> + */
> +
> +#include<linux/clk.h>
> +#include<linux/module.h>
> +#include<linux/mutex.h>
> +#include<linux/slab.h>
> +#include<linux/spinlock.h>
> +#include<linux/err.h>
> +
> +static DEFINE_SPINLOCK(enable_lock);
> +static DEFINE_MUTEX(prepare_lock);
> +
> +void __clk_unprepare(struct clk *clk)
> +{
> +	if (!clk)
> +		return;
> +
> +	if (WARN_ON(clk->prepare_count == 0))
> +		return;
> +
> +	if (--clk->prepare_count>  0)

Space before ">"?

> +		return;
> +
> +	WARN_ON(clk->enable_count>  0);

The spacing comment applies to all such instances the follow too.

> +
> +	if (clk->ops->unprepare)
> +		clk->ops->unprepare(clk);
> +
> +	__clk_unprepare(clk->parent);
> +}
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
> +	if (--clk->enable_count>  0)
> +		return;
> +
> +	if (clk->ops->disable)
> +		clk->ops->disable(clk);
> +
> +	if (clk->parent)
> +		__clk_disable(clk->parent);
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
EPERM? EBADFD?

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
> + * clk_enable - perform the slow part of a clk ungate
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
> +	if (!clk)
> +		return 0;
> +
> +	return clk->rate;

I think you need to grab the prepare_mutex here too. Otherwise another 
call to clk_set_rate() could be changing clk->rate while it's being read 
here. It shouldn't be a problem in ARM where I think 32bit reads are 
atomic. But I'm not sure you can say the same for all archs.

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
> +	if (clk&&  clk->ops->round_rate)
> +		return clk->ops->round_rate(clk, rate, NULL);
> +
> +	return rate;
> +}
> +EXPORT_SYMBOL_GPL(clk_round_rate);
> +
> +/**
> + * clk_recalc_rates
> + * @clk: first clk in the subtree
> + *
> + * Walks the subtree of clks starting with clk and recalculates rates as it
> + * goes.  Note that if a clk does not implement the recalc_rate operation then
> + * propagation of that subtree stops and all of that clks children will not
> + * have their rates updated.  Caller must hold prepare_lock.

May be call this functions __clk_recalc_rates() to match the naming 
convention of the other fns that don't grab locks?

> + */
> +static void clk_recalc_rates(struct clk *clk)
> +{
> +	unsigned long old_rate;
> +	struct hlist_node *tmp;
> +	struct clk *child;
> +
> +	old_rate = clk->rate;
> +
> +	if (clk->ops->recalc_rate)
> +		clk->rate = clk->ops->recalc_rate(clk);

Any reason you can't just do "else return" instead of the check below? 
That would be more straight-forward and also remove the need for old_rate.

> +
> +	if (old_rate == clk->rate)
> +		return;
> +
> +	/* FIXME add post-rate change notification here */
> +
> +	hlist_for_each_entry(child, tmp,&clk->children, child_node)
> +		clk_recalc_rates(child);
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
> +struct clk *__clk_set_rate(struct clk *clk, unsigned long rate)
> +{
> +	struct clk *fail_clk = NULL;
> +	int ret;
> +	unsigned long old_rate = clk->rate;
> +	unsigned long new_rate;
> +	unsigned long parent_old_rate;
> +	unsigned long parent_new_rate = 0;
> +	struct clk *child;
> +	struct hlist_node *tmp;
> +
> +	/* bail early if we can't change rate while clk is enabled */
> +	if ((clk->flags&  CLK_GATE_SET_RATE)&&  clk->enable_count)
> +		return clk;

Spacing fix near & and &&.

> +
> +	/* find the new rate and see if parent rate should change too */
> +	WARN_ON(!clk->ops->round_rate);

It looks like you don't consider absence of round_rate as an error 
(going by clk_round_rate()), so why warn on this? See below for 
additional comments.

> +	new_rate = clk->ops->round_rate(clk, rate,&parent_new_rate);

Should we split the "figuring out the parent rate" and "round rate"?
If any clock driver doesn't care for propagation (too simple clock tree 
or very versatile clock tree), and doesn't want to implement 
ops->round_rate, this code is still forcing them to implement 
ops->round_rate(). But then clk_round_rate() thinks it's okay if that 
ops->round_rate() is not implemented. This is a bit inconsistent.

May be we should just add ops->propagate_parent() that is optional and 
takes in the result of ops->round_rate()? If a clock needs propagation, 
it will implement and return the new parent rate.

> +
> +	/* FIXME propagate pre-rate change notification here */
> +	/* XXX note that pre-rate change notifications will stack */
> +
> +	/* change the rate of this clk */
> +	ret = clk->ops->set_rate(clk, new_rate);
> +	if (ret)
> +		return clk;
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
> +	if ((clk->flags&  CLK_PARENT_SET_RATE)&&  parent_new_rate) {
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
> +	 * set clk's rate&  recalculate the rates of clk's children
> +	 *
> +	 * hitting this path implies we have successfully finished
> +	 * propagating recursive calls to __clk_set_rate up the clk tree
> +	 * (if necessary) and it is safe to propagate clk_recalc_rates and
> +	 * post-rate change notifiers down the clk tree from this point.
> +	 */
> +	clk->rate = new_rate;
> +	/* FIXME propagate post-rate change notifier for only this clk */
> +	hlist_for_each_entry(child, tmp,&clk->children, child_node)
> +		clk_recalc_rates(child);
> +
> +	return fail_clk;
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
> + * clk_recalc_rates and propagates the rate changes downstream, starting
> + * from the highest clk whose rate was changed.  This has the added
> + * benefit of propagating post-rate change notifiers.
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
> +	if (!clk->ops->set_rate)
> +		return -ENOSYS;
> +
> +	/* bail early if nothing to do */
> +	if (rate == clk->rate)
> +		return rate;

This check needs to be after the lock is taken.

> +
> +	/* prevent racing with updates to the clock topology */
> +	mutex_lock(&prepare_lock);
> +	fail_clk = __clk_set_rate(clk, rate);
> +	if (fail_clk) {
> +		pr_warn("%s: failed to set %s rate to %lu\n",
> +				__func__, fail_clk->name, rate);

Going by the current implementation, the "fail_clk" is not necessarily 
the same as "clk". But the "rate" you are printing is always the rate 
for "clk".

if (fail_clk == clk)
  print blah
else
  print blah bloo

?

> +		/* FIXME propagate rate change abort notification here */
> +		ret = -EIO;
> +	}
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
> +	if (!clk)
> +		return NULL;
> +
> +	return clk->parent;

Same comment as get_rate(). I think this needs locking too to avoid 
maligned reads.

> +}
> +EXPORT_SYMBOL_GPL(clk_get_parent);
> +
> +void __clk_reparent(struct clk *clk, struct clk *new_parent)
> +{
> +	hlist_del(&clk->child_node);
> +	hlist_add_head(&clk->child_node,&new_parent->children);

Check new_parent != NULL before trying to add the clock to its children 
list?

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
> + * propagate rate recalculation via clk_recalc_rates.  Returns 0 on
> + * success, -EERROR otherwise.
> + */
> +int clk_set_parent(struct clk *clk, struct clk *parent)
> +{
> +	int ret = 0;
> +
> +	if (!clk || !clk->ops)

I would like NULL clocks to be treated as real/proper clocks. So, can we 
split this into two "if"s please? And return 0 for (!clk)?

> +		return -EINVAL;
> +
> +	if (!clk->ops->set_parent)
> +		return -ENOSYS;
> +
> +	if (clk->parent == parent)
> +		return 0;

This check should be done after taking the lock.

> +
> +	/* prevent racing with updates to the clock topology */
> +	mutex_lock(&prepare_lock);
> +
> +	/* FIXME add pre-rate change notification here */
> +
> +	/* only re-parent if the clock is not in use */
> +	if ((clk->flags&  CLK_GATE_SET_PARENT)&&  clk->prepare_count)
> +		ret = -EBUSY;
> +	else
> +		ret = clk->ops->set_parent(clk, parent);
> +
> +	if (ret<  0)
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
> +	clk_recalc_rates(clk);
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
> +	if (clk->ops->get_parent) {
> +		clk->parent = clk->ops->get_parent(clk);
> +		if (clk->parent)
> +			hlist_add_head(&clk->child_node,
> +					&clk->parent->children);
> +	} else
> +		clk->parent = NULL;
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

Didn't review closely past this.

Thanks,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
