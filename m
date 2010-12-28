Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab0L1Ujk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 15:39:40 -0500
Received: from smtp-out-091.synserver.de ([212.40.180.91]:1088 "HELO
	smtp-out-089.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1752480Ab0L1UiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 15:38:23 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 9841
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Subject: [PATCH 7/9] ASoC: codecs: wm8962: Fix register cache incoherency
Date: Tue, 28 Dec 2010 21:38:01 +0100
Message-Id: <1293568684-9626-8-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1293568684-9626-1-git-send-email-lars@metafoo.de>
References: <1293568684-9626-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The multi-component patch(commit f0fba2ad1) moved the allocation of the
register cache from the driver to the ASoC core. Most drivers where adjusted to
this, but the wm8962 driver still uses its own register cache for its
private functions, while functions from the ASoC core use the generic cache.
Thus we end up with two from each other incoherent caches, which can lead to
undefined behaviour.
This patch fixes the issue by changing the wm8962 driver to use the
generic register cache in its private functions.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ian Lartey <ian@opensource.wolfsonmicro.com>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>

---
Compile tested only
---
 sound/soc/codecs/wm8962.c |   45 ++++++++++++++++++++-------------------------
 1 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index 1304ca9..7c421cc 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -52,8 +52,6 @@ static const char *wm8962_supply_names[WM8962_NUM_SUPPLIES] = {
 struct wm8962_priv {
 	struct snd_soc_codec *codec;
 
-	u16 reg_cache[WM8962_MAX_REGISTER + 1];
-
 	int sysclk;
 	int sysclk_rate;
 
@@ -1991,8 +1989,7 @@ static int wm8962_put_hp_sw(struct snd_kcontrol *kcontrol,
 			    struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
-	struct wm8962_priv *wm8962 = snd_soc_codec_get_drvdata(codec);
-	u16 *reg_cache = wm8962->reg_cache;
+	u16 *reg_cache = codec->reg_cache;
 	int ret;
 
 	/* Apply the update (if any) */
@@ -2020,8 +2017,7 @@ static int wm8962_put_spk_sw(struct snd_kcontrol *kcontrol,
 			    struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
-	struct wm8962_priv *wm8962 = snd_soc_codec_get_drvdata(codec);
-	u16 *reg_cache = wm8962->reg_cache;
+	u16 *reg_cache = codec->reg_cache;
 	int ret;
 
 	/* Apply the update (if any) */
@@ -2329,8 +2325,7 @@ static int out_pga_event(struct snd_soc_dapm_widget *w,
 			 struct snd_kcontrol *kcontrol, int event)
 {
 	struct snd_soc_codec *codec = w->codec;
-	struct wm8962_priv *wm8962 = snd_soc_codec_get_drvdata(codec);
-	u16 *reg_cache = wm8962->reg_cache;
+	u16 *reg_cache = codec->reg_cache;
 	int reg;
 
 	switch (w->shift) {
@@ -2719,7 +2714,7 @@ static int wm8962_add_widgets(struct snd_soc_codec *codec)
 
 static void wm8962_sync_cache(struct snd_soc_codec *codec)
 {
-	struct wm8962_priv *wm8962 = snd_soc_codec_get_drvdata(codec);
+	u16 *reg_cache = codec->reg_cache;
 	int i;
 
 	if (!codec->cache_sync)
@@ -2732,13 +2727,13 @@ static void wm8962_sync_cache(struct snd_soc_codec *codec)
 	/* Sync back cached values if they're different from the
 	 * hardware default.
 	 */
-	for (i = 1; i < ARRAY_SIZE(wm8962->reg_cache); i++) {
+	for (i = 1; i < codec->driver->reg_cache_size; i++) {
 		if (i == WM8962_SOFTWARE_RESET)
 			continue;
-		if (wm8962->reg_cache[i] == wm8962_reg[i])
+		if (reg_cache[i] == wm8962_reg[i])
 			continue;
 
-		snd_soc_write(codec, i, wm8962->reg_cache[i]);
+		snd_soc_write(codec, i, reg_cache[i]);
 	}
 
 	codec->cache_sync = 0;
@@ -3406,12 +3401,11 @@ EXPORT_SYMBOL_GPL(wm8962_mic_detect);
 #ifdef CONFIG_PM
 static int wm8962_resume(struct snd_soc_codec *codec)
 {
-	struct wm8962_priv *wm8962 = snd_soc_codec_get_drvdata(codec);
 	u16 *reg_cache = codec->reg_cache;
 	int i;
 
 	/* Restore the registers */
-	for (i = 1; i < ARRAY_SIZE(wm8962->reg_cache); i++) {
+	for (i = 1; i < codec->driver->reg_cache_size; i++) {
 		switch (i) {
 		case WM8962_SOFTWARE_RESET:
 			continue;
@@ -3705,6 +3699,7 @@ static int wm8962_probe(struct snd_soc_codec *codec)
 	struct wm8962_pdata *pdata = dev_get_platdata(codec->dev);
 	struct i2c_client *i2c = container_of(codec->dev, struct i2c_client,
 					      dev);
+	u16 *reg_cache = codec->reg_cache;
 	int i, trigger, irq_pol;
 
 	wm8962->codec = codec;
@@ -3804,7 +3799,7 @@ static int wm8962_probe(struct snd_soc_codec *codec)
 
 		/* Put the speakers into mono mode? */
 		if (pdata->spk_mono)
-			wm8962->reg_cache[WM8962_CLASS_D_CONTROL_2]
+			reg_cache[WM8962_CLASS_D_CONTROL_2]
 				|= WM8962_SPK_MONO;
 
 		/* Micbias setup, detection enable and detection
@@ -3819,16 +3814,16 @@ static int wm8962_probe(struct snd_soc_codec *codec)
 	}
 
 	/* Latch volume update bits */
-	wm8962->reg_cache[WM8962_LEFT_INPUT_VOLUME] |= WM8962_IN_VU;
-	wm8962->reg_cache[WM8962_RIGHT_INPUT_VOLUME] |= WM8962_IN_VU;
-	wm8962->reg_cache[WM8962_LEFT_ADC_VOLUME] |= WM8962_ADC_VU;
-	wm8962->reg_cache[WM8962_RIGHT_ADC_VOLUME] |= WM8962_ADC_VU;	
-	wm8962->reg_cache[WM8962_LEFT_DAC_VOLUME] |= WM8962_DAC_VU;
-	wm8962->reg_cache[WM8962_RIGHT_DAC_VOLUME] |= WM8962_DAC_VU;
-	wm8962->reg_cache[WM8962_SPKOUTL_VOLUME] |= WM8962_SPKOUT_VU;
-	wm8962->reg_cache[WM8962_SPKOUTR_VOLUME] |= WM8962_SPKOUT_VU;
-	wm8962->reg_cache[WM8962_HPOUTL_VOLUME] |= WM8962_HPOUT_VU;
-	wm8962->reg_cache[WM8962_HPOUTR_VOLUME] |= WM8962_HPOUT_VU;
+	reg_cache[WM8962_LEFT_INPUT_VOLUME] |= WM8962_IN_VU;
+	reg_cache[WM8962_RIGHT_INPUT_VOLUME] |= WM8962_IN_VU;
+	reg_cache[WM8962_LEFT_ADC_VOLUME] |= WM8962_ADC_VU;
+	reg_cache[WM8962_RIGHT_ADC_VOLUME] |= WM8962_ADC_VU;
+	reg_cache[WM8962_LEFT_DAC_VOLUME] |= WM8962_DAC_VU;
+	reg_cache[WM8962_RIGHT_DAC_VOLUME] |= WM8962_DAC_VU;
+	reg_cache[WM8962_SPKOUTL_VOLUME] |= WM8962_SPKOUT_VU;
+	reg_cache[WM8962_SPKOUTR_VOLUME] |= WM8962_SPKOUT_VU;
+	reg_cache[WM8962_HPOUTL_VOLUME] |= WM8962_HPOUT_VU;
+	reg_cache[WM8962_HPOUTR_VOLUME] |= WM8962_HPOUT_VU;
 
 	wm8962_add_widgets(codec);
 
-- 
1.7.2.3

