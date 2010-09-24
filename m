Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449Ab0IXXNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 19:13:55 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:44951 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab0IXXNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 19:13:53 -0400
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH RFCv2 1/2] dmaengine: add support for scatterlist to scatterlist transfers
Date: Fri, 24 Sep 2010 16:13:51 -0700
Message-Id: <1285370032-16937-2-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285370032-16937-1-git-send-email-iws@ovro.caltech.edu>
References: <1285370032-16937-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Fri, 24 Sep 2010 16:13:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for scatterlist to scatterlist DMA transfers. This is
currently hidden behind a configuration option, which will allow drivers
which need this functionality to select it individually.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/dma/Kconfig       |    3 +
 drivers/dma/dmaengine.c   |  125 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dmaengine.h |    6 ++
 3 files changed, 134 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 9520cf0..82d2244 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -89,6 +89,9 @@ config AT_HDMAC
 	  Support the Atmel AHB DMA controller.  This can be integrated in
 	  chips such as the Atmel AT91SAM9RL.
 
+config DMAENGINE_SG_TO_SG
+	bool
+
 config FSL_DMA
 	tristate "Freescale Elo and Elo Plus DMA support"
 	depends on FSL_SOC
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 9d31d5e..9238b86 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -972,6 +972,131 @@ dma_async_memcpy_pg_to_pg(struct dma_chan *chan, struct page *dest_pg,
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
+	struct scatterlist *sg;
+	size_t transferred = 0;
+	size_t dst_total = 0;
+	size_t src_total = 0;
+	dma_addr_t dst, src;
+	size_t len;
+	int i;
+
+	if (dst_nents == 0 || src_nents == 0)
+		return -EINVAL;
+
+	if (dst_sg == NULL || src_sg == NULL)
+		return -EINVAL;
+
+	/* get the total count of bytes in each scatterlist */
+	for_each_sg(dst_sg, sg, dst_nents, i)
+		dst_total += sg_dma_len(sg);
+
+	for_each_sg(src_sg, sg, src_nents, i)
+		src_total += sg_dma_len(sg);
+
+	/* get prepared for the loop */
+	dst_avail = sg_dma_len(dst_sg);
+	src_avail = sg_dma_len(src_sg);
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
+		/*
+		 * get a descriptor
+		 *
+		 * we must poll for a descriptor here since the DMAEngine API
+		 * does not provide a way for external users to free previously
+		 * allocated descriptors
+		 */
+		for (;;) {
+			tx = dev->device_prep_dma_memcpy(chan, dst, src, len, 0);
+			if (likely(tx))
+				break;
+
+			dma_async_issue_pending(chan);
+		}
+
+		/* update metadata */
+		transferred += len;
+		dst_avail -= len;
+		src_avail -= len;
+
+		/* if this is the last transfer, setup the callback */
+		if (dst_total == transferred || src_total == transferred) {
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
+	/* update counters */
+	preempt_disable();
+	__this_cpu_add(chan->local->bytes_transferred, transferred);
+	__this_cpu_inc(chan->local->memcpy_count);
+	preempt_enable();
+
+	return 0;
+}
+EXPORT_SYMBOL(dma_async_memcpy_sg_to_sg);
+#endif
+
 void dma_async_tx_descriptor_init(struct dma_async_tx_descriptor *tx,
 	struct dma_chan *chan)
 {
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index c61d4ca..28803a0 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -632,6 +632,12 @@ dma_cookie_t dma_async_memcpy_buf_to_pg(struct dma_chan *chan,
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

