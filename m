Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935698Ab1JFGP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 02:15:59 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59396 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933935Ab1JFGP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 02:15:58 -0400
Subject: [PATCH 04/10] ASoC: wm8750: Convert to snd_soc_cache_sync
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
In-Reply-To: <1317881417.13399.1.camel@phoenix>
References: <1317881417.13399.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Oct 2011 14:15:50 +0800
Message-ID: <1317881750.13399.8.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to snd_soc_cache_sync for sync reg_cache with the hardware.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8750.c |   32 ++++++++++++++++++--------------
 1 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/sound/soc/codecs/wm8750.c b/sound/soc/codecs/wm8750.c
index 862c520..7e5af9f 100644
--- a/sound/soc/codecs/wm8750.c
+++ b/sound/soc/codecs/wm8750.c
@@ -55,6 +55,17 @@ struct wm8750_priv {
 	enum snd_soc_control_type control_type;
 };
 
+static int wm8750_volatile_register(struct snd_soc_codec *codec,
+				    unsigned int reg)
+{
+	switch (reg) {
+	case WM8750_RESET:
+		return 1;
+	default:
+		return 0;
+	}
+}
+
 #define wm8750_reset(c)	snd_soc_write(c, WM8750_RESET, 0)
 
 /*
@@ -605,6 +616,7 @@ static int wm8750_mute(struct snd_soc_dai *dai, int mute)
 static int wm8750_set_bias_level(struct snd_soc_codec *codec,
 				 enum snd_soc_bias_level level)
 {
+	int ret;
 	u16 pwr_reg = snd_soc_read(codec, WM8750_PWR1) & 0xfe3e;
 
 	switch (level) {
@@ -616,6 +628,11 @@ static int wm8750_set_bias_level(struct snd_soc_codec *codec,
 		break;
 	case SND_SOC_BIAS_STANDBY:
 		if (codec->dapm.bias_level == SND_SOC_BIAS_OFF) {
+			ret = snd_soc_cache_sync(codec);
+			if (ret < 0) {
+				dev_err(codec->dev, "Failed to sync cache: %d\n", ret);
+				return ret;
+			}
 			/* Set VMID to 5k */
 			snd_soc_write(codec, WM8750_PWR1, pwr_reg | 0x01c1);
 
@@ -673,21 +690,7 @@ static int wm8750_suspend(struct snd_soc_codec *codec, pm_message_t state)
 
 static int wm8750_resume(struct snd_soc_codec *codec)
 {
-	int i;
-	u8 data[2];
-	u16 *cache = codec->reg_cache;
-
-	/* Sync reg_cache with the hardware */
-	for (i = 0; i < ARRAY_SIZE(wm8750_reg); i++) {
-		if (i == WM8750_RESET)
-			continue;
-		data[0] = (i << 1) | ((cache[i] >> 8) & 0x0001);
-		data[1] = cache[i] & 0x00ff;
-		codec->hw_write(codec->control_data, data, 2);
-	}
-
 	wm8750_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
-
 	return 0;
 }
 
@@ -742,6 +745,7 @@ static struct snd_soc_codec_driver soc_codec_dev_wm8750 = {
 	.reg_cache_size = ARRAY_SIZE(wm8750_reg),
 	.reg_word_size = sizeof(u16),
 	.reg_cache_default = wm8750_reg,
+	.volatile_register = wm8750_volatile_register,
 };
 
 static const struct of_device_id wm8750_of_match[] = {
-- 
1.7.4.1



