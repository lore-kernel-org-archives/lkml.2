Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab1JQDu6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 23:50:58 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59196 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab1JQDu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 23:50:57 -0400
Subject: [PATCH v2] ASoC: wm8580: Use snd_soc_update_bits for
 read-modify-write
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Oct 2011 11:50:46 +0800
Message-ID: <1318823446.8786.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use snd_soc_update_bits for read-modify-write register access instead of
open-coding it using snd_soc_read and snd_soc_write

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
v2: Fix below build warning:
  CC      sound/soc/codecs/wm8580.o
sound/soc/codecs/wm8580.c: In function 'wm8580_set_bias_level':
sound/soc/codecs/wm8580.c:749: warning: unused variable 'reg'

 sound/soc/codecs/wm8580.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/sound/soc/codecs/wm8580.c b/sound/soc/codecs/wm8580.c
index b256727..8212b3c 100644
--- a/sound/soc/codecs/wm8580.c
+++ b/sound/soc/codecs/wm8580.c
@@ -430,8 +430,7 @@ static int wm8580_set_dai_pll(struct snd_soc_dai *codec_dai, int pll_id,
 	/* Always disable the PLL - it is not safe to leave it running
 	 * while reprogramming it.
 	 */
-	reg = snd_soc_read(codec, WM8580_PWRDN2);
-	snd_soc_write(codec, WM8580_PWRDN2, reg | pwr_mask);
+	snd_soc_update_bits(codec, WM8580_PWRDN2, pwr_mask, pwr_mask);
 
 	if (!freq_in || !freq_out)
 		return 0;
@@ -449,8 +448,7 @@ static int wm8580_set_dai_pll(struct snd_soc_dai *codec_dai, int pll_id,
 	snd_soc_write(codec, WM8580_PLLA4 + offset, reg);
 
 	/* All done, turn it on */
-	reg = snd_soc_read(codec, WM8580_PWRDN2);
-	snd_soc_write(codec, WM8580_PWRDN2, reg & ~pwr_mask);
+	snd_soc_update_bits(codec, WM8580_PWRDN2, pwr_mask, 0);
 
 	return 0;
 }
@@ -748,7 +746,6 @@ static int wm8580_digital_mute(struct snd_soc_dai *codec_dai, int mute)
 static int wm8580_set_bias_level(struct snd_soc_codec *codec,
 	enum snd_soc_bias_level level)
 {
-	u16 reg;
 	switch (level) {
 	case SND_SOC_BIAS_ON:
 	case SND_SOC_BIAS_PREPARE:
@@ -757,20 +754,19 @@ static int wm8580_set_bias_level(struct snd_soc_codec *codec,
 	case SND_SOC_BIAS_STANDBY:
 		if (codec->dapm.bias_level == SND_SOC_BIAS_OFF) {
 			/* Power up and get individual control of the DACs */
-			reg = snd_soc_read(codec, WM8580_PWRDN1);
-			reg &= ~(WM8580_PWRDN1_PWDN | WM8580_PWRDN1_ALLDACPD);
-			snd_soc_write(codec, WM8580_PWRDN1, reg);
+			snd_soc_update_bits(codec, WM8580_PWRDN1,
+					    WM8580_PWRDN1_PWDN |
+					    WM8580_PWRDN1_ALLDACPD, 0);
 
 			/* Make VMID high impedance */
-			reg = snd_soc_read(codec,  WM8580_ADC_CONTROL1);
-			reg &= ~0x100;
-			snd_soc_write(codec, WM8580_ADC_CONTROL1, reg);
+			snd_soc_update_bits(codec, WM8580_ADC_CONTROL1,
+					    0x100, 0);
 		}
 		break;
 
 	case SND_SOC_BIAS_OFF:
-		reg = snd_soc_read(codec, WM8580_PWRDN1);
-		snd_soc_write(codec, WM8580_PWRDN1, reg | WM8580_PWRDN1_PWDN);
+		snd_soc_update_bits(codec, WM8580_PWRDN1,
+				    WM8580_PWRDN1_PWDN, WM8580_PWRDN1_PWDN);
 		break;
 	}
 	codec->dapm.bias_level = level;
-- 
1.7.4.1



