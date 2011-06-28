Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab1F1XVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 19:21:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752733Ab1F1XVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 19:21:09 -0400
Date: Tue, 28 Jun 2011 16:20:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] backlight: add ams369fg06 amoled driver
Message-Id: <20110628162054.b341a5c9.akpm@linux-foundation.org>
In-Reply-To: <1309246977-6644-1-git-send-email-jg1.han@samsung.com>
References: <1309246977-6644-1-git-send-email-jg1.han@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jun 2011 16:42:57 +0900
Jingoo Han <jg1.han@samsung.com> wrote:

> This patch adds ams369fg06 amoled panel driver. The ams369fg06
> amoled panel (480 x 800) driver uses 3-wired SPI inteface.
> The brightness can be controlled by gamma setting of amoled panel.
> 
>
> ...
>
> +
> +#define POWER_IS_ON(pwr)	((pwr) <= FB_BLANK_NORMAL)

This could have been implemented as a regular lower-case C function. 
They're better than macros.

> +struct ams369fg06 {
> +	struct device			*dev;
> +	struct spi_device		*spi;
> +	unsigned int			power;
> +	struct lcd_device		*ld;
> +	struct backlight_device		*bd;
> +	struct lcd_platform_data	*lcd_pd;
> +};
> +
> +const unsigned short SEQ_DISPLAY_ON[] = {
> +	0x14, 0x03,
> +	ENDDEF, 0x0000
> +};
> +
> +const unsigned short SEQ_DISPLAY_OFF[] = {
> +	0x14, 0x00,
> +	ENDDEF, 0x0000
> +};
> +
> +const unsigned short SEQ_STAND_BY_ON[] = {
> +	0x1D, 0xA1,
> +	SLEEPMSEC, 200,
> +	ENDDEF, 0x0000
> +};
> +
> +const unsigned short SEQ_STAND_BY_OFF[] = {
> +	0x1D, 0xA0,
> +	SLEEPMSEC, 250,
> +	ENDDEF, 0x0000
> +};
> +
> +const unsigned short SEQ_SETTING[] = {

The patch adds lots of globally-scoped symbols, such as the above. 
There are others, too.  Please go through it and make as many things
static as possible.

It's odd that these symbols are all-uppercase.  The reader will expect
them to be cpp macros, but they aren't.  I suggest they be made
lower-case.

>
> ...
>
> +static int ams369fg06_panel_send_sequence(struct ams369fg06 *lcd,
> +	const unsigned short *wbuf)
> +{
> +	int ret = 0, i = 0;
> +
> +	while ((wbuf[i] & DEFMASK) != ENDDEF) {
> +		if ((wbuf[i] & DEFMASK) != SLEEPMSEC) {
> +			ret = ams369fg06_spi_write(lcd, wbuf[i], wbuf[i+1]);
> +			if (ret)
> +				break;
> +		} else
> +			udelay(wbuf[i+1]*1000);

mdelay()

> +		i += 2;
> +	}
> +
> +	return ret;
> +}
> +
>
> ...
>
> +static int ams369fg06_gamma_ctl(struct ams369fg06 *lcd, int brightness)
> +{
> +	int ret = 0;
> +	int gamma = 0;
> +
> +	if ((brightness >= 0) && (brightness <= 50))
> +		gamma = 0;
> +	else if ((brightness > 50) && (brightness <= 100))
> +		gamma = 1;
> +	else if ((brightness > 100) && (brightness <= 150))
> +		gamma = 2;
> +	else if ((brightness > 150) && (brightness <= 200))
> +		gamma = 3;
> +	else if ((brightness > 200) && (brightness <= 255))
> +		gamma = 4;

gcc has a

	switch (foo) {
	case 0..50:
	case 51..100:

feature.  But I wouldn't really suggest that you use it ;)

> +	ret = _ams369fg06_gamma_ctl(lcd, gamma_table.gamma_22_table[gamma]);
> +
> +	return ret;
> +}
> +
> +static int ams369fg06_ldi_init(struct ams369fg06 *lcd)
> +{
> +	int ret, i;
> +	const unsigned short *init_seq[] = {
> +		SEQ_SETTING,
> +		SEQ_STAND_BY_OFF,
> +	};

Please consider making things like this static also.  Probably the
compiler is already doing this internally.  If it isn't doing this then
the array gets needlessly assembled on the stack each time the function
is called!


> +	for (i = 0; i < ARRAY_SIZE(init_seq); i++) {
> +		ret = ams369fg06_panel_send_sequence(lcd, init_seq[i]);
> +		if (ret)
> +			break;
> +	}
> +
> +	return ret;
> +}
> +
>
> ...
>
> +static int __init ams369fg06_probe(struct spi_device *spi)
> +{
> +	int ret = 0;
> +	struct ams369fg06 *lcd = NULL;
> +	struct lcd_device *ld = NULL;
> +	struct backlight_device *bd = NULL;
> +
> +	lcd = kzalloc(sizeof(struct ams369fg06), GFP_KERNEL);
> +	if (!lcd)
> +		return -ENOMEM;
> +
> +	/* ams369fg06 lcd panel uses 3-wire 16bits SPI Mode. */
> +	spi->bits_per_word = 16;
> +
> +	ret = spi_setup(spi);
> +	if (ret < 0) {
> +		dev_err(&spi->dev, "spi setup failed.\n");
> +		goto out_free_lcd;
> +	}
> +
> +	lcd->spi = spi;
> +	lcd->dev = &spi->dev;
> +
> +	lcd->lcd_pd = (struct lcd_platform_data *)spi->dev.platform_data;

This is an unneeed and undesirable cast of void*.

> +	if (!lcd->lcd_pd) {
> +		dev_err(&spi->dev, "platform data is NULL\n");
> +		goto out_free_lcd;
> +	}
> +
> +	ld = lcd_device_register("ams369fg06", &spi->dev, lcd,
> +		&ams369fg06_lcd_ops);
> +	if (IS_ERR(ld)) {
> +		ret = PTR_ERR(ld);
> +		goto out_free_lcd;
> +	}
> +
> +	lcd->ld = ld;
> +
> +	bd = backlight_device_register("ams369fg06-bl", &spi->dev, lcd,
> +		&ams369fg06_backlight_ops, NULL);
> +	if (IS_ERR(bd)) {
> +		ret =  PTR_ERR(bd);
> +		goto out_lcd_unregister;
> +	}
> +
> +	bd->props.max_brightness = MAX_BRIGHTNESS;
> +	bd->props.brightness = DEFAULT_BRIGHTNESS;
> +	bd->props.type = BACKLIGHT_RAW;
> +	lcd->bd = bd;
> +
> +	if (!lcd->lcd_pd->lcd_enabled) {
> +		/*
> +		 * if lcd panel was off from bootloader then
> +		 * current lcd status is powerdown and then
> +		 * it enables lcd panel.
> +		 */
> +		lcd->power = FB_BLANK_POWERDOWN;
> +
> +		ams369fg06_power(lcd, FB_BLANK_UNBLANK);
> +	} else
> +		lcd->power = FB_BLANK_UNBLANK;
> +
> +	dev_set_drvdata(&spi->dev, lcd);
> +
> +	dev_info(&spi->dev, "ams369fg06 panel driver has been probed.\n");
> +
> +	return 0;
> +
> +out_lcd_unregister:
> +	lcd_device_unregister(ld);
> +out_free_lcd:
> +	kfree(lcd);
> +	return ret;
> +}
> +
>
> ...
>
> --- /dev/null
> +++ b/drivers/video/backlight/ams369fg06_gamma.h
> @@ -0,0 +1,61 @@
> +/*
> + * Gamma level definitions.
> + *
> + * Copyright (c) 2011 Samsung Electronics
> + * Jingoo Han <jg1.han@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> +*/
> +
> +#ifndef _AMS369FG06_BRIGHTNESS_H
> +#define _AMS369FG06_BRIGHTNESS_H
> +
> +#define MAX_GAMMA_LEVEL		5
> +#define GAMMA_TABLE_COUNT	21
> +
> +/* gamma value: 2.2 */
> +static const unsigned int ams369fg06_22_250[] = {
> +	0x00, 0x3f, 0x2a, 0x27, 0x27, 0x1f, 0x44,
> +	0x00, 0x00, 0x17, 0x24, 0x26, 0x1f, 0x43,
> +	0x00, 0x3f, 0x2a, 0x25, 0x24, 0x1b, 0x5c,
> +};
> +
> +static const unsigned int ams369fg06_22_200[] = {
> +	0x00, 0x3f, 0x28, 0x29, 0x27, 0x21, 0x3e,
> +	0x00, 0x00, 0x10, 0x25, 0x27, 0x20, 0x3d,
> +	0x00, 0x3f, 0x28, 0x27, 0x25, 0x1d, 0x53,
> +};
> +
> +static const unsigned int ams369fg06_22_150[] = {
> +	0x00, 0x3f, 0x2d, 0x29, 0x28, 0x23, 0x37,
> +	0x00, 0x00, 0x0b, 0x25, 0x28, 0x22, 0x36,
> +	0x00, 0x3f, 0x2b, 0x28, 0x26, 0x1f, 0x4a,
> +};
> +
> +static const unsigned int ams369fg06_22_100[] = {
> +	0x00, 0x3f, 0x30, 0x2a, 0x2b, 0x24, 0x2f,
> +	0x00, 0x00, 0x00, 0x25, 0x29, 0x24, 0x2e,
> +	0x00, 0x3f, 0x2f, 0x29, 0x29, 0x21, 0x3f,
> +};
> +
> +static const unsigned int ams369fg06_22_50[] = {
> +	0x00, 0x3f, 0x3c, 0x2c, 0x2d, 0x27, 0x24,
> +	0x00, 0x00, 0x00, 0x22, 0x2a, 0x27, 0x23,
> +	0x00, 0x3f, 0x3b, 0x2c, 0x2b, 0x24, 0x31,
> +};
> +
> +struct ams369fg06_gamma {
> +	unsigned int *gamma_22_table[MAX_GAMMA_LEVEL];
> +};
> +
> +struct ams369fg06_gamma gamma_table = {
> +	.gamma_22_table[0] = (unsigned int *)&ams369fg06_22_50,
> +	.gamma_22_table[1] = (unsigned int *)&ams369fg06_22_100,
> +	.gamma_22_table[2] = (unsigned int *)&ams369fg06_22_150,
> +	.gamma_22_table[3] = (unsigned int *)&ams369fg06_22_200,
> +	.gamma_22_table[4] = (unsigned int *)&ams369fg06_22_250,
> +};

This is a bad idea, IMO.  If this header file is included in more than
one .c file then each .c file gets its own copy of the data!  Unless
the compiler and linker are being very clever, whcih they might be
nowadays.

But we shouldn't depend on that, and it makes no sense to put this info
in a header file, because that header file will never be used from more
than one .c file.

IOW, this stuff should be moved into the .c file.

