Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab1DLCCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 22:02:40 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40588 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab1DLCCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 22:02:38 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6313"; a="85042640"
From: Kenneth Heitke <kheitke@codeaurora.org>
To: davidb@codeaurora.org, dwalker@fifo99.com, ben-linux@fluff.org
Cc: tsoni@codeaurora.org, linux-arm-msm@vger.kernel.org,
        sdharia@codeaurora.org, arve@android.com, swetland@google.com,
        Kenneth Heitke <kheitke@codeaurora.org>, <bryanh@codeaurora.org>,
        <linux@arm.linux.org.uk>, <khali@linux-fr.org>,
        <seth.heasley@intel.com>, <w.sang@pengutronix.de>,
        <tomoya-linux@dsn.okisemi.com>, <guenter.roeck@ericsson.com>,
        <linus.walleij@stericsson.com>,
        linux-arm-kernel@lists.infradead.org (open list:ARM PORT),
        linux-kernel@vger.kernel.org (open list),
        linux-i2c@vger.kernel.org (open list:I2C SUBSYSTEM)
Subject: [PATCH] i2c: QUP based bus driver for Qualcomm MSM chipsets
Date: Mon, 11 Apr 2011 20:02:27 -0600
Message-Id: <1302573749-15647-1-git-send-email-kheitke@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bus driver supports the QUP i2c hardware controller in the Qualcomm
MSM SOCs.  The Qualcomm Universal Peripheral Engine (QUP) is a general
purpose data path engine with input/output FIFOs and an embedded i2c
mini-core. The driver supports FIFO mode (for low bandwidth applications)
and block mode (interrupt generated for each block-size data transfer).
The driver currently does not support DMA transfers.

Signed-off-by: Kenneth Heitke <kheitke@codeaurora.org>
---
The header file (msm_qup_i2c.h) defines the platform data used by the
QUP driver.  This file can be picked up by the i2c maintainers but also
needs to be Acked by the msm maintainers (linux-arm-msm).
---
 arch/arm/mach-msm/include/mach/msm_qup_i2c.h |   24 +
 drivers/i2c/busses/Kconfig                   |   11 +
 drivers/i2c/busses/Makefile                  |    1 +
 drivers/i2c/busses/i2c-qup.c                 | 1194 ++++++++++++++++++++++++++
 4 files changed, 1230 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-msm/include/mach/msm_qup_i2c.h
 create mode 100644 drivers/i2c/busses/i2c-qup.c

diff --git a/arch/arm/mach-msm/include/mach/msm_qup_i2c.h b/arch/arm/mach-msm/include/mach/msm_qup_i2c.h
new file mode 100644
index 0000000..a96c3c2
--- /dev/null
+++ b/arch/arm/mach-msm/include/mach/msm_qup_i2c.h
@@ -0,0 +1,24 @@
+/*
+ * Qualcomm MSM QUP i2c Controller Platform Data
+ *
+ * Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MSM_QUP_I2C_MSM_H
+#define __MSM_QUP_I2C_MSM_H
+
+struct msm_qup_i2c_platform_data {
+	int bus_freq;		/* I2C bus frequency (Hz) */
+	int src_clk_rate;	/* I2C controller clock rate (Hz) */
+};
+
+#endif /* __MSM_QUP_I2C_MSM_H */
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 326652f..ecf0896 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -564,6 +564,17 @@ config I2C_PXA_SLAVE
 	  is necessary for systems where the PXA may be a target on the
 	  I2C bus.
 
+config I2C_QUP
+	tristate "Qualcomm MSM QUP I2C Controller"
+	depends on ARCH_MSM
+	help
+	  If you say yes to this option, support will be included for the
+	  built-in QUP I2C interface on Qualcomm MSM family processors.
+
+	  The Qualcomm Universal Peripheral Engine (QUP) is a general
+	  purpose data path engine with input/output FIFOs and an
+	  embedded I2C mini-core.
+
 config HAVE_S3C2410_I2C
 	bool
 	help
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index e6cf294..0516104 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -55,6 +55,7 @@ obj-$(CONFIG_I2C_PNX)		+= i2c-pnx.o
 obj-$(CONFIG_I2C_PUV3)		+= i2c-puv3.o
 obj-$(CONFIG_I2C_PXA)		+= i2c-pxa.o
 obj-$(CONFIG_I2C_PXA_PCI)	+= i2c-pxa-pci.o
+obj-$(CONFIG_I2C_QUP)		+= i2c-qup.o
 obj-$(CONFIG_I2C_S3C2410)	+= i2c-s3c2410.o
 obj-$(CONFIG_I2C_S6000)		+= i2c-s6000.o
 obj-$(CONFIG_I2C_SH7760)	+= i2c-sh7760.o
diff --git a/drivers/i2c/busses/i2c-qup.c b/drivers/i2c/busses/i2c-qup.c
new file mode 100644
index 0000000..d769b25
--- /dev/null
+++ b/drivers/i2c/busses/i2c-qup.c
@@ -0,0 +1,1194 @@
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/pm_runtime.h>
+#include <linux/mutex.h>
+#include <mach/msm_qup_i2c.h>
+
+/* QUP Registers */
+enum qup_registers {
+	QUP_CONFIG              = 0x0,
+	QUP_STATE               = 0x4,
+	QUP_IO_MODE             = 0x8,
+	QUP_SW_RESET            = 0xC,
+	QUP_OPERATIONAL         = 0x18,
+	QUP_ERROR_FLAGS         = 0x1C,
+	QUP_ERROR_FLAGS_EN      = 0x20,
+	QUP_MX_READ_CNT         = 0x208,
+	QUP_MX_INPUT_CNT        = 0x200,
+	QUP_MX_WR_CNT           = 0x100,
+	QUP_OUT_DEBUG           = 0x108,
+	QUP_OUT_FIFO_CNT        = 0x10C,
+	QUP_OUT_FIFO_BASE       = 0x110,
+	QUP_IN_READ_CUR         = 0x20C,
+	QUP_IN_DEBUG            = 0x210,
+	QUP_IN_FIFO_CNT         = 0x214,
+	QUP_IN_FIFO_BASE        = 0x218,
+	QUP_I2C_CLK_CTL         = 0x400,
+	QUP_I2C_STATUS          = 0x404,
+};
+
+/* QUP States and reset values */
+enum qup_state {
+	QUP_RESET_STATE         = 0,
+	QUP_RUN_STATE           = 1U,
+	QUP_STATE_MASK          = 3U,
+	QUP_PAUSE_STATE         = 3U,
+	QUP_STATE_VALID         = 1U << 2,
+	QUP_I2C_MAST_GEN        = 1U << 4,
+	QUP_OPERATIONAL_RESET   = 0xFF0,
+	QUP_I2C_STATUS_RESET    = 0xFFFFFC,
+};
+
+/* QUP OPERATIONAL FLAGS */
+enum qup_operational {
+	QUP_OUT_SVC_FLAG        = 1U << 8,
+	QUP_IN_SVC_FLAG         = 1U << 9,
+	QUP_MX_INPUT_DONE       = 1U << 11,
+};
+
+/* I2C mini core related values */
+enum qup_config {
+	I2C_MINI_CORE           = 2U << 8,
+	I2C_N_VAL               = 0xF,
+};
+
+/* Packing Unpacking words in FIFOs, and IO modes */
+#define QUP_OUTPUT_FIFO_SIZE_SHIFT	2
+#define QUP_INPUT_BLK_SIZE_SHIFT	5
+#define QUP_INPUT_FIFO_SIZE_SHIFT	7
+
+enum qup_io_modes {
+	QUP_OUTPUT_BLK_SIZE = 3U,
+	QUP_OUTPUT_FIFO_SIZE = 7U << QUP_OUTPUT_FIFO_SIZE_SHIFT,
+	QUP_INPUT_BLK_SIZE = 3U << QUP_INPUT_BLK_SIZE_SHIFT,
+	QUP_INPUT_FIFO_SIZE = 7U << QUP_INPUT_FIFO_SIZE_SHIFT,
+	QUP_WR_BLK_MODE  = 1U << 10,
+	QUP_RD_BLK_MODE  = 1U << 12,
+	QUP_UNPACK_EN = 1U << 14,
+	QUP_PACK_EN = 1U << 15,
+};
+
+/* QUP tags */
+enum qup_tags {
+	QUP_OUT_NOP   = 0,
+	QUP_OUT_START = 1U << 8,
+	QUP_OUT_DATA  = 2U << 8,
+	QUP_OUT_STOP  = 3U << 8,
+	QUP_OUT_REC   = 4U << 8,
+	QUP_IN_DATA   = 5U << 8,
+	QUP_IN_STOP   = 6U << 8,
+	QUP_IN_NACK   = 7U << 8,
+};
+
+/* Status, Error flags */
+enum qup_status {
+	I2C_STATUS_WR_BUFFER_FULL  = 1U << 0,
+	I2C_STATUS_BUS_ACTIVE      = 1U << 8,
+	I2C_STATUS_ERROR_MASK      = 0x38000FC,
+	QUP_I2C_NACK_FLAG          = 1U << 3,
+	QUP_IN_NOT_EMPTY           = 1U << 5,
+	QUP_STATUS_ERROR_FLAGS     = 0x7C,
+};
+
+/* GSBI Control Register */
+enum gsbi_ctrl_reg {
+	GSBI_I2C_PROTOCOL_CODE	= 0x2 << 4,	/* I2C protocol */
+};
+
+/* I2C Master clock control */
+#define QUP_CLK_CTL_FS_DIVIDER_MASK	0xff
+#define QUP_CLK_CTL_HS_DIVIDER_SHIFT	0x08
+#define QUP_CLK_CTL_HS_DIVIDER_MASK	0x07
+#define QUP_CLK_CTL_HS_DIVIDER_MIN	0x03
+
+#define QUP_MAX_RETRIES	2000
+#define QUP_SRC_CLK_RATE	19200000	/* Default source clock rate */
+#define QUP_AUTOSUSPEND_DELAY	(3*MSEC_PER_SEC)
+
+/**
+ * struct qup_i2c_dev
+ * @dev: parent platform device.
+ * @base: location of QUP controller I/O area in memory.
+ * @gsbi: location of QUP GSBI block I/O area in memory.
+ * @in_irq: assigned interrupt line for input interrupts.
+ * @out_irq: assigned interrupt line for output interrupts.
+ * @err_irq: assigned interrupt line for error interrupts.
+ * @num_irqs: the number of supported interrupt lines (usually 1 or 3).
+ * @clk: the I2C master clock (the I2C bus clock is derived from this clock).
+ * @pclk: hardware core clock.  Needs to be enabled to access the QUP registers.
+ * @adapter: corresponding I2C adapter.
+ * @msg: the current i2c_msg segment being processed.
+ * @pos: the current position (index) into the message buffer.
+ * @cnt: the number of bytes remaining to be transferred in the current segment.
+ * @err: error status reported from the interrupt handler.
+ * @clk_ctl: clock control (clock divider values).  A non-zero value indicates
+ *	that the clocks have been initialized.
+ * @one_bit_t: calculated time (in usecs) to transfer one bit of data on
+ *	the I2C bus (used, as necesary, for delay loops).
+ * @out_fifo_sz: the QUP output FIFO size (in bytes).
+ * @in_fifo_sz: the QUP input FIFO size (in bytes).
+ * @out_blk_sz: the QUP output block size (in bytes).
+ * @in_blk_sz: the QUP input block size (in bytes).
+ * @wr_sz: max bytes to write (either output FIFO size or output block size).
+ * @pdata: platform data.
+ * @suspended: the suspend state.
+ * @mlock: mutex used to protect this struct.
+ * @complete: completion function to signal the end of an i2c_msg transfer.
+ *
+ * Early QUP controller used three separate interrupt lines for input, output,
+ * and error interrupts.  Later versions share a single interrupt line.
+ * The num_irq field indicates whether or not there is a shared interrupt line.
+ */
+
+struct qup_i2c_dev {
+	struct device                *dev;
+	void __iomem                 *base;		/* virtual */
+	void __iomem                 *gsbi;		/* virtual */
+	int                          in_irq;
+	int                          out_irq;
+	int                          err_irq;
+	int                          num_irqs;
+	struct clk                   *clk;
+	struct clk                   *pclk;
+	struct i2c_adapter           adapter;
+	struct i2c_msg               *msg;
+	int                          pos;
+	int                          cnt;
+	int                          err;
+	int                          clk_ctl;
+	int                          one_bit_t;
+	int                          out_fifo_sz;
+	int                          in_fifo_sz;
+	int                          out_blk_sz;
+	int                          in_blk_sz;
+	int                          wr_sz;
+	struct msm_qup_i2c_platform_data *pdata;
+	int                          suspended;
+	struct mutex                 mlock;
+	void                         *complete;
+};
+
+#ifdef DEBUG
+static void
+qup_print_status(struct qup_i2c_dev *dev)
+{
+	uint32_t val;
+	val = readl(dev->base + QUP_CONFIG);
+	dev_dbg(dev->dev, "Qup config is :0x%x\n", val);
+	val = readl(dev->base + QUP_STATE);
+	dev_dbg(dev->dev, "Qup state is :0x%x\n", val);
+	val = readl(dev->base + QUP_IO_MODE);
+	dev_dbg(dev->dev, "Qup mode is :0x%x\n", val);
+}
+#else
+static inline void qup_print_status(struct qup_i2c_dev *dev)
+{
+}
+#endif
+
+static inline void qup_i2c_clk_enable(struct qup_i2c_dev *dev)
+{
+	dev_dbg(dev->dev, "%s\n", __func__);
+
+	clk_enable(dev->clk);
+	clk_enable(dev->pclk);
+}
+
+static inline void qup_i2c_clk_disable(struct qup_i2c_dev *dev)
+{
+	dev_dbg(dev->dev, "%s\n", __func__);
+
+	clk_disable(dev->clk);
+	clk_disable(dev->pclk);
+}
+
+static inline void qup_i2c_pwr_enable(struct qup_i2c_dev *dev)
+{
+	dev_dbg(dev->dev, "%s\n", __func__);
+
+	if (pm_runtime_enabled(dev->dev))
+		pm_runtime_get_sync(dev->dev);
+	else
+		qup_i2c_clk_enable(dev);
+}
+
+static inline void qup_i2c_pwr_disable(struct qup_i2c_dev *dev)
+{
+	dev_dbg(dev->dev, "%s\n", __func__);
+
+	if (pm_runtime_enabled(dev->dev)) {
+		pm_runtime_mark_last_busy(dev->dev);
+		pm_runtime_put_sync(dev->dev);
+	} else
+		qup_i2c_clk_disable(dev);
+}
+
+static irqreturn_t
+qup_i2c_interrupt(int irq, void *devid)
+{
+	struct qup_i2c_dev *dev = devid;
+	uint32_t status = readl(dev->base + QUP_I2C_STATUS);
+	uint32_t errors = readl(dev->base + QUP_ERROR_FLAGS);
+	uint32_t op_flgs = readl(dev->base + QUP_OPERATIONAL);
+	int err = 0;
+
+	if (!dev->msg || !dev->complete) {
+		/* Clear Error interrupt if it's a level triggered interrupt */
+		if (dev->num_irqs == 1)
+			writel(QUP_RESET_STATE, dev->base + QUP_STATE);
+		return IRQ_HANDLED;
+	}
+
+	if (status & I2C_STATUS_ERROR_MASK) {
+		dev_dbg(dev->dev, "QUP: I2C status flags :0x%x, irq:%d\n",
+			status, irq);
+		err = status;
+		/* Clear Error interrupt if it's a level triggered interrupt */
+		if (dev->num_irqs == 1)
+			writel(QUP_RESET_STATE, dev->base + QUP_STATE);
+		goto intr_done;
+	}
+
+	if (errors & QUP_STATUS_ERROR_FLAGS) {
+		dev_dbg(dev->dev, "QUP: QUP status flags :0x%x\n", errors);
+		err = -errors;
+		/* Clear Error interrupt if it's a level triggered interrupt */
+		if (dev->num_irqs == 1)
+			writel(errors & QUP_STATUS_ERROR_FLAGS,
+				dev->base + QUP_ERROR_FLAGS);
+		goto intr_done;
+	}
+
+	if ((dev->num_irqs == 3) && (dev->msg->flags == I2C_M_RD)
+		&& (irq == dev->out_irq))
+		return IRQ_HANDLED;
+	if (op_flgs & QUP_OUT_SVC_FLAG)
+		writel(QUP_OUT_SVC_FLAG, dev->base + QUP_OPERATIONAL);
+	if (dev->msg->flags == I2C_M_RD) {
+		if ((op_flgs & QUP_MX_INPUT_DONE) ||
+			(op_flgs & QUP_IN_SVC_FLAG))
+			writel(QUP_IN_SVC_FLAG, dev->base + QUP_OPERATIONAL);
+		else
+			return IRQ_HANDLED;
+	}
+
+intr_done:
+	dev_dbg(dev->dev, "QUP intr= %d, i2c status=0x%x, qup status = 0x%x\n",
+			irq, status, errors);
+	qup_print_status(dev);
+	dev->err = err;
+	complete(dev->complete);
+	return IRQ_HANDLED;
+}
+
+static int
+qup_i2c_poll_writeready(struct qup_i2c_dev *dev, int rem)
+{
+	uint32_t retries = 0;
+
+	while (retries != QUP_MAX_RETRIES) {
+		uint32_t status = readl(dev->base + QUP_I2C_STATUS);
+
+		if (!(status & I2C_STATUS_WR_BUFFER_FULL)) {
+			if (((dev->msg->flags & I2C_M_RD) || (rem == 0)) &&
+				!(status & I2C_STATUS_BUS_ACTIVE))
+				return 0;
+			else if ((dev->msg->flags == 0) && (rem > 0))
+				return 0;
+			else /* 1-bit delay before we check for bus busy */
+				udelay(dev->one_bit_t);
+		}
+		if (retries++ == 1000)
+			udelay(100);
+	}
+	qup_print_status(dev);
+	return -ETIMEDOUT;
+}
+
+static int
+qup_i2c_poll_state(struct qup_i2c_dev *dev, uint32_t state)
+{
+	uint32_t retries = 0;
+
+	dev_dbg(dev->dev, "Polling Status for state:0x%x\n", state);
+
+	while (retries != QUP_MAX_RETRIES) {
+		uint32_t status = readl(dev->base + QUP_STATE);
+
+		if ((status & (QUP_STATE_VALID | state)) ==
+				(QUP_STATE_VALID | state))
+			return 0;
+		else if (retries++ == 1000)
+			udelay(100);
+	}
+	return -ETIMEDOUT;
+}
+
+#ifdef DEBUG
+static void qup_print_fifo_entry(struct qup_i2c_dev *dev, uint32_t val,
+				uint32_t offset, int rdwr)
+{
+	if (rdwr)
+		dev_dbg(dev->dev, "RD:Wrote 0x%x to out_ff:0x%p\n",
+			val, dev->base + QUP_OUT_FIFO_BASE + offset);
+	else
+		dev_dbg(dev->dev, "WR:Wrote 0x%x to out_ff:0x%p\n",
+			val, dev->base + QUP_OUT_FIFO_BASE + offset);
+}
+#else
+static inline void qup_print_fifo_entry(struct qup_i2c_dev *dev, uint32_t val,
+				uint32_t offset, int rdwr)
+{
+}
+#endif
+
+static void
+qup_issue_read(struct qup_i2c_dev *dev, struct i2c_msg *msg, int *idx,
+		uint32_t carry_over)
+{
+	uint16_t addr = (msg->addr << 1) | 1;
+	/*
+	 * QUP limit 256 bytes per read. By HW design, 0 in the 8-bit field
+	 * is treated as 256 byte read.
+	 */
+	uint16_t rd_len = ((dev->cnt == 256) ? 0 : dev->cnt);
+
+	if (*idx % 4) {
+		writel(carry_over | ((QUP_OUT_START | addr) << 16),
+		dev->base + QUP_OUT_FIFO_BASE);
+
+		qup_print_fifo_entry(dev, carry_over |
+			((QUP_OUT_START | addr) << 16), *idx - 2, 1);
+		writel((QUP_OUT_REC | rd_len),
+			dev->base + QUP_OUT_FIFO_BASE);
+
+		qup_print_fifo_entry(dev, (QUP_OUT_REC | rd_len), *idx + 2, 1);
+	} else {
+		writel(((QUP_OUT_REC | rd_len) << 16) | QUP_OUT_START | addr,
+			dev->base + QUP_OUT_FIFO_BASE);
+
+		qup_print_fifo_entry(dev, QUP_OUT_REC << 16 | rd_len << 16 |
+			QUP_OUT_START | addr, *idx, 1);
+	}
+	*idx += 4;
+}
+
+static void
+qup_issue_write(struct qup_i2c_dev *dev, struct i2c_msg *msg, int rem,
+			int *idx, uint32_t *carry_over)
+{
+	int entries = dev->cnt;
+	int empty_sl = dev->wr_sz - ((*idx) >> 1);
+	int i = 0;
+	uint32_t val = 0;
+	uint32_t last_entry = 0;
+	uint16_t addr = msg->addr << 1;
+
+	if (dev->pos == 0) {
+		if (*idx % 4) {
+			writel(*carry_over | ((QUP_OUT_START | addr) << 16),
+					dev->base + QUP_OUT_FIFO_BASE);
+
+			qup_print_fifo_entry(dev,
+				*carry_over | QUP_OUT_START << 16 |
+				addr << 16, *idx - 2, 0);
+		} else
+			val = QUP_OUT_START | addr;
+		*idx += 2;
+		i++;
+		entries++;
+	} else {
+		/*
+		 * Avoid setup time issue by adding 1 NOP when number of bytes
+		 * are more than FIFO/BLOCK size. setup time issue can't appear
+		 * otherwise since next byte to be written will always be ready
+		 */
+		val = (QUP_OUT_NOP | 1);
+		*idx += 2;
+		i++;
+		entries++;
+	}
+	if (entries > empty_sl)
+		entries = empty_sl;
+
+	for (; i < (entries - 1); i++) {
+		if (*idx % 4) {
+			writel(val | ((QUP_OUT_DATA |
+				msg->buf[dev->pos]) << 16),
+				dev->base + QUP_OUT_FIFO_BASE);
+
+			qup_print_fifo_entry(dev, val | QUP_OUT_DATA << 16 |
+				msg->buf[dev->pos] << 16, *idx - 2, 0);
+		} else
+			val = QUP_OUT_DATA | msg->buf[dev->pos];
+		(*idx) += 2;
+		dev->pos++;
+	}
+	if (dev->pos < (msg->len - 1))
+		last_entry = QUP_OUT_DATA;
+	else if (rem > 1) /* not last array entry */
+		last_entry = QUP_OUT_DATA;
+	else
+		last_entry = QUP_OUT_STOP;
+	if ((*idx % 4) == 0) {
+		/*
+		 * If read-start and read-command end up in different fifos, it
+		 * may result in extra-byte being read due to extra-read cycle.
+		 * Avoid that by inserting NOP as the last entry of fifo only
+		 * if write command(s) leave 1 space in fifo.
+		 */
+		if (rem > 1) {
+			struct i2c_msg *next = msg + 1;
+			if (next->addr == msg->addr && (next->flags | I2C_M_RD)
+				&& *idx == ((dev->wr_sz*2) - 4)) {
+				writel(((last_entry | msg->buf[dev->pos]) |
+					((1 | QUP_OUT_NOP) << 16)), dev->base +
+					QUP_OUT_FIFO_BASE);
+				*idx += 2;
+			} else if (next->flags == 0 && dev->pos == msg->len - 1
+					&& *idx < (dev->wr_sz*2)) {
+				/* Last byte of an intermittent write */
+				writel((last_entry | msg->buf[dev->pos]),
+					dev->base + QUP_OUT_FIFO_BASE);
+
+				qup_print_fifo_entry(dev,
+					last_entry | msg->buf[dev->pos],
+					*idx, 0);
+				*idx += 2;
+			} else
+				*carry_over = (last_entry | msg->buf[dev->pos]);
+		} else {
+			writel((last_entry | msg->buf[dev->pos]),
+				dev->base + QUP_OUT_FIFO_BASE);
+
+			qup_print_fifo_entry(dev,
+				last_entry | msg->buf[dev->pos], *idx, 0);
+		}
+	} else {
+		writel(val | ((last_entry | msg->buf[dev->pos]) << 16),
+			dev->base + QUP_OUT_FIFO_BASE);
+
+		qup_print_fifo_entry(dev, val | (last_entry << 16) |
+			(msg->buf[dev->pos] << 16), *idx - 2, 0);
+	}
+
+	*idx += 2;
+	dev->pos++;
+	dev->cnt = msg->len - dev->pos;
+}
+
+static int
+qup_update_state(struct qup_i2c_dev *dev, uint32_t state)
+{
+	if (qup_i2c_poll_state(dev, 0) != 0)
+		return -EIO;
+	writel(state, dev->base + QUP_STATE);
+	if (qup_i2c_poll_state(dev, state) != 0)
+		return -EIO;
+	return 0;
+}
+
+static void
+qup_set_read_mode(struct qup_i2c_dev *dev, int rd_len)
+{
+	uint32_t wr_mode = (dev->wr_sz < dev->out_fifo_sz) ?
+				QUP_WR_BLK_MODE : 0;
+	if (rd_len > 256) {
+		dev_dbg(dev->dev, "HW limit: Breaking reads in chunk of 256\n");
+		rd_len = 256;
+	}
+	if (rd_len <= dev->in_fifo_sz) {
+		writel(wr_mode | QUP_PACK_EN | QUP_UNPACK_EN,
+			dev->base + QUP_IO_MODE);
+		writel(rd_len, dev->base + QUP_MX_READ_CNT);
+	} else {
+		writel(wr_mode | QUP_RD_BLK_MODE |
+			QUP_PACK_EN | QUP_UNPACK_EN, dev->base + QUP_IO_MODE);
+		writel(rd_len, dev->base + QUP_MX_INPUT_CNT);
+	}
+}
+
+static int
+qup_set_wr_mode(struct qup_i2c_dev *dev, int rem)
+{
+	int total_len = 0;
+	int ret = 0;
+	if (dev->msg->len >= (dev->out_fifo_sz - 1)) {
+		total_len = dev->msg->len + 1 +
+				(dev->msg->len/(dev->out_blk_sz-1));
+		writel(QUP_WR_BLK_MODE | QUP_PACK_EN | QUP_UNPACK_EN,
+			dev->base + QUP_IO_MODE);
+		dev->wr_sz = dev->out_blk_sz;
+	} else
+		writel(QUP_PACK_EN | QUP_UNPACK_EN,
+			dev->base + QUP_IO_MODE);
+
+	if (rem > 1) {
+		struct i2c_msg *next = dev->msg + 1;
+		if (next->addr == dev->msg->addr &&
+			next->flags == I2C_M_RD) {
+			qup_set_read_mode(dev, next->len);
+			/* make sure read start & read command are in 1 blk */
+			if ((total_len % dev->out_blk_sz) ==
+				(dev->out_blk_sz - 1))
+				total_len += 3;
+			else
+				total_len += 2;
+		}
+	}
+	/* WRITE COUNT register valid/used only in block mode */
+	if (dev->wr_sz == dev->out_blk_sz)
+		writel(total_len, dev->base + QUP_MX_WR_CNT);
+	return ret;
+}
+
+static int
+qup_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
+{
+	DECLARE_COMPLETION_ONSTACK(complete);
+	struct qup_i2c_dev *dev = i2c_get_adapdata(adap);
+	int ret;
+	int rem = num;
+	long timeout;
+	int err;
+
+	mutex_lock(&dev->mlock);
+
+	if (dev->suspended) {
+		mutex_unlock(&dev->mlock);
+		return -EBUSY;
+	}
+
+	if (dev->clk_ctl == 0) {
+		if (dev->pdata->src_clk_rate > 0)
+			clk_set_rate(dev->clk, dev->pdata->src_clk_rate);
+		else
+			dev->pdata->src_clk_rate = QUP_SRC_CLK_RATE;
+	}
+
+	qup_i2c_pwr_enable(dev);
+
+	/* Initialize QUP registers during first transfer */
+	if (dev->clk_ctl == 0) {
+		int fs_div;
+		int hs_div;
+		uint32_t fifo_reg;
+
+		/* Configure GSBI block to use I2C functionality */
+		writel(GSBI_I2C_PROTOCOL_CODE, dev->gsbi);
+
+		/* FS clk = I2C clk / (2*(FS_DIVIDER+3)) */
+		fs_div = ((dev->pdata->src_clk_rate
+				/ dev->pdata->bus_freq) / 2) - 3;
+		hs_div = QUP_CLK_CTL_HS_DIVIDER_MIN;
+
+		dev->clk_ctl = (fs_div & QUP_CLK_CTL_FS_DIVIDER_MASK) |
+				((hs_div & QUP_CLK_CTL_HS_DIVIDER_MASK) <<
+				QUP_CLK_CTL_HS_DIVIDER_SHIFT);
+
+		fifo_reg = readl(dev->base + QUP_IO_MODE);
+		if (fifo_reg & QUP_OUTPUT_BLK_SIZE)
+			dev->out_blk_sz = (fifo_reg & QUP_OUTPUT_BLK_SIZE) * 16;
+		else
+			dev->out_blk_sz = 16;
+		if (fifo_reg & QUP_INPUT_BLK_SIZE)
+			dev->in_blk_sz = ((fifo_reg & QUP_INPUT_BLK_SIZE) >>
+						QUP_INPUT_BLK_SIZE_SHIFT) * 16;
+		else
+			dev->in_blk_sz = 16;
+		/*
+		 * The block/fifo size w.r.t. 'actual data' is 1/2 due to 'tag'
+		 * associated with each byte written/received
+		 */
+		dev->out_blk_sz /= 2;
+		dev->in_blk_sz /= 2;
+		dev->out_fifo_sz = dev->out_blk_sz *
+				(2 << ((fifo_reg & QUP_OUTPUT_FIFO_SIZE) >>
+				       QUP_OUTPUT_FIFO_SIZE_SHIFT));
+		dev->in_fifo_sz = dev->in_blk_sz *
+				(2 << ((fifo_reg & QUP_INPUT_FIFO_SIZE) >>
+				       QUP_INPUT_FIFO_SIZE_SHIFT));
+		dev_dbg(dev->dev, "QUP IN:bl:%d, ff:%d, OUT:bl:%d, ff:%d\n",
+				dev->in_blk_sz, dev->in_fifo_sz,
+				dev->out_blk_sz, dev->out_fifo_sz);
+	}
+
+	if (dev->num_irqs == 3) {
+		enable_irq(dev->in_irq);
+		enable_irq(dev->out_irq);
+	}
+	enable_irq(dev->err_irq);
+	writel(1, dev->base + QUP_SW_RESET);
+	ret = qup_i2c_poll_state(dev, QUP_RESET_STATE);
+	if (ret) {
+		dev_err(dev->dev, "QUP Busy:Trying to recover\n");
+		goto out_err;
+	}
+
+	/* Initialize QUP registers */
+	writel(0, dev->base + QUP_CONFIG);
+	writel(QUP_OPERATIONAL_RESET, dev->base + QUP_OPERATIONAL);
+	writel(QUP_STATUS_ERROR_FLAGS, dev->base + QUP_ERROR_FLAGS_EN);
+
+	writel(I2C_MINI_CORE | I2C_N_VAL, dev->base + QUP_CONFIG);
+
+	/* Initialize I2C mini core registers */
+	writel(0, dev->base + QUP_I2C_CLK_CTL);
+	writel(QUP_I2C_STATUS_RESET, dev->base + QUP_I2C_STATUS);
+
+	while (rem) {
+		bool filled = false;
+
+		dev->cnt = msgs->len - dev->pos;
+		dev->msg = msgs;
+
+		dev->wr_sz = dev->out_fifo_sz;
+		dev->err = 0;
+		dev->complete = &complete;
+
+		if (qup_i2c_poll_state(dev, QUP_I2C_MAST_GEN) != 0) {
+			ret = -EIO;
+			goto out_err;
+		}
+
+		qup_print_status(dev);
+		/* HW limits Read upto 256 bytes in 1 read without stop */
+		if (dev->msg->flags & I2C_M_RD) {
+			qup_set_read_mode(dev, dev->cnt);
+			if (dev->cnt > 256)
+				dev->cnt = 256;
+		} else {
+			ret = qup_set_wr_mode(dev, rem);
+			if (ret != 0)
+				goto out_err;
+			/* Don't fill block till we get interrupt */
+			if (dev->wr_sz == dev->out_blk_sz)
+				filled = true;
+		}
+
+		err = qup_update_state(dev, QUP_RUN_STATE);
+		if (err < 0) {
+			ret = err;
+			goto out_err;
+		}
+
+		qup_print_status(dev);
+		writel(dev->clk_ctl, dev->base + QUP_I2C_CLK_CTL);
+
+		do {
+			int idx = 0;
+			uint32_t carry_over = 0;
+
+			/* Transition to PAUSE state only possible from RUN */
+			err = qup_update_state(dev, QUP_PAUSE_STATE);
+			if (err < 0) {
+				ret = err;
+				goto out_err;
+			}
+
+			qup_print_status(dev);
+			/*
+			 * This operation is Write, check the next operation
+			 * and decide mode
+			 */
+			while (filled == false) {
+				if ((msgs->flags & I2C_M_RD))
+					qup_issue_read(dev, msgs, &idx,
+							carry_over);
+				else if (!(msgs->flags & I2C_M_RD))
+					qup_issue_write(dev, msgs, rem, &idx,
+							&carry_over);
+				if (idx >= (dev->wr_sz << 1))
+					filled = true;
+				/* Start new message */
+				if (filled == false) {
+					if (msgs->flags & I2C_M_RD)
+							filled = true;
+					else if (rem > 1) {
+						/*
+						 * Only combine operations with
+						 * same address
+						 */
+						struct i2c_msg *next = msgs + 1;
+						if (next->addr != msgs->addr ||
+							next->flags == 0)
+							filled = true;
+						else {
+							rem--;
+							msgs++;
+							dev->msg = msgs;
+							dev->pos = 0;
+							dev->cnt = msgs->len;
+							if (msgs->len > 256)
+								dev->cnt = 256;
+						}
+					} else
+						filled = true;
+				}
+			}
+			err = qup_update_state(dev, QUP_RUN_STATE);
+			if (err < 0) {
+				ret = err;
+				goto out_err;
+			}
+			dev_dbg(dev->dev, "idx:%d, rem:%d, num:%d\n",
+				idx, rem, num);
+
+			qup_print_status(dev);
+			timeout = wait_for_completion_timeout(&complete, HZ);
+			if (!timeout) {
+				uint32_t istatus = readl(dev->base +
+							QUP_I2C_STATUS);
+				uint32_t qstatus = readl(dev->base +
+							QUP_ERROR_FLAGS);
+				uint32_t op_flgs = readl(dev->base +
+							QUP_OPERATIONAL);
+
+				dev_err(dev->dev, "Transaction timed out\n");
+				dev_err(dev->dev, "I2C Status: %x\n", istatus);
+				dev_err(dev->dev, "QUP Status: %x\n", qstatus);
+				dev_err(dev->dev, "OP Flags: %x\n", op_flgs);
+				writel(1, dev->base + QUP_SW_RESET);
+				ret = -ETIMEDOUT;
+				goto out_err;
+			}
+			if (dev->err) {
+				if (dev->err > 0 &&
+					dev->err & QUP_I2C_NACK_FLAG)
+					dev_err(dev->dev,
+					"I2C slave addr:0x%x not connected\n",
+					dev->msg->addr);
+				else if (dev->err < 0) {
+					dev_err(dev->dev,
+					"QUP data xfer error %d\n", dev->err);
+					ret = dev->err;
+					goto out_err;
+				}
+				ret = -dev->err;
+				goto out_err;
+			}
+			if (dev->msg->flags & I2C_M_RD) {
+				int i;
+				uint32_t dval = 0;
+				for (i = 0; dev->pos < dev->msg->len; i++,
+						dev->pos++) {
+					uint32_t rd_status = readl(dev->base +
+							QUP_OPERATIONAL);
+					if (i % 2 == 0) {
+						if ((rd_status &
+							QUP_IN_NOT_EMPTY) == 0)
+							break;
+						dval = readl(dev->base +
+							QUP_IN_FIFO_BASE);
+						dev->msg->buf[dev->pos] =
+							dval & 0xFF;
+					} else
+						dev->msg->buf[dev->pos] =
+							((dval & 0xFF0000) >>
+							 16);
+				}
+				dev->cnt -= i;
+			} else
+				filled = false; /* refill output FIFO */
+			dev_dbg(dev->dev, "pos:%d, len:%d, cnt:%d\n",
+					dev->pos, msgs->len, dev->cnt);
+		} while (dev->cnt > 0);
+		if (dev->cnt == 0) {
+			if (msgs->len == dev->pos) {
+				rem--;
+				msgs++;
+				dev->pos = 0;
+			}
+			if (rem) {
+				err = qup_update_state(dev, QUP_RESET_STATE);
+				if (err < 0) {
+					ret = err;
+					goto out_err;
+				}
+			}
+		}
+		/* Wait for I2C bus to be idle */
+		ret = qup_i2c_poll_writeready(dev, rem);
+		if (ret) {
+			dev_err(dev->dev,
+				"Error waiting for write ready\n");
+			goto out_err;
+		}
+	}
+
+	ret = num;
+out_err:
+	dev->complete = NULL;
+	dev->msg = NULL;
+	dev->pos = 0;
+	dev->err = 0;
+	dev->cnt = 0;
+	disable_irq(dev->err_irq);
+	if (dev->num_irqs == 3) {
+		disable_irq(dev->in_irq);
+		disable_irq(dev->out_irq);
+	}
+	qup_i2c_pwr_disable(dev);
+	mutex_unlock(&dev->mlock);
+	return ret;
+}
+
+static u32
+qup_i2c_func(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_I2C | (I2C_FUNC_SMBUS_EMUL & ~I2C_FUNC_SMBUS_QUICK);
+}
+
+static const struct i2c_algorithm qup_i2c_algo = {
+	.master_xfer	= qup_i2c_xfer,
+	.functionality	= qup_i2c_func,
+};
+
+static int __devinit
+qup_i2c_probe(struct platform_device *pdev)
+{
+	struct qup_i2c_dev	*dev;
+	struct resource         *qup_mem, *gsbi_mem, *qup_io, *gsbi_io;
+	struct resource		*in_irq, *out_irq, *err_irq;
+	struct clk		*clk, *pclk;
+	int ret = 0;
+	struct msm_qup_i2c_platform_data *pdata;
+
+	dev_dbg(&pdev->dev, "qup_i2c_probe\n");
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata) {
+		dev_err(&pdev->dev, "platform data not initialized\n");
+		return -ENOSYS;
+	}
+
+	/* We support frequencies upto FAST Mode(400KHz) */
+	if (pdata->bus_freq <= 0 || pdata->bus_freq > 400000) {
+		dev_err(&pdev->dev, "clock frequency not supported: %d Hz\n",
+				pdata->bus_freq);
+		return -EINVAL;
+	}
+
+	qup_mem = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+						"qup_phys_addr");
+	if (!qup_mem) {
+		dev_err(&pdev->dev, "no qup mem resource?\n");
+		return -ENXIO;
+	}
+
+	gsbi_mem = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+						"gsbi_qup_i2c_addr");
+	if (!gsbi_mem) {
+		dev_err(&pdev->dev, "no gsbi mem resource?\n");
+		return -ENXIO;
+	}
+
+	/*
+	 * We only have 1 interrupt for new hardware targets and in_irq,
+	 * out_irq will be NULL for those platforms
+	 */
+	in_irq = platform_get_resource_byname(pdev, IORESOURCE_IRQ,
+						"qup_in_intr");
+
+	out_irq = platform_get_resource_byname(pdev, IORESOURCE_IRQ,
+						"qup_out_intr");
+
+	err_irq = platform_get_resource_byname(pdev, IORESOURCE_IRQ,
+						"qup_err_intr");
+	if (!err_irq) {
+		dev_err(&pdev->dev, "no error irq resource?\n");
+		return -ENXIO;
+	}
+
+	qup_io = devm_request_mem_region(&pdev->dev, qup_mem->start,
+			resource_size(qup_mem), pdev->name);
+	if (!qup_io) {
+		dev_err(&pdev->dev, "QUP region already claimed\n");
+		return -EBUSY;
+	}
+
+	gsbi_io = devm_request_mem_region(&pdev->dev, gsbi_mem->start,
+			resource_size(gsbi_mem), pdev->name);
+	if (!gsbi_io) {
+		dev_err(&pdev->dev, "GSBI region already claimed\n");
+		return -EBUSY;
+	}
+
+	dev = devm_kzalloc(&pdev->dev, sizeof(struct qup_i2c_dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	dev->dev = &pdev->dev;
+	dev->base = devm_ioremap(&pdev->dev,
+			qup_mem->start, resource_size(qup_mem));
+	if (!dev->base)
+		return -ENOMEM;
+
+	dev->gsbi = devm_ioremap(&pdev->dev,
+			gsbi_mem->start, resource_size(gsbi_mem));
+	if (!dev->gsbi)
+		return -ENOMEM;
+
+	clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(clk)) {
+		dev_err(&pdev->dev, "Could not get clock\n");
+		ret = PTR_ERR(clk);
+		goto err_clk_get_failed;
+	}
+
+	pclk = clk_get(&pdev->dev, "pclk");
+	if (IS_ERR(pclk)) {
+		dev_err(&pdev->dev, "Could not get pclock\n");
+		ret = PTR_ERR(pclk);
+		goto err_pclk_get_failed;
+	}
+
+	if (in_irq)
+		dev->in_irq = in_irq->start;
+	if (out_irq)
+		dev->out_irq = out_irq->start;
+	dev->err_irq = err_irq->start;
+	if (in_irq && out_irq)
+		dev->num_irqs = 3;
+	else
+		dev->num_irqs = 1;
+	dev->clk = clk;
+	dev->pclk = pclk;
+
+	platform_set_drvdata(pdev, dev);
+
+	dev->one_bit_t = DIV_ROUND_UP(USEC_PER_SEC, pdata->bus_freq);
+	dev->pdata = pdata;
+	dev->clk_ctl = 0;
+	dev->pos = 0;
+
+	/*
+	 * We use num_irqs to also indicate if we got 3 interrupts or just 1.
+	 * If we have just 1, we use err_irq as the general purpose irq
+	 * and handle the changes in ISR accordingly
+	 * Per Hardware guidelines, if we have 3 interrupts, they are always
+	 * edge triggering, and if we have 1, it's always level-triggering
+	 */
+	if (dev->num_irqs == 3) {
+		ret = request_irq(dev->in_irq, qup_i2c_interrupt,
+				IRQF_TRIGGER_RISING, "qup_in_intr", dev);
+		if (ret) {
+			dev_err(&pdev->dev, "request_in_irq failed\n");
+			goto err_request_irq_failed;
+		}
+		/*
+		 * We assume out_irq exists if in_irq does since platform
+		 * configuration either has 3 interrupts assigned to QUP or 1
+		 */
+		ret = request_irq(dev->out_irq, qup_i2c_interrupt,
+				IRQF_TRIGGER_RISING, "qup_out_intr", dev);
+		if (ret) {
+			dev_err(&pdev->dev, "request_out_irq failed\n");
+			free_irq(dev->in_irq, dev);
+			goto err_request_irq_failed;
+		}
+		ret = request_irq(dev->err_irq, qup_i2c_interrupt,
+				IRQF_TRIGGER_RISING, "qup_err_intr", dev);
+		if (ret) {
+			dev_err(&pdev->dev, "request_err_irq failed\n");
+			free_irq(dev->out_irq, dev);
+			free_irq(dev->in_irq, dev);
+			goto err_request_irq_failed;
+		}
+	} else {
+		ret = request_irq(dev->err_irq, qup_i2c_interrupt,
+				IRQF_TRIGGER_HIGH, "qup_err_intr", dev);
+		if (ret) {
+			dev_err(&pdev->dev, "request_err_irq failed\n");
+			goto err_request_irq_failed;
+		}
+	}
+	disable_irq(dev->err_irq);
+	if (dev->num_irqs == 3) {
+		disable_irq(dev->in_irq);
+		disable_irq(dev->out_irq);
+	}
+	i2c_set_adapdata(&dev->adapter, dev);
+	dev->adapter.algo = &qup_i2c_algo;
+	strlcpy(dev->adapter.name,
+		"QUP I2C adapter",
+		sizeof(dev->adapter.name));
+	dev->adapter.nr = pdev->id;
+	dev->adapter.dev.parent = &pdev->dev;
+
+	dev->suspended = 0;
+	mutex_init(&dev->mlock);
+
+	pm_runtime_use_autosuspend(&pdev->dev);
+	pm_runtime_set_autosuspend_delay(&pdev->dev, QUP_AUTOSUSPEND_DELAY);
+	pm_runtime_enable(&pdev->dev);
+
+	ret = i2c_add_numbered_adapter(&dev->adapter);
+	if (ret) {
+		dev_err(&pdev->dev, "i2c_add_adapter failed\n");
+		if (dev->num_irqs == 3) {
+			free_irq(dev->out_irq, dev);
+			free_irq(dev->in_irq, dev);
+		}
+		free_irq(dev->err_irq, dev);
+	} else
+		return 0;
+
+	pm_runtime_disable(&pdev->dev);
+
+err_request_irq_failed:
+	clk_put(pclk);
+err_pclk_get_failed:
+	clk_put(clk);
+err_clk_get_failed:
+	return ret;
+}
+
+static int __devexit
+qup_i2c_remove(struct platform_device *pdev)
+{
+	struct qup_i2c_dev	*dev = platform_get_drvdata(pdev);
+
+	/* Grab mutex to ensure ongoing transaction is over */
+	mutex_lock(&dev->mlock);
+	dev->suspended = 1;
+	mutex_unlock(&dev->mlock);
+	mutex_destroy(&dev->mlock);
+	qup_i2c_clk_disable(dev);
+	platform_set_drvdata(pdev, NULL);
+	if (dev->num_irqs == 3) {
+		free_irq(dev->out_irq, dev);
+		free_irq(dev->in_irq, dev);
+	}
+	free_irq(dev->err_irq, dev);
+	i2c_del_adapter(&dev->adapter);
+	pm_runtime_disable(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
+	clk_put(dev->clk);
+	clk_put(dev->pclk);
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int qup_i2c_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct qup_i2c_dev *qup = platform_get_drvdata(pdev);
+	dev_dbg(dev, "%s\n", __func__);
+
+	/* Grab mutex to ensure ongoing transaction is over */
+	mutex_lock(&qup->mlock);
+	qup->suspended = 1;
+	mutex_unlock(&qup->mlock);
+
+	if (pm_runtime_enabled(dev) && !pm_runtime_suspended(dev))
+		qup_i2c_clk_disable(qup);
+
+	return 0;
+}
+
+static int qup_i2c_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct qup_i2c_dev *qup = platform_get_drvdata(pdev);
+	dev_dbg(dev, "%s\n", __func__);
+
+	if (pm_runtime_enabled(dev) && !pm_runtime_suspended(dev))
+		qup_i2c_clk_enable(qup);
+
+	qup->suspended = 0;
+	return 0;
+}
+#endif /* CONFIG_PM_SLEEP */
+
+#ifdef CONFIG_PM_RUNTIME
+static int i2c_qup_runtime_idle(struct device *dev)
+{
+	dev_dbg(dev, "pm_runtime: idle...\n");
+
+	pm_request_autosuspend(dev);
+	return -EAGAIN;
+}
+
+static int i2c_qup_runtime_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct qup_i2c_dev *qup = platform_get_drvdata(pdev);
+
+	dev_dbg(dev, "pm_runtime: suspending...\n");
+
+	qup_i2c_clk_disable(qup);
+	return 0;
+}
+
+static int i2c_qup_runtime_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct qup_i2c_dev *qup = platform_get_drvdata(pdev);
+
+	dev_dbg(dev, "pm_runtime: resuming...\n");
+
+	qup_i2c_clk_enable(qup);
+	return 0;
+}
+#endif
+
+static const struct dev_pm_ops i2c_qup_dev_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(
+		qup_i2c_suspend,
+		qup_i2c_resume
+	)
+	SET_RUNTIME_PM_OPS(
+		i2c_qup_runtime_suspend,
+		i2c_qup_runtime_resume,
+		i2c_qup_runtime_idle
+	)
+};
+
+static struct platform_driver qup_i2c_driver = {
+	.probe		= qup_i2c_probe,
+	.remove		= __devexit_p(qup_i2c_remove),
+	.driver		= {
+		.name	= "qup_i2c",
+		.owner	= THIS_MODULE,
+		.pm = &i2c_qup_dev_pm_ops,
+	},
+};
+
+/* QUP may be needed to bring up other drivers */
+static int __init
+qup_i2c_init_driver(void)
+{
+	return platform_driver_register(&qup_i2c_driver);
+}
+arch_initcall(qup_i2c_init_driver);
+
+static void __exit qup_i2c_exit_driver(void)
+{
+	platform_driver_unregister(&qup_i2c_driver);
+}
+module_exit(qup_i2c_exit_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_VERSION("1.0");
+MODULE_ALIAS("platform:i2c_qup");
+MODULE_AUTHOR("Sagar Dharia <sdharia@codeaurora.org>");
-- 
1.7.3.3
--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
