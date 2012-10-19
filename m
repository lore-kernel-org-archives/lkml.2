Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778Ab2JSCvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:51:10 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:49693 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab2JSCuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:50:15 -0400
From: Matt Porter <mporter@ti.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Chris Ball <cjb@laptop.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: [RFC PATCH 1/3] dmaengine: add dma_get_channel_caps()
Date: Thu, 18 Oct 2012 22:51:26 -0400
Message-Id: <1350615088-14562-2-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350615088-14562-1-git-send-email-mporter@ti.com>
References: <1350615088-14562-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a dmaengine API to retrieve per channel capabilities.
Currently, only channel ops and SG segment limitations are
implemented caps.

The API is optionally implemented by drivers and when
unimplemented will return a NULL pointer. It is intended
to be executed after a channel has been requested and, if
the channel is intended to be used with slave SG transfers,
then it may only be called after dmaengine_slave_config()
has executed. The slave driver provides parameters such as
burst size and address width which may be necessary for
the dmaengine driver to use in order to properly return SG
segment limit caps.

Suggested-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Matt Porter <mporter@ti.com>
---
 include/linux/dmaengine.h |   52 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 11d9e25..0181887 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -371,6 +371,38 @@ struct dma_slave_config {
 	unsigned int slave_id;
 };
 
+enum dmaengine_apis {
+	DMAENGINE_MEMCPY	= 0x0001,
+	DMAENGINE_XOR		= 0x0002,
+	DMAENGINE_XOR_VAL	= 0x0004,
+	DMAENGINE_PQ		= 0x0008,
+	DMAENGINE_PQ_VAL	= 0x0010,
+	DMAENGINE_MEMSET	= 0x0020,
+	DMAENGINE_SLAVE		= 0x0040,
+	DMAENGINE_CYCLIC	= 0x0080,
+	DMAENGINE_INTERLEAVED	= 0x0100,
+	DMAENGINE_SG		= 0x0200,
+};
+
+/* struct dmaengine_chan_caps - expose capability of a channel
+ * Note: each channel can have same or different capabilities
+ *
+ * This primarily classifies capabilities into
+ * a) APIs/ops supported
+ * b) channel physical capabilities
+ *
+ * @ops: or'ed api capability
+ * @seg_nr: maximum number of SG segments supported on a SG/SLAVE
+ *	    channel (0 for no maximum or not a SG/SLAVE channel)
+ * @seg_len: maximum length of SG segments supported on a SG/SLAVE
+ *	     channel (0 for no maximum or not a SG/SLAVE channel)
+ */
+struct dmaengine_chan_caps {
+	enum dmaengine_apis ops;
+	int seg_nr;
+	int seg_len;
+};
+
 static inline const char *dma_chan_name(struct dma_chan *chan)
 {
 	return dev_name(&chan->dev->device);
@@ -534,6 +566,7 @@ struct dma_tx_state {
  *	struct with auxiliary transfer status information, otherwise the call
  *	will just return a simple status code
  * @device_issue_pending: push pending transactions to hardware
+ * @device_channel_caps: return the channel capabilities
  */
 struct dma_device {
 
@@ -602,6 +635,8 @@ struct dma_device {
 					    dma_cookie_t cookie,
 					    struct dma_tx_state *txstate);
 	void (*device_issue_pending)(struct dma_chan *chan);
+	struct dmaengine_chan_caps *(*device_channel_caps)(
+		struct dma_chan *chan, enum dma_transfer_direction direction);
 };
 
 static inline int dmaengine_device_control(struct dma_chan *chan,
@@ -969,6 +1004,23 @@ dma_set_tx_state(struct dma_tx_state *st, dma_cookie_t last, dma_cookie_t used,
 	}
 }
 
+/**
+ * dma_get_channel_caps - flush pending transactions to HW
+ * @chan: target DMA channel
+ * @dir: direction of transfer
+ *
+ * Get the channel-specific capabilities. If the dmaengine
+ * driver does not implement per channel capbilities then
+ * NULL is returned.
+ */
+static inline struct dmaengine_chan_caps
+*dma_get_channel_caps(struct dma_chan *chan, enum dma_transfer_direction dir)
+{
+	if (chan->device->device_channel_caps)
+		return chan->device->device_channel_caps(chan, dir);
+	return NULL;
+}
+
 enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie);
 #ifdef CONFIG_DMA_ENGINE
 enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx);
-- 
1.7.9.5

