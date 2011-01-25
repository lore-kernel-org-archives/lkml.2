Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab1AYKWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:22:12 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:45469 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753451Ab1AYKTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:19:48 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 11/32] dma40: fix DMA API usage for LCLA
Date: Tue, 25 Jan 2011 11:18:14 +0100
Message-ID: <1295950715-22340-12-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
References: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

Map the buffer once and use dma_sync*() appropriately instead of mapping the
buffer over and over without unmapping it.

Acked-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |   33 +++++++++++++++++++++++++--------
 1 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index d32a9ac..f08e5c49 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -128,6 +128,7 @@ struct d40_desc {
  */
 struct d40_lcla_pool {
 	void		*base;
+	dma_addr_t	dma_addr;
 	void		*base_unaligned;
 	int		 pages;
 	spinlock_t	 lock;
@@ -504,25 +505,25 @@ static void d40_desc_load(struct d40_chan *d40c, struct d40_desc *d40d)
 
 		d40d->lli_current++;
 		for (; d40d->lli_current < d40d->lli_len; d40d->lli_current++) {
-			struct d40_log_lli *lcla;
+			unsigned int lcla_offset = d40c->phy_chan->num * 1024 +
+						   8 * curr_lcla * 2;
+			struct d40_lcla_pool *pool = &d40c->base->lcla_pool;
+			struct d40_log_lli *lcla = pool->base + lcla_offset;
 
 			if (d40d->lli_current + 1 < d40d->lli_len)
 				next_lcla = d40_lcla_alloc_one(d40c, d40d);
 			else
 				next_lcla = -EINVAL;
 
-			lcla = d40c->base->lcla_pool.base +
-				d40c->phy_chan->num * 1024 +
-				8 * curr_lcla * 2;
-
 			d40_log_lli_lcla_write(lcla,
 					       &d40d->lli_log.dst[d40d->lli_current],
 					       &d40d->lli_log.src[d40d->lli_current],
 					       next_lcla);
 
-			(void) dma_map_single(d40c->base->dev, lcla,
-					      2 * sizeof(struct d40_log_lli),
-					      DMA_TO_DEVICE);
+			dma_sync_single_range_for_device(d40c->base->dev,
+						pool->dma_addr, lcla_offset,
+						2 * sizeof(struct d40_log_lli),
+						DMA_TO_DEVICE);
 
 			curr_lcla = next_lcla;
 
@@ -2771,6 +2772,7 @@ static void __init d40_hw_init(struct d40_base *base)
 
 static int __init d40_lcla_allocate(struct d40_base *base)
 {
+	struct d40_lcla_pool *pool = &base->lcla_pool;
 	unsigned long *page_list;
 	int i, j;
 	int ret = 0;
@@ -2835,6 +2837,15 @@ static int __init d40_lcla_allocate(struct d40_base *base)
 						 LCLA_ALIGNMENT);
 	}
 
+	pool->dma_addr = dma_map_single(base->dev, pool->base,
+					SZ_1K * base->num_phy_chans,
+					DMA_TO_DEVICE);
+	if (dma_mapping_error(base->dev, pool->dma_addr)) {
+		pool->dma_addr = 0;
+		ret = -ENOMEM;
+		goto failure;
+	}
+
 	writel(virt_to_phys(base->lcla_pool.base),
 	       base->virtbase + D40_DREG_LCLA);
 failure:
@@ -2929,6 +2940,12 @@ failure:
 			kmem_cache_destroy(base->desc_slab);
 		if (base->virtbase)
 			iounmap(base->virtbase);
+
+		if (base->lcla_pool.dma_addr)
+			dma_unmap_single(base->dev, base->lcla_pool.dma_addr,
+					 SZ_1K * base->num_phy_chans,
+					 DMA_TO_DEVICE);
+
 		if (!base->lcla_pool.base_unaligned && base->lcla_pool.base)
 			free_pages((unsigned long)base->lcla_pool.base,
 				   base->lcla_pool.pages);
-- 
1.7.3.2

