Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463Ab0IXXN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 19:13:56 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:44953 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411Ab0IXXNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 19:13:53 -0400
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH RFCv2 2/2] fsldma: use generic support for scatterlist to scatterlist transfers
Date: Fri, 24 Sep 2010 16:13:52 -0700
Message-Id: <1285370032-16937-3-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285370032-16937-1-git-send-email-iws@ovro.caltech.edu>
References: <1285370032-16937-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Fri, 24 Sep 2010 16:13:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fsldma driver uses the DMA_SLAVE API to handle scatterlist to
scatterlist DMA transfers. For quite a while now, it has been possible
to mimic the operation by using the device_prep_dma_memcpy() routine
intelligently.

Now that the DMAEngine API has grown generic support for scatterlist to
scatterlist transfers, this operation is no longer needed. The generic
support is used for scatterlist to scatterlist transfers.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 arch/powerpc/include/asm/fsldma.h |  115 ++------------------
 drivers/dma/fsldma.c              |  219 +++++++------------------------------
 2 files changed, 48 insertions(+), 286 deletions(-)

diff --git a/arch/powerpc/include/asm/fsldma.h b/arch/powerpc/include/asm/fsldma.h
index debc5ed..dc0bd27 100644
--- a/arch/powerpc/include/asm/fsldma.h
+++ b/arch/powerpc/include/asm/fsldma.h
@@ -1,7 +1,7 @@
 /*
  * Freescale MPC83XX / MPC85XX DMA Controller
  *
- * Copyright (c) 2009 Ira W. Snyder <iws@ovro.caltech.edu>
+ * Copyright (c) 2009-2010 Ira W. Snyder <iws@ovro.caltech.edu>
  *
  * This file is licensed under the terms of the GNU General Public License
  * version 2. This program is licensed "as is" without any warranty of any
@@ -11,127 +11,32 @@
 #ifndef __ARCH_POWERPC_ASM_FSLDMA_H__
 #define __ARCH_POWERPC_ASM_FSLDMA_H__
 
-#include <linux/slab.h>
 #include <linux/dmaengine.h>
 
 /*
- * Definitions for the Freescale DMA controller's DMA_SLAVE implemention
+ * The Freescale DMA controller has several features that are not accomodated
+ * in the Linux DMAEngine API. Therefore, the generic structure is expanded
+ * to allow drivers to use these features.
  *
- * The Freescale DMA_SLAVE implementation was designed to handle many-to-many
- * transfers. An example usage would be an accelerated copy between two
- * scatterlists. Another example use would be an accelerated copy from
- * multiple non-contiguous device buffers into a single scatterlist.
+ * This structure should be passed into the DMAEngine routine device_control()
+ * as in this example:
  *
- * A DMA_SLAVE transaction is defined by a struct fsl_dma_slave. This
- * structure contains a list of hardware addresses that should be copied
- * to/from the scatterlist passed into device_prep_slave_sg(). The structure
- * also has some fields to enable hardware-specific features.
+ * chan->device->device_control(chan, DMA_SLAVE_CONFIG, (unsigned long)cfg);
  */
 
 /**
- * struct fsl_dma_hw_addr
- * @entry: linked list entry
- * @address: the hardware address
- * @length: length to transfer
- *
- * Holds a single physical hardware address / length pair for use
- * with the DMAEngine DMA_SLAVE API.
- */
-struct fsl_dma_hw_addr {
-	struct list_head entry;
-
-	dma_addr_t address;
-	size_t length;
-};
-
-/**
  * struct fsl_dma_slave
- * @addresses: a linked list of struct fsl_dma_hw_addr structures
+ * @config: the standard Linux DMAEngine API DMA_SLAVE configuration
  * @request_count: value for DMA request count
- * @src_loop_size: setup and enable constant source-address DMA transfers
- * @dst_loop_size: setup and enable constant destination address DMA transfers
  * @external_start: enable externally started DMA transfers
  * @external_pause: enable externally paused DMA transfers
- *
- * Holds a list of address / length pairs for use with the DMAEngine
- * DMA_SLAVE API implementation for the Freescale DMA controller.
  */
-struct fsl_dma_slave {
+struct fsldma_slave_config {
+	struct dma_slave_config config;
 
-	/* List of hardware address/length pairs */
-	struct list_head addresses;
-
-	/* Support for extra controller features */
 	unsigned int request_count;
-	unsigned int src_loop_size;
-	unsigned int dst_loop_size;
 	bool external_start;
 	bool external_pause;
 };
 
-/**
- * fsl_dma_slave_append - add an address/length pair to a struct fsl_dma_slave
- * @slave: the &struct fsl_dma_slave to add to
- * @address: the hardware address to add
- * @length: the length of bytes to transfer from @address
- *
- * Add a hardware address/length pair to a struct fsl_dma_slave. Returns 0 on
- * success, -ERRNO otherwise.
- */
-static inline int fsl_dma_slave_append(struct fsl_dma_slave *slave,
-				       dma_addr_t address, size_t length)
-{
-	struct fsl_dma_hw_addr *addr;
-
-	addr = kzalloc(sizeof(*addr), GFP_ATOMIC);
-	if (!addr)
-		return -ENOMEM;
-
-	INIT_LIST_HEAD(&addr->entry);
-	addr->address = address;
-	addr->length = length;
-
-	list_add_tail(&addr->entry, &slave->addresses);
-	return 0;
-}
-
-/**
- * fsl_dma_slave_free - free a struct fsl_dma_slave
- * @slave: the struct fsl_dma_slave to free
- *
- * Free a struct fsl_dma_slave and all associated address/length pairs
- */
-static inline void fsl_dma_slave_free(struct fsl_dma_slave *slave)
-{
-	struct fsl_dma_hw_addr *addr, *tmp;
-
-	if (slave) {
-		list_for_each_entry_safe(addr, tmp, &slave->addresses, entry) {
-			list_del(&addr->entry);
-			kfree(addr);
-		}
-
-		kfree(slave);
-	}
-}
-
-/**
- * fsl_dma_slave_alloc - allocate a struct fsl_dma_slave
- * @gfp: the flags to pass to kmalloc when allocating this structure
- *
- * Allocate a struct fsl_dma_slave for use by the DMA_SLAVE API. Returns a new
- * struct fsl_dma_slave on success, or NULL on failure.
- */
-static inline struct fsl_dma_slave *fsl_dma_slave_alloc(gfp_t gfp)
-{
-	struct fsl_dma_slave *slave;
-
-	slave = kzalloc(sizeof(*slave), gfp);
-	if (!slave)
-		return NULL;
-
-	INIT_LIST_HEAD(&slave->addresses);
-	return slave;
-}
-
 #endif /* __ARCH_POWERPC_ASM_FSLDMA_H__ */
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index cea08be..c90b393 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -599,207 +599,64 @@ static struct dma_async_tx_descriptor *fsl_dma_prep_slave_sg(
 	struct dma_chan *dchan, struct scatterlist *sgl, unsigned int sg_len,
 	enum dma_data_direction direction, unsigned long flags)
 {
-	struct fsldma_chan *chan;
-	struct fsl_desc_sw *first = NULL, *prev = NULL, *new = NULL;
-	struct fsl_dma_slave *slave;
-	size_t copy;
-
-	int i;
-	struct scatterlist *sg;
-	size_t sg_used;
-	size_t hw_used;
-	struct fsl_dma_hw_addr *hw;
-	dma_addr_t dma_dst, dma_src;
-
-	if (!dchan)
-		return NULL;
-
-	if (!dchan->private)
-		return NULL;
-
-	chan = to_fsl_chan(dchan);
-	slave = dchan->private;
-
-	if (list_empty(&slave->addresses))
-		return NULL;
-
-	hw = list_first_entry(&slave->addresses, struct fsl_dma_hw_addr, entry);
-	hw_used = 0;
-
 	/*
-	 * Build the hardware transaction to copy from the scatterlist to
-	 * the hardware, or from the hardware to the scatterlist
+	 * This operation is not supported on the Freescale DMA controller
 	 *
-	 * If you are copying from the hardware to the scatterlist and it
-	 * takes two hardware entries to fill an entire page, then both
-	 * hardware entries will be coalesced into the same page
-	 *
-	 * If you are copying from the scatterlist to the hardware and a
-	 * single page can fill two hardware entries, then the data will
-	 * be read out of the page into the first hardware entry, and so on
+	 * However, we need to provide the function pointer to allow the
+	 * device_control() method to work.
 	 */
-	for_each_sg(sgl, sg, sg_len, i) {
-		sg_used = 0;
-
-		/* Loop until the entire scatterlist entry is used */
-		while (sg_used < sg_dma_len(sg)) {
-
-			/*
-			 * If we've used up the current hardware address/length
-			 * pair, we need to load a new one
-			 *
-			 * This is done in a while loop so that descriptors with
-			 * length == 0 will be skipped
-			 */
-			while (hw_used >= hw->length) {
-
-				/*
-				 * If the current hardware entry is the last
-				 * entry in the list, we're finished
-				 */
-				if (list_is_last(&hw->entry, &slave->addresses))
-					goto finished;
-
-				/* Get the next hardware address/length pair */
-				hw = list_entry(hw->entry.next,
-						struct fsl_dma_hw_addr, entry);
-				hw_used = 0;
-			}
-
-			/* Allocate the link descriptor from DMA pool */
-			new = fsl_dma_alloc_descriptor(chan);
-			if (!new) {
-				dev_err(chan->dev, "No free memory for "
-						       "link descriptor\n");
-				goto fail;
-			}
-#ifdef FSL_DMA_LD_DEBUG
-			dev_dbg(chan->dev, "new link desc alloc %p\n", new);
-#endif
-
-			/*
-			 * Calculate the maximum number of bytes to transfer,
-			 * making sure it is less than the DMA controller limit
-			 */
-			copy = min_t(size_t, sg_dma_len(sg) - sg_used,
-					     hw->length - hw_used);
-			copy = min_t(size_t, copy, FSL_DMA_BCR_MAX_CNT);
-
-			/*
-			 * DMA_FROM_DEVICE
-			 * from the hardware to the scatterlist
-			 *
-			 * DMA_TO_DEVICE
-			 * from the scatterlist to the hardware
-			 */
-			if (direction == DMA_FROM_DEVICE) {
-				dma_src = hw->address + hw_used;
-				dma_dst = sg_dma_address(sg) + sg_used;
-			} else {
-				dma_src = sg_dma_address(sg) + sg_used;
-				dma_dst = hw->address + hw_used;
-			}
-
-			/* Fill in the descriptor */
-			set_desc_cnt(chan, &new->hw, copy);
-			set_desc_src(chan, &new->hw, dma_src);
-			set_desc_dst(chan, &new->hw, dma_dst);
-
-			/*
-			 * If this is not the first descriptor, chain the
-			 * current descriptor after the previous descriptor
-			 */
-			if (!first) {
-				first = new;
-			} else {
-				set_desc_next(chan, &prev->hw,
-					      new->async_tx.phys);
-			}
-
-			new->async_tx.cookie = 0;
-			async_tx_ack(&new->async_tx);
-
-			prev = new;
-			sg_used += copy;
-			hw_used += copy;
-
-			/* Insert the link descriptor into the LD ring */
-			list_add_tail(&new->node, &first->tx_list);
-		}
-	}
-
-finished:
-
-	/* All of the hardware address/length pairs had length == 0 */
-	if (!first || !new)
-		return NULL;
-
-	new->async_tx.flags = flags;
-	new->async_tx.cookie = -EBUSY;
-
-	/* Set End-of-link to the last link descriptor of new list */
-	set_ld_eol(chan, new);
-
-	/* Enable extra controller features */
-	if (chan->set_src_loop_size)
-		chan->set_src_loop_size(chan, slave->src_loop_size);
-
-	if (chan->set_dst_loop_size)
-		chan->set_dst_loop_size(chan, slave->dst_loop_size);
-
-	if (chan->toggle_ext_start)
-		chan->toggle_ext_start(chan, slave->external_start);
-
-	if (chan->toggle_ext_pause)
-		chan->toggle_ext_pause(chan, slave->external_pause);
-
-	if (chan->set_request_count)
-		chan->set_request_count(chan, slave->request_count);
-
-	return &first->async_tx;
-
-fail:
-	/* If first was not set, then we failed to allocate the very first
-	 * descriptor, and we're done */
-	if (!first)
-		return NULL;
-
-	/*
-	 * First is set, so all of the descriptors we allocated have been added
-	 * to first->tx_list, INCLUDING "first" itself. Therefore we
-	 * must traverse the list backwards freeing each descriptor in turn
-	 *
-	 * We're re-using variables for the loop, oh well
-	 */
-	fsldma_free_desc_list_reverse(chan, &first->tx_list);
 	return NULL;
 }
 
 static int fsl_dma_device_control(struct dma_chan *dchan,
 				  enum dma_ctrl_cmd cmd, unsigned long arg)
 {
+	struct fsldma_slave_config *cfg;
 	struct fsldma_chan *chan;
 	unsigned long flags;
 
-	/* Only supports DMA_TERMINATE_ALL */
-	if (cmd != DMA_TERMINATE_ALL)
-		return -ENXIO;
-
 	if (!dchan)
 		return -EINVAL;
 
 	chan = to_fsl_chan(dchan);
 
-	/* Halt the DMA engine */
-	dma_halt(chan);
+	switch (cmd) {
+	case DMA_TERMINATE_ALL:
+		/* Halt the DMA engine */
+		dma_halt(chan);
 
-	spin_lock_irqsave(&chan->desc_lock, flags);
+		spin_lock_irqsave(&chan->desc_lock, flags);
 
-	/* Remove and free all of the descriptors in the LD queue */
-	fsldma_free_desc_list(chan, &chan->ld_pending);
-	fsldma_free_desc_list(chan, &chan->ld_running);
+		/* Remove and free all of the descriptors in the LD queue */
+		fsldma_free_desc_list(chan, &chan->ld_pending);
+		fsldma_free_desc_list(chan, &chan->ld_running);
 
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
+		spin_unlock_irqrestore(&chan->desc_lock, flags);
+		return 0;
+
+	case DMA_SLAVE_CONFIG:
+
+		cfg = (struct fsldma_slave_config *)arg;
+		if (chan->set_request_count)
+			chan->set_request_count(chan, cfg->request_count);
+
+		if (chan->toggle_ext_start)
+			chan->toggle_ext_start(chan, cfg->external_start);
+
+		if (chan->toggle_ext_pause)
+			chan->toggle_ext_pause(chan, cfg->external_pause);
+
+		/*
+		 * TODO: add other features
+		 *
+		 * I'm not sure how to use the members dma_slave_config to
+		 * control the src/dst address hold features.
+		 */
+		return 0;
+
+	default:
+		return -ENXIO;
+	}
 
 	return 0;
 }
-- 
1.7.1

