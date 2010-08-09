Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab0HIMI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 08:08:27 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:47451 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756372Ab0HIMIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 08:08:21 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Jonas Aaberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 05/14] DMAENGINE: ste_dma40: fix bug related to callback handling
Date: Mon, 9 Aug 2010 14:08:10 +0200
Message-ID: <1281355690-13211-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

The callback got called even when it was not supposed to. Also
removed some not needed interrupt trigger on/off code.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c    |   17 +++++------------
 drivers/dma/ste_dma40_ll.c |   13 ++++++-------
 drivers/dma/ste_dma40_ll.h |    7 +++----
 3 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 1adaebf..a6a7d66 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -878,7 +878,7 @@ static void dma_tasklet(unsigned long data)
 
 	spin_unlock_irqrestore(&d40c->lock, flags);
 
-	if (callback)
+	if (callback && (d40d_fin->txd.flags & DMA_PREP_INTERRUPT))
 		callback(callback_param);
 
 	return;
@@ -1583,7 +1583,6 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 					 d40d->lli_log.src,
 					 d40c->log_def.lcsp1,
 					 d40c->dma_cfg.src_info.data_width,
-					 dma_flags & DMA_PREP_INTERRUPT,
 					 d40d->lli_tx_len,
 					 d40c->base->plat_data->llis_per_log);
 
@@ -1593,7 +1592,6 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 					 d40d->lli_log.dst,
 					 d40c->log_def.lcsp3,
 					 d40c->dma_cfg.dst_info.data_width,
-					 dma_flags & DMA_PREP_INTERRUPT,
 					 d40d->lli_tx_len,
 					 d40c->base->plat_data->llis_per_log);
 
@@ -1612,8 +1610,7 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 					d40d->lli_phy.src_addr,
 					d40c->src_def_cfg,
 					d40c->dma_cfg.src_info.data_width,
-					d40c->dma_cfg.src_info.psize,
-					true);
+					d40c->dma_cfg.src_info.psize);
 
 		if (res < 0)
 			goto err;
@@ -1625,8 +1622,7 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 					d40d->lli_phy.dst_addr,
 					d40c->dst_def_cfg,
 					d40c->dma_cfg.dst_info.data_width,
-					d40c->dma_cfg.dst_info.psize,
-					true);
+					d40c->dma_cfg.dst_info.psize);
 
 		if (res < 0)
 			goto err;
@@ -1913,7 +1909,6 @@ static int d40_prep_slave_sg_log(struct d40_desc *d40d,
 				       d40c->dma_cfg.src_info.data_width,
 				       d40c->dma_cfg.dst_info.data_width,
 				       direction,
-				       dma_flags & DMA_PREP_INTERRUPT,
 				       dev_addr, d40d->lli_tx_len,
 				       d40c->base->plat_data->llis_per_log);
 
@@ -1965,8 +1960,7 @@ static int d40_prep_slave_sg_phy(struct d40_desc *d40d,
 				d40d->lli_phy.src_addr,
 				d40c->src_def_cfg,
 				d40c->dma_cfg.src_info.data_width,
-				d40c->dma_cfg.src_info.psize,
-				true);
+				d40c->dma_cfg.src_info.psize);
 	if (res < 0)
 		return res;
 
@@ -1977,8 +1971,7 @@ static int d40_prep_slave_sg_phy(struct d40_desc *d40d,
 				d40d->lli_phy.dst_addr,
 				d40c->dst_def_cfg,
 				d40c->dma_cfg.dst_info.data_width,
-				d40c->dma_cfg.dst_info.psize,
-				 true);
+				d40c->dma_cfg.dst_info.psize);
 	if (res < 0)
 		return res;
 
diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
index d937f76..6707672 100644
--- a/drivers/dma/ste_dma40_ll.c
+++ b/drivers/dma/ste_dma40_ll.c
@@ -197,8 +197,7 @@ int d40_phy_sg_to_lli(struct scatterlist *sg,
 		      dma_addr_t lli_phys,
 		      u32 reg_cfg,
 		      u32 data_width,
-		      int psize,
-		      bool term_int)
+		      int psize)
 {
 	int total_size = 0;
 	int i;
@@ -309,7 +308,7 @@ int d40_log_sg_to_dev(struct d40_lcla_elem *lcla,
 		      u32 src_data_width,
 		      u32 dst_data_width,
 		      enum dma_data_direction direction,
-		      bool term_int, dma_addr_t dev_addr, int max_len,
+		      dma_addr_t dev_addr, int max_len,
 		      int llis_per_log)
 {
 	int total_size = 0;
@@ -356,7 +355,7 @@ int d40_log_sg_to_dev(struct d40_lcla_elem *lcla,
 					 next_lli_off_dst,
 					 lcsp->lcsp3, dst_data_width,
 					 /* No next == terminal interrupt */
-					 term_int && !next_lli_off_dst,
+					 !next_lli_off_dst,
 					 false);
 		} else {
 			d40_log_fill_lli(&lli->dst[i],
@@ -365,7 +364,7 @@ int d40_log_sg_to_dev(struct d40_lcla_elem *lcla,
 					 next_lli_off_dst,
 					 lcsp->lcsp3, dst_data_width,
 					 /* No next == terminal interrupt */
-					 term_int && !next_lli_off_dst,
+					 !next_lli_off_dst,
 					 true);
 			d40_log_fill_lli(&lli->src[i],
 					 dev_addr,
@@ -385,7 +384,7 @@ int d40_log_sg_to_lli(int lcla_id,
 		      struct d40_log_lli *lli_sg,
 		      u32 lcsp13, /* src or dst*/
 		      u32 data_width,
-		      bool term_int, int max_len, int llis_per_log)
+		      int max_len, int llis_per_log)
 {
 	int total_size = 0;
 	struct scatterlist *current_sg = sg;
@@ -414,7 +413,7 @@ int d40_log_sg_to_lli(int lcla_id,
 				 sg_dma_len(current_sg),
 				 next_lli_off,
 				 lcsp13, data_width,
-				 term_int && !next_lli_off,
+				 !next_lli_off,
 				 true);
 	}
 	return total_size;
diff --git a/drivers/dma/ste_dma40_ll.h b/drivers/dma/ste_dma40_ll.h
index 9c0fa2f..0c468c3 100644
--- a/drivers/dma/ste_dma40_ll.h
+++ b/drivers/dma/ste_dma40_ll.h
@@ -302,8 +302,7 @@ int d40_phy_sg_to_lli(struct scatterlist *sg,
 		      dma_addr_t lli_phys,
 		      u32 reg_cfg,
 		      u32 data_width,
-		      int psize,
-		      bool term_int);
+		      int psize);
 
 int d40_phy_fill_lli(struct d40_phy_lli *lli,
 		     dma_addr_t data,
@@ -336,7 +335,7 @@ int d40_log_sg_to_dev(struct d40_lcla_elem *lcla,
 		      u32 src_data_width,
 		      u32 dst_data_width,
 		      enum dma_data_direction direction,
-		      bool term_int, dma_addr_t dev_addr, int max_len,
+		      dma_addr_t dev_addr, int max_len,
 		      int llis_per_log);
 
 int d40_log_lli_write(struct d40_log_lli_full *lcpa,
@@ -352,6 +351,6 @@ int d40_log_sg_to_lli(int lcla_id,
 		      struct d40_log_lli *lli_sg,
 		      u32 lcsp13, /* src or dst*/
 		      u32 data_width,
-		      bool term_int, int max_len, int llis_per_log);
+		      int max_len, int llis_per_log);
 
 #endif /* STE_DMA40_LLI_H */
-- 
1.6.3.3

