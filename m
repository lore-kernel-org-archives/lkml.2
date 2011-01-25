Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab1AYKZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:25:45 -0500
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:60434 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753235Ab1AYKTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:19:25 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 14/32] dma40: implement prep_memcpy as a wrapper around memcpy_sg
Date: Tue, 25 Jan 2011 11:18:17 +0100
Message-ID: <1295950715-22340-15-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
References: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

To simplify the code.

Acked-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c    |  107 ++++----------------------------------------
 drivers/dma/ste_dma40_ll.c |    2 +-
 drivers/dma/ste_dma40_ll.h |   11 -----
 3 files changed, 10 insertions(+), 110 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index bd72269..0a20179 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1863,108 +1863,19 @@ static struct dma_async_tx_descriptor *d40_prep_memcpy(struct dma_chan *chan,
 						       size_t size,
 						       unsigned long dma_flags)
 {
-	struct d40_desc *d40d;
-	struct d40_chan *d40c = container_of(chan, struct d40_chan,
-					     chan);
-	unsigned long flags;
-
-	if (d40c->phy_chan == NULL) {
-		chan_err(d40c, "Channel is not allocated.\n");
-		return ERR_PTR(-EINVAL);
-	}
-
-	spin_lock_irqsave(&d40c->lock, flags);
-	d40d = d40_desc_get(d40c);
-
-	if (d40d == NULL) {
-		chan_err(d40c, "Descriptor is NULL\n");
-		goto err;
-	}
-
-	d40d->txd.flags = dma_flags;
-	d40d->lli_len = d40_size_2_dmalen(size,
-					  d40c->dma_cfg.src_info.data_width,
-					  d40c->dma_cfg.dst_info.data_width);
-	if (d40d->lli_len < 0) {
-		chan_err(d40c, "Unaligned size\n");
-		goto err;
-	}
-
-
-	dma_async_tx_descriptor_init(&d40d->txd, chan);
-
-	d40d->txd.tx_submit = d40_tx_submit;
-
-	if (chan_is_logical(d40c)) {
-
-		if (d40_pool_lli_alloc(d40c,d40d, d40d->lli_len, true) < 0) {
-			chan_err(d40c, "Out of memory\n");
-			goto err;
-		}
-		d40d->lli_current = 0;
-
-		if (d40_log_buf_to_lli(d40d->lli_log.src,
-				       src,
-				       size,
-				       d40c->log_def.lcsp1,
-				       d40c->dma_cfg.src_info.data_width,
-				       d40c->dma_cfg.dst_info.data_width,
-				       true) == NULL)
-			goto err;
-
-		if (d40_log_buf_to_lli(d40d->lli_log.dst,
-				       dst,
-				       size,
-				       d40c->log_def.lcsp3,
-				       d40c->dma_cfg.dst_info.data_width,
-				       d40c->dma_cfg.src_info.data_width,
-				       true) == NULL)
-			goto err;
-
-	} else {
-
-		if (d40_pool_lli_alloc(d40c, d40d, d40d->lli_len, false) < 0) {
-			chan_err(d40c, "Out of memory\n");
-			goto err;
-		}
-
-		if (d40_phy_buf_to_lli(d40d->lli_phy.src,
-				       src,
-				       size,
-				       d40c->dma_cfg.src_info.psize,
-				       0,
-				       d40c->src_def_cfg,
-				       true,
-				       d40c->dma_cfg.src_info.data_width,
-				       d40c->dma_cfg.dst_info.data_width,
-				       false) == NULL)
-			goto err;
+	struct scatterlist dst_sg;
+	struct scatterlist src_sg;
 
-		if (d40_phy_buf_to_lli(d40d->lli_phy.dst,
-				       dst,
-				       size,
-				       d40c->dma_cfg.dst_info.psize,
-				       0,
-				       d40c->dst_def_cfg,
-				       true,
-				       d40c->dma_cfg.dst_info.data_width,
-				       d40c->dma_cfg.src_info.data_width,
-				       false) == NULL)
-			goto err;
+	sg_init_table(&dst_sg, 1);
+	sg_init_table(&src_sg, 1);
 
-		dma_sync_single_for_device(d40c->base->dev,
-					   d40d->lli_pool.dma_addr,
-					   d40d->lli_pool.size, DMA_TO_DEVICE);
-	}
+	sg_dma_address(&dst_sg) = dst;
+	sg_dma_address(&src_sg) = src;
 
-	spin_unlock_irqrestore(&d40c->lock, flags);
-	return &d40d->txd;
+	sg_dma_len(&dst_sg) = size;
+	sg_dma_len(&src_sg) = size;
 
-err:
-	if (d40d)
-		d40_desc_free(d40c, d40d);
-	spin_unlock_irqrestore(&d40c->lock, flags);
-	return NULL;
+	return stedma40_memcpy_sg(chan, &dst_sg, &src_sg, 1, dma_flags);
 }
 
 static struct dma_async_tx_descriptor *
diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
index 6f03f58..552c597 100644
--- a/drivers/dma/ste_dma40_ll.c
+++ b/drivers/dma/ste_dma40_ll.c
@@ -198,7 +198,7 @@ static int d40_seg_size(int size, int data_width1, int data_width2)
 	return seg_max;
 }
 
-struct d40_phy_lli *d40_phy_buf_to_lli(struct d40_phy_lli *lli,
+static struct d40_phy_lli *d40_phy_buf_to_lli(struct d40_phy_lli *lli,
 				       dma_addr_t addr,
 				       u32 size,
 				       int psize,
diff --git a/drivers/dma/ste_dma40_ll.h b/drivers/dma/ste_dma40_ll.h
index e93f394..a5d7171 100644
--- a/drivers/dma/ste_dma40_ll.h
+++ b/drivers/dma/ste_dma40_ll.h
@@ -312,17 +312,6 @@ int d40_phy_sg_to_lli(struct scatterlist *sg,
 		      u32 data_width2,
 		      int psize);
 
-struct d40_phy_lli *d40_phy_buf_to_lli(struct d40_phy_lli *lli,
-				       dma_addr_t data,
-				       u32 data_size,
-				       int psize,
-				       dma_addr_t next_lli,
-				       u32 reg_cfg,
-				       bool term_int,
-				       u32 data_width1,
-				       u32 data_width2,
-				       bool is_device);
-
 void d40_phy_lli_write(void __iomem *virtbase,
 		       u32 phy_chan_num,
 		       struct d40_phy_lli *lli_dst,
-- 
1.7.3.2

