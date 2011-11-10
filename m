Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab1KJBHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 20:07:33 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35769 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab1KJBHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 20:07:31 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6525"; a="136270101"
From: Harini Jayaraman <harinij@codeaurora.org>
To: grant.likely@secretlab.ca
Cc: davidb@codeaurora.org, bryanh@codeaurora.org, kheitke@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Harini Jayaraman <harinij@codeaurora.org>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] spi: QUP based bus driver for Qualcomm MSM chipsets
Date: Wed,  9 Nov 2011 18:07:00 -0700
Message-Id: <1320887221-7165-1-git-send-email-harinij@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bus driver supports the QUP SPI hardware controller in the Qualcomm
MSM SOCs. The Qualcomm Universal Peripheral Engine (QUP) is a general
purpose data path engine with input/output FIFOs and an embedded SPI
mini-core. The driver currently supports only FIFO mode.

Signed-off-by: Harini Jayaraman <harinij@codeaurora.org>
---
 drivers/spi/Kconfig                   |   10 +
 drivers/spi/Makefile                  |    1 +
 drivers/spi/msm_spi_qsd.h             |  436 +++++++++++++
 drivers/spi/spi-qsd.c                 | 1144 +++++++++++++++++++++++++++++++++
 include/linux/platform_data/msm_spi.h |   19 +
 5 files changed, 1610 insertions(+), 0 deletions(-)
 create mode 100644 drivers/spi/msm_spi_qsd.h
 create mode 100644 drivers/spi/spi-qsd.c
 create mode 100644 include/linux/platform_data/msm_spi.h

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 52e2900..af55a0a 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -280,6 +280,16 @@ config SPI_PXA2XX
 config SPI_PXA2XX_PCI
 	def_bool SPI_PXA2XX && X86_32 && PCI
 
+config SPI_QUP
+	tristate "Qualcomm MSM SPI QUPe Support"
+	depends on ARCH_MSM
+	help
+	  Support for Serial Peripheral Interface for Qualcomm Universal
+	  Peripheral.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called spi-qsd.
+
 config SPI_S3C24XX
 	tristate "Samsung S3C24XX series SPI"
 	depends on ARCH_S3C2410 && EXPERIMENTAL
diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
index 61c3261..f426c89 100644
--- a/drivers/spi/Makefile
+++ b/drivers/spi/Makefile
@@ -44,6 +44,7 @@ obj-$(CONFIG_SPI_PL022)			+= spi-pl022.o
 obj-$(CONFIG_SPI_PPC4xx)		+= spi-ppc4xx.o
 obj-$(CONFIG_SPI_PXA2XX)		+= spi-pxa2xx.o
 obj-$(CONFIG_SPI_PXA2XX_PCI)		+= spi-pxa2xx-pci.o
+obj-$(CONFIG_SPI_QUP)			+= spi-qsd.o
 obj-$(CONFIG_SPI_S3C24XX)		+= spi-s3c24xx-hw.o
 spi-s3c24xx-hw-y			:= spi-s3c24xx.o
 spi-s3c24xx-hw-$(CONFIG_SPI_S3C24XX_FIQ) += spi-s3c24xx-fiq.o
diff --git a/drivers/spi/msm_spi_qsd.h b/drivers/spi/msm_spi_qsd.h
new file mode 100644
index 0000000..d141d08
--- /dev/null
+++ b/drivers/spi/msm_spi_qsd.h
@@ -0,0 +1,436 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
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
+#ifndef _MSM_SPI_QSD_H
+#define _MSM_SPI_QSD_H
+
+#define SPI_DRV_NAME                  "spi_qsd"
+
+#define QUP_CONFIG                    0x0000 /* N & NO_INPUT/NO_OUPUT bits */
+#define QUP_ERROR_FLAGS               0x0308
+#define QUP_ERROR_FLAGS_EN            0x030C
+#define QUP_ERR_MASK                  0x3
+#define SPI_OUTPUT_FIFO_WORD_CNT      0x010C
+#define SPI_INPUT_FIFO_WORD_CNT       0x0214
+#define QUP_MX_WRITE_COUNT            0x0150
+#define QUP_MX_WRITE_CNT_CURRENT      0x0154
+
+#define QUP_CONFIG_SPI_MODE           0x0100
+
+#define GSBI_CTRL_REG                 0x0
+#define GSBI_SPI_CONFIG               0x30
+
+#define SPI_CONFIG                    0x0300
+#define SPI_IO_CONTROL                0x0304
+#define SPI_IO_MODES                  0x0008
+#define SPI_SW_RESET                  0x000C
+#define SPI_TIME_OUT                  0x0010
+#define SPI_TIME_OUT_CURRENT          0x0014
+#define SPI_MX_OUTPUT_COUNT           0x0100
+#define SPI_MX_OUTPUT_CNT_CURRENT     0x0104
+#define SPI_MX_INPUT_COUNT            0x0200
+#define SPI_MX_INPUT_CNT_CURRENT      0x0204
+#define SPI_MX_READ_COUNT             0x0208
+#define SPI_MX_READ_CNT_CURRENT       0x020C
+#define SPI_OPERATIONAL               0x0018
+#define SPI_ERROR_FLAGS               0x001C
+#define SPI_ERROR_FLAGS_EN            0x0020
+#define SPI_DEASSERT_WAIT             0x0310
+#define SPI_OUTPUT_DEBUG              0x0108
+#define SPI_INPUT_DEBUG               0x0210
+#define SPI_TEST_CTRL                 0x0024
+#define SPI_OUTPUT_FIFO               0x0110
+#define SPI_INPUT_FIFO                0x0218
+#define SPI_STATE                     0x0004
+
+/* SPI_CONFIG fields */
+#define SPI_CFG_INPUT_FIRST           0x00000200
+#define SPI_NO_INPUT                  0x00000080
+#define SPI_NO_OUTPUT                 0x00000040
+#define SPI_CFG_LOOPBACK              0x00000100
+#define SPI_CFG_N                     0x0000001F
+
+/* SPI_IO_CONTROL fields */
+#define SPI_IO_C_CLK_IDLE_HIGH        0x00000400
+#define SPI_IO_C_MX_CS_MODE           0x00000100
+#define SPI_IO_C_CS_N_POLARITY        0x000000F0
+#define SPI_IO_C_CS_N_POLARITY_0      0x00000010
+#define SPI_IO_C_CS_SELECT            0x0000000C
+#define SPI_IO_C_TRISTATE_CS          0x00000002
+#define SPI_IO_C_NO_TRI_STATE         0x00000001
+
+/* SPI_IO_MODES fields */
+#define SPI_IO_M_PACK_EN              0x00008000
+#define SPI_IO_M_UNPACK_EN            0x00004000
+#define SPI_IO_M_INPUT_MODE           0x00003000
+#define SPI_IO_M_OUTPUT_MODE          0x00000C00
+#define SPI_IO_M_INPUT_FIFO_SIZE      0x00000380
+#define SPI_IO_M_INPUT_BLOCK_SIZE     0x00000060
+#define SPI_IO_M_OUTPUT_FIFO_SIZE     0x0000001C
+#define SPI_IO_M_OUTPUT_BLOCK_SIZE    0x00000003
+
+#define INPUT_BLOCK_SZ_SHIFT          5
+#define INPUT_FIFO_SZ_SHIFT           7
+#define OUTPUT_BLOCK_SZ_SHIFT         0
+#define OUTPUT_FIFO_SZ_SHIFT          2
+#define OUTPUT_MODE_SHIFT             10
+#define INPUT_MODE_SHIFT              12
+
+/* SPI_OPERATIONAL fields */
+#define SPI_OP_MAX_INPUT_DONE_FLAG    0x00000800
+#define SPI_OP_MAX_OUTPUT_DONE_FLAG   0x00000400
+#define SPI_OP_INPUT_SERVICE_FLAG     0x00000200
+#define SPI_OP_OUTPUT_SERVICE_FLAG    0x00000100
+#define SPI_OP_INPUT_FIFO_FULL        0x00000080
+#define SPI_OP_OUTPUT_FIFO_FULL       0x00000040
+#define SPI_OP_IP_FIFO_NOT_EMPTY      0x00000020
+#define SPI_OP_OP_FIFO_NOT_EMPTY      0x00000010
+#define SPI_OP_STATE_VALID            0x00000004
+#define SPI_OP_STATE                  0x00000003
+#define SPI_OP_STATE_CLEAR_BITS       0x2
+
+/* SPI_ERROR_FLAGS fields */
+#define SPI_ERR_OUTPUT_OVER_RUN_ERR   0x00000020
+#define SPI_ERR_INPUT_UNDER_RUN_ERR   0x00000010
+#define SPI_ERR_OUTPUT_UNDER_RUN_ERR  0x00000008
+#define SPI_ERR_INPUT_OVER_RUN_ERR    0x00000004
+#define SPI_ERR_CLK_OVER_RUN_ERR      0x00000002
+#define SPI_ERR_CLK_UNDER_RUN_ERR     0x00000001
+
+#define SPI_NUM_CHIPSELECTS           4
+#define SPI_SUPPORTED_MODES  (SPI_CPOL | SPI_CPHA | SPI_CS_HIGH | SPI_LOOP)
+
+#define SPI_DELAY_THRESHOLD           1
+/* Default timeout is 10 milliseconds */
+#define SPI_DEFAULT_TIMEOUT           10
+
+enum msm_spi_state {
+	SPI_OP_STATE_RESET = 0x00000000,
+	SPI_OP_STATE_RUN   = 0x00000001,
+	SPI_OP_STATE_PAUSE = 0x00000003,
+};
+
+enum msm_spi_mode {
+	SPI_FIFO_MODE  = 0x0,  /* 00 */
+	SPI_BLOCK_MODE = 0x1,  /* 01 */
+	SPI_DMOV_MODE  = 0x2,  /* 10 */
+	SPI_MODE_NONE  = 0xFF, /* invalid value */
+};
+
+#ifdef CONFIG_DEBUG_FS
+static const struct {
+	const char *name;
+	mode_t mode;
+	int offset;
+} debugfs_spi_regs[] = {
+	{"config",                S_IRUGO | S_IWUSR, SPI_CONFIG},
+	{"io_control",            S_IRUGO | S_IWUSR, SPI_IO_CONTROL},
+	{"io_modes",              S_IRUGO | S_IWUSR, SPI_IO_MODES},
+	{"sw_reset",                        S_IWUSR, SPI_SW_RESET},
+	{"time_out",              S_IRUGO | S_IWUSR, SPI_TIME_OUT},
+	{"time_out_current",      S_IRUGO,           SPI_TIME_OUT_CURRENT},
+	{"mx_output_count",       S_IRUGO | S_IWUSR, SPI_MX_OUTPUT_COUNT},
+	{"mx_output_cnt_current", S_IRUGO,           SPI_MX_OUTPUT_CNT_CURRENT},
+	{"mx_input_count",        S_IRUGO | S_IWUSR, SPI_MX_INPUT_COUNT},
+	{"mx_input_cnt_current",  S_IRUGO,           SPI_MX_INPUT_CNT_CURRENT},
+	{"mx_read_count",         S_IRUGO | S_IWUSR, SPI_MX_READ_COUNT},
+	{"mx_read_cnt_current",   S_IRUGO,           SPI_MX_READ_CNT_CURRENT},
+	{"operational",           S_IRUGO | S_IWUSR, SPI_OPERATIONAL},
+	{"error_flags",           S_IRUGO | S_IWUSR, SPI_ERROR_FLAGS},
+	{"error_flags_en",        S_IRUGO | S_IWUSR, SPI_ERROR_FLAGS_EN},
+	{"deassert_wait",         S_IRUGO | S_IWUSR, SPI_DEASSERT_WAIT},
+	{"output_debug",          S_IRUGO,           SPI_OUTPUT_DEBUG},
+	{"input_debug",           S_IRUGO,           SPI_INPUT_DEBUG},
+	{"test_ctrl",             S_IRUGO | S_IWUSR, SPI_TEST_CTRL},
+	{"output_fifo",                     S_IWUSR, SPI_OUTPUT_FIFO},
+	{"input_fifo" ,           S_IRUSR,           SPI_INPUT_FIFO},
+	{"spi_state",             S_IRUGO | S_IWUSR, SPI_STATE},
+	{"qup_config",            S_IRUGO | S_IWUSR, QUP_CONFIG},
+	{"qup_error_flags",       S_IRUGO | S_IWUSR, QUP_ERROR_FLAGS},
+	{"qup_error_flags_en",    S_IRUGO | S_IWUSR, QUP_ERROR_FLAGS_EN},
+	{"mx_write_cnt",          S_IRUGO | S_IWUSR, QUP_MX_WRITE_COUNT},
+	{"mx_write_cnt_current",  S_IRUGO,           QUP_MX_WRITE_CNT_CURRENT},
+	{"output_fifo_word_cnt",  S_IRUGO,           SPI_OUTPUT_FIFO_WORD_CNT},
+	{"input_fifo_word_cnt",   S_IRUGO,           SPI_INPUT_FIFO_WORD_CNT},
+};
+#endif
+
+/**
+ * struct msm_spi
+ * @read_buf: rx_buf from the spi_transfer.
+ * @write_buf: tx_buf from the spi_transfer.
+ * @base: location of QUP controller I/O area in memory.
+ * @dev: parent platform device.
+ * @queue_lock: lock to protect queue.
+ * @core_lock: mutex used to protect this struct.
+ * @queue: to log SPI transfer requests.
+ * @workqueue: workqueue for the SPI transfer requests.
+ * @work_data: work.
+ * @cur_msg: the current spi_message being processed.
+ * @cur_transfer: the current spi_transfer being processed.
+ * @transfer_complete: completion function to signal the end of a spi_transfer.
+ * @clk: the SPI core clock
+ * @pclk: hardware core clock. Needs to be enabled to access the QUP register
+ * @mem_phys_addr: physical address of the QUP controller.
+ * @mem_size: size of the QUP controller block.
+ * @input_fifo_size: the input FIFO size (in bytes).
+ * @output_fifo_size: the output FIFO size (in bytes).
+ * @rx_bytes_remaining: the number of rx bytes remaining to be transferred.
+ * @tx_bytes_remaining: the number of tx bytes remaining to be transferred.
+ * @clock_speed: SPI clock speed.
+ * @irq_in: assigned interrupt line for QUP interrupts.
+ * @read_xfr_cnt: number of words read from the FIFO (per transfer).
+ * @write_xfr_cnt: number of words written to the FIFO (per transfer).
+ * @write_len: the total number of tx bytes to be transferred, per
+ *	spi_message. This is valid only for WR-WR and WR-RD transfers
+ *	in a single spi_message.
+ * @read_len: the total number of rx bytes to be transferred, per
+ *	spi_message. This is valid only for WR-WR and WR-RD transfers
+ *	in a single spi_message.
+ * @bytes_per_word: bytes per word
+ * @suspended: the suspend state.
+ * @transfer_pending: when set indicates a pending transfer.
+ * @continue_suspend: head of wait queue.
+ * @mode: mode for SPI operation.
+ * @input_block_size: the input block size (in bytes).
+ * @output_block_size: the output block size (in bytes).
+ * @stat_rx: count of input interrupts handled.
+ * @stat_tx: count of output interrupts handled.
+ * @dent_spi: used for debug purposes.
+ * @debugfs_spi_regs: used for debug purposes.
+ * @pdata: platform data
+ * @multi_xfr: when set indicates multiple spi_transfers in a single
+ *	spi_message.
+ * @done: flag used to signal completion.
+ * @cur_msg_len: combined length of all the transfers in a single
+ *	spi_message (in bytes).
+ * @cur_tx_transfer: the current tx transfer being processed. Used in
+ *	FIFO mode only.
+ * @cur_rx_transfer: the current rx transfer being processed. Used in
+ *	FIFO mode only.
+ *
+ * Early QUP controller used three separate interrupt lines for input, output,
+ * and error interrupts.  Later versions share a single interrupt line.
+ */
+struct msm_spi {
+	u8                      *read_buf;
+	const u8                *write_buf;
+	void __iomem            *base;
+	struct device           *dev;
+	spinlock_t               queue_lock;
+	struct mutex             core_lock;
+	struct list_head         queue;
+	struct workqueue_struct *workqueue;
+	struct work_struct       work_data;
+	struct spi_message      *cur_msg;
+	struct spi_transfer     *cur_transfer;
+	struct completion        transfer_complete;
+	struct clk              *clk;
+	struct clk              *pclk;
+	unsigned long            mem_phys_addr;
+	size_t                   mem_size;
+	int                      input_fifo_size;
+	int                      output_fifo_size;
+	u32                      rx_bytes_remaining;
+	u32                      tx_bytes_remaining;
+	u32                      clock_speed;
+	int                      irq_in;
+	int                      read_xfr_cnt;
+	int                      write_xfr_cnt;
+	int                      write_len;
+	int                      read_len;
+	int                      bytes_per_word;
+	bool                     suspended;
+	bool                     transfer_pending;
+	wait_queue_head_t        continue_suspend;
+	enum msm_spi_mode        mode;
+	int                      input_block_size;
+	int                      output_block_size;
+	int                      stat_rx;
+	int                      stat_tx;
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *dent_spi;
+	struct dentry *debugfs_spi_regs[ARRAY_SIZE(debugfs_spi_regs)];
+#endif
+	struct msm_spi_platform_data *pdata;
+	bool                     multi_xfr;
+	bool                     done;
+	u32                      cur_msg_len;
+	struct spi_transfer     *cur_tx_transfer;
+	struct spi_transfer     *cur_rx_transfer;
+};
+
+/* Forward declaration */
+static irqreturn_t msm_spi_input_irq(int irq, void *dev_id);
+static irqreturn_t msm_spi_output_irq(int irq, void *dev_id);
+static irqreturn_t msm_spi_error_irq(int irq, void *dev_id);
+static inline int msm_spi_set_state(struct msm_spi *dd,
+				enum msm_spi_state state);
+static void msm_spi_write_word_to_fifo(struct msm_spi *dd);
+static inline void msm_spi_write_rmn_to_fifo(struct msm_spi *dd);
+
+/* In QUP the same interrupt line is used for input, output and error */
+static inline int msm_spi_get_irq_data(struct msm_spi *dd,
+					struct platform_device *pdev)
+{
+	dd->irq_in  = platform_get_irq_byname(pdev, "spi_irq_in");
+	if (dd->irq_in < 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+static inline int msm_spi_configure_gsbi(struct msm_spi *dd,
+					struct platform_device *pdev)
+{
+	struct resource *resource;
+	unsigned long   gsbi_mem_phys_addr;
+	size_t          gsbi_mem_size;
+	void __iomem    *gsbi_base;
+
+	resource  = platform_get_resource_byname(pdev,
+						 IORESOURCE_MEM, "gsbi_base");
+	if (!resource)
+		return -ENXIO;
+
+	gsbi_mem_phys_addr = resource->start;
+	gsbi_mem_size = resource_size(resource);
+	if (!devm_request_mem_region(&pdev->dev, gsbi_mem_phys_addr,
+					gsbi_mem_size, SPI_DRV_NAME))
+		return -ENXIO;
+
+	gsbi_base = devm_ioremap(&pdev->dev, gsbi_mem_phys_addr,
+					gsbi_mem_size);
+	if (!gsbi_base)
+		return -ENXIO;
+
+	/* Set GSBI to SPI mode */
+	writel(GSBI_SPI_CONFIG, gsbi_base + GSBI_CTRL_REG);
+
+	return 0;
+}
+
+/* Figure which irq occured and call the relevant functions */
+static irqreturn_t msm_spi_qup_irq(int irq, void *dev_id)
+{
+	u32 op, ret = IRQ_NONE;
+	struct msm_spi *dd = dev_id;
+
+	if (readl(dd->base + SPI_ERROR_FLAGS) ||
+		readl(dd->base + QUP_ERROR_FLAGS)) {
+		struct spi_master *master = dev_get_drvdata(dd->dev);
+		ret |= msm_spi_error_irq(irq, master);
+	}
+
+	op = readl(dd->base + SPI_OPERATIONAL);
+	if (op & SPI_OP_INPUT_SERVICE_FLAG) {
+		writel(SPI_OP_INPUT_SERVICE_FLAG, dd->base + SPI_OPERATIONAL);
+		ret |= msm_spi_input_irq(irq, dev_id);
+	}
+
+	if (op & SPI_OP_OUTPUT_SERVICE_FLAG) {
+		writel(SPI_OP_OUTPUT_SERVICE_FLAG, dd->base + SPI_OPERATIONAL);
+		ret |= msm_spi_output_irq(irq, dev_id);
+	}
+
+	if (dd->done) {
+		complete(&dd->transfer_complete);
+		dd->done = 0;
+	}
+	return ret;
+}
+
+static inline int msm_spi_request_irq(struct msm_spi *dd,
+					const char *name,
+					struct spi_master *master)
+{
+	return request_irq(dd->irq_in, msm_spi_qup_irq, IRQF_TRIGGER_HIGH,
+			   name, dd);
+}
+
+static inline void msm_spi_free_irq(struct msm_spi *dd,
+					struct spi_master *master)
+{
+	free_irq(dd->irq_in, dd);
+}
+
+static inline void msm_spi_disable_irqs(struct msm_spi *dd)
+{
+	disable_irq(dd->irq_in);
+}
+
+static inline void msm_spi_enable_irqs(struct msm_spi *dd)
+{
+	enable_irq(dd->irq_in);
+}
+
+static inline void msm_spi_get_clk_err(struct msm_spi *dd, u32 *spi_err)
+{
+	*spi_err = readl(dd->base + QUP_ERROR_FLAGS);
+}
+
+static inline void msm_spi_ack_clk_err(struct msm_spi *dd)
+{
+	writel(QUP_ERR_MASK, dd->base + QUP_ERROR_FLAGS);
+}
+
+static inline void msm_spi_add_configs(struct msm_spi *dd, u32 *config, int n);
+
+/* QUP has no_input, no_output, and N bits at QUP_CONFIG */
+static inline void msm_spi_set_qup_config(struct msm_spi *dd, int bpw)
+{
+	u32 qup_config = readl(dd->base + QUP_CONFIG);
+
+	msm_spi_add_configs(dd, &qup_config, bpw-1);
+	writel(qup_config | QUP_CONFIG_SPI_MODE, dd->base + QUP_CONFIG);
+}
+
+static inline int msm_spi_prepare_for_write(struct msm_spi *dd)
+{
+	if (msm_spi_set_state(dd, SPI_OP_STATE_RUN))
+		return -EINVAL;
+
+	if (msm_spi_set_state(dd, SPI_OP_STATE_PAUSE))
+		return -EINVAL;
+
+	return 0;
+}
+
+static inline void msm_spi_start_write(struct msm_spi *dd, u32 read_count)
+{
+	if (read_count <= dd->input_fifo_size)
+		msm_spi_write_rmn_to_fifo(dd);
+	else
+		msm_spi_write_word_to_fifo(dd);
+}
+
+static inline void msm_spi_set_write_count(struct msm_spi *dd, int val)
+{
+	writel(val, dd->base + QUP_MX_WRITE_COUNT);
+}
+
+static inline void msm_spi_complete(struct msm_spi *dd)
+{
+	dd->done = 1;
+}
+
+static inline void msm_spi_enable_error_flags(struct msm_spi *dd)
+{
+	writel_relaxed(0x00000078, dd->base + SPI_ERROR_FLAGS_EN);
+}
+
+static inline void msm_spi_clear_error_flags(struct msm_spi *dd)
+{
+	writel_relaxed(0x0000007C, dd->base + SPI_ERROR_FLAGS);
+}
+
+#endif
diff --git a/drivers/spi/spi-qsd.c b/drivers/spi/spi-qsd.c
new file mode 100644
index 0000000..d949020
--- /dev/null
+++ b/drivers/spi/spi-qsd.c
@@ -0,0 +1,1144 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
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
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/spinlock.h>
+#include <linux/list.h>
+#include <linux/irq.h>
+#include <linux/platform_device.h>
+#include <linux/spi/spi.h>
+#include <linux/interrupt.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/workqueue.h>
+#include <linux/io.h>
+#include <linux/debugfs.h>
+#include <linux/sched.h>
+#include <linux/mutex.h>
+#include <linux/platform_data/msm_spi.h>
+#include "msm_spi_qsd.h"
+
+static void msm_spi_clock_set(struct msm_spi *dd, int speed)
+{
+	int rc;
+
+	rc = clk_set_rate(dd->clk, speed);
+	if (!rc)
+		dd->clock_speed = speed;
+}
+
+static int msm_spi_calculate_size(int *fifo_size,
+				  int *block_size,
+				  int block,
+				  int mult)
+{
+	int words;
+
+	switch (block) {
+	case 0:
+		words = 1; /* 4 bytes */
+		break;
+	case 1:
+		words = 4; /* 16 bytes */
+		break;
+	case 2:
+		words = 8; /* 32 bytes */
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (mult) {
+	case 0:
+		*fifo_size = words * 2;
+		break;
+	case 1:
+		*fifo_size = words * 4;
+		break;
+	case 2:
+		*fifo_size = words * 8;
+		break;
+	case 3:
+		*fifo_size = words * 16;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	*block_size = words * sizeof(u32); /* in bytes */
+	return 0;
+}
+
+static void __init msm_spi_calculate_fifo_size(struct msm_spi *dd)
+{
+	u32 spi_iom;
+	int block;
+	int mult;
+
+	spi_iom = readl(dd->base + SPI_IO_MODES);
+	block = (spi_iom & SPI_IO_M_INPUT_BLOCK_SIZE) >> INPUT_BLOCK_SZ_SHIFT;
+	mult = (spi_iom & SPI_IO_M_INPUT_FIFO_SIZE) >> INPUT_FIFO_SZ_SHIFT;
+	if (msm_spi_calculate_size(&dd->input_fifo_size, &dd->input_block_size,
+		block, mult)) {
+		goto fifo_size_err;
+	}
+
+	block = (spi_iom & SPI_IO_M_OUTPUT_BLOCK_SIZE) >> OUTPUT_BLOCK_SZ_SHIFT;
+	mult = (spi_iom & SPI_IO_M_OUTPUT_FIFO_SIZE) >> OUTPUT_FIFO_SZ_SHIFT;
+	if (msm_spi_calculate_size(&dd->output_fifo_size,
+		&dd->output_block_size, block, mult)) {
+		goto fifo_size_err;
+	}
+
+	return;
+
+fifo_size_err:
+	pr_err("%s: Invalid FIFO size,SPI_IO_MODES=0x%x\n", __func__, spi_iom);
+	return;
+}
+
+static void msm_spi_read_word_from_fifo(struct msm_spi *dd)
+{
+	u32   data_in;
+	int   i;
+	int   shift;
+
+	data_in = readl(dd->base + SPI_INPUT_FIFO);
+
+	if (dd->read_buf) {
+		for (i = 0; (i < dd->bytes_per_word) &&
+			dd->rx_bytes_remaining; i++) {
+			/*
+			 * The data format depends on bytes_per_word:
+			 * 4 bytes: 0x12345678
+			 * 3 bytes: 0x00123456
+			 * 2 bytes: 0x00001234
+			 * 1 byte : 0x00000012
+			 */
+			shift = 8 * (dd->bytes_per_word - i - 1);
+			*dd->read_buf++ = (data_in & (0xFF << shift)) >> shift;
+			dd->rx_bytes_remaining--;
+		}
+	} else {
+		if (dd->rx_bytes_remaining >= dd->bytes_per_word)
+			dd->rx_bytes_remaining -= dd->bytes_per_word;
+		else
+			dd->rx_bytes_remaining = 0;
+	}
+
+	dd->read_xfr_cnt++;
+	if (dd->multi_xfr) {
+		if (!dd->rx_bytes_remaining)
+			dd->read_xfr_cnt = 0;
+		else if ((dd->read_xfr_cnt * dd->bytes_per_word) ==
+							dd->read_len) {
+			struct spi_transfer *t = dd->cur_rx_transfer;
+			if (t->transfer_list.next != &dd->cur_msg->transfers) {
+				t = list_entry(t->transfer_list.next,
+						struct spi_transfer,
+						transfer_list);
+				dd->read_buf = t->rx_buf;
+				dd->read_len = t->len;
+				dd->read_xfr_cnt = 0;
+				dd->cur_rx_transfer = t;
+			}
+		}
+	}
+}
+
+static inline bool msm_spi_is_valid_state(struct msm_spi *dd)
+{
+	u32 spi_op = readl(dd->base + SPI_STATE);
+
+	return spi_op & SPI_OP_STATE_VALID;
+}
+
+static inline int msm_spi_wait_valid(struct msm_spi *dd)
+{
+	unsigned long delay;
+	unsigned long timeout;
+
+	if (dd->clock_speed == 0)
+		return -EINVAL;
+
+	/*
+	 * Based on the SPI clock speed, sufficient time
+	 * should be given for the SPI state transition to occur
+	 */
+	delay = (10 * USEC_PER_SEC) / dd->clock_speed;
+	/* For small delay values, the default timeout would be one jiffy */
+	if (delay < SPI_DELAY_THRESHOLD)
+		delay = SPI_DELAY_THRESHOLD;
+
+	timeout = jiffies + msecs_to_jiffies(delay * SPI_DEFAULT_TIMEOUT) + 1;
+	while (!msm_spi_is_valid_state(dd)) {
+		if (time_after(jiffies, timeout)) {
+			if (!msm_spi_is_valid_state(dd)) {
+				if (dd->cur_msg)
+					dd->cur_msg->status = -EIO;
+				dev_err(dd->dev, "%s: SPI operational state"
+					"not valid\n", __func__);
+				return -ETIMEDOUT;
+			} else
+				return 0;
+		}
+		/*
+		 * For smaller values of delay, context switch time
+		 * would negate the usage of usleep
+		 */
+		if (delay > 20)
+			usleep_range(delay, delay);
+		else if (delay)
+			udelay(delay);
+	}
+
+	return 0;
+}
+
+static inline int msm_spi_set_state(struct msm_spi *dd,
+				    enum msm_spi_state state)
+{
+	enum msm_spi_state cur_state;
+
+	if (msm_spi_wait_valid(dd))
+		return -EIO;
+
+	cur_state = readl(dd->base + SPI_STATE);
+	/*
+	 * Per spec:
+	 * For PAUSE_STATE to RESET_STATE, two writes of (10) are required
+	 */
+	if (((cur_state & SPI_OP_STATE) == SPI_OP_STATE_PAUSE) &&
+			(state == SPI_OP_STATE_RESET)) {
+		writel(SPI_OP_STATE_CLEAR_BITS, dd->base + SPI_STATE);
+		writel(SPI_OP_STATE_CLEAR_BITS, dd->base + SPI_STATE);
+	} else {
+		writel((cur_state & ~SPI_OP_STATE) | state,
+			dd->base + SPI_STATE);
+	}
+
+	if (msm_spi_wait_valid(dd))
+		return -EIO;
+
+	return 0;
+}
+
+static inline void msm_spi_add_configs(struct msm_spi *dd, u32 *config, int n)
+{
+	*config &= ~(SPI_NO_INPUT|SPI_NO_OUTPUT);
+	if (n != (*config & SPI_CFG_N))
+		*config = (*config & ~SPI_CFG_N) | n;
+}
+
+static void msm_spi_set_config(struct msm_spi *dd, int bpw)
+{
+	u32 spi_config;
+
+	spi_config = readl(dd->base + SPI_CONFIG);
+	if (dd->cur_msg->spi->mode & SPI_CPHA)
+		spi_config &= ~SPI_CFG_INPUT_FIRST;
+	else
+		spi_config |= SPI_CFG_INPUT_FIRST;
+
+	if (dd->cur_msg->spi->mode & SPI_LOOP)
+		spi_config |= SPI_CFG_LOOPBACK;
+	else
+		spi_config &= ~SPI_CFG_LOOPBACK;
+
+	msm_spi_add_configs(dd, &spi_config, bpw-1);
+	writel(spi_config, dd->base + SPI_CONFIG);
+	msm_spi_set_qup_config(dd, bpw);
+}
+
+static irqreturn_t msm_spi_input_irq(int irq, void *dev_id)
+{
+	struct msm_spi *dd = dev_id;
+
+	dd->stat_rx++;
+	if (dd->mode == SPI_FIFO_MODE) {
+		while ((readl(dd->base + SPI_OPERATIONAL) &
+			SPI_OP_IP_FIFO_NOT_EMPTY) &&
+			(dd->rx_bytes_remaining > 0)) {
+			msm_spi_read_word_from_fifo(dd);
+		}
+		if (dd->rx_bytes_remaining == 0)
+			msm_spi_complete(dd);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void msm_spi_write_word_to_fifo(struct msm_spi *dd)
+{
+	u32    word = 0;
+	u8     byte;
+	int    i;
+
+	if (dd->write_buf) {
+		for (i = 0; (i < dd->bytes_per_word) &&
+				dd->tx_bytes_remaining; i++) {
+			dd->tx_bytes_remaining--;
+			byte = *dd->write_buf++;
+			word |= (byte << (BITS_PER_BYTE * (3 - i)));
+		}
+	} else
+		if (dd->tx_bytes_remaining > dd->bytes_per_word)
+			dd->tx_bytes_remaining -= dd->bytes_per_word;
+		else
+			dd->tx_bytes_remaining = 0;
+
+	dd->write_xfr_cnt++;
+	if (dd->multi_xfr) {
+		if (!dd->tx_bytes_remaining)
+			dd->write_xfr_cnt = 0;
+		else if ((dd->write_xfr_cnt * dd->bytes_per_word) ==
+							dd->write_len) {
+			struct spi_transfer *t = dd->cur_tx_transfer;
+			if (t->transfer_list.next != &dd->cur_msg->transfers) {
+				t = list_entry(t->transfer_list.next,
+						struct spi_transfer,
+						transfer_list);
+				dd->write_buf = t->tx_buf;
+				dd->write_len = t->len;
+				dd->write_xfr_cnt = 0;
+				dd->cur_tx_transfer = t;
+			}
+		}
+	}
+
+	writel_relaxed(word, dd->base + SPI_OUTPUT_FIFO);
+}
+
+static inline void msm_spi_write_rmn_to_fifo(struct msm_spi *dd)
+{
+	int count = 0;
+
+	while ((dd->tx_bytes_remaining > 0) && (count < dd->input_fifo_size) &&
+		!(readl(dd->base + SPI_OPERATIONAL) &
+			SPI_OP_OUTPUT_FIFO_FULL)) {
+		msm_spi_write_word_to_fifo(dd);
+		count++;
+	}
+}
+
+static irqreturn_t msm_spi_output_irq(int irq, void *dev_id)
+{
+	struct msm_spi *dd = dev_id;
+
+	dd->stat_tx++;
+	/* Output FIFO is empty. Transmit any outstanding write data. */
+	if (dd->mode == SPI_FIFO_MODE)
+		msm_spi_write_rmn_to_fifo(dd);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t msm_spi_error_irq(int irq, void *dev_id)
+{
+	struct spi_master	*master = dev_id;
+	struct msm_spi          *dd = spi_master_get_devdata(master);
+	u32                      spi_err;
+
+	spi_err = readl(dd->base + SPI_ERROR_FLAGS);
+	if (spi_err & SPI_ERR_OUTPUT_OVER_RUN_ERR)
+		dev_warn(master->dev.parent, "SPI output overrun error\n");
+
+	if  (spi_err & SPI_ERR_INPUT_UNDER_RUN_ERR)
+		dev_warn(master->dev.parent, "SPI input underrun error\n");
+
+	if (spi_err & SPI_ERR_OUTPUT_UNDER_RUN_ERR)
+		dev_warn(master->dev.parent, "SPI output underrun error\n");
+
+	msm_spi_get_clk_err(dd, &spi_err);
+	if (spi_err & SPI_ERR_CLK_OVER_RUN_ERR)
+		dev_warn(master->dev.parent, "SPI clock overrun error\n");
+
+	if (spi_err & SPI_ERR_CLK_UNDER_RUN_ERR)
+		dev_warn(master->dev.parent, "SPI clock underrun error\n");
+
+	msm_spi_clear_error_flags(dd);
+	msm_spi_ack_clk_err(dd);
+
+	return IRQ_HANDLED;
+}
+
+static void msm_spi_process_transfer(struct msm_spi *dd)
+{
+	u8  bpw;
+	u32 spi_ioc;
+	u32 spi_iom;
+	u32 spi_ioc_orig;
+	u32 max_speed;
+	u32 chip_select;
+	u32 read_count;
+	u32 timeout;
+	u32 int_loopback = 0;
+
+	dd->tx_bytes_remaining = dd->cur_msg_len;
+	dd->rx_bytes_remaining = dd->cur_msg_len;
+	dd->read_buf           = dd->cur_transfer->rx_buf;
+	dd->write_buf          = dd->cur_transfer->tx_buf;
+	init_completion(&dd->transfer_complete);
+	if (dd->cur_transfer->bits_per_word)
+		bpw = dd->cur_transfer->bits_per_word;
+	else
+		if (dd->cur_msg->spi->bits_per_word)
+			bpw = dd->cur_msg->spi->bits_per_word;
+		else
+			bpw = 8;
+
+	dd->bytes_per_word = (bpw + 7) / 8;
+	if (dd->cur_transfer->speed_hz)
+		max_speed = dd->cur_transfer->speed_hz;
+	else
+		max_speed = dd->cur_msg->spi->max_speed_hz;
+
+	if (!dd->clock_speed || max_speed != dd->clock_speed)
+		msm_spi_clock_set(dd, max_speed);
+
+	read_count = DIV_ROUND_UP(dd->cur_msg_len, dd->bytes_per_word);
+	if (dd->cur_msg->spi->mode & SPI_LOOP)
+		int_loopback = 1;
+
+	if (int_loopback && dd->multi_xfr &&
+			(read_count > dd->input_fifo_size)) {
+		if (dd->read_len && dd->write_len)
+			pr_err(
+			"%s:Internal Loopback does not support > fifo size"
+			"for write-then-read transactions\n",
+			__func__);
+		else if (dd->write_len && !dd->read_len)
+			pr_err(
+			"%s:Internal Loopback does not support > fifo size"
+			"for write-then-write transactions\n",
+			__func__);
+
+		return;
+	}
+
+	dd->mode = SPI_FIFO_MODE;
+	if (dd->multi_xfr) {
+		dd->read_len = dd->cur_transfer->len;
+		dd->write_len = dd->cur_transfer->len;
+	}
+
+	/*
+	 * read_count cannot exceed fifo_size, and only one READ COUNT
+	 * interrupt is generated per transaction, so for transactions
+	 * larger than fifo size READ COUNT must be disabled.
+	 */
+	if (read_count <= dd->input_fifo_size) {
+		writel(read_count, dd->base + SPI_MX_READ_COUNT);
+		msm_spi_set_write_count(dd, read_count);
+	} else {
+		writel(0, dd->base + SPI_MX_READ_COUNT);
+		msm_spi_set_write_count(dd, 0);
+	}
+
+	spi_iom = readl(dd->base + SPI_IO_MODES);
+	spi_iom &= ~(SPI_IO_M_INPUT_MODE | SPI_IO_M_OUTPUT_MODE);
+	spi_iom = (spi_iom | (dd->mode << OUTPUT_MODE_SHIFT));
+	spi_iom = (spi_iom | (dd->mode << INPUT_MODE_SHIFT));
+	spi_iom &= ~(SPI_IO_M_PACK_EN | SPI_IO_M_UNPACK_EN);
+
+	writel(spi_iom, dd->base + SPI_IO_MODES);
+	msm_spi_set_config(dd, bpw);
+	spi_ioc = readl(dd->base + SPI_IO_CONTROL);
+	spi_ioc_orig = spi_ioc;
+	if (dd->cur_msg->spi->mode & SPI_CPOL)
+		spi_ioc |= SPI_IO_C_CLK_IDLE_HIGH;
+	else
+		spi_ioc &= ~SPI_IO_C_CLK_IDLE_HIGH;
+
+	chip_select = dd->cur_msg->spi->chip_select << 2;
+	if ((spi_ioc & SPI_IO_C_CS_SELECT) != chip_select)
+		spi_ioc = (spi_ioc & ~SPI_IO_C_CS_SELECT) | chip_select;
+
+	if (!dd->cur_transfer->cs_change)
+		spi_ioc |= SPI_IO_C_MX_CS_MODE;
+
+	if (spi_ioc != spi_ioc_orig)
+		writel(spi_ioc, dd->base + SPI_IO_CONTROL);
+
+	/*
+	 * The output fifo interrupt handler will handle all writes
+	 * after the first. Restricting this to one write avoids
+	 * contention issues and race conditions between this thread
+	 *  and the int handler.
+	 */
+	if (msm_spi_prepare_for_write(dd))
+		goto transfer_end;
+	msm_spi_start_write(dd, read_count);
+
+	/*
+	 * Only enter the RUN state after the first word is written into
+	 * the output FIFO. Otherwise, the output FIFO EMPTY interrupt
+	 * might fire before the first word is written resulting in a
+	 * possible race condition.
+	 */
+	if (msm_spi_set_state(dd, SPI_OP_STATE_RUN))
+		goto transfer_end;
+
+	timeout = 100 * msecs_to_jiffies(
+	      DIV_ROUND_UP(dd->cur_msg_len * 8,
+		 DIV_ROUND_UP(max_speed, MSEC_PER_SEC)));
+
+	/* Assume success, this might change later upon transaction result */
+	dd->cur_msg->status = 0;
+	if (!wait_for_completion_timeout(&dd->transfer_complete, timeout)) {
+		dev_err(dd->dev, "%s: SPI transaction timeout\n", __func__);
+		dd->cur_msg->status = -EIO;
+	}
+
+transfer_end:
+	dd->mode = SPI_MODE_NONE;
+	msm_spi_set_state(dd, SPI_OP_STATE_RESET);
+	writel(spi_ioc & ~SPI_IO_C_MX_CS_MODE, dd->base + SPI_IO_CONTROL);
+}
+
+static void get_transfer_length(struct msm_spi *dd)
+{
+	struct spi_transfer *tr;
+	int num_xfrs = 0;
+	int readlen = 0;
+	int writelen = 0;
+
+	dd->cur_msg_len = 0;
+	dd->multi_xfr = 0;
+	dd->read_len = dd->write_len = 0;
+
+	list_for_each_entry(tr, &dd->cur_msg->transfers, transfer_list) {
+		if (tr->tx_buf)
+			writelen += tr->len;
+		if (tr->rx_buf)
+			readlen += tr->len;
+		dd->cur_msg_len += tr->len;
+		num_xfrs++;
+	}
+
+	if (num_xfrs == 2) {
+		struct spi_transfer *first_xfr = dd->cur_transfer;
+
+		dd->multi_xfr = 1;
+		tr = list_entry(first_xfr->transfer_list.next,
+				struct spi_transfer,
+				transfer_list);
+		/*
+		 * We update dd->read_len and dd->write_len only
+		 * for WR-WR and WR-RD transfers.
+		 */
+		if ((first_xfr->tx_buf) && (!first_xfr->rx_buf)) {
+			if (((tr->tx_buf) && (!tr->rx_buf)) ||
+				((!tr->tx_buf) && (tr->rx_buf))) {
+				dd->read_len = readlen;
+				dd->write_len = writelen;
+			}
+		}
+	} else if (num_xfrs > 1)
+		dd->multi_xfr = 1;
+}
+
+static inline int combine_transfers(struct msm_spi *dd)
+{
+	struct spi_transfer *t = dd->cur_transfer;
+	struct spi_transfer *nxt;
+	int xfrs_grped = 1;
+
+	dd->cur_msg_len = dd->cur_transfer->len;
+	while (t->transfer_list.next != &dd->cur_msg->transfers) {
+		nxt = list_entry(t->transfer_list.next,
+				struct spi_transfer,
+				transfer_list);
+		if (t->cs_change != nxt->cs_change)
+			return xfrs_grped;
+		dd->cur_msg_len += nxt->len;
+		xfrs_grped++;
+		t = nxt;
+	}
+
+	return xfrs_grped;
+}
+
+static void msm_spi_process_message(struct msm_spi *dd)
+{
+	int xfrs_grped = 0;
+	dd->write_xfr_cnt = dd->read_xfr_cnt = 0;
+
+	dd->cur_transfer = list_first_entry(&dd->cur_msg->transfers,
+						struct spi_transfer,
+						transfer_list);
+	get_transfer_length(dd);
+	if (dd->multi_xfr && !dd->read_len && !dd->write_len) {
+		/* Handling of multi-transfers. FIFO mode is used by default */
+		list_for_each_entry(dd->cur_transfer,
+					&dd->cur_msg->transfers,
+					transfer_list) {
+			if (!dd->cur_transfer->len)
+				return;
+
+			if (xfrs_grped) {
+				xfrs_grped--;
+				continue;
+			} else {
+				dd->read_len = dd->write_len = 0;
+				xfrs_grped = combine_transfers(dd);
+			}
+
+			dd->cur_tx_transfer = dd->cur_transfer;
+			dd->cur_rx_transfer = dd->cur_transfer;
+			msm_spi_process_transfer(dd);
+			xfrs_grped--;
+		}
+	} else {
+		dd->cur_tx_transfer = dd->cur_rx_transfer = dd->cur_transfer;
+		msm_spi_process_transfer(dd);
+	}
+}
+
+/* workqueue - pull messages from queue and process */
+static void msm_spi_workq(struct work_struct *work)
+{
+	struct msm_spi      *dd =
+		container_of(work, struct msm_spi, work_data);
+	unsigned long        flags;
+	u32                  status_error = 0;
+
+	mutex_lock(&dd->core_lock);
+	clk_enable(dd->clk);
+	clk_enable(dd->pclk);
+	msm_spi_enable_irqs(dd);
+	if (!msm_spi_is_valid_state(dd)) {
+		dev_err(dd->dev, "%s: SPI operational state not valid\n",
+			__func__);
+		status_error = 1;
+	}
+
+	spin_lock_irqsave(&dd->queue_lock, flags);
+	while (!list_empty(&dd->queue)) {
+		dd->cur_msg = list_entry(dd->queue.next,
+					struct spi_message, queue);
+		list_del_init(&dd->cur_msg->queue);
+		spin_unlock_irqrestore(&dd->queue_lock, flags);
+		if (status_error)
+			dd->cur_msg->status = -EIO;
+		else
+			msm_spi_process_message(dd);
+
+		if (dd->cur_msg->complete)
+			dd->cur_msg->complete(dd->cur_msg->context);
+
+		spin_lock_irqsave(&dd->queue_lock, flags);
+	}
+
+	dd->transfer_pending = 0;
+	spin_unlock_irqrestore(&dd->queue_lock, flags);
+
+	msm_spi_disable_irqs(dd);
+	clk_disable(dd->clk);
+	clk_disable(dd->pclk);
+	mutex_unlock(&dd->core_lock);
+
+	/*
+	 * If needed, this can be done after the current message is complete,
+	 * and work can be continued upon resume. No motivation for now.
+	 */
+	if (dd->suspended)
+		wake_up_interruptible(&dd->continue_suspend);
+}
+
+static int msm_spi_transfer(struct spi_device *spi, struct spi_message *msg)
+{
+	struct msm_spi	*dd;
+	unsigned long    flags;
+	struct spi_transfer *tr;
+
+	dd = spi_master_get_devdata(spi->master);
+	if (dd->suspended)
+		return -EBUSY;
+
+	if (list_empty(&msg->transfers) || !msg->complete)
+		return -EINVAL;
+
+	list_for_each_entry(tr, &msg->transfers, transfer_list) {
+		/* Check message parameters */
+		if (tr->speed_hz > dd->pdata->max_clock_speed ||
+			(tr->bits_per_word &&
+			(tr->bits_per_word < 4 || tr->bits_per_word > 32)) ||
+			(tr->tx_buf == NULL && tr->rx_buf == NULL)) {
+			dev_err(&spi->dev, "Invalid transfer: %d Hz, %d bpw"
+				"tx=%p, rx=%p\n",
+				tr->speed_hz, tr->bits_per_word,
+				tr->tx_buf, tr->rx_buf);
+			return -EINVAL;
+		}
+	}
+
+	spin_lock_irqsave(&dd->queue_lock, flags);
+	if (dd->suspended) {
+		spin_unlock_irqrestore(&dd->queue_lock, flags);
+		return -EBUSY;
+	}
+
+	dd->transfer_pending = 1;
+	list_add_tail(&msg->queue, &dd->queue);
+	spin_unlock_irqrestore(&dd->queue_lock, flags);
+	queue_work(dd->workqueue, &dd->work_data);
+	return 0;
+}
+
+static int msm_spi_setup(struct spi_device *spi)
+{
+	struct msm_spi	*dd;
+	int              rc = 0;
+	u32              spi_ioc;
+	u32              spi_config;
+	u32              mask;
+
+	if (spi->bits_per_word < 4 || spi->bits_per_word > 32) {
+		dev_err(&spi->dev, "%s: invalid bits_per_word %d\n",
+			__func__, spi->bits_per_word);
+		rc = -EINVAL;
+	}
+
+	if (spi->chip_select > SPI_NUM_CHIPSELECTS-1) {
+		dev_err(&spi->dev, "%s, chip select %d exceeds max value %d\n",
+			__func__, spi->chip_select, SPI_NUM_CHIPSELECTS - 1);
+		rc = -EINVAL;
+	}
+
+	if (rc)
+		goto err_setup_exit;
+
+	dd = spi_master_get_devdata(spi->master);
+
+	mutex_lock(&dd->core_lock);
+	if (dd->suspended) {
+		mutex_unlock(&dd->core_lock);
+		return -EBUSY;
+	}
+
+	clk_enable(dd->clk);
+	clk_enable(dd->pclk);
+	spi_ioc = readl(dd->base + SPI_IO_CONTROL);
+	mask = SPI_IO_C_CS_N_POLARITY_0 << spi->chip_select;
+	if (spi->mode & SPI_CS_HIGH)
+		spi_ioc |= mask;
+	else
+		spi_ioc &= ~mask;
+
+	if (spi->mode & SPI_CPOL)
+		spi_ioc |= SPI_IO_C_CLK_IDLE_HIGH;
+	else
+		spi_ioc &= ~SPI_IO_C_CLK_IDLE_HIGH;
+
+	writel(spi_ioc, dd->base + SPI_IO_CONTROL);
+	spi_config = readl(dd->base + SPI_CONFIG);
+	if (spi->mode & SPI_LOOP)
+		spi_config |= SPI_CFG_LOOPBACK;
+	else
+		spi_config &= ~SPI_CFG_LOOPBACK;
+
+	if (spi->mode & SPI_CPHA)
+		spi_config &= ~SPI_CFG_INPUT_FIRST;
+	else
+		spi_config |= SPI_CFG_INPUT_FIRST;
+
+	writel(spi_config, dd->base + SPI_CONFIG);
+	clk_disable(dd->clk);
+	clk_disable(dd->pclk);
+	mutex_unlock(&dd->core_lock);
+
+err_setup_exit:
+	return rc;
+}
+
+#ifdef CONFIG_DEBUG_FS
+static int debugfs_iomem_x32_set(void *data, u64 val)
+{
+	iowrite32(val, data);
+	/* Ensure the previous write completed. */
+	wmb();
+	return 0;
+}
+
+static int debugfs_iomem_x32_get(void *data, u64 *val)
+{
+	*val = ioread32(data);
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(fops_iomem_x32, debugfs_iomem_x32_get,
+			debugfs_iomem_x32_set, "0x%08llx\n");
+
+static void spi_debugfs_init(struct msm_spi *dd)
+{
+	dd->dent_spi = debugfs_create_dir(dev_name(dd->dev), NULL);
+	if (dd->dent_spi) {
+		int i;
+
+		for (i = 0; i < ARRAY_SIZE(debugfs_spi_regs); i++) {
+			dd->debugfs_spi_regs[i] =
+				debugfs_create_file(
+					debugfs_spi_regs[i].name,
+					debugfs_spi_regs[i].mode,
+					dd->dent_spi,
+					dd->base + debugfs_spi_regs[i].offset,
+					&fops_iomem_x32);
+		}
+	}
+}
+
+static void spi_debugfs_exit(struct msm_spi *dd)
+{
+	if (dd->dent_spi) {
+		int i;
+
+		debugfs_remove_recursive(dd->dent_spi);
+		dd->dent_spi = NULL;
+		for (i = 0; i < ARRAY_SIZE(debugfs_spi_regs); i++)
+			dd->debugfs_spi_regs[i] = NULL;
+	}
+}
+#else
+static void spi_debugfs_init(struct msm_spi *dd) {}
+static void spi_debugfs_exit(struct msm_spi *dd) {}
+#endif
+
+/* ===Device attributes begin=== */
+static ssize_t show_stats(struct device *dev, struct device_attribute *attr,
+				char *buf)
+{
+	struct spi_master *master = dev_get_drvdata(dev);
+	struct msm_spi *dd =  spi_master_get_devdata(master);
+
+	return snprintf(buf, PAGE_SIZE,
+			"Device       %s\n"
+			"rx fifo_size = %d spi words\n"
+			"tx fifo_size = %d spi words\n"
+			"rx block size = %d bytes\n"
+			"tx block size = %d bytes\n"
+			"--statistics--\n"
+			"Rx isrs  = %d\n"
+			"Tx isrs  = %d\n"
+			"--debug--\n"
+			"NA yet\n",
+			dev_name(dev),
+			dd->input_fifo_size,
+			dd->output_fifo_size,
+			dd->input_block_size,
+			dd->output_block_size,
+			dd->stat_rx,
+			dd->stat_tx
+			);
+}
+
+/* Reset statistics on write */
+static ssize_t set_stats(struct device *dev, struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct msm_spi *dd = dev_get_drvdata(dev);
+
+	dd->stat_rx = 0;
+	dd->stat_tx = 0;
+	return count;
+}
+
+static DEVICE_ATTR(stats, S_IRUGO | S_IWUSR, show_stats, set_stats);
+
+static struct attribute *dev_attrs[] = {
+	&dev_attr_stats.attr,
+	NULL,
+};
+
+static struct attribute_group dev_attr_grp = {
+	.attrs = dev_attrs,
+};
+/* ===Device attributes end=== */
+
+static int __init msm_spi_probe(struct platform_device *pdev)
+{
+	struct spi_master      *master;
+	struct msm_spi	       *dd;
+	struct resource	       *resource;
+	int                     rc = -ENXIO;
+	int                     locked = 0;
+	int                     clk_enabled = 0;
+	int                     pclk_enabled = 0;
+	struct msm_spi_platform_data *pdata = pdev->dev.platform_data;
+
+	master = spi_alloc_master(&pdev->dev, sizeof(struct msm_spi));
+	if (!master) {
+		rc = -ENOMEM;
+		dev_err(&pdev->dev, "master allocation failed\n");
+		goto err_probe_exit;
+	}
+
+	master->bus_num        = pdev->id;
+	master->mode_bits      = SPI_SUPPORTED_MODES;
+	master->num_chipselect = SPI_NUM_CHIPSELECTS;
+	master->setup          = msm_spi_setup;
+	master->transfer       = msm_spi_transfer;
+	platform_set_drvdata(pdev, master);
+	dd = spi_master_get_devdata(master);
+
+	dd->pdata = pdata;
+	rc = msm_spi_get_irq_data(dd, pdev);
+	if (rc)
+		goto err_probe_res;
+
+	resource = platform_get_resource_byname(pdev,
+						IORESOURCE_MEM, "spi_base");
+	if (!resource) {
+		rc = -ENXIO;
+		goto err_probe_res;
+	}
+
+	dd->mem_phys_addr = resource->start;
+	dd->mem_size = resource_size(resource);
+
+	spin_lock_init(&dd->queue_lock);
+	mutex_init(&dd->core_lock);
+	INIT_LIST_HEAD(&dd->queue);
+	INIT_WORK(&dd->work_data, msm_spi_workq);
+	init_waitqueue_head(&dd->continue_suspend);
+	dd->workqueue = create_singlethread_workqueue(
+						dev_name(master->dev.parent));
+	if (!dd->workqueue)
+		goto err_probe_res;
+
+	if (!devm_request_mem_region(&pdev->dev, dd->mem_phys_addr,
+					dd->mem_size, SPI_DRV_NAME)) {
+		rc = -ENXIO;
+		goto err_probe_reqmem;
+	}
+
+	dd->base = devm_ioremap(&pdev->dev, dd->mem_phys_addr, dd->mem_size);
+	if (!dd->base) {
+		rc = -ENOMEM;
+		goto err_probe_reqmem;
+	}
+
+
+	mutex_lock(&dd->core_lock);
+	locked = 1;
+	dd->dev = &pdev->dev;
+	dd->clk = clk_get(&pdev->dev, "spi_clk");
+	if (IS_ERR(dd->clk)) {
+		dev_err(&pdev->dev, "%s: unable to get spi_clk\n", __func__);
+		rc = PTR_ERR(dd->clk);
+		goto err_probe_clk_get;
+	}
+
+	dd->pclk = clk_get(&pdev->dev, "spi_pclk");
+	if (IS_ERR(dd->pclk)) {
+		dev_err(&pdev->dev, "%s: unable to get spi_pclk\n", __func__);
+		rc = PTR_ERR(dd->pclk);
+		goto err_probe_pclk_get;
+	}
+
+	if (pdata && pdata->max_clock_speed)
+		msm_spi_clock_set(dd, dd->pdata->max_clock_speed);
+
+	rc = clk_enable(dd->clk);
+	if (rc) {
+		dev_err(&pdev->dev, "%s: unable to enable spi_clk\n",
+			__func__);
+		goto err_probe_clk_enable;
+	}
+
+	clk_enabled = 1;
+	rc = clk_enable(dd->pclk);
+	if (rc) {
+		dev_err(&pdev->dev, "%s: unable to enable spi_pclk\n",
+		__func__);
+		goto err_probe_pclk_enable;
+	}
+
+	pclk_enabled = 1;
+	rc = msm_spi_configure_gsbi(dd, pdev);
+	if (rc)
+		goto err_probe_gsbi;
+
+	msm_spi_calculate_fifo_size(dd);
+
+	/* Initialize registers */
+	writel(0x00000001, dd->base + SPI_SW_RESET);
+	msm_spi_set_state(dd, SPI_OP_STATE_RESET);
+	writel(0x00000000, dd->base + SPI_OPERATIONAL);
+	writel(0x00000000, dd->base + SPI_CONFIG);
+	writel(0x00000000, dd->base + SPI_IO_MODES);
+	/*
+	 * The SPI core generates a bogus input overrun error on some targets,
+	 * when a transition from run to reset state occurs and if the FIFO has
+	 * an odd number of entries. Hence we disable the INPUT_OVER_RUN_ERR_EN
+	 * bit.
+	 */
+	msm_spi_enable_error_flags(dd);
+
+	writel(SPI_IO_C_NO_TRI_STATE, dd->base + SPI_IO_CONTROL);
+	rc = msm_spi_set_state(dd, SPI_OP_STATE_RESET);
+	if (rc)
+		goto err_probe_state;
+
+	clk_disable(dd->clk);
+	clk_disable(dd->pclk);
+	clk_enabled = 0;
+	pclk_enabled = 0;
+
+	dd->suspended = 0;
+	dd->transfer_pending = 0;
+	dd->multi_xfr = 0;
+	dd->mode = SPI_MODE_NONE;
+
+	rc = msm_spi_request_irq(dd, pdev->name, master);
+	if (rc)
+		goto err_probe_irq;
+
+	msm_spi_disable_irqs(dd);
+	mutex_unlock(&dd->core_lock);
+	locked = 0;
+
+	rc = spi_register_master(master);
+	if (rc)
+		goto err_probe_reg_master;
+
+	rc = sysfs_create_group(&(dd->dev->kobj), &dev_attr_grp);
+	if (rc) {
+		dev_err(&pdev->dev, "failed to create dev. attrs : %d\n", rc);
+		goto err_attrs;
+	}
+
+	spi_debugfs_init(dd);
+
+	return 0;
+
+err_attrs:
+	spi_unregister_master(master);
+err_probe_reg_master:
+	msm_spi_free_irq(dd, master);
+err_probe_irq:
+err_probe_state:
+err_probe_gsbi:
+	if (pclk_enabled)
+		clk_disable(dd->pclk);
+err_probe_pclk_enable:
+	if (clk_enabled)
+		clk_disable(dd->clk);
+err_probe_clk_enable:
+	clk_put(dd->pclk);
+err_probe_pclk_get:
+	clk_put(dd->clk);
+err_probe_clk_get:
+	if (locked)
+		mutex_unlock(&dd->core_lock);
+err_probe_reqmem:
+	destroy_workqueue(dd->workqueue);
+err_probe_res:
+	spi_master_put(master);
+err_probe_exit:
+	return rc;
+}
+
+#ifdef CONFIG_PM
+static int msm_spi_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct spi_master *master = platform_get_drvdata(pdev);
+	struct msm_spi    *dd;
+	unsigned long      flags;
+
+	if (!master)
+		goto suspend_exit;
+
+	dd = spi_master_get_devdata(master);
+	if (!dd)
+		goto suspend_exit;
+
+	/* Make sure nothing is added to the queue while we're suspending */
+	spin_lock_irqsave(&dd->queue_lock, flags);
+	dd->suspended = 1;
+	spin_unlock_irqrestore(&dd->queue_lock, flags);
+
+	/* Wait for transactions to end, or time out */
+	wait_event_interruptible(dd->continue_suspend, !dd->transfer_pending);
+
+suspend_exit:
+	return 0;
+}
+
+static int msm_spi_resume(struct platform_device *pdev)
+{
+	struct spi_master *master = platform_get_drvdata(pdev);
+	struct msm_spi    *dd;
+
+	if (!master)
+		goto resume_exit;
+
+	dd = spi_master_get_devdata(master);
+	if (!dd)
+		goto resume_exit;
+
+	dd->suspended = 0;
+resume_exit:
+	return 0;
+}
+#else
+#define msm_spi_suspend NULL
+#define msm_spi_resume NULL
+#endif /* CONFIG_PM */
+
+static int __devexit msm_spi_remove(struct platform_device *pdev)
+{
+	struct spi_master *master = platform_get_drvdata(pdev);
+	struct msm_spi    *dd = spi_master_get_devdata(master);
+
+	spi_debugfs_exit(dd);
+	sysfs_remove_group(&pdev->dev.kobj, &dev_attr_grp);
+
+	msm_spi_free_irq(dd, master);
+	clk_put(dd->clk);
+	clk_put(dd->pclk);
+	destroy_workqueue(dd->workqueue);
+	platform_set_drvdata(pdev, 0);
+	spi_unregister_master(master);
+	spi_master_put(master);
+
+	return 0;
+}
+
+static struct platform_driver msm_spi_driver = {
+	.driver		= {
+		.name	= SPI_DRV_NAME,
+		.owner	= THIS_MODULE,
+	},
+	.suspend        = msm_spi_suspend,
+	.resume         = msm_spi_resume,
+	.remove         = __exit_p(msm_spi_remove),
+};
+
+static int __init msm_spi_init(void)
+{
+	return platform_driver_probe(&msm_spi_driver, msm_spi_probe);
+}
+module_init(msm_spi_init);
+
+static void __exit msm_spi_exit(void)
+{
+	platform_driver_unregister(&msm_spi_driver);
+}
+module_exit(msm_spi_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_VERSION("0.3");
+MODULE_ALIAS("platform:"SPI_DRV_NAME);
diff --git a/include/linux/platform_data/msm_spi.h b/include/linux/platform_data/msm_spi.h
new file mode 100644
index 0000000..a37ef6d
--- /dev/null
+++ b/include/linux/platform_data/msm_spi.h
@@ -0,0 +1,19 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
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
+#ifndef __ARCH_ARM_MACH_MSM_SPI_H
+#define __ARCH_ARM_MACH_MSM_SPI_H
+
+struct msm_spi_platform_data {
+	u32 max_clock_speed;
+};
+#endif
-- 
1.7.3.3

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

