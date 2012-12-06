Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422854Ab2LFJqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 04:46:36 -0500
Received: from outmail010.snc4.facebook.com ([66.220.144.144]:39958 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422835Ab2LFJq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 04:46:29 -0500
Subject: [PATCH 12/12] dmaengine: remove DMA unmap flags
To: linux-kernel@vger.kernel.org
From: Dan Williams <djbw@fb.com>
Cc: linux@arm.linux.org.uk,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Vinod Koul <vinod.koul@intel.com>, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, dave.jiang@intel.com
Date: Thu, 06 Dec 2012 01:26:17 -0800
Message-ID: <20121206092616.17085.17465.stgit@dev279.prn1.facebook.com>
In-Reply-To: <20121206091055.17085.47979.stgit@dev279.prn1.facebook.com>
References: <20121206091055.17085.47979.stgit@dev279.prn1.facebook.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Remove no longer needed DMA unmap flags:
- DMA_COMPL_SKIP_SRC_UNMAP
- DMA_COMPL_SKIP_DEST_UNMAP
- DMA_COMPL_SRC_UNMAP_SINGLE
- DMA_COMPL_DEST_UNMAP_SINGLE

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Dan Williams <djbw@fb.com>
---
 crypto/async_tx/async_memcpy.c           |    3 +--
 crypto/async_tx/async_memset.c           |    3 +--
 crypto/async_tx/async_pq.c               |    1 -
 crypto/async_tx/async_raid6_recov.c      |    8 ++------
 crypto/async_tx/async_xor.c              |    4 +---
 drivers/ata/pata_arasan_cf.c             |    3 +--
 drivers/dma/dmaengine.c                  |    3 +--
 drivers/dma/dmatest.c                    |    3 +--
 drivers/dma/ioat/dma.c                   |    3 +--
 drivers/dma/ioat/dma_v3.c                |   16 ++++------------
 drivers/media/platform/m2m-deinterlace.c |    3 +--
 drivers/media/platform/timblogiw.c       |    2 +-
 drivers/misc/carma/carma-fpga.c          |    3 +--
 drivers/mtd/nand/atmel_nand.c            |    3 +--
 drivers/mtd/nand/fsmc_nand.c             |    2 --
 drivers/net/ethernet/micrel/ks8842.c     |    6 ++----
 drivers/spi/spi-dw-mid.c                 |    4 ++--
 include/linux/dmaengine.h                |   18 ++++--------------
 18 files changed, 25 insertions(+), 63 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index ca95c4c..8caffb0 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -56,8 +56,7 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 		unmap = dmaengine_get_unmap_data(device->dev, 2, GFP_NOIO);
 
 	if (unmap && is_dma_copy_aligned(device, src_offset, dest_offset, len)) {
-		unsigned long dma_prep_flags = DMA_COMPL_SKIP_SRC_UNMAP |
-					       DMA_COMPL_SKIP_DEST_UNMAP;
+		unsigned long dma_prep_flags = 0;
 
 		if (submit->cb_fn)
 			dma_prep_flags |= DMA_PREP_INTERRUPT;
diff --git a/crypto/async_tx/async_memset.c b/crypto/async_tx/async_memset.c
index ffca53b..169ab25 100644
--- a/crypto/async_tx/async_memset.c
+++ b/crypto/async_tx/async_memset.c
@@ -53,8 +53,7 @@ async_memset(struct page *dest, int val, unsigned int offset, size_t len,
 		unmap = dmaengine_get_unmap_data(device->dev, 1, GFP_NOIO);
 
 	if (unmap && is_dma_fill_aligned(device, offset, 0, len)) {
-		unsigned long dma_prep_flags = DMA_COMPL_SKIP_SRC_UNMAP |
-					       DMA_COMPL_SKIP_DEST_UNMAP;
+		unsigned long dma_prep_flags = 0;
 
 		if (submit->cb_fn)
 			dma_prep_flags |= DMA_PREP_INTERRUPT;
diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index e5ddb31..a00aa1e 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -62,7 +62,6 @@ do_async_gen_syndrome(struct dma_chan *chan,
 	unsigned short pq_src_cnt;
 	int src_off = 0;
 
-	dma_flags |= DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP;
 	if (submit->flags & ASYNC_TX_FENCE)
 		dma_flags |= DMA_PREP_FENCE;
 
diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index 20aea04..01b00c9 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -47,9 +47,7 @@ async_sum_product(struct page *dest, struct page **srcs, unsigned char *coef,
 		struct device *dev = dma->dev;
 		dma_addr_t pq[2];
 		struct dma_async_tx_descriptor *tx;
-		enum dma_ctrl_flags dma_flags = DMA_COMPL_SKIP_SRC_UNMAP |
-						DMA_COMPL_SKIP_DEST_UNMAP |
-						DMA_PREP_PQ_DISABLE_P;
+		enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P;
 
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_flags |= DMA_PREP_FENCE;
@@ -112,9 +110,7 @@ async_mult(struct page *dest, struct page *src, u8 coef, size_t len,
 	if (unmap) {
 		struct device *dev = dma->dev;
 		struct dma_async_tx_descriptor *tx;
-		enum dma_ctrl_flags dma_flags = DMA_COMPL_SKIP_SRC_UNMAP |
-						DMA_COMPL_SKIP_DEST_UNMAP |
-						DMA_PREP_PQ_DISABLE_P;
+		enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P;
 
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_flags |= DMA_PREP_FENCE;
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index d6e1dc0..a5e1ebc 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -56,7 +56,6 @@ do_async_xor(struct dma_chan *chan, struct dmaengine_unmap_data *unmap,
 		/* if we are submitting additional xors, leave the chain open
 		 * and clear the callback parameters
 		 */
-		dma_flags = DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP;
 		if (src_cnt > xor_src_cnt) {
 			submit->flags &= ~ASYNC_TX_ACK;
 			submit->flags |= ASYNC_TX_FENCE;
@@ -287,8 +286,7 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 
 	if (unmap && src_cnt <= device->max_xor &&
 	    is_dma_xor_aligned(device, offset, 0, len)) {
-		unsigned long dma_prep_flags = DMA_COMPL_SKIP_SRC_UNMAP |
-					       DMA_COMPL_SKIP_DEST_UNMAP;
+		unsigned long dma_prep_flags = 0;
 		int i;
 
 		pr_debug("%s: (async) len: %zu\n", __func__, len);
diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
index 26201eb..9a6d38d 100644
--- a/drivers/ata/pata_arasan_cf.c
+++ b/drivers/ata/pata_arasan_cf.c
@@ -393,8 +393,7 @@ dma_xfer(struct arasan_cf_dev *acdev, dma_addr_t src, dma_addr_t dest, u32 len)
 	struct dma_async_tx_descriptor *tx;
 	struct dma_chan *chan = acdev->dma_chan;
 	dma_cookie_t cookie;
-	unsigned long flags = DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP |
-		DMA_COMPL_SKIP_DEST_UNMAP;
+	unsigned long flags = DMA_PREP_INTERRUPT;
 	int ret = 0;
 
 	tx = chan->device->device_prep_dma_memcpy(chan, dest, src, len, flags);
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 5a3c7c0..96b5493 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -1021,8 +1021,7 @@ dma_async_memcpy_pg_to_pg(struct dma_chan *chan, struct page *dest_pg,
 				      DMA_TO_DEVICE);
 	unmap->addr[1] = dma_map_page(dev->dev, dest_pg, dest_off, len,
 				      DMA_FROM_DEVICE);
-	flags = DMA_CTRL_ACK | DMA_COMPL_SKIP_SRC_UNMAP |
-		DMA_COMPL_SKIP_DEST_UNMAP;
+	flags = DMA_CTRL_ACK;
 	tx = dev->device_prep_dma_memcpy(chan, unmap->addr[1], unmap->addr[0],
 					 len, flags);
 
diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 3b36890..df78702 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -305,8 +305,7 @@ static int dmatest_func(void *data)
 	set_user_nice(current, 10);
 
 	/* src and dst buffers are freed by ourselves below */
-	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT |
-		DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP;
+	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
 
 	while (!kthread_should_stop()
 	       && !(iterations && total_tests >= iterations)) {
diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index b01df57..c8fc6d4 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -818,8 +818,7 @@ int __devinit ioat_dma_self_test(struct ioatdma_device *device)
 
 	dma_src = dma_map_single(dev, src, IOAT_TEST_SIZE, DMA_TO_DEVICE);
 	dma_dest = dma_map_single(dev, dest, IOAT_TEST_SIZE, DMA_FROM_DEVICE);
-	flags = DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP |
-		DMA_PREP_INTERRUPT;
+	flags = DMA_PREP_INTERRUPT;
 	tx = device->common.device_prep_dma_memcpy(dma_chan, dma_dest, dma_src,
 						   IOAT_TEST_SIZE, flags);
 	if (!tx) {
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index cdf37ff..e38077c 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -792,9 +792,7 @@ static int __devinit ioat_xor_val_self_test(struct ioatdma_device *device)
 					   DMA_TO_DEVICE);
 	tx = dma->device_prep_dma_xor(dma_chan, dest_dma, dma_srcs,
 				      IOAT_NUM_SRC_TEST, PAGE_SIZE,
-				      DMA_PREP_INTERRUPT |
-				      DMA_COMPL_SKIP_SRC_UNMAP |
-				      DMA_COMPL_SKIP_DEST_UNMAP);
+				      DMA_PREP_INTERRUPT);
 
 	if (!tx) {
 		dev_err(dev, "Self-test xor prep failed\n");
@@ -855,9 +853,7 @@ static int __devinit ioat_xor_val_self_test(struct ioatdma_device *device)
 					   DMA_TO_DEVICE);
 	tx = dma->device_prep_dma_xor_val(dma_chan, dma_srcs,
 					  IOAT_NUM_SRC_TEST + 1, PAGE_SIZE,
-					  &xor_val_result, DMA_PREP_INTERRUPT |
-					  DMA_COMPL_SKIP_SRC_UNMAP |
-					  DMA_COMPL_SKIP_DEST_UNMAP);
+					  &xor_val_result, DMA_PREP_INTERRUPT);
 	if (!tx) {
 		dev_err(dev, "Self-test zero prep failed\n");
 		err = -ENODEV;
@@ -903,9 +899,7 @@ static int __devinit ioat_xor_val_self_test(struct ioatdma_device *device)
 	dma_addr = dma_map_page(dev, dest, 0,
 			PAGE_SIZE, DMA_FROM_DEVICE);
 	tx = dma->device_prep_dma_memset(dma_chan, dma_addr, 0, PAGE_SIZE,
-					 DMA_PREP_INTERRUPT |
-					 DMA_COMPL_SKIP_SRC_UNMAP |
-					 DMA_COMPL_SKIP_DEST_UNMAP);
+					 DMA_PREP_INTERRUPT);
 	if (!tx) {
 		dev_err(dev, "Self-test memset prep failed\n");
 		err = -ENODEV;
@@ -952,9 +946,7 @@ static int __devinit ioat_xor_val_self_test(struct ioatdma_device *device)
 					   DMA_TO_DEVICE);
 	tx = dma->device_prep_dma_xor_val(dma_chan, dma_srcs,
 					  IOAT_NUM_SRC_TEST + 1, PAGE_SIZE,
-					  &xor_val_result, DMA_PREP_INTERRUPT |
-					  DMA_COMPL_SKIP_SRC_UNMAP |
-					  DMA_COMPL_SKIP_DEST_UNMAP);
+					  &xor_val_result, DMA_PREP_INTERRUPT);
 	if (!tx) {
 		dev_err(dev, "Self-test 2nd zero prep failed\n");
 		err = -ENODEV;
diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 45164c4..8c63b93 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -344,8 +344,7 @@ static void deinterlace_issue_dma(struct deinterlace_ctx *ctx, int op,
 	ctx->xt->dir = DMA_MEM_TO_MEM;
 	ctx->xt->src_sgl = false;
 	ctx->xt->dst_sgl = true;
-	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT |
-		DMA_COMPL_SKIP_DEST_UNMAP | DMA_COMPL_SKIP_SRC_UNMAP;
+	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
 
 	tx = dmadev->device_prep_interleaved_dma(chan, ctx->xt, flags);
 	if (tx == NULL) {
diff --git a/drivers/media/platform/timblogiw.c b/drivers/media/platform/timblogiw.c
index 02194c0..8ae630c 100644
--- a/drivers/media/platform/timblogiw.c
+++ b/drivers/media/platform/timblogiw.c
@@ -566,7 +566,7 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 
 	desc = dmaengine_prep_slave_sg(fh->chan,
 		buf->sg, sg_elems, DMA_DEV_TO_MEM,
-		DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP);
+		DMA_PREP_INTERRUPT);
 	if (!desc) {
 		spin_lock_irq(&fh->queue_lock);
 		list_del_init(&vb->queue);
diff --git a/drivers/misc/carma/carma-fpga.c b/drivers/misc/carma/carma-fpga.c
index 7508caf..b654c79 100644
--- a/drivers/misc/carma/carma-fpga.c
+++ b/drivers/misc/carma/carma-fpga.c
@@ -631,8 +631,7 @@ static int data_submit_dma(struct fpga_device *priv, struct data_buf *buf)
 	struct dma_async_tx_descriptor *tx;
 	dma_cookie_t cookie;
 	dma_addr_t dst, src;
-	unsigned long dma_flags = DMA_COMPL_SKIP_DEST_UNMAP |
-				  DMA_COMPL_SKIP_SRC_UNMAP;
+	unsigned long dma_flags = 0;
 
 	dst_sg = buf->vb.sglist;
 	dst_nents = buf->vb.sglen;
diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index 9144557..5e1f88f 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -238,8 +238,7 @@ static int atmel_nand_dma_op(struct mtd_info *mtd, void *buf, int len,
 
 	dma_dev = host->dma_chan->device;
 
-	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP |
-		DMA_COMPL_SKIP_DEST_UNMAP;
+	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
 
 	phys_addr = dma_map_single(dma_dev->dev, p, len, dir);
 	if (dma_mapping_error(dma_dev->dev, phys_addr)) {
diff --git a/drivers/mtd/nand/fsmc_nand.c b/drivers/mtd/nand/fsmc_nand.c
index 679ede8..fdb98f0 100644
--- a/drivers/mtd/nand/fsmc_nand.c
+++ b/drivers/mtd/nand/fsmc_nand.c
@@ -569,8 +569,6 @@ static int dma_xfer(struct fsmc_nand_data *host, void *buffer, int len,
 	dma_dev = chan->device;
 	dma_addr = dma_map_single(dma_dev->dev, buffer, len, direction);
 
-	flags |= DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP;
-
 	if (direction == DMA_TO_DEVICE) {
 		dma_src = dma_addr;
 		dma_dst = host->data_pa;
diff --git a/drivers/net/ethernet/micrel/ks8842.c b/drivers/net/ethernet/micrel/ks8842.c
index 24fb049..f657760 100644
--- a/drivers/net/ethernet/micrel/ks8842.c
+++ b/drivers/net/ethernet/micrel/ks8842.c
@@ -459,8 +459,7 @@ static int ks8842_tx_frame_dma(struct sk_buff *skb, struct net_device *netdev)
 		sg_dma_len(&ctl->sg) += 4 - sg_dma_len(&ctl->sg) % 4;
 
 	ctl->adesc = dmaengine_prep_slave_sg(ctl->chan,
-		&ctl->sg, 1, DMA_MEM_TO_DEV,
-		DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP);
+		&ctl->sg, 1, DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT);
 	if (!ctl->adesc)
 		return NETDEV_TX_BUSY;
 
@@ -571,8 +570,7 @@ static int __ks8842_start_new_rx_dma(struct net_device *netdev)
 		sg_dma_len(sg) = DMA_BUFFER_SIZE;
 
 		ctl->adesc = dmaengine_prep_slave_sg(ctl->chan,
-			sg, 1, DMA_DEV_TO_MEM,
-			DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP);
+			sg, 1, DMA_DEV_TO_MEM, DMA_PREP_INTERRUPT);
 
 		if (!ctl->adesc)
 			goto out;
diff --git a/drivers/spi/spi-dw-mid.c b/drivers/spi/spi-dw-mid.c
index b9f0192..6d207af 100644
--- a/drivers/spi/spi-dw-mid.c
+++ b/drivers/spi/spi-dw-mid.c
@@ -150,7 +150,7 @@ static int mid_spi_dma_transfer(struct dw_spi *dws, int cs_change)
 				&dws->tx_sgl,
 				1,
 				DMA_MEM_TO_DEV,
-				DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_DEST_UNMAP);
+				DMA_PREP_INTERRUPT);
 	txdesc->callback = dw_spi_dma_done;
 	txdesc->callback_param = dws;
 
@@ -173,7 +173,7 @@ static int mid_spi_dma_transfer(struct dw_spi *dws, int cs_change)
 				&dws->rx_sgl,
 				1,
 				DMA_DEV_TO_MEM,
-				DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_DEST_UNMAP);
+				DMA_PREP_INTERRUPT);
 	rxdesc->callback = dw_spi_dma_done;
 	rxdesc->callback_param = dws;
 
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index e954e9f..6f3873d 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -169,12 +169,6 @@ struct dma_interleaved_template {
  * @DMA_CTRL_ACK - if clear, the descriptor cannot be reused until the client
  *  acknowledges receipt, i.e. has has a chance to establish any dependency
  *  chains
- * @DMA_COMPL_SKIP_SRC_UNMAP - set to disable dma-unmapping the source buffer(s)
- * @DMA_COMPL_SKIP_DEST_UNMAP - set to disable dma-unmapping the destination(s)
- * @DMA_COMPL_SRC_UNMAP_SINGLE - set to do the source dma-unmapping as single
- * 	(if not set, do the source dma-unmapping as page)
- * @DMA_COMPL_DEST_UNMAP_SINGLE - set to do the destination dma-unmapping as single
- * 	(if not set, do the destination dma-unmapping as page)
  * @DMA_PREP_PQ_DISABLE_P - prevent generation of P while generating Q
  * @DMA_PREP_PQ_DISABLE_Q - prevent generation of Q while generating P
  * @DMA_PREP_CONTINUE - indicate to a driver that it is reusing buffers as
@@ -186,14 +180,10 @@ struct dma_interleaved_template {
 enum dma_ctrl_flags {
 	DMA_PREP_INTERRUPT = (1 << 0),
 	DMA_CTRL_ACK = (1 << 1),
-	DMA_COMPL_SKIP_SRC_UNMAP = (1 << 2),
-	DMA_COMPL_SKIP_DEST_UNMAP = (1 << 3),
-	DMA_COMPL_SRC_UNMAP_SINGLE = (1 << 4),
-	DMA_COMPL_DEST_UNMAP_SINGLE = (1 << 5),
-	DMA_PREP_PQ_DISABLE_P = (1 << 6),
-	DMA_PREP_PQ_DISABLE_Q = (1 << 7),
-	DMA_PREP_CONTINUE = (1 << 8),
-	DMA_PREP_FENCE = (1 << 9),
+	DMA_PREP_PQ_DISABLE_P = (1 << 2),
+	DMA_PREP_PQ_DISABLE_Q = (1 << 3),
+	DMA_PREP_CONTINUE = (1 << 4),
+	DMA_PREP_FENCE = (1 << 5),
 };
 
 /**

