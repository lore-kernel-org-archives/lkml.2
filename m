Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab0GGNPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 09:15:09 -0400
Received: from fb2.tech.numericable.fr ([82.216.111.50]:49863 "EHLO
	fb2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab0GGNPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 09:15:05 -0400
From: Thibaut Girka <thib@sitedethib.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Thibaut Girka <thib@sitedethib.com>
Subject: [PATCH 1/4] Smedia Glamo 3362 core/resource driver
Date: Wed,  7 Jul 2010 15:12:03 +0200
Message-Id: <1278508326-7109-2-git-send-email-thib@sitedethib.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278508326-7109-1-git-send-email-thib@sitedethib.com>
References: <1278508326-7109-1-git-send-email-thib@sitedethib.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver provides base support for the Smedia Glamo 3362 multi-function device.

Signed-off-by: Thibaut Girka <thib@sitedethib.com>
---
 drivers/mfd/Kconfig            |    8 +
 drivers/mfd/Makefile           |    1 +
 drivers/mfd/glamo-core.c       | 1299 ++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/glamo-core.h |   58 ++
 include/linux/mfd/glamo-regs.h |  630 +++++++++++++++++++
 include/linux/mfd/glamo.h      |   54 ++
 6 files changed, 2050 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/glamo-core.c
 create mode 100644 include/linux/mfd/glamo-core.h
 create mode 100644 include/linux/mfd/glamo-regs.h
 create mode 100644 include/linux/mfd/glamo.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 9da0e50..7937883 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -505,4 +505,12 @@ config MCP_UCB1200_TS
 	tristate "Touchscreen interface support"
 	depends on MCP_UCB1200 && INPUT
 
+config MFD_GLAMO
+	bool "Smedia Glamo 336x/337x support"
+	select MFD_CORE
+	help
+	  This enables the core driver for the Smedia Glamo 336x/337x
+	  multi-function device.  It includes irq_chip demultiplex as
+	  well as clock / power management and GPIO support.
+
 endmenu
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index fb503e7..54ae9b3 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_MFD_88PM860X)	+= 88pm860x.o
 obj-$(CONFIG_MFD_SM501)		+= sm501.o
 obj-$(CONFIG_MFD_ASIC3)		+= asic3.o tmio_core.o
 obj-$(CONFIG_MFD_SH_MOBILE_SDHI)		+= sh_mobile_sdhi.o
+obj-$(CONFIG_MFD_GLAMO)		+= glamo-core.o
 
 obj-$(CONFIG_HTC_EGPIO)		+= htc-egpio.o
 obj-$(CONFIG_HTC_PASIC3)	+= htc-pasic3.o
diff --git a/drivers/mfd/glamo-core.c b/drivers/mfd/glamo-core.c
new file mode 100644
index 0000000..8220906
--- /dev/null
+++ b/drivers/mfd/glamo-core.c
@@ -0,0 +1,1299 @@
+/* Smedia Glamo 3362 driver
+ *
+ * (C) 2007 by Openmoko, Inc.
+ * Author: Harald Welte <laforge@openmoko.org>
+ * (C) 2009, Lars-Peter Clausen <lars@metafoo.de>
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/platform_device.h>
+#include <linux/kernel_stat.h>
+#include <linux/spinlock.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/glamo.h>
+#include <linux/mfd/glamo-regs.h>
+#include <linux/mfd/glamo-core.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/uaccess.h>
+
+#include <linux/pm.h>
+
+#define GLAMO_MEM_REFRESH_COUNT 0x100
+
+#define GLAMO_NR_IRQS 9
+
+#define GLAMO_IRQ_HOSTBUS	0
+#define GLAMO_IRQ_JPEG		1
+#define GLAMO_IRQ_MPEG		2
+#define GLAMO_IRQ_MPROC1	3
+#define GLAMO_IRQ_MPROC0	4
+#define GLAMO_IRQ_CMDQUEUE	5
+#define GLAMO_IRQ_2D		6
+#define GLAMO_IRQ_MMC		7
+#define GLAMO_IRQ_RISC		8
+
+/*
+ * Glamo internal settings
+ *
+ * We run the memory interface from the faster PLLB on 2.6.28 kernels and
+ * above.  Couple of GTA02 users report trouble with memory bus when they
+ * upgraded from 2.6.24.  So this parameter allows reversion to 2.6.24
+ * scheme if their Glamo chip needs it.
+ *
+ * you can override the faster default on kernel commandline using
+ *
+ *   glamo3362.slow_memory=1
+ *
+ * for example
+ */
+
+static int slow_memory;
+module_param(slow_memory, int, 0644);
+
+struct reg_range {
+	int start;
+	int count;
+	char *name;
+	unsigned dump:1;
+};
+
+static const struct reg_range reg_range[] = {
+	{ 0x0000, 0x76,		"General",	1 },
+	{ 0x0200, 0x18,		"Host Bus",	1 },
+	{ 0x0300, 0x38,		"Memory",	1 },
+/*	{ 0x0400, 0x100,	"Sensor",	0 }, */
+/*	{ 0x0500, 0x300,	"ISP",		0 }, */
+/*	{ 0x0800, 0x400,	"JPEG",		0 }, */
+/*	{ 0x0c00, 0xcc,		"MPEG",		0 }, */
+	{ 0x1100, 0xb2,		"LCD 1",	0 },
+	{ 0x1200, 0x64,		"LCD 2",	0 },
+	{ 0x1400, 0x42,		"MMC",		0 },
+/*	{ 0x1500, 0x080,	"MPU 0",	0 },
+	{ 0x1580, 0x080,	"MPU 1",	0 },
+	{ 0x1600, 0x080,	"Cmd Queue",	0 },
+	{ 0x1680, 0x080,	"RISC CPU",	0 },*/
+	{ 0x1700, 0x400,	"2D Unit",	0 },
+/*	{ 0x1b00, 0x900,	"3D Unit",	0 }, */
+};
+
+static inline void __reg_write(struct glamo_core *glamo,
+				uint16_t reg, uint16_t val)
+{
+	writew(val, glamo->base + reg);
+}
+
+void glamo_reg_write(struct glamo_core *glamo,
+				uint16_t reg, uint16_t val)
+{
+	spin_lock(&glamo->lock);
+	__reg_write(glamo, reg, val);
+	spin_unlock(&glamo->lock);
+}
+EXPORT_SYMBOL_GPL(glamo_reg_write);
+
+
+static inline uint16_t __reg_read(struct glamo_core *glamo,
+					uint16_t reg)
+{
+	return readw(glamo->base + reg);
+}
+
+uint16_t glamo_reg_read(struct glamo_core *glamo, uint16_t reg)
+{
+	uint16_t val;
+	spin_lock(&glamo->lock);
+	val = __reg_read(glamo, reg);
+	spin_unlock(&glamo->lock);
+
+	return val;
+}
+EXPORT_SYMBOL_GPL(glamo_reg_read);
+
+static void __reg_set_bit_mask(struct glamo_core *glamo,
+				uint16_t reg, uint16_t mask,
+				uint16_t val)
+{
+	uint16_t tmp;
+
+	val &= mask;
+
+	tmp = __reg_read(glamo, reg);
+	tmp &= ~mask;
+	tmp |= val;
+	__reg_write(glamo, reg, tmp);
+}
+
+static void reg_set_bit_mask(struct glamo_core *glamo,
+				uint16_t reg, uint16_t mask,
+				uint16_t val)
+{
+	spin_lock(&glamo->lock);
+	__reg_set_bit_mask(glamo, reg, mask, val);
+	spin_unlock(&glamo->lock);
+}
+
+static inline void __reg_set_bit(struct glamo_core *glamo,
+				 uint16_t reg, uint16_t bit)
+{
+	uint16_t tmp;
+	tmp = __reg_read(glamo, reg);
+	tmp |= bit;
+	__reg_write(glamo, reg, tmp);
+}
+
+static inline void __reg_clear_bit(struct glamo_core *glamo,
+					uint16_t reg, uint16_t bit)
+{
+	uint16_t tmp;
+	tmp = __reg_read(glamo, reg);
+	tmp &= ~bit;
+	__reg_write(glamo, reg, tmp);
+}
+
+/***********************************************************************
+ * resources of sibling devices
+ ***********************************************************************/
+
+static struct resource glamo_fb_resources[] = {
+	{
+		.name	= "glamo-fb-regs",
+		.start	= GLAMO_REGOFS_LCD,
+		.end	= GLAMO_REGOFS_MMC - 1,
+		.flags	= IORESOURCE_MEM,
+	}, {
+		.name	= "glamo-fb-mem",
+		.start	= GLAMO_OFFSET_FB,
+		.end	= GLAMO_OFFSET_FB + GLAMO_FB_SIZE - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static struct resource glamo_mmc_resources[] = {
+	{
+		.name	= "glamo-mmc-regs",
+		.start	= GLAMO_REGOFS_MMC,
+		.end	= GLAMO_REGOFS_MPROC0 - 1,
+		.flags	= IORESOURCE_MEM
+	}, {
+		.name	= "glamo-mmc-mem",
+		.start	= GLAMO_OFFSET_FB + GLAMO_FB_SIZE,
+		.end	= GLAMO_OFFSET_FB + GLAMO_FB_SIZE +
+				  GLAMO_MMC_BUFFER_SIZE - 1,
+		.flags	= IORESOURCE_MEM
+	}, {
+		.start	= GLAMO_IRQ_MMC,
+		.end	= GLAMO_IRQ_MMC,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+enum glamo_cells {
+	GLAMO_CELL_FB,
+	GLAMO_CELL_MMC,
+	GLAMO_CELL_GPIO,
+};
+
+static const struct mfd_cell glamo_cells[] = {
+	[GLAMO_CELL_FB] = {
+		.name = "glamo-fb",
+		.num_resources = ARRAY_SIZE(glamo_fb_resources),
+		.resources = glamo_fb_resources,
+	},
+	[GLAMO_CELL_MMC] = {
+		.name = "glamo-mci",
+		.num_resources = ARRAY_SIZE(glamo_mmc_resources),
+		.resources = glamo_mmc_resources,
+	},
+	[GLAMO_CELL_GPIO] = {
+		.name = "glamo-gpio",
+	},
+};
+
+/***********************************************************************
+ * IRQ demultiplexer
+ ***********************************************************************/
+#define glamo_irq_bit(glamo, x)	BIT(x - glamo->irq_base)
+
+static inline struct glamo_core *irq_to_glamo(unsigned int irq)
+{
+	return (struct glamo_core *)get_irq_chip_data(irq);
+}
+
+static void glamo_ack_irq(unsigned int irq)
+{
+	struct glamo_core *glamo = irq_to_glamo(irq);
+	/* clear interrupt source */
+	__reg_write(glamo, GLAMO_REG_IRQ_CLEAR, glamo_irq_bit(glamo, irq));
+}
+
+static void glamo_mask_irq(unsigned int irq)
+{
+	struct glamo_core *glamo = irq_to_glamo(irq);
+
+	/* clear bit in enable register */
+	__reg_clear_bit(glamo, GLAMO_REG_IRQ_ENABLE, glamo_irq_bit(glamo, irq));
+}
+
+static void glamo_unmask_irq(unsigned int irq)
+{
+	struct glamo_core *glamo = irq_to_glamo(irq);
+
+	/* set bit in enable register */
+	__reg_set_bit(glamo, GLAMO_REG_IRQ_ENABLE, glamo_irq_bit(glamo, irq));
+}
+
+static struct irq_chip glamo_irq_chip = {
+	.name	= "glamo",
+	.ack	= glamo_ack_irq,
+	.mask	= glamo_mask_irq,
+	.unmask	= glamo_unmask_irq,
+};
+
+static void glamo_irq_demux_handler(unsigned int irq, struct irq_desc *desc)
+{
+	struct glamo_core *glamo = get_irq_desc_data(desc);
+	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
+
+	if (unlikely(desc->status & IRQ_INPROGRESS)) {
+		desc->status |= (IRQ_PENDING | IRQ_MASKED);
+		desc->chip->mask(irq);
+		desc->chip->ack(irq);
+		return;
+	}
+	kstat_incr_irqs_this_cpu(irq, desc);
+
+	desc->chip->ack(irq);
+	desc->status |= IRQ_INPROGRESS;
+
+	do {
+		uint16_t irqstatus;
+		int i;
+
+		if (unlikely((desc->status &
+				(IRQ_PENDING | IRQ_MASKED | IRQ_DISABLED)) ==
+				(IRQ_PENDING | IRQ_MASKED))) {
+			/* dealing with pending IRQ, unmasking */
+			desc->chip->unmask(irq);
+			desc->status &= ~IRQ_MASKED;
+		}
+
+		desc->status &= ~IRQ_PENDING;
+
+		/* read IRQ status register */
+		irqstatus = __reg_read(glamo, GLAMO_REG_IRQ_STATUS);
+		for (i = 0; i < 9; ++i) {
+			if (irqstatus & BIT(i))
+				generic_handle_irq(glamo->irq_base + i);
+		}
+
+	} while ((desc->status & (IRQ_PENDING | IRQ_DISABLED)) == IRQ_PENDING);
+
+	desc->status &= ~IRQ_INPROGRESS;
+}
+
+/*
+debugfs
+*/
+
+#ifdef CONFIG_DEBUG_FS
+static ssize_t debugfs_regs_write(struct file *file,
+				  const char __user *user_buf,
+				  size_t count, loff_t *ppos)
+{
+	struct glamo_core *glamo = ((struct seq_file *)file->private_data)->private;
+	char buf[14];
+	unsigned int reg;
+	unsigned int val;
+	int buf_size;
+
+	buf_size = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	if (sscanf(buf, "%x %x", &reg, &val) != 2)
+		return -EFAULT;
+
+	dev_info(&glamo->pdev->dev, "reg %#02x <-- %#04x\n", reg, val);
+
+	glamo_reg_write(glamo, reg, val);
+
+	return count;
+}
+
+static int glamo_show_regs(struct seq_file *s, void *pos)
+{
+	struct glamo_core *glamo = s->private;
+	int i, n;
+	const struct reg_range *rr = reg_range;
+
+	spin_lock(&glamo->lock);
+	for (i = 0; i < ARRAY_SIZE(reg_range); ++i, ++rr) {
+		if (!rr->dump)
+			continue;
+		seq_printf(s, "\n%s\n", rr->name);
+		for (n = rr->start; n < rr->start + rr->count; n += 2) {
+			if ((n & 15) == 0)
+				seq_printf(s, "\n%04X:  ", n);
+			seq_printf(s, "%04x ", __reg_read(glamo, n));
+		}
+		seq_printf(s, "\n");
+	}
+	spin_unlock(&glamo->lock);
+
+	return 0;
+}
+
+static int debugfs_open_file(struct inode *inode, struct file *file)
+{
+	return single_open(file, glamo_show_regs, inode->i_private);
+}
+
+static const struct file_operations debugfs_regs_ops = {
+	.open = debugfs_open_file,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.write = debugfs_regs_write,
+	.release	= single_release,
+};
+
+struct glamo_engine_reg_set {
+	uint16_t reg;
+	uint16_t mask_suspended;
+	uint16_t mask_enabled;
+};
+
+static void glamo_init_debugfs(struct glamo_core *glamo)
+{
+	glamo->debugfs_dir = debugfs_create_dir("glamo3362", NULL);
+	if (glamo->debugfs_dir)
+		debugfs_create_file("regs", S_IRUGO | S_IWUSR,
+				    glamo->debugfs_dir,
+				    glamo, &debugfs_regs_ops);
+	else
+		dev_warn(&glamo->pdev->dev, "Failed to set up debugfs.\n");
+}
+
+static void glamo_exit_debugfs(struct glamo_core *glamo)
+{
+	if (glamo->debugfs_dir)
+		debugfs_remove_recursive(glamo->debugfs_dir);
+}
+#else
+static void glamo_init_debugfs(struct glamo_core *glamo)
+{
+}
+
+static void glamo_exit_debugfs(struct glamo_core *glamo)
+{
+}
+#endif
+
+struct glamo_engine_desc {
+	const char *name;
+	uint16_t hostbus;
+	const struct glamo_engine_reg_set *regs;
+	int num_regs;
+};
+
+static const struct glamo_engine_reg_set glamo_lcd_regs[] = {
+	{ GLAMO_REG_CLOCK_LCD,
+	GLAMO_CLOCK_LCD_EN_M5CLK |
+	GLAMO_CLOCK_LCD_DG_M5CLK |
+	GLAMO_CLOCK_LCD_EN_DMCLK,
+
+	GLAMO_CLOCK_LCD_EN_DHCLK |
+	GLAMO_CLOCK_LCD_EN_DCLK
+	},
+	{ GLAMO_REG_CLOCK_GEN5_1,
+	GLAMO_CLOCK_GEN51_EN_DIV_DMCLK,
+
+	GLAMO_CLOCK_GEN51_EN_DIV_DHCLK |
+	GLAMO_CLOCK_GEN51_EN_DIV_DCLK
+	}
+};
+
+static const struct glamo_engine_reg_set glamo_mmc_regs[] = {
+	{ GLAMO_REG_CLOCK_MMC,
+	GLAMO_CLOCK_MMC_EN_M9CLK |
+	GLAMO_CLOCK_MMC_DG_M9CLK,
+
+	GLAMO_CLOCK_MMC_EN_TCLK |
+	GLAMO_CLOCK_MMC_DG_TCLK
+	},
+	{ GLAMO_REG_CLOCK_GEN5_1,
+	0,
+	GLAMO_CLOCK_GEN51_EN_DIV_TCLK
+	}
+};
+
+static const struct glamo_engine_reg_set glamo_2d_regs[] = {
+	{ GLAMO_REG_CLOCK_2D,
+	GLAMO_CLOCK_2D_EN_M7CLK |
+	GLAMO_CLOCK_2D_DG_M7CLK,
+
+	GLAMO_CLOCK_2D_EN_GCLK |
+	GLAMO_CLOCK_2D_DG_GCLK
+	},
+	{ GLAMO_REG_CLOCK_GEN5_1,
+	0,
+	GLAMO_CLOCK_GEN51_EN_DIV_GCLK,
+	}
+};
+
+static const struct glamo_engine_reg_set glamo_cmdq_regs[] = {
+	{ GLAMO_REG_CLOCK_2D,
+	GLAMO_CLOCK_2D_EN_M6CLK,
+	0
+	},
+};
+
+#define GLAMO_ENGINE(xname, xhostbus, xregs) { \
+	.name = xname, \
+	.hostbus = xhostbus, \
+	.num_regs = ARRAY_SIZE(xregs), \
+	.regs = xregs, \
+}
+
+static const struct glamo_engine_desc glamo_engines[] = {
+	[GLAMO_ENGINE_LCD] = GLAMO_ENGINE("LCD", GLAMO_HOSTBUS2_MMIO_EN_LCD,
+					glamo_lcd_regs),
+	[GLAMO_ENGINE_MMC] = GLAMO_ENGINE("MMC", GLAMO_HOSTBUS2_MMIO_EN_MMC,
+					glamo_mmc_regs),
+	[GLAMO_ENGINE_2D] = GLAMO_ENGINE("2D", GLAMO_HOSTBUS2_MMIO_EN_2D,
+					glamo_2d_regs),
+	[GLAMO_ENGINE_CMDQ] = GLAMO_ENGINE("CMDQ", GLAMO_HOSTBUS2_MMIO_EN_CQ,
+					glamo_cmdq_regs),
+};
+
+static inline const char *glamo_engine_name(enum glamo_engine engine)
+{
+	return glamo_engines[engine].name;
+}
+
+/***********************************************************************
+ * 'engine' support
+ ***********************************************************************/
+
+int __glamo_engine_enable(struct glamo_core *glamo, enum glamo_engine engine)
+{
+	int i;
+	const struct glamo_engine_desc *engine_desc = &glamo_engines[engine];
+	const struct glamo_engine_reg_set *reg;
+
+	switch (engine) {
+	case GLAMO_ENGINE_LCD:
+	case GLAMO_ENGINE_MMC:
+	case GLAMO_ENGINE_2D:
+	case GLAMO_ENGINE_CMDQ:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	reg = engine_desc->regs;
+
+	__reg_set_bit(glamo, GLAMO_REG_HOSTBUS(2),
+			engine_desc->hostbus);
+	for (i = engine_desc->num_regs; i; --i, ++reg)
+		__reg_set_bit(glamo, reg->reg,
+				reg->mask_suspended | reg->mask_enabled);
+
+	return 0;
+}
+
+int glamo_engine_enable(struct glamo_core *glamo, enum glamo_engine engine)
+{
+	int ret = 0;
+
+	spin_lock(&glamo->lock);
+
+	if (glamo->engine_state[engine] != GLAMO_ENGINE_ENABLED) {
+		ret = __glamo_engine_enable(glamo, engine);
+		if (!ret)
+			glamo->engine_state[engine] = GLAMO_ENGINE_ENABLED;
+	}
+
+	spin_unlock(&glamo->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(glamo_engine_enable);
+
+int __glamo_engine_disable(struct glamo_core *glamo, enum glamo_engine engine)
+{
+	int i;
+	const struct glamo_engine_desc *engine_desc = &glamo_engines[engine];
+	const struct glamo_engine_reg_set *reg;
+
+	switch (engine) {
+	case GLAMO_ENGINE_LCD:
+	case GLAMO_ENGINE_MMC:
+	case GLAMO_ENGINE_2D:
+	case GLAMO_ENGINE_CMDQ:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	reg = engine_desc->regs;
+
+	__reg_clear_bit(glamo, GLAMO_REG_HOSTBUS(2),
+			engine_desc->hostbus);
+	for (i = engine_desc->num_regs; i; --i, ++reg)
+		__reg_clear_bit(glamo, reg->reg,
+				reg->mask_suspended | reg->mask_enabled);
+
+	return 0;
+}
+int glamo_engine_disable(struct glamo_core *glamo, enum glamo_engine engine)
+{
+	int ret = 0;
+
+	spin_lock(&glamo->lock);
+
+	if (glamo->engine_state[engine] != GLAMO_ENGINE_DISABLED) {
+		ret = __glamo_engine_disable(glamo, engine);
+		if (!ret)
+			glamo->engine_state[engine] = GLAMO_ENGINE_DISABLED;
+	}
+
+	spin_unlock(&glamo->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(glamo_engine_disable);
+
+int __glamo_engine_suspend(struct glamo_core *glamo, enum glamo_engine engine)
+{
+	int i;
+	const struct glamo_engine_desc *engine_desc = &glamo_engines[engine];
+	const struct glamo_engine_reg_set *reg;
+
+	switch (engine) {
+	case GLAMO_ENGINE_LCD:
+	case GLAMO_ENGINE_MMC:
+	case GLAMO_ENGINE_2D:
+	case GLAMO_ENGINE_CMDQ:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	reg = engine_desc->regs;
+
+	__reg_set_bit(glamo, GLAMO_REG_HOSTBUS(2),
+			engine_desc->hostbus);
+	for (i = engine_desc->num_regs; i; --i, ++reg) {
+		__reg_set_bit(glamo, reg->reg, reg->mask_suspended);
+		__reg_clear_bit(glamo, reg->reg, reg->mask_enabled);
+	}
+
+	return 0;
+}
+
+int glamo_engine_suspend(struct glamo_core *glamo, enum glamo_engine engine)
+{
+	int ret = 0;
+
+	spin_lock(&glamo->lock);
+
+	if (glamo->engine_state[engine] != GLAMO_ENGINE_SUSPENDED) {
+		ret = __glamo_engine_suspend(glamo, engine);
+		if (!ret)
+			glamo->engine_state[engine] = GLAMO_ENGINE_SUSPENDED;
+	}
+
+	spin_unlock(&glamo->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(glamo_engine_suspend);
+
+static const struct glamo_script reset_regs[] = {
+	[GLAMO_ENGINE_LCD] = {
+		GLAMO_REG_CLOCK_LCD, GLAMO_CLOCK_LCD_RESET
+	},
+	[GLAMO_ENGINE_MMC] = {
+		GLAMO_REG_CLOCK_MMC, GLAMO_CLOCK_MMC_RESET
+	},
+	[GLAMO_ENGINE_CMDQ] = {
+		GLAMO_REG_CLOCK_2D, GLAMO_CLOCK_2D_CQ_RESET
+	},
+	[GLAMO_ENGINE_2D] = {
+		GLAMO_REG_CLOCK_2D, GLAMO_CLOCK_2D_RESET
+	},
+	[GLAMO_ENGINE_JPEG] = {
+		GLAMO_REG_CLOCK_JPEG, GLAMO_CLOCK_JPEG_RESET
+	},
+};
+
+void glamo_engine_reset(struct glamo_core *glamo, enum glamo_engine engine)
+{
+	uint16_t reg = reset_regs[engine].reg;
+	uint16_t val = reset_regs[engine].val;
+
+	if (engine >= ARRAY_SIZE(reset_regs)) {
+		dev_warn(&glamo->pdev->dev, "unknown engine %u ", engine);
+		return;
+	}
+
+	spin_lock(&glamo->lock);
+	__reg_set_bit(glamo, reg, val);
+	__reg_clear_bit(glamo, reg, val);
+	spin_unlock(&glamo->lock);
+}
+EXPORT_SYMBOL_GPL(glamo_engine_reset);
+
+int glamo_pll_rate(struct glamo_core *glamo,
+			  enum glamo_pll pll)
+{
+	uint16_t reg;
+	unsigned int osci = glamo->pdata->osci_clock_rate;
+
+	switch (pll) {
+	case GLAMO_PLL1:
+		reg = __reg_read(glamo, GLAMO_REG_PLL_GEN1);
+		break;
+	case GLAMO_PLL2:
+		reg = __reg_read(glamo, GLAMO_REG_PLL_GEN3);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return (int)osci * (int)reg;
+}
+EXPORT_SYMBOL_GPL(glamo_pll_rate);
+
+int glamo_engine_reclock(struct glamo_core *glamo,
+			 enum glamo_engine engine,
+			 int hz)
+{
+	int pll;
+	uint16_t reg, mask, div;
+
+	if (!hz)
+		return -EINVAL;
+
+	switch (engine) {
+	case GLAMO_ENGINE_LCD:
+		pll = GLAMO_PLL1;
+		reg = GLAMO_REG_CLOCK_GEN7;
+		mask = 0xff;
+		break;
+	case GLAMO_ENGINE_MMC:
+		pll = GLAMO_PLL1;
+		reg = GLAMO_REG_CLOCK_GEN8;
+		mask = 0xff;
+		break;
+	default:
+		dev_warn(&glamo->pdev->dev,
+			 "reclock of engine 0x%x not supported\n", engine);
+		return -EINVAL;
+		break;
+	}
+
+	pll = glamo_pll_rate(glamo, pll);
+
+	div = pll / hz;
+
+	if (div != 0 && pll / div <= hz)
+		--div;
+
+	if (div > mask)
+		div = mask;
+
+	dev_dbg(&glamo->pdev->dev,
+			"PLL %d, kHZ %d, div %d\n", pll, hz / 1000, div);
+
+	reg_set_bit_mask(glamo, reg, mask, div);
+	mdelay(5); /* wait some time to stabilize */
+
+	return pll / (div + 1);
+}
+EXPORT_SYMBOL_GPL(glamo_engine_reclock);
+
+/***********************************************************************
+ * script support
+ ***********************************************************************/
+
+#define GLAMO_SCRIPT_END	0xffff
+#define GLAMO_SCRIPT_WAIT	0xfffe
+#define GLAMO_SCRIPT_LOCK_PLL	0xfffd
+
+/*
+ * couple of people reported artefacts with 2.6.28 changes, this
+ * allows reversion to 2.6.24 settings
+*/
+static const uint16_t reg_0x200[] = {
+	0xe03, /* 0 waits on Async BB R & W, Use PLL 2 for mem bus */
+	0xef0, /* 3 waits on Async BB R & W, Use PLL 1 for mem bus */
+	0xea0, /* 2 waits on Async BB R & W, Use PLL 1 for mem bus */
+	0xe50, /* 1 waits on Async BB R & W, Use PLL 1 for mem bus */
+	0xe00, /* 0 waits on Async BB R & W, Use PLL 1 for mem bus */
+	0xef3, /* 3 waits on Async BB R & W, Use PLL 2 for mem bus */
+	0xea3, /* 2 waits on Async BB R & W, Use PLL 2 for mem bus */
+	0xe53, /* 1 waits on Async BB R & W, Use PLL 2 for mem bus */
+};
+
+static int glamo_run_script(struct glamo_core *glamo,
+				const struct glamo_script *script, int len,
+				int may_sleep)
+{
+	int i;
+	uint16_t status;
+	const struct glamo_script *line = script;
+
+	for (i = 0; i < len; ++i, ++line) {
+		switch (line->reg) {
+		case GLAMO_SCRIPT_END:
+			return 0;
+		case GLAMO_SCRIPT_WAIT:
+			if (may_sleep)
+				msleep(line->val);
+			else
+				mdelay(line->val * 4);
+			break;
+		case GLAMO_SCRIPT_LOCK_PLL:
+			/* spin until PLLs lock */
+			do {
+				status = __reg_read(glamo, GLAMO_REG_PLL_GEN5);
+			} while ((status & 3) != 3);
+			break;
+		case 0x200:
+			__reg_write(glamo, line->reg,
+					reg_0x200[slow_memory & 0x7]);
+			break;
+		default:
+			__reg_write(glamo, line->reg, line->val);
+			break;
+		}
+	}
+
+	return 0;
+}
+
+static const struct glamo_script glamo_init_script[] = {
+	{ GLAMO_REG_CLOCK_HOST,		0x1000 },
+	{ GLAMO_SCRIPT_WAIT,		     2 },
+	{ GLAMO_REG_CLOCK_MEMORY,	0x1000 },
+	{ GLAMO_REG_CLOCK_MEMORY,	0x2000 },
+	{ GLAMO_REG_CLOCK_LCD,		0x1000 },
+	{ GLAMO_REG_CLOCK_MMC,		0x1000 },
+	{ GLAMO_REG_CLOCK_ISP,		0x1000 },
+	{ GLAMO_REG_CLOCK_ISP,		0x3000 },
+	{ GLAMO_REG_CLOCK_JPEG,		0x1000 },
+	{ GLAMO_REG_CLOCK_3D,		0x1000 },
+	{ GLAMO_REG_CLOCK_3D,		0x3000 },
+	{ GLAMO_REG_CLOCK_2D,		0x1000 },
+	{ GLAMO_REG_CLOCK_2D,		0x3000 },
+	{ GLAMO_REG_CLOCK_RISC1,	0x1000 },
+	{ GLAMO_REG_CLOCK_MPEG,		0x1000 },
+	{ GLAMO_REG_CLOCK_MPEG,		0x3000 },
+	{ GLAMO_REG_CLOCK_MPROC,	0x1000 /*0x100f*/ },
+	{ GLAMO_SCRIPT_WAIT,		     2 },
+	{ GLAMO_REG_CLOCK_HOST,		0x0000 },
+	{ GLAMO_REG_CLOCK_MEMORY,	0x0000 },
+	{ GLAMO_REG_CLOCK_LCD,		0x0000 },
+	{ GLAMO_REG_CLOCK_MMC,		0x0000 },
+	{ GLAMO_REG_PLL_GEN1,		0x05db },	/* 48MHz */
+	{ GLAMO_REG_PLL_GEN3,		0x0aba },	/* 90MHz */
+	{ GLAMO_SCRIPT_LOCK_PLL, 0 },
+	/*
+	 * b9 of this register MUST be zero to get any interrupts on INT#
+	 * the other set bits enable all the engine interrupt sources
+	 */
+	{ GLAMO_REG_IRQ_ENABLE,		0x0100 },
+	{ GLAMO_REG_CLOCK_GEN6,		0x2000 },
+	{ GLAMO_REG_CLOCK_GEN7,		0x0101 },
+	{ GLAMO_REG_CLOCK_GEN8,		0x0100 },
+	{ GLAMO_REG_CLOCK_HOST,		0x000d },
+	/*
+	 * b7..b4 = 0 = no wait states on read or write
+	 * b0 = 1 select PLL2 for Host interface, b1 = enable it
+	 */
+	{ GLAMO_REG_HOSTBUS(1),		0x0e03 /* this is replaced by script parser */ },
+	{ GLAMO_REG_HOSTBUS(2),		0x07ff }, /* TODO: Disable all */
+	{ GLAMO_REG_HOSTBUS(10),	0x0000 },
+	{ GLAMO_REG_HOSTBUS(11),	0x4000 },
+	{ GLAMO_REG_HOSTBUS(12),	0xf00e },
+
+	/* S-Media recommended "set tiling mode to 512 mode for memory access
+	 * more efficiency when 640x480" */
+	{ GLAMO_REG_MEM_TYPE,		0x0c74 }, /* 8MB, 16 word pg wr+rd */
+	{ GLAMO_REG_MEM_GEN,		0xafaf }, /* 63 grants min + max */
+
+	{ GLAMO_REG_MEM_TIMING1,	0x0108 },
+	{ GLAMO_REG_MEM_TIMING2,	0x0010 }, /* Taa = 3 MCLK */
+	{ GLAMO_REG_MEM_TIMING3,	0x0000 },
+	{ GLAMO_REG_MEM_TIMING4,	0x0000 }, /* CE1# delay fall/rise */
+	{ GLAMO_REG_MEM_TIMING5,	0x0000 }, /* UB# LB# */
+	{ GLAMO_REG_MEM_TIMING6,	0x0000 }, /* OE# */
+	{ GLAMO_REG_MEM_TIMING7,	0x0000 }, /* WE# */
+	{ GLAMO_REG_MEM_TIMING8,	0x1002 }, /* MCLK delay, was 0x1000 */
+	{ GLAMO_REG_MEM_TIMING9,	0x6006 },
+	{ GLAMO_REG_MEM_TIMING10,	0x00ff },
+	{ GLAMO_REG_MEM_TIMING11,	0x0001 },
+	{ GLAMO_REG_MEM_POWER1,		0x0020 },
+	{ GLAMO_REG_MEM_POWER2,		0x0000 },
+	{ GLAMO_REG_MEM_DRAM1,		0x0000 },
+	{ GLAMO_SCRIPT_WAIT,		     1 },
+	{ GLAMO_REG_MEM_DRAM1,		0xc100 },
+	{ GLAMO_SCRIPT_WAIT,		     1 },
+	{ GLAMO_REG_MEM_DRAM1,		0xe100 },
+	{ GLAMO_REG_MEM_DRAM2,		0x01d6 },
+	{ GLAMO_REG_CLOCK_MEMORY,	0x000b },
+};
+
+/* Find out if we can support this version of the Glamo chip */
+static int __devinit glamo_supported(struct glamo_core *glamo)
+{
+	uint16_t dev_id, rev_id;
+
+	dev_id = __reg_read(glamo, GLAMO_REG_DEVICE_ID);
+	rev_id = __reg_read(glamo, GLAMO_REG_REVISION_ID);
+
+	switch (dev_id) {
+	case 0x3650:
+		switch (rev_id) {
+		case GLAMO_CORE_REV_A2:
+			break;
+		case GLAMO_CORE_REV_A0:
+		case GLAMO_CORE_REV_A1:
+		case GLAMO_CORE_REV_A3:
+			dev_warn(&glamo->pdev->dev, "untested core revision "
+				 "%04x, your mileage may vary\n", rev_id);
+			break;
+		default:
+			dev_warn(&glamo->pdev->dev, "unknown glamo revision "
+				 "%04x, your mileage may vary\n", rev_id);
+		}
+		break;
+	default:
+		dev_err(&glamo->pdev->dev, "unsupported Glamo device %04x\n",
+			dev_id);
+		return 0;
+	}
+
+	dev_dbg(&glamo->pdev->dev, "Detected Glamo core %04x Revision %04x "
+		 "(%uHz CPU / %uHz Memory)\n", dev_id, rev_id,
+		 glamo_pll_rate(glamo, GLAMO_PLL1),
+		 glamo_pll_rate(glamo, GLAMO_PLL2));
+
+	return 1;
+}
+
+static int __devinit glamo_probe(struct platform_device *pdev)
+{
+	int ret = 0, n, irq, irq_base;
+	struct glamo_core *glamo;
+	struct resource *mem;
+
+	glamo = kmalloc(GFP_KERNEL, sizeof(*glamo));
+	if (!glamo)
+		return -ENOMEM;
+
+	for (n = 0; n < __NUM_GLAMO_ENGINES; n++)
+		glamo->engine_state[n] = GLAMO_ENGINE_DISABLED;
+
+	spin_lock_init(&glamo->lock);
+
+	glamo->pdev = pdev;
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	glamo->irq = platform_get_irq(pdev, 0);
+	glamo->irq_base = irq_base = platform_get_irq(pdev, 1);
+	glamo->pdata = pdev->dev.platform_data;
+
+	if (glamo->irq < 0) {
+		ret = glamo->irq;
+		dev_err(&pdev->dev, "Failed to get platform irq: %d\n", ret);
+		goto err_free;
+	}
+
+	if (irq_base < 0) {
+		ret = glamo->irq;
+		dev_err(&pdev->dev, "Failed to get glamo irq base: %d\n", ret);
+		goto err_free;
+	}
+
+	if (!mem) {
+		dev_err(&pdev->dev, "Failed to get platform memory\n");
+		ret = -ENOENT;
+		goto err_free;
+	}
+
+	if (!glamo->pdata) {
+		dev_err(&pdev->dev, "Missing platform data\n");
+		ret = -ENOENT;
+		goto err_free;
+	}
+
+	/* only request the generic, hostbus and memory controller registers */
+	glamo->mem = request_mem_region(mem->start, GLAMO_REGOFS_VIDCAP,
+					pdev->name);
+
+	if (!glamo->mem) {
+		dev_err(&pdev->dev, "Failed to request io memory region\n");
+		ret = -ENOENT;
+		goto err_free;
+	}
+
+	glamo->base = ioremap(glamo->mem->start, resource_size(glamo->mem));
+	if (!glamo->base) {
+		dev_err(&pdev->dev, "Failed to ioremap() memory region\n");
+		goto err_release_mem_region;
+	}
+
+	/* confirm it isn't insane version */
+	if (!glamo_supported(glamo)) {
+		dev_err(&pdev->dev,
+			"This version of the Glamo is not supported\n");
+		goto err_iounmap;
+	}
+
+	platform_set_drvdata(pdev, glamo);
+
+	/* debugfs */
+	glamo_init_debugfs(glamo);
+
+	/* init the chip with canned register set */
+	glamo_run_script(glamo, glamo_init_script,
+			 ARRAY_SIZE(glamo_init_script), 1);
+
+	/*
+	 * finally set the mfd interrupts up
+	 */
+	for (irq = irq_base; irq < irq_base + GLAMO_NR_IRQS; ++irq) {
+#ifdef CONFIG_ARM
+		set_irq_flags(irq, IRQF_VALID);
+#else
+		set_irq_noprobe(irq);
+#endif
+		set_irq_chip_data(irq, glamo);
+		set_irq_chip_and_handler(irq, &glamo_irq_chip,
+					handle_level_irq);
+	}
+
+	set_irq_type(glamo->irq, IRQ_TYPE_EDGE_FALLING);
+	set_irq_data(glamo->irq, glamo);
+	set_irq_chained_handler(glamo->irq, glamo_irq_demux_handler);
+
+	ret = mfd_add_devices(&pdev->dev, pdev->id, glamo_cells,
+				ARRAY_SIZE(glamo_cells), mem, glamo->irq_base);
+
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to add child devices: %d\n", ret);
+		goto err_free_irqs;
+	}
+
+	dev_info(&glamo->pdev->dev, "Glamo core PLL1: %uHz, PLL2: %uHz\n",
+		 glamo_pll_rate(glamo, GLAMO_PLL1),
+		 glamo_pll_rate(glamo, GLAMO_PLL2));
+
+	return 0;
+
+err_free_irqs:
+	disable_irq(glamo->irq);
+	set_irq_chained_handler(glamo->irq, NULL);
+	set_irq_chip_data(glamo->irq, NULL);
+
+	for (irq = irq_base; irq < irq_base + GLAMO_NR_IRQS; ++irq) {
+		set_irq_chip(irq, NULL);
+#ifdef CONFIG_ARM
+		set_irq_flags(irq, 0);
+#else
+		set_irq_probe(irq);
+#endif
+		set_irq_chip_data(irq, NULL);
+	}
+err_iounmap:
+	iounmap(glamo->base);
+err_release_mem_region:
+	release_mem_region(glamo->mem->start, resource_size(glamo->mem));
+err_free:
+	platform_set_drvdata(pdev, NULL);
+	kfree(glamo);
+
+	return ret;
+}
+
+static int __devexit glamo_remove(struct platform_device *pdev)
+{
+	struct glamo_core *glamo = platform_get_drvdata(pdev);
+	int irq;
+	int irq_base = glamo->irq_base;
+
+	glamo_exit_debugfs(glamo);
+
+	mfd_remove_devices(&pdev->dev);
+
+	disable_irq(glamo->irq);
+	set_irq_chained_handler(glamo->irq, NULL);
+	set_irq_chip_data(glamo->irq, NULL);
+
+	for (irq = irq_base; irq < irq_base + GLAMO_NR_IRQS; ++irq) {
+#ifdef CONFIG_ARM
+		set_irq_flags(irq, 0);
+#else
+		set_irq_noprobe();
+#endif
+		set_irq_chip(irq, NULL);
+		set_irq_chip_data(irq, NULL);
+	}
+
+	platform_set_drvdata(pdev, NULL);
+	iounmap(glamo->base);
+	release_mem_region(glamo->mem->start, resource_size(glamo->mem));
+	kfree(glamo);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+#if 0
+static struct glamo_script glamo_resume_script[] = {
+
+	{ GLAMO_REG_PLL_GEN1,		0x05db },	/* 48MHz */
+	{ GLAMO_REG_PLL_GEN3,		0x0aba },	/* 90MHz */
+	{ GLAMO_REG_DFT_GEN6, 1 },
+		{ 0xfffe, 100 },
+		{ 0xfffd, 0 },
+	{ 0x200,	0x0e03 },
+
+	/*
+	 * b9 of this register MUST be zero to get any interrupts on INT#
+	 * the other set bits enable all the engine interrupt sources
+	 */
+	{ GLAMO_REG_IRQ_ENABLE,		0x01ff },
+	{ GLAMO_REG_CLOCK_HOST,		0x0018 },
+	{ GLAMO_REG_CLOCK_GEN5_1, 0x18b1 },
+
+	{ GLAMO_REG_MEM_DRAM1,		0x0000 },
+		{ 0xfffe, 1 },
+	{ GLAMO_REG_MEM_DRAM1,		0xc100 },
+		{ 0xfffe, 1 },
+	{ GLAMO_REG_MEM_DRAM1,		0xe100 },
+	{ GLAMO_REG_MEM_DRAM2,		0x01d6 },
+	{ GLAMO_REG_CLOCK_MEMORY,	0x000b },
+};
+#endif
+
+#if 0
+static void glamo_power(struct glamo_core *glamo)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&glamo->lock, flags);
+
+	/*
+Power management
+static const REG_VALUE_MASK_TYPE reg_powerOn[] =
+{
+	{ REG_GEN_DFT6,	    REG_BIT_ALL,    REG_DATA(1u << 0)		},
+	{ REG_GEN_PLL3,	    0u,		    REG_DATA(1u << 13)		},
+	{ REG_GEN_MEM_CLK,  REG_BIT_ALL,    REG_BIT_EN_MOCACLK		},
+	{ REG_MEM_DRAM2,    0u,		    REG_BIT_EN_DEEP_POWER_DOWN	},
+	{ REG_MEM_DRAM1,    0u,		    REG_BIT_SELF_REFRESH	}
+};
+
+static const REG_VALUE_MASK_TYPE reg_powerStandby[] =
+{
+	{ REG_MEM_DRAM1,    REG_BIT_ALL,    REG_BIT_SELF_REFRESH    },
+	{ REG_GEN_MEM_CLK,  0u,		    REG_BIT_EN_MOCACLK	    },
+	{ REG_GEN_PLL3,	    REG_BIT_ALL,    REG_DATA(1u << 13)	    },
+	{ REG_GEN_DFT5,	    REG_BIT_ALL,    REG_DATA(1u << 0)	    }
+};
+
+static const REG_VALUE_MASK_TYPE reg_powerSuspend[] =
+{
+	{ REG_MEM_DRAM2,    REG_BIT_ALL,    REG_BIT_EN_DEEP_POWER_DOWN  },
+	{ REG_GEN_MEM_CLK,  0u,		    REG_BIT_EN_MOCACLK		},
+	{ REG_GEN_PLL3,	    REG_BIT_ALL,    REG_DATA(1u << 13)		},
+	{ REG_GEN_DFT5,	    REG_BIT_ALL,    REG_DATA(1u << 0)		}
+};
+*/
+	switch (new_state) {
+	case GLAMO_POWER_ON:
+
+		/*
+		 * glamo state on resume is nondeterministic in some
+		 * fundamental way, it has also been observed that the
+		 * Glamo reset pin can get asserted by, eg, touching it with
+		 * a scope probe.  So the only answer is to roll with it and
+		 * force an external reset on the Glamo during resume.
+		 */
+
+
+		break;
+
+	case GLAMO_POWER_SUSPEND:
+
+		break;
+	}
+	spin_unlock_irqrestore(&glamo->lock, flags);
+}
+#endif
+
+static int glamo_suspend(struct device *dev)
+{
+	struct glamo_core *glamo = dev_get_drvdata(dev);
+	int n;
+
+	spin_lock(&glamo->lock);
+
+	glamo->saved_irq_mask = __reg_read(glamo, GLAMO_REG_IRQ_ENABLE);
+
+	/* nuke interrupts */
+	__reg_write(glamo, GLAMO_REG_IRQ_ENABLE, 0x200);
+
+	/* take down each engine before we kill mem and pll */
+	for (n = 0; n < __NUM_GLAMO_ENGINES; n++) {
+		if (glamo->engine_state[n] != GLAMO_ENGINE_DISABLED)
+			__glamo_engine_disable(glamo, n);
+	}
+
+	/* enable self-refresh */
+
+	__reg_write(glamo, GLAMO_REG_MEM_DRAM1,
+				GLAMO_MEM_DRAM1_EN_DRAM_REFRESH |
+				GLAMO_MEM_DRAM1_EN_GATE_CKE |
+				GLAMO_MEM_DRAM1_SELF_REFRESH |
+				GLAMO_MEM_REFRESH_COUNT);
+	__reg_write(glamo, GLAMO_REG_MEM_DRAM1,
+				GLAMO_MEM_DRAM1_EN_MODEREG_SET |
+				GLAMO_MEM_DRAM1_EN_DRAM_REFRESH |
+				GLAMO_MEM_DRAM1_EN_GATE_CKE |
+				GLAMO_MEM_DRAM1_SELF_REFRESH |
+				GLAMO_MEM_REFRESH_COUNT);
+
+	/* force RAM into deep powerdown */
+	__reg_write(glamo, GLAMO_REG_MEM_DRAM2,
+				GLAMO_MEM_DRAM2_DEEP_PWRDOWN |
+				(7 << 6) | /* tRC */
+				(1 << 4) | /* tRP */
+				(1 << 2) | /* tRCD */
+				2); /* CAS latency */
+
+	/* disable clocks to memory */
+	__reg_write(glamo, GLAMO_REG_CLOCK_MEMORY, 0);
+
+	/* all dividers from OSCI */
+	__reg_set_bit_mask(glamo, GLAMO_REG_CLOCK_GEN5_1, 0x400, 0x400);
+
+	/* PLL2 into bypass */
+	__reg_set_bit_mask(glamo, GLAMO_REG_PLL_GEN3, 1 << 12, 1 << 12);
+
+	__reg_write(glamo, GLAMO_BASIC_MMC_EN_TCLK_DLYA1, 0x0e00);
+
+	/* kill PLLS 1 then 2 */
+	__reg_write(glamo, GLAMO_REG_DFT_GEN5, 0x0001);
+	__reg_set_bit_mask(glamo, GLAMO_REG_PLL_GEN3, 1 << 13, 1 << 13);
+
+	spin_unlock(&glamo->lock);
+
+	return 0;
+}
+
+static int glamo_resume(struct device *dev)
+{
+	struct glamo_core *glamo = dev_get_drvdata(dev);
+	int n;
+
+	(glamo->pdata->glamo_external_reset)(0);
+	udelay(10);
+	(glamo->pdata->glamo_external_reset)(1);
+	mdelay(5);
+
+	spin_lock(&glamo->lock);
+
+	glamo_run_script(glamo, glamo_init_script,
+			 ARRAY_SIZE(glamo_init_script), 0);
+
+
+	for (n = 0; n < __NUM_GLAMO_ENGINES; n++) {
+		switch (glamo->engine_state[n]) {
+		case GLAMO_ENGINE_SUSPENDED:
+			__glamo_engine_suspend(glamo, n);
+			break;
+		case GLAMO_ENGINE_ENABLED:
+			__glamo_engine_enable(glamo, n);
+			break;
+		default:
+			break;
+		}
+	}
+
+	__reg_write(glamo, GLAMO_REG_IRQ_ENABLE, glamo->saved_irq_mask);
+
+	spin_unlock(&glamo->lock);
+
+	return 0;
+}
+
+static const struct dev_pm_ops glamo_pm_ops = {
+	.suspend    = glamo_suspend,
+	.resume     = glamo_resume,
+	.poweroff   = glamo_suspend,
+	.restore    = glamo_resume,
+};
+
+#define GLAMO_PM_OPS (&glamo_pm_ops)
+
+#else
+#define GLAMO_PM_OPS NULL
+#endif
+
+static struct platform_driver glamo_driver = {
+	.probe		= glamo_probe,
+	.remove		= __devexit_p(glamo_remove),
+	.driver		= {
+		.name	= "glamo3362",
+		.owner	= THIS_MODULE,
+		.pm	= GLAMO_PM_OPS,
+	},
+};
+
+static int __devinit glamo_init(void)
+{
+	return platform_driver_register(&glamo_driver);
+}
+module_init(glamo_init);
+
+static void __exit glamo_exit(void)
+{
+	platform_driver_unregister(&glamo_driver);
+}
+module_exit(glamo_exit);
+
+MODULE_AUTHOR("Harald Welte <laforge@openmoko.org>");
+MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
+MODULE_DESCRIPTION("Smedia Glamo 3362 core/resource driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:glamo3362");
diff --git a/include/linux/mfd/glamo-core.h b/include/linux/mfd/glamo-core.h
new file mode 100644
index 0000000..8275a2f
--- /dev/null
+++ b/include/linux/mfd/glamo-core.h
@@ -0,0 +1,58 @@
+#ifndef __GLAMO_CORE_H
+#define __GLAMO_CORE_H
+
+#include <linux/mfd/glamo.h>
+
+/* for the time being, we put the on-screen framebuffer into the lowest
+ * VRAM space.  This should make the code easily compatible with the various
+ * 2MB/4MB/8MB variants of the Smedia chips */
+#define GLAMO_OFFSET_VRAM	0x800000
+#define GLAMO_OFFSET_FB	(GLAMO_OFFSET_VRAM)
+
+/* we only allocate the minimum possible size for the framebuffer to make
+ * sure we have sufficient memory for other functions of the chip */
+/*#define GLAMO_FB_SIZE	(640*480*4)	*//* == 0x12c000 */
+#define GLAMO_INTERNAL_RAM_SIZE 0x800000
+#define GLAMO_MMC_BUFFER_SIZE (64 * 1024)
+#define GLAMO_FB_SIZE	(GLAMO_INTERNAL_RAM_SIZE - GLAMO_MMC_BUFFER_SIZE)
+
+enum glamo_pll {
+	GLAMO_PLL1,
+	GLAMO_PLL2,
+};
+
+enum glamo_engine_state {
+	GLAMO_ENGINE_DISABLED,
+	GLAMO_ENGINE_SUSPENDED,
+	GLAMO_ENGINE_ENABLED,
+};
+
+struct glamo_core {
+	int irq;
+	int irq_base;
+	struct resource *mem;
+	void __iomem *base;
+	struct platform_device *pdev;
+	struct glamo_platform_data *pdata;
+	enum glamo_engine_state engine_state[__NUM_GLAMO_ENGINES];
+	spinlock_t lock;
+	uint16_t saved_irq_mask;
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *debugfs_dir;
+#endif
+};
+
+struct glamo_script {
+	uint16_t reg;
+	uint16_t val;
+};
+
+int glamo_pll_rate(struct glamo_core *glamo, enum glamo_pll pll);
+
+int glamo_engine_enable(struct glamo_core *glamo, enum glamo_engine engine);
+int glamo_engine_suspend(struct glamo_core *glamo, enum glamo_engine engine);
+int glamo_engine_disable(struct glamo_core *glamo, enum glamo_engine engine);
+void glamo_engine_reset(struct glamo_core *glamo, enum glamo_engine engine);
+int glamo_engine_reclock(struct glamo_core *glamo,
+			 enum glamo_engine engine, int ps);
+#endif /* __GLAMO_CORE_H */
diff --git a/include/linux/mfd/glamo-regs.h b/include/linux/mfd/glamo-regs.h
new file mode 100644
index 0000000..59848e1
--- /dev/null
+++ b/include/linux/mfd/glamo-regs.h
@@ -0,0 +1,630 @@
+#ifndef _GLAMO_REGS_H
+#define _GLAMO_REGS_H
+
+/* Smedia Glamo 336x/337x driver
+ *
+ * (C) 2007 by Openmoko, Inc.
+ * Author: Harald Welte <laforge@openmoko.org>
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ */
+
+enum glamo_regster_offsets {
+	GLAMO_REGOFS_GENERIC	= 0x0000,
+	GLAMO_REGOFS_HOSTBUS	= 0x0200,
+	GLAMO_REGOFS_MEMORY	= 0x0300,
+	GLAMO_REGOFS_VIDCAP	= 0x0400,
+	GLAMO_REGOFS_ISP	= 0x0500,
+	GLAMO_REGOFS_JPEG	= 0x0800,
+	GLAMO_REGOFS_MPEG	= 0x0c00,
+	GLAMO_REGOFS_LCD	= 0x1100,
+	GLAMO_REGOFS_MMC	= 0x1400,
+	GLAMO_REGOFS_MPROC0	= 0x1500,
+	GLAMO_REGOFS_MPROC1	= 0x1580,
+	GLAMO_REGOFS_CMDQUEUE	= 0x1600,
+	GLAMO_REGOFS_RISC	= 0x1680,
+	GLAMO_REGOFS_2D		= 0x1700,
+	GLAMO_REGOFS_3D		= 0x1b00,
+	GLAMO_REGOFS_END	= 0x2400,
+};
+
+
+enum glamo_register_generic {
+	GLAMO_REG_GCONF1	= 0x0000,
+	GLAMO_REG_GCONF2	= 0x0002,
+#define	GLAMO_REG_DEVICE_ID	GLAMO_REG_GCONF2
+	GLAMO_REG_GCONF3	= 0x0004,
+#define	GLAMO_REG_REVISION_ID	GLAMO_REG_GCONF3
+	GLAMO_REG_IRQ_GEN1	= 0x0006,
+#define GLAMO_REG_IRQ_ENABLE	GLAMO_REG_IRQ_GEN1
+	GLAMO_REG_IRQ_GEN2	= 0x0008,
+#define GLAMO_REG_IRQ_SET	GLAMO_REG_IRQ_GEN2
+	GLAMO_REG_IRQ_GEN3	= 0x000a,
+#define GLAMO_REG_IRQ_CLEAR	GLAMO_REG_IRQ_GEN3
+	GLAMO_REG_IRQ_GEN4	= 0x000c,
+#define GLAMO_REG_IRQ_STATUS	GLAMO_REG_IRQ_GEN4
+	GLAMO_REG_CLOCK_HOST	= 0x0010,
+	GLAMO_REG_CLOCK_MEMORY	= 0x0012,
+	GLAMO_REG_CLOCK_LCD	= 0x0014,
+	GLAMO_REG_CLOCK_MMC	= 0x0016,
+	GLAMO_REG_CLOCK_ISP	= 0x0018,
+	GLAMO_REG_CLOCK_JPEG	= 0x001a,
+	GLAMO_REG_CLOCK_3D	= 0x001c,
+	GLAMO_REG_CLOCK_2D	= 0x001e,
+	GLAMO_REG_CLOCK_RISC1	= 0x0020,	/* 3365 only? */
+	GLAMO_REG_CLOCK_RISC2	= 0x0022,	/* 3365 only? */
+	GLAMO_REG_CLOCK_MPEG	= 0x0024,
+	GLAMO_REG_CLOCK_MPROC	= 0x0026,
+
+	GLAMO_REG_CLOCK_GEN5_1	= 0x0030,
+	GLAMO_REG_CLOCK_GEN5_2	= 0x0032,
+	GLAMO_REG_CLOCK_GEN6	= 0x0034,
+	GLAMO_REG_CLOCK_GEN7	= 0x0036,
+	GLAMO_REG_CLOCK_GEN8	= 0x0038,
+	GLAMO_REG_CLOCK_GEN9	= 0x003a,
+	GLAMO_REG_CLOCK_GEN10	= 0x003c,
+	GLAMO_REG_CLOCK_GEN11	= 0x003e,
+	GLAMO_REG_PLL_GEN1	= 0x0040,
+	GLAMO_REG_PLL_GEN2	= 0x0042,
+	GLAMO_REG_PLL_GEN3	= 0x0044,
+	GLAMO_REG_PLL_GEN4	= 0x0046,
+	GLAMO_REG_PLL_GEN5	= 0x0048,
+	GLAMO_REG_GPIO_GEN1	= 0x0050,
+	GLAMO_REG_GPIO_GEN2	= 0x0052,
+	GLAMO_REG_GPIO_GEN3	= 0x0054,
+	GLAMO_REG_GPIO_GEN4	= 0x0056,
+	GLAMO_REG_GPIO_GEN5	= 0x0058,
+	GLAMO_REG_GPIO_GEN6	= 0x005a,
+	GLAMO_REG_GPIO_GEN7	= 0x005c,
+	GLAMO_REG_GPIO_GEN8	= 0x005e,
+	GLAMO_REG_GPIO_GEN9	= 0x0060,
+	GLAMO_REG_GPIO_GEN10	= 0x0062,
+	GLAMO_REG_DFT_GEN1	= 0x0070,
+	GLAMO_REG_DFT_GEN2	= 0x0072,
+	GLAMO_REG_DFT_GEN3	= 0x0074,
+	GLAMO_REG_DFT_GEN4	= 0x0076,
+
+	GLAMO_REG_DFT_GEN5	= 0x01e0,
+	GLAMO_REG_DFT_GEN6	= 0x01f0,
+};
+
+#define GLAMO_REG_HOSTBUS(x)	(GLAMO_REGOFS_HOSTBUS-2+(x*2))
+
+#define REG_MEM(x)		(GLAMO_REGOFS_MEMORY+(x))
+#define GLAMO_REG_MEM_TIMING(x)	(GLAMO_REG_MEM_TIMING1-2+(x*2))
+
+enum glamo_register_mem {
+	GLAMO_REG_MEM_TYPE	= REG_MEM(0x00),
+	GLAMO_REG_MEM_GEN	= REG_MEM(0x02),
+	GLAMO_REG_MEM_TIMING1	= REG_MEM(0x04),
+	GLAMO_REG_MEM_TIMING2	= REG_MEM(0x06),
+	GLAMO_REG_MEM_TIMING3	= REG_MEM(0x08),
+	GLAMO_REG_MEM_TIMING4	= REG_MEM(0x0a),
+	GLAMO_REG_MEM_TIMING5	= REG_MEM(0x0c),
+	GLAMO_REG_MEM_TIMING6	= REG_MEM(0x0e),
+	GLAMO_REG_MEM_TIMING7	= REG_MEM(0x10),
+	GLAMO_REG_MEM_TIMING8	= REG_MEM(0x12),
+	GLAMO_REG_MEM_TIMING9	= REG_MEM(0x14),
+	GLAMO_REG_MEM_TIMING10	= REG_MEM(0x16),
+	GLAMO_REG_MEM_TIMING11	= REG_MEM(0x18),
+	GLAMO_REG_MEM_POWER1	= REG_MEM(0x1a),
+	GLAMO_REG_MEM_POWER2	= REG_MEM(0x1c),
+	GLAMO_REG_MEM_LCD_BUF1	= REG_MEM(0x1e),
+	GLAMO_REG_MEM_LCD_BUF2	= REG_MEM(0x20),
+	GLAMO_REG_MEM_LCD_BUF3	= REG_MEM(0x22),
+	GLAMO_REG_MEM_LCD_BUF4	= REG_MEM(0x24),
+	GLAMO_REG_MEM_BIST1	= REG_MEM(0x26),
+	GLAMO_REG_MEM_BIST2	= REG_MEM(0x28),
+	GLAMO_REG_MEM_BIST3	= REG_MEM(0x2a),
+	GLAMO_REG_MEM_BIST4	= REG_MEM(0x2c),
+	GLAMO_REG_MEM_BIST5	= REG_MEM(0x2e),
+	GLAMO_REG_MEM_MAH1	= REG_MEM(0x30),
+	GLAMO_REG_MEM_MAH2	= REG_MEM(0x32),
+	GLAMO_REG_MEM_DRAM1	= REG_MEM(0x34),
+	GLAMO_REG_MEM_DRAM2	= REG_MEM(0x36),
+	GLAMO_REG_MEM_CRC	= REG_MEM(0x38),
+};
+
+#define GLAMO_MEM_TYPE_MASK	0x03
+
+enum glamo_reg_mem_dram1 {
+	/* b0 - b10 == refresh period, 1 -> 2048 clocks */
+	GLAMO_MEM_DRAM1_EN_GATE_CLK	= (1 << 11),
+	GLAMO_MEM_DRAM1_SELF_REFRESH	= (1 << 12),
+	GLAMO_MEM_DRAM1_EN_GATE_CKE	= (1 << 13),
+	GLAMO_MEM_DRAM1_EN_DRAM_REFRESH	= (1 << 14),
+	GLAMO_MEM_DRAM1_EN_MODEREG_SET	= (1 << 15),
+};
+
+enum glamo_reg_mem_dram2 {
+	GLAMO_MEM_DRAM2_DEEP_PWRDOWN	= (1 << 12),
+};
+
+enum glamo_irq_index {
+	GLAMO_IRQIDX_HOSTBUS	= 0,
+	GLAMO_IRQIDX_JPEG	= 1,
+	GLAMO_IRQIDX_MPEG	= 2,
+	GLAMO_IRQIDX_MPROC1	= 3,
+	GLAMO_IRQIDX_MPROC0	= 4,
+	GLAMO_IRQIDX_CMDQUEUE	= 5,
+	GLAMO_IRQIDX_2D		= 6,
+	GLAMO_IRQIDX_MMC	= 7,
+	GLAMO_IRQIDX_RISC	= 8,
+};
+
+enum glamo_irq {
+	GLAMO_IRQ_HOSTBUS	= (1 << GLAMO_IRQIDX_HOSTBUS),
+	GLAMO_IRQ_JPEG		= (1 << GLAMO_IRQIDX_JPEG),
+	GLAMO_IRQ_MPEG		= (1 << GLAMO_IRQIDX_MPEG),
+	GLAMO_IRQ_MPROC1	= (1 << GLAMO_IRQIDX_MPROC1),
+	GLAMO_IRQ_MPROC0	= (1 << GLAMO_IRQIDX_MPROC0),
+	GLAMO_IRQ_CMDQUEUE	= (1 << GLAMO_IRQIDX_CMDQUEUE),
+	GLAMO_IRQ_2D		= (1 << GLAMO_IRQIDX_2D),
+	GLAMO_IRQ_MMC		= (1 << GLAMO_IRQIDX_MMC),
+	GLAMO_IRQ_RISC		= (1 << GLAMO_IRQIDX_RISC),
+};
+
+enum glamo_reg_clock_host {
+	GLAMO_CLOCK_HOST_DG_BCLK	= 0x0001,
+	GLAMO_CLOCK_HOST_DG_M0CLK	= 0x0004,
+	GLAMO_CLOCK_HOST_RESET		= 0x1000,
+};
+
+enum glamo_reg_clock_mem {
+	GLAMO_CLOCK_MEM_DG_M1CLK	= 0x0001,
+	GLAMO_CLOCK_MEM_EN_M1CLK	= 0x0002,
+	GLAMO_CLOCK_MEM_DG_MOCACLK	= 0x0004,
+	GLAMO_CLOCK_MEM_EN_MOCACLK	= 0x0008,
+	GLAMO_CLOCK_MEM_RESET		= 0x1000,
+	GLAMO_CLOCK_MOCA_RESET		= 0x2000,
+};
+
+enum glamo_reg_clock_lcd {
+	GLAMO_CLOCK_LCD_DG_DCLK		= 0x0001,
+	GLAMO_CLOCK_LCD_EN_DCLK		= 0x0002,
+	GLAMO_CLOCK_LCD_DG_DMCLK	= 0x0004,
+	GLAMO_CLOCK_LCD_EN_DMCLK	= 0x0008,
+	GLAMO_CLOCK_LCD_EN_DHCLK	= 0x0020,
+	GLAMO_CLOCK_LCD_DG_M5CLK	= 0x0040,
+	GLAMO_CLOCK_LCD_EN_M5CLK	= 0x0080,
+	GLAMO_CLOCK_LCD_RESET		= 0x1000,
+};
+
+enum glamo_reg_clock_mmc {
+	GLAMO_CLOCK_MMC_DG_TCLK		= 0x0001,
+	GLAMO_CLOCK_MMC_EN_TCLK		= 0x0002,
+	GLAMO_CLOCK_MMC_DG_M9CLK	= 0x0004,
+	GLAMO_CLOCK_MMC_EN_M9CLK	= 0x0008,
+	GLAMO_CLOCK_MMC_RESET		= 0x1000,
+};
+
+enum glamo_reg_basic_mmc {
+	/* set to disable CRC error rejection */
+	GLAMO_BASIC_MMC_DISABLE_CRC	= 0x0001,
+	/* enable completion interrupt */
+	GLAMO_BASIC_MMC_EN_COMPL_INT	= 0x0002,
+	/* stop MMC clock while enforced idle waiting for data from card */
+	GLAMO_BASIC_MMC_NO_CLK_RD_WAIT	= 0x0004,
+	/* 0 = 1-bit bus to card, 1 = use 4-bit bus (has to be negotiated) */
+	GLAMO_BASIC_MMC_EN_4BIT_DATA	= 0x0008,
+	/* enable 75K pullups on D3..D0 */
+	GLAMO_BASIC_MMC_EN_DATA_PUPS	= 0x0010,
+	/* enable 75K pullup on CMD */
+	GLAMO_BASIC_MMC_EN_CMD_PUP	= 0x0020,
+	/* IO drive strength 00=weak -> 11=strongest */
+	GLAMO_BASIC_MMC_EN_DR_STR0	= 0x0040,
+	GLAMO_BASIC_MMC_EN_DR_STR1	= 0x0080,
+	/* TCLK delay stage A, 0000 = 500ps --> 1111 = 8ns */
+	GLAMO_BASIC_MMC_EN_TCLK_DLYA0	= 0x0100,
+	GLAMO_BASIC_MMC_EN_TCLK_DLYA1	= 0x0200,
+	GLAMO_BASIC_MMC_EN_TCLK_DLYA2	= 0x0400,
+	GLAMO_BASIC_MMC_EN_TCLK_DLYA3	= 0x0800,
+	/* TCLK delay stage B (cumulative), 0000 = 500ps --> 1111 = 8ns */
+	GLAMO_BASIC_MMC_EN_TCLK_DLYB0	= 0x1000,
+	GLAMO_BASIC_MMC_EN_TCLK_DLYB1	= 0x2000,
+	GLAMO_BASIC_MMC_EN_TCLK_DLYB2	= 0x4000,
+	GLAMO_BASIC_MMC_EN_TCLK_DLYB3	= 0x8000,
+};
+
+enum glamo_reg_stat1_mmc {
+	/* command "counter" (really: toggle) */
+	GLAMO_STAT1_MMC_CMD_CTR	= 0x8000,
+	/* engine is idle */
+	GLAMO_STAT1_MMC_IDLE	= 0x4000,
+	/* readback response is ready */
+	GLAMO_STAT1_MMC_RB_RRDY	= 0x0200,
+	/* readback data is ready */
+	GLAMO_STAT1_MMC_RB_DRDY	= 0x0100,
+	/* no response timeout */
+	GLAMO_STAT1_MMC_RTOUT	= 0x0020,
+	/* no data timeout */
+	GLAMO_STAT1_MMC_DTOUT	= 0x0010,
+	/* CRC error on block write */
+	GLAMO_STAT1_MMC_BWERR	= 0x0004,
+	/* CRC error on block read */
+	GLAMO_STAT1_MMC_BRERR	= 0x0002
+};
+
+enum glamo_reg_fire_mmc {
+	/* command "counter" (really: toggle)
+	 * the STAT1 register reflects this so you can ensure you don't look
+	 * at status for previous command
+	 */
+	GLAMO_FIRE_MMC_CMD_CTR	= 0x8000,
+	/* sets kind of response expected */
+	GLAMO_FIRE_MMC_RES_MASK	= 0x0700,
+	/* sets command type */
+	GLAMO_FIRE_MMC_TYP_MASK	= 0x00C0,
+	/* sets command class */
+	GLAMO_FIRE_MMC_CLS_MASK	= 0x000F,
+};
+
+enum glamo_fire_mmc_response_types {
+	GLAMO_FIRE_MMC_RSPT_R1	= 0x0000,
+	GLAMO_FIRE_MMC_RSPT_R1b	= 0x0100,
+	GLAMO_FIRE_MMC_RSPT_R2	= 0x0200,
+	GLAMO_FIRE_MMC_RSPT_R3	= 0x0300,
+	GLAMO_FIRE_MMC_RSPT_R4	= 0x0400,
+	GLAMO_FIRE_MMC_RSPT_R5	= 0x0500,
+};
+
+enum glamo_fire_mmc_command_types {
+	/* broadcast, no response */
+	GLAMO_FIRE_MMC_CMDT_BNR	= 0x0000,
+	/* broadcast, with response */
+	GLAMO_FIRE_MMC_CMDT_BR	= 0x0040,
+	/* addressed, no data */
+	GLAMO_FIRE_MMC_CMDT_AND	= 0x0080,
+	/* addressed, with data */
+	GLAMO_FIRE_MMC_CMDT_AD	= 0x00C0,
+};
+
+enum glamo_fire_mmc_command_class {
+	/* "Stream Read" */
+	GLAMO_FIRE_MMC_CC_STRR	= 0x0000,
+	/* Single Block Read */
+	GLAMO_FIRE_MMC_CC_SBR	= 0x0001,
+	/* Multiple Block Read With Stop */
+	GLAMO_FIRE_MMC_CC_MBRS	= 0x0002,
+	/* Multiple Block Read No Stop */
+	GLAMO_FIRE_MMC_CC_MBRNS	= 0x0003,
+	/* RESERVED for "Stream Write" */
+	GLAMO_FIRE_MMC_CC_STRW	= 0x0004,
+	/* "Stream Write" */
+	GLAMO_FIRE_MMC_CC_SBW	= 0x0005,
+	/* RESERVED for Multiple Block Write With Stop */
+	GLAMO_FIRE_MMC_CC_MBWS	= 0x0006,
+	/* Multiple Block Write No Stop */
+	GLAMO_FIRE_MMC_CC_MBWNS	= 0x0007,
+	/* STOP command */
+	GLAMO_FIRE_MMC_CC_STOP	= 0x0008,
+	/* Cancel on Running Command */
+	GLAMO_FIRE_MMC_CC_CANCL	= 0x0009,
+	/* "Basic Command" */
+	GLAMO_FIRE_MMC_CC_BASIC	= 0x000a,
+};
+
+/* these are offsets from the start of the MMC register region */
+enum glamo_register_mmc {
+	/* MMC command, b15..8 = cmd arg b7..0; b7..1 = CRC; b0 = end bit */
+	GLAMO_REG_MMC_CMD_REG1	= 0x00,
+	/* MMC command, b15..0 = cmd arg b23 .. 8 */
+	GLAMO_REG_MMC_CMD_REG2	= 0x02,
+	/* MMC command, b15=start, b14=transmission,
+	 * b13..8=cmd idx, b7..0=cmd arg b31..24
+	 */
+	GLAMO_REG_MMC_CMD_REG3	= 0x04,
+	GLAMO_REG_MMC_CMD_FIRE	= 0x06,
+	GLAMO_REG_MMC_CMD_RSP1	= 0x10,
+	GLAMO_REG_MMC_CMD_RSP2	= 0x12,
+	GLAMO_REG_MMC_CMD_RSP3	= 0x14,
+	GLAMO_REG_MMC_CMD_RSP4	= 0x16,
+	GLAMO_REG_MMC_CMD_RSP5	= 0x18,
+	GLAMO_REG_MMC_CMD_RSP6	= 0x1a,
+	GLAMO_REG_MMC_CMD_RSP7	= 0x1c,
+	GLAMO_REG_MMC_CMD_RSP8	= 0x1e,
+	GLAMO_REG_MMC_RB_STAT1	= 0x20,
+	GLAMO_REG_MMC_RB_BLKCNT	= 0x22,
+	GLAMO_REG_MMC_RB_BLKLEN	= 0x24,
+	GLAMO_REG_MMC_BASIC	= 0x30,
+	GLAMO_REG_MMC_RDATADS1	= 0x34,
+	GLAMO_REG_MMC_RDATADS2	= 0x36,
+	GLAMO_REG_MMC_WDATADS1	= 0x38,
+	GLAMO_REG_MMC_WDATADS2	= 0x3a,
+	GLAMO_REG_MMC_DATBLKCNT	= 0x3c,
+	GLAMO_REG_MMC_DATBLKLEN	= 0x3e,
+	GLAMO_REG_MMC_TIMEOUT	= 0x40,
+
+};
+
+enum glamo_reg_clock_isp {
+	GLAMO_CLOCK_ISP_DG_I1CLK	= 0x0001,
+	GLAMO_CLOCK_ISP_EN_I1CLK	= 0x0002,
+	GLAMO_CLOCK_ISP_DG_CCLK		= 0x0004,
+	GLAMO_CLOCK_ISP_EN_CCLK		= 0x0008,
+	GLAMO_CLOCK_ISP_EN_SCLK		= 0x0020,
+	GLAMO_CLOCK_ISP_DG_M2CLK	= 0x0040,
+	GLAMO_CLOCK_ISP_EN_M2CLK	= 0x0080,
+	GLAMO_CLOCK_ISP_DG_M15CLK	= 0x0100,
+	GLAMO_CLOCK_ISP_EN_M15CLK	= 0x0200,
+	GLAMO_CLOCK_ISP1_RESET		= 0x1000,
+	GLAMO_CLOCK_ISP2_RESET		= 0x2000,
+};
+
+enum glamo_reg_clock_jpeg {
+	GLAMO_CLOCK_JPEG_DG_JCLK	= 0x0001,
+	GLAMO_CLOCK_JPEG_EN_JCLK	= 0x0002,
+	GLAMO_CLOCK_JPEG_DG_M3CLK	= 0x0004,
+	GLAMO_CLOCK_JPEG_EN_M3CLK	= 0x0008,
+	GLAMO_CLOCK_JPEG_RESET		= 0x1000,
+};
+
+enum glamo_reg_clock_2d {
+	GLAMO_CLOCK_2D_DG_GCLK		= 0x0001,
+	GLAMO_CLOCK_2D_EN_GCLK		= 0x0002,
+	GLAMO_CLOCK_2D_DG_M7CLK		= 0x0004,
+	GLAMO_CLOCK_2D_EN_M7CLK		= 0x0008,
+	GLAMO_CLOCK_2D_DG_M6CLK		= 0x0010,
+	GLAMO_CLOCK_2D_EN_M6CLK		= 0x0020,
+	GLAMO_CLOCK_2D_RESET		= 0x1000,
+	GLAMO_CLOCK_2D_CQ_RESET		= 0x2000,
+};
+
+enum glamo_reg_clock_3d {
+	GLAMO_CLOCK_3D_DG_ECLK		= 0x0001,
+	GLAMO_CLOCK_3D_EN_ECLK		= 0x0002,
+	GLAMO_CLOCK_3D_DG_RCLK		= 0x0004,
+	GLAMO_CLOCK_3D_EN_RCLK		= 0x0008,
+	GLAMO_CLOCK_3D_DG_M8CLK		= 0x0010,
+	GLAMO_CLOCK_3D_EN_M8CLK		= 0x0020,
+	GLAMO_CLOCK_3D_BACK_RESET	= 0x1000,
+	GLAMO_CLOCK_3D_FRONT_RESET	= 0x2000,
+};
+
+enum glamo_reg_clock_mpeg {
+	GLAMO_CLOCK_MPEG_DG_X0CLK	= 0x0001,
+	GLAMO_CLOCK_MPEG_EN_X0CLK	= 0x0002,
+	GLAMO_CLOCK_MPEG_DG_X1CLK	= 0x0004,
+	GLAMO_CLOCK_MPEG_EN_X1CLK	= 0x0008,
+	GLAMO_CLOCK_MPEG_DG_X2CLK	= 0x0010,
+	GLAMO_CLOCK_MPEG_EN_X2CLK	= 0x0020,
+	GLAMO_CLOCK_MPEG_DG_X3CLK	= 0x0040,
+	GLAMO_CLOCK_MPEG_EN_X3CLK	= 0x0080,
+	GLAMO_CLOCK_MPEG_DG_X4CLK	= 0x0100,
+	GLAMO_CLOCK_MPEG_EN_X4CLK	= 0x0200,
+	GLAMO_CLOCK_MPEG_DG_X6CLK	= 0x0400,
+	GLAMO_CLOCK_MPEG_EN_X6CLK	= 0x0800,
+	GLAMO_CLOCK_MPEG_ENC_RESET	= 0x1000,
+	GLAMO_CLOCK_MPEG_DEC_RESET	= 0x2000,
+};
+
+enum glamo_reg_clock51 {
+	GLAMO_CLOCK_GEN51_EN_DIV_MCLK	= 0x0001,
+	GLAMO_CLOCK_GEN51_EN_DIV_SCLK	= 0x0002,
+	GLAMO_CLOCK_GEN51_EN_DIV_JCLK	= 0x0004,
+	GLAMO_CLOCK_GEN51_EN_DIV_DCLK	= 0x0008,
+	GLAMO_CLOCK_GEN51_EN_DIV_DMCLK	= 0x0010,
+	GLAMO_CLOCK_GEN51_EN_DIV_DHCLK	= 0x0020,
+	GLAMO_CLOCK_GEN51_EN_DIV_GCLK	= 0x0040,
+	GLAMO_CLOCK_GEN51_EN_DIV_TCLK	= 0x0080,
+	/* FIXME: higher bits */
+};
+
+enum glamo_reg_hostbus2 {
+	GLAMO_HOSTBUS2_MMIO_EN_ISP	= 0x0001,
+	GLAMO_HOSTBUS2_MMIO_EN_JPEG	= 0x0002,
+	GLAMO_HOSTBUS2_MMIO_EN_MPEG	= 0x0004,
+	GLAMO_HOSTBUS2_MMIO_EN_LCD	= 0x0008,
+	GLAMO_HOSTBUS2_MMIO_EN_MMC	= 0x0010,
+	GLAMO_HOSTBUS2_MMIO_EN_MICROP0	= 0x0020,
+	GLAMO_HOSTBUS2_MMIO_EN_MICROP1	= 0x0040,
+	GLAMO_HOSTBUS2_MMIO_EN_CQ	= 0x0080,
+	GLAMO_HOSTBUS2_MMIO_EN_RISC	= 0x0100,
+	GLAMO_HOSTBUS2_MMIO_EN_2D	= 0x0200,
+	GLAMO_HOSTBUS2_MMIO_EN_3D	= 0x0400,
+};
+
+/* LCD Controller */
+
+#define REG_LCD(x)	(x)
+enum glamo_reg_lcd {
+	GLAMO_REG_LCD_MODE1		= REG_LCD(0x00),
+	GLAMO_REG_LCD_MODE2		= REG_LCD(0x02),
+	GLAMO_REG_LCD_MODE3		= REG_LCD(0x04),
+	GLAMO_REG_LCD_WIDTH		= REG_LCD(0x06),
+	GLAMO_REG_LCD_HEIGHT		= REG_LCD(0x08),
+	GLAMO_REG_LCD_POLARITY		= REG_LCD(0x0a),
+	GLAMO_REG_LCD_A_BASE1		= REG_LCD(0x0c),
+	GLAMO_REG_LCD_A_BASE2		= REG_LCD(0x0e),
+	GLAMO_REG_LCD_B_BASE1		= REG_LCD(0x10),
+	GLAMO_REG_LCD_B_BASE2		= REG_LCD(0x12),
+	GLAMO_REG_LCD_C_BASE1		= REG_LCD(0x14),
+	GLAMO_REG_LCD_C_BASE2		= REG_LCD(0x16),
+	GLAMO_REG_LCD_PITCH		= REG_LCD(0x18),
+	/* RES */
+	GLAMO_REG_LCD_HORIZ_TOTAL	= REG_LCD(0x1c),
+	/* RES */
+	GLAMO_REG_LCD_HORIZ_RETR_START	= REG_LCD(0x20),
+	/* RES */
+	GLAMO_REG_LCD_HORIZ_RETR_END	= REG_LCD(0x24),
+	/* RES */
+	GLAMO_REG_LCD_HORIZ_DISP_START	= REG_LCD(0x28),
+	/* RES */
+	GLAMO_REG_LCD_HORIZ_DISP_END	= REG_LCD(0x2c),
+	/* RES */
+	GLAMO_REG_LCD_VERT_TOTAL	= REG_LCD(0x30),
+	/* RES */
+	GLAMO_REG_LCD_VERT_RETR_START	= REG_LCD(0x34),
+	/* RES */
+	GLAMO_REG_LCD_VERT_RETR_END	= REG_LCD(0x38),
+	/* RES */
+	GLAMO_REG_LCD_VERT_DISP_START	= REG_LCD(0x3c),
+	/* RES */
+	GLAMO_REG_LCD_VERT_DISP_END	= REG_LCD(0x40),
+	/* RES */
+	GLAMO_REG_LCD_POL		= REG_LCD(0x44),
+	GLAMO_REG_LCD_DATA_START	= REG_LCD(0x46),
+	GLAMO_REG_LCD_FRATE_CONTRO	= REG_LCD(0x48),
+	GLAMO_REG_LCD_DATA_CMD_HDR	= REG_LCD(0x4a),
+	GLAMO_REG_LCD_SP_START		= REG_LCD(0x4c),
+	GLAMO_REG_LCD_SP_END		= REG_LCD(0x4e),
+	GLAMO_REG_LCD_CURSOR_BASE1	= REG_LCD(0x50),
+	GLAMO_REG_LCD_CURSOR_BASE2	= REG_LCD(0x52),
+	GLAMO_REG_LCD_CURSOR_PITCH	= REG_LCD(0x54),
+	GLAMO_REG_LCD_CURSOR_X_SIZE	= REG_LCD(0x56),
+	GLAMO_REG_LCD_CURSOR_Y_SIZE	= REG_LCD(0x58),
+	GLAMO_REG_LCD_CURSOR_X_POS	= REG_LCD(0x5a),
+	GLAMO_REG_LCD_CURSOR_Y_POS	= REG_LCD(0x5c),
+	GLAMO_REG_LCD_CURSOR_PRESET	= REG_LCD(0x5e),
+	GLAMO_REG_LCD_CURSOR_FG_COLOR	= REG_LCD(0x60),
+	/* RES */
+	GLAMO_REG_LCD_CURSOR_BG_COLOR	= REG_LCD(0x64),
+	/* RES */
+	GLAMO_REG_LCD_CURSOR_DST_COLOR	= REG_LCD(0x68),
+	/* RES */
+	GLAMO_REG_LCD_STATUS1		= REG_LCD(0x80),
+	GLAMO_REG_LCD_STATUS2		= REG_LCD(0x82),
+	GLAMO_REG_LCD_STATUS3		= REG_LCD(0x84),
+	GLAMO_REG_LCD_STATUS4		= REG_LCD(0x86),
+	/* RES */
+	GLAMO_REG_LCD_COMMAND1		= REG_LCD(0xa0),
+	GLAMO_REG_LCD_COMMAND2		= REG_LCD(0xa2),
+	/* RES */
+	GLAMO_REG_LCD_WFORM_DELAY1	= REG_LCD(0xb0),
+	GLAMO_REG_LCD_WFORM_DELAY2	= REG_LCD(0xb2),
+	/* RES */
+	GLAMO_REG_LCD_GAMMA_CORR	= REG_LCD(0x100),
+	/* RES */
+	GLAMO_REG_LCD_GAMMA_R_ENTRY01	= REG_LCD(0x110),
+	GLAMO_REG_LCD_GAMMA_R_ENTRY23	= REG_LCD(0x112),
+	GLAMO_REG_LCD_GAMMA_R_ENTRY45	= REG_LCD(0x114),
+	GLAMO_REG_LCD_GAMMA_R_ENTRY67	= REG_LCD(0x116),
+	GLAMO_REG_LCD_GAMMA_R_ENTRY8	= REG_LCD(0x118),
+	/* RES */
+	GLAMO_REG_LCD_GAMMA_G_ENTRY01	= REG_LCD(0x130),
+	GLAMO_REG_LCD_GAMMA_G_ENTRY23	= REG_LCD(0x132),
+	GLAMO_REG_LCD_GAMMA_G_ENTRY45	= REG_LCD(0x134),
+	GLAMO_REG_LCD_GAMMA_G_ENTRY67	= REG_LCD(0x136),
+	GLAMO_REG_LCD_GAMMA_G_ENTRY8	= REG_LCD(0x138),
+	/* RES */
+	GLAMO_REG_LCD_GAMMA_B_ENTRY01	= REG_LCD(0x150),
+	GLAMO_REG_LCD_GAMMA_B_ENTRY23	= REG_LCD(0x152),
+	GLAMO_REG_LCD_GAMMA_B_ENTRY45	= REG_LCD(0x154),
+	GLAMO_REG_LCD_GAMMA_B_ENTRY67	= REG_LCD(0x156),
+	GLAMO_REG_LCD_GAMMA_B_ENTRY8	= REG_LCD(0x158),
+	/* RES */
+	GLAMO_REG_LCD_SRAM_DRIVING1	= REG_LCD(0x160),
+	GLAMO_REG_LCD_SRAM_DRIVING2	= REG_LCD(0x162),
+	GLAMO_REG_LCD_SRAM_DRIVING3	= REG_LCD(0x164),
+};
+
+enum glamo_reg_lcd_mode1 {
+	GLAMO_LCD_MODE1_PWRSAVE		= 0x0001,
+	GLAMO_LCD_MODE1_PARTIAL_PRT	= 0x0002,
+	GLAMO_LCD_MODE1_HWFLIP		= 0x0004,
+	GLAMO_LCD_MODE1_LCD2		= 0x0008,
+	/* RES */
+	GLAMO_LCD_MODE1_PARTIAL_MODE	= 0x0020,
+	GLAMO_LCD_MODE1_CURSOR_DSTCOLOR	= 0x0040,
+	GLAMO_LCD_MODE1_PARTIAL_ENABLE	= 0x0080,
+	GLAMO_LCD_MODE1_TVCLK_IN_ENABLE	= 0x0100,
+	GLAMO_LCD_MODE1_HSYNC_HIGH_ACT	= 0x0200,
+	GLAMO_LCD_MODE1_VSYNC_HIGH_ACT	= 0x0400,
+	GLAMO_LCD_MODE1_HSYNC_FLIP	= 0x0800,
+	GLAMO_LCD_MODE1_GAMMA_COR_EN	= 0x1000,
+	GLAMO_LCD_MODE1_DITHER_EN	= 0x2000,
+	GLAMO_LCD_MODE1_CURSOR_EN	= 0x4000,
+	GLAMO_LCD_MODE1_ROTATE_EN	= 0x8000,
+};
+
+enum glamo_reg_lcd_mode2 {
+	GLAMO_LCD_MODE2_CRC_CHECK_EN	= 0x0001,
+	GLAMO_LCD_MODE2_DCMD_PER_LINE	= 0x0002,
+	GLAMO_LCD_MODE2_NOUSE_BDEF	= 0x0004,
+	GLAMO_LCD_MODE2_OUT_POS_MODE	= 0x0008,
+	GLAMO_LCD_MODE2_FRATE_CTRL_EN	= 0x0010,
+	GLAMO_LCD_MODE2_SINGLE_BUFFER	= 0x0020,
+	GLAMO_LCD_MODE2_SER_LSB_TO_MSB	= 0x0040,
+	/* FIXME */
+};
+
+enum glamo_reg_lcd_mode3 {
+	/* LCD color source data format */
+	GLAMO_LCD_SRC_RGB565		= 0x0000,
+	GLAMO_LCD_SRC_ARGB1555		= 0x4000,
+	GLAMO_LCD_SRC_ARGB4444		= 0x8000,
+	/* interface type */
+	GLAMO_LCD_MODE3_LCD		= 0x1000,
+	GLAMO_LCD_MODE3_RGB		= 0x0800,
+	GLAMO_LCD_MODE3_CPU		= 0x0000,
+	/* mode */
+	GLAMO_LCD_MODE3_RGB332		= 0x0000,
+	GLAMO_LCD_MODE3_RGB444		= 0x0100,
+	GLAMO_LCD_MODE3_RGB565		= 0x0200,
+	GLAMO_LCD_MODE3_RGB666		= 0x0300,
+	/* depth */
+	GLAMO_LCD_MODE3_6BITS		= 0x0000,
+	GLAMO_LCD_MODE3_8BITS		= 0x0010,
+	GLAMO_LCD_MODE3_9BITS		= 0x0020,
+	GLAMO_LCD_MODE3_16BITS		= 0x0030,
+	GLAMO_LCD_MODE3_18BITS		= 0x0040,
+};
+
+enum glamo_lcd_rot_mode {
+	GLAMO_LCD_ROT_MODE_0            = 0x0000,
+	GLAMO_LCD_ROT_MODE_180          = 0x2000,
+	GLAMO_LCD_ROT_MODE_MIRROR       = 0x4000,
+	GLAMO_LCD_ROT_MODE_FLIP         = 0x6000,
+	GLAMO_LCD_ROT_MODE_90           = 0x8000,
+	GLAMO_LCD_ROT_MODE_270          = 0xa000,
+};
+#define GLAMO_LCD_ROT_MODE_MASK         0xe000
+
+enum glamo_lcd_cmd_type {
+	GLAMO_LCD_CMD_TYPE_DISP		 = 0x0000,
+	GLAMO_LCD_CMD_TYPE_PARALLEL	 = 0x4000,
+	GLAMO_LCD_CMD_TYPE_SERIAL	 = 0x8000,
+	GLAMO_LCD_CMD_TYPE_SERIAL_DIRECT = 0xc000,
+};
+#define GLAMO_LCD_CMD_TYPE_MASK		0xc000
+
+enum glamo_lcd_cmds {
+	GLAMO_LCD_CMD_DATA_DISP_FIRE	= 0x00,
+	GLAMO_LCD_CMD_DATA_DISP_SYNC	= 0x01,		/* RGB only */
+	/* switch to command mode, no display */
+	GLAMO_LCD_CMD_DATA_FIRE_NO_DISP	= 0x02,
+	/* display until VSYNC, switch to command */
+	GLAMO_LCD_CMD_DATA_FIRE_VSYNC	= 0x11,
+	/* display until HSYNC, switch to command */
+	GLAMO_LCD_CMD_DATA_FIRE_HSYNC	= 0x12,
+	/* display until VSYNC, 1 black frame, VSYNC, switch to command */
+	GLAMO_LCD_CMD_DATA_FIRE_VSYNC_B	= 0x13,
+	/* don't care about display and switch to command */
+	GLAMO_LCD_CMD_DATA_FIRE_FREE	= 0x14,		/* RGB only */
+	/* don't care about display, keep data display but disable data,
+	 * and switch to command */
+	GLAMO_LCD_CMD_DATA_FIRE_FREE_D	= 0x15,		/* RGB only */
+};
+
+enum glamo_core_revisions {
+	GLAMO_CORE_REV_A0		= 0x0000,
+	GLAMO_CORE_REV_A1		= 0x0001,
+	GLAMO_CORE_REV_A2		= 0x0002,
+	GLAMO_CORE_REV_A3		= 0x0003,
+};
+
+#endif /* _GLAMO_REGS_H */
diff --git a/include/linux/mfd/glamo.h b/include/linux/mfd/glamo.h
new file mode 100644
index 0000000..ae52f3d
--- /dev/null
+++ b/include/linux/mfd/glamo.h
@@ -0,0 +1,54 @@
+#ifndef __GLAMO_MFD_H
+#define __GLAMO_MFD_H
+
+struct glamo_core;
+struct glamo_spigpio_platform_data;
+struct glamo_fb_platform_data;
+
+struct glamo_mmc_platform_data {
+	int	(*glamo_mmc_use_slow)(void);
+
+	unsigned nonremovable:1;
+
+	struct glamo_core *core;
+};
+
+struct glamo_gpio_platform_data {
+	int base;
+	void (*registered)(struct device *dev);
+};
+
+struct glamo_platform_data {
+	struct glamo_fb_platform_data	*fb_data;
+	struct glamo_mmc_platform_data	*mmc_data;
+	struct glamo_gpio_platform_data	*gpio_data;
+
+	unsigned int osci_clock_rate;
+
+	void (*glamo_external_reset)(int);
+};
+
+enum glamo_engine {
+	GLAMO_ENGINE_CAPTURE = 0,
+	GLAMO_ENGINE_ISP = 1,
+	GLAMO_ENGINE_JPEG = 2,
+	GLAMO_ENGINE_MPEG_ENC = 3,
+	GLAMO_ENGINE_MPEG_DEC = 4,
+	GLAMO_ENGINE_LCD = 5,
+	GLAMO_ENGINE_CMDQ = 6,
+	GLAMO_ENGINE_2D = 7,
+	GLAMO_ENGINE_3D = 8,
+	GLAMO_ENGINE_MMC = 9,
+	GLAMO_ENGINE_MICROP0 = 10,
+	GLAMO_ENGINE_RISC = 11,
+	GLAMO_ENGINE_MICROP1_MPEG_ENC = 12,
+	GLAMO_ENGINE_MICROP1_MPEG_DEC = 13,
+#if 0
+	GLAMO_ENGINE_H264_DEC = 14,
+	GLAMO_ENGINE_RISC1 = 15,
+	GLAMO_ENGINE_SPI = 16,
+#endif
+	__NUM_GLAMO_ENGINES
+};
+
+#endif
-- 
1.7.1

