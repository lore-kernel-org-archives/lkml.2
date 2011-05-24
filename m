Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab1EXMiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 08:38:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:29922 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754925Ab1EXMiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 08:38:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,261,1304319600"; 
   d="scan'208";a="575301"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dan <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH] dmaengine: Add API documentation for slave dma usage
Date: Tue, 24 May 2011 17:34:17 +0530
Message-Id: <1306238657-30089-1-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinod Koul <vinod.koul@intel.com>

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 Documentation/dma-slave-api.txt |   74 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 74 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/dma-slave-api.txt

diff --git a/Documentation/dma-slave-api.txt b/Documentation/dma-slave-api.txt
new file mode 100644
index 0000000..7498807
--- /dev/null
+++ b/Documentation/dma-slave-api.txt
@@ -0,0 +1,74 @@
+		     Slave DMA API Guide
+		     ===================
+
+		 Vinod Koul <vinod dot koul at intel.com>
+
+This is a guide to device driver writers on how to use the Slave-DMA API of the
+DMA Engine. This is applicable only for slave DMA usage and not async tx. For
+the async tx usage of DMA Engine please see
+Documentation/crypto/async-tx-api.txt
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
+__dma_request_channel() API is used.
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
+struct dma_async_tx_descriptor *(*chan->device->device_prep_dma_sg)(
+		struct dma_chan *chan,
+		struct scatterlist *dst_sg, unsigned int dst_nents,
+		struct scatterlist *src_sg, unsigned int src_nents,
+		unsigned long flags);
+struct dma_async_tx_descriptor *(*chan->device->device_prep_dma_cyclic)(
+		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
+		size_t period_len, enum dma_data_direction direction);
+
+4. Submit the transaction(s) and wait for callback notification when slave API
+is 3 above returns, the non NULL value would imply a "descriptor" for the
+transaction. These transaction(s) would need to be submitted which pushes them
+into queue in DMA driver. If DMA is idle then the first descriptor submit will
+be pushed to DMA and subsequent ones will be queued. On completion of the DMA
+operation the next in queue is submitted and a tasklet triggered. The tasklet
+would then call the client driver completion callback routine for notification,
+if set.
+
+Additional usage notes
+1/ Although DMA engine specifies that completion callback routines cannot submit
+any new operations, but typically for slave DMA subsequent transaction may not
+be available for submit prior to callback routine being called. This requirement
+|is not a requirement for DMA-slave devices. But they should take care to drop
+the spin-lock they might be holding before calling the callback routine
+
-- 
1.7.0.4

