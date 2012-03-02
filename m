Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258Ab2CBHZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 02:25:47 -0500
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:56068 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758198Ab2CBHZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 02:25:44 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of rnayak@ti.com designates 10.100.83.6 as permitted sender) smtp.mail=rnayak@ti.com
Message-ID: <4F5075EE.1050902@ti.com>
Date: Fri, 02 Mar 2012 12:55:34 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: linux-kernel@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/4] mmc: omap_hsmmc: Use gpio_find_by_chip_name() for
 omap_hsmmc_gpio_init()
References: <20120301185044.29210.44521.stgit@kaulin.local> <20120301185528.29210.85854.stgit@kaulin.local>
In-Reply-To: <20120301185528.29210.85854.stgit@kaulin.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 March 2012 12:25 AM, Tony Lindgren wrote:
> Use gpio_find_by_chip_name() to find the GPIO pins as they can
> be dynamically allocated on various gpio_chips.
>
> Note that we don't want to touch the platform data as it can
> now specify the GPIO offset on a named gpio_chip.
>
> This removes the need to use callbacks to set the GPIO pins
> in platform data.
>
> Cc: Chris Ball<cjb@laptop.org>
> Cc: Grant Likely<grant.likely@secretlab.ca>
> Cc: Rajendra Nayak<rnayak@ti.com>
> Signed-off-by: Tony Lindgren<tony@atomide.com>
> ---

some more comments based on my testing with twl4030-gpio
built as a module..

>   arch/arm/mach-omap2/hsmmc.c           |    3 +
>   arch/arm/mach-omap2/hsmmc.h           |    5 ++
>   arch/arm/plat-omap/include/plat/mmc.h |    3 +
>   drivers/gpio/gpio-twl4030.c           |    2 +
>   drivers/mmc/host/omap_hsmmc.c         |  109 +++++++++++++++++++++------------
>   5 files changed, 82 insertions(+), 40 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/hsmmc.c b/arch/arm/mach-omap2/hsmmc.c
> index a97876d..dda88f7 100644
> --- a/arch/arm/mach-omap2/hsmmc.c
> +++ b/arch/arm/mach-omap2/hsmmc.c
> @@ -323,7 +323,10 @@ static int __init omap_hsmmc_pdata_init(struct omap2_hsmmc_info *c,

> @@ -497,55 +502,80 @@ static inline int omap_hsmmc_have_reg(void)
>
>   #endif
>
> -static int omap_hsmmc_gpio_init(struct omap_mmc_platform_data *pdata)
> +static int omap_hsmmc_gpio_init(struct omap_hsmmc_host *host)
>   {
> -	int ret;
> -
> -	if (gpio_is_valid(pdata->slots[0].switch_pin)) {
> -		if (pdata->slots[0].cover)
> -			pdata->slots[0].get_cover_state =
> +	struct omap_mmc_platform_data *pdata = host->pdata;
> +	struct omap_mmc_slot_data *slot =&pdata->slots[0];
> +	int gpio, ret;
> +
> +	gpio = slot->switch_pin;
> +	if (slot->gpiochip_cd)
> +		gpio = gpio_find_by_chip_name(slot->gpiochip_cd, gpio);
> +	if (gpio_is_valid(gpio)) {
> +		if (slot->cover)
> +			slot->get_cover_state =
>   					omap_hsmmc_get_cover_state;
>   		else
> -			pdata->slots[0].card_detect = omap_hsmmc_card_detect;
> -		pdata->slots[0].card_detect_irq =
> -				gpio_to_irq(pdata->slots[0].switch_pin);
> -		ret = gpio_request(pdata->slots[0].switch_pin, "mmc_cd");
> +			slot->card_detect = omap_hsmmc_card_detect;
> +		slot->card_detect_irq =
> +				gpio_to_irq(gpio);
> +		ret = gpio_request(gpio, "mmc_cd");
>   		if (ret)
>   			return ret;
> -		ret = gpio_direction_input(pdata->slots[0].switch_pin);
> +		ret = gpio_direction_input(gpio);
>   		if (ret)
>   			goto err_free_sp;
> -	} else
> -		pdata->slots[0].switch_pin = -EINVAL;
> +		host->gpio_cd = gpio;
> +	} else {
> +		if (slot->gpiochip_cd) {
> +			pr_warning("MMC %s card detect GPIO chip %s unavailable\n",
> +				slot->name, slot->gpiochip_cd);
> +			ret = -ENODEV;
> +			goto err_free_sp;

This should just return -ENODEV, nothing really to free here.

> +		}
> +		host->gpio_cd = -EINVAL;
> +	}
>
> -	if (gpio_is_valid(pdata->slots[0].gpio_wp)) {
> -		pdata->slots[0].get_ro = omap_hsmmc_get_wp;
> -		ret = gpio_request(pdata->slots[0].gpio_wp, "mmc_wp");
> +	gpio = slot->gpio_wp;
> +	if (slot->gpiochip_wp)
> +		gpio = gpio_find_by_chip_name(slot->gpiochip_wp, gpio);
> +	if (gpio_is_valid(gpio)) {
> +		slot->get_ro = omap_hsmmc_get_wp;
> +		ret = gpio_request(gpio, "mmc_wp");
>   		if (ret)
>   			goto err_free_cd;
> -		ret = gpio_direction_input(pdata->slots[0].gpio_wp);
> +		ret = gpio_direction_input(gpio);
>   		if (ret)
>   			goto err_free_wp;
> -	} else
> -		pdata->slots[0].gpio_wp = -EINVAL;
> +		host->gpio_wp = gpio;
> +	} else {
> +		if (slot->gpiochip_wp) {
> +			pr_warning("MMC %s write protect GPIO chip %s unavailable\n",
> +				slot->name, slot->gpiochip_wp);
> +			ret = -ENODEV;
> +			goto err_free_wp;
> +		}
> +		host->gpio_wp = -EINVAL;
> +	}
>
>   	return 0;
>
>   err_free_wp:
> -	gpio_free(pdata->slots[0].gpio_wp);
> +	if (gpio_is_valid(host->gpio_wp))
> +		gpio_free(host->gpio_wp);
>   err_free_cd:
> -	if (gpio_is_valid(pdata->slots[0].switch_pin))
> +	if (gpio_is_valid(host->gpio_cd))
>   err_free_sp:
> -		gpio_free(pdata->slots[0].switch_pin);
> +		gpio_free(host->gpio_cd);
>   	return ret;
>   }
>
> -static void omap_hsmmc_gpio_free(struct omap_mmc_platform_data *pdata)
> +static void omap_hsmmc_gpio_free(struct omap_hsmmc_host *host)
>   {
> -	if (gpio_is_valid(pdata->slots[0].gpio_wp))
> -		gpio_free(pdata->slots[0].gpio_wp);
> -	if (gpio_is_valid(pdata->slots[0].switch_pin))
> -		gpio_free(pdata->slots[0].switch_pin);
> +	if (gpio_is_valid(host->gpio_wp))
> +		gpio_free(host->gpio_wp);
> +	if (gpio_is_valid(host->gpio_cd))
> +		gpio_free(host->gpio_cd);
>   }
>
>   /*
> @@ -1876,10 +1906,6 @@ static int __init omap_hsmmc_probe(struct platform_device *pdev)
>   	if (res == NULL)
>   		return -EBUSY;
>
> -	ret = omap_hsmmc_gpio_init(pdata);
> -	if (ret)
> -		goto err;
> -
>   	mmc = mmc_alloc_host(sizeof(struct omap_hsmmc_host),&pdev->dev);
>   	if (!mmc) {
>   		ret = -ENOMEM;
> @@ -1903,6 +1929,10 @@ static int __init omap_hsmmc_probe(struct platform_device *pdev)
>
>   	platform_set_drvdata(pdev, host);
>
> +	ret = omap_hsmmc_gpio_init(host);
> +	if (ret)
> +		goto err1;
> +
>   	mmc->ops	=&omap_hsmmc_ops;
>
>   	/*
> @@ -2093,8 +2123,7 @@ err1:
>   	platform_set_drvdata(pdev, NULL);
>   	mmc_free_host(mmc);
>   err_alloc:
> -	omap_hsmmc_gpio_free(pdata);
> -err:
> +	omap_hsmmc_gpio_free(host);

This error handling needs to be fixed up. In case
omap_hsmmc_gpio_init() fails, which already frees up
any requested gpios, omap_hsmmc_gpio_free() again tries
freeing gpios.

regards,
Rajendra

>   	release_mem_region(res->start, resource_size(res));
>   	return ret;
>   }
> @@ -2125,7 +2154,7 @@ static int omap_hsmmc_remove(struct platform_device *pdev)
>
>   		mmc_free_host(host->mmc);
>   		iounmap(host->base);
> -		omap_hsmmc_gpio_free(pdev->dev.platform_data);
> +		omap_hsmmc_gpio_free(host);
>   	}
>
>   	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>

