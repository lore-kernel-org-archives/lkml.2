Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375Ab0HUJVc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 05:21:32 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:59814 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875Ab0HUJV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 05:21:28 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] MFD: Align AB8500 with the abx500.h interface
Date: Sat, 21 Aug 2010 11:20:28 +0200
Message-ID: <1282382428-10389-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattias Wallin <mattias.wallin@stericsson.com>

This patch consolidates the ab8500 mixed signal chip to expose the
same interface for register access as the ab3100, ab3550 and ab5500
chips. The ab8500_read() and ab8500_write() are removed and replaced
with abx500_get_register_interruptible() and
abx500_set_register_interruptible() respectively.

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
This patch need be applied across the subsystems so as not to break
bisection. Since it is mainly related to the core, the suggestion
is to bring this in through Sam:s tree.
---
 drivers/mfd/Kconfig        |    4 +-
 drivers/mfd/ab8500-core.c  |  286 ++++++++++++++++++++++++++------------------
 drivers/regulator/ab8500.c |   86 ++++++++------
 drivers/rtc/rtc-ab8500.c   |  103 ++++++++--------
 include/linux/mfd/ab8500.h |   28 ++++-
 include/linux/mfd/abx500.h |    3 +-
 6 files changed, 301 insertions(+), 209 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index db51ea1..c957c3a 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -433,7 +433,7 @@ config PCF50633_GPIO
 
 config ABX500_CORE
 	bool "ST-Ericsson ABX500 Mixed Signal Circuit register functions"
-	default y if ARCH_U300
+	default y if ARCH_U300 || ARCH_U8500
 	help
 	  Say yes here if you have the ABX500 Mixed Signal IC family
 	  chips. This core driver expose register access functions.
@@ -473,7 +473,7 @@ config EZX_PCAP
 
 config AB8500_CORE
 	bool "ST-Ericsson AB8500 Mixed Signal Power Management chip"
-	depends on SPI=y && GENERIC_HARDIRQS
+	depends on SPI=y && GENERIC_HARDIRQS && ABX500_CORE
 	select MFD_CORE
 	help
 	  Select this option to enable access to AB8500 power management
diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index defa786..6548f50 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -4,6 +4,7 @@
  * License Terms: GNU General Public License v2
  * Author: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
  * Author: Rabin Vincent <rabin.vincent@stericsson.com>
+ * Changes: Mattias Wallin <mattias.wallin@stericsson.com>
  */
 
 #include <linux/kernel.h>
@@ -15,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/mfd/core.h>
+#include <linux/mfd/abx500.h>
 #include <linux/mfd/ab8500.h>
 #include <linux/regulator/ab8500.h>
 
@@ -22,71 +24,71 @@
  * Interrupt register offsets
  * Bank : 0x0E
  */
-#define AB8500_IT_SOURCE1_REG		0x0E00
-#define AB8500_IT_SOURCE2_REG		0x0E01
-#define AB8500_IT_SOURCE3_REG		0x0E02
-#define AB8500_IT_SOURCE4_REG		0x0E03
-#define AB8500_IT_SOURCE5_REG		0x0E04
-#define AB8500_IT_SOURCE6_REG		0x0E05
-#define AB8500_IT_SOURCE7_REG		0x0E06
-#define AB8500_IT_SOURCE8_REG		0x0E07
-#define AB8500_IT_SOURCE19_REG		0x0E12
-#define AB8500_IT_SOURCE20_REG		0x0E13
-#define AB8500_IT_SOURCE21_REG		0x0E14
-#define AB8500_IT_SOURCE22_REG		0x0E15
-#define AB8500_IT_SOURCE23_REG		0x0E16
-#define AB8500_IT_SOURCE24_REG		0x0E17
+#define AB8500_IT_SOURCE1_REG		0x00
+#define AB8500_IT_SOURCE2_REG		0x01
+#define AB8500_IT_SOURCE3_REG		0x02
+#define AB8500_IT_SOURCE4_REG		0x03
+#define AB8500_IT_SOURCE5_REG		0x04
+#define AB8500_IT_SOURCE6_REG		0x05
+#define AB8500_IT_SOURCE7_REG		0x06
+#define AB8500_IT_SOURCE8_REG		0x07
+#define AB8500_IT_SOURCE19_REG		0x12
+#define AB8500_IT_SOURCE20_REG		0x13
+#define AB8500_IT_SOURCE21_REG		0x14
+#define AB8500_IT_SOURCE22_REG		0x15
+#define AB8500_IT_SOURCE23_REG		0x16
+#define AB8500_IT_SOURCE24_REG		0x17
 
 /*
  * latch registers
  */
-#define AB8500_IT_LATCH1_REG		0x0E20
-#define AB8500_IT_LATCH2_REG		0x0E21
-#define AB8500_IT_LATCH3_REG		0x0E22
-#define AB8500_IT_LATCH4_REG		0x0E23
-#define AB8500_IT_LATCH5_REG		0x0E24
-#define AB8500_IT_LATCH6_REG		0x0E25
-#define AB8500_IT_LATCH7_REG		0x0E26
-#define AB8500_IT_LATCH8_REG		0x0E27
-#define AB8500_IT_LATCH9_REG		0x0E28
-#define AB8500_IT_LATCH10_REG		0x0E29
-#define AB8500_IT_LATCH19_REG		0x0E32
-#define AB8500_IT_LATCH20_REG		0x0E33
-#define AB8500_IT_LATCH21_REG		0x0E34
-#define AB8500_IT_LATCH22_REG		0x0E35
-#define AB8500_IT_LATCH23_REG		0x0E36
-#define AB8500_IT_LATCH24_REG		0x0E37
+#define AB8500_IT_LATCH1_REG		0x20
+#define AB8500_IT_LATCH2_REG		0x21
+#define AB8500_IT_LATCH3_REG		0x22
+#define AB8500_IT_LATCH4_REG		0x23
+#define AB8500_IT_LATCH5_REG		0x24
+#define AB8500_IT_LATCH6_REG		0x25
+#define AB8500_IT_LATCH7_REG		0x26
+#define AB8500_IT_LATCH8_REG		0x27
+#define AB8500_IT_LATCH9_REG		0x28
+#define AB8500_IT_LATCH10_REG		0x29
+#define AB8500_IT_LATCH19_REG		0x32
+#define AB8500_IT_LATCH20_REG		0x33
+#define AB8500_IT_LATCH21_REG		0x34
+#define AB8500_IT_LATCH22_REG		0x35
+#define AB8500_IT_LATCH23_REG		0x36
+#define AB8500_IT_LATCH24_REG		0x37
 
 /*
  * mask registers
  */
 
-#define AB8500_IT_MASK1_REG		0x0E40
-#define AB8500_IT_MASK2_REG		0x0E41
-#define AB8500_IT_MASK3_REG		0x0E42
-#define AB8500_IT_MASK4_REG		0x0E43
-#define AB8500_IT_MASK5_REG		0x0E44
-#define AB8500_IT_MASK6_REG		0x0E45
-#define AB8500_IT_MASK7_REG		0x0E46
-#define AB8500_IT_MASK8_REG		0x0E47
-#define AB8500_IT_MASK9_REG		0x0E48
-#define AB8500_IT_MASK10_REG		0x0E49
-#define AB8500_IT_MASK11_REG		0x0E4A
-#define AB8500_IT_MASK12_REG		0x0E4B
-#define AB8500_IT_MASK13_REG		0x0E4C
-#define AB8500_IT_MASK14_REG		0x0E4D
-#define AB8500_IT_MASK15_REG		0x0E4E
-#define AB8500_IT_MASK16_REG		0x0E4F
-#define AB8500_IT_MASK17_REG		0x0E50
-#define AB8500_IT_MASK18_REG		0x0E51
-#define AB8500_IT_MASK19_REG		0x0E52
-#define AB8500_IT_MASK20_REG		0x0E53
-#define AB8500_IT_MASK21_REG		0x0E54
-#define AB8500_IT_MASK22_REG		0x0E55
-#define AB8500_IT_MASK23_REG		0x0E56
-#define AB8500_IT_MASK24_REG		0x0E57
-
-#define AB8500_REV_REG			0x1080
+#define AB8500_IT_MASK1_REG		0x40
+#define AB8500_IT_MASK2_REG		0x41
+#define AB8500_IT_MASK3_REG		0x42
+#define AB8500_IT_MASK4_REG		0x43
+#define AB8500_IT_MASK5_REG		0x44
+#define AB8500_IT_MASK6_REG		0x45
+#define AB8500_IT_MASK7_REG		0x46
+#define AB8500_IT_MASK8_REG		0x47
+#define AB8500_IT_MASK9_REG		0x48
+#define AB8500_IT_MASK10_REG		0x49
+#define AB8500_IT_MASK11_REG		0x4A
+#define AB8500_IT_MASK12_REG		0x4B
+#define AB8500_IT_MASK13_REG		0x4C
+#define AB8500_IT_MASK14_REG		0x4D
+#define AB8500_IT_MASK15_REG		0x4E
+#define AB8500_IT_MASK16_REG		0x4F
+#define AB8500_IT_MASK17_REG		0x50
+#define AB8500_IT_MASK18_REG		0x51
+#define AB8500_IT_MASK19_REG		0x52
+#define AB8500_IT_MASK20_REG		0x53
+#define AB8500_IT_MASK21_REG		0x54
+#define AB8500_IT_MASK22_REG		0x55
+#define AB8500_IT_MASK23_REG		0x56
+#define AB8500_IT_MASK24_REG		0x57
+
+#define AB8500_REV_REG			0x80
 
 /*
  * Map interrupt numbers to the LATCH and MASK register offsets, Interrupt
@@ -99,96 +101,132 @@ static const int ab8500_irq_regoffset[AB8500_NUM_IRQ_REGS] = {
 	0, 1, 2, 3, 4, 6, 7, 8, 9, 18, 19, 20, 21,
 };
 
-static int __ab8500_write(struct ab8500 *ab8500, u16 addr, u8 data)
+static int ab8500_get_chip_id(struct device *dev)
+{
+	struct ab8500 *ab8500 = dev_get_drvdata(dev->parent);
+	return (int)ab8500->chip_id;
+}
+
+static int set_register_interruptible(struct ab8500 *ab8500, u8 bank,
+	u8 reg, u8 data)
 {
 	int ret;
+	/*
+	 * Put the u8 bank and u8 register together into a an u16.
+	 * The bank on higher 8 bits and register in lower 8 bits.
+	 * */
+	u16 addr = ((u16)bank) << 8 | reg;
 
 	dev_vdbg(ab8500->dev, "wr: addr %#x <= %#x\n", addr, data);
 
+	ret = mutex_lock_interruptible(&ab8500->lock);
+	if (ret)
+		return ret;
+
 	ret = ab8500->write(ab8500, addr, data);
 	if (ret < 0)
 		dev_err(ab8500->dev, "failed to write reg %#x: %d\n",
 			addr, ret);
+	mutex_unlock(&ab8500->lock);
 
 	return ret;
 }
 
-/**
- * ab8500_write() - write an AB8500 register
- * @ab8500: device to write to
- * @addr: address of the register
- * @data: value to write
- */
-int ab8500_write(struct ab8500 *ab8500, u16 addr, u8 data)
+static int ab8500_set_register(struct device *dev, u8 bank,
+	u8 reg, u8 value)
 {
-	int ret;
-
-	mutex_lock(&ab8500->lock);
-	ret = __ab8500_write(ab8500, addr, data);
-	mutex_unlock(&ab8500->lock);
+	struct ab8500 *ab8500 = dev_get_drvdata(dev->parent);
 
-	return ret;
+	return set_register_interruptible(ab8500, bank, reg, value);
 }
-EXPORT_SYMBOL_GPL(ab8500_write);
 
-static int __ab8500_read(struct ab8500 *ab8500, u16 addr)
+static int get_register_interruptible(struct ab8500 *ab8500, u8 bank,
+	u8 reg, u8 *value)
 {
 	int ret;
+	/* put the u8 bank and u8 reg together into a an u16.
+	 * bank on higher 8 bits and reg in lower */
+	u16 addr = ((u16)bank) << 8 | reg;
+
+	ret = mutex_lock_interruptible(&ab8500->lock);
+	if (ret)
+		return ret;
 
 	ret = ab8500->read(ab8500, addr);
 	if (ret < 0)
 		dev_err(ab8500->dev, "failed to read reg %#x: %d\n",
 			addr, ret);
+	else
+		*value = ret;
 
+	mutex_unlock(&ab8500->lock);
 	dev_vdbg(ab8500->dev, "rd: addr %#x => data %#x\n", addr, ret);
 
 	return ret;
 }
 
-/**
- * ab8500_read() - read an AB8500 register
- * @ab8500: device to read from
- * @addr: address of the register
- */
-int ab8500_read(struct ab8500 *ab8500, u16 addr)
+static int ab8500_get_register(struct device *dev, u8 bank,
+	u8 reg, u8 *value)
 {
-	int ret;
-
-	mutex_lock(&ab8500->lock);
-	ret = __ab8500_read(ab8500, addr);
-	mutex_unlock(&ab8500->lock);
+	struct ab8500 *ab8500 = dev_get_drvdata(dev->parent);
 
-	return ret;
+	return get_register_interruptible(ab8500, bank, reg, value);
 }
-EXPORT_SYMBOL_GPL(ab8500_read);
-
-/**
- * ab8500_set_bits() - set a bitfield in an AB8500 register
- * @ab8500: device to read from
- * @addr: address of the register
- * @mask: mask of the bitfield to modify
- * @data: value to set to the bitfield
- */
-int ab8500_set_bits(struct ab8500 *ab8500, u16 addr, u8 mask, u8 data)
+
+static int mask_and_set_register_interruptible(struct ab8500 *ab8500, u8 bank,
+	u8 reg, u8 bitmask, u8 bitvalues)
 {
 	int ret;
+	u8 data;
+	/* put the u8 bank and u8 reg together into a an u16.
+	 * bank on higher 8 bits and reg in lower */
+	u16 addr = ((u16)bank) << 8 | reg;
 
-	mutex_lock(&ab8500->lock);
+	ret = mutex_lock_interruptible(&ab8500->lock);
+	if (ret)
+		return ret;
 
-	ret = __ab8500_read(ab8500, addr);
-	if (ret < 0)
+	ret = ab8500->read(ab8500, addr);
+	if (ret < 0) {
+		dev_err(ab8500->dev, "failed to read reg %#x: %d\n",
+			addr, ret);
 		goto out;
+	}
 
-	ret &= ~mask;
-	ret |= data;
+	data = (u8)ret;
+	data = (~bitmask & data) | (bitmask & bitvalues);
 
-	ret = __ab8500_write(ab8500, addr, ret);
+	ret = ab8500->write(ab8500, addr, data);
+	if (ret < 0)
+		dev_err(ab8500->dev, "failed to write reg %#x: %d\n",
+			addr, ret);
 
+	dev_vdbg(ab8500->dev, "mask: addr %#x => data %#x\n", addr, data);
 out:
 	mutex_unlock(&ab8500->lock);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(ab8500_set_bits);
+
+static int ab8500_mask_and_set_register(struct device *dev,
+	u8 bank, u8 reg, u8 bitmask, u8 bitvalues)
+{
+	struct ab8500 *ab8500 = dev_get_drvdata(dev->parent);
+
+	return mask_and_set_register_interruptible(ab8500, bank, reg,
+		bitmask, bitvalues);
+
+}
+
+static struct abx500_ops ab8500_ops = {
+	.get_chip_id = ab8500_get_chip_id,
+	.get_register = ab8500_get_register,
+	.set_register = ab8500_set_register,
+	.get_register_page = NULL,
+	.set_register_page = NULL,
+	.mask_and_set_register = ab8500_mask_and_set_register,
+	.event_registers_startup_state_get = NULL,
+	.startup_irq_enabled = NULL,
+};
 
 static void ab8500_irq_lock(unsigned int irq)
 {
@@ -213,7 +251,7 @@ static void ab8500_irq_sync_unlock(unsigned int irq)
 		ab8500->oldmask[i] = new;
 
 		reg = AB8500_IT_MASK1_REG + ab8500_irq_regoffset[i];
-		ab8500_write(ab8500, reg, new);
+		set_register_interruptible(ab8500, AB8500_INTERRUPT, reg, new);
 	}
 
 	mutex_unlock(&ab8500->irq_lock);
@@ -257,9 +295,11 @@ static irqreturn_t ab8500_irq(int irq, void *dev)
 	for (i = 0; i < AB8500_NUM_IRQ_REGS; i++) {
 		int regoffset = ab8500_irq_regoffset[i];
 		int status;
+		u8 value;
 
-		status = ab8500_read(ab8500, AB8500_IT_LATCH1_REG + regoffset);
-		if (status <= 0)
+		status = get_register_interruptible(ab8500, AB8500_INTERRUPT,
+			AB8500_IT_LATCH1_REG + regoffset, &value);
+		if (status < 0 || value == 0)
 			continue;
 
 		do {
@@ -267,8 +307,8 @@ static irqreturn_t ab8500_irq(int irq, void *dev)
 			int line = i * 8 + bit;
 
 			handle_nested_irq(ab8500->irq_base + line);
-			status &= ~(1 << bit);
-		} while (status);
+			value &= ~(1 << bit);
+		} while (value);
 	}
 
 	return IRQ_HANDLED;
@@ -339,6 +379,11 @@ static struct resource ab8500_rtc_resources[] = {
 };
 
 static struct mfd_cell ab8500_devs[] = {
+#ifdef CONFIG_DEBUG_FS
+	{
+		.name = "ab8500-debug",
+	},
+#endif
 	{
 		.name = "ab8500-gpadc",
 		.num_resources = ARRAY_SIZE(ab8500_gpadc_resources),
@@ -361,6 +406,7 @@ int __devinit ab8500_init(struct ab8500 *ab8500)
 	struct ab8500_platform_data *plat = dev_get_platdata(ab8500->dev);
 	int ret;
 	int i;
+	u8 value;
 
 	if (plat)
 		ab8500->irq_base = plat->irq_base;
@@ -368,7 +414,8 @@ int __devinit ab8500_init(struct ab8500 *ab8500)
 	mutex_init(&ab8500->lock);
 	mutex_init(&ab8500->irq_lock);
 
-	ret = ab8500_read(ab8500, AB8500_REV_REG);
+	ret = get_register_interruptible(ab8500, AB8500_MISC,
+		AB8500_REV_REG, &value);
 	if (ret < 0)
 		return ret;
 
@@ -377,28 +424,37 @@ int __devinit ab8500_init(struct ab8500 *ab8500)
 	 * 0x10 - Cut 1.0
 	 * 0x11 - Cut 1.1
 	 */
-	if (ret == 0x0 || ret == 0x10 || ret == 0x11) {
-		ab8500->revision = ret;
-		dev_info(ab8500->dev, "detected chip, revision: %#x\n", ret);
+	if (value == 0x0 || value == 0x10 || value == 0x11) {
+		ab8500->revision = value;
+		dev_info(ab8500->dev, "detected chip, revision: %#x\n", value);
 	} else {
-		dev_err(ab8500->dev, "unknown chip, revision: %#x\n", ret);
+		dev_err(ab8500->dev, "unknown chip, revision: %#x\n", value);
 		return -EINVAL;
 	}
+	ab8500->chip_id = value;
 
 	if (plat && plat->init)
 		plat->init(ab8500);
 
 	/* Clear and mask all interrupts */
 	for (i = 0; i < 10; i++) {
-		ab8500_read(ab8500, AB8500_IT_LATCH1_REG + i);
-		ab8500_write(ab8500, AB8500_IT_MASK1_REG + i, 0xff);
+		get_register_interruptible(ab8500, AB8500_INTERRUPT,
+			AB8500_IT_LATCH1_REG + i, &value);
+		set_register_interruptible(ab8500, AB8500_INTERRUPT,
+			AB8500_IT_MASK1_REG + i, 0xff);
 	}
 
 	for (i = 18; i < 24; i++) {
-		ab8500_read(ab8500, AB8500_IT_LATCH1_REG + i);
-		ab8500_write(ab8500, AB8500_IT_MASK1_REG + i, 0xff);
+		get_register_interruptible(ab8500, AB8500_INTERRUPT,
+			AB8500_IT_LATCH1_REG + i, &value);
+		set_register_interruptible(ab8500, AB8500_INTERRUPT,
+			AB8500_IT_MASK1_REG + i, 0xff);
 	}
 
+	ret = abx500_register_ops(ab8500->dev, &ab8500_ops);
+	if (ret)
+		return ret;
+
 	for (i = 0; i < AB8500_NUM_IRQ_REGS; i++)
 		ab8500->mask[i] = ab8500->oldmask[i] = 0xff;
 
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 3d09580..c9cef04 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -21,6 +21,7 @@
 #include <linux/err.h>
 #include <linux/platform_device.h>
 #include <linux/mfd/ab8500.h>
+#include <linux/mfd/abx500.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/ab8500.h>
@@ -33,9 +34,11 @@
  * @max_uV: maximum voltage (for variable voltage supplies)
  * @min_uV: minimum voltage (for variable voltage supplies)
  * @fixed_uV: typical voltage (for fixed voltage supplies)
+ * @update_bank: bank to control on/off
  * @update_reg: register to control on/off
  * @mask: mask to enable/disable regulator
  * @enable: bits to enable the regulator in normal(high power) mode
+ * @voltage_bank: bank to control regulator voltage
  * @voltage_reg: register to control regulator voltage
  * @voltage_mask: mask to control regulator voltage
  * @supported_voltages: supported voltage table
@@ -49,11 +52,13 @@ struct ab8500_regulator_info {
 	int max_uV;
 	int min_uV;
 	int fixed_uV;
-	int update_reg;
-	int mask;
-	int enable;
-	int voltage_reg;
-	int voltage_mask;
+	u8 update_bank;
+	u8 update_reg;
+	u8 mask;
+	u8 enable;
+	u8 voltage_bank;
+	u8 voltage_reg;
+	u8 voltage_mask;
 	int const *supported_voltages;
 	int voltages_len;
 };
@@ -97,8 +102,8 @@ static int ab8500_regulator_enable(struct regulator_dev *rdev)
 	if (regulator_id >= AB8500_NUM_REGULATORS)
 		return -EINVAL;
 
-	ret = ab8500_set_bits(info->ab8500, info->update_reg,
-			info->mask, info->enable);
+	ret = abx500_mask_and_set_register_interruptible(info->dev,
+		info->update_bank, info->update_reg, info->mask, info->enable);
 	if (ret < 0)
 		dev_err(rdev_get_dev(rdev),
 			"couldn't set enable bits for regulator\n");
@@ -114,8 +119,8 @@ static int ab8500_regulator_disable(struct regulator_dev *rdev)
 	if (regulator_id >= AB8500_NUM_REGULATORS)
 		return -EINVAL;
 
-	ret = ab8500_set_bits(info->ab8500, info->update_reg,
-			info->mask, 0x0);
+	ret = abx500_mask_and_set_register_interruptible(info->dev,
+		info->update_bank, info->update_reg, info->mask, 0x0);
 	if (ret < 0)
 		dev_err(rdev_get_dev(rdev),
 			"couldn't set disable bits for regulator\n");
@@ -126,19 +131,21 @@ static int ab8500_regulator_is_enabled(struct regulator_dev *rdev)
 {
 	int regulator_id, ret;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
+	u8 value;
 
 	regulator_id = rdev_get_id(rdev);
 	if (regulator_id >= AB8500_NUM_REGULATORS)
 		return -EINVAL;
 
-	ret = ab8500_read(info->ab8500, info->update_reg);
+	ret = abx500_get_register_interruptible(info->dev,
+		info->update_bank, info->update_reg, &value);
 	if (ret < 0) {
 		dev_err(rdev_get_dev(rdev),
 			"couldn't read 0x%x register\n", info->update_reg);
 		return ret;
 	}
 
-	if (ret & info->mask)
+	if (value & info->mask)
 		return true;
 	else
 		return false;
@@ -165,14 +172,16 @@ static int ab8500_list_voltage(struct regulator_dev *rdev, unsigned selector)
 
 static int ab8500_regulator_get_voltage(struct regulator_dev *rdev)
 {
-	int regulator_id, ret, val;
+	int regulator_id, ret;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
+	u8 value;
 
 	regulator_id = rdev_get_id(rdev);
 	if (regulator_id >= AB8500_NUM_REGULATORS)
 		return -EINVAL;
 
-	ret = ab8500_read(info->ab8500, info->voltage_reg);
+	ret = abx500_get_register_interruptible(info->dev, info->voltage_bank,
+		info->voltage_reg, &value);
 	if (ret < 0) {
 		dev_err(rdev_get_dev(rdev),
 			"couldn't read voltage reg for regulator\n");
@@ -180,11 +189,11 @@ static int ab8500_regulator_get_voltage(struct regulator_dev *rdev)
 	}
 
 	/* vintcore has a different layout */
-	val = ret & info->voltage_mask;
+	value &= info->voltage_mask;
 	if (regulator_id == AB8500_LDO_INTCORE)
-		ret = info->supported_voltages[val >> 0x3];
+		ret = info->supported_voltages[value >> 0x3];
 	else
-		ret = info->supported_voltages[val];
+		ret = info->supported_voltages[value];
 
 	return ret;
 }
@@ -224,8 +233,9 @@ static int ab8500_regulator_set_voltage(struct regulator_dev *rdev,
 	}
 
 	/* set the registers for the request */
-	ret = ab8500_set_bits(info->ab8500, info->voltage_reg,
-				info->voltage_mask, ret);
+	ret = abx500_mask_and_set_register_interruptible(info->dev,
+		info->voltage_bank, info->voltage_reg,
+		info->voltage_mask, (u8)ret);
 	if (ret < 0)
 		dev_err(rdev_get_dev(rdev),
 		"couldn't set voltage reg for regulator\n");
@@ -262,9 +272,9 @@ static struct regulator_ops ab8500_ldo_fixed_ops = {
 	.list_voltage	= ab8500_list_voltage,
 };
 
-#define AB8500_LDO(_id, min, max, reg, reg_mask, reg_enable,	\
-		volt_reg, volt_mask, voltages,			\
-			len_volts)				\
+#define AB8500_LDO(_id, min, max, bank, reg, reg_mask,		\
+		reg_enable, volt_bank, volt_reg, volt_mask,	\
+		voltages, len_volts)				\
 {								\
 	.desc	= {						\
 		.name	= "LDO-" #_id,				\
@@ -275,9 +285,11 @@ static struct regulator_ops ab8500_ldo_fixed_ops = {
 	},							\
 	.min_uV		= (min) * 1000,				\
 	.max_uV		= (max) * 1000,				\
+	.update_bank	= bank,					\
 	.update_reg	= reg,					\
 	.mask		= reg_mask,				\
 	.enable		= reg_enable,				\
+	.voltage_bank	= volt_bank,				\
 	.voltage_reg	= volt_reg,				\
 	.voltage_mask	= volt_mask,				\
 	.supported_voltages = voltages,				\
@@ -285,8 +297,8 @@ static struct regulator_ops ab8500_ldo_fixed_ops = {
 	.fixed_uV	= 0,					\
 }
 
-#define AB8500_FIXED_LDO(_id, fixed, reg, reg_mask,	\
-				reg_enable)		\
+#define AB8500_FIXED_LDO(_id, fixed, bank, reg,		\
+			reg_mask, reg_enable)		\
 {							\
 	.desc	= {					\
 		.name	= "LDO-" #_id,			\
@@ -296,6 +308,7 @@ static struct regulator_ops ab8500_ldo_fixed_ops = {
 		.owner	= THIS_MODULE,			\
 	},						\
 	.fixed_uV	= fixed * 1000,			\
+	.update_bank	= bank,				\
 	.update_reg	= reg,				\
 	.mask		= reg_mask,			\
 	.enable		= reg_enable,			\
@@ -304,28 +317,29 @@ static struct regulator_ops ab8500_ldo_fixed_ops = {
 static struct ab8500_regulator_info ab8500_regulator_info[] = {
 	/*
 	 * Variable Voltage LDOs
-	 * name, min uV, max uV, ctrl reg, reg mask, enable mask,
-	 *	volt ctrl reg, volt ctrl mask, volt table, num supported volts
+	 * name, min uV, max uV, ctrl bank, ctrl reg, reg mask, enable mask,
+	 *      volt ctrl bank, volt ctrl reg, volt ctrl mask, volt table,
+	 *      num supported volts
 	 */
-	AB8500_LDO(AUX1, 1100, 3300, 0x0409, 0x3, 0x1, 0x041f, 0xf,
+	AB8500_LDO(AUX1, 1100, 3300, 0x04, 0x09, 0x3, 0x1, 0x04, 0x1f, 0xf,
 			ldo_vauxn_voltages, ARRAY_SIZE(ldo_vauxn_voltages)),
-	AB8500_LDO(AUX2, 1100, 3300, 0x0409, 0xc, 0x4, 0x0420, 0xf,
+	AB8500_LDO(AUX2, 1100, 3300, 0x04, 0x09, 0xc, 0x4, 0x04, 0x20, 0xf,
 			ldo_vauxn_voltages, ARRAY_SIZE(ldo_vauxn_voltages)),
-	AB8500_LDO(AUX3, 1100, 3300, 0x040a, 0x3, 0x1, 0x0421, 0xf,
+	AB8500_LDO(AUX3, 1100, 3300, 0x04, 0x0a, 0x3, 0x1, 0x04, 0x21, 0xf,
 			ldo_vauxn_voltages, ARRAY_SIZE(ldo_vauxn_voltages)),
-	AB8500_LDO(INTCORE, 1100, 3300, 0x0380, 0x4, 0x4, 0x0380, 0x38,
+	AB8500_LDO(INTCORE, 1100, 3300, 0x03, 0x80, 0x4, 0x4, 0x03, 0x80, 0x38,
 		ldo_vintcore_voltages, ARRAY_SIZE(ldo_vintcore_voltages)),
 
 	/*
 	 * Fixed Voltage LDOs
-	 *		 name,	o/p uV, ctrl reg, enable, disable
+	 *		 name,	o/p uV, ctrl bank, ctrl reg, enable, disable
 	 */
-	AB8500_FIXED_LDO(TVOUT,	  2000,   0x0380,   0x2,    0x2),
-	AB8500_FIXED_LDO(AUDIO,   2000,   0x0383,   0x2,    0x2),
-	AB8500_FIXED_LDO(ANAMIC1, 2050,   0x0383,   0x4,    0x4),
-	AB8500_FIXED_LDO(ANAMIC2, 2050,   0x0383,   0x8,    0x8),
-	AB8500_FIXED_LDO(DMIC,    1800,   0x0383,   0x10,   0x10),
-	AB8500_FIXED_LDO(ANA,     1200,   0x0383,   0xc,    0x4),
+	AB8500_FIXED_LDO(TVOUT,	  2000, 0x03,      0x80,     0x2,    0x2),
+	AB8500_FIXED_LDO(AUDIO,   2000, 0x03,      0x83,     0x2,    0x2),
+	AB8500_FIXED_LDO(ANAMIC1, 2050, 0x03,      0x83,     0x4,    0x4),
+	AB8500_FIXED_LDO(ANAMIC2, 2050, 0x03,      0x83,     0x8,    0x8),
+	AB8500_FIXED_LDO(DMIC,    1800, 0x03,      0x83,     0x10,   0x10),
+	AB8500_FIXED_LDO(ANA,     1200, 0x03,      0x83,     0xc,    0x4),
 };
 
 static inline struct ab8500_regulator_info *find_regulator_info(int id)
diff --git a/drivers/rtc/rtc-ab8500.c b/drivers/rtc/rtc-ab8500.c
index 2fda031..e346705 100644
--- a/drivers/rtc/rtc-ab8500.c
+++ b/drivers/rtc/rtc-ab8500.c
@@ -14,26 +14,26 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/rtc.h>
+#include <linux/mfd/abx500.h>
 #include <linux/mfd/ab8500.h>
 #include <linux/delay.h>
 
-#define AB8500_RTC_SOFF_STAT_REG	0x0F00
-#define AB8500_RTC_CC_CONF_REG		0x0F01
-#define AB8500_RTC_READ_REQ_REG		0x0F02
-#define AB8500_RTC_WATCH_TSECMID_REG	0x0F03
-#define AB8500_RTC_WATCH_TSECHI_REG	0x0F04
-#define AB8500_RTC_WATCH_TMIN_LOW_REG	0x0F05
-#define AB8500_RTC_WATCH_TMIN_MID_REG	0x0F06
-#define AB8500_RTC_WATCH_TMIN_HI_REG	0x0F07
-#define AB8500_RTC_ALRM_MIN_LOW_REG	0x0F08
-#define AB8500_RTC_ALRM_MIN_MID_REG	0x0F09
-#define AB8500_RTC_ALRM_MIN_HI_REG	0x0F0A
-#define AB8500_RTC_STAT_REG		0x0F0B
-#define AB8500_RTC_BKUP_CHG_REG		0x0F0C
-#define AB8500_RTC_FORCE_BKUP_REG	0x0F0D
-#define AB8500_RTC_CALIB_REG		0x0F0E
-#define AB8500_RTC_SWITCH_STAT_REG	0x0F0F
-#define AB8500_REV_REG			0x1080
+#define AB8500_RTC_SOFF_STAT_REG	0x00
+#define AB8500_RTC_CC_CONF_REG		0x01
+#define AB8500_RTC_READ_REQ_REG		0x02
+#define AB8500_RTC_WATCH_TSECMID_REG	0x03
+#define AB8500_RTC_WATCH_TSECHI_REG	0x04
+#define AB8500_RTC_WATCH_TMIN_LOW_REG	0x05
+#define AB8500_RTC_WATCH_TMIN_MID_REG	0x06
+#define AB8500_RTC_WATCH_TMIN_HI_REG	0x07
+#define AB8500_RTC_ALRM_MIN_LOW_REG	0x08
+#define AB8500_RTC_ALRM_MIN_MID_REG	0x09
+#define AB8500_RTC_ALRM_MIN_HI_REG	0x0A
+#define AB8500_RTC_STAT_REG		0x0B
+#define AB8500_RTC_BKUP_CHG_REG		0x0C
+#define AB8500_RTC_FORCE_BKUP_REG	0x0D
+#define AB8500_RTC_CALIB_REG		0x0E
+#define AB8500_RTC_SWITCH_STAT_REG	0x0F
 
 /* RtcReadRequest bits */
 #define RTC_READ_REQUEST		0x01
@@ -46,13 +46,13 @@
 #define COUNTS_PER_SEC			(0xF000 / 60)
 #define AB8500_RTC_EPOCH		2000
 
-static const unsigned long ab8500_rtc_time_regs[] = {
+static const u8 ab8500_rtc_time_regs[] = {
 	AB8500_RTC_WATCH_TMIN_HI_REG, AB8500_RTC_WATCH_TMIN_MID_REG,
 	AB8500_RTC_WATCH_TMIN_LOW_REG, AB8500_RTC_WATCH_TSECHI_REG,
 	AB8500_RTC_WATCH_TSECMID_REG
 };
 
-static const unsigned long ab8500_rtc_alarm_regs[] = {
+static const u8 ab8500_rtc_alarm_regs[] = {
 	AB8500_RTC_ALRM_MIN_HI_REG, AB8500_RTC_ALRM_MIN_MID_REG,
 	AB8500_RTC_ALRM_MIN_LOW_REG
 };
@@ -76,29 +76,30 @@ static unsigned long get_elapsed_seconds(int year)
 
 static int ab8500_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
-	struct ab8500 *ab8500 = dev_get_drvdata(dev->parent);
 	unsigned long timeout = jiffies + HZ;
 	int retval, i;
 	unsigned long mins, secs;
 	unsigned char buf[ARRAY_SIZE(ab8500_rtc_time_regs)];
+	u8 value;
 
 	/* Request a data read */
-	retval = ab8500_write(ab8500, AB8500_RTC_READ_REQ_REG,
-			      RTC_READ_REQUEST);
+	retval = abx500_set_register_interruptible(dev,
+		AB8500_RTC, AB8500_RTC_READ_REQ_REG, RTC_READ_REQUEST);
 	if (retval < 0)
 		return retval;
 
 	/* Early AB8500 chips will not clear the rtc read request bit */
-	if (ab8500->revision == 0) {
+	if (abx500_get_chip_id(dev) == 0) {
 		msleep(1);
 	} else {
 		/* Wait for some cycles after enabling the rtc read in ab8500 */
 		while (time_before(jiffies, timeout)) {
-			retval = ab8500_read(ab8500, AB8500_RTC_READ_REQ_REG);
+			retval = abx500_get_register_interruptible(dev,
+				AB8500_RTC, AB8500_RTC_READ_REQ_REG, &value);
 			if (retval < 0)
 				return retval;
 
-			if (!(retval & RTC_READ_REQUEST))
+			if (!(value & RTC_READ_REQUEST))
 				break;
 
 			msleep(1);
@@ -107,10 +108,11 @@ static int ab8500_rtc_read_time(struct device *dev, struct rtc_time *tm)
 
 	/* Read the Watchtime registers */
 	for (i = 0; i < ARRAY_SIZE(ab8500_rtc_time_regs); i++) {
-		retval = ab8500_read(ab8500, ab8500_rtc_time_regs[i]);
+		retval = abx500_get_register_interruptible(dev,
+			AB8500_RTC, ab8500_rtc_time_regs[i], &value);
 		if (retval < 0)
 			return retval;
-		buf[i] = retval;
+		buf[i] = value;
 	}
 
 	mins = (buf[0] << 16) | (buf[1] << 8) | buf[2];
@@ -128,7 +130,6 @@ static int ab8500_rtc_read_time(struct device *dev, struct rtc_time *tm)
 
 static int ab8500_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
-	struct ab8500 *ab8500 = dev_get_drvdata(dev->parent);
 	int retval, i;
 	unsigned char buf[ARRAY_SIZE(ab8500_rtc_time_regs)];
 	unsigned long no_secs, no_mins, secs = 0;
@@ -162,27 +163,29 @@ static int ab8500_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	buf[0] = (no_mins >> 16) & 0xFF;
 
 	for (i = 0; i < ARRAY_SIZE(ab8500_rtc_time_regs); i++) {
-		retval = ab8500_write(ab8500, ab8500_rtc_time_regs[i], buf[i]);
+		retval = abx500_set_register_interruptible(dev, AB8500_RTC,
+			ab8500_rtc_time_regs[i], buf[i]);
 		if (retval < 0)
 			return retval;
 	}
 
 	/* Request a data write */
-	return ab8500_write(ab8500, AB8500_RTC_READ_REQ_REG, RTC_WRITE_REQUEST);
+	return abx500_set_register_interruptible(dev, AB8500_RTC,
+		AB8500_RTC_READ_REQ_REG, RTC_WRITE_REQUEST);
 }
 
 static int ab8500_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
-	struct ab8500 *ab8500 = dev_get_drvdata(dev->parent);
 	int retval, i;
-	int rtc_ctrl;
+	u8 rtc_ctrl, value;
 	unsigned char buf[ARRAY_SIZE(ab8500_rtc_alarm_regs)];
 	unsigned long secs, mins;
 
 	/* Check if the alarm is enabled or not */
-	rtc_ctrl = ab8500_read(ab8500, AB8500_RTC_STAT_REG);
-	if (rtc_ctrl < 0)
-		return rtc_ctrl;
+	retval = abx500_get_register_interruptible(dev, AB8500_RTC,
+		AB8500_RTC_STAT_REG, &rtc_ctrl);
+	if (retval < 0)
+		return retval;
 
 	if (rtc_ctrl & RTC_ALARM_ENA)
 		alarm->enabled = 1;
@@ -192,10 +195,11 @@ static int ab8500_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	alarm->pending = 0;
 
 	for (i = 0; i < ARRAY_SIZE(ab8500_rtc_alarm_regs); i++) {
-		retval = ab8500_read(ab8500, ab8500_rtc_alarm_regs[i]);
+		retval = abx500_get_register_interruptible(dev, AB8500_RTC,
+			ab8500_rtc_alarm_regs[i], &value);
 		if (retval < 0)
 			return retval;
-		buf[i] = retval;
+		buf[i] = value;
 	}
 
 	mins = (buf[0] << 16) | (buf[1] << 8) | (buf[2]);
@@ -211,15 +215,13 @@ static int ab8500_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 
 static int ab8500_rtc_irq_enable(struct device *dev, unsigned int enabled)
 {
-	struct ab8500 *ab8500 = dev_get_drvdata(dev->parent);
-
-	return ab8500_set_bits(ab8500, AB8500_RTC_STAT_REG, RTC_ALARM_ENA,
-			       enabled ? RTC_ALARM_ENA : 0);
+	return abx500_mask_and_set_register_interruptible(dev, AB8500_RTC,
+		AB8500_RTC_STAT_REG, RTC_ALARM_ENA,
+		enabled ? RTC_ALARM_ENA : 0);
 }
 
 static int ab8500_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
-	struct ab8500 *ab8500 = dev_get_drvdata(dev->parent);
 	int retval, i;
 	unsigned char buf[ARRAY_SIZE(ab8500_rtc_alarm_regs)];
 	unsigned long mins, secs = 0;
@@ -247,7 +249,8 @@ static int ab8500_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 
 	/* Set the alarm time */
 	for (i = 0; i < ARRAY_SIZE(ab8500_rtc_alarm_regs); i++) {
-		retval = ab8500_write(ab8500, ab8500_rtc_alarm_regs[i], buf[i]);
+		retval = abx500_set_register_interruptible(dev, AB8500_RTC,
+			ab8500_rtc_alarm_regs[i], buf[i]);
 		if (retval < 0)
 			return retval;
 	}
@@ -276,10 +279,9 @@ static const struct rtc_class_ops ab8500_rtc_ops = {
 
 static int __devinit ab8500_rtc_probe(struct platform_device *pdev)
 {
-	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
 	int err;
 	struct rtc_device *rtc;
-	int rtc_ctrl;
+	u8 rtc_ctrl;
 	int irq;
 
 	irq = platform_get_irq_byname(pdev, "ALARM");
@@ -287,17 +289,18 @@ static int __devinit ab8500_rtc_probe(struct platform_device *pdev)
 		return irq;
 
 	/* For RTC supply test */
-	err = ab8500_set_bits(ab8500, AB8500_RTC_STAT_REG, RTC_STATUS_DATA,
-			RTC_STATUS_DATA);
+	err = abx500_mask_and_set_register_interruptible(&pdev->dev, AB8500_RTC,
+		AB8500_RTC_STAT_REG, RTC_STATUS_DATA, RTC_STATUS_DATA);
 	if (err < 0)
 		return err;
 
 	/* Wait for reset by the PorRtc */
 	msleep(1);
 
-	rtc_ctrl = ab8500_read(ab8500, AB8500_RTC_STAT_REG);
-	if (rtc_ctrl < 0)
-		return rtc_ctrl;
+	err = abx500_get_register_interruptible(&pdev->dev, AB8500_RTC,
+		AB8500_RTC_STAT_REG, &rtc_ctrl);
+	if (err < 0)
+		return err;
 
 	/* Check if the RTC Supply fails */
 	if (!(rtc_ctrl & RTC_STATUS_DATA)) {
diff --git a/include/linux/mfd/ab8500.h b/include/linux/mfd/ab8500.h
index f5cec45..d63b605 100644
--- a/include/linux/mfd/ab8500.h
+++ b/include/linux/mfd/ab8500.h
@@ -10,6 +10,29 @@
 #include <linux/device.h>
 
 /*
+ * AB8500 bank addresses
+ */
+#define AB8500_SYS_CTRL1_BLOCK	0x1
+#define AB8500_SYS_CTRL2_BLOCK	0x2
+#define AB8500_REGU_CTRL1	0x3
+#define AB8500_REGU_CTRL2	0x4
+#define AB8500_USB		0x5
+#define AB8500_TVOUT		0x6
+#define AB8500_DBI		0x7
+#define AB8500_ECI_AV_ACC	0x8
+#define AB8500_RESERVED		0x9
+#define AB8500_GPADC		0xA
+#define AB8500_CHARGER		0xB
+#define AB8500_GAS_GAUGE	0xC
+#define AB8500_AUDIO		0xD
+#define AB8500_INTERRUPT	0xE
+#define AB8500_RTC		0xF
+#define AB8500_MISC		0x10
+#define AB8500_DEBUG		0x12
+#define AB8500_PROD_TEST	0x13
+#define AB8500_OTP_EMUL		0x15
+
+/*
  * Interrupts
  */
 
@@ -99,6 +122,7 @@ struct ab8500 {
 	int		revision;
 	int		irq_base;
 	int		irq;
+	u8		chip_id;
 
 	int (*write) (struct ab8500 *a8500, u16 addr, u8 data);
 	int (*read) (struct ab8500 *a8500, u16 addr);
@@ -124,10 +148,6 @@ struct ab8500_platform_data {
 	struct regulator_init_data *regulator[AB8500_NUM_REGULATORS];
 };
 
-extern int ab8500_write(struct ab8500 *a8500, u16 addr, u8 data);
-extern int ab8500_read(struct ab8500 *a8500, u16 addr);
-extern int ab8500_set_bits(struct ab8500 *a8500, u16 addr, u8 mask, u8 data);
-
 extern int __devinit ab8500_init(struct ab8500 *ab8500);
 extern int __devexit ab8500_exit(struct ab8500 *ab8500);
 
diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index 390726f..be7373c 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -6,8 +6,7 @@
  *
  * ABX500 core access functions.
  * The abx500 interface is used for the Analog Baseband chip
- * ab3100, ab3550, ab5500 and possibly comming. It is not used for
- * ab4500 and ab8500 since they are another family of chip.
+ * ab3100, ab3550, ab5500, and ab8500.
  *
  * Author: Mattias Wallin <mattias.wallin@stericsson.com>
  * Author: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
-- 
1.6.3.3

