Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705Ab2CHNCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 08:02:25 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:40481 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757122Ab2CHNCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 08:02:12 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/4] mfd/ab8500: support the AB8505 variant
Date: Thu, 8 Mar 2012 14:01:57 +0100
Message-ID: <1331211717-9799-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>

This builds upon the changes done to support AB9540 so as
also to support the AB8505 derivative of the AB8500
circuit.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-core.c         |   32 ++++++------
 include/linux/mfd/abx500/ab8500.h |   99 +++++++++++++++++++++----------------
 2 files changed, 72 insertions(+), 59 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index f134a6c..c637c8d 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -360,6 +360,8 @@ static int ab8500_irq_init(struct ab8500 *ab8500)
 
 	if (is_ab9540(ab8500))
 		num_irqs = AB9540_NR_IRQS;
+	else if (is_ab8505(ab8500))
+		num_irqs = AB8505_NR_IRQS;
 	else
 		num_irqs = AB8500_NR_IRQS;
 
@@ -386,6 +388,8 @@ static void ab8500_irq_remove(struct ab8500 *ab8500)
 
 	if (is_ab9540(ab8500))
 		num_irqs = AB9540_NR_IRQS;
+	else if (is_ab8505(ab8500))
+		num_irqs = AB8505_NR_IRQS;
 	else
 		num_irqs = AB8500_NR_IRQS;
 
@@ -546,12 +550,6 @@ static struct resource __devinitdata ab8500_charger_resources[] = {
 		.flags = IORESOURCE_IRQ,
 	},
 	{
-		.name = "USB_CHARGE_DET_DONE",
-		.start = AB8500_INT_USB_CHG_DET_DONE,
-		.end = AB8500_INT_USB_CHG_DET_DONE,
-		.flags = IORESOURCE_IRQ,
-	},
-	{
 		.name = "VBUS_OVV",
 		.start = AB8500_INT_VBUS_OVV,
 		.end = AB8500_INT_VBUS_OVV,
@@ -589,14 +587,8 @@ static struct resource __devinitdata ab8500_charger_resources[] = {
 	},
 	{
 		.name = "USB_CHARGER_NOT_OKR",
-		.start = AB8500_INT_USB_CHARGER_NOT_OK,
-		.end = AB8500_INT_USB_CHARGER_NOT_OK,
-		.flags = IORESOURCE_IRQ,
-	},
-	{
-		.name = "USB_CHARGER_NOT_OKF",
-		.start = AB8500_INT_USB_CHARGER_NOT_OKF,
-		.end = AB8500_INT_USB_CHARGER_NOT_OKF,
+		.start = AB8500_INT_USB_CHARGER_NOT_OKR,
+		.end = AB8500_INT_USB_CHARGER_NOT_OKR,
 		.flags = IORESOURCE_IRQ,
 	},
 	{
@@ -671,6 +663,12 @@ static struct resource __devinitdata ab8500_fg_resources[] = {
 		.end = AB8500_INT_CC_INT_CALIB,
 		.flags = IORESOURCE_IRQ,
 	},
+	{
+		.name = "CCEOC",
+		.start = AB8500_INT_CCEOC,
+		.end = AB8500_INT_CCEOC,
+		.flags = IORESOURCE_IRQ,
+	},
 };
 
 static struct resource __devinitdata ab8500_chargalg_resources[] = {};
@@ -685,8 +683,8 @@ static struct resource __devinitdata ab8500_debug_resources[] = {
 	},
 	{
 		.name	= "IRQ_LAST",
-		.start	= AB8500_INT_USB_CHARGER_NOT_OKF,
-		.end	= AB8500_INT_USB_CHARGER_NOT_OKF,
+		.start	= AB8500_INT_XTAL32K_KO,
+		.end	= AB8500_INT_XTAL32K_KO,
 		.flags	= IORESOURCE_IRQ,
 	},
 };
@@ -1033,7 +1031,7 @@ int __devinit ab8500_init(struct ab8500 *ab8500, enum ab8500_version version)
 			ab8500->chip_id & 0x0F);
 
 	/* Configure AB8500 or AB9540 IRQ */
-	if (is_ab9540(ab8500)) {
+	if (is_ab9540(ab8500) || is_ab8505(ab8500)) {
 		ab8500->mask_size = AB9540_NUM_IRQ_REGS;
 		ab8500->irq_reg_offset = ab9540_irq_regoffset;
 	} else {
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index 4b2df29..78ed95b 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -62,9 +62,9 @@ enum ab8500_version {
  */
 /* Definitions for AB8500 and AB9540 */
 /* ab8500_irq_regoffset[0] -> IT[Source|Latch|Mask]1 */
-#define AB8500_INT_MAIN_EXT_CH_NOT_OK	0
-#define AB8500_INT_UN_PLUG_TV_DET	1
-#define AB8500_INT_PLUG_TV_DET		2
+#define AB8500_INT_MAIN_EXT_CH_NOT_OK	0 /* not 8505/9540 */
+#define AB8500_INT_UN_PLUG_TV_DET	1 /* not 8505/9540 */
+#define AB8500_INT_PLUG_TV_DET		2 /* not 8505/9540 */
 #define AB8500_INT_TEMP_WARM		3
 #define AB8500_INT_PON_KEY2DB_F		4
 #define AB8500_INT_PON_KEY2DB_R		5
@@ -72,10 +72,8 @@ enum ab8500_version {
 #define AB8500_INT_PON_KEY1DB_R		7
 /* ab8500_irq_regoffset[1] -> IT[Source|Latch|Mask]2 */
 #define AB8500_INT_BATT_OVV		8
-#define AB8500_INT_MAIN_CH_UNPLUG_DET	10
-#define AB8500_INT_MAIN_CH_PLUG_DET	11
-#define AB8500_INT_USB_ID_DET_F		12
-#define AB8500_INT_USB_ID_DET_R		13
+#define AB8500_INT_MAIN_CH_UNPLUG_DET	10 /* not 8505 */
+#define AB8500_INT_MAIN_CH_PLUG_DET	11 /* not 8505 */
 #define AB8500_INT_VBUS_DET_F		14
 #define AB8500_INT_VBUS_DET_R		15
 /* ab8500_irq_regoffset[2] -> IT[Source|Latch|Mask]3 */
@@ -85,7 +83,7 @@ enum ab8500_version {
 #define AB8500_INT_BAT_CTRL_INDB	20
 #define AB8500_INT_CH_WD_EXP		21
 #define AB8500_INT_VBUS_OVV		22
-#define AB8500_INT_MAIN_CH_DROP_END	23
+#define AB8500_INT_MAIN_CH_DROP_END	23 /* not 8505/9540 */
 /* ab8500_irq_regoffset[3] -> IT[Source|Latch|Mask]4 */
 #define AB8500_INT_CCN_CONV_ACC		24
 #define AB8500_INT_INT_AUD		25
@@ -96,7 +94,7 @@ enum ab8500_version {
 #define AB8500_INT_BUP_CHG_NOT_OK	30
 #define AB8500_INT_BUP_CHG_OK		31
 /* ab8500_irq_regoffset[4] -> IT[Source|Latch|Mask]5 */
-#define AB8500_INT_GP_HW_ADC_CONV_END	32
+#define AB8500_INT_GP_HW_ADC_CONV_END	32 /* not 8505 */
 #define AB8500_INT_ACC_DETECT_1DB_F	33
 #define AB8500_INT_ACC_DETECT_1DB_R	34
 #define AB8500_INT_ACC_DETECT_22DB_F	35
@@ -105,39 +103,39 @@ enum ab8500_version {
 #define AB8500_INT_ACC_DETECT_21DB_R	38
 #define AB8500_INT_GP_SW_ADC_CONV_END	39
 /* ab8500_irq_regoffset[5] -> IT[Source|Latch|Mask]7 */
-#define AB8500_INT_GPIO6R		40
-#define AB8500_INT_GPIO7R		41
-#define AB8500_INT_GPIO8R		42
-#define AB8500_INT_GPIO9R		43
+#define AB8500_INT_GPIO6R		40 /* not 8505/9540 */
+#define AB8500_INT_GPIO7R		41 /* not 8505/9540 */
+#define AB8500_INT_GPIO8R		42 /* not 8505/9540 */
+#define AB8500_INT_GPIO9R		43 /* not 8505/9540 */
 #define AB8500_INT_GPIO10R		44
 #define AB8500_INT_GPIO11R		45
-#define AB8500_INT_GPIO12R		46
+#define AB8500_INT_GPIO12R		46 /* not 8505 */
 #define AB8500_INT_GPIO13R		47
 /* ab8500_irq_regoffset[6] -> IT[Source|Latch|Mask]8 */
-#define AB8500_INT_GPIO24R		48
-#define AB8500_INT_GPIO25R		49
-#define AB8500_INT_GPIO36R		50
-#define AB8500_INT_GPIO37R		51
-#define AB8500_INT_GPIO38R		52
-#define AB8500_INT_GPIO39R		53
+#define AB8500_INT_GPIO24R		48 /* not 8505 */
+#define AB8500_INT_GPIO25R		49 /* not 8505 */
+#define AB8500_INT_GPIO36R		50 /* not 8505/9540 */
+#define AB8500_INT_GPIO37R		51 /* not 8505/9540 */
+#define AB8500_INT_GPIO38R		52 /* not 8505/9540 */
+#define AB8500_INT_GPIO39R		53 /* not 8505/9540 */
 #define AB8500_INT_GPIO40R		54
 #define AB8500_INT_GPIO41R		55
 /* ab8500_irq_regoffset[7] -> IT[Source|Latch|Mask]9 */
-#define AB8500_INT_GPIO6F		56
-#define AB8500_INT_GPIO7F		57
-#define AB8500_INT_GPIO8F		58
-#define AB8500_INT_GPIO9F		59
+#define AB8500_INT_GPIO6F		56 /* not 8505/9540 */
+#define AB8500_INT_GPIO7F		57 /* not 8505/9540 */
+#define AB8500_INT_GPIO8F		58 /* not 8505/9540 */
+#define AB8500_INT_GPIO9F		59 /* not 8505/9540 */
 #define AB8500_INT_GPIO10F		60
 #define AB8500_INT_GPIO11F		61
-#define AB8500_INT_GPIO12F		62
+#define AB8500_INT_GPIO12F		62 /* not 8505 */
 #define AB8500_INT_GPIO13F		63
 /* ab8500_irq_regoffset[8] -> IT[Source|Latch|Mask]10 */
-#define AB8500_INT_GPIO24F		64
-#define AB8500_INT_GPIO25F		65
-#define AB8500_INT_GPIO36F		66
-#define AB8500_INT_GPIO37F		67
-#define AB8500_INT_GPIO38F		68
-#define AB8500_INT_GPIO39F		69
+#define AB8500_INT_GPIO24F		64 /* not 8505 */
+#define AB8500_INT_GPIO25F		65 /* not 8505 */
+#define AB8500_INT_GPIO36F		66 /* not 8505/9540 */
+#define AB8500_INT_GPIO37F		67 /* not 8505/9540 */
+#define AB8500_INT_GPIO38F		68 /* not 8505/9540 */
+#define AB8500_INT_GPIO39F		69 /* not 8505/9540 */
 #define AB8500_INT_GPIO40F		70
 #define AB8500_INT_GPIO41F		71
 /* ab8500_irq_regoffset[9] -> IT[Source|Latch|Mask]12 */
@@ -154,7 +152,8 @@ enum ab8500_version {
 #define AB8500_INT_BTEMP_MEDIUM_HIGH	82
 #define AB8500_INT_BTEMP_HIGH		83
 /* ab8500_irq_regoffset[11] -> IT[Source|Latch|Mask]20 */
-#define AB8500_INT_USB_CHARGER_NOT_OK	89
+#define AB8500_INT_SRP_DETECT		88
+#define AB8500_INT_USB_CHARGER_NOT_OKR	89
 #define AB8500_INT_ID_WAKEUP_R		90
 #define AB8500_INT_ID_DET_R1R		92
 #define AB8500_INT_ID_DET_R2R		93
@@ -166,29 +165,32 @@ enum ab8500_version {
 #define AB8500_INT_ID_DET_R2F		99
 #define AB8500_INT_ID_DET_R3F		100
 #define AB8500_INT_ID_DET_R4F		101
-#define AB8500_INT_USB_CHG_DET_DONE	102
+#define AB8500_INT_CHAUTORESTARTAFTSEC  102
+#define AB8500_INT_CHSTOPBYSEC		103
 /* ab8500_irq_regoffset[13] -> IT[Source|Latch|Mask]22 */
 #define AB8500_INT_USB_CH_TH_PROT_F	104
 #define AB8500_INT_USB_CH_TH_PROT_R    105
-#define AB8500_INT_MAIN_CH_TH_PROT_F   106
-#define AB8500_INT_MAIN_CH_TH_PROT_R	107
-#define AB8500_INT_USB_CHARGER_NOT_OKF	111
+#define AB8500_INT_MAIN_CH_TH_PROT_F	106 /* not 8505/9540 */
+#define AB8500_INT_MAIN_CH_TH_PROT_R	107 /* not 8505/9540 */
+#define AB8500_INT_CHCURLIMNOHSCHIRP	109
+#define AB8500_INT_CHCURLIMHSCHIRP	110
+#define AB8500_INT_XTAL32K_KO		111
 
 /* Definitions for AB9540 */
 /* ab8500_irq_regoffset[14] -> IT[Source|Latch|Mask]13 */
 #define AB9540_INT_GPIO50R		113
-#define AB9540_INT_GPIO51R		114
+#define AB9540_INT_GPIO51R		114 /* not 8505 */
 #define AB9540_INT_GPIO52R		115
 #define AB9540_INT_GPIO53R		116
-#define AB9540_INT_GPIO54R		117
+#define AB9540_INT_GPIO54R		117 /* not 8505 */
 #define AB9540_INT_IEXT_CH_RF_BFN_R	118
 #define AB9540_INT_IEXT_CH_RF_BFN_F	119
 /* ab8500_irq_regoffset[15] -> IT[Source|Latch|Mask]14 */
 #define AB9540_INT_GPIO50F		121
-#define AB9540_INT_GPIO51F		122
+#define AB9540_INT_GPIO51F		122 /* not 8505 */
 #define AB9540_INT_GPIO52F		123
 #define AB9540_INT_GPIO53F		124
-#define AB9540_INT_GPIO54F		125
+#define AB9540_INT_GPIO54F		125 /* not 8505 */
 
 /*
  * AB8500_AB9540_NR_IRQS is used when configuring the IRQ numbers for the
@@ -198,6 +200,7 @@ enum ab8500_version {
  * which is larger.
  */
 #define AB8500_NR_IRQS			112
+#define AB8505_NR_IRQS			128
 #define AB9540_NR_IRQS			128
 /* This is set to the roof of any AB8500 chip variant IRQ counts */
 #define AB8500_MAX_NR_IRQS		AB9540_NR_IRQS
@@ -292,16 +295,28 @@ static inline int is_ab8540(struct ab8500 *ab)
 	return ab->version == AB8500_VERSION_AB8540;
 }
 
-/* include also ab8505, ab9540... */
+/* exclude also ab8505, ab9540... */
+static inline int is_ab8500_1p0_or_earlier(struct ab8500 *ab)
+{
+	return (is_ab8500(ab) && (ab->chip_id <= AB8500_CUT1P0));
+}
+
+/* exclude also ab8505, ab9540... */
 static inline int is_ab8500_1p1_or_earlier(struct ab8500 *ab)
 {
 	return (is_ab8500(ab) && (ab->chip_id <= AB8500_CUT1P1));
 }
 
-/* include also ab8505, ab9540... */
+/* exclude also ab8505, ab9540... */
 static inline int is_ab8500_2p0_or_earlier(struct ab8500 *ab)
 {
 	return (is_ab8500(ab) && (ab->chip_id <= AB8500_CUT2P0));
 }
 
+/* exclude also ab8505, ab9540... */
+static inline int is_ab8500_2p0(struct ab8500 *ab)
+{
+	return (is_ab8500(ab) && (ab->chip_id == AB8500_CUT2P0));
+}
+
 #endif /* MFD_AB8500_H */
-- 
1.7.8

