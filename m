Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935062Ab1JFHZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 03:25:11 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48438 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933227Ab1JFHZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 03:25:09 -0400
Subject: [PATCH 07/10 v2] ASoC: wm8960: Convert to snd_soc_cache_sync
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
In-Reply-To: <1317881919.13399.11.camel@phoenix>
References: <1317881417.13399.1.camel@phoenix>
	 <1317881919.13399.11.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Oct 2011 15:25:02 +0800
Message-ID: <1317885902.13399.25.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to snd_soc_cache_sync for sync reg_cache with the hardware.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
v2: Just found in v1 I put snd_soc_cache_sync() at wrong place in
wm8960_set_bias_level_capless().

 sound/soc/codecs/wm8960.c |   38 +++++++++++++++++++++++++++-----------
 1 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
index 831c20f..e8262a0 100644
--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -81,6 +81,17 @@ struct wm8960_priv {
 	int playback_fs;
 };
 
+static int wm8960_volatile_register(struct snd_soc_codec *codec,
+				    unsigned int reg)
+{
+	switch (reg) {
+	case WM8960_RESET:
+		return 1;
+	default:
+		return 0;
+	}
+}
+
 #define wm8960_reset(c)	snd_soc_write(c, WM8960_RESET, 0)
 
 /* enumerated controls */
@@ -558,6 +569,7 @@ static int wm8960_mute(struct snd_soc_dai *dai, int mute)
 static int wm8960_set_bias_level_out3(struct snd_soc_codec *codec,
 				      enum snd_soc_bias_level level)
 {
+	int ret;
 	u16 reg;
 
 	switch (level) {
@@ -574,6 +586,12 @@ static int wm8960_set_bias_level_out3(struct snd_soc_codec *codec,
 
 	case SND_SOC_BIAS_STANDBY:
 		if (codec->dapm.bias_level == SND_SOC_BIAS_OFF) {
+			ret = snd_soc_cache_sync(codec);
+			if (ret < 0) {
+				dev_err(codec->dev, "Failed to sync cache: %d\n", ret);
+				return ret;
+			}
+
 			/* Enable anti-pop features */
 			snd_soc_write(codec, WM8960_APOP1,
 				      WM8960_POBCTRL | WM8960_SOFT_ST |
@@ -620,7 +638,7 @@ static int wm8960_set_bias_level_capless(struct snd_soc_codec *codec,
 					 enum snd_soc_bias_level level)
 {
 	struct wm8960_priv *wm8960 = snd_soc_codec_get_drvdata(codec);
-	int reg;
+	int reg, ret;
 
 	switch (level) {
 	case SND_SOC_BIAS_ON:
@@ -697,6 +715,13 @@ static int wm8960_set_bias_level_capless(struct snd_soc_codec *codec,
 					    WM8960_BUFDCOPEN);
 			break;
 
+		case SND_SOC_BIAS_OFF:
+			ret = snd_soc_cache_sync(codec);
+			if (ret < 0) {
+				dev_err(codec->dev, "Failed to sync cache: %d\n", ret);
+				return ret;
+			}
+			break;
 		default:
 			break;
 		}
@@ -901,16 +926,6 @@ static int wm8960_suspend(struct snd_soc_codec *codec, pm_message_t state)
 static int wm8960_resume(struct snd_soc_codec *codec)
 {
 	struct wm8960_priv *wm8960 = snd_soc_codec_get_drvdata(codec);
-	int i;
-	u8 data[2];
-	u16 *cache = codec->reg_cache;
-
-	/* Sync reg_cache with the hardware */
-	for (i = 0; i < ARRAY_SIZE(wm8960_reg); i++) {
-		data[0] = (i << 1) | ((cache[i] >> 8) & 0x0001);
-		data[1] = cache[i] & 0x00ff;
-		codec->hw_write(codec->control_data, data, 2);
-	}
 
 	wm8960->set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 	return 0;
@@ -998,6 +1013,7 @@ static struct snd_soc_codec_driver soc_codec_dev_wm8960 = {
 	.reg_cache_size = ARRAY_SIZE(wm8960_reg),
 	.reg_word_size = sizeof(u16),
 	.reg_cache_default = wm8960_reg,
+	.volatile_register = wm8960_volatile_register,
 };
 
 #if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
-- 
1.7.4.1



