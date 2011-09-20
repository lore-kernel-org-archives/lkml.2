Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab1ITMMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 08:12:25 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55735 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab1ITMMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 08:12:23 -0400
From: Jassi Brar <jaswinder.singh@linaro.org>
To: dan.j.williams@intel.com, vkoul@infradead.org,
        linux-kernel@vger.kernel.org
Cc: rmk@arm.linux.org.uk, 21cnbao@gmail.com,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCHv3] DMAEngine: Define interleaved transfer request api
Date: Tue, 20 Sep 2011 17:42:10 +0530
Message-Id: <1316520730-3655-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316072789-12830-1-git-send-email-jaswinder.singh@linaro.org>
References: <1316072789-12830-1-git-send-email-jaswinder.singh@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define a new api that could be used for doing fancy data transfers
like interleaved to contiguous copy and vice-versa.
Traditional SG_list based transfers tend to be very inefficient in
such cases as where the interleave and chunk are only a few bytes,
which call for a very condensed api to convey pattern of the transfer.
This api supports all 4 variants of scatter-gather and contiguous transfer.

Of course, neither can this api help transfers that don't lend to DMA by
nature, i.e, scattered tiny read/writes with no periodic pattern.

Also since now we support SLAVE channels that might not provide
device_prep_slave_sg callback but device_prep_interleaved_dma,
remove the BUG_ON check.

Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
---

Changes since v2:
1) Added some notes to documentation.
2) Removed the BUG_ON check that expects every SLAVE channel to
   provide a prep_slave_sg, as we are now valid otherwise too.
3) Fixed the DMA_TX_TYPE_END offset - made it last element of enum.
4) Renamed prep_dma_genxfer to prep_interleaved_dma as Vinod wanted.

Changes since v1:
1) Dropped the 'dma_transaction_type' member until we really
   merge another type into this api. Instead added special
   type for this api - DMA_GENXFER in dma_transaction_type.
2) Renamed 'xfer_template' to 'dmaxfer_template' inorder to
   preserve namespace, closer to as suggested by Barry Song.

 Documentation/dmaengine.txt |    8 ++++
 drivers/dma/dmaengine.c     |    4 +-
 include/linux/dmaengine.h   |   77 +++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 85 insertions(+), 4 deletions(-)

diff --git a/Documentation/dmaengine.txt b/Documentation/dmaengine.txt
index 94b7e0f..962a2d3 100644
--- a/Documentation/dmaengine.txt
+++ b/Documentation/dmaengine.txt
@@ -75,6 +75,10 @@ The slave DMA usage consists of following steps:
    slave_sg	- DMA a list of scatter gather buffers from/to a peripheral
    dma_cyclic	- Perform a cyclic DMA operation from/to a peripheral till the
 		  operation is explicitly stopped.
+   interleaved_dma - This is common to Slave as well as M2M clients. For slave
+		 address of devices' fifo could be already known to the driver.
+		 Various types of operations could be expressed by setting
+		 appropriate values to the 'dmaxfer_template' members.
 
    A non-NULL return of this transfer API represents a "descriptor" for
    the given transaction.
@@ -89,6 +93,10 @@ The slave DMA usage consists of following steps:
 		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
 		size_t period_len, enum dma_data_direction direction);
 
+	struct dma_async_tx_descriptor *(*device_prep_interleaved_dma)(
+		struct dma_chan *chan, struct dmaxfer_template *xt,
+		unsigned long flags);
+
    The peripheral driver is expected to have mapped the scatterlist for
    the DMA operation prior to calling device_prep_slave_sg, and must
    keep the scatterlist mapped until the DMA operation has completed.
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index b48967b..a6c6051 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -693,12 +693,12 @@ int dma_async_device_register(struct dma_device *device)
 		!device->device_prep_dma_interrupt);
 	BUG_ON(dma_has_cap(DMA_SG, device->cap_mask) &&
 		!device->device_prep_dma_sg);
-	BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
-		!device->device_prep_slave_sg);
 	BUG_ON(dma_has_cap(DMA_CYCLIC, device->cap_mask) &&
 		!device->device_prep_dma_cyclic);
 	BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
 		!device->device_control);
+	BUG_ON(dma_has_cap(DMA_INTERLEAVE, device->cap_mask) &&
+		!device->device_prep_interleaved_dma);
 
 	BUG_ON(!device->device_alloc_chan_resources);
 	BUG_ON(!device->device_free_chan_resources);
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 8fbf40e..fcc85d7 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -71,11 +71,78 @@ enum dma_transaction_type {
 	DMA_ASYNC_TX,
 	DMA_SLAVE,
 	DMA_CYCLIC,
+	DMA_INTERLEAVE,
+/* last transaction type for creation of the capabilities mask */
+	DMA_TX_TYPE_END,
 };
 
-/* last transaction type for creation of the capabilities mask */
-#define DMA_TX_TYPE_END (DMA_CYCLIC + 1)
+/**
+ * Interleaved Transfer Request
+ * ----------------------------
+ * A chunk is collection of contiguous bytes to be transfered.
+ * The gap(in bytes) between two chunks is called inter-chunk-gap(ICG).
+ * ICGs may or maynot change between chunks.
+ * A FRAME is the smallest series of contiguous {chunk,icg} pairs,
+ *  that when repeated an integral number of times, specifies the transfer.
+ * A transfer template is specification of a Frame, the number of times
+ *  it is to be repeated and other per-transfer attributes.
+ *
+ * Practically, a client driver would have ready a template for each
+ *  type of transfer it is going to need during its lifetime and
+ *  set only 'src_start' and 'dst_start' before submitting the requests.
+ *
+ *
+ *  |      Frame-1        |       Frame-2       | ~ |       Frame-'numf'  |
+ *  |====....==.===...=...|====....==.===...=...| ~ |====....==.===...=...|
+ *
+ *    ==  Chunk size
+ *    ... ICG
+ */
 
+/**
+ * struct data_chunk - Element of scatter-gather list that makes a frame.
+ * @size: Number of bytes to read from source.
+ *	  size_dst := fn(op, size_src), so doesn't mean much for destination.
+ * @icg: Number of bytes to jump after last src/dst address of this
+ *	 chunk and before first src/dst address for next chunk.
+ *	 Ignored for dst(assumed 0), if dst_inc is true and dst_sgl is false.
+ *	 Ignored for src(assumed 0), if src_inc is true and src_sgl is false.
+ */
+struct data_chunk {
+	size_t size;
+	size_t icg;
+};
+
+/**
+ * struct dmaxfer_template - Template to convey DMAC the transfer pattern
+ *	 and attributes.
+ * @src_start: Bus address of source for the first chunk.
+ * @dst_start: Bus address of destination for the first chunk.
+ * @src_inc: If the source address increments after reading from it.
+ * @dst_inc: If the destination address increments after writing to it.
+ * @src_sgl: If the 'icg' of sgl[] applies to Source (scattered read).
+ *		Otherwise, source is read contiguously (icg ignored).
+ *		Ignored if src_inc is false.
+ * @dst_sgl: If the 'icg' of sgl[] applies to Destination (scattered write).
+ *		Otherwise, destination is filled contiguously (icg ignored).
+ *		Ignored if dst_inc is false.
+ * @frm_irq: If the client expects DMAC driver to do callback after each frame.
+ * @numf: Number of frames in this template.
+ * @frame_size: Number of chunks in a frame i.e, size of sgl[].
+ * @sgl: Array of {chunk,icg} pairs that make up a frame.
+ */
+struct dmaxfer_template {
+	dma_addr_t src_start;
+	dma_addr_t dst_start;
+	bool src_inc;
+	bool dst_inc;
+	bool src_sgl;
+	bool dst_sgl;
+	bool frm_irq;
+	size_t numf;
+	size_t frame_size;
+	struct data_chunk sgl[0];
+};
 
 /**
  * enum dma_ctrl_flags - DMA flags to augment operation preparation,
@@ -309,6 +376,8 @@ typedef void (*dma_async_tx_callback)(void *dma_async_param);
  * @chan: target channel for this operation
  * @tx_submit: set the prepared descriptor(s) to be executed by the engine
  * @callback: routine to call after this operation is complete
+ *	And after each frame if the 'frm_irq' flag is set during
+ *	device_prep_interleaved_dma.
  * @callback_param: general parameter to pass to the callback routine
  * ---async_tx api specific fields---
  * @next: at completion submit this descriptor
@@ -432,6 +501,7 @@ struct dma_tx_state {
  * @device_prep_dma_cyclic: prepare a cyclic dma operation suitable for audio.
  *	The function takes a buffer of size buf_len. The callback function will
  *	be called after period_len bytes have been transferred.
+ * @device_prep_interleaved_dma: Transfer expression in a generic way.
  * @device_control: manipulate all pending operations on a channel, returns
  *	zero or error code
  * @device_tx_status: poll for transaction completion, the optional
@@ -496,6 +566,9 @@ struct dma_device {
 	struct dma_async_tx_descriptor *(*device_prep_dma_cyclic)(
 		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
 		size_t period_len, enum dma_data_direction direction);
+	struct dma_async_tx_descriptor *(*device_prep_interleaved_dma)(
+		struct dma_chan *chan, struct dmaxfer_template *xt,
+		unsigned long flags);
 	int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		unsigned long arg);
 
-- 
1.7.4.1

