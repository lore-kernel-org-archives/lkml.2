Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab1LACN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 21:13:56 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:46450 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab1LACNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 21:13:55 -0500
Date: Wed, 30 Nov 2011 19:13:53 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Mike Turquette <mturquette@ti.com>
cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jeremy.kerr@canonical.com, broonie@opensource.wolfsonmicro.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, aul@pwsan.com, grant.likely@secretlab.ca,
        sboyd@quicinc.com, shawn.guo@freescale.com, skannan@quicinc.com,
        magnus.damm@gmail.com, arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org, Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH v3 3/5] clk: introduce the common clock framework
In-Reply-To: <1321926047-14211-4-git-send-email-mturquette@linaro.org>
Message-ID: <alpine.DEB.2.00.1111301831430.6289@utopia.booyaka.com>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org> <1321926047-14211-4-git-send-email-mturquette@linaro.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

a few initial comments on clk_get_parent().

On Mon, 21 Nov 2011, Mike Turquette wrote:

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
> +}
> +EXPORT_SYMBOL_GPL(clk_get_parent);

This implementation of clk_get_parent() has similar problems to the 
clk_get_rate() implementation:

    http://lkml.org/lkml/2011/11/30/403

clk_get_parent() should return an error if some other entity can change 
the clock's parent between the time that clk_get_parent() returns, and the 
time that the returned struct clk * is used.

For this to work, we need to define when clk_get_parent() should succeed. 
If we follow the protocol outlined in the above URL about clk_get_rate(), 
and we stipulate that when we block rate changes, we also block parent 
changes, then this should be fairly straightforward.  clk_get_parent() can 
succeed:

1. between a clk_enable() and a clk_disable() or clk_allow_rate_changes(),

2. between a clk_block_rate_changes() and a clk_enable(), clk_disable(), 
   or clk_allow_rate_changes()

As with clk_get_rate(), include/linux/clk.h is missing documentation of 
what the error return value should be.  This should be a little easier to 
define than with clk_get_rate(), but I don't think the error value should 
be NULL.  This is because NULL is a valid return value when 
clk_get_parent() is called on root clocks.  Better to use 
ERR_PTR(-EINVAL/-EBUSY/etc.).


- Paul
