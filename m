Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab2EXNlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 09:41:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38454 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab2EXNlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 09:41:49 -0400
From: Marc Reilly <marc@cpdesign.com.au>
Reply-To: marc@cpdesign.com.au
Organization: Creative Product Design
To: Fabio Estevam <festevam@gmail.com>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
Date: Thu, 24 May 2012 23:38:41 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.11-desktop; KDE/4.6.0; x86_64; ; )
Cc: Shawn Guo <shawn.guo@freescale.com>,
        "Uwe =?utf-8?q?Kleine-K=C3=B6nig?=" <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Philippe =?utf-8?q?R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <201205221053.21792.marc@cpdesign.com.au> <201205241908.38278.marc@cpdesign.com.au> <CAOMZO5AYCSVT=s=rB3xPkz5SYEQQZ9q7f=rFbTbJkkVPk7Y7Vw@mail.gmail.com>
In-Reply-To: <CAOMZO5AYCSVT=s=rB3xPkz5SYEQQZ9q7f=rFbTbJkkVPk7Y7Vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205242338.41420.marc@cpdesign.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Yes, you are right. buf_size should be changed as you suggests so that
> it can be 4 bytes instead of 3.
> 
> This is the patch I am using now:

I just sent something similar before I saw this.

> 
> diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
> index 0bcda48..6beef98 100644
> --- a/drivers/base/regmap/regmap.c
> +++ b/drivers/base/regmap/regmap.c
> @@ -246,11 +246,12 @@ struct regmap *regmap_init(struct device *dev,
>  		map->lock = regmap_lock_mutex;
>  		map->unlock = regmap_unlock_mutex;
>  	}
> -	map->format.buf_size = (config->reg_bits + config->val_bits) / 8;
>  	map->format.reg_bytes = DIV_ROUND_UP(config->reg_bits, 8);
>  	map->format.pad_bytes = config->pad_bits / 8;
>  	map->format.val_bytes = DIV_ROUND_UP(config->val_bits, 8);
> -	map->format.buf_size += map->format.pad_bytes;
> +	map->format.buf_size = (config->reg_bits + config->val_bits +
> +						(config->pad_bits % 8)) / 8;
> +

This won't work when pad bits is > 8


>  	map->reg_shift = config->pad_bits % 8;
>  	if (config->reg_stride)
>  		map->reg_stride = config->reg_stride;
> diff --git a/drivers/mfd/mc13xxx-spi.c b/drivers/mfd/mc13xxx-spi.c
> index 3fcdab3..4c14dfc 100644
> --- a/drivers/mfd/mc13xxx-spi.c
> +++ b/drivers/mfd/mc13xxx-spi.c
> @@ -49,6 +49,8 @@ static struct regmap_config mc13xxx_regmap_spi_config = {
>  	.reg_bits = 7,
>  	.pad_bits = 1,
>  	.val_bits = 24,
> +	.write_flag_mask = 0x80,
> +	.read_flag_mask = 0x00,
> 
>  	.max_register = MC13XXX_NUMREGS,
> 
> @@ -73,7 +75,6 @@ static int mc13xxx_spi_probe(struct spi_device *spi)
> 
>  	dev_set_drvdata(&spi->dev, mc13xxx);
>  	spi->mode = SPI_MODE_0 | SPI_CS_HIGH;
> -	spi->bits_per_word = 32;
> 
>  	mc13xxx->dev = &spi->dev;
>  	mutex_init(&mc13xxx->lock);
> 
> , which is still not allowing me to read the SPI registers correctly.
> 
> Have I missed anything?


If I had something to test with, I'd be looking at the parameters of 
"regmap_spi_read" in drivers/base/regmap/regmap-spi.c . Verify reg_size is 1 
(8bits) and val_size is 3. Check also what the reg address is. The first read 
when the mc13xxx is probed is register 46, so would expect reg to be 0x5C.

> 
> Still reading 0x810 for all registers (0x810000 is the value of
> register 0 , btw).


This could mean that all the registers are being sent as 0 and the value is 
shifted by 12 bits. (which is a bit weird). It's also a strange that Shawn's 
board seems to work.

Do you have any other devices on that SPI that you can verify are working 
correctly? (you said it worked from the bootloader, I'm running out of 
ideas... :| )


Cheers,
Marc
