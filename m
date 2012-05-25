Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab2EYGmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 02:42:19 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:28095 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750930Ab2EYGmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 02:42:18 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: -11
X-BigFish: VPS-11(zzbb2dI9371I1432N98dKzz1202hzz8275ch8275bhz2dh2a8h668h839hd25he5bhf0ah)
Message-ID: <4FBF29BE.5010103@analog.com>
Date: Fri, 25 May 2012 08:42:06 +0200
From: Michael Hennerich <michael.hennerich@analog.com>
Reply-To: <michael.hennerich@analog.com>
Organization: Analog Devices Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>
Subject: Re: [PATCH 01/13] backlight: adp8860: use devm_ functions
References: <000c01cd3a1c$74c84670$5e58d350$%han@samsung.com>
In-Reply-To: <000c01cd3a1c$74c84670$5e58d350$%han@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2012 04:16 AM, Jingoo Han wrote:
> The devm_ functions allocate memory that is released when a driver
> detaches. This patch uses devm_kzalloc of these functions.
>
> Cc: Michael Hennerich<michael.hennerich@analog.com>
> Cc: Richard Purdie<rpurdie@rpsys.net>
> Signed-off-by: Jingoo Han<jg1.han@samsung.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
> ---
>   drivers/video/backlight/adp8860_bl.c |   22 +++++++---------------
>   1 files changed, 7 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/video/backlight/adp8860_bl.c b/drivers/video/backlight/adp8860_bl.c
> index 550dbf0..48af78f 100644
> --- a/drivers/video/backlight/adp8860_bl.c
> +++ b/drivers/video/backlight/adp8860_bl.c
> @@ -222,7 +222,8 @@ static int __devinit adp8860_led_probe(struct i2c_client *client)
>   	struct led_info *cur_led;
>   	int ret, i;
>
> -	led = kzalloc(sizeof(*led) * pdata->num_leds, GFP_KERNEL);
> +	led = devm_kzalloc(&client->dev, sizeof(*led) * pdata->num_leds,
> +				GFP_KERNEL);
>   	if (led == NULL) {
>   		dev_err(&client->dev, "failed to alloc memory\n");
>   		return -ENOMEM;
> @@ -236,7 +237,7 @@ static int __devinit adp8860_led_probe(struct i2c_client *client)
>
>   	if (ret) {
>   		dev_err(&client->dev, "failed to write\n");
> -		goto err_free;
> +		return ret;
>   	}
>
>   	for (i = 0; i<  pdata->num_leds; ++i) {
> @@ -291,9 +292,6 @@ static int __devinit adp8860_led_probe(struct i2c_client *client)
>   		cancel_work_sync(&led[i].work);
>   	}
>
> - err_free:
> -	kfree(led);
> -
>   	return ret;
>   }
>
> @@ -309,7 +307,6 @@ static int __devexit adp8860_led_remove(struct i2c_client *client)
>   		cancel_work_sync(&data->led[i].work);
>   	}
>
> -	kfree(data->led);
>   	return 0;
>   }
>   #else
> @@ -675,13 +672,13 @@ static int __devinit adp8860_probe(struct i2c_client *client,
>   		return -EINVAL;
>   	}
>
> -	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	data = devm_kzalloc(&client->dev, sizeof(*data), GFP_KERNEL);
>   	if (data == NULL)
>   		return -ENOMEM;
>
>   	ret = adp8860_read(client, ADP8860_MFDVID,&reg_val);
>   	if (ret<  0)
> -		goto out2;
> +		return ret;
>
>   	switch (ADP8860_MANID(reg_val)) {
>   	case ADP8863_MANUFID:
> @@ -694,8 +691,7 @@ static int __devinit adp8860_probe(struct i2c_client *client,
>   		break;
>   	default:
>   		dev_err(&client->dev, "failed to probe\n");
> -		ret = -ENODEV;
> -		goto out2;
> +		return -ENODEV;
>   	}
>
>   	/* It's confirmed that the DEVID field is actually a REVID */
> @@ -717,8 +713,7 @@ static int __devinit adp8860_probe(struct i2c_client *client,
>   			&client->dev, data,&adp8860_bl_ops,&props);
>   	if (IS_ERR(bl)) {
>   		dev_err(&client->dev, "failed to register backlight\n");
> -		ret = PTR_ERR(bl);
> -		goto out2;
> +		return PTR_ERR(bl);
>   	}
>
>   	bl->props.brightness = ADP8860_MAX_BRIGHTNESS;
> @@ -756,8 +751,6 @@ out:
>   			&adp8860_bl_attr_group);
>   out1:
>   	backlight_device_unregister(bl);
> -out2:
> -	kfree(data);
>
>   	return ret;
>   }
> @@ -776,7 +769,6 @@ static int __devexit adp8860_remove(struct i2c_client *client)
>   			&adp8860_bl_attr_group);
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


