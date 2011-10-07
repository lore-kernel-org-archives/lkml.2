Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965473Ab1JGNwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 09:52:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62734 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab1JGNwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 09:52:07 -0400
Subject: [PATCH v3 08/10] ASoC: wm8971: Convert to snd_soc_cache_sync
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1317994508.9906.1.camel@phoenix>
References: <1317994508.9906.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 21:52:00 +0800
Message-ID: <1317995520.9906.15.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to snd_soc_cache_sync for sync reg_cache with the hardware.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8971.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/sound/soc/codecs/wm8971.c b/sound/soc/codecs/wm8971.c
index 08ea6f8..b444b29 100644
--- a/sound/soc/codecs/wm8971.c
+++ b/sound/soc/codecs/wm8971.c
@@ -546,6 +546,9 @@ static int wm8971_set_bias_level(struct snd_soc_codec *codec,
 	case SND_SOC_BIAS_PREPARE:
 		break;
 	case SND_SOC_BIAS_STANDBY:
+		if (codec->dapm.bias_level == SND_SOC_BIAS_OFF)
+			snd_soc_cache_sync(codec);
+
 		/* mute dac and set vmid to 500k, enable VREF */
 		snd_soc_write(codec, WM8971_PWR1, pwr_reg | 0x0140);
 		break;
@@ -605,20 +608,8 @@ static int wm8971_suspend(struct snd_soc_codec *codec, pm_message_t state)
 
 static int wm8971_resume(struct snd_soc_codec *codec)
 {
-	int i;
-	u8 data[2];
-	u16 *cache = codec->reg_cache;
 	u16 reg;
 
-	/* Sync reg_cache with the hardware */
-	for (i = 0; i < ARRAY_SIZE(wm8971_reg); i++) {
-		if (i == WM8971_RESET)
-			continue;
-		data[0] = (i << 1) | ((cache[i] >> 8) & 0x0001);
-		data[1] = cache[i] & 0x00ff;
-		codec->hw_write(codec->control_data, data, 2);
-	}
-
 	wm8971_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
 	/* charge wm8971 caps */
-- 
1.7.4.1



