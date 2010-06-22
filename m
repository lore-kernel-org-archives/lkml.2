Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708Ab0FVN4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 09:56:11 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:58469 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758263Ab0FVNzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 09:55:52 -0400
From: Rabin Vincent <rabin.vincent@stericsson.com>
To: <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       <STEricsson_nomadik_linux@list.st.com>, <linus.walleij@stericsson.com>,
       <l.fu@pengutronix.de>, Rabin Vincent <rabin.vincent@stericsson.com>
Subject: [PATCHv2 1/3] mfd: add STMPE I/O Expander support
Date: Tue, 22 Jun 2010 19:25:27 +0530
Message-ID: <1277214929-32240-1-git-send-email-rabin.vincent@stericsson.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100621154514.GA416@pengutronix.de>
References: <20100621154514.GA416@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the STMPE family of I/O Expanders from
STMicroelectronics.  These devices include upto 24 gpios and a varying
selection of blocks, including PWM, keypad, and touchscreen controllers.
This patch adds the MFD core.

Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
---

CHANGELOG (for the whole set)
v1 -> v2:
  - Variant data to support other STMPE* variants
  - Enable/disable API
  - GPIO setup/remove callbacks
  - pdata made optional for GPIO
  - Platform specifies which blocks it wants to use
  - IRQ invert polarity option
  - STMPE811 support (needs testing)

 drivers/mfd/Kconfig         |   12 +
 drivers/mfd/Makefile        |    1 +
 drivers/mfd/stmpe-devices.c |  328 ++++++++++++++++++++++++++
 drivers/mfd/stmpe.c         |  530 +++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/stmpe.h         |  164 +++++++++++++
 include/linux/mfd/stmpe.h   |  154 +++++++++++++
 6 files changed, 1189 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/stmpe-devices.c
 create mode 100644 drivers/mfd/stmpe.c
 create mode 100644 drivers/mfd/stmpe.h
 create mode 100644 include/linux/mfd/stmpe.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 9da0e50..63dce71 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -177,6 +177,18 @@ config TWL4030_CODEC
 	select MFD_CORE
 	default n
 
+config MFD_STMPE
+	bool "Support STMicroelectronics STMPE"
+	depends on I2C=y && GENERIC_HARDIRQS
+	select MFD_CORE
+	help
+	  Support for the STMPE family of I/O Expanders from
+	  STMicroelectronics.
+
+	  This driver provides common support for accessing the device,
+	  additional drivers must be enabled in order to use the
+	  functionality of the device.
+
 config MFD_TC35892
 	bool "Support Toshiba TC35892"
 	depends on I2C=y && GENERIC_HARDIRQS
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index fb503e7..012412a 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_HTC_I2CPLD)	+= htc-i2cpld.o
 obj-$(CONFIG_MFD_DAVINCI_VOICECODEC)	+= davinci_voicecodec.o
 obj-$(CONFIG_MFD_DM355EVM_MSP)	+= dm355evm_msp.o
 
+obj-$(CONFIG_MFD_STMPE)		+= stmpe.o stmpe-devices.o
 obj-$(CONFIG_MFD_TC35892)	+= tc35892.o
 obj-$(CONFIG_MFD_T7L66XB)	+= t7l66xb.o tmio_core.o
 obj-$(CONFIG_MFD_TC6387XB)	+= tc6387xb.o tmio_core.o
diff --git a/drivers/mfd/stmpe-devices.c b/drivers/mfd/stmpe-devices.c
new file mode 100644
index 0000000..fa6934d
--- /dev/null
+++ b/drivers/mfd/stmpe-devices.c
@@ -0,0 +1,328 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License, version 2
+ * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/stmpe.h>
+#include "stmpe.h"
+
+/*
+ * GPIO (all variants)
+ */
+
+static struct resource stmpe_gpio_resources[] = {
+	/* Start and end filled dynamically */
+	{
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct mfd_cell stmpe_gpio_cell = {
+	.name		= "stmpe-gpio",
+	.resources	= stmpe_gpio_resources,
+	.num_resources	= ARRAY_SIZE(stmpe_gpio_resources),
+};
+
+/*
+ * Keypad (1601, 2401, 2403)
+ */
+
+static struct resource stmpe_keypad_resources[] = {
+	{
+		.name	= "KEYPAD",
+		.start	= 0,
+		.end	= 0,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.name	= "KEYPAD_OVER",
+		.start	= 1,
+		.end	= 1,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct mfd_cell stmpe_keypad_cell = {
+	.name		= "stmpe-keypad",
+	.resources	= stmpe_keypad_resources,
+	.num_resources	= ARRAY_SIZE(stmpe_keypad_resources),
+};
+
+/*
+ * Touchscreen (STMPE811)
+ */
+
+static struct resource stmpe_ts_resources[] = {
+	{
+		.name	= "TOUCH_DET",
+		.start	= 0,
+		.end	= 0,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.name	= "FIFO_TH",
+		.start	= 1,
+		.end	= 1,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct mfd_cell stmpe_ts_cell = {
+	.name		= "stmpe-ts",
+	.resources	= stmpe_ts_resources,
+	.num_resources	= ARRAY_SIZE(stmpe_ts_resources),
+};
+
+/*
+ * STMPE811
+ */
+
+static const u8 stmpe811_regs[] = {
+	[STMPE_IDX_CHIP_ID]	= STMPE811_REG_CHIP_ID,
+	[STMPE_IDX_ICR_LSB]	= STMPE811_REG_INT_CTRL,
+	[STMPE_IDX_IER_LSB]	= STMPE811_REG_INT_EN,
+	[STMPE_IDX_ISR_MSB]	= STMPE811_REG_INT_STA,
+	[STMPE_IDX_GPMR_LSB]	= STMPE811_REG_GPIO_MP_STA,
+	[STMPE_IDX_GPSR_LSB]	= STMPE811_REG_GPIO_SET_PIN,
+	[STMPE_IDX_GPCR_LSB]	= STMPE811_REG_GPIO_CLR_PIN,
+	[STMPE_IDX_GPDR_LSB]	= STMPE811_REG_GPIO_DIR,
+	[STMPE_IDX_GPRER_LSB]	= STMPE811_REG_GPIO_RE,
+	[STMPE_IDX_GPFER_LSB]	= STMPE811_REG_GPIO_FE,
+	[STMPE_IDX_GPAFR_U_MSB]	= STMPE811_REG_GPIO_AF,
+	[STMPE_IDX_IEGPIOR_LSB]	= STMPE811_REG_GPIO_INT_EN,
+	[STMPE_IDX_ISGPIOR_MSB]	= STMPE811_REG_GPIO_INT_STA,
+	[STMPE_IDX_GPEDR_MSB]	= STMPE811_REG_GPIO_ED,
+};
+
+static struct stmpe_variant_block stmpe811_blocks[] = {
+	{
+		.cell	= &stmpe_gpio_cell,
+		.irq	= STMPE811_IRQ_GPIOC,
+		.block	= STMPE_BLOCK_GPIO,
+	},
+	{
+		.cell	= &stmpe_ts_cell,
+		.irq	= STMPE811_IRQ_TOUCH_DET,
+		.block	= STMPE_BLOCK_TOUCHSCREEN,
+	},
+};
+
+static int stmpe811_enable(struct stmpe *stmpe, unsigned int blocks,
+			   bool enable)
+{
+	unsigned int mask = 0;
+
+	if (blocks & STMPE_BLOCK_GPIO)
+		mask |= STMPE811_SYS_CTRL2_GPIO_OFF;
+
+	if (blocks & STMPE_BLOCK_ADC)
+		mask |= STMPE811_SYS_CTRL2_ADC_OFF;
+
+	if (blocks & STMPE_BLOCK_KEYPAD)
+		mask |= STMPE811_SYS_CTRL2_TSC_OFF;
+
+	return stmpe_set_bits(stmpe, STMPE811_REG_SYS_CTRL2, mask,
+			      enable ? 0 : mask);
+}
+
+static int stmpe811_get_altfunc(struct stmpe *stmpe, enum stmpe_block block)
+{
+	/* 0 for touchscreen, 1 for GPIO */
+	return block != STMPE_BLOCK_TOUCHSCREEN;
+}
+
+static struct stmpe_variant_info stmpe811 = {
+	.name		= "stmpe811",
+	.id_val		= 0x0811,
+	.id_mask	= 0xffff,
+	.num_gpios	= 8,
+	.af_bits	= 1,
+	.regs		= stmpe811_regs,
+	.blocks		= stmpe811_blocks,
+	.num_blocks	= ARRAY_SIZE(stmpe811_blocks),
+	.num_irqs	= STMPE811_NR_INTERNAL_IRQS,
+	.enable		= stmpe811_enable,
+	.get_altfunc	= stmpe811_get_altfunc,
+};
+
+/*
+ * STMPE1601
+ */
+
+static const u8 stmpe1601_regs[] = {
+	[STMPE_IDX_CHIP_ID]	= STMPE1601_REG_CHIP_ID,
+	[STMPE_IDX_ICR_LSB]	= STMPE1601_REG_ICR_LSB,
+	[STMPE_IDX_IER_LSB]	= STMPE1601_REG_IER_LSB,
+	[STMPE_IDX_ISR_MSB]	= STMPE1601_REG_ISR_MSB,
+	[STMPE_IDX_GPMR_LSB]	= STMPE1601_REG_GPIO_MP_LSB,
+	[STMPE_IDX_GPSR_LSB]	= STMPE1601_REG_GPIO_SET_LSB,
+	[STMPE_IDX_GPCR_LSB]	= STMPE1601_REG_GPIO_CLR_LSB,
+	[STMPE_IDX_GPDR_LSB]	= STMPE1601_REG_GPIO_SET_DIR_LSB,
+	[STMPE_IDX_GPRER_LSB]	= STMPE1601_REG_GPIO_RE_LSB,
+	[STMPE_IDX_GPFER_LSB]	= STMPE1601_REG_GPIO_FE_LSB,
+	[STMPE_IDX_GPAFR_U_MSB]	= STMPE1601_REG_GPIO_AF_U_MSB,
+	[STMPE_IDX_IEGPIOR_LSB]	= STMPE1601_REG_INT_EN_GPIO_MASK_LSB,
+	[STMPE_IDX_ISGPIOR_MSB]	= STMPE1601_REG_INT_STA_GPIO_MSB,
+	[STMPE_IDX_GPEDR_MSB]	= STMPE1601_REG_GPIO_ED_MSB,
+};
+
+static struct stmpe_variant_block stmpe1601_blocks[] = {
+	{
+		.cell	= &stmpe_gpio_cell,
+		.irq	= STMPE24XX_IRQ_GPIOC,
+		.block	= STMPE_BLOCK_GPIO,
+	},
+	{
+		.cell	= &stmpe_keypad_cell,
+		.irq	= STMPE24XX_IRQ_KEYPAD,
+		.block	= STMPE_BLOCK_KEYPAD,
+	},
+};
+
+static int stmpe1601_enable(struct stmpe *stmpe, unsigned int blocks,
+			    bool enable)
+{
+	unsigned int mask = 0;
+
+	if (blocks & STMPE_BLOCK_GPIO)
+		mask |= STMPE1601_SYS_CTRL_ENABLE_GPIO;
+
+	if (blocks & STMPE_BLOCK_KEYPAD)
+		mask |= STMPE1601_SYS_CTRL_ENABLE_KPC;
+
+	return stmpe_set_bits(stmpe, STMPE1601_REG_SYS_CTRL, mask,
+			      enable ? mask : 0);
+}
+
+static int stmpe1601_get_altfunc(struct stmpe *stmpe, enum stmpe_block block)
+{
+	switch (block) {
+	case STMPE_BLOCK_PWM:
+		return 2;
+
+	case STMPE_BLOCK_KEYPAD:
+		return 1;
+
+	case STMPE_BLOCK_GPIO:
+	default:
+		return 0;
+	}
+}
+
+static struct stmpe_variant_info stmpe1601 = {
+	.name		= "stmpe1601",
+	.id_val		= 0x0210,
+	.id_mask	= 0xfff0,	/* at least 0x0210 and 0x0212 */
+	.num_gpios	= 16,
+	.af_bits	= 2,
+	.regs		= stmpe1601_regs,
+	.blocks		= stmpe1601_blocks,
+	.num_blocks	= ARRAY_SIZE(stmpe1601_blocks),
+	.num_irqs	= STMPE1601_NR_INTERNAL_IRQS,
+	.enable		= stmpe1601_enable,
+	.get_altfunc	= stmpe1601_get_altfunc,
+};
+
+/*
+ * STMPE24XX
+ */
+
+static const u8 stmpe24xx_regs[] = {
+	[STMPE_IDX_CHIP_ID]	= STMPE24XX_REG_CHIP_ID,
+	[STMPE_IDX_ICR_LSB]	= STMPE24XX_REG_ICR_LSB,
+	[STMPE_IDX_IER_LSB]	= STMPE24XX_REG_IER_LSB,
+	[STMPE_IDX_ISR_MSB]	= STMPE24XX_REG_ISR_MSB,
+	[STMPE_IDX_GPMR_LSB]	= STMPE24XX_REG_GPMR_LSB,
+	[STMPE_IDX_GPSR_LSB]	= STMPE24XX_REG_GPSR_LSB,
+	[STMPE_IDX_GPCR_LSB]	= STMPE24XX_REG_GPCR_LSB,
+	[STMPE_IDX_GPDR_LSB]	= STMPE24XX_REG_GPDR_LSB,
+	[STMPE_IDX_GPRER_LSB]	= STMPE24XX_REG_GPRER_LSB,
+	[STMPE_IDX_GPFER_LSB]	= STMPE24XX_REG_GPFER_LSB,
+	[STMPE_IDX_GPAFR_U_MSB]	= STMPE24XX_REG_GPAFR_U_MSB,
+	[STMPE_IDX_IEGPIOR_LSB]	= STMPE24XX_REG_IEGPIOR_LSB,
+	[STMPE_IDX_ISGPIOR_MSB]	= STMPE24XX_REG_ISGPIOR_MSB,
+	[STMPE_IDX_GPEDR_MSB]	= STMPE24XX_REG_GPEDR_MSB,
+};
+
+static struct stmpe_variant_block stmpe24xx_blocks[] = {
+	{
+		.cell	= &stmpe_gpio_cell,
+		.irq	= STMPE24XX_IRQ_GPIOC,
+		.block	= STMPE_BLOCK_GPIO,
+	},
+	{
+		.cell	= &stmpe_keypad_cell,
+		.irq	= STMPE24XX_IRQ_KEYPAD,
+		.block	= STMPE_BLOCK_KEYPAD,
+	},
+};
+
+static int stmpe24xx_enable(struct stmpe *stmpe, unsigned int blocks,
+			    bool enable)
+{
+	unsigned int mask = 0;
+
+	if (blocks & STMPE_BLOCK_GPIO)
+		mask |= STMPE24XX_SYS_CTRL_ENABLE_GPIO;
+
+	if (blocks & STMPE_BLOCK_KEYPAD)
+		mask |= STMPE24XX_SYS_CTRL_ENABLE_KPC;
+
+	return stmpe_set_bits(stmpe, STMPE24XX_REG_SYS_CTRL, mask,
+			      enable ? mask : 0);
+}
+
+static int stmpe24xx_get_altfunc(struct stmpe *stmpe, enum stmpe_block block)
+{
+	switch (block) {
+	case STMPE_BLOCK_ROTATOR:
+		return 2;
+
+	case STMPE_BLOCK_KEYPAD:
+		return 1;
+
+	case STMPE_BLOCK_GPIO:
+	default:
+		return 0;
+	}
+}
+
+static struct stmpe_variant_info stmpe2401 = {
+	.name		= "stmpe2401",
+	.id_val		= 0x0101,
+	.id_mask	= 0xffff,
+	.num_gpios	= 24,
+	.af_bits	= 2,
+	.regs		= stmpe24xx_regs,
+	.blocks		= stmpe24xx_blocks,
+	.num_blocks	= ARRAY_SIZE(stmpe24xx_blocks),
+	.num_irqs	= STMPE24XX_NR_INTERNAL_IRQS,
+	.enable		= stmpe24xx_enable,
+	.get_altfunc	= stmpe24xx_get_altfunc,
+};
+
+static struct stmpe_variant_info stmpe2403 = {
+	.name		= "stmpe2403",
+	.id_val		= 0x0120,
+	.id_mask	= 0xffff,
+	.num_gpios	= 24,
+	.af_bits	= 2,
+	.regs		= stmpe24xx_regs,
+	.blocks		= stmpe24xx_blocks,
+	.num_blocks	= ARRAY_SIZE(stmpe24xx_blocks),
+	.num_irqs	= STMPE24XX_NR_INTERNAL_IRQS,
+	.enable		= stmpe24xx_enable,
+	.get_altfunc	= stmpe24xx_get_altfunc,
+};
+
+struct stmpe_variant_info *stmpe_variant_info[] = {
+	[STMPE811]	= &stmpe811,
+	[STMPE1601]	= &stmpe1601,
+	[STMPE2401]	= &stmpe2401,
+	[STMPE2403]	= &stmpe2403,
+};
diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
new file mode 100644
index 0000000..dc938f6
--- /dev/null
+++ b/drivers/mfd/stmpe.c
@@ -0,0 +1,530 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License, version 2
+ * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/stmpe.h>
+#include "stmpe.h"
+
+/**
+ * stmpe_enable - enable blocks on an STMPE device
+ * @stmpe:	Device to work on
+ * @blocks:	Mask of blocks (enum stmpe_block values) to enable
+ */
+int stmpe_enable(struct stmpe *stmpe, unsigned int blocks)
+{
+	return stmpe->variant->enable(stmpe, blocks, true);
+}
+EXPORT_SYMBOL_GPL(stmpe_enable);
+
+/**
+ * stmpe_disable - disable blocks on an STMPE device
+ * @stmpe:	Device to work on
+ * @blocks:	Mask of blocks (enum stmpe_block values) to enable
+ */
+int stmpe_disable(struct stmpe *stmpe, unsigned int blocks)
+{
+	return stmpe->variant->enable(stmpe, blocks, false);
+}
+EXPORT_SYMBOL_GPL(stmpe_disable);
+
+/**
+ * stmpe_reg_read() - read a single STMPE register
+ * @stmpe:	Device to read from
+ * @reg:	Register to read
+ */
+int stmpe_reg_read(struct stmpe *stmpe, u8 reg)
+{
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(stmpe->i2c, reg);
+	if (ret < 0)
+		dev_err(stmpe->dev, "failed to read reg %#x: %d\n",
+			reg, ret);
+
+	dev_vdbg(stmpe->dev, "rd: reg %#x => data %#x\n", reg, ret);
+
+	return ret;
+}
+EXPORT_SYMBOL(stmpe_reg_read);
+
+/**
+ * stmpe_reg_write() - write a single STMPE register
+ * @stmpe:	Device to write to
+ * @reg:	Register to write
+ * @val:	Value to write
+ */
+int stmpe_reg_write(struct stmpe *stmpe, u8 reg, u8 val)
+{
+	int ret;
+
+	dev_vdbg(stmpe->dev, "wr: reg %#x <= %#x\n", reg, val);
+
+	ret = i2c_smbus_write_byte_data(stmpe->i2c, reg, val);
+	if (ret < 0)
+		dev_err(stmpe->dev, "failed to write reg %#x: %d\n",
+			reg, ret);
+
+	return ret;
+}
+EXPORT_SYMBOL(stmpe_reg_write);
+
+/**
+ * stmpe_set_bits() - set the value of a bitfield in a STMPE register
+ * @stmpe:	Device to write to
+ * @reg:	Register to write
+ * @mask:	Mask of bits to set
+ * @val:	Value to set
+ */
+int stmpe_set_bits(struct stmpe *stmpe, u8 reg, u8 mask, u8 val)
+{
+	int ret;
+
+	mutex_lock(&stmpe->lock);
+
+	ret = stmpe_reg_read(stmpe, reg);
+	if (ret < 0)
+		goto out;
+
+	ret &= ~mask;
+	ret |= val;
+
+	ret = stmpe_reg_write(stmpe, reg, ret);
+
+out:
+	mutex_unlock(&stmpe->lock);
+	return ret;
+}
+EXPORT_SYMBOL(stmpe_set_bits);
+
+/**
+ * stmpe_block_read() - read multiple STMPE registers
+ * @stmpe:	Device to read from
+ * @reg:	First register
+ * @length:	Number of registers
+ * @values:	Buffer to write to
+ */
+int stmpe_block_read(struct stmpe *stmpe, u8 reg, u8 length, u8 *values)
+{
+	int ret;
+
+	ret = i2c_smbus_read_i2c_block_data(stmpe->i2c, reg, length, values);
+	if (ret < 0)
+		dev_err(stmpe->dev, "failed to read regs %#x: %d\n",
+			reg, ret);
+
+	dev_vdbg(stmpe->dev, "rd: reg %#x (%d) => ret %#x\n", reg, length, ret);
+#ifdef VERBOSE_DEBUG
+	print_hex_dump_bytes("stmpe rd: ", DUMP_PREFIX_OFFSET, values, length);
+#endif
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(stmpe_block_read);
+
+/**
+ * stmpe_block_write() - write multiple STMPE registers
+ * @stmpe:	Device to write to
+ * @reg:	First register
+ * @length:	Number of registers
+ * @values:	Values to write
+ */
+int stmpe_block_write(struct stmpe *stmpe, u8 reg, u8 length,
+			const u8 *values)
+{
+	int ret;
+
+	dev_vdbg(stmpe->dev, "wr: regs %#x (%d)\n", reg, length);
+#ifdef VERBOSE_DEBUG
+	print_hex_dump_bytes("stmpe wr: ", DUMP_PREFIX_OFFSET, values, length);
+#endif
+
+	ret = i2c_smbus_write_i2c_block_data(stmpe->i2c, reg, length,
+					     values);
+	if (ret < 0)
+		dev_err(stmpe->dev, "failed to write regs %#x: %d\n",
+			reg, ret);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(stmpe_block_write);
+
+/**
+ * stmpe_set_altfunc: set the alternate function for STMPE pins
+ * @stmpe:	Device to configure
+ * @pins:	Bitmask of pins to affect
+ * @block:	block to enable alternate functions for
+ *
+ * @pins is assumed to have a bit set for each of the bits whose alternate
+ * function is to be changed, numbered according to the GPIOXY numbers.
+ *
+ * If the GPIO module is not enabled, this function automatically enables it in
+ * order to perform the change.
+ */
+int stmpe_set_altfunc(struct stmpe *stmpe, u32 pins, enum stmpe_block block)
+{
+	struct stmpe_variant_info *variant = stmpe->variant;
+	u8 regaddr = stmpe->regs[STMPE_IDX_GPAFR_U_MSB];
+	int af_bits = variant->af_bits;
+	int numregs = DIV_ROUND_UP(stmpe->num_gpios * af_bits, 8);
+	int afperreg = 8 / af_bits;
+	int mask = (1 << af_bits) - 1;
+	u8 regs[numregs];
+	int af;
+	int ret;
+
+	ret = stmpe_enable(stmpe, STMPE_BLOCK_GPIO);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&stmpe->lock);
+
+	ret = stmpe_block_read(stmpe, regaddr, numregs, regs);
+	if (ret < 0)
+		goto out;
+
+	af = variant->get_altfunc(stmpe, block);
+
+	while (pins) {
+		int pin = __ffs(pins);
+		int regoffset = numregs - (pin / afperreg) - 1;
+		int pos = (pin % afperreg) * (8 / afperreg);
+
+		regs[regoffset] &= ~(mask << pos);
+		regs[regoffset] |= af << pos;
+
+		pins &= ~(1 << pin);
+	}
+
+	ret = stmpe_block_write(stmpe, regaddr, numregs, regs);
+
+out:
+	mutex_unlock(&stmpe->lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(stmpe_set_altfunc);
+
+static irqreturn_t stmpe_irq(int irq, void *data)
+{
+	struct stmpe *stmpe = data;
+	struct stmpe_variant_info *variant = stmpe->variant;
+	int num = DIV_ROUND_UP(variant->num_irqs, 8);
+	u8 israddr = stmpe->regs[STMPE_IDX_ISR_MSB];
+	u8 isr[num];
+	int ret;
+	int i;
+
+	ret = stmpe_block_read(stmpe, israddr, num, isr);
+	if (ret < 0)
+		return IRQ_NONE;
+
+	for (i = 0; i < num; i++) {
+		int bank = num - i - 1;
+		u8 status = isr[i];
+		u8 clear;
+
+		status &= stmpe->ier[bank];
+		if (!status)
+			continue;
+
+		clear = status;
+		while (status) {
+			int bit = __ffs(status);
+			int line = bank * 8 + bit;
+
+			handle_nested_irq(stmpe->irq_base + line);
+			status &= ~(1 << bit);
+		}
+
+		stmpe_reg_write(stmpe, israddr + i, clear);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void stmpe_irq_lock(unsigned int irq)
+{
+	struct stmpe *stmpe = get_irq_chip_data(irq);
+
+	mutex_lock(&stmpe->irq_lock);
+}
+
+static void stmpe_irq_sync_unlock(unsigned int irq)
+{
+	struct stmpe *stmpe = get_irq_chip_data(irq);
+	struct stmpe_variant_info *variant = stmpe->variant;
+	int num = DIV_ROUND_UP(variant->num_irqs, 8);
+	int i;
+
+	for (i = 0; i < num; i++) {
+		u8 new = stmpe->ier[i];
+		u8 old = stmpe->oldier[i];
+
+		if (new == old)
+			continue;
+
+		stmpe->oldier[i] = new;
+		stmpe_reg_write(stmpe, stmpe->regs[STMPE_IDX_IER_LSB] - i, new);
+	}
+
+	mutex_unlock(&stmpe->irq_lock);
+}
+
+static void stmpe_irq_mask(unsigned int irq)
+{
+	struct stmpe *stmpe = get_irq_chip_data(irq);
+	int offset = irq - stmpe->irq_base;
+	int regoffset = offset / 8;
+	int mask = 1 << (offset % 8);
+
+	stmpe->ier[regoffset] &= ~mask;
+}
+
+static void stmpe_irq_unmask(unsigned int irq)
+{
+	struct stmpe *stmpe = get_irq_chip_data(irq);
+	int offset = irq - stmpe->irq_base;
+	int regoffset = offset / 8;
+	int mask = 1 << (offset % 8);
+
+	stmpe->ier[regoffset] |= mask;
+}
+
+static struct irq_chip stmpe_irq_chip = {
+	.name			= "stmpe",
+	.bus_lock		= stmpe_irq_lock,
+	.bus_sync_unlock	= stmpe_irq_sync_unlock,
+	.mask			= stmpe_irq_mask,
+	.unmask			= stmpe_irq_unmask,
+};
+
+static int __devinit stmpe_irq_init(struct stmpe *stmpe)
+{
+	int num_irqs = stmpe->variant->num_irqs;
+	int base = stmpe->irq_base;
+	int irq;
+
+	for (irq = base; irq < base + num_irqs; irq++) {
+		set_irq_chip_data(irq, stmpe);
+		set_irq_chip_and_handler(irq, &stmpe_irq_chip,
+					 handle_edge_irq);
+		set_irq_nested_thread(irq, 1);
+#ifdef CONFIG_ARM
+		set_irq_flags(irq, IRQF_VALID);
+#else
+		set_irq_noprobe(irq);
+#endif
+	}
+
+	return 0;
+}
+
+static void stmpe_irq_remove(struct stmpe *stmpe)
+{
+	int num_irqs = stmpe->variant->num_irqs;
+	int base = stmpe->irq_base;
+	int irq;
+
+	for (irq = base; irq < base + num_irqs; irq++) {
+#ifdef CONFIG_ARM
+		set_irq_flags(irq, 0);
+#endif
+		set_irq_chip_and_handler(irq, NULL, NULL);
+		set_irq_chip_data(irq, NULL);
+	}
+}
+
+static int __devinit stmpe_chip_init(struct stmpe *stmpe)
+{
+	unsigned int irq_trigger = stmpe->pdata->irq_trigger;
+	struct stmpe_variant_info *variant = stmpe->variant;
+	u8 icr = STMPE_ICR_LSB_GIM;
+	unsigned int id;
+	u8 data[2];
+	int ret;
+
+	ret = stmpe_block_read(stmpe, stmpe->regs[STMPE_IDX_CHIP_ID],
+			       ARRAY_SIZE(data), data);
+	if (ret < 0)
+		return ret;
+
+	id = (data[0] << 8) | data[1];
+	if ((id & variant->id_mask) != variant->id_val) {
+		dev_err(stmpe->dev, "unknown chip id: %#x\n", id);
+		return -EINVAL;
+	}
+
+	dev_info(stmpe->dev, "%s detected, chip id: %#x\n", variant->name, id);
+
+	/* Disable all modules -- subdrivers should enable what they need. */
+	ret = stmpe_disable(stmpe, ~0);
+	if (ret)
+		return ret;
+
+	if (irq_trigger == IRQF_TRIGGER_FALLING ||
+	    irq_trigger == IRQF_TRIGGER_RISING)
+		icr |= STMPE_ICR_LSB_EDGE;
+
+	if (irq_trigger == IRQF_TRIGGER_RISING ||
+	    irq_trigger == IRQF_TRIGGER_HIGH)
+		icr |= STMPE_ICR_LSB_HIGH;
+
+	if (stmpe->pdata->irq_invert_polarity)
+		icr ^= STMPE_ICR_LSB_HIGH;
+
+	return stmpe_reg_write(stmpe, stmpe->regs[STMPE_IDX_ICR_LSB], icr);
+}
+
+static int __devinit stmpe_add_device(struct stmpe *stmpe,
+				      struct mfd_cell *cell, int irq)
+{
+	return mfd_add_devices(stmpe->dev, stmpe->pdata->id, cell, 1,
+			       NULL, stmpe->irq_base + irq);
+}
+
+static int __devinit stmpe_devices_init(struct stmpe *stmpe)
+{
+	struct stmpe_variant_info *variant = stmpe->variant;
+	unsigned int platform_blocks = stmpe->pdata->blocks;
+	int ret = -EINVAL;
+	int i;
+
+	for (i = 0; i < variant->num_blocks; i++) {
+		struct stmpe_variant_block *block = &variant->blocks[i];
+
+		if (!(platform_blocks & block->block))
+			continue;
+
+		platform_blocks &= ~block->block;
+		ret = stmpe_add_device(stmpe, block->cell, block->irq);
+		if (ret)
+			return ret;
+	}
+
+	if (platform_blocks)
+		dev_warn(stmpe->dev,
+			 "platform wants blocks (%#x) not present on variant",
+			 platform_blocks);
+
+	return ret;
+}
+
+static int __devinit stmpe_probe(struct i2c_client *i2c,
+				 const struct i2c_device_id *id)
+{
+	struct stmpe_platform_data *pdata = i2c->dev.platform_data;
+	struct stmpe *stmpe;
+	int ret;
+
+	if (!pdata)
+		return -EINVAL;
+
+	stmpe = kzalloc(sizeof(struct stmpe), GFP_KERNEL);
+	if (!stmpe)
+		return -ENOMEM;
+
+	mutex_init(&stmpe->irq_lock);
+	mutex_init(&stmpe->lock);
+
+	stmpe->dev = &i2c->dev;
+	stmpe->i2c = i2c;
+
+	stmpe->pdata = pdata;
+	stmpe->irq_base = pdata->irq_base;
+
+	stmpe->partnum = id->driver_data;
+	stmpe->variant = stmpe_variant_info[stmpe->partnum];
+	stmpe->regs = stmpe->variant->regs;
+	stmpe->num_gpios = stmpe->variant->num_gpios;
+
+	i2c_set_clientdata(i2c, stmpe);
+
+	ret = stmpe_chip_init(stmpe);
+	if (ret)
+		goto out_free;
+
+	ret = stmpe_irq_init(stmpe);
+	if (ret)
+		goto out_free;
+
+	ret = request_threaded_irq(stmpe->i2c->irq, NULL, stmpe_irq,
+				   pdata->irq_trigger | IRQF_ONESHOT,
+				   "stmpe", stmpe);
+	if (ret) {
+		dev_err(stmpe->dev, "failed to request IRQ: %d\n", ret);
+		goto out_removeirq;
+	}
+
+	ret = stmpe_devices_init(stmpe);
+	if (ret) {
+		dev_err(stmpe->dev, "failed to add children\n");
+		goto out_removedevs;
+	}
+
+	return 0;
+
+out_removedevs:
+	mfd_remove_devices(stmpe->dev);
+	free_irq(stmpe->i2c->irq, stmpe);
+out_removeirq:
+	stmpe_irq_remove(stmpe);
+out_free:
+	kfree(stmpe);
+	return ret;
+}
+
+static int __devexit stmpe_remove(struct i2c_client *client)
+{
+	struct stmpe *stmpe = i2c_get_clientdata(client);
+
+	mfd_remove_devices(stmpe->dev);
+
+	free_irq(stmpe->i2c->irq, stmpe);
+	stmpe_irq_remove(stmpe);
+
+	kfree(stmpe);
+
+	return 0;
+}
+
+static const struct i2c_device_id stmpe_id[] = {
+	{ "stmpe811", STMPE811 },
+	{ "stmpe1601", STMPE1601 },
+	{ "stmpe2401", STMPE2401 },
+	{ "stmpe2403", STMPE2403 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, stmpe_id);
+
+static struct i2c_driver stmpe_driver = {
+	.driver.name	= "stmpe",
+	.driver.owner	= THIS_MODULE,
+	.probe		= stmpe_probe,
+	.remove		= __devexit_p(stmpe_remove),
+	.id_table	= stmpe_id,
+};
+
+static int __init stmpe_init(void)
+{
+	return i2c_add_driver(&stmpe_driver);
+}
+subsys_initcall(stmpe_init);
+
+static void __exit stmpe_exit(void)
+{
+	i2c_del_driver(&stmpe_driver);
+}
+module_exit(stmpe_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("STMPExxxx MFD core driver");
+MODULE_AUTHOR("Rabin Vincent <rabin.vincent@stericsson.com>");
diff --git a/drivers/mfd/stmpe.h b/drivers/mfd/stmpe.h
new file mode 100644
index 0000000..406aa2b
--- /dev/null
+++ b/drivers/mfd/stmpe.h
@@ -0,0 +1,164 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License, version 2
+ * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
+ */
+
+#ifndef __STMPE_H
+#define __STMPE_H
+
+/**
+ * struct stmpe_variant_block - information about block
+ * @cell:	base mfd cell
+ * @irq:	interrupt number to be added to each IORESOURCE_IRQ
+ *		in the cell
+ * @block:	block id; used for identification with platform data and for
+ *		enable and altfunc callbacks
+ */
+struct stmpe_variant_block {
+	struct mfd_cell		*cell;
+	int			irq;
+	enum stmpe_block	block;
+};
+
+/**
+ * struct stmpe_variant_info - variant-specific information
+ * @name:	part name
+ * @id_val:	content of CHIPID register
+ * @id_mask:	bits valid in CHIPID register for comparison with id_val
+ * @num_gpios:	number of GPIOS
+ * @af_bits:	number of bits used to specify the alternate function
+ * @blocks:	list of blocks present on this device
+ * @num_blocks:	number of blocks present on this device
+ * @num_irqs:	number of internal IRQs available on this device
+ * @enable:	callback to enable the specified blocks
+ * @get_altfunc: calllback to get the alternate function number for the
+ *		 specific block
+ */
+struct stmpe_variant_info {
+	const char *name;
+	u16 id_val;
+	u16 id_mask;
+	int num_gpios;
+	int af_bits;
+	const u8 *regs;
+	struct stmpe_variant_block *blocks;
+	int num_blocks;
+	int num_irqs;
+	int (*enable)(struct stmpe *stmpe, unsigned int blocks, bool enable);
+	int (*get_altfunc)(struct stmpe *stmpe, enum stmpe_block block);
+};
+
+extern struct stmpe_variant_info *stmpe_variant_info[];
+
+#define STMPE_ICR_LSB_HIGH	(1 << 2)
+#define STMPE_ICR_LSB_EDGE	(1 << 1)
+#define STMPE_ICR_LSB_GIM	(1 << 0)
+
+/*
+ * STMPE811
+ */
+
+#define STMPE811_IRQ_TOUCH_DET		0
+#define STMPE811_IRQ_FIFO_TH		1
+#define STMPE811_IRQ_FIFO_OFLOW		2
+#define STMPE811_IRQ_FIFO_FULL		3
+#define STMPE811_IRQ_FIFO_EMPTY		4
+#define STMPE811_IRQ_TEMP_SENS		5
+#define STMPE811_IRQ_ADC		6
+#define STMPE811_IRQ_GPIOC		7
+#define STMPE811_NR_INTERNAL_IRQS	8
+
+#define STMPE811_REG_CHIP_ID		0x00
+#define STMPE811_REG_SYS_CTRL2		0x04
+#define STMPE811_REG_INT_CTRL		0x09
+#define STMPE811_REG_INT_EN		0x0A
+#define STMPE811_REG_INT_STA		0x0B
+#define STMPE811_REG_GPIO_INT_EN	0x0C
+#define STMPE811_REG_GPIO_INT_STA	0x0D
+#define STMPE811_REG_GPIO_SET_PIN	0x10
+#define STMPE811_REG_GPIO_CLR_PIN	0x11
+#define STMPE811_REG_GPIO_MP_STA	0x12
+#define STMPE811_REG_GPIO_DIR		0x13
+#define STMPE811_REG_GPIO_ED		0x14
+#define STMPE811_REG_GPIO_RE		0x15
+#define STMPE811_REG_GPIO_FE		0x16
+#define STMPE811_REG_GPIO_AF		0x17
+
+#define STMPE811_SYS_CTRL2_ADC_OFF	(1 << 0)
+#define STMPE811_SYS_CTRL2_TSC_OFF	(1 << 1)
+#define STMPE811_SYS_CTRL2_GPIO_OFF	(1 << 2)
+#define STMPE811_SYS_CTRL2_TS_OFF	(1 << 3)
+
+/*
+ * STMPE1601
+ */
+
+#define STMPE1601_IRQ_GPIOC		8
+#define STMPE1601_IRQ_PWM3		7
+#define STMPE1601_IRQ_PWM2		6
+#define STMPE1601_IRQ_PWM1		5
+#define STMPE1601_IRQ_PWM0		4
+#define STMPE1601_IRQ_KEYPAD_OVER	2
+#define STMPE1601_IRQ_KEYPAD		1
+#define STMPE1601_IRQ_WAKEUP		0
+#define STMPE1601_NR_INTERNAL_IRQS	9
+
+#define STMPE1601_REG_SYS_CTRL			0x02
+#define STMPE1601_REG_ICR_LSB			0x11
+#define STMPE1601_REG_IER_LSB			0x13
+#define STMPE1601_REG_ISR_MSB			0x14
+#define STMPE1601_REG_CHIP_ID			0x80
+#define STMPE1601_REG_INT_EN_GPIO_MASK_LSB	0x17
+#define STMPE1601_REG_INT_STA_GPIO_MSB		0x18
+#define STMPE1601_REG_GPIO_MP_LSB		0x87
+#define STMPE1601_REG_GPIO_SET_LSB		0x83
+#define STMPE1601_REG_GPIO_CLR_LSB		0x85
+#define STMPE1601_REG_GPIO_SET_DIR_LSB		0x89
+#define STMPE1601_REG_GPIO_ED_MSB		0x8A
+#define STMPE1601_REG_GPIO_RE_LSB		0x8D
+#define STMPE1601_REG_GPIO_FE_LSB		0x8F
+#define STMPE1601_REG_GPIO_AF_U_MSB		0x92
+
+#define STMPE1601_SYS_CTRL_ENABLE_GPIO		(1 << 3)
+#define STMPE1601_SYS_CTRL_ENABLE_KPC		(1 << 1)
+#define STMPE1601_SYSCON_ENABLE_SPWM		(1 << 0)
+
+/*
+ * STMPE24xx
+ */
+
+#define STMPE24XX_IRQ_GPIOC		8
+#define STMPE24XX_IRQ_PWM2		7
+#define STMPE24XX_IRQ_PWM1		6
+#define STMPE24XX_IRQ_PWM0		5
+#define STMPE24XX_IRQ_ROT_OVER		4
+#define STMPE24XX_IRQ_ROT		3
+#define STMPE24XX_IRQ_KEYPAD_OVER	2
+#define STMPE24XX_IRQ_KEYPAD		1
+#define STMPE24XX_IRQ_WAKEUP		0
+#define STMPE24XX_NR_INTERNAL_IRQS	9
+
+#define STMPE24XX_REG_SYS_CTRL		0x02
+#define STMPE24XX_REG_ICR_LSB		0x11
+#define STMPE24XX_REG_IER_LSB		0x13
+#define STMPE24XX_REG_ISR_MSB		0x14
+#define STMPE24XX_REG_CHIP_ID		0x80
+#define STMPE24XX_REG_IEGPIOR_LSB	0x18
+#define STMPE24XX_REG_ISGPIOR_MSB	0x19
+#define STMPE24XX_REG_GPMR_LSB		0xA5
+#define STMPE24XX_REG_GPSR_LSB		0x85
+#define STMPE24XX_REG_GPCR_LSB		0x88
+#define STMPE24XX_REG_GPDR_LSB		0x8B
+#define STMPE24XX_REG_GPEDR_MSB		0x8C
+#define STMPE24XX_REG_GPRER_LSB		0x91
+#define STMPE24XX_REG_GPFER_LSB		0x94
+#define STMPE24XX_REG_GPAFR_U_MSB	0x9B
+
+#define STMPE24XX_SYS_CTRL_ENABLE_GPIO		(1 << 3)
+#define STMPE24XX_SYSCON_ENABLE_PWM		(1 << 2)
+#define STMPE24XX_SYS_CTRL_ENABLE_KPC		(1 << 1)
+#define STMPE24XX_SYSCON_ENABLE_ROT		(1 << 0)
+
+#endif
diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
new file mode 100644
index 0000000..cf2155f
--- /dev/null
+++ b/include/linux/mfd/stmpe.h
@@ -0,0 +1,154 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License, version 2
+ * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
+ */
+
+#ifndef __LINUX_MFD_STMPE_H
+#define __LINUX_MFD_STMPE_H
+
+#include <linux/device.h>
+
+enum stmpe_block {
+	STMPE_BLOCK_GPIO	= 1 << 0,
+	STMPE_BLOCK_KEYPAD	= 1 << 1,
+	STMPE_BLOCK_TOUCHSCREEN	= 1 << 2,
+	STMPE_BLOCK_ADC		= 1 << 3,
+	STMPE_BLOCK_PWM		= 1 << 4,
+	STMPE_BLOCK_ROTATOR	= 1 << 5,
+};
+
+enum stmpe_partnum {
+	STMPE811,
+	STMPE1601,
+	STMPE2401,
+	STMPE2403,
+};
+
+/*
+ * For registers whose locations differ on variants,  the correct address is
+ * obtained by indexing stmpe->regs with one of the following.
+ */
+enum {
+	STMPE_IDX_CHIP_ID,
+	STMPE_IDX_ICR_LSB,
+	STMPE_IDX_IER_LSB,
+	STMPE_IDX_ISR_MSB,
+	STMPE_IDX_GPMR_LSB,
+	STMPE_IDX_GPSR_LSB,
+	STMPE_IDX_GPCR_LSB,
+	STMPE_IDX_GPDR_LSB,
+	STMPE_IDX_GPEDR_MSB,
+	STMPE_IDX_GPRER_LSB,
+	STMPE_IDX_GPFER_LSB,
+	STMPE_IDX_GPAFR_U_MSB,
+	STMPE_IDX_IEGPIOR_LSB,
+	STMPE_IDX_ISGPIOR_MSB,
+	STMPE_IDX_MAX,
+};
+
+
+struct stmpe_variant_info;
+
+/**
+ * struct stmpe - STMPE MFD structure
+ * @lock: lock protecting I/O operations
+ * @irq_lock: IRQ bus lock
+ * @dev: device, mostly for dev_dbg()
+ * @i2c: i2c client
+ * @variant: the detected STMPExxxx model number
+ * @regs: list of addresses of registers which are at different addresses on
+ *	  different variants.  Indexed by one of STMPE_IDX_*.
+ * @irq_base: starting IRQ number for internal IRQs
+ * @num_gpios: number of gpios, differs for variants
+ * @ier: cache of IER registers for bus_lock
+ * @oldier: cache of IER registers for bus_lock
+ * @pdata: platform data
+ */
+struct stmpe {
+	struct mutex lock;
+	struct mutex irq_lock;
+	struct device *dev;
+	struct i2c_client *i2c;
+	enum stmpe_partnum partnum;
+	struct stmpe_variant_info *variant;
+	const u8 *regs;
+
+	int irq_base;
+	int num_gpios;
+	u8 ier[2];
+	u8 oldier[2];
+	struct stmpe_platform_data *pdata;
+};
+
+extern int stmpe_reg_write(struct stmpe *stmpe, u8 reg, u8 data);
+extern int stmpe_reg_read(struct stmpe *stmpe, u8 reg);
+extern int stmpe_block_read(struct stmpe *stmpe, u8 reg, u8 length,
+			    u8 *values);
+extern int stmpe_block_write(struct stmpe *stmpe, u8 reg, u8 length,
+			     const u8 *values);
+extern int stmpe_set_bits(struct stmpe *stmpe, u8 reg, u8 mask, u8 val);
+extern int stmpe_set_altfunc(struct stmpe *stmpe, u32 pins,
+			     enum stmpe_block block);
+extern int stmpe_enable(struct stmpe *stmpe, unsigned int blocks);
+extern int stmpe_disable(struct stmpe *stmpe, unsigned int blocks);
+
+struct matrix_keymap_data;
+
+/**
+ * struct stmpe_keypad_platform_data - STMPE keypad platform data
+ * @keymap_data: key map table and size
+ * @debounce_ms: debounce interval, in ms.  Maximum is
+ *		 %STMPE_KEYPAD_MAX_DEBOUNCE.
+ * @scan_count: number of key scanning cycles to confirm key data.
+ *		Maximum is %STMPE_KEYPAD_MAX_SCAN_COUNT.
+ * @no_autorepeat: disable key autorepeat
+ */
+struct stmpe_keypad_platform_data {
+	struct matrix_keymap_data *keymap_data;
+	unsigned int debounce_ms;
+	unsigned int scan_count;
+	bool no_autorepeat;
+};
+
+/**
+ * struct stmpe_gpio_platform_data - STMPE GPIO platform data
+ * @gpio_base: first gpio number assigned.  A maximum of
+ *	       %STMPE_NR_GPIOS GPIOs will be allocated.
+ */
+struct stmpe_gpio_platform_data {
+	int gpio_base;
+	void (*setup)(struct stmpe *stmpe, unsigned gpio_base);
+	void (*remove)(struct stmpe *stmpe, unsigned gpio_base);
+};
+
+/**
+ * struct stmpe_platform_data - STMPE platform data
+ * @id: device id to distinguish between multiple STMPEs on the same board
+ * @blocks: bitmask of blocks to enable (use STMPE_BLOCK_*)
+ * @irq_trigger: IRQ trigger to use for the interrupt to the host
+ * @irq_invert_polarity: IRQ line is connected with reversed polarity
+ * @irq_base: base IRQ number.  %STMPE_NR_IRQS irqs will be used, or
+ *	      %STMPE_NR_INTERNAL_IRQS if the GPIO driver is not used.
+ * @gpio: GPIO-specific platform data
+ * @keypad: keypad-specific platform data
+ */
+struct stmpe_platform_data {
+	int id;
+	unsigned int blocks;
+	int irq_base;
+	unsigned int irq_trigger;
+	bool irq_invert_polarity;
+
+	struct stmpe_gpio_platform_data *gpio;
+	struct stmpe_keypad_platform_data *keypad;
+};
+
+#define STMPE_NR_INTERNAL_IRQS	9
+#define STMPE_INT_GPIO(x)	(STMPE_NR_INTERNAL_IRQS + (x))
+
+#define STMPE_NR_GPIOS		24
+#define STMPE_NR_IRQS		STMPE_INT_GPIO(STMPE_NR_GPIOS)
+
+#endif
-- 
1.7.0

