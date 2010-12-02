Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab0LBIlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 03:41:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:62548 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab0LBIlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 03:41:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,287,1288594800"; 
   d="scan'208";a="579783315"
From: Feng Tang <feng.tang@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Cc: alan@linux.intel.com, Feng Tang <feng.tang@intel.com>
Subject: [PATCH] intel_mid_dma: add support for single item scatter-gather list
Date: Thu,  2 Dec 2010 17:14:30 +0800
Message-Id: <1291281270-8195-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current driver's device_prep_slave_sg can't be used by DMAC2 even
the sg list contains one item, this patch will enable DMAC2 to
use this API.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Acked-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/dma/intel_mid_dma.c |   28 ++++++++++++++++++++++++----
 1 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index 338bc4e..9e29d28 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -664,11 +664,20 @@ static struct dma_async_tx_descriptor *intel_mid_dma_prep_memcpy(
 	/*calculate CTL_LO*/
 	ctl_lo.ctl_lo = 0;
 	ctl_lo.ctlx.int_en = 1;
-	ctl_lo.ctlx.dst_tr_width = mids->dma_slave.dst_addr_width;
-	ctl_lo.ctlx.src_tr_width = mids->dma_slave.src_addr_width;
 	ctl_lo.ctlx.dst_msize = mids->dma_slave.src_maxburst;
 	ctl_lo.ctlx.src_msize = mids->dma_slave.dst_maxburst;
 
+	/*
+	 * Here we need some translation from "enum dma_slave_buswidth"
+	 * to the format for our dma controller
+	 *		standard	intel_mid_dmac's format
+	 *		 1 Byte			0b000
+	 *		 2 Bytes		0b001
+	 *		 4 Bytes		0b010
+	 */
+	ctl_lo.ctlx.dst_tr_width = mids->dma_slave.dst_addr_width / 2;
+	ctl_lo.ctlx.src_tr_width = mids->dma_slave.src_addr_width / 2;
+
 	if (mids->cfg_mode == LNW_DMA_MEM_TO_MEM) {
 		ctl_lo.ctlx.tt_fc = 0;
 		ctl_lo.ctlx.sinc = 0;
@@ -746,8 +755,18 @@ static struct dma_async_tx_descriptor *intel_mid_dma_prep_slave_sg(
 	BUG_ON(!mids);
 
 	if (!midc->dma->pimr_mask) {
-		pr_debug("MDMA: SG list is not supported by this controller\n");
-		return  NULL;
+		/* We can still handle sg list with only one item */
+		if (sg_len == 1) {
+			txd = intel_mid_dma_prep_memcpy(chan,
+						mids->dma_slave.dst_addr,
+						mids->dma_slave.src_addr,
+						sgl->length,
+						flags);
+			return txd;
+		} else {
+			pr_warn("MDMA: SG list is not supported by this controller\n");
+			return  NULL;
+		}
 	}
 
 	pr_debug("MDMA: SG Length = %d, direction = %d, Flags = %#lx\n",
@@ -758,6 +777,7 @@ static struct dma_async_tx_descriptor *intel_mid_dma_prep_slave_sg(
 		pr_err("MDMA: Prep memcpy failed\n");
 		return NULL;
 	}
+
 	desc = to_intel_mid_dma_desc(txd);
 	desc->dirn = direction;
 	ctl_lo.ctl_lo = desc->ctl_lo;
-- 
1.7.0.4

