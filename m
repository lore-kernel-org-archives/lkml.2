Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784Ab1JCW4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 18:56:21 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48438 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757351Ab1JCW4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 18:56:10 -0400
From: Ryan Mallon <rmallon@gmail.com>
To: broonie@opensource.wolfsonmicro.com
Cc: axel.lin@gmail.com, linux-kernel@vger.kernel.org, lrg@ti.com,
        alsa-devel@alsa-project.org, peter.hsiang@maxim-ic.com,
        jesse.marroquin@maxim-ic.com, hidave.darkstar@gmail.com,
        Ryan Mallon <rmallon@gmail.com>
Subject: [PATCH 2/2] ASoC: max98095 codec: Catch driver bugs for biquad channel name
Date: Tue,  4 Oct 2011 09:55:41 +1100
Message-Id: <1317682541-28494-2-git-send-email-rmallon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1317682541-28494-1-git-send-email-rmallon@gmail.com>
References: <1317682541-28494-1-git-send-email-rmallon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the biquad channel names to a separate array and iterate over it in
max98095_get_bq_channel rather than duplicating the hardcoded channel
names. Add an error message if an invalid channel is passed and check
the error in the callers.

Also added a BUILD_BUG_ON to ensure that the bq_mode_name and controls
arrays are the same size.

Signed-off-by: Ryan Mallon <rmallon@gmail.com>
---
 sound/soc/codecs/max98095.c |   32 ++++++++++++++++++++++----------
 1 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/sound/soc/codecs/max98095.c b/sound/soc/codecs/max98095.c
index 668434d..7931c48 100644
--- a/sound/soc/codecs/max98095.c
+++ b/sound/soc/codecs/max98095.c
@@ -1992,12 +1992,19 @@ static void max98095_handle_eq_pdata(struct snd_soc_codec *codec)
 		dev_err(codec->dev, "Failed to add EQ control: %d\n", ret);
 }
 
-static int max98095_get_bq_channel(const char *name)
+static const char *bq_mode_name[] = {"Biquad1 Mode", "Biquad2 Mode"};
+
+static int max98095_get_bq_channel(struct snd_soc_codec *codec,
+				   const char *name)
 {
-	if (strcmp(name, "Biquad1 Mode") == 0)
-		return 0;
-	if (strcmp(name, "Biquad2 Mode") == 0)
-		return 1;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(bq_mode_name); i++)
+		if (strcmp(name, bq_mode_name[i]) == 0)
+			return i;
+
+	/* Shouldn't happen */
+	dev_err(codec->dev, "Bad biquad channel name '%s'\n", name);
 	return -EINVAL;
 }
 
@@ -2007,14 +2014,15 @@ static int max98095_put_bq_enum(struct snd_kcontrol *kcontrol,
 	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
 	struct max98095_priv *max98095 = snd_soc_codec_get_drvdata(codec);
 	struct max98095_pdata *pdata = max98095->pdata;
-	int channel = max98095_get_bq_channel(kcontrol->id.name);
+	int channel = max98095_get_bq_channel(codec, kcontrol->id.name);
 	struct max98095_cdata *cdata;
 	int sel = ucontrol->value.integer.value[0];
 	struct max98095_biquad_cfg *coef_set;
 	int fs, best, best_val, i;
 	int regmask, regsave;
 
-	BUG_ON(channel > 1);
+	if (channel < 0)
+		return channel;
 
 	if (!pdata || !max98095->bq_textcnt)
 		return 0;
@@ -2066,9 +2074,12 @@ static int max98095_get_bq_enum(struct snd_kcontrol *kcontrol,
 {
 	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
 	struct max98095_priv *max98095 = snd_soc_codec_get_drvdata(codec);
-	int channel = max98095_get_bq_channel(kcontrol->id.name);
+	int channel = max98095_get_bq_channel(codec, kcontrol->id.name);
 	struct max98095_cdata *cdata;
 
+	if (channel < 0)
+		return channel;
+
 	cdata = &max98095->dai[channel];
 	ucontrol->value.enumerated.item[0] = cdata->bq_sel;
 
@@ -2086,15 +2097,16 @@ static void max98095_handle_bq_pdata(struct snd_soc_codec *codec)
 	int ret;
 
 	struct snd_kcontrol_new controls[] = {
-		SOC_ENUM_EXT("Biquad1 Mode",
+		SOC_ENUM_EXT((char *)bq_mode_name[0],
 			max98095->bq_enum,
 			max98095_get_bq_enum,
 			max98095_put_bq_enum),
-		SOC_ENUM_EXT("Biquad2 Mode",
+		SOC_ENUM_EXT((char *)bq_mode_name[1],
 			max98095->bq_enum,
 			max98095_get_bq_enum,
 			max98095_put_bq_enum),
 	};
+	BUILD_BUG_ON(ARRAY_SIZE(controls) != ARRAY_SIZE(bq_mode_name));
 
 	cfg = pdata->bq_cfg;
 	cfgcnt = pdata->bq_cfgcnt;
-- 
1.7.0.4

