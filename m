Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab1JMO4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 10:56:47 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49869 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab1JMO4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 10:56:46 -0400
Subject: [PATCH] ASoC: tlv320aic32x4: Use snd_soc_update_bits for
 read-modify-write
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Javier Martin <javier.martin@vista-silicon.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Oct 2011 22:56:34 +0800
Message-ID: <1318517794.4554.4.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use snd_soc_update_bits for read-modify-write register access instead of
open-coding it using snd_soc_read and snd_soc_write.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This patch also fixes the mix usage of 
AIC32X4_MDACEN/AIC32X4_NDACEN/AIC32X4_NADCEN/AIC32X4_MADCEN in current code.
(They are all defined as (0x01 << 7), so it is not a bug,
 but not good for readability.)
Axel

 sound/soc/codecs/tlv320aic32x4.c |   61 +++++++++++++++-----------------------
 1 files changed, 24 insertions(+), 37 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic32x4.c b/sound/soc/codecs/tlv320aic32x4.c
index a68982e..b21c610 100644
--- a/sound/soc/codecs/tlv320aic32x4.c
+++ b/sound/soc/codecs/tlv320aic32x4.c
@@ -528,40 +528,33 @@ static int aic32x4_set_bias_level(struct snd_soc_codec *codec,
 				  enum snd_soc_bias_level level)
 {
 	struct aic32x4_priv *aic32x4 = snd_soc_codec_get_drvdata(codec);
-	u8 value;
 
 	switch (level) {
 	case SND_SOC_BIAS_ON:
 		if (aic32x4->master) {
 			/* Switch on PLL */
-			value = snd_soc_read(codec, AIC32X4_PLLPR);
-			snd_soc_write(codec, AIC32X4_PLLPR,
-				      (value | AIC32X4_PLLEN));
+			snd_soc_update_bits(codec, AIC32X4_PLLPR,
+					    AIC32X4_PLLEN, AIC32X4_PLLEN);
 
 			/* Switch on NDAC Divider */
-			value = snd_soc_read(codec, AIC32X4_NDAC);
-			snd_soc_write(codec, AIC32X4_NDAC,
-				      value | AIC32X4_NDACEN);
+			snd_soc_update_bits(codec, AIC32X4_NDAC,
+					    AIC32X4_NDACEN, AIC32X4_NDACEN);
 
 			/* Switch on MDAC Divider */
-			value = snd_soc_read(codec, AIC32X4_MDAC);
-			snd_soc_write(codec, AIC32X4_MDAC,
-				      value | AIC32X4_MDACEN);
+			snd_soc_update_bits(codec, AIC32X4_MDAC,
+					    AIC32X4_MDACEN, AIC32X4_MDACEN);
 
 			/* Switch on NADC Divider */
-			value = snd_soc_read(codec, AIC32X4_NADC);
-			snd_soc_write(codec, AIC32X4_NADC,
-				      value | AIC32X4_MDACEN);
+			snd_soc_update_bits(codec, AIC32X4_NADC,
+					    AIC32X4_NADCEN, AIC32X4_NADCEN);
 
 			/* Switch on MADC Divider */
-			value = snd_soc_read(codec, AIC32X4_MADC);
-			snd_soc_write(codec, AIC32X4_MADC,
-				      value | AIC32X4_MDACEN);
+			snd_soc_update_bits(codec, AIC32X4_MADC,
+					    AIC32X4_MADCEN, AIC32X4_MADCEN);
 
 			/* Switch on BCLK_N Divider */
-			value = snd_soc_read(codec, AIC32X4_BCLKN);
-			snd_soc_write(codec, AIC32X4_BCLKN,
-				      value | AIC32X4_BCLKEN);
+			snd_soc_update_bits(codec, AIC32X4_BCLKN,
+					    AIC32X4_BCLKEN, AIC32X4_BCLKEN);
 		}
 		break;
 	case SND_SOC_BIAS_PREPARE:
@@ -569,34 +562,28 @@ static int aic32x4_set_bias_level(struct snd_soc_codec *codec,
 	case SND_SOC_BIAS_STANDBY:
 		if (aic32x4->master) {
 			/* Switch off PLL */
-			value = snd_soc_read(codec, AIC32X4_PLLPR);
-			snd_soc_write(codec, AIC32X4_PLLPR,
-				      (value & ~AIC32X4_PLLEN));
+			snd_soc_update_bits(codec, AIC32X4_PLLPR,
+					    AIC32X4_PLLEN, 0);
 
 			/* Switch off NDAC Divider */
-			value = snd_soc_read(codec, AIC32X4_NDAC);
-			snd_soc_write(codec, AIC32X4_NDAC,
-				      value & ~AIC32X4_NDACEN);
+			snd_soc_update_bits(codec, AIC32X4_NDAC,
+					    AIC32X4_NDACEN, 0);
 
 			/* Switch off MDAC Divider */
-			value = snd_soc_read(codec, AIC32X4_MDAC);
-			snd_soc_write(codec, AIC32X4_MDAC,
-				      value & ~AIC32X4_MDACEN);
+			snd_soc_update_bits(codec, AIC32X4_MDAC,
+					    AIC32X4_MDACEN, 0);
 
 			/* Switch off NADC Divider */
-			value = snd_soc_read(codec, AIC32X4_NADC);
-			snd_soc_write(codec, AIC32X4_NADC,
-				      value & ~AIC32X4_NDACEN);
+			snd_soc_update_bits(codec, AIC32X4_NADC,
+					    AIC32X4_NADCEN, 0);
 
 			/* Switch off MADC Divider */
-			value = snd_soc_read(codec, AIC32X4_MADC);
-			snd_soc_write(codec, AIC32X4_MADC,
-				      value & ~AIC32X4_MDACEN);
-			value = snd_soc_read(codec, AIC32X4_BCLKN);
+			snd_soc_update_bits(codec, AIC32X4_MADC,
+					    AIC32X4_MADCEN, 0);
 
 			/* Switch off BCLK_N Divider */
-			snd_soc_write(codec, AIC32X4_BCLKN,
-				      value & ~AIC32X4_BCLKEN);
+			snd_soc_update_bits(codec, AIC32X4_BCLKN,
+					    AIC32X4_BCLKEN, 0);
 		}
 		break;
 	case SND_SOC_BIAS_OFF:
-- 
1.7.4.1



