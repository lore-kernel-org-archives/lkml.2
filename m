Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab1IOHqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 03:46:54 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:57549 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab1IOHqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 03:46:53 -0400
From: Jassi Brar <jaswinder.singh@linaro.org>
To: dan.j.williams@intel.com, vkoul@infradead.org,
        linux-kernel@vger.kernel.org
Cc: rmk+kernel@arm.linux.org.uk, 21cnbao@gmail.com,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCHv2] DMAEngine: Define generic transfer request api
Date: Thu, 15 Sep 2011 13:16:29 +0530
Message-Id: <1316072789-12830-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1313147667-3385-1-git-send-email-jaswinder.singh@linaro.org>
References: <1313147667-3385-1-git-send-email-jaswinder.singh@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define a new api that could be used for doing fancy data transfers
like interleaved to contiguous copy and vice-versa.
Traditional SG_list based transfers tend to be very inefficient in
such cases as where the interleave and chunk are only a few bytes,
which call for a very condensed api to convey pattern of the transfer.

This api supports all 4 variants of scatter-gather and contiguous transfer.
Besides, in future it could also represent common operations like
        device_prep_dma_{cyclic, memset, memcpy}
and maybe some more that I am not sure of.

Of course, neither can this api help transfers that don't lend to DMA by
nature, i.e, scattered tiny read/writes with no periodic pattern.

Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
---

Changes since v1:
   1) Dropped the 'dma_transaction_type' member until we really
      merge another type into this api. Instead added special
      type for this api - DMA_GENXFER in dma_transaction_type.
   2) Renamed 'xfer_template' to 'dmaxfer_template' inorder to
      preserve namespace, closer to as suggested by Barry Song.

 drivers/dma/dmaengine.c   |    2 +
 include/linux/dmaengine.h |   71 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index b48967b..63284f6 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -699,6 +699,8 @@ int dma_async_device_register(struct dma_device *device)
 		!device->device_prep_dma_cyclic);
 	BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
 		!device->device_control);
+	BUG_ON(dma_has_cap(DMA_GENXFER, device->cap_mask) &&
+		!device->device_prep_dma_genxfer);
 
 	BUG_ON(!device->device_alloc_chan_resources);
 	BUG_ON(!device->device_free_chan_resources);
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 8fbf40e..68ebe6c 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -71,11 +71,79 @@ enum dma_transaction_type {
 	DMA_ASYNC_TX,
 	DMA_SLAVE,
 	DMA_CYCLIC,
+	DMA_GENXFER,
 };
 
 /* last transaction type for creation of the capabilities mask */
 #define DMA_TX_TYPE_END (DMA_CYCLIC + 1)
 
+/**
+ * Generic Transfer Request
+ * ------------------------
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
+
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
@@ -432,6 +500,7 @@ struct dma_tx_state {
  * @device_prep_dma_cyclic: prepare a cyclic dma operation suitable for audio.
  *	The function takes a buffer of size buf_len. The callback function will
  *	be called after period_len bytes have been transferred.
+ * @device_prep_dma_genxfer: Transfer expression in a generic way.
  * @device_control: manipulate all pending operations on a channel, returns
  *	zero or error code
  * @device_tx_status: poll for transaction completion, the optional
@@ -496,6 +565,8 @@ struct dma_device {
 	struct dma_async_tx_descriptor *(*device_prep_dma_cyclic)(
 		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
 		size_t period_len, enum dma_data_direction direction);
+	struct dma_async_tx_descriptor *(*device_prep_dma_genxfer)(
+		struct dma_chan *chan, struct dmaxfer_template *xt);
 	int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		unsigned long arg);
 
-- 
1.7.4.1

