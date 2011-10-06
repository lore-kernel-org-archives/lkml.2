Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935691Ab1JFGPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 02:15:03 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58163 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933935Ab1JFGPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 02:15:01 -0400
Subject: [PATCH 03/10] ASoC: wm8731: Convert to snd_soc_cache_sync
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
Date: Thu, 06 Oct 2011 14:14:54 +0800
Message-ID: <1317881694.13399.7.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to snd_soc_cache_sync for sync reg_cache with the hardware.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8731.c |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/sound/soc/codecs/wm8731.c b/sound/soc/codecs/wm8731.c
index f76b6fc..78cbcf8 100644
--- a/sound/soc/codecs/wm8731.c
+++ b/sound/soc/codecs/wm8731.c
@@ -63,6 +63,17 @@ static const u16 wm8731_reg[WM8731_CACHEREGNUM] = {
 	0x0000, 0x0000
 };
 
+static int wm8731_volatile_register(struct snd_soc_codec *codec,
+				    unsigned int reg)
+{
+	switch (reg) {
+	case WM8731_RESET:
+		return 1;
+	default:
+		return 0;
+	}
+}
+
 #define wm8731_reset(c)	snd_soc_write(c, WM8731_RESET, 0)
 
 static const char *wm8731_input_select[] = {"Line In", "Mic"};
@@ -427,9 +438,7 @@ static int wm8731_set_bias_level(struct snd_soc_codec *codec,
 				 enum snd_soc_bias_level level)
 {
 	struct wm8731_priv *wm8731 = snd_soc_codec_get_drvdata(codec);
-	int i, ret;
-	u8 data[2];
-	u16 *cache = codec->reg_cache;
+	int ret;
 	u16 reg;
 
 	switch (level) {
@@ -444,15 +453,10 @@ static int wm8731_set_bias_level(struct snd_soc_codec *codec,
 			if (ret != 0)
 				return ret;
 
-			/* Sync reg_cache with the hardware */
-			for (i = 0; i < ARRAY_SIZE(wm8731_reg); i++) {
-				if (cache[i] == wm8731_reg[i])
-					continue;
-
-				data[0] = (i << 1) | ((cache[i] >> 8)
-						      & 0x0001);
-				data[1] = cache[i] & 0x00ff;
-				codec->hw_write(codec->control_data, data, 2);
+			ret = snd_soc_cache_sync(codec);
+			if (ret < 0) {
+				dev_err(codec->dev, "Failed to sync cache: %d\n", ret);
+				return ret;
 			}
 		}
 
@@ -606,6 +610,7 @@ static struct snd_soc_codec_driver soc_codec_dev_wm8731 = {
 	.num_dapm_widgets = ARRAY_SIZE(wm8731_dapm_widgets),
 	.dapm_routes = wm8731_intercon,
 	.num_dapm_routes = ARRAY_SIZE(wm8731_intercon),
+	.volatile_register = wm8731_volatile_register,
 };
 
 static const struct of_device_id wm8731_of_match[] = {
-- 
1.7.4.1



