Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab0LXNtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 08:49:09 -0500
Received: from smtp-out-045.synserver.de ([212.40.180.45]:1162 "HELO
	smtp-out-045.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752673Ab0LXNsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 08:48:53 -0500
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
Subject: [PATCH 3/9] ASoC: codecs: wm8523: Fix register cache incoherency
Date: Fri, 24 Dec 2010 14:47:58 +0100
Message-Id: <1293198484-1902-4-git-send-email-lars@metafoo.de>
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
This pachtes fixes the issue by changing the wm8523 driver to use the generic
cache framework.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ian Lartey <ian@opensource.wolfsonmicro.com>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>

---
Compile tested only
---
 sound/soc/codecs/wm8523.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/wm8523.c b/sound/soc/codecs/wm8523.c
index 08f3189..5eb2f50 100644
--- a/sound/soc/codecs/wm8523.c
+++ b/sound/soc/codecs/wm8523.c
@@ -40,7 +40,6 @@ static const char *wm8523_supply_names[WM8523_NUM_SUPPLIES] = {
 /* codec private data */
 struct wm8523_priv {
 	enum snd_soc_control_type control_type;
-	u16 reg_cache[WM8523_REGISTER_COUNT];
 	struct regulator_bulk_data supplies[WM8523_NUM_SUPPLIES];
 	unsigned int sysclk;
 	unsigned int rate_constraint_list[WM8523_NUM_RATES];
@@ -314,6 +313,7 @@ static int wm8523_set_bias_level(struct snd_soc_codec *codec,
 				 enum snd_soc_bias_level level)
 {
 	struct wm8523_priv *wm8523 = snd_soc_codec_get_drvdata(codec);
+	u16 *reg_cache = codec->reg_cache;
 	int ret, i;
 
 	switch (level) {
@@ -344,7 +344,7 @@ static int wm8523_set_bias_level(struct snd_soc_codec *codec,
 			/* Sync back default/cached values */
 			for (i = WM8523_AIF_CTRL1;
 			     i < WM8523_MAX_REGISTER; i++)
-				snd_soc_write(codec, i, wm8523->reg_cache[i]);
+				snd_soc_write(codec, i, reg_cache[i]);
 
 
 			msleep(100);
@@ -414,6 +414,7 @@ static int wm8523_resume(struct snd_soc_codec *codec)
 static int wm8523_probe(struct snd_soc_codec *codec)
 {
 	struct wm8523_priv *wm8523 = snd_soc_codec_get_drvdata(codec);
+	u16 *reg_cache = codec->reg_cache;
 	int ret, i;
 
 	codec->hw_write = (hw_write_t)i2c_master_send;
@@ -470,8 +471,8 @@ static int wm8523_probe(struct snd_soc_codec *codec)
 	}
 
 	/* Change some default settings - latch VU and enable ZC */
-	wm8523->reg_cache[WM8523_DAC_GAINR] |= WM8523_DACR_VU;
-	wm8523->reg_cache[WM8523_DAC_CTRL3] |= WM8523_ZC;
+	reg_cache[WM8523_DAC_GAINR] |= WM8523_DACR_VU;
+	reg_cache[WM8523_DAC_CTRL3] |= WM8523_ZC;
 
 	wm8523_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
-- 
1.7.2.3

