Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab1JLCSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 22:18:09 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39858 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab1JLCSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 22:18:07 -0400
Subject: [PATCH] ASoC: tlv320aic23: convert to soc-cache
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arun KS <arunks@mistralsolutions.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 10:17:53 +0800
Message-ID: <1318385873.11530.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Hi,
This patch converts tlv320aic23 to use soc-cache APIs.
I don't have this hardware, I'd appreciate if someone can test this patch.

Thanks,
Axel
 sound/soc/codecs/tlv320aic23.c |  169 +++++++++++++---------------------------
 1 files changed, 54 insertions(+), 115 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic23.c b/sound/soc/codecs/tlv320aic23.c
index c3a4bb2..c9d85db 100644
--- a/sound/soc/codecs/tlv320aic23.c
+++ b/sound/soc/codecs/tlv320aic23.c
@@ -47,63 +47,6 @@ static const u16 tlv320aic23_reg[] = {
 	0x0000, 0x0000, 0x0000, 0x0000,	/* 12 */
 };
 
-/*
- * read tlv320aic23 register cache
- */
-static inline unsigned int tlv320aic23_read_reg_cache(struct snd_soc_codec
-						      *codec, unsigned int reg)
-{
-	u16 *cache = codec->reg_cache;
-	if (reg >= ARRAY_SIZE(tlv320aic23_reg))
-		return -1;
-	return cache[reg];
-}
-
-/*
- * write tlv320aic23 register cache
- */
-static inline void tlv320aic23_write_reg_cache(struct snd_soc_codec *codec,
-					       u8 reg, u16 value)
-{
-	u16 *cache = codec->reg_cache;
-	if (reg >= ARRAY_SIZE(tlv320aic23_reg))
-		return;
-	cache[reg] = value;
-}
-
-/*
- * write to the tlv320aic23 register space
- */
-static int tlv320aic23_write(struct snd_soc_codec *codec, unsigned int reg,
-			     unsigned int value)
-{
-
-	u8 data[2];
-
-	/* TLV320AIC23 has 7 bit address and 9 bits of data
-	 * so we need to switch one data bit into reg and rest
-	 * of data into val
-	 */
-
-	if (reg > 9 && reg != 15) {
-		printk(KERN_WARNING "%s Invalid register R%u\n", __func__, reg);
-		return -1;
-	}
-
-	data[0] = (reg << 1) | (value >> 8 & 0x01);
-	data[1] = value & 0xff;
-
-	tlv320aic23_write_reg_cache(codec, reg, value);
-
-	if (codec->hw_write(codec->control_data, data, 2) == 2)
-		return 0;
-
-	printk(KERN_ERR "%s cannot write %03x to register R%u\n", __func__,
-	       value, reg);
-
-	return -EIO;
-}
-
 static const char *rec_src_text[] = { "Line", "Mic" };
 static const char *deemph_text[] = {"None", "32Khz", "44.1Khz", "48Khz"};
 
@@ -139,8 +82,8 @@ static int snd_soc_tlv320aic23_put_volsw(struct snd_kcontrol *kcontrol,
 	*/
 	val = (val >= 4) ? 4  : (3 - val);
 
-	reg = tlv320aic23_read_reg_cache(codec, TLV320AIC23_ANLG) & (~0x1C0);
-	tlv320aic23_write(codec, TLV320AIC23_ANLG, reg | (val << 6));
+	reg = snd_soc_read(codec, TLV320AIC23_ANLG) & (~0x1C0);
+	snd_soc_write(codec, TLV320AIC23_ANLG, reg | (val << 6));
 
 	return 0;
 }
@@ -151,7 +94,7 @@ static int snd_soc_tlv320aic23_get_volsw(struct snd_kcontrol *kcontrol,
 	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
 	u16 val;
 
-	val = tlv320aic23_read_reg_cache(codec, TLV320AIC23_ANLG) & (0x1C0);
+	val = snd_soc_read(codec, TLV320AIC23_ANLG) & (0x1C0);
 	val = val >> 6;
 	val = (val >= 4) ? 4  : (3 -  val);
 	ucontrol->value.integer.value[0] = val;
@@ -232,7 +175,6 @@ static const struct snd_soc_dapm_route tlv320aic23_intercon[] = {
 /* AIC23 driver data */
 struct aic23 {
 	enum snd_soc_control_type control_type;
-	void *control_data;
 	int mclk;
 	int requested_adc;
 	int requested_dac;
@@ -344,7 +286,7 @@ static int find_rate(int mclk, u32 need_adc, u32 need_dac)
 static void get_current_sample_rates(struct snd_soc_codec *codec, int mclk,
 		u32 *sample_rate_adc, u32 *sample_rate_dac)
 {
-	int src = tlv320aic23_read_reg_cache(codec, TLV320AIC23_SRATE);
+	int src = snd_soc_read(codec, TLV320AIC23_SRATE);
 	int sr = (src >> 2) & 0x0f;
 	int val = (mclk / bosr_usb_divisor_table[src & 3]);
 	int adc = (val * sr_adc_mult_table[sr]) / SR_MULT;
@@ -368,7 +310,7 @@ static int set_sample_rate_control(struct snd_soc_codec *codec, int mclk,
 				__func__, sample_rate_adc, sample_rate_dac);
 		return -EINVAL;
 	}
-	tlv320aic23_write(codec, TLV320AIC23_SRATE, data);
+	snd_soc_write(codec, TLV320AIC23_SRATE, data);
 #ifdef DEBUG
 	{
 		u32 adc, dac;
@@ -407,9 +349,8 @@ static int tlv320aic23_hw_params(struct snd_pcm_substream *substream,
 	if (ret < 0)
 		return ret;
 
-	iface_reg =
-	    tlv320aic23_read_reg_cache(codec,
-				       TLV320AIC23_DIGT_FMT) & ~(0x03 << 2);
+	iface_reg = snd_soc_read(codec, TLV320AIC23_DIGT_FMT) & ~(0x03 << 2);
+
 	switch (params_format(params)) {
 	case SNDRV_PCM_FORMAT_S16_LE:
 		break;
@@ -423,7 +364,7 @@ static int tlv320aic23_hw_params(struct snd_pcm_substream *substream,
 		iface_reg |= (0x03 << 2);
 		break;
 	}
-	tlv320aic23_write(codec, TLV320AIC23_DIGT_FMT, iface_reg);
+	snd_soc_write(codec, TLV320AIC23_DIGT_FMT, iface_reg);
 
 	return 0;
 }
@@ -435,7 +376,7 @@ static int tlv320aic23_pcm_prepare(struct snd_pcm_substream *substream,
 	struct snd_soc_codec *codec = rtd->codec;
 
 	/* set active */
-	tlv320aic23_write(codec, TLV320AIC23_ACTIVE, 0x0001);
+	snd_soc_write(codec, TLV320AIC23_ACTIVE, 0x0001);
 
 	return 0;
 }
@@ -450,7 +391,7 @@ static void tlv320aic23_shutdown(struct snd_pcm_substream *substream,
 	/* deactivate */
 	if (!codec->active) {
 		udelay(50);
-		tlv320aic23_write(codec, TLV320AIC23_ACTIVE, 0x0);
+		snd_soc_write(codec, TLV320AIC23_ACTIVE, 0x0);
 	}
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
 		aic23->requested_dac = 0;
@@ -463,14 +404,14 @@ static int tlv320aic23_mute(struct snd_soc_dai *dai, int mute)
 	struct snd_soc_codec *codec = dai->codec;
 	u16 reg;
 
-	reg = tlv320aic23_read_reg_cache(codec, TLV320AIC23_DIGT);
+	reg = snd_soc_read(codec, TLV320AIC23_DIGT);
 	if (mute)
 		reg |= TLV320AIC23_DACM_MUTE;
 
 	else
 		reg &= ~TLV320AIC23_DACM_MUTE;
 
-	tlv320aic23_write(codec, TLV320AIC23_DIGT, reg);
+	snd_soc_write(codec, TLV320AIC23_DIGT, reg);
 
 	return 0;
 }
@@ -481,8 +422,7 @@ static int tlv320aic23_set_dai_fmt(struct snd_soc_dai *codec_dai,
 	struct snd_soc_codec *codec = codec_dai->codec;
 	u16 iface_reg;
 
-	iface_reg =
-	    tlv320aic23_read_reg_cache(codec, TLV320AIC23_DIGT_FMT) & (~0x03);
+	iface_reg = snd_soc_read(codec, TLV320AIC23_DIGT_FMT) & (~0x03);
 
 	/* set master/slave audio interface */
 	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
@@ -516,7 +456,7 @@ static int tlv320aic23_set_dai_fmt(struct snd_soc_dai *codec_dai,
 
 	}
 
-	tlv320aic23_write(codec, TLV320AIC23_DIGT_FMT, iface_reg);
+	snd_soc_write(codec, TLV320AIC23_DIGT_FMT, iface_reg);
 
 	return 0;
 }
@@ -532,26 +472,26 @@ static int tlv320aic23_set_dai_sysclk(struct snd_soc_dai *codec_dai,
 static int tlv320aic23_set_bias_level(struct snd_soc_codec *codec,
 				      enum snd_soc_bias_level level)
 {
-	u16 reg = tlv320aic23_read_reg_cache(codec, TLV320AIC23_PWR) & 0xff7f;
+	u16 reg = snd_soc_read(codec, TLV320AIC23_PWR) & 0xff7f;
 
 	switch (level) {
 	case SND_SOC_BIAS_ON:
 		/* vref/mid, osc on, dac unmute */
 		reg &= ~(TLV320AIC23_DEVICE_PWR_OFF | TLV320AIC23_OSC_OFF | \
 			TLV320AIC23_DAC_OFF);
-		tlv320aic23_write(codec, TLV320AIC23_PWR, reg);
+		snd_soc_write(codec, TLV320AIC23_PWR, reg);
 		break;
 	case SND_SOC_BIAS_PREPARE:
 		break;
 	case SND_SOC_BIAS_STANDBY:
 		/* everything off except vref/vmid, */
-		tlv320aic23_write(codec, TLV320AIC23_PWR, reg | \
-			TLV320AIC23_CLK_OFF);
+		snd_soc_write(codec, TLV320AIC23_PWR,
+			      reg | TLV320AIC23_CLK_OFF);
 		break;
 	case SND_SOC_BIAS_OFF:
 		/* everything off, dac mute, inactive */
-		tlv320aic23_write(codec, TLV320AIC23_ACTIVE, 0x0);
-		tlv320aic23_write(codec, TLV320AIC23_PWR, 0xffff);
+		snd_soc_write(codec, TLV320AIC23_ACTIVE, 0x0);
+		snd_soc_write(codec, TLV320AIC23_PWR, 0xffff);
 		break;
 	}
 	codec->dapm.bias_level = level;
@@ -598,13 +538,7 @@ static int tlv320aic23_suspend(struct snd_soc_codec *codec,
 
 static int tlv320aic23_resume(struct snd_soc_codec *codec)
 {
-	u16 reg;
-
-	/* Sync reg_cache with the hardware */
-	for (reg = 0; reg <= TLV320AIC23_ACTIVE; reg++) {
-		u16 val = tlv320aic23_read_reg_cache(codec, reg);
-		tlv320aic23_write(codec, reg, val);
-	}
+	snd_soc_cache_sync(codec);
 	tlv320aic23_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
 	return 0;
@@ -613,46 +547,54 @@ static int tlv320aic23_resume(struct snd_soc_codec *codec)
 static int tlv320aic23_probe(struct snd_soc_codec *codec)
 {
 	struct aic23 *aic23 = snd_soc_codec_get_drvdata(codec);
-	int reg;
+	int ret;
 
 	printk(KERN_INFO "AIC23 Audio Codec %s\n", AIC23_VERSION);
-	codec->control_data = aic23->control_data;
-	codec->hw_write = (hw_write_t)i2c_master_send;
-	codec->hw_read = NULL;
+
+	ret = snd_soc_codec_set_cache_io(codec, 7, 9, aic23->control_type);
+	if (ret < 0) {
+		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
+		return ret;
+	}
 
 	/* Reset codec */
-	tlv320aic23_write(codec, TLV320AIC23_RESET, 0);
+	snd_soc_write(codec, TLV320AIC23_RESET, 0);
+
+	/* Write the register default value to cache for reserved registers,
+	 * so the write to the these registers are suppressed by the cache
+	 * restore code when it skips writes of default registers.
+	 */
+	codec->cache_only = 1;
+	snd_soc_write(codec, 0x0A, 0);
+	snd_soc_write(codec, 0x0B, 0);
+	snd_soc_write(codec, 0x0C, 0);
+	snd_soc_write(codec, 0x0D, 0);
+	snd_soc_write(codec, 0x0E, 0);
+	codec->cache_only = 0;
 
 	/* power on device */
 	tlv320aic23_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
-	tlv320aic23_write(codec, TLV320AIC23_DIGT, TLV320AIC23_DEEMP_44K);
+	snd_soc_write(codec, TLV320AIC23_DIGT, TLV320AIC23_DEEMP_44K);
 
 	/* Unmute input */
-	reg = tlv320aic23_read_reg_cache(codec, TLV320AIC23_LINVOL);
-	tlv320aic23_write(codec, TLV320AIC23_LINVOL,
-			  (reg & (~TLV320AIC23_LIM_MUTED)) |
-			  (TLV320AIC23_LRS_ENABLED));
+	snd_soc_update_bits(codec, TLV320AIC23_LINVOL,
+			    TLV320AIC23_LIM_MUTED, TLV320AIC23_LRS_ENABLED);
 
-	reg = tlv320aic23_read_reg_cache(codec, TLV320AIC23_RINVOL);
-	tlv320aic23_write(codec, TLV320AIC23_RINVOL,
-			  (reg & (~TLV320AIC23_LIM_MUTED)) |
-			  TLV320AIC23_LRS_ENABLED);
+	snd_soc_update_bits(codec, TLV320AIC23_RINVOL,
+			    TLV320AIC23_LIM_MUTED, TLV320AIC23_LRS_ENABLED);
 
-	reg = tlv320aic23_read_reg_cache(codec, TLV320AIC23_ANLG);
-	tlv320aic23_write(codec, TLV320AIC23_ANLG,
-			 (reg) & (~TLV320AIC23_BYPASS_ON) &
-			 (~TLV320AIC23_MICM_MUTED));
+	snd_soc_update_bits(codec, TLV320AIC23_ANLG,
+			    TLV320AIC23_BYPASS_ON | TLV320AIC23_MICM_MUTED,
+			    0);
 
 	/* Default output volume */
-	tlv320aic23_write(codec, TLV320AIC23_LCHNVOL,
-			  TLV320AIC23_DEFAULT_OUT_VOL &
-			  TLV320AIC23_OUT_VOL_MASK);
-	tlv320aic23_write(codec, TLV320AIC23_RCHNVOL,
-			  TLV320AIC23_DEFAULT_OUT_VOL &
-			  TLV320AIC23_OUT_VOL_MASK);
+	snd_soc_write(codec, TLV320AIC23_LCHNVOL,
+		      TLV320AIC23_DEFAULT_OUT_VOL & TLV320AIC23_OUT_VOL_MASK);
+	snd_soc_write(codec, TLV320AIC23_RCHNVOL,
+		      TLV320AIC23_DEFAULT_OUT_VOL & TLV320AIC23_OUT_VOL_MASK);
 
-	tlv320aic23_write(codec, TLV320AIC23_ACTIVE, 0x1);
+	snd_soc_write(codec, TLV320AIC23_ACTIVE, 0x1);
 
 	snd_soc_add_controls(codec, tlv320aic23_snd_controls,
 				ARRAY_SIZE(tlv320aic23_snd_controls));
@@ -674,8 +616,6 @@ static struct snd_soc_codec_driver soc_codec_dev_tlv320aic23 = {
 	.remove = tlv320aic23_remove,
 	.suspend = tlv320aic23_suspend,
 	.resume = tlv320aic23_resume,
-	.read = tlv320aic23_read_reg_cache,
-	.write = tlv320aic23_write,
 	.set_bias_level = tlv320aic23_set_bias_level,
 	.dapm_widgets = tlv320aic23_dapm_widgets,
 	.num_dapm_widgets = ARRAY_SIZE(tlv320aic23_dapm_widgets),
@@ -702,7 +642,6 @@ static int tlv320aic23_codec_probe(struct i2c_client *i2c,
 		return -ENOMEM;
 
 	i2c_set_clientdata(i2c, aic23);
-	aic23->control_data = i2c;
 	aic23->control_type = SND_SOC_I2C;
 
 	ret =  snd_soc_register_codec(&i2c->dev,
-- 
1.7.4.1



