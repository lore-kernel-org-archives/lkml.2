Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab0I3N5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 09:57:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60150 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258Ab0I3N4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 09:56:46 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Dan Williams <dan.j.williams@intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 1/4] dmaengine: add possibility for cyclic transfers
Date: Thu, 30 Sep 2010 15:56:32 +0200
Message-Id: <1285854995-6569-2-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1285854995-6569-1-git-send-email-s.hauer@pengutronix.de>
References: <1285854995-6569-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyclic transfers are useful for audio where a single buffer divided
in periods has to be transfered endlessly until stopped. After being
prepared the transfer is started using the dma_async_descriptor->tx_submit
function. dma_async_descriptor->callback is called after each period.
The transfer is stopped using the DMA_TERMINATE_ALL callback.
While being used for cyclic transfers the channel cannot be used
for other transfer types.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/dma/dmaengine.c   |    2 ++
 include/linux/dmaengine.h |    9 ++++++++-
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 9d31d5e..e5e79ce 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -692,6 +692,8 @@ int dma_async_device_register(struct dma_device *device)
 		!device->device_prep_dma_interrupt);
 	BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
 		!device->device_prep_slave_sg);
+	BUG_ON(dma_has_cap(DMA_CYCLIC, device->cap_mask) &&
+		!device->device_prep_dma_cyclic);
 	BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
 		!device->device_control);
 
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index c61d4ca..32cd84b 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -67,10 +67,11 @@ enum dma_transaction_type {
 	DMA_PRIVATE,
 	DMA_ASYNC_TX,
 	DMA_SLAVE,
+	DMA_CYCLIC,
 };
 
 /* last transaction type for creation of the capabilities mask */
-#define DMA_TX_TYPE_END (DMA_SLAVE + 1)
+#define DMA_TX_TYPE_END (DMA_CYCLIC + 1)
 
 
 /**
@@ -422,6 +423,9 @@ struct dma_tx_state {
  * @device_prep_dma_memset: prepares a memset operation
  * @device_prep_dma_interrupt: prepares an end of chain interrupt operation
  * @device_prep_slave_sg: prepares a slave dma operation
+ * @device_prep_dma_cyclic: prepare a cyclic dma operation suitable for audio.
+ *	The function takes a buffer of size buf_len. The callback function will
+ *	be called after period_len bytes have been transferred.
  * @device_control: manipulate all pending operations on a channel, returns
  *	zero or error code
  * @device_tx_status: poll for transaction completion, the optional
@@ -478,6 +482,9 @@ struct dma_device {
 		struct dma_chan *chan, struct scatterlist *sgl,
 		unsigned int sg_len, enum dma_data_direction direction,
 		unsigned long flags);
+	struct dma_async_tx_descriptor *(*device_prep_dma_cyclic)(
+		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
+		size_t period_len, enum dma_data_direction direction);
 	int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		unsigned long arg);
 
-- 
1.7.2.3

