Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab2EYGm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 02:42:27 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:39195 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754249Ab2EYGmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 02:42:23 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: -11
X-BigFish: VPS-11(zzbb2dI9371I1432N98dKzz1202hzz8275ch8275bhz2dh2a8h668h839hd25he5bhf0ah)
Message-ID: <4FBF29B4.7000206@analog.com>
Date: Fri, 25 May 2012 08:41:56 +0200
From: Michael Hennerich <michael.hennerich@analog.com>
Reply-To: <michael.hennerich@analog.com>
Organization: Analog Devices Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>
Subject: Re: [PATCH 02/13] backlight: adp8870: use devm_ functions
References: <000d01cd3a1c$90d16630$b2743290$%han@samsung.com>
In-Reply-To: <000d01cd3a1c$90d16630$b2743290$%han@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2012 04:17 AM, Jingoo Han wrote:
> The devm_ functions allocate memory that is released when a driver
> detaches. This patch uses devm_kzalloc of these functions.
>
> Cc: Michael Hennerich<michael.hennerich@analog.com>
> Cc: Richard Purdie<rpurdie@rpsys.net>
> Signed-off-by: Jingoo Han<jg1.han@samsung.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
> ---
>   drivers/video/backlight/adp8870_bl.c |   22 +++++++---------------
>   1 files changed, 7 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/video/backlight/adp8870_bl.c b/drivers/video/backlight/adp8870_bl.c
> index 9be58c6..32c025f 100644
> --- a/drivers/video/backlight/adp8870_bl.c
> +++ b/drivers/video/backlight/adp8870_bl.c
> @@ -244,8 +244,8 @@ static int __devinit adp8870_led_probe(struct i2c_client *client)
>   	struct led_info *cur_led;
>   	int ret, i;
>
> -
> -	led = kcalloc(pdata->num_leds, sizeof(*led), GFP_KERNEL);
> +	led = devm_kzalloc(&client->dev, pdata->num_leds * sizeof(*led),
> +				GFP_KERNEL);
>   	if (led == NULL) {
>   		dev_err(&client->dev, "failed to alloc memory\n");
>   		return -ENOMEM;
> @@ -253,17 +253,17 @@ static int __devinit adp8870_led_probe(struct i2c_client *client)
>
>   	ret = adp8870_write(client, ADP8870_ISCLAW, pdata->led_fade_law);
>   	if (ret)
> -		goto err_free;
> +		return ret;
>
>   	ret = adp8870_write(client, ADP8870_ISCT1,
>   			(pdata->led_on_time&  0x3)<<  6);
>   	if (ret)
> -		goto err_free;
> +		return ret;
>
>   	ret = adp8870_write(client, ADP8870_ISCF,
>   			FADE_VAL(pdata->led_fade_in, pdata->led_fade_out));
>   	if (ret)
> -		goto err_free;
> +		return ret;
>
>   	for (i = 0; i<  pdata->num_leds; ++i) {
>   		cur_led =&pdata->leds[i];
> @@ -317,9 +317,6 @@ static int __devinit adp8870_led_probe(struct i2c_client *client)
>   		cancel_work_sync(&led[i].work);
>   	}
>
> - err_free:
> -	kfree(led);
> -
>   	return ret;
>   }
>
> @@ -335,7 +332,6 @@ static int __devexit adp8870_led_remove(struct i2c_client *client)
>   		cancel_work_sync(&data->led[i].work);
>   	}
>
> -	kfree(data->led);
>   	return 0;
>   }
>   #else
> @@ -874,7 +870,7 @@ static int __devinit adp8870_probe(struct i2c_client *client,
>   		return -ENODEV;
>   	}
>
> -	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	data = devm_kzalloc(&client->dev, sizeof(*data), GFP_KERNEL);
>   	if (data == NULL)
>   		return -ENOMEM;
>
> @@ -894,8 +890,7 @@ static int __devinit adp8870_probe(struct i2c_client *client,
>   			&client->dev, data,&adp8870_bl_ops,&props);
>   	if (IS_ERR(bl)) {
>   		dev_err(&client->dev, "failed to register backlight\n");
> -		ret = PTR_ERR(bl);
> -		goto out2;
> +		return PTR_ERR(bl);
>   	}
>
>   	data->bl = bl;
> @@ -930,8 +925,6 @@ out:
>   			&adp8870_bl_attr_group);
>   out1:
>   	backlight_device_unregister(bl);
> -out2:
> -	kfree(data);
>
>   	return ret;
>   }
> @@ -950,7 +943,6 @@ static int __devexit adp8870_remove(struct i2c_client *client)
>   			&adp8870_bl_attr_group);
>
>   	backlight_device_unregister(data->bl);
> -	kfree(data);
>
>   	return 0;
>   }


-- 
Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368;
Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin,
Margaret Seif


