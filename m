Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab0JDKy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 06:54:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:36481 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112Ab0JDKy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 06:54:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,277,1283756400"; 
   d="scan'208";a="843463940"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, ramesh.b.k.v@intel.com,
        yong.y.wang@linux.intel.com
Cc: Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 6/6] intel_mid_dma: change the slave interface
Date: Mon,  4 Oct 2010 16:08:43 +0530
Message-Id: <1286188723-6341-1-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 2.6.36 kernel, dma slave control command was introduced,
this patch changes the intel-mid-dma driver to this
new kernel slave interface

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/dma/intel_mid_dma.c      |   66 ++++++++++++++++++++++++-------------
 drivers/dma/intel_mid_dma_regs.h |   11 +++++-
 include/linux/intel_mid_dma.h    |   15 +--------
 3 files changed, 53 insertions(+), 39 deletions(-)

diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index ef7ffb8..338bc4e 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -92,13 +92,13 @@ static int get_block_ts(int len, int tx_width, int block_size)
 	int byte_width = 0, block_ts = 0;
 
 	switch (tx_width) {
-	case LNW_DMA_WIDTH_8BIT:
+	case DMA_SLAVE_BUSWIDTH_1_BYTE:
 		byte_width = 1;
 		break;
-	case LNW_DMA_WIDTH_16BIT:
+	case DMA_SLAVE_BUSWIDTH_2_BYTES:
 		byte_width = 2;
 		break;
-	case LNW_DMA_WIDTH_32BIT:
+	case DMA_SLAVE_BUSWIDTH_4_BYTES:
 	default:
 		byte_width = 4;
 		break;
@@ -367,7 +367,7 @@ static int midc_lli_fill_sg(struct intel_mid_dma_chan *midc,
 	int i;
 
 	pr_debug("MDMA: Entered midc_lli_fill_sg\n");
-	mids = midc->chan.private;
+	mids = midc->mid_slave;
 
 	lli_bloc_desc = desc->lli;
 	lli_next = desc->lli_phys;
@@ -398,9 +398,9 @@ static int midc_lli_fill_sg(struct intel_mid_dma_chan *midc,
 		sg_phy_addr = sg_phys(sg);
 		if (desc->dirn ==  DMA_TO_DEVICE) {
 			lli_bloc_desc->sar  = sg_phy_addr;
-			lli_bloc_desc->dar  = mids->per_addr;
+			lli_bloc_desc->dar  = mids->dma_slave.dst_addr;
 		} else if (desc->dirn ==  DMA_FROM_DEVICE) {
-			lli_bloc_desc->sar  = mids->per_addr;
+			lli_bloc_desc->sar  = mids->dma_slave.src_addr;
 			lli_bloc_desc->dar  = sg_phy_addr;
 		}
 		/*Copy values into block descriptor in system memroy*/
@@ -507,6 +507,23 @@ static enum dma_status intel_mid_dma_tx_status(struct dma_chan *chan,
 	return ret;
 }
 
+static int dma_slave_control(struct dma_chan *chan, unsigned long arg)
+{
+	struct intel_mid_dma_chan	*midc = to_intel_mid_dma_chan(chan);
+	struct dma_slave_config  *slave = (struct dma_slave_config *)arg;
+	struct intel_mid_dma_slave *mid_slave;
+
+	BUG_ON(!midc);
+	BUG_ON(!slave);
+	pr_debug("MDMA: slave control called\n");
+
+	mid_slave = to_intel_mid_dma_slave(slave);
+
+	BUG_ON(!mid_slave);
+
+	midc->mid_slave = mid_slave;
+	return 0;
+}
 /**
  * intel_mid_dma_device_control -	DMA device control
  * @chan: chan for DMA control
@@ -523,6 +540,9 @@ static int intel_mid_dma_device_control(struct dma_chan *chan,
 	struct intel_mid_dma_desc	*desc, *_desc;
 	union intel_mid_dma_cfg_lo cfg_lo;
 
+	if (cmd == DMA_SLAVE_CONFIG)
+		return dma_slave_control(chan, arg);
+
 	if (cmd != DMA_TERMINATE_ALL)
 		return -ENXIO;
 
@@ -540,7 +560,6 @@ static int intel_mid_dma_device_control(struct dma_chan *chan,
 	/* Disable interrupts */
 	disable_dma_interrupt(midc);
 	midc->descs_allocated = 0;
-	midc->slave = NULL;
 
 	spin_unlock_bh(&midc->lock);
 	list_for_each_entry_safe(desc, _desc, &midc->active_list, desc_node) {
@@ -578,23 +597,24 @@ static struct dma_async_tx_descriptor *intel_mid_dma_prep_memcpy(
 	union intel_mid_dma_ctl_hi ctl_hi;
 	union intel_mid_dma_cfg_lo cfg_lo;
 	union intel_mid_dma_cfg_hi cfg_hi;
-	enum intel_mid_dma_width width = 0;
+	enum dma_slave_buswidth width;
 
 	pr_debug("MDMA: Prep for memcpy\n");
 	BUG_ON(!chan);
 	if (!len)
 		return NULL;
 
-	mids = chan->private;
-	BUG_ON(!mids);
-
 	midc = to_intel_mid_dma_chan(chan);
 	BUG_ON(!midc);
 
+	mids = midc->mid_slave;
+	BUG_ON(!mids);
+
 	pr_debug("MDMA:called for DMA %x CH %d Length %zu\n",
 				midc->dma->pci_id, midc->ch_id, len);
 	pr_debug("MDMA:Cfg passed Mode %x, Dirn %x, HS %x, Width %x\n",
-		mids->cfg_mode, mids->dirn, mids->hs_mode, mids->src_width);
+			mids->cfg_mode, mids->dma_slave.direction,
+			mids->hs_mode, mids->dma_slave.src_addr_width);
 
 	/*calculate CFG_LO*/
 	if (mids->hs_mode == LNW_DMA_SW_HS) {
@@ -613,13 +633,13 @@ static struct dma_async_tx_descriptor *intel_mid_dma_prep_memcpy(
 		if (midc->dma->pimr_mask) {
 			cfg_hi.cfgx.protctl = 0x0; /*default value*/
 			cfg_hi.cfgx.fifo_mode = 1;
-			if (mids->dirn == DMA_TO_DEVICE) {
+			if (mids->dma_slave.direction == DMA_TO_DEVICE) {
 				cfg_hi.cfgx.src_per = 0;
 				if (mids->device_instance == 0)
 					cfg_hi.cfgx.dst_per = 3;
 				if (mids->device_instance == 1)
 					cfg_hi.cfgx.dst_per = 1;
-			} else if (mids->dirn == DMA_FROM_DEVICE) {
+			} else if (mids->dma_slave.direction == DMA_FROM_DEVICE) {
 				if (mids->device_instance == 0)
 					cfg_hi.cfgx.src_per = 2;
 				if (mids->device_instance == 1)
@@ -636,7 +656,7 @@ static struct dma_async_tx_descriptor *intel_mid_dma_prep_memcpy(
 	/*calculate CTL_HI*/
 	ctl_hi.ctlx.reser = 0;
 	ctl_hi.ctlx.done  = 0;
-	width = mids->src_width;
+	width = mids->dma_slave.src_addr_width;
 
 	ctl_hi.ctlx.block_ts = get_block_ts(len, width, midc->dma->block_size);
 	pr_debug("MDMA:calc len %d for block size %d\n",
@@ -644,21 +664,21 @@ static struct dma_async_tx_descriptor *intel_mid_dma_prep_memcpy(
 	/*calculate CTL_LO*/
 	ctl_lo.ctl_lo = 0;
 	ctl_lo.ctlx.int_en = 1;
-	ctl_lo.ctlx.dst_tr_width = mids->dst_width;
-	ctl_lo.ctlx.src_tr_width = mids->src_width;
-	ctl_lo.ctlx.dst_msize = mids->src_msize;
-	ctl_lo.ctlx.src_msize = mids->dst_msize;
+	ctl_lo.ctlx.dst_tr_width = mids->dma_slave.dst_addr_width;
+	ctl_lo.ctlx.src_tr_width = mids->dma_slave.src_addr_width;
+	ctl_lo.ctlx.dst_msize = mids->dma_slave.src_maxburst;
+	ctl_lo.ctlx.src_msize = mids->dma_slave.dst_maxburst;
 
 	if (mids->cfg_mode == LNW_DMA_MEM_TO_MEM) {
 		ctl_lo.ctlx.tt_fc = 0;
 		ctl_lo.ctlx.sinc = 0;
 		ctl_lo.ctlx.dinc = 0;
 	} else {
-		if (mids->dirn == DMA_TO_DEVICE) {
+		if (mids->dma_slave.direction == DMA_TO_DEVICE) {
 			ctl_lo.ctlx.sinc = 0;
 			ctl_lo.ctlx.dinc = 2;
 			ctl_lo.ctlx.tt_fc = 1;
-		} else if (mids->dirn == DMA_FROM_DEVICE) {
+		} else if (mids->dma_slave.direction == DMA_FROM_DEVICE) {
 			ctl_lo.ctlx.sinc = 2;
 			ctl_lo.ctlx.dinc = 0;
 			ctl_lo.ctlx.tt_fc = 2;
@@ -681,7 +701,7 @@ static struct dma_async_tx_descriptor *intel_mid_dma_prep_memcpy(
 	desc->ctl_lo = ctl_lo.ctl_lo;
 	desc->ctl_hi = ctl_hi.ctl_hi;
 	desc->width = width;
-	desc->dirn = mids->dirn;
+	desc->dirn = mids->dma_slave.direction;
 	desc->lli_phys = 0;
 	desc->lli = NULL;
 	desc->lli_pool = NULL;
@@ -722,7 +742,7 @@ static struct dma_async_tx_descriptor *intel_mid_dma_prep_slave_sg(
 	midc = to_intel_mid_dma_chan(chan);
 	BUG_ON(!midc);
 
-	mids = chan->private;
+	mids = midc->mid_slave;
 	BUG_ON(!mids);
 
 	if (!midc->dma->pimr_mask) {
diff --git a/drivers/dma/intel_mid_dma_regs.h b/drivers/dma/intel_mid_dma_regs.h
index 7a5ac56..709fecb 100644
--- a/drivers/dma/intel_mid_dma_regs.h
+++ b/drivers/dma/intel_mid_dma_regs.h
@@ -187,13 +187,13 @@ struct intel_mid_dma_chan {
 	struct list_head	active_list;
 	struct list_head	queue;
 	struct list_head	free_list;
-	struct intel_mid_dma_slave	*slave;
 	unsigned int		descs_allocated;
 	struct middma_device	*dma;
 	bool			busy;
 	bool			in_use;
 	u32			raw_tfr;
 	u32			raw_block;
+	struct intel_mid_dma_slave *mid_slave;
 };
 
 static inline struct intel_mid_dma_chan *to_intel_mid_dma_chan(
@@ -264,7 +264,7 @@ struct intel_mid_dma_desc {
 	dma_addr_t			next;
 	enum dma_data_direction		dirn;
 	enum dma_status			status;
-	enum intel_mid_dma_width	width; /*width of DMA txn*/
+	enum dma_slave_buswidth		width; /*width of DMA txn*/
 	enum intel_mid_dma_mode		cfg_mode; /*mode configuration*/
 
 };
@@ -289,6 +289,13 @@ static inline struct intel_mid_dma_desc *to_intel_mid_dma_desc
 	return container_of(txd, struct intel_mid_dma_desc, txd);
 }
 
+static inline struct intel_mid_dma_slave *to_intel_mid_dma_slave
+		(struct dma_slave_config *slave)
+{
+	return container_of(slave, struct intel_mid_dma_slave, dma_slave);
+}
+
+
 int dma_resume(struct pci_dev *pci);
 
 #endif /*__INTEL_MID_DMAC_REGS_H__*/
diff --git a/include/linux/intel_mid_dma.h b/include/linux/intel_mid_dma.h
index befe3fb..10496bd 100644
--- a/include/linux/intel_mid_dma.h
+++ b/include/linux/intel_mid_dma.h
@@ -28,14 +28,6 @@
 #include <linux/dmaengine.h>
 
 #define DMA_PREP_CIRCULAR_LIST		(1 << 10)
-/*DMA transaction width, src and dstn width would be same
-The DMA length must be width aligned,
-for 32 bit width the length must be 32 bit (4bytes) aligned only*/
-enum intel_mid_dma_width {
-	LNW_DMA_WIDTH_8BIT = 0x0,
-	LNW_DMA_WIDTH_16BIT = 0x1,
-	LNW_DMA_WIDTH_32BIT = 0x2,
-};
 
 /*DMA mode configurations*/
 enum intel_mid_dma_mode {
@@ -75,15 +67,10 @@ enum intel_mid_dma_msize {
  *		peripheral device connected to single DMAC
  */
 struct intel_mid_dma_slave {
-	enum dma_data_direction		dirn;
-	enum intel_mid_dma_width	src_width; /*width of DMA src txn*/
-	enum intel_mid_dma_width	dst_width; /*width of DMA dst txn*/
 	enum intel_mid_dma_hs_mode	hs_mode;  /*handshaking*/
 	enum intel_mid_dma_mode		cfg_mode; /*mode configuration*/
-	enum intel_mid_dma_msize	src_msize; /*size if src burst*/
-	enum intel_mid_dma_msize	dst_msize; /*size of dst burst*/
-	dma_addr_t			per_addr; /*Peripheral address*/
 	unsigned int		device_instance; /*0, 1 for periphral instance*/
+	struct dma_slave_config		dma_slave;
 };
 
 #endif /*__INTEL_MID_DMA_H__*/
-- 
1.6.6.1

