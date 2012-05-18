Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946366Ab2ERXbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:31:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37906 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946292Ab2ERXbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:31:15 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 3/3] gpio: tps65910: dt: process gpio specific device node info
To: Laxman Dewangan <ldewangan@nvidia.com>, linus.walleij@stericsson.com,
        sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        lrg@slimlogic.co.uk
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>
In-Reply-To: <1337373103-23933-4-git-send-email-ldewangan@nvidia.com>
References: <1337373103-23933-1-git-send-email-ldewangan@nvidia.com> <1337373103-23933-4-git-send-email-ldewangan@nvidia.com>
Date: Fri, 18 May 2012 17:31:13 -0600
Message-Id: <20120518233113.7164E3E07C8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2012 02:01:43 +0530, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> Parse the gpio specific device node information locally.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

I expect this needs to go in via Samuel's tree with the mfd patches?

g.

> ---
>  drivers/gpio/gpio-tps65910.c |   36 ++++++++++++++++++++++++++++++++++++
>  1 files changed, 36 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-tps65910.c b/drivers/gpio/gpio-tps65910.c
> index af6dc83..c1ad288 100644
> --- a/drivers/gpio/gpio-tps65910.c
> +++ b/drivers/gpio/gpio-tps65910.c
> @@ -20,6 +20,7 @@
>  #include <linux/i2c.h>
>  #include <linux/platform_device.h>
>  #include <linux/mfd/tps65910.h>
> +#include <linux/of_device.h>
>  
>  struct tps65910_gpio {
>  	struct gpio_chip gpio_chip;
> @@ -81,6 +82,37 @@ static int tps65910_gpio_input(struct gpio_chip *gc, unsigned offset)
>  						GPIO_CFG_MASK);
>  }
>  
> +#ifdef CONFIG_OF
> +static struct tps65910_board *tps65910_parse_dt_for_gpio(struct device *dev,
> +		struct tps65910 *tps65910, int chip_ngpio)
> +{
> +	struct tps65910_board *tps65910_board = tps65910->of_plat_data;
> +	unsigned int prop_array[TPS6591X_MAX_NUM_GPIO];
> +	int ngpio = min(chip_ngpio, TPS6591X_MAX_NUM_GPIO);
> +	int ret;
> +	int idx;
> +
> +	tps65910_board->gpio_base = -1;
> +	ret = of_property_read_u32_array(tps65910->dev->of_node,
> +			"ti,en-gpio-sleep", prop_array, ngpio);
> +	if (ret < 0) {
> +		dev_dbg(dev, "ti,en-gpio-sleep not specified\n");
> +		return tps65910_board;
> +	}
> +
> +	for (idx = 0; idx < ngpio; idx++)
> +		tps65910_board->en_gpio_sleep[idx] = (prop_array[idx] != 0);
> +
> +	return tps65910_board;
> +}
> +#else
> +static struct tps65910_board *tps65910_parse_dt_for_gpio(struct device *dev,
> +		struct tps65910 *tps65910, int chip_ngpio)
> +{
> +	return NULL;
> +}
> +#endif
> +
>  static int __devinit tps65910_gpio_probe(struct platform_device *pdev)
>  {
>  	struct tps65910 *tps65910 = dev_get_drvdata(pdev->dev.parent);
> @@ -122,6 +154,10 @@ static int __devinit tps65910_gpio_probe(struct platform_device *pdev)
>  	else
>  		tps65910_gpio->gpio_chip.base = -1;
>  
> +	if (!pdata && tps65910->dev->of_node)
> +		pdata = tps65910_parse_dt_for_gpio(&pdev->dev, tps65910,
> +			tps65910_gpio->gpio_chip.ngpio);
> +
>  	if (!pdata)
>  		goto skip_init;
>  
> -- 
> 1.7.1.1
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
