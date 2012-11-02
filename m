Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422668Ab2KBKJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 06:09:23 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:45386 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab2KBKJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 06:09:22 -0400
Message-ID: <50939BD0.9010000@kernel.org>
Date: Fri, 02 Nov 2012 10:09:20 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121012 Thunderbird/16.0.1
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: "Kim, Milo" <Milo.Kim@ti.com>, "cbou@mail.ru" <cbou@mail.ru>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] lp8788-charger: fix wrong ADC conversion
References: <A874F61F95741C4A9BA573A70FE3998F64179109@DQHE02.ent.ti.com> <50814B6A.6010000@metafoo.de>
In-Reply-To: <50814B6A.6010000@metafoo.de>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 01:45 PM, Lars-Peter Clausen wrote:
> On 10/19/2012 02:12 AM, Kim, Milo wrote:
>>  To get the battery voltage and temperature, IIO ADC functions are used.
>>  LP8788 ADC driver provides RAW and SCALE channel information.
>>  This patch fixes wrong ADC result.
>>
>>  Patch v2.
>>  Use simple iio_read_channel_processed() function rather than
>>  iio_read_channel_raw() and _scale().
>>
>>  Fix the result type of ADC function as a signed integer.
>>  Because power_supply_propval.intval and the return value of
>>  iio_read_channel_processed() are a signed integer,
>>  'unsigned int' are replaced with 'int'.
>>
>>  Patch v1.
>>  Fix wrong ADC results using iio_read_channel_raw() and _scale().
>>
>> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> 
> Looks good to me, fwiw:
> 
> Reviewed-by Lars-Peter Clausen <lars@metafoo.de>
On this stuff as far as I'm concerned Lars' approval is fine but
for what it's worth this all looks fine to me.

Acked-by: Jonathan Cameron <jic23@kernel.org>

> 
> But there is one issue, but this is not necessarily related to this patch,
> more inline.
> 
>> ---
>>  drivers/power/lp8788-charger.c |   26 +++++++-------------------
>>  1 file changed, 7 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/power/lp8788-charger.c b/drivers/power/lp8788-charger.c
>> index 02fc9ab..f18ec8f 100644
>> --- a/drivers/power/lp8788-charger.c
>> +++ b/drivers/power/lp8788-charger.c
>> @@ -235,25 +235,14 @@ static int lp8788_get_battery_present(struct lp8788_charger *pchg,
>>  	return 0;
>>  }
>>  
> [...]
>>  static int lp8788_get_battery_voltage(struct lp8788_charger *pchg,
>> @@ -268,7 +257,7 @@ static int lp8788_get_battery_capacity(struct lp8788_charger *pchg,
>>  	struct lp8788 *lp = pchg->lp;
>>  	struct lp8788_charger_platform_data *pdata = pchg->pdata;
>>  	unsigned int max_vbatt;
>> -	unsigned int vbatt;
>> +	int vbatt;
>>  	enum lp8788_charging_state state;
>>  	u8 data;
>>  	int ret;
>> @@ -304,19 +293,18 @@ static int lp8788_get_battery_temperature(struct lp8788_charger *pchg,
>>  				union power_supply_propval *val)
>>  {
>>  	struct iio_channel *channel = pchg->chan[LP8788_BATT_TEMP];
>> -	int scaleint;
>> -	int scalepart;
>> +	int result;
>>  	int ret;
>>  
>>  	if (!channel)
>>  		return -EINVAL;
>>  
>> -	ret = iio_read_channel_scale(channel, &scaleint, &scalepart);
>> -	if (ret != IIO_VAL_INT_PLUS_MICRO)
>> +	ret = iio_read_channel_processed(channel, &result);
>> +	if (ret < 0)
>>  		return -EINVAL;
>>  
>>  	/* unit: 0.1 'C */
>> -	val->intval = (scaleint + scalepart * 1000000) / 100;
>> +	val->intval = result * 10;
> 
> IIO reports temperatures in milli degree Celsius. So it should be multiplied
> by 100 to get tenth degree like the power supply framework expects it. But
> this might be a issue in your IIO driver reporting the wrong scale.
> 
> - Lars
> 
>>  
>>  	return 0;
>>  }
> 
