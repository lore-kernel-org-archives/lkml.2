Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab2AZO4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 09:56:55 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:56363 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab2AZO4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 09:56:44 -0500
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-mmc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-serial@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 1/7 v2] dmaengine: add a simple dma library
Date: Thu, 26 Jan 2012 15:56:18 +0100
Message-Id: <1327589784-4287-2-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1327589784-4287-1-git-send-email-g.liakhovetski@gmx.de>
References: <1327589784-4287-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:ng5AWhZl/FztHpe3Mzn4ZCtkqoBxV2gXIsX6Vw/Z4d8
 QweXrNLtDuv6BllUr3n/wWuqjn0Tbn47QAhPUcxjsXOm2HY4Zo
 FQZHmjQ82C/6DmMIRZo9DRPv1lo7lvIhj4psEQoij6rElbEkYe
 7aH0ILgktzoaSwG4Z8A8CKImfz/c+SzgF5hUckSsNU0cNPrFHF
 WKWR9X7PbjZLpMQu6t+fNbVC1Hy9GpN7Lcl9gcjWopdfG1/Xvq
 FAw3+rV4nv57Mk3Cpt2DPfGik4crAfM8ptCGTTGN9g/MLQM6mO
 j6d+3h9kXDaqkFVOS51oV7ZQWKKoNc9gPld8LvkjSjNMuOGrTJ
 2pqz6B1FglgaKs/kUNt2yK8m3nPWllxlLENSfxLOqDwmjv5APN
 USixx7/JNY/wA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a library of functions, helping to implement dmaengine
drivers for hardware, unable to handle scatter-gather lists natively.
The first version of this driver only supports memcpy and slave DMA
operation.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

v2:

1. switch from using a tasklet to threaded IRQ, which allowed to
2. remove lock / unlock inline functions
3. remove __devinit, __devexit annotations

 drivers/dma/Kconfig        |    3 +
 drivers/dma/Makefile       |    1 +
 drivers/dma/dma-simple.c   |  873 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dma-simple.h |  124 +++++++
 4 files changed, 1001 insertions(+), 0 deletions(-)
 create mode 100644 drivers/dma/dma-simple.c
 create mode 100644 include/linux/dma-simple.h

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index f1a2749..f7c583e 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -149,6 +149,9 @@ config TXX9_DMAC
 	  Support the TXx9 SoC internal DMA controller.  This can be
 	  integrated in chips such as the Toshiba TX4927/38/39.
 
+config DMA_SIMPLE
+	tristate
+
 config SH_DMAE
 	tristate "Renesas SuperH DMAC support"
 	depends on (SUPERH && SH_DMA) || (ARM && ARCH_SHMOBILE)
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index 009a222..d63f773 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -2,6 +2,7 @@ ccflags-$(CONFIG_DMADEVICES_DEBUG)  := -DDEBUG
 ccflags-$(CONFIG_DMADEVICES_VDEBUG) += -DVERBOSE_DEBUG
 
 obj-$(CONFIG_DMA_ENGINE) += dmaengine.o
+obj-$(CONFIG_DMA_SIMPLE) += dma-simple.o
 obj-$(CONFIG_NET_DMA) += iovlock.o
 obj-$(CONFIG_INTEL_MID_DMAC) += intel_mid_dma.o
 obj-$(CONFIG_DMATEST) += dmatest.o
diff --git a/drivers/dma/dma-simple.c b/drivers/dma/dma-simple.c
new file mode 100644
index 0000000..49d8f7d
--- /dev/null
+++ b/drivers/dma/dma-simple.c
@@ -0,0 +1,873 @@
+/*
+ * Simple dmaengine driver library
+ *
+ * extracted from shdma.c
+ *
+ * Copyright (C) 2011-2012 Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ * Copyright (C) 2009 Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
+ * Copyright (C) 2009 Renesas Solutions, Inc. All rights reserved.
+ * Copyright (C) 2007 Freescale Semiconductor, Inc. All rights reserved.
+ *
+ * This is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/dma-simple.h>
+#include <linux/dmaengine.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+/* DMA descriptor control */
+enum simple_desc_status {
+	DESC_IDLE,
+	DESC_PREPARED,
+	DESC_SUBMITTED,
+	DESC_COMPLETED,	/* completed, have to call callback */
+	DESC_WAITING,	/* callback called, waiting for ack / re-submit */
+};
+
+#define NR_DESCS_PER_CHANNEL 32
+
+#define to_simple_chan(c) container_of(c, struct dma_simple_chan, dma_chan)
+#define to_simple_dev(d) container_of(d, struct dma_simple_dev, dma_dev)
+
+/*
+ * For slave DMA we assume, that there is a finite number of DMA slaves in the
+ * system, and that each such slave can only use a finite number of channels.
+ * We use slave channel IDs to make sure, that no such slave channel ID is
+ * allocated more than once.
+ */
+static unsigned int slave_num = 256;
+module_param(slave_num, uint, 0444);
+
+/* A bitmask with slave_num bits */
+static unsigned long *simple_slave_used;
+
+/* Called under spin_lock_irq(&schan->chan_lock") */
+static void simple_chan_xfer_ld_queue(struct dma_simple_chan *schan)
+{
+	struct dma_simple_dev *sdev = to_simple_dev(schan->dma_chan.device);
+	const struct dma_simple_ops *ops = sdev->ops;
+	struct dma_simple_desc *sdesc;
+
+	/* DMA work check */
+	if (ops->channel_busy(schan))
+		return;
+
+	/* Find the first not transferred descriptor */
+	list_for_each_entry(sdesc, &schan->ld_queue, node)
+		if (sdesc->mark == DESC_SUBMITTED) {
+			ops->start_xfer(schan, sdesc);
+			break;
+		}
+}
+
+static dma_cookie_t simple_tx_submit(struct dma_async_tx_descriptor *tx)
+{
+	struct dma_simple_desc *chunk, *c, *desc =
+		container_of(tx, struct dma_simple_desc, async_tx),
+		*last = desc;
+	struct dma_simple_chan *schan = to_simple_chan(tx->chan);
+	struct dma_simple_slave *slave = tx->chan->private;
+	dma_async_tx_callback callback = tx->callback;
+	dma_cookie_t cookie;
+	bool power_up;
+
+	spin_lock_irq(&schan->chan_lock);
+
+	power_up = list_empty(&schan->ld_queue);
+
+	cookie = schan->dma_chan.cookie + 1;
+	if (cookie < 0)
+		cookie = 1;
+
+	schan->dma_chan.cookie = cookie;
+	tx->cookie = cookie;
+
+	/* Mark all chunks of this descriptor as submitted, move to the queue */
+	list_for_each_entry_safe(chunk, c, desc->node.prev, node) {
+		/*
+		 * All chunks are on the global ld_free, so, we have to find
+		 * the end of the chain ourselves
+		 */
+		if (chunk != desc && (chunk->mark == DESC_IDLE ||
+				      chunk->async_tx.cookie > 0 ||
+				      chunk->async_tx.cookie == -EBUSY ||
+				      &chunk->node == &schan->ld_free))
+			break;
+		chunk->mark = DESC_SUBMITTED;
+		/* Callback goes to the last chunk */
+		chunk->async_tx.callback = NULL;
+		chunk->cookie = cookie;
+		list_move_tail(&chunk->node, &schan->ld_queue);
+		last = chunk;
+
+		dev_dbg(schan->dev, "submit #%d@%p on %d\n",
+			tx->cookie, &last->async_tx, schan->id);
+	}
+
+	last->async_tx.callback = callback;
+	last->async_tx.callback_param = tx->callback_param;
+
+	if (power_up) {
+		int ret;
+		schan->pm_state = DMA_SIMPLE_PM_BUSY;
+
+		ret = pm_runtime_get(schan->dev);
+
+		spin_unlock_irq(&schan->chan_lock);
+		if (ret < 0)
+			dev_err(schan->dev, "%s(): GET = %d\n", __func__, ret);
+
+		pm_runtime_barrier(schan->dev);
+
+		spin_lock_irq(&schan->chan_lock);
+
+		/* Have we been reset, while waiting? */
+		if (schan->pm_state != DMA_SIMPLE_PM_ESTABLISHED) {
+			struct dma_simple_dev *sdev =
+				to_simple_dev(schan->dma_chan.device);
+			const struct dma_simple_ops *ops = sdev->ops;
+			dev_dbg(schan->dev, "Bring up channel %d\n",
+				schan->id);
+			/*
+			 * TODO: .xfer_setup() might fail on some platforms.
+			 * Make it int then, on error remove chunks from the
+			 * queue again
+			 */
+			ops->setup_xfer(schan, slave);
+
+			if (schan->pm_state == DMA_SIMPLE_PM_PENDING)
+				simple_chan_xfer_ld_queue(schan);
+			schan->pm_state = DMA_SIMPLE_PM_ESTABLISHED;
+		}
+	} else {
+		/*
+		 * Tell .device_issue_pending() not to run the queue, interrupts
+		 * will do it anyway
+		 */
+		schan->pm_state = DMA_SIMPLE_PM_PENDING;
+	}
+
+	spin_unlock_irq(&schan->chan_lock);
+
+	return cookie;
+}
+
+/* Called with desc_lock held */
+static struct dma_simple_desc *simple_get_desc(struct dma_simple_chan *schan)
+{
+	struct dma_simple_desc *sdesc;
+
+	list_for_each_entry(sdesc, &schan->ld_free, node)
+		if (sdesc->mark != DESC_PREPARED) {
+			BUG_ON(sdesc->mark != DESC_IDLE);
+			list_del(&sdesc->node);
+			return sdesc;
+		}
+
+	return NULL;
+}
+
+static int simple_alloc_chan_resources(struct dma_chan *chan)
+{
+	struct dma_simple_chan *schan = to_simple_chan(chan);
+	struct dma_simple_dev *sdev = to_simple_dev(schan->dma_chan.device);
+	const struct dma_simple_ops *ops = sdev->ops;
+	struct dma_simple_desc *desc;
+	struct dma_simple_slave *slave = chan->private;
+	int ret, i;
+
+	/*
+	 * This relies on the guarantee from dmaengine that alloc_chan_resources
+	 * never runs concurrently with itself or free_chan_resources.
+	 */
+	if (slave) {
+		if (test_and_set_bit(slave->slave_id, simple_slave_used)) {
+			ret = -EBUSY;
+			goto etestused;
+		}
+
+		ret = ops->set_slave(schan, slave);
+		if (ret < 0)
+			goto esetslave;
+	}
+
+	schan->desc = kcalloc(NR_DESCS_PER_CHANNEL,
+			      sdev->desc_size, GFP_KERNEL);
+	if (!schan->desc) {
+		ret = -ENOMEM;
+		goto edescalloc;
+	}
+	schan->desc_num = NR_DESCS_PER_CHANNEL;
+
+	for (i = 0; i < NR_DESCS_PER_CHANNEL; i++) {
+		desc = ops->embedded_desc(schan->desc, i);
+		dma_async_tx_descriptor_init(&desc->async_tx,
+					     &schan->dma_chan);
+		desc->async_tx.tx_submit = simple_tx_submit;
+		desc->mark = DESC_IDLE;
+
+		list_add(&desc->node, &schan->ld_free);
+	}
+
+	return NR_DESCS_PER_CHANNEL;
+
+edescalloc:
+	if (slave)
+esetslave:
+		clear_bit(slave->slave_id, simple_slave_used);
+etestused:
+	chan->private = NULL;
+	return ret;
+}
+
+static dma_async_tx_callback __ld_cleanup(struct dma_simple_chan *schan, bool all)
+{
+	struct dma_simple_desc *desc, *_desc;
+	/* Is the "exposed" head of a chain acked? */
+	bool head_acked = false;
+	dma_cookie_t cookie = 0;
+	dma_async_tx_callback callback = NULL;
+	void *param = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&schan->chan_lock, flags);
+	list_for_each_entry_safe(desc, _desc, &schan->ld_queue, node) {
+		struct dma_async_tx_descriptor *tx = &desc->async_tx;
+
+		BUG_ON(tx->cookie > 0 && tx->cookie != desc->cookie);
+		BUG_ON(desc->mark != DESC_SUBMITTED &&
+		       desc->mark != DESC_COMPLETED &&
+		       desc->mark != DESC_WAITING);
+
+		/*
+		 * queue is ordered, and we use this loop to (1) clean up all
+		 * completed descriptors, and to (2) update descriptor flags of
+		 * any chunks in a (partially) completed chain
+		 */
+		if (!all && desc->mark == DESC_SUBMITTED &&
+		    desc->cookie != cookie)
+			break;
+
+		if (tx->cookie > 0)
+			cookie = tx->cookie;
+
+		if (desc->mark == DESC_COMPLETED && desc->chunks == 1) {
+			if (schan->completed_cookie != desc->cookie - 1)
+				dev_dbg(schan->dev,
+					"Completing cookie %d, expected %d\n",
+					desc->cookie,
+					schan->completed_cookie + 1);
+			schan->completed_cookie = desc->cookie;
+		}
+
+		/* Call callback on the last chunk */
+		if (desc->mark == DESC_COMPLETED && tx->callback) {
+			desc->mark = DESC_WAITING;
+			callback = tx->callback;
+			param = tx->callback_param;
+			dev_dbg(schan->dev, "descriptor #%d@%p on %d callback\n",
+				tx->cookie, tx, schan->id);
+			BUG_ON(desc->chunks != 1);
+			break;
+		}
+
+		if (tx->cookie > 0 || tx->cookie == -EBUSY) {
+			if (desc->mark == DESC_COMPLETED) {
+				BUG_ON(tx->cookie < 0);
+				desc->mark = DESC_WAITING;
+			}
+			head_acked = async_tx_test_ack(tx);
+		} else {
+			switch (desc->mark) {
+			case DESC_COMPLETED:
+				desc->mark = DESC_WAITING;
+				/* Fall through */
+			case DESC_WAITING:
+				if (head_acked)
+					async_tx_ack(&desc->async_tx);
+			}
+		}
+
+		dev_dbg(schan->dev, "descriptor %p #%d completed.\n",
+			tx, tx->cookie);
+
+		if (((desc->mark == DESC_COMPLETED ||
+		      desc->mark == DESC_WAITING) &&
+		     async_tx_test_ack(&desc->async_tx)) || all) {
+			/* Remove from ld_queue list */
+			desc->mark = DESC_IDLE;
+
+			list_move(&desc->node, &schan->ld_free);
+
+			if (list_empty(&schan->ld_queue)) {
+				dev_dbg(schan->dev, "Bring down channel %d\n", schan->id);
+				pm_runtime_put(schan->dev);
+				schan->pm_state = DMA_SIMPLE_PM_ESTABLISHED;
+			}
+		}
+	}
+
+	if (all && !callback)
+		/*
+		 * Terminating and the loop completed normally: forgive
+		 * uncompleted cookies
+		 */
+		schan->completed_cookie = schan->dma_chan.cookie;
+
+	spin_unlock_irqrestore(&schan->chan_lock, flags);
+
+	if (callback)
+		callback(param);
+
+	return callback;
+}
+
+/*
+ * simple_chan_ld_cleanup - Clean up link descriptors
+ *
+ * Clean up the ld_queue of DMA channel.
+ */
+static void simple_chan_ld_cleanup(struct dma_simple_chan *schan, bool all)
+{
+	while (__ld_cleanup(schan, all))
+		;
+}
+
+/*
+ * simple_free_chan_resources - Free all resources of the channel.
+ */
+static void simple_free_chan_resources(struct dma_chan *chan)
+{
+	struct dma_simple_chan *schan = to_simple_chan(chan);
+	struct dma_simple_dev *sdev = to_simple_dev(chan->device);
+	const struct dma_simple_ops *ops = sdev->ops;
+	LIST_HEAD(list);
+
+	/* Protect against ISR */
+	spin_lock_irq(&schan->chan_lock);
+	ops->halt_channel(schan);
+	spin_unlock_irq(&schan->chan_lock);
+
+	/* Now no new interrupts will occur */
+
+	/* Prepared and not submitted descriptors can still be on the queue */
+	if (!list_empty(&schan->ld_queue))
+		simple_chan_ld_cleanup(schan, true);
+
+	if (chan->private) {
+		/* The caller is holding dma_list_mutex */
+		struct dma_simple_slave *slave = chan->private;
+		clear_bit(slave->slave_id, simple_slave_used);
+		chan->private = NULL;
+	}
+
+	spin_lock_irq(&schan->chan_lock);
+
+	list_splice_init(&schan->ld_free, &list);
+	schan->desc_num = 0;
+
+	spin_unlock_irq(&schan->chan_lock);
+
+	kfree(schan->desc);
+}
+
+/**
+ * simple_add_desc - get, set up and return one transfer descriptor
+ * @schan:	DMA channel
+ * @flags:	DMA transfer flags
+ * @dst:	destination DMA address, incremented when direction equals
+ *		DMA_DEV_TO_MEM or DMA_MEM_TO_MEM
+ * @src:	source DMA address, incremented when direction equals
+ *		DMA_MEM_TO_DEV or DMA_MEM_TO_MEM
+ * @len:	DMA transfer length
+ * @first:	if NULL, set to the current descriptor and cookie set to -EBUSY
+ * @direction:	needed for slave DMA to decide which address to keep constant,
+ *		equals DMA_MEM_TO_MEM for MEMCPY
+ * Returns 0 or an error
+ * Locks: called with desc_lock held
+ */
+static struct dma_simple_desc *simple_add_desc(struct dma_simple_chan *schan,
+	unsigned long flags, dma_addr_t *dst, dma_addr_t *src, size_t *len,
+	struct dma_simple_desc **first, enum dma_transfer_direction direction)
+{
+	struct dma_simple_dev *sdev = to_simple_dev(schan->dma_chan.device);
+	const struct dma_simple_ops *ops = sdev->ops;
+	struct dma_simple_desc *new;
+	size_t copy_size = *len;
+
+	if (!copy_size)
+		return NULL;
+
+	/* Allocate the link descriptor from the free list */
+	new = simple_get_desc(schan);
+	if (!new) {
+		dev_err(schan->dev, "No free link descriptor available\n");
+		return NULL;
+	}
+
+	ops->desc_setup(schan, new, *src, *dst, &copy_size);
+
+	if (!*first) {
+		/* First desc */
+		new->async_tx.cookie = -EBUSY;
+		*first = new;
+	} else {
+		/* Other desc - invisible to the user */
+		new->async_tx.cookie = -EINVAL;
+	}
+
+	dev_dbg(schan->dev,
+		"chaining (%u/%u)@%x -> %x with %p, cookie %d\n",
+		copy_size, *len, *src, *dst, &new->async_tx,
+		new->async_tx.cookie);
+
+	new->mark = DESC_PREPARED;
+	new->async_tx.flags = flags;
+	new->direction = direction;
+
+	*len -= copy_size;
+	if (direction == DMA_MEM_TO_MEM || direction == DMA_MEM_TO_DEV)
+		*src += copy_size;
+	if (direction == DMA_MEM_TO_MEM || direction == DMA_DEV_TO_MEM)
+		*dst += copy_size;
+
+	return new;
+}
+
+/*
+ * simple_prep_sg - prepare transfer descriptors from an SG list
+ *
+ * Common routine for public (MEMCPY) and slave DMA. The MEMCPY case is also
+ * converted to scatter-gather to guarantee consistent locking and a correct
+ * list manipulation. For slave DMA direction carries the usual meaning, and,
+ * logically, the SG list is RAM and the addr variable contains slave address,
+ * e.g., the FIFO I/O register. For MEMCPY direction equals DMA_MEM_TO_MEM
+ * and the SG list contains only one element and points at the source buffer.
+ */
+static struct dma_async_tx_descriptor *simple_prep_sg(struct dma_simple_chan *schan,
+	struct scatterlist *sgl, unsigned int sg_len, dma_addr_t *addr,
+	enum dma_transfer_direction direction, unsigned long flags)
+{
+	struct scatterlist *sg;
+	struct dma_simple_desc *first = NULL, *new = NULL /* compiler... */;
+	LIST_HEAD(tx_list);
+	int chunks = 0;
+	unsigned long irq_flags;
+	int i;
+
+	for_each_sg(sgl, sg, sg_len, i)
+		chunks += DIV_ROUND_UP(sg_dma_len(sg), schan->max_xfer_len);
+
+	/* Have to lock the whole loop to protect against concurrent release */
+	spin_lock_irqsave(&schan->chan_lock, irq_flags);
+
+	/*
+	 * Chaining:
+	 * first descriptor is what user is dealing with in all API calls, its
+	 *	cookie is at first set to -EBUSY, at tx-submit to a positive
+	 *	number
+	 * if more than one chunk is needed further chunks have cookie = -EINVAL
+	 * the last chunk, if not equal to the first, has cookie = -ENOSPC
+	 * all chunks are linked onto the tx_list head with their .node heads
+	 *	only during this function, then they are immediately spliced
+	 *	back onto the free list in form of a chain
+	 */
+	for_each_sg(sgl, sg, sg_len, i) {
+		dma_addr_t sg_addr = sg_dma_address(sg);
+		size_t len = sg_dma_len(sg);
+
+		if (!len)
+			goto err_get_desc;
+
+		do {
+			dev_dbg(schan->dev, "Add SG #%d@%p[%d], dma %llx\n",
+				i, sg, len, (unsigned long long)sg_addr);
+
+			if (direction == DMA_DEV_TO_MEM)
+				new = simple_add_desc(schan, flags,
+						&sg_addr, addr, &len, &first,
+						direction);
+			else
+				new = simple_add_desc(schan, flags,
+						addr, &sg_addr, &len, &first,
+						direction);
+			if (!new)
+				goto err_get_desc;
+
+			new->chunks = chunks--;
+			list_add_tail(&new->node, &tx_list);
+		} while (len);
+	}
+
+	if (new != first)
+		new->async_tx.cookie = -ENOSPC;
+
+	/* Put them back on the free list, so, they don't get lost */
+	list_splice_tail(&tx_list, &schan->ld_free);
+
+	spin_unlock_irqrestore(&schan->chan_lock, irq_flags);
+
+	return &first->async_tx;
+
+err_get_desc:
+	list_for_each_entry(new, &tx_list, node)
+		new->mark = DESC_IDLE;
+	list_splice(&tx_list, &schan->ld_free);
+
+	spin_unlock_irqrestore(&schan->chan_lock, irq_flags);
+
+	return NULL;
+}
+
+static struct dma_async_tx_descriptor *simple_prep_memcpy(
+	struct dma_chan *chan, dma_addr_t dma_dest, dma_addr_t dma_src,
+	size_t len, unsigned long flags)
+{
+	struct dma_simple_chan *schan = to_simple_chan(chan);
+	struct scatterlist sg;
+
+	if (!chan || !len)
+		return NULL;
+
+	BUG_ON(!schan->desc_num);
+
+	sg_init_table(&sg, 1);
+	sg_set_page(&sg, pfn_to_page(PFN_DOWN(dma_src)), len,
+		    offset_in_page(dma_src));
+	sg_dma_address(&sg) = dma_src;
+	sg_dma_len(&sg) = len;
+
+	return simple_prep_sg(schan, &sg, 1, &dma_dest, DMA_MEM_TO_MEM, flags);
+}
+
+static struct dma_async_tx_descriptor *simple_prep_slave_sg(
+	struct dma_chan *chan, struct scatterlist *sgl, unsigned int sg_len,
+	enum dma_transfer_direction direction, unsigned long flags)
+{
+	struct dma_simple_chan *schan = to_simple_chan(chan);
+	struct dma_simple_dev *sdev = to_simple_dev(schan->dma_chan.device);
+	const struct dma_simple_ops *ops = sdev->ops;
+	struct dma_simple_slave *slave = chan->private;
+	dma_addr_t slave_addr;
+
+	if (!chan)
+		return NULL;
+
+	BUG_ON(!schan->desc_num);
+
+	/* Someone calling slave DMA on a generic channel? */
+	if (!slave || !sg_len) {
+		dev_warn(schan->dev, "%s: bad parameter: %p, %d, %d\n",
+			 __func__, slave, sg_len, slave ? slave->slave_id : -1);
+		return NULL;
+	}
+
+	slave_addr = ops->slave_addr(schan);
+
+	return simple_prep_sg(schan, sgl, sg_len, &slave_addr,
+			      direction, flags);
+}
+
+static int simple_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
+			  unsigned long arg)
+{
+	struct dma_simple_chan *schan = to_simple_chan(chan);
+	struct dma_simple_dev *sdev = to_simple_dev(chan->device);
+	const struct dma_simple_ops *ops = sdev->ops;
+	unsigned long flags;
+
+	/* Only supports DMA_TERMINATE_ALL */
+	if (cmd != DMA_TERMINATE_ALL)
+		return -ENXIO;
+
+	if (!chan)
+		return -EINVAL;
+
+	spin_lock_irqsave(&schan->chan_lock, flags);
+
+	ops->halt_channel(schan);
+
+	spin_unlock_irqrestore(&schan->chan_lock, flags);
+
+	simple_chan_ld_cleanup(schan, true);
+
+	return 0;
+}
+
+static void simple_issue_pending(struct dma_chan *chan)
+{
+	struct dma_simple_chan *schan = to_simple_chan(chan);
+
+	spin_lock_irq(&schan->chan_lock);
+	if (schan->pm_state == DMA_SIMPLE_PM_ESTABLISHED)
+		simple_chan_xfer_ld_queue(schan);
+	else
+		schan->pm_state = DMA_SIMPLE_PM_PENDING;
+	spin_unlock_irq(&schan->chan_lock);
+}
+
+static enum dma_status simple_tx_status(struct dma_chan *chan,
+					dma_cookie_t cookie,
+					struct dma_tx_state *txstate)
+{
+	struct dma_simple_chan *schan = to_simple_chan(chan);
+	dma_cookie_t last_used;
+	dma_cookie_t last_complete;
+	enum dma_status status;
+	unsigned long flags;
+
+	simple_chan_ld_cleanup(schan, false);
+
+	/* First read completed cookie to avoid a skew */
+	last_complete = schan->completed_cookie;
+	rmb();
+	last_used = chan->cookie;
+	BUG_ON(last_complete < 0);
+	dma_set_tx_state(txstate, last_complete, last_used, 0);
+
+	spin_lock_irqsave(&schan->chan_lock, flags);
+
+	status = dma_async_is_complete(cookie, last_complete, last_used);
+
+	/*
+	 * If we don't find cookie on the queue, it has been aborted and we have
+	 * to report error
+	 */
+	if (status != DMA_SUCCESS) {
+		struct dma_simple_desc *sdesc;
+		status = DMA_ERROR;
+		list_for_each_entry(sdesc, &schan->ld_queue, node)
+			if (sdesc->cookie == cookie) {
+				status = DMA_IN_PROGRESS;
+				break;
+			}
+	}
+
+	spin_unlock_irqrestore(&schan->chan_lock, flags);
+
+	return status;
+}
+
+/* Called from error IRQ or NMI */
+bool dma_simple_reset(struct dma_simple_dev *sdev)
+{
+	const struct dma_simple_ops *ops = sdev->ops;
+	struct dma_simple_chan *schan;
+	unsigned int handled = 0;
+	int i;
+
+	/* Reset all channels */
+	dma_simple_for_each_chan(schan, sdev, i) {
+		struct dma_simple_desc *sdesc;
+		LIST_HEAD(dl);
+
+		if (!schan)
+			continue;
+
+		spin_lock(&schan->chan_lock);
+
+		/* Stop the channel */
+		ops->halt_channel(schan);
+
+		list_splice_init(&schan->ld_queue, &dl);
+
+		if (!list_empty(&dl)) {
+			dev_dbg(schan->dev, "Bring down channel %d\n", schan->id);
+			pm_runtime_put(schan->dev);
+		}
+		schan->pm_state = DMA_SIMPLE_PM_ESTABLISHED;
+
+		spin_unlock(&schan->chan_lock);
+
+		/* Complete all  */
+		list_for_each_entry(sdesc, &dl, node) {
+			struct dma_async_tx_descriptor *tx = &sdesc->async_tx;
+			sdesc->mark = DESC_IDLE;
+			if (tx->callback)
+				tx->callback(tx->callback_param);
+		}
+
+		spin_lock(&schan->chan_lock);
+		list_splice(&dl, &schan->ld_free);
+		spin_unlock(&schan->chan_lock);
+
+		handled++;
+	}
+
+	return !!handled;
+}
+EXPORT_SYMBOL(dma_simple_reset);
+
+static irqreturn_t chan_irq(int irq, void *dev)
+{
+	struct dma_simple_chan *schan = dev;
+	const struct dma_simple_ops *ops =
+		to_simple_dev(schan->dma_chan.device)->ops;
+	irqreturn_t ret;
+
+	spin_lock(&schan->chan_lock);
+
+	ret = ops->chan_irq(schan, irq) ? IRQ_WAKE_THREAD : IRQ_NONE;
+
+	spin_unlock(&schan->chan_lock);
+
+	return ret;
+}
+
+static irqreturn_t chan_irqt(int irq, void *dev)
+{
+	struct dma_simple_chan *schan = dev;
+	const struct dma_simple_ops *ops =
+		to_simple_dev(schan->dma_chan.device)->ops;
+	struct dma_simple_desc *sdesc;
+
+	spin_lock_irq(&schan->chan_lock);
+	list_for_each_entry(sdesc, &schan->ld_queue, node) {
+		if (sdesc->mark == DESC_SUBMITTED &&
+		    ops->desc_completed(schan, sdesc)) {
+			dev_dbg(schan->dev, "done #%d@%p\n",
+				sdesc->async_tx.cookie, &sdesc->async_tx);
+			sdesc->mark = DESC_COMPLETED;
+			break;
+		}
+	}
+	/* Next desc */
+	simple_chan_xfer_ld_queue(schan);
+	spin_unlock_irq(&schan->chan_lock);
+
+	simple_chan_ld_cleanup(schan, false);
+
+	return IRQ_HANDLED;
+}
+
+int dma_simple_request_irq(struct dma_simple_chan *schan, int irq,
+			   unsigned long flags, const char *name)
+{
+	int ret = request_threaded_irq(irq, chan_irq, chan_irqt,
+				       flags, name, schan);
+
+	schan->irq = ret < 0 ? ret : irq;
+
+	return ret;
+}
+EXPORT_SYMBOL(dma_simple_request_irq);
+
+void dma_simple_free_irq(struct dma_simple_chan *schan)
+{
+	if (schan->irq >= 0)
+		free_irq(schan->irq, schan);
+}
+EXPORT_SYMBOL(dma_simple_free_irq);
+
+void dma_simple_chan_probe(struct dma_simple_dev *sdev,
+			   struct dma_simple_chan *schan, int id)
+{
+	schan->pm_state = DMA_SIMPLE_PM_ESTABLISHED;
+
+	/* reference struct dma_device */
+	schan->dma_chan.device = &sdev->dma_dev;
+
+	schan->dev = sdev->dma_dev.dev;
+	schan->id = id;
+
+	if (!schan->max_xfer_len)
+		schan->max_xfer_len = PAGE_SIZE;
+
+	spin_lock_init(&schan->chan_lock);
+
+	/* Init descripter manage list */
+	INIT_LIST_HEAD(&schan->ld_queue);
+	INIT_LIST_HEAD(&schan->ld_free);
+
+	/* Add the channel to DMA device channel list */
+	list_add_tail(&schan->dma_chan.device_node,
+			&sdev->dma_dev.channels);
+	sdev->schan[sdev->dma_dev.chancnt++] = schan;
+}
+EXPORT_SYMBOL(dma_simple_chan_probe);
+
+void dma_simple_chan_remove(struct dma_simple_chan *schan)
+{
+	list_del(&schan->dma_chan.device_node);
+}
+EXPORT_SYMBOL(dma_simple_chan_remove);
+
+int dma_simple_init(struct device *dev, struct dma_simple_dev *sdev,
+		    int chan_num)
+{
+	struct dma_device *dma_dev = &sdev->dma_dev;
+
+	/*
+	 * Require all call-backs for now, they can trivially be made optional
+	 * later as required
+	 */
+	if (!sdev->ops ||
+	    !sdev->desc_size ||
+	    !sdev->ops->embedded_desc ||
+	    !sdev->ops->start_xfer ||
+	    !sdev->ops->setup_xfer ||
+	    !sdev->ops->set_slave ||
+	    !sdev->ops->desc_setup ||
+	    !sdev->ops->slave_addr ||
+	    !sdev->ops->channel_busy ||
+	    !sdev->ops->halt_channel ||
+	    !sdev->ops->desc_completed)
+		return -EINVAL;
+
+	sdev->schan = kcalloc(chan_num, sizeof(*sdev->schan), GFP_KERNEL);
+	if (!sdev->schan)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&dma_dev->channels);
+
+	/* Common and MEMCPY operations */
+	dma_dev->device_alloc_chan_resources
+		= simple_alloc_chan_resources;
+	dma_dev->device_free_chan_resources = simple_free_chan_resources;
+	dma_dev->device_prep_dma_memcpy = simple_prep_memcpy;
+	dma_dev->device_tx_status = simple_tx_status;
+	dma_dev->device_issue_pending = simple_issue_pending;
+
+	/* Compulsory for DMA_SLAVE fields */
+	dma_dev->device_prep_slave_sg = simple_prep_slave_sg;
+	dma_dev->device_control = simple_control;
+
+	dma_dev->dev = dev;
+
+	return 0;
+}
+EXPORT_SYMBOL(dma_simple_init);
+
+void dma_simple_cleanup(struct dma_simple_dev *sdev)
+{
+	kfree(sdev->schan);
+}
+EXPORT_SYMBOL(dma_simple_cleanup);
+
+static int __init dma_simple_enter(void)
+{
+	simple_slave_used = kzalloc(DIV_ROUND_UP(slave_num, BITS_PER_LONG) *
+				    sizeof(long), GFP_KERNEL);
+	if (!simple_slave_used)
+		return -ENOMEM;
+	return 0;
+}
+module_init(dma_simple_enter);
+
+static void __exit dma_simple_exit(void)
+{
+	kfree(simple_slave_used);
+}
+module_exit(dma_simple_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Simple dmaengine driver library");
+MODULE_AUTHOR("Guennadi Liakhovetski <g.liakhovetski@gmx.de>");
diff --git a/include/linux/dma-simple.h b/include/linux/dma-simple.h
new file mode 100644
index 0000000..5336674
--- /dev/null
+++ b/include/linux/dma-simple.h
@@ -0,0 +1,124 @@
+/*
+ * Simple dmaengine driver library
+ *
+ * extracted from shdma.c and headers
+ *
+ * Copyright (C) 2011-2012 Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ * Copyright (C) 2009 Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
+ * Copyright (C) 2009 Renesas Solutions, Inc. All rights reserved.
+ * Copyright (C) 2007 Freescale Semiconductor, Inc. All rights reserved.
+ *
+ * This is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef DMA_SIMPLE_H
+#define DMA_SIMPLE_H
+
+#include <linux/dmaengine.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/types.h>
+
+/**
+ * dma_simple_pm_state - DMA channel PM state
+ * DMA_SIMPLE_PM_ESTABLISHED:	either idle or during data transfer
+ * DMA_SIMPLE_PM_BUSY:		during the transfer preparation, when we have to
+ *				drop the lock temporarily
+ * DMA_SIMPLE_PM_PENDING:	transfers pending
+ */
+enum dma_simple_pm_state {
+	DMA_SIMPLE_PM_ESTABLISHED,
+	DMA_SIMPLE_PM_BUSY,
+	DMA_SIMPLE_PM_PENDING,
+};
+
+struct device;
+
+/*
+ * Drivers, using this library are expected to embed struct dma_simple_dev,
+ * struct dma_simple_chan, struct dma_simple_desc, and struct dma_simple_slave
+ * in their respective device, channel, descriptor and slave objects.
+ */
+
+struct dma_simple_slave {
+	unsigned int slave_id;
+};
+
+struct dma_simple_desc {
+	struct list_head node;
+	struct dma_async_tx_descriptor async_tx;
+	enum dma_transfer_direction direction;
+	dma_cookie_t cookie;
+	int chunks;
+	int mark;
+};
+
+struct dma_simple_chan {
+	dma_cookie_t completed_cookie;	/* The maximum cookie completed */
+	spinlock_t chan_lock;		/* Channel operation lock */
+	struct list_head ld_queue;	/* Link descriptors queue */
+	struct list_head ld_free;	/* Free link descriptors */
+	struct dma_chan dma_chan;	/* DMA channel */
+	struct device *dev;		/* Channel device */
+	void *desc;			/* buffer for descriptor array */
+	int desc_num;			/* desc count */
+	size_t max_xfer_len;		/* max transfer length */
+	int id;				/* Raw id of this channel */
+	int irq;			/* Channel IRQ */
+	enum dma_simple_pm_state pm_state;
+};
+
+/**
+ * struct dma_simple_ops - simple DMA driver operations
+ * desc_completed:	return true, if this is the descriptor, that just has
+ *			completed (atomic)
+ * halt_channel:	stop DMA channel operation (atomic)
+ * channel_busy:	return true, if the channel is busy (atomic)
+ * slave_addr:		return slave DMA address
+ * desc_setup:		set up the hardware specific descriptor portion (atomic)
+ * set_slave:		bind channel to a slave
+ * setup_xfer:		configure channel hardware for operation (atomic)
+ * start_xfer:		start the DMA transfer (atomic)
+ * embedded_desc:	return Nth struct dma_simple_desc pointer from the
+ *			descriptor array
+ * chan_irq:		process channel IRQ, return true if a transfer has
+ *			completed (atomic)
+ */
+struct dma_simple_ops {
+	bool (*desc_completed)(struct dma_simple_chan *, struct dma_simple_desc *);
+	void (*halt_channel)(struct dma_simple_chan *);
+	bool (*channel_busy)(struct dma_simple_chan *);
+	dma_addr_t (*slave_addr)(struct dma_simple_chan *);
+	int (*desc_setup)(struct dma_simple_chan *, struct dma_simple_desc *,
+			  dma_addr_t, dma_addr_t, size_t *);
+	int (*set_slave)(struct dma_simple_chan *, struct dma_simple_slave *);
+	void (*setup_xfer)(struct dma_simple_chan *, struct dma_simple_slave *);
+	void (*start_xfer)(struct dma_simple_chan *, struct dma_simple_desc *);
+	struct dma_simple_desc *(*embedded_desc)(void *, int);
+	bool (*chan_irq)(struct dma_simple_chan *, int);
+};
+
+struct dma_simple_dev {
+	struct dma_device dma_dev;
+	struct dma_simple_chan **schan;
+	const struct dma_simple_ops *ops;
+	size_t desc_size;
+};
+
+#define dma_simple_for_each_chan(c, d, i) for (i = 0, c = (d)->schan[0]; \
+				i < (d)->dma_dev.chancnt; c = (d)->schan[++i])
+
+int dma_simple_request_irq(struct dma_simple_chan *, int,
+			   unsigned long, const char *);
+void dma_simple_free_irq(struct dma_simple_chan *);
+bool dma_simple_reset(struct dma_simple_dev *sdev);
+void dma_simple_chan_probe(struct dma_simple_dev *sdev,
+			   struct dma_simple_chan *schan, int id);
+void dma_simple_chan_remove(struct dma_simple_chan *schan);
+int dma_simple_init(struct device *dev, struct dma_simple_dev *sdev,
+		    int chan_num);
+void dma_simple_cleanup(struct dma_simple_dev *sdev);
+
+#endif
-- 
1.7.2.5

