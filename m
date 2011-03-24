Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201Ab1CXKUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 06:20:55 -0400
Received: from router.aksignal.cz ([188.175.113.102]:48507 "EHLO
	router.aksignal.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762Ab1CXKUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 06:20:53 -0400
Message-ID: <4D8B1AFD.5060508@aksignal.cz>
Date: Thu, 24 Mar 2011 11:20:45 +0100
From: =?ISO-8859-2?Q?Prchal_Ji=F8=ED?= <jiri.prchal@aksignal.cz>
Organization: AK signal Brno
User-Agent: Mozilla/5.0 (X11; U; Linux i686; cs-CZ; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Lightning/1.0b1 Thunderbird/3.0.11
MIME-Version: 1.0
To: alsa-devel@vger.kernel.org, alsa-devel@alsa-project.org,
        vbarinov@embeddedalley.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ALSA: ASoc: TLV320AIC3X: ad SPI and clock on GPIO2 or
 BCLK
References: <1300949648-15078-1-git-send-email-horms@verge.net.au> <1300949648-15078-2-git-send-email-horms@verge.net.au>
In-Reply-To: <1300949648-15078-2-git-send-email-horms@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
this patch ads SPI communication for codecs TLV320AIC3X and clock input on GPIO2 or BCLK.
Tested on TLV320AIC3106 and AT91SAM9260.
TODO: Set the model in SPI probe the right way. I don't know how.
This codec communicates on SPI in 1st byte: 7 MSB is register address, 1 LSB is read/write, 2nd byte data. For this
reason there is new functions in soc-cache.c snd_soc_7_8_*.

Kernel version: 2.6.38
Signed-off-by: Jiri Prchal <jiri.prchal@aksignal.cz>
---

diff -uprN -X linux-2.6.38-vanilla/Documentation/dontdiff linux-2.6.38-vanilla/sound/soc/codecs/Kconfig
/home/prchal/arm/fw-cdu/linux/linux-2.6.38/sound/soc/codecs/Kconfig
--- linux-2.6.38-vanilla/sound/soc/codecs/Kconfig	2011-03-15 02:20:32.000000000 +0100
+++ /home/prchal/arm/fw-cdu/linux/linux-2.6.38/sound/soc/codecs/Kconfig	2011-03-17 08:37:14.997500191 +0100
@@ -37,7 +37,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_STAC9766 if SND_SOC_AC97_BUS
 	select SND_SOC_TLV320AIC23 if I2C
 	select SND_SOC_TLV320AIC26 if SPI_MASTER
-	select SND_SOC_TLV320AIC3X if I2C
+	select SND_SOC_TLV320AIC3X if SND_SOC_I2C_AND_SPI
 	select SND_SOC_TPA6130A2 if I2C
 	select SND_SOC_TLV320DAC33 if I2C
 	select SND_SOC_TWL4030 if TWL4030_CORE
@@ -118,7 +118,7 @@ config SND_SOC_AD1980

 config SND_SOC_AD73311
 	tristate
-
+
 config SND_SOC_ADS117X
 	tristate

diff -uprN -X linux-2.6.38-vanilla/Documentation/dontdiff linux-2.6.38-vanilla/sound/soc/codecs/tlv320aic3x.c
/home/prchal/arm/fw-cdu/linux/linux-2.6.38/sound/soc/codecs/tlv320aic3x.c
--- linux-2.6.38-vanilla/sound/soc/codecs/tlv320aic3x.c	2011-03-15 02:20:32.000000000 +0100
+++ /home/prchal/arm/fw-cdu/linux/linux-2.6.38/sound/soc/codecs/tlv320aic3x.c	2011-03-24 09:34:58.769370117 +0100
@@ -2,7 +2,9 @@
  * ALSA SoC TLV320AIC3X codec driver
  *
  * Author:      Vladimir Barinov, <vbarinov@embeddedalley.com>
+ *              Jiri Prchal, <jiri.prchal@aksignal.cz
  * Copyright:   (C) 2007 MontaVista Software, Inc., <source@mvista.com>
+ *              (C) 2011 AK signal Brno
  *
  * Based on sound/soc/codecs/wm8753.c by Liam Girdwood
  *
@@ -42,6 +44,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/spi/spi.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
@@ -984,6 +987,13 @@ static int aic3x_set_dai_sysclk(struct s
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
 	struct aic3x_priv *aic3x = snd_soc_codec_get_drvdata(codec);
+	u8 data;
+
+	/* set external clock on GPIO2 or BCLK */
+	data = snd_soc_read(codec, AIC3X_CLKGEN_CTRL_REG);
+	data &= 0x0f;
+	data |= ((clk_id << PLLCLK_IN_SHIFT) | (clk_id << CLKDIV_IN_SHIFT));
+	snd_soc_write(codec, AIC3X_CLKGEN_CTRL_REG, data);

 	aic3x->sysclk = freq;
 	return 0;
@@ -1371,9 +1381,12 @@ static int aic3x_probe(struct snd_soc_co
 	aic3x->codec = codec;
 	codec->dapm.idle_bias_off = 1;

-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, aic3x->control_type);
+	if (aic3x->control_type == SND_SOC_I2C)
+		ret = snd_soc_codec_set_cache_io(codec, 8, 8, aic3x->control_type);
+	else
+		ret = snd_soc_codec_set_cache_io(codec, 7, 8, aic3x->control_type);
 	if (ret != 0) {
-		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
+		dev_err(codec->dev, "failed to set cache I/O: %d\n", ret);
 		return ret;
 	}

@@ -1472,6 +1485,54 @@ static struct snd_soc_codec_driver soc_c
 	.resume = aic3x_resume,
 };

+#if defined(CONFIG_SPI_MASTER)
+static int aic3x_spi_probe(struct spi_device *spi)
+{
+	struct aic3x_pdata *pdata = spi->dev.platform_data;
+	struct aic3x_priv *aic3x;
+	int ret;
+
+	aic3x = kzalloc(sizeof(struct aic3x_priv), GFP_KERNEL);
+	if (aic3x == NULL) {
+		dev_err(&spi->dev, "failed to create private data\n");
+		return -ENOMEM;
+	}
+
+	aic3x->control_type = SND_SOC_SPI;
+	spi_set_drvdata(spi, aic3x);
+
+	if (pdata) {
+		aic3x->gpio_reset = pdata->gpio_reset;
+		aic3x->setup = pdata->setup;
+	} else {
+		aic3x->gpio_reset = -1;
+	}
+
+	aic3x->model = AIC3X_MODEL_3X;
+
+	ret = snd_soc_register_codec(&spi->dev, &soc_codec_dev_aic3x, &aic3x_dai, 1);
+	if (ret < 0)
+		kfree(aic3x);
+	return ret;
+}
+
+static int __devexit aic3x_spi_remove(struct spi_device *spi)
+{
+	snd_soc_unregister_codec(&spi->dev);
+	kfree(spi_get_drvdata(spi));
+	return 0;
+}
+
+static struct spi_driver aic3x_spi_driver = {
+	.driver = {
+		.name	= "tlv320aic3x-codec",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= aic3x_spi_probe,
+	.remove		= __devexit_p(aic3x_spi_remove),
+};
+#endif /* CONFIG_SPI_MASTER */
+
 #if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
 /*
  * AIC3X 2 wire address can be up to 4 devices with device addresses
@@ -1557,6 +1618,13 @@ static int __init aic3x_modinit(void)
 		       ret);
 	}
 #endif
+#if defined(CONFIG_SPI_MASTER)
+	ret = spi_register_driver(&aic3x_spi_driver);
+	if (ret != 0) {
+		printk(KERN_ERR "Failed to register AIC3X SPI driver: %d\n",
+		       ret);
+	}
+#endif
 	return ret;
 }
 module_init(aic3x_modinit);
@@ -1566,6 +1634,9 @@ static void __exit aic3x_exit(void)
 #if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
 	i2c_del_driver(&aic3x_i2c_driver);
 #endif
+#if defined(CONFIG_SPI_MASTER)
+	spi_unregister_driver(&aic3x_spi_driver);
+#endif
 }
 module_exit(aic3x_exit);

diff -uprN -X linux-2.6.38-vanilla/Documentation/dontdiff linux-2.6.38-vanilla/sound/soc/codecs/tlv320aic3x.h
/home/prchal/arm/fw-cdu/linux/linux-2.6.38/sound/soc/codecs/tlv320aic3x.h
--- linux-2.6.38-vanilla/sound/soc/codecs/tlv320aic3x.h	2011-03-15 02:20:32.000000000 +0100
+++ /home/prchal/arm/fw-cdu/linux/linux-2.6.38/sound/soc/codecs/tlv320aic3x.h	2011-03-22 13:37:54.751566089 +0100
@@ -178,6 +178,13 @@
 #define PLL_CLKIN_SHIFT		4
 #define MCLK_SOURCE		0x0
 #define PLL_CLKDIV_SHIFT	0
+#define PLLCLK_IN_SHIFT		4
+#define CLKDIV_IN_SHIFT		6
+/* clock in source */
+#define CLKIN_MCLK		0
+#define CLKIN_GPIO2		1
+#define CLKIN_BCLK		2
+

 /* Software reset register bits */
 #define SOFT_RESET		0x80
diff -uprN -X linux-2.6.38-vanilla/Documentation/dontdiff linux-2.6.38-vanilla/sound/soc/soc-cache.c
/home/prchal/arm/fw-cdu/linux/linux-2.6.38/sound/soc/soc-cache.c
--- linux-2.6.38-vanilla/sound/soc/soc-cache.c	2011-03-15 02:20:32.000000000 +0100
+++ /home/prchal/arm/fw-cdu/linux/linux-2.6.38/sound/soc/soc-cache.c	2011-03-24 09:23:00.984373772 +0100
@@ -99,6 +99,58 @@ static int snd_soc_4_12_spi_write(void *
 #define snd_soc_4_12_spi_write NULL
 #endif

+/* special functions for codecs with 7 bit register address and LSB read/write (like TLV320AIC3X) */
+static unsigned int snd_soc_7_8_read(struct snd_soc_codec *codec,
+				     unsigned int reg)
+{
+	int ret;
+	unsigned int val;
+
+	if (reg >= codec->driver->reg_cache_size ||
+		snd_soc_codec_volatile_register(codec, reg)) {
+			if (codec->cache_only)
+				return -1;
+
+			BUG_ON(!codec->hw_read);
+			return codec->hw_read(codec, ((reg << 1) | 1));
+	}
+
+	ret = snd_soc_cache_read(codec, reg, &val);
+	if (ret < 0)
+		return -1;
+	return val;
+}
+
+static int snd_soc_7_8_write(struct snd_soc_codec *codec, unsigned int reg,
+			     unsigned int value)
+{
+	u8 data[2];
+	int ret;
+
+	data[0] = (reg << 1);
+	data[1] = value;
+
+	if (!snd_soc_codec_volatile_register(codec, reg) &&
+		reg < codec->driver->reg_cache_size) {
+		ret = snd_soc_cache_write(codec, reg, value);
+		if (ret < 0)
+			return -1;
+	}
+
+	if (codec->cache_only) {
+		codec->cache_sync = 1;
+		return 0;
+	}
+
+	ret = codec->hw_write(codec->control_data, data, 2);
+	if (ret == 2)
+		return 0;
+	if (ret < 0)
+		return ret;
+	else
+		return -EIO;
+}
+
 static unsigned int snd_soc_7_9_read(struct snd_soc_codec *codec,
 				     unsigned int reg)
 {
@@ -661,6 +713,11 @@ static struct {
 		.spi_write = snd_soc_4_12_spi_write,
 	},
 	{
+		.addr_bits = 7, .data_bits = 8,
+		.write = snd_soc_7_8_write, .read = snd_soc_7_8_read,
+		.spi_write = snd_soc_8_8_spi_write,
+	},
+	{
 		.addr_bits = 7, .data_bits = 9,
 		.write = snd_soc_7_9_write, .read = snd_soc_7_9_read,
 		.spi_write = snd_soc_7_9_spi_write,
