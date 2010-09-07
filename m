Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab0IGMXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 08:23:39 -0400
Received: from compulab.co.il ([67.18.134.219]:38573 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755476Ab0IGMXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 08:23:32 -0400
Message-ID: <4C862EB3.4080006@compulab.co.il>
Date: Tue, 07 Sep 2010 15:23:15 +0300
From: Igor Grinberg <grinberg@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.7) Gecko/20100816 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Marek Vasut <marek.vasut@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, vapier@gentoo.org,
        khilman@deeprootsystems.com, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org, pavel@ucw.cz,
        linux-input@vger.kernel.org, eric.y.miao@gmail.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v2] Input: Make ADS7846 independent on regulator
References: <1280560182-7071-1-git-send-email-marek.vasut@gmail.com>
In-Reply-To: <1280560182-7071-1-git-send-email-marek.vasut@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Seems that there are some more platforms then Sharp Zaurus
are interested in this patch.

Dmitry, Mike, Pavel,

What's the status of it?

On 07/31/10 10:09, Marek Vasut wrote:
> In case regulator was not found, ADS7846 failed to probe.
>
> This fixes a problem on some Sharp Zaurus devices, where there is no regulator
> present and the touchscreen is used.
>
> Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> ---
>  drivers/input/touchscreen/ads7846.c |   38 +++++++++++++++++++---------------
>  1 files changed, 21 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
> index a9fdf55..53b318b 100644
> --- a/drivers/input/touchscreen/ads7846.c
> +++ b/drivers/input/touchscreen/ads7846.c
> @@ -791,7 +791,8 @@ static void ads7846_disable(struct ads7846 *ts)
>  		}
>  	}
>  
> -	regulator_disable(ts->reg);
> +	if (ts->reg)
> +		regulator_disable(ts->reg);
>  
>  	/* we know the chip's in lowpower mode since we always
>  	 * leave it that way after every request
> @@ -804,7 +805,8 @@ static void ads7846_enable(struct ads7846 *ts)
>  	if (!ts->disabled)
>  		return;
>  
> -	regulator_enable(ts->reg);
> +	if (ts->reg)
> +		regulator_enable(ts->reg);
>  
>  	ts->disabled = 0;
>  	ts->irq_disabled = 0;
> @@ -1162,16 +1164,15 @@ static int __devinit ads7846_probe(struct spi_device *spi)
>  	ts->last_msg = m;
>  
>  	ts->reg = regulator_get(&spi->dev, "vcc");
> -	if (IS_ERR(ts->reg)) {
> -		err = PTR_ERR(ts->reg);
> -		dev_err(&spi->dev, "unable to get regulator: %d\n", err);
> -		goto err_free_gpio;
> -	}
> -
> -	err = regulator_enable(ts->reg);
> -	if (err) {
> -		dev_err(&spi->dev, "unable to enable regulator: %d\n", err);
> -		goto err_put_regulator;
> +	if (IS_ERR(ts->reg))
> +		ts->reg = NULL;
> +	else {
> +		err = regulator_enable(ts->reg);
> +		if (err) {
> +			dev_err(&spi->dev, "unable to enable regulator: %d\n",
> +				err);
> +			goto err_put_regulator;
> +		}
>  	}
>  
>  	if (request_irq(spi->irq, ads7846_irq, IRQF_TRIGGER_FALLING,
> @@ -1218,10 +1219,11 @@ static int __devinit ads7846_probe(struct spi_device *spi)
>   err_free_irq:
>  	free_irq(spi->irq, ts);
>   err_disable_regulator:
> -	regulator_disable(ts->reg);
> +	if (ts->reg)
> +		regulator_disable(ts->reg);
>   err_put_regulator:
> -	regulator_put(ts->reg);
> - err_free_gpio:
> +	if (ts->reg)
> +		regulator_put(ts->reg);
>  	if (ts->gpio_pendown != -1)
>  		gpio_free(ts->gpio_pendown);
>   err_cleanup_filter:
> @@ -1251,8 +1253,10 @@ static int __devexit ads7846_remove(struct spi_device *spi)
>  	/* suspend left the IRQ disabled */
>  	enable_irq(ts->spi->irq);
>  
> -	regulator_disable(ts->reg);
> -	regulator_put(ts->reg);
> +	if (ts->reg) {
> +		regulator_disable(ts->reg);
> +		regulator_put(ts->reg);
> +	}
>  
>  	if (ts->gpio_pendown != -1)
>  		gpio_free(ts->gpio_pendown);

-- 
Regards,
Igor.

