Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab0FAMWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:22:18 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:47537 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756301Ab0FAMWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:22:13 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Jonas Aaberg <jonas.aberg@stericsson.com>
Subject: [PATCH 12/18] DMAENGINE: ste_dma40: allocate LCLA dynamically
Date: Tue, 1 Jun 2010 14:22:01 +0200
Message-ID: <1275394921-26633-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to allocating LCLA in memory instead of having a fixed
address.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c    |  246 +++++++++++++++++++++++++++-----------------
 drivers/dma/ste_dma40_ll.c |    5 +-
 drivers/dma/ste_dma40_ll.h |   12 +-
 3 files changed, 161 insertions(+), 102 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 5579401..ec092fa 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -30,6 +30,12 @@
 /* Maximum iterations taken before giving up suspending a channel */
 #define D40_SUSPEND_MAX_IT 500
 
+/* Hardware requirement on LCLA alignment */
+#define LCLA_ALIGNMENT 0x40000
+/* Attempts before giving up to trying to get pages that are aligned */
+#define MAX_LCLA_ALLOC_ATTEMPTS 256
+
+/* Bit markings for allocation map */
 #define D40_ALLOC_FREE		(1 << 31)
 #define D40_ALLOC_PHY		(1 << 30)
 #define D40_ALLOC_LOG_FREE	0
@@ -64,9 +70,9 @@ enum d40_command {
  */
 struct d40_lli_pool {
 	void	*base;
-	int	size;
+	int	 size;
 	/* Space for dst and src, plus an extra for padding */
-	u8	pre_alloc_lli[3 * sizeof(struct d40_phy_lli)];
+	u8	 pre_alloc_lli[3 * sizeof(struct d40_phy_lli)];
 };
 
 /**
@@ -111,18 +117,20 @@ struct d40_desc {
 /**
  * struct d40_lcla_pool - LCLA pool settings and data.
  *
- * @base: The virtual address of LCLA.
- * @phy: Physical base address of LCLA.
- * @base_size: size of lcla.
+ * @base: The virtual address of LCLA. 18 bit aligned.
+ * @base_unaligned: The orignal kmalloc pointer, if kmalloc is used.
+ * This pointer is only there for clean-up on error.
+ * @pages: The number of pages needed for all physical channels.
+ * Only used later for clean-up on error
  * @lock: Lock to protect the content in this struct.
- * @alloc_map: Mapping between physical channel and LCLA entries.
+ * @alloc_map: Bitmap mapping between physical channel and LCLA entries.
  * @num_blocks: The number of entries of alloc_map. Equals to the
  * number of physical channels.
  */
 struct d40_lcla_pool {
 	void		*base;
-	dma_addr_t	 phy;
-	resource_size_t  base_size;
+	void		*base_unaligned;
+	int		 pages;
 	spinlock_t	 lock;
 	u32		*alloc_map;
 	int		 num_blocks;
@@ -432,13 +440,12 @@ static struct d40_desc *d40_first_queued(struct d40_chan *d40c)
 
 /* Support functions for logical channels */
 
-static int d40_lcla_id_get(struct d40_chan *d40c,
-			   struct d40_lcla_pool *pool)
+static int d40_lcla_id_get(struct d40_chan *d40c)
 {
 	int src_id = 0;
 	int dst_id = 0;
 	struct d40_log_lli *lcla_lidx_base =
-		pool->base + d40c->phy_chan->num * 1024;
+		d40c->base->lcla_pool.base + d40c->phy_chan->num * 1024;
 	int i;
 	int lli_per_log = d40c->base->plat_data->llis_per_log;
 	unsigned long flags;
@@ -446,24 +453,28 @@ static int d40_lcla_id_get(struct d40_chan *d40c,
 	if (d40c->lcla.src_id >= 0 && d40c->lcla.dst_id >= 0)
 		return 0;
 
-	if (pool->num_blocks > 32)
+	if (d40c->base->lcla_pool.num_blocks > 32)
 		return -EINVAL;
 
-	spin_lock_irqsave(&pool->lock, flags);
+	spin_lock_irqsave(&d40c->base->lcla_pool.lock, flags);
 
-	for (i = 0; i < pool->num_blocks; i++) {
-		if (!(pool->alloc_map[d40c->phy_chan->num] & (0x1 << i))) {
-			pool->alloc_map[d40c->phy_chan->num] |= (0x1 << i);
+	for (i = 0; i < d40c->base->lcla_pool.num_blocks; i++) {
+		if (!(d40c->base->lcla_pool.alloc_map[d40c->phy_chan->num] &
+		      (0x1 << i))) {
+			d40c->base->lcla_pool.alloc_map[d40c->phy_chan->num] |=
+				(0x1 << i);
 			break;
 		}
 	}
 	src_id = i;
-	if (src_id >= pool->num_blocks)
+	if (src_id >= d40c->base->lcla_pool.num_blocks)
 		goto err;
 
-	for (; i < pool->num_blocks; i++) {
-		if (!(pool->alloc_map[d40c->phy_chan->num] & (0x1 << i))) {
-			pool->alloc_map[d40c->phy_chan->num] |= (0x1 << i);
+	for (; i < d40c->base->lcla_pool.num_blocks; i++) {
+		if (!(d40c->base->lcla_pool.alloc_map[d40c->phy_chan->num] &
+		      (0x1 << i))) {
+			d40c->base->lcla_pool.alloc_map[d40c->phy_chan->num] |=
+				(0x1 << i);
 			break;
 		}
 	}
@@ -477,29 +488,13 @@ static int d40_lcla_id_get(struct d40_chan *d40c,
 	d40c->lcla.dst = lcla_lidx_base + dst_id * lli_per_log + 1;
 	d40c->lcla.src = lcla_lidx_base + src_id * lli_per_log + 1;
 
-
-	spin_unlock_irqrestore(&pool->lock, flags);
+	spin_unlock_irqrestore(&d40c->base->lcla_pool.lock, flags);
 	return 0;
 err:
-	spin_unlock_irqrestore(&pool->lock, flags);
+	spin_unlock_irqrestore(&d40c->base->lcla_pool.lock, flags);
 	return -EINVAL;
 }
 
-static void d40_lcla_id_put(struct d40_chan *d40c,
-			    struct d40_lcla_pool *pool,
-			    int id)
-{
-	unsigned long flags;
-	if (id < 0)
-		return;
-
-	d40c->lcla.src_id = -1;
-	d40c->lcla.dst_id = -1;
-
-	spin_lock_irqsave(&pool->lock, flags);
-	pool->alloc_map[d40c->phy_chan->num] &= (~(0x1 << id));
-	spin_unlock_irqrestore(&pool->lock, flags);
-}
 
 static int d40_channel_execute_command(struct d40_chan *d40c,
 				       enum d40_command command)
@@ -567,6 +562,7 @@ done:
 static void d40_term_all(struct d40_chan *d40c)
 {
 	struct d40_desc *d40d;
+	unsigned long flags;
 
 	/* Release active descriptors */
 	while ((d40d = d40_first_active_get(d40c))) {
@@ -584,10 +580,17 @@ static void d40_term_all(struct d40_chan *d40c)
 		d40_desc_free(d40c, d40d);
 	}
 
-	d40_lcla_id_put(d40c, &d40c->base->lcla_pool,
-			d40c->lcla.src_id);
-	d40_lcla_id_put(d40c, &d40c->base->lcla_pool,
-			d40c->lcla.dst_id);
+	spin_lock_irqsave(&d40c->base->lcla_pool.lock, flags);
+
+	d40c->base->lcla_pool.alloc_map[d40c->phy_chan->num] &=
+		(~(0x1 << d40c->lcla.dst_id));
+	d40c->base->lcla_pool.alloc_map[d40c->phy_chan->num] &=
+		(~(0x1 << d40c->lcla.src_id));
+
+	d40c->lcla.src_id = -1;
+	d40c->lcla.dst_id = -1;
+
+	spin_unlock_irqrestore(&d40c->base->lcla_pool.lock, flags);
 
 	d40c->pending_tx = 0;
 	d40c->busy = false;
@@ -703,7 +706,6 @@ static int d40_config_write(struct d40_chan *d40c)
 
 static void d40_desc_load(struct d40_chan *d40c, struct d40_desc *d40d)
 {
-
 	if (d40d->lli_phy.dst && d40d->lli_phy.src) {
 		d40_phy_lli_write(d40c->base->virtbase,
 				  d40c->phy_chan->num,
@@ -712,13 +714,24 @@ static void d40_desc_load(struct d40_chan *d40c, struct d40_desc *d40d)
 	} else if (d40d->lli_log.dst && d40d->lli_log.src) {
 		struct d40_log_lli *src = d40d->lli_log.src;
 		struct d40_log_lli *dst = d40d->lli_log.dst;
+		int s;
 
 		src += d40d->lli_count;
 		dst += d40d->lli_count;
-		d40_log_lli_write(d40c->lcpa, d40c->lcla.src,
-				  d40c->lcla.dst,
-				  dst, src,
-				  d40c->base->plat_data->llis_per_log);
+		s = d40_log_lli_write(d40c->lcpa,
+				      d40c->lcla.src, d40c->lcla.dst,
+				      dst, src,
+				      d40c->base->plat_data->llis_per_log);
+
+		/* If s equals to zero, the job is not linked */
+		if (s > 0) {
+			(void) dma_map_single(d40c->base->dev, d40c->lcla.src,
+					      s * sizeof(struct d40_log_lli),
+					      DMA_TO_DEVICE);
+			(void) dma_map_single(d40c->base->dev, d40c->lcla.dst,
+					      s * sizeof(struct d40_log_lli),
+					      DMA_TO_DEVICE);
+		}
 	}
 	d40d->lli_count += d40d->lli_tx_len;
 }
@@ -930,7 +943,8 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
 		if (!il[row].is_error)
 			dma_tc_handle(d40c);
 		else
-			dev_err(base->dev, "[%s] IRQ chan: %ld offset %d idx %d\n",
+			dev_err(base->dev,
+				"[%s] IRQ chan: %ld offset %d idx %d\n",
 				__func__, chan, il[row].offset, idx);
 
 		spin_unlock(&d40c->lock);
@@ -1089,7 +1103,8 @@ static int d40_allocate_channel(struct d40_chan *d40c)
 	int j;
 	int log_num;
 	bool is_src;
-	bool is_log = (d40c->dma_cfg.channel_type & STEDMA40_CHANNEL_IN_OPER_MODE)
+	bool is_log = (d40c->dma_cfg.channel_type &
+		       STEDMA40_CHANNEL_IN_OPER_MODE)
 		== STEDMA40_CHANNEL_IN_LOG_MODE;
 
 
@@ -1124,8 +1139,10 @@ static int d40_allocate_channel(struct d40_chan *d40c)
 			for (j = 0; j < d40c->base->num_phy_chans; j += 8) {
 				int phy_num = j  + event_group * 2;
 				for (i = phy_num; i < phy_num + 2; i++) {
-					if (d40_alloc_mask_set(&phys[i], is_src,
-							       0, is_log))
+					if (d40_alloc_mask_set(&phys[i],
+							       is_src,
+							       0,
+							       is_log))
 						goto found_phy;
 				}
 			}
@@ -1426,13 +1443,14 @@ static u32 d40_residue(struct d40_chan *d40c)
 	u32 num_elt;
 
 	if (d40c->log_num != D40_PHY_CHAN)
-		num_elt = (readl(&d40c->lcpa->lcsp2) &  D40_MEM_LCSP2_ECNT_MASK)
+		num_elt = (readl(&d40c->lcpa->lcsp2) & D40_MEM_LCSP2_ECNT_MASK)
 			>> D40_MEM_LCSP2_ECNT_POS;
 	else
 		num_elt = (readl(d40c->base->virtbase + D40_DREG_PCBASE +
 				 d40c->phy_chan->num * D40_DREG_PCDELTA +
 				 D40_CHAN_REG_SDELT) &
-			   D40_SREG_ELEM_PHY_ECNT_MASK) >> D40_SREG_ELEM_PHY_ECNT_POS;
+			   D40_SREG_ELEM_PHY_ECNT_MASK) >>
+			D40_SREG_ELEM_PHY_ECNT_POS;
 	return num_elt * (1 << d40c->dma_cfg.dst_info.data_width);
 }
 
@@ -1485,8 +1503,10 @@ int stedma40_set_psize(struct dma_chan *chan,
 	if (d40c->log_num != D40_PHY_CHAN) {
 		d40c->log_def.lcsp1 &= ~D40_MEM_LCSP1_SCFG_PSIZE_MASK;
 		d40c->log_def.lcsp3 &= ~D40_MEM_LCSP1_SCFG_PSIZE_MASK;
-		d40c->log_def.lcsp1 |= src_psize << D40_MEM_LCSP1_SCFG_PSIZE_POS;
-		d40c->log_def.lcsp3 |= dst_psize << D40_MEM_LCSP1_SCFG_PSIZE_POS;
+		d40c->log_def.lcsp1 |= src_psize <<
+			D40_MEM_LCSP1_SCFG_PSIZE_POS;
+		d40c->log_def.lcsp3 |= dst_psize <<
+			D40_MEM_LCSP1_SCFG_PSIZE_POS;
 		goto out;
 	}
 
@@ -1551,8 +1571,7 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 			 * split list into 1-length and run only in lcpa
 			 * space.
 			 */
-			if (d40_lcla_id_get(d40c,
-					    &d40c->base->lcla_pool) != 0)
+			if (d40_lcla_id_get(d40c) != 0)
 				d40d->lli_tx_len = 1;
 
 		if (d40_pool_lli_alloc(d40d, sgl_len, true) < 0) {
@@ -1855,7 +1874,7 @@ static int d40_prep_slave_sg_log(struct d40_desc *d40d,
 		 * If not, split list into 1-length and run only
 		 * in lcpa space.
 		 */
-		if (d40_lcla_id_get(d40c, &d40c->base->lcla_pool) != 0)
+		if (d40_lcla_id_get(d40c) != 0)
 			d40d->lli_tx_len = 1;
 
 	if (direction == DMA_FROM_DEVICE)
@@ -2482,6 +2501,71 @@ static void __init d40_hw_init(struct d40_base *base)
 
 }
 
+static int __init d40_lcla_allocate(struct d40_base *base)
+{
+	unsigned long *page_list;
+	int i, j;
+	int ret = 0;
+
+	/*
+	 * This is somewhat ugly. We need 8192 bytes that are 18 bit aligned,
+	 * To full fill this hardware requirement without wasting 256 kb
+	 * we allocate pages until we get an aligned one.
+	 */
+	page_list = kmalloc(sizeof(unsigned long) * MAX_LCLA_ALLOC_ATTEMPTS,
+			    GFP_KERNEL);
+
+	if (!page_list) {
+		ret = -ENOMEM;
+		goto failure;
+	}
+
+	/* Calculating how many pages that are required */
+	base->lcla_pool.pages = SZ_1K * (base->num_phy_chans + PAGE_SIZE /
+					 SZ_1K - 1) / PAGE_SIZE + 3;
+
+	for (i = 0; i < MAX_LCLA_ALLOC_ATTEMPTS; i++) {
+		page_list[i] = __get_free_pages(GFP_KERNEL,
+						base->lcla_pool.pages);
+
+		if ((virt_to_phys((void *)page_list[i]) &
+		     (LCLA_ALIGNMENT - 1)) == 0 && page_list[i] != 0)
+			break;
+	}
+
+	for (j = 0; j < i; j++) {
+		if (page_list[i] != 0)
+			free_pages(page_list[j], base->lcla_pool.pages);
+	}
+
+	if (i < MAX_LCLA_ALLOC_ATTEMPTS) {
+		base->lcla_pool.base = (void *)page_list[i];
+	} else {
+		/* After many attempts, no succees with finding the correct
+		 * alignment try with allocating a big buffer */
+		dev_warn(base->dev,
+			 "[%s] Failed to get %d pages @ 18 bit align.\n",
+			 __func__, base->lcla_pool.pages);
+		base->lcla_pool.base_unaligned = kmalloc(SZ_1K *
+							 base->num_phy_chans +
+							 LCLA_ALIGNMENT,
+							 GFP_KERNEL);
+		if (!base->lcla_pool.base_unaligned) {
+			ret = -ENOMEM;
+			goto failure;
+		}
+
+		base->lcla_pool.base = PTR_ALIGN(base->lcla_pool.base_unaligned,
+						 LCLA_ALIGNMENT);
+	}
+
+	writel(virt_to_phys(base->lcla_pool.base),
+	       base->virtbase + D40_DREG_LCLA);
+failure:
+	kfree(page_list);
+	return ret;
+}
+
 static int __init d40_probe(struct platform_device *pdev)
 {
 	int err;
@@ -2541,41 +2625,11 @@ static int __init d40_probe(struct platform_device *pdev)
 			__func__);
 		goto failure;
 	}
-	/* Get IO for logical channel link address */
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "lcla");
-	if (!res) {
-		ret = -ENOENT;
-		dev_err(&pdev->dev,
-			"[%s] No \"lcla\" resource defined\n",
-			__func__);
-		goto failure;
-	}
 
-	base->lcla_pool.base_size = resource_size(res);
-	base->lcla_pool.phy = res->start;
-
-	if (request_mem_region(res->start, resource_size(res),
-			       D40_NAME " I/O lcla") == NULL) {
-		ret = -EBUSY;
-		dev_err(&pdev->dev,
-			"[%s] Failed to request LCLA region 0x%x-0x%x\n",
-			__func__, res->start, res->end);
-		goto failure;
-	}
-	val = readl(base->virtbase + D40_DREG_LCLA);
-	if (res->start != val && val != 0) {
-		dev_warn(&pdev->dev,
-			 "[%s] Mismatch LCLA dma 0x%x, def 0x%x\n",
-			 __func__, val, res->start);
-	} else
-		writel(res->start, base->virtbase + D40_DREG_LCLA);
-
-	base->lcla_pool.base = ioremap(res->start, resource_size(res));
-	if (!base->lcla_pool.base) {
-		ret = -ENOMEM;
-		dev_err(&pdev->dev,
-			"[%s] Failed to ioremap LCLA 0x%x-0x%x\n",
-			__func__, res->start, res->end);
+	ret = d40_lcla_allocate(base);
+	if (ret) {
+		dev_err(&pdev->dev, "[%s] Failed to allocate LCLA area\n",
+			__func__);
 		goto failure;
 	}
 
@@ -2607,9 +2661,11 @@ failure:
 			kmem_cache_destroy(base->desc_slab);
 		if (base->virtbase)
 			iounmap(base->virtbase);
-		if (base->lcla_pool.phy)
-			release_mem_region(base->lcla_pool.phy,
-					   base->lcla_pool.base_size);
+		if (!base->lcla_pool.base_unaligned && base->lcla_pool.base)
+			free_pages((unsigned long)base->lcla_pool.base,
+				   base->lcla_pool.pages);
+		if (base->lcla_pool.base_unaligned)
+			kfree(base->lcla_pool.base_unaligned);
 		if (base->phy_lcpa)
 			release_mem_region(base->phy_lcpa,
 					   base->lcpa_size);
diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
index 772636b..d937f76 100644
--- a/drivers/dma/ste_dma40_ll.c
+++ b/drivers/dma/ste_dma40_ll.c
@@ -420,7 +420,7 @@ int d40_log_sg_to_lli(int lcla_id,
 	return total_size;
 }
 
-void d40_log_lli_write(struct d40_log_lli_full *lcpa,
+int d40_log_lli_write(struct d40_log_lli_full *lcpa,
 		       struct d40_log_lli *lcla_src,
 		       struct d40_log_lli *lcla_dst,
 		       struct d40_log_lli *lli_dst,
@@ -448,4 +448,7 @@ void d40_log_lli_write(struct d40_log_lli_full *lcpa,
 		slos = lli_src[i + 1].lcsp13 & D40_MEM_LCSP1_SLOS_MASK;
 		dlos = lli_dst[i + 1].lcsp13 & D40_MEM_LCSP3_DLOS_MASK;
 	}
+
+	return i;
+
 }
diff --git a/drivers/dma/ste_dma40_ll.h b/drivers/dma/ste_dma40_ll.h
index 2029280..d745e40 100644
--- a/drivers/dma/ste_dma40_ll.h
+++ b/drivers/dma/ste_dma40_ll.h
@@ -336,12 +336,12 @@ int d40_log_sg_to_dev(struct d40_lcla_elem *lcla,
 		      bool term_int, dma_addr_t dev_addr, int max_len,
 		      int llis_per_log);
 
-void d40_log_lli_write(struct d40_log_lli_full *lcpa,
-		       struct d40_log_lli *lcla_src,
-		       struct d40_log_lli *lcla_dst,
-		       struct d40_log_lli *lli_dst,
-		       struct d40_log_lli *lli_src,
-		       int llis_per_log);
+int d40_log_lli_write(struct d40_log_lli_full *lcpa,
+		      struct d40_log_lli *lcla_src,
+		      struct d40_log_lli *lcla_dst,
+		      struct d40_log_lli *lli_dst,
+		      struct d40_log_lli *lli_src,
+		      int llis_per_log);
 
 int d40_log_sg_to_lli(int lcla_id,
 		      struct scatterlist *sg,
-- 
1.6.3.3

