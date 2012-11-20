Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab2KTNi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 08:38:59 -0500
Received: from mga03.intel.com ([143.182.124.21]:53578 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab2KTNi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 08:38:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,285,1352102400"; 
   d="scan'208";a="220152466"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/2] dw_dmac: store direction in the custom channel structure
Date: Tue, 20 Nov 2012 15:38:45 +0200
Message-Id: <1353418726-7879-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the direction value is come from the generic slave configuration
structure and explicitly as a preparation function parameter. The first one is
kinda obsoleted. Thus, we have to store the value passed to the preparation
function somewhere in our structures to be able to use it later. The best
candidate to provide the storage is a custom channel structure. Until now we
still keep and check the direction field of the slave config structure as well.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c      |   10 ++++++++--
 drivers/dma/dw_dmac_regs.h |    2 ++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 5e2c4dc..58c6d3c 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -178,9 +178,9 @@ static void dwc_initialize(struct dw_dma_chan *dwc)
 		cfghi = dws->cfg_hi;
 		cfglo |= dws->cfg_lo & ~DWC_CFGL_CH_PRIOR_MASK;
 	} else {
-		if (dwc->dma_sconfig.direction == DMA_MEM_TO_DEV)
+		if (dwc->direction == DMA_MEM_TO_DEV)
 			cfghi = DWC_CFGH_DST_PER(dwc->dma_sconfig.slave_id);
-		else if (dwc->dma_sconfig.direction == DMA_DEV_TO_MEM)
+		else if (dwc->direction == DMA_DEV_TO_MEM)
 			cfghi = DWC_CFGH_SRC_PER(dwc->dma_sconfig.slave_id);
 	}
 
@@ -807,6 +807,8 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	if (unlikely(!dws || !sg_len))
 		return NULL;
 
+	dwc->direction = direction;
+
 	prev = first = NULL;
 
 	switch (direction) {
@@ -983,6 +985,7 @@ set_runtime_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
 		return -EINVAL;
 
 	memcpy(&dwc->dma_sconfig, sconfig, sizeof(*sconfig));
+	dwc->direction = sconfig->direction;
 
 	convert_burst(&dwc->dma_sconfig.src_maxburst);
 	convert_burst(&dwc->dma_sconfig.dst_maxburst);
@@ -1339,6 +1342,8 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
 	if (unlikely(!is_slave_xfer(direction)))
 		goto out_err;
 
+	dwc->direction = direction;
+
 	if (direction == DMA_MEM_TO_DEV)
 		reg_width = __ffs(sconfig->dst_addr_width);
 	else
@@ -1713,6 +1718,7 @@ static int __devinit dw_probe(struct platform_device *pdev)
 		channel_clear_bit(dw, CH_EN, dwc->mask);
 
 		dwc->dw = dw;
+		dwc->direction = DMA_TRANS_NONE;
 
 		/* hardware configuration */
 		if (autocfg) {
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index 8881e9b..362aba1 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -9,6 +9,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/dmaengine.h>
 #include <linux/dw_dmac.h>
 
 #define DW_DMA_MAX_NR_CHANNELS	8
@@ -188,6 +189,7 @@ struct dw_dma_chan {
 	void __iomem		*ch_regs;
 	u8			mask;
 	u8			priority;
+	enum dma_transfer_direction direction;
 	bool			paused;
 	bool			initialized;
 
-- 
1.7.10.4

