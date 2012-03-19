Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030509Ab2CSLWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 07:22:24 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:59838 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075Ab2CSLWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 07:22:20 -0400
Message-ID: <4F6716DD.5090900@ti.com>
Date: Mon, 19 Mar 2012 16:52:05 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>, patches@linaro.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Richard Zhao <richard.zhao@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Deepak Saxena <dsaxena@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Shawn Guo <shawn.guo@freescale.com>, linaro-dev@lists.linaro.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [PATCH v7 2/3] clk: introduce the common clock framework
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org> <1331878280-2758-3-git-send-email-mturquette@linaro.org>
In-Reply-To: <1331878280-2758-3-git-send-email-mturquette@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Friday 16 March 2012 11:41 AM, Mike Turquette wrote:
> The common clock framework defines a common struct clk useful across
> most platforms as well as an implementation of the clk api that drivers
> can use safely for managing clocks.
>
> The net result is consolidation of many different struct clk definitions
> and platform-specific clock framework implementations.
>
> This patch introduces the common struct clk, struct clk_ops and an
> implementation of the well-known clock api in include/clk/clk.h.
> Platforms may define their own hardware-specific clock structure and
> their own clock operation callbacks, so long as it wraps an instance of
> struct clk_hw.
>
> See Documentation/clk.txt for more details.
>

> +/*
> + * calculate the new rates returning the topmost clock that has to be
> + * changed.
> + */
> +static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
> +{
> +	struct clk *top = clk;
> +	unsigned long best_parent_rate = clk->parent->rate;

Shouldn't you check for a valid parent before dereferencing it? A
clk_set_rate() on a root clock might throw up some issues otherwise.

> +	unsigned long new_rate;
> +
> +	if (!clk->ops->round_rate&&  !(clk->flags&  CLK_SET_RATE_PARENT)) {
> +		clk->new_rate = clk->rate;
> +		return NULL;

So does this mean a clk_set_rate() fails for a clk which does not have
a valid .round_rate and does not have a CLK_SET_RATE_PARENT flag set?
I was thinking this could do a..
		clk->new_rate = rate;
		top = clk;
		goto out;
..instead.

regards,
Rajendra

> +	}
> +
> +	if (!clk->ops->round_rate&&  (clk->flags&  CLK_SET_RATE_PARENT)) {
> +		top = clk_calc_new_rates(clk->parent, rate);
> +		new_rate = clk->new_rate = clk->parent->new_rate;
> +
> +		goto out;
> +	}
> +
> +	if (clk->flags&  CLK_SET_RATE_PARENT)
> +		new_rate = clk->ops->round_rate(clk->hw, rate,&best_parent_rate);
> +	else
> +		new_rate = clk->ops->round_rate(clk->hw, rate, NULL);
> +
> +	if (best_parent_rate != clk->parent->rate) {
> +		top = clk_calc_new_rates(clk->parent, best_parent_rate);
> +
> +		goto out;
> +	}
> +
> +out:
> +	clk_calc_subtree(clk, new_rate);
> +
> +	return top;
> +}
> +
> +/*
> + * Notify about rate changes in a subtree. Always walk down the whole tree
> + * so that in case of an error we can walk down the whole tree again and
> + * abort the change.
> + */
> +static struct clk *clk_propagate_rate_change(struct clk *clk, unsigned long event)
> +{
> +	struct hlist_node *tmp;
> +	struct clk *child, *fail_clk = NULL;
> +	int ret = NOTIFY_DONE;
> +
> +	if (clk->rate == clk->new_rate)
> +		return 0;
> +
> +	if (clk->notifier_count) {
> +		ret = __clk_notify(clk, event, clk->rate, clk->new_rate);
> +		if (ret == NOTIFY_BAD)
> +			fail_clk = clk;
> +	}
> +
> +	hlist_for_each_entry(child, tmp,&clk->children, child_node) {
> +		clk = clk_propagate_rate_change(child, event);
> +		if (clk)
> +			fail_clk = clk;
> +	}
> +
> +	return fail_clk;
> +}
> +
> +/*
> + * walk down a subtree and set the new rates notifying the rate
> + * change on the way
> + */
> +static void clk_change_rate(struct clk *clk)
> +{
> +	struct clk *child;
> +	unsigned long old_rate;
> +	struct hlist_node *tmp;
> +
> +	old_rate = clk->rate;
> +
> +	if (clk->ops->set_rate)
> +		clk->ops->set_rate(clk->hw, clk->new_rate);
> +
> +	if (clk->ops->recalc_rate)
> +		clk->rate = clk->ops->recalc_rate(clk->hw,
> +				clk->parent->rate);
> +	else
> +		clk->rate = clk->parent->rate;
> +
> +	if (clk->notifier_count&&  old_rate != clk->rate)
> +		__clk_notify(clk, POST_RATE_CHANGE, old_rate, clk->rate);
> +
> +	hlist_for_each_entry(child, tmp,&clk->children, child_node)
> +		clk_change_rate(child);
> +}
> +
> +/**
> + * clk_set_rate - specify a new rate for clk
> + * @clk: the clk whose rate is being changed
> + * @rate: the new rate for clk
> + *
> + * In the simplest case clk_set_rate will only change the rate of clk.
> + *
> + * If clk has the CLK_SET_RATE_GATE flag set and it is enabled this call
> + * will fail; only when the clk is disabled will it be able to change
> + * its rate.
> + *
> + * Setting the CLK_SET_RATE_PARENT flag allows clk_set_rate to
> + * recursively propagate up to clk's parent; whether or not this happens
> + * depends on the outcome of clk's .round_rate implementation.  If
> + * *parent_rate is 0 after calling .round_rate then upstream parent
> + * propagation is ignored.  If *parent_rate comes back with a new rate
> + * for clk's parent then we propagate up to clk's parent and set it's
> + * rate.  Upward propagation will continue until either a clk does not
> + * support the CLK_SET_RATE_PARENT flag or .round_rate stops requesting
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
> +	struct clk *top, *fail_clk;
> +	int ret = 0;
> +
> +	/* prevent racing with updates to the clock topology */
> +	mutex_lock(&prepare_lock);
> +
> +	/* bail early if nothing to do */
> +	if (rate == clk->rate)
> +		goto out;
> +
> +	/* calculate new rates and get the topmost changed clock */
> +	top = clk_calc_new_rates(clk, rate);
> +	if (!top) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	/* notify that we are about to change rates */
> +	fail_clk = clk_propagate_rate_change(top, PRE_RATE_CHANGE);
> +	if (fail_clk) {
> +		pr_warn("%s: failed to set %s rate\n", __func__,
> +				fail_clk->name);
> +		clk_propagate_rate_change(top, ABORT_RATE_CHANGE);
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	/* change the rates */
> +	clk_change_rate(top);
> +
> +	mutex_unlock(&prepare_lock);
> +
> +	return 0;
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
> + * Simply returns clk->parent.  Returns NULL if clk is NULL.
> + */
> +struct clk *clk_get_parent(struct clk *clk)
> +{
> +	struct clk *parent;
> +
> +	mutex_lock(&prepare_lock);
> +	parent = __clk_get_parent(clk);
> +	mutex_unlock(&prepare_lock);
> +
> +	return parent;
> +}
> +EXPORT_SYMBOL_GPL(clk_get_parent);
> +
> +/*
> + * .get_parent is mandatory for clocks with multiple possible parents.  It is
> + * optional for single-parent clocks.  Always call .get_parent if it is
> + * available and WARN if it is missing for multi-parent clocks.
> + *
> + * For single-parent clocks without .get_parent, first check to see if the
> + * .parents array exists, and if so use it to avoid an expensive tree
> + * traversal.  If .parents does not exist then walk the tree with __clk_lookup.
> + */
> +static struct clk *__clk_init_parent(struct clk *clk)
> +{
> +	struct clk *ret = NULL;
> +	u8 index;
> +
> +	/* handle the trivial cases */
> +
> +	if (!clk->num_parents)
> +		goto out;
> +
> +	if (clk->num_parents == 1) {
> +		if (IS_ERR_OR_NULL(clk->parent))
> +			ret = clk->parent = __clk_lookup(clk->parent_names[0]);
> +		ret = clk->parent;
> +		goto out;
> +	}
> +
> +	if (!clk->ops->get_parent) {
> +		WARN(!clk->ops->get_parent,
> +			"%s: multi-parent clocks must implement .get_parent\n",
> +			__func__);
> +		goto out;
> +	};
> +
> +	/*
> +	 * Do our best to cache parent clocks in clk->parents.  This prevents
> +	 * unnecessary and expensive calls to __clk_lookup.  We don't set
> +	 * clk->parent here; that is done by the calling function
> +	 */
> +
> +	index = clk->ops->get_parent(clk->hw);
> +
> +	if (!clk->parents)
> +		clk->parents =
> +			kmalloc((sizeof(struct clk*) * clk->num_parents),
> +					GFP_KERNEL);
> +
> +	if (!clk->parents)
> +		ret = __clk_lookup(clk->parent_names[index]);
> +	else if (!clk->parents[index])
> +		ret = clk->parents[index] =
> +			__clk_lookup(clk->parent_names[index]);
> +	else
> +		ret = clk->parents[index];
> +
> +out:
> +	return ret;
> +}
> +
> +void __clk_reparent(struct clk *clk, struct clk *new_parent)
> +{
> +#ifdef CONFIG_COMMON_CLK_DEBUG
> +	struct dentry *d;
> +	struct dentry *new_parent_d;
> +#endif
> +
> +	if (!clk || !new_parent)
> +		return;
> +
> +	hlist_del(&clk->child_node);
> +
> +	if (new_parent)
> +		hlist_add_head(&clk->child_node,&new_parent->children);
> +	else
> +		hlist_add_head(&clk->child_node,&clk_orphan_list);
> +
> +#ifdef CONFIG_COMMON_CLK_DEBUG
> +	if (!inited)
> +		goto out;
> +
> +	if (new_parent)
> +		new_parent_d = new_parent->dentry;
> +	else
> +		new_parent_d = orphandir;
> +
> +	d = debugfs_rename(clk->dentry->d_parent, clk->dentry,
> +			new_parent_d, clk->name);
> +	if (d)
> +		clk->dentry = d;
> +	else
> +		pr_debug("%s: failed to rename debugfs entry for %s\n",
> +				__func__, clk->name);
> +out:
> +#endif
> +
> +	clk->parent = new_parent;
> +
> +	__clk_recalc_rates(clk, POST_RATE_CHANGE);
> +}
> +
> +static int __clk_set_parent(struct clk *clk, struct clk *parent)
> +{
> +	struct clk *old_parent;
> +	unsigned long flags;
> +	int ret = -EINVAL;
> +	u8 i;
> +
> +	old_parent = clk->parent;
> +
> +	/* find index of new parent clock using cached parent ptrs */
> +	for (i = 0; i<  clk->num_parents; i++)
> +		if (clk->parents[i] == parent)
> +			break;
> +
> +	/*
> +	 * find index of new parent clock using string name comparison
> +	 * also try to cache the parent to avoid future calls to __clk_lookup
> +	 */
> +	if (i == clk->num_parents)
> +		for (i = 0; i<  clk->num_parents; i++)
> +			if (!strcmp(clk->parent_names[i], parent->name)) {
> +				clk->parents[i] = __clk_lookup(parent->name);
> +				break;
> +			}
> +
> +	if (i == clk->num_parents) {
> +		pr_debug("%s: clock %s is not a possible parent of clock %s\n",
> +				__func__, parent->name, clk->name);
> +		goto out;
> +	}
> +
> +	/* migrate prepare and enable */
> +	if (clk->prepare_count)
> +		__clk_prepare(parent);
> +
> +	/* FIXME replace with clk_is_enabled(clk) someday */
> +	spin_lock_irqsave(&enable_lock, flags);
> +	if (clk->enable_count)
> +		__clk_enable(parent);
> +	spin_unlock_irqrestore(&enable_lock, flags);
> +
> +	/* change clock input source */
> +	ret = clk->ops->set_parent(clk->hw, i);
> +
> +	/* clean up old prepare and enable */
> +	spin_lock_irqsave(&enable_lock, flags);
> +	if (clk->enable_count)
> +		__clk_disable(old_parent);
> +	spin_unlock_irqrestore(&enable_lock, flags);
> +
> +	if (clk->prepare_count)
> +		__clk_unprepare(old_parent);
> +
> +out:
> +	return ret;
> +}
> +
> +/**
> + * clk_set_parent - switch the parent of a mux clk
> + * @clk: the mux clk whose input we are switching
> + * @parent: the new input to clk
> + *
> + * Re-parent clk to use parent as it's new input source.  If clk has the
> + * CLK_SET_PARENT_GATE flag set then clk must be gated for this
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
> +	/* propagate PRE_RATE_CHANGE notifications */
> +	if (clk->notifier_count)
> +		ret = __clk_speculate_rates(clk, parent->rate);
> +
> +	/* abort if a driver objects */
> +	if (ret == NOTIFY_STOP)
> +		goto out;
> +
> +	/* only re-parent if the clock is not in use */
> +	if ((clk->flags&  CLK_SET_PARENT_GATE)&&  clk->prepare_count)
> +		ret = -EBUSY;
> +	else
> +		ret = __clk_set_parent(clk, parent);
> +
> +	/* propagate ABORT_RATE_CHANGE if .set_parent failed */
> +	if (ret) {
> +		__clk_recalc_rates(clk, ABORT_RATE_CHANGE);
> +		goto out;
> +	}
> +
> +	/* propagate rate recalculation downstream */
> +	__clk_reparent(clk, parent);
> +
> +out:
> +	mutex_unlock(&prepare_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(clk_set_parent);
> +
> +/**
> + * __clk_init - initialize the data structures in a struct clk
> + * @dev:	device initializing this clk, placeholder for now
> + * @clk:	clk being initialized
> + *
> + * Initializes the lists in struct clk, queries the hardware for the
> + * parent and rate and sets them both.
> + *
> + * Any struct clk passed into __clk_init must have the following members
> + * populated:
> + * 	.name
> + * 	.ops
> + * 	.hw
> + * 	.parent_names
> + * 	.num_parents
> + * 	.flags
> + *
> + * Essentially, everything that would normally be passed into clk_register is
> + * assumed to be initialized already in __clk_init.  The other members may be
> + * populated, but are optional.
> + *
> + * __clk_init is only exposed via clk-private.h and is intended for use with
> + * very large numbers of clocks that need to be statically initialized.  It is
> + * a layering violation to include clk-private.h from any code which implements
> + * a clock's .ops; as such any statically initialized clock data MUST be in a
> + * separate C file from the logic that implements it's operations.
> + */
> +void __clk_init(struct device *dev, struct clk *clk)
> +{
> +	int i;
> +	struct clk *orphan;
> +	struct hlist_node *tmp, *tmp2;
> +
> +	if (!clk)
> +		return;
> +
> +	mutex_lock(&prepare_lock);
> +
> +	/* check to see if a clock with this name is already registered */
> +	if (__clk_lookup(clk->name))
> +		goto out;
> +
> +	/* throw a WARN if any entries in parent_names are NULL */
> +	for (i = 0; i<  clk->num_parents; i++)
> +		WARN(!clk->parent_names[i],
> +				"%s: invalid NULL in %s's .parent_names\n",
> +				__func__, clk->name);
> +
> +	/*
> +	 * Allocate an array of struct clk *'s to avoid unnecessary string
> +	 * look-ups of clk's possible parents.  This can fail for clocks passed
> +	 * in to clk_init during early boot; thus any access to clk->parents[]
> +	 * must always check for a NULL pointer and try to populate it if
> +	 * necessary.
> +	 *
> +	 * If clk->parents is not NULL we skip this entire block.  This allows
> +	 * for clock drivers to statically initialize clk->parents.
> +	 */
> +	if (clk->num_parents&&  !clk->parents) {
> +		clk->parents = kmalloc((sizeof(struct clk*) * clk->num_parents),
> +				GFP_KERNEL);
> +		/*
> +		 * __clk_lookup returns NULL for parents that have not been
> +		 * clk_init'd; thus any access to clk->parents[] must check
> +		 * for a NULL pointer.  We can always perform lazy lookups for
> +		 * missing parents later on.
> +		 */
> +		if (clk->parents)
> +			for (i = 0; i<  clk->num_parents; i++)
> +				clk->parents[i] =
> +					__clk_lookup(clk->parent_names[i]);
> +	}
> +
> +	clk->parent = __clk_init_parent(clk);
> +
> +	/*
> +	 * Populate clk->parent if parent has already been __clk_init'd.  If
> +	 * parent has not yet been __clk_init'd then place clk in the orphan
> +	 * list.  If clk has set the CLK_IS_ROOT flag then place it in the root
> +	 * clk list.
> +	 *
> +	 * Every time a new clk is clk_init'd then we walk the list of orphan
> +	 * clocks and re-parent any that are children of the clock currently
> +	 * being clk_init'd.
> +	 */
> +	if (clk->parent)
> +		hlist_add_head(&clk->child_node,
> +				&clk->parent->children);
> +	else if (clk->flags&  CLK_IS_ROOT)
> +		hlist_add_head(&clk->child_node,&clk_root_list);
> +	else
> +		hlist_add_head(&clk->child_node,&clk_orphan_list);
> +
> +	/*
> +	 * Set clk's rate.  The preferred method is to use .recalc_rate.  For
> +	 * simple clocks and lazy developers the default fallback is to use the
> +	 * parent's rate.  If a clock doesn't have a parent (or is orphaned)
> +	 * then rate is set to zero.
> +	 */
> +	if (clk->ops->recalc_rate)
> +		clk->rate = clk->ops->recalc_rate(clk->hw,
> +				__clk_get_rate(clk->parent));
> +	else if (clk->parent)
> +		clk->rate = clk->parent->rate;
> +	else
> +		clk->rate = 0;
> +
> +	/*
> +	 * walk the list of orphan clocks and reparent any that are children of
> +	 * this clock
> +	 */
> +	hlist_for_each_entry_safe(orphan, tmp, tmp2,&clk_orphan_list, child_node)
> +		for (i = 0; i<  orphan->num_parents; i++)
> +			if (!strcmp(clk->name, orphan->parent_names[i])) {
> +				__clk_reparent(orphan, clk);
> +				break;
> +			}
> +
> +	/*
> +	 * optional platform-specific magic
> +	 *
> +	 * The .init callback is not used by any of the basic clock types, but
> +	 * exists for weird hardware that must perform initialization magic.
> +	 * Please consider other ways of solving initialization problems before
> +	 * using this callback, as it's use is discouraged.
> +	 */
> +	if (clk->ops->init)
> +		clk->ops->init(clk->hw);
> +
> +	clk_debug_register(clk);
> +
> +out:
> +	mutex_unlock(&prepare_lock);
> +
> +	return;
> +}
> +
> +/**
> + * clk_register - allocate a new clock, register it and return an opaque cookie
> + * @dev: device that is registering this clock
> + * @name: clock name
> + * @ops: operations this clock supports
> + * @hw: link to hardware-specific clock data
> + * @parent_names: array of string names for all possible parents
> + * @num_parents: number of possible parents
> + * @flags: framework-level hints and quirks
> + *
> + * clk_register is the primary interface for populating the clock tree with new
> + * clock nodes.  It returns a pointer to the newly allocated struct clk which
> + * cannot be dereferenced by driver code but may be used in conjuction with the
> + * rest of the clock API.
> + */
> +struct clk *clk_register(struct device *dev, const char *name,
> +		const struct clk_ops *ops, struct clk_hw *hw,
> +		char **parent_names, u8 num_parents, unsigned long flags)
> +{
> +	struct clk *clk;
> +
> +	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
> +	if (!clk)
> +		return NULL;
> +
> +	clk->name = name;
> +	clk->ops = ops;
> +	clk->hw = hw;
> +	clk->flags = flags;
> +	clk->parent_names = parent_names;
> +	clk->num_parents = num_parents;
> +	hw->clk = clk;
> +
> +	__clk_init(dev, clk);
> +
> +	return clk;
> +}
> +EXPORT_SYMBOL_GPL(clk_register);
> +
> +/***        clk rate change notifiers        ***/
> +
> +/**
> + * clk_notifier_register - add a clk rate change notifier
> + * @clk: struct clk * to watch
> + * @nb: struct notifier_block * with callback info
> + *
> + * Request notification when clk's rate changes.  This uses an SRCU
> + * notifier because we want it to block and notifier unregistrations are
> + * uncommon.  The callbacks associated with the notifier must not
> + * re-enter into the clk framework by calling any top-level clk APIs;
> + * this will cause a nested prepare_lock mutex.
> + *
> + * Pre-change notifier callbacks will be passed the current, pre-change
> + * rate of the clk via struct clk_notifier_data.old_rate.  The new,
> + * post-change rate of the clk is passed via struct
> + * clk_notifier_data.new_rate.
> + *
> + * Post-change notifiers will pass the now-current, post-change rate of
> + * the clk in both struct clk_notifier_data.old_rate and struct
> + * clk_notifier_data.new_rate.
> + *
> + * Abort-change notifiers are effectively the opposite of pre-change
> + * notifiers: the original pre-change clk rate is passed in via struct
> + * clk_notifier_data.new_rate and the failed post-change rate is passed
> + * in via struct clk_notifier_data.old_rate.
> + *
> + * clk_notifier_register() must be called from non-atomic context.
> + * Returns -EINVAL if called with null arguments, -ENOMEM upon
> + * allocation failure; otherwise, passes along the return value of
> + * srcu_notifier_chain_register().
> + */
> +int clk_notifier_register(struct clk *clk, struct notifier_block *nb)
> +{
> +	struct clk_notifier *cn;
> +	int ret = -ENOMEM;
> +
> +	if (!clk || !nb)
> +		return -EINVAL;
> +
> +	mutex_lock(&prepare_lock);
> +
> +	/* search the list of notifiers for this clk */
> +	list_for_each_entry(cn,&clk_notifier_list, node)
> +		if (cn->clk == clk)
> +			break;
> +
> +	/* if clk wasn't in the notifier list, allocate new clk_notifier */
> +	if (cn->clk != clk) {
> +		cn = kzalloc(sizeof(struct clk_notifier), GFP_KERNEL);
> +		if (!cn)
> +			goto out;
> +
> +		cn->clk = clk;
> +		srcu_init_notifier_head(&cn->notifier_head);
> +
> +		list_add(&cn->node,&clk_notifier_list);
> +	}
> +
> +	ret = srcu_notifier_chain_register(&cn->notifier_head, nb);
> +
> +	clk->notifier_count++;
> +
> +out:
> +	mutex_unlock(&prepare_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(clk_notifier_register);
> +
> +/**
> + * clk_notifier_unregister - remove a clk rate change notifier
> + * @clk: struct clk *
> + * @nb: struct notifier_block * with callback info
> + *
> + * Request no further notification for changes to 'clk' and frees memory
> + * allocated in clk_notifier_register.
> + *
> + * Returns -EINVAL if called with null arguments; otherwise, passes
> + * along the return value of srcu_notifier_chain_unregister().
> + */
> +int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb)
> +{
> +	struct clk_notifier *cn = NULL;
> +	int ret = -EINVAL;
> +
> +	if (!clk || !nb)
> +		return -EINVAL;
> +
> +	mutex_lock(&prepare_lock);
> +
> +	list_for_each_entry(cn,&clk_notifier_list, node)
> +		if (cn->clk == clk)
> +			break;
> +
> +	if (cn->clk == clk) {
> +		ret = srcu_notifier_chain_unregister(&cn->notifier_head, nb);
> +
> +		clk->notifier_count--;
> +
> +		/* XXX the notifier code should handle this better */
> +		if (!cn->notifier_head.head) {
> +			srcu_cleanup_notifier_head(&cn->notifier_head);
> +			kfree(cn);
> +		}
> +
> +	} else {
> +		ret = -ENOENT;
> +	}
> +
> +	mutex_unlock(&prepare_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(clk_notifier_unregister);
> diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
> new file mode 100644
> index 0000000..e2cce6f
> --- /dev/null
> +++ b/include/linux/clk-private.h
> @@ -0,0 +1,72 @@
> +/*
> + *  linux/include/linux/clk-private.h
> + *
> + *  Copyright (c) 2010-2011 Jeremy Kerr<jeremy.kerr@canonical.com>
> + *  Copyright (C) 2011-2012 Linaro Ltd<mturquette@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef __LINUX_CLK_PRIVATE_H
> +#define __LINUX_CLK_PRIVATE_H
> +
> +#include<linux/clk-provider.h>
> +#include<linux/list.h>
> +
> +/*
> + * WARNING: Do not include clk-private.h from any file that implements struct
> + * clk_ops.  Doing so is a layering violation!
> + *
> + * This header exists only to allow for statically initialized clock data.  Any
> + * static clock data must be defined in a separate file from the logic that
> + * implements the clock operations for that same data.
> + */
> +
> +#ifdef CONFIG_COMMON_CLK
> +
> +struct clk {
> +	const char		*name;
> +	const struct clk_ops	*ops;
> +	struct clk_hw		*hw;
> +	struct clk		*parent;
> +	char			**parent_names;
> +	struct clk		**parents;
> +	u8			num_parents;
> +	unsigned long		rate;
> +	unsigned long		new_rate;
> +	unsigned long		flags;
> +	unsigned int		enable_count;
> +	unsigned int		prepare_count;
> +	struct hlist_head	children;
> +	struct hlist_node	child_node;
> +	unsigned int		notifier_count;
> +#ifdef CONFIG_COMMON_CLK_DEBUG
> +	struct dentry		*dentry;
> +#endif
> +};
> +
> +/**
> + * __clk_init - initialize the data structures in a struct clk
> + * @dev:	device initializing this clk, placeholder for now
> + * @clk:	clk being initialized
> + *
> + * Initializes the lists in struct clk, queries the hardware for the
> + * parent and rate and sets them both.
> + *
> + * Any struct clk passed into __clk_init must have the following members
> + * populated:
> + * 	.name
> + * 	.ops
> + * 	.hw
> + * 	.parent_names
> + * 	.num_parents
> + * 	.flags
> + *
> + * It is not necessary to call clk_register if __clk_init is used directly with
> + * statically initialized clock data.
> + */
> +void __clk_init(struct device *dev, struct clk *clk);
> +
> +#endif /* CONFIG_COMMON_CLK */
> +#endif /* CLK_PRIVATE_H */
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> new file mode 100644
> index 0000000..b18b0e7
> --- /dev/null
> +++ b/include/linux/clk-provider.h
> @@ -0,0 +1,173 @@
> +/*
> + *  linux/include/linux/clk-provider.h
> + *
> + *  Copyright (c) 2010-2011 Jeremy Kerr<jeremy.kerr@canonical.com>
> + *  Copyright (C) 2011-2012 Linaro Ltd<mturquette@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef __LINUX_CLK_PROVIDER_H
> +#define __LINUX_CLK_PROVIDER_H
> +
> +#include<linux/clk.h>
> +
> +#ifdef CONFIG_COMMON_CLK
> +
> +/**
> + * struct clk_hw - handle for traversing from a struct clk to its corresponding
> + * hardware-specific structure.  struct clk_hw should be declared within struct
> + * clk_foo and then referenced by the struct clk instance that uses struct
> + * clk_foo's clk_ops
> + *
> + * clk: pointer to the struct clk instance that points back to this struct
> + * clk_hw instance
> + */
> +struct clk_hw {
> +	struct clk *clk;
> +};
> +
> +/*
> + * flags used across common struct clk.  these flags should only affect the
> + * top-level framework.  custom flags for dealing with hardware specifics
> + * belong in struct clk_foo
> + */
> +#define CLK_SET_RATE_GATE	BIT(0) /* must be gated across rate change */
> +#define CLK_SET_PARENT_GATE	BIT(1) /* must be gated across re-parent */
> +#define CLK_SET_RATE_PARENT	BIT(2) /* propagate rate change up one level */
> +#define CLK_IGNORE_UNUSED	BIT(3) /* do not gate even if unused */
> +#define CLK_IS_ROOT		BIT(4) /* root clk, has no parent */
> +
> +/**
> + * struct clk_ops -  Callback operations for hardware clocks; these are to
> + * be provided by the clock implementation, and will be called by drivers
> + * through the clk_* api.
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
> + * @recalc_rate	Recalculate the rate of this clock, by quering hardware.  The
> + * 		parent rate is an input parameter.  It is up to the caller to
> + * 		insure that the prepare_mutex is held across this call.
> + * 		Returns the calculated rate.  Optional, but recommended - if
> + * 		this op is not set then clock rate will be initialized to 0.
> + *
> + * @round_rate:	Given a target rate as input, returns the closest rate actually
> + * 		supported by the clock.
> + *
> + * @get_parent:	Queries the hardware to determine the parent of a clock.  The
> + * 		return value is a u8 which specifies the index corresponding to
> + * 		the parent clock.  This index can be applied to either the
> + * 		.parent_names or .parents arrays.  In short, this function
> + * 		translates the parent value read from hardware into an array
> + * 		index.  Currently only called when the clock is initialized by
> + * 		__clk_init.  This callback is mandatory for clocks with
> + * 		multiple parents.  It is optional (and unnecessary) for clocks
> + * 		with 0 or 1 parents.
> + *
> + * @set_parent:	Change the input source of this clock; for clocks with multiple
> + * 		possible parents specify a new parent by passing in the index
> + * 		as a u8 corresponding to the parent in either the .parent_names
> + * 		or .parents arrays.  This function in affect translates an
> + * 		array index into the value programmed into the hardware.
> + * 		Returns 0 on success, -EERROR otherwise.
> + *
> + * @set_rate:	Change the rate of this clock. If this callback returns
> + * 		CLK_SET_RATE_PARENT, the rate change will be propagated to the
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
> + */
> +struct clk_ops {
> +	int		(*prepare)(struct clk_hw *hw);
> +	void		(*unprepare)(struct clk_hw *hw);
> +	int		(*enable)(struct clk_hw *hw);
> +	void		(*disable)(struct clk_hw *hw);
> +	int		(*is_enabled)(struct clk_hw *hw);
> +	unsigned long	(*recalc_rate)(struct clk_hw *hw,
> +					unsigned long parent_rate);
> +	long		(*round_rate)(struct clk_hw *hw, unsigned long,
> +					unsigned long *);
> +	int		(*set_parent)(struct clk_hw *hw, u8 index);
> +	u8		(*get_parent)(struct clk_hw *hw);
> +	int		(*set_rate)(struct clk_hw *hw, unsigned long);
> +	void		(*init)(struct clk_hw *hw);
> +};
> +
> +
> +/**
> + * clk_register - allocate a new clock, register it and return an opaque cookie
> + * @dev: device that is registering this clock
> + * @name: clock name
> + * @ops: operations this clock supports
> + * @hw: link to hardware-specific clock data
> + * @parent_names: array of string names for all possible parents
> + * @num_parents: number of possible parents
> + * @flags: framework-level hints and quirks
> + *
> + * clk_register is the primary interface for populating the clock tree with new
> + * clock nodes.  It returns a pointer to the newly allocated struct clk which
> + * cannot be dereferenced by driver code but may be used in conjuction with the
> + * rest of the clock API.
> + */
> +struct clk *clk_register(struct device *dev, const char *name,
> +		const struct clk_ops *ops, struct clk_hw *hw,
> +		char **parent_names, u8 num_parents, unsigned long flags);
> +
> +/* helper functions */
> +const char *__clk_get_name(struct clk *clk);
> +struct clk_hw *__clk_get_hw(struct clk *clk);
> +u8 __clk_get_num_parents(struct clk *clk);
> +struct clk *__clk_get_parent(struct clk *clk);
> +inline int __clk_get_enable_count(struct clk *clk);
> +inline int __clk_get_prepare_count(struct clk *clk);
> +unsigned long __clk_get_rate(struct clk *clk);
> +unsigned long __clk_get_flags(struct clk *clk);
> +int __clk_is_enabled(struct clk *clk);
> +struct clk *__clk_lookup(const char *name);
> +
> +/*
> + * FIXME clock api without lock protection
> + */
> +int __clk_prepare(struct clk *clk);
> +void __clk_unprepare(struct clk *clk);
> +void __clk_reparent(struct clk *clk, struct clk *new_parent);
> +unsigned long __clk_round_rate(struct clk *clk, unsigned long rate);
> +
> +#endif /* CONFIG_COMMON_CLK */
> +#endif /* CLK_PROVIDER_H */
> diff --git a/include/linux/clk.h b/include/linux/clk.h
> index b9d46fa..b025272 100644
> --- a/include/linux/clk.h
> +++ b/include/linux/clk.h
> @@ -3,6 +3,7 @@
>    *
>    *  Copyright (C) 2004 ARM Limited.
>    *  Written by Deep Blue Solutions Limited.
> + *  Copyright (C) 2011-2012 Linaro Ltd<mturquette@linaro.org>
>    *
>    * This program is free software; you can redistribute it and/or modify
>    * it under the terms of the GNU General Public License version 2 as
> @@ -12,18 +13,75 @@
>   #define __LINUX_CLK_H
>
>   #include<linux/kernel.h>
> +#include<linux/notifier.h>
>
>   struct device;
>
> -/*
> - * The base API.
> +struct clk;
> +
> +#ifdef CONFIG_COMMON_CLK
> +
> +/**
> + * DOC: clk notifier callback types
> + *
> + * PRE_RATE_CHANGE - called immediately before the clk rate is changed,
> + *     to indicate that the rate change will proceed.  Drivers must
> + *     immediately terminate any operations that will be affected by the
> + *     rate change.  Callbacks may either return NOTIFY_DONE or
> + *     NOTIFY_STOP.
> + *
> + * ABORT_RATE_CHANGE: called if the rate change failed for some reason
> + *     after PRE_RATE_CHANGE.  In this case, all registered notifiers on
> + *     the clk will be called with ABORT_RATE_CHANGE. Callbacks must
> + *     always return NOTIFY_DONE.
> + *
> + * POST_RATE_CHANGE - called after the clk rate change has successfully
> + *     completed.  Callbacks must always return NOTIFY_DONE.
> + *
>    */
> +#define PRE_RATE_CHANGE			BIT(0)
> +#define POST_RATE_CHANGE		BIT(1)
> +#define ABORT_RATE_CHANGE		BIT(2)
>
> +/**
> + * struct clk_notifier - associate a clk with a notifier
> + * @clk: struct clk * to associate the notifier with
> + * @notifier_head: a blocking_notifier_head for this clk
> + * @node: linked list pointers
> + *
> + * A list of struct clk_notifier is maintained by the notifier code.
> + * An entry is created whenever code registers the first notifier on a
> + * particular @clk.  Future notifiers on that @clk are added to the
> + * @notifier_head.
> + */
> +struct clk_notifier {
> +	struct clk			*clk;
> +	struct srcu_notifier_head	notifier_head;
> +	struct list_head		node;
> +};
>
> -/*
> - * struct clk - an machine class defined object / cookie.
> +/**
> + * struct clk_notifier_data - rate data to pass to the notifier callback
> + * @clk: struct clk * being changed
> + * @old_rate: previous rate of this clk
> + * @new_rate: new rate of this clk
> + *
> + * For a pre-notifier, old_rate is the clk's rate before this rate
> + * change, and new_rate is what the rate will be in the future.  For a
> + * post-notifier, old_rate and new_rate are both set to the clk's
> + * current rate (this was done to optimize the implementation).
>    */
> -struct clk;
> +struct clk_notifier_data {
> +	struct clk		*clk;
> +	unsigned long		old_rate;
> +	unsigned long		new_rate;
> +};
> +
> +int clk_notifier_register(struct clk *clk, struct notifier_block *nb);
> +
> +int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb);
> +
> +#endif /* !CONFIG_COMMON_CLK */
>
>   /**
>    * clk_get - lookup and obtain a reference to a clock producer.

