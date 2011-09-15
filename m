Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596Ab1IOMkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:40:51 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:54086 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933524Ab1IOMkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:40:35 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH 10/17] ASoC: twl6040: Introduce SW only shadow register
Date: Thu, 15 Sep 2011 15:39:32 +0300
Message-Id: <1316090379-30760-11-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Software only shadow register to be used by the driver.
For example Earpiece path will need this shadow register.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 include/linux/mfd/twl6040.h |    2 --
 sound/soc/codecs/twl6040.c  |   19 ++++++++++++++++---
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
index ec1ec79..47470ca 100644
--- a/include/linux/mfd/twl6040.h
+++ b/include/linux/mfd/twl6040.h
@@ -68,8 +68,6 @@
 #define TWL6040_REG_ACCCTL		0x2D
 #define TWL6040_REG_STATUS		0x2E
 
-#define TWL6040_CACHEREGNUM		(TWL6040_REG_STATUS + 1)
-
 /* INTID (0x03) fields */
 
 #define TWL6040_THINT			0x01
diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index 689e88b..ce9fb37 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -57,6 +57,10 @@
 #define TWL6040_HF_VOL_MASK	0x1F
 #define TWL6040_HF_VOL_SHIFT	0
 
+/* Shadow register used by the driver */
+#define TWL6040_REG_SW_SHADOW	0x2F
+#define TWL6040_CACHEREGNUM	(TWL6040_REG_SW_SHADOW + 1)
+
 struct twl6040_output {
 	u16 active;
 	u16 left_vol;
@@ -153,6 +157,8 @@ static const u8 twl6040_reg[TWL6040_CACHEREGNUM] = {
 	0x00, /* REG_HFOTRIM	0x2C	*/
 	0x09, /* REG_ACCCTL	0x2D	*/
 	0x00, /* REG_STATUS	0x2E (ro) */
+
+	0x00, /* REG_SW_SHADOW	0x2F - Shadow, non HW register */
 };
 
 /* List of registers to be restored after power up */
@@ -236,8 +242,12 @@ static int twl6040_read_reg_volatile(struct snd_soc_codec *codec,
 	if (reg >= TWL6040_CACHEREGNUM)
 		return -EIO;
 
-	value = twl6040_reg_read(twl6040, reg);
-	twl6040_write_reg_cache(codec, reg, value);
+	if (likely(reg < TWL6040_REG_SW_SHADOW)) {
+		value = twl6040_reg_read(twl6040, reg);
+		twl6040_write_reg_cache(codec, reg, value);
+	} else {
+		value = twl6040_read_reg_cache(codec, reg);
+	}
 
 	return value;
 }
@@ -254,7 +264,10 @@ static int twl6040_write(struct snd_soc_codec *codec,
 		return -EIO;
 
 	twl6040_write_reg_cache(codec, reg, value);
-	return twl6040_reg_write(twl6040, reg, value);
+	if (likely(reg < TWL6040_REG_SW_SHADOW))
+		return twl6040_reg_write(twl6040, reg, value);
+	else
+		return 0;
 }
 
 static void twl6040_init_chip(struct snd_soc_codec *codec)
-- 
1.7.6.1

