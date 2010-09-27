Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923Ab0I0W6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 18:58:01 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:35821 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506Ab0I0W56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 18:57:58 -0400
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 2/4] fsldma: implement support for scatterlist to scatterlist copy
Date: Mon, 27 Sep 2010 15:57:55 -0700
Message-Id: <1285628277-26894-3-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285628277-26894-1-git-send-email-iws@ovro.caltech.edu>
References: <1285628277-26894-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Mon, 27 Sep 2010 15:57:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the DMAEngine API has support for scatterlist to scatterlist
copy, implement support for the Freescale DMA controller.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/dma/fsldma.c |  128 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 125 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index cea08be..1ed29d1 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -38,6 +38,8 @@
 #include <asm/fsldma.h>
 #include "fsldma.h"
 
+static const char msg_ld_oom[] = "No free memory for link descriptor\n";
+
 static void dma_init(struct fsldma_chan *chan)
 {
 	/* Reset the channel */
@@ -499,7 +501,7 @@ fsl_dma_prep_interrupt(struct dma_chan *dchan, unsigned long flags)
 
 	new = fsl_dma_alloc_descriptor(chan);
 	if (!new) {
-		dev_err(chan->dev, "No free memory for link descriptor\n");
+		dev_err(chan->dev, msg_ld_oom);
 		return NULL;
 	}
 
@@ -536,8 +538,7 @@ static struct dma_async_tx_descriptor *fsl_dma_prep_memcpy(
 		/* Allocate the link descriptor from DMA pool */
 		new = fsl_dma_alloc_descriptor(chan);
 		if (!new) {
-			dev_err(chan->dev,
-					"No free memory for link descriptor\n");
+			dev_err(chan->dev, msg_ld_oom);
 			goto fail;
 		}
 #ifdef FSL_DMA_LD_DEBUG
@@ -583,6 +584,125 @@ fail:
 	return NULL;
 }
 
+static struct dma_async_tx_descriptor *fsl_dma_prep_sg(struct dma_chan *dchan,
+	struct scatterlist *dst_sg, unsigned int dst_nents,
+	struct scatterlist *src_sg, unsigned int src_nents,
+	unsigned long flags)
+{
+	struct fsl_desc_sw *first = NULL, *prev = NULL, *new = NULL;
+	struct fsldma_chan *chan = to_fsl_chan(dchan);
+	size_t dst_avail, src_avail;
+	dma_addr_t dst, src;
+	size_t len;
+
+	/* basic sanity checks */
+	if (dst_nents == 0 || src_nents == 0)
+		return NULL;
+
+	if (dst_sg == NULL || src_sg == NULL)
+		return NULL;
+
+	/*
+	 * TODO: should we check that both scatterlists have the same
+	 * TODO: number of bytes in total? Is that really an error?
+	 */
+
+	/* get prepared for the loop */
+	dst_avail = sg_dma_len(dst_sg);
+	src_avail = sg_dma_len(src_sg);
+
+	/* run until we are out of scatterlist entries */
+	while (true) {
+
+		/* create the largest transaction possible */
+		len = min_t(size_t, src_avail, dst_avail);
+		len = min_t(size_t, len, FSL_DMA_BCR_MAX_CNT);
+		if (len == 0)
+			goto fetch;
+
+		dst = sg_dma_address(dst_sg) + sg_dma_len(dst_sg) - dst_avail;
+		src = sg_dma_address(src_sg) + sg_dma_len(src_sg) - src_avail;
+
+		/* allocate and populate the descriptor */
+		new = fsl_dma_alloc_descriptor(chan);
+		if (!new) {
+			dev_err(chan->dev, msg_ld_oom);
+			goto fail;
+		}
+#ifdef FSL_DMA_LD_DEBUG
+		dev_dbg(chan->dev, "new link desc alloc %p\n", new);
+#endif
+
+		set_desc_cnt(chan, &new->hw, len);
+		set_desc_src(chan, &new->hw, src);
+		set_desc_dst(chan, &new->hw, dst);
+
+		if (!first)
+			first = new;
+		else
+			set_desc_next(chan, &prev->hw, new->async_tx.phys);
+
+		new->async_tx.cookie = 0;
+		async_tx_ack(&new->async_tx);
+		prev = new;
+
+		/* Insert the link descriptor to the LD ring */
+		list_add_tail(&new->node, &first->tx_list);
+
+		/* update metadata */
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
+	new->async_tx.flags = flags; /* client is in control of this ack */
+	new->async_tx.cookie = -EBUSY;
+
+	/* Set End-of-link to the last link descriptor of new list */
+	set_ld_eol(chan, new);
+
+	return &first->async_tx;
+
+fail:
+	if (!first)
+		return NULL;
+
+	fsldma_free_desc_list_reverse(chan, &first->tx_list);
+	return NULL;
+}
+
 /**
  * fsl_dma_prep_slave_sg - prepare descriptors for a DMA_SLAVE transaction
  * @chan: DMA channel
@@ -1327,11 +1447,13 @@ static int __devinit fsldma_of_probe(struct platform_device *op,
 
 	dma_cap_set(DMA_MEMCPY, fdev->common.cap_mask);
 	dma_cap_set(DMA_INTERRUPT, fdev->common.cap_mask);
+	dma_cap_set(DMA_SG, fdev->common.cap_mask);
 	dma_cap_set(DMA_SLAVE, fdev->common.cap_mask);
 	fdev->common.device_alloc_chan_resources = fsl_dma_alloc_chan_resources;
 	fdev->common.device_free_chan_resources = fsl_dma_free_chan_resources;
 	fdev->common.device_prep_dma_interrupt = fsl_dma_prep_interrupt;
 	fdev->common.device_prep_dma_memcpy = fsl_dma_prep_memcpy;
+	fdev->common.device_prep_dma_sg = fsl_dma_prep_sg;
 	fdev->common.device_tx_status = fsl_tx_status;
 	fdev->common.device_issue_pending = fsl_dma_memcpy_issue_pending;
 	fdev->common.device_prep_slave_sg = fsl_dma_prep_slave_sg;
-- 
1.7.1

