Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab1JFCME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 22:12:04 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49967 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab1JFCMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 22:12:02 -0400
Subject: [RFC][PATCH] ASoC: ak4535: convert to soc-cache
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Oct 2011 10:11:51 +0800
Message-ID: <1317867111.8321.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
I don't have this hardware, this patch is UNTESTED!!
( But current code is broken anyway )
I'd appreciate if someone can test it.

Axel
 sound/soc/codecs/ak4535.c |  100 ++++++++-------------------------------------
 1 files changed, 18 insertions(+), 82 deletions(-)

diff --git a/sound/soc/codecs/ak4535.c b/sound/soc/codecs/ak4535.c
index e1a214e..68df32d 100644
--- a/sound/soc/codecs/ak4535.c
+++ b/sound/soc/codecs/ak4535.c
@@ -34,7 +34,6 @@
 struct ak4535_priv {
 	unsigned int sysclk;
 	enum snd_soc_control_type control_type;
-	void *control_data;
 };
 
 /*
@@ -47,63 +46,6 @@ static const u16 ak4535_reg[AK4535_CACHEREGNUM] = {
     0x0000, 0x0000, 0x0057, 0x0000,
 };
 
-/*
- * read ak4535 register cache
- */
-static inline unsigned int ak4535_read_reg_cache(struct snd_soc_codec *codec,
-	unsigned int reg)
-{
-	u16 *cache = codec->reg_cache;
-	if (reg >= AK4535_CACHEREGNUM)
-		return -1;
-	return cache[reg];
-}
-
-/*
- * write ak4535 register cache
- */
-static inline void ak4535_write_reg_cache(struct snd_soc_codec *codec,
-	u16 reg, unsigned int value)
-{
-	u16 *cache = codec->reg_cache;
-	if (reg >= AK4535_CACHEREGNUM)
-		return;
-	cache[reg] = value;
-}
-
-/*
- * write to the AK4535 register space
- */
-static int ak4535_write(struct snd_soc_codec *codec, unsigned int reg,
-	unsigned int value)
-{
-	u8 data[2];
-
-	/* data is
-	 *   D15..D8 AK4535 register offset
-	 *   D7...D0 register data
-	 */
-	data[0] = reg & 0xff;
-	data[1] = value & 0xff;
-
-	ak4535_write_reg_cache(codec, reg, value);
-	if (codec->hw_write(codec->control_data, data, 2) == 2)
-		return 0;
-	else
-		return -EIO;
-}
-
-static int ak4535_sync(struct snd_soc_codec *codec)
-{
-	u16 *cache = codec->reg_cache;
-	int i, r = 0;
-
-	for (i = 0; i < AK4535_CACHEREGNUM; i++)
-		r |= ak4535_write(codec, i, cache[i]);
-
-	return r;
-};
-
 static const char *ak4535_mono_gain[] = {"+6dB", "-17dB"};
 static const char *ak4535_mono_out[] = {"(L + R)/2", "Hi-Z"};
 static const char *ak4535_hp_out[] = {"Stereo", "Mono"};
@@ -304,7 +246,7 @@ static int ak4535_hw_params(struct snd_pcm_substream *substream,
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
 	struct snd_soc_codec *codec = rtd->codec;
 	struct ak4535_priv *ak4535 = snd_soc_codec_get_drvdata(codec);
-	u8 mode2 = ak4535_read_reg_cache(codec, AK4535_MODE2) & ~(0x3 << 5);
+	u8 mode2 = snd_soc_read(codec, AK4535_MODE2) & ~(0x3 << 5);
 	int rate = params_rate(params), fs = 256;
 
 	if (rate)
@@ -323,7 +265,7 @@ static int ak4535_hw_params(struct snd_pcm_substream *substream,
 	}
 
 	/* set rate */
-	ak4535_write(codec, AK4535_MODE2, mode2);
+	snd_soc_write(codec, AK4535_MODE2, mode2);
 	return 0;
 }
 
@@ -348,44 +290,37 @@ static int ak4535_set_dai_fmt(struct snd_soc_dai *codec_dai,
 	/* use 32 fs for BCLK to save power */
 	mode1 |= 0x4;
 
-	ak4535_write(codec, AK4535_MODE1, mode1);
+	snd_soc_write(codec, AK4535_MODE1, mode1);
 	return 0;
 }
 
 static int ak4535_mute(struct snd_soc_dai *dai, int mute)
 {
 	struct snd_soc_codec *codec = dai->codec;
-	u16 mute_reg = ak4535_read_reg_cache(codec, AK4535_DAC);
+	u16 mute_reg = snd_soc_read(codec, AK4535_DAC);
 	if (!mute)
-		ak4535_write(codec, AK4535_DAC, mute_reg & ~0x20);
+		snd_soc_write(codec, AK4535_DAC, mute_reg & ~0x20);
 	else
-		ak4535_write(codec, AK4535_DAC, mute_reg | 0x20);
+		snd_soc_write(codec, AK4535_DAC, mute_reg | 0x20);
 	return 0;
 }
 
 static int ak4535_set_bias_level(struct snd_soc_codec *codec,
 	enum snd_soc_bias_level level)
 {
-	u16 i, mute_reg;
-
 	switch (level) {
 	case SND_SOC_BIAS_ON:
-		mute_reg = ak4535_read_reg_cache(codec, AK4535_DAC);
-		ak4535_write(codec, AK4535_DAC, mute_reg & ~0x20);
+		snd_soc_update_bits(codec, AK4535_DAC, 0x20, 0);
 		break;
 	case SND_SOC_BIAS_PREPARE:
-		mute_reg = ak4535_read_reg_cache(codec, AK4535_DAC);
-		ak4535_write(codec, AK4535_DAC, mute_reg | 0x20);
+		snd_soc_update_bits(codec, AK4535_DAC, 0x20, 0x20);
 		break;
 	case SND_SOC_BIAS_STANDBY:
-		i = ak4535_read_reg_cache(codec, AK4535_PM1);
-		ak4535_write(codec, AK4535_PM1, i | 0x80);
-		i = ak4535_read_reg_cache(codec, AK4535_PM2);
-		ak4535_write(codec, AK4535_PM2, i & (~0x80));
+		snd_soc_update_bits(codec, AK4535_PM1, 0x80, 0x80);
+		snd_soc_update_bits(codec, AK4535_PM2, 0x80, 0);
 		break;
 	case SND_SOC_BIAS_OFF:
-		i = ak4535_read_reg_cache(codec, AK4535_PM1);
-		ak4535_write(codec, AK4535_PM1, i & (~0x80));
+		snd_soc_update_bits(codec, AK4535_PM1, 0x80, 0);
 		break;
 	}
 	codec->dapm.bias_level = level;
@@ -428,7 +363,7 @@ static int ak4535_suspend(struct snd_soc_codec *codec, pm_message_t state)
 
 static int ak4535_resume(struct snd_soc_codec *codec)
 {
-	ak4535_sync(codec);
+	snd_soc_cache_sync(codec);
 	ak4535_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 	return 0;
 }
@@ -436,11 +371,15 @@ static int ak4535_resume(struct snd_soc_codec *codec)
 static int ak4535_probe(struct snd_soc_codec *codec)
 {
 	struct ak4535_priv *ak4535 = snd_soc_codec_get_drvdata(codec);
+	int ret;
 
 	printk(KERN_INFO "AK4535 Audio Codec %s", AK4535_VERSION);
 
-	codec->control_data = ak4535->control_data;
-
+	ret = snd_soc_codec_set_cache_io(codec, 8, 8, ak4535->control_type);
+	if (ret < 0) {
+		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
+		return ret;
+	}
 	/* power on device */
 	ak4535_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
@@ -461,8 +400,6 @@ static struct snd_soc_codec_driver soc_codec_dev_ak4535 = {
 	.remove =	ak4535_remove,
 	.suspend =	ak4535_suspend,
 	.resume =	ak4535_resume,
-	.read = ak4535_read_reg_cache,
-	.write = ak4535_write,
 	.set_bias_level = ak4535_set_bias_level,
 	.reg_cache_size = ARRAY_SIZE(ak4535_reg),
 	.reg_word_size = sizeof(u8),
@@ -485,7 +422,6 @@ static __devinit int ak4535_i2c_probe(struct i2c_client *i2c,
 		return -ENOMEM;
 
 	i2c_set_clientdata(i2c, ak4535);
-	ak4535->control_data = i2c;
 	ak4535->control_type = SND_SOC_I2C;
 
 	ret = snd_soc_register_codec(&i2c->dev,
-- 
1.7.4.1



