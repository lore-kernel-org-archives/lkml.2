Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab2EXNBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 09:01:47 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58479 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab2EXNBq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 09:01:46 -0400
MIME-Version: 1.0
In-Reply-To: <201205241908.38278.marc@cpdesign.com.au>
References: <201205221053.21792.marc@cpdesign.com.au>
	<20120524064635.GP3710@pengutronix.de>
	<20120524073315.GE7843@S2100-06.ap.freescale.net>
	<201205241908.38278.marc@cpdesign.com.au>
Date: Thu, 24 May 2012 10:01:43 -0300
Message-ID: <CAOMZO5AYCSVT=s=rB3xPkz5SYEQQZ9q7f=rFbTbJkkVPk7Y7Vw@mail.gmail.com>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
From: Fabio Estevam <festevam@gmail.com>
To: marc@cpdesign.com.au
Cc: Shawn Guo <shawn.guo@freescale.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        =?UTF-8?Q?Philippe_R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 6:08 AM, Marc Reilly <marc@cpdesign.com.au> wrote:

> I'm wondering about regmap_init where the buf_size is set up. I think it will
> only end up being 3 bytes. I think line 249 should be something like:
>
>        map->format.buf_size = (config->reg_bits
>                          + config->val_bits
>                                                 + (config->pad_bits % 8)) / 8;

Yes, you are right. buf_size should be changed as you suggests so that
it can be 4 bytes instead of 3.

This is the patch I am using now:

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 0bcda48..6beef98 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -246,11 +246,12 @@ struct regmap *regmap_init(struct device *dev,
 		map->lock = regmap_lock_mutex;
 		map->unlock = regmap_unlock_mutex;
 	}
-	map->format.buf_size = (config->reg_bits + config->val_bits) / 8;
 	map->format.reg_bytes = DIV_ROUND_UP(config->reg_bits, 8);
 	map->format.pad_bytes = config->pad_bits / 8;
 	map->format.val_bytes = DIV_ROUND_UP(config->val_bits, 8);
-	map->format.buf_size += map->format.pad_bytes;
+	map->format.buf_size = (config->reg_bits + config->val_bits +
+						(config->pad_bits % 8)) / 8;
+
 	map->reg_shift = config->pad_bits % 8;
 	if (config->reg_stride)
 		map->reg_stride = config->reg_stride;
diff --git a/drivers/mfd/mc13xxx-spi.c b/drivers/mfd/mc13xxx-spi.c
index 3fcdab3..4c14dfc 100644
--- a/drivers/mfd/mc13xxx-spi.c
+++ b/drivers/mfd/mc13xxx-spi.c
@@ -49,6 +49,8 @@ static struct regmap_config mc13xxx_regmap_spi_config = {
 	.reg_bits = 7,
 	.pad_bits = 1,
 	.val_bits = 24,
+	.write_flag_mask = 0x80,
+	.read_flag_mask = 0x00,

 	.max_register = MC13XXX_NUMREGS,

@@ -73,7 +75,6 @@ static int mc13xxx_spi_probe(struct spi_device *spi)

 	dev_set_drvdata(&spi->dev, mc13xxx);
 	spi->mode = SPI_MODE_0 | SPI_CS_HIGH;
-	spi->bits_per_word = 32;

 	mc13xxx->dev = &spi->dev;
 	mutex_init(&mc13xxx->lock);

, which is still not allowing me to read the SPI registers correctly.

Have I missed anything?

Still reading 0x810 for all registers (0x810000 is the value of
register 0 , btw).

Thanks,

Fabio Estevam
