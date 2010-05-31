Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab0EaMRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 08:17:47 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:39356 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753652Ab0EaMRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 08:17:45 -0400
From: Rabin Vincent <rabin.vincent@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>, <STEricsson_nomadik_linux@list.st.com>,
       Rabin Vincent <rabin.vincent@stericsson.com>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 1/3] mfd: add STMPExxxx I/O Expander support
Date: Mon, 31 May 2010 17:47:14 +0530
Message-ID: <1275308236-1775-1-git-send-email-rabin.vincent@stericsson.com>
X-Mailer: git-send-email 1.7.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the STMPExxxx family of I/O Expanders from
STMicroelectronics.  These devices include upto 24 gpios, a PWM
controller, and a keypad controller.  This patch adds the MFD core.

Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
---
 drivers/mfd/Kconfig       |   12 +
 drivers/mfd/Makefile      |    1 +
 drivers/mfd/stmpe.c       |  600 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/stmpe.h |  135 ++++++++++
 4 files changed, 748 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/stmpe.c
 create mode 100644 include/linux/mfd/stmpe.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 9da0e50..e4ee19d 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -177,6 +177,18 @@ config TWL4030_CODEC
 	select MFD_CORE
 	default n
 
+config MFD_STMPE
+	bool "Support STMicroelectronics STMPExxxx"
+	depends on I2C=y && GENERIC_HARDIRQS
+	select MFD_CORE
+	help
+	  Support for the STMPExxxx family of I/O Expanders from
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
index fb503e7..4410747 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_HTC_I2CPLD)	+= htc-i2cpld.o
 obj-$(CONFIG_MFD_DAVINCI_VOICECODEC)	+= davinci_voicecodec.o
 obj-$(CONFIG_MFD_DM355EVM_MSP)	+= dm355evm_msp.o
 
+obj-$(CONFIG_MFD_STMPE)		+= stmpe.o
 obj-$(CONFIG_MFD_TC35892)	+= tc35892.o
 obj-$(CONFIG_MFD_T7L66XB)	+= t7l66xb.o tmio_core.o
 obj-$(CONFIG_MFD_TC6387XB)	+= tc6387xb.o tmio_core.o
diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
new file mode 100644
index 0000000..53e72b6
--- /dev/null
+++ b/drivers/mfd/stmpe.c
@@ -0,0 +1,600 @@
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
+
+/* Interrupts */
+#define STMPE_INT_GPIOC		8
+#define STMPE1601_INT_PWM3	7
+#define STMPE1601_INT_PWM2	6
+#define STMPE1601_INT_PWM1	5
+#define STMPE1601_INT_PWM0	4
+#define STMPE24XX_INT_PWM2	7
+#define STMPE24XX_INT_PWM1	6
+#define STMPE24XX_INT_PWM0	5
+#define STMPE24XX_INT_ROT_OVER	4
+#define STMPE24XX_INT_ROT	3
+#define STMPE_INT_KEYPAD_OVER	2
+#define STMPE_INT_KEYPAD	1
+#define STMPE_INT_WAKEUP	0
+
+/* Core registers at same addresses on all variants */
+#define STMPE_ICR_LSB		0x11
+#define STMPE_IER_LSB		0x13
+#define STMPE_ISR_MSB		0x14
+#define STMPE_CHIP_ID		0x80
+
+#define STMPE_ICR_LSB_HIGH	(1 << 2)
+#define STMPE_ICR_LSB_EDGE	(1 << 1)
+#define STMPE_ICR_LSB_GIM	(1 << 0)
+
+/*
+ * The following registers are at different addresses on different variants.
+ * We provide a set of register indices and a translation table.
+ */
+
+#define STMPE1601_INT_EN_GPIO_MASK_LSB	0x17
+#define STMPE1601_INT_STA_GPIO_MSB	0x18
+#define STMPE1601_GPIO_MP_LSB		0x87
+#define STMPE1601_GPIO_SET_LSB		0x83
+#define STMPE1601_GPIO_CLR_LSB		0x85
+#define STMPE1601_GPIO_SET_DIR_LSB	0x89
+#define STMPE1601_GPIO_ED_MSB		0x8A
+#define STMPE1601_GPIO_RE_LSB		0x8D
+#define STMPE1601_GPIO_FE_LSB		0x8F
+#define STMPE1601_GPIO_AF_U_MSB		0x92
+
+#define STMPE24XX_IEGPIOR_LSB		0x18
+#define STMPE24XX_ISGPIOR_MSB		0x19
+#define STMPE24XX_GPMR_LSB		0xA5
+#define STMPE24XX_GPSR_LSB		0x85
+#define STMPE24XX_GPCR_LSB		0x88
+#define STMPE24XX_GPDR_LSB		0x8B
+#define STMPE24XX_GPEDR_MSB		0x8C
+#define STMPE24XX_GPRER_LSB		0x91
+#define STMPE24XX_GPFER_LSB		0x94
+#define STMPE24XX_GPAFR_U_MSB		0x9B
+
+static const u8 stmpe1601_regs[] = {
+	[STMPE_IDX_GPMR_LSB]	= STMPE1601_GPIO_MP_LSB,
+	[STMPE_IDX_GPSR_LSB]	= STMPE1601_GPIO_SET_LSB,
+	[STMPE_IDX_GPCR_LSB]	= STMPE1601_GPIO_CLR_LSB,
+	[STMPE_IDX_GPDR_LSB]	= STMPE1601_GPIO_SET_DIR_LSB,
+	[STMPE_IDX_GPRER_LSB]	= STMPE1601_GPIO_RE_LSB,
+	[STMPE_IDX_GPFER_LSB]	= STMPE1601_GPIO_FE_LSB,
+	[STMPE_IDX_GPAFR_U_MSB]	= STMPE1601_GPIO_AF_U_MSB,
+	[STMPE_IDX_IEGPIOR_LSB]	= STMPE1601_INT_EN_GPIO_MASK_LSB,
+	[STMPE_IDX_ISGPIOR_MSB]	= STMPE1601_INT_STA_GPIO_MSB,
+	[STMPE_IDX_GPEDR_MSB]	= STMPE1601_GPIO_ED_MSB,
+};
+
+static const u8 stmpe24xx_regs[] = {
+	[STMPE_IDX_GPMR_LSB]	= STMPE24XX_GPMR_LSB,
+	[STMPE_IDX_GPSR_LSB]	= STMPE24XX_GPSR_LSB,
+	[STMPE_IDX_GPCR_LSB]	= STMPE24XX_GPCR_LSB,
+	[STMPE_IDX_GPDR_LSB]	= STMPE24XX_GPDR_LSB,
+	[STMPE_IDX_GPRER_LSB]	= STMPE24XX_GPRER_LSB,
+	[STMPE_IDX_GPFER_LSB]	= STMPE24XX_GPFER_LSB,
+	[STMPE_IDX_GPAFR_U_MSB]	= STMPE24XX_GPAFR_U_MSB,
+	[STMPE_IDX_IEGPIOR_LSB]	= STMPE24XX_IEGPIOR_LSB,
+	[STMPE_IDX_ISGPIOR_MSB]	= STMPE24XX_ISGPIOR_MSB,
+	[STMPE_IDX_GPEDR_MSB]	= STMPE24XX_GPEDR_MSB,
+};
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
+ * @af:		Alternate function number (0 - 3)
+ *
+ * @pins is assumed to have a bit set for each of the bits whose alternate
+ * function is to be changed, numbered according to the GPIOXY numbers.
+ *
+ * If the GPIO module is not enabled, this function automatically enables it in
+ * order to perform the change.
+ */
+int stmpe_set_altfunc(struct stmpe *stmpe, u32 pins, int af)
+{
+	u8 regaddr = stmpe->regs[STMPE_IDX_GPAFR_U_MSB];
+	int numregs = stmpe->num_gpios / 4;
+	u8 regs[numregs];
+	bool gpioon;
+	int syscon;
+	int ret;
+
+	mutex_lock(&stmpe->lock);
+
+	syscon = stmpe_reg_read(stmpe, STMPE_SYSCON);
+	if (syscon < 0)
+		return syscon;
+
+	gpioon = syscon & STMPE_SYSCON_ENABLE_GPIO;
+	if (!gpioon) {
+		ret = stmpe_reg_write(stmpe, STMPE_SYSCON,
+				      syscon | STMPE_SYSCON_ENABLE_GPIO);
+		if (ret < 0)
+			return ret;
+	}
+
+	ret = stmpe_block_read(stmpe, regaddr, numregs, regs);
+	if (ret < 0)
+		goto out;
+
+	while (pins) {
+		int pin = __ffs(pins);
+		int regoffset = numregs - (pin / 4) - 1;
+		int pos = (pin % 4) * 2;
+
+		regs[regoffset] &= ~(0x3 << pos);
+		regs[regoffset] |= af << pos;
+
+		pins &= ~(1 << pin);
+	}
+
+	ret = stmpe_block_write(stmpe, regaddr, numregs, regs);
+
+	if (!gpioon)
+		stmpe_reg_write(stmpe, STMPE_SYSCON, syscon);
+
+out:
+	mutex_unlock(&stmpe->lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(stmpe_set_altfunc);
+
+static struct resource gpio_resources[] = {
+	{
+		.start	= STMPE_INT_GPIOC,
+		.end	= STMPE_INT_GPIOC,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct resource keypad_resources[] = {
+	{
+		.start	= STMPE_INT_KEYPAD,
+		.end	= STMPE_INT_KEYPAD,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= STMPE_INT_KEYPAD_OVER,
+		.end	= STMPE_INT_KEYPAD_OVER,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct mfd_cell stmpe_devs[] = {
+	{
+		.name		= "stmpe-gpio",
+		.resources	= gpio_resources,
+		.num_resources	= ARRAY_SIZE(gpio_resources),
+	},
+	{
+		.name		= "stmpe-keypad",
+		.resources	= keypad_resources,
+		.num_resources	= ARRAY_SIZE(keypad_resources),
+	},
+};
+
+static irqreturn_t stmpe_irq(int irq, void *data)
+{
+	struct stmpe *stmpe = data;
+	int num = ARRAY_SIZE(stmpe->ier);
+	u8 isr[num];
+	int ret;
+	int i;
+
+	ret = stmpe_block_read(stmpe, STMPE_ISR_MSB, num, isr);
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
+		stmpe_reg_write(stmpe, STMPE_ISR_MSB + i, clear);
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
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(stmpe->ier); i++) {
+		u8 new = stmpe->ier[i];
+		u8 old = stmpe->oldier[i];
+
+		if (new == old)
+			continue;
+
+		stmpe->oldier[i] = new;
+		stmpe_reg_write(stmpe, STMPE_IER_LSB - i, new);
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
+	int base = stmpe->irq_base;
+	int irq;
+
+	for (irq = base; irq < base + STMPE_NR_INTERNAL_IRQS; irq++) {
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
+	int base = stmpe->irq_base;
+	int irq;
+
+	for (irq = base; irq < base + STMPE_NR_INTERNAL_IRQS; irq++) {
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
+	u8 icr = STMPE_ICR_LSB_GIM;
+	const char *name;
+	unsigned int id;
+	u8 data[2];
+	int ret;
+
+	ret = stmpe_block_read(stmpe, STMPE_CHIP_ID, ARRAY_SIZE(data), data);
+	if (ret < 0)
+		return ret;
+
+	id = (data[0] << 8) | data[1];
+
+	switch (id) {
+	case 0x0210:
+	case 0x0212:
+		name = "STMPE1601";
+		stmpe->variant = STMPE1601;
+		stmpe->regs = stmpe1601_regs;
+		stmpe->num_gpios = 16;
+		break;
+
+	case 0x0101:
+		name = "STMPE2401";
+		stmpe->variant = STMPE2401;
+		stmpe->regs = stmpe24xx_regs;
+		stmpe->num_gpios = 24;
+		break;
+
+	case 0x0120:
+		name = "STMPE2403";
+		stmpe->variant = STMPE2403;
+		stmpe->regs = stmpe24xx_regs;
+		stmpe->num_gpios = 24;
+		break;
+
+	default:
+		dev_err(stmpe->dev, "unknown id: %#x\n", id);
+		return -EINVAL;
+	}
+
+	dev_info(stmpe->dev, "%s detected\n", name);
+
+	/* Disable all modules -- subdrivers should enable what they need. */
+	ret = stmpe_set_bits(stmpe, STMPE_SYSCON, STMPE_SYSCON_ENABLE, 0);
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
+	return stmpe_reg_write(stmpe, STMPE_ICR_LSB, icr);
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
+	ret = mfd_add_devices(stmpe->dev, pdata->id, stmpe_devs,
+			      ARRAY_SIZE(stmpe_devs), NULL,
+			      stmpe->irq_base);
+	if (ret) {
+		dev_err(stmpe->dev, "failed to add children\n");
+		goto out_freeirq;
+	}
+
+	return 0;
+
+out_freeirq:
+	free_irq(stmpe->i2c->irq, stmpe);
+out_removeirq:
+	stmpe_irq_remove(stmpe);
+out_free:
+	i2c_set_clientdata(i2c, NULL);
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
+	i2c_set_clientdata(client, NULL);
+	kfree(stmpe);
+
+	return 0;
+}
+
+static const struct i2c_device_id stmpe_id[] = {
+	{ "stmpe", 0 },
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
diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
new file mode 100644
index 0000000..7c6733b
--- /dev/null
+++ b/include/linux/mfd/stmpe.h
@@ -0,0 +1,135 @@
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
+#define STMPE_SYSCON			0x02
+
+#define STMPE_SYSCON_ENABLE		(0xf << 0)
+#define STMPE_SYSCON_ENABLE_GPIO	(1 << 3)
+#define STMPE24XX_SYSCON_ENABLE_PWM	(1 << 2)
+#define STMPE_SYSCON_ENABLE_KPC		(1 << 1)
+#define STMPE16XX_SYSCON_ENABLE_SPWM	(1 << 0)
+#define STMPE24XX_SYSCON_ENABLE_ROT	(1 << 0)
+
+enum stmpe_variant {
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
+};
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
+	enum stmpe_variant variant;
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
+extern int stmpe_set_altfunc(struct stmpe *stmpe, u32 pins, int af);
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
+};
+
+/**
+ * struct stmpe_platform_data - STMPE platform data
+ * @id: device id to distinguish between multiple STMPEs on the same board
+ * @irq_trigger: IRQ trigger to use for the interrupt to the host
+ * @irq_base: base IRQ number.  %STMPE_NR_IRQS irqs will be used, or
+ *	      %STMPE_NR_INTERNAL_IRQS if the GPIO driver is not used.
+ * @gpio: GPIO-specific platform data
+ * @keypad: keypad-specific platform data
+ */
+struct stmpe_platform_data {
+	int id;
+	int irq_base;
+	unsigned int irq_trigger;
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

