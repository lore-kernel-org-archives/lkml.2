Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab0KZMEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 07:04:21 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:59489 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753126Ab0KZMEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 07:04:20 -0500
From: Mattias Wallin <mattias.wallin@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Subject: [PATCH] MFD: ab8500 chip version 2
Date: Fri, 26 Nov 2010 13:04:03 +0100
Message-ID: <1290773043-8985-1-git-send-email-mattias.wallin@stericsson.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for chip version 2.0.
One new event latch register is added to v2 - Latch12.
Due to hardware problems reading this address on earlier
versions it is treated seperately.
This patch also adds platform IORESOURCE irq to various
subdrivers to make way for their mainlining.
Removing nested interrupts to allow them to be shared
is also added.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
---
 drivers/mfd/ab8500-core.c  |  286 +++++++++++++++++++++++++++++++++++++++-----
 include/linux/mfd/ab8500.h |   23 ++--
 2 files changed, 271 insertions(+), 38 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index dbe1c93..e64569e 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -4,14 +4,13 @@
  * License Terms: GNU General Public License v2
  * Author: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
  * Author: Rabin Vincent <rabin.vincent@stericsson.com>
- * Changes: Mattias Wallin <mattias.wallin@stericsson.com>
+ * Author: Mattias Wallin <mattias.wallin@stericsson.com>
  */
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/irq.h>
-#include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
@@ -52,6 +51,7 @@
 #define AB8500_IT_LATCH8_REG		0x27
 #define AB8500_IT_LATCH9_REG		0x28
 #define AB8500_IT_LATCH10_REG		0x29
+#define AB8500_IT_LATCH12_REG		0x2B
 #define AB8500_IT_LATCH19_REG		0x32
 #define AB8500_IT_LATCH20_REG		0x33
 #define AB8500_IT_LATCH21_REG		0x34
@@ -73,20 +73,11 @@
 #define AB8500_IT_MASK8_REG		0x47
 #define AB8500_IT_MASK9_REG		0x48
 #define AB8500_IT_MASK10_REG		0x49
-#define AB8500_IT_MASK11_REG		0x4A
 #define AB8500_IT_MASK12_REG		0x4B
-#define AB8500_IT_MASK13_REG		0x4C
-#define AB8500_IT_MASK14_REG		0x4D
-#define AB8500_IT_MASK15_REG		0x4E
-#define AB8500_IT_MASK16_REG		0x4F
-#define AB8500_IT_MASK17_REG		0x50
-#define AB8500_IT_MASK18_REG		0x51
 #define AB8500_IT_MASK19_REG		0x52
 #define AB8500_IT_MASK20_REG		0x53
 #define AB8500_IT_MASK21_REG		0x54
 #define AB8500_IT_MASK22_REG		0x55
-#define AB8500_IT_MASK23_REG		0x56
-#define AB8500_IT_MASK24_REG		0x57
 
 #define AB8500_REV_REG			0x80
 
@@ -103,7 +94,10 @@ static const int ab8500_irq_regoffset[AB8500_NUM_IRQ_REGS] = {
 
 static int ab8500_get_chip_id(struct device *dev)
 {
-	struct ab8500 *ab8500 = dev_get_drvdata(dev->parent);
+	struct ab8500 *ab8500;
+	if (!dev)
+		return -EINVAL;
+	ab8500 = dev_get_drvdata(dev->parent);
 	return (int)ab8500->chip_id;
 }
 
@@ -253,6 +247,17 @@ static void ab8500_irq_sync_unlock(unsigned int irq)
 		reg = AB8500_IT_MASK1_REG + ab8500_irq_regoffset[i];
 		set_register_interruptible(ab8500, AB8500_INTERRUPT, reg, new);
 	}
+	/* MASK register 12 exist only in v2 */
+	if (ab8500->chip_id >= 0x20) {
+		u8 old = ab8500->oldmask[AB8500_NUM_IRQ_REGS];
+		u8 new = ab8500->mask[AB8500_NUM_IRQ_REGS];
+
+		if (new != old) {
+			ab8500->oldmask[AB8500_NUM_IRQ_REGS] = new;
+			set_register_interruptible(ab8500, AB8500_INTERRUPT,
+				AB8500_IT_MASK12_REG, new);
+		}
+	}
 
 	mutex_unlock(&ab8500->irq_lock);
 }
@@ -303,13 +308,33 @@ static irqreturn_t ab8500_irq(int irq, void *dev)
 			continue;
 
 		do {
-			int bit = __ffs(status);
+			int bit = __ffs(value);
 			int line = i * 8 + bit;
 
-			handle_nested_irq(ab8500->irq_base + line);
+			generic_handle_irq(ab8500->irq_base + line);
 			value &= ~(1 << bit);
 		} while (value);
 	}
+	/* LATCH register 12 exist only in v2 */
+	if (ab8500->chip_id >= 0x20) {
+		int status;
+		u8 value;
+
+		status = get_register_interruptible(ab8500, AB8500_INTERRUPT,
+			AB8500_IT_LATCH12_REG, &value);
+		if (status < 0) {
+			dev_err(dev, "LATCH12 get reg failed\n");
+			return IRQ_HANDLED;
+		}
+		while (value) {
+			int bit = __ffs(value);
+			int line = AB8500_NUM_IRQ_REGS * 8 + bit;
+
+			generic_handle_irq(ab8500->irq_base + line);
+			value &= ~(1 << bit);
+
+		}
+	}
 
 	return IRQ_HANDLED;
 }
@@ -323,7 +348,6 @@ static int ab8500_irq_init(struct ab8500 *ab8500)
 		set_irq_chip_data(irq, ab8500);
 		set_irq_chip_and_handler(irq, &ab8500_irq_chip,
 					 handle_simple_irq);
-		set_irq_nested_thread(irq, 1);
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, IRQF_VALID);
 #else
@@ -393,13 +417,195 @@ static struct resource ab8500_poweronkey_db_resources[] = {
 	},
 };
 
+static struct resource ab8500_bm_resources[] = {
+	{
+		.name = "MAIN_EXT_CH_NOT_OK",
+		.start = AB8500_INT_MAIN_EXT_CH_NOT_OK,
+		.end = AB8500_INT_MAIN_EXT_CH_NOT_OK,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "BATT_OVV",
+		.start = AB8500_INT_BATT_OVV,
+		.end = AB8500_INT_BATT_OVV,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "MAIN_CH_UNPLUG_DET",
+		.start = AB8500_INT_MAIN_CH_UNPLUG_DET,
+		.end = AB8500_INT_MAIN_CH_UNPLUG_DET,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "MAIN_CHARGE_PLUG_DET",
+		.start = AB8500_INT_MAIN_CH_PLUG_DET,
+		.end = AB8500_INT_MAIN_CH_PLUG_DET,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "VBUS_DET_F",
+		.start = AB8500_INT_VBUS_DET_F,
+		.end = AB8500_INT_VBUS_DET_F,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "VBUS_DET_R",
+		.start = AB8500_INT_VBUS_DET_R,
+		.end = AB8500_INT_VBUS_DET_R,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "BAT_CTRL_INDB",
+		.start = AB8500_INT_BAT_CTRL_INDB,
+		.end = AB8500_INT_BAT_CTRL_INDB,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "CH_WD_EXP",
+		.start = AB8500_INT_CH_WD_EXP,
+		.end = AB8500_INT_CH_WD_EXP,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "VBUS_OVV",
+		.start = AB8500_INT_VBUS_OVV,
+		.end = AB8500_INT_VBUS_OVV,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "NCONV_ACCU",
+		.start = AB8500_INT_CCN_CONV_ACC,
+		.end = AB8500_INT_CCN_CONV_ACC,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "LOW_BAT_F",
+		.start = AB8500_INT_LOW_BAT_F,
+		.end = AB8500_INT_LOW_BAT_F,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "LOW_BAT_R",
+		.start = AB8500_INT_LOW_BAT_R,
+		.end = AB8500_INT_LOW_BAT_R,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "BTEMP_LOW",
+		.start = AB8500_INT_BTEMP_LOW,
+		.end = AB8500_INT_BTEMP_LOW,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "BTEMP_HIGH",
+		.start = AB8500_INT_BTEMP_HIGH,
+		.end = AB8500_INT_BTEMP_HIGH,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "USB_CHARGER_NOT_OKR",
+		.start = AB8500_INT_USB_CHARGER_NOT_OK,
+		.end = AB8500_INT_USB_CHARGER_NOT_OK,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "USB_CHARGE_DET_DONE",
+		.start = AB8500_INT_USB_CHG_DET_DONE,
+		.end = AB8500_INT_USB_CHG_DET_DONE,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "USB_CH_TH_PROT_R",
+		.start = AB8500_INT_USB_CH_TH_PROT_R,
+		.end = AB8500_INT_USB_CH_TH_PROT_R,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "MAIN_CH_TH_PROT_R",
+		.start = AB8500_INT_MAIN_CH_TH_PROT_R,
+		.end = AB8500_INT_MAIN_CH_TH_PROT_R,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "USB_CHARGER_NOT_OKF",
+		.start = AB8500_INT_USB_CHARGER_NOT_OKF,
+		.end = AB8500_INT_USB_CHARGER_NOT_OKF,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource ab8500_debug_resources[] = {
+	{
+		.name	= "IRQ_FIRST",
+		.start	= AB8500_INT_MAIN_EXT_CH_NOT_OK,
+		.end	= AB8500_INT_MAIN_EXT_CH_NOT_OK,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.name	= "IRQ_LAST",
+		.start	= AB8500_INT_USB_LINK_STATUS,
+		.end	= AB8500_INT_USB_LINK_STATUS,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct resource ab8500_usb_resources[] = {
+	{
+		.name = "ID_WAKEUP_R",
+		.start = AB8500_INT_ID_WAKEUP_R,
+		.end = AB8500_INT_ID_WAKEUP_R,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "ID_WAKEUP_F",
+		.start = AB8500_INT_ID_WAKEUP_F,
+		.end = AB8500_INT_ID_WAKEUP_F,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "VBUS_DET_F",
+		.start = AB8500_INT_VBUS_DET_F,
+		.end = AB8500_INT_VBUS_DET_F,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "VBUS_DET_R",
+		.start = AB8500_INT_VBUS_DET_R,
+		.end = AB8500_INT_VBUS_DET_R,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "USB_LINK_STATUS",
+		.start = AB8500_INT_USB_LINK_STATUS,
+		.end = AB8500_INT_USB_LINK_STATUS,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource ab8500_temp_resources[] = {
+	{
+		.name  = "AB8500_TEMP_WARM",
+		.start = AB8500_INT_TEMP_WARM,
+		.end   = AB8500_INT_TEMP_WARM,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
 static struct mfd_cell ab8500_devs[] = {
 #ifdef CONFIG_DEBUG_FS
 	{
 		.name = "ab8500-debug",
+		.num_resources = ARRAY_SIZE(ab8500_debug_resources),
+		.resources = ab8500_debug_resources,
 	},
 #endif
 	{
+		.name = "ab8500-sysctrl",
+	},
+	{
+		.name = "ab8500-regulator",
+	},
+	{
 		.name = "ab8500-gpadc",
 		.num_resources = ARRAY_SIZE(ab8500_gpadc_resources),
 		.resources = ab8500_gpadc_resources,
@@ -410,6 +616,22 @@ static struct mfd_cell ab8500_devs[] = {
 		.resources = ab8500_rtc_resources,
 	},
 	{
+		.name = "ab8500-bm",
+		.num_resources = ARRAY_SIZE(ab8500_bm_resources),
+		.resources = ab8500_bm_resources,
+	},
+	{ .name = "ab8500-codec", },
+	{
+		.name = "ab8500-usb",
+		.num_resources = ARRAY_SIZE(ab8500_usb_resources),
+		.resources = ab8500_usb_resources,
+	},
+	{
+		.name = "ab8500-poweron-key",
+		.num_resources = ARRAY_SIZE(ab8500_poweronkey_db_resources),
+		.resources = ab8500_poweronkey_db_resources,
+	},
+	{
 		.name = "ab8500-pwm",
 		.id = 1,
 	},
@@ -421,14 +643,14 @@ static struct mfd_cell ab8500_devs[] = {
 		.name = "ab8500-pwm",
 		.id = 3,
 	},
-	{ .name = "ab8500-charger", },
-	{ .name = "ab8500-audio", },
-	{ .name = "ab8500-usb", },
-	{ .name = "ab8500-regulator", },
+	{ .name = "ab8500-leds", },
 	{
-		.name = "ab8500-poweron-key",
-		.num_resources = ARRAY_SIZE(ab8500_poweronkey_db_resources),
-		.resources = ab8500_poweronkey_db_resources,
+		.name = "ab8500-denc",
+	},
+	{
+		.name = "ab8500-temp",
+		.num_resources = ARRAY_SIZE(ab8500_temp_resources),
+		.resources = ab8500_temp_resources,
 	},
 };
 
@@ -455,8 +677,7 @@ int __devinit ab8500_init(struct ab8500 *ab8500)
 	 * 0x10 - Cut 1.0
 	 * 0x11 - Cut 1.1
 	 */
-	if (value == 0x0 || value == 0x10 || value == 0x11) {
-		ab8500->revision = value;
+	if (value == 0x0 || value == 0x10 || value == 0x11 || value == 0x20) {
 		dev_info(ab8500->dev, "detected chip, revision: %#x\n", value);
 	} else {
 		dev_err(ab8500->dev, "unknown chip, revision: %#x\n", value);
@@ -474,8 +695,13 @@ int __devinit ab8500_init(struct ab8500 *ab8500)
 		set_register_interruptible(ab8500, AB8500_INTERRUPT,
 			AB8500_IT_MASK1_REG + i, 0xff);
 	}
-
-	for (i = 18; i < 24; i++) {
+	if (ab8500->chip_id >= 0x20) {
+		get_register_interruptible(ab8500, AB8500_INTERRUPT,
+			AB8500_IT_LATCH12_REG, &value);
+		set_register_interruptible(ab8500, AB8500_INTERRUPT,
+			AB8500_IT_MASK12_REG, 0xff);
+	}
+	for (i = 18; i < 22; i++) {
 		get_register_interruptible(ab8500, AB8500_INTERRUPT,
 			AB8500_IT_LATCH1_REG + i, &value);
 		set_register_interruptible(ab8500, AB8500_INTERRUPT,
@@ -486,7 +712,8 @@ int __devinit ab8500_init(struct ab8500 *ab8500)
 	if (ret)
 		return ret;
 
-	for (i = 0; i < AB8500_NUM_IRQ_REGS; i++)
+	/* Last element is MASK12 */
+	for (i = 0; i < AB8500_NUM_IRQ_REGS + 1; i++)
 		ab8500->mask[i] = ab8500->oldmask[i] = 0xff;
 
 	if (ab8500->irq_base) {
@@ -495,7 +722,8 @@ int __devinit ab8500_init(struct ab8500 *ab8500)
 			return ret;
 
 		ret = request_threaded_irq(ab8500->irq, NULL, ab8500_irq,
-					   IRQF_ONESHOT, "ab8500", ab8500);
+					   IRQF_ONESHOT | IRQF_NO_SUSPEND,
+					   "ab8500", ab8500);
 		if (ret)
 			goto out_removeirq;
 	}
@@ -528,6 +756,6 @@ int __devexit ab8500_exit(struct ab8500 *ab8500)
 	return 0;
 }
 
-MODULE_AUTHOR("Srinidhi Kasagar, Rabin Vincent");
+MODULE_AUTHOR("Srinidhi Kasagar, Rabin Vincent, Mattias Wallin");
 MODULE_DESCRIPTION("AB8500 MFD core");
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/mfd/ab8500.h b/include/linux/mfd/ab8500.h
index d63b605..fc92391 100644
--- a/include/linux/mfd/ab8500.h
+++ b/include/linux/mfd/ab8500.h
@@ -91,23 +91,29 @@
 #define AB8500_INT_ID_DET_R4F		93
 #define AB8500_INT_USB_CHG_DET_DONE	94
 #define AB8500_INT_USB_CH_TH_PROT_F	96
-#define AB8500_INT_USB_CH_TH_PROP_R	97
-#define AB8500_INT_MAIN_CH_TH_PROP_F	98
+#define AB8500_INT_USB_CH_TH_PROT_R    97
+#define AB8500_INT_MAIN_CH_TH_PROT_F   98
 #define AB8500_INT_MAIN_CH_TH_PROT_R	99
 #define AB8500_INT_USB_CHARGER_NOT_OKF	103
+#define AB8500_INT_ADP_SOURCE_ERROR	104
+#define AB8500_INT_ADP_SINK_ERROR	105
+#define AB8500_INT_ADP_PROBE_PLUG	106
+#define AB8500_INT_ADP_PROBE_UNPLUG	107
+#define AB8500_INT_ADP_SENSE_OFF	108
+#define AB8500_INT_USB_LINK_STATUS	111
 
-#define AB8500_NR_IRQS			104
+#define AB8500_NR_IRQS			112
 #define AB8500_NUM_IRQ_REGS		13
 
-#define AB8500_NUM_REGULATORS   15
+#define AB8500_NUM_REGULATORS		15
 
 /**
  * struct ab8500 - ab8500 internal structure
  * @dev: parent device
  * @lock: read/write operations lock
  * @irq_lock: genirq bus lock
- * @revision: chip revision
  * @irq: irq line
+ * @chip_id: chip revision id
  * @write: register write
  * @read: register read
  * @rx_buf: rx buf for SPI
@@ -119,7 +125,6 @@ struct ab8500 {
 	struct device	*dev;
 	struct mutex	lock;
 	struct mutex	irq_lock;
-	int		revision;
 	int		irq_base;
 	int		irq;
 	u8		chip_id;
@@ -130,8 +135,9 @@ struct ab8500 {
 	unsigned long	tx_buf[4];
 	unsigned long	rx_buf[4];
 
-	u8 mask[AB8500_NUM_IRQ_REGS];
-	u8 oldmask[AB8500_NUM_IRQ_REGS];
+	/* MASK12 exists only in v2 so last element dedicated for MASK12 */
+	u8 mask[AB8500_NUM_IRQ_REGS + 1];
+	u8 oldmask[AB8500_NUM_IRQ_REGS + 1];
 };
 
 struct regulator_init_data;
@@ -150,5 +156,4 @@ struct ab8500_platform_data {
 
 extern int __devinit ab8500_init(struct ab8500 *ab8500);
 extern int __devexit ab8500_exit(struct ab8500 *ab8500);
-
 #endif /* MFD_AB8500_H */
-- 
1.7.2.2

