Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab1GKJfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 05:35:00 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39892 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab1GKJe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 05:34:59 -0400
Date: Mon, 11 Jul 2011 10:34:39 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>, Grant Likely <grant@secretlab.ca>,
        linux-sh@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 5/6] clk: Support multiple instances of the same clock
	provider
Message-ID: <20110711093439.GB3239@n2100.arm.linux.org.uk>
References: <20110711025344.GA27497@opensource.wolfsonmicro.com> <1310352837-4277-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1310352837-4277-5-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310352837-4277-5-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 11:53:56AM +0900, Mark Brown wrote:
> Currently the generic clk API identifies clocks internally using the name
> of the clock. This is OK for on-SoC clocks where we have enough control to
> disambiguate but doesn't work well for clocks provided on external chips
> where a system design may include more than one instance of the same chip
> (the Wolfson Speyside system is an example of this) or may have namespace
> collisions.
> 
> Address this by allowing the clock provider to supply a struct device for
> the clock for use in disambiguation. As a first pass if it is provided we
> prefix the clock name with the dev_name() of the device. With a device
> tree binding for clocks it should be possible to remove this mangling and
> instead use the struct device to provide access to the binding information.
> 
> In order to avoid needless noise in names and memory usage it is strongly
> recommended that on-SoC clocks do not provide a struct device until the
> implementation is improved.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/clk/clk.c   |   36 ++++++++++++++++++++++++++++++++----
>  include/linux/clk.h |   14 ++++++++++----
>  2 files changed, 42 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 1df6e23..f36f637 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -13,6 +13,7 @@
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
> +#include <linux/device.h>
>  
>  struct clk {
>  	const char		*name;
> @@ -252,20 +253,44 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
>  }
>  EXPORT_SYMBOL_GPL(clk_set_parent);
>  
> -struct clk *clk_register(const struct clk_hw_ops *ops, struct clk_hw *hw,
> -		const char *name)
> +struct clk *clk_register(struct device *dev, const struct clk_hw_ops *ops,
> +			 struct clk_hw *hw, const char *name)
>  {
>  	struct clk *clk;
> +	char *new_name;
> +	size_t name_len;
>  
>  	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
>  	if (!clk)
>  		return NULL;
>  
> -	clk->name = name;
>  	clk->ops = ops;
>  	clk->hw = hw;
>  	hw->clk = clk;
>  
> +	/* Since we currently match clock providers on a purely string
> +	 * based method add a prefix based on the device name if a
> +	 * device is provided.  When we have support for device tree
> +	 * based clock matching it should be possible to avoid this
> +	 * mangling and instead use the struct device to hook into
> +	 * the bindings.
> +	 *
> +	 * As we don't currently support unregistering clocks we don't
> +	 * need to worry about cleanup as yet.
> +	 */
> +	if (dev) {
> +		name_len = strlen(name) + strlen(dev_name(dev)) + 2;
> +		new_name = kzalloc(name_len, GFP_KERNEL);
> +		if (!new_name)
> +			goto err;
> +
> +		snprintf(new_name, name_len, "%s-%s", dev_name(dev), name);
> +
> +		clk->name = new_name;
> +	} else {
> +		clk->name = name;
> +	}

This "clk consolidation" is really idiotic.  The clk matching mechanism
should have _nothing_ to do with the rest of the clk API, especially the
consolidation effort.

It should not matter whether clkdev is used, or an alternative method
to specify this stuff via DT.  Keep the clk_get()/clk_put() _separate_
from the consolidation of the rest.
