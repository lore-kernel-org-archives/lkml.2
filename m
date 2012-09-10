Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab2IJDID (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 23:08:03 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:63527 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab2IJDH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 23:07:59 -0400
Message-ID: <504D5A1D.2090808@snapgear.com>
Date: Mon, 10 Sep 2012 13:10:21 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Mike Turquette <mturquette@ti.com>, Russell King <linux@arm.linux.org.uk>,
        Greg Ungerer <gerg@uclinux.org>, Mark Brown <broonie@sirena.org.uk>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Artem Bityutskiy <dedekind1@gmail.com>, <linux-m68k@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clk: Make the managed clk functions generically available
References: <1347202862-1617-1-git-send-email-lars@metafoo.de>
In-Reply-To: <1347202862-1617-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars-Peter,

On 10/09/12 01:01, Lars-Peter Clausen wrote:
> The managed clk functions are currently only available when the generic clk
> lookup framework is build. But the managed clk functions are merely wrappers
> around clk_get and clk_put and do not depend on any specifics of the generic
> lookup functions and there are still quite a few custom implementations of the
> clk API. So make the managed functions available whenever the clk API is
> implemented.
>
> The patch also removes the custom implementation of devm_clk_get for the
> coldfire platform.
>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Nice work, thanks.

Acked-by: Greg Ungerer <gerg@uclinux.org>

Regards
Greg



> ---
>   arch/m68k/platform/coldfire/clk.c |    6 ----
>   drivers/clk/Makefile              |    1 +
>   drivers/clk/clk-devres.c          |   55 +++++++++++++++++++++++++++++++++++++
>   drivers/clk/clkdev.c              |   45 ------------------------------
>   4 files changed, 56 insertions(+), 51 deletions(-)
>   create mode 100644 drivers/clk/clk-devres.c
>
> diff --git a/arch/m68k/platform/coldfire/clk.c b/arch/m68k/platform/coldfire/clk.c
> index 75f9ee9..9cd13b4 100644
> --- a/arch/m68k/platform/coldfire/clk.c
> +++ b/arch/m68k/platform/coldfire/clk.c
> @@ -146,9 +146,3 @@ struct clk_ops clk_ops1 = {
>   };
>   #endif /* MCFPM_PPMCR1 */
>   #endif /* MCFPM_PPMCR0 */
> -
> -struct clk *devm_clk_get(struct device *dev, const char *id)
> -{
> -	return NULL;
> -}
> -EXPORT_SYMBOL(devm_clk_get);
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index 6327536..b7b8620 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -1,4 +1,5 @@
>   # common clock types
> +obj-$(CONFIG_HAVE_CLK)		+= clk-devres.o
>   obj-$(CONFIG_CLKDEV_LOOKUP)	+= clkdev.o
>   obj-$(CONFIG_COMMON_CLK)	+= clk.o clk-fixed-rate.o clk-gate.o \
>   				   clk-mux.o clk-divider.o clk-fixed-factor.o
> diff --git a/drivers/clk/clk-devres.c b/drivers/clk/clk-devres.c
> new file mode 100644
> index 0000000..f1e7a83
> --- /dev/null
> +++ b/drivers/clk/clk-devres.c
> @@ -0,0 +1,55 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/device.h>
> +#include <linux/export.h>
> +#include <linux/gfp.h>
> +
> +static void devm_clk_release(struct device *dev, void *res)
> +{
> +	clk_put(*(struct clk **)res);
> +}
> +
> +struct clk *devm_clk_get(struct device *dev, const char *id)
> +{
> +	struct clk **ptr, *clk;
> +
> +	ptr = devres_alloc(devm_clk_release, sizeof(*ptr), GFP_KERNEL);
> +	if (!ptr)
> +		return ERR_PTR(-ENOMEM);
> +
> +	clk = clk_get(dev, id);
> +	if (!IS_ERR(clk)) {
> +		*ptr = clk;
> +		devres_add(dev, ptr);
> +	} else {
> +		devres_free(ptr);
> +	}
> +
> +	return clk;
> +}
> +EXPORT_SYMBOL(devm_clk_get);
> +
> +static int devm_clk_match(struct device *dev, void *res, void *data)
> +{
> +	struct clk **c = res;
> +	if (!c || !*c) {
> +		WARN_ON(!c || !*c);
> +		return 0;
> +	}
> +	return *c == data;
> +}
> +
> +void devm_clk_put(struct device *dev, struct clk *clk)
> +{
> +	int ret;
> +
> +	ret = devres_destroy(dev, devm_clk_release, devm_clk_match, clk);
> +
> +	WARN_ON(ret);
> +}
> +EXPORT_SYMBOL(devm_clk_put);
> diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
> index d423c9b..442a313 100644
> --- a/drivers/clk/clkdev.c
> +++ b/drivers/clk/clkdev.c
> @@ -171,51 +171,6 @@ void clk_put(struct clk *clk)
>   }
>   EXPORT_SYMBOL(clk_put);
>
> -static void devm_clk_release(struct device *dev, void *res)
> -{
> -	clk_put(*(struct clk **)res);
> -}
> -
> -struct clk *devm_clk_get(struct device *dev, const char *id)
> -{
> -	struct clk **ptr, *clk;
> -
> -	ptr = devres_alloc(devm_clk_release, sizeof(*ptr), GFP_KERNEL);
> -	if (!ptr)
> -		return ERR_PTR(-ENOMEM);
> -
> -	clk = clk_get(dev, id);
> -	if (!IS_ERR(clk)) {
> -		*ptr = clk;
> -		devres_add(dev, ptr);
> -	} else {
> -		devres_free(ptr);
> -	}
> -
> -	return clk;
> -}
> -EXPORT_SYMBOL(devm_clk_get);
> -
> -static int devm_clk_match(struct device *dev, void *res, void *data)
> -{
> -	struct clk **c = res;
> -	if (!c || !*c) {
> -		WARN_ON(!c || !*c);
> -		return 0;
> -	}
> -	return *c == data;
> -}
> -
> -void devm_clk_put(struct device *dev, struct clk *clk)
> -{
> -	int ret;
> -
> -	ret = devres_destroy(dev, devm_clk_release, devm_clk_match, clk);
> -
> -	WARN_ON(ret);
> -}
> -EXPORT_SYMBOL(devm_clk_put);
> -
>   void clkdev_add(struct clk_lookup *cl)
>   {
>   	mutex_lock(&clocks_mutex);
>


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
