Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab0LXNuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 08:50:35 -0500
Received: from smtp-out-045.synserver.de ([212.40.180.45]:1176 "HELO
	smtp-out-045.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752685Ab0LXNsz (ORCPT
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
Subject: [PATCH 6/9] ASoC: codecs: wm8955: Fix register cache incoherency
Date: Fri, 24 Dec 2010 14:48:01 +0100
Message-Id: <1293198484-1902-7-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1293198484-1902-1-git-send-email-lars@metafoo.de>
References: <1293198484-1902-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The multi-component patch(commit f0fba2ad1) introduced a generic register cache
framework. But the wm8753 driver still uses its own register cache for its
private functions, while functions from the ASoC core use the generic cache.
Thus we end up with two from each other incoherent caches, which leads to
undefined behaviour.
This pachtes fixes the issue by changing the wm8955 driver to use the generic
cache framework.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ian Lartey <ian@opensource.wolfsonmicro.com>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>

---
Compile tested only
---
 sound/soc/codecs/wm8955.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/sound/soc/codecs/wm8955.c b/sound/soc/codecs/wm8955.c
index ca0265f..70e9516 100644
--- a/sound/soc/codecs/wm8955.c
+++ b/sound/soc/codecs/wm8955.c
@@ -41,8 +41,6 @@ static const char *wm8955_supply_names[WM8955_NUM_SUPPLIES] = {
 struct wm8955_priv {
 	enum snd_soc_control_type control_type;
 
-	u16 reg_cache[WM8955_MAX_REGISTER + 1];
-
 	unsigned int mclk_rate;
 
 	int deemph;
@@ -768,6 +766,7 @@ static int wm8955_set_bias_level(struct snd_soc_codec *codec,
 				 enum snd_soc_bias_level level)
 {
 	struct wm8955_priv *wm8955 = snd_soc_codec_get_drvdata(codec);
+	u16 *reg_cache = codec->reg_cache;
 	int ret, i;
 
 	switch (level) {
@@ -800,14 +799,14 @@ static int wm8955_set_bias_level(struct snd_soc_codec *codec,
 			/* Sync back cached values if they're
 			 * different from the hardware default.
 			 */
-			for (i = 0; i < ARRAY_SIZE(wm8955->reg_cache); i++) {
+			for (i = 0; i < codec->driver->reg_cache_size; i++) {
 				if (i == WM8955_RESET)
 					continue;
 
-				if (wm8955->reg_cache[i] == wm8955_reg[i])
+				if (reg_cache[i] == wm8955_reg[i])
 					continue;
 
-				snd_soc_write(codec, i, wm8955->reg_cache[i]);
+				snd_soc_write(codec, i, reg_cache[i]);
 			}
 
 			/* Enable VREF and VMID */
@@ -902,6 +901,7 @@ static int wm8955_probe(struct snd_soc_codec *codec)
 {
 	struct wm8955_priv *wm8955 = snd_soc_codec_get_drvdata(codec);
 	struct wm8955_pdata *pdata = dev_get_platdata(codec->dev);
+	u16 *reg_cache = codec->reg_cache;
 	int ret, i;
 
 	ret = snd_soc_codec_set_cache_io(codec, 7, 9, wm8955->control_type);
@@ -934,25 +934,25 @@ static int wm8955_probe(struct snd_soc_codec *codec)
 	}
 
 	/* Change some default settings - latch VU and enable ZC */
-	wm8955->reg_cache[WM8955_LEFT_DAC_VOLUME] |= WM8955_LDVU;
-	wm8955->reg_cache[WM8955_RIGHT_DAC_VOLUME] |= WM8955_RDVU;
-	wm8955->reg_cache[WM8955_LOUT1_VOLUME] |= WM8955_LO1VU | WM8955_LO1ZC;
-	wm8955->reg_cache[WM8955_ROUT1_VOLUME] |= WM8955_RO1VU | WM8955_RO1ZC;
-	wm8955->reg_cache[WM8955_LOUT2_VOLUME] |= WM8955_LO2VU | WM8955_LO2ZC;
-	wm8955->reg_cache[WM8955_ROUT2_VOLUME] |= WM8955_RO2VU | WM8955_RO2ZC;
-	wm8955->reg_cache[WM8955_MONOOUT_VOLUME] |= WM8955_MOZC;
+	reg_cache[WM8955_LEFT_DAC_VOLUME] |= WM8955_LDVU;
+	reg_cache[WM8955_RIGHT_DAC_VOLUME] |= WM8955_RDVU;
+	reg_cache[WM8955_LOUT1_VOLUME] |= WM8955_LO1VU | WM8955_LO1ZC;
+	reg_cache[WM8955_ROUT1_VOLUME] |= WM8955_RO1VU | WM8955_RO1ZC;
+	reg_cache[WM8955_LOUT2_VOLUME] |= WM8955_LO2VU | WM8955_LO2ZC;
+	reg_cache[WM8955_ROUT2_VOLUME] |= WM8955_RO2VU | WM8955_RO2ZC;
+	reg_cache[WM8955_MONOOUT_VOLUME] |= WM8955_MOZC;
 
 	/* Also enable adaptive bass boost by default */
-	wm8955->reg_cache[WM8955_BASS_CONTROL] |= WM8955_BB;
+	reg_cache[WM8955_BASS_CONTROL] |= WM8955_BB;
 
 	/* Set platform data values */
 	if (pdata) {
 		if (pdata->out2_speaker)
-			wm8955->reg_cache[WM8955_ADDITIONAL_CONTROL_2]
+			reg_cache[WM8955_ADDITIONAL_CONTROL_2]
 				|= WM8955_ROUT2INV;
 
 		if (pdata->monoin_diff)
-			wm8955->reg_cache[WM8955_MONO_OUT_MIX_1]
+			reg_cache[WM8955_MONO_OUT_MIX_1]
 				|= WM8955_DMEN;
 	}
 
-- 
1.7.2.3

