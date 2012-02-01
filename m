Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab2BALC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 06:02:56 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:46368 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753954Ab2BALCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 06:02:54 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Michel Jaouen <michel.jaouen@stericsson.com>,
        Maxime Coquelin <maxime.coquelin@st-ericsson.com>,
        Alex Macro <alex.macro@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] mfd/ab8500: support AB9540 variant
Date: Wed, 1 Feb 2012 12:02:35 +0100
Message-ID: <1328094155-3320-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel Jaouen <michel.jaouen@stericsson.com>

The AB9540 variant of the AB8500 is basically close enough
to use the same driver with some help of a platform data
identifier field. If possible, we fall back on auto-detecting
the AB variant. The necessary deviations are factored into
the driver and board data.

Signed-off-by: Maxime Coquelin <maxime.coquelin@st-ericsson.com>
Signed-off-by: Alex Macro <alex.macro@stericsson.com>
Signed-off-by: Michel Jaouen <michel.jaouen@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Sam, if this one is OK with you I am requesting your ACK to
take it through the Ux500 tree. It is part of a series to
support the U9540 variant of the Ux500:s with some
cross-dependencies.
---
 arch/arm/mach-ux500/board-mop500.c                 |    5 +-
 .../mach-ux500/include/mach/irqs-board-mop500.h    |    2 +-
 drivers/mfd/ab8500-core.c                          |  293 ++++++++++++++++----
 include/linux/mfd/abx500.h                         |    7 -
 include/linux/mfd/abx500/ab8500-gpio.h             |    4 +-
 include/linux/mfd/abx500/ab8500-sysctrl.h          |   43 +++
 include/linux/mfd/abx500/ab8500.h                  |  114 ++++++++-
 include/linux/regulator/ab8500.h                   |   70 +++++-
 8 files changed, 472 insertions(+), 66 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 5c00712..1fe75ba 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -191,6 +191,7 @@ static struct ab8500_platform_data ab8500_platdata = {
 	.regulator	= ab8500_regulators,
 	.num_regulator	= ARRAY_SIZE(ab8500_regulators),
 	.gpio		= &ab8500_gpio_pdata,
+	.version	= AB8500_VERSION_UNDEFINED,
 };
 
 static struct resource ab8500_resources[] = {
@@ -512,7 +513,6 @@ static struct stedma40_chan_cfg uart2_dma_cfg_tx = {
 };
 #endif
 
-
 static pin_cfg_t mop500_pins_uart0[] = {
 	GPIO0_U0_CTSn   | PIN_INPUT_PULLUP,
 	GPIO1_U0_RTSn   | PIN_OUTPUT_HIGH,
@@ -611,6 +611,7 @@ static void __init mop500_init_machine(void)
 
 	mop500_pins_init();
 
+	ab8500_platdata.version = AB8500_VERSION_AB8500;
 	platform_add_devices(mop500_platform_devs,
 			ARRAY_SIZE(mop500_platform_devs));
 
@@ -637,6 +638,7 @@ static void __init snowball_init_machine(void)
 
 	snowball_pins_init();
 
+	ab8500_platdata.version = AB8500_VERSION_AB8500;
 	platform_add_devices(snowball_platform_devs,
 			ARRAY_SIZE(snowball_platform_devs));
 
@@ -669,6 +671,7 @@ static void __init hrefv60_init_machine(void)
 
 	hrefv60_pins_init();
 
+	ab8500_platdata.version = AB8500_VERSION_AB8500;
 	platform_add_devices(mop500_platform_devs,
 			ARRAY_SIZE(mop500_platform_devs));
 
diff --git a/arch/arm/mach-ux500/include/mach/irqs-board-mop500.h b/arch/arm/mach-ux500/include/mach/irqs-board-mop500.h
index d2d4131..7d34c52 100644
--- a/arch/arm/mach-ux500/include/mach/irqs-board-mop500.h
+++ b/arch/arm/mach-ux500/include/mach/irqs-board-mop500.h
@@ -13,7 +13,7 @@
 
 #define MOP500_AB8500_IRQ_BASE		IRQ_BOARD_START
 #define MOP500_AB8500_IRQ_END		(MOP500_AB8500_IRQ_BASE \
-					 + AB8500_NR_IRQS)
+					 + AB8500_MAX_NR_IRQS)
 
 /* TC35892 */
 #define TC35892_NR_INTERNAL_IRQS	8
diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 53e2a80..f69f2e1 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -32,6 +32,7 @@
 #define AB8500_IT_SOURCE6_REG		0x05
 #define AB8500_IT_SOURCE7_REG		0x06
 #define AB8500_IT_SOURCE8_REG		0x07
+#define AB9540_IT_SOURCE13_REG		0x0C
 #define AB8500_IT_SOURCE19_REG		0x12
 #define AB8500_IT_SOURCE20_REG		0x13
 #define AB8500_IT_SOURCE21_REG		0x14
@@ -53,6 +54,7 @@
 #define AB8500_IT_LATCH9_REG		0x28
 #define AB8500_IT_LATCH10_REG		0x29
 #define AB8500_IT_LATCH12_REG		0x2B
+#define AB9540_IT_LATCH13_REG		0x2C
 #define AB8500_IT_LATCH19_REG		0x32
 #define AB8500_IT_LATCH20_REG		0x33
 #define AB8500_IT_LATCH21_REG		0x34
@@ -90,21 +92,39 @@
 #define AB8500_IT_MASK24_REG		0x57
 
 #define AB8500_REV_REG			0x80
+#define AB8500_IC_NAME_REG		0x82
 #define AB8500_SWITCH_OFF_STATUS	0x00
 
 #define AB8500_TURN_ON_STATUS		0x00
 
+#define AB9540_MODEM_CTRL2_REG			0x23
+#define AB9540_MODEM_CTRL2_SWDBBRSTN_BIT	BIT(2)
+
 /*
  * Map interrupt numbers to the LATCH and MASK register offsets, Interrupt
- * numbers are indexed into this array with (num / 8).
+ * numbers are indexed into this array with (num / 8). The interupts are
+ * defined in linux/mfd/ab8500.h
  *
  * This is one off from the register names, i.e. AB8500_IT_MASK1_REG is at
  * offset 0.
  */
+/* AB8500 support */
 static const int ab8500_irq_regoffset[AB8500_NUM_IRQ_REGS] = {
 	0, 1, 2, 3, 4, 6, 7, 8, 9, 11, 18, 19, 20, 21,
 };
 
+/* AB9540 support */
+static const int ab9540_irq_regoffset[AB9540_NUM_IRQ_REGS] = {
+	0, 1, 2, 3, 4, 6, 7, 8, 9, 11, 18, 19, 20, 21, 12, 13, 24,
+};
+
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
@@ -248,7 +268,7 @@ static void ab8500_irq_sync_unlock(struct irq_data *data)
 	struct ab8500 *ab8500 = irq_data_get_irq_chip_data(data);
 	int i;
 
-	for (i = 0; i < AB8500_NUM_IRQ_REGS; i++) {
+	for (i = 0; i < ab8500->mask_size; i++) {
 		u8 old = ab8500->oldmask[i];
 		u8 new = ab8500->mask[i];
 		int reg;
@@ -256,14 +276,15 @@ static void ab8500_irq_sync_unlock(struct irq_data *data)
 		if (new == old)
 			continue;
 
-		/* Interrupt register 12 doesn't exist prior to version 2.0 */
-		if (ab8500_irq_regoffset[i] == 11 &&
-			ab8500->chip_id < AB8500_CUT2P0)
+		/* Interrupt register 12 doesn't exist prior to AB8500 version
+		 * 2.0 */
+		if (ab8500->irq_reg_offset[i] == 11 &&
+			is_ab8500_1p1_or_earlier(ab8500))
 			continue;
 
 		ab8500->oldmask[i] = new;
 
-		reg = AB8500_IT_MASK1_REG + ab8500_irq_regoffset[i];
+		reg = AB8500_IT_MASK1_REG + ab8500->irq_reg_offset[i];
 		set_register_interruptible(ab8500, AB8500_INTERRUPT, reg, new);
 	}
 
@@ -306,13 +327,14 @@ static irqreturn_t ab8500_irq(int irq, void *dev)
 
 	dev_vdbg(ab8500->dev, "interrupt\n");
 
-	for (i = 0; i < AB8500_NUM_IRQ_REGS; i++) {
-		int regoffset = ab8500_irq_regoffset[i];
+	for (i = 0; i < ab8500->mask_size; i++) {
+		int regoffset = ab8500->irq_reg_offset[i];
 		int status;
 		u8 value;
 
-		/* Interrupt register 12 doesn't exist prior to version 2.0 */
-		if (regoffset == 11 && ab8500->chip_id < AB8500_CUT2P0)
+		/* Interrupt register 12 doesn't exist prior to AB8500 version
+		 * 2.0 */
+		if (regoffset == 11 && is_ab8500_1p1_or_earlier(ab8500))
 			continue;
 
 		status = get_register_interruptible(ab8500, AB8500_INTERRUPT,
@@ -336,8 +358,14 @@ static int ab8500_irq_init(struct ab8500 *ab8500)
 {
 	int base = ab8500->irq_base;
 	int irq;
+	int num_irqs;
+
+	if (is_ab9540(ab8500))
+		num_irqs = AB9540_NR_IRQS;
+	else
+		num_irqs = AB8500_NR_IRQS;
 
-	for (irq = base; irq < base + AB8500_NR_IRQS; irq++) {
+	for (irq = base; irq < base + num_irqs; irq++) {
 		irq_set_chip_data(irq, ab8500);
 		irq_set_chip_and_handler(irq, &ab8500_irq_chip,
 					 handle_simple_irq);
@@ -356,8 +384,14 @@ static void ab8500_irq_remove(struct ab8500 *ab8500)
 {
 	int base = ab8500->irq_base;
 	int irq;
+	int num_irqs;
 
-	for (irq = base; irq < base + AB8500_NR_IRQS; irq++) {
+	if (is_ab9540(ab8500))
+		num_irqs = AB9540_NR_IRQS;
+	else
+		num_irqs = AB8500_NR_IRQS;
+
+	for (irq = base; irq < base + num_irqs; irq++) {
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, 0);
 #endif
@@ -366,6 +400,7 @@ static void ab8500_irq_remove(struct ab8500 *ab8500)
 	}
 }
 
+/* AB8500 GPIO Resources */
 static struct resource __devinitdata ab8500_gpio_resources[] = {
 	{
 		.name	= "GPIO_INT6",
@@ -375,6 +410,28 @@ static struct resource __devinitdata ab8500_gpio_resources[] = {
 	}
 };
 
+/* AB9540 GPIO Resources */
+static struct resource __devinitdata ab9540_gpio_resources[] = {
+	{
+		.name	= "GPIO_INT6",
+		.start	= AB8500_INT_GPIO6R,
+		.end	= AB8500_INT_GPIO41F,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.name	= "GPIO_INT14",
+		.start	= AB9540_INT_GPIO50R,
+		.end	= AB9540_INT_GPIO54R,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.name	= "GPIO_INT15",
+		.start	= AB9540_INT_GPIO50F,
+		.end	= AB9540_INT_GPIO54F,
+		.flags	= IORESOURCE_IRQ,
+	}
+};
+
 static struct resource __devinitdata ab8500_gpadc_resources[] = {
 	{
 		.name	= "HW_CONV_END",
@@ -691,7 +748,7 @@ static struct resource __devinitdata ab8500_temp_resources[] = {
 	},
 };
 
-static struct mfd_cell __devinitdata ab8500_devs[] = {
+static struct mfd_cell __devinitdata abx500_common_devs[] = {
 #ifdef CONFIG_DEBUG_FS
 	{
 		.name = "ab8500-debug",
@@ -706,11 +763,6 @@ static struct mfd_cell __devinitdata ab8500_devs[] = {
 		.name = "ab8500-regulator",
 	},
 	{
-		.name = "ab8500-gpio",
-		.num_resources = ARRAY_SIZE(ab8500_gpio_resources),
-		.resources = ab8500_gpio_resources,
-	},
-	{
 		.name = "ab8500-gpadc",
 		.num_resources = ARRAY_SIZE(ab8500_gpadc_resources),
 		.resources = ab8500_gpadc_resources,
@@ -748,11 +800,7 @@ static struct mfd_cell __devinitdata ab8500_devs[] = {
 	{
 		.name = "ab8500-codec",
 	},
-	{
-		.name = "ab8500-usb",
-		.num_resources = ARRAY_SIZE(ab8500_usb_resources),
-		.resources = ab8500_usb_resources,
-	},
+
 	{
 		.name = "ab8500-poweron-key",
 		.num_resources = ARRAY_SIZE(ab8500_poweronkey_db_resources),
@@ -781,6 +829,32 @@ static struct mfd_cell __devinitdata ab8500_devs[] = {
 	},
 };
 
+static struct mfd_cell __devinitdata ab8500_devs[] = {
+	{
+		.name = "ab8500-gpio",
+		.num_resources = ARRAY_SIZE(ab8500_gpio_resources),
+		.resources = ab8500_gpio_resources,
+	},
+	{
+		.name = "ab8500-usb",
+		.num_resources = ARRAY_SIZE(ab8500_usb_resources),
+		.resources = ab8500_usb_resources,
+	},
+};
+
+static struct mfd_cell __devinitdata ab9540_devs[] = {
+	{
+		.name = "ab8500-gpio",
+		.num_resources = ARRAY_SIZE(ab9540_gpio_resources),
+		.resources = ab9540_gpio_resources,
+	},
+	{
+		.name = "ab9540-usb",
+		.num_resources = ARRAY_SIZE(ab8500_usb_resources),
+		.resources = ab8500_usb_resources,
+	},
+};
+
 static ssize_t show_chip_id(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
@@ -842,9 +916,64 @@ static ssize_t show_turn_on_status(struct device *dev,
 	return sprintf(buf, "%#x\n", value);
 }
 
+static ssize_t show_ab9540_dbbrstn(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct ab8500 *ab8500;
+	int ret;
+	u8 value;
+
+	ab8500 = dev_get_drvdata(dev);
+
+	ret = get_register_interruptible(ab8500, AB8500_REGU_CTRL2,
+		AB9540_MODEM_CTRL2_REG, &value);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%d\n",
+			(value & AB9540_MODEM_CTRL2_SWDBBRSTN_BIT) ? 1 : 0);
+}
+
+static ssize_t store_ab9540_dbbrstn(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct ab8500 *ab8500;
+	int ret = count;
+	int err;
+	u8 bitvalues;
+
+	ab8500 = dev_get_drvdata(dev);
+
+	if (count > 0) {
+		switch (buf[0]) {
+		case '0':
+			bitvalues = 0;
+			break;
+		case '1':
+			bitvalues = AB9540_MODEM_CTRL2_SWDBBRSTN_BIT;
+			break;
+		default:
+			goto exit;
+		}
+
+		err = mask_and_set_register_interruptible(ab8500,
+			AB8500_REGU_CTRL2, AB9540_MODEM_CTRL2_REG,
+			AB9540_MODEM_CTRL2_SWDBBRSTN_BIT, bitvalues);
+		if (err)
+			dev_info(ab8500->dev,
+				"Failed to set DBBRSTN %c, err %#x\n",
+				buf[0], err);
+	}
+
+exit:
+	return ret;
+}
+
 static DEVICE_ATTR(chip_id, S_IRUGO, show_chip_id, NULL);
 static DEVICE_ATTR(switch_off_status, S_IRUGO, show_switch_off_status, NULL);
 static DEVICE_ATTR(turn_on_status, S_IRUGO, show_turn_on_status, NULL);
+static DEVICE_ATTR(dbbrstn, S_IRUGO | S_IWUSR,
+			show_ab9540_dbbrstn, store_ab9540_dbbrstn);
 
 static struct attribute *ab8500_sysfs_entries[] = {
 	&dev_attr_chip_id.attr,
@@ -853,10 +982,22 @@ static struct attribute *ab8500_sysfs_entries[] = {
 	NULL,
 };
 
+static struct attribute *ab9540_sysfs_entries[] = {
+	&dev_attr_chip_id.attr,
+	&dev_attr_switch_off_status.attr,
+	&dev_attr_turn_on_status.attr,
+	&dev_attr_dbbrstn.attr,
+	NULL,
+};
+
 static struct attribute_group ab8500_attr_group = {
 	.attrs	= ab8500_sysfs_entries,
 };
 
+static struct attribute_group ab9540_attr_group = {
+	.attrs	= ab9540_sysfs_entries,
+};
+
 int __devinit ab8500_init(struct ab8500 *ab8500)
 {
 	struct ab8500_platform_data *plat = dev_get_platdata(ab8500->dev);
@@ -870,25 +1011,45 @@ int __devinit ab8500_init(struct ab8500 *ab8500)
 	mutex_init(&ab8500->lock);
 	mutex_init(&ab8500->irq_lock);
 
+	if (plat->version != AB8500_VERSION_UNDEFINED)
+		ab8500->version = plat->version;
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
+	/* Configure AB8500 or AB9540 IRQ */
+	if (is_ab9540(ab8500)) {
+		ab8500->mask_size = AB9540_NUM_IRQ_REGS;
+		ab8500->irq_reg_offset = ab9540_irq_regoffset;
+	} else {
+		ab8500->mask_size = AB8500_NUM_IRQ_REGS;
+		ab8500->irq_reg_offset = ab8500_irq_regoffset;
+	}
+	ab8500->mask = kzalloc(ab8500->mask_size, GFP_KERNEL);
+	if (!ab8500->mask)
+		return -ENOMEM;
+	ab8500->oldmask = kzalloc(ab8500->mask_size, GFP_KERNEL);
+	if (!ab8500->oldmask) {
+		ret = -ENOMEM;
+		goto out_freemask;
+	}
 	/*
 	 * ab8500 has switched off due to (SWITCH_OFF_STATUS):
 	 * 0x01 Swoff bit programming
@@ -911,30 +1072,31 @@ int __devinit ab8500_init(struct ab8500 *ab8500)
 		plat->init(ab8500);
 
 	/* Clear and mask all interrupts */
-	for (i = 0; i < AB8500_NUM_IRQ_REGS; i++) {
-		/* Interrupt register 12 doesn't exist prior to version 2.0 */
-		if (ab8500_irq_regoffset[i] == 11 &&
-			ab8500->chip_id < AB8500_CUT2P0)
+	for (i = 0; i < ab8500->mask_size; i++) {
+		/* Interrupt register 12 doesn't exist prior to AB8500 version
+		 * 2.0 */
+		if (ab8500->irq_reg_offset[i] == 11 &&
+				is_ab8500_1p1_or_earlier(ab8500))
 			continue;
 
 		get_register_interruptible(ab8500, AB8500_INTERRUPT,
-			AB8500_IT_LATCH1_REG + ab8500_irq_regoffset[i],
+			AB8500_IT_LATCH1_REG + ab8500->irq_reg_offset[i],
 			&value);
 		set_register_interruptible(ab8500, AB8500_INTERRUPT,
-			AB8500_IT_MASK1_REG + ab8500_irq_regoffset[i], 0xff);
+			AB8500_IT_MASK1_REG + ab8500->irq_reg_offset[i], 0xff);
 	}
 
 	ret = abx500_register_ops(ab8500->dev, &ab8500_ops);
 	if (ret)
-		return ret;
+		goto out_freeoldmask;
 
-	for (i = 0; i < AB8500_NUM_IRQ_REGS; i++)
+	for (i = 0; i < ab8500->mask_size; i++)
 		ab8500->mask[i] = ab8500->oldmask[i] = 0xff;
 
 	if (ab8500->irq_base) {
 		ret = ab8500_irq_init(ab8500);
 		if (ret)
-			return ret;
+			goto out_freeoldmask;
 
 		ret = request_threaded_irq(ab8500->irq, NULL, ab8500_irq,
 					   IRQF_ONESHOT | IRQF_NO_SUSPEND,
@@ -943,35 +1105,62 @@ int __devinit ab8500_init(struct ab8500 *ab8500)
 			goto out_removeirq;
 	}
 
-	ret = mfd_add_devices(ab8500->dev, 0, ab8500_devs,
-			      ARRAY_SIZE(ab8500_devs), NULL,
+	ret = mfd_add_devices(ab8500->dev, 0, abx500_common_devs,
+			      ARRAY_SIZE(abx500_common_devs), NULL,
+			      ab8500->irq_base);
+
+	if (ret)
+		goto out_freeirq;
+
+	if (is_ab9540(ab8500))
+		ret = mfd_add_devices(ab8500->dev, 0, ab9540_devs,
+			      ARRAY_SIZE(ab9540_devs), NULL,
+			      ab8500->irq_base);
+	else
+		ret = mfd_add_devices(ab8500->dev, 0, ab8500_devs,
+			      ARRAY_SIZE(ab9540_devs), NULL,
 			      ab8500->irq_base);
 	if (ret)
 		goto out_freeirq;
 
-	ret = sysfs_create_group(&ab8500->dev->kobj, &ab8500_attr_group);
+	if (is_ab9540(ab8500))
+		ret = sysfs_create_group(&ab8500->dev->kobj,
+					&ab9540_attr_group);
+	else
+		ret = sysfs_create_group(&ab8500->dev->kobj,
+					&ab8500_attr_group);
 	if (ret)
 		dev_err(ab8500->dev, "error creating sysfs entries\n");
-
-	return ret;
+	else
+		return ret;
 
 out_freeirq:
-	if (ab8500->irq_base) {
+	if (ab8500->irq_base)
 		free_irq(ab8500->irq, ab8500);
 out_removeirq:
+	if (ab8500->irq_base)
 		ab8500_irq_remove(ab8500);
-	}
+
+out_freeoldmask:
+	kfree(ab8500->oldmask);
+out_freemask:
+	kfree(ab8500->mask);
 	return ret;
 }
 
 int __devexit ab8500_exit(struct ab8500 *ab8500)
 {
-	sysfs_remove_group(&ab8500->dev->kobj, &ab8500_attr_group);
+	if (is_ab9540(ab8500))
+		sysfs_remove_group(&ab8500->dev->kobj, &ab9540_attr_group);
+	else
+		sysfs_remove_group(&ab8500->dev->kobj, &ab8500_attr_group);
 	mfd_remove_devices(ab8500->dev);
 	if (ab8500->irq_base) {
 		free_irq(ab8500->irq, ab8500);
 		ab8500_irq_remove(ab8500);
 	}
+	kfree(ab8500->oldmask);
+	kfree(ab8500->mask);
 
 	return 0;
 }
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
diff --git a/include/linux/mfd/abx500/ab8500-gpio.h b/include/linux/mfd/abx500/ab8500-gpio.h
index 488a8c9..2387c20 100644
--- a/include/linux/mfd/abx500/ab8500-gpio.h
+++ b/include/linux/mfd/abx500/ab8500-gpio.h
@@ -10,12 +10,14 @@
 
 /*
  * Platform data to register a block: only the initial gpio/irq number.
+ * Array sizes are large enough to contain all AB8500 and AB9540 GPIO
+ * registers.
  */
 
 struct ab8500_gpio_platform_data {
 	int gpio_base;
 	u32 irq_base;
-	u8  config_reg[7];
+	u8  config_reg[8];
 };
 
 #endif /* _AB8500_GPIO_H */
diff --git a/include/linux/mfd/abx500/ab8500-sysctrl.h b/include/linux/mfd/abx500/ab8500-sysctrl.h
index 10da029..10eb509 100644
--- a/include/linux/mfd/abx500/ab8500-sysctrl.h
+++ b/include/linux/mfd/abx500/ab8500-sysctrl.h
@@ -71,6 +71,13 @@ static inline int ab8500_sysctrl_clear(u16 reg, u8 bits)
 #define AB8500_SWATCTRL			0x230
 #define AB8500_HIQCLKCTRL		0x232
 #define AB8500_VSIMSYSCLKCTRL		0x233
+#define AB9540_SYSCLK12BUFCTRL		0x234
+#define AB9540_SYSCLK12CONFCTRL		0x235
+#define AB9540_SYSCLK12BUFCTRL2		0x236
+#define AB9540_SYSCLK12BUF1VALID	0x237
+#define AB9540_SYSCLK12BUF2VALID	0x238
+#define AB9540_SYSCLK12BUF3VALID	0x239
+#define AB9540_SYSCLK12BUF4VALID	0x23A
 
 /* Bits */
 #define AB8500_TURNONSTATUS_PORNVBAT BIT(0)
@@ -251,4 +258,40 @@ static inline int ab8500_sysctrl_clear(u16 reg, u8 bits)
 #define AB8500_VSIMSYSCLKCTRL_VSIMSYSCLKREQ7VALID BIT(6)
 #define AB8500_VSIMSYSCLKCTRL_VSIMSYSCLKREQ8VALID BIT(7)
 
+#define AB9540_SYSCLK12BUFCTRL_SYSCLK12BUF1ENA BIT(0)
+#define AB9540_SYSCLK12BUFCTRL_SYSCLK12BUF2ENA BIT(1)
+#define AB9540_SYSCLK12BUFCTRL_SYSCLK12BUF3ENA BIT(2)
+#define AB9540_SYSCLK12BUFCTRL_SYSCLK12BUF4ENA BIT(3)
+#define AB9540_SYSCLK12BUFCTRL_SYSCLK12BUFENA_MASK 0x0F
+#define AB9540_SYSCLK12BUFCTRL_SYSCLK12BUF1STRE BIT(4)
+#define AB9540_SYSCLK12BUFCTRL_SYSCLK12BUF2STRE BIT(5)
+#define AB9540_SYSCLK12BUFCTRL_SYSCLK12BUF3STRE BIT(6)
+#define AB9540_SYSCLK12BUFCTRL_SYSCLK12BUF4STRE BIT(7)
+#define AB9540_SYSCLK12BUFCTRL_SYSCLK12BUFSTRE_MASK 0xF0
+
+#define AB9540_SYSCLK12CONFCTRL_PLL26TO38ENA BIT(0)
+#define AB9540_SYSCLK12CONFCTRL_SYSCLK12USBMUXSEL BIT(1)
+#define AB9540_SYSCLK12CONFCTRL_INT384MHZMUXSEL_MASK 0x0C
+#define AB9540_SYSCLK12CONFCTRL_INT384MHZMUXSEL_SHIFT 2
+#define AB9540_SYSCLK12CONFCTRL_SYSCLK12BUFMUX BIT(4)
+#define AB9540_SYSCLK12CONFCTRL_SYSCLK12PLLMUX BIT(5)
+#define AB9540_SYSCLK12CONFCTRL_SYSCLK2MUXVALID BIT(6)
+
+#define AB9540_SYSCLK12BUFCTRL2_SYSCLK12BUF1PDENA BIT(0)
+#define AB9540_SYSCLK12BUFCTRL2_SYSCLK12BUF2PDENA BIT(1)
+#define AB9540_SYSCLK12BUFCTRL2_SYSCLK12BUF3PDENA BIT(2)
+#define AB9540_SYSCLK12BUFCTRL2_SYSCLK12BUF4PDENA BIT(3)
+
+#define AB9540_SYSCLK12BUF1VALID_SYSCLK12BUF1VALID_MASK 0xFF
+#define AB9540_SYSCLK12BUF1VALID_SYSCLK12BUF1VALID_SHIFT 0
+
+#define AB9540_SYSCLK12BUF2VALID_SYSCLK12BUF2VALID_MASK 0xFF
+#define AB9540_SYSCLK12BUF2VALID_SYSCLK12BUF2VALID_SHIFT 0
+
+#define AB9540_SYSCLK12BUF3VALID_SYSCLK12BUF3VALID_MASK 0xFF
+#define AB9540_SYSCLK12BUF3VALID_SYSCLK12BUF3VALID_SHIFT 0
+
+#define AB9540_SYSCLK12BUF4VALID_SYSCLK12BUF4VALID_MASK 0xFF
+#define AB9540_SYSCLK12BUF4VALID_SYSCLK12BUF4VALID_SHIFT 0
+
 #endif /* __AB8500_SYSCTRL_H */
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index 838c6b4..90801a4 100644
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
@@ -35,8 +57,11 @@
 
 /*
  * Interrupts
+ * Values used to index into array ab8500_irq_regoffset[] defined in
+ * drivers/mdf/ab8500-core.c
  */
-
+/* Definitions for AB8500 and AB9540 */
+/* ab8500_irq_regoffset[0] -> IT[Source|Latch|Mask]1 */
 #define AB8500_INT_MAIN_EXT_CH_NOT_OK	0
 #define AB8500_INT_UN_PLUG_TV_DET	1
 #define AB8500_INT_PLUG_TV_DET		2
@@ -45,6 +70,7 @@
 #define AB8500_INT_PON_KEY2DB_R		5
 #define AB8500_INT_PON_KEY1DB_F		6
 #define AB8500_INT_PON_KEY1DB_R		7
+/* ab8500_irq_regoffset[1] -> IT[Source|Latch|Mask]2 */
 #define AB8500_INT_BATT_OVV		8
 #define AB8500_INT_MAIN_CH_UNPLUG_DET	10
 #define AB8500_INT_MAIN_CH_PLUG_DET	11
@@ -52,6 +78,7 @@
 #define AB8500_INT_USB_ID_DET_R		13
 #define AB8500_INT_VBUS_DET_F		14
 #define AB8500_INT_VBUS_DET_R		15
+/* ab8500_irq_regoffset[2] -> IT[Source|Latch|Mask]3 */
 #define AB8500_INT_VBUS_CH_DROP_END	16
 #define AB8500_INT_RTC_60S		17
 #define AB8500_INT_RTC_ALARM		18
@@ -59,6 +86,7 @@
 #define AB8500_INT_CH_WD_EXP		21
 #define AB8500_INT_VBUS_OVV		22
 #define AB8500_INT_MAIN_CH_DROP_END	23
+/* ab8500_irq_regoffset[3] -> IT[Source|Latch|Mask]4 */
 #define AB8500_INT_CCN_CONV_ACC		24
 #define AB8500_INT_INT_AUD		25
 #define AB8500_INT_CCEOC		26
@@ -67,6 +95,7 @@
 #define AB8500_INT_LOW_BAT_R		29
 #define AB8500_INT_BUP_CHG_NOT_OK	30
 #define AB8500_INT_BUP_CHG_OK		31
+/* ab8500_irq_regoffset[4] -> IT[Source|Latch|Mask]5 */
 #define AB8500_INT_GP_HW_ADC_CONV_END	32
 #define AB8500_INT_ACC_DETECT_1DB_F	33
 #define AB8500_INT_ACC_DETECT_1DB_R	34
@@ -75,6 +104,7 @@
 #define AB8500_INT_ACC_DETECT_21DB_F	37
 #define AB8500_INT_ACC_DETECT_21DB_R	38
 #define AB8500_INT_GP_SW_ADC_CONV_END	39
+/* ab8500_irq_regoffset[5] -> IT[Source|Latch|Mask]7 */
 #define AB8500_INT_GPIO6R		40
 #define AB8500_INT_GPIO7R		41
 #define AB8500_INT_GPIO8R		42
@@ -83,6 +113,7 @@
 #define AB8500_INT_GPIO11R		45
 #define AB8500_INT_GPIO12R		46
 #define AB8500_INT_GPIO13R		47
+/* ab8500_irq_regoffset[6] -> IT[Source|Latch|Mask]8 */
 #define AB8500_INT_GPIO24R		48
 #define AB8500_INT_GPIO25R		49
 #define AB8500_INT_GPIO36R		50
@@ -91,6 +122,7 @@
 #define AB8500_INT_GPIO39R		53
 #define AB8500_INT_GPIO40R		54
 #define AB8500_INT_GPIO41R		55
+/* ab8500_irq_regoffset[7] -> IT[Source|Latch|Mask]9 */
 #define AB8500_INT_GPIO6F		56
 #define AB8500_INT_GPIO7F		57
 #define AB8500_INT_GPIO8F		58
@@ -99,6 +131,7 @@
 #define AB8500_INT_GPIO11F		61
 #define AB8500_INT_GPIO12F		62
 #define AB8500_INT_GPIO13F		63
+/* ab8500_irq_regoffset[8] -> IT[Source|Latch|Mask]10 */
 #define AB8500_INT_GPIO24F		64
 #define AB8500_INT_GPIO25F		65
 #define AB8500_INT_GPIO36F		66
@@ -107,6 +140,7 @@
 #define AB8500_INT_GPIO39F		69
 #define AB8500_INT_GPIO40F		70
 #define AB8500_INT_GPIO41F		71
+/* ab8500_irq_regoffset[9] -> IT[Source|Latch|Mask]12 */
 #define AB8500_INT_ADP_SOURCE_ERROR	72
 #define AB8500_INT_ADP_SINK_ERROR	73
 #define AB8500_INT_ADP_PROBE_PLUG	74
@@ -114,30 +148,62 @@
 #define AB8500_INT_ADP_SENSE_OFF	76
 #define AB8500_INT_USB_PHY_POWER_ERR	78
 #define AB8500_INT_USB_LINK_STATUS	79
+/* ab8500_irq_regoffset[10] -> IT[Source|Latch|Mask]19 */
 #define AB8500_INT_BTEMP_LOW		80
 #define AB8500_INT_BTEMP_LOW_MEDIUM	81
 #define AB8500_INT_BTEMP_MEDIUM_HIGH	82
 #define AB8500_INT_BTEMP_HIGH		83
+/* ab8500_irq_regoffset[11] -> IT[Source|Latch|Mask]20 */
 #define AB8500_INT_USB_CHARGER_NOT_OK	89
 #define AB8500_INT_ID_WAKEUP_R		90
 #define AB8500_INT_ID_DET_R1R		92
 #define AB8500_INT_ID_DET_R2R		93
 #define AB8500_INT_ID_DET_R3R		94
 #define AB8500_INT_ID_DET_R4R		95
+/* ab8500_irq_regoffset[12] -> IT[Source|Latch|Mask]21 */
 #define AB8500_INT_ID_WAKEUP_F		96
 #define AB8500_INT_ID_DET_R1F		98
 #define AB8500_INT_ID_DET_R2F		99
 #define AB8500_INT_ID_DET_R3F		100
 #define AB8500_INT_ID_DET_R4F		101
 #define AB8500_INT_USB_CHG_DET_DONE	102
+/* ab8500_irq_regoffset[13] -> IT[Source|Latch|Mask]22 */
 #define AB8500_INT_USB_CH_TH_PROT_F	104
 #define AB8500_INT_USB_CH_TH_PROT_R    105
 #define AB8500_INT_MAIN_CH_TH_PROT_F   106
 #define AB8500_INT_MAIN_CH_TH_PROT_R	107
 #define AB8500_INT_USB_CHARGER_NOT_OKF	111
 
+/* Definitions for AB9540 */
+/* ab8500_irq_regoffset[14] -> IT[Source|Latch|Mask]13 */
+#define AB9540_INT_GPIO50R		113
+#define AB9540_INT_GPIO51R		114
+#define AB9540_INT_GPIO52R		115
+#define AB9540_INT_GPIO53R		116
+#define AB9540_INT_GPIO54R		117
+#define AB9540_INT_IEXT_CH_RF_BFN_R	118
+#define AB9540_INT_IEXT_CH_RF_BFN_F	119
+/* ab8500_irq_regoffset[15] -> IT[Source|Latch|Mask]14 */
+#define AB9540_INT_GPIO50F		121
+#define AB9540_INT_GPIO51F		122
+#define AB9540_INT_GPIO52F		123
+#define AB9540_INT_GPIO53F		124
+#define AB9540_INT_GPIO54F		125
+
+/*
+ * AB8500_AB9540_NR_IRQS is used when configuring the IRQ numbers for the
+ * entire platform. This is a "compile time" constant so this must be set to
+ * the largest possible value that may be encountered with different AB SOCs.
+ * Of the currently supported AB devices, AB8500 and AB9540, it is the AB9540
+ * which is larger.
+ */
 #define AB8500_NR_IRQS			112
+#define AB9540_NR_IRQS			128
+/* This is set to the roof of any AB8500 chip variant IRQ counts */
+#define AB8500_MAX_NR_IRQS		AB9540_NR_IRQS
+
 #define AB8500_NUM_IRQ_REGS		14
+#define AB9540_NUM_IRQ_REGS		17
 
 /**
  * struct ab8500 - ab8500 internal structure
@@ -145,6 +211,7 @@
  * @lock: read/write operations lock
  * @irq_lock: genirq bus lock
  * @irq: irq line
+ * @version: chip version id (e.g. ab8500 or ab9540)
  * @chip_id: chip revision id
  * @write: register write
  * @read: register read
@@ -152,6 +219,9 @@
  * @tx_buf: tx buf for SPI
  * @mask: cache of IRQ regs for bus lock
  * @oldmask: cache of previous IRQ regs for bus lock
+ * @mask_size: Actual number of valid entries in mask[], oldmask[] and
+ * irq_reg_offset
+ * @irq_reg_offset: Array of offsets into IRQ registers
  */
 struct ab8500 {
 	struct device	*dev;
@@ -160,6 +230,7 @@ struct ab8500 {
 
 	int		irq_base;
 	int		irq;
+	enum ab8500_version version;
 	u8		chip_id;
 
 	int (*write) (struct ab8500 *a8500, u16 addr, u8 data);
@@ -168,8 +239,10 @@ struct ab8500 {
 	unsigned long	tx_buf[4];
 	unsigned long	rx_buf[4];
 
-	u8 mask[AB8500_NUM_IRQ_REGS];
-	u8 oldmask[AB8500_NUM_IRQ_REGS];
+	u8 *mask;
+	u8 *oldmask;
+	int mask_size;
+	const int *irq_reg_offset;
 };
 
 struct regulator_reg_init;
@@ -184,6 +257,8 @@ struct ab8500_gpio_platform_data;
  * @regulator_reg_init: regulator init registers
  * @num_regulator: number of regulators
  * @regulator: machine-specific constraints for regulators
+ * @gpio: machine-specific AB8500 GPIO platform data
+ * @version: hard-coded chip variant stated by the platform
  */
 struct ab8500_platform_data {
 	int irq_base;
@@ -193,9 +268,42 @@ struct ab8500_platform_data {
 	int num_regulator;
 	struct regulator_init_data *regulator;
 	struct ab8500_gpio_platform_data *gpio;
+	enum ab8500_version version;
 };
 
 extern int __devinit ab8500_init(struct ab8500 *ab8500);
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
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index 76579f9..7bd73bb 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -26,7 +26,26 @@ enum ab8500_regulator_id {
 	AB8500_NUM_REGULATORS,
 };
 
-/* AB8500 register initialization */
+/* AB9450 regulators */
+enum ab9540_regulator_id {
+	AB9540_LDO_AUX1,
+	AB9540_LDO_AUX2,
+	AB9540_LDO_AUX3,
+	AB9540_LDO_AUX4,
+	AB9540_LDO_INTCORE,
+	AB9540_LDO_TVOUT,
+	AB9540_LDO_USB,
+	AB9540_LDO_AUDIO,
+	AB9540_LDO_ANAMIC1,
+	AB9540_LDO_ANAMIC2,
+	AB9540_LDO_DMIC,
+	AB9540_LDO_ANA,
+	AB9540_SYSCLKREQ_2,
+	AB9540_SYSCLKREQ_4,
+	AB9540_NUM_REGULATORS,
+};
+
+/* AB8500 and AB9540 register initialization */
 struct ab8500_regulator_reg_init {
 	int id;
 	u8 value;
@@ -71,4 +90,53 @@ enum ab8500_regulator_reg {
 	AB8500_NUM_REGULATOR_REGISTERS,
 };
 
+
+/* AB9540 registers */
+enum ab9540_regulator_reg {
+	AB9540_REGUREQUESTCTRL1,
+	AB9540_REGUREQUESTCTRL2,
+	AB9540_REGUREQUESTCTRL3,
+	AB9540_REGUREQUESTCTRL4,
+	AB9540_REGUSYSCLKREQ1HPVALID1,
+	AB9540_REGUSYSCLKREQ1HPVALID2,
+	AB9540_REGUHWHPREQ1VALID1,
+	AB9540_REGUHWHPREQ1VALID2,
+	AB9540_REGUHWHPREQ2VALID1,
+	AB9540_REGUHWHPREQ2VALID2,
+	AB9540_REGUSWHPREQVALID1,
+	AB9540_REGUSWHPREQVALID2,
+	AB9540_REGUSYSCLKREQVALID1,
+	AB9540_REGUSYSCLKREQVALID2,
+	AB9540_REGUVAUX4REQVALID,
+	AB9540_REGUMISC1,
+	AB9540_VAUDIOSUPPLY,
+	AB9540_REGUCTRL1VAMIC,
+	AB9540_VSMPS1REGU,
+	AB9540_VSMPS2REGU,
+	AB9540_VSMPS3REGU, /* NOTE! PRCMU register */
+	AB9540_VPLLVANAREGU,
+	AB9540_EXTSUPPLYREGU,
+	AB9540_VAUX12REGU,
+	AB9540_VRF1VAUX3REGU,
+	AB9540_VSMPS1SEL1,
+	AB9540_VSMPS1SEL2,
+	AB9540_VSMPS1SEL3,
+	AB9540_VSMPS2SEL1,
+	AB9540_VSMPS2SEL2,
+	AB9540_VSMPS2SEL3,
+	AB9540_VSMPS3SEL1, /* NOTE! PRCMU register */
+	AB9540_VSMPS3SEL2, /* NOTE! PRCMU register */
+	AB9540_VAUX1SEL,
+	AB9540_VAUX2SEL,
+	AB9540_VRF1VAUX3SEL,
+	AB9540_REGUCTRL2SPARE,
+	AB9540_VAUX4REQCTRL,
+	AB9540_VAUX4REGU,
+	AB9540_VAUX4SEL,
+	AB9540_REGUCTRLDISCH,
+	AB9540_REGUCTRLDISCH2,
+	AB9540_REGUCTRLDISCH3,
+	AB9540_NUM_REGULATOR_REGISTERS,
+};
+
 #endif
-- 
1.7.8

