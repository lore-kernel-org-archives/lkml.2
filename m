Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab2DPUa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:30:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47352 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab2DPUa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:30:26 -0400
Date: Mon, 16 Apr 2012 22:30:16 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Mike Turquette <mturquette@linaro.org>
Cc: arnd.bergmann@linaro.org, Andrew Lunn <andrew@lunn.ch>,
        Rajendra Nayak <rnayak@ti.com>, patches@linaro.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Saravana Kannan <skannan@codeaurora.org>,
        Shawn Guo <shawn.guo@freescale.com>, Olof Johansson <olof@lixom.net>,
        linaro-dev@lists.linaro.org, Richard Zhao <richard.zhao@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 12/13] clk: core: copy parent_names & return error codes
Message-ID: <20120416203016.GH20478@pengutronix.de>
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
 <1334192572-12499-13-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334192572-12499-13-git-send-email-mturquette@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 22:27:12 up 156 days,  4:14, 20 users,  load average: 0.14, 0.36,
 0.55
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 06:02:50PM -0700, Mike Turquette wrote:
> This patch cleans up clk_register and solves a few bugs by teaching
> clk_register and __clk_init to return error codes (instead of just NULL)
> to better align with the existing clk.h api.
> 
> Along with that change this patch also introduces a new behavior whereby
> clk_register copies the parent_names array, thus allowing platforms to
> declare their parent_names arrays as __initdata.
> 
> Signed-off-by: Mike Turquette <mturquette@linaro.org>
> Cc: Arnd Bergman <arnd.bergmann@linaro.org>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Shawn Guo <shawn.guo@freescale.com>
> Cc: Richard Zhao <richard.zhao@linaro.org>
> Cc: Saravana Kannan <skannan@codeaurora.org>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Rajendra Nayak <rnayak@ti.com>
> Cc: Viresh Kumar <viresh.kumar@st.com>
> ---
>  drivers/clk/clk.c            |   61 +++++++++++++++++++++++++++++++++--------
>  include/linux/clk-private.h  |    4 ++-
>  include/linux/clk-provider.h |    3 +-
>  3 files changed, 54 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index ddade87..af2bf12 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1185,34 +1185,41 @@ EXPORT_SYMBOL_GPL(clk_set_parent);
>   * very large numbers of clocks that need to be statically initialized.  It is
>   * a layering violation to include clk-private.h from any code which implements
>   * a clock's .ops; as such any statically initialized clock data MUST be in a
> - * separate C file from the logic that implements it's operations.
> + * separate C file from the logic that implements it's operations.  Returns 0
> + * on success, otherwise an error code.
>   */
> -void __clk_init(struct device *dev, struct clk *clk)
> +int __clk_init(struct device *dev, struct clk *clk)
>  {
> -	int i;
> +	int i, ret = 0;
>  	struct clk *orphan;
>  	struct hlist_node *tmp, *tmp2;
>  
>  	if (!clk)
> -		return;
> +		return -EINVAL;
>  
>  	mutex_lock(&prepare_lock);
>  
>  	/* check to see if a clock with this name is already registered */
> -	if (__clk_lookup(clk->name))
> +	if (__clk_lookup(clk->name)) {
> +		pr_debug("%s: clk %s already initialized\n",
> +				__func__, clk->name);
> +		ret = -EEXIST;
>  		goto out;
> +	}
>  
>  	/* check that clk_ops are sane.  See Documentation/clk.txt */
>  	if (clk->ops->set_rate &&
>  			!(clk->ops->round_rate && clk->ops->recalc_rate)) {
>  		pr_warning("%s: %s must implement .round_rate & .recalc_rate\n",
>  				__func__, clk->name);
> +		ret = -EINVAL;
>  		goto out;
>  	}
>  
>  	if (clk->ops->set_parent && !clk->ops->get_parent) {
>  		pr_warning("%s: %s must implement .get_parent & .set_parent\n",
>  				__func__, clk->name);
> +		ret = -EINVAL;
>  		goto out;
>  	}
>  
> @@ -1308,7 +1315,7 @@ void __clk_init(struct device *dev, struct clk *clk)
>  out:
>  	mutex_unlock(&prepare_lock);
>  
> -	return;
> +	return ret;
>  }
>  
>  /**
> @@ -1324,29 +1331,59 @@ out:
>   * clk_register is the primary interface for populating the clock tree with new
>   * clock nodes.  It returns a pointer to the newly allocated struct clk which
>   * cannot be dereferenced by driver code but may be used in conjuction with the
> - * rest of the clock API.
> + * rest of the clock API.  In the event of an error clk_register will return an
> + * error code; drivers must test for an error code after calling clk_register.
>   */
>  struct clk *clk_register(struct device *dev, const char *name,
>  		const struct clk_ops *ops, struct clk_hw *hw,
>  		const char **parent_names, u8 num_parents, unsigned long flags)
>  {
> +	int i, ret = -ENOMEM;

I suggest to move the initialization of ret from here...

>  	struct clk *clk;
>  
>  	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
> -	if (!clk)
> -		return NULL;
> +	if (!clk) {
> +		pr_err("%s: could not allocate clk\n", __func__);
> +		goto fail_out;
> +	}
>  
>  	clk->name = name;
>  	clk->ops = ops;
>  	clk->hw = hw;
>  	clk->flags = flags;
> -	clk->parent_names = parent_names;
>  	clk->num_parents = num_parents;
>  	hw->clk = clk;
>  
> -	__clk_init(dev, clk);
> +	/* allocate local copy in case parent_names is __initdata */
> +	clk->parent_names = kzalloc((sizeof(char*) * num_parents),
> +			GFP_KERNEL);
> +
> +	if (!clk->parent_names) {
> +		pr_err("%s: could not allocate clk->parent_names\n", __func__);
> +		goto fail_parent_names;
> +	}
> +
> +	/* copy each string name in case parent_names is __initdata */

... to here.

The rationale is that when this code is changed later someone might use
ret above and doesn't remember that the code below expects ret to be
initialized with -ENOMEM. Also it's easier to see that the code is
correct.

Sascha

> +	for (i = 0; i < num_parents; i++) {
> +		clk->parent_names[i] = kstrdup(parent_names[i], GFP_KERNEL);
> +		if (!clk->parent_names[i]) {
> +			pr_err("%s: could not copy parent_names\n", __func__);
> +			goto fail_parent_names_copy;
> +		}
> +	}
> +
> +	ret = __clk_init(dev, clk);
> +	if (!ret)
> +		return clk;
>  
> -	return clk;
> +fail_parent_names_copy:
> +	while (--i >= 0)
> +		kfree(clk->parent_names[i]);
> +	kfree(clk->parent_names);
> +fail_parent_names:
> +	kfree(clk);
> +fail_out:
> +	return ERR_PTR(ret);
>  }
>  EXPORT_SYMBOL_GPL(clk_register);
>  
> diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
> index e9c8b98..e7032fd 100644
> --- a/include/linux/clk-private.h
> +++ b/include/linux/clk-private.h
> @@ -181,8 +181,10 @@ struct clk {
>   *
>   * It is not necessary to call clk_register if __clk_init is used directly with
>   * statically initialized clock data.
> + *
> + * Returns 0 on success, otherwise an error code.
>   */
> -void __clk_init(struct device *dev, struct clk *clk);
> +int __clk_init(struct device *dev, struct clk *clk);
>  
>  #endif /* CONFIG_COMMON_CLK */
>  #endif /* CLK_PRIVATE_H */
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index 8981435..97f9fab 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -274,7 +274,8 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
>   * clk_register is the primary interface for populating the clock tree with new
>   * clock nodes.  It returns a pointer to the newly allocated struct clk which
>   * cannot be dereferenced by driver code but may be used in conjuction with the
> - * rest of the clock API.
> + * rest of the clock API.  In the event of an error clk_register will return an
> + * error code; drivers must test for an error code after calling clk_register.
>   */
>  struct clk *clk_register(struct device *dev, const char *name,
>  		const struct clk_ops *ops, struct clk_hw *hw,
> -- 
> 1.7.5.4
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
