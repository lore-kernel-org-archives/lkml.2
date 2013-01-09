Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab3AIIUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 03:20:42 -0500
Received: from mga03.intel.com ([143.182.124.21]:25873 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757020Ab3AIIRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 03:17:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,436,1355126400"; 
   d="scan'208";a="189184461"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Subject: [resend][PATCH 11/16] dw_dmac: backlink to dw_dma in dw_dma_chan is superfluous
Date: Wed,  9 Jan 2013 10:17:10 +0200
Message-Id: <1357719435-29955-12-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <20130108155423.GJ19691@intel.com>
 <1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same information could be exctracted from the struct dma_chan.
The patch introduces helper function dwc_get_data_width() as well.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/dma/dw_dmac.c      |   27 ++++++++++++++++++++-------
 drivers/dma/dw_dmac_regs.h |    3 ---
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index ff9d68b..39a6506 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -73,6 +73,22 @@ static inline unsigned int dwc_get_sms(struct dw_dma_slave *slave)
  */
 #define NR_DESCS_PER_CHANNEL	64
 
+#define SRC_MASTER	0
+#define DST_MASTER	1
+
+static inline unsigned int dwc_get_data_width(struct dma_chan *chan, int master)
+{
+	struct dw_dma *dw = to_dw_dma(chan->device);
+	struct dw_dma_slave *dws = chan->private;
+
+	if (master == SRC_MASTER)
+		return dw->data_width[dwc_get_sms(dws)];
+	else if (master == DST_MASTER)
+		return dw->data_width[dwc_get_dms(dws)];
+
+	return 0;
+}
+
 /*----------------------------------------------------------------------*/
 
 /*
@@ -703,7 +719,6 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 		size_t len, unsigned long flags)
 {
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
-	struct dw_dma_slave	*dws = chan->private;
 	struct dw_desc		*desc;
 	struct dw_desc		*first;
 	struct dw_desc		*prev;
@@ -726,8 +741,8 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 
 	dwc->direction = DMA_MEM_TO_MEM;
 
-	data_width = min_t(unsigned int, dwc->dw->data_width[dwc_get_sms(dws)],
-					 dwc->dw->data_width[dwc_get_dms(dws)]);
+	data_width = min_t(unsigned int, dwc_get_data_width(chan, SRC_MASTER),
+			   dwc_get_data_width(chan, DST_MASTER));
 
 	src_width = dst_width = min_t(unsigned int, data_width,
 				      dwc_fast_fls(src | dest | len));
@@ -792,7 +807,6 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		unsigned long flags, void *context)
 {
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
-	struct dw_dma_slave	*dws = chan->private;
 	struct dma_slave_config	*sconfig = &dwc->dma_sconfig;
 	struct dw_desc		*prev;
 	struct dw_desc		*first;
@@ -826,7 +840,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		ctllo |= sconfig->device_fc ? DWC_CTLL_FC(DW_DMA_FC_P_M2P) :
 			DWC_CTLL_FC(DW_DMA_FC_D_M2P);
 
-		data_width = dwc->dw->data_width[dwc_get_sms(dws)];
+		data_width = dwc_get_data_width(chan, SRC_MASTER);
 
 		for_each_sg(sgl, sg, sg_len, i) {
 			struct dw_desc	*desc;
@@ -889,7 +903,7 @@ slave_sg_todev_fill_desc:
 		ctllo |= sconfig->device_fc ? DWC_CTLL_FC(DW_DMA_FC_P_P2M) :
 			DWC_CTLL_FC(DW_DMA_FC_D_P2M);
 
-		data_width = dwc->dw->data_width[dwc_get_dms(dws)];
+		data_width = dwc_get_data_width(chan, DST_MASTER);
 
 		for_each_sg(sgl, sg, sg_len, i) {
 			struct dw_desc	*desc;
@@ -1720,7 +1734,6 @@ static int dw_probe(struct platform_device *pdev)
 
 		channel_clear_bit(dw, CH_EN, dwc->mask);
 
-		dwc->dw = dw;
 		dwc->direction = DMA_TRANS_NONE;
 
 		/* hardware configuration */
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index f9532c2..577f2dd 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -214,9 +214,6 @@ struct dw_dma_chan {
 
 	/* configuration passed via DMA_SLAVE_CONFIG */
 	struct dma_slave_config dma_sconfig;
-
-	/* backlink to dw_dma */
-	struct dw_dma		*dw;
 };
 
 static inline struct dw_dma_chan_regs __iomem *
-- 
1.7.10.4

