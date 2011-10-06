Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158Ab1JFDA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 23:00:27 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48979 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab1JFDA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 23:00:26 -0400
Subject: [RFC][PATCH] ASoC: wm8990: Convert to snd_soc_cache_sync for sync
 reg_cache with the hardware
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Oct 2011 11:00:19 +0800
Message-ID: <1317870019.8321.4.camel@phoenix>
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
 sound/soc/codecs/wm8990.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/sound/soc/codecs/wm8990.c b/sound/soc/codecs/wm8990.c
index 100aeee..48e9dd9 100644
--- a/sound/soc/codecs/wm8990.c
+++ b/sound/soc/codecs/wm8990.c
@@ -36,6 +36,17 @@ struct wm8990_priv {
 	unsigned int pcmclk;
 };
 
+static int wm8990_volatile_register(struct snd_soc_codec *codec,
+				    unsigned int reg)
+{
+	switch (reg) {
+	case WM8990_RESET:
+		return 1;
+	default:
+		return 0;
+	}
+}
+
 /*
  * wm8990 register cache.  Note that register 0 is not included in the
  * cache.
@@ -1156,6 +1167,7 @@ static int wm8990_mute(struct snd_soc_dai *dai, int mute)
 static int wm8990_set_bias_level(struct snd_soc_codec *codec,
 	enum snd_soc_bias_level level)
 {
+	int ret;
 	u16 val;
 
 	switch (level) {
@@ -1171,6 +1183,12 @@ static int wm8990_set_bias_level(struct snd_soc_codec *codec,
 
 	case SND_SOC_BIAS_STANDBY:
 		if (codec->dapm.bias_level == SND_SOC_BIAS_OFF) {
+			ret = snd_soc_cache_sync(codec);
+			if (ret < 0) {
+				dev_err(codec->dev, "Failed to sync cache: %d\n", ret);
+				return ret;
+			}
+
 			/* Enable all output discharge bits */
 			snd_soc_write(codec, WM8990_ANTIPOP1, WM8990_DIS_LLINE |
 				WM8990_DIS_RLINE | WM8990_DIS_OUT3 |
@@ -1319,19 +1337,6 @@ static int wm8990_suspend(struct snd_soc_codec *codec, pm_message_t state)
 
 static int wm8990_resume(struct snd_soc_codec *codec)
 {
-	int i;
-	u8 data[2];
-	u16 *cache = codec->reg_cache;
-
-	/* Sync reg_cache with the hardware */
-	for (i = 0; i < ARRAY_SIZE(wm8990_reg); i++) {
-		if (i + 1 == WM8990_RESET)
-			continue;
-		data[0] = ((i + 1) << 1) | ((cache[i] >> 8) & 0x0001);
-		data[1] = cache[i] & 0x00ff;
-		codec->hw_write(codec->control_data, data, 2);
-	}
-
 	wm8990_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 	return 0;
 }
@@ -1392,6 +1397,7 @@ static struct snd_soc_codec_driver soc_codec_dev_wm8990 = {
 	.reg_cache_size = ARRAY_SIZE(wm8990_reg),
 	.reg_word_size = sizeof(u16),
 	.reg_cache_default = wm8990_reg,
+	.volatile_register = wm8990_volatile_register,
 };
 
 #if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
-- 
1.7.4.1



