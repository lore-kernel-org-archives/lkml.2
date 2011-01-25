Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab1AYKTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:19:35 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:46313 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753227Ab1AYKTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:19:23 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 12/32] dma40: fix DMA API usage for LLIs
Date: Tue, 25 Jan 2011 11:18:15 +0100
Message-ID: <1295950715-22340-13-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
References: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

Map and unmap the LLIs and use dma_sync_single_for_device() appropriately
instead of mapping and never unmapping them.

Acked-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |   58 +++++++++++++++++++++++++++++++++-------------
 1 files changed, 41 insertions(+), 17 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index f08e5c49..b585686 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -68,6 +68,7 @@ enum d40_command {
  * @base: Pointer to memory area when the pre_alloc_lli's are not large
  * enough, IE bigger than the most common case, 1 dst and 1 src. NULL if
  * pre_alloc_lli is used.
+ * @dma_addr: DMA address, if mapped
  * @size: The size in bytes of the memory at base or the size of pre_alloc_lli.
  * @pre_alloc_lli: Pre allocated area for the most common case of transfers,
  * one buffer to one buffer.
@@ -75,6 +76,7 @@ enum d40_command {
 struct d40_lli_pool {
 	void	*base;
 	int	 size;
+	dma_addr_t	dma_addr;
 	/* Space for dst and src, plus an extra for padding */
 	u8	 pre_alloc_lli[3 * sizeof(struct d40_phy_lli)];
 };
@@ -329,7 +331,7 @@ static void __iomem *chan_base(struct d40_chan *chan)
 #define chan_err(d40c, format, arg...)		\
 	d40_err(chan2dev(d40c), format, ## arg)
 
-static int d40_pool_lli_alloc(struct d40_desc *d40d,
+static int d40_pool_lli_alloc(struct d40_chan *d40c, struct d40_desc *d40d,
 			      int lli_len, bool is_log)
 {
 	u32 align;
@@ -358,17 +360,36 @@ static int d40_pool_lli_alloc(struct d40_desc *d40d,
 		d40d->lli_log.src = PTR_ALIGN((struct d40_log_lli *) base,
 					      align);
 		d40d->lli_log.dst = d40d->lli_log.src + lli_len;
+
+		d40d->lli_pool.dma_addr = 0;
 	} else {
 		d40d->lli_phy.src = PTR_ALIGN((struct d40_phy_lli *)base,
 					      align);
 		d40d->lli_phy.dst = d40d->lli_phy.src + lli_len;
+
+		d40d->lli_pool.dma_addr = dma_map_single(d40c->base->dev,
+							 d40d->lli_phy.src,
+							 d40d->lli_pool.size,
+							 DMA_TO_DEVICE);
+
+		if (dma_mapping_error(d40c->base->dev,
+				      d40d->lli_pool.dma_addr)) {
+			kfree(d40d->lli_pool.base);
+			d40d->lli_pool.base = NULL;
+			d40d->lli_pool.dma_addr = 0;
+			return -ENOMEM;
+		}
 	}
 
 	return 0;
 }
 
-static void d40_pool_lli_free(struct d40_desc *d40d)
+static void d40_pool_lli_free(struct d40_chan *d40c, struct d40_desc *d40d)
 {
+	if (d40d->lli_pool.dma_addr)
+		dma_unmap_single(d40c->base->dev, d40d->lli_pool.dma_addr,
+				 d40d->lli_pool.size, DMA_TO_DEVICE);
+
 	kfree(d40d->lli_pool.base);
 	d40d->lli_pool.base = NULL;
 	d40d->lli_pool.size = 0;
@@ -454,7 +475,7 @@ static struct d40_desc *d40_desc_get(struct d40_chan *d40c)
 
 		list_for_each_entry_safe(d, _d, &d40c->client, node)
 			if (async_tx_test_ack(&d->txd)) {
-				d40_pool_lli_free(d);
+				d40_pool_lli_free(d40c, d);
 				d40_desc_remove(d);
 				desc = d;
 				memset(desc, 0, sizeof(*desc));
@@ -474,6 +495,7 @@ static struct d40_desc *d40_desc_get(struct d40_chan *d40c)
 static void d40_desc_free(struct d40_chan *d40c, struct d40_desc *d40d)
 {
 
+	d40_pool_lli_free(d40c, d40d);
 	d40_lcla_free_all(d40c, d40d);
 	kmem_cache_free(d40c->base->desc_slab, d40d);
 }
@@ -1063,7 +1085,7 @@ static void dma_tasklet(unsigned long data)
 	callback_param = d40d->txd.callback_param;
 
 	if (async_tx_test_ack(&d40d->txd)) {
-		d40_pool_lli_free(d40d);
+		d40_pool_lli_free(d40c, d40d);
 		d40_desc_remove(d40d);
 		d40_desc_free(d40c, d40d);
 	} else {
@@ -1459,7 +1481,7 @@ static int d40_free_dma(struct d40_chan *d40c)
 	/* Release client owned descriptors */
 	if (!list_empty(&d40c->client))
 		list_for_each_entry_safe(d, _d, &d40c->client, node) {
-			d40_pool_lli_free(d);
+			d40_pool_lli_free(d40c, d);
 			d40_desc_remove(d);
 			d40_desc_free(d40c, d);
 		}
@@ -1633,7 +1655,7 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 
 	if (chan_is_logical(d40c)) {
 
-		if (d40_pool_lli_alloc(d40d, d40d->lli_len, true) < 0) {
+		if (d40_pool_lli_alloc(d40c, d40d, d40d->lli_len, true) < 0) {
 			chan_err(d40c, "Out of memory\n");
 			goto err;
 		}
@@ -1652,7 +1674,7 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 					 d40c->dma_cfg.dst_info.data_width,
 					 d40c->dma_cfg.src_info.data_width);
 	} else {
-		if (d40_pool_lli_alloc(d40d, d40d->lli_len, false) < 0) {
+		if (d40_pool_lli_alloc(d40c, d40d, d40d->lli_len, false) < 0) {
 			chan_err(d40c, "Out of memory\n");
 			goto err;
 		}
@@ -1683,8 +1705,9 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 		if (res < 0)
 			goto err;
 
-		(void) dma_map_single(d40c->base->dev, d40d->lli_phy.src,
-				      d40d->lli_pool.size, DMA_TO_DEVICE);
+		dma_sync_single_for_device(d40c->base->dev,
+					   d40d->lli_pool.dma_addr,
+					   d40d->lli_pool.size, DMA_TO_DEVICE);
 	}
 
 	dma_async_tx_descriptor_init(&d40d->txd, chan);
@@ -1876,7 +1899,7 @@ static struct dma_async_tx_descriptor *d40_prep_memcpy(struct dma_chan *chan,
 
 	if (chan_is_logical(d40c)) {
 
-		if (d40_pool_lli_alloc(d40d, d40d->lli_len, true) < 0) {
+		if (d40_pool_lli_alloc(d40c,d40d, d40d->lli_len, true) < 0) {
 			chan_err(d40c, "Out of memory\n");
 			goto err;
 		}
@@ -1902,7 +1925,7 @@ static struct dma_async_tx_descriptor *d40_prep_memcpy(struct dma_chan *chan,
 
 	} else {
 
-		if (d40_pool_lli_alloc(d40d, d40d->lli_len, false) < 0) {
+		if (d40_pool_lli_alloc(d40c, d40d, d40d->lli_len, false) < 0) {
 			chan_err(d40c, "Out of memory\n");
 			goto err;
 		}
@@ -1931,8 +1954,9 @@ static struct dma_async_tx_descriptor *d40_prep_memcpy(struct dma_chan *chan,
 				       false) == NULL)
 			goto err;
 
-		(void) dma_map_single(d40c->base->dev, d40d->lli_phy.src,
-				      d40d->lli_pool.size, DMA_TO_DEVICE);
+		dma_sync_single_for_device(d40c->base->dev,
+					   d40d->lli_pool.dma_addr,
+					   d40d->lli_pool.size, DMA_TO_DEVICE);
 	}
 
 	spin_unlock_irqrestore(&d40c->lock, flags);
@@ -1975,7 +1999,7 @@ static int d40_prep_slave_sg_log(struct d40_desc *d40d,
 		return -EINVAL;
 	}
 
-	if (d40_pool_lli_alloc(d40d, d40d->lli_len, true) < 0) {
+	if (d40_pool_lli_alloc(d40c, d40d, d40d->lli_len, true) < 0) {
 		chan_err(d40c, "Out of memory\n");
 		return -ENOMEM;
 	}
@@ -2029,7 +2053,7 @@ static int d40_prep_slave_sg_phy(struct d40_desc *d40d,
 		return -EINVAL;
 	}
 
-	if (d40_pool_lli_alloc(d40d, d40d->lli_len, false) < 0) {
+	if (d40_pool_lli_alloc(d40c, d40d, d40d->lli_len, false) < 0) {
 		chan_err(d40c, "Out of memory\n");
 		return -ENOMEM;
 	}
@@ -2075,8 +2099,8 @@ static int d40_prep_slave_sg_phy(struct d40_desc *d40d,
 	if (res < 0)
 		return res;
 
-	(void) dma_map_single(d40c->base->dev, d40d->lli_phy.src,
-			      d40d->lli_pool.size, DMA_TO_DEVICE);
+	dma_sync_single_for_device(d40c->base->dev, d40d->lli_pool.dma_addr,
+				   d40d->lli_pool.size, DMA_TO_DEVICE);
 	return 0;
 }
 
-- 
1.7.3.2

