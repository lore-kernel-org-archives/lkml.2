Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab1EYMOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 08:14:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:13423 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757025Ab1EYMNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 08:13:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,266,1304319600"; 
   d="scan'208";a="8442366"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dan <dan.j.williams@intel.com>, Per Forlin <per.forlin@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 1/2] dmaengine: Add API documentation for slave dma usage
Date: Wed, 25 May 2011 17:09:29 +0530
Message-Id: <1306323570-11133-2-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1306323570-11133-1-git-send-email-vinod.koul@intel.com>
References: <1306323570-11133-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinod Koul <vinod.koul@intel.com>

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 Documentation/dmaengine.txt |   97 ++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 96 insertions(+), 1 deletions(-)

diff --git a/Documentation/dmaengine.txt b/Documentation/dmaengine.txt
index 0c1c2f6..5a0cb1e 100644
--- a/Documentation/dmaengine.txt
+++ b/Documentation/dmaengine.txt
@@ -1 +1,96 @@
-See Documentation/crypto/async-tx-api.txt
+			DMA Engine API Guide
+			====================
+
+		 Vinod Koul <vinod dot koul at intel.com>
+
+NOTE: For DMA Engine usage in async_tx please see:
+	Documentation/crypto/async-tx-api.txt
+
+
+Below is a guide to device driver writers on how to use the Slave-DMA API of the
+DMA Engine. This is applicable only for slave DMA usage only.
+
+The slave DMA usage consists of following steps
+1. Allocate a DMA slave channel
+2. Set slave and controller specific parameters
+3. Get a descriptor for transaction
+4. Submit the transaction and wait for callback notification
+
+1. Allocate a DMA slave channel
+Channel allocation is slightly different in the slave DMA context, client
+drivers typically need a channel from a particular DMA controller only and even
+in some cases a specific channel is desired. To request a channel
+dma_request_channel() API is used.
+
+Interface:
+struct dma_chan *dma_request_channel(dma_cap_mask_t mask,
+		dma_filter_fn filter_fn,
+		void *filter_param);
+where dma_filter_fn is defined as:
+typedef bool (*dma_filter_fn)(struct dma_chan *chan, void *filter_param);
+
+When the optional 'filter_fn' parameter is set to NULL dma_request_channel
+simply returns the first channel that satisfies the capability mask.  Otherwise,
+when the mask parameter is insufficient for specifying the necessary channel,
+the filter_fn routine can be used to disposition the available channels in the
+system. The filter_fn routine is called once for each free channel in the
+system.  Upon seeing a suitable channel filter_fn returns DMA_ACK which flags
+that channel to be the return value from dma_request_channel.  A channel
+allocated via this interface is exclusive to the caller, until
+dma_release_channel() is called.
+
+2. Set slave and controller specific parameters
+Next step is always to pass some specific information to the DMA driver. Most of
+the generic information which a slave DMA can use is in struct dma_slave_config.
+It allows the clients to specify DMA direction, DMA addresses, bus widths, DMA
+burst lengths etc. If some DMA controllers have more parameters to be sent then
+they should try to embed struct dma_slave_config in their controller specific
+structure. That gives flexibility to client to pass more parameters, if
+required.
+
+Interface:
+int dmaengine_slave_config(struct dma_chan *chan,
+					  struct dma_slave_config *config)
+
+3. Get a descriptor for transaction
+For slave usage the various modes of slave transfers supported by the
+DMA-engine are:
+slave_sg	- DMA a list of scatter gather buffers from/to a peripheral
+dma_cyclic	- Perform a cyclic DMA operation from/to a peripheral till the
+		  operation is explicitly stopped.
+The non NULL return of this transfer API represents a "descriptor" for the given
+transaction.
+
+Interface:
+struct dma_async_tx_descriptor *(*chan->device->device_prep_dma_sg)(
+		struct dma_chan *chan,
+		struct scatterlist *dst_sg, unsigned int dst_nents,
+		struct scatterlist *src_sg, unsigned int src_nents,
+		unsigned long flags);
+struct dma_async_tx_descriptor *(*chan->device->device_prep_dma_cyclic)(
+		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
+		size_t period_len, enum dma_data_direction direction);
+
+4. Submit the transaction and wait for callback notification
+To schedule the transaction to be scheduled by dma device, the "descriptor"
+returned in above (3) needs to be submitted.
+To tell the dma driver that a transaction is ready to be serviced, the
+descriptor->submit() callback needs to be invoked. This chains the descriptor to
+the pending queue.
+The transactions in the pending queue can be activated by calling the
+issue_pending API. If channel is idle then the first transaction in queue is
+started and subsequent ones queued up.
+On completion of the DMA operation the next in queue is submitted and a tasklet
+triggered. The tasklet would then call the client driver completion callback
+routine for notification, if set.
+Interface:
+void dma_async_issue_pending(struct dma_chan *chan);
+
+==============================================================================
+
+Additional usage notes for dma driver writers
+1/ Although DMA engine specifies that completion callback routines cannot submit
+any new operations, but typically for slave DMA subsequent transaction may not
+be available for submit prior to callback routine being called. This requirement
+is not a requirement for DMA-slave devices. But they should take care to drop
+the spin-lock they might be holding before calling the callback routine
-- 
1.7.0.4

