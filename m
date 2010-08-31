Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab0HaASc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 20:18:32 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53596 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692Ab0HaASa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 20:18:30 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6090"; a="52801943"
From: Gregory Bean <gbean@codeaurora.org>
To: dwalker@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Gregory Bean <gbean@codeaurora.org>
Subject: [PATCH 1/2] msm: Install the Google-Android gpio driver.
Date: Mon, 30 Aug 2010 17:18:25 -0700
Message-Id: <1283213906-17671-1-git-send-email-gbean@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

As part of the ongoing effort to converge on a common code base,
adopt the Google-Android msmgpio driver, as it has a stronger pedigree
than the previous submission from codeaurora.

Cc: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Gregory Bean <gbean@codeaurora.org>
---
 arch/arm/mach-msm/Makefile  |    3 +
 arch/arm/mach-msm/gpio.c    |  627 +++++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/gpio_hw.h |  277 +++++++++++++++++++
 3 files changed, 907 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-msm/gpio.c
 create mode 100644 arch/arm/mach-msm/gpio_hw.h

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 2263b8f..c95d19a 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -22,3 +22,6 @@ obj-$(CONFIG_ARCH_QSD8X50) += board-qsd8x50.o devices-qsd8x50.o
 obj-$(CONFIG_ARCH_MSM7X30) += gpiomux-7x30.o gpiomux-v1.o gpiomux.o
 obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-8x50.o gpiomux-v1.o gpiomux.o
 obj-$(CONFIG_ARCH_MSM8X60) += gpiomux-8x60.o gpiomux-v2.o gpiomux.o
+ifndef CONFIG_MSM_V2_TLMM
+obj-y	+= gpio.o
+endif
diff --git a/arch/arm/mach-msm/gpio.c b/arch/arm/mach-msm/gpio.c
new file mode 100644
index 0000000..fd899a1
--- /dev/null
+++ b/arch/arm/mach-msm/gpio.c
@@ -0,0 +1,627 @@
+/* linux/arch/arm/mach-msm/gpio.c
+ *
+ * Copyright (C) 2007 Google, Inc.
+ * Copyright (c) 2009-2010, Code Aurora Forum. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/bitops.h>
+#include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/module.h>
+#include "gpio_hw.h"
+#include "proc_comm.h"
+#include "smd_private.h"
+
+#define FIRST_GPIO_IRQ MSM_GPIO_TO_INT(0)
+
+enum {
+	GPIO_DEBUG_SLEEP = 1U << 0,
+};
+static int msm_gpio_debug_mask;
+module_param_named(debug_mask, msm_gpio_debug_mask, int,
+		   S_IRUGO | S_IWUSR | S_IWGRP);
+
+#define MSM_GPIO_BROKEN_INT_CLEAR 1
+
+struct msm_gpio_regs {
+	void __iomem *out;
+	void __iomem *in;
+	void __iomem *int_status;
+	void __iomem *int_clear;
+	void __iomem *int_en;
+	void __iomem *int_edge;
+	void __iomem *int_pos;
+	void __iomem *oe;
+};
+
+struct msm_gpio_chip {
+	spinlock_t		lock;
+	struct gpio_chip	chip;
+	struct msm_gpio_regs	regs;
+#if MSM_GPIO_BROKEN_INT_CLEAR
+	unsigned                int_status_copy;
+#endif
+	unsigned int            both_edge_detect;
+	unsigned int            int_enable[2]; /* 0: awake, 1: sleep */
+};
+
+static int msm_gpio_write(struct msm_gpio_chip *msm_chip,
+			  unsigned offset, unsigned on)
+{
+	unsigned b = 1U << offset;
+	unsigned v;
+
+	v = readl(msm_chip->regs.out);
+	if (on)
+		writel(v | b, msm_chip->regs.out);
+	else
+		writel(v & (~b), msm_chip->regs.out);
+	return 0;
+}
+
+static void msm_gpio_update_both_edge_detect(struct msm_gpio_chip *msm_chip)
+{
+	int loop_limit = 100;
+	unsigned pol, val, val2, intstat;
+	do {
+		val = readl(msm_chip->regs.in);
+		pol = readl(msm_chip->regs.int_pos);
+		pol = (pol & ~msm_chip->both_edge_detect) |
+		      (~val & msm_chip->both_edge_detect);
+		writel(pol, msm_chip->regs.int_pos);
+		intstat = readl(msm_chip->regs.int_status);
+		val2 = readl(msm_chip->regs.in);
+		if (((val ^ val2) & msm_chip->both_edge_detect & ~intstat) == 0)
+			return;
+	} while (loop_limit-- > 0);
+	printk(KERN_ERR "msm_gpio_update_both_edge_detect, "
+	       "failed to reach stable state %x != %x\n", val, val2);
+}
+
+static int msm_gpio_clear_detect_status(struct msm_gpio_chip *msm_chip,
+					unsigned offset)
+{
+	unsigned b = BIT(offset);
+
+#if MSM_GPIO_BROKEN_INT_CLEAR
+	/* Save interrupts that already triggered before we loose them. */
+	/* Any interrupt that triggers between the read of int_status */
+	/* and the write to int_clear will still be lost though. */
+	msm_chip->int_status_copy |= readl(msm_chip->regs.int_status);
+	msm_chip->int_status_copy &= ~b;
+#endif
+	writel(b, msm_chip->regs.int_clear);
+	msm_gpio_update_both_edge_detect(msm_chip);
+	return 0;
+}
+
+static int msm_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	struct msm_gpio_chip *msm_chip;
+	unsigned long irq_flags;
+
+	msm_chip = container_of(chip, struct msm_gpio_chip, chip);
+	spin_lock_irqsave(&msm_chip->lock, irq_flags);
+	writel(readl(msm_chip->regs.oe) & ~BIT(offset), msm_chip->regs.oe);
+	spin_unlock_irqrestore(&msm_chip->lock, irq_flags);
+	return 0;
+}
+
+static int
+msm_gpio_direction_output(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct msm_gpio_chip *msm_chip;
+	unsigned long irq_flags;
+
+	msm_chip = container_of(chip, struct msm_gpio_chip, chip);
+	spin_lock_irqsave(&msm_chip->lock, irq_flags);
+	msm_gpio_write(msm_chip, offset, value);
+	writel(readl(msm_chip->regs.oe) | BIT(offset), msm_chip->regs.oe);
+	spin_unlock_irqrestore(&msm_chip->lock, irq_flags);
+	return 0;
+}
+
+static int msm_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct msm_gpio_chip *msm_chip;
+
+	msm_chip = container_of(chip, struct msm_gpio_chip, chip);
+	return (readl(msm_chip->regs.in) & (1U << offset)) ? 1 : 0;
+}
+
+static void msm_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct msm_gpio_chip *msm_chip;
+	unsigned long irq_flags;
+
+	msm_chip = container_of(chip, struct msm_gpio_chip, chip);
+	spin_lock_irqsave(&msm_chip->lock, irq_flags);
+	msm_gpio_write(msm_chip, offset, value);
+	spin_unlock_irqrestore(&msm_chip->lock, irq_flags);
+}
+
+static int msm_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	return MSM_GPIO_TO_INT(chip->base + offset);
+}
+
+struct msm_gpio_chip msm_gpio_chips[] = {
+	{
+		.regs = {
+			.out =         GPIO_OUT_0,
+			.in =          GPIO_IN_0,
+			.int_status =  GPIO_INT_STATUS_0,
+			.int_clear =   GPIO_INT_CLEAR_0,
+			.int_en =      GPIO_INT_EN_0,
+			.int_edge =    GPIO_INT_EDGE_0,
+			.int_pos =     GPIO_INT_POS_0,
+			.oe =          GPIO_OE_0,
+		},
+		.chip = {
+			.base = 0,
+			.ngpio = 16,
+			.get = msm_gpio_get,
+			.set = msm_gpio_set,
+			.direction_input = msm_gpio_direction_input,
+			.direction_output = msm_gpio_direction_output,
+			.to_irq = msm_gpio_to_irq,
+		}
+	},
+	{
+		.regs = {
+			.out =         GPIO_OUT_1,
+			.in =          GPIO_IN_1,
+			.int_status =  GPIO_INT_STATUS_1,
+			.int_clear =   GPIO_INT_CLEAR_1,
+			.int_en =      GPIO_INT_EN_1,
+			.int_edge =    GPIO_INT_EDGE_1,
+			.int_pos =     GPIO_INT_POS_1,
+			.oe =          GPIO_OE_1,
+		},
+		.chip = {
+			.base = 16,
+#if defined(CONFIG_ARCH_MSM7X30)
+			.ngpio = 28,
+#else
+			.ngpio = 27,
+#endif
+			.get = msm_gpio_get,
+			.set = msm_gpio_set,
+			.direction_input = msm_gpio_direction_input,
+			.direction_output = msm_gpio_direction_output,
+			.to_irq = msm_gpio_to_irq,
+		}
+	},
+	{
+		.regs = {
+			.out =         GPIO_OUT_2,
+			.in =          GPIO_IN_2,
+			.int_status =  GPIO_INT_STATUS_2,
+			.int_clear =   GPIO_INT_CLEAR_2,
+			.int_en =      GPIO_INT_EN_2,
+			.int_edge =    GPIO_INT_EDGE_2,
+			.int_pos =     GPIO_INT_POS_2,
+			.oe =          GPIO_OE_2,
+		},
+		.chip = {
+#if defined(CONFIG_ARCH_MSM7X30)
+			.base = 44,
+			.ngpio = 24,
+#else
+			.base = 43,
+			.ngpio = 25,
+#endif
+			.get = msm_gpio_get,
+			.set = msm_gpio_set,
+			.direction_input = msm_gpio_direction_input,
+			.direction_output = msm_gpio_direction_output,
+			.to_irq = msm_gpio_to_irq,
+		}
+	},
+	{
+		.regs = {
+			.out =         GPIO_OUT_3,
+			.in =          GPIO_IN_3,
+			.int_status =  GPIO_INT_STATUS_3,
+			.int_clear =   GPIO_INT_CLEAR_3,
+			.int_en =      GPIO_INT_EN_3,
+			.int_edge =    GPIO_INT_EDGE_3,
+			.int_pos =     GPIO_INT_POS_3,
+			.oe =          GPIO_OE_3,
+		},
+		.chip = {
+			.base = 68,
+			.ngpio = 27,
+			.get = msm_gpio_get,
+			.set = msm_gpio_set,
+			.direction_input = msm_gpio_direction_input,
+			.direction_output = msm_gpio_direction_output,
+			.to_irq = msm_gpio_to_irq,
+		}
+	},
+	{
+		.regs = {
+			.out =         GPIO_OUT_4,
+			.in =          GPIO_IN_4,
+			.int_status =  GPIO_INT_STATUS_4,
+			.int_clear =   GPIO_INT_CLEAR_4,
+			.int_en =      GPIO_INT_EN_4,
+			.int_edge =    GPIO_INT_EDGE_4,
+			.int_pos =     GPIO_INT_POS_4,
+			.oe =          GPIO_OE_4,
+		},
+		.chip = {
+			.base = 95,
+#if defined(CONFIG_ARCH_QSD8X50)
+			.ngpio = 9,
+#else
+			.ngpio = 12,
+#endif
+			.get = msm_gpio_get,
+			.set = msm_gpio_set,
+			.direction_input = msm_gpio_direction_input,
+			.direction_output = msm_gpio_direction_output,
+			.to_irq = msm_gpio_to_irq,
+		}
+	},
+	{
+		.regs = {
+			.out =         GPIO_OUT_5,
+			.in =          GPIO_IN_5,
+			.int_status =  GPIO_INT_STATUS_5,
+			.int_clear =   GPIO_INT_CLEAR_5,
+			.int_en =      GPIO_INT_EN_5,
+			.int_edge =    GPIO_INT_EDGE_5,
+			.int_pos =     GPIO_INT_POS_5,
+			.oe =          GPIO_OE_5,
+		},
+		.chip = {
+#if defined(CONFIG_ARCH_QSD8X50)
+			.base = 104,
+			.ngpio = 18,
+#elif defined(CONFIG_ARCH_MSM7X30)
+			.base = 107,
+			.ngpio = 27,
+#elif defined(CONFIG_ARCH_MSM7X27)
+			.base = 107,
+			.ngpio = 26,
+#else
+			.base = 107,
+			.ngpio = 15,
+#endif
+			.get = msm_gpio_get,
+			.set = msm_gpio_set,
+			.direction_input = msm_gpio_direction_input,
+			.direction_output = msm_gpio_direction_output,
+			.to_irq = msm_gpio_to_irq,
+		}
+	},
+#if defined(CONFIG_ARCH_QSD8X50) || defined(CONFIG_ARCH_MSM7X30)
+	{
+		.regs = {
+			.out =         GPIO_OUT_6,
+			.in =          GPIO_IN_6,
+			.int_status =  GPIO_INT_STATUS_6,
+			.int_clear =   GPIO_INT_CLEAR_6,
+			.int_en =      GPIO_INT_EN_6,
+			.int_edge =    GPIO_INT_EDGE_6,
+			.int_pos =     GPIO_INT_POS_6,
+			.oe =          GPIO_OE_6,
+		},
+		.chip = {
+#if defined(CONFIG_ARCH_MSM7X30)
+			.base = 134,
+			.ngpio = 17,
+#else
+			.base = 122,
+			.ngpio = 31,
+#endif
+			.get = msm_gpio_get,
+			.set = msm_gpio_set,
+			.direction_input = msm_gpio_direction_input,
+			.direction_output = msm_gpio_direction_output,
+			.to_irq = msm_gpio_to_irq,
+		}
+	},
+	{
+		.regs = {
+			.out =         GPIO_OUT_7,
+			.in =          GPIO_IN_7,
+			.int_status =  GPIO_INT_STATUS_7,
+			.int_clear =   GPIO_INT_CLEAR_7,
+			.int_en =      GPIO_INT_EN_7,
+			.int_edge =    GPIO_INT_EDGE_7,
+			.int_pos =     GPIO_INT_POS_7,
+			.oe =          GPIO_OE_7,
+		},
+		.chip = {
+#if defined(CONFIG_ARCH_MSM7X30)
+			.base = 151,
+			.ngpio = 31,
+#else
+			.base = 153,
+			.ngpio = 12,
+#endif
+			.get = msm_gpio_get,
+			.set = msm_gpio_set,
+			.direction_input = msm_gpio_direction_input,
+			.direction_output = msm_gpio_direction_output,
+			.to_irq = msm_gpio_to_irq,
+		}
+	},
+#endif
+};
+
+static void msm_gpio_irq_ack(unsigned int irq)
+{
+	unsigned long irq_flags;
+	struct msm_gpio_chip *msm_chip = get_irq_chip_data(irq);
+	spin_lock_irqsave(&msm_chip->lock, irq_flags);
+	msm_gpio_clear_detect_status(msm_chip,
+				     irq - gpio_to_irq(msm_chip->chip.base));
+	spin_unlock_irqrestore(&msm_chip->lock, irq_flags);
+}
+
+static void msm_gpio_irq_mask(unsigned int irq)
+{
+	unsigned long irq_flags;
+	struct msm_gpio_chip *msm_chip = get_irq_chip_data(irq);
+	unsigned offset = irq - gpio_to_irq(msm_chip->chip.base);
+
+	spin_lock_irqsave(&msm_chip->lock, irq_flags);
+	/* level triggered interrupts are also latched */
+	if (!(readl(msm_chip->regs.int_edge) & BIT(offset)))
+		msm_gpio_clear_detect_status(msm_chip, offset);
+	msm_chip->int_enable[0] &= ~BIT(offset);
+	writel(msm_chip->int_enable[0], msm_chip->regs.int_en);
+	spin_unlock_irqrestore(&msm_chip->lock, irq_flags);
+}
+
+static void msm_gpio_irq_unmask(unsigned int irq)
+{
+	unsigned long irq_flags;
+	struct msm_gpio_chip *msm_chip = get_irq_chip_data(irq);
+	unsigned offset = irq - gpio_to_irq(msm_chip->chip.base);
+
+	spin_lock_irqsave(&msm_chip->lock, irq_flags);
+	/* level triggered interrupts are also latched */
+	if (!(readl(msm_chip->regs.int_edge) & BIT(offset)))
+		msm_gpio_clear_detect_status(msm_chip, offset);
+	msm_chip->int_enable[0] |= BIT(offset);
+	writel(msm_chip->int_enable[0], msm_chip->regs.int_en);
+	spin_unlock_irqrestore(&msm_chip->lock, irq_flags);
+}
+
+static int msm_gpio_irq_set_wake(unsigned int irq, unsigned int on)
+{
+	unsigned long irq_flags;
+	struct msm_gpio_chip *msm_chip = get_irq_chip_data(irq);
+	unsigned offset = irq - gpio_to_irq(msm_chip->chip.base);
+
+	spin_lock_irqsave(&msm_chip->lock, irq_flags);
+
+	if (on)
+		msm_chip->int_enable[1] |= BIT(offset);
+	else
+		msm_chip->int_enable[1] &= ~BIT(offset);
+
+	spin_unlock_irqrestore(&msm_chip->lock, irq_flags);
+	return 0;
+}
+
+static int msm_gpio_irq_set_type(unsigned int irq, unsigned int flow_type)
+{
+	unsigned long irq_flags;
+	struct msm_gpio_chip *msm_chip = get_irq_chip_data(irq);
+	unsigned offset = irq - gpio_to_irq(msm_chip->chip.base);
+	unsigned v, b = BIT(offset);
+
+	spin_lock_irqsave(&msm_chip->lock, irq_flags);
+	v = readl(msm_chip->regs.int_edge);
+	if (flow_type & IRQ_TYPE_EDGE_BOTH) {
+		writel(v | b, msm_chip->regs.int_edge);
+		irq_desc[irq].handle_irq = handle_edge_irq;
+	} else {
+		writel(v & ~b, msm_chip->regs.int_edge);
+		irq_desc[irq].handle_irq = handle_level_irq;
+	}
+	if ((flow_type & IRQ_TYPE_EDGE_BOTH) == IRQ_TYPE_EDGE_BOTH) {
+		msm_chip->both_edge_detect |= b;
+		msm_gpio_update_both_edge_detect(msm_chip);
+	} else {
+		msm_chip->both_edge_detect &= ~b;
+		v = readl(msm_chip->regs.int_pos);
+		if (flow_type & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_HIGH))
+			writel(v | b, msm_chip->regs.int_pos);
+		else
+			writel(v & ~b, msm_chip->regs.int_pos);
+	}
+	spin_unlock_irqrestore(&msm_chip->lock, irq_flags);
+	return 0;
+}
+
+static void msm_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
+{
+	int i, j, m;
+	unsigned v;
+
+	for (i = 0; i < ARRAY_SIZE(msm_gpio_chips); i++) {
+		struct msm_gpio_chip *msm_chip = &msm_gpio_chips[i];
+		v = readl(msm_chip->regs.int_status);
+		v &= msm_chip->int_enable[0];
+		while (v) {
+			m = v & -v;
+			j = fls(m) - 1;
+			/* printk("%s %08x %08x bit %d gpio %d irq %d\n",
+				__func__, v, m, j, msm_chip->chip.start + j,
+				FIRST_GPIO_IRQ + msm_chip->chip.start + j); */
+			v &= ~m;
+			generic_handle_irq(FIRST_GPIO_IRQ +
+					   msm_chip->chip.base + j);
+		}
+	}
+	desc->chip->ack(irq);
+}
+
+static struct irq_chip msm_gpio_irq_chip = {
+	.name      = "msmgpio",
+	.ack       = msm_gpio_irq_ack,
+	.mask      = msm_gpio_irq_mask,
+	.unmask    = msm_gpio_irq_unmask,
+	.set_wake  = msm_gpio_irq_set_wake,
+	.set_type  = msm_gpio_irq_set_type,
+};
+
+#define NUM_GPIO_SMEM_BANKS 6
+#define GPIO_SMEM_NUM_GROUPS 2
+#define GPIO_SMEM_MAX_PC_INTERRUPTS 8
+struct tramp_gpio_smem {
+	uint16_t num_fired[GPIO_SMEM_NUM_GROUPS];
+	uint16_t fired[GPIO_SMEM_NUM_GROUPS][GPIO_SMEM_MAX_PC_INTERRUPTS];
+	uint32_t enabled[NUM_GPIO_SMEM_BANKS];
+	uint32_t detection[NUM_GPIO_SMEM_BANKS];
+	uint32_t polarity[NUM_GPIO_SMEM_BANKS];
+};
+
+static void msm_gpio_sleep_int(unsigned long arg)
+{
+	int i, j;
+	struct tramp_gpio_smem *smem_gpio;
+
+	BUILD_BUG_ON(NR_GPIO_IRQS > NUM_GPIO_SMEM_BANKS * 32);
+
+	smem_gpio = smem_alloc(SMEM_GPIO_INT, sizeof(*smem_gpio));
+	if (smem_gpio == NULL)
+		return;
+
+	local_irq_disable();
+	for (i = 0; i < GPIO_SMEM_NUM_GROUPS; i++) {
+		int count = smem_gpio->num_fired[i];
+		for (j = 0; j < count; j++) {
+			/* TODO: Check mask */
+			generic_handle_irq(
+				MSM_GPIO_TO_INT(smem_gpio->fired[i][j]));
+		}
+	}
+	local_irq_enable();
+}
+
+static DECLARE_TASKLET(msm_gpio_sleep_int_tasklet, msm_gpio_sleep_int, 0);
+
+void msm_gpio_enter_sleep(int from_idle)
+{
+	int i;
+	struct tramp_gpio_smem *smem_gpio;
+
+	smem_gpio = smem_alloc(SMEM_GPIO_INT, sizeof(*smem_gpio));
+
+	if (smem_gpio) {
+		for (i = 0; i < ARRAY_SIZE(smem_gpio->enabled); i++) {
+			smem_gpio->enabled[i] = 0;
+			smem_gpio->detection[i] = 0;
+			smem_gpio->polarity[i] = 0;
+		}
+	}
+
+	for (i = 0; i < ARRAY_SIZE(msm_gpio_chips); i++) {
+		writel(msm_gpio_chips[i].int_enable[!from_idle],
+		       msm_gpio_chips[i].regs.int_en);
+		if (smem_gpio) {
+			uint32_t tmp;
+			int start, index, shiftl, shiftr;
+			start = msm_gpio_chips[i].chip.base;
+			index = start / 32;
+			shiftl = start % 32;
+			shiftr = 32 - shiftl;
+			tmp = msm_gpio_chips[i].int_enable[!from_idle];
+			smem_gpio->enabled[index] |= tmp << shiftl;
+			smem_gpio->enabled[index+1] |= tmp >> shiftr;
+			smem_gpio->detection[index] |=
+				readl(msm_gpio_chips[i].regs.int_edge) <<
+				shiftl;
+			smem_gpio->detection[index+1] |=
+				readl(msm_gpio_chips[i].regs.int_edge) >>
+				shiftr;
+			smem_gpio->polarity[index] |=
+				readl(msm_gpio_chips[i].regs.int_pos) << shiftl;
+			smem_gpio->polarity[index+1] |=
+				readl(msm_gpio_chips[i].regs.int_pos) >> shiftr;
+		}
+	}
+
+	if (smem_gpio) {
+		if (msm_gpio_debug_mask & GPIO_DEBUG_SLEEP)
+			for (i = 0; i < ARRAY_SIZE(smem_gpio->enabled); i++) {
+				printk("msm_gpio_enter_sleep gpio %d-%d: enable"
+				       " %08x, edge %08x, polarity %08x\n",
+				       i * 32, i * 32 + 31,
+				       smem_gpio->enabled[i],
+				       smem_gpio->detection[i],
+				       smem_gpio->polarity[i]);
+			}
+		for (i = 0; i < GPIO_SMEM_NUM_GROUPS; i++)
+			smem_gpio->num_fired[i] = 0;
+	}
+}
+
+void msm_gpio_exit_sleep(void)
+{
+	int i;
+	struct tramp_gpio_smem *smem_gpio;
+
+	smem_gpio = smem_alloc(SMEM_GPIO_INT, sizeof(*smem_gpio));
+
+	for (i = 0; i < ARRAY_SIZE(msm_gpio_chips); i++) {
+		writel(msm_gpio_chips[i].int_enable[0],
+		       msm_gpio_chips[i].regs.int_en);
+	}
+
+	if (smem_gpio && (smem_gpio->num_fired[0] || smem_gpio->num_fired[1])) {
+		if (msm_gpio_debug_mask & GPIO_DEBUG_SLEEP)
+			printk(KERN_INFO "gpio: fired %x %x\n",
+			      smem_gpio->num_fired[0], smem_gpio->num_fired[1]);
+		tasklet_schedule(&msm_gpio_sleep_int_tasklet);
+	}
+}
+
+static int __init msm_init_gpio(void)
+{
+	int i, j = 0;
+
+	for (i = FIRST_GPIO_IRQ; i < FIRST_GPIO_IRQ + NR_GPIO_IRQS; i++) {
+		if (i - FIRST_GPIO_IRQ >=
+			msm_gpio_chips[j].chip.base +
+			msm_gpio_chips[j].chip.ngpio)
+			j++;
+		set_irq_chip_data(i, &msm_gpio_chips[j]);
+		set_irq_chip(i, &msm_gpio_irq_chip);
+		set_irq_handler(i, handle_edge_irq);
+		set_irq_flags(i, IRQF_VALID);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(msm_gpio_chips); i++) {
+		spin_lock_init(&msm_gpio_chips[i].lock);
+		writel(0, msm_gpio_chips[i].regs.int_en);
+		gpiochip_add(&msm_gpio_chips[i].chip);
+	}
+
+	set_irq_chained_handler(INT_GPIO_GROUP1, msm_gpio_irq_handler);
+	set_irq_chained_handler(INT_GPIO_GROUP2, msm_gpio_irq_handler);
+	set_irq_wake(INT_GPIO_GROUP1, 1);
+	set_irq_wake(INT_GPIO_GROUP2, 2);
+	return 0;
+}
+
+postcore_initcall(msm_init_gpio);
diff --git a/arch/arm/mach-msm/gpio_hw.h b/arch/arm/mach-msm/gpio_hw.h
new file mode 100644
index 0000000..74c22cf
--- /dev/null
+++ b/arch/arm/mach-msm/gpio_hw.h
@@ -0,0 +1,277 @@
+/* arch/arm/mach-msm/gpio_hw.h
+ *
+ * Copyright (C) 2007 Google, Inc.
+ * Author: Brian Swetland <swetland@google.com>
+ * Copyright (c) 2008-2010, Code Aurora Forum. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __ARCH_ARM_MACH_MSM_GPIO_HW_H
+#define __ARCH_ARM_MACH_MSM_GPIO_HW_H
+
+#include <mach/msm_iomap.h>
+
+/* see 80-VA736-2 Rev C pp 695-751
+**
+** These are actually the *shadow* gpio registers, since the
+** real ones (which allow full access) are only available to the
+** ARM9 side of the world.
+**
+** Since the _BASE need to be page-aligned when we're mapping them
+** to virtual addresses, adjust for the additional offset in these
+** macros.
+*/
+
+#if defined(CONFIG_ARCH_MSM7X30)
+#define GPIO1_REG(off) (MSM_GPIO1_BASE + (off))
+#define GPIO2_REG(off) (MSM_GPIO2_BASE + 0x400 + (off))
+#else
+#define GPIO1_REG(off) (MSM_GPIO1_BASE + 0x800 + (off))
+#define GPIO2_REG(off) (MSM_GPIO2_BASE + 0xC00 + (off))
+#endif
+
+#if defined(CONFIG_ARCH_MSM7X00A) || defined(CONFIG_ARCH_MSM7X27)
+
+/* output value */
+#define GPIO_OUT_0         GPIO1_REG(0x00)  /* gpio  15-0  */
+#define GPIO_OUT_1         GPIO2_REG(0x00)  /* gpio  42-16 */
+#define GPIO_OUT_2         GPIO1_REG(0x04)  /* gpio  67-43 */
+#define GPIO_OUT_3         GPIO1_REG(0x08)  /* gpio  94-68 */
+#define GPIO_OUT_4         GPIO1_REG(0x0C)  /* gpio 106-95 */
+#define GPIO_OUT_5         GPIO1_REG(0x50)  /* gpio 107-121 */
+
+/* same pin map as above, output enable */
+#define GPIO_OE_0          GPIO1_REG(0x10)
+#define GPIO_OE_1          GPIO2_REG(0x08)
+#define GPIO_OE_2          GPIO1_REG(0x14)
+#define GPIO_OE_3          GPIO1_REG(0x18)
+#define GPIO_OE_4          GPIO1_REG(0x1C)
+#define GPIO_OE_5          GPIO1_REG(0x54)
+
+/* same pin map as above, input read */
+#define GPIO_IN_0          GPIO1_REG(0x34)
+#define GPIO_IN_1          GPIO2_REG(0x20)
+#define GPIO_IN_2          GPIO1_REG(0x38)
+#define GPIO_IN_3          GPIO1_REG(0x3C)
+#define GPIO_IN_4          GPIO1_REG(0x40)
+#define GPIO_IN_5          GPIO1_REG(0x44)
+
+/* same pin map as above, 1=edge 0=level interrup */
+#define GPIO_INT_EDGE_0    GPIO1_REG(0x60)
+#define GPIO_INT_EDGE_1    GPIO2_REG(0x50)
+#define GPIO_INT_EDGE_2    GPIO1_REG(0x64)
+#define GPIO_INT_EDGE_3    GPIO1_REG(0x68)
+#define GPIO_INT_EDGE_4    GPIO1_REG(0x6C)
+#define GPIO_INT_EDGE_5    GPIO1_REG(0xC0)
+
+/* same pin map as above, 1=positive 0=negative */
+#define GPIO_INT_POS_0     GPIO1_REG(0x70)
+#define GPIO_INT_POS_1     GPIO2_REG(0x58)
+#define GPIO_INT_POS_2     GPIO1_REG(0x74)
+#define GPIO_INT_POS_3     GPIO1_REG(0x78)
+#define GPIO_INT_POS_4     GPIO1_REG(0x7C)
+#define GPIO_INT_POS_5     GPIO1_REG(0xBC)
+
+/* same pin map as above, interrupt enable */
+#define GPIO_INT_EN_0      GPIO1_REG(0x80)
+#define GPIO_INT_EN_1      GPIO2_REG(0x60)
+#define GPIO_INT_EN_2      GPIO1_REG(0x84)
+#define GPIO_INT_EN_3      GPIO1_REG(0x88)
+#define GPIO_INT_EN_4      GPIO1_REG(0x8C)
+#define GPIO_INT_EN_5      GPIO1_REG(0xB8)
+
+/* same pin map as above, write 1 to clear interrupt */
+#define GPIO_INT_CLEAR_0   GPIO1_REG(0x90)
+#define GPIO_INT_CLEAR_1   GPIO2_REG(0x68)
+#define GPIO_INT_CLEAR_2   GPIO1_REG(0x94)
+#define GPIO_INT_CLEAR_3   GPIO1_REG(0x98)
+#define GPIO_INT_CLEAR_4   GPIO1_REG(0x9C)
+#define GPIO_INT_CLEAR_5   GPIO1_REG(0xB4)
+
+/* same pin map as above, 1=interrupt pending */
+#define GPIO_INT_STATUS_0  GPIO1_REG(0xA0)
+#define GPIO_INT_STATUS_1  GPIO2_REG(0x70)
+#define GPIO_INT_STATUS_2  GPIO1_REG(0xA4)
+#define GPIO_INT_STATUS_3  GPIO1_REG(0xA8)
+#define GPIO_INT_STATUS_4  GPIO1_REG(0xAC)
+#define GPIO_INT_STATUS_5  GPIO1_REG(0xB0)
+
+#endif
+
+#if defined(CONFIG_ARCH_QSD8X50)
+/* output value */
+#define GPIO_OUT_0         GPIO1_REG(0x00)  /* gpio  15-0   */
+#define GPIO_OUT_1         GPIO2_REG(0x00)  /* gpio  42-16  */
+#define GPIO_OUT_2         GPIO1_REG(0x04)  /* gpio  67-43  */
+#define GPIO_OUT_3         GPIO1_REG(0x08)  /* gpio  94-68  */
+#define GPIO_OUT_4         GPIO1_REG(0x0C)  /* gpio 103-95  */
+#define GPIO_OUT_5         GPIO1_REG(0x10)  /* gpio 121-104 */
+#define GPIO_OUT_6         GPIO1_REG(0x14)  /* gpio 152-122 */
+#define GPIO_OUT_7         GPIO1_REG(0x18)  /* gpio 164-153 */
+
+/* same pin map as above, output enable */
+#define GPIO_OE_0          GPIO1_REG(0x20)
+#define GPIO_OE_1          GPIO2_REG(0x08)
+#define GPIO_OE_2          GPIO1_REG(0x24)
+#define GPIO_OE_3          GPIO1_REG(0x28)
+#define GPIO_OE_4          GPIO1_REG(0x2C)
+#define GPIO_OE_5          GPIO1_REG(0x30)
+#define GPIO_OE_6          GPIO1_REG(0x34)
+#define GPIO_OE_7          GPIO1_REG(0x38)
+
+/* same pin map as above, input read */
+#define GPIO_IN_0          GPIO1_REG(0x50)
+#define GPIO_IN_1          GPIO2_REG(0x20)
+#define GPIO_IN_2          GPIO1_REG(0x54)
+#define GPIO_IN_3          GPIO1_REG(0x58)
+#define GPIO_IN_4          GPIO1_REG(0x5C)
+#define GPIO_IN_5          GPIO1_REG(0x60)
+#define GPIO_IN_6          GPIO1_REG(0x64)
+#define GPIO_IN_7          GPIO1_REG(0x68)
+
+/* same pin map as above, 1=edge 0=level interrup */
+#define GPIO_INT_EDGE_0    GPIO1_REG(0x70)
+#define GPIO_INT_EDGE_1    GPIO2_REG(0x50)
+#define GPIO_INT_EDGE_2    GPIO1_REG(0x74)
+#define GPIO_INT_EDGE_3    GPIO1_REG(0x78)
+#define GPIO_INT_EDGE_4    GPIO1_REG(0x7C)
+#define GPIO_INT_EDGE_5    GPIO1_REG(0x80)
+#define GPIO_INT_EDGE_6    GPIO1_REG(0x84)
+#define GPIO_INT_EDGE_7    GPIO1_REG(0x88)
+
+/* same pin map as above, 1=positive 0=negative */
+#define GPIO_INT_POS_0     GPIO1_REG(0x90)
+#define GPIO_INT_POS_1     GPIO2_REG(0x58)
+#define GPIO_INT_POS_2     GPIO1_REG(0x94)
+#define GPIO_INT_POS_3     GPIO1_REG(0x98)
+#define GPIO_INT_POS_4     GPIO1_REG(0x9C)
+#define GPIO_INT_POS_5     GPIO1_REG(0xA0)
+#define GPIO_INT_POS_6     GPIO1_REG(0xA4)
+#define GPIO_INT_POS_7     GPIO1_REG(0xA8)
+
+/* same pin map as above, interrupt enable */
+#define GPIO_INT_EN_0      GPIO1_REG(0xB0)
+#define GPIO_INT_EN_1      GPIO2_REG(0x60)
+#define GPIO_INT_EN_2      GPIO1_REG(0xB4)
+#define GPIO_INT_EN_3      GPIO1_REG(0xB8)
+#define GPIO_INT_EN_4      GPIO1_REG(0xBC)
+#define GPIO_INT_EN_5      GPIO1_REG(0xC0)
+#define GPIO_INT_EN_6      GPIO1_REG(0xC4)
+#define GPIO_INT_EN_7      GPIO1_REG(0xC8)
+
+/* same pin map as above, write 1 to clear interrupt */
+#define GPIO_INT_CLEAR_0   GPIO1_REG(0xD0)
+#define GPIO_INT_CLEAR_1   GPIO2_REG(0x68)
+#define GPIO_INT_CLEAR_2   GPIO1_REG(0xD4)
+#define GPIO_INT_CLEAR_3   GPIO1_REG(0xD8)
+#define GPIO_INT_CLEAR_4   GPIO1_REG(0xDC)
+#define GPIO_INT_CLEAR_5   GPIO1_REG(0xE0)
+#define GPIO_INT_CLEAR_6   GPIO1_REG(0xE4)
+#define GPIO_INT_CLEAR_7   GPIO1_REG(0xE8)
+
+/* same pin map as above, 1=interrupt pending */
+#define GPIO_INT_STATUS_0  GPIO1_REG(0xF0)
+#define GPIO_INT_STATUS_1  GPIO2_REG(0x70)
+#define GPIO_INT_STATUS_2  GPIO1_REG(0xF4)
+#define GPIO_INT_STATUS_3  GPIO1_REG(0xF8)
+#define GPIO_INT_STATUS_4  GPIO1_REG(0xFC)
+#define GPIO_INT_STATUS_5  GPIO1_REG(0x100)
+#define GPIO_INT_STATUS_6  GPIO1_REG(0x104)
+#define GPIO_INT_STATUS_7  GPIO1_REG(0x108)
+
+#endif
+
+#if defined(CONFIG_ARCH_MSM7X30)
+
+/* output value */
+#define GPIO_OUT_0         GPIO1_REG(0x00)   /* gpio  15-0   */
+#define GPIO_OUT_1         GPIO2_REG(0x00)   /* gpio  43-16  */
+#define GPIO_OUT_2         GPIO1_REG(0x04)   /* gpio  67-44  */
+#define GPIO_OUT_3         GPIO1_REG(0x08)   /* gpio  94-68  */
+#define GPIO_OUT_4         GPIO1_REG(0x0C)   /* gpio 106-95  */
+#define GPIO_OUT_5         GPIO1_REG(0x50)   /* gpio 133-107 */
+#define GPIO_OUT_6         GPIO1_REG(0xC4)   /* gpio 150-134 */
+#define GPIO_OUT_7         GPIO1_REG(0x214)  /* gpio 181-151 */
+
+/* same pin map as above, output enable */
+#define GPIO_OE_0          GPIO1_REG(0x10)
+#define GPIO_OE_1          GPIO2_REG(0x08)
+#define GPIO_OE_2          GPIO1_REG(0x14)
+#define GPIO_OE_3          GPIO1_REG(0x18)
+#define GPIO_OE_4          GPIO1_REG(0x1C)
+#define GPIO_OE_5          GPIO1_REG(0x54)
+#define GPIO_OE_6          GPIO1_REG(0xC8)
+#define GPIO_OE_7          GPIO1_REG(0x218)
+
+/* same pin map as above, input read */
+#define GPIO_IN_0          GPIO1_REG(0x34)
+#define GPIO_IN_1          GPIO2_REG(0x20)
+#define GPIO_IN_2          GPIO1_REG(0x38)
+#define GPIO_IN_3          GPIO1_REG(0x3C)
+#define GPIO_IN_4          GPIO1_REG(0x40)
+#define GPIO_IN_5          GPIO1_REG(0x44)
+#define GPIO_IN_6          GPIO1_REG(0xCC)
+#define GPIO_IN_7          GPIO1_REG(0x21C)
+
+/* same pin map as above, 1=edge 0=level interrup */
+#define GPIO_INT_EDGE_0    GPIO1_REG(0x60)
+#define GPIO_INT_EDGE_1    GPIO2_REG(0x50)
+#define GPIO_INT_EDGE_2    GPIO1_REG(0x64)
+#define GPIO_INT_EDGE_3    GPIO1_REG(0x68)
+#define GPIO_INT_EDGE_4    GPIO1_REG(0x6C)
+#define GPIO_INT_EDGE_5    GPIO1_REG(0xC0)
+#define GPIO_INT_EDGE_6    GPIO1_REG(0xD0)
+#define GPIO_INT_EDGE_7    GPIO1_REG(0x240)
+
+/* same pin map as above, 1=positive 0=negative */
+#define GPIO_INT_POS_0     GPIO1_REG(0x70)
+#define GPIO_INT_POS_1     GPIO2_REG(0x58)
+#define GPIO_INT_POS_2     GPIO1_REG(0x74)
+#define GPIO_INT_POS_3     GPIO1_REG(0x78)
+#define GPIO_INT_POS_4     GPIO1_REG(0x7C)
+#define GPIO_INT_POS_5     GPIO1_REG(0xBC)
+#define GPIO_INT_POS_6     GPIO1_REG(0xD4)
+#define GPIO_INT_POS_7     GPIO1_REG(0x228)
+
+/* same pin map as above, interrupt enable */
+#define GPIO_INT_EN_0      GPIO1_REG(0x80)
+#define GPIO_INT_EN_1      GPIO2_REG(0x60)
+#define GPIO_INT_EN_2      GPIO1_REG(0x84)
+#define GPIO_INT_EN_3      GPIO1_REG(0x88)
+#define GPIO_INT_EN_4      GPIO1_REG(0x8C)
+#define GPIO_INT_EN_5      GPIO1_REG(0xB8)
+#define GPIO_INT_EN_6      GPIO1_REG(0xD8)
+#define GPIO_INT_EN_7      GPIO1_REG(0x22C)
+
+/* same pin map as above, write 1 to clear interrupt */
+#define GPIO_INT_CLEAR_0   GPIO1_REG(0x90)
+#define GPIO_INT_CLEAR_1   GPIO2_REG(0x68)
+#define GPIO_INT_CLEAR_2   GPIO1_REG(0x94)
+#define GPIO_INT_CLEAR_3   GPIO1_REG(0x98)
+#define GPIO_INT_CLEAR_4   GPIO1_REG(0x9C)
+#define GPIO_INT_CLEAR_5   GPIO1_REG(0xB4)
+#define GPIO_INT_CLEAR_6   GPIO1_REG(0xDC)
+#define GPIO_INT_CLEAR_7   GPIO1_REG(0x230)
+
+/* same pin map as above, 1=interrupt pending */
+#define GPIO_INT_STATUS_0  GPIO1_REG(0xA0)
+#define GPIO_INT_STATUS_1  GPIO2_REG(0x70)
+#define GPIO_INT_STATUS_2  GPIO1_REG(0xA4)
+#define GPIO_INT_STATUS_3  GPIO1_REG(0xA8)
+#define GPIO_INT_STATUS_4  GPIO1_REG(0xAC)
+#define GPIO_INT_STATUS_5  GPIO1_REG(0xB0)
+#define GPIO_INT_STATUS_6  GPIO1_REG(0xE0)
+#define GPIO_INT_STATUS_7  GPIO1_REG(0x234)
+
+#endif
+
+#endif
-- 
1.7.0.4

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
