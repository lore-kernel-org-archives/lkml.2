Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab1G2LQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 07:16:29 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:58787 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932127Ab1G2LQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 07:16:25 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <linus.walleij@linaro.org>
Cc: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>
Subject: [PATCH 16/18] dmaengine/amba-pl08x: Add support for sg len greater than one for slave transfers
Date: Fri, 29 Jul 2011 16:19:26 +0530
Message-ID: <5d691ab0c4f447c9f324213d8d740ac61d1739a1.1311936524.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1311936523.git.viresh.kumar@st.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Untill now, sg_len greater than one is not supported. This patch adds support to
do that.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/amba-pl08x.c   |  288 ++++++++++++++++++++++++++------------------
 include/linux/amba/pl08x.h |   22 +++-
 2 files changed, 184 insertions(+), 126 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 9eea0d1..ddc06bd 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -354,7 +354,9 @@ static u32 pl08x_getbytes_chan(struct pl08x_dma_chan *plchan)
 	if (!list_empty(&plchan->pend_list)) {
 		struct pl08x_txd *txdi;
 		list_for_each_entry(txdi, &plchan->pend_list, node) {
-			bytes += txdi->len;
+			struct pl08x_sg *dsg;
+			list_for_each_entry(dsg, &txd->dsg_list, node)
+				bytes += dsg->len;
 		}
 	}
 
@@ -564,6 +566,7 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 	u32 cctl, early_bytes = 0;
 	size_t max_bytes_per_lli, total_bytes = 0;
 	struct pl08x_lli *llis_va;
+	struct pl08x_sg *dsg;
 
 	txd->llis_va = dma_pool_alloc(pl08x->pool, GFP_NOWAIT, &txd->llis_bus);
 	if (!txd->llis_va) {
@@ -573,13 +576,9 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 
 	pl08x->pool_ctr++;
 
-	/* Get the default CCTL */
-	cctl = txd->cctl;
-
 	bd.txd = txd;
-	bd.srcbus.addr = txd->src_addr;
-	bd.dstbus.addr = txd->dst_addr;
 	bd.lli_bus = (pl08x->lli_buses & PL08X_AHB2) ? PL080_LLI_LM_AHB2 : 0;
+	cctl = txd->cctl;
 
 	/* Find maximum width of the source bus */
 	bd.srcbus.maxwidth =
@@ -591,46 +590,27 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 		pl08x_get_bytes_for_cctl((cctl & PL080_CONTROL_DWIDTH_MASK) >>
 				PL080_CONTROL_DWIDTH_SHIFT);
 
-	/* Set up the bus widths to the maximum */
-	bd.srcbus.buswidth = bd.srcbus.maxwidth;
-	bd.dstbus.buswidth = bd.dstbus.maxwidth;
+	list_for_each_entry(dsg, &txd->dsg_list, node) {
+		cctl = txd->cctl;
 
-	/* We need to count this down to zero */
-	bd.remainder = txd->len;
+		bd.srcbus.addr = dsg->src_addr;
+		bd.dstbus.addr = dsg->dst_addr;
+		bd.remainder = dsg->len;
+		bd.srcbus.buswidth = bd.srcbus.maxwidth;
+		bd.dstbus.buswidth = bd.dstbus.maxwidth;
 
-	pl08x_choose_master_bus(&bd, &mbus, &sbus, cctl);
+		pl08x_choose_master_bus(&bd, &mbus, &sbus, cctl);
 
-	dev_vdbg(&pl08x->adev->dev, "src=0x%08x%s/%u dst=0x%08x%s/%u len=%zu\n",
-		 bd.srcbus.addr, cctl & PL080_CONTROL_SRC_INCR ? "+" : "",
-		 bd.srcbus.buswidth,
-		 bd.dstbus.addr, cctl & PL080_CONTROL_DST_INCR ? "+" : "",
-		 bd.dstbus.buswidth,
-		 bd.remainder);
-	dev_vdbg(&pl08x->adev->dev, "mbus=%s sbus=%s\n",
-		 mbus == &bd.srcbus ? "src" : "dst",
-		 sbus == &bd.srcbus ? "src" : "dst");
-
-	/*
-	 * Send byte by byte for following cases
-	 * - Less than a bus width available
-	 * - until master bus is aligned
-	 */
-	if (bd.remainder < mbus->buswidth)
-		early_bytes = bd.remainder;
-	else if ((mbus->addr) % (mbus->buswidth)) {
-		early_bytes = mbus->buswidth - (mbus->addr) % (mbus->buswidth);
-		if ((bd.remainder - early_bytes) < mbus->buswidth)
-			early_bytes = bd.remainder;
-	}
+		dev_vdbg(&pl08x->adev->dev, "src=0x%08x%s/%u dst=0x%08x%s/%u len=%zu\n",
+			bd.srcbus.addr, cctl & PL080_CONTROL_SRC_INCR ? "+" : "",
+			bd.srcbus.buswidth,
+			bd.dstbus.addr, cctl & PL080_CONTROL_DST_INCR ? "+" : "",
+			bd.dstbus.buswidth,
+			bd.remainder);
+		dev_vdbg(&pl08x->adev->dev, "mbus=%s sbus=%s\n",
+			mbus == &bd.srcbus ? "src" : "dst",
+			sbus == &bd.srcbus ? "src" : "dst");
 
-	if (early_bytes) {
-		dev_vdbg(&pl08x->adev->dev, "%s byte width LLIs "
-				"(remain 0x%08x)\n", __func__, bd.remainder);
-		prep_byte_width_lli(&bd, &cctl, early_bytes, num_llis++,
-				&total_bytes);
-	}
-
-	if (bd.remainder) {
 		/*
 		 * Zero length is only allowed if all these requirements are
 		 * met:
@@ -664,79 +644,111 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 		}
 
 		/*
-		 * Master now aligned
-		 * - if slave is not then we must set its width down
+		 * Send byte by byte for following cases
+		 * - Less than a bus width available
+		 * - until master bus is aligned
 		 */
-		if (sbus->addr % sbus->buswidth) {
-			dev_dbg(&pl08x->adev->dev,
-				"%s set down bus width to one byte\n",
-				 __func__);
+		if (bd.remainder < mbus->buswidth)
+			early_bytes = bd.remainder;
+		else if ((mbus->addr) % (mbus->buswidth)) {
+			early_bytes = mbus->buswidth - (mbus->addr) %
+				(mbus->buswidth);
+			if ((bd.remainder - early_bytes) < mbus->buswidth)
+				early_bytes = bd.remainder;
+		}
 
-			sbus->buswidth = 1;
+		if (early_bytes) {
+			dev_vdbg(&pl08x->adev->dev, "%s byte width LLIs "
+				"(remain 0x%08x)\n", __func__, bd.remainder);
+			prep_byte_width_lli(&bd, &cctl, early_bytes, num_llis++,
+				&total_bytes);
 		}
 
-		/* Bytes transferred = tsize * src width, not MIN(buswidths) */
-		max_bytes_per_lli = bd.srcbus.buswidth *
-			PL080_CONTROL_TRANSFER_SIZE_MASK;
+		if (bd.remainder) {
+			/*
+			 * Master now aligned
+			 * - if slave is not then we must set its width down
+			 */
+			if (sbus->addr % sbus->buswidth) {
+				dev_dbg(&pl08x->adev->dev,
+					"%s set down bus width to one byte\n",
+					__func__);
 
-		/*
-		 * Make largest possible LLIs until less than one bus
-		 * width left
-		 */
-		while (bd.remainder > (mbus->buswidth - 1)) {
-			size_t lli_len, tsize, width;
+				sbus->buswidth = 1;
+			}
 
 			/*
-			 * If enough left try to send max possible,
-			 * otherwise try to send the remainder
+			 * Bytes transferred = tsize * src width, not
+			 * MIN(buswidths)
 			 */
-			lli_len = min(bd.remainder, max_bytes_per_lli);
+			max_bytes_per_lli = bd.srcbus.buswidth *
+				PL080_CONTROL_TRANSFER_SIZE_MASK;
+			dev_vdbg(&pl08x->adev->dev, "%s max bytes per lli = "
+				"%zu\n", __func__, max_bytes_per_lli);
 
 			/*
-			 * Check against maximum bus alignment: Calculate actual
-			 * transfer size in relation to bus width and get a
-			 * maximum remainder of the highest bus width - 1
+			 * Make largest possible LLIs until less than one bus
+			 * width left
 			 */
-			width = max(mbus->buswidth, sbus->buswidth);
-			lli_len = (lli_len / width) * width;
-			tsize = lli_len / bd.srcbus.buswidth;
+			while (bd.remainder > (mbus->buswidth - 1)) {
+				size_t lli_len, tsize, width;
 
-			dev_vdbg(&pl08x->adev->dev,
+				/*
+				 * If enough left try to send max possible,
+				 * otherwise try to send the remainder
+				 */
+				lli_len = min(bd.remainder, max_bytes_per_lli);
+
+				/*
+				 * Check against maximum bus alignment:
+				 * Calculate actual transfer size in relation to
+				 * bus width an get a maximum remainder of the
+				 * highest bus width - 1
+				 */
+				width = max(mbus->buswidth, sbus->buswidth);
+				lli_len = (lli_len / width) * width;
+				tsize = lli_len / bd.srcbus.buswidth;
+
+				dev_vdbg(&pl08x->adev->dev,
 					"%s fill lli with single lli chunk of "
 					"size 0x%08zx (remainder 0x%08zx)\n",
 					__func__, lli_len, bd.remainder);
 
-			cctl = pl08x_cctl_bits(cctl, bd.srcbus.buswidth,
+				cctl = pl08x_cctl_bits(cctl, bd.srcbus.buswidth,
 					bd.dstbus.buswidth, tsize);
-			pl08x_fill_lli_for_desc(&bd, num_llis++, lli_len, cctl);
-			total_bytes += lli_len;
-		}
+				pl08x_fill_lli_for_desc(&bd, num_llis++,
+						lli_len, cctl);
+				total_bytes += lli_len;
+			}
 
-		/*
-		 * Send any odd bytes
-		 */
-		if (bd.remainder) {
-			dev_vdbg(&pl08x->adev->dev,
-				"%s align with boundary, send odd bytes "
-				"(remain %zu)\n", __func__, bd.remainder);
-			prep_byte_width_lli(&bd, &cctl, bd.remainder,
-					num_llis++, &total_bytes);
+			/*
+			 * Send any odd bytes
+			 */
+			if (bd.remainder) {
+				dev_vdbg(&pl08x->adev->dev,
+					"%s align with boundary, send odd bytes"
+					" (remain %zu)\n", __func__,
+					bd.remainder);
+				prep_byte_width_lli(&bd, &cctl, bd.remainder,
+						num_llis++, &total_bytes);
+			}
 		}
-	}
 
-	if (total_bytes != txd->len) {
-		dev_err(&pl08x->adev->dev,
-			"%s size of encoded lli:s don't match total txd, "
-			"transferred 0x%08zx from size 0x%08zx\n", __func__,
-			total_bytes, txd->len);
-		return 0;
-	}
+		if (total_bytes != dsg->len) {
+			dev_err(&pl08x->adev->dev,
+				"%s size of encoded lli:s don't match total txd"
+				", transferred 0x%08zx from size 0x%08zx\n",
+				__func__,
+				total_bytes, dsg->len);
+			return 0;
+		}
 
-	if (num_llis >= MAX_NUM_TSFR_LLIS) {
-		dev_err(&pl08x->adev->dev,
-			"%s need to increase MAX_NUM_TSFR_LLIS from 0x%08x\n",
-			__func__, (u32) MAX_NUM_TSFR_LLIS);
-		return 0;
+		if (num_llis >= MAX_NUM_TSFR_LLIS) {
+			dev_err(&pl08x->adev->dev,
+				"%s need to increase MAX_NUM_TSFR_LLIS from "
+				"0x%08x\n", __func__, (u32) MAX_NUM_TSFR_LLIS);
+			return 0;
+		}
 	}
 
 	llis_va = txd->llis_va;
@@ -769,11 +781,18 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 static void pl08x_free_txd(struct pl08x_driver_data *pl08x,
 		struct pl08x_txd *txd)
 {
+	struct pl08x_sg *dsg, *_dsg;
+
 	/* Free the LLI */
 	dma_pool_free(pl08x->pool, txd->llis_va, txd->llis_bus);
 
 	pl08x->pool_ctr--;
 
+	list_for_each_entry_safe(dsg, _dsg, &txd->dsg_list, node) {
+		list_del(&dsg->node);
+		kfree(dsg);
+	}
+
 	kfree(txd);
 }
 
@@ -1228,6 +1247,7 @@ static struct pl08x_txd *pl08x_get_txd(struct pl08x_dma_chan *plchan,
 		txd->tx.flags = flags;
 		txd->tx.tx_submit = pl08x_tx_submit;
 		INIT_LIST_HEAD(&txd->node);
+		INIT_LIST_HEAD(&txd->dsg_list);
 
 		/* Always enable error and terminal interrupts */
 		txd->ccfg = PL080_CONFIG_ERR_IRQ_MASK |
@@ -1246,6 +1266,7 @@ static struct dma_async_tx_descriptor *pl08x_prep_dma_memcpy(
 	struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
 	struct pl08x_driver_data *pl08x = plchan->host;
 	struct pl08x_txd *txd;
+	struct pl08x_sg *dsg;
 	int ret;
 
 	txd = pl08x_get_txd(plchan, flags);
@@ -1255,10 +1276,19 @@ static struct dma_async_tx_descriptor *pl08x_prep_dma_memcpy(
 		return NULL;
 	}
 
+	dsg = kzalloc(sizeof(struct pl08x_sg), GFP_NOWAIT);
+	if (!dsg) {
+		pl08x_free_txd(pl08x, txd);
+		dev_err(&pl08x->adev->dev, "%s no memory for pl080 sg\n",
+				__func__);
+		return NULL;
+	}
+	list_add_tail(&dsg->node, &txd->dsg_list);
+
 	txd->direction = DMA_NONE;
-	txd->src_addr = src;
-	txd->dst_addr = dest;
-	txd->len = len;
+	dsg->src_addr = src;
+	dsg->dst_addr = dest;
+	dsg->len = len;
 
 	/* Set platform data for m2m */
 	txd->ccfg |= PL080_FLOW_MEM2MEM << PL080_CONFIG_FLOW_CONTROL_SHIFT;
@@ -1287,17 +1317,11 @@ static struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
 	struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
 	struct pl08x_driver_data *pl08x = plchan->host;
 	struct pl08x_txd *txd;
+	struct pl08x_sg *dsg;
+	struct scatterlist *sg;
+	dma_addr_t slave_addr;
 	int ret, tmp;
 
-	/*
-	 * Current implementation ASSUMES only one sg
-	 */
-	if (sg_len != 1) {
-		dev_err(&pl08x->adev->dev, "%s prepared too long sglist\n",
-			__func__);
-		BUG();
-	}
-
 	dev_dbg(&pl08x->adev->dev, "%s prepare transaction of %d bytes from"
 			" %s\n", __func__, sgl->length, plchan->name);
 
@@ -1318,17 +1342,15 @@ static struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
 	 * channel target address dynamically at runtime.
 	 */
 	txd->direction = direction;
-	txd->len = sgl->length;
 
 	if (direction == DMA_TO_DEVICE) {
 		txd->cctl = plchan->dst_cctl;
-		txd->src_addr = sgl->dma_address;
-		txd->dst_addr = plchan->dst_addr;
+		slave_addr = plchan->dst_addr;
 	} else if (direction == DMA_FROM_DEVICE) {
 		txd->cctl = plchan->src_cctl;
-		txd->src_addr = plchan->src_addr;
-		txd->dst_addr = sgl->dma_address;
+		slave_addr = plchan->src_addr;
 	} else {
+		pl08x_free_txd(pl08x, txd);
 		dev_err(&pl08x->adev->dev,
 			"%s direction unsupported\n", __func__);
 		return NULL;
@@ -1342,6 +1364,26 @@ static struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
 
 	txd->ccfg |= tmp << PL080_CONFIG_FLOW_CONTROL_SHIFT;
 
+	for_each_sg(sgl, sg, sg_len, tmp) {
+		dsg = kzalloc(sizeof(struct pl08x_sg), GFP_NOWAIT);
+		if (!dsg) {
+			pl08x_free_txd(pl08x, txd);
+			dev_err(&pl08x->adev->dev, "%s no mem for pl080 sg\n",
+					__func__);
+			return NULL;
+		}
+		list_add_tail(&dsg->node, &txd->dsg_list);
+
+		dsg->len = sg_dma_len(sg);
+		if (direction == DMA_TO_DEVICE) {
+			dsg->src_addr = sg_phys(sg);
+			dsg->dst_addr = slave_addr;
+		} else {
+			dsg->src_addr = slave_addr;
+			dsg->dst_addr = sg_phys(sg);
+		}
+	}
+
 	ret = pl08x_prep_channel_resources(plchan, txd);
 	if (ret)
 		return NULL;
@@ -1439,22 +1481,28 @@ static void pl08x_ensure_on(struct pl08x_driver_data *pl08x)
 static void pl08x_unmap_buffers(struct pl08x_txd *txd)
 {
 	struct device *dev = txd->tx.chan->device->dev;
+	struct pl08x_sg *dsg;
 
 	if (!(txd->tx.flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
 		if (txd->tx.flags & DMA_COMPL_SRC_UNMAP_SINGLE)
-			dma_unmap_single(dev, txd->src_addr, txd->len,
-				DMA_TO_DEVICE);
-		else
-			dma_unmap_page(dev, txd->src_addr, txd->len,
-				DMA_TO_DEVICE);
+			list_for_each_entry(dsg, &txd->dsg_list, node)
+				dma_unmap_single(dev, dsg->src_addr, dsg->len,
+						DMA_TO_DEVICE);
+		else {
+			list_for_each_entry(dsg, &txd->dsg_list, node)
+				dma_unmap_page(dev, dsg->src_addr, dsg->len,
+						DMA_TO_DEVICE);
+		}
 	}
 	if (!(txd->tx.flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
 		if (txd->tx.flags & DMA_COMPL_DEST_UNMAP_SINGLE)
-			dma_unmap_single(dev, txd->dst_addr, txd->len,
-				DMA_FROM_DEVICE);
+			list_for_each_entry(dsg, &txd->dsg_list, node)
+				dma_unmap_single(dev, dsg->dst_addr, dsg->len,
+						DMA_FROM_DEVICE);
 		else
-			dma_unmap_page(dev, txd->dst_addr, txd->len,
-				DMA_FROM_DEVICE);
+			list_for_each_entry(dsg, &txd->dsg_list, node)
+				dma_unmap_page(dev, dsg->dst_addr, dsg->len,
+						DMA_FROM_DEVICE);
 	}
 }
 
diff --git a/include/linux/amba/pl08x.h b/include/linux/amba/pl08x.h
index febb0da..9090342 100644
--- a/include/linux/amba/pl08x.h
+++ b/include/linux/amba/pl08x.h
@@ -107,12 +107,24 @@ struct pl08x_phy_chan {
 };
 
 /**
+ * struct pl08x_sg - structure containing data per sg
+ * @src_addr: src address of sg
+ * @dst_addr: dst address of sg
+ * @len: transfer len in bytes
+ * @node: node for txd's dsg_list
+ */
+struct pl08x_sg {
+	dma_addr_t src_addr;
+	dma_addr_t dst_addr;
+	size_t len;
+	struct list_head node;
+};
+
+/**
  * struct pl08x_txd - wrapper for struct dma_async_tx_descriptor
  * @tx: async tx descriptor
  * @node: node for txd list for channels
- * @src_addr: src address of txd
- * @dst_addr: dst address of txd
- * @len: transfer len in bytes
+ * @dsg_list: list of children sg's
  * @direction: direction of transfer
  * @llis_bus: DMA memory address (physical) start for the LLIs
  * @llis_va: virtual memory address start for the LLIs
@@ -122,10 +134,8 @@ struct pl08x_phy_chan {
 struct pl08x_txd {
 	struct dma_async_tx_descriptor tx;
 	struct list_head node;
+	struct list_head dsg_list;
 	enum dma_data_direction	direction;
-	dma_addr_t src_addr;
-	dma_addr_t dst_addr;
-	size_t len;
 	dma_addr_t llis_bus;
 	struct pl08x_lli *llis_va;
 	/* Default cctl value for LLIs */
-- 
1.7.2.2

