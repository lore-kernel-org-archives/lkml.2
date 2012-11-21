Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab2KUInG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 03:43:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:9026 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab2KUImx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 03:42:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,291,1352102400"; 
   d="scan'208";a="222541516"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 1/2] dw_dmac: store direction in the custom channel structure
Date: Wed, 21 Nov 2012 10:42:34 +0200
Message-Id: <1353487355-9894-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the direction value comes from the generic slave configuration
structure and explicitly as a preparation function parameter. The first one is
kinda obsoleted. Thus, we have to store the value passed to the preparation
function somewhere in our structures to be able to use it later. The best
candidate to provide the storage is a custom channel structure. Until now we
still keep and check the direction field of the slave config structure as well.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/dma/dw_dmac.c      |   12 ++++++++++--
 drivers/dma/dw_dmac_regs.h |   14 ++++++++------
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 5e2c4dc..1100fa0 100644
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
 
@@ -723,6 +723,8 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 		return NULL;
 	}
 
+	dwc->direction = DMA_MEM_TO_MEM;
+
 	data_width = min_t(unsigned int, dwc->dw->data_width[dwc_get_sms(dws)],
 					 dwc->dw->data_width[dwc_get_dms(dws)]);
 
@@ -807,6 +809,8 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	if (unlikely(!dws || !sg_len))
 		return NULL;
 
+	dwc->direction = direction;
+
 	prev = first = NULL;
 
 	switch (direction) {
@@ -983,6 +987,7 @@ set_runtime_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
 		return -EINVAL;
 
 	memcpy(&dwc->dma_sconfig, sconfig, sizeof(*sconfig));
+	dwc->direction = sconfig->direction;
 
 	convert_burst(&dwc->dma_sconfig.src_maxburst);
 	convert_burst(&dwc->dma_sconfig.dst_maxburst);
@@ -1339,6 +1344,8 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
 	if (unlikely(!is_slave_xfer(direction)))
 		goto out_err;
 
+	dwc->direction = direction;
+
 	if (direction == DMA_MEM_TO_DEV)
 		reg_width = __ffs(sconfig->dst_addr_width);
 	else
@@ -1713,6 +1720,7 @@ static int __devinit dw_probe(struct platform_device *pdev)
 		channel_clear_bit(dw, CH_EN, dwc->mask);
 
 		dwc->dw = dw;
+		dwc->direction = DMA_TRANS_NONE;
 
 		/* hardware configuration */
 		if (autocfg) {
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index 8881e9b..f9532c2 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -9,6 +9,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/dmaengine.h>
 #include <linux/dw_dmac.h>
 
 #define DW_DMA_MAX_NR_CHANNELS	8
@@ -184,12 +185,13 @@ enum dw_dmac_flags {
 };
 
 struct dw_dma_chan {
-	struct dma_chan		chan;
-	void __iomem		*ch_regs;
-	u8			mask;
-	u8			priority;
-	bool			paused;
-	bool			initialized;
+	struct dma_chan			chan;
+	void __iomem			*ch_regs;
+	u8				mask;
+	u8				priority;
+	enum dma_transfer_direction	direction;
+	bool				paused;
+	bool				initialized;
 
 	/* software emulation of the LLP transfers */
 	struct list_head	*tx_list;
-- 
1.7.10.4

