Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab0LXNtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 08:49:16 -0500
Received: from smtp-out-045.synserver.de ([212.40.180.45]:1194 "HELO
	smtp-out-045.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752708Ab0LXNsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 08:48:55 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 27157
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Subject: [PATCH 9/9] ASoC: codecs: wm8753: Fix register cache incoherency
Date: Fri, 24 Dec 2010 14:48:04 +0100
Message-Id: <1293198484-1902-10-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1293198484-1902-1-git-send-email-lars@metafoo.de>
References: <1293198484-1902-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The multi-component patch(commit f0fba2ad1) introduced a generic register cache
framework. But the wm8753 driver still uses its own register cache for its
private functions, while functions from the ASoC core use the generic cache.
Furthermore the generic cache uses zero-based numbering while the wm8753 cache
uses one-based numbering.
Thus we end up with two from each other incoherent caches, which leads to undefined
behaviour.
This patch fixes the issue by changing the wm8753 driver to use the generic
cache framework.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ian Lartey <ian@opensource.wolfsonmicro.com>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 sound/soc/codecs/wm8753.c |  267 +++++++++++++++++----------------------------
 1 files changed, 99 insertions(+), 168 deletions(-)

diff --git a/sound/soc/codecs/wm8753.c b/sound/soc/codecs/wm8753.c
index 73507e7..12c647a 100644
--- a/sound/soc/codecs/wm8753.c
+++ b/sound/soc/codecs/wm8753.c
@@ -64,22 +64,22 @@ static void wm8753_set_dai_mode(struct snd_soc_codec *codec,
  * are using 2 wire for device control, so we cache them instead.
  */
 static const u16 wm8753_reg[] = {
-	0x0008, 0x0000, 0x000a, 0x000a,
-	0x0033, 0x0000, 0x0007, 0x00ff,
-	0x00ff, 0x000f, 0x000f, 0x007b,
-	0x0000, 0x0032, 0x0000, 0x00c3,
-	0x00c3, 0x00c0, 0x0000, 0x0000,
+	0x0000, 0x0008, 0x0000, 0x000a,
+	0x000a, 0x0033, 0x0000, 0x0007,
+	0x00ff, 0x00ff, 0x000f, 0x000f,
+	0x007b, 0x0000, 0x0032, 0x0000,
+	0x00c3, 0x00c3, 0x00c0, 0x0000,
 	0x0000, 0x0000, 0x0000, 0x0000,
 	0x0000, 0x0000, 0x0000, 0x0000,
-	0x0000, 0x0000, 0x0000, 0x0055,
-	0x0005, 0x0050, 0x0055, 0x0050,
-	0x0055, 0x0050, 0x0055, 0x0079,
-	0x0079, 0x0079, 0x0079, 0x0079,
 	0x0000, 0x0000, 0x0000, 0x0000,
-	0x0097, 0x0097, 0x0000, 0x0004,
-	0x0000, 0x0083, 0x0024, 0x01ba,
-	0x0000, 0x0083, 0x0024, 0x01ba,
-	0x0000, 0x0000, 0x0000
+	0x0055, 0x0005, 0x0050, 0x0055,
+	0x0050, 0x0055, 0x0050, 0x0055,
+	0x0079, 0x0079, 0x0079, 0x0079,
+	0x0079, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0097, 0x0097, 0x0000,
+	0x0004, 0x0000, 0x0083, 0x0024,
+	0x01ba, 0x0000, 0x0083, 0x0024,
+	0x01ba, 0x0000, 0x0000, 0x0000
 };
 
 /* codec private data */
@@ -87,57 +87,10 @@ struct wm8753_priv {
 	enum snd_soc_control_type control_type;
 	unsigned int sysclk;
 	unsigned int pcmclk;
-	u16 reg_cache[ARRAY_SIZE(wm8753_reg)];
 	int dai_func;
 };
 
-/*
- * read wm8753 register cache
- */
-static inline unsigned int wm8753_read_reg_cache(struct snd_soc_codec *codec,
-	unsigned int reg)
-{
-	u16 *cache = codec->reg_cache;
-	if (reg < 1 || reg >= (ARRAY_SIZE(wm8753_reg) + 1))
-		return -1;
-	return cache[reg - 1];
-}
-
-/*
- * write wm8753 register cache
- */
-static inline void wm8753_write_reg_cache(struct snd_soc_codec *codec,
-	unsigned int reg, unsigned int value)
-{
-	u16 *cache = codec->reg_cache;
-	if (reg < 1 || reg >= (ARRAY_SIZE(wm8753_reg) + 1))
-		return;
-	cache[reg - 1] = value;
-}
-
-/*
- * write to the WM8753 register space
- */
-static int wm8753_write(struct snd_soc_codec *codec, unsigned int reg,
-	unsigned int value)
-{
-	u8 data[2];
-
-	/* data is
-	 *   D15..D9 WM8753 register offset
-	 *   D8...D0 register data
-	 */
-	data[0] = (reg << 1) | ((value >> 8) & 0x0001);
-	data[1] = value & 0x00ff;
-
-	wm8753_write_reg_cache(codec, reg, value);
-	if (codec->hw_write(codec->control_data, data, 2) == 2)
-		return 0;
-	else
-		return -EIO;
-}
-
-#define wm8753_reset(c) wm8753_write(c, WM8753_RESET, 0)
+#define wm8753_reset(c) snd_soc_write(c, WM8753_RESET, 0)
 
 /*
  * WM8753 Controls
@@ -217,7 +170,7 @@ static int wm8753_get_dai(struct snd_kcontrol *kcontrol,
 	struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_codec *codec =  snd_kcontrol_chip(kcontrol);
-	int mode = wm8753_read_reg_cache(codec, WM8753_IOCTL);
+	int mode = snd_soc_read(codec, WM8753_IOCTL);
 
 	ucontrol->value.integer.value[0] = (mode & 0xc) >> 2;
 	return 0;
@@ -227,7 +180,7 @@ static int wm8753_set_dai(struct snd_kcontrol *kcontrol,
 	struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_codec *codec =  snd_kcontrol_chip(kcontrol);
-	int mode = wm8753_read_reg_cache(codec, WM8753_IOCTL);
+	int mode = snd_soc_read(codec, WM8753_IOCTL);
 	struct wm8753_priv *wm8753 = snd_soc_codec_get_drvdata(codec);
 
 	if (((mode & 0xc) >> 2) == ucontrol->value.integer.value[0])
@@ -738,17 +691,17 @@ static int wm8753_set_dai_pll(struct snd_soc_dai *codec_dai, int pll_id,
 	if (pll_id == WM8753_PLL1) {
 		offset = 0;
 		enable = 0x10;
-		reg = wm8753_read_reg_cache(codec, WM8753_CLOCK) & 0xffef;
+		reg = snd_soc_read(codec, WM8753_CLOCK) & 0xffef;
 	} else {
 		offset = 4;
 		enable = 0x8;
-		reg = wm8753_read_reg_cache(codec, WM8753_CLOCK) & 0xfff7;
+		reg = snd_soc_read(codec, WM8753_CLOCK) & 0xfff7;
 	}
 
 	if (!freq_in || !freq_out) {
 		/* disable PLL  */
-		wm8753_write(codec, WM8753_PLL1CTL1 + offset, 0x0026);
-		wm8753_write(codec, WM8753_CLOCK, reg);
+		snd_soc_write(codec, WM8753_PLL1CTL1 + offset, 0x0026);
+		snd_soc_write(codec, WM8753_CLOCK, reg);
 		return 0;
 	} else {
 		u16 value = 0;
@@ -759,20 +712,20 @@ static int wm8753_set_dai_pll(struct snd_soc_dai *codec_dai, int pll_id,
 		/* set up N and K PLL divisor ratios */
 		/* bits 8:5 = PLL_N, bits 3:0 = PLL_K[21:18] */
 		value = (pll_div.n << 5) + ((pll_div.k & 0x3c0000) >> 18);
-		wm8753_write(codec, WM8753_PLL1CTL2 + offset, value);
+		snd_soc_write(codec, WM8753_PLL1CTL2 + offset, value);
 
 		/* bits 8:0 = PLL_K[17:9] */
 		value = (pll_div.k & 0x03fe00) >> 9;
-		wm8753_write(codec, WM8753_PLL1CTL3 + offset, value);
+		snd_soc_write(codec, WM8753_PLL1CTL3 + offset, value);
 
 		/* bits 8:0 = PLL_K[8:0] */
 		value = pll_div.k & 0x0001ff;
-		wm8753_write(codec, WM8753_PLL1CTL4 + offset, value);
+		snd_soc_write(codec, WM8753_PLL1CTL4 + offset, value);
 
 		/* set PLL as input and enable */
-		wm8753_write(codec, WM8753_PLL1CTL1 + offset, 0x0027 |
+		snd_soc_write(codec, WM8753_PLL1CTL1 + offset, 0x0027 |
 			(pll_div.div2 << 3));
-		wm8753_write(codec, WM8753_CLOCK, reg | enable);
+		snd_soc_write(codec, WM8753_CLOCK, reg | enable);
 	}
 	return 0;
 }
@@ -879,29 +832,30 @@ static int wm8753_vdac_adc_set_dai_fmt(struct snd_soc_dai *codec_dai,
 		unsigned int fmt)
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
-	u16 voice = wm8753_read_reg_cache(codec, WM8753_PCM) & 0x01ec;
+	u16 voice;
 
 	/* interface format */
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S:
-		voice |= 0x0002;
+		voice = 0x0002;
 		break;
 	case SND_SOC_DAIFMT_RIGHT_J:
+		voice = 0x0000;
 		break;
 	case SND_SOC_DAIFMT_LEFT_J:
-		voice |= 0x0001;
+		voice = 0x0001;
 		break;
 	case SND_SOC_DAIFMT_DSP_A:
-		voice |= 0x0003;
+		voice = 0x0003;
 		break;
 	case SND_SOC_DAIFMT_DSP_B:
-		voice |= 0x0013;
+		voice = 0x0013;
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	wm8753_write(codec, WM8753_PCM, voice);
+	snd_soc_update_bits(codec, WM8753_PCM, 0x0013, voice);
 	return 0;
 }
 
@@ -922,30 +876,32 @@ static int wm8753_pcm_hw_params(struct snd_pcm_substream *substream,
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
 	struct snd_soc_codec *codec = rtd->codec;
 	struct wm8753_priv *wm8753 = snd_soc_codec_get_drvdata(codec);
-	u16 voice = wm8753_read_reg_cache(codec, WM8753_PCM) & 0x01f3;
-	u16 srate = wm8753_read_reg_cache(codec, WM8753_SRATE1) & 0x017f;
+	u16 voice = 0x0000;
+	u16 srate;
 
 	/* bit size */
 	switch (params_format(params)) {
 	case SNDRV_PCM_FORMAT_S16_LE:
 		break;
 	case SNDRV_PCM_FORMAT_S20_3LE:
-		voice |= 0x0004;
+		voice = 0x0004;
 		break;
 	case SNDRV_PCM_FORMAT_S24_LE:
-		voice |= 0x0008;
+		voice = 0x0008;
 		break;
 	case SNDRV_PCM_FORMAT_S32_LE:
-		voice |= 0x000c;
+		voice = 0x000c;
 		break;
 	}
 
 	/* sample rate */
 	if (params_rate(params) * 384 == wm8753->pcmclk)
-		srate |= 0x80;
-	wm8753_write(codec, WM8753_SRATE1, srate);
+		srate = 0x80;
+	else
+		srate = 0x00;
 
-	wm8753_write(codec, WM8753_PCM, voice);
+	snd_soc_update_bits(codec, WM8753_SRATE1, 0x0080, srate);
+	snd_soc_update_bits(codec, WM8753_PCM, 0x000c, voice);
 	return 0;
 }
 
@@ -956,17 +912,16 @@ static int wm8753_pcm_set_dai_fmt(struct snd_soc_dai *codec_dai,
 		unsigned int fmt)
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
-	u16 voice, ioctl;
+	u16 voice, ioctl = 0;
 
-	voice = wm8753_read_reg_cache(codec, WM8753_PCM) & 0x011f;
-	ioctl = wm8753_read_reg_cache(codec, WM8753_IOCTL) & 0x015d;
+	voice = snd_soc_read(codec, WM8753_PCM) & 0x011f;
 
 	/* set master/slave audio interface */
 	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
 	case SND_SOC_DAIFMT_CBS_CFS:
 		break;
 	case SND_SOC_DAIFMT_CBM_CFM:
-		ioctl |= 0x2;
+		ioctl = 0x2;
 	case SND_SOC_DAIFMT_CBM_CFS:
 		voice |= 0x0040;
 		break;
@@ -1013,8 +968,8 @@ static int wm8753_pcm_set_dai_fmt(struct snd_soc_dai *codec_dai,
 		return -EINVAL;
 	}
 
-	wm8753_write(codec, WM8753_PCM, voice);
-	wm8753_write(codec, WM8753_IOCTL, ioctl);
+	snd_soc_write(codec, WM8753_PCM, voice);
+	snd_soc_update_bits(codec, WM8753_IOCTL, 0x00a2, ioctl);
 	return 0;
 }
 
@@ -1022,20 +977,16 @@ static int wm8753_set_dai_clkdiv(struct snd_soc_dai *codec_dai,
 		int div_id, int div)
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
-	u16 reg;
 
 	switch (div_id) {
 	case WM8753_PCMDIV:
-		reg = wm8753_read_reg_cache(codec, WM8753_CLOCK) & 0x003f;
-		wm8753_write(codec, WM8753_CLOCK, reg | div);
+		snd_soc_update_bits(codec, WM8753_CLOCK, 0x01c0, div);
 		break;
 	case WM8753_BCLKDIV:
-		reg = wm8753_read_reg_cache(codec, WM8753_SRATE2) & 0x01c7;
-		wm8753_write(codec, WM8753_SRATE2, reg | div);
+		snd_soc_update_bits(codec, WM8753_SRATE2, 0x0038, div);
 		break;
 	case WM8753_VXCLKDIV:
-		reg = wm8753_read_reg_cache(codec, WM8753_SRATE2) & 0x003f;
-		wm8753_write(codec, WM8753_SRATE2, reg | div);
+		snd_soc_update_bits(codec, WM8753_SRATE2, 0x01c0, div);
 		break;
 	default:
 		return -EINVAL;
@@ -1050,29 +1001,30 @@ static int wm8753_hdac_set_dai_fmt(struct snd_soc_dai *codec_dai,
 		unsigned int fmt)
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
-	u16 hifi = wm8753_read_reg_cache(codec, WM8753_HIFI) & 0x01e0;
+	u16 hifi;
 
 	/* interface format */
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S:
-		hifi |= 0x0002;
+		hifi = 0x0002;
 		break;
 	case SND_SOC_DAIFMT_RIGHT_J:
+		hifi = 0x0000;
 		break;
 	case SND_SOC_DAIFMT_LEFT_J:
-		hifi |= 0x0001;
+		hifi = 0x0001;
 		break;
 	case SND_SOC_DAIFMT_DSP_A:
-		hifi |= 0x0003;
+		hifi = 0x0003;
 		break;
 	case SND_SOC_DAIFMT_DSP_B:
-		hifi |= 0x0013;
+		hifi = 0x0013;
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	wm8753_write(codec, WM8753_HIFI, hifi);
+	snd_soc_update_bits(codec, WM8753_HIFI, 0x001f, hifi);
 	return 0;
 }
 
@@ -1083,17 +1035,16 @@ static int wm8753_i2s_set_dai_fmt(struct snd_soc_dai *codec_dai,
 		unsigned int fmt)
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
-	u16 ioctl, hifi;
+	u16 hifi, ioctl = 0x0;
 
-	hifi = wm8753_read_reg_cache(codec, WM8753_HIFI) & 0x011f;
-	ioctl = wm8753_read_reg_cache(codec, WM8753_IOCTL) & 0x00ae;
+	hifi = snd_soc_read(codec, WM8753_HIFI) & 0x011f;
 
 	/* set master/slave audio interface */
 	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
 	case SND_SOC_DAIFMT_CBS_CFS:
 		break;
 	case SND_SOC_DAIFMT_CBM_CFM:
-		ioctl |= 0x1;
+		ioctl = 0x1;
 	case SND_SOC_DAIFMT_CBM_CFS:
 		hifi |= 0x0040;
 		break;
@@ -1140,8 +1091,8 @@ static int wm8753_i2s_set_dai_fmt(struct snd_soc_dai *codec_dai,
 		return -EINVAL;
 	}
 
-	wm8753_write(codec, WM8753_HIFI, hifi);
-	wm8753_write(codec, WM8753_IOCTL, ioctl);
+	snd_soc_write(codec, WM8753_HIFI, hifi);
+	snd_soc_update_bits(codec, WM8753_IOCTL, 0x0151, ioctl);
 	return 0;
 }
 
@@ -1162,8 +1113,7 @@ static int wm8753_i2s_hw_params(struct snd_pcm_substream *substream,
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
 	struct snd_soc_codec *codec = rtd->codec;
 	struct wm8753_priv *wm8753 = snd_soc_codec_get_drvdata(codec);
-	u16 srate = wm8753_read_reg_cache(codec, WM8753_SRATE1) & 0x01c0;
-	u16 hifi = wm8753_read_reg_cache(codec, WM8753_HIFI) & 0x01f3;
+	u16 hifi = 0x0000;
 	int coeff;
 
 	/* is digital filter coefficient valid ? */
@@ -1172,25 +1122,25 @@ static int wm8753_i2s_hw_params(struct snd_pcm_substream *substream,
 		printk(KERN_ERR "wm8753 invalid MCLK or rate\n");
 		return coeff;
 	}
-	wm8753_write(codec, WM8753_SRATE1, srate | (coeff_div[coeff].sr << 1) |
-		coeff_div[coeff].usb);
+	snd_soc_update_bits(codec, WM8753_SRATE1, 0x003f,
+		(coeff_div[coeff].sr << 1) | coeff_div[coeff].usb);
 
 	/* bit size */
 	switch (params_format(params)) {
 	case SNDRV_PCM_FORMAT_S16_LE:
 		break;
 	case SNDRV_PCM_FORMAT_S20_3LE:
-		hifi |= 0x0004;
+		hifi = 0x0004;
 		break;
 	case SNDRV_PCM_FORMAT_S24_LE:
-		hifi |= 0x0008;
+		hifi = 0x0008;
 		break;
 	case SNDRV_PCM_FORMAT_S32_LE:
-		hifi |= 0x000c;
+		hifi = 0x000c;
 		break;
 	}
 
-	wm8753_write(codec, WM8753_HIFI, hifi);
+	snd_soc_update_bits(codec, WM8753_HIFI, 0x000c, hifi);
 	return 0;
 }
 
@@ -1198,11 +1148,9 @@ static int wm8753_mode1v_set_dai_fmt(struct snd_soc_dai *codec_dai,
 		unsigned int fmt)
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
-	u16 clock;
 
 	/* set clk source as pcmclk */
-	clock = wm8753_read_reg_cache(codec, WM8753_CLOCK) & 0xfffb;
-	wm8753_write(codec, WM8753_CLOCK, clock);
+	snd_soc_update_bits(codec, WM8753_CLOCK, 0x0004, 0x0);
 
 	if (wm8753_vdac_adc_set_dai_fmt(codec_dai, fmt) < 0)
 		return -EINVAL;
@@ -1221,11 +1169,9 @@ static int wm8753_mode2_set_dai_fmt(struct snd_soc_dai *codec_dai,
 		unsigned int fmt)
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
-	u16 clock;
 
 	/* set clk source as pcmclk */
-	clock = wm8753_read_reg_cache(codec, WM8753_CLOCK) & 0xfffb;
-	wm8753_write(codec, WM8753_CLOCK, clock);
+	snd_soc_update_bits(codec, WM8753_CLOCK, 0x0004, 0x0);
 
 	if (wm8753_vdac_adc_set_dai_fmt(codec_dai, fmt) < 0)
 		return -EINVAL;
@@ -1236,11 +1182,9 @@ static int wm8753_mode3_4_set_dai_fmt(struct snd_soc_dai *codec_dai,
 		unsigned int fmt)
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
-	u16 clock;
 
 	/* set clk source as mclk */
-	clock = wm8753_read_reg_cache(codec, WM8753_CLOCK) & 0xfffb;
-	wm8753_write(codec, WM8753_CLOCK, clock | 0x4);
+	snd_soc_update_bits(codec, WM8753_CLOCK, 0x0004, 0x4);
 
 	if (wm8753_hdac_set_dai_fmt(codec_dai, fmt) < 0)
 		return -EINVAL;
@@ -1252,19 +1196,18 @@ static int wm8753_mode3_4_set_dai_fmt(struct snd_soc_dai *codec_dai,
 static int wm8753_mute(struct snd_soc_dai *dai, int mute)
 {
 	struct snd_soc_codec *codec = dai->codec;
-	u16 mute_reg = wm8753_read_reg_cache(codec, WM8753_DAC) & 0xfff7;
 	struct wm8753_priv *wm8753 = snd_soc_codec_get_drvdata(codec);
 
 	/* the digital mute covers the HiFi and Voice DAC's on the WM8753.
 	 * make sure we check if they are not both active when we mute */
 	if (mute && wm8753->dai_func == 1) {
 		if (!codec->active)
-			wm8753_write(codec, WM8753_DAC, mute_reg | 0x8);
+			snd_soc_update_bits(codec, WM8753_DAC, 0x0008, 0x8);
 	} else {
 		if (mute)
-			wm8753_write(codec, WM8753_DAC, mute_reg | 0x8);
+			snd_soc_update_bits(codec, WM8753_DAC, 0x0008, 0x8);
 		else
-			wm8753_write(codec, WM8753_DAC, mute_reg);
+			snd_soc_update_bits(codec, WM8753_DAC, 0x0008, 0x0);
 	}
 
 	return 0;
@@ -1273,23 +1216,21 @@ static int wm8753_mute(struct snd_soc_dai *dai, int mute)
 static int wm8753_set_bias_level(struct snd_soc_codec *codec,
 				 enum snd_soc_bias_level level)
 {
-	u16 pwr_reg = wm8753_read_reg_cache(codec, WM8753_PWR1) & 0xfe3e;
-
 	switch (level) {
 	case SND_SOC_BIAS_ON:
 		/* set vmid to 50k and unmute dac */
-		wm8753_write(codec, WM8753_PWR1, pwr_reg | 0x00c0);
+		snd_soc_update_bits(codec, WM8753_PWR1, 0x01c1, 0x00c0);
 		break;
 	case SND_SOC_BIAS_PREPARE:
 		/* set vmid to 5k for quick power up */
-		wm8753_write(codec, WM8753_PWR1, pwr_reg | 0x01c1);
+		snd_soc_update_bits(codec, WM8753_PWR1, 0x01c1, 0x01c1);
 		break;
 	case SND_SOC_BIAS_STANDBY:
 		/* mute dac and set vmid to 500k, enable VREF */
-		wm8753_write(codec, WM8753_PWR1, pwr_reg | 0x0141);
+		snd_soc_update_bits(codec, WM8753_PWR1, 0x01c1, 0x0141);
 		break;
 	case SND_SOC_BIAS_OFF:
-		wm8753_write(codec, WM8753_PWR1, 0x0001);
+		snd_soc_write(codec, WM8753_PWR1, 0x0001);
 		break;
 	}
 	codec->dapm.bias_level = level;
@@ -1477,7 +1418,7 @@ static void wm8753_set_dai_mode(struct snd_soc_codec *codec,
 		else
 			dai->driver = &wm8753_all_dai[(wm8753->dai_func << 1) + 1];
 	}
-	wm8753_write(codec, WM8753_IOCTL, wm8753->dai_func);
+	snd_soc_write(codec, WM8753_IOCTL, wm8753->dai_func);
 }
 
 static void wm8753_work(struct work_struct *work)
@@ -1498,21 +1439,21 @@ static int wm8753_suspend(struct snd_soc_codec *codec, pm_message_t state)
 static int wm8753_resume(struct snd_soc_codec *codec)
 {
 	int i;
-	u8 data[2];
-	u16 *cache = codec->reg_cache;
+	unsigned int val;
 
 	/* Sync reg_cache with the hardware */
-	for (i = 0; i < ARRAY_SIZE(wm8753_reg); i++) {
-		if (i + 1 == WM8753_RESET)
+	for (i = 1; i < ARRAY_SIZE(wm8753_reg); i++) {
+		if (i == WM8753_RESET)
+			continue;
+
+		if (snd_soc_cache_read(codec, i, &val))
 			continue;
 
 		/* No point in writing hardware default values back */
-		if (cache[i] == wm8753_reg[i])
+		if (val == wm8753_reg[i])
 			continue;
 
-		data[0] = ((i + 1) << 1) | ((cache[i] >> 8) & 0x0001);
-		data[1] = cache[i] & 0x00ff;
-		codec->hw_write(codec->control_data, data, 2);
+		snd_soc_write(codec, i, val);
 	}
 
 	wm8753_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
@@ -1531,7 +1472,7 @@ static int wm8753_resume(struct snd_soc_codec *codec)
 static int wm8753_probe(struct snd_soc_codec *codec)
 {
 	struct wm8753_priv *wm8753 = snd_soc_codec_get_drvdata(codec);
-	int ret = 0, reg;
+	int ret;
 
 	INIT_DELAYED_WORK(&codec->dapm.delayed_work, wm8753_work);
 
@@ -1556,26 +1497,16 @@ static int wm8753_probe(struct snd_soc_codec *codec)
 			      msecs_to_jiffies(caps_charge));
 
 	/* set the update bits */
-	reg = wm8753_read_reg_cache(codec, WM8753_LDAC);
-	wm8753_write(codec, WM8753_LDAC, reg | 0x0100);
-	reg = wm8753_read_reg_cache(codec, WM8753_RDAC);
-	wm8753_write(codec, WM8753_RDAC, reg | 0x0100);
-	reg = wm8753_read_reg_cache(codec, WM8753_LADC);
-	wm8753_write(codec, WM8753_LADC, reg | 0x0100);
-	reg = wm8753_read_reg_cache(codec, WM8753_RADC);
-	wm8753_write(codec, WM8753_RADC, reg | 0x0100);
-	reg = wm8753_read_reg_cache(codec, WM8753_LOUT1V);
-	wm8753_write(codec, WM8753_LOUT1V, reg | 0x0100);
-	reg = wm8753_read_reg_cache(codec, WM8753_ROUT1V);
-	wm8753_write(codec, WM8753_ROUT1V, reg | 0x0100);
-	reg = wm8753_read_reg_cache(codec, WM8753_LOUT2V);
-	wm8753_write(codec, WM8753_LOUT2V, reg | 0x0100);
-	reg = wm8753_read_reg_cache(codec, WM8753_ROUT2V);
-	wm8753_write(codec, WM8753_ROUT2V, reg | 0x0100);
-	reg = wm8753_read_reg_cache(codec, WM8753_LINVOL);
-	wm8753_write(codec, WM8753_LINVOL, reg | 0x0100);
-	reg = wm8753_read_reg_cache(codec, WM8753_RINVOL);
-	wm8753_write(codec, WM8753_RINVOL, reg | 0x0100);
+	snd_soc_update_bits(codec, WM8753_LDAC, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8753_RDAC, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8753_LDAC, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8753_RDAC, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8753_LOUT1V, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8753_ROUT1V, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8753_LOUT2V, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8753_ROUT2V, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8753_LINVOL, 0x0100, 0x0100);
+	snd_soc_update_bits(codec, WM8753_RINVOL, 0x0100, 0x0100);
 
 	snd_soc_add_controls(codec, wm8753_snd_controls,
 			     ARRAY_SIZE(wm8753_snd_controls));
-- 
1.7.2.3

