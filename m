Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab1KIIiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:38:19 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40115 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037Ab1KIIiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:38:17 -0500
Message-ID: <1320827885.6708.1.camel@phoenix>
Subject: [PATCH v3] ASoC: wm9081: Use snd_soc_update_bits for
 read-modify-write
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Date: Wed, 09 Nov 2011 16:38:05 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use snd_soc_update_bits for read-modify-write register access instead of
open-coding it using snd_soc_read and snd_soc_write

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm9081.c |   82 ++++++++++++++++++++-------------------------
 1 files changed, 36 insertions(+), 46 deletions(-)

diff --git a/sound/soc/codecs/wm9081.c b/sound/soc/codecs/wm9081.c
index b491ae1..f032078 100644
--- a/sound/soc/codecs/wm9081.c
+++ b/sound/soc/codecs/wm9081.c
@@ -826,84 +826,75 @@ static const struct snd_soc_dapm_route wm9081_audio_paths[] = {
 static int wm9081_set_bias_level(struct snd_soc_codec *codec,
 				 enum snd_soc_bias_level level)
 {
-	u16 reg;
-
 	switch (level) {
 	case SND_SOC_BIAS_ON:
 		break;
 
 	case SND_SOC_BIAS_PREPARE:
 		/* VMID=2*40k */
-		reg = snd_soc_read(codec, WM9081_VMID_CONTROL);
-		reg &= ~WM9081_VMID_SEL_MASK;
-		reg |= 0x2;
-		snd_soc_write(codec, WM9081_VMID_CONTROL, reg);
+		snd_soc_update_bits(codec, WM9081_VMID_CONTROL,
+				    WM9081_VMID_SEL_MASK, 0x2);
 
 		/* Normal bias current */
-		reg = snd_soc_read(codec, WM9081_BIAS_CONTROL_1);
-		reg &= ~WM9081_STBY_BIAS_ENA;
-		snd_soc_write(codec, WM9081_BIAS_CONTROL_1, reg);
+		snd_soc_update_bits(codec, WM9081_BIAS_CONTROL_1,
+				    WM9081_STBY_BIAS_ENA, 0);
 		break;
 
 	case SND_SOC_BIAS_STANDBY:
 		/* Initial cold start */
 		if (codec->dapm.bias_level == SND_SOC_BIAS_OFF) {
 			/* Disable LINEOUT discharge */
-			reg = snd_soc_read(codec, WM9081_ANTI_POP_CONTROL);
-			reg &= ~WM9081_LINEOUT_DISCH;
-			snd_soc_write(codec, WM9081_ANTI_POP_CONTROL, reg);
+			snd_soc_update_bits(codec, WM9081_ANTI_POP_CONTROL,
+					    WM9081_LINEOUT_DISCH, 0);
 
 			/* Select startup bias source */
-			reg = snd_soc_read(codec, WM9081_BIAS_CONTROL_1);
-			reg |= WM9081_BIAS_SRC | WM9081_BIAS_ENA;
-			snd_soc_write(codec, WM9081_BIAS_CONTROL_1, reg);
+			snd_soc_update_bits(codec, WM9081_BIAS_CONTROL_1,
+					    WM9081_BIAS_SRC | WM9081_BIAS_ENA,
+					    WM9081_BIAS_SRC | WM9081_BIAS_ENA);
 
 			/* VMID 2*4k; Soft VMID ramp enable */
-			reg = snd_soc_read(codec, WM9081_VMID_CONTROL);
-			reg |= WM9081_VMID_RAMP | 0x6;
-			snd_soc_write(codec, WM9081_VMID_CONTROL, reg);
+			snd_soc_update_bits(codec, WM9081_VMID_CONTROL,
+					    WM9081_VMID_RAMP |
+					    WM9081_VMID_SEL_MASK,
+					    WM9081_VMID_RAMP | 0x6);
 
 			mdelay(100);
 
 			/* Normal bias enable & soft start off */
-			reg &= ~WM9081_VMID_RAMP;
-			snd_soc_write(codec, WM9081_VMID_CONTROL, reg);
+			snd_soc_update_bits(codec, WM9081_VMID_CONTROL,
+					    WM9081_VMID_RAMP |
+					    WM9081_VMID_SEL_MASK, 0);
 
 			/* Standard bias source */
-			reg = snd_soc_read(codec, WM9081_BIAS_CONTROL_1);
-			reg &= ~WM9081_BIAS_SRC;
-			snd_soc_write(codec, WM9081_BIAS_CONTROL_1, reg);
+			snd_soc_update_bits(codec, WM9081_BIAS_CONTROL_1,
+					    WM9081_BIAS_SRC, 0);
 		}
 
 		/* VMID 2*240k */
-		reg = snd_soc_read(codec, WM9081_VMID_CONTROL);
-		reg &= ~WM9081_VMID_SEL_MASK;
-		reg |= 0x04;
-		snd_soc_write(codec, WM9081_VMID_CONTROL, reg);
+		snd_soc_update_bits(codec, WM9081_VMID_CONTROL,
+				    WM9081_VMID_SEL_MASK, 0x04);
 
 		/* Standby bias current on */
-		reg = snd_soc_read(codec, WM9081_BIAS_CONTROL_1);
-		reg |= WM9081_STBY_BIAS_ENA;
-		snd_soc_write(codec, WM9081_BIAS_CONTROL_1, reg);
+		snd_soc_update_bits(codec, WM9081_BIAS_CONTROL_1,
+				    WM9081_STBY_BIAS_ENA,
+				    WM9081_STBY_BIAS_ENA);
 		break;
 
 	case SND_SOC_BIAS_OFF:
 		/* Startup bias source and disable bias */
-		reg = snd_soc_read(codec, WM9081_BIAS_CONTROL_1);
-		reg |= WM9081_BIAS_SRC;
-		reg &= ~WM9081_BIAS_ENA;
-		snd_soc_write(codec, WM9081_BIAS_CONTROL_1, reg);
+		snd_soc_update_bits(codec, WM9081_BIAS_CONTROL_1,
+				    WM9081_BIAS_SRC | WM9081_BIAS_ENA,
+				    WM9081_BIAS_SRC);
 
 		/* Disable VMID with soft ramping */
-		reg = snd_soc_read(codec, WM9081_VMID_CONTROL);
-		reg &= ~WM9081_VMID_SEL_MASK;
-		reg |= WM9081_VMID_RAMP;
-		snd_soc_write(codec, WM9081_VMID_CONTROL, reg);
+		snd_soc_update_bits(codec, WM9081_VMID_CONTROL,
+				    WM9081_VMID_RAMP | WM9081_VMID_SEL_MASK,
+				    WM9081_VMID_RAMP);
 
 		/* Actively discharge LINEOUT */
-		reg = snd_soc_read(codec, WM9081_ANTI_POP_CONTROL);
-		reg |= WM9081_LINEOUT_DISCH;
-		snd_soc_write(codec, WM9081_ANTI_POP_CONTROL, reg);
+		snd_soc_update_bits(codec, WM9081_ANTI_POP_CONTROL,
+				    WM9081_LINEOUT_DISCH,
+				    WM9081_LINEOUT_DISCH);
 		break;
 	}
 
@@ -1291,11 +1282,10 @@ static int wm9081_probe(struct snd_soc_codec *codec)
 	wm9081_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
 	/* Enable zero cross by default */
-	reg = snd_soc_read(codec, WM9081_ANALOGUE_LINEOUT);
-	snd_soc_write(codec, WM9081_ANALOGUE_LINEOUT, reg | WM9081_LINEOUTZC);
-	reg = snd_soc_read(codec, WM9081_ANALOGUE_SPEAKER_PGA);
-	snd_soc_write(codec, WM9081_ANALOGUE_SPEAKER_PGA,
-		     reg | WM9081_SPKPGAZC);
+	snd_soc_update_bits(codec, WM9081_ANALOGUE_LINEOUT,
+			    WM9081_LINEOUTZC, WM9081_LINEOUTZC);
+	snd_soc_update_bits(codec, WM9081_ANALOGUE_SPEAKER_PGA,
+			    WM9081_SPKPGAZC, WM9081_SPKPGAZC);
 
 	if (!wm9081->pdata.num_retune_configs) {
 		dev_dbg(codec->dev,
-- 
1.7.5.4



