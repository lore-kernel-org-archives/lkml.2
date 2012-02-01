Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab2BAQJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 11:09:34 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:51467 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756659Ab2BAQJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 11:09:30 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Maxime Coquelin <maxime.coquelin@stericsson.com>,
        Alex Macro <alex.macro@stericsson.com>,
        Michel Jaouen <michel.jaouen@stericsson.com>
Subject: [PATCH 2/4] mfd/ab8500: add version detection and enforcing
Date: Wed, 1 Feb 2012 17:09:21 +0100
Message-ID: <1328112561-32494-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

There are currently four different versions of the AB8500
around: AB8500, AB8505, AB9540 and AB8540. Unfortunately:

- Some of the chips (AB8500, AB8505, AB9540) cannot read
  the AB8500_REV_REG register but return errors

- Some of them have the same ID value in the hardware
  register AB8500_REV_REV, for example the first versions
  of AB8505 and AB9540 have 0xFF in this register -
  just like the AB8500.

So we need to be able to enforce a certain version from
the platform. We do this by using the id of the platform
device that provides the read/write functions.

Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Maxime Coquelin <maxime.coquelin@stericsson.com>
Signed-off-by: Alex Macro <alex.macro@stericsson.com>
Signed-off-by: Michel Jaouen <michel.jaouen@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c |    1 -
 drivers/mfd/ab8500-core.c          |   63 ++++++++++++++++++++++++------------
 drivers/mfd/ab8500-i2c.c           |   15 +++++++-
 include/linux/mfd/abx500.h         |    7 ----
 include/linux/mfd/abx500/ab8500.h  |   59 +++++++++++++++++++++++++++++++++-
 5 files changed, 113 insertions(+), 32 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 5c00712..c3fb904 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -512,7 +512,6 @@ static struct stedma40_chan_cfg uart2_dma_cfg_tx = {
 };
 #endif
 
-
 static pin_cfg_t mop500_pins_uart0[] = {
 	GPIO0_U0_CTSn   | PIN_INPUT_PULLUP,
 	GPIO1_U0_RTSn   | PIN_OUTPUT_HIGH,
diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index bf823d2..f768bb8 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -90,6 +90,7 @@
 #define AB8500_IT_MASK24_REG		0x57
 
 #define AB8500_REV_REG			0x80
+#define AB8500_IC_NAME_REG		0x82
 #define AB8500_SWITCH_OFF_STATUS	0x00
 
 #define AB8500_TURN_ON_STATUS		0x00
@@ -105,6 +106,13 @@ static const int ab8500_irq_regoffset[AB8500_NUM_IRQ_REGS] = {
 	0, 1, 2, 3, 4, 6, 7, 8, 9, 11, 18, 19, 20, 21,
 };
 
+static const char ab8500_version_str[][7] = {
+	[AB8500_VERSION_AB8500] = "AB8500",
+	[AB8500_VERSION_AB8505] = "AB8505",
+	[AB8500_VERSION_AB9540] = "AB9540",
+	[AB8500_VERSION_AB8540] = "AB8540",
+};
+
 static int ab8500_get_chip_id(struct device *dev)
 {
 	struct ab8500 *ab8500;
@@ -256,9 +264,12 @@ static void ab8500_irq_sync_unlock(struct irq_data *data)
 		if (new == old)
 			continue;
 
-		/* Interrupt register 12 doesn't exist prior to version 2.0 */
-		if (ab8500_irq_regoffset[i] == 11 &&
-			ab8500->chip_id < AB8500_CUT2P0)
+		/*
+		 * Interrupt register 12 doesn't exist prior to AB8500 version
+		 * 2.0
+		 */
+		if (ab8500->irq_reg_offset[i] == 11 &&
+			is_ab8500_1p1_or_earlier(ab8500))
 			continue;
 
 		ab8500->oldmask[i] = new;
@@ -311,8 +322,11 @@ static irqreturn_t ab8500_irq(int irq, void *dev)
 		int status;
 		u8 value;
 
-		/* Interrupt register 12 doesn't exist prior to version 2.0 */
-		if (regoffset == 11 && ab8500->chip_id < AB8500_CUT2P0)
+		/*
+		 * Interrupt register 12 doesn't exist prior to AB8500 version
+		 * 2.0
+		 */
+		if (regoffset == 11 && is_ab8500_1p1_or_earlier(ab8500))
 			continue;
 
 		status = get_register_interruptible(ab8500, AB8500_INTERRUPT,
@@ -857,7 +871,7 @@ static struct attribute_group ab8500_attr_group = {
 	.attrs	= ab8500_sysfs_entries,
 };
 
-int __devinit ab8500_init(struct ab8500 *ab8500)
+int __devinit ab8500_init(struct ab8500 *ab8500, enum ab8500_version version)
 {
 	struct ab8500_platform_data *plat = dev_get_platdata(ab8500->dev);
 	int ret;
@@ -870,25 +884,29 @@ int __devinit ab8500_init(struct ab8500 *ab8500)
 	mutex_init(&ab8500->lock);
 	mutex_init(&ab8500->irq_lock);
 
+	if (version != AB8500_VERSION_UNDEFINED)
+		ab8500->version = version;
+	else {
+		ret = get_register_interruptible(ab8500, AB8500_MISC,
+			AB8500_IC_NAME_REG, &value);
+		if (ret < 0)
+			return ret;
+
+		ab8500->version = value;
+	}
+
 	ret = get_register_interruptible(ab8500, AB8500_MISC,
 		AB8500_REV_REG, &value);
 	if (ret < 0)
 		return ret;
 
-	switch (value) {
-	case AB8500_CUT1P0:
-	case AB8500_CUT1P1:
-	case AB8500_CUT2P0:
-	case AB8500_CUT3P0:
-	case AB8500_CUT3P3:
-		dev_info(ab8500->dev, "detected chip, revision: %#x\n", value);
-		break;
-	default:
-		dev_err(ab8500->dev, "unknown chip, revision: %#x\n", value);
-		return -EINVAL;
-	}
 	ab8500->chip_id = value;
 
+	dev_info(ab8500->dev, "detected chip, %s rev. %1x.%1x\n",
+			ab8500_version_str[ab8500->version],
+			ab8500->chip_id >> 4,
+			ab8500->chip_id & 0x0F);
+
 	/*
 	 * ab8500 has switched off due to (SWITCH_OFF_STATUS):
 	 * 0x01 Swoff bit programming
@@ -912,9 +930,12 @@ int __devinit ab8500_init(struct ab8500 *ab8500)
 
 	/* Clear and mask all interrupts */
 	for (i = 0; i < AB8500_NUM_IRQ_REGS; i++) {
-		/* Interrupt register 12 doesn't exist prior to version 2.0 */
-		if (ab8500_irq_regoffset[i] == 11 &&
-			ab8500->chip_id < AB8500_CUT2P0)
+		/*
+		 * Interrupt register 12 doesn't exist prior to AB8500 version
+		 * 2.0
+		 */
+		if (ab8500->irq_reg_offset[i] == 11 &&
+				is_ab8500_1p1_or_earlier(ab8500))
 			continue;
 
 		get_register_interruptible(ab8500, AB8500_INTERRUPT,
diff --git a/drivers/mfd/ab8500-i2c.c b/drivers/mfd/ab8500-i2c.c
index 087fecd..70a16ae 100644
--- a/drivers/mfd/ab8500-i2c.c
+++ b/drivers/mfd/ab8500-i2c.c
@@ -38,6 +38,7 @@ static int ab8500_i2c_read(struct ab8500 *ab8500, u16 addr)
 
 static int __devinit ab8500_i2c_probe(struct platform_device *plf)
 {
+	const struct platform_device_id *platid = platform_get_device_id(plf);
 	struct ab8500 *ab8500;
 	struct resource *resource;
 	int ret;
@@ -61,10 +62,11 @@ static int __devinit ab8500_i2c_probe(struct platform_device *plf)
 
 	platform_set_drvdata(plf, ab8500);
 
-	ret = ab8500_init(ab8500);
+	ret = ab8500_init(ab8500, platid->driver_data);
 	if (ret)
 		kfree(ab8500);
 
+
 	return ret;
 }
 
@@ -78,13 +80,22 @@ static int __devexit ab8500_i2c_remove(struct platform_device *plf)
 	return 0;
 }
 
+static const struct platform_device_id ab8500_id[] = {
+	{ "ab8500-i2c", AB8500_VERSION_AB8500 },
+	{ "ab8505-i2c", AB8500_VERSION_AB8505 },
+	{ "ab9540-i2c", AB8500_VERSION_AB9540 },
+	{ "ab8540-i2c", AB8500_VERSION_AB8540 },
+	{ }
+};
+
 static struct platform_driver ab8500_i2c_driver = {
 	.driver = {
 		.name = "ab8500-i2c",
 		.owner = THIS_MODULE,
 	},
 	.probe	= ab8500_i2c_probe,
-	.remove	= __devexit_p(ab8500_i2c_remove)
+	.remove	= __devexit_p(ab8500_i2c_remove),
+	.id_table = ab8500_id,
 };
 
 static int __init ab8500_i2c_init(void)
diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index 9970337..1bfbb11 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -33,13 +33,6 @@
 #define AB5500_1_1	0x21
 #define AB5500_2_0	0x24
 
-/* AB8500 CIDs*/
-#define AB8500_CUT1P0	0x10
-#define AB8500_CUT1P1	0x11
-#define AB8500_CUT2P0	0x20
-#define AB8500_CUT3P0	0x30
-#define AB8500_CUT3P3	0x33
-
 /*
  * AB3100, EVENTA1, A2 and A3 event register flags
  * these are catenated into a single 32-bit flag in the code
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index 838c6b4..7989258 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -8,6 +8,28 @@
 #define MFD_AB8500_H
 
 #include <linux/device.h>
+/*
+ * AB IC versions
+ *
+ * AB8500_VERSION_AB8500 should be 0xFF but will never be read as need a
+ * non-supported multi-byte I2C access via PRCMU. Set to 0x00 to ease the
+ * print of version string.
+ */
+enum ab8500_version {
+	AB8500_VERSION_AB8500 = 0x0,
+	AB8500_VERSION_AB8505 = 0x1,
+	AB8500_VERSION_AB9540 = 0x2,
+	AB8500_VERSION_AB8540 = 0x3,
+	AB8500_VERSION_UNDEFINED,
+};
+
+/* AB8500 CIDs*/
+#define AB8500_CUTEARLY	0x00
+#define AB8500_CUT1P0	0x10
+#define AB8500_CUT1P1	0x11
+#define AB8500_CUT2P0	0x20
+#define AB8500_CUT3P0	0x30
+#define AB8500_CUT3P3	0x33
 
 /*
  * AB8500 bank addresses
@@ -145,6 +167,7 @@
  * @lock: read/write operations lock
  * @irq_lock: genirq bus lock
  * @irq: irq line
+ * @version: chip version id (e.g. ab8500 or ab9540)
  * @chip_id: chip revision id
  * @write: register write
  * @read: register read
@@ -160,6 +183,7 @@ struct ab8500 {
 
 	int		irq_base;
 	int		irq;
+	enum ab8500_version version;
 	u8		chip_id;
 
 	int (*write) (struct ab8500 *a8500, u16 addr, u8 data);
@@ -195,7 +219,40 @@ struct ab8500_platform_data {
 	struct ab8500_gpio_platform_data *gpio;
 };
 
-extern int __devinit ab8500_init(struct ab8500 *ab8500);
+extern int __devinit ab8500_init(struct ab8500 *ab8500,
+				 enum ab8500_version version);
 extern int __devexit ab8500_exit(struct ab8500 *ab8500);
 
+static inline int is_ab8500(struct ab8500 *ab)
+{
+	return ab->version == AB8500_VERSION_AB8500;
+}
+
+static inline int is_ab8505(struct ab8500 *ab)
+{
+	return ab->version == AB8500_VERSION_AB8505;
+}
+
+static inline int is_ab9540(struct ab8500 *ab)
+{
+	return ab->version == AB8500_VERSION_AB9540;
+}
+
+static inline int is_ab8540(struct ab8500 *ab)
+{
+	return ab->version == AB8500_VERSION_AB8540;
+}
+
+/* include also ab8505, ab9540... */
+static inline int is_ab8500_1p1_or_earlier(struct ab8500 *ab)
+{
+	return (is_ab8500(ab) && (ab->chip_id <= AB8500_CUT1P1));
+}
+
+/* include also ab8505, ab9540... */
+static inline int is_ab8500_2p0_or_earlier(struct ab8500 *ab)
+{
+	return (is_ab8500(ab) && (ab->chip_id <= AB8500_CUT2P0));
+}
+
 #endif /* MFD_AB8500_H */
-- 
1.7.8

