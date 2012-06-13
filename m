Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab2FML0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:26:39 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34970 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab2FML0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:26:38 -0400
From: Marek Vasut <marek.vasut@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 5/7] backlight: lms283gf05: use devm_gpio_request()
Date: Wed, 13 Jun 2012 13:26:33 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-2-amd64; KDE/4.8.3; x86_64; ; )
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Axel Lin'" <axel.lin@gmail.com>
References: <000601cd4957$1d7b88b0$58729a10$%han@samsung.com>
In-Reply-To: <000601cd4957$1d7b88b0$58729a10$%han@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201206131326.33716.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jingoo Han,

> The devm_ functions allocate memory that is released when a driver
> detaches. This patch uses devm_gpio_request of these functions.
> 
> Cc: Marek Vasut <marek.vasut@gmail.com>

Acked-by: Marek Vasut <marek.vasut@gmail.com>

> Cc: Richard Purdie <rpurdie@rpsys.net>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/video/backlight/lms283gf05.c |   24 ++++++------------------
>  1 files changed, 6 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/video/backlight/lms283gf05.c
> b/drivers/video/backlight/lms283gf05.c index a9f2c36..ea43f22 100644
> --- a/drivers/video/backlight/lms283gf05.c
> +++ b/drivers/video/backlight/lms283gf05.c
> @@ -158,29 +158,27 @@ static int __devinit lms283gf05_probe(struct
> spi_device *spi) int ret = 0;
> 
>  	if (pdata != NULL) {
> -		ret = gpio_request(pdata->reset_gpio, "LMS285GF05 RESET");
> +		ret = devm_gpio_request(&spi->dev, pdata->reset_gpio,
> +					"LMS285GF05 RESET");
>  		if (ret)
>  			return ret;
> 
>  		ret = gpio_direction_output(pdata->reset_gpio,
>  						!pdata->reset_inverted);
>  		if (ret)
> -			goto err;
> +			return ret;
>  	}
> 
>  	st = devm_kzalloc(&spi->dev, sizeof(struct lms283gf05_state),
>  				GFP_KERNEL);
>  	if (st == NULL) {
>  		dev_err(&spi->dev, "No memory for device state\n");
> -		ret = -ENOMEM;
> -		goto err;
> +		return -ENOMEM;
>  	}
> 
>  	ld = lcd_device_register("lms283gf05", &spi->dev, st, &lms_ops);
> -	if (IS_ERR(ld)) {
> -		ret = PTR_ERR(ld);
> -		goto err;
> -	}
> +	if (IS_ERR(ld))
> +		return PTR_ERR(ld);
> 
>  	st->spi = spi;
>  	st->ld = ld;
> @@ -193,24 +191,14 @@ static int __devinit lms283gf05_probe(struct
> spi_device *spi) lms283gf05_toggle(spi, disp_initseq,
> ARRAY_SIZE(disp_initseq));
> 
>  	return 0;
> -
> -err:
> -	if (pdata != NULL)
> -		gpio_free(pdata->reset_gpio);
> -
> -	return ret;
>  }
> 
>  static int __devexit lms283gf05_remove(struct spi_device *spi)
>  {
>  	struct lms283gf05_state *st = dev_get_drvdata(&spi->dev);
> -	struct lms283gf05_pdata *pdata = st->spi->dev.platform_data;
> 
>  	lcd_device_unregister(st->ld);
> 
> -	if (pdata != NULL)
> -		gpio_free(pdata->reset_gpio);
> -
>  	return 0;
>  }

Best regards,
Marek Vasut
