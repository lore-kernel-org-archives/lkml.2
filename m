Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab2B1NF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 08:05:59 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2442 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab2B1NF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 08:05:56 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 28 Feb 2012 05:05:55 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, ldewangan@nvidia.com,
        linux-tegra@vger.kernel.org
Subject: [PATCH] mfd: rc5t583: Add support for RICOH PMIC RC5T583
Date: Tue, 28 Feb 2012 18:35:17 +0530
Message-Id: <1330434317-3554-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ricoh power management IC  RC5T583 contains is multi
functional device having multiple sub devices inside this.
This device has multiple dcdc/ldo regulators, gpios, interrupt
controllers, on-key, RTCs, ADCs.
This device have 4 DCDCs, 8 LDOs, 8 GPIOs, 6 ADCs, 3 RTCs etc.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/mfd/Kconfig         |   14 ++
 drivers/mfd/Makefile        |    1 +
 drivers/mfd/rc5t583-irq.c   |  408 +++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/rc5t583.c       |  386 ++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/rc5t583.h |  295 +++++++++++++++++++++++++++++++
 5 files changed, 1104 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/rc5t583-irq.c
 create mode 100644 drivers/mfd/rc5t583.c
 create mode 100644 include/linux/mfd/rc5t583.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index f3951d3..a658b36 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -854,6 +854,20 @@ config MFD_INTEL_MSIC
 	  Passage) chip. This chip embeds audio, battery, GPIO, etc.
 	  devices used in Intel Medfield platforms.
 
+config MFD_RC5T583
+	bool "Ricoh RC5T583 Power Management system device"
+	depends on I2C && GENERIC_HARDIRQS
+	select MFD_CORE
+	select REGMAP_I2C
+	help
+	  Select this option to get support for the RICOH583 Power
+	  Management system device.
+	  This driver provides common support for accessing the device
+	  through i2c interface. The device supports multiple sub-devices
+	  like GPIO, interrupts, RTC, LDO and DCDC regulators, onkey.
+	  Additional drivers must be enabled in order to use the
+	  different functionality of the device.
+
 endmenu
 endif
 
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 27430d3..ea0bb80 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -112,4 +112,5 @@ obj-$(CONFIG_MFD_PM8XXX_IRQ) 	+= pm8xxx-irq.o
 obj-$(CONFIG_TPS65911_COMPARATOR)	+= tps65911-comparator.o
 obj-$(CONFIG_MFD_AAT2870_CORE)	+= aat2870-core.o
 obj-$(CONFIG_MFD_INTEL_MSIC)	+= intel_msic.o
+obj-$(CONFIG_MFD_RC5T583)	+= rc5t583.o rc5t583-irq.o
 obj-$(CONFIG_MFD_S5M_CORE)	+= s5m-core.o s5m-irq.o
diff --git a/drivers/mfd/rc5t583-irq.c b/drivers/mfd/rc5t583-irq.c
new file mode 100644
index 0000000..fa6f80f
--- /dev/null
+++ b/drivers/mfd/rc5t583-irq.c
@@ -0,0 +1,408 @@
+/*
+ * Interrupt driver for RICOH583 power management chip.
+ *
+ * Copyright (c) 2011-2012, NVIDIA CORPORATION.  All rights reserved.
+ * Author: Laxman dewangan <ldewangan@nvidia.com>
+ *
+ * based on code
+ *      Copyright (C) 2011 RICOH COMPANY,LTD
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/mfd/rc5t583.h>
+
+enum int_type {
+	SYS_INT  = 0x1,
+	DCDC_INT = 0x2,
+	RTC_INT  = 0x4,
+	ADC_INT  = 0x8,
+	GPIO_INT = 0x10,
+};
+
+static int gpedge_add[] = {
+	RC5T583_GPIO_GPEDGE2,
+	RC5T583_GPIO_GPEDGE2
+};
+
+static int irq_en_add[] = {
+	RC5T583_INT_EN_SYS1,
+	RC5T583_INT_EN_SYS2,
+	RC5T583_INT_EN_DCDC,
+	RC5T583_INT_EN_RTC,
+	RC5T583_INT_EN_ADC1,
+	RC5T583_INT_EN_ADC2,
+	RC5T583_INT_EN_ADC3,
+	RC5T583_GPIO_EN_INT
+};
+
+static int irq_mon_add[] = {
+	RC5T583_INT_MON_SYS1,
+	RC5T583_INT_MON_SYS2,
+	RC5T583_INT_MON_DCDC,
+	RC5T583_INT_MON_RTC,
+	RC5T583_INT_IR_ADCL,
+	RC5T583_INT_IR_ADCH,
+	RC5T583_INT_IR_ADCEND,
+	RC5T583_INT_IR_GPIOF,
+	RC5T583_INT_IR_GPIOR
+};
+
+static int irq_clr_add[] = {
+	RC5T583_INT_IR_SYS1,
+	RC5T583_INT_IR_SYS2,
+	RC5T583_INT_IR_DCDC,
+	RC5T583_INT_IR_RTC,
+	RC5T583_INT_IR_ADCL,
+	RC5T583_INT_IR_ADCH,
+	RC5T583_INT_IR_ADCEND,
+	RC5T583_INT_IR_GPIOF,
+	RC5T583_INT_IR_GPIOR
+};
+
+static int main_int_type[] = {
+	SYS_INT,
+	SYS_INT,
+	DCDC_INT,
+	RTC_INT,
+	ADC_INT,
+	ADC_INT,
+	ADC_INT,
+	GPIO_INT,
+	GPIO_INT,
+};
+
+struct rc5t583_irq_data {
+	u8	int_type;
+	u8	master_bit;
+	u8	int_en_bit;
+	u8	mask_reg_index;
+	int	grp_index;
+};
+
+#define RC5T583_IRQ(_int_type, _master_bit, _grp_index, \
+			_int_bit, _mask_ind)		\
+	{						\
+		.int_type	= _int_type,		\
+		.master_bit	= _master_bit,		\
+		.grp_index	= _grp_index,		\
+		.int_en_bit	= _int_bit,		\
+		.mask_reg_index	= _mask_ind,		\
+	}
+
+static const struct rc5t583_irq_data rc5t583_irqs[RC5T583_MAX_IRQS] = {
+	[RC5T583_IRQ_ONKEY]		= RC5T583_IRQ(SYS_INT,  0, 0, 0, 0),
+	[RC5T583_IRQ_ACOK]		= RC5T583_IRQ(SYS_INT,  0, 1, 1, 0),
+	[RC5T583_IRQ_LIDOPEN]		= RC5T583_IRQ(SYS_INT,  0, 2, 2, 0),
+	[RC5T583_IRQ_PREOT]		= RC5T583_IRQ(SYS_INT,  0, 3, 3, 0),
+	[RC5T583_IRQ_CLKSTP]		= RC5T583_IRQ(SYS_INT,  0, 4, 4, 0),
+	[RC5T583_IRQ_ONKEY_OFF]		= RC5T583_IRQ(SYS_INT,  0, 5, 5, 0),
+	[RC5T583_IRQ_WD]		= RC5T583_IRQ(SYS_INT,  0, 7, 7, 0),
+	[RC5T583_IRQ_EN_PWRREQ1]	= RC5T583_IRQ(SYS_INT,  0, 8, 0, 1),
+	[RC5T583_IRQ_EN_PWRREQ2]	= RC5T583_IRQ(SYS_INT,  0, 9, 1, 1),
+	[RC5T583_IRQ_PRE_VINDET]	= RC5T583_IRQ(SYS_INT,  0, 10, 2, 1),
+
+	[RC5T583_IRQ_DC0LIM]		= RC5T583_IRQ(DCDC_INT, 1, 0, 0, 2),
+	[RC5T583_IRQ_DC1LIM]		= RC5T583_IRQ(DCDC_INT, 1, 1, 1, 2),
+	[RC5T583_IRQ_DC2LIM]		= RC5T583_IRQ(DCDC_INT, 1, 2, 2, 2),
+	[RC5T583_IRQ_DC3LIM]		= RC5T583_IRQ(DCDC_INT, 1, 3, 3, 2),
+
+	[RC5T583_IRQ_CTC]		= RC5T583_IRQ(RTC_INT,  2, 0, 0, 3),
+	[RC5T583_IRQ_YALE]		= RC5T583_IRQ(RTC_INT,  2, 5, 5, 3),
+	[RC5T583_IRQ_DALE]		= RC5T583_IRQ(RTC_INT,  2, 6, 6, 3),
+	[RC5T583_IRQ_WALE]		= RC5T583_IRQ(RTC_INT,  2, 7, 7, 3),
+
+	[RC5T583_IRQ_AIN1L]		= RC5T583_IRQ(ADC_INT,  3, 0, 0, 4),
+	[RC5T583_IRQ_AIN2L]		= RC5T583_IRQ(ADC_INT,  3, 1, 1, 4),
+	[RC5T583_IRQ_AIN3L]		= RC5T583_IRQ(ADC_INT,  3, 2, 2, 4),
+	[RC5T583_IRQ_VBATL]		= RC5T583_IRQ(ADC_INT,  3, 3, 3, 4),
+	[RC5T583_IRQ_VIN3L]		= RC5T583_IRQ(ADC_INT,  3, 4, 4, 4),
+	[RC5T583_IRQ_VIN8L]		= RC5T583_IRQ(ADC_INT,  3, 5, 5, 4),
+	[RC5T583_IRQ_AIN1H]		= RC5T583_IRQ(ADC_INT,  3, 6, 0, 5),
+	[RC5T583_IRQ_AIN2H]		= RC5T583_IRQ(ADC_INT,  3, 7, 1, 5),
+	[RC5T583_IRQ_AIN3H]		= RC5T583_IRQ(ADC_INT,  3, 8, 2, 5),
+	[RC5T583_IRQ_VBATH]		= RC5T583_IRQ(ADC_INT,  3, 9, 3, 5),
+	[RC5T583_IRQ_VIN3H]		= RC5T583_IRQ(ADC_INT,  3, 10, 4, 5),
+	[RC5T583_IRQ_VIN8H]		= RC5T583_IRQ(ADC_INT,  3, 11, 5, 5),
+	[RC5T583_IRQ_ADCEND]		= RC5T583_IRQ(ADC_INT,  3, 12, 0, 6),
+
+	[RC5T583_IRQ_GPIO0]		= RC5T583_IRQ(GPIO_INT, 4, 0, 0, 7),
+	[RC5T583_IRQ_GPIO1]		= RC5T583_IRQ(GPIO_INT, 4, 1, 1, 7),
+	[RC5T583_IRQ_GPIO2]		= RC5T583_IRQ(GPIO_INT, 4, 2, 2, 7),
+	[RC5T583_IRQ_GPIO3]		= RC5T583_IRQ(GPIO_INT, 4, 3, 3, 7),
+	[RC5T583_IRQ_GPIO4]		= RC5T583_IRQ(GPIO_INT, 4, 4, 4, 7),
+	[RC5T583_IRQ_GPIO5]		= RC5T583_IRQ(GPIO_INT, 4, 5, 5, 7),
+	[RC5T583_IRQ_GPIO6]		= RC5T583_IRQ(GPIO_INT, 4, 6, 6, 7),
+	[RC5T583_IRQ_GPIO7]		= RC5T583_IRQ(GPIO_INT, 4, 7, 7, 7),
+};
+
+static void rc5t583_irq_lock(struct irq_data *irq_data)
+{
+	struct rc5t583 *rc5t583 = irq_data_get_irq_chip_data(irq_data);
+	mutex_lock(&rc5t583->irq_lock);
+}
+
+static void rc5t583_irq_unmask(struct irq_data *irq_data)
+{
+	struct rc5t583 *rc5t583 = irq_data_get_irq_chip_data(irq_data);
+	unsigned int __irq = irq_data->irq - rc5t583->irq_base;
+	const struct rc5t583_irq_data *data = &rc5t583_irqs[__irq];
+
+	rc5t583->group_irq_en[data->grp_index] |= 1 << data->grp_index;
+	rc5t583->intc_inten_reg |= 1 << data->master_bit;
+	rc5t583->irq_en_reg[data->mask_reg_index] |= 1 << data->int_en_bit;
+}
+
+static void rc5t583_irq_mask(struct irq_data *irq_data)
+{
+	struct rc5t583 *rc5t583 = irq_data_get_irq_chip_data(irq_data);
+	unsigned int __irq = irq_data->irq - rc5t583->irq_base;
+	const struct rc5t583_irq_data *data = &rc5t583_irqs[__irq];
+
+	rc5t583->group_irq_en[data->grp_index] &= ~(1 << data->grp_index);
+	if (!rc5t583->group_irq_en[data->grp_index])
+		rc5t583->intc_inten_reg &= ~(1 << data->master_bit);
+
+	rc5t583->irq_en_reg[data->mask_reg_index] &= ~(1 << data->int_en_bit);
+}
+
+static int rc5t583_irq_set_type(struct irq_data *irq_data, unsigned int type)
+{
+	struct rc5t583 *rc5t583 = irq_data_get_irq_chip_data(irq_data);
+	unsigned int __irq = irq_data->irq - rc5t583->irq_base;
+	const struct rc5t583_irq_data *data = &rc5t583_irqs[__irq];
+	int val = 0;
+	int gpedge_index;
+	int gpedge_bit_pos;
+
+	/* Supporting only trigger level inetrrupt */
+	if ((data->int_type & GPIO_INT) && (type & IRQ_TYPE_EDGE_BOTH)) {
+		gpedge_index = data->int_en_bit / 4;
+		gpedge_bit_pos = data->int_en_bit % 4;
+
+		if (type & IRQ_TYPE_EDGE_FALLING)
+			val |= 0x2;
+
+		if (type & IRQ_TYPE_EDGE_RISING)
+			val |= 0x1;
+
+		rc5t583->gpedge_reg[gpedge_index] &= ~(3 << gpedge_bit_pos);
+		rc5t583->gpedge_reg[gpedge_index] |= (val << gpedge_bit_pos);
+		rc5t583_irq_unmask(irq_data);
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static void rc5t583_irq_sync_unlock(struct irq_data *irq_data)
+{
+	struct rc5t583 *rc5t583 = irq_data_get_irq_chip_data(irq_data);
+	int i;
+	int ret;
+
+	for (i = 0; i < ARRAY_SIZE(rc5t583->gpedge_reg); i++) {
+		ret = rc5t583_write(rc5t583->dev, gpedge_add[i],
+				rc5t583->gpedge_reg[i]);
+		if (ret < 0)
+			dev_warn(rc5t583->dev,
+				"Error in writing reg 0x%02x error: %d\n",
+				gpedge_add[i], ret);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(rc5t583->irq_en_reg); i++) {
+		ret = rc5t583_write(rc5t583->dev, irq_en_add[i],
+					rc5t583->irq_en_reg[i]);
+		if (ret < 0)
+			dev_warn(rc5t583->dev,
+				"Error in writing reg 0x%02x error: %d\n",
+				irq_en_add[i], ret);
+	}
+
+	ret = rc5t583_write(rc5t583->dev, RC5T583_INTC_INTEN,
+				rc5t583->intc_inten_reg);
+	if (ret < 0)
+		dev_warn(rc5t583->dev,
+			"Error in writing reg 0x%02x error: %d\n",
+			RC5T583_INTC_INTEN, ret);
+
+	mutex_unlock(&rc5t583->irq_lock);
+}
+#ifdef CONFIG_PM_SLEEP
+static int rc5t583_irq_set_wake(struct irq_data *irq_data, unsigned int on)
+{
+	struct rc5t583 *rc5t583 = irq_data_get_irq_chip_data(irq_data);
+	return irq_set_irq_wake(rc5t583->chip_irq, on);
+}
+#else
+#define rc5t583_irq_set_wake NULL
+#endif
+
+static irqreturn_t rc5t583_irq(int irq, void *data)
+{
+	struct rc5t583 *rc5t583 = data;
+	uint8_t int_sts[RC5T583_MAX_INTERRUPT_MASK_REGS];
+	uint8_t master_int;
+	int i;
+	int ret;
+	unsigned int rtc_int_sts = 0;
+
+	/* Clear the status */
+	for (i = 0; i < RC5T583_MAX_INTERRUPT_MASK_REGS; i++)
+		int_sts[i] = 0;
+
+	ret  = rc5t583_read(rc5t583->dev, RC5T583_INTC_INTMON, &master_int);
+	if (ret < 0) {
+		dev_err(rc5t583->dev,
+			"Error in reading reg 0x%02x error: %d\n",
+			RC5T583_INTC_INTMON, ret);
+		return IRQ_HANDLED;
+	}
+
+	for (i = 0; i < RC5T583_MAX_INTERRUPT_MASK_REGS; ++i) {
+		if (!(master_int & main_int_type[i]))
+			continue;
+
+		ret = rc5t583_read(rc5t583->dev, irq_mon_add[i], &int_sts[i]);
+		if (ret < 0) {
+			dev_warn(rc5t583->dev,
+				"Error in reading reg 0x%02x error: %d\n",
+				irq_mon_add[i], ret);
+			int_sts[i] = 0;
+			continue;
+		}
+
+		if (main_int_type[i] & RTC_INT) {
+			rtc_int_sts = 0;
+			if (int_sts[i] & 0x1)
+				rtc_int_sts |= BIT(6);
+			if (int_sts[i] & 0x2)
+				rtc_int_sts |= BIT(7);
+			if (int_sts[i] & 0x4)
+				rtc_int_sts |= BIT(0);
+			if (int_sts[i] & 0x8)
+				rtc_int_sts |= BIT(5);
+		}
+
+		ret = rc5t583_write(rc5t583->dev, irq_clr_add[i],
+				~int_sts[i]);
+		if (ret < 0)
+			dev_warn(rc5t583->dev,
+				"Error in reading reg 0x%02x error: %d\n",
+				irq_clr_add[i], ret);
+
+		if (main_int_type[i] & RTC_INT)
+			int_sts[i] = rtc_int_sts;
+	}
+
+	/* Merge gpio interrupts for rising and falling case*/
+	int_sts[7] |= int_sts[8];
+
+	/* Call interrupt handler if enabled */
+	for (i = 0; i < RC5T583_MAX_IRQS; ++i) {
+		const struct rc5t583_irq_data *data = &rc5t583_irqs[i];
+		if ((int_sts[data->mask_reg_index] & (1 << data->int_en_bit)) &&
+			(rc5t583->group_irq_en[data->master_bit] &
+					(1 << data->grp_index)))
+			handle_nested_irq(rc5t583->irq_base + i);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static struct irq_chip rc5t583_irq_chip = {
+	.name = "rc5t583-irq",
+	.irq_mask = rc5t583_irq_mask,
+	.irq_unmask = rc5t583_irq_unmask,
+	.irq_bus_lock = rc5t583_irq_lock,
+	.irq_bus_sync_unlock = rc5t583_irq_sync_unlock,
+	.irq_set_type = rc5t583_irq_set_type,
+	.irq_set_wake = rc5t583_irq_set_wake,
+};
+
+int rc5t583_irq_init(struct rc5t583 *rc5t583, int irq, int irq_base)
+{
+	int i, ret;
+
+	if (!irq_base) {
+		dev_warn(rc5t583->dev, "No interrupt support on IRQ base\n");
+		return -EINVAL;
+	}
+
+	mutex_init(&rc5t583->irq_lock);
+
+	/* Initailize all int register to 0 */
+	for (i = 0; i < RC5T583_MAX_INTERRUPT_MASK_REGS; i++)  {
+		ret = rc5t583_write(rc5t583->dev, irq_en_add[i],
+				rc5t583->irq_en_reg[i]);
+		if (ret < 0)
+			dev_warn(rc5t583->dev,
+				"Error in writing reg 0x%02x error: %d\n",
+				irq_en_add[i], ret);
+	}
+
+	for (i = 0; i < RC5T583_MAX_GPEDGE_REG; i++)  {
+		ret = rc5t583_write(rc5t583->dev, gpedge_add[i],
+				rc5t583->gpedge_reg[i]);
+		if (ret < 0)
+			dev_warn(rc5t583->dev,
+				"Error in writing reg 0x%02x error: %d\n",
+				gpedge_add[i], ret);
+	}
+
+	ret = rc5t583_write(rc5t583->dev, RC5T583_INTC_INTEN, 0x0);
+	if (ret < 0)
+		dev_warn(rc5t583->dev,
+			"Error in writing reg 0x%02x error: %d\n",
+			RC5T583_INTC_INTEN, ret);
+
+	/* Clear all interrupts in case they woke up active. */
+	for (i = 0; i < RC5T583_MAX_INTERRUPT_MASK_REGS; i++)  {
+		ret = rc5t583_write(rc5t583->dev, irq_clr_add[i], 0);
+		if (ret < 0)
+			dev_warn(rc5t583->dev,
+				"Error in writing reg 0x%02x error: %d\n",
+				irq_clr_add[i], ret);
+	}
+
+	rc5t583->irq_base = irq_base;
+	rc5t583->chip_irq = irq;
+
+	for (i = 0; i < RC5T583_MAX_IRQS; i++) {
+		int __irq = i + rc5t583->irq_base;
+		irq_set_chip_data(__irq, rc5t583);
+		irq_set_chip_and_handler(__irq, &rc5t583_irq_chip,
+					 handle_simple_irq);
+		irq_set_nested_thread(__irq, 1);
+#ifdef CONFIG_ARM
+		set_irq_flags(__irq, IRQF_VALID);
+#endif
+	}
+
+	ret = request_threaded_irq(irq, NULL, rc5t583_irq, IRQF_ONESHOT,
+				"rc5t583", rc5t583);
+	if (ret < 0)
+		dev_err(rc5t583->dev,
+			"Error in registering interrupt error: %d\n", ret);
+	return ret;
+}
+
+int rc5t583_irq_exit(struct rc5t583 *rc5t583)
+{
+	if (rc5t583->chip_irq)
+		free_irq(rc5t583->chip_irq, rc5t583);
+	return 0;
+}
diff --git a/drivers/mfd/rc5t583.c b/drivers/mfd/rc5t583.c
new file mode 100644
index 0000000..99ef944
--- /dev/null
+++ b/drivers/mfd/rc5t583.c
@@ -0,0 +1,386 @@
+/*
+ * Core driver access RC5T583 power management chip.
+ *
+ * Copyright (c) 2011-2012, NVIDIA CORPORATION.  All rights reserved.
+ * Author: Laxman dewangan <ldewangan@nvidia.com>
+ *
+ * Based on code
+ *	Copyright (C) 2011 RICOH COMPANY,LTD
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/rc5t583.h>
+#include <linux/regmap.h>
+
+#define RICOH_ONOFFSEL_REG	0x10
+#define RICOH_SWCTL_REG		0x5E
+
+struct deepsleep_control_data {
+	u8 reg_add;
+	u8 ds_pos_bit;
+};
+
+#define DEEPSLEEP_INIT(_id, _reg, _pos)		\
+	{					\
+		.reg_add = RC5T583_##_reg,	\
+		.ds_pos_bit = _pos,		\
+	}
+
+static struct deepsleep_control_data deepsleep_data[] = {
+	DEEPSLEEP_INIT(DC0, SLPSEQ1, 0),
+	DEEPSLEEP_INIT(DC1, SLPSEQ1, 4),
+	DEEPSLEEP_INIT(DC2, SLPSEQ2, 0),
+	DEEPSLEEP_INIT(DC3, SLPSEQ2, 4),
+	DEEPSLEEP_INIT(LDO0, SLPSEQ3, 0),
+	DEEPSLEEP_INIT(LDO1, SLPSEQ3, 4),
+	DEEPSLEEP_INIT(LDO2, SLPSEQ4, 0),
+	DEEPSLEEP_INIT(LDO3, SLPSEQ4, 4),
+	DEEPSLEEP_INIT(LDO4, SLPSEQ5, 0),
+	DEEPSLEEP_INIT(LDO5, SLPSEQ5, 4),
+	DEEPSLEEP_INIT(LDO6, SLPSEQ6, 0),
+	DEEPSLEEP_INIT(LDO7, SLPSEQ6, 4),
+	DEEPSLEEP_INIT(LDO8, SLPSEQ7, 0),
+	DEEPSLEEP_INIT(LDO9, SLPSEQ7, 4),
+	DEEPSLEEP_INIT(PSO0, SLPSEQ8, 0),
+	DEEPSLEEP_INIT(PSO1, SLPSEQ8, 4),
+	DEEPSLEEP_INIT(PSO2, SLPSEQ9, 0),
+	DEEPSLEEP_INIT(PSO3, SLPSEQ9, 4),
+	DEEPSLEEP_INIT(PSO4, SLPSEQ10, 0),
+	DEEPSLEEP_INIT(PSO5, SLPSEQ10, 4),
+	DEEPSLEEP_INIT(PSO6, SLPSEQ11, 0),
+	DEEPSLEEP_INIT(PSO7, SLPSEQ11, 4),
+};
+
+#define EXT_PWR_REQ		\
+	(RC5T583_EXT_PWRREQ1_CONTROL | RC5T583_EXT_PWRREQ2_CONTROL)
+
+static struct mfd_cell rc5t583_subdevs[] = {
+	{.name = "rc5t583-regulator",},
+	{.name = "rc5t583-rtc",      },
+	{.name = "rc5t583-key",      }
+};
+
+int rc5t583_write(struct device *dev, uint8_t reg, uint8_t val)
+{
+	struct rc5t583 *rc5t583 = dev_get_drvdata(dev);
+	return regmap_write(rc5t583->regmap, reg, val);
+}
+
+int rc5t583_read(struct device *dev, uint8_t reg, uint8_t *val)
+{
+	struct rc5t583 *rc5t583 = dev_get_drvdata(dev);
+	unsigned int ival;
+	int ret;
+	ret = regmap_read(rc5t583->regmap, reg, &ival);
+	if (!ret)
+		*val = (uint8_t)ival;
+	return ret;
+}
+
+int rc5t583_set_bits(struct device *dev, unsigned int reg,
+			unsigned int bit_mask)
+{
+	struct rc5t583 *rc5t583 = dev_get_drvdata(dev);
+	return regmap_update_bits(rc5t583->regmap, reg, bit_mask, bit_mask);
+}
+
+int rc5t583_clear_bits(struct device *dev, unsigned int reg,
+			unsigned int bit_mask)
+{
+	struct rc5t583 *rc5t583 = dev_get_drvdata(dev);
+	return regmap_update_bits(rc5t583->regmap, reg, bit_mask, 0);
+}
+
+int rc5t583_update(struct device *dev, unsigned int reg,
+		unsigned int val, unsigned int mask)
+{
+	struct rc5t583 *rc5t583 = dev_get_drvdata(dev);
+	return regmap_update_bits(rc5t583->regmap, reg, mask, val);
+}
+
+static int __rc5t583_set_ext_pwrreq1_control(struct device *dev,
+	int id, int ext_pwr, int slots)
+{
+	int ret;
+	uint8_t sleepseq_val;
+	unsigned int en_bit;
+	unsigned int slot_bit;
+
+	if (id == RC5T583_DS_DC0) {
+		dev_err(dev, "PWRREQ1 is invalid control for rail %d\n", id);
+		return -EINVAL;
+	}
+
+	en_bit = deepsleep_data[id].ds_pos_bit;
+	slot_bit = en_bit + 1;
+	ret = rc5t583_read(dev, deepsleep_data[id].reg_add, &sleepseq_val);
+	if (ret < 0) {
+		dev_err(dev, "Error in reading reg 0x%x\n",
+				deepsleep_data[id].reg_add);
+		return ret;
+	}
+
+	sleepseq_val &= ~(0xF << en_bit);
+	sleepseq_val |= BIT(en_bit);
+	sleepseq_val |= ((slots & 0x7) << slot_bit);
+	ret = rc5t583_set_bits(dev, RICOH_ONOFFSEL_REG, BIT(1));
+	if (ret < 0) {
+		dev_err(dev, "Error in updating the 0x%02x register\n",
+				RICOH_ONOFFSEL_REG);
+		return ret;
+	}
+
+	ret = rc5t583_write(dev, deepsleep_data[id].reg_add, sleepseq_val);
+	if (ret < 0) {
+		dev_err(dev, "Error in writing reg 0x%x\n",
+				deepsleep_data[id].reg_add);
+		return ret;
+	}
+
+	if (id == RC5T583_DS_LDO4) {
+		ret = rc5t583_write(dev, RICOH_SWCTL_REG, 0x1);
+		if (ret < 0)
+			dev_err(dev, "Error in writing reg 0x%x\n",
+				RICOH_SWCTL_REG);
+	}
+	return ret;
+}
+
+static int __rc5t583_set_ext_pwrreq2_control(struct device *dev,
+	int id, int ext_pwr)
+{
+	int ret;
+
+	if (id != RC5T583_DS_DC0) {
+		dev_err(dev, "PWRREQ2 is invalid control for rail %d\n", id);
+		return -EINVAL;
+	}
+
+	ret = rc5t583_set_bits(dev, RICOH_ONOFFSEL_REG, BIT(2));
+	if (ret < 0)
+		dev_err(dev, "Error in updating the ONOFFSEL 0x10 register\n");
+	return ret;
+}
+
+int rc5t583_ext_power_req_config(struct device *dev, int ds_id,
+	int ext_pwr_req, int deepsleep_slot_nr)
+{
+	if ((ext_pwr_req & EXT_PWR_REQ) == EXT_PWR_REQ)
+		return -EINVAL;
+
+	if (ext_pwr_req & RC5T583_EXT_PWRREQ1_CONTROL)
+		return __rc5t583_set_ext_pwrreq1_control(dev, ds_id,
+				ext_pwr_req, deepsleep_slot_nr);
+
+	if (ext_pwr_req & RC5T583_EXT_PWRREQ2_CONTROL)
+		return __rc5t583_set_ext_pwrreq2_control(dev,
+			ds_id, ext_pwr_req);
+	return 0;
+}
+
+static int rc5t583_clear_ext_power_req(struct rc5t583 *rc5t583,
+	struct rc5t583_platform_data *pdata)
+{
+	int ret;
+	int i;
+	uint8_t on_off_val = 0;
+
+	/*  Clear ONOFFSEL register */
+	if (pdata->enable_shutdown)
+		on_off_val = 0x1;
+
+	ret = rc5t583_write(rc5t583->dev, RICOH_ONOFFSEL_REG, on_off_val);
+	if (ret < 0)
+		dev_warn(rc5t583->dev, "Error in writing reg %d error: %d\n",
+					RICOH_ONOFFSEL_REG, ret);
+
+	ret = rc5t583_write(rc5t583->dev, RICOH_SWCTL_REG, 0x0);
+	if (ret < 0)
+		dev_warn(rc5t583->dev, "Error in writing reg %d error: %d\n",
+					RICOH_SWCTL_REG, ret);
+
+	/* Clear sleep sequence register */
+	for (i = RC5T583_SLPSEQ1; i <= RC5T583_SLPSEQ11; ++i) {
+		ret = rc5t583_write(rc5t583->dev, i, 0x0);
+		if (ret < 0)
+			dev_warn(rc5t583->dev,
+				"Error in writing reg 0x%02x error: %d\n",
+				i, ret);
+	}
+	return 0;
+}
+
+static bool volatile_reg(struct device *dev, unsigned int reg)
+{
+	/* Enable caching in interrupt registers */
+	switch (reg) {
+	case RC5T583_INT_EN_SYS1:
+	case RC5T583_INT_EN_SYS2:
+	case RC5T583_INT_EN_DCDC:
+	case RC5T583_INT_EN_RTC:
+	case RC5T583_INT_EN_ADC1:
+	case RC5T583_INT_EN_ADC2:
+	case RC5T583_INT_EN_ADC3:
+	case RC5T583_GPIO_GPEDGE1:
+	case RC5T583_GPIO_GPEDGE2:
+	case RC5T583_GPIO_EN_INT:
+		return false;
+
+	case RC5T583_GPIO_MON_IOIN:
+		/* This is gpio input register */
+		return true;
+
+	default:
+		/* Enable caching in gpio registers */
+		if ((reg >= RC5T583_GPIO_IOSEL) &&
+				(reg <= RC5T583_GPIO_GPOFUNC))
+			return false;
+
+		/* Enable caching in sleep seq registers */
+		if ((reg >= RC5T583_SLPSEQ1) && (reg <= RC5T583_SLPSEQ11))
+			return false;
+
+		/* Enable caching of regulator registers */
+		if ((reg >= RC5T583_REG_DC0CTL) && (reg <= RC5T583_REG_SR3CTL))
+			return false;
+		if ((reg >= RC5T583_REG_LDOEN1) &&
+					(reg <= RC5T583_REG_LDO9DAC_DS))
+			return false;
+
+		break;
+	}
+
+	return true;
+}
+
+static const struct regmap_config rc5t583_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.volatile_reg = volatile_reg,
+	.max_register = RC5T583_MAX_REGS,
+	.num_reg_defaults_raw = RC5T583_MAX_REGS,
+	.cache_type = REGCACHE_RBTREE,
+};
+
+static int __devinit rc5t583_i2c_probe(struct i2c_client *i2c,
+			      const struct i2c_device_id *id)
+{
+	struct rc5t583 *rc5t583;
+	struct rc5t583_platform_data *pdata = i2c->dev.platform_data;
+	int ret;
+	bool irq_init_success = false;
+
+	if (!pdata) {
+		dev_err(&i2c->dev, "Err: Platform data not found\n");
+		return -EINVAL;
+	}
+
+	rc5t583 = devm_kzalloc(&i2c->dev, sizeof(struct rc5t583), GFP_KERNEL);
+	if (!rc5t583) {
+		dev_err(&i2c->dev, "Memory allocation failed\n");
+		return -ENOMEM;
+	}
+
+	rc5t583->dev = &i2c->dev;
+	i2c_set_clientdata(i2c, rc5t583);
+
+	rc5t583->regmap = regmap_init_i2c(i2c, &rc5t583_regmap_config);
+	if (IS_ERR(rc5t583->regmap)) {
+		ret = PTR_ERR(rc5t583->regmap);
+		dev_err(&i2c->dev, "regmap initialization failed: %d\n", ret);
+		return ret;
+	}
+
+	ret = rc5t583_clear_ext_power_req(rc5t583, pdata);
+	if (ret < 0)
+		goto err_irq_init;
+
+	if (i2c->irq) {
+		ret = rc5t583_irq_init(rc5t583, i2c->irq, pdata->irq_base);
+		/* Still continue with waring if irq init fails */
+		if (ret)
+			dev_warn(&i2c->dev, "IRQ init failed: %d\n", ret);
+		else
+			irq_init_success = true;
+	}
+
+	ret = mfd_add_devices(rc5t583->dev, -1, rc5t583_subdevs,
+			ARRAY_SIZE(rc5t583_subdevs), NULL, 0);
+	if (ret) {
+		dev_err(&i2c->dev, "add mfd devices failed: %d\n", ret);
+		goto err_add_devs;
+	}
+
+	return 0;
+
+err_add_devs:
+	if (irq_init_success)
+		rc5t583_irq_exit(rc5t583);
+err_irq_init:
+	regmap_exit(rc5t583->regmap);
+	return ret;
+}
+
+static int  __devexit rc5t583_i2c_remove(struct i2c_client *i2c)
+{
+	struct rc5t583 *rc5t583 = i2c_get_clientdata(i2c);
+
+	mfd_remove_devices(rc5t583->dev);
+	rc5t583_irq_exit(rc5t583);
+	regmap_exit(rc5t583->regmap);
+	return 0;
+}
+
+static const struct i2c_device_id rc5t583_i2c_id[] = {
+	{.name = "rc5t583", .driver_data = 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, rc5t583_i2c_id);
+
+static struct i2c_driver rc5t583_i2c_driver = {
+	.driver = {
+		   .name = "rc5t583",
+		   .owner = THIS_MODULE,
+		   },
+	.probe = rc5t583_i2c_probe,
+	.remove = __devexit_p(rc5t583_i2c_remove),
+	.id_table = rc5t583_i2c_id,
+};
+
+static int __init rc5t583_i2c_init(void)
+{
+	return i2c_add_driver(&rc5t583_i2c_driver);
+}
+subsys_initcall(rc5t583_i2c_init);
+
+static void __exit rc5t583_i2c_exit(void)
+{
+	i2c_del_driver(&rc5t583_i2c_driver);
+}
+
+module_exit(rc5t583_i2c_exit);
+
+MODULE_AUTHOR("Laxman Dewangan <ldewangan@nvidia.com>");
+MODULE_DESCRIPTION("RICOH RC5T583 power management system device driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/mfd/rc5t583.h b/include/linux/mfd/rc5t583.h
new file mode 100644
index 0000000..a2c6160
--- /dev/null
+++ b/include/linux/mfd/rc5t583.h
@@ -0,0 +1,295 @@
+/*
+ * Core driver interface to access RICOH_RC5T583 power management chip.
+ *
+ * Copyright (c) 2011-2012, NVIDIA CORPORATION.  All rights reserved.
+ * Author: Laxman dewangan <ldewangan@nvidia.com>
+ *
+ * Based on code
+ *      Copyright (C) 2011 RICOH COMPANY,LTD
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+#ifndef __LINUX_MFD_RC5T583_H
+#define __LINUX_MFD_RC5T583_H
+
+#include <linux/mutex.h>
+#include <linux/types.h>
+
+#define RC5T583_MAX_REGS		0xF8
+
+/* Maximum number of main interrupts */
+#define MAX_MAIN_INTERRUPT		5
+#define RC5T583_MAX_GPEDGE_REG		2
+#define RC5T583_MAX_INTERRUPT_MASK_REGS	9
+
+/* Interrupt enable register */
+#define RC5T583_INT_EN_SYS1	0x19
+#define RC5T583_INT_EN_SYS2	0x1D
+#define RC5T583_INT_EN_DCDC	0x41
+#define RC5T583_INT_EN_RTC	0xED
+#define RC5T583_INT_EN_ADC1	0x90
+#define RC5T583_INT_EN_ADC2	0x91
+#define RC5T583_INT_EN_ADC3	0x92
+
+/* Interrupt status registers (monitor regs in Ricoh)*/
+#define RC5T583_INTC_INTPOL	0xAD
+#define RC5T583_INTC_INTEN	0xAE
+#define RC5T583_INTC_INTMON	0xAF
+
+#define RC5T583_INT_MON_GRP	0xAF
+#define RC5T583_INT_MON_SYS1	0x1B
+#define RC5T583_INT_MON_SYS2	0x1F
+#define RC5T583_INT_MON_DCDC	0x43
+#define RC5T583_INT_MON_RTC	0xEE
+
+/* Interrupt clearing registers */
+#define RC5T583_INT_IR_SYS1	0x1A
+#define RC5T583_INT_IR_SYS2	0x1E
+#define RC5T583_INT_IR_DCDC	0x42
+#define RC5T583_INT_IR_RTC	0xEE
+#define RC5T583_INT_IR_ADCL	0x94
+#define RC5T583_INT_IR_ADCH	0x95
+#define RC5T583_INT_IR_ADCEND	0x96
+#define RC5T583_INT_IR_GPIOR	0xA9
+#define RC5T583_INT_IR_GPIOF	0xAA
+
+/* Sleep sequence registers */
+#define RC5T583_SLPSEQ1		0x21
+#define RC5T583_SLPSEQ2		0x22
+#define RC5T583_SLPSEQ3		0x23
+#define RC5T583_SLPSEQ4		0x24
+#define RC5T583_SLPSEQ5		0x25
+#define RC5T583_SLPSEQ6		0x26
+#define RC5T583_SLPSEQ7		0x27
+#define RC5T583_SLPSEQ8		0x28
+#define RC5T583_SLPSEQ9		0x29
+#define RC5T583_SLPSEQ10	0x2A
+#define RC5T583_SLPSEQ11	0x2B
+
+/* Regulator registers */
+#define RC5T583_REG_DC0CTL	0x30
+#define RC5T583_REG_DC0DAC	0x31
+#define RC5T583_REG_DC0LATCTL	0x32
+#define RC5T583_REG_SR0CTL	0x33
+
+#define RC5T583_REG_DC1CTL	0x34
+#define RC5T583_REG_DC1DAC	0x35
+#define RC5T583_REG_DC1LATCTL	0x36
+#define RC5T583_REG_SR1CTL	0x37
+
+#define RC5T583_REG_DC2CTL	0x38
+#define RC5T583_REG_DC2DAC	0x39
+#define RC5T583_REG_DC2LATCTL	0x3A
+#define RC5T583_REG_SR2CTL	0x3B
+
+#define RC5T583_REG_DC3CTL	0x3C
+#define RC5T583_REG_DC3DAC	0x3D
+#define RC5T583_REG_DC3LATCTL	0x3E
+#define RC5T583_REG_SR3CTL	0x3F
+
+
+#define RC5T583_REG_LDOEN1	0x50
+#define RC5T583_REG_LDOEN2	0x51
+#define RC5T583_REG_LDODIS1	0x52
+#define RC5T583_REG_LDODIS2	0x53
+
+#define RC5T583_REG_LDO0DAC	0x54
+#define RC5T583_REG_LDO1DAC	0x55
+#define RC5T583_REG_LDO2DAC	0x56
+#define RC5T583_REG_LDO3DAC	0x57
+#define RC5T583_REG_LDO4DAC	0x58
+#define RC5T583_REG_LDO5DAC	0x59
+#define RC5T583_REG_LDO6DAC	0x5A
+#define RC5T583_REG_LDO7DAC	0x5B
+#define RC5T583_REG_LDO8DAC	0x5C
+#define RC5T583_REG_LDO9DAC	0x5D
+
+#define RC5T583_REG_DC0DAC_DS	0x60
+#define RC5T583_REG_DC1DAC_DS	0x61
+#define RC5T583_REG_DC2DAC_DS	0x62
+#define RC5T583_REG_DC3DAC_DS	0x63
+
+#define RC5T583_REG_LDO0DAC_DS	0x64
+#define RC5T583_REG_LDO1DAC_DS	0x65
+#define RC5T583_REG_LDO2DAC_DS	0x66
+#define RC5T583_REG_LDO3DAC_DS	0x67
+#define RC5T583_REG_LDO4DAC_DS	0x68
+#define RC5T583_REG_LDO5DAC_DS	0x69
+#define RC5T583_REG_LDO6DAC_DS	0x6A
+#define RC5T583_REG_LDO7DAC_DS	0x6B
+#define RC5T583_REG_LDO8DAC_DS	0x6C
+#define RC5T583_REG_LDO9DAC_DS	0x6D
+
+/* GPIO register base address */
+#define RC5T583_GPIO_IOSEL	0xA0
+#define RC5T583_GPIO_PDEN	0xA1
+#define RC5T583_GPIO_IOOUT	0xA2
+#define RC5T583_GPIO_PGSEL	0xA3
+#define RC5T583_GPIO_GPINV	0xA4
+#define RC5T583_GPIO_GPDEB	0xA5
+#define RC5T583_GPIO_GPEDGE1	0xA6
+#define RC5T583_GPIO_GPEDGE2	0xA7
+#define RC5T583_GPIO_EN_INT	0xA8
+#define RC5T583_GPIO_MON_IOIN	0xAB
+#define RC5T583_GPIO_GPOFUNC	0xAC
+
+/* RICOH_RC5T583 IRQ definitions */
+enum {
+	RC5T583_IRQ_ONKEY,
+	RC5T583_IRQ_ACOK,
+	RC5T583_IRQ_LIDOPEN,
+	RC5T583_IRQ_PREOT,
+	RC5T583_IRQ_CLKSTP,
+	RC5T583_IRQ_ONKEY_OFF,
+	RC5T583_IRQ_WD,
+	RC5T583_IRQ_EN_PWRREQ1,
+	RC5T583_IRQ_EN_PWRREQ2,
+	RC5T583_IRQ_PRE_VINDET,
+
+	RC5T583_IRQ_DC0LIM,
+	RC5T583_IRQ_DC1LIM,
+	RC5T583_IRQ_DC2LIM,
+	RC5T583_IRQ_DC3LIM,
+
+	RC5T583_IRQ_CTC,
+	RC5T583_IRQ_YALE,
+	RC5T583_IRQ_DALE,
+	RC5T583_IRQ_WALE,
+
+	RC5T583_IRQ_AIN1L,
+	RC5T583_IRQ_AIN2L,
+	RC5T583_IRQ_AIN3L,
+	RC5T583_IRQ_VBATL,
+	RC5T583_IRQ_VIN3L,
+	RC5T583_IRQ_VIN8L,
+	RC5T583_IRQ_AIN1H,
+	RC5T583_IRQ_AIN2H,
+	RC5T583_IRQ_AIN3H,
+	RC5T583_IRQ_VBATH,
+	RC5T583_IRQ_VIN3H,
+	RC5T583_IRQ_VIN8H,
+	RC5T583_IRQ_ADCEND,
+
+	RC5T583_IRQ_GPIO0,
+	RC5T583_IRQ_GPIO1,
+	RC5T583_IRQ_GPIO2,
+	RC5T583_IRQ_GPIO3,
+	RC5T583_IRQ_GPIO4,
+	RC5T583_IRQ_GPIO5,
+	RC5T583_IRQ_GPIO6,
+	RC5T583_IRQ_GPIO7,
+
+	/* Should be last entry */
+	RC5T583_MAX_IRQS,
+};
+
+/* Ricoh583 gpio definitions */
+enum {
+	RC5T583_GPIO0,
+	RC5T583_GPIO1,
+	RC5T583_GPIO2,
+	RC5T583_GPIO3,
+	RC5T583_GPIO4,
+	RC5T583_GPIO5,
+	RC5T583_GPIO6,
+	RC5T583_GPIO7,
+
+	/* Should be last entry */
+	RC5T583_MAX_GPIO,
+};
+
+enum {
+	RC5T583_DS_NONE,
+	RC5T583_DS_DC0,
+	RC5T583_DS_DC1,
+	RC5T583_DS_DC2,
+	RC5T583_DS_DC3,
+	RC5T583_DS_LDO0,
+	RC5T583_DS_LDO1,
+	RC5T583_DS_LDO2,
+	RC5T583_DS_LDO3,
+	RC5T583_DS_LDO4,
+	RC5T583_DS_LDO5,
+	RC5T583_DS_LDO6,
+	RC5T583_DS_LDO7,
+	RC5T583_DS_LDO8,
+	RC5T583_DS_LDO9,
+	RC5T583_DS_PSO0,
+	RC5T583_DS_PSO1,
+	RC5T583_DS_PSO2,
+	RC5T583_DS_PSO3,
+	RC5T583_DS_PSO4,
+	RC5T583_DS_PSO5,
+	RC5T583_DS_PSO6,
+	RC5T583_DS_PSO7,
+
+	/* Should be last entry */
+	RC5T583_DS_MAX,
+};
+
+/*
+ * Ricoh pmic RC5T583 supports sleep through two external controls.
+ * The output of gpios and regulator can be enable/disable through
+ * this external signals.
+ */
+enum {
+	RC5T583_EXT_PWRREQ1_CONTROL = 0x1,
+	RC5T583_EXT_PWRREQ2_CONTROL = 0x2,
+};
+
+struct rc5t583 {
+	struct device	*dev;
+	struct regmap	*regmap;
+	int		chip_irq;
+	int		irq_base;
+	struct mutex	irq_lock;
+	unsigned long	group_irq_en[MAX_MAIN_INTERRUPT];
+
+	/* For main interrupt bits in INTC */
+	uint8_t		intc_inten_reg;
+
+	/* For group interrupt bits and address */
+	uint8_t		irq_en_reg[RC5T583_MAX_INTERRUPT_MASK_REGS];
+
+	/* For gpio edge */
+	uint8_t		gpedge_reg[RC5T583_MAX_GPEDGE_REG];
+};
+
+/*
+ * rc5t583_platform_data: Platform data for ricoh rc5t583 pmu.
+ * The board specific data is provided through this structure.
+ * @irq_base: Irq base number on which this device registers their interrupts.
+ * @enable_shutdown: Enable shutdown through the input pin "shutdown".
+ */
+
+struct rc5t583_platform_data {
+	int		irq_base;
+	bool		enable_shutdown;
+};
+
+int rc5t583_write(struct device *dev, u8 reg, uint8_t val);
+int rc5t583_read(struct device *dev, uint8_t reg, uint8_t *val);
+int rc5t583_set_bits(struct device *dev, unsigned int reg,
+		unsigned int bit_mask);
+int rc5t583_clear_bits(struct device *dev, unsigned int reg,
+		unsigned int bit_mask);
+int rc5t583_update(struct device *dev, unsigned int reg,
+		unsigned int val, unsigned int mask);
+int rc5t583_ext_power_req_config(struct device *dev, int deepsleep_id,
+	int ext_pwr_req, int deepsleep_slot_nr);
+int rc5t583_irq_init(struct rc5t583 *rc5t583, int irq, int irq_base);
+int rc5t583_irq_exit(struct rc5t583 *rc5t583);
+
+#endif
-- 
1.7.1.1

