Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935732Ab1JFGVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 02:21:35 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57774 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935288Ab1JFGVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 02:21:34 -0400
Subject: [PATCH 10/10] ASoC: wm8988: Convert to snd_soc_cache_sync
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
In-Reply-To: <1317881417.13399.1.camel@phoenix>
References: <1317881417.13399.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Oct 2011 14:21:27 +0800
Message-ID: <1317882087.13399.14.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to snd_soc_cache_sync for sync reg_cache with the hardware.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8988.c |   32 ++++++++++++++++++--------------
 1 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/sound/soc/codecs/wm8988.c b/sound/soc/codecs/wm8988.c
index 1c6f8bf..ed453e5 100644
--- a/sound/soc/codecs/wm8988.c
+++ b/sound/soc/codecs/wm8988.c
@@ -55,6 +55,16 @@ struct wm8988_priv {
 	struct snd_pcm_hw_constraint_list *sysclk_constraints;
 };
 
+static int wm8988_volatile_register(struct snd_soc_codec *codec,
+				    unsigned int reg)
+{
+	switch (reg) {
+	case WM8988_RESET:
+		return 1;
+	default:
+		return 0;
+	}
+}
 
 #define wm8988_reset(c)	snd_soc_write(c, WM8988_RESET, 0)
 
@@ -663,6 +673,7 @@ static int wm8988_mute(struct snd_soc_dai *dai, int mute)
 static int wm8988_set_bias_level(struct snd_soc_codec *codec,
 				 enum snd_soc_bias_level level)
 {
+	int ret;
 	u16 pwr_reg = snd_soc_read(codec, WM8988_PWR1) & ~0x1c1;
 
 	switch (level) {
@@ -676,6 +687,12 @@ static int wm8988_set_bias_level(struct snd_soc_codec *codec,
 
 	case SND_SOC_BIAS_STANDBY:
 		if (codec->dapm.bias_level == SND_SOC_BIAS_OFF) {
+			ret = snd_soc_cache_sync(codec);
+			if (ret < 0) {
+				dev_err(codec->dev, "Failed to sync cache: %d\n", ret);
+				return ret;
+			}
+
 			/* VREF, VMID=2x5k */
 			snd_soc_write(codec, WM8988_PWR1, pwr_reg | 0x1c1);
 
@@ -736,21 +753,7 @@ static int wm8988_suspend(struct snd_soc_codec *codec, pm_message_t state)
 
 static int wm8988_resume(struct snd_soc_codec *codec)
 {
-	int i;
-	u8 data[2];
-	u16 *cache = codec->reg_cache;
-
-	/* Sync reg_cache with the hardware */
-	for (i = 0; i < WM8988_NUM_REG; i++) {
-		if (i == WM8988_RESET)
-			continue;
-		data[0] = (i << 1) | ((cache[i] >> 8) & 0x0001);
-		data[1] = cache[i] & 0x00ff;
-		codec->hw_write(codec->control_data, data, 2);
-	}
-
 	wm8988_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
-
 	return 0;
 }
 
@@ -805,6 +808,7 @@ static struct snd_soc_codec_driver soc_codec_dev_wm8988 = {
 	.reg_cache_size = ARRAY_SIZE(wm8988_reg),
 	.reg_word_size = sizeof(u16),
 	.reg_cache_default = wm8988_reg,
+	.volatile_register = wm8988_volatile_register,
 };
 
 #if defined(CONFIG_SPI_MASTER)
-- 
1.7.4.1



