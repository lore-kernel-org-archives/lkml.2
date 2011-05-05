Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab1EEABj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 20:01:39 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:15943 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248Ab1EEABi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 20:01:38 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-132.messagelabs.com!1304553696!24590317!1
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.178]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Jamie Iles <jamie@jamieiles.com>
Date: Wed, 4 May 2011 19:01:35 -0500
Subject: Re: [RFC PATCH 1/3] basic_mmio_gpio: split into a gpio library and
 platform device
Thread-Topic: Re: [RFC PATCH 1/3] basic_mmio_gpio: split into a gpio library
 and platform device
Thread-Index: AcwKt5mG5ksZRLVQTCSRC/sbWrGFcw==
Message-ID: <0D753D10438DA54287A00B027084269764D29BEAEE@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p4501h1A003256

On Wed, 4 May 2011 16:07:35 +0100, Jamie Iles wrote,
>
> Allow GPIO_BASIC_MMIO_CORE to be used to provide an accessor library
> for implementing GPIO drivers whilst abstracting the register access
> detail.  Based on a patch from Anton Vorontsov[1] and adapted to allow
> bgpio_chip to be embedded in another structure.

[snip]

> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index cfbdef1..91a295d 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -6,6 +6,7 @@ obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
> 
>  obj-$(CONFIG_GPIO_ADP5520)	+= adp5520-gpio.o
>  obj-$(CONFIG_GPIO_ADP5588)	+= adp5588-gpio.o
> +obj-$(CONFIG_GPIO_BASIC_MMIO_CORE)	+= basic_mmio_gpio.o
>  obj-$(CONFIG_GPIO_BASIC_MMIO)	+= basic_mmio_gpio.o

The line above can be removed.  GPIO_BASIC_MMIO selects GPIO_BASIC_MMIO_CORE.

>  obj-$(CONFIG_GPIO_LANGWELL)	+= langwell_gpio.o
>  obj-$(CONFIG_GPIO_MAX730X)	+= max730x.o
> diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
> index b2ec45f..6b1c6e5 100644
> --- a/drivers/gpio/basic_mmio_gpio.c
> +++ b/drivers/gpio/basic_mmio_gpio.c

[snip]

> +static int __devinit bgpio_pdev_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct resource *r;
> +	void __iomem *dat;
> +	void __iomem *set;
> +	void __iomem *clr;
> +	void __iomem *dirout;
> +	void __iomem *dirin;
> +	unsigned long sz;
> +	bool be;
> +	int err;
> +	struct bgpio_chip *bgc;
> +	struct bgpio_pdata *pdata = dev_get_platdata(dev);
> +
> +	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dat");
> +	if (!r)
> +		return -EINVAL;
> +
> +	sz = resource_size(r);
> +
> +	dat = bgpio_map(pdev, "dat", sz, &err);
> +	if (!dat)
> +		return err ? err : -EINVAL;
> +
> +	set = bgpio_map(pdev, "set", sz, &err);
> +	if (err)
> +		return err;
> +
> +	clr = bgpio_map(pdev, "clr", sz, &err);
> +	if (err)
> +		return err;
> +
> +	dirout = bgpio_map(pdev, "dirout", sz, &err);
> +	if (err)
> +		return err;
> +
> +	dirin = bgpio_map(pdev, "dirin", sz, &err);
> +	if (err)
> +		return err;
> +
> +	be = !strcmp(platform_get_device_id(pdev)->name, "basic-mmio-gpio-be");
> +
> +	bgc = devm_kzalloc(&pdev->dev, sizeof(*bgc), GFP_KERNEL);
> +	if (!bgc)
> +		return -ENOMEM;
> +
> +	err = bgpio_init(bgc, dev, sz, dat, set, clr, dirout, dirin, be);
> +	if (err)
> +		return err;
> +
> +	if (pdata) {
> +		bgc->gc.base = pdata->base;
> +		if (pdata->ngpio > 0)
> +			bgc->gc.ngpio = pdata->ngpio;
> +	}
> +
> +	platform_set_drvdata(pdev, bgc);
> +
> +	return 0;
> +}

Unless I missed it, the probe should end by actually adding the gpiochip:

-	return 0;
+	return gpiochip_add(&bgc->gc);

Regards,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
