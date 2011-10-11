Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab1JKXQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 19:16:35 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43512 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab1JKXQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 19:16:34 -0400
Subject: [PATCH] ASoC: da7210: convert to soc-cache
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Chen <Dajun.chen@diasemi.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 07:16:25 +0800
Message-ID: <1318374985.6115.10.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Hi Kuninori,
This patch converts da7210 to use soc-cache APIs.
I don't have this hardware, I'd appreciate if you can test this patch.

Thanks,
Axel
 sound/soc/codecs/da7210.c |  123 ++++++++++++++++----------------------------
 1 files changed, 45 insertions(+), 78 deletions(-)

diff --git a/sound/soc/codecs/da7210.c b/sound/soc/codecs/da7210.c
index 33b4823..1f30ef9 100644
--- a/sound/soc/codecs/da7210.c
+++ b/sound/soc/codecs/da7210.c
@@ -162,7 +162,6 @@ static const struct snd_kcontrol_new da7210_snd_controls[] = {
 /* Codec private data */
 struct da7210_priv {
 	enum snd_soc_control_type control_type;
-	void *control_data;
 };
 
 /*
@@ -189,50 +188,16 @@ static const u8 da7210_reg[] = {
 	0x00,						/* R88       */
 };
 
-/*
- * Read da7210 register cache
- */
-static inline u32 da7210_read_reg_cache(struct snd_soc_codec *codec, u32 reg)
-{
-	u8 *cache = codec->reg_cache;
-	BUG_ON(reg >= ARRAY_SIZE(da7210_reg));
-	return cache[reg];
-}
-
-/*
- * Write to the da7210 register space
- */
-static int da7210_write(struct snd_soc_codec *codec, u32 reg, u32 value)
-{
-	u8 *cache = codec->reg_cache;
-	u8 data[2];
-
-	BUG_ON(codec->driver->volatile_register);
-
-	data[0] = reg & 0xff;
-	data[1] = value & 0xff;
-
-	if (reg >= codec->driver->reg_cache_size)
-		return -EIO;
-
-	if (2 != codec->hw_write(codec->control_data, data, 2))
-		return -EIO;
-
-	cache[reg] = value;
-	return 0;
-}
-
-/*
- * Read from the da7210 register space.
- */
-static inline u32 da7210_read(struct snd_soc_codec *codec, u32 reg)
+static int da7210_volatile_register(struct snd_soc_codec *codec,
+				    unsigned int reg)
 {
-	if (DA7210_STATUS == reg)
-		return i2c_smbus_read_byte_data(codec->control_data, reg);
-
-	return da7210_read_reg_cache(codec, reg);
+	switch (reg) {
+	case DA7210_STATUS:
+		return 1;
+	default:
+		return 0;
+	}
 }
-
 static int da7210_startup(struct snd_pcm_substream *substream,
 			  struct snd_soc_dai *dai)
 {
@@ -271,13 +236,13 @@ static int da7210_hw_params(struct snd_pcm_substream *substream,
 	u32 fs, bypass;
 
 	/* set DAI source to Left and Right ADC */
-	da7210_write(codec, DA7210_DAI_SRC_SEL,
+	snd_soc_write(codec, DA7210_DAI_SRC_SEL,
 		     DA7210_DAI_OUT_R_SRC | DA7210_DAI_OUT_L_SRC);
 
 	/* Enable DAI */
-	da7210_write(codec, DA7210_DAI_CFG3, DA7210_DAI_OE | DA7210_DAI_EN);
+	snd_soc_write(codec, DA7210_DAI_CFG3, DA7210_DAI_OE | DA7210_DAI_EN);
 
-	dai_cfg1 = 0xFC & da7210_read(codec, DA7210_DAI_CFG1);
+	dai_cfg1 = 0xFC & snd_soc_read(codec, DA7210_DAI_CFG1);
 
 	switch (params_format(params)) {
 	case SNDRV_PCM_FORMAT_S16_LE:
@@ -290,7 +255,7 @@ static int da7210_hw_params(struct snd_pcm_substream *substream,
 		return -EINVAL;
 	}
 
-	da7210_write(codec, DA7210_DAI_CFG1, dai_cfg1);
+	snd_soc_write(codec, DA7210_DAI_CFG1, dai_cfg1);
 
 	hpf_reg = (SNDRV_PCM_STREAM_PLAYBACK == substream->stream) ?
 		DA7210_DAC_HPF : DA7210_ADC_HPF;
@@ -383,8 +348,8 @@ static int da7210_set_dai_fmt(struct snd_soc_dai *codec_dai, u32 fmt)
 	u32 dai_cfg1;
 	u32 dai_cfg3;
 
-	dai_cfg1 = 0x7f & da7210_read(codec, DA7210_DAI_CFG1);
-	dai_cfg3 = 0xfc & da7210_read(codec, DA7210_DAI_CFG3);
+	dai_cfg1 = 0x7f & snd_soc_read(codec, DA7210_DAI_CFG1);
+	dai_cfg3 = 0xfc & snd_soc_read(codec, DA7210_DAI_CFG3);
 
 	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
 	case SND_SOC_DAIFMT_CBM_CFM:
@@ -412,8 +377,8 @@ static int da7210_set_dai_fmt(struct snd_soc_dai *codec_dai, u32 fmt)
 	 */
 	dai_cfg1 |= DA7210_DAI_FLEN_64BIT;
 
-	da7210_write(codec, DA7210_DAI_CFG1, dai_cfg1);
-	da7210_write(codec, DA7210_DAI_CFG3, dai_cfg3);
+	snd_soc_write(codec, DA7210_DAI_CFG1, dai_cfg1);
+	snd_soc_write(codec, DA7210_DAI_CFG3, dai_cfg3);
 
 	return 0;
 }
@@ -452,11 +417,15 @@ static struct snd_soc_dai_driver da7210_dai = {
 static int da7210_probe(struct snd_soc_codec *codec)
 {
 	struct da7210_priv *da7210 = snd_soc_codec_get_drvdata(codec);
+	int ret;
 
 	dev_info(codec->dev, "DA7210 Audio Codec %s\n", DA7210_VERSION);
 
-	codec->control_data	= da7210->control_data;
-	codec->hw_write		= (hw_write_t)i2c_master_send;
+	ret = snd_soc_codec_set_cache_io(codec, 8, 8, da7210->control_type);
+	if (ret < 0) {
+		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
+		return ret;
+	}
 
 	/* FIXME
 	 *
@@ -473,8 +442,8 @@ static int da7210_probe(struct snd_soc_codec *codec)
 	/*
 	 * make sure that DA7210 use bypass mode before start up
 	 */
-	da7210_write(codec, DA7210_STARTUP1, 0);
-	da7210_write(codec, DA7210_PLL_DIV3,
+	snd_soc_write(codec, DA7210_STARTUP1, 0);
+	snd_soc_write(codec, DA7210_PLL_DIV3,
 		     DA7210_MCLK_RANGE_10_20_MHZ | DA7210_PLL_BYP);
 
 	/*
@@ -482,36 +451,36 @@ static int da7210_probe(struct snd_soc_codec *codec)
 	 */
 
 	/* Enable Left & Right MIC PGA and Mic Bias */
-	da7210_write(codec, DA7210_MIC_L, DA7210_MIC_L_EN | DA7210_MICBIAS_EN);
-	da7210_write(codec, DA7210_MIC_R, DA7210_MIC_R_EN);
+	snd_soc_write(codec, DA7210_MIC_L, DA7210_MIC_L_EN | DA7210_MICBIAS_EN);
+	snd_soc_write(codec, DA7210_MIC_R, DA7210_MIC_R_EN);
 
 	/* Enable Left and Right input PGA */
-	da7210_write(codec, DA7210_INMIX_L, DA7210_IN_L_EN);
-	da7210_write(codec, DA7210_INMIX_R, DA7210_IN_R_EN);
+	snd_soc_write(codec, DA7210_INMIX_L, DA7210_IN_L_EN);
+	snd_soc_write(codec, DA7210_INMIX_R, DA7210_IN_R_EN);
 
 	/* Enable Left and Right ADC */
-	da7210_write(codec, DA7210_ADC, DA7210_ADC_L_EN | DA7210_ADC_R_EN);
+	snd_soc_write(codec, DA7210_ADC, DA7210_ADC_L_EN | DA7210_ADC_R_EN);
 
 	/*
 	 * DAC settings
 	 */
 
 	/* Enable Left and Right DAC */
-	da7210_write(codec, DA7210_DAC_SEL,
+	snd_soc_write(codec, DA7210_DAC_SEL,
 		     DA7210_DAC_L_SRC_DAI_L | DA7210_DAC_L_EN |
 		     DA7210_DAC_R_SRC_DAI_R | DA7210_DAC_R_EN);
 
 	/* Enable Left and Right out PGA */
-	da7210_write(codec, DA7210_OUTMIX_L, DA7210_OUT_L_EN);
-	da7210_write(codec, DA7210_OUTMIX_R, DA7210_OUT_R_EN);
+	snd_soc_write(codec, DA7210_OUTMIX_L, DA7210_OUT_L_EN);
+	snd_soc_write(codec, DA7210_OUTMIX_R, DA7210_OUT_R_EN);
 
 	/* Enable Left and Right HeadPhone PGA */
-	da7210_write(codec, DA7210_HP_CFG,
+	snd_soc_write(codec, DA7210_HP_CFG,
 		     DA7210_HP_2CAP_MODE | DA7210_HP_SENSE_EN |
 		     DA7210_HP_L_EN | DA7210_HP_MODE | DA7210_HP_R_EN);
 
 	/* Diable PLL and bypass it */
-	da7210_write(codec, DA7210_PLL, DA7210_PLL_FS_48000);
+	snd_soc_write(codec, DA7210_PLL, DA7210_PLL_FS_48000);
 
 	/*
 	 * If 48kHz sound came, it use bypass mode,
@@ -522,22 +491,22 @@ static int da7210_probe(struct snd_soc_codec *codec)
 	 * DA7210_PLL_DIV3 :: DA7210_PLL_BYP bit.
 	 *   see da7210_hw_params
 	 */
-	da7210_write(codec, DA7210_PLL_DIV1, 0xE5); /* MCLK = 12.288MHz */
-	da7210_write(codec, DA7210_PLL_DIV2, 0x99);
-	da7210_write(codec, DA7210_PLL_DIV3, 0x0A |
+	snd_soc_write(codec, DA7210_PLL_DIV1, 0xE5); /* MCLK = 12.288MHz */
+	snd_soc_write(codec, DA7210_PLL_DIV2, 0x99);
+	snd_soc_write(codec, DA7210_PLL_DIV3, 0x0A |
 		     DA7210_MCLK_RANGE_10_20_MHZ | DA7210_PLL_BYP);
 	snd_soc_update_bits(codec, DA7210_PLL, DA7210_PLL_EN, DA7210_PLL_EN);
 
 	/* As suggested by Dialog */
-	da7210_write(codec, DA7210_A_HID_UNLOCK,	0x8B); /* unlock */
-	da7210_write(codec, DA7210_A_TEST_UNLOCK,	0xB4);
-	da7210_write(codec, DA7210_A_PLL1,		0x01);
-	da7210_write(codec, DA7210_A_CP_MODE,		0x7C);
-	da7210_write(codec, DA7210_A_HID_UNLOCK,	0x00); /* re-lock */
-	da7210_write(codec, DA7210_A_TEST_UNLOCK,	0x00);
+	snd_soc_write(codec, DA7210_A_HID_UNLOCK,	0x8B); /* unlock */
+	snd_soc_write(codec, DA7210_A_TEST_UNLOCK,	0xB4);
+	snd_soc_write(codec, DA7210_A_PLL1,		0x01);
+	snd_soc_write(codec, DA7210_A_CP_MODE,		0x7C);
+	snd_soc_write(codec, DA7210_A_HID_UNLOCK,	0x00); /* re-lock */
+	snd_soc_write(codec, DA7210_A_TEST_UNLOCK,	0x00);
 
 	/* Activate all enabled subsystem */
-	da7210_write(codec, DA7210_STARTUP1, DA7210_SC_MST_EN);
+	snd_soc_write(codec, DA7210_STARTUP1, DA7210_SC_MST_EN);
 
 	snd_soc_add_controls(codec, da7210_snd_controls,
 			     ARRAY_SIZE(da7210_snd_controls));
@@ -549,11 +518,10 @@ static int da7210_probe(struct snd_soc_codec *codec)
 
 static struct snd_soc_codec_driver soc_codec_dev_da7210 = {
 	.probe			= da7210_probe,
-	.read			= da7210_read,
-	.write			= da7210_write,
 	.reg_cache_size		= ARRAY_SIZE(da7210_reg),
 	.reg_word_size		= sizeof(u8),
 	.reg_cache_default	= da7210_reg,
+	.volatile_register	= da7210_volatile_register,
 };
 
 #if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
@@ -568,7 +536,6 @@ static int __devinit da7210_i2c_probe(struct i2c_client *i2c,
 		return -ENOMEM;
 
 	i2c_set_clientdata(i2c, da7210);
-	da7210->control_data = i2c;
 	da7210->control_type = SND_SOC_I2C;
 
 	ret =  snd_soc_register_codec(&i2c->dev,
-- 
1.7.4.1



