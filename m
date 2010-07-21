Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933684Ab0GUH7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 03:59:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:14886 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933339Ab0GUH7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 03:59:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,237,1278313200"; 
   d="scan'208";a="302557752"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        linus.ml.walleij@gmail.com
Cc: Vinod Koul <vinod.koul@intel.com>, Alan Cox <alan@linux.intel.com>
Subject: Resend [PATCH] intel_mid: Add Mrst & Mfld DMA Drivers
Date: Wed, 21 Jul 2010 13:28:10 +0530
Message-Id: <1279699090-26032-1-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dan,

The second rev of patch fixes the comments recieved last time.
I have also cleaned up the driver and few more cosmetic changes

This patch add DMA drivers for DMA controllers in Langwell chipset
of Intel(R) Moorestown platform and DMA controllers in Penwell of
Intel(R) Medfield platfrom

This patch adds support for Moorestown DMAC1 and DMAC2 controllers.
It also add support for Medfiled GP DMA and DMAC1 controllers.
These controllers supports memory to peripheral and peripheral to
memory transfers. It support only single block transfers.

This driver is based on Kernel DMA engine
Anyone who wishes to use this controller should use DMA engine APIs

This controller exposes DMA_SLAVE capabilities and notifies the client drivers
of DMA transaction completion

Config option required to be enabled CONFIG_INTEL_MID_DMAC=y

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/dma/Kconfig              |   13 +
 drivers/dma/Makefile             |    1 +
 drivers/dma/intel_mid_dma.c      | 1143 ++++++++++++++++++++++++++++++++++++++
 drivers/dma/intel_mid_dma_regs.h |  260 +++++++++
 include/linux/intel_mid_dma.h    |   86 +++
 5 files changed, 1503 insertions(+), 0 deletions(-)
 create mode 100644 drivers/dma/intel_mid_dma.c
 create mode 100644 drivers/dma/intel_mid_dma_regs.h
 create mode 100644 include/linux/intel_mid_dma.h

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 9e01e96..6a3e5bf 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -33,6 +33,19 @@ if DMADEVICES
 
 comment "DMA Devices"
 
+config INTEL_MID_DMAC
+	tristate "Intel MID DMA support for Peripheral DMA controllers"
+	depends on PCI && X86
+	select DMA_ENGINE
+	default n
+	help
+	  Enable support for the Intel(R) MID DMA engine present
+	  in Intel MID chipsets.
+
+	  Say Y here if you have such a chipset.
+
+	  If unsure, say N.
+
 config ASYNC_TX_DISABLE_CHANNEL_SWITCH
 	bool
 
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index 0fe5ebb..27b6c69 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -7,6 +7,7 @@ endif
 
 obj-$(CONFIG_DMA_ENGINE) += dmaengine.o
 obj-$(CONFIG_NET_DMA) += iovlock.o
+obj-$(CONFIG_INTEL_MID_DMAC) += intel_mid_dma.o
 obj-$(CONFIG_DMATEST) += dmatest.o
 obj-$(CONFIG_INTEL_IOATDMA) += ioat/
 obj-$(CONFIG_INTEL_IOP_ADMA) += iop-adma.o
diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
new file mode 100644
index 0000000..ece354c
--- /dev/null
+++ b/drivers/dma/intel_mid_dma.c
@@ -0,0 +1,1143 @@
+/*
+ *  intel_mid_dma.c - Intel Langwell DMA Drivers
+ *
+ *  Copyright (C) 2008-10 Intel Corp
+ *  Author: Vinod Koul <vinod.koul@intel.com>
+ *  The driver design is based on dw_dmac driver
+ *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *
+ */
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+#include <linux/intel_mid_dma.h>
+
+#define MAX_CHAN	4 /*max ch across controllers*/
+#include "intel_mid_dma_regs.h"
+
+#define INTEL_MID_DMAC1_ID		0x0814
+#define INTEL_MID_DMAC2_ID		0x0813
+#define INTEL_MID_GP_DMAC2_ID		0x0827
+#define INTEL_MFLD_DMAC1_ID		0x0830
+#define LNW_PERIPHRAL_MASK_BASE		0xFFAE8008
+#define LNW_PERIPHRAL_MASK_SIZE		0x10
+#define LNW_PERIPHRAL_STATUS		0x0
+#define LNW_PERIPHRAL_MASK		0x8
+
+struct intel_mid_dma_probe_info {
+	u8 max_chan;
+	u8 ch_base;
+	u16 block_size;
+	u32 pimr_mask;
+};
+
+#define INFO(_max_chan, _ch_base, _block_size, _pimr_mask) \
+	((kernel_ulong_t)&(struct intel_mid_dma_probe_info) {	\
+		.max_chan = (_max_chan),			\
+		.ch_base = (_ch_base),				\
+		.block_size = (_block_size),			\
+		.pimr_mask = (_pimr_mask),			\
+	})
+
+/*****************************************************************************
+Utility Functions*/
+/**
+ * get_ch_index	-	convert status to channel
+ * @status: status mask
+ * @base: dma ch base value
+ *
+ * Modify the status mask and return the channel index needing
+ * attention (or -1 if neither)
+ */
+static int get_ch_index(int *status, unsigned int base)
+{
+	int i;
+	for (i = 0; i < MAX_CHAN; i++) {
+		if (*status & (1 << (i + base))) {
+			*status = *status & ~(1 << (i + base));
+			pr_debug("MDMA: index %d New status %x\n", i, *status);
+			return i;
+		}
+	}
+	return -1;
+}
+
+/**
+ * get_block_ts	-	calculates dma transaction length
+ * @len: dma transfer length
+ * @tx_width: dma transfer src width
+ * @block_size: dma controller max block size
+ *
+ * Based on src width calculate the DMA trsaction length in data items
+ * return data items or FFFF if exceeds max length for block
+ */
+static int get_block_ts(int len, int tx_width, int block_size)
+{
+	int byte_width = 0, block_ts = 0;
+
+	switch (tx_width) {
+	case LNW_DMA_WIDTH_8BIT:
+		byte_width = 1;
+		break;
+	case LNW_DMA_WIDTH_16BIT:
+		byte_width = 2;
+		break;
+	case LNW_DMA_WIDTH_32BIT:
+	default:
+		byte_width = 4;
+		break;
+	}
+
+	block_ts = len/byte_width;
+	if (block_ts > block_size)
+		block_ts = 0xFFFF;
+	return block_ts;
+}
+
+/*****************************************************************************
+DMAC1 interrupt Functions*/
+
+/**
+ * dmac1_mask_periphral_intr -	mask the periphral interrupt
+ * @midc: dma channel for which masking is required
+ *
+ * Masks the DMA periphral interrupt
+ * this is valid for DMAC1 family controllers only
+ * This controller should have periphral mask registers already mapped
+ */
+static void dmac1_mask_periphral_intr(struct intel_mid_dma_chan *midc)
+{
+	u32 pimr;
+	struct middma_device *mid = to_middma_device(midc->chan.device);
+
+	if (mid->pimr_mask) {
+		pimr = readl(mid->mask_reg + LNW_PERIPHRAL_MASK);
+		pimr |= mid->pimr_mask;
+		writel(pimr, mid->mask_reg + LNW_PERIPHRAL_MASK);
+	}
+	return;
+}
+
+/**
+ * dmac1_unmask_periphral_intr -	unmask the periphral interrupt
+ * @midc: dma channel for which masking is required
+ *
+ * UnMasks the DMA periphral interrupt,
+ * this is valid for DMAC1 family controllers only
+ * This controller should have periphral mask registers already mapped
+ */
+static void dmac1_unmask_periphral_intr(struct intel_mid_dma_chan *midc)
+{
+	u32 pimr;
+	struct middma_device *mid = to_middma_device(midc->chan.device);
+
+	if (mid->pimr_mask) {
+		pimr = readl(mid->mask_reg + LNW_PERIPHRAL_MASK);
+		pimr &= ~mid->pimr_mask;
+		writel(pimr, mid->mask_reg + LNW_PERIPHRAL_MASK);
+	}
+	return;
+}
+
+/**
+ * enable_dma_interrupt -	enable the periphral interrupt
+ * @midc: dma channel for which enable interrupt is required
+ *
+ * Enable the DMA periphral interrupt,
+ * this is valid for DMAC1 family controllers only
+ * This controller should have periphral mask registers already mapped
+ */
+static void enable_dma_interrupt(struct intel_mid_dma_chan *midc)
+{
+	dmac1_unmask_periphral_intr(midc);
+
+	/*en ch interrupts*/
+	iowrite32(UNMASK_INTR_REG(midc->ch_id), midc->dma_base + MASK_TFR);
+	iowrite32(UNMASK_INTR_REG(midc->ch_id), midc->dma_base + MASK_ERR);
+	return;
+}
+
+/**
+ * disable_dma_interrupt -	disable the periphral interrupt
+ * @midc: dma channel for which disable interrupt is required
+ *
+ * Disable the DMA periphral interrupt,
+ * this is valid for DMAC1 family controllers only
+ * This controller should have periphral mask registers already mapped
+ */
+static void disable_dma_interrupt(struct intel_mid_dma_chan *midc)
+{
+	/*Check LPE PISR, make sure fwd is disabled*/
+	dmac1_mask_periphral_intr(midc);
+	iowrite32(MASK_INTR_REG(midc->ch_id), midc->dma_base + MASK_BLOCK);
+	iowrite32(MASK_INTR_REG(midc->ch_id), midc->dma_base + MASK_TFR);
+	iowrite32(MASK_INTR_REG(midc->ch_id), midc->dma_base + MASK_ERR);
+	return;
+}
+
+/*****************************************************************************
+DMA channel helper Functions*/
+/**
+ * mid_desc_get		-	get a descriptor
+ * @midc: dma channel for which descriptor is required
+ *
+ * Obtain a descriptor for the channel. Returns NULL if none are free.
+ * Once the descriptor is returned it is private until put on another
+ * list or freed
+ */
+static struct intel_mid_dma_desc *midc_desc_get(struct intel_mid_dma_chan *midc)
+{
+	struct intel_mid_dma_desc *desc, *_desc;
+	struct intel_mid_dma_desc *ret = NULL;
+
+	spin_lock_bh(&midc->lock);
+	list_for_each_entry_safe(desc, _desc, &midc->free_list, desc_node) {
+		if (async_tx_test_ack(&desc->txd)) {
+			list_del(&desc->desc_node);
+			ret = desc;
+			break;
+		}
+	}
+	spin_unlock_bh(&midc->lock);
+	return ret;
+}
+
+/**
+ * mid_desc_put		-	put a descriptor
+ * @midc: dma channel for which descriptor is required
+ * @desc: descriptor to put
+ *
+ * Return a descriptor from lwn_desc_get back to the free pool
+ */
+static void midc_desc_put(struct intel_mid_dma_chan *midc,
+			struct intel_mid_dma_desc *desc)
+{
+	if (desc) {
+		spin_lock_bh(&midc->lock);
+		list_add_tail(&desc->desc_node, &midc->free_list);
+		spin_unlock_bh(&midc->lock);
+	}
+}
+/**
+ * midc_dostart		-		begin a DMA transaction
+ * @midc: channel for which txn is to be started
+ * @first: first descriptor of series
+ *
+ * Load a transaction into the engine. This must be called with midc->lock
+ * held and bh disabled.
+ */
+static void midc_dostart(struct intel_mid_dma_chan *midc,
+			struct intel_mid_dma_desc *first)
+{
+	struct middma_device *mid = to_middma_device(midc->chan.device);
+
+	/*  channel is idle */
+	if (midc->in_use && test_ch_en(midc->dma_base, midc->ch_id)) {
+		/*error*/
+		pr_err("ERR_MDMA: channel is busy in start\n");
+		/* The tasklet will hopefully advance the queue... */
+		return;
+	}
+
+	/*write registers and en*/
+	iowrite32(first->sar, midc->ch_regs + SAR);
+	iowrite32(first->dar, midc->ch_regs + DAR);
+	iowrite32(first->cfg_hi, midc->ch_regs + CFG_HIGH);
+	iowrite32(first->cfg_lo, midc->ch_regs + CFG_LOW);
+	iowrite32(first->ctl_lo, midc->ch_regs + CTL_LOW);
+	iowrite32(first->ctl_hi, midc->ch_regs + CTL_HIGH);
+	pr_debug("MDMA:TX SAR %x,DAR %x,CFGL %x,CFGH %x,CTLH %x, CTLL %x\n",
+		(int)first->sar, (int)first->dar, first->cfg_hi,
+		first->cfg_lo, first->ctl_hi, first->ctl_lo);
+
+	iowrite32(ENABLE_CHANNEL(midc->ch_id), mid->dma_base + DMA_CHAN_EN);
+	first->status = DMA_IN_PROGRESS;
+}
+
+/**
+ * midc_descriptor_complete	-	process completed descriptor
+ * @midc: channel owning the descriptor
+ * @desc: the descriptor itself
+ *
+ * Process a completed descriptor and perform any callbacks upon
+ * the completion. The completion handling drops the lock during the
+ * callbacks but must be called with the lock held.
+ */
+static void midc_descriptor_complete(struct intel_mid_dma_chan *midc,
+	       struct intel_mid_dma_desc *desc)
+{
+	struct dma_async_tx_descriptor	*txd = &desc->txd;
+	dma_async_tx_callback callback_txd = NULL;
+	void *param_txd = NULL;
+
+	midc->completed = txd->cookie;
+	callback_txd = txd->callback;
+	param_txd = txd->callback_param;
+
+	list_move(&desc->desc_node, &midc->free_list);
+
+	spin_unlock_bh(&midc->lock);
+	if (callback_txd) {
+		pr_debug("MDMA: TXD callback set ... calling\n");
+		callback_txd(param_txd);
+		spin_lock_bh(&midc->lock);
+		return;
+	}
+	spin_lock_bh(&midc->lock);
+
+}
+/**
+ * midc_scan_descriptors -		check the descriptors in channel
+ *					mark completed when tx is completete
+ * @mid: device
+ * @midc: channel to scan
+ *
+ * Walk the descriptor chain for the device and process any entries
+ * that are complete.
+ */
+static void midc_scan_descriptors(struct middma_device *mid,
+				struct intel_mid_dma_chan *midc)
+{
+	struct intel_mid_dma_desc *desc = NULL, *_desc = NULL;
+
+	/*tx is complete*/
+	list_for_each_entry_safe(desc, _desc, &midc->active_list, desc_node) {
+		if (desc->status == DMA_IN_PROGRESS)  {
+			desc->status = DMA_SUCCESS;
+			midc_descriptor_complete(midc, desc);
+		}
+	}
+	return;
+}
+
+/*****************************************************************************
+DMA engine callback Functions*/
+/**
+ * intel_mid_dma_tx_submit -	callback to submit DMA transaction
+ * @tx: dma engine descriptor
+ *
+ * Submit the DMA trasaction for this descriptor, start if ch idle
+ */
+static dma_cookie_t intel_mid_dma_tx_submit(struct dma_async_tx_descriptor *tx)
+{
+	struct intel_mid_dma_desc	*desc = to_intel_mid_dma_desc(tx);
+	struct intel_mid_dma_chan	*midc = to_intel_mid_dma_chan(tx->chan);
+	dma_cookie_t		cookie;
+
+	spin_lock_bh(&midc->lock);
+	cookie = midc->chan.cookie;
+
+	if (++cookie < 0)
+		cookie = 1;
+
+	midc->chan.cookie = cookie;
+	desc->txd.cookie = cookie;
+
+
+	if (list_empty(&midc->active_list)) {
+		midc_dostart(midc, desc);
+		list_add_tail(&desc->desc_node, &midc->active_list);
+	} else {
+		list_add_tail(&desc->desc_node, &midc->queue);
+	}
+	spin_unlock_bh(&midc->lock);
+
+	return cookie;
+}
+
+/**
+ * intel_mid_dma_issue_pending -	callback to issue pending txn
+ * @chan: chan where pending trascation needs to be checked and submitted
+ *
+ * Call for scan to issue pending descriptors
+ */
+static void intel_mid_dma_issue_pending(struct dma_chan *chan)
+{
+	struct intel_mid_dma_chan	*midc = to_intel_mid_dma_chan(chan);
+
+	spin_lock_bh(&midc->lock);
+	if (!list_empty(&midc->queue))
+		midc_scan_descriptors(to_middma_device(chan->device), midc);
+	spin_unlock_bh(&midc->lock);
+}
+
+/**
+ * intel_mid_dma_tx_status -	Return status of txn
+ * @chan: chan for where status needs to be checked
+ * @cookie: cookie for txn
+ * @txstate: DMA txn state
+ *
+ * Return status of DMA txn
+ */
+static enum dma_status intel_mid_dma_tx_status(struct dma_chan *chan,
+						dma_cookie_t cookie,
+						struct dma_tx_state *txstate)
+{
+	struct intel_mid_dma_chan	*midc = to_intel_mid_dma_chan(chan);
+	dma_cookie_t		last_used;
+	dma_cookie_t		last_complete;
+	int				ret;
+
+	last_complete = midc->completed;
+	last_used = chan->cookie;
+
+	ret = dma_async_is_complete(cookie, last_complete, last_used);
+	if (ret != DMA_SUCCESS) {
+		midc_scan_descriptors(to_middma_device(chan->device), midc);
+
+		last_complete = midc->completed;
+		last_used = chan->cookie;
+
+		ret = dma_async_is_complete(cookie, last_complete, last_used);
+	}
+
+	if (txstate) {
+		txstate->last = last_complete;
+		txstate->used = last_used;
+		txstate->residue = 0;
+	}
+	return ret;
+}
+
+/**
+ * intel_mid_dma_device_control -	DMA device control
+ * @chan: chan for DMA control
+ * @cmd: control cmd
+ * @arg: cmd arg value
+ *
+ * Perform DMA control command
+ */
+static int intel_mid_dma_device_control(struct dma_chan *chan,
+			enum dma_ctrl_cmd cmd, unsigned long arg)
+{
+	struct intel_mid_dma_chan	*midc = to_intel_mid_dma_chan(chan);
+	struct middma_device	*mid = to_middma_device(chan->device);
+	struct intel_mid_dma_desc	*desc, *_desc;
+	LIST_HEAD(list);
+
+	if (cmd != DMA_TERMINATE_ALL)
+		return -ENXIO;
+
+	spin_lock_bh(&midc->lock);
+	if (midc->in_use == false) {
+		spin_unlock_bh(&midc->lock);
+		return 0;
+	}
+	list_splice_init(&midc->free_list, &list);
+	midc->descs_allocated = 0;
+	midc->slave = NULL;
+
+	/* Disable interrupts */
+	disable_dma_interrupt(midc);
+
+	spin_unlock_bh(&midc->lock);
+	list_for_each_entry_safe(desc, _desc, &list, desc_node) {
+		pr_debug("MDMA: freeing descriptor %p\n", desc);
+		pci_pool_free(mid->dma_pool, desc, desc->txd.phys);
+	}
+	return 0;
+}
+
+/**
+ * intel_mid_dma_prep_slave_sg -	Prep slave sg txn
+ * @chan: chan for DMA transfer
+ * @sgl: scatter gather list
+ * @sg_len: length of sg txn
+ * @direction: DMA transfer dirtn
+ * @flags: DMA flags
+ *
+ * Do DMA sg txn: NOT supported now
+ */
+static struct dma_async_tx_descriptor *intel_mid_dma_prep_slave_sg(
+			struct dma_chan *chan, struct scatterlist *sgl,
+			unsigned int sg_len, enum dma_data_direction direction,
+			unsigned long flags)
+{
+	/*not supported now*/
+	return NULL;
+}
+
+/**
+ * intel_mid_dma_prep_memcpy -	Prep memcpy txn
+ * @chan: chan for DMA transfer
+ * @dest: destn address
+ * @src: src address
+ * @len: DMA transfer len
+ * @flags: DMA flags
+ *
+ * Perform a DMA memcpy. Note we support slave periphral DMA transfers only
+ * The periphral txn details should be filled in slave structure properly
+ * Returns the descriptor for this txn
+ */
+static struct dma_async_tx_descriptor *intel_mid_dma_prep_memcpy(
+			struct dma_chan *chan, dma_addr_t dest,
+			dma_addr_t src, size_t len, unsigned long flags)
+{
+	struct intel_mid_dma_chan *midc;
+	struct intel_mid_dma_desc *desc = NULL;
+	struct intel_mid_dma_slave *mids;
+	union intel_mid_dma_ctl_lo ctl_lo;
+	union intel_mid_dma_ctl_hi ctl_hi;
+	union intel_mid_dma_cfg_lo cfg_lo;
+	union intel_mid_dma_cfg_hi cfg_hi;
+	enum intel_mid_dma_width width = 0;
+
+	pr_debug("MDMA: Prep for memcpy\n");
+	WARN_ON(!chan);
+	if (!len)
+		return NULL;
+
+	mids = chan->private;
+	WARN_ON(!mids);
+
+	midc = to_intel_mid_dma_chan(chan);
+	WARN_ON(!midc);
+
+	pr_debug("MDMA:called for DMA %x CH %d Length %d\n",
+				midc->dma->pci_id, midc->ch_id, len);
+	pr_debug("MDMA:Cfg passed Mode %x, Dirn %x, HS %x, Width %x\n",
+		mids->cfg_mode, mids->dirn, mids->hs_mode, mids->src_width);
+
+	/*calculate CFG_LO*/
+	if (mids->hs_mode == LNW_DMA_SW_HS) {
+		cfg_lo.cfg_lo = 0;
+		cfg_lo.cfgx.hs_sel_dst = 1;
+		cfg_lo.cfgx.hs_sel_src = 1;
+	} else if (mids->hs_mode == LNW_DMA_HW_HS)
+		cfg_lo.cfg_lo = 0x00000;
+
+	/*calculate CFG_HI*/
+	if (mids->cfg_mode == LNW_DMA_MEM_TO_MEM) {
+		/*SW HS only*/
+		cfg_hi.cfg_hi = 0;
+	} else {
+		cfg_hi.cfg_hi = 0;
+		if (midc->dma->pimr_mask) {
+			cfg_hi.cfgx.protctl = 0x0; /*default value*/
+			cfg_hi.cfgx.fifo_mode = 1;
+			if (mids->dirn == DMA_TO_DEVICE) {
+				cfg_hi.cfgx.src_per = 0;
+				if (mids->device_instance == 0)
+					cfg_hi.cfgx.dst_per = 3;
+				if (mids->device_instance == 1)
+					cfg_hi.cfgx.dst_per = 1;
+			} else if (mids->dirn == DMA_FROM_DEVICE) {
+				if (mids->device_instance == 0)
+					cfg_hi.cfgx.src_per = 2;
+				if (mids->device_instance == 1)
+					cfg_hi.cfgx.src_per = 0;
+				cfg_hi.cfgx.dst_per = 0;
+			}
+		} else {
+			cfg_hi.cfgx.protctl = 0x1; /*default value*/
+			cfg_hi.cfgx.src_per = cfg_hi.cfgx.dst_per =
+					midc->ch_id - midc->dma->chan_base;
+		}
+	}
+
+	/*calculate CTL_HI*/
+	ctl_hi.ctlx.reser = 0;
+	width = mids->src_width;
+
+	ctl_hi.ctlx.block_ts = get_block_ts(len, width, midc->dma->block_size);
+	pr_debug("MDMA:calc len %d for block size %d\n",
+				ctl_hi.ctlx.block_ts, midc->dma->block_size);
+	/*calculate CTL_LO*/
+	ctl_lo.ctl_lo = 0;
+	ctl_lo.ctlx.int_en = 1;
+	ctl_lo.ctlx.dst_tr_width = mids->dst_width;
+	ctl_lo.ctlx.src_tr_width = mids->src_width;
+	ctl_lo.ctlx.dst_msize = mids->src_msize;
+	ctl_lo.ctlx.src_msize = mids->dst_msize;
+
+	if (mids->cfg_mode == LNW_DMA_MEM_TO_MEM) {
+		ctl_lo.ctlx.tt_fc = 0;
+		ctl_lo.ctlx.sinc = 0;
+		ctl_lo.ctlx.dinc = 0;
+	} else {
+		if (mids->dirn == DMA_TO_DEVICE) {
+			ctl_lo.ctlx.sinc = 0;
+			ctl_lo.ctlx.dinc = 2;
+			ctl_lo.ctlx.tt_fc = 1;
+		} else if (mids->dirn == DMA_FROM_DEVICE) {
+			ctl_lo.ctlx.sinc = 2;
+			ctl_lo.ctlx.dinc = 0;
+			ctl_lo.ctlx.tt_fc = 2;
+		}
+	}
+
+	pr_debug("MDMA:Calc CTL LO %x, CTL HI %x, CFG LO %x, CFG HI %x\n",
+		ctl_lo.ctl_lo, ctl_hi.ctl_hi, cfg_lo.cfg_lo, cfg_hi.cfg_hi);
+
+	enable_dma_interrupt(midc);
+
+	desc = midc_desc_get(midc);
+	if (desc == NULL)
+		goto err_desc_get;
+	desc->sar = src;
+	desc->dar = dest ;
+	desc->len = len;
+	desc->cfg_hi = cfg_hi.cfg_hi;
+	desc->cfg_lo = cfg_lo.cfg_lo;
+	desc->ctl_lo = ctl_lo.ctl_lo;
+	desc->ctl_hi = ctl_hi.ctl_hi;
+	desc->width = width;
+	desc->dirn = mids->dirn;
+	return &desc->txd;
+
+err_desc_get:
+	pr_err("ERR_MDMA: Failed to get desc\n");
+	midc_desc_put(midc, desc);
+	return NULL;
+}
+
+/**
+ * intel_mid_dma_free_chan_resources -	Frees dma resources
+ * @chan: chan requiring attention
+ *
+ * Frees the allocated resources on this DMA chan
+ */
+static void intel_mid_dma_free_chan_resources(struct dma_chan *chan)
+{
+	struct intel_mid_dma_chan	*midc = to_intel_mid_dma_chan(chan);
+	struct middma_device	*mid = to_middma_device(chan->device);
+	struct intel_mid_dma_desc	*desc, *_desc;
+
+	if (true == midc->in_use) {
+		/*trying to free ch in use!!!!!*/
+		pr_err("ERR_MDMA: trying to free ch in use\n");
+	}
+
+	spin_lock_bh(&midc->lock);
+	midc->descs_allocated = 0;
+	list_for_each_entry_safe(desc, _desc, &midc->active_list, desc_node) {
+		list_del(&desc->desc_node);
+		pci_pool_free(mid->dma_pool, desc, desc->txd.phys);
+	}
+	list_for_each_entry_safe(desc, _desc, &midc->free_list, desc_node) {
+		list_del(&desc->desc_node);
+		pci_pool_free(mid->dma_pool, desc, desc->txd.phys);
+	}
+	list_for_each_entry_safe(desc, _desc, &midc->queue, desc_node) {
+		list_del(&desc->desc_node);
+		pci_pool_free(mid->dma_pool, desc, desc->txd.phys);
+	}
+	spin_unlock_bh(&midc->lock);
+	midc->in_use = false;
+	/* Disable CH interrupts */
+	iowrite32(MASK_INTR_REG(midc->ch_id), mid->dma_base + MASK_BLOCK);
+	iowrite32(MASK_INTR_REG(midc->ch_id), mid->dma_base + MASK_ERR);
+}
+
+/**
+ * intel_mid_dma_alloc_chan_resources -	Allocate dma resources
+ * @chan: chan requiring attention
+ *
+ * Allocates DMA resources on this chan
+ * Return the descriptors allocated
+ */
+static int intel_mid_dma_alloc_chan_resources(struct dma_chan *chan)
+{
+	struct intel_mid_dma_chan	*midc = to_intel_mid_dma_chan(chan);
+	struct middma_device	*mid = to_middma_device(chan->device);
+	struct intel_mid_dma_desc	*desc;
+	dma_addr_t		phys;
+	int	i = 0;
+
+
+	/* ASSERT:  channel is idle */
+	if (test_ch_en(mid->dma_base, midc->ch_id)) {
+		/*ch is not idle*/
+		pr_err("ERR_MDMA: ch not idle\n");
+		return -EIO;
+	}
+	midc->completed = chan->cookie = 1;
+
+	spin_lock_bh(&midc->lock);
+	while (midc->descs_allocated < DESCS_PER_CHANNEL) {
+		spin_unlock_bh(&midc->lock);
+		desc = pci_pool_alloc(mid->dma_pool, GFP_KERNEL, &phys);
+		if (!desc) {
+			pr_err("ERR_MDMA: desc failed\n");
+			return -ENOMEM;
+			/*check*/
+		}
+		dma_async_tx_descriptor_init(&desc->txd, chan);
+		desc->txd.tx_submit = intel_mid_dma_tx_submit;
+		desc->txd.flags = DMA_CTRL_ACK;
+		desc->txd.phys = phys;
+		spin_lock_bh(&midc->lock);
+		i = ++midc->descs_allocated;
+		list_add_tail(&desc->desc_node, &midc->free_list);
+	}
+	spin_unlock_bh(&midc->lock);
+	midc->in_use = false;
+	pr_debug("MID_DMA: Desc alloc done ret: %d desc\n", i);
+	return i;
+}
+
+/**
+ * midc_handle_error -	Handle DMA txn error
+ * @mid: controller where error occured
+ * @midc: chan where error occured
+ *
+ * Scan the descriptor for error
+ */
+static void midc_handle_error(struct middma_device *mid,
+		struct intel_mid_dma_chan *midc)
+{
+	midc_scan_descriptors(mid, midc);
+}
+
+/**
+ * dma_tasklet -	DMA interrupt tasklet
+ * @data: tasklet arg (the controller structure)
+ *
+ * Scan the controller for interrupts for completion/error
+ * Clear the interrupt and call for handling completion/error
+ */
+static void dma_tasklet(unsigned long data)
+{
+	struct middma_device *mid = NULL;
+	struct intel_mid_dma_chan *midc = NULL;
+	u32 status;
+	int i;
+
+	mid = (struct middma_device *)data;
+	if (mid == NULL) {
+		pr_err("ERR_MDMA: tasklet Null param\n");
+		return;
+	}
+	pr_debug("MDMA: in tasklet for device %x\n", mid->pci_id);
+	status = ioread32(mid->dma_base + RAW_TFR);
+	pr_debug("MDMA:RAW_TFR %x\n", status);
+	status &= mid->intr_mask;
+	while (status) {
+		/*txn interrupt*/
+		i = get_ch_index(&status, mid->chan_base);
+		if (i < 0) {
+			pr_err("ERR_MDMA:Invalid ch index %x\n", i);
+			return;
+		}
+		midc = &mid->ch[i];
+		if (midc == NULL) {
+			pr_err("ERR_MDMA:Null param midc\n");
+			return;
+		}
+		pr_debug("MDMA:Tx complete interrupt %x, Ch No %d Index %d\n",
+				status, midc->ch_id, i);
+		/*clearing this interrupts first*/
+		iowrite32((1 << midc->ch_id), mid->dma_base + CLEAR_TFR);
+		iowrite32((1 << midc->ch_id), mid->dma_base + CLEAR_BLOCK);
+
+		spin_lock_bh(&midc->lock);
+		midc_scan_descriptors(mid, midc);
+		pr_debug("MDMA:Scan of desc... complete, unmasking\n");
+		iowrite32(UNMASK_INTR_REG(midc->ch_id),
+				mid->dma_base + MASK_TFR);
+		spin_unlock_bh(&midc->lock);
+	}
+
+	status = ioread32(mid->dma_base + RAW_ERR);
+	status &= mid->intr_mask;
+	while (status) {
+		/*err interrupt*/
+		i = get_ch_index(&status, mid->chan_base);
+		if (i < 0) {
+			pr_err("ERR_MDMA:Invalid ch index %x\n", i);
+			return;
+		}
+		midc = &mid->ch[i];
+		if (midc == NULL) {
+			pr_err("ERR_MDMA:Null param midc\n");
+			return;
+		}
+		pr_debug("MDMA:Tx complete interrupt %x, Ch No %d Index %d\n",
+				status, midc->ch_id, i);
+
+		iowrite32((1 << midc->ch_id), mid->dma_base + CLEAR_ERR);
+		spin_lock_bh(&midc->lock);
+		midc_handle_error(mid, midc);
+		iowrite32(UNMASK_INTR_REG(midc->ch_id),
+				mid->dma_base + MASK_ERR);
+		spin_unlock_bh(&midc->lock);
+	}
+	pr_debug("MDMA:Exiting takslet...\n");
+	return;
+}
+
+static void dma_tasklet1(unsigned long data)
+{
+	pr_debug("MDMA:in takslet1...\n");
+	return dma_tasklet(data);
+}
+
+static void dma_tasklet2(unsigned long data)
+{
+	pr_debug("MDMA:in takslet2...\n");
+	return dma_tasklet(data);
+}
+
+/**
+ * intel_mid_dma_interrupt -	DMA ISR
+ * @irq: IRQ where interrupt occurred
+ * @data: ISR cllback data (the controller structure)
+ *
+ * See if this is our interrupt if so then schedule the tasklet
+ * otherwise ignore
+ */
+static irqreturn_t intel_mid_dma_interrupt(int irq, void *data)
+{
+	struct middma_device *mid = data;
+	u32 status;
+	int call_tasklet = 0;
+
+	/*DMA Interrupt*/
+	pr_debug("MDMA:Got an interrupt on irq %d\n", irq);
+	if (!mid) {
+		pr_err("ERR_MDMA:null pointer mid\n");
+		return -EINVAL;
+	}
+
+	status = ioread32(mid->dma_base + RAW_TFR);
+	pr_debug("MDMA: Status %x, Mask %x\n", status, mid->intr_mask);
+	status &= mid->intr_mask;
+	if (status) {
+		/*need to disable intr*/
+		iowrite32((status << 8), mid->dma_base + MASK_TFR);
+		pr_debug("MDMA: Calling tasklet %x\n", status);
+		call_tasklet = 1;
+	}
+	status = ioread32(mid->dma_base + RAW_ERR);
+	status &= mid->intr_mask;
+	if (status) {
+		iowrite32(MASK_INTR_REG(status), mid->dma_base + MASK_ERR);
+		call_tasklet = 1;
+	}
+	if (call_tasklet)
+		tasklet_schedule(&mid->tasklet);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t intel_mid_dma_interrupt1(int irq, void *data)
+{
+	return intel_mid_dma_interrupt(irq, data);
+}
+
+static irqreturn_t intel_mid_dma_interrupt2(int irq, void *data)
+{
+	return intel_mid_dma_interrupt(irq, data);
+}
+
+/**
+ * mid_setup_dma -	Setup the DMA controller
+ * @pdev: Controller PCI device structure
+ *
+ * Initilize the DMA controller, channels, registers with DMA engine,
+ * ISR. Initilize DMA controller channels.
+ */
+static int mid_setup_dma(struct pci_dev *pdev)
+{
+	struct middma_device *dma = pci_get_drvdata(pdev);
+	int err, i;
+	unsigned int irq_level;
+
+	/* DMA coherent memory pool for DMA descriptor allocations */
+	dma->dma_pool = pci_pool_create("intel_mid_dma_desc_pool", pdev,
+					sizeof(struct intel_mid_dma_desc),
+					32, 0);
+	if (NULL == dma->dma_pool) {
+		pr_err("ERR_MDMA:pci_pool_create failed\n");
+		err = -ENOMEM;
+		kfree(dma);
+		goto err_dma_pool;
+	}
+
+	INIT_LIST_HEAD(&dma->common.channels);
+	dma->pci_id = pdev->device;
+	if (dma->pimr_mask) {
+		dma->mask_reg = ioremap(LNW_PERIPHRAL_MASK_BASE,
+					LNW_PERIPHRAL_MASK_SIZE);
+		if (dma->mask_reg == NULL) {
+			pr_err("ERR_MDMA:Cant map periphral intr space !!\n");
+			return -ENOMEM;
+		}
+	} else
+		dma->mask_reg = NULL;
+
+	pr_debug("MDMA:Adding %d channel for this controller\n", dma->max_chan);
+	/*init CH structures*/
+	dma->intr_mask = 0;
+	for (i = 0; i < dma->max_chan; i++) {
+		struct intel_mid_dma_chan *midch = &dma->ch[i];
+
+		midch->chan.device = &dma->common;
+		midch->chan.cookie =  1;
+		midch->chan.chan_id = i;
+		midch->ch_id = dma->chan_base + i;
+		pr_debug("MDMA:Init CH %d, ID %d\n", i, midch->ch_id);
+
+		midch->dma_base = dma->dma_base;
+		midch->ch_regs = dma->dma_base + DMA_CH_SIZE * midch->ch_id;
+		midch->dma = dma;
+		dma->intr_mask |= 1 << (dma->chan_base + i);
+		spin_lock_init(&midch->lock);
+
+		INIT_LIST_HEAD(&midch->active_list);
+		INIT_LIST_HEAD(&midch->queue);
+		INIT_LIST_HEAD(&midch->free_list);
+		/*mask interrupts*/
+		iowrite32(MASK_INTR_REG(midch->ch_id),
+			dma->dma_base + MASK_BLOCK);
+		iowrite32(MASK_INTR_REG(midch->ch_id),
+			dma->dma_base + MASK_SRC_TRAN);
+		iowrite32(MASK_INTR_REG(midch->ch_id),
+			dma->dma_base + MASK_DST_TRAN);
+		iowrite32(MASK_INTR_REG(midch->ch_id),
+			dma->dma_base + MASK_ERR);
+		iowrite32(MASK_INTR_REG(midch->ch_id),
+			dma->dma_base + MASK_TFR);
+
+		disable_dma_interrupt(midch);
+		list_add_tail(&midch->chan.device_node, &dma->common.channels);
+	}
+	pr_debug("MDMA: Calc Mask as %x for this controller\n", dma->intr_mask);
+
+	/*init dma structure*/
+	dma_cap_zero(dma->common.cap_mask);
+	dma_cap_set(DMA_MEMCPY, dma->common.cap_mask);
+	dma_cap_set(DMA_SLAVE, dma->common.cap_mask);
+	dma_cap_set(DMA_PRIVATE, dma->common.cap_mask);
+	dma->common.dev = &pdev->dev;
+	dma->common.chancnt = dma->max_chan;
+
+	dma->common.device_alloc_chan_resources =
+					intel_mid_dma_alloc_chan_resources;
+	dma->common.device_free_chan_resources =
+					intel_mid_dma_free_chan_resources;
+
+	dma->common.device_tx_status = intel_mid_dma_tx_status;
+	dma->common.device_prep_dma_memcpy = intel_mid_dma_prep_memcpy;
+	dma->common.device_issue_pending = intel_mid_dma_issue_pending;
+	dma->common.device_prep_slave_sg = intel_mid_dma_prep_slave_sg;
+	dma->common.device_control = intel_mid_dma_device_control;
+
+	/*enable dma cntrl*/
+	iowrite32(REG_BIT0, dma->dma_base + DMA_CFG);
+
+	/*register irq */
+	if (dma->pimr_mask) {
+		irq_level = IRQF_SHARED;
+		pr_debug("MDMA:Requesting irq shared for DMAC1\n");
+		err = request_irq(pdev->irq, intel_mid_dma_interrupt1,
+			IRQF_SHARED, "INTEL_MID_DMAC1", dma);
+		if (0 != err)
+			goto err_irq;
+	} else {
+		dma->intr_mask = 0x03;
+		irq_level = 0;
+		pr_debug("MDMA:Requesting irq for DMAC2\n");
+		err = request_irq(pdev->irq, intel_mid_dma_interrupt2,
+			0, "INTEL_MID_DMAC2", dma);
+		if (0 != err)
+			goto err_irq;
+	}
+	/*register device w/ engine*/
+	err = dma_async_device_register(&dma->common);
+	if (0 != err) {
+		pr_err("ERR_MDMA:device_register failed: %d\n", err);
+		goto err_engine;
+	}
+	if (dma->pimr_mask) {
+		pr_debug("setting up tasklet1 for DMAC1\n");
+		tasklet_init(&dma->tasklet, dma_tasklet1, (unsigned long)dma);
+	} else {
+		pr_debug("setting up tasklet2 for DMAC2\n");
+		tasklet_init(&dma->tasklet, dma_tasklet2, (unsigned long)dma);
+	}
+	return 0;
+
+err_engine:
+	free_irq(pdev->irq, dma);
+err_irq:
+	pci_pool_destroy(dma->dma_pool);
+	kfree(dma);
+err_dma_pool:
+	pr_err("ERR_MDMA:setup_dma failed: %d\n", err);
+	return err;
+
+}
+
+/**
+ * middma_shutdown -	Shutdown the DMA controller
+ * @pdev: Controller PCI device structure
+ *
+ * Called by remove
+ * Unregister DMa controller, clear all structures and free interrupt
+ */
+static void middma_shutdown(struct pci_dev *pdev)
+{
+	struct middma_device *device = pci_get_drvdata(pdev);
+
+	dma_async_device_unregister(&device->common);
+	pci_pool_destroy(device->dma_pool);
+	if (device->mask_reg)
+		iounmap(device->mask_reg);
+	if (device->dma_base)
+		iounmap(device->dma_base);
+	free_irq(pdev->irq, device);
+	return;
+}
+
+/**
+ * intel_mid_dma_probe -	PCI Probe
+ * @pdev: Controller PCI device structure
+ * @id: pci device id structure
+ *
+ * Initilize the PCI device, map BARs, query driver data.
+ * Call setup_dma to complete contoller and chan initilzation
+ */
+static int __devinit intel_mid_dma_probe(struct pci_dev *pdev,
+					const struct pci_device_id *id)
+{
+	struct middma_device *device;
+	u32 base_addr, bar_size;
+	struct intel_mid_dma_probe_info *info;
+	int err;
+
+	pr_debug("MDMA: probe for %x\n", pdev->device);
+	info = (void *)id->driver_data;
+	pr_debug("MDMA: CH %d, base %d, block len %d, Periphral mask %x\n",
+				info->max_chan, info->ch_base,
+				info->block_size, info->pimr_mask);
+
+	err = pci_enable_device(pdev);
+	if (err)
+		goto err_enable_device;
+
+	err = pci_request_regions(pdev, "intel_mid_dmac");
+	if (err)
+		goto err_request_regions;
+
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	if (err)
+		goto err_set_dma_mask;
+
+	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+	if (err)
+		goto err_set_dma_mask;
+
+	device = kzalloc(sizeof(*device), GFP_KERNEL);
+	if (!device) {
+		pr_err("ERR_MDMA:kzalloc failed probe\n");
+		err = -ENOMEM;
+		goto err_kzalloc;
+	}
+	device->pdev = pci_dev_get(pdev);
+
+	base_addr = pci_resource_start(pdev, 0);
+	bar_size  = pci_resource_len(pdev, 0);
+	device->dma_base = ioremap_nocache(base_addr, DMA_REG_SIZE);
+	if (!device->dma_base) {
+		pr_err("ERR_MDMA:ioremap failed\n");
+		err = -ENOMEM;
+		goto err_ioremap;
+	}
+	pci_set_drvdata(pdev, device);
+	pci_set_master(pdev);
+	device->max_chan = info->max_chan;
+	device->chan_base = info->ch_base;
+	device->block_size = info->block_size;
+	device->pimr_mask = info->pimr_mask;
+
+	err = mid_setup_dma(pdev);
+	if (err)
+		goto err_dma;
+
+	return 0;
+
+err_dma:
+	iounmap(device->dma_base);
+err_ioremap:
+	pci_dev_put(pdev);
+	kfree(device);
+err_kzalloc:
+err_set_dma_mask:
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+err_request_regions:
+err_enable_device:
+	pr_err("ERR_MDMA:Probe failed %d\n", err);
+	return err;
+}
+
+/**
+ * intel_mid_dma_remove -	PCI remove
+ * @pdev: Controller PCI device structure
+ *
+ * Free up all resources and data
+ * Call shutdown_dma to complete contoller and chan cleanup
+ */
+static void __devexit intel_mid_dma_remove(struct pci_dev *pdev)
+{
+	struct middma_device *device = pci_get_drvdata(pdev);
+	middma_shutdown(pdev);
+	pci_dev_put(pdev);
+	kfree(device);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+}
+
+/******************************************************************************
+* PCI stuff
+*/
+static struct pci_device_id intel_mid_dma_ids[] = {
+	{ PCI_VDEVICE(INTEL, INTEL_MID_DMAC1_ID),	INFO(2, 6, 4095, 0x200020)},
+	{ PCI_VDEVICE(INTEL, INTEL_MID_DMAC2_ID),	INFO(2, 0, 2047, 0)},
+	{ PCI_VDEVICE(INTEL, INTEL_MID_GP_DMAC2_ID),	INFO(2, 0, 2047, 0)},
+	{ PCI_VDEVICE(INTEL, INTEL_MFLD_DMAC1_ID),	INFO(4, 0, 4095, 0x400040)},
+	{ 0, }
+};
+MODULE_DEVICE_TABLE(pci, intel_mid_dma_ids);
+
+static struct pci_driver intel_mid_dma_pci = {
+	.name		=	"Intel MID DMA",
+	.id_table	=	intel_mid_dma_ids,
+	.probe		=	intel_mid_dma_probe,
+	.remove		=	__devexit_p(intel_mid_dma_remove),
+};
+
+static int __init intel_mid_dma_init(void)
+{
+	pr_debug("INFO_MDMA: LNW DMA Driver Version %s\n",
+			INTEL_MID_DMA_DRIVER_VERSION);
+	return pci_register_driver(&intel_mid_dma_pci);
+}
+fs_initcall(intel_mid_dma_init);
+
+static void __exit intel_mid_dma_exit(void)
+{
+	pci_unregister_driver(&intel_mid_dma_pci);
+}
+module_exit(intel_mid_dma_exit);
+
+MODULE_AUTHOR("Vinod Koul <vinod.koul@intel.com>");
+MODULE_DESCRIPTION("Intel (R) MID DMAC Driver");
+MODULE_LICENSE("GPL v2");
+MODULE_VERSION(INTEL_MID_DMA_DRIVER_VERSION);
diff --git a/drivers/dma/intel_mid_dma_regs.h b/drivers/dma/intel_mid_dma_regs.h
new file mode 100644
index 0000000..d81aa65
--- /dev/null
+++ b/drivers/dma/intel_mid_dma_regs.h
@@ -0,0 +1,260 @@
+/*
+ *  intel_mid_dma_regs.h - Intel MID DMA Drivers
+ *
+ *  Copyright (C) 2008-10 Intel Corp
+ *  Author: Vinod Koul <vinod.koul@intel.com>
+ *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *
+ */
+#ifndef __INTEL_MID_DMAC_REGS_H__
+#define __INTEL_MID_DMAC_REGS_H__
+
+#include <linux/dmaengine.h>
+#include <linux/dmapool.h>
+#include <linux/pci_ids.h>
+
+#define INTEL_MID_DMA_DRIVER_VERSION "1.0.5"
+
+#define	REG_BIT0		0x00000001
+#define	REG_BIT8		0x00000100
+
+#define UNMASK_INTR_REG(chan_num) \
+	((REG_BIT0 << chan_num) | (REG_BIT8 << chan_num))
+#define MASK_INTR_REG(chan_num) (REG_BIT8 << chan_num)
+
+#define ENABLE_CHANNEL(chan_num) \
+	((REG_BIT0 << chan_num) | (REG_BIT8 << chan_num))
+
+#define DESCS_PER_CHANNEL	16
+/*DMA Registers*/
+/*registers associated with channel programming*/
+#define DMA_REG_SIZE		0x400
+#define DMA_CH_SIZE		0x58
+
+/*CH X REG = (DMA_CH_SIZE)*CH_NO + REG*/
+#define SAR			0x00 /* Source Address Register*/
+#define DAR			0x08 /* Destination Address Register*/
+#define CTL_LOW			0x18 /* Control Register*/
+#define CTL_HIGH		0x1C /* Control Register*/
+#define CFG_LOW			0x40 /* Configuration Register Low*/
+#define CFG_HIGH		0x44 /* Configuration Register high*/
+
+#define STATUS_TFR		0x2E8
+#define STATUS_BLOCK		0x2F0
+#define STATUS_ERR		0x308
+
+#define RAW_TFR			0x2C0
+#define RAW_BLOCK		0x2C8
+#define RAW_ERR			0x2E0
+
+#define MASK_TFR		0x310
+#define MASK_BLOCK		0x318
+#define MASK_SRC_TRAN		0x320
+#define MASK_DST_TRAN		0x328
+#define MASK_ERR		0x330
+
+#define CLEAR_TFR		0x338
+#define CLEAR_BLOCK		0x340
+#define CLEAR_SRC_TRAN		0x348
+#define CLEAR_DST_TRAN		0x350
+#define CLEAR_ERR		0x358
+
+#define INTR_STATUS		0x360
+#define DMA_CFG			0x398
+#define DMA_CHAN_EN		0x3A0
+
+/*DMA channel control registers*/
+union intel_mid_dma_ctl_lo {
+	struct {
+		u32	int_en:1;	/*enable or disable interrupts*/
+					/*should be 0*/
+		u32	dst_tr_width:3;	/*destination transfer width*/
+					/*usually 32 bits = 010*/
+		u32	src_tr_width:3; /*source transfer width*/
+					/*usually 32 bits = 010*/
+		u32	dinc:2;		/*destination address inc/dec*/
+					/*For mem:INC=00, Periphral NoINC=11*/
+		u32	sinc:2;		/*source address inc or dec, as above*/
+		u32	dst_msize:3;	/*destination burst transaction length*/
+					/*always = 16 ie 011*/
+		u32	src_msize:3;	/*source burst transaction length*/
+					/*always = 16 ie 011*/
+		u32	reser1:3;
+		u32	tt_fc:3;	/*transfer type and flow controller*/
+					/*M-M = 000
+					  P-M = 010
+					  M-P = 001*/
+		u32	dms:2;		/*destination master select = 0*/
+		u32	sms:2;		/*source master select = 0*/
+		u32	llp_dst_en:1;	/*enable/disable destination LLP = 0*/
+		u32	llp_src_en:1;	/*enable/disable source LLP = 0*/
+		u32	reser2:3;
+	} ctlx;
+	u32	ctl_lo;
+};
+
+union intel_mid_dma_ctl_hi {
+	struct {
+		u32	block_ts:12;	/*block transfer size*/
+					/*configured by DMAC*/
+		u32	reser:20;
+	} ctlx;
+	u32	ctl_hi;
+
+};
+
+/*DMA channel configuration registers*/
+union intel_mid_dma_cfg_lo {
+	struct {
+		u32	reser1:5;
+		u32	ch_prior:3;	/*channel priority = 0*/
+		u32	ch_susp:1;	/*channel suspend = 0*/
+		u32	fifo_empty:1;	/*FIFO empty or not R bit = 0*/
+		u32	hs_sel_dst:1;	/*select HW/SW destn handshaking*/
+					/*HW = 0, SW = 1*/
+		u32	hs_sel_src:1;	/*select HW/SW src handshaking*/
+		u32	reser2:6;
+		u32	dst_hs_pol:1;	/*dest HS interface polarity*/
+		u32	src_hs_pol:1;	/*src HS interface polarity*/
+		u32	max_abrst:10;	/*max AMBA burst len = 0 (no sw limit*/
+		u32	reload_src:1;	/*auto reload src addr =1 if src is P*/
+		u32	reload_dst:1;	/*AR destn addr =1 if dstn is P*/
+	} cfgx;
+	u32	cfg_lo;
+};
+
+union intel_mid_dma_cfg_hi {
+	struct {
+		u32	fcmode:1;	/*flow control mode = 1*/
+		u32	fifo_mode:1;	/*FIFO mode select = 1*/
+		u32	protctl:3;	/*protection control = 0*/
+		u32	rsvd:2;
+		u32	src_per:4;	/*src hw HS interface*/
+		u32	dst_per:4;	/*dstn hw HS interface*/
+		u32	reser2:17;
+	} cfgx;
+	u32	cfg_hi;
+};
+
+/**
+ * struct intel_mid_dma_chan - internal mid representation of a DMA channel
+ * @chan: dma_chan strcture represetation for mid chan
+ * @ch_regs: MMIO register space pointer to channel register
+ * @dma_base: MMIO register space DMA engine base pointer
+ * @ch_id: DMA channel id
+ * @lock: channel spinlock
+ * @completed: DMA cookie
+ * @active_list: current active descriptors
+ * @queue: current queued up descriptors
+ * @free_list: current free descriptors
+ * @slave: dma slave struture
+ * @descs_allocated: total number of decsiptors allocated
+ * @dma: dma device struture pointer
+ * @in_use: bool representing if ch is in use or not
+ */
+struct intel_mid_dma_chan {
+	struct dma_chan		chan;
+	void __iomem		*ch_regs;
+	void __iomem		*dma_base;
+	int			ch_id;
+	spinlock_t		lock;
+	dma_cookie_t		completed;
+	struct list_head	active_list;
+	struct list_head	queue;
+	struct list_head	free_list;
+	struct intel_mid_dma_slave	*slave;
+	unsigned int		descs_allocated;
+	struct middma_device	*dma;
+	bool			in_use;
+};
+
+static inline struct intel_mid_dma_chan *to_intel_mid_dma_chan(
+						struct dma_chan *chan)
+{
+	return container_of(chan, struct intel_mid_dma_chan, chan);
+}
+
+/**
+ * struct middma_device - internal representation of a DMA device
+ * @pdev: PCI device
+ * @dma_base: MMIO register space pointer of DMA
+ * @dma_pool: for allocating DMA descriptors
+ * @common: embedded struct dma_device
+ * @tasklet: dma tasklet for processing interrupts
+ * @ch: per channel data
+ * @pci_id: DMA device PCI ID
+ * @intr_mask: Interrupt mask to be used
+ * @mask_reg: MMIO register for periphral mask
+ * @chan_base: Base ch index (read from driver data)
+ * @max_chan: max number of chs supported (from drv_data)
+ * @block_size: Block size of DMA transfer supported (from drv_data)
+ * @pimr_mask: MMIO register addr for periphral interrupt (from drv_data)
+ */
+struct middma_device {
+	struct pci_dev		*pdev;
+	void __iomem		*dma_base;
+	struct pci_pool		*dma_pool;
+	struct dma_device	common;
+	struct tasklet_struct   tasklet;
+	struct intel_mid_dma_chan ch[MAX_CHAN];
+	unsigned int		pci_id;
+	unsigned int		intr_mask;
+	void __iomem		*mask_reg;
+	int			chan_base;
+	int			max_chan;
+	int			block_size;
+	unsigned int		pimr_mask;
+};
+
+static inline struct middma_device *to_middma_device(struct dma_device *common)
+{
+	return container_of(common, struct middma_device, common);
+}
+
+struct intel_mid_dma_desc {
+	void __iomem			*block; /*ch ptr*/
+	struct list_head		desc_node;
+	struct dma_async_tx_descriptor	txd;
+	size_t				len;
+	dma_addr_t			sar;
+	dma_addr_t			dar;
+	u32				cfg_hi;
+	u32				cfg_lo;
+	u32				ctl_lo;
+	u32				ctl_hi;
+	dma_addr_t			next;
+	enum dma_data_direction		dirn;
+	enum dma_status			status;
+	enum intel_mid_dma_width	width; /*width of DMA txn*/
+	enum intel_mid_dma_mode		cfg_mode; /*mode configuration*/
+
+};
+
+static inline int test_ch_en(void __iomem *dma, u32 ch_no)
+{
+	u32 en_reg = ioread32(dma + DMA_CHAN_EN);
+	return (en_reg >> ch_no) & 0x1;
+}
+
+static inline struct intel_mid_dma_desc *to_intel_mid_dma_desc
+		(struct dma_async_tx_descriptor *txd)
+{
+	return container_of(txd, struct intel_mid_dma_desc, txd);
+}
+#endif /*__INTEL_MID_DMAC_REGS_H__*/
diff --git a/include/linux/intel_mid_dma.h b/include/linux/intel_mid_dma.h
new file mode 100644
index 0000000..d9d08b6
--- /dev/null
+++ b/include/linux/intel_mid_dma.h
@@ -0,0 +1,86 @@
+/*
+ *  intel_mid_dma.h - Intel MID DMA Drivers
+ *
+ *  Copyright (C) 2008-10 Intel Corp
+ *  Author: Vinod Koul <vinod.koul@intel.com>
+ *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *
+ */
+#ifndef __INTEL_MID_DMA_H__
+#define __INTEL_MID_DMA_H__
+
+#include <linux/dmaengine.h>
+
+/*DMA transaction width, src and dstn width would be same
+The DMA length must be width aligned,
+for 32 bit width the length must be 32 bit (4bytes) aligned only*/
+enum intel_mid_dma_width {
+	LNW_DMA_WIDTH_8BIT = 0x0,
+	LNW_DMA_WIDTH_16BIT = 0x1,
+	LNW_DMA_WIDTH_32BIT = 0x2,
+};
+
+/*DMA mode configurations*/
+enum intel_mid_dma_mode {
+	LNW_DMA_PER_TO_MEM = 0, /*periphral to memory configuration*/
+	LNW_DMA_MEM_TO_PER,	/*memory to periphral configuration*/
+	LNW_DMA_MEM_TO_MEM,	/*mem to mem confg (testing only)*/
+};
+
+/*DMA handshaking*/
+enum intel_mid_dma_hs_mode {
+	LNW_DMA_HW_HS = 0,	/*HW Handshaking only*/
+	LNW_DMA_SW_HS = 1,	/*SW Handshaking not recommended*/
+};
+
+/*Burst size configuration*/
+enum intel_mid_dma_msize {
+	LNW_DMA_MSIZE_1 = 0x0,
+	LNW_DMA_MSIZE_4 = 0x1,
+	LNW_DMA_MSIZE_8 = 0x2,
+	LNW_DMA_MSIZE_16 = 0x3,
+	LNW_DMA_MSIZE_32 = 0x4,
+	LNW_DMA_MSIZE_64 = 0x5,
+};
+
+/**
+ * struct intel_mid_dma_slave - DMA slave structure
+ *
+ * @dirn: DMA trf direction
+ * @src_width: tx register width
+ * @dst_width: rx register width
+ * @hs_mode: HW/SW handshaking mode
+ * @cfg_mode: DMA data transfer mode (per-per/mem-per/mem-mem)
+ * @src_msize: Source DMA burst size
+ * @dst_msize: Dst DMA burst size
+ * @device_instance: DMA peripheral device instance, we can have multiple
+ *		peripheral device connected to single DMAC
+ */
+struct intel_mid_dma_slave {
+	enum dma_data_direction		dirn;
+	enum intel_mid_dma_width	src_width; /*width of DMA src txn*/
+	enum intel_mid_dma_width	dst_width; /*width of DMA dst txn*/
+	enum intel_mid_dma_hs_mode	hs_mode;  /*handshaking*/
+	enum intel_mid_dma_mode		cfg_mode; /*mode configuration*/
+	enum intel_mid_dma_msize	src_msize; /*size if src burst*/
+	enum intel_mid_dma_msize	dst_msize; /*size of dst burst*/
+	unsigned int		device_instance; /*0, 1 for periphral instance*/
+};
+
+#endif /*__INTEL_MID_DMA_H__*/
-- 
1.6.6.1

