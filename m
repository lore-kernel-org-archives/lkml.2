Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab1DTBU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 21:20:59 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:40304 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab1DTBU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 21:20:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cW7yg3vTiPTCI+TYtz5YGta5iqDYZrCc/lMOOSb1Lt8silWy+bcANRb6Gj3EDqcrsM
         NiIOjhqvA4IWEVNQdZ/T+Xef1kWRHwtjj64rYZv+KBtQHoQcF5MMjpXnqk4vFfTbSRIl
         YuiU4047aosz5GtKa68z2cI3zL+ed41x3r7Gg=
From: Peter Hsiang <cdefgab1288@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Hsiang <peter.hsiang@maxim-ic.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Cc: Jesse Marroquin <jesse.marroquin@maxim-ic.com>,
        Peter Hsiang <peter.hsiang@maxim-ic.com>
Subject: [PATCH] ASoC: Add EQ and filter to max98095 CODEC driver
Date: Tue, 19 Apr 2011 18:20:40 -0700
Message-Id: <1303262440-19412-1-git-send-email-peter.hsiang@maxim-ic.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the equalizer and biquad filter controls.

Signed-off-by: Peter Hsiang <peter.hsiang@maxim-ic.com>
---
 include/sound/max98095.h    |   28 +++
 sound/soc/codecs/max98095.c |  391 +++++++++++++++++++++++++++++++++++++++++++
 sound/soc/codecs/max98095.h |   15 ++
 3 files changed, 434 insertions(+), 0 deletions(-)

diff --git a/include/sound/max98095.h b/include/sound/max98095.h
index 3381765..7513a42 100644
--- a/include/sound/max98095.h
+++ b/include/sound/max98095.h
@@ -13,8 +13,36 @@
 #ifndef __SOUND_MAX98095_PDATA_H__
 #define __SOUND_MAX98095_PDATA_H__
 
+/* Equalizer filter response configuration */
+struct max98095_eq_cfg {
+	const char *name;
+	unsigned int rate;
+	u16 band1[5];
+	u16 band2[5];
+	u16 band3[5];
+	u16 band4[5];
+	u16 band5[5];
+};
+
+/* Biquad filter response configuration */
+struct max98095_biquad_cfg {
+	const char *name;
+	unsigned int rate;
+	u16 band1[5];
+	u16 band2[5];
+};
+
 /* codec platform data */
 struct max98095_pdata {
+
+	/* Equalizers for DAI1 and DAI2 */
+	struct max98095_eq_cfg *eq_cfg;
+	unsigned int eq_cfgcnt;
+
+	/* Biquad filter for DAI1 and DAI2 */
+	struct max98095_biquad_cfg *bq_cfg;
+	unsigned int bq_cfgcnt;
+
 	/* Analog/digital microphone configuration:
 	 * 0 = analog microphone input (normal setting)
 	 * 1 = digital microphone input
diff --git a/sound/soc/codecs/max98095.c b/sound/soc/codecs/max98095.c
index 9c77f17..a6cc94e 100644
--- a/sound/soc/codecs/max98095.c
+++ b/sound/soc/codecs/max98095.c
@@ -34,6 +34,8 @@ enum max98095_type {
 struct max98095_cdata {
 	unsigned int rate;
 	unsigned int fmt;
+	int eq_sel;
+	int bq_sel;
 };
 
 struct max98095_priv {
@@ -42,6 +44,12 @@ struct max98095_priv {
 	struct max98095_pdata *pdata;
 	unsigned int sysclk;
 	struct max98095_cdata dai[3];
+	const char **eq_texts;
+	const char **bq_texts;
+	struct soc_enum eq_enum;
+	struct soc_enum bq_enum;
+	int eq_textcnt;
+	int bq_textcnt;
 	u8 lin_state;
 	unsigned int mic1pre;
 	unsigned int mic2pre;
@@ -602,6 +610,74 @@ static int max98095_volatile(struct snd_soc_codec *codec, unsigned int reg)
 	return 0;
 }
 
+/*
+ * Filter coefficients are in a separate register segment
+ * and they share the address space of the normal registers.
+ * The coefficient registers do not need or share the cache.
+ */
+static int max98095_hw_write(struct snd_soc_codec *codec, unsigned int reg,
+			     unsigned int value)
+{
+	u8 data[2];
+
+	data[0] = reg;
+	data[1] = value;
+	if (codec->hw_write(codec->control_data, data, 2) == 2)
+		return 0;
+	else
+		return -EIO;
+}
+
+/*
+ * Load equalizer DSP coefficient configurations registers
+ */
+static void m98095_eq_band(struct snd_soc_codec *codec, unsigned int dai,
+		    unsigned int band, u16 *coefs)
+{
+	unsigned int eq_reg;
+	unsigned int i;
+
+	BUG_ON(band > 4);
+	BUG_ON(dai > 1);
+
+	/* Load the base register address */
+	eq_reg = dai ? M98095_142_DAI2_EQ_BASE : M98095_110_DAI1_EQ_BASE;
+
+	/* Add the band address offset, note adjustment for word address */
+	eq_reg += band * (M98095_COEFS_PER_BAND << 1);
+
+	/* Step through the registers and coefs */
+	for (i = 0; i < M98095_COEFS_PER_BAND; i++) {
+		max98095_hw_write(codec, eq_reg++, M98095_BYTE1(coefs[i]));
+		max98095_hw_write(codec, eq_reg++, M98095_BYTE0(coefs[i]));
+	}
+}
+
+/*
+ * Load biquad filter coefficient configurations registers
+ */
+static void m98095_biquad_band(struct snd_soc_codec *codec, unsigned int dai,
+		    unsigned int band, u16 *coefs)
+{
+	unsigned int bq_reg;
+	unsigned int i;
+
+	BUG_ON(band > 1);
+	BUG_ON(dai > 1);
+
+	/* Load the base register address */
+	bq_reg = dai ? M98095_17E_DAI2_BQ_BASE : M98095_174_DAI1_BQ_BASE;
+
+	/* Add the band address offset, note adjustment for word address */
+	bq_reg += band * (M98095_COEFS_PER_BAND << 1);
+
+	/* Step through the registers and coefs */
+	for (i = 0; i < M98095_COEFS_PER_BAND; i++) {
+		max98095_hw_write(codec, bq_reg++, M98095_BYTE1(coefs[i]));
+		max98095_hw_write(codec, bq_reg++, M98095_BYTE0(coefs[i]));
+	}
+}
+
 static const char * const max98095_fltr_mode[] = { "Voice", "Music" };
 static const struct soc_enum max98095_dai1_filter_mode_enum[] = {
 	SOC_ENUM_SINGLE(M98095_02E_DAI1_FILTERS, 7, 2, max98095_fltr_mode),
@@ -792,6 +868,12 @@ static const struct snd_kcontrol_new max98095_snd_controls[] = {
 	SOC_SINGLE_TLV("ADCR Boost Volume", M98095_05E_LVL_ADC_R, 4, 3, 0,
 		max98095_adcboost_tlv),
 
+	SOC_SINGLE("EQ1 Switch", M98095_088_CFG_LEVEL, 0, 1, 0),
+	SOC_SINGLE("EQ2 Switch", M98095_088_CFG_LEVEL, 1, 1, 0),
+
+	SOC_SINGLE("Biquad1 Switch", M98095_088_CFG_LEVEL, 2, 1, 0),
+	SOC_SINGLE("Biquad2 Switch", M98095_088_CFG_LEVEL, 3, 1, 0),
+
 	SOC_ENUM("DAI1 Filter Mode", max98095_dai1_filter_mode_enum),
 	SOC_ENUM("DAI2 Filter Mode", max98095_dai2_filter_mode_enum),
 	SOC_ENUM("DAI1 DAC Filter", max98095_dai1_dac_filter_enum),
@@ -1766,6 +1848,299 @@ static struct snd_soc_dai_driver max98095_dai[] = {
 
 };
 
+static int max98095_get_eq_channel(const char *name)
+{
+	if (strcmp(name, "EQ1 Mode") == 0)
+		return 0;
+	if (strcmp(name, "EQ2 Mode") == 0)
+		return 1;
+	return -EINVAL;
+}
+
+static int max98095_put_eq_enum(struct snd_kcontrol *kcontrol,
+				 struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct max98095_priv *max98095 = snd_soc_codec_get_drvdata(codec);
+	struct max98095_pdata *pdata = max98095->pdata;
+	int channel = max98095_get_eq_channel(kcontrol->id.name);
+	struct max98095_cdata *cdata;
+	int sel = ucontrol->value.integer.value[0];
+	struct max98095_eq_cfg *coef_set;
+	int fs, best, best_val, i;
+	int regmask, regsave;
+
+	BUG_ON(channel > 1);
+
+	cdata = &max98095->dai[channel];
+
+	if (sel >= pdata->eq_cfgcnt)
+		return -EINVAL;
+
+	cdata->eq_sel = sel;
+
+	if (!pdata || !max98095->eq_textcnt)
+		return 0;
+
+	fs = cdata->rate;
+
+	/* Find the selected configuration with nearest sample rate */
+	best = 0;
+	best_val = INT_MAX;
+	for (i = 0; i < pdata->eq_cfgcnt; i++) {
+		if (strcmp(pdata->eq_cfg[i].name, max98095->eq_texts[sel]) == 0 &&
+			abs(pdata->eq_cfg[i].rate - fs) < best_val) {
+			best = i;
+			best_val = abs(pdata->eq_cfg[i].rate - fs);
+		}
+	}
+
+	dev_dbg(codec->dev, "Selected %s/%dHz for %dHz sample rate\n",
+		pdata->eq_cfg[best].name,
+		pdata->eq_cfg[best].rate, fs);
+
+	coef_set = &pdata->eq_cfg[best];
+
+	regmask = (channel == 0) ? M98095_EQ1EN : M98095_EQ2EN;
+
+	/* Disable filter while configuring, and save current on/off state */
+	regsave = snd_soc_read(codec, M98095_088_CFG_LEVEL);
+	snd_soc_update_bits(codec, M98095_088_CFG_LEVEL, regmask, 0);
+
+	mutex_lock(&codec->mutex);
+	snd_soc_update_bits(codec, M98095_00F_HOST_CFG, M98095_SEG, M98095_SEG);
+	m98095_eq_band(codec, channel, 0, coef_set->band1);
+	m98095_eq_band(codec, channel, 1, coef_set->band2);
+	m98095_eq_band(codec, channel, 2, coef_set->band3);
+	m98095_eq_band(codec, channel, 3, coef_set->band4);
+	m98095_eq_band(codec, channel, 4, coef_set->band5);
+	snd_soc_update_bits(codec, M98095_00F_HOST_CFG, M98095_SEG, 0);
+	mutex_unlock(&codec->mutex);
+
+	/* Restore the original on/off state */
+	snd_soc_update_bits(codec, M98095_088_CFG_LEVEL, regmask, regsave);
+	return 0;
+}
+
+static int max98095_get_eq_enum(struct snd_kcontrol *kcontrol,
+				 struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct max98095_priv *max98095 = snd_soc_codec_get_drvdata(codec);
+	int channel = max98095_get_eq_channel(kcontrol->id.name);
+	struct max98095_cdata *cdata;
+
+	cdata = &max98095->dai[channel];
+	ucontrol->value.enumerated.item[0] = cdata->eq_sel;
+
+	return 0;
+}
+
+static void max98095_handle_eq_pdata(struct snd_soc_codec *codec)
+{
+	struct max98095_priv *max98095 = snd_soc_codec_get_drvdata(codec);
+	struct max98095_pdata *pdata = max98095->pdata;
+	struct max98095_eq_cfg *cfg;
+	unsigned int cfgcnt;
+	int i, j;
+	const char **t;
+	int ret;
+
+	struct snd_kcontrol_new controls[] = {
+		SOC_ENUM_EXT("EQ1 Mode",
+			max98095->eq_enum,
+			max98095_get_eq_enum,
+			max98095_put_eq_enum),
+		SOC_ENUM_EXT("EQ2 Mode",
+			max98095->eq_enum,
+			max98095_get_eq_enum,
+			max98095_put_eq_enum),
+	};
+
+	cfg = pdata->eq_cfg;
+	cfgcnt = pdata->eq_cfgcnt;
+
+	/* Setup an array of texts for the equalizer enum.
+	 * This is based on Mark Brown's equalizer driver code.
+	 */
+	max98095->eq_textcnt = 0;
+	max98095->eq_texts = NULL;
+	for (i = 0; i < cfgcnt; i++) {
+		for (j = 0; j < max98095->eq_textcnt; j++) {
+			if (strcmp(cfg[i].name, max98095->eq_texts[j]) == 0)
+				break;
+		}
+
+		if (j != max98095->eq_textcnt)
+			continue;
+
+		/* Expand the array */
+		t = krealloc(max98095->eq_texts,
+			     sizeof(char *) * (max98095->eq_textcnt + 1),
+			     GFP_KERNEL);
+		if (t == NULL)
+			continue;
+
+		/* Store the new entry */
+		t[max98095->eq_textcnt] = cfg[i].name;
+		max98095->eq_textcnt++;
+		max98095->eq_texts = t;
+	}
+
+	/* Now point the soc_enum to .texts array items */
+	max98095->eq_enum.texts = max98095->eq_texts;
+	max98095->eq_enum.max = max98095->eq_textcnt;
+
+	ret = snd_soc_add_controls(codec, controls, ARRAY_SIZE(controls));
+	if (ret != 0)
+		dev_err(codec->dev, "Failed to add EQ control: %d\n", ret);
+}
+
+static int max98095_get_bq_channel(const char *name)
+{
+	if (strcmp(name, "Biquad1 Mode") == 0)
+		return 0;
+	if (strcmp(name, "Biquad2 Mode") == 0)
+		return 1;
+	return -EINVAL;
+}
+
+static int max98095_put_bq_enum(struct snd_kcontrol *kcontrol,
+				 struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct max98095_priv *max98095 = snd_soc_codec_get_drvdata(codec);
+	struct max98095_pdata *pdata = max98095->pdata;
+	int channel = max98095_get_bq_channel(kcontrol->id.name);
+	struct max98095_cdata *cdata;
+	int sel = ucontrol->value.integer.value[0];
+	struct max98095_biquad_cfg *coef_set;
+	int fs, best, best_val, i;
+	int regmask, regsave;
+
+	BUG_ON(channel > 1);
+
+	cdata = &max98095->dai[channel];
+
+	if (sel >= pdata->bq_cfgcnt)
+		return -EINVAL;
+
+	cdata->bq_sel = sel;
+
+	if (!pdata || !max98095->bq_textcnt)
+		return 0;
+
+	fs = cdata->rate;
+
+	/* Find the selected configuration with nearest sample rate */
+	best = 0;
+	best_val = INT_MAX;
+	for (i = 0; i < pdata->bq_cfgcnt; i++) {
+		if (strcmp(pdata->bq_cfg[i].name, max98095->bq_texts[sel]) == 0 &&
+			abs(pdata->bq_cfg[i].rate - fs) < best_val) {
+			best = i;
+			best_val = abs(pdata->bq_cfg[i].rate - fs);
+		}
+	}
+
+	dev_dbg(codec->dev, "Selected %s/%dHz for %dHz sample rate\n",
+		pdata->bq_cfg[best].name,
+		pdata->bq_cfg[best].rate, fs);
+
+	coef_set = &pdata->bq_cfg[best];
+
+	regmask = (channel == 0) ? M98095_BQ1EN : M98095_BQ2EN;
+
+	/* Disable filter while configuring, and save current on/off state */
+	regsave = snd_soc_read(codec, M98095_088_CFG_LEVEL);
+	snd_soc_update_bits(codec, M98095_088_CFG_LEVEL, regmask, 0);
+
+	mutex_lock(&codec->mutex);
+	snd_soc_update_bits(codec, M98095_00F_HOST_CFG, M98095_SEG, M98095_SEG);
+	m98095_biquad_band(codec, channel, 0, coef_set->band1);
+	m98095_biquad_band(codec, channel, 1, coef_set->band2);
+	snd_soc_update_bits(codec, M98095_00F_HOST_CFG, M98095_SEG, 0);
+	mutex_unlock(&codec->mutex);
+
+	/* Restore the original on/off state */
+	snd_soc_update_bits(codec, M98095_088_CFG_LEVEL, regmask, regsave);
+	return 0;
+}
+
+static int max98095_get_bq_enum(struct snd_kcontrol *kcontrol,
+				 struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct max98095_priv *max98095 = snd_soc_codec_get_drvdata(codec);
+	int channel = max98095_get_bq_channel(kcontrol->id.name);
+	struct max98095_cdata *cdata;
+
+	cdata = &max98095->dai[channel];
+	ucontrol->value.enumerated.item[0] = cdata->bq_sel;
+
+	return 0;
+}
+
+static void max98095_handle_bq_pdata(struct snd_soc_codec *codec)
+{
+	struct max98095_priv *max98095 = snd_soc_codec_get_drvdata(codec);
+	struct max98095_pdata *pdata = max98095->pdata;
+	struct max98095_biquad_cfg *cfg;
+	unsigned int cfgcnt;
+	int i, j;
+	const char **t;
+	int ret;
+
+	struct snd_kcontrol_new controls[] = {
+		SOC_ENUM_EXT("Biquad1 Mode",
+			max98095->bq_enum,
+			max98095_get_bq_enum,
+			max98095_put_bq_enum),
+		SOC_ENUM_EXT("Biquad2 Mode",
+			max98095->bq_enum,
+			max98095_get_bq_enum,
+			max98095_put_bq_enum),
+	};
+
+	cfg = pdata->bq_cfg;
+	cfgcnt = pdata->bq_cfgcnt;
+
+	/* Setup an array of texts for the biquad enum.
+	 * This is based on Mark Brown's equalizer driver code.
+	 */
+	max98095->bq_textcnt = 0;
+	max98095->bq_texts = NULL;
+	for (i = 0; i < cfgcnt; i++) {
+		for (j = 0; j < max98095->bq_textcnt; j++) {
+			if (strcmp(cfg[i].name, max98095->bq_texts[j]) == 0)
+				break;
+		}
+
+		if (j != max98095->bq_textcnt)
+			continue;
+
+		/* Expand the array */
+		t = krealloc(max98095->bq_texts,
+			     sizeof(char *) * (max98095->bq_textcnt + 1),
+			     GFP_KERNEL);
+		if (t == NULL)
+			continue;
+
+		/* Store the new entry */
+		t[max98095->bq_textcnt] = cfg[i].name;
+		max98095->bq_textcnt++;
+		max98095->bq_texts = t;
+	}
+
+	/* Now point the soc_enum to .texts array items */
+	max98095->bq_enum.texts = max98095->bq_texts;
+	max98095->bq_enum.max = max98095->bq_textcnt;
+
+	ret = snd_soc_add_controls(codec, controls, ARRAY_SIZE(controls));
+	if (ret != 0)
+		dev_err(codec->dev, "Failed to add Biquad control: %d\n", ret);
+}
+
 static void max98095_handle_pdata(struct snd_soc_codec *codec)
 {
 	struct max98095_priv *max98095 = snd_soc_codec_get_drvdata(codec);
@@ -1785,6 +2160,14 @@ static void max98095_handle_pdata(struct snd_soc_codec *codec)
 		regval |= M98095_DIGMIC_R;
 
 	snd_soc_write(codec, M98095_087_CFG_MIC, regval);
+
+	/* Configure equalizers */
+	if (pdata->eq_cfgcnt)
+		max98095_handle_eq_pdata(codec);
+
+	/* Configure bi-quad filters */
+	if (pdata->bq_cfgcnt)
+		max98095_handle_bq_pdata(codec);
 }
 
 #ifdef CONFIG_PM
@@ -1855,18 +2238,26 @@ static int max98095_probe(struct snd_soc_codec *codec)
 	/* initialize private data */
 
 	max98095->sysclk = (unsigned)-1;
+	max98095->eq_textcnt = 0;
+	max98095->bq_textcnt = 0;
 
 	cdata = &max98095->dai[0];
 	cdata->rate = (unsigned)-1;
 	cdata->fmt  = (unsigned)-1;
+	cdata->eq_sel = 0;
+	cdata->bq_sel = 0;
 
 	cdata = &max98095->dai[1];
 	cdata->rate = (unsigned)-1;
 	cdata->fmt  = (unsigned)-1;
+	cdata->eq_sel = 0;
+	cdata->bq_sel = 0;
 
 	cdata = &max98095->dai[2];
 	cdata->rate = (unsigned)-1;
 	cdata->fmt  = (unsigned)-1;
+	cdata->eq_sel = 0;
+	cdata->bq_sel = 0;
 
 	max98095->lin_state = 0;
 	max98095->mic1pre = 0;
diff --git a/sound/soc/codecs/max98095.h b/sound/soc/codecs/max98095.h
index 5b22bc8..891584a 100644
--- a/sound/soc/codecs/max98095.h
+++ b/sound/soc/codecs/max98095.h
@@ -250,6 +250,8 @@
 /* M98095_088_CFG_LEVEL */
 	#define M98095_VSEN                     (1<<6)
 	#define M98095_ZDEN                     (1<<5)
+	#define M98095_BQ2EN                    (1<<3)
+	#define M98095_BQ1EN                    (1<<2)
 	#define M98095_EQ2EN                    (1<<1)
 	#define M98095_EQ1EN                    (1<<0)
 
@@ -281,4 +283,17 @@
 	#define M98095_PWRSV8K                  (1<<1)
 	#define M98095_PWRSV                    (1<<0)
 
+#define M98095_COEFS_PER_BAND            5
+
+#define M98095_BYTE1(w) ((w >> 8) & 0xff)
+#define M98095_BYTE0(w) (w & 0xff)
+
+/* Equalizer filter coefficients */
+#define M98095_110_DAI1_EQ_BASE             0x10
+#define M98095_142_DAI2_EQ_BASE             0x42
+
+/* Biquad filter coefficients */
+#define M98095_174_DAI1_BQ_BASE             0x74
+#define M98095_17E_DAI2_BQ_BASE             0x7E
+
 #endif
-- 
1.6.3.3

