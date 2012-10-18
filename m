Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab2JRLTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 07:19:25 -0400
Received: from smtp-out-124.synserver.de ([212.40.185.124]:1280 "EHLO
	smtp-out-124.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab2JRLTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 07:19:24 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 32037
Message-ID: <507FE604.8070404@metafoo.de>
Date: Thu, 18 Oct 2012 13:20:36 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: "cbou@mail.ru" <cbou@mail.ru>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] lp8788-charger: fix wrong ADC conversion
References: <A874F61F95741C4A9BA573A70FE3998F64178FA7@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F64178FA7@DQHE02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/18/2012 08:11 AM, Kim, Milo wrote:
>  To get the battery voltage and temperature, IIO ADC functions are used.
>  LP8788 ADC driver provides RAW and SCALE channel information.
>  Both RAW with SCALE values are used for the ADC calculation.
>  The scale is micro unit, additional conversions are required in each case.
>  This patch fixes wrong ADC result.
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/power/lp8788-charger.c |   18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/power/lp8788-charger.c b/drivers/power/lp8788-charger.c
> index 02fc9ab..3c739e6 100644
> --- a/drivers/power/lp8788-charger.c
> +++ b/drivers/power/lp8788-charger.c
> @@ -239,19 +239,26 @@ static int lp8788_get_vbatt_adc(struct lp8788_charger *pchg,
>  				unsigned int *result)
>  {
>  	struct iio_channel *channel = pchg->chan[LP8788_VBATT];
> +	int raw;
>  	int scaleint;
>  	int scalepart;
>  	int ret;
> +	unsigned long tmp;
>  
>  	if (!channel)
>  		return -EINVAL;
>  
> +	ret = iio_read_channel_raw(channel, &raw);
> +	if (ret != IIO_VAL_INT)
> +		return -EINVAL;
> +
>  	ret = iio_read_channel_scale(channel, &scaleint, &scalepart);
>  	if (ret != IIO_VAL_INT_PLUS_MICRO)
>  		return -EINVAL;
>  
>  	/* unit: mV */
> -	*result = (scaleint + scalepart * 1000000) / 1000;
> +	tmp = raw * scaleint + div_u64(raw * scalepart, 1000000L);
> +	*result = (unsigned int)tmp;


We now have a function in the IIO core which does the sampling + conversion
in one step: iio_read_channel_processed. This basically allows you to reduce
this function to

	return iio_read_channel_processed(channel, result);

I'd also make the result parameter of lp8788_get_vbatt_adc signed, since
both power_supply_propval.intval and iio_read_channel_processed use a signed
int.

>  
>  	return 0;
>  }
> @@ -304,19 +311,26 @@ static int lp8788_get_battery_temperature(struct lp8788_charger *pchg,
>  				union power_supply_propval *val)
>  {
>  	struct iio_channel *channel = pchg->chan[LP8788_BATT_TEMP];
> +	int raw;
>  	int scaleint;
>  	int scalepart;
>  	int ret;
> +	unsigned long tmp;
>  
>  	if (!channel)
>  		return -EINVAL;
>  
> +	ret = iio_read_channel_raw(channel, &raw);
> +	if (ret != IIO_VAL_INT)
> +		return -EINVAL;
> +
>  	ret = iio_read_channel_scale(channel, &scaleint, &scalepart);
>  	if (ret != IIO_VAL_INT_PLUS_MICRO)
>  		return -EINVAL;
>  
>  	/* unit: 0.1 'C */
> -	val->intval = (scaleint + scalepart * 1000000) / 100;
> +	tmp = raw * scaleint + div_u64(raw * scalepart, 1000000L);
> +	val->intval = (unsigned int)tmp * 10;
>  

Same here

>  	return 0;
>  }

