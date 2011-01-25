Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab1AYKY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:24:57 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:34853 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753256Ab1AYKT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:19:27 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 15/32] dma40: combine desc init functions
Date: Tue, 25 Jan 2011 11:18:18 +0100
Message-ID: <1295950715-22340-16-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
References: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

The desc init code can be shared between the mem and slave prep routines.

Acked-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |   76 ++++++++++++++++++++---------------------------
 1 files changed, 32 insertions(+), 44 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 0a20179..5259a98 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1617,6 +1617,35 @@ static u32 stedma40_residue(struct dma_chan *chan)
 	return bytes_left;
 }
 
+static struct d40_desc *
+d40_prep_desc(struct d40_chan *chan, struct scatterlist *sg,
+	      unsigned int sg_len, unsigned long dma_flags)
+{
+	struct stedma40_chan_cfg *cfg = &chan->dma_cfg;
+	struct d40_desc *desc;
+
+	desc = d40_desc_get(chan);
+	if (!desc)
+		return NULL;
+
+	desc->lli_len = d40_sg_2_dmalen(sg, sg_len, cfg->src_info.data_width,
+					cfg->dst_info.data_width);
+	if (desc->lli_len < 0) {
+		chan_err(chan, "Unaligned size\n");
+		d40_desc_free(chan, desc);
+
+		return NULL;
+	}
+
+	desc->lli_current = 0;
+	desc->txd.flags = dma_flags;
+	desc->txd.tx_submit = d40_tx_submit;
+
+	dma_async_tx_descriptor_init(&desc->txd, &chan->chan);
+
+	return desc;
+}
+
 struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 						   struct scatterlist *sgl_dst,
 						   struct scatterlist *sgl_src,
@@ -1635,22 +1664,11 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 	}
 
 	spin_lock_irqsave(&d40c->lock, flags);
-	d40d = d40_desc_get(d40c);
 
-	if (d40d == NULL)
+	d40d = d40_prep_desc(d40c, sgl_dst, sgl_len, dma_flags);
+	if (!d40d)
 		goto err;
 
-	d40d->lli_len = d40_sg_2_dmalen(sgl_dst, sgl_len,
-					d40c->dma_cfg.src_info.data_width,
-					d40c->dma_cfg.dst_info.data_width);
-	if (d40d->lli_len < 0) {
-		chan_err(d40c, "Unaligned size\n");
-		goto err;
-	}
-
-	d40d->lli_current = 0;
-	d40d->txd.flags = dma_flags;
-
 	if (chan_is_logical(d40c)) {
 
 		if (d40_pool_lli_alloc(d40c, d40d, d40d->lli_len, true) < 0) {
@@ -1708,10 +1726,6 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 					   d40d->lli_pool.size, DMA_TO_DEVICE);
 	}
 
-	dma_async_tx_descriptor_init(&d40d->txd, chan);
-
-	d40d->txd.tx_submit = d40_tx_submit;
-
 	spin_unlock_irqrestore(&d40c->lock, flags);
 
 	return &d40d->txd;
@@ -1900,21 +1914,11 @@ static int d40_prep_slave_sg_log(struct d40_desc *d40d,
 	dma_addr_t dev_addr = 0;
 	int total_size;
 
-	d40d->lli_len = d40_sg_2_dmalen(sgl, sg_len,
-					d40c->dma_cfg.src_info.data_width,
-					d40c->dma_cfg.dst_info.data_width);
-	if (d40d->lli_len < 0) {
-		chan_err(d40c, "Unaligned size\n");
-		return -EINVAL;
-	}
-
 	if (d40_pool_lli_alloc(d40c, d40d, d40d->lli_len, true) < 0) {
 		chan_err(d40c, "Out of memory\n");
 		return -ENOMEM;
 	}
 
-	d40d->lli_current = 0;
-
 	if (direction == DMA_FROM_DEVICE)
 		if (d40c->runtime_addr)
 			dev_addr = d40c->runtime_addr;
@@ -1954,21 +1958,11 @@ static int d40_prep_slave_sg_phy(struct d40_desc *d40d,
 	dma_addr_t dst_dev_addr;
 	int res;
 
-	d40d->lli_len = d40_sg_2_dmalen(sgl, sgl_len,
-					d40c->dma_cfg.src_info.data_width,
-					d40c->dma_cfg.dst_info.data_width);
-	if (d40d->lli_len < 0) {
-		chan_err(d40c, "Unaligned size\n");
-		return -EINVAL;
-	}
-
 	if (d40_pool_lli_alloc(d40c, d40d, d40d->lli_len, false) < 0) {
 		chan_err(d40c, "Out of memory\n");
 		return -ENOMEM;
 	}
 
-	d40d->lli_current = 0;
-
 	if (direction == DMA_FROM_DEVICE) {
 		dst_dev_addr = 0;
 		if (d40c->runtime_addr)
@@ -2031,8 +2025,8 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 	}
 
 	spin_lock_irqsave(&d40c->lock, flags);
-	d40d = d40_desc_get(d40c);
 
+	d40d = d40_prep_desc(d40c, sgl, sg_len, dma_flags);
 	if (d40d == NULL)
 		goto err;
 
@@ -2048,12 +2042,6 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 		goto err;
 	}
 
-	d40d->txd.flags = dma_flags;
-
-	dma_async_tx_descriptor_init(&d40d->txd, chan);
-
-	d40d->txd.tx_submit = d40_tx_submit;
-
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return &d40d->txd;
 
-- 
1.7.3.2

