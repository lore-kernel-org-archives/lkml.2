Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020Ab0IXTqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 15:46:16 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:47098 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757825Ab0IXTqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 15:46:12 -0400
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH RFCv1 1/2] dmaengine: add support for scatterlist to scatterlist transfers
Date: Fri, 24 Sep 2010 12:46:10 -0700
Message-Id: <1285357571-23377-2-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285357571-23377-1-git-send-email-iws@ovro.caltech.edu>
References: <1285357571-23377-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Fri, 24 Sep 2010 12:46:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for scatterlist to scatterlist DMA transfers. As
requested by Dan, this is hidden behind an ifdef so that it can be
selected by the drivers that need it.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/dma/Kconfig       |    4 ++
 drivers/dma/dmaengine.c   |  119 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dmaengine.h |   10 ++++
 3 files changed, 133 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 9520cf0..f688669 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -89,10 +89,14 @@ config AT_HDMAC
 	  Support the Atmel AHB DMA controller.  This can be integrated in
 	  chips such as the Atmel AT91SAM9RL.
 
+config DMAENGINE_SG_TO_SG
+	bool
+
 config FSL_DMA
 	tristate "Freescale Elo and Elo Plus DMA support"
 	depends on FSL_SOC
 	select DMA_ENGINE
+	select DMAENGINE_SG_TO_SG
 	---help---
 	  Enable support for the Freescale Elo and Elo Plus DMA controllers.
 	  The Elo is the DMA controller on some 82xx and 83xx parts, and the
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 9d31d5e..57ec1e5 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -972,10 +972,129 @@ dma_async_memcpy_pg_to_pg(struct dma_chan *chan, struct page *dest_pg,
 }
 EXPORT_SYMBOL(dma_async_memcpy_pg_to_pg);
 
+#ifdef CONFIG_DMAENGINE_SG_TO_SG
+dma_cookie_t
+dma_async_memcpy_sg_to_sg(struct dma_chan *chan,
+			  struct scatterlist *dst_sg, unsigned int dst_nents,
+			  struct scatterlist *src_sg, unsigned int src_nents,
+			  dma_async_tx_callback cb, void *cb_param)
+{
+	struct dma_device *dev = chan->device;
+	struct dma_async_tx_descriptor *tx;
+	dma_cookie_t cookie = -ENOMEM;
+	size_t dst_avail, src_avail;
+	struct list_head tx_list;
+	size_t transferred = 0;
+	dma_addr_t dst, src;
+	size_t len;
+
+	if (dst_nents == 0 || src_nents == 0)
+		return -EINVAL;
+
+	if (dst_sg == NULL || src_sg == NULL)
+		return -EINVAL;
+
+	/* get prepared for the loop */
+	dst_avail = sg_dma_len(dst_sg);
+	src_avail = sg_dma_len(src_sg);
+
+	INIT_LIST_HEAD(&tx_list);
+
+	/* run until we are out of descriptors */
+	while (true) {
+
+		/* create the largest transaction possible */
+		len = min_t(size_t, src_avail, dst_avail);
+		if (len == 0)
+			goto fetch;
+
+		dst = sg_dma_address(dst_sg) + sg_dma_len(dst_sg) - dst_avail;
+		src = sg_dma_address(src_sg) + sg_dma_len(src_sg) - src_avail;
+
+		/* setup the transaction */
+		tx = dev->device_prep_dma_memcpy(chan, dst, src, len, 0);
+		if (!tx) {
+			dev_err(dev->dev, "failed to alloc desc for memcpy\n");
+			return -ENOMEM;
+		}
+
+		/* keep track of the tx for later */
+		list_add_tail(&tx->entry, &tx_list);
+
+		/* update metadata */
+		transferred += len;
+		dst_avail -= len;
+		src_avail -= len;
+
+fetch:
+		/* fetch the next dst scatterlist entry */
+		if (dst_avail == 0) {
+
+			/* no more entries: we're done */
+			if (dst_nents == 0)
+				break;
+
+			/* fetch the next entry: if there are no more: done */
+			dst_sg = sg_next(dst_sg);
+			if (dst_sg == NULL)
+				break;
+
+			dst_nents--;
+			dst_avail = sg_dma_len(dst_sg);
+		}
+
+		/* fetch the next src scatterlist entry */
+		if (src_avail == 0) {
+
+			/* no more entries: we're done */
+			if (src_nents == 0)
+				break;
+
+			/* fetch the next entry: if there are no more: done */
+			src_sg = sg_next(src_sg);
+			if (src_sg == NULL)
+				break;
+
+			src_nents--;
+			src_avail = sg_dma_len(src_sg);
+		}
+	}
+
+	/* loop through the list of descriptors and submit them */
+	list_for_each_entry(tx, &tx_list, entry) {
+
+		/* this is the last descriptor: add the callback */
+		if (list_is_last(&tx->entry, &tx_list)) {
+			tx->callback = cb;
+			tx->callback_param = cb_param;
+		}
+
+		/* submit the transaction */
+		cookie = tx->tx_submit(tx);
+		if (dma_submit_error(cookie)) {
+			dev_err(dev->dev, "failed to submit desc\n");
+			return cookie;
+		}
+	}
+
+	/* update counters */
+	preempt_disable();
+	__this_cpu_add(chan->local->bytes_transferred, transferred);
+	__this_cpu_inc(chan->local->memcpy_count);
+	preempt_enable();
+
+	return cookie;
+}
+EXPORT_SYMBOL(dma_async_memcpy_sg_to_sg);
+#endif
+
 void dma_async_tx_descriptor_init(struct dma_async_tx_descriptor *tx,
 	struct dma_chan *chan)
 {
 	tx->chan = chan;
+	#ifdef CONFIG_DMAENGINE_SG_TO_SG
+	INIT_LIST_HEAD(&tx->entry);
+	#endif
 	#ifndef CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH
 	spin_lock_init(&tx->lock);
 	#endif
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index c61d4ca..5507f4c 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -24,6 +24,7 @@
 #include <linux/device.h>
 #include <linux/uio.h>
 #include <linux/dma-mapping.h>
+#include <linux/list.h>
 
 /**
  * typedef dma_cookie_t - an opaque DMA cookie
@@ -316,6 +317,9 @@ struct dma_async_tx_descriptor {
 	dma_cookie_t (*tx_submit)(struct dma_async_tx_descriptor *tx);
 	dma_async_tx_callback callback;
 	void *callback_param;
+#ifdef CONFIG_DMAENGINE_SG_TO_SG
+	struct list_head entry;
+#endif
 #ifndef CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH
 	struct dma_async_tx_descriptor *next;
 	struct dma_async_tx_descriptor *parent;
@@ -632,6 +636,12 @@ dma_cookie_t dma_async_memcpy_buf_to_pg(struct dma_chan *chan,
 dma_cookie_t dma_async_memcpy_pg_to_pg(struct dma_chan *chan,
 	struct page *dest_pg, unsigned int dest_off, struct page *src_pg,
 	unsigned int src_off, size_t len);
+#ifdef CONFIG_DMAENGINE_SG_TO_SG
+dma_cookie_t dma_async_memcpy_sg_to_sg(struct dma_chan *chan,
+	struct scatterlist *dst_sg, unsigned int dst_nents,
+	struct scatterlist *src_sg, unsigned int src_nents,
+	dma_async_tx_callback cb, void *cb_param);
+#endif
 void dma_async_tx_descriptor_init(struct dma_async_tx_descriptor *tx,
 	struct dma_chan *chan);
 
-- 
1.7.1

