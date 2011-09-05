Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab1IESrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 14:47:04 -0400
Received: from smtp-out-051.synserver.de ([212.40.185.51]:1083 "HELO
	smtp-out-049.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1751602Ab1IESqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 14:46:51 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 5786
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, device-drivers-devel@blackfin.uclinux.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Scott Jiang <scott.jiang.linux@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 2/2] ASoC: ad193x: Setup regmap read and write flag masks for SPI
Date: Mon,  5 Sep 2011 20:46:33 +0200
Message-Id: <1315248393-31791-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1315248393-31791-1-git-send-email-lars@metafoo.de>
References: <1315248393-31791-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently register read-back for the ad193x is broken, because it expects bit 0
of the upper byte to be set to indicate a read operation, while the regmap
default for SPI is to use bit 7.

This patch also addresses another oddity of the device. There are SPI and I2C
versions of this codec. In both cases the registers are 8-bit wide and numbered
from 0x0 to 0x10, but in the SPI case there is also a so called
'global address' which is prefixed in-front of the register address. The global
address mimics I2C behaviour and includes a static device address the and the
read/write flag. This basically extends the register address to an 16-bit value
numbered from 0x800 to 0x810. These are the register numbers which are
currently used by the driver. This works, because I2C will ignore the upper
8 bits of the register, but it is still a bit confusing, as there are no such
register numbers in the I2C case.

The approach taken by this patch is to number the registers from 0x00 to 0x10
and encode the global address for SPI mode into the read and write flag masks.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

---
Changes since v1:
	* Setup regmap in the driver instead the ASoC core.

Scott, it would be nice if you could test these changes since I don't have a
ad1936 board here right now. But I compared the generated SPI signals with what
is in 3.1 and they look identical, so it should work.
---
 sound/soc/codecs/ad193x.c |   65 +++++++++++++++++++++++++++++++++++++-------
 sound/soc/codecs/ad193x.h |   34 ++++++++++++------------
 2 files changed, 71 insertions(+), 28 deletions(-)

diff --git a/sound/soc/codecs/ad193x.c b/sound/soc/codecs/ad193x.c
index eedb6f5..f934670 100644
--- a/sound/soc/codecs/ad193x.c
+++ b/sound/soc/codecs/ad193x.c
@@ -23,7 +23,7 @@
 
 /* codec private data */
 struct ad193x_priv {
-	enum snd_soc_control_type control_type;
+	struct regmap *regmap;
 	int sysclk;
 };
 
@@ -349,10 +349,8 @@ static int ad193x_probe(struct snd_soc_codec *codec)
 	struct snd_soc_dapm_context *dapm = &codec->dapm;
 	int ret;
 
-	if (ad193x->control_type == SND_SOC_I2C)
-		ret = snd_soc_codec_set_cache_io(codec, 8, 8, ad193x->control_type);
-	else
-		ret = snd_soc_codec_set_cache_io(codec, 16, 8, ad193x->control_type);
+	codec->control_data = ad193x->regmap;
+	ret = snd_soc_codec_set_cache_io(codec, 0, 0, SND_SOC_REGMAP);
 	if (ret < 0) {
 		dev_err(codec->dev, "failed to set cache I/O: %d\n", ret);
 		return ret;
@@ -388,6 +386,14 @@ static struct snd_soc_codec_driver soc_codec_dev_ad193x = {
 };
 
 #if defined(CONFIG_SPI_MASTER)
+
+static const struct regmap_config ad193x_spi_regmap_config = {
+	.val_bits = 8,
+	.reg_bits = 16,
+	.read_flag_mask = 0x09,
+	.write_flag_mask = 0x08,
+};
+
 static int __devinit ad193x_spi_probe(struct spi_device *spi)
 {
 	struct ad193x_priv *ad193x;
@@ -397,20 +403,36 @@ static int __devinit ad193x_spi_probe(struct spi_device *spi)
 	if (ad193x == NULL)
 		return -ENOMEM;
 
+	ad193x->regmap = regmap_init_spi(spi, &ad193x_spi_regmap_config);
+	if (IS_ERR(ad193x->regmap)) {
+		ret = PTR_ERR(ad193x->regmap);
+		goto err_free;
+	}
+
 	spi_set_drvdata(spi, ad193x);
-	ad193x->control_type = SND_SOC_SPI;
 
 	ret = snd_soc_register_codec(&spi->dev,
 			&soc_codec_dev_ad193x, &ad193x_dai, 1);
 	if (ret < 0)
-		kfree(ad193x);
+		goto err_regmap_exit;
+
+	return 0;
+
+err_regmap_exit:
+	regmap_exit(ad193x->regmap);
+err_free:
+	kfree(ad193x);
+
 	return ret;
 }
 
 static int __devexit ad193x_spi_remove(struct spi_device *spi)
 {
+	struct ad193x_priv *ad193x = spi_get_drvdata(spi);
+
 	snd_soc_unregister_codec(&spi->dev);
-	kfree(spi_get_drvdata(spi));
+	regmap_exit(ad193x->regmap);
+	kfree(ad193x);
 	return 0;
 }
 
@@ -425,6 +447,12 @@ static struct spi_driver ad193x_spi_driver = {
 #endif
 
 #if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
+
+static const struct regmap_config ad193x_i2c_regmap_config = {
+	.val_bits = 8,
+	.reg_bits = 8,
+};
+
 static const struct i2c_device_id ad193x_id[] = {
 	{ "ad1936", 0 },
 	{ "ad1937", 0 },
@@ -442,20 +470,35 @@ static int __devinit ad193x_i2c_probe(struct i2c_client *client,
 	if (ad193x == NULL)
 		return -ENOMEM;
 
+	ad193x->regmap = regmap_init_i2c(client, &ad193x_i2c_regmap_config);
+	if (IS_ERR(ad193x->regmap)) {
+		ret = PTR_ERR(ad193x->regmap);
+		goto err_free;
+	}
+
 	i2c_set_clientdata(client, ad193x);
-	ad193x->control_type = SND_SOC_I2C;
 
 	ret =  snd_soc_register_codec(&client->dev,
 			&soc_codec_dev_ad193x, &ad193x_dai, 1);
 	if (ret < 0)
-		kfree(ad193x);
+		goto err_regmap_exit;
+
+	return 0;
+
+err_regmap_exit:
+	regmap_exit(ad193x->regmap);
+err_free:
+	kfree(ad193x);
 	return ret;
 }
 
 static int __devexit ad193x_i2c_remove(struct i2c_client *client)
 {
+	struct ad193x_priv *ad193x = i2c_get_clientdata(client);
+
 	snd_soc_unregister_codec(&client->dev);
-	kfree(i2c_get_clientdata(client));
+	regmap_exit(ad193x->regmap);
+	kfree(ad193x);
 	return 0;
 }
 
diff --git a/sound/soc/codecs/ad193x.h b/sound/soc/codecs/ad193x.h
index cccc2e8..536e5f2 100644
--- a/sound/soc/codecs/ad193x.h
+++ b/sound/soc/codecs/ad193x.h
@@ -9,20 +9,20 @@
 #ifndef __AD193X_H__
 #define __AD193X_H__
 
-#define AD193X_PLL_CLK_CTRL0    0x800
+#define AD193X_PLL_CLK_CTRL0    0x00
 #define AD193X_PLL_POWERDOWN           0x01
 #define AD193X_PLL_INPUT_MASK   (~0x6)
 #define AD193X_PLL_INPUT_256    (0 << 1)
 #define AD193X_PLL_INPUT_384    (1 << 1)
 #define AD193X_PLL_INPUT_512    (2 << 1)
 #define AD193X_PLL_INPUT_768    (3 << 1)
-#define AD193X_PLL_CLK_CTRL1    0x801
-#define AD193X_DAC_CTRL0        0x802
+#define AD193X_PLL_CLK_CTRL1    0x01
+#define AD193X_DAC_CTRL0        0x02
 #define AD193X_DAC_POWERDOWN           0x01
 #define AD193X_DAC_SERFMT_MASK		0xC0
 #define AD193X_DAC_SERFMT_STEREO	(0 << 6)
 #define AD193X_DAC_SERFMT_TDM		(1 << 6)
-#define AD193X_DAC_CTRL1        0x803
+#define AD193X_DAC_CTRL1        0x03
 #define AD193X_DAC_2_CHANNELS   0
 #define AD193X_DAC_4_CHANNELS   1
 #define AD193X_DAC_8_CHANNELS   2
@@ -33,11 +33,11 @@
 #define AD193X_DAC_BCLK_MASTER  (1 << 5)
 #define AD193X_DAC_LEFT_HIGH    (1 << 3)
 #define AD193X_DAC_BCLK_INV     (1 << 7)
-#define AD193X_DAC_CTRL2        0x804
+#define AD193X_DAC_CTRL2        0x04
 #define AD193X_DAC_WORD_LEN_SHFT        3
 #define AD193X_DAC_WORD_LEN_MASK        0x18
 #define AD193X_DAC_MASTER_MUTE  1
-#define AD193X_DAC_CHNL_MUTE    0x805
+#define AD193X_DAC_CHNL_MUTE    0x05
 #define AD193X_DACL1_MUTE       0
 #define AD193X_DACR1_MUTE       1
 #define AD193X_DACL2_MUTE       2
@@ -46,28 +46,28 @@
 #define AD193X_DACR3_MUTE       5
 #define AD193X_DACL4_MUTE       6
 #define AD193X_DACR4_MUTE       7
-#define AD193X_DAC_L1_VOL       0x806
-#define AD193X_DAC_R1_VOL       0x807
-#define AD193X_DAC_L2_VOL       0x808
-#define AD193X_DAC_R2_VOL       0x809
-#define AD193X_DAC_L3_VOL       0x80a
-#define AD193X_DAC_R3_VOL       0x80b
-#define AD193X_DAC_L4_VOL       0x80c
-#define AD193X_DAC_R4_VOL       0x80d
-#define AD193X_ADC_CTRL0        0x80e
+#define AD193X_DAC_L1_VOL       0x06
+#define AD193X_DAC_R1_VOL       0x07
+#define AD193X_DAC_L2_VOL       0x08
+#define AD193X_DAC_R2_VOL       0x09
+#define AD193X_DAC_L3_VOL       0x0a
+#define AD193X_DAC_R3_VOL       0x0b
+#define AD193X_DAC_L4_VOL       0x0c
+#define AD193X_DAC_R4_VOL       0x0d
+#define AD193X_ADC_CTRL0        0x0e
 #define AD193X_ADC_POWERDOWN           0x01
 #define AD193X_ADC_HIGHPASS_FILTER	1
 #define AD193X_ADCL1_MUTE 		2
 #define AD193X_ADCR1_MUTE 		3
 #define AD193X_ADCL2_MUTE 		4
 #define AD193X_ADCR2_MUTE 		5
-#define AD193X_ADC_CTRL1        0x80f
+#define AD193X_ADC_CTRL1        0x0f
 #define AD193X_ADC_SERFMT_MASK		0x60
 #define AD193X_ADC_SERFMT_STEREO	(0 << 5)
 #define AD193X_ADC_SERFMT_TDM		(1 << 5)
 #define AD193X_ADC_SERFMT_AUX		(2 << 5)
 #define AD193X_ADC_WORD_LEN_MASK	0x3
-#define AD193X_ADC_CTRL2        0x810
+#define AD193X_ADC_CTRL2        0x10
 #define AD193X_ADC_2_CHANNELS   0
 #define AD193X_ADC_4_CHANNELS   1
 #define AD193X_ADC_8_CHANNELS   2
-- 
1.7.2.5

