Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935679Ab1JFGLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 02:11:51 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50308 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933935Ab1JFGLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 02:11:49 -0400
Subject: [PATCH 01/10] ASoC: wm8510: Convert to snd_soc_cache_sync
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
In-Reply-To: <1317881417.13399.1.camel@phoenix>
References: <1317881417.13399.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Oct 2011 14:11:43 +0800
Message-ID: <1317881503.13399.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to snd_soc_cache_sync for sync reg_cache with the hardware.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8510.c |   30 +++++++++++++++++++-----------
 1 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/sound/soc/codecs/wm8510.c b/sound/soc/codecs/wm8510.c
index 55a4c83..8e2fe22 100644
--- a/sound/soc/codecs/wm8510.c
+++ b/sound/soc/codecs/wm8510.c
@@ -55,6 +55,17 @@ static const u16 wm8510_reg[WM8510_CACHEREGNUM] = {
 #define WM8510_POWER1_BIASEN  0x08
 #define WM8510_POWER1_BUFIOEN 0x10
 
+static int wm8510_volatile_register(struct snd_soc_codec *codec,
+				    unsigned int reg)
+{
+	switch (reg) {
+	case WM8510_RESET:
+		return 1;
+	default:
+		return 0;
+	}
+}
+
 #define wm8510_reset(c)	snd_soc_write(c, WM8510_RESET, 0)
 
 /* codec private data */
@@ -467,6 +478,7 @@ static int wm8510_mute(struct snd_soc_dai *dai, int mute)
 static int wm8510_set_bias_level(struct snd_soc_codec *codec,
 	enum snd_soc_bias_level level)
 {
+	int ret;
 	u16 power1 = snd_soc_read(codec, WM8510_POWER1) & ~0x3;
 
 	switch (level) {
@@ -480,6 +492,12 @@ static int wm8510_set_bias_level(struct snd_soc_codec *codec,
 		power1 |= WM8510_POWER1_BIASEN | WM8510_POWER1_BUFIOEN;
 
 		if (codec->dapm.bias_level == SND_SOC_BIAS_OFF) {
+			ret = snd_soc_cache_sync(codec);
+			if (ret < 0) {
+				dev_err(codec->dev, "Failed to sync cache: %d\n", ret);
+				return ret;
+			}
+
 			/* Initial cap charge at VMID 5k */
 			snd_soc_write(codec, WM8510_POWER1, power1 | 0x3);
 			mdelay(100);
@@ -541,18 +559,7 @@ static int wm8510_suspend(struct snd_soc_codec *codec, pm_message_t state)
 
 static int wm8510_resume(struct snd_soc_codec *codec)
 {
-	int i;
-	u8 data[2];
-	u16 *cache = codec->reg_cache;
-
-	/* Sync reg_cache with the hardware */
-	for (i = 0; i < ARRAY_SIZE(wm8510_reg); i++) {
-		data[0] = (i << 1) | ((cache[i] >> 8) & 0x0001);
-		data[1] = cache[i] & 0x00ff;
-		codec->hw_write(codec->control_data, data, 2);
-	}
 	wm8510_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
-
 	return 0;
 }
 
@@ -597,6 +604,7 @@ static struct snd_soc_codec_driver soc_codec_dev_wm8510 = {
 	.reg_cache_size = ARRAY_SIZE(wm8510_reg),
 	.reg_word_size = sizeof(u16),
 	.reg_cache_default =wm8510_reg,
+	.volatile_register = wm8510_volatile_register,
 };
 
 static const struct of_device_id wm8510_of_match[] = {
-- 
1.7.4.1



