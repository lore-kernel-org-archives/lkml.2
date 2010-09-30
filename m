Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab0I3Vqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 17:46:54 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:41526 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060Ab0I3Vqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 17:46:49 -0400
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 3/4] fsldma: improved DMA_SLAVE support
Date: Thu, 30 Sep 2010 14:46:46 -0700
Message-Id: <1285883207-13761-4-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285883207-13761-1-git-send-email-iws@ovro.caltech.edu>
References: <1285883207-13761-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Thu, 30 Sep 2010 14:46:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the generic DMAEngine API has support for scatterlist to
scatterlist copying, the device_prep_slave_sg() portion of the
DMA_SLAVE API is no longer necessary and has been removed.

However, the device_control() portion of the DMA_SLAVE API is still
useful to control device specific parameters, such as externally
controlled DMA transfers and maximum burst length.

A special dma_ctrl_cmd has been added to enable externally controlled
DMA transfers. This is currently specific to the Freescale DMA
controller, but can easily be made generic when another user is found.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 arch/powerpc/include/asm/fsldma.h |  137 ----------------------
 drivers/dma/fsldma.c              |  226 +++++++-----------------------------
 include/linux/dmaengine.h         |    3 +
 3 files changed, 47 insertions(+), 319 deletions(-)
 delete mode 100644 arch/powerpc/include/asm/fsldma.h

diff --git a/arch/powerpc/include/asm/fsldma.h b/arch/powerpc/include/asm/fsldma.h
deleted file mode 100644
index debc5ed..0000000
--- a/arch/powerpc/include/asm/fsldma.h
+++ /dev/null
@@ -1,137 +0,0 @@
-/*
- * Freescale MPC83XX / MPC85XX DMA Controller
- *
- * Copyright (c) 2009 Ira W. Snyder <iws@ovro.caltech.edu>
- *
- * This file is licensed under the terms of the GNU General Public License
- * version 2. This program is licensed "as is" without any warranty of any
- * kind, whether express or implied.
- */
-
-#ifndef __ARCH_POWERPC_ASM_FSLDMA_H__
-#define __ARCH_POWERPC_ASM_FSLDMA_H__
-
-#include <linux/slab.h>
-#include <linux/dmaengine.h>
-
-/*
- * Definitions for the Freescale DMA controller's DMA_SLAVE implemention
- *
- * The Freescale DMA_SLAVE implementation was designed to handle many-to-many
- * transfers. An example usage would be an accelerated copy between two
- * scatterlists. Another example use would be an accelerated copy from
- * multiple non-contiguous device buffers into a single scatterlist.
- *
- * A DMA_SLAVE transaction is defined by a struct fsl_dma_slave. This
- * structure contains a list of hardware addresses that should be copied
- * to/from the scatterlist passed into device_prep_slave_sg(). The structure
- * also has some fields to enable hardware-specific features.
- */
-
-/**
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
- * struct fsl_dma_slave
- * @addresses: a linked list of struct fsl_dma_hw_addr structures
- * @request_count: value for DMA request count
- * @src_loop_size: setup and enable constant source-address DMA transfers
- * @dst_loop_size: setup and enable constant destination address DMA transfers
- * @external_start: enable externally started DMA transfers
- * @external_pause: enable externally paused DMA transfers
- *
- * Holds a list of address / length pairs for use with the DMAEngine
- * DMA_SLAVE API implementation for the Freescale DMA controller.
- */
-struct fsl_dma_slave {
-
-	/* List of hardware address/length pairs */
-	struct list_head addresses;
-
-	/* Support for extra controller features */
-	unsigned int request_count;
-	unsigned int src_loop_size;
-	unsigned int dst_loop_size;
-	bool external_start;
-	bool external_pause;
-};
-
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
-#endif /* __ARCH_POWERPC_ASM_FSLDMA_H__ */
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 1ed29d1..286c3ac 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -35,7 +35,6 @@
 #include <linux/dmapool.h>
 #include <linux/of_platform.h>
 
-#include <asm/fsldma.h>
 #include "fsldma.h"
 
 static const char msg_ld_oom[] = "No free memory for link descriptor\n";
@@ -719,207 +718,70 @@ static struct dma_async_tx_descriptor *fsl_dma_prep_slave_sg(
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
+	struct dma_slave_config *config;
 	struct fsldma_chan *chan;
 	unsigned long flags;
-
-	/* Only supports DMA_TERMINATE_ALL */
-	if (cmd != DMA_TERMINATE_ALL)
-		return -ENXIO;
+	int size;
 
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
+		config = (struct dma_slave_config *)arg;
+
+		/* make sure the channel supports setting burst size */
+		if (!chan->set_request_count)
+			return -ENXIO;
+
+		/* we set the controller burst size depending on direction */
+		if (config->direction == DMA_TO_DEVICE)
+			size = config->dst_addr_width * config->dst_maxburst;
+		else
+			size = config->src_addr_width * config->src_maxburst;
+
+		chan->set_request_count(chan, size);
+		return 0;
+
+	case FSLDMA_EXTERNAL_START:
+
+		/* make sure the channel supports external start */
+		if (!chan->toggle_ext_start)
+			return -ENXIO;
+
+		chan->toggle_ext_start(chan, arg);
+		return 0;
+
+	default:
+		return -ENXIO;
+	}
 
 	return 0;
 }
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 7c44620..f92c139 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -120,12 +120,15 @@ enum dma_ctrl_flags {
  * configuration data in statically from the platform). An additional
  * argument of struct dma_slave_config must be passed in with this
  * command.
+ * @FSLDMA_EXTERNAL_START: this command will put the Freescale DMA controller
+ * into external start mode.
  */
 enum dma_ctrl_cmd {
 	DMA_TERMINATE_ALL,
 	DMA_PAUSE,
 	DMA_RESUME,
 	DMA_SLAVE_CONFIG,
+	FSLDMA_EXTERNAL_START,
 };
 
 /**
-- 
1.7.1

