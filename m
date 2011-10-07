Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086Ab1JGNxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 09:53:47 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41310 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760029Ab1JGNxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 09:53:46 -0400
Subject: [PATCH v3 10/10] ASoC: wm8988: Convert to snd_soc_cache_sync
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1317994508.9906.1.camel@phoenix>
References: <1317994508.9906.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 21:53:39 +0800
Message-ID: <1317995619.9906.17.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to snd_soc_cache_sync for sync reg_cache with the hardware.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8988.c |   17 ++---------------
 1 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/sound/soc/codecs/wm8988.c b/sound/soc/codecs/wm8988.c
index 1c6f8bf..2e9eba7 100644
--- a/sound/soc/codecs/wm8988.c
+++ b/sound/soc/codecs/wm8988.c
@@ -55,7 +55,6 @@ struct wm8988_priv {
 	struct snd_pcm_hw_constraint_list *sysclk_constraints;
 };
 
-
 #define wm8988_reset(c)	snd_soc_write(c, WM8988_RESET, 0)
 
 /*
@@ -676,6 +675,8 @@ static int wm8988_set_bias_level(struct snd_soc_codec *codec,
 
 	case SND_SOC_BIAS_STANDBY:
 		if (codec->dapm.bias_level == SND_SOC_BIAS_OFF) {
+			snd_soc_cache_sync(codec);
+
 			/* VREF, VMID=2x5k */
 			snd_soc_write(codec, WM8988_PWR1, pwr_reg | 0x1c1);
 
@@ -736,21 +737,7 @@ static int wm8988_suspend(struct snd_soc_codec *codec, pm_message_t state)
 
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
 
-- 
1.7.4.1



