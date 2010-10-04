Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab0JDKxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 06:53:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:13146 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671Ab0JDKxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 06:53:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,277,1283756400"; 
   d="scan'208";a="331793395"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, ramesh.b.k.v@intel.com,
        yong.y.wang@linux.intel.com
Cc: Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 4/6] intel_mid_dma: Add sg list support to DMA driver
Date: Mon,  4 Oct 2010 16:07:53 +0530
Message-Id: <1286188673-6269-1-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramesh Babu K V <ramesh.b.k.v@intel.com>

For a very high speed DMA various periphral devices need
scatter-gather list support. The DMA hardware support link list items.
This list can be circular also (adding new flag DMA_PREP_CIRCULAR_LIST)
Right now this flag is in driver header and should be moved to
dmaengine header file eventually

Signed-off-by: Ramesh Babu K V <ramesh.b.k.v@intel.com>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/dma/intel_mid_dma.c      |  267 +++++++++++++++++++++++++++++++-------
 drivers/dma/intel_mid_dma_regs.h |   30 ++++-
 include/linux/intel_mid_dma.h    |    3 +
 3 files changed, 250 insertions(+), 50 deletions(-)

diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index 3c4333e..2ae1086 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -258,6 +258,7 @@ static void midc_dostart(struct intel_mid_dma_chan *midc,
 	/*write registers and en*/
 	iowrite32(first->sar, midc->ch_regs + SAR);
 	iowrite32(first->dar, midc->ch_regs + DAR);
+	iowrite32(first->lli_phys, midc->ch_regs + LLP);
 	iowrite32(first->cfg_hi, midc->ch_regs + CFG_HIGH);
 	iowrite32(first->cfg_lo, midc->ch_regs + CFG_LOW);
 	iowrite32(first->ctl_lo, midc->ch_regs + CTL_LOW);
@@ -265,9 +266,9 @@ static void midc_dostart(struct intel_mid_dma_chan *midc,
 	pr_debug("MDMA:TX SAR %x,DAR %x,CFGL %x,CFGH %x,CTLH %x, CTLL %x\n",
 		(int)first->sar, (int)first->dar, first->cfg_hi,
 		first->cfg_lo, first->ctl_hi, first->ctl_lo);
+	first->status = DMA_IN_PROGRESS;
 
 	iowrite32(ENABLE_CHANNEL(midc->ch_id), mid->dma_base + DMA_CHAN_EN);
-	first->status = DMA_IN_PROGRESS;
 }
 
 /**
@@ -284,20 +285,36 @@ static void midc_descriptor_complete(struct intel_mid_dma_chan *midc,
 {
 	struct dma_async_tx_descriptor	*txd = &desc->txd;
 	dma_async_tx_callback callback_txd = NULL;
+	struct intel_mid_dma_lli	*llitem;
 	void *param_txd = NULL;
 
 	midc->completed = txd->cookie;
 	callback_txd = txd->callback;
 	param_txd = txd->callback_param;
 
-	list_move(&desc->desc_node, &midc->free_list);
-	midc->busy = false;
+	if (desc->lli != NULL) {
+		/*clear the DONE bit of completed LLI in memory*/
+		llitem = desc->lli + desc->current_lli;
+		llitem->ctl_hi &= CLEAR_DONE;
+		if (desc->current_lli < desc->lli_length-1)
+			(desc->current_lli)++;
+		else
+			desc->current_lli = 0;
+	}
 	spin_unlock_bh(&midc->lock);
 	if (callback_txd) {
 		pr_debug("MDMA: TXD callback set ... calling\n");
 		callback_txd(param_txd);
-		spin_lock_bh(&midc->lock);
-		return;
+	}
+	if (midc->raw_tfr) {
+		desc->status = DMA_SUCCESS;
+		if (desc->lli != NULL) {
+			pci_pool_free(desc->lli_pool, desc->lli,
+						desc->lli_phys);
+			pci_pool_destroy(desc->lli_pool);
+		}
+		list_move(&desc->desc_node, &midc->free_list);
+		midc->busy = false;
 	}
 	spin_lock_bh(&midc->lock);
 
@@ -318,14 +335,89 @@ static void midc_scan_descriptors(struct middma_device *mid,
 
 	/*tx is complete*/
 	list_for_each_entry_safe(desc, _desc, &midc->active_list, desc_node) {
-		if (desc->status == DMA_IN_PROGRESS)  {
-			desc->status = DMA_SUCCESS;
+		if (desc->status == DMA_IN_PROGRESS)
 			midc_descriptor_complete(midc, desc);
-		}
 	}
 	return;
-}
+	}
+/**
+ * midc_lli_fill_sg -		Helper function to convert
+ *				SG list to Linked List Items.
+ *@midc: Channel
+ *@desc: DMA descriptor
+ *@sglist: Pointer to SG list
+ *@sglen: SG list length
+ *@flags: DMA transaction flags
+ *
+ * Walk through the SG list and convert the SG list into Linked
+ * List Items (LLI).
+ */
+static int midc_lli_fill_sg(struct intel_mid_dma_chan *midc,
+				struct intel_mid_dma_desc *desc,
+				struct scatterlist *sglist,
+				unsigned int sglen,
+				unsigned int flags)
+{
+	struct intel_mid_dma_slave *mids;
+	struct scatterlist  *sg;
+	dma_addr_t lli_next, sg_phy_addr;
+	struct intel_mid_dma_lli *lli_bloc_desc;
+	union intel_mid_dma_ctl_lo ctl_lo;
+	union intel_mid_dma_ctl_hi ctl_hi;
+	int i;
+
+	pr_debug("MDMA: Entered midc_lli_fill_sg\n");
+	mids = midc->chan.private;
+
+	lli_bloc_desc = desc->lli;
+	lli_next = desc->lli_phys;
 
+	ctl_lo.ctl_lo = desc->ctl_lo;
+	ctl_hi.ctl_hi = desc->ctl_hi;
+	for_each_sg(sglist, sg, sglen, i) {
+		/*Populate CTL_LOW and LLI values*/
+		if (i != sglen - 1) {
+			lli_next = lli_next +
+				sizeof(struct intel_mid_dma_lli);
+		} else {
+		/*Check for circular list, otherwise terminate LLI to ZERO*/
+			if (flags & DMA_PREP_CIRCULAR_LIST) {
+				pr_debug("MDMA: LLI is configured in circular mode\n");
+				lli_next = desc->lli_phys;
+			} else {
+				lli_next = 0;
+				ctl_lo.ctlx.llp_dst_en = 0;
+				ctl_lo.ctlx.llp_src_en = 0;
+			}
+		}
+		/*Populate CTL_HI values*/
+		ctl_hi.ctlx.block_ts = get_block_ts(sg->length,
+							desc->width,
+							midc->dma->block_size);
+		/*Populate SAR and DAR values*/
+		sg_phy_addr = sg_phys(sg);
+		if (desc->dirn ==  DMA_TO_DEVICE) {
+			lli_bloc_desc->sar  = sg_phy_addr;
+			lli_bloc_desc->dar  = mids->per_addr;
+		} else if (desc->dirn ==  DMA_FROM_DEVICE) {
+			lli_bloc_desc->sar  = mids->per_addr;
+			lli_bloc_desc->dar  = sg_phy_addr;
+		}
+		/*Copy values into block descriptor in system memroy*/
+		lli_bloc_desc->llp = lli_next;
+		lli_bloc_desc->ctl_lo = ctl_lo.ctl_lo;
+		lli_bloc_desc->ctl_hi = ctl_hi.ctl_hi;
+
+		lli_bloc_desc++;
+	}
+	/*Copy very first LLI values to descriptor*/
+	desc->ctl_lo = desc->lli->ctl_lo;
+	desc->ctl_hi = desc->lli->ctl_hi;
+	desc->sar = desc->lli->sar;
+	desc->dar = desc->lli->dar;
+
+	return 0;
+}
 /*****************************************************************************
 DMA engine callback Functions*/
 /**
@@ -350,12 +442,12 @@ static dma_cookie_t intel_mid_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 	desc->txd.cookie = cookie;
 
 
-	if (list_empty(&midc->active_list)) {
-		midc_dostart(midc, desc);
+	if (list_empty(&midc->active_list))
 		list_add_tail(&desc->desc_node, &midc->active_list);
-	} else {
+	else
 		list_add_tail(&desc->desc_node, &midc->queue);
-	}
+
+	midc_dostart(midc, desc);
 	spin_unlock_bh(&midc->lock);
 
 	return cookie;
@@ -429,7 +521,7 @@ static int intel_mid_dma_device_control(struct dma_chan *chan,
 	struct intel_mid_dma_chan	*midc = to_intel_mid_dma_chan(chan);
 	struct middma_device	*mid = to_middma_device(chan->device);
 	struct intel_mid_dma_desc	*desc, *_desc;
-	LIST_HEAD(list);
+	union intel_mid_dma_cfg_lo cfg_lo;
 
 	if (cmd != DMA_TERMINATE_ALL)
 		return -ENXIO;
@@ -439,39 +531,29 @@ static int intel_mid_dma_device_control(struct dma_chan *chan,
 		spin_unlock_bh(&midc->lock);
 		return 0;
 	}
-	list_splice_init(&midc->free_list, &list);
-	midc->descs_allocated = 0;
-	midc->slave = NULL;
-
+	/*Suspend and disable the channel*/
+	cfg_lo.cfg_lo = ioread32(midc->ch_regs + CFG_LOW);
+	cfg_lo.cfgx.ch_susp = 1;
+	iowrite32(cfg_lo.cfg_lo, midc->ch_regs + CFG_LOW);
+	iowrite32(DISABLE_CHANNEL(midc->ch_id), mid->dma_base + DMA_CHAN_EN);
+	midc->busy = false;
 	/* Disable interrupts */
 	disable_dma_interrupt(midc);
+	midc->descs_allocated = 0;
+	midc->slave = NULL;
 
 	spin_unlock_bh(&midc->lock);
-	list_for_each_entry_safe(desc, _desc, &list, desc_node) {
-		pr_debug("MDMA: freeing descriptor %p\n", desc);
-		pci_pool_free(mid->dma_pool, desc, desc->txd.phys);
+	list_for_each_entry_safe(desc, _desc, &midc->active_list, desc_node) {
+		if (desc->lli != NULL) {
+			pci_pool_free(desc->lli_pool, desc->lli,
+						desc->lli_phys);
+			pci_pool_destroy(desc->lli_pool);
+		}
+		list_move(&desc->desc_node, &midc->free_list);
 	}
 	return 0;
 }
 
-/**
- * intel_mid_dma_prep_slave_sg -	Prep slave sg txn
- * @chan: chan for DMA transfer
- * @sgl: scatter gather list
- * @sg_len: length of sg txn
- * @direction: DMA transfer dirtn
- * @flags: DMA flags
- *
- * Do DMA sg txn: NOT supported now
- */
-static struct dma_async_tx_descriptor *intel_mid_dma_prep_slave_sg(
-			struct dma_chan *chan, struct scatterlist *sgl,
-			unsigned int sg_len, enum dma_data_direction direction,
-			unsigned long flags)
-{
-	/*not supported now*/
-	return NULL;
-}
 
 /**
  * intel_mid_dma_prep_memcpy -	Prep memcpy txn
@@ -553,6 +635,7 @@ static struct dma_async_tx_descriptor *intel_mid_dma_prep_memcpy(
 
 	/*calculate CTL_HI*/
 	ctl_hi.ctlx.reser = 0;
+	ctl_hi.ctlx.done  = 0;
 	width = mids->src_width;
 
 	ctl_hi.ctlx.block_ts = get_block_ts(len, width, midc->dma->block_size);
@@ -599,6 +682,9 @@ static struct dma_async_tx_descriptor *intel_mid_dma_prep_memcpy(
 	desc->ctl_hi = ctl_hi.ctl_hi;
 	desc->width = width;
 	desc->dirn = mids->dirn;
+	desc->lli_phys = 0;
+	desc->lli = NULL;
+	desc->lli_pool = NULL;
 	return &desc->txd;
 
 err_desc_get:
@@ -606,6 +692,85 @@ err_desc_get:
 	midc_desc_put(midc, desc);
 	return NULL;
 }
+/**
+ * intel_mid_dma_prep_slave_sg -	Prep slave sg txn
+ * @chan: chan for DMA transfer
+ * @sgl: scatter gather list
+ * @sg_len: length of sg txn
+ * @direction: DMA transfer dirtn
+ * @flags: DMA flags
+ *
+ * Prepares LLI based periphral transfer
+ */
+static struct dma_async_tx_descriptor *intel_mid_dma_prep_slave_sg(
+			struct dma_chan *chan, struct scatterlist *sgl,
+			unsigned int sg_len, enum dma_data_direction direction,
+			unsigned long flags)
+{
+	struct intel_mid_dma_chan *midc = NULL;
+	struct intel_mid_dma_slave *mids = NULL;
+	struct intel_mid_dma_desc *desc = NULL;
+	struct dma_async_tx_descriptor *txd = NULL;
+	union intel_mid_dma_ctl_lo ctl_lo;
+
+	pr_debug("MDMA: Prep for slave SG\n");
+
+	if (!sg_len) {
+		pr_err("MDMA: Invalid SG length\n");
+		return NULL;
+	}
+	midc = to_intel_mid_dma_chan(chan);
+	BUG_ON(!midc);
+
+	mids = chan->private;
+	BUG_ON(!mids);
+
+	if (!midc->dma->pimr_mask) {
+		pr_debug("MDMA: SG list is not supported by this controller\n");
+		return  NULL;
+	}
+
+	pr_debug("MDMA: SG Length = %d, direction = %d, Flags = %#lx\n",
+			sg_len, direction, flags);
+
+	txd = intel_mid_dma_prep_memcpy(chan, 0, 0, sgl->length, flags);
+	if (NULL == txd) {
+		pr_err("MDMA: Prep memcpy failed\n");
+		return NULL;
+	}
+	desc = to_intel_mid_dma_desc(txd);
+	desc->dirn = direction;
+	ctl_lo.ctl_lo = desc->ctl_lo;
+	ctl_lo.ctlx.llp_dst_en = 1;
+	ctl_lo.ctlx.llp_src_en = 1;
+	desc->ctl_lo = ctl_lo.ctl_lo;
+	desc->lli_length = sg_len;
+	desc->current_lli = 0;
+	/* DMA coherent memory pool for LLI descriptors*/
+	desc->lli_pool = pci_pool_create("intel_mid_dma_lli_pool",
+				midc->dma->pdev,
+				(sizeof(struct intel_mid_dma_lli)*sg_len),
+				32, 0);
+	if (NULL == desc->lli_pool) {
+		pr_err("MID_DMA:LLI pool create failed\n");
+		return NULL;
+	}
+
+	desc->lli = pci_pool_alloc(desc->lli_pool, GFP_KERNEL, &desc->lli_phys);
+	if (!desc->lli) {
+		pr_err("MID_DMA: LLI alloc failed\n");
+		pci_pool_destroy(desc->lli_pool);
+		return NULL;
+	}
+
+	midc_lli_fill_sg(midc, desc, sgl, sg_len, flags);
+	if (flags & DMA_PREP_INTERRUPT) {
+		iowrite32(UNMASK_INTR_REG(midc->ch_id),
+				midc->dma_base + MASK_BLOCK);
+		pr_debug("MDMA:Enabled Block interrupt\n");
+	}
+	return &desc->txd;
+}
 
 /**
  * intel_mid_dma_free_chan_resources -	Frees dma resources
@@ -728,7 +893,7 @@ static void dma_tasklet(unsigned long data)
 {
 	struct middma_device *mid = NULL;
 	struct intel_mid_dma_chan *midc = NULL;
-	u32 status;
+	u32 status, raw_tfr, raw_block;
 	int i;
 
 	mid = (struct middma_device *)data;
@@ -737,8 +902,9 @@ static void dma_tasklet(unsigned long data)
 		return;
 	}
 	pr_debug("MDMA: in tasklet for device %x\n", mid->pci_id);
-	status = ioread32(mid->dma_base + RAW_TFR);
-	pr_debug("MDMA:RAW_TFR %x\n", status);
+	raw_tfr = ioread32(mid->dma_base + RAW_TFR);
+	raw_block = ioread32(mid->dma_base + RAW_BLOCK);
+	status = raw_tfr | raw_block;
 	status &= mid->intr_mask;
 	while (status) {
 		/*txn interrupt*/
@@ -754,15 +920,23 @@ static void dma_tasklet(unsigned long data)
 		}
 		pr_debug("MDMA:Tx complete interrupt %x, Ch No %d Index %d\n",
 				status, midc->ch_id, i);
+		midc->raw_tfr = raw_tfr;
+		midc->raw_block = raw_block;
+		spin_lock_bh(&midc->lock);
 		/*clearing this interrupts first*/
 		iowrite32((1 << midc->ch_id), mid->dma_base + CLEAR_TFR);
-		iowrite32((1 << midc->ch_id), mid->dma_base + CLEAR_BLOCK);
-
-		spin_lock_bh(&midc->lock);
+		if (raw_block) {
+			iowrite32((1 << midc->ch_id),
+				mid->dma_base + CLEAR_BLOCK);
+		}
 		midc_scan_descriptors(mid, midc);
 		pr_debug("MDMA:Scan of desc... complete, unmasking\n");
 		iowrite32(UNMASK_INTR_REG(midc->ch_id),
 				mid->dma_base + MASK_TFR);
+		if (raw_block) {
+			iowrite32(UNMASK_INTR_REG(midc->ch_id),
+				mid->dma_base + MASK_BLOCK);
+		}
 		spin_unlock_bh(&midc->lock);
 	}
 
@@ -836,7 +1010,8 @@ static irqreturn_t intel_mid_dma_interrupt(int irq, void *data)
 	tfr_status &= mid->intr_mask;
 	if (tfr_status) {
 		/*need to disable intr*/
-		iowrite32((tfr_status << 8), mid->dma_base + MASK_TFR);
+		iowrite32((tfr_status << INT_MASK_WE), mid->dma_base + MASK_TFR);
+		iowrite32((tfr_status << INT_MASK_WE), mid->dma_base + MASK_BLOCK);
 		pr_debug("MDMA: Calling tasklet %x\n", tfr_status);
 		call_tasklet = 1;
 	}
diff --git a/drivers/dma/intel_mid_dma_regs.h b/drivers/dma/intel_mid_dma_regs.h
index a12dd25..7a5ac56 100644
--- a/drivers/dma/intel_mid_dma_regs.h
+++ b/drivers/dma/intel_mid_dma_regs.h
@@ -29,11 +29,12 @@
 #include <linux/dmapool.h>
 #include <linux/pci_ids.h>
 
-#define INTEL_MID_DMA_DRIVER_VERSION "1.0.6"
+#define INTEL_MID_DMA_DRIVER_VERSION "1.1.0"
 
 #define	REG_BIT0		0x00000001
 #define	REG_BIT8		0x00000100
-
+#define INT_MASK_WE		0x8
+#define CLEAR_DONE		0xFFFFEFFF
 #define UNMASK_INTR_REG(chan_num) \
 	((REG_BIT0 << chan_num) | (REG_BIT8 << chan_num))
 #define MASK_INTR_REG(chan_num) (REG_BIT8 << chan_num)
@@ -41,6 +42,9 @@
 #define ENABLE_CHANNEL(chan_num) \
 	((REG_BIT0 << chan_num) | (REG_BIT8 << chan_num))
 
+#define DISABLE_CHANNEL(chan_num) \
+	(REG_BIT8 << chan_num)
+
 #define DESCS_PER_CHANNEL	16
 /*DMA Registers*/
 /*registers associated with channel programming*/
@@ -50,6 +54,7 @@
 /*CH X REG = (DMA_CH_SIZE)*CH_NO + REG*/
 #define SAR			0x00 /* Source Address Register*/
 #define DAR			0x08 /* Destination Address Register*/
+#define LLP			0x10 /* Linked List Pointer Register*/
 #define CTL_LOW			0x18 /* Control Register*/
 #define CTL_HIGH		0x1C /* Control Register*/
 #define CFG_LOW			0x40 /* Configuration Register Low*/
@@ -112,8 +117,8 @@ union intel_mid_dma_ctl_lo {
 union intel_mid_dma_ctl_hi {
 	struct {
 		u32	block_ts:12;	/*block transfer size*/
-					/*configured by DMAC*/
-		u32	reser:20;
+		u32	done:1;		/*Done - updated by DMAC*/
+		u32	reser:19;	/*configured by DMAC*/
 	} ctlx;
 	u32	ctl_hi;
 
@@ -169,6 +174,8 @@ union intel_mid_dma_cfg_hi {
  * @dma: dma device struture pointer
  * @busy: bool representing if ch is busy (active txn) or not
  * @in_use: bool representing if ch is in use or not
+ * @raw_tfr: raw trf interrupt recieved
+ * @raw_block: raw block interrupt recieved
  */
 struct intel_mid_dma_chan {
 	struct dma_chan		chan;
@@ -185,6 +192,8 @@ struct intel_mid_dma_chan {
 	struct middma_device	*dma;
 	bool			busy;
 	bool			in_use;
+	u32			raw_tfr;
+	u32			raw_block;
 };
 
 static inline struct intel_mid_dma_chan *to_intel_mid_dma_chan(
@@ -247,6 +256,11 @@ struct intel_mid_dma_desc {
 	u32				cfg_lo;
 	u32				ctl_lo;
 	u32				ctl_hi;
+	struct pci_pool			*lli_pool;
+	struct intel_mid_dma_lli	*lli;
+	dma_addr_t			lli_phys;
+	unsigned int			lli_length;
+	unsigned int			current_lli;
 	dma_addr_t			next;
 	enum dma_data_direction		dirn;
 	enum dma_status			status;
@@ -255,6 +269,14 @@ struct intel_mid_dma_desc {
 
 };
 
+struct intel_mid_dma_lli {
+	dma_addr_t			sar;
+	dma_addr_t			dar;
+	dma_addr_t			llp;
+	u32				ctl_lo;
+	u32				ctl_hi;
+} __attribute__ ((packed));
+
 static inline int test_ch_en(void __iomem *dma, u32 ch_no)
 {
 	u32 en_reg = ioread32(dma + DMA_CHAN_EN);
diff --git a/include/linux/intel_mid_dma.h b/include/linux/intel_mid_dma.h
index d9d08b6..befe3fb 100644
--- a/include/linux/intel_mid_dma.h
+++ b/include/linux/intel_mid_dma.h
@@ -27,6 +27,7 @@
 
 #include <linux/dmaengine.h>
 
+#define DMA_PREP_CIRCULAR_LIST		(1 << 10)
 /*DMA transaction width, src and dstn width would be same
 The DMA length must be width aligned,
 for 32 bit width the length must be 32 bit (4bytes) aligned only*/
@@ -69,6 +70,7 @@ enum intel_mid_dma_msize {
  * @cfg_mode: DMA data transfer mode (per-per/mem-per/mem-mem)
  * @src_msize: Source DMA burst size
  * @dst_msize: Dst DMA burst size
+ * @per_addr: Periphral address
  * @device_instance: DMA peripheral device instance, we can have multiple
  *		peripheral device connected to single DMAC
  */
@@ -80,6 +82,7 @@ struct intel_mid_dma_slave {
 	enum intel_mid_dma_mode		cfg_mode; /*mode configuration*/
 	enum intel_mid_dma_msize	src_msize; /*size if src burst*/
 	enum intel_mid_dma_msize	dst_msize; /*size of dst burst*/
+	dma_addr_t			per_addr; /*Peripheral address*/
 	unsigned int		device_instance; /*0, 1 for periphral instance*/
 };
 
-- 
1.6.6.1

