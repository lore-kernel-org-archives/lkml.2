Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933553Ab1IOMkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:40:45 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:48723 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933520Ab1IOMkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:40:22 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH 05/17] ASoC: twl6040: Chip initialization cleanup
Date: Thu, 15 Sep 2011 15:39:27 +0300
Message-Id: <1316090379-30760-6-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to write to the vio registers at probe time, since most
them either read only, or shared with MFD or not used.
On the other hand it is a good idea to updated the ASICREV register in
the cache at this time.

After power up we need to restore some registers. Clean up the list to
contain only the registers we are going to restore.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 include/linux/mfd/twl6040.h |    3 -
 sound/soc/codecs/twl6040.c  |  100 ++++++-------------------------------------
 2 files changed, 13 insertions(+), 90 deletions(-)

diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
index cb3b822..ec1ec79 100644
--- a/include/linux/mfd/twl6040.h
+++ b/include/linux/mfd/twl6040.h
@@ -70,9 +70,6 @@
 
 #define TWL6040_CACHEREGNUM		(TWL6040_REG_STATUS + 1)
 
-#define TWL6040_VIOREGNUM		18
-#define TWL6040_VDDREGNUM		21
-
 /* INTID (0x03) fields */
 
 #define TWL6040_THINT			0x01
diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index 443032b..8bbd46a 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -155,41 +155,8 @@ static const u8 twl6040_reg[TWL6040_CACHEREGNUM] = {
 	0x00, /* TWL6040_STATUS (ro)	0x2E	*/
 };
 
-/*
- * twl6040 vio/gnd registers:
- * registers under vio/gnd supply can be accessed
- * before the power-up sequence, after NRESPWRON goes high
- */
-static const int twl6040_vio_reg[TWL6040_VIOREGNUM] = {
-	TWL6040_REG_ASICID,
-	TWL6040_REG_ASICREV,
-	TWL6040_REG_INTID,
-	TWL6040_REG_INTMR,
-	TWL6040_REG_NCPCTL,
-	TWL6040_REG_LDOCTL,
-	TWL6040_REG_AMICBCTL,
-	TWL6040_REG_DMICBCTL,
-	TWL6040_REG_HKCTL1,
-	TWL6040_REG_HKCTL2,
-	TWL6040_REG_GPOCTL,
-	TWL6040_REG_TRIM1,
-	TWL6040_REG_TRIM2,
-	TWL6040_REG_TRIM3,
-	TWL6040_REG_HSOTRIM,
-	TWL6040_REG_HFOTRIM,
-	TWL6040_REG_ACCCTL,
-	TWL6040_REG_STATUS,
-};
-
-/*
- * twl6040 vdd/vss registers:
- * registers under vdd/vss supplies can only be accessed
- * after the power-up sequence
- */
-static const int twl6040_vdd_reg[TWL6040_VDDREGNUM] = {
-	TWL6040_REG_HPPLLCTL,
-	TWL6040_REG_LPPLLCTL,
-	TWL6040_REG_LPPLLDIV,
+/* List of registers to be restored after power up */
+static const int twl6040_restore_list[] = {
 	TWL6040_REG_MICLCTL,
 	TWL6040_REG_MICRCTL,
 	TWL6040_REG_MICGAIN,
@@ -202,12 +169,6 @@ static const int twl6040_vdd_reg[TWL6040_VDDREGNUM] = {
 	TWL6040_REG_HFLGAIN,
 	TWL6040_REG_HFRCTL,
 	TWL6040_REG_HFRGAIN,
-	TWL6040_REG_VIBCTLL,
-	TWL6040_REG_VIBDATL,
-	TWL6040_REG_VIBCTLR,
-	TWL6040_REG_VIBDATR,
-	TWL6040_REG_ALB,
-	TWL6040_REG_DLB,
 };
 
 /* set of rates for each pll: low-power and high-performance */
@@ -296,56 +257,23 @@ static int twl6040_write(struct snd_soc_codec *codec,
 	return twl6040_reg_write(twl6040, reg, value);
 }
 
-static void twl6040_init_vio_regs(struct snd_soc_codec *codec)
+static void twl6040_init_chip(struct snd_soc_codec *codec)
 {
-	u8 *cache = codec->reg_cache;
-	int reg, i;
+	struct twl6040 *twl6040 = codec->control_data;
+	u8 val;
+
+	val = twl6040_get_revid(twl6040);
+	twl6040_write_reg_cache(codec, TWL6040_REG_ASICREV, val);
 
-	for (i = 0; i < TWL6040_VIOREGNUM; i++) {
-		reg = twl6040_vio_reg[i];
-		/*
-		 * skip read-only registers (ASICID, ASICREV, STATUS)
-		 * and registers shared among MFD children
-		 */
-		switch (reg) {
-		case TWL6040_REG_ASICID:
-		case TWL6040_REG_ASICREV:
-		case TWL6040_REG_INTID:
-		case TWL6040_REG_INTMR:
-		case TWL6040_REG_NCPCTL:
-		case TWL6040_REG_LDOCTL:
-		case TWL6040_REG_GPOCTL:
-		case TWL6040_REG_ACCCTL:
-		case TWL6040_REG_STATUS:
-			continue;
-		default:
-			break;
-		}
-		twl6040_write(codec, reg, cache[reg]);
-	}
 }
 
-static void twl6040_init_vdd_regs(struct snd_soc_codec *codec)
+static void twl6040_restore_regs(struct snd_soc_codec *codec)
 {
 	u8 *cache = codec->reg_cache;
 	int reg, i;
 
-	for (i = 0; i < TWL6040_VDDREGNUM; i++) {
-		reg = twl6040_vdd_reg[i];
-		/* skip vibra and PLL registers */
-		switch (reg) {
-		case TWL6040_REG_VIBCTLL:
-		case TWL6040_REG_VIBDATL:
-		case TWL6040_REG_VIBCTLR:
-		case TWL6040_REG_VIBDATR:
-		case TWL6040_REG_HPPLLCTL:
-		case TWL6040_REG_LPPLLCTL:
-		case TWL6040_REG_LPPLLDIV:
-			continue;
-		default:
-			break;
-		}
-
+	for (i = 0; i < ARRAY_SIZE(twl6040_restore_list); i++) {
+		reg = twl6040_restore_list[i];
 		twl6040_write(codec, reg, cache[reg]);
 	}
 }
@@ -1325,8 +1253,7 @@ static int twl6040_set_bias_level(struct snd_soc_codec *codec,
 
 		priv->codec_powered = 1;
 
-		/* initialize vdd/vss registers with reg_cache */
-		twl6040_init_vdd_regs(codec);
+		twl6040_restore_regs(codec);
 
 		/* Set external boost GPO */
 		twl6040_write(codec, TWL6040_REG_GPOCTL, 0x02);
@@ -1620,8 +1547,7 @@ static int twl6040_probe(struct snd_soc_codec *codec)
 		goto plugirq_err;
 	}
 
-	/* init vio registers */
-	twl6040_init_vio_regs(codec);
+	twl6040_init_chip(codec);
 
 	/* power on device */
 	ret = twl6040_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
-- 
1.7.6.1

