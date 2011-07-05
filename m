Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab1GEGHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 02:07:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:50790 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab1GEGHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 02:07:22 -0400
X-AuditID: cbfee60d-b7b89ae0000007c1-ed-4e12aa1818c1
Date: Tue, 05 Jul 2011 06:07:20 +0000 (GMT)
From: JinGoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH] backlight: Set backlight type and max_brightness before
 backlights are registered
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Matthew Garrett <mjg@redhat.com>, JinGoo Han <jg1.han@samsung.com>,
        Donghwa Lee <dh09.lee@samsung.com>, In-Ki Dae <inki.dae@samsung.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20110705060429324@jg1.han
Msgkey: 20110705060429324@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20110705060429324@jg1.han
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <11756226.359271309846040127.JavaMail.weblogic@epml17>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p6567dbw014362

Acked-by: Jingoo Han <jg1.han@samsung.com>

The ams369fg06 driver is tested.

> -----Original Message-----
> From: Axel Lin [mailto:axel.lin@gmail.com]
> Sent: Tuesday, July 05, 2011 1:38 PM
> To: linux-kernel@vger.kernel.org
> Cc: Matthew Garrett; Jingoo Han; Donghwa Lee; InKi Dae; Richard Purdie;
> Andrew Morton
> Subject: [PATCH] backlight: Set backlight type and max_brightness before
> backlights are registered
> 
> Since commit a19a6ee "backlight: Allow properties to be passed at
> registration"
> and commit bb7ca74 "backlight: add backlight type",
> we can set backlight type and max_brightness before backlights are
> registered.
> Some newly added drivers did not set it properly, let's fix it.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: Jingoo Han <jg1.han@samsung.com>
> Cc: Donghwa Lee <dh09.lee@samsung.com>
> Cc: InKi Dae <inki.dae@samsung.com>
> ---
>  drivers/video/backlight/ams369fg06.c |    9 ++++++---
>  drivers/video/backlight/ld9040.c     |    8 ++++++--
>  drivers/video/backlight/s6e63m0.c    |    9 ++++++---
>  3 files changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/video/backlight/ams369fg06.c
> b/drivers/video/backlight/ams369fg06.c
> index 6462d05..201a593 100644
> --- a/drivers/video/backlight/ams369fg06.c
> +++ b/drivers/video/backlight/ams369fg06.c
> @@ -479,6 +479,7 @@ static int __init ams369fg06_probe(struct spi_device
> *spi)
>  	struct ams369fg06 *lcd = NULL;
>  	struct lcd_device *ld = NULL;
>  	struct backlight_device *bd = NULL;
> +	struct backlight_properties props;
> 
>  	lcd = kzalloc(sizeof(struct ams369fg06), GFP_KERNEL);
>  	if (!lcd)
> @@ -511,16 +512,18 @@ static int __init ams369fg06_probe(struct spi_device
> *spi)
> 
>  	lcd->ld = ld;
> 
> +	memset(&props, 0, sizeof(struct backlight_properties));
> +	props.type = BACKLIGHT_RAW;
> +	props.max_brightness = MAX_BRIGHTNESS;
> +
>  	bd = backlight_device_register("ams369fg06-bl", &spi->dev, lcd,
> -		&ams369fg06_backlight_ops, NULL);
> +		&ams369fg06_backlight_ops, &props);
>  	if (IS_ERR(bd)) {
>  		ret =  PTR_ERR(bd);
>  		goto out_lcd_unregister;
>  	}
> 
> -	bd->props.max_brightness = MAX_BRIGHTNESS;
>  	bd->props.brightness = DEFAULT_BRIGHTNESS;
> -	bd->props.type = BACKLIGHT_RAW;
>  	lcd->bd = bd;
> 
>  	if (!lcd->lcd_pd->lcd_enabled) {
> diff --git a/drivers/video/backlight/ld9040.c
> b/drivers/video/backlight/ld9040.c
> index 62bcde3..5934655 100644
> --- a/drivers/video/backlight/ld9040.c
> +++ b/drivers/video/backlight/ld9040.c
> @@ -668,6 +668,7 @@ static int ld9040_probe(struct spi_device *spi)
>  	struct ld9040 *lcd = NULL;
>  	struct lcd_device *ld = NULL;
>  	struct backlight_device *bd = NULL;
> +	struct backlight_properties props;
> 
>  	lcd = kzalloc(sizeof(struct ld9040), GFP_KERNEL);
>  	if (!lcd)
> @@ -699,14 +700,17 @@ static int ld9040_probe(struct spi_device *spi)
> 
>  	lcd->ld = ld;
> 
> +	memset(&props, 0, sizeof(struct backlight_properties));
> +	props.type = BACKLIGHT_RAW;
> +	props.max_brightness = MAX_BRIGHTNESS;
> +
>  	bd = backlight_device_register("ld9040-bl", &spi->dev,
> -		lcd, &ld9040_backlight_ops, NULL);
> +		lcd, &ld9040_backlight_ops, &props);
>  	if (IS_ERR(bd)) {
>  		ret = PTR_ERR(bd);
>  		goto out_unregister_lcd;
>  	}
> 
> -	bd->props.max_brightness = MAX_BRIGHTNESS;
>  	bd->props.brightness = MAX_BRIGHTNESS;
>  	lcd->bd = bd;
> 
> diff --git a/drivers/video/backlight/s6e63m0.c
> b/drivers/video/backlight/s6e63m0.c
> index e1803ba..694e5aa 100644
> --- a/drivers/video/backlight/s6e63m0.c
> +++ b/drivers/video/backlight/s6e63m0.c
> @@ -738,6 +738,7 @@ static int __devinit s6e63m0_probe(struct spi_device
> *spi)
>  	struct s6e63m0 *lcd = NULL;
>  	struct lcd_device *ld = NULL;
>  	struct backlight_device *bd = NULL;
> +	struct backlight_properties props;
> 
>  	lcd = kzalloc(sizeof(struct s6e63m0), GFP_KERNEL);
>  	if (!lcd)
> @@ -769,16 +770,18 @@ static int __devinit s6e63m0_probe(struct spi_device
> *spi)
> 
>  	lcd->ld = ld;
> 
> +	memset(&props, 0, sizeof(struct backlight_properties));
> +	props.type = BACKLIGHT_RAW;
> +	props.max_brightness = MAX_BRIGHTNESS;
> +
>  	bd = backlight_device_register("s6e63m0bl-bl", &spi->dev, lcd,
> -		&s6e63m0_backlight_ops, NULL);
> +		&s6e63m0_backlight_ops, &props);
>  	if (IS_ERR(bd)) {
>  		ret =  PTR_ERR(bd);
>  		goto out_lcd_unregister;
>  	}
> 
> -	bd->props.max_brightness = MAX_BRIGHTNESS;
>  	bd->props.brightness = MAX_BRIGHTNESS;
> -	bd->props.type = BACKLIGHT_RAW;
>  	lcd->bd = bd;
> 
>  	/*
> --
> 1.7.4.1
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
