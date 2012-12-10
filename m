Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab2LJOkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 09:40:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:42075 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414Ab2LJOkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 09:40:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,252,1355126400"; 
   d="scan'208";a="261880343"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 2/2] dw_dmac: check for mapping errors
Date: Mon, 10 Dec 2012 16:40:04 +0200
Message-Id: <1355150404-6732-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355150404-6732-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1355150404-6732-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise we get a warning in case of CONFIG_DMA_API_DEBUG=y

[   45.775943] WARNING: at lib/dma-debug.c:933 check_unmap+0x5d6/0x6ac()
[   45.782369] dw_dmac dw_dmac.0: DMA-API: device driver failed to check map error[device address=0x00000000356efcc0] [size=28 bytes] [mapped as single]

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 427d35b..f8937cb 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1099,6 +1099,7 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 	struct dw_desc		*desc;
 	int			i;
 	unsigned long		flags;
+	int			ret;
 
 	dev_vdbg(chan2dev(chan), "%s\n", __func__);
 
@@ -1122,12 +1123,8 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 		spin_unlock_irqrestore(&dwc->lock, flags);
 
 		desc = kzalloc(sizeof(struct dw_desc), GFP_KERNEL);
-		if (!desc) {
-			dev_info(chan2dev(chan),
-				"only allocated %d descriptors\n", i);
-			spin_lock_irqsave(&dwc->lock, flags);
-			break;
-		}
+		if (!desc)
+			goto err_desc_alloc;
 
 		INIT_LIST_HEAD(&desc->tx_list);
 		dma_async_tx_descriptor_init(&desc->txd, chan);
@@ -1135,6 +1132,10 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 		desc->txd.flags = DMA_CTRL_ACK;
 		desc->txd.phys = dma_map_single(chan2parent(chan), &desc->lli,
 				sizeof(desc->lli), DMA_TO_DEVICE);
+		ret = dma_mapping_error(chan2parent(chan), desc->txd.phys);
+		if (ret)
+			goto err_desc_alloc;
+
 		dwc_desc_put(dwc, desc);
 
 		spin_lock_irqsave(&dwc->lock, flags);
@@ -1146,6 +1147,13 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 	dev_dbg(chan2dev(chan), "%s: allocated %d descriptors\n", __func__, i);
 
 	return i;
+
+err_desc_alloc:
+	kfree(desc);
+
+	dev_info(chan2dev(chan), "only allocated %d descriptors\n", i);
+
+	return i;
 }
 
 static void dwc_free_chan_resources(struct dma_chan *chan)
-- 
1.7.10.4

