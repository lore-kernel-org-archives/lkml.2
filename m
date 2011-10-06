Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935926Ab1JFXw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 19:52:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36261 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935786Ab1JFXw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 19:52:26 -0400
Subject: [PATCH 06/11] ASoC: wm8940: Convert to snd_soc_cache_sync
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
In-Reply-To: <1317944619.5579.1.camel@phoenix>
References: <1317944619.5579.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 07:52:19 +0800
Message-ID: <1317945139.5579.12.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert codec->hw_write to snd_soc_cache_sync

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8940.c |   46 +++++++++++++++++++++-----------------------
 1 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/sound/soc/codecs/wm8940.c b/sound/soc/codecs/wm8940.c
index 7e0f54c..a4abfdf 100644
--- a/sound/soc/codecs/wm8940.c
+++ b/sound/soc/codecs/wm8940.c
@@ -45,6 +45,17 @@ struct wm8940_priv {
 	enum snd_soc_control_type control_type;
 };
 
+static int wm8940_volatile_register(struct snd_soc_codec *codec,
+				    unsigned int reg)
+{
+	switch (reg) {
+	case WM8940_SOFTRESET:
+		return 1;
+	default:
+		return 0;
+	}
+}
+
 static u16 wm8940_reg_defaults[] = {
 	0x8940, /* Soft Reset */
 	0x0000, /* Power 1 */
@@ -459,6 +470,14 @@ static int wm8940_set_bias_level(struct snd_soc_codec *codec,
 		ret = snd_soc_write(codec, WM8940_POWER1, pwr_reg | 0x1);
 		break;
 	case SND_SOC_BIAS_STANDBY:
+		if (codec->dapm.bias_level == SND_SOC_BIAS_OFF) {
+			ret = snd_soc_cache_sync(codec);
+			if (ret < 0) {
+				dev_err(codec->dev, "Failed to sync cache: %d\n", ret);
+				return ret;
+			}
+		}
+
 		/* ensure bufioen and biasen */
 		pwr_reg |= (1 << 2) | (1 << 3);
 		/* set vmid to 300k for standby */
@@ -659,30 +678,8 @@ static int wm8940_suspend(struct snd_soc_codec *codec, pm_message_t state)
 
 static int wm8940_resume(struct snd_soc_codec *codec)
 {
-	int i;
-	int ret;
-	u8 data[3];
-	u16 *cache = codec->reg_cache;
-
-	/* Sync reg_cache with the hardware
-	 * Could use auto incremented writes to speed this up
-	 */
-	for (i = 0; i < ARRAY_SIZE(wm8940_reg_defaults); i++) {
-		data[0] = i;
-		data[1] = (cache[i] & 0xFF00) >> 8;
-		data[2] = cache[i] & 0x00FF;
-		ret = codec->hw_write(codec->control_data, data, 3);
-		if (ret < 0)
-			goto error_ret;
-		else if (ret != 3) {
-			ret = -EIO;
-			goto error_ret;
-		}
-	}
-	ret = wm8940_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
-
-error_ret:
-	return ret;
+	wm8940_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
+	return 0;
 }
 
 static int wm8940_probe(struct snd_soc_codec *codec)
@@ -742,6 +739,7 @@ static struct snd_soc_codec_driver soc_codec_dev_wm8940 = {
 	.reg_cache_size = ARRAY_SIZE(wm8940_reg_defaults),
 	.reg_word_size = sizeof(u16),
 	.reg_cache_default = wm8940_reg_defaults,
+	.volatile_register = wm8940_volatile_register,
 };
 
 #if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
-- 
1.7.4.1



