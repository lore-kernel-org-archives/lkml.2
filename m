Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab2CMLZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 07:25:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47881 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab2CMLZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 07:25:08 -0400
Date: Tue, 13 Mar 2012 12:24:47 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Mike Turquette <mturquette@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        linaro-dev@lists.linaro.org, Grant Likely <grant.likely@secretlab.ca>,
        Saravana Kannan <skannan@codeaurora.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Mike Turquette <mturquette@ti.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergman <arnd.bergmann@linaro.org>, patches@linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [PATCH v5 3/4] clk: introduce the common clock framework
Message-ID: <20120313112447.GA29317@pengutronix.de>
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
 <1330763341-3437-4-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330763341-3437-4-git-send-email-mturquette@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:18:15 up 121 days, 19:05, 70 users,  load average: 41.93, 19.51,
 7.83
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2012 at 12:29:00AM -0800, Mike Turquette wrote:
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
> This patch is based on the work of Jeremy Kerr, which in turn was based
> on the work of Ben Herrenschmidt.
> 
> Signed-off-by: Mike Turquette <mturquette@linaro.org>
> Signed-off-by: Mike Turquette <mturquette@ti.com>
> Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Arnd Bergman <arnd.bergmann@linaro.org>
> Cc: Paul Walmsley <paul@pwsan.com>
> Cc: Shawn Guo <shawn.guo@freescale.com>
> Cc: Richard Zhao <richard.zhao@linaro.org>
> Cc: Saravana Kannan <skannan@codeaurora.org>
> Cc: Magnus Damm <magnus.damm@gmail.com>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Linus Walleij <linus.walleij@stericsson.com>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Amit Kucheria <amit.kucheria@linaro.org>
> Cc: Deepak Saxena <dsaxena@linaro.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/clk/Kconfig          |   28 +
>  drivers/clk/Makefile         |    1 +
>  drivers/clk/clk.c            | 1323 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/clk-private.h  |   68 +++
>  include/linux/clk-provider.h |  169 ++++++
>  include/linux/clk.h          |   68 ++-
>  6 files changed, 1652 insertions(+), 5 deletions(-)
>  create mode 100644 drivers/clk/clk.c
>  create mode 100644 include/linux/clk-private.h
>  create mode 100644 include/linux/clk-provider.h
> 
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index 3912576..18eb8c2 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -11,3 +11,31 @@ config HAVE_MACH_CLKDEV
>  
>  config HAVE_CLK_PREPARE
>  	bool
> +
> +menuconfig COMMON_CLK
> +	bool "Common Clock Framework"
> +	select HAVE_CLK_PREPARE
> +	---help---
> +	  The common clock framework is a single definition of struct
> +	  clk, useful across many platforms, as well as an
> +	  implementation of the clock API in include/linux/clk.h.
> +	  Architectures utilizing the common struct clk should select
> +	  this automatically, but it may be necessary to manually select
> +	  this option for loadable modules requiring the common clock
> +	  framework.
> +
> +	  If in doubt, say "N".
> +
> +if COMMON_CLK
> +
> +config COMMON_CLK_DEBUG
> +	bool "DebugFS representation of clock tree"
> +	depends on COMMON_CLK
> +	---help---
> +	  Creates a directory hierchy in debugfs for visualizing the clk
> +	  tree structure.  Each directory contains read-only members
> +	  that export information specific to that clk node: clk_rate,
> +	  clk_flags, clk_prepare_count, clk_enable_count &
> +	  clk_notifier_count.
> +
> +endif
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index 07613fa..ff362c4 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -1,2 +1,3 @@
>  
>  obj-$(CONFIG_CLKDEV_LOOKUP)	+= clkdev.o
> +obj-$(CONFIG_COMMON_CLK)	+= clk.o
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> new file mode 100644
> index 0000000..b979d74
> --- /dev/null
> +++ b/drivers/clk/clk.c
> @@ -0,0 +1,1323 @@
> +/*
> + * Copyright (C) 2010-2011 Canonical Ltd <jeremy.kerr@canonical.com>
> + * Copyright (C) 2011-2012 Linaro Ltd <mturquette@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Standard functionality for the common clock API.  See Documentation/clk.txt
> + */
> +
> +#include <linux/clk-private.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/spinlock.h>
> +#include <linux/err.h>
> +#include <linux/list.h>
> +#include <linux/slab.h>
> +
> +static DEFINE_SPINLOCK(enable_lock);
> +static DEFINE_MUTEX(prepare_lock);
> +
> +static HLIST_HEAD(clk_root_list);
> +static HLIST_HEAD(clk_orphan_list);
> +static LIST_HEAD(clk_notifier_list);
> +
> +/***        debugfs support        ***/
> +
> +#ifdef CONFIG_COMMON_CLK_DEBUG
> +#include <linux/debugfs.h>
> +
> +static struct dentry *rootdir;
> +static struct dentry *orphandir;
> +static int inited = 0;
> +
> +/* caller must hold prepare_lock */
> +static int clk_debug_create_one(struct clk *clk, struct dentry *pdentry)
> +{
> +	struct dentry *d;
> +	int ret = -ENOMEM;
> +
> +	if (!clk || !pdentry) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	d = debugfs_create_dir(clk->name, pdentry);
> +	if (!d)
> +		goto out;
> +
> +	clk->dentry = d;
> +
> +	d = debugfs_create_u32("clk_rate", S_IRUGO, clk->dentry,
> +			(u32 *)&clk->rate);
> +	if (!d)
> +		goto err_out;
> +
> +	d = debugfs_create_x32("clk_flags", S_IRUGO, clk->dentry,
> +			(u32 *)&clk->flags);
> +	if (!d)
> +		goto err_out;
> +
> +	d = debugfs_create_u32("clk_prepare_count", S_IRUGO, clk->dentry,
> +			(u32 *)&clk->prepare_count);
> +	if (!d)
> +		goto err_out;
> +
> +	d = debugfs_create_u32("clk_enable_count", S_IRUGO, clk->dentry,
> +			(u32 *)&clk->enable_count);
> +	if (!d)
> +		goto err_out;
> +
> +	d = debugfs_create_u32("clk_notifier_count", S_IRUGO, clk->dentry,
> +			(u32 *)&clk->notifier_count);
> +	if (!d)
> +		goto err_out;
> +
> +	ret = 0;
> +	goto out;
> +
> +err_out:
> +	debugfs_remove(clk->dentry);
> +out:
> +	return ret;
> +}
> +
> +/* caller must hold prepare_lock */
> +static int clk_debug_create_subtree(struct clk *clk, struct dentry *pdentry)
> +{
> +	struct clk *child;
> +	struct hlist_node *tmp;
> +	int ret = -EINVAL;;
> +
> +	if (!clk || !pdentry)
> +		goto out;
> +
> +	ret = clk_debug_create_one(clk, pdentry);
> +
> +	if (ret)
> +		goto out;
> +
> +	hlist_for_each_entry(child, tmp, &clk->children, child_node)
> +		clk_debug_create_subtree(child, clk->dentry);
> +
> +	ret = 0;
> +out:
> +	return ret;
> +}
> +
> +/**
> + * clk_debug_register - add a clk node to the debugfs clk tree
> + * @clk: the clk being added to the debugfs clk tree
> + *
> + * Dynamically adds a clk to the debugfs clk tree if debugfs has been
> + * initialized.  Otherwise it bails out early since the debugfs clk tree
> + * will be created lazily by clk_debug_init as part of a late_initcall.
> + *
> + * Caller must hold prepare_lock.  Only clk_init calls this function (so
> + * far) so this is taken care.
> + */
> +static int clk_debug_register(struct clk *clk)
> +{
> +	struct clk *parent;
> +	struct dentry *pdentry;
> +	int ret = 0;
> +
> +	if (!inited)
> +		goto out;
> +
> +	parent = clk->parent;
> +
> +	/*
> +	 * Check to see if a clk is a root clk.  Also check that it is
> +	 * safe to add this clk to debugfs
> +	 */
> +	if (!parent)
> +		if (clk->flags & CLK_IS_ROOT)
> +			pdentry = rootdir;
> +		else
> +			pdentry = orphandir;
> +	else
> +		if (parent->dentry)
> +			pdentry = parent->dentry;
> +		else
> +			goto out;
> +
> +	ret = clk_debug_create_subtree(clk, pdentry);
> +
> +out:
> +	return ret;
> +}
> +
> +/**
> + * clk_debug_init - lazily create the debugfs clk tree visualization
> + *
> + * clks are often initialized very early during boot before memory can
> + * be dynamically allocated and well before debugfs is setup.
> + * clk_debug_init walks the clk tree hierarchy while holding
> + * prepare_lock and creates the topology as part of a late_initcall,
> + * thus insuring that clks initialized very early will still be
> + * represented in the debugfs clk tree.  This function should only be
> + * called once at boot-time, and all other clks added dynamically will
> + * be done so with clk_debug_register.
> + */
> +static int __init clk_debug_init(void)
> +{
> +	struct clk *clk;
> +	struct hlist_node *tmp;
> +
> +	rootdir = debugfs_create_dir("clk", NULL);
> +
> +	if (!rootdir)
> +		return -ENOMEM;
> +
> +	orphandir = debugfs_create_dir("orphans", rootdir);
> +
> +	if (!orphandir)
> +		return -ENOMEM;
> +
> +	mutex_lock(&prepare_lock);
> +
> +	hlist_for_each_entry(clk, tmp, &clk_root_list, child_node)
> +		clk_debug_create_subtree(clk, rootdir);
> +
> +	hlist_for_each_entry(clk, tmp, &clk_orphan_list, child_node)
> +		clk_debug_create_subtree(clk, orphandir);
> +
> +	inited = 1;
> +
> +	mutex_unlock(&prepare_lock);
> +
> +	return 0;
> +}
> +late_initcall(clk_debug_init);
> +#else
> +static inline int clk_debug_register(struct clk *clk) { return 0; }
> +#endif /* CONFIG_COMMON_CLK_DEBUG */
> +
> +/***    helper functions   ***/
> +
> +inline const char *__clk_get_name(struct clk *clk)
> +{
> +	return !clk ? NULL : clk->name;
> +}
> +
> +inline struct clk_hw *__clk_get_hw(struct clk *clk)
> +{
> +	return !clk ? NULL : clk->hw;
> +}
> +
> +inline u8 __clk_get_num_parents(struct clk *clk)
> +{
> +	return !clk ? -EINVAL : clk->num_parents;
> +}
> +
> +inline struct clk *__clk_get_parent(struct clk *clk)
> +{
> +	return !clk ? NULL : clk->parent;
> +}
> +
> +inline unsigned long __clk_get_rate(struct clk *clk)
> +{
> +	return !clk ? -EINVAL : clk->rate;
> +}
> +
> +inline unsigned long __clk_get_flags(struct clk *clk)
> +{
> +	return !clk ? -EINVAL : clk->flags;
> +}
> +
> +static struct clk *__clk_lookup_subtree(const char *name, struct clk *clk)
> +{
> +	struct clk *child;
> +	struct clk *ret;
> +	struct hlist_node *tmp;
> +
> +	if (!strcmp(clk->name, name))
> +		return clk;
> +
> +	hlist_for_each_entry(child, tmp, &clk->children, child_node) {
> +		ret = __clk_lookup_subtree(name, child);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return NULL;
> +}
> +
> +struct clk *__clk_lookup(const char *name)
> +{
> +	struct clk *root_clk;
> +	struct clk *ret;
> +	struct hlist_node *tmp;
> +

This should have a check for NULL pointers. NULL pointers can happen
here if a mux has holes in it. In this case the parent name array would
look like this:

{ "parentclk1", "parentclk2", NULL /* reserved */, "parentclk3" }

Without checking for NULL pointers we dereference the NULL pointer here.

> +
> +/**
> + * __clk_round_rate - round the given rate for a clk
> + * @clk: round the rate of this clock
> + *
> + * Caller must hold prepare_lock.  Useful for clk_ops such as .set_rate
> + */
> +unsigned long __clk_round_rate(struct clk *clk, unsigned long rate)
> +{
> +	if (!clk && !clk->ops->round_rate)
> +		return -EINVAL;

This should return the parents rate if the clock itself does not
have a round_rate function. Also, must be || instead of &&

> +
> +	return clk->ops->round_rate(clk->hw, rate, NULL);
> +}
> +
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
