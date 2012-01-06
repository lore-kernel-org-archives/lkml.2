Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab2AFMsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 07:48:12 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11824 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab2AFMsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 07:48:09 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6580"; a="150451123"
From: Ravi Kumar V <kumarrav@codeaurora.org>
To: vinod.koul@intel.com, dan.j.williams@intel.com
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, davidb@codeaurora.org,
        dwalker@fifo99.com, bryanh@codeaurora.org, linux@arm.linux.org.uk,
        tsoni@qualcomm.com, johlstei@qualcomm.com,
        Ravi Kumar V <kumarrav@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 1/2] dmaengine: Add support for per xfer specific privatedata & box dma
Date: Fri,  6 Jan 2012 18:17:31 +0530
Message-Id: <1325854052-21402-2-git-send-email-kumarrav@codeaurora.org>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1325854052-21402-1-git-send-email-kumarrav@codeaurora.org>
References: <1325854052-21402-1-git-send-email-kumarrav@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Qualcomm MSM have a feature to pass command configuration and
control data along with source,destination and length of transfer
for every transaction, as of now struct scatterlist has no support
to send private data related to each transaction we added private_data
variable for supporting this type of archictures.

Qualcomm MSM also supports BOX mode of dma, currently as there is no
API in dmaengine to support this type of dma we added new API.

Change-Id: Ia9ee19f2c253e68b8e5ff254a57478dcc51014ca
Signed-off-by: Ravi Kumar V <kumarrav@codeaurora.org>
---
 include/asm-generic/scatterlist.h |    1 +
 include/linux/dmaengine.h         |   17 ++++++++++++++++-
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/scatterlist.h b/include/asm-generic/scatterlist.h
index 5de0735..e66dfcb 100644
--- a/include/asm-generic/scatterlist.h
+++ b/include/asm-generic/scatterlist.h
@@ -14,6 +14,7 @@ struct scatterlist {
 #ifdef CONFIG_NEED_SG_DMA_LENGTH
 	unsigned int	dma_length;
 #endif
+	unsigned long	private_data;
 };
 
 /*
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 75f53f8..ea29e73 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -72,10 +72,11 @@ enum dma_transaction_type {
 	DMA_ASYNC_TX,
 	DMA_SLAVE,
 	DMA_CYCLIC,
+	DMA_BOX,
 };
 
 /* last transaction type for creation of the capabilities mask */
-#define DMA_TX_TYPE_END (DMA_CYCLIC + 1)
+#define DMA_TX_TYPE_END (DMA_BOX + 1)
 
 
 /**
@@ -404,6 +405,15 @@ struct dma_tx_state {
 	u32 residue;
 };
 
+
+struct dma_box_list {
+	dma_addr_t dma_row_address;
+	unsigned int dma_row_len;
+	unsigned int dma_row_num;
+	unsigned int dma_row_offset;
+	unsigned long private_data;
+};
+
 /**
  * struct dma_device - info on the entity supplying DMA services
  * @chancnt: how many DMA channels are supported
@@ -497,6 +507,11 @@ struct dma_device {
 	struct dma_async_tx_descriptor *(*device_prep_dma_cyclic)(
 		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
 		size_t period_len, enum dma_data_direction direction);
+	struct dma_async_tx_descriptor *(*device_prep_dma_box)(
+		struct dma_chan *chan, struct dma_box_list *dst_box,
+		struct dma_box_list *src_box, unsigned int num_list,
+		unsigned long flags);
+
 	int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		unsigned long arg);
 
-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

