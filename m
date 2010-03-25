Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab0CYDRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 23:17:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60515 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab0CYDRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 23:17:18 -0400
Date: Thu, 25 Mar 2010 12:17:15 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH v2] PL330: Add PL330 DMA controller driver
To: dan.j.williams@intel.com
Cc: linus.ml.walleij@gmail.com, kyungmin.park@samsung.com,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-id: <4BAAD5BB.7050101@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
X-OriginalArrivalTime: 25 Mar 2010 03:17:15.0808 (UTC)
 FILETIME=[AB683A00:01CACBC9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PL330 is currently the dma controller using at the S5PC1XX arm SoC.
This supports DMA_MEMCPY and DMA_SLAVE.

The datasheet for the PL330 can find below url:
http://infocenter.arm.com/help/topic/com.arm.doc.ddi0424a/DDI0424A_dmac_pl330_r0p0_trm.pdf

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
Change log:

v2: Convert into an amba_device driver.
    Code clean and update from v1 patch review.

 drivers/dma/Kconfig        |    7 +
 drivers/dma/Makefile       |    1 +
 drivers/dma/pl330_dmac.c   |  900 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/dma/pl330_dmac.h   |  175 +++++++++
 include/linux/amba/pl330.h |   64 ++++
 5 files changed, 1147 insertions(+), 0 deletions(-)
 create mode 100644 drivers/dma/pl330_dmac.c
 create mode 100644 drivers/dma/pl330_dmac.h
 create mode 100644 include/linux/amba/pl330.h

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index c27f80e..5989b6e 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -149,6 +149,13 @@ config AMCC_PPC440SPE_ADMA
 	help
 	  Enable support for the AMCC PPC440SPe RAID engines.
 
+config PL330_DMAC
+	bool "PrimeCell DMA Controller(PL330) support"
+	depends on ARCH_S5PC1XX
+	select DMA_ENGINE
+	help
+	  Enable support for the PrimeCell DMA Controller(PL330) support.
+
 config ARCH_HAS_ASYNC_TX_FIND_CHANNEL
 	bool
 
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index 22bba3d..d98be12 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -20,3 +20,4 @@ obj-$(CONFIG_TXX9_DMAC) += txx9dmac.o
 obj-$(CONFIG_SH_DMAE) += shdma.o
 obj-$(CONFIG_COH901318) += coh901318.o coh901318_lli.o
 obj-$(CONFIG_AMCC_PPC440SPE_ADMA) += ppc4xx/
+obj-$(CONFIG_PL330_DMAC) += pl330_dmac.o
diff --git a/drivers/dma/pl330_dmac.c b/drivers/dma/pl330_dmac.c
new file mode 100644
index 0000000..4427110
--- /dev/null
+++ b/drivers/dma/pl330_dmac.c
@@ -0,0 +1,900 @@
+/*
+ * pl330_dmac.c  --  Driver for PL330 DMA Controller
+ *
+ * Copyright (C) 2009 Samsung Electronics Co.Ltd
+ * Author: Joonyoung Shim <jy0922.shim@samsung.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/dmaengine.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/amba/bus.h>
+#include <linux/amba/pl330.h>
+
+#include "pl330_dmac.h"
+
+#define to_pl330_chan(chan)	container_of(chan, struct pl330_chan, common)
+#define to_pl330_desc(node)	container_of(node, struct pl330_desc, desc_node)
+#define tx_to_pl330_desc(tx)	container_of(tx, struct pl330_desc, async_tx)
+
+/* instruction set functions */
+static inline int pl330_dmaaddh(u8 *desc_pool_virt, u16 imm, bool ra)
+{
+	u8 opcode = DMAADDH | (ra << 1);
+
+	writeb(opcode, desc_pool_virt++);
+	writew(imm, desc_pool_virt);
+	return 3;
+}
+
+static inline int pl330_dmaend(u8 *desc_pool_virt)
+{
+	u8 opcode = DMAEND;
+
+	writeb(opcode, desc_pool_virt);
+	return 1;
+}
+
+static inline int pl330_dmaflushp(u8 *desc_pool_virt, u8 periph)
+{
+	u8 opcode = DMAFLUSHHP;
+
+	writeb(opcode, desc_pool_virt++);
+	writeb(periph << 3, desc_pool_virt);
+	return 2;
+}
+
+static inline int pl330_dmald(u8 *desc_pool_virt)
+{
+	u8 opcode = DMALD;
+
+	writeb(opcode, desc_pool_virt);
+	return 1;
+}
+
+static inline int pl330_dmalds(u8 *desc_pool_virt)
+{
+	u8 opcode = DMALDS;
+
+	writeb(opcode, desc_pool_virt);
+	return 1;
+}
+
+static inline int pl330_dmaldb(u8 *desc_pool_virt)
+{
+	u8 opcode = DMALDB;
+
+	writeb(opcode, desc_pool_virt);
+	return 1;
+}
+
+static inline int pl330_dmaldps(u8 *desc_pool_virt, u8 periph)
+{
+	u8 opcode = DMALDPS;
+
+	writeb(opcode, desc_pool_virt++);
+	writeb(periph << 3, desc_pool_virt);
+	return 2;
+}
+
+static inline int pl330_dmaldpb(u8 *desc_pool_virt, u8 periph)
+{
+	u8 opcode = DMALDPB;
+
+	writeb(opcode, desc_pool_virt++);
+	writeb(periph << 3, desc_pool_virt);
+	return 2;
+}
+
+static inline int pl330_dmalp(u8 *desc_pool_virt, u8 iter, bool lc)
+{
+	u8 opcode = DMALP | (lc << 1);
+
+	writeb(opcode, desc_pool_virt++);
+	writeb(iter, desc_pool_virt);
+	return 2;
+}
+
+static inline int pl330_dmalpend(u8 *desc_pool_virt, u8 backwards_jump, bool lc)
+{
+	u8 opcode = DMALPEND | (lc << 2);
+
+	writeb(opcode, desc_pool_virt++);
+	writeb(backwards_jump, desc_pool_virt);
+	return 2;
+}
+
+static inline int pl330_dmalpends(u8 *desc_pool_virt, u8 backwards_jump,
+		bool lc)
+{
+	u8 opcode = DMALPENDS | (lc << 2);
+
+	writeb(opcode, desc_pool_virt++);
+	writeb(backwards_jump, desc_pool_virt);
+	return 2;
+}
+
+static inline int pl330_dmalpendb(u8 *desc_pool_virt, u8 backwards_jump,
+		bool lc)
+{
+	u8 opcode = DMALPENDB | (lc << 2);
+
+	writeb(opcode, desc_pool_virt++);
+	writeb(backwards_jump, desc_pool_virt);
+	return 2;
+}
+
+static inline int pl330_dmalpfe(u8 *desc_pool_virt, u8 backwards_jump, bool lc)
+{
+	u8 opcode = DMALPFE | (lc << 2);
+
+	writeb(opcode, desc_pool_virt++);
+	writeb(backwards_jump, desc_pool_virt);
+	return 2;
+}
+
+static inline int pl330_dmakill(u8 *desc_pool_virt)
+{
+	u8 opcode = DMAKILL;
+
+	writeb(opcode, desc_pool_virt);
+	return 1;
+}
+
+static inline int pl330_dmamov(u8 *desc_pool_virt, u8 rd, u32 imm)
+{
+	u8 opcode = DMAMOV;
+
+	writeb(opcode, desc_pool_virt++);
+	writeb(rd, desc_pool_virt++);
+	writel(imm, desc_pool_virt);
+	return 6;
+}
+
+static inline int pl330_dmanop(u8 *desc_pool_virt)
+{
+	u8 opcode = DMANOP;
+
+	writeb(opcode, desc_pool_virt);
+	return 1;
+}
+
+static inline int pl330_dmarmb(u8 *desc_pool_virt)
+{
+	u8 opcode = DMARMB;
+
+	writeb(opcode, desc_pool_virt);
+	return 1;
+}
+
+static inline int pl330_dmasev(u8 *desc_pool_virt, u8 event_num)
+{
+	u8 opcode = DMASEV;
+
+	writeb(opcode, desc_pool_virt++);
+	writeb(event_num << 3, desc_pool_virt);
+	return 2;
+}
+
+static inline int pl330_dmast(u8 *desc_pool_virt)
+{
+	u8 opcode = DMAST;
+
+	writeb(opcode, desc_pool_virt);
+	return 1;
+}
+
+static inline int pl330_dmasts(u8 *desc_pool_virt)
+{
+	u8 opcode = DMASTS;
+
+	writeb(opcode, desc_pool_virt);
+	return 1;
+}
+
+static inline int pl330_dmastb(u8 *desc_pool_virt)
+{
+	u8 opcode = DMASTB;
+
+	writeb(opcode, desc_pool_virt);
+	return 1;
+}
+
+static inline int pl330_dmastps(u8 *desc_pool_virt, u8 periph)
+{
+	u8 opcode = DMASTPS;
+
+	writeb(opcode, desc_pool_virt++);
+	writeb(periph << 3, desc_pool_virt);
+	return 2;
+}
+
+static inline int pl330_dmastpb(u8 *desc_pool_virt, u8 periph)
+{
+	u8 opcode = DMASTPB;
+
+	writeb(opcode, desc_pool_virt++);
+	writeb(periph << 3, desc_pool_virt);
+	return 2;
+}
+
+static inline int pl330_dmastz(u8 *desc_pool_virt)
+{
+	u8 opcode = DMASTZ;
+
+	writeb(opcode, desc_pool_virt);
+	return 1;
+}
+
+static inline int pl330_dmawfe(u8 *desc_pool_virt, u8 event_num, bool invalid)
+{
+	u8 opcode = DMAWFE;
+
+	writeb(opcode, desc_pool_virt++);
+	writeb((event_num << 3) | (invalid << 1), desc_pool_virt);
+	return 2;
+}
+
+static inline int pl330_dmawfps(u8 *desc_pool_virt, u8 periph)
+{
+	u8 opcode = DMAWFPS;
+
+	writeb(opcode, desc_pool_virt++);
+	writeb(periph << 3, desc_pool_virt);
+	return 2;
+}
+
+static inline int pl330_dmawfpb(u8 *desc_pool_virt, u8 periph)
+{
+	u8 opcode = DMAWFPB;
+
+	writeb(opcode, desc_pool_virt++);
+	writeb(periph << 3, desc_pool_virt);
+	return 2;
+}
+
+static inline int pl330_dmawfpp(u8 *desc_pool_virt, u8 periph)
+{
+	u8 opcode = DMAWFPP;
+
+	writeb(opcode, desc_pool_virt++);
+	writeb(periph << 3, desc_pool_virt);
+	return 2;
+}
+
+static inline int pl330_dmawmb(u8 *desc_pool_virt)
+{
+	u8 opcode = DMAWMB;
+
+	writeb(opcode, desc_pool_virt);
+	return 1;
+}
+
+static void pl330_dmago(struct pl330_chan *pl330_ch, struct pl330_desc *desc,
+		bool ns)
+{
+	unsigned int val;
+	u8 opcode = DMAGO | (ns << 1);
+
+	val = (pl330_ch->id << 24) | (opcode << 16) | (pl330_ch->id << 8);
+	writel(val, pl330_ch->pl330_dev->reg_base + PL330_DBGINST0);
+
+	val = desc->async_tx.phys;
+	writel(val, pl330_ch->pl330_dev->reg_base + PL330_DBGINST1);
+
+	writel(0, pl330_ch->pl330_dev->reg_base + PL330_DBGCMD);
+}
+
+static void __pl330_terminate_all(struct pl330_chan *pl330_ch)
+{
+	list_splice_init(&pl330_ch->complete_desc, &pl330_ch->free_desc);
+	list_splice_init(&pl330_ch->queue_desc, &pl330_ch->free_desc);
+}
+
+static void pl330_terminate_all(struct dma_chan *chan)
+{
+	struct pl330_chan *pl330_ch = to_pl330_chan(chan);
+
+	/* Before freeing channel resources first check
+	 * if they have been previously allocated for this channel.
+	 */
+	if (pl330_ch->desc_num == 0)
+		return;
+
+	__pl330_terminate_all(pl330_ch);
+}
+
+static dma_cookie_t pl330_tx_submit(struct dma_async_tx_descriptor *tx)
+{
+	struct pl330_chan *pl330_ch = to_pl330_chan(tx->chan);
+	struct pl330_desc *desc = tx_to_pl330_desc(tx);
+	unsigned long flags;
+	dma_cookie_t cookie;
+
+	spin_lock_irqsave(&pl330_ch->lock, flags);
+
+	cookie = pl330_ch->common.cookie;
+
+	if (++cookie < 0)
+		cookie = 1;
+
+	desc->async_tx.cookie = cookie;
+	pl330_ch->common.cookie = cookie;
+
+	list_add_tail(&desc->desc_node, &pl330_ch->queue_desc);
+
+	spin_unlock_irqrestore(&pl330_ch->lock, flags);
+
+	return cookie;
+}
+
+static struct pl330_desc *
+pl330_alloc_descriptor(struct pl330_chan *pl330_ch, gfp_t flags)
+{
+	struct device *dev = pl330_ch->pl330_dev->common.dev;
+	struct pl330_desc *desc;
+	dma_addr_t phys;
+
+	desc = kzalloc(sizeof(*desc), flags);
+	if (!desc)
+		return NULL;
+
+	desc->desc_pool_virt = dma_alloc_coherent(dev, PL330_POOL_SIZE, &phys,
+			flags);
+	if (!desc->desc_pool_virt) {
+		kfree(desc);
+		return NULL;
+	}
+
+	dma_async_tx_descriptor_init(&desc->async_tx, &pl330_ch->common);
+	desc->async_tx.tx_submit = pl330_tx_submit;
+	desc->async_tx.phys = phys;
+
+	return desc;
+}
+
+static struct pl330_desc *pl330_get_descriptor(struct pl330_chan *pl330_ch)
+{
+	struct device *dev = pl330_ch->pl330_dev->common.dev;
+	struct pl330_desc *desc;
+
+	if (!list_empty(&pl330_ch->free_desc)) {
+		desc = to_pl330_desc(pl330_ch->free_desc.next);
+		list_del(&desc->desc_node);
+	} else {
+		/* try to get another desc */
+		desc = pl330_alloc_descriptor(pl330_ch, GFP_ATOMIC);
+		if (!desc) {
+			dev_err(dev, "descriptor alloc failed\n");
+			return NULL;
+		}
+	}
+
+	return desc;
+}
+
+static int pl330_alloc_chan_resources(struct dma_chan *chan)
+{
+	struct pl330_chan *pl330_ch = to_pl330_chan(chan);
+	struct device *dev = pl330_ch->pl330_dev->common.dev;
+	struct pl330_desc *desc;
+	int i;
+	LIST_HEAD(tmp_list);
+
+	/* have we already been set up? */
+	if (!list_empty(&pl330_ch->free_desc))
+		return pl330_ch->desc_num;
+
+	for (i = 0; i < PL330_DESC_NUM; i++) {
+		desc = pl330_alloc_descriptor(pl330_ch, GFP_KERNEL);
+		if (!desc) {
+			dev_err(dev, "Only %d initial descriptors\n", i);
+			break;
+		}
+		list_add_tail(&desc->desc_node, &tmp_list);
+	}
+
+	pl330_ch->completed = chan->cookie = 1;
+	pl330_ch->desc_num = i;
+	list_splice(&tmp_list, &pl330_ch->free_desc);
+
+	return pl330_ch->desc_num;
+}
+
+static void pl330_free_chan_resources(struct dma_chan *chan)
+{
+	struct pl330_chan *pl330_ch = to_pl330_chan(chan);
+	struct device *dev = pl330_ch->pl330_dev->common.dev;
+	struct pl330_desc *desc, *_desc;
+
+	/* Before freeing channel resources first check
+	 * if they have been previously allocated for this channel.
+	 */
+	if (pl330_ch->desc_num == 0)
+		return;
+
+	__pl330_terminate_all(pl330_ch);
+
+	list_for_each_entry_safe(desc, _desc, &pl330_ch->free_desc,
+			desc_node) {
+		list_del(&desc->desc_node);
+		dma_free_coherent(dev, PL330_POOL_SIZE, desc->desc_pool_virt,
+				desc->async_tx.phys);
+		kfree(desc);
+	}
+}
+
+static enum dma_status pl330_is_tx_complete(struct dma_chan *chan,
+		dma_cookie_t cookie, dma_cookie_t *done, dma_cookie_t *used)
+{
+	struct pl330_chan *pl330_ch = to_pl330_chan(chan);
+	dma_cookie_t last_used;
+	dma_cookie_t last_complete;
+	int ret;
+
+	last_complete = pl330_ch->completed;
+	last_used = chan->cookie;
+
+	ret = dma_async_is_complete(cookie, last_complete, last_used);
+
+	return ret;
+}
+
+static void pl330_issue_pending(struct dma_chan *chan)
+{
+	struct pl330_chan *pl330_ch = to_pl330_chan(chan);
+	struct pl330_desc *desc;
+	unsigned int val;
+
+	if (!list_empty(&pl330_ch->queue_desc)) {
+		val = readl(pl330_ch->pl330_dev->reg_base + PL330_DBGSTATUS);
+		if (val == PL330_DBG_BUSY)
+			return;
+
+		desc = to_pl330_desc(pl330_ch->queue_desc.next);
+		list_move_tail(&desc->desc_node, &pl330_ch->complete_desc);
+
+		pl330_dmago(pl330_ch, desc, NS_NONSECURE);
+	}
+}
+
+static unsigned int pl330_make_instructions(struct pl330_chan *pl330_ch,
+		struct pl330_desc *desc, dma_addr_t dest, dma_addr_t src,
+		size_t len, unsigned int inst_size,
+		enum dma_data_direction direction)
+{
+	struct device *dev = pl330_ch->pl330_dev->common.dev;
+	void *buf = desc->desc_pool_virt;
+	u32 control = *(u32 *)&pl330_ch->pl330_reg_cc;
+	unsigned int loop_size;
+	unsigned int loop_size_rest;
+	unsigned int loop_count0;
+	unsigned int loop_count1 = 0;
+	unsigned int loop_count0_rest = 0;
+	unsigned int loop_start0 = 0;
+	unsigned int loop_start1 = 0;
+
+	dev_dbg(dev, "desc_pool_phys: 0x%x\n", desc->async_tx.phys);
+	dev_dbg(dev, "control: 0x%x\n", control);
+	dev_dbg(dev, "dest: 0x%x\n", dest);
+	dev_dbg(dev, "src: 0x%x\n", src);
+	dev_dbg(dev, "len: 0x%x\n", len);
+
+	/* calculate loop count */
+	loop_size = (pl330_ch->pl330_reg_cc.src_burst_len + 1) *
+		(1 << pl330_ch->pl330_reg_cc.src_burst_size);
+	loop_count0 = (len / loop_size) - 1;
+	loop_size_rest = len % loop_size;
+
+	dev_dbg(dev, "loop_size: 0x%x\n", loop_size);
+	dev_dbg(dev, "loop_count0: 0x%x\n", loop_count0);
+	dev_dbg(dev, "loop_size_rest: 0x%x\n", loop_size_rest);
+
+	if (loop_size_rest) {
+		dev_err(dev, "Transfer length must be aligned to loop_size\n");
+		return -EINVAL;
+	}
+
+	if (loop_count0 >= PL330_MAX_LOOPS) {
+		loop_count1 = (loop_count0 / PL330_MAX_LOOPS) - 1;
+		loop_count0_rest = (loop_count0 % PL330_MAX_LOOPS) + 1;
+		loop_count0 = PL330_MAX_LOOPS - 1;
+		dev_dbg(dev, "loop_count0: 0x%x\n", loop_count0);
+		dev_dbg(dev, "loop_count0_rest: 0x%x\n", loop_count0_rest);
+		dev_dbg(dev, "loop_count1: 0x%x\n", loop_count1);
+
+		if (loop_count1 >= PL330_MAX_LOOPS)
+			dev_dbg(dev, "loop_count1 overflow\n");
+	}
+
+	/* write instruction sets on buffer */
+	inst_size += pl330_dmamov(buf + inst_size, RD_DAR, dest);
+	inst_size += pl330_dmamov(buf + inst_size, RD_SAR, src);
+	inst_size += pl330_dmamov(buf + inst_size, RD_CCR, control);
+
+	if (loop_count1) {
+		inst_size += pl330_dmalp(buf + inst_size, loop_count1, LC_1);
+		loop_start1 = inst_size;
+	}
+
+	if (loop_count0) {
+		inst_size += pl330_dmalp(buf + inst_size, loop_count0, LC_0);
+		loop_start0 = inst_size;
+	}
+
+	if (direction == DMA_TO_DEVICE) {
+		struct pl330_dma_slave *dma_slave = pl330_ch->common.private;
+		u8 periph = dma_slave->peri_num;
+		inst_size += pl330_dmawfps(buf + inst_size, periph);
+		inst_size += pl330_dmald(buf + inst_size);
+		inst_size += pl330_dmastps(buf + inst_size, periph);
+		inst_size += pl330_dmaflushp(buf + inst_size, periph);
+	} else if (direction == DMA_FROM_DEVICE) {
+		struct pl330_dma_slave *dma_slave = pl330_ch->common.private;
+		u8 periph = dma_slave->peri_num;
+		inst_size += pl330_dmawfps(buf + inst_size, periph);
+		inst_size += pl330_dmaldps(buf + inst_size, periph);
+		inst_size += pl330_dmast(buf + inst_size);
+		inst_size += pl330_dmaflushp(buf + inst_size, periph);
+	} else {
+		inst_size += pl330_dmald(buf + inst_size);
+		inst_size += pl330_dmarmb(buf + inst_size);
+		inst_size += pl330_dmast(buf + inst_size);
+		inst_size += pl330_dmawmb(buf + inst_size);
+	}
+
+	if (loop_count0)
+		inst_size += pl330_dmalpend(buf + inst_size,
+				inst_size - loop_start0, LC_0);
+
+	if (loop_count1)
+		inst_size += pl330_dmalpend(buf + inst_size,
+				inst_size - loop_start1, LC_1);
+
+	if (loop_count0_rest) {
+		inst_size += pl330_dmalp(buf + inst_size, loop_count0_rest - 1,
+				LC_0);
+		loop_start0 = inst_size;
+
+		if (direction == DMA_TO_DEVICE) {
+			struct pl330_dma_slave *dma_slave =
+				pl330_ch->common.private;
+			u8 periph = dma_slave->peri_num;
+			inst_size += pl330_dmawfps(buf + inst_size, periph);
+			inst_size += pl330_dmald(buf + inst_size);
+			inst_size += pl330_dmastps(buf + inst_size, periph);
+			inst_size += pl330_dmaflushp(buf + inst_size, periph);
+		} else if (direction == DMA_FROM_DEVICE) {
+			struct pl330_dma_slave *dma_slave =
+				pl330_ch->common.private;
+			u8 periph = dma_slave->peri_num;
+			inst_size += pl330_dmawfps(buf + inst_size, periph);
+			inst_size += pl330_dmaldps(buf + inst_size, periph);
+			inst_size += pl330_dmast(buf + inst_size);
+			inst_size += pl330_dmaflushp(buf + inst_size, periph);
+		} else {
+			inst_size += pl330_dmald(buf + inst_size);
+			inst_size += pl330_dmarmb(buf + inst_size);
+			inst_size += pl330_dmast(buf + inst_size);
+			inst_size += pl330_dmawmb(buf + inst_size);
+		}
+
+		inst_size += pl330_dmalpend(buf + inst_size,
+				inst_size - loop_start0, LC_0);
+	}
+
+	inst_size += pl330_dmasev(buf + inst_size, pl330_ch->id);
+	inst_size += pl330_dmaend(buf + inst_size);
+
+	return inst_size;
+}
+
+static struct dma_async_tx_descriptor *
+pl330_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
+		size_t len, unsigned long flags)
+{
+	struct pl330_chan *pl330_ch = to_pl330_chan(chan);
+	struct device *dev = pl330_ch->pl330_dev->common.dev;
+	struct pl330_desc *desc;
+	int inst_size;
+
+	if (!chan || !len)
+		return NULL;
+
+	desc = pl330_get_descriptor(pl330_ch);
+	if (!desc)
+		return NULL;
+
+	inst_size = pl330_make_instructions(pl330_ch, desc, dest, src, len, 0,
+			DMA_NONE);
+	if (inst_size < 0) {
+		dev_err(dev, "Failed to make instructions for memcpy\n");
+		return NULL;
+	}
+
+	desc->async_tx.flags = flags;
+
+	return &desc->async_tx;
+}
+
+static struct dma_async_tx_descriptor *
+pl330_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
+		unsigned int sg_len, enum dma_data_direction direction,
+		unsigned long flags)
+{
+	struct pl330_chan *pl330_ch = to_pl330_chan(chan);
+	struct device *dev = pl330_ch->pl330_dev->common.dev;
+	struct pl330_register_cc *pl330_reg_cc = &pl330_ch->pl330_reg_cc;
+	struct pl330_dma_slave *dma_slave = chan->private;
+	struct pl330_desc *desc;
+	struct scatterlist *sg;
+	int inst_size = 0;
+	int i;
+
+	BUG_ON(!dma_slave);
+
+	if (!dma_slave->tx_reg)
+		BUG_ON(direction == DMA_TO_DEVICE);
+
+	if (!dma_slave->rx_reg)
+		BUG_ON(direction == DMA_FROM_DEVICE);
+
+	if (unlikely(!sg_len))
+		return NULL;
+
+	desc = pl330_get_descriptor(pl330_ch);
+	if (!desc)
+		return NULL;
+
+	for_each_sg(sgl, sg, sg_len, i) {
+		dma_addr_t dest;
+		dma_addr_t src;
+		unsigned int len = sg_dma_len(sg);
+
+		if (direction == DMA_TO_DEVICE) {
+			dest = dma_slave->tx_reg;
+			src = sg_dma_address(sg);
+			pl330_reg_cc->dst_inc = 0;
+		} else {
+			dest = sg_dma_address(sg);
+			src = dma_slave->rx_reg;
+			pl330_reg_cc->src_inc = 0;
+		}
+		pl330_reg_cc->src_burst_size = dma_slave->reg_width;
+		pl330_reg_cc->dst_burst_size = dma_slave->reg_width;
+
+		inst_size = pl330_make_instructions(pl330_ch, desc, dest, src,
+				len, inst_size, direction);
+		if (inst_size < 0) {
+			dev_err(dev, "Failed to make instructions for slave\n");
+			return NULL;
+		}
+	}
+
+	desc->async_tx.flags = flags;
+
+	return &desc->async_tx;
+}
+
+static void pl330_xfer_complete(struct pl330_chan *pl330_ch)
+{
+	struct pl330_desc *desc;
+	dma_async_tx_callback callback;
+	void *callback_param;
+
+	/* execute next desc */
+	pl330_issue_pending(&pl330_ch->common);
+
+	if (list_empty(&pl330_ch->complete_desc))
+		return;
+
+	desc = to_pl330_desc(pl330_ch->complete_desc.next);
+	list_move_tail(&desc->desc_node, &pl330_ch->free_desc);
+
+	pl330_ch->completed = desc->async_tx.cookie;
+
+	callback = desc->async_tx.callback;
+	callback_param = desc->async_tx.callback_param;
+	if (callback)
+		callback(callback_param);
+}
+
+static void pl330_ch_tasklet(unsigned long data)
+{
+	struct pl330_chan *pl330_ch = (struct pl330_chan *)data;
+	unsigned int val;
+
+	pl330_xfer_complete(pl330_ch);
+
+	/* enable channel interrupt */
+	val = readl(pl330_ch->pl330_dev->reg_base + PL330_INTEN);
+	val |= (1 << pl330_ch->id);
+	writel(val, pl330_ch->pl330_dev->reg_base + PL330_INTEN);
+}
+
+static irqreturn_t pl330_irq_handler(int irq, void *data)
+{
+	struct pl330_device *pl330_dev = data;
+	struct pl330_chan *pl330_ch;
+	unsigned int intstatus;
+	unsigned int inten;
+	int i;
+
+	intstatus = readl(pl330_dev->reg_base + PL330_INTSTATUS);
+
+	if (intstatus == 0)
+		return IRQ_HANDLED;
+
+	inten = readl(pl330_dev->reg_base + PL330_INTEN);
+	for (i = 0; i < PL330_MAX_CHANS; i++) {
+		if (intstatus & (1 << i)) {
+			pl330_ch = &pl330_dev->pl330_ch[i];
+			writel(1 << i, pl330_dev->reg_base + PL330_INTCLR);
+
+			/* disable channel interrupt */
+			inten &= ~(1 << i);
+			writel(inten, pl330_dev->reg_base + PL330_INTEN);
+
+			tasklet_schedule(&pl330_ch->tasklet);
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void pl330_reg_cc_init(struct pl330_register_cc *pl330_reg_cc)
+{
+	pl330_reg_cc->src_inc = 0x1;
+	pl330_reg_cc->src_burst_size = 0;
+	pl330_reg_cc->src_burst_len = 0;
+	pl330_reg_cc->src_prot_ctrl = 0x2;
+	pl330_reg_cc->src_cache_ctrl = 0;
+	pl330_reg_cc->dst_inc = 0x1;
+	pl330_reg_cc->dst_burst_size = 0;
+	pl330_reg_cc->dst_burst_len = 0;
+	pl330_reg_cc->dst_prot_ctrl = 0x2;
+	pl330_reg_cc->dst_cache_ctrl = 0;
+	pl330_reg_cc->endian_swqp_size = 0;
+}
+
+static int __devinit pl330_probe(struct amba_device *adev, struct amba_id *id)
+{
+	struct pl330_device *pl330_dev;
+	struct dma_device *dma_dev;
+	struct pl330_platform_data *pdata = adev->dev.platform_data;
+	int err;
+	int i;
+
+	if (!pdata) {
+		dev_err(&adev->dev, "platform data is required!\n");
+		return -EINVAL;
+	}
+
+	pl330_dev = devm_kzalloc(&adev->dev, sizeof(*pl330_dev), GFP_KERNEL);
+	if (!pl330_dev)
+		return -ENOMEM;
+
+	err = amba_request_regions(adev, NULL);
+	if (err)
+		return err;
+
+	pl330_dev->reg_base = devm_ioremap(&adev->dev, adev->res.start,
+			resource_size(&adev->res));
+	if (!pl330_dev->reg_base)
+		return -EBUSY;
+
+	err = devm_request_irq(&adev->dev, adev->irq[0], pl330_irq_handler, 0,
+			dev_name(&adev->dev), pl330_dev);
+	if (err)
+		return err;
+
+	dma_dev = &pl330_dev->common;
+	INIT_LIST_HEAD(&dma_dev->channels);
+
+	/* set base routines */
+	dma_dev->device_alloc_chan_resources = pl330_alloc_chan_resources;
+	dma_dev->device_free_chan_resources = pl330_free_chan_resources;
+	dma_dev->device_is_tx_complete = pl330_is_tx_complete;
+	dma_dev->device_issue_pending = pl330_issue_pending;
+	dma_dev->device_terminate_all = pl330_terminate_all;
+	dma_dev->dev = &adev->dev;
+	dma_dev->cap_mask = pdata->cap_mask;
+
+	/* set prep routines based on capability */
+	if (dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask))
+		dma_dev->device_prep_dma_memcpy = pl330_prep_dma_memcpy;
+	if (dma_has_cap(DMA_SLAVE, dma_dev->cap_mask))
+		dma_dev->device_prep_slave_sg = pl330_prep_slave_sg;
+
+	for (i = 0; i < PL330_MAX_CHANS; i++) {
+		struct pl330_chan *pl330_ch = &pl330_dev->pl330_ch[i];
+		unsigned int val;
+
+		spin_lock_init(&pl330_ch->lock);
+		pl330_ch->id = i;
+		pl330_ch->pl330_dev = pl330_dev;
+		pl330_ch->common.device = dma_dev;
+		tasklet_init(&pl330_ch->tasklet, pl330_ch_tasklet,
+				(unsigned long)pl330_ch);
+		INIT_LIST_HEAD(&pl330_ch->free_desc);
+		INIT_LIST_HEAD(&pl330_ch->queue_desc);
+		INIT_LIST_HEAD(&pl330_ch->complete_desc);
+		list_add_tail(&pl330_ch->common.device_node,
+				&dma_dev->channels);
+		dma_dev->chancnt++;
+		pl330_reg_cc_init(&pl330_ch->pl330_reg_cc);
+		val = readl(pl330_ch->pl330_dev->reg_base + PL330_INTEN);
+		val |= (1 << pl330_ch->id);
+		writel(val, pl330_ch->pl330_dev->reg_base + PL330_INTEN);
+	}
+
+	amba_set_drvdata(adev, pl330_dev);
+
+	dev_info(&adev->dev, "PL330 DMA Controller: ( %s%s)\n",
+		dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask) ? "memcpy " : "",
+		dma_has_cap(DMA_SLAVE, dma_dev->cap_mask) ? "slave " : "");
+
+	dma_async_device_register(dma_dev);
+	return 0;
+}
+
+static int __devexit pl330_remove(struct amba_device *adev)
+{
+	struct pl330_device *pl330_dev = amba_get_drvdata(adev);
+	struct pl330_chan *pl330_ch, *_pl330_ch;
+
+	dma_async_device_unregister(&pl330_dev->common);
+
+	list_for_each_entry_safe(pl330_ch, _pl330_ch,
+			&pl330_dev->common.channels, common.device_node) {
+		list_del(&pl330_ch->common.device_node);
+		tasklet_kill(&pl330_ch->tasklet);
+	}
+
+	amba_set_drvdata(adev, NULL);
+
+	return 0;
+}
+
+static struct amba_id pl330_ids[] = {
+	{
+		.id	= 0x00041330,
+		.mask	= 0x000fffff,
+	},
+	{ 0, 0 },
+};
+
+static struct amba_driver pl330_driver = {
+	.drv = {
+		.owner	= THIS_MODULE,
+		.name	= "pl330",
+	},
+	.probe		= pl330_probe,
+	.remove		= __devexit_p(pl330_remove),
+	.id_table	= pl330_ids,
+};
+
+static int __init pl330_init(void)
+{
+	return amba_driver_register(&pl330_driver);
+}
+subsys_initcall(pl330_init);
+
+static void __exit pl330_exit(void)
+{
+	amba_driver_unregister(&pl330_driver);
+}
+
+module_exit(pl330_exit);
+
+MODULE_DESCRIPTION("Driver for PL330 DMA Controller");
+MODULE_AUTHOR("Joonyoung Shim <jy0922.shim@samsung.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/dma/pl330_dmac.h b/drivers/dma/pl330_dmac.h
new file mode 100644
index 0000000..d2cbd4e
--- /dev/null
+++ b/drivers/dma/pl330_dmac.h
@@ -0,0 +1,175 @@
+/*
+ * Copyright (C) 2009 Samsung Electronics Co.Ltd
+ * Author: Joonyoung Shim <jy0922.shim@samsung.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#ifndef __PL330_DMAC_H
+#define __PL330_DMAC_H
+
+#define PL330_MAX_CHANS		8
+#define PL330_MAX_LOOPS		256
+#define PL330_POOL_SIZE		SZ_256
+#define PL330_DESC_NUM		8
+
+/* registers */
+#define PL330_DS		0x00
+#define PL330_DPC		0x04
+#define PL330_INTEN		0x20			/* R/W */
+#define PL330_ES		0x24
+#define PL330_INTSTATUS		0x28
+#define PL330_INTCLR		0x2c			/* W/O */
+#define PL330_FSM		0x30
+#define PL330_FSC		0x34
+#define PL330_FTM		0x38
+#define PL330_FTC(ch)		(0x40 + (ch << 2))
+#define PL330_CS(ch)		(0x100 + (ch << 3))
+#define PL330_CPC(ch)		(0x104 + (ch << 3))
+#define PL330_SA(ch)		(0x400 + (ch << 5))
+#define PL330_DA(ch)		(0x404 + (ch << 5))
+#define PL330_CC(ch)		(0x408 + (ch << 5))
+#define PL330_LC0(ch)		(0x40c + (ch << 5))
+#define PL330_LC1(ch)		(0x410 + (ch << 5))
+#define PL330_DBGSTATUS		0xd00
+#define PL330_DBGCMD		0xd04			/* W/O */
+#define PL330_DBGINST0		0xd08			/* W/O */
+#define PL330_DBGINST1		0xd0c			/* W/O */
+#define PL330_CR0		0xe00
+#define PL330_CR1		0xe04
+#define PL330_CR2		0xe08
+#define PL330_CR3		0xe0c
+#define PL330_CR4		0xe10
+#define PL330_CRDN		0xe14
+#define PL330_PERIPH_ID0	0xfe0
+#define PL330_PERIPH_ID1	0xfe4
+#define PL330_PERIPH_ID2	0xfe8
+#define PL330_PERIPH_ID3	0xfec
+#define PL330_PCELL_ID0		0xff0
+#define PL330_PCELL_ID1		0xff4
+#define PL330_PCELL_ID2		0xff8
+#define PL330_PCELL_ID3		0xffc
+
+/* PL330_CC */
+#define PL330_SRC_INC			(1 << 0)
+#define PL330_SRC_BSIZE_1BYTE		(1 << 1)
+#define PL330_SRC_BSIZE_2BYTE		(2 << 1)
+#define PL330_SRC_BSIZE_4BYTE		(3 << 1)
+#define PL330_SRC_BSIZE_16BYTE		(4 << 1)
+#define PL330_SRC_BSIZE_32BYTE		(5 << 1)
+#define PL330_SRC_BSIZE_64BYTE		(6 << 1)
+#define PL330_SRC_BSIZE_128BYTE		(7 << 1)
+#define PL330_SRC_BLEN(n)		((n - 1) << 4)
+#define PL330_DEST_INC			(1 << 14)
+#define PL330_DEST_BSIZE_1BYTE		(1 << 15)
+#define PL330_DEST_BSIZE_2BYTE		(2 << 15)
+#define PL330_DEST_BSIZE_4BYTE		(3 << 15)
+#define PL330_DEST_BSIZE_16BYTE		(4 << 15)
+#define PL330_DEST_BSIZE_32BYTE		(5 << 15)
+#define PL330_DEST_BSIZE_64BYTE		(6 << 15)
+#define PL330_DEST_BSIZE_128BYTE	(7 << 15)
+#define PL330_DEST_BLEN(n)		((n - 18) << 4)
+
+/* PL330_DBGSTATUS */
+#define PL330_DBG_IDLE		0
+#define PL330_DBG_BUSY		1
+
+/* instruction set opcode */
+#define DMAADDH			(0x54)
+#define DMAEND			(0x00)
+#define DMAFLUSHHP		(0x35)
+#define DMAGO			(0xa0)
+#define DMALD			(0x04)
+#define DMALDS			(0x05)
+#define DMALDB			(0x07)
+#define DMALDPS			(0x25)
+#define DMALDPB			(0x27)
+#define DMALP			(0x20)
+#define DMALPEND		(0x38)
+#define DMALPENDS		(0x39)
+#define DMALPENDB		(0x3b)
+#define DMALPFE			(0x28)
+#define DMAKILL			(0x01)
+#define DMAMOV			(0xbc)
+#define DMANOP			(0xbc)
+#define DMARMB			(0x12)
+#define DMASEV			(0x34)
+#define DMAST			(0x08)
+#define DMASTS			(0x09)
+#define DMASTB			(0x0b)
+#define DMASTPS			(0x29)
+#define DMASTPB			(0x2b)
+#define DMASTZ			(0x0c)
+#define DMAWFE			(0x36)
+#define DMAWFPS			(0x30)
+#define DMAWFPB			(0x32)
+#define DMAWFPP			(0x31)
+#define DMAWMB			(0x13)
+
+/* ra DMAADDH */
+#define RA_SA			0
+#define RA_DA			1
+
+/* ns DMAGO */
+#define NS_SECURE		0
+#define NS_NONSECURE		1
+
+/* lc DMALP* */
+#define LC_0			0
+#define LC_1			1
+
+/* rd DMAMOV */
+#define RD_SAR			0
+#define RD_CCR			1
+#define RD_DAR			2
+
+/* invalid DMAWFE */
+#define INVALID_OFF		0
+#define INVALID_ON		1
+
+/* struct for PL330_CC Register */
+struct pl330_register_cc {
+	unsigned int src_inc:1;
+	unsigned int src_burst_size:3;
+	unsigned int src_burst_len:4;
+	unsigned int src_prot_ctrl:3;
+	unsigned int src_cache_ctrl:3;
+	unsigned int dst_inc:1;
+	unsigned int dst_burst_size:3;
+	unsigned int dst_burst_len:4;
+	unsigned int dst_prot_ctrl:3;
+	unsigned int dst_cache_ctrl:3;
+	unsigned int endian_swqp_size:4;
+};
+
+struct pl330_desc {
+	struct dma_async_tx_descriptor	async_tx;
+	struct list_head		desc_node;
+	void				*desc_pool_virt;
+};
+
+struct pl330_chan {
+	struct pl330_device		*pl330_dev;
+	struct pl330_register_cc	pl330_reg_cc;
+	struct dma_chan			common;
+	struct tasklet_struct		tasklet;
+	struct list_head		free_desc;
+	struct list_head		queue_desc;
+	struct list_head		complete_desc;
+	spinlock_t			lock;
+	dma_cookie_t			completed;
+	unsigned int			id;
+	unsigned int			desc_num;
+};
+
+struct pl330_device {
+	void __iomem		*reg_base;
+	struct pl330_chan	pl330_ch[PL330_MAX_CHANS];
+	struct dma_device	common;
+};
+
+#endif
diff --git a/include/linux/amba/pl330.h b/include/linux/amba/pl330.h
new file mode 100644
index 0000000..566b441
--- /dev/null
+++ b/include/linux/amba/pl330.h
@@ -0,0 +1,64 @@
+/*
+ * include/linux/amba/pl330.h
+ *
+ * Copyright (C) 2009 Samsung Electronics Co.Ltd
+ *	Joonyoung Shim <jy0922.shim@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef __AMBA_PL330_H
+#define __AMBA_PL330_H
+
+#include <linux/dmaengine.h>
+
+/**
+ * struct pl330_platform_data - Platform device data for PL330 DMAC
+ * @cap_mask: one or more dma_capability flags
+ */
+struct pl330_platform_data {
+	dma_cap_mask_t		cap_mask;
+};
+
+/**
+ * enum pl330_dma_slave_width - DMA slave register access width.
+ * @PL330_DMA_SLAVE_WIDTH_1BYTE: Do 1-byte slave register accesses
+ * @PL330_DMA_SLAVE_WIDTH_2BYTE: Do 2-byte slave register accesses
+ * @PL330_DMA_SLAVE_WIDTH_4BYTE: Do 4-byte slave register accesses
+ * @PL330_DMA_SLAVE_WIDTH_8BYTE: Do 8-byte slave register accesses
+ * @PL330_DMA_SLAVE_WIDTH_16BYTE: Do 16-byte slave register accesses
+ * @PL330_DMA_SLAVE_WIDTH_32BYTE: Do 32-byte slave register accesses
+ * @PL330_DMA_SLAVE_WIDTH_64BYTE: Do 64-byte slave register accesses
+ * @PL330_DMA_SLAVE_WIDTH_128BYTE: Do 128-byte slave register accesses
+ */
+enum pl330_dma_slave_width {
+	PL330_DMA_SLAVE_WIDTH_1BYTE = 0,
+	PL330_DMA_SLAVE_WIDTH_2BYTE,
+	PL330_DMA_SLAVE_WIDTH_4BYTE,
+	PL330_DMA_SLAVE_WIDTH_8BYTE,
+	PL330_DMA_SLAVE_WIDTH_16BYTE,
+	PL330_DMA_SLAVE_WIDTH_32BYTE,
+	PL330_DMA_SLAVE_WIDTH_64BYTE,
+	PL330_DMA_SLAVE_WIDTH_128BYTE,
+};
+
+/**
+ * struct pl330_dma_slave - Controller-specific information about a slave
+ * @tx_reg: physical address of data register used for
+ *	memory-to-peripheral transfers
+ * @rx_reg: physical address of data register used for
+ *	peripheral-to-memory transfers
+ * @reg_width: peripheral register width
+ * @peri_num: peripheral number
+ */
+struct pl330_dma_slave {
+	dma_addr_t			tx_reg;
+	dma_addr_t			rx_reg;
+	enum pl330_dma_slave_width	reg_width;
+	unsigned int			peri_num;
+};
+
+#endif /* __AMBA_PL330_H */
-- 
1.6.3.3
