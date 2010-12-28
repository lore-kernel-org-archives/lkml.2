Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab0L1Ui1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 15:38:27 -0500
Received: from smtp-out-091.synserver.de ([212.40.180.91]:1099 "HELO
	smtp-out-089.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1752035Ab0L1UiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 15:38:24 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 9841
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] ASoC: codecs: wm8753: Fix register cache incoherency
Date: Tue, 28 Dec 2010 21:38:04 +0100
Message-Id: <1293568684-9626-11-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1293568684-9626-1-git-send-email-lars@metafoo.de>
References: <1293568684-9626-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    ASoC: codecs: wm8753: Fix register cache incoherency
    
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
