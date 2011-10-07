Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965459Ab1JGNub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 09:50:31 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62854 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab1JGNua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 09:50:30 -0400
Subject: [PATCH v3 07/10] ASoC: wm8960: Convert to snd_soc_cache_sync
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1317994508.9906.1.camel@phoenix>
References: <1317994508.9906.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 21:50:23 +0800
Message-ID: <1317995423.9906.14.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to snd_soc_cache_sync for sync reg_cache with the hardware.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8960.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
index 831c20f..2df253c 100644
--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -574,6 +574,8 @@ static int wm8960_set_bias_level_out3(struct snd_soc_codec *codec,
 
 	case SND_SOC_BIAS_STANDBY:
 		if (codec->dapm.bias_level == SND_SOC_BIAS_OFF) {
+			snd_soc_cache_sync(codec);
+
 			/* Enable anti-pop features */
 			snd_soc_write(codec, WM8960_APOP1,
 				      WM8960_POBCTRL | WM8960_SOFT_ST |
@@ -676,6 +678,9 @@ static int wm8960_set_bias_level_capless(struct snd_soc_codec *codec,
 					    WM8960_VREF | WM8960_VMID_MASK, 0);
 			break;
 
+		case SND_SOC_BIAS_OFF:
+			snd_soc_cache_sync(codec);
+			break;
 		default:
 			break;
 		}
@@ -901,16 +906,6 @@ static int wm8960_suspend(struct snd_soc_codec *codec, pm_message_t state)
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
-- 
1.7.4.1



