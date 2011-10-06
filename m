Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935897Ab1JFXqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 19:46:47 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50589 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab1JFXqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 19:46:46 -0400
Subject: [PATCH 02/11] ASoC: wm8711: Convert to snd_soc_write
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Arthur <linux@wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
In-Reply-To: <1317944619.5579.1.camel@phoenix>
References: <1317944619.5579.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 07:46:39 +0800
Message-ID: <1317944799.5579.5.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert codec->hw_write to snd_soc_write

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8711.c |   33 ++++++++++++++++++++++-----------
 1 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/sound/soc/codecs/wm8711.c b/sound/soc/codecs/wm8711.c
index 47c7fd5..f4c15ea 100644
--- a/sound/soc/codecs/wm8711.c
+++ b/sound/soc/codecs/wm8711.c
@@ -287,6 +287,25 @@ static int wm8711_set_dai_fmt(struct snd_soc_dai *codec_dai,
 	return 0;
 }
 
+static void wm8711_sync_cache(struct snd_soc_codec *codec)
+{
+	short i;
+	u16 *cache;
+
+	if (!codec->cache_sync)
+		return;
+	codec->cache_only = 0;
+	codec->cache_bypass = 1;
+	/* restore cache */
+	cache = codec->reg_cache;
+	for (i = 0; i < codec->driver->reg_cache_size; i++) {
+		if (i == WM8711_RESET || cache[i] == wm8711_reg[i])
+			continue;
+		snd_soc_write(codec, i, cache[i]);
+	}
+	codec->cache_bypass = 0;
+	codec->cache_sync = 0;
+}
 
 static int wm8711_set_bias_level(struct snd_soc_codec *codec,
 	enum snd_soc_bias_level level)
@@ -300,6 +319,9 @@ static int wm8711_set_bias_level(struct snd_soc_codec *codec,
 	case SND_SOC_BIAS_PREPARE:
 		break;
 	case SND_SOC_BIAS_STANDBY:
+		if (codec->dapm.bias_level == SND_SOC_BIAS_OFF)
+			wm8711_sync_cache(codec);
+
 		snd_soc_write(codec, WM8711_PWR, reg | 0x0040);
 		break;
 	case SND_SOC_BIAS_OFF:
@@ -346,18 +368,7 @@ static int wm8711_suspend(struct snd_soc_codec *codec, pm_message_t state)
 
 static int wm8711_resume(struct snd_soc_codec *codec)
 {
-	int i;
-	u8 data[2];
-	u16 *cache = codec->reg_cache;
-
-	/* Sync reg_cache with the hardware */
-	for (i = 0; i < ARRAY_SIZE(wm8711_reg); i++) {
-		data[0] = (i << 1) | ((cache[i] >> 8) & 0x0001);
-		data[1] = cache[i] & 0x00ff;
-		codec->hw_write(codec->control_data, data, 2);
-	}
 	wm8711_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
-
 	return 0;
 }
 
-- 
1.7.4.1



