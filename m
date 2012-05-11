Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495Ab2EKLFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 07:05:33 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1294 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab2EKLF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 07:05:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 11 May 2012 04:05:16 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
CC: Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 2/2] dma: tegra: add dmaengine based dma driver
Date: Fri, 11 May 2012 16:30:44 +0530
Message-ID: <1336734044-14275-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1336734044-14275-1-git-send-email-ldewangan@nvidia.com>
References: <1336734044-14275-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding dmaengine based NVIDIA's Tegra APB DMA driver.
This driver support the slave mode of data transfer from
peripheral to memory and vice versa.
The driver supports for the cyclic and non-cyclic mode
of data transfer.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- Incorportaed review comments from Vinod.
- get rid of the tegra_dma header.
- Having clock control through runtime pm.
- Remove regmap support.

Changes from V2:
- Taken care of aall review comments provided by Vinod.
- Drop cyclic_half notify mode of dma and implemented as cyclic only.
  This will make the this patch as simple. Also this can be achive
  by cyclic once mode. If require, we will add later.
- Remove goto most of places.
- Remove the cookie_complete() in aborted case.
- Remove callback when terminating.
- Macro names are now namespaced.
- Message prints are well formated to have in 1 or 2 line.

 drivers/dma/Kconfig     |   13 +
 drivers/dma/Makefile    |    1 +
 drivers/dma/tegra_dma.c | 1594 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1608 insertions(+), 0 deletions(-)
 create mode 100644 drivers/dma/tegra_dma.c

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index ef378b5..26d9a23 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -148,6 +148,19 @@ config TXX9_DMAC
 	  Support the TXx9 SoC internal DMA controller.  This can be
 	  integrated in chips such as the Toshiba TX4927/38/39.
 
+config TEGRA_DMA
+	bool "NVIDIA Tegra DMA support"
+	depends on ARCH_TEGRA
+	select DMA_ENGINE
+	help
+	  Support for the NVIDIA Tegra DMA controller driver. The DMA
+	  controller is having multiple DMA channel which can be configured
+	  for different peripherals like audio, UART, SPI, I2C etc which is
+	  in APB bus.
+	  This DMA controller transfers data from memory to peripheral fifo
+	  address or vice versa. It does not support memory to memory data
+	  transfer.
+
 config SH_DMAE
 	tristate "Renesas SuperH DMAC support"
 	depends on (SUPERH && SH_DMA) || (ARM && ARCH_SHMOBILE)
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index 86b795b..3aaa63a 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_MXS_DMA) += mxs-dma.o
 obj-$(CONFIG_TIMB_DMA) += timb_dma.o
 obj-$(CONFIG_SIRF_DMA) += sirf-dma.o
 obj-$(CONFIG_STE_DMA40) += ste_dma40.o ste_dma40_ll.o
+obj-$(CONFIG_TEGRA_DMA) += tegra_dma.o
 obj-$(CONFIG_PL330_DMA) += pl330.o
 obj-$(CONFIG_PCH_DMA) += pch_dma.o
 obj-$(CONFIG_AMBA_PL08X) += amba-pl08x.o
diff --git a/drivers/dma/tegra_dma.c b/drivers/dma/tegra_dma.c
new file mode 100644
index 0000000..eaaf74a
--- /dev/null
+++ b/drivers/dma/tegra_dma.c
@@ -0,0 +1,1594 @@
+/*
+ * DMA driver for Nvidia's Tegra APB DMA controller.
+ *
+ * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
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
+ */
+
+#include <linux/bitops.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+
+#include <mach/clk.h>
+#include "dmaengine.h"
+
+#define TEGRA_APBDMA_GENERAL		0x0
+#define GEN_ENABLE			BIT(31)
+
+#define TEGRA_APBDMA_CONTROL		0x010
+#define TEGRA_APBDMA_IRQ_MASK		0x01c
+#define TEGRA_APBDMA_IRQ_MASK_SET	0x020
+
+/* CSR register */
+#define TEGRA_APBDMA_CHAN_CSR		0x00
+#define CSR_ENB				BIT(31)
+#define CSR_IE_EOC			BIT(30)
+#define CSR_HOLD			BIT(29)
+#define CSR_DIR				BIT(28)
+#define CSR_ONCE			BIT(27)
+#define CSR_FLOW			BIT(21)
+#define CSR_REQ_SEL_SHIFT		16
+#define CSR_WCOUNT_MASK			0xFFFC
+
+/* STATUS register */
+#define TEGRA_APBDMA_CHAN_STATUS	0x004
+#define STATUS_BUSY			BIT(31)
+#define STATUS_ISE_EOC			BIT(30)
+#define STATUS_HALT			BIT(29)
+#define STATUS_PING_PONG		BIT(28)
+#define STATUS_COUNT_SHIFT		2
+#define STATUS_COUNT_MASK		0xFFFC
+
+/* AHB memory address */
+#define TEGRA_APBDMA_CHAN_AHBPTR	0x010
+
+/* AHB sequence register */
+#define TEGRA_APBDMA_CHAN_AHBSEQ	0x14
+#define AHBSEQ_INTR_ENB			BIT(31)
+#define AHBSEQ_BUS_WIDTH_SHIFT		28
+#define AHBSEQ_BUS_WIDTH_8		(0 << AHBSEQ_BUS_WIDTH_SHIFT)
+#define AHBSEQ_BUS_WIDTH_16		(1 << AHBSEQ_BUS_WIDTH_SHIFT)
+#define AHBSEQ_BUS_WIDTH_32		(2 << AHBSEQ_BUS_WIDTH_SHIFT)
+#define AHBSEQ_BUS_WIDTH_64		(3 << AHBSEQ_BUS_WIDTH_SHIFT)
+#define AHBSEQ_BUS_WIDTH_128		(4 << AHBSEQ_BUS_WIDTH_SHIFT)
+#define AHBSEQ_DATA_SWAP		BIT(27)
+#define AHBSEQ_BURST_1			(4 << 24)
+#define AHBSEQ_BURST_4			(5 << 24)
+#define AHBSEQ_BURST_8			(6 << 24)
+#define AHBSEQ_DBL_BUF			BIT(19)
+#define AHBSEQ_WRAP_SHIFT		16
+#define AHBSEQ_WRAP_NONE		0
+
+/* APB address */
+#define TEGRA_APBDMA_CHAN_APBPTR	0x018
+
+/* APB sequence register */
+#define TEGRA_APBDMA_CHAN_APBSEQ	0x01c
+#define APBSEQ_BUS_WIDTH_SHIFT		28
+#define APBSEQ_BUS_WIDTH_8		(0 << APBSEQ_BUS_WIDTH_SHIFT)
+#define APBSEQ_BUS_WIDTH_16		(1 << APBSEQ_BUS_WIDTH_SHIFT)
+#define APBSEQ_BUS_WIDTH_32		(2 << APBSEQ_BUS_WIDTH_SHIFT)
+#define APBSEQ_BUS_WIDTH_64		(3 << APBSEQ_BUS_WIDTH_SHIFT)
+#define APBSEQ_BUS_WIDTH_128		(4 << APBSEQ_BUS_WIDTH_SHIFT)
+#define APBSEQ_DATA_SWAP		BIT(27)
+#define APBSEQ_WRAP_SHIFT		16
+#define APBSEQ_WRAP_WORD_1		(1 << APBSEQ_WRAP_SHIFT)
+
+/*
+ * If any burst is in flight and DMA paused then this is the time to complete
+ * on-flight burst and update DMA status register.
+ */
+#define TEGRA_APBDMA_BURST_COMPLETE_TIME	20
+
+/* Channel base address offset from APBDMA base address */
+#define TEGRA_APBDMA_CHANNEL_BASE_ADD_OFFSET	0x1000
+
+/* DMA channel register space size */
+#define TEGRA_APBDMA_CHANNEL_REGISTER_SIZE	0x20
+
+/*
+ * Initial number of descriptors to allocate for each channel during
+ * allocation. More descriptors will be allocated dynamically if
+ * client needs it.
+ */
+#define TEGRA_APBDMA_NR_DESCS			4
+#define TEGRA_APBDMA_NR_REQ_PER_DESC		8
+
+struct tegra_dma;
+
+/*
+ * tegra_dma_chip_data Tegra chip specific DMA data
+ * @nr_channels: Number of channels available in the controller.
+ * @max_dma_count: Maximum DMA transfer count supported by DMA controller.
+ */
+struct tegra_dma_chip_data {
+	int nr_channels;
+	int max_dma_count;
+};
+
+/* Dma channel registers */
+struct tegra_dma_channel_regs {
+	unsigned long	csr;
+	unsigned long	ahb_ptr;
+	unsigned long	apb_ptr;
+	unsigned long	ahb_seq;
+	unsigned long	apb_seq;
+};
+
+/*
+ * tegra_dma_sg_req: Dma request details to configure hardware. This
+ * contains the details for one transfer to configure DMA hw.
+ * The client's request for data transfer can be broken into multiple
+ * sub-transfer as per requester details and hw support.
+ * This sub transfer get added in the list of transfer and point to Tegra
+ * DMA descriptor which manages the transfer details.
+ */
+struct tegra_dma_sg_req {
+	struct tegra_dma_channel_regs	ch_regs;
+	int				req_len;
+	bool				configured;
+	bool				last_sg;
+	bool				half_done;
+	struct list_head		node;
+	struct tegra_dma_desc		*dma_desc;
+};
+
+/*
+ * tegra_dma_desc: Tegra DMA descriptors which manages the client requests.
+ * This descriptor keep track of transfer status, callbacks and request
+ * counts etc.
+ */
+struct tegra_dma_desc {
+	struct dma_async_tx_descriptor	txd;
+	int				bytes_requested;
+	int				bytes_transferred;
+	enum dma_status			dma_status;
+	struct list_head		node;
+	struct list_head		tx_list;
+	struct list_head		cb_node;
+	bool				ack_reqd;
+	bool				cb_due;
+};
+
+struct tegra_dma_channel;
+
+typedef void (*dma_isr_handler)(struct tegra_dma_channel *tdc,
+				bool to_terminate);
+
+/* tegra_dma_channel: Channel specific information */
+struct tegra_dma_channel {
+	struct dma_chan		dma_chan;
+	bool			config_init;
+	int			id;
+	int			irq;
+	unsigned long		chan_base_offset;
+	spinlock_t		lock;
+	bool			busy;
+	int			descs_allocated;
+	struct tegra_dma	*tdma;
+	bool			cyclic;
+
+	/* Different lists for managing the requests */
+	struct list_head	free_sg_req;
+	struct list_head	pending_sg_req;
+	struct list_head	free_dma_desc;
+	struct list_head	wait_ack_dma_desc;
+	struct list_head	cb_desc;
+
+	/* isr handler and tasklet for bottom half of isr handling */
+	dma_isr_handler		isr_handler;
+	struct tasklet_struct	tasklet;
+	dma_async_tx_callback	callback;
+	void			*callback_param;
+
+	/* Channel-slave specific configuration */
+	struct dma_slave_config dma_sconfig;
+};
+
+/* tegra_dma: Tegra DMA specific information */
+struct tegra_dma {
+	struct dma_device		dma_dev;
+	struct device			*dev;
+	struct clk			*dma_clk;
+	spinlock_t			global_lock;
+	void __iomem			*base_addr;
+	struct tegra_dma_chip_data	*chip_data;
+
+	/* Some register need to be cache before suspend */
+	u32				reg_gen;
+
+	/* Last member of the structure */
+	struct tegra_dma_channel channels[0];
+};
+
+static inline void tdma_write(struct tegra_dma *tdma, u32 reg, u32 val)
+{
+	writel(val, tdma->base_addr + reg);
+}
+
+static inline u32 tdma_read(struct tegra_dma *tdma, u32 reg)
+{
+	return readl(tdma->base_addr + reg);
+}
+
+static inline void tdc_write(struct tegra_dma_channel *tdc,
+		u32 reg, u32 val)
+{
+	writel(val, tdc->tdma->base_addr + tdc->chan_base_offset + reg);
+}
+
+static inline u32 tdc_read(struct tegra_dma_channel *tdc, u32 reg)
+{
+	return readl(tdc->tdma->base_addr + tdc->chan_base_offset + reg);
+}
+
+static inline struct tegra_dma_channel *to_tegra_dma_chan(struct dma_chan *dc)
+{
+	return container_of(dc, struct tegra_dma_channel, dma_chan);
+}
+
+static inline struct tegra_dma_desc *txd_to_tegra_dma_desc(
+		struct dma_async_tx_descriptor *td)
+{
+	return container_of(td, struct tegra_dma_desc, txd);
+}
+
+static inline struct device *tdc2dev(struct tegra_dma_channel *tdc)
+{
+	return &tdc->dma_chan.dev->device;
+}
+
+static dma_cookie_t tegra_dma_tx_submit(struct dma_async_tx_descriptor *tx);
+static int tegra_dma_runtime_suspend(struct device *dev);
+static int tegra_dma_runtime_resume(struct device *dev);
+
+/* Caller need to hold lock */
+static int tegra_dma_allocate_desc(struct tegra_dma_channel *tdc,
+		int ndma_desc, int nsg_req)
+{
+	int i;
+	struct tegra_dma_desc *dma_desc;
+	struct tegra_dma_sg_req *sg_req;
+	struct dma_chan *dc = &tdc->dma_chan;
+	struct list_head dma_desc_list;
+	struct list_head sg_req_list;
+
+	INIT_LIST_HEAD(&dma_desc_list);
+	INIT_LIST_HEAD(&sg_req_list);
+
+	/* Initialize DMA descriptors */
+	for (i = 0; i < ndma_desc; ++i) {
+		dma_desc = kzalloc(sizeof(*dma_desc), GFP_ATOMIC);
+		if (!dma_desc) {
+			dev_err(tdc2dev(tdc), "dma_desc alloc failed");
+			goto exit_clean;
+		}
+
+		dma_async_tx_descriptor_init(&dma_desc->txd, dc);
+		dma_desc->txd.tx_submit = tegra_dma_tx_submit;
+		dma_desc->txd.flags = DMA_CTRL_ACK;
+		list_add_tail(&dma_desc->node, &dma_desc_list);
+	}
+
+	/* Initialize req descriptors */
+	for (i = 0; i < nsg_req; ++i) {
+		sg_req = kzalloc(sizeof(struct tegra_dma_sg_req), GFP_ATOMIC);
+		if (!sg_req) {
+			dev_err(tdc2dev(tdc), "sg_req alloc failed");
+			goto exit_clean;
+		}
+		list_add_tail(&sg_req->node, &sg_req_list);
+	}
+
+	if (ndma_desc) {
+		tdc->descs_allocated += ndma_desc;
+		list_splice(&dma_desc_list, &tdc->free_dma_desc);
+	}
+
+	if (nsg_req)
+		list_splice(&sg_req_list, &tdc->free_sg_req);
+
+	return tdc->descs_allocated;
+
+exit_clean:
+	while (!list_empty(&dma_desc_list)) {
+		dma_desc = list_first_entry(&dma_desc_list,
+					typeof(*dma_desc), node);
+		list_del(&dma_desc->node);
+		kfree(dma_desc);
+	}
+
+	while (!list_empty(&sg_req_list)) {
+		sg_req = list_first_entry(&sg_req_list, typeof(*sg_req), node);
+		list_del(&sg_req->node);
+		kfree(sg_req);
+	}
+	return 0;
+}
+
+/*
+ * Caller need to lock.
+ * Get DMA desc from free list, if not there then allocate it.
+ */
+static struct tegra_dma_desc *tegra_dma_desc_get_locked(
+		struct tegra_dma_channel *tdc)
+{
+	struct tegra_dma_desc *dma_desc = NULL;
+
+	/* Check from free list desc */
+	if (!list_empty(&tdc->free_dma_desc)) {
+		dma_desc = list_first_entry(&tdc->free_dma_desc,
+					typeof(*dma_desc), node);
+		list_del(&dma_desc->node);
+		return dma_desc;
+	}
+
+	/*
+	 * Check list with desc which are waiting for ack, may be it
+	 * got acked from client.
+	 */
+	if (!list_empty(&tdc->wait_ack_dma_desc)) {
+		list_for_each_entry(dma_desc, &tdc->wait_ack_dma_desc, node) {
+			if (async_tx_test_ack(&dma_desc->txd)) {
+				list_del(&dma_desc->node);
+				return dma_desc;
+			}
+		}
+	}
+
+	/* There is no free desc, allocate it */
+	dev_dbg(tdc2dev(tdc), "Allocate more desc for channel %d", tdc->id);
+	tegra_dma_allocate_desc(tdc, TEGRA_APBDMA_NR_DESCS,
+			TEGRA_APBDMA_NR_DESCS * TEGRA_APBDMA_NR_REQ_PER_DESC);
+	if (list_empty(&tdc->free_dma_desc))
+		return NULL;
+
+	dma_desc = list_first_entry(&tdc->free_dma_desc,
+					typeof(*dma_desc), node);
+	list_del(&dma_desc->node);
+	return dma_desc;
+}
+
+/* Get DMA desc from free list, if not there then allocate it */
+static struct tegra_dma_desc *tegra_dma_desc_get(struct tegra_dma_channel *tdc)
+{
+	struct tegra_dma_desc *dma_desc = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tdc->lock, flags);
+	dma_desc = tegra_dma_desc_get_locked(tdc);
+	spin_unlock_irqrestore(&tdc->lock, flags);
+	return dma_desc;
+}
+
+static void tegra_dma_desc_put(struct tegra_dma_channel *tdc,
+		struct tegra_dma_desc *dma_desc)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&tdc->lock, flags);
+	if (!list_empty(&dma_desc->tx_list))
+		list_splice_init(&dma_desc->tx_list, &tdc->free_sg_req);
+	list_add_tail(&dma_desc->node, &tdc->free_dma_desc);
+	spin_unlock_irqrestore(&tdc->lock, flags);
+}
+
+static void tegra_dma_desc_done_locked(struct tegra_dma_channel *tdc,
+		struct tegra_dma_desc *dma_desc)
+{
+	if (dma_desc->ack_reqd)
+		list_add_tail(&dma_desc->node, &tdc->wait_ack_dma_desc);
+	else
+		list_add_tail(&dma_desc->node, &tdc->free_dma_desc);
+}
+
+static struct tegra_dma_sg_req *tegra_dma_sg_req_get_locked(
+		struct tegra_dma_channel *tdc)
+{
+	struct tegra_dma_sg_req *sg_req = NULL;
+
+	if (list_empty(&tdc->free_sg_req)) {
+		dev_dbg(tdc2dev(tdc), "Allocate more sq_req");
+		tegra_dma_allocate_desc(tdc, 0,
+			TEGRA_APBDMA_NR_DESCS * TEGRA_APBDMA_NR_REQ_PER_DESC);
+
+		if (list_empty(&tdc->free_sg_req)) {
+			dev_dbg(tdc2dev(tdc), "sg_req alloc failed");
+			return NULL;
+		}
+	}
+
+	sg_req = list_first_entry(&tdc->free_sg_req, typeof(*sg_req), node);
+	list_del(&sg_req->node);
+	return sg_req;
+}
+
+static struct tegra_dma_sg_req *tegra_dma_sg_req_get(
+		struct tegra_dma_channel *tdc)
+{
+	struct tegra_dma_sg_req *sg_req = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tdc->lock, flags);
+	sg_req = tegra_dma_sg_req_get_locked(tdc);
+	spin_unlock_irqrestore(&tdc->lock, flags);
+	return sg_req;
+}
+
+static int tegra_dma_slave_config(struct dma_chan *dc,
+		struct dma_slave_config *sconfig)
+{
+	struct tegra_dma_channel *tdc = to_tegra_dma_chan(dc);
+
+	if (!list_empty(&tdc->pending_sg_req)) {
+		dev_err(tdc2dev(tdc), "Configuration not allowed");
+		return -EBUSY;
+	}
+
+	memcpy(&tdc->dma_sconfig, sconfig, sizeof(*sconfig));
+	tdc->config_init = true;
+	return 0;
+}
+
+static void tegra_dma_pause(struct tegra_dma_channel *tdc,
+	bool wait_for_burst_complete)
+{
+	struct tegra_dma *tdma = tdc->tdma;
+
+	spin_lock(&tdma->global_lock);
+	tdma_write(tdma, TEGRA_APBDMA_GENERAL, 0);
+	if (wait_for_burst_complete)
+		udelay(TEGRA_APBDMA_BURST_COMPLETE_TIME);
+}
+
+static void tegra_dma_resume(struct tegra_dma_channel *tdc)
+{
+	struct tegra_dma *tdma = tdc->tdma;
+
+	tdma_write(tdma, TEGRA_APBDMA_GENERAL, GEN_ENABLE);
+	spin_unlock(&tdma->global_lock);
+}
+
+static void tegra_dma_stop(struct tegra_dma_channel *tdc)
+{
+	u32 csr;
+	u32 status;
+
+	/* Disable interrupts */
+	csr = tdc_read(tdc, TEGRA_APBDMA_CHAN_CSR);
+	csr &= ~CSR_IE_EOC;
+	tdc_write(tdc, TEGRA_APBDMA_CHAN_CSR, csr);
+
+	/* Disable DMA */
+	csr &= ~CSR_ENB;
+	tdc_write(tdc, TEGRA_APBDMA_CHAN_CSR, csr);
+
+	/* Clear interrupt status if it is there */
+	status = tdc_read(tdc, TEGRA_APBDMA_CHAN_STATUS);
+	if (status & STATUS_ISE_EOC) {
+		dev_dbg(tdc2dev(tdc), "%s():clearing interrupt", __func__);
+		tdc_write(tdc, TEGRA_APBDMA_CHAN_STATUS, status);
+	}
+	tdc->busy = false;
+}
+
+static void tegra_dma_start(struct tegra_dma_channel *tdc,
+		struct tegra_dma_sg_req *sg_req)
+{
+	struct tegra_dma_channel_regs *ch_regs = &sg_req->ch_regs;
+
+	tdc_write(tdc, TEGRA_APBDMA_CHAN_CSR, ch_regs->csr);
+	tdc_write(tdc, TEGRA_APBDMA_CHAN_APBSEQ, ch_regs->apb_seq);
+	tdc_write(tdc, TEGRA_APBDMA_CHAN_APBPTR, ch_regs->apb_ptr);
+	tdc_write(tdc, TEGRA_APBDMA_CHAN_AHBSEQ, ch_regs->ahb_seq);
+	tdc_write(tdc, TEGRA_APBDMA_CHAN_AHBPTR, ch_regs->ahb_ptr);
+
+	/* Dump the configuration register if verbose mode enabled */
+	dev_vdbg(tdc2dev(tdc), "csr:    0x%08lx\n", ch_regs->csr);
+	dev_vdbg(tdc2dev(tdc), "apbseq: 0x%08lx\n", ch_regs->apb_seq);
+	dev_vdbg(tdc2dev(tdc), "apbptr: 0x%08lx\n", ch_regs->apb_ptr);
+	dev_vdbg(tdc2dev(tdc), "ahbseq: 0x%08lx\n", ch_regs->ahb_seq);
+	dev_vdbg(tdc2dev(tdc), "ahbptr: 0x%08lx\n", ch_regs->ahb_ptr);
+
+	/* Start DMA */
+	tdc_write(tdc, TEGRA_APBDMA_CHAN_CSR, ch_regs->csr | CSR_ENB);
+}
+
+static void tegra_dma_configure_for_next(struct tegra_dma_channel *tdc,
+		struct tegra_dma_sg_req *nsg_req)
+{
+	unsigned long status;
+
+	/*
+	 * The DMA controller reloads the new configuration for next transfer
+	 * after last burst of current transfer completes.
+	 * If there is no IEC status then this makes sure that last burst
+	 * has not be completed. There may be case that last burst is on
+	 * flight and so it can complete but because DMA is paused, it
+	 * will not generates interrupt as well as not reload the new
+	 * configuration.
+	 * If there is already IEC status then interrupt handler need to
+	 * load new configuration.
+	 */
+	tegra_dma_pause(tdc, false);
+	status  = tdc_read(tdc, TEGRA_APBDMA_CHAN_STATUS);
+
+	/*
+	 * If interrupt is pending then do nothing as the ISR will handle
+	 * the programing for new request.
+	 */
+	if (status & STATUS_ISE_EOC) {
+		dev_err(tdc2dev(tdc),
+			"Skipping new configuration as interrupt is pending\n");
+		goto exit_config;
+	}
+
+	/* Safe to program new configuration */
+	tdc_write(tdc, TEGRA_APBDMA_CHAN_APBPTR, nsg_req->ch_regs.apb_ptr);
+	tdc_write(tdc, TEGRA_APBDMA_CHAN_AHBPTR, nsg_req->ch_regs.ahb_ptr);
+	tdc_write(tdc, TEGRA_APBDMA_CHAN_CSR, nsg_req->ch_regs.csr | CSR_ENB);
+	nsg_req->configured = true;
+
+exit_config:
+	tegra_dma_resume(tdc);
+}
+
+static void tdc_start_head_req(struct tegra_dma_channel *tdc)
+{
+	struct tegra_dma_sg_req *sg_req;
+
+	if (list_empty(&tdc->pending_sg_req))
+		return;
+
+	sg_req = list_first_entry(&tdc->pending_sg_req,
+					typeof(*sg_req), node);
+	tegra_dma_start(tdc, sg_req);
+	sg_req->configured = true;
+	tdc->busy = true;
+}
+
+static void tdc_configure_next_head_desc(struct tegra_dma_channel *tdc)
+{
+	struct tegra_dma_sg_req *hsgreq;
+	struct tegra_dma_sg_req *hnsgreq;
+
+	if (list_empty(&tdc->pending_sg_req))
+		return;
+
+	hsgreq = list_first_entry(&tdc->pending_sg_req, typeof(*hsgreq), node);
+	if (!list_is_last(&hsgreq->node, &tdc->pending_sg_req)) {
+		hnsgreq = list_first_entry(&hsgreq->node,
+					typeof(*hnsgreq), node);
+		tegra_dma_configure_for_next(tdc, hnsgreq);
+	}
+}
+
+static inline int get_current_xferred_count(struct tegra_dma_channel *tdc,
+	struct tegra_dma_sg_req *sg_req, unsigned long status)
+{
+	return sg_req->req_len - ((status & STATUS_COUNT_MASK) + 4);
+}
+
+static void tegra_dma_abort_all(struct tegra_dma_channel *tdc)
+{
+	struct tegra_dma_sg_req *sgreq;
+	struct tegra_dma_desc *dma_desc;
+
+	while (!list_empty(&tdc->pending_sg_req)) {
+		sgreq = list_first_entry(&tdc->pending_sg_req,
+						typeof(*sgreq), node);
+		list_del(&sgreq->node);
+		list_add_tail(&sgreq->node, &tdc->free_sg_req);
+		if (sgreq->last_sg) {
+			dma_desc = sgreq->dma_desc;
+			dma_desc->dma_status = DMA_ERROR;
+			tegra_dma_desc_done_locked(tdc, dma_desc);
+
+			/* Add in cb list if it is not there. */
+			if (!dma_desc->cb_due) {
+				list_add_tail(&dma_desc->cb_node,
+							&tdc->cb_desc);
+				dma_desc->cb_due = true;
+			}
+		}
+	}
+	tdc->isr_handler = NULL;
+}
+
+static bool handle_continuous_head_request(struct tegra_dma_channel *tdc,
+		struct tegra_dma_sg_req *last_sg_req, bool to_terminate)
+{
+	struct tegra_dma_sg_req *hsgreq = NULL;
+
+	if (list_empty(&tdc->pending_sg_req)) {
+		dev_err(tdc2dev(tdc), "Dma is running without req\n");
+		tegra_dma_stop(tdc);
+		return false;
+	}
+
+	/*
+	 * Check that head req on list should be in flight.
+	 * If it is not in flight then abort transfer as
+	 * transfer looping can not continue.
+	 */
+	hsgreq = list_first_entry(&tdc->pending_sg_req, typeof(*hsgreq), node);
+	if (!hsgreq->configured) {
+		tegra_dma_stop(tdc);
+		dev_err(tdc2dev(tdc), "Error in dma transfer, aborting dma\n");
+		tegra_dma_abort_all(tdc);
+		return false;
+	}
+
+	/* Configure next request */
+	if (!to_terminate)
+		tdc_configure_next_head_desc(tdc);
+	return true;
+}
+
+static void handle_once_dma_done(struct tegra_dma_channel *tdc,
+	bool to_terminate)
+{
+	struct tegra_dma_sg_req *sgreq;
+	struct tegra_dma_desc *dma_desc;
+
+	tdc->busy = false;
+	sgreq = list_first_entry(&tdc->pending_sg_req, typeof(*sgreq), node);
+	dma_desc = sgreq->dma_desc;
+	dma_desc->bytes_transferred += sgreq->req_len;
+
+	list_del(&sgreq->node);
+	if (sgreq->last_sg) {
+		dma_desc->dma_status = DMA_SUCCESS;
+		dma_cookie_complete(&dma_desc->txd);
+		list_add_tail(&dma_desc->cb_node, &tdc->cb_desc);
+		dma_desc->cb_due = true;
+		tegra_dma_desc_done_locked(tdc, dma_desc);
+	}
+	list_add_tail(&sgreq->node, &tdc->free_sg_req);
+
+	/* Do not start DMA if it is going to be terminate */
+	if (to_terminate || list_empty(&tdc->pending_sg_req))
+		return;
+
+	tdc_start_head_req(tdc);
+	return;
+}
+
+static void handle_cont_sngl_cycle_dma_done(struct tegra_dma_channel *tdc,
+		bool to_terminate)
+{
+	struct tegra_dma_sg_req *sgreq;
+	struct tegra_dma_desc *dma_desc;
+	bool st;
+
+	sgreq = list_first_entry(&tdc->pending_sg_req, typeof(*sgreq), node);
+	dma_desc = sgreq->dma_desc;
+	dma_desc->bytes_transferred += sgreq->req_len;
+
+	/* Callback need to be call */
+	list_add_tail(&dma_desc->cb_node, &tdc->cb_desc);
+	dma_desc->cb_due = true;
+
+	/* If not last req then put at end of pending list */
+	if (!list_is_last(&sgreq->node, &tdc->pending_sg_req)) {
+		list_del(&sgreq->node);
+		list_add_tail(&sgreq->node, &tdc->pending_sg_req);
+		sgreq->configured = false;
+		st = handle_continuous_head_request(tdc, sgreq, to_terminate);
+		if (!st)
+			dma_desc->dma_status = DMA_ERROR;
+	}
+	return;
+}
+
+static void tegra_dma_tasklet(unsigned long data)
+{
+	struct tegra_dma_channel *tdc = (struct tegra_dma_channel *)data;
+	unsigned long flags;
+	dma_async_tx_callback callback = NULL;
+	void *callback_param = NULL;
+	struct tegra_dma_desc *dma_desc;
+	struct list_head cb_dma_desc_list;
+
+	INIT_LIST_HEAD(&cb_dma_desc_list);
+	spin_lock_irqsave(&tdc->lock, flags);
+	if (list_empty(&tdc->cb_desc)) {
+		spin_unlock_irqrestore(&tdc->lock, flags);
+		return;
+	}
+	list_splice_init(&tdc->cb_desc, &cb_dma_desc_list);
+	spin_unlock_irqrestore(&tdc->lock, flags);
+
+	while (!list_empty(&cb_dma_desc_list)) {
+		dma_desc  = list_first_entry(&cb_dma_desc_list,
+				typeof(*dma_desc), cb_node);
+		list_del(&dma_desc->cb_node);
+
+		callback = dma_desc->txd.callback;
+		callback_param = dma_desc->txd.callback_param;
+		dma_desc->cb_due = false;
+		if (callback)
+			callback(callback_param);
+	}
+}
+
+static irqreturn_t tegra_dma_isr(int irq, void *dev_id)
+{
+	struct tegra_dma_channel *tdc = dev_id;
+	unsigned long status;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tdc->lock, flags);
+
+	status = tdc_read(tdc, TEGRA_APBDMA_CHAN_STATUS);
+	if (status & STATUS_ISE_EOC) {
+		tdc_write(tdc, TEGRA_APBDMA_CHAN_STATUS, status);
+		if (!list_empty(&tdc->cb_desc)) {
+			dev_err(tdc2dev(tdc),
+				"Int before tasklet handled, Stopping DMA\n");
+			tegra_dma_stop(tdc);
+			tdc->isr_handler(tdc, true);
+			tegra_dma_abort_all(tdc);
+			/* Schedule tasklet to make callback */
+			tasklet_schedule(&tdc->tasklet);
+			goto end;
+		}
+		tdc->isr_handler(tdc, false);
+		tasklet_schedule(&tdc->tasklet);
+	} else {
+		dev_info(tdc2dev(tdc),
+			"Interrupt already handled status 0x%08lx\n", status);
+	}
+
+end:
+	spin_unlock_irqrestore(&tdc->lock, flags);
+	return IRQ_HANDLED;
+}
+
+static dma_cookie_t tegra_dma_tx_submit(struct dma_async_tx_descriptor *txd)
+{
+	struct tegra_dma_desc *dma_desc = txd_to_tegra_dma_desc(txd);
+	struct tegra_dma_channel *tdc = to_tegra_dma_chan(txd->chan);
+	unsigned long flags;
+	dma_cookie_t cookie;
+
+	spin_lock_irqsave(&tdc->lock, flags);
+	dma_desc->dma_status = DMA_IN_PROGRESS;
+	cookie = dma_cookie_assign(&dma_desc->txd);
+	list_splice_tail_init(&dma_desc->tx_list, &tdc->pending_sg_req);
+	spin_unlock_irqrestore(&tdc->lock, flags);
+	return cookie;
+}
+
+static void tegra_dma_issue_pending(struct dma_chan *dc)
+{
+	struct tegra_dma_channel *tdc = to_tegra_dma_chan(dc);
+	unsigned long flags;
+
+	spin_lock_irqsave(&tdc->lock, flags);
+	if (list_empty(&tdc->pending_sg_req)) {
+		dev_err(tdc2dev(tdc), "No DMA request\n");
+		goto end;
+	}
+	if (!tdc->busy) {
+		tdc_start_head_req(tdc);
+
+		/* Continuous single mode: Configure next req */
+		if (tdc->cyclic) {
+			/*
+			 * Wait for 1 burst time for configure DMA for
+			 * next transfer.
+			 */
+			udelay(TEGRA_APBDMA_BURST_COMPLETE_TIME);
+			tdc_configure_next_head_desc(tdc);
+		}
+	}
+end:
+	spin_unlock_irqrestore(&tdc->lock, flags);
+	return;
+}
+
+static void tegra_dma_terminate_all(struct dma_chan *dc)
+{
+	struct tegra_dma_channel *tdc = to_tegra_dma_chan(dc);
+	struct tegra_dma_sg_req *sgreq;
+	struct tegra_dma_desc *dma_desc;
+	unsigned long flags;
+	unsigned long status;
+	bool was_busy;
+
+	spin_lock_irqsave(&tdc->lock, flags);
+	if (list_empty(&tdc->pending_sg_req)) {
+		spin_unlock_irqrestore(&tdc->lock, flags);
+		return;
+	}
+
+	if (!tdc->busy)
+		goto skip_dma_stop;
+
+	/* Pause DMA before checking the queue status */
+	tegra_dma_pause(tdc, true);
+
+	status = tdc_read(tdc, TEGRA_APBDMA_CHAN_STATUS);
+	if (status & STATUS_ISE_EOC) {
+		dev_dbg(tdc2dev(tdc), "%s():handling isr\n", __func__);
+		tdc->isr_handler(tdc, true);
+		status = tdc_read(tdc, TEGRA_APBDMA_CHAN_STATUS);
+	}
+
+	was_busy = tdc->busy;
+	tegra_dma_stop(tdc);
+
+	if (!list_empty(&tdc->pending_sg_req) && was_busy) {
+		sgreq = list_first_entry(&tdc->pending_sg_req,
+					typeof(*sgreq), node);
+		sgreq->dma_desc->bytes_transferred +=
+				get_current_xferred_count(tdc, sgreq, status);
+	}
+	tegra_dma_resume(tdc);
+
+skip_dma_stop:
+	tegra_dma_abort_all(tdc);
+
+	while (!list_empty(&tdc->cb_desc)) {
+		dma_desc  = list_first_entry(&tdc->cb_desc, typeof(*dma_desc),
+					cb_node);
+		list_del(&dma_desc->cb_node);
+		dma_desc->cb_due = false;
+	}
+	spin_unlock_irqrestore(&tdc->lock, flags);
+}
+
+static enum dma_status tegra_dma_tx_status(struct dma_chan *dc,
+	dma_cookie_t cookie, struct dma_tx_state *txstate)
+{
+	struct tegra_dma_channel *tdc = to_tegra_dma_chan(dc);
+	struct tegra_dma_desc *dma_desc;
+	struct tegra_dma_sg_req *sg_req;
+	enum dma_status ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tdc->lock, flags);
+
+	ret = dma_cookie_status(dc, cookie, txstate);
+	if (ret == DMA_SUCCESS) {
+		dma_set_residue(txstate, 0);
+		spin_unlock_irqrestore(&tdc->lock, flags);
+		return ret;
+	}
+
+	/* Check on wait_ack desc status */
+	if (!list_empty(&tdc->wait_ack_dma_desc))
+		list_for_each_entry(dma_desc, &tdc->wait_ack_dma_desc, node) {
+			if (dma_desc->txd.cookie == cookie) {
+				dma_set_residue(txstate,
+					dma_desc->bytes_requested -
+						dma_desc->bytes_transferred);
+				ret = dma_desc->dma_status;
+				spin_unlock_irqrestore(&tdc->lock, flags);
+				return ret;
+		}
+	}
+
+	/* Check in pending list */
+	if (!list_empty(&tdc->pending_sg_req)) {
+		list_for_each_entry(sg_req, &tdc->pending_sg_req, node) {
+			dma_desc = sg_req->dma_desc;
+			if (dma_desc->txd.cookie == cookie) {
+				dma_set_residue(txstate,
+					dma_desc->bytes_requested -
+					dma_desc->bytes_transferred);
+				ret = dma_desc->dma_status;
+				spin_unlock_irqrestore(&tdc->lock, flags);
+				return ret;
+			}
+		}
+	}
+
+	dev_dbg(tdc2dev(tdc), "cookie %d does not found\n", cookie);
+	spin_unlock_irqrestore(&tdc->lock, flags);
+	return ret;
+}
+
+static int tegra_dma_device_control(struct dma_chan *dc, enum dma_ctrl_cmd cmd,
+			unsigned long arg)
+{
+	switch (cmd) {
+	case DMA_SLAVE_CONFIG:
+		return tegra_dma_slave_config(dc,
+				(struct dma_slave_config *)arg);
+
+	case DMA_TERMINATE_ALL:
+		tegra_dma_terminate_all(dc);
+		return 0;
+
+	default:
+		break;
+	}
+
+	return -ENXIO;
+}
+
+static inline int get_bus_width(enum dma_slave_buswidth slave_bw)
+{
+	BUG_ON(!slave_bw);
+	switch (slave_bw) {
+	case DMA_SLAVE_BUSWIDTH_1_BYTE:
+		return APBSEQ_BUS_WIDTH_8;
+	case DMA_SLAVE_BUSWIDTH_2_BYTES:
+		return APBSEQ_BUS_WIDTH_16;
+	case DMA_SLAVE_BUSWIDTH_4_BYTES:
+		return APBSEQ_BUS_WIDTH_32;
+	case DMA_SLAVE_BUSWIDTH_8_BYTES:
+		return APBSEQ_BUS_WIDTH_64;
+	default:
+		BUG();
+	}
+}
+
+static inline int get_burst_size(struct tegra_dma_channel *tdc,
+	u32 burst_size, enum dma_slave_buswidth slave_bw, int len)
+{
+	int burst_byte;
+	int burst_ahb_width;
+
+	/*
+	 * burst_size from client is in terms of the bus_width.
+	 * convert them into ahb mmeory width which is 4 byte.
+	 */
+	burst_byte = burst_size * slave_bw;
+	burst_ahb_width = burst_byte / 4;
+
+	/* If burst size is 0 then calculate the burst size based on length */
+	if (!burst_ahb_width) {
+		if (len & 0xF)
+			return AHBSEQ_BURST_1;
+		else if ((len >> 4) & 0x1)
+			return AHBSEQ_BURST_4;
+		else
+			return AHBSEQ_BURST_8;
+	}
+	if (burst_ahb_width < 4)
+		return AHBSEQ_BURST_1;
+	else if (burst_ahb_width < 8)
+		return AHBSEQ_BURST_4;
+	else
+		return AHBSEQ_BURST_8;
+}
+
+static struct dma_async_tx_descriptor *tegra_dma_prep_slave_sg(
+	struct dma_chan *dc, struct scatterlist *sgl, unsigned int sg_len,
+	enum dma_transfer_direction direction, unsigned long flags,
+	void *context)
+{
+	struct tegra_dma_channel *tdc = to_tegra_dma_chan(dc);
+	struct tegra_dma_desc *dma_desc;
+	unsigned int	    i;
+	struct scatterlist      *sg;
+	unsigned long csr, ahb_seq, apb_ptr, apb_seq;
+	struct list_head req_list;
+	struct tegra_dma_sg_req  *sg_req = NULL;
+	u32 burst_size;
+	enum dma_slave_buswidth slave_bw;
+
+	if (!tdc->config_init) {
+		dev_err(tdc2dev(tdc), "dma channel is not configured\n");
+		return NULL;
+	}
+	if (sg_len < 1) {
+		dev_err(tdc2dev(tdc), "Invalid segment length %d\n", sg_len);
+		return NULL;
+	}
+
+	INIT_LIST_HEAD(&req_list);
+
+	ahb_seq = AHBSEQ_INTR_ENB;
+	ahb_seq |= AHBSEQ_WRAP_NONE << AHBSEQ_WRAP_SHIFT;
+	ahb_seq |= AHBSEQ_BUS_WIDTH_32;
+
+	csr = CSR_ONCE | CSR_FLOW;
+	csr |= tdc->dma_sconfig.slave_id << CSR_REQ_SEL_SHIFT;
+	if (flags & DMA_PREP_INTERRUPT)
+		csr |= CSR_IE_EOC;
+
+	apb_seq = APBSEQ_WRAP_WORD_1;
+
+	switch (direction) {
+	case DMA_MEM_TO_DEV:
+		apb_ptr = tdc->dma_sconfig.dst_addr;
+		apb_seq |= get_bus_width(tdc->dma_sconfig.dst_addr_width);
+		burst_size = tdc->dma_sconfig.dst_maxburst;
+		slave_bw = tdc->dma_sconfig.dst_addr_width;
+		csr |= CSR_DIR;
+		break;
+
+	case DMA_DEV_TO_MEM:
+		apb_ptr = tdc->dma_sconfig.src_addr;
+		apb_seq |= get_bus_width(tdc->dma_sconfig.src_addr_width);
+		burst_size = tdc->dma_sconfig.src_maxburst;
+		slave_bw = tdc->dma_sconfig.src_addr_width;
+		break;
+	default:
+		dev_err(tdc2dev(tdc), "Dma direction is not supported\n");
+		return NULL;
+	}
+
+	dma_desc = tegra_dma_desc_get(tdc);
+	if (!dma_desc) {
+		dev_err(tdc2dev(tdc), "Dma descriptors not available\n");
+		return NULL;
+	}
+	INIT_LIST_HEAD(&dma_desc->tx_list);
+	INIT_LIST_HEAD(&dma_desc->cb_node);
+	dma_desc->bytes_requested = 0;
+	dma_desc->bytes_transferred = 0;
+	dma_desc->dma_status = DMA_IN_PROGRESS;
+
+	/* Make transfer requests */
+	for_each_sg(sgl, sg, sg_len, i) {
+		u32 len, mem;
+
+		mem = sg_phys(sg);
+		len = sg_dma_len(sg);
+
+		if ((len & 3) || (mem & 3) ||
+				(len > tdc->tdma->chip_data->max_dma_count)) {
+			dev_err(tdc2dev(tdc),
+				"Dma length/memory address is not supported\n");
+			tegra_dma_desc_put(tdc, dma_desc);
+			return NULL;
+		}
+
+		sg_req = tegra_dma_sg_req_get(tdc);
+		if (!sg_req) {
+			dev_err(tdc2dev(tdc), "Dma sg-req not available\n");
+			tegra_dma_desc_put(tdc, dma_desc);
+			return NULL;
+		}
+
+		ahb_seq |= get_burst_size(tdc, burst_size, slave_bw, len);
+		dma_desc->bytes_requested += len;
+
+		sg_req->ch_regs.apb_ptr = apb_ptr;
+		sg_req->ch_regs.ahb_ptr = mem;
+		sg_req->ch_regs.csr = csr | ((len - 4) & 0xFFFC);
+		sg_req->ch_regs.apb_seq = apb_seq;
+		sg_req->ch_regs.ahb_seq = ahb_seq;
+		sg_req->configured = false;
+		sg_req->last_sg = false;
+		sg_req->dma_desc = dma_desc;
+		sg_req->req_len = len;
+
+		list_add_tail(&sg_req->node, &dma_desc->tx_list);
+	}
+	sg_req->last_sg = true;
+	dma_desc->ack_reqd = false;
+	if (flags & DMA_CTRL_ACK) {
+		dma_desc->ack_reqd = true;
+		dma_desc->txd.flags = DMA_CTRL_ACK;
+	}
+
+	/*
+	 * Make sure that mode should not be conflicting with currently
+	 * configured mode.
+	 */
+	if (!tdc->isr_handler) {
+		tdc->isr_handler = handle_once_dma_done;
+		tdc->cyclic = false;
+	} else {
+		if (tdc->cyclic) {
+			dev_err(tdc2dev(tdc), "DMA configured in cyclic mode");
+			tegra_dma_desc_put(tdc, dma_desc);
+			return NULL;
+		}
+	}
+
+	return &dma_desc->txd;
+}
+
+struct dma_async_tx_descriptor *tegra_dma_prep_dma_cyclic(
+	struct dma_chan *dc, dma_addr_t buf_addr, size_t buf_len,
+	size_t period_len, enum dma_transfer_direction direction,
+	void *context)
+{
+	struct tegra_dma_channel *tdc = to_tegra_dma_chan(dc);
+	struct tegra_dma_desc *dma_desc = NULL;
+	struct tegra_dma_sg_req  *sg_req = NULL;
+	unsigned long csr, ahb_seq, apb_ptr, apb_seq;
+	int len;
+	size_t remain_len;
+	dma_addr_t mem = buf_addr;
+	u32 burst_size;
+	enum dma_slave_buswidth slave_bw;
+
+	if (!buf_len || !period_len) {
+		dev_err(tdc2dev(tdc), "Invalid buffer/period len");
+		return NULL;
+	}
+
+	if (!tdc->config_init) {
+		dev_err(tdc2dev(tdc), "DMA slave is not configured");
+		return NULL;
+	}
+
+	/*
+	 * We allow to take more number of requests till DMA is
+	 * not started. The driver will loop over all requests.
+	 * Once DMA is started then new requests can be queued only after
+	 * terminating the dma.
+	 */
+	if (tdc->busy) {
+		dev_err(tdc2dev(tdc), "Request not allowed when dma running");
+		return NULL;
+	}
+
+	/*
+	 * We only support cycle transfer when buf_len is multiple of
+	 * period_len.
+	 */
+	if (buf_len % period_len) {
+		dev_err(tdc2dev(tdc), "buf_len is not multiple of period_len");
+		return NULL;
+	}
+
+	len = period_len;
+	if ((len & 3) || (buf_addr & 3) ||
+			(len > tdc->tdma->chip_data->max_dma_count)) {
+		dev_err(tdc2dev(tdc), "Req len/mem address is not correct");
+		return NULL;
+	}
+
+	ahb_seq = AHBSEQ_INTR_ENB;
+	ahb_seq |= AHBSEQ_WRAP_NONE << AHBSEQ_WRAP_SHIFT;
+	ahb_seq |= AHBSEQ_BUS_WIDTH_32;
+
+	csr = CSR_FLOW | CSR_IE_EOC;
+	csr |= tdc->dma_sconfig.slave_id << CSR_REQ_SEL_SHIFT;
+
+	apb_seq = APBSEQ_WRAP_WORD_1;
+
+	switch (direction) {
+	case DMA_MEM_TO_DEV:
+		apb_ptr = tdc->dma_sconfig.dst_addr;
+		apb_seq |= get_bus_width(tdc->dma_sconfig.dst_addr_width);
+		burst_size = tdc->dma_sconfig.dst_maxburst;
+		slave_bw = tdc->dma_sconfig.dst_addr_width;
+		csr |= CSR_DIR;
+		break;
+
+	case DMA_DEV_TO_MEM:
+		apb_ptr = tdc->dma_sconfig.src_addr;
+		apb_seq |= get_bus_width(tdc->dma_sconfig.src_addr_width);
+		burst_size = tdc->dma_sconfig.src_maxburst;
+		slave_bw = tdc->dma_sconfig.src_addr_width;
+		break;
+	default:
+		dev_err(tdc2dev(tdc), "Dma direction is not supported\n");
+		return NULL;
+	}
+
+	dma_desc = tegra_dma_desc_get(tdc);
+	if (!dma_desc) {
+		dev_err(tdc2dev(tdc), "not enough descriptors available\n");
+		return NULL;
+	}
+
+	INIT_LIST_HEAD(&dma_desc->tx_list);
+
+	dma_desc->bytes_transferred = 0;
+	dma_desc->bytes_requested = buf_len;
+	remain_len = buf_len;
+
+	while (remain_len) {
+		sg_req = tegra_dma_sg_req_get(tdc);
+		if (!sg_req) {
+			dev_err(tdc2dev(tdc), "Dma sg-req not available\n");
+			tegra_dma_desc_put(tdc, dma_desc);
+			return NULL;
+		}
+
+		ahb_seq |= get_burst_size(tdc, burst_size, slave_bw, len);
+		sg_req->ch_regs.apb_ptr = apb_ptr;
+		sg_req->ch_regs.ahb_ptr = mem;
+		sg_req->ch_regs.csr = csr | ((len - 4) & 0xFFFC);
+		sg_req->ch_regs.apb_seq = apb_seq;
+		sg_req->ch_regs.ahb_seq = ahb_seq;
+		sg_req->configured = false;
+		sg_req->half_done = false;
+		sg_req->last_sg = false;
+		sg_req->dma_desc = dma_desc;
+		sg_req->req_len = len;
+
+		list_add_tail(&sg_req->node, &dma_desc->tx_list);
+		remain_len -= len;
+		mem += len;
+	}
+	sg_req->last_sg = true;
+	dma_desc->ack_reqd = true;
+	dma_desc->txd.flags = DMA_CTRL_ACK;
+
+	/*
+	 * Make sure that mode should not be conflicting with currently
+	 * configured mode.
+	 */
+	if (!tdc->isr_handler) {
+		tdc->isr_handler = handle_cont_sngl_cycle_dma_done;
+		tdc->cyclic = true;
+	} else {
+		if (!tdc->cyclic) {
+			dev_err(tdc2dev(tdc), "DMA configuration conflict");
+			tegra_dma_desc_put(tdc, dma_desc);
+			return NULL;
+		}
+	}
+
+	return &dma_desc->txd;
+}
+
+static int tegra_dma_alloc_chan_resources(struct dma_chan *dc)
+{
+	struct tegra_dma_channel *tdc = to_tegra_dma_chan(dc);
+	int total_desc;
+
+	total_desc = tegra_dma_allocate_desc(tdc, TEGRA_APBDMA_NR_DESCS,
+			TEGRA_APBDMA_NR_DESCS * TEGRA_APBDMA_NR_REQ_PER_DESC);
+	dma_cookie_init(&tdc->dma_chan);
+	dev_dbg(tdc2dev(tdc), "Allocated %d descriptors\n", total_desc);
+	tdc->config_init = false;
+	return total_desc;
+}
+
+static void tegra_dma_free_chan_resources(struct dma_chan *dc)
+{
+	struct tegra_dma_channel *tdc = to_tegra_dma_chan(dc);
+
+	struct tegra_dma_desc *dma_desc;
+	struct tegra_dma_sg_req *sg_req;
+	struct list_head dma_desc_list;
+	struct list_head sg_req_list;
+	unsigned long flags;
+
+	INIT_LIST_HEAD(&dma_desc_list);
+	INIT_LIST_HEAD(&sg_req_list);
+
+	dev_dbg(tdc2dev(tdc), "Freeing channel %d", tdc->id);
+
+	if (tdc->busy)
+		tegra_dma_terminate_all(dc);
+
+	spin_lock_irqsave(&tdc->lock, flags);
+	list_splice_init(&tdc->pending_sg_req, &sg_req_list);
+	list_splice_init(&tdc->free_sg_req, &sg_req_list);
+	list_splice_init(&tdc->free_dma_desc, &dma_desc_list);
+	list_splice_init(&tdc->wait_ack_dma_desc, &dma_desc_list);
+	INIT_LIST_HEAD(&tdc->cb_desc);
+	tdc->descs_allocated = 0;
+	tdc->config_init = false;
+	spin_unlock_irqrestore(&tdc->lock, flags);
+
+	while (!list_empty(&dma_desc_list)) {
+		dma_desc = list_first_entry(&dma_desc_list,
+					typeof(*dma_desc), node);
+		list_del(&dma_desc->node);
+		kfree(dma_desc);
+	}
+
+	while (!list_empty(&sg_req_list)) {
+		sg_req = list_first_entry(&sg_req_list, typeof(*sg_req), node);
+		list_del(&sg_req->node);
+		kfree(sg_req);
+	}
+}
+
+/* Tegra20 specific DMA controller information */
+static struct tegra_dma_chip_data tegra20_dma_chip_data = {
+	.nr_channels		= 16,
+	.max_dma_count		= 1024UL * 64,
+};
+
+#if defined(CONFIG_OF)
+/* Tegra30 specific DMA controller information */
+static struct tegra_dma_chip_data tegra30_dma_chip_data = {
+	.nr_channels		= 32,
+	.max_dma_count		= 1024UL * 64,
+};
+
+static const struct of_device_id tegra_dma_of_match[] __devinitconst = {
+	{
+		.compatible = "nvidia,tegra30-apbdma-new",
+		.data = &tegra30_dma_chip_data,
+	}, {
+		.compatible = "nvidia,tegra20-apbdma-new",
+		.data = &tegra20_dma_chip_data,
+	}, {
+	},
+};
+MODULE_DEVICE_TABLE(of, tegra_dma_of_match);
+#endif
+
+static int __devinit tegra_dma_probe(struct platform_device *pdev)
+{
+	struct resource	*res;
+	struct tegra_dma *tdma;
+	int ret;
+	int i;
+	struct tegra_dma_chip_data *cdata = NULL;
+
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+		match = of_match_device(of_match_ptr(tegra_dma_of_match),
+					&pdev->dev);
+		if (!match) {
+			dev_err(&pdev->dev, "Error: No device match found\n");
+			return -ENODEV;
+		}
+		cdata = match->data;
+	} else {
+		/* If no device tree then fallback to tegra20 */
+		cdata = &tegra20_dma_chip_data;
+	}
+
+	tdma = devm_kzalloc(&pdev->dev, sizeof(*tdma) + cdata->nr_channels *
+			sizeof(struct tegra_dma_channel), GFP_KERNEL);
+	if (!tdma) {
+		dev_err(&pdev->dev, "Error: memory allocation failed\n");
+		return -ENOMEM;
+	}
+
+	tdma->dev = &pdev->dev;
+	tdma->chip_data = cdata;
+	platform_set_drvdata(pdev, tdma);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "No mem resource for DMA\n");
+		return -EINVAL;
+	}
+
+	tdma->base_addr = devm_request_and_ioremap(&pdev->dev, res);
+	if (!tdma->base_addr) {
+		dev_err(&pdev->dev,
+			"Cannot request memregion/iomap dma address\n");
+		return -EADDRNOTAVAIL;
+	}
+
+	tdma->dma_clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(tdma->dma_clk)) {
+		dev_err(&pdev->dev, "Error: Missing controller clock");
+		return PTR_ERR(tdma->dma_clk);
+	}
+
+	spin_lock_init(&tdma->global_lock);
+
+	pm_runtime_enable(&pdev->dev);
+	if (!pm_runtime_enabled(&pdev->dev)) {
+		ret = tegra_dma_runtime_resume(&pdev->dev);
+		if (ret) {
+			dev_err(&pdev->dev, "dma_runtime_resume failed %d",
+				ret);
+			goto err_pm_disable;
+		}
+	}
+
+	/* Reset DMA controller */
+	tegra_periph_reset_assert(tdma->dma_clk);
+	tegra_periph_reset_deassert(tdma->dma_clk);
+
+	/* Enable global DMA registers */
+	tdma_write(tdma, TEGRA_APBDMA_GENERAL, GEN_ENABLE);
+	tdma_write(tdma, TEGRA_APBDMA_CONTROL, 0);
+	tdma_write(tdma, TEGRA_APBDMA_IRQ_MASK_SET, 0xFFFFFFFFul);
+
+	INIT_LIST_HEAD(&tdma->dma_dev.channels);
+	for (i = 0; i < cdata->nr_channels; i++) {
+		struct tegra_dma_channel *tdc = &tdma->channels[i];
+		char irq_name[30];
+
+		tdc->chan_base_offset = TEGRA_APBDMA_CHANNEL_BASE_ADD_OFFSET +
+					i * TEGRA_APBDMA_CHANNEL_REGISTER_SIZE;
+
+		res = platform_get_resource(pdev, IORESOURCE_IRQ, i);
+		if (!res) {
+			ret = -EINVAL;
+			dev_err(&pdev->dev, "No irq resource for chan %d", i);
+			goto err_irq;
+		}
+		tdc->irq = res->start;
+		snprintf(irq_name, sizeof(irq_name), "apbdma.%d", i);
+		ret = devm_request_irq(&pdev->dev, tdc->irq,
+				tegra_dma_isr, 0, irq_name, tdc);
+		if (ret) {
+			dev_err(&pdev->dev,
+				"request_irq failed with err %d channel %d\n",
+				i, ret);
+			goto err_irq;
+		}
+
+		tdc->dma_chan.device = &tdma->dma_dev;
+		dma_cookie_init(&tdc->dma_chan);
+		list_add_tail(&tdc->dma_chan.device_node,
+				&tdma->dma_dev.channels);
+		tdc->tdma = tdma;
+		tdc->id = i;
+
+		tasklet_init(&tdc->tasklet, tegra_dma_tasklet,
+				(unsigned long)tdc);
+		spin_lock_init(&tdc->lock);
+
+		INIT_LIST_HEAD(&tdc->pending_sg_req);
+		INIT_LIST_HEAD(&tdc->free_sg_req);
+		INIT_LIST_HEAD(&tdc->free_dma_desc);
+		INIT_LIST_HEAD(&tdc->wait_ack_dma_desc);
+		INIT_LIST_HEAD(&tdc->cb_desc);
+	}
+
+	dma_cap_set(DMA_SLAVE, tdma->dma_dev.cap_mask);
+	dma_cap_set(DMA_PRIVATE, tdma->dma_dev.cap_mask);
+	tdma->dma_dev.dev = &pdev->dev;
+	tdma->dma_dev.device_alloc_chan_resources =
+					tegra_dma_alloc_chan_resources;
+	tdma->dma_dev.device_free_chan_resources =
+					tegra_dma_free_chan_resources;
+	tdma->dma_dev.device_prep_slave_sg = tegra_dma_prep_slave_sg;
+	tdma->dma_dev.device_prep_dma_cyclic = tegra_dma_prep_dma_cyclic;
+	tdma->dma_dev.device_control = tegra_dma_device_control;
+	tdma->dma_dev.device_tx_status = tegra_dma_tx_status;
+	tdma->dma_dev.device_issue_pending = tegra_dma_issue_pending;
+
+	ret = dma_async_device_register(&tdma->dma_dev);
+	if (ret < 0) {
+		dev_err(&pdev->dev,
+			"Tegra APB DMA driver registration failed %d", ret);
+		goto err_irq;
+	}
+	dev_info(&pdev->dev, "Tegra APB DMA Controller, %d channels registered",
+			cdata->nr_channels);
+	return 0;
+
+err_irq:
+	while (--i >= 0) {
+		struct tegra_dma_channel *tdc = &tdma->channels[i];
+		tasklet_kill(&tdc->tasklet);
+	}
+
+err_pm_disable:
+	pm_runtime_disable(&pdev->dev);
+	clk_put(tdma->dma_clk);
+	return ret;
+}
+
+static int __devexit tegra_dma_remove(struct platform_device *pdev)
+{
+	struct tegra_dma *tdma = platform_get_drvdata(pdev);
+	int i;
+	struct tegra_dma_channel *tdc;
+
+	dma_async_device_unregister(&tdma->dma_dev);
+
+	for (i = 0; i < tdma->chip_data->nr_channels; ++i) {
+		tdc = &tdma->channels[i];
+		tasklet_kill(&tdc->tasklet);
+	}
+
+	pm_runtime_disable(&pdev->dev);
+	if (!pm_runtime_status_suspended(&pdev->dev))
+		tegra_dma_runtime_suspend(&pdev->dev);
+
+	clk_put(tdma->dma_clk);
+
+	return 0;
+}
+
+static int tegra_dma_runtime_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct tegra_dma *tdma = platform_get_drvdata(pdev);
+
+	clk_disable(tdma->dma_clk);
+	return 0;
+}
+
+static int tegra_dma_runtime_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct tegra_dma *tdma = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = clk_enable(tdma->dma_clk);
+	if (ret < 0) {
+		dev_err(dev, "clk_enable failed: %d\n", ret);
+		return ret;
+	}
+	return 0;
+}
+
+static int tegra_dma_suspend_noirq(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct tegra_dma *tdma = platform_get_drvdata(pdev);
+
+	/* Store the global config register */
+	tdma->reg_gen = tdma_read(tdma, TEGRA_APBDMA_GENERAL);
+
+	tegra_dma_runtime_suspend(dev);
+	return 0;
+}
+
+static int tegra_dma_resume_noirq(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct tegra_dma *tdma = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = tegra_dma_runtime_resume(dev);
+	if (ret < 0) {
+		dev_err(dev, "dma runtime_resume failed %d\n", ret);
+		return ret;
+	}
+
+	/* Restore config register */
+	tdma_write(tdma, TEGRA_APBDMA_GENERAL, tdma->reg_gen);
+	tdma_write(tdma, TEGRA_APBDMA_CONTROL, 0);
+	tdma_write(tdma, TEGRA_APBDMA_IRQ_MASK_SET, 0xFFFFFFFFul);
+	return 0;
+}
+
+static const struct dev_pm_ops tegra_dma_dev_pm_ops __devinitconst = {
+	.suspend_noirq = tegra_dma_suspend_noirq,
+	.resume_noirq = tegra_dma_resume_noirq,
+#ifdef CONFIG_PM_RUNTIME
+	.runtime_suspend = tegra_dma_runtime_suspend,
+	.runtime_resume = tegra_dma_runtime_resume,
+#endif
+};
+
+static struct platform_driver tegra_dmac_driver = {
+	.driver = {
+		.name	= "tegra30-apbdma",
+		.owner = THIS_MODULE,
+		.pm	= &tegra_dma_dev_pm_ops,
+		.of_match_table = of_match_ptr(tegra_dma_of_match),
+	},
+	.probe		= tegra_dma_probe,
+	.remove		= __devexit_p(tegra_dma_remove),
+};
+
+static int __init tegra_dmac_init(void)
+{
+	return platform_driver_register(&tegra_dmac_driver);
+}
+arch_initcall_sync(tegra_dmac_init);
+
+static void __exit tegra_dmac_exit(void)
+{
+	platform_driver_unregister(&tegra_dmac_driver);
+}
+module_exit(tegra_dmac_exit);
+
+MODULE_DESCRIPTION("NVIDIA Tegra APB DMA Controller driver");
+MODULE_AUTHOR("Laxman Dewangan <ldewangan@nvidia.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:tegra-apbdma");
-- 
1.7.1.1

