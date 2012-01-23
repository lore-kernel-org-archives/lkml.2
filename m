Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab2AWOAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 09:00:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50560 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752431Ab2AWN7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 08:59:38 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/3] ASoC: Convert the WM5100 revision A updates to a regmap patch
Date: Mon, 23 Jan 2012 13:59:32 +0000
Message-Id: <1327327172-8411-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1327327172-8411-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1327327172-8411-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 sound/soc/codecs/wm5100.c |   46 ++++++++++++++++----------------------------
 1 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/sound/soc/codecs/wm5100.c b/sound/soc/codecs/wm5100.c
index e99fadc..f916043 100644
--- a/sound/soc/codecs/wm5100.c
+++ b/sound/soc/codecs/wm5100.c
@@ -1388,10 +1388,7 @@ static const struct snd_soc_dapm_route wm5100_dapm_routes[] = {
 	{ "PWM2", NULL, "PWM2 Driver" },
 };
 
-static struct {
-	int reg;
-	int val;
-} wm5100_reva_patches[] = {
+static const __devinitdata struct reg_default wm5100_reva_patches[] = {
 	{ WM5100_AUDIO_IF_1_10, 0 },
 	{ WM5100_AUDIO_IF_1_11, 1 },
 	{ WM5100_AUDIO_IF_1_12, 2 },
@@ -1454,31 +1451,6 @@ static int wm5100_set_bias_level(struct snd_soc_codec *codec,
 			}
 
 			regcache_cache_only(wm5100->regmap, false);
-
-			switch (wm5100->rev) {
-			case 0:
-				regcache_cache_bypass(wm5100->regmap, true);
-				snd_soc_write(codec, 0x11, 0x3);
-				snd_soc_write(codec, 0x203, 0xc);
-				snd_soc_write(codec, 0x206, 0);
-				snd_soc_write(codec, 0x207, 0xf0);
-				snd_soc_write(codec, 0x208, 0x3c);
-				snd_soc_write(codec, 0x209, 0);
-				snd_soc_write(codec, 0x211, 0x20d8);
-				snd_soc_write(codec, 0x11, 0);
-
-				for (i = 0;
-				     i < ARRAY_SIZE(wm5100_reva_patches);
-				     i++)
-					snd_soc_write(codec,
-						      wm5100_reva_patches[i].reg,
-						      wm5100_reva_patches[i].val);
-				regcache_cache_bypass(wm5100->regmap, false);
-				break;
-			default:
-				break;
-			}
-
 			regcache_sync(wm5100->regmap);
 		}
 		break;
@@ -2838,6 +2810,22 @@ static __devinit int wm5100_i2c_probe(struct i2c_client *i2c,
 		goto err_reset;
 	}
 
+	switch (wm5100->rev) {
+	case 0:
+		ret = regmap_register_patch(wm5100->regmap,
+					    wm5100_reva_patches,
+					    ARRAY_SIZE(wm5100_reva_patches));
+		if (ret != 0) {
+			dev_err(&i2c->dev, "Failed to register patches: %d\n",
+				ret);
+			goto err_reset;
+		}
+		break;
+	default:
+		break;
+	}
+
+
 	wm5100_init_gpio(i2c);
 
 	for (i = 0; i < ARRAY_SIZE(wm5100->pdata.gpio_defaults); i++) {
-- 
1.7.7.3

