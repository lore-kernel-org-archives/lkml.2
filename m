Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab0LGKVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 05:21:43 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:60489 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750887Ab0LGKVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 05:21:42 -0500
From: Mattias Wallin <mattias.wallin@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Subject: [PATCH] MFD: ab8500-core chip version cut 2.0 support
Date: Tue, 7 Dec 2010 11:20:47 +0100
Message-ID: <1291717247-10280-1-git-send-email-mattias.wallin@stericsson.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for chip version 2.0 or cut 2.0.
One new interrupt latch register - latch 12 - is introduced.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/mfd/ab8500-core.c  |   36 ++++++++++++++++++++---------
 include/linux/mfd/ab8500.h |   53 ++++++++++++++++++++++++-------------------
 2 files changed, 55 insertions(+), 34 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 7f01a3a..39c762a 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -52,6 +52,7 @@
 #define AB8500_IT_LATCH8_REG		0x27
 #define AB8500_IT_LATCH9_REG		0x28
 #define AB8500_IT_LATCH10_REG		0x29
+#define AB8500_IT_LATCH12_REG		0x2B
 #define AB8500_IT_LATCH19_REG		0x32
 #define AB8500_IT_LATCH20_REG		0x33
 #define AB8500_IT_LATCH21_REG		0x34
@@ -98,7 +99,7 @@
  * offset 0.
  */
 static const int ab8500_irq_regoffset[AB8500_NUM_IRQ_REGS] = {
-	0, 1, 2, 3, 4, 6, 7, 8, 9, 18, 19, 20, 21,
+	0, 1, 2, 3, 4, 6, 7, 8, 9, 11, 18, 19, 20, 21,
 };
 
 static int ab8500_get_chip_id(struct device *dev)
@@ -252,6 +253,10 @@ static void ab8500_irq_sync_unlock(unsigned int irq)
 		if (new == old)
 			continue;
 
+		/* Interrupt register 12 does'nt exist prior to version 0x20 */
+		if (ab8500_irq_regoffset[i] == 11 && ab8500->chip_id < 0x20)
+			continue;
+
 		ab8500->oldmask[i] = new;
 
 		reg = AB8500_IT_MASK1_REG + ab8500_irq_regoffset[i];
@@ -301,6 +306,10 @@ static irqreturn_t ab8500_irq(int irq, void *dev)
 		int status;
 		u8 value;
 
+		/* Interrupt register 12 does'nt exist prior to version 0x20 */
+		if (regoffset == 11 && ab8500->chip_id < 0x20)
+			continue;
+
 		status = get_register_interruptible(ab8500, AB8500_INTERRUPT,
 			AB8500_IT_LATCH1_REG + regoffset, &value);
 		if (status < 0 || value == 0)
@@ -554,6 +563,12 @@ static struct resource ab8500_usb_resources[] = {
 		.end = AB8500_INT_VBUS_DET_R,
 		.flags = IORESOURCE_IRQ,
 	},
+	{
+		.name = "USB_LINK_STATUS",
+		.start = AB8500_INT_USB_LINK_STATUS,
+		.end = AB8500_INT_USB_LINK_STATUS,
+		.flags = IORESOURCE_IRQ,
+	},
 };
 
 static struct resource ab8500_temp_resources[] = {
@@ -670,8 +685,9 @@ int __devinit ab8500_init(struct ab8500 *ab8500)
 	 * 0x0 - Early Drop
 	 * 0x10 - Cut 1.0
 	 * 0x11 - Cut 1.1
+	 * 0x20 - Cut 2.0
 	 */
-	if (value == 0x0 || value == 0x10 || value == 0x11) {
+	if (value == 0x0 || value == 0x10 || value == 0x11 || value == 0x20) {
 		ab8500->revision = value;
 		dev_info(ab8500->dev, "detected chip, revision: %#x\n", value);
 	} else {
@@ -684,18 +700,16 @@ int __devinit ab8500_init(struct ab8500 *ab8500)
 		plat->init(ab8500);
 
 	/* Clear and mask all interrupts */
-	for (i = 0; i < 10; i++) {
-		get_register_interruptible(ab8500, AB8500_INTERRUPT,
-			AB8500_IT_LATCH1_REG + i, &value);
-		set_register_interruptible(ab8500, AB8500_INTERRUPT,
-			AB8500_IT_MASK1_REG + i, 0xff);
-	}
+	for (i = 0; i < AB8500_NUM_IRQ_REGS; i++) {
+		/* Interrupt register 12 does'nt exist prior to version 0x20 */
+		if (ab8500_irq_regoffset[i] == 11 && ab8500->chip_id < 0x20)
+			continue;
 
-	for (i = 18; i < 24; i++) {
 		get_register_interruptible(ab8500, AB8500_INTERRUPT,
-			AB8500_IT_LATCH1_REG + i, &value);
+			AB8500_IT_LATCH1_REG + ab8500_irq_regoffset[i],
+			&value);
 		set_register_interruptible(ab8500, AB8500_INTERRUPT,
-			AB8500_IT_MASK1_REG + i, 0xff);
+			AB8500_IT_MASK1_REG + ab8500_irq_regoffset[i], 0xff);
 	}
 
 	ret = abx500_register_ops(ab8500->dev, &ab8500_ops);
diff --git a/include/linux/mfd/ab8500.h b/include/linux/mfd/ab8500.h
index 1848781..157f000 100644
--- a/include/linux/mfd/ab8500.h
+++ b/include/linux/mfd/ab8500.h
@@ -74,30 +74,37 @@
 #define AB8500_INT_ACC_DETECT_21DB_F	37
 #define AB8500_INT_ACC_DETECT_21DB_R	38
 #define AB8500_INT_GP_SW_ADC_CONV_END	39
-#define AB8500_INT_BTEMP_LOW		72
-#define AB8500_INT_BTEMP_LOW_MEDIUM	73
-#define AB8500_INT_BTEMP_MEDIUM_HIGH	74
-#define AB8500_INT_BTEMP_HIGH		75
-#define AB8500_INT_USB_CHARGER_NOT_OK	81
-#define AB8500_INT_ID_WAKEUP_R		82
-#define AB8500_INT_ID_DET_R1R		84
-#define AB8500_INT_ID_DET_R2R		85
-#define AB8500_INT_ID_DET_R3R		86
-#define AB8500_INT_ID_DET_R4R		87
-#define AB8500_INT_ID_WAKEUP_F		88
-#define AB8500_INT_ID_DET_R1F		90
-#define AB8500_INT_ID_DET_R2F		91
-#define AB8500_INT_ID_DET_R3F		92
-#define AB8500_INT_ID_DET_R4F		93
-#define AB8500_INT_USB_CHG_DET_DONE	94
-#define AB8500_INT_USB_CH_TH_PROT_F	96
-#define AB8500_INT_USB_CH_TH_PROT_R	97
-#define AB8500_INT_MAIN_CH_TH_PROT_F	98
-#define AB8500_INT_MAIN_CH_TH_PROT_R	99
-#define AB8500_INT_USB_CHARGER_NOT_OKF	103
+#define AB8500_INT_ADP_SOURCE_ERROR	72
+#define AB8500_INT_ADP_SINK_ERROR	73
+#define AB8500_INT_ADP_PROBE_PLUG	74
+#define AB8500_INT_ADP_PROBE_UNPLUG	75
+#define AB8500_INT_ADP_SENSE_OFF	76
+#define AB8500_INT_USB_PHY_POWER_ERR	78
+#define AB8500_INT_USB_LINK_STATUS	79
+#define AB8500_INT_BTEMP_LOW		80
+#define AB8500_INT_BTEMP_LOW_MEDIUM	81
+#define AB8500_INT_BTEMP_MEDIUM_HIGH	82
+#define AB8500_INT_BTEMP_HIGH		83
+#define AB8500_INT_USB_CHARGER_NOT_OK	89
+#define AB8500_INT_ID_WAKEUP_R		90
+#define AB8500_INT_ID_DET_R1R		92
+#define AB8500_INT_ID_DET_R2R		93
+#define AB8500_INT_ID_DET_R3R		94
+#define AB8500_INT_ID_DET_R4R		95
+#define AB8500_INT_ID_WAKEUP_F		96
+#define AB8500_INT_ID_DET_R1F		98
+#define AB8500_INT_ID_DET_R2F		99
+#define AB8500_INT_ID_DET_R3F		100
+#define AB8500_INT_ID_DET_R4F		101
+#define AB8500_INT_USB_CHG_DET_DONE	102
+#define AB8500_INT_USB_CH_TH_PROT_F	104
+#define AB8500_INT_USB_CH_TH_PROT_R    105
+#define AB8500_INT_MAIN_CH_TH_PROT_F   106
+#define AB8500_INT_MAIN_CH_TH_PROT_R	107
+#define AB8500_INT_USB_CHARGER_NOT_OKF	111
 
-#define AB8500_NR_IRQS			104
-#define AB8500_NUM_IRQ_REGS		13
+#define AB8500_NR_IRQS			112
+#define AB8500_NUM_IRQ_REGS		14
 
 #define AB8500_NUM_REGULATORS   15
 
-- 
1.7.2.2

