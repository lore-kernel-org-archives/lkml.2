Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab1JRCgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 22:36:39 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46724 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab1JRCgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 22:36:38 -0400
Message-ID: <1318905385.4228.1.camel@phoenix>
Subject: [PATCH v2] ASoC: wm9081: Use snd_soc_update_bits for
 read-modify-write
From: axel <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Date: Tue, 18 Oct 2011 10:36:25 +0800
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
v2:
For Initial cold start ( change bias level from SND_SOC_BIAS_OFF to
SND_SOC_BIAS_STANDBY ), the v1 does not set VMID_SEL[1:0] bits
correctly for Normal bias enable & soft start off.
In v2 we also clear VMID_SEL[1:0] bits for Normal bias enable & soft start off.
We did clear VMID_SEL[1:0] bits in SND_SOC_BIAS_OFF,
thus we know the VMID_SEL[1:0] bits status is 0b00 in this case.

 sound/soc/codecs/wm9081.c |   82 +++++++++++++++++++-------------------------
 1 files changed, 35 insertions(+), 47 deletions(-)

diff --git a/sound/soc/codecs/wm9081.c b/sound/soc/codecs/wm9081.c
index 66092ef..9c38ddb 100644
--- a/sound/soc/codecs/wm9081.c
+++ b/sound/soc/codecs/wm9081.c
@@ -766,84 +766,73 @@ static const struct snd_soc_dapm_route wm9081_audio_paths[] = {
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
-
+			snd_soc_update_bits(codec, WM9081_VMID_CONTROL,
+					    WM9081_VMID_RAMP | 0x6,
+					    WM9081_VMID_RAMP | 0x6);
 			mdelay(100);
 
 			/* Normal bias enable & soft start off */
-			reg |= WM9081_BIAS_ENA;
-			reg &= ~WM9081_VMID_RAMP;
-			snd_soc_write(codec, WM9081_VMID_CONTROL, reg);
+			snd_soc_update_bits(codec, WM9081_VMID_CONTROL,
+					    WM9081_VMID_RAMP | WM9081_BIAS_ENA |
+					    WM9081_VMID_SEL_MASK,
+					    WM9081_BIAS_ENA);
 
 			/* Standard bias source */
-			reg = snd_soc_read(codec, WM9081_BIAS_CONTROL_1);
-			reg &= ~WM9081_BIAS_SRC;
-			snd_soc_write(codec, WM9081_BIAS_CONTROL_1, reg);
+			snd_soc_update_bits(codec, WM9081_BIAS_CONTROL_1,
+					    WM9081_BIAS_SRC, 0);
 		}
 
 		/* VMID 2*240k */
-		reg = snd_soc_read(codec, WM9081_BIAS_CONTROL_1);
-		reg &= ~WM9081_VMID_SEL_MASK;
-		reg |= 0x04;
-		snd_soc_write(codec, WM9081_VMID_CONTROL, reg);
+		snd_soc_update_bits(codec, WM9081_BIAS_CONTROL_1,
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
 		/* Startup bias source */
-		reg = snd_soc_read(codec, WM9081_BIAS_CONTROL_1);
-		reg |= WM9081_BIAS_SRC;
-		snd_soc_write(codec, WM9081_BIAS_CONTROL_1, reg);
+		snd_soc_update_bits(codec, WM9081_BIAS_CONTROL_1,
+				    WM9081_BIAS_SRC, WM9081_BIAS_SRC);
 
 		/* Disable VMID and biases with soft ramping */
-		reg = snd_soc_read(codec, WM9081_VMID_CONTROL);
-		reg &= ~(WM9081_VMID_SEL_MASK | WM9081_BIAS_ENA);
-		reg |= WM9081_VMID_RAMP;
-		snd_soc_write(codec, WM9081_VMID_CONTROL, reg);
+		snd_soc_update_bits(codec, WM9081_VMID_CONTROL,
+				    WM9081_VMID_RAMP | WM9081_VMID_SEL_MASK |
+				    WM9081_BIAS_ENA, WM9081_VMID_RAMP);
 
 		/* Actively discharge LINEOUT */
-		reg = snd_soc_read(codec, WM9081_ANTI_POP_CONTROL);
-		reg |= WM9081_LINEOUT_DISCH;
-		snd_soc_write(codec, WM9081_ANTI_POP_CONTROL, reg);
+		snd_soc_update_bits(codec, WM9081_ANTI_POP_CONTROL,
+				    WM9081_LINEOUT_DISCH,
+				    WM9081_LINEOUT_DISCH);
 		break;
 	}
 
@@ -1242,11 +1231,10 @@ static int wm9081_probe(struct snd_soc_codec *codec)
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
 
 	snd_soc_add_controls(codec, wm9081_snd_controls,
 			     ARRAY_SIZE(wm9081_snd_controls));
-- 
1.7.5.4



