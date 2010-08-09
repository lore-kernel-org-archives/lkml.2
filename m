Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab0HIMJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 08:09:14 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:47936 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756398Ab0HIMJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 08:09:04 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Jonas Aaberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 11/14] DMAENGINE: ste_dma40: rewrote LCLA entries allocation code
Date: Mon, 9 Aug 2010 14:08:56 +0200
Message-ID: <1281355736-13515-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

LLI allocation is now done on job level instead of channel level.
Previously the maximum length of a linked job in hw on a logical
channel was 8, since the LLIs where evenly divided. Now only
executing jobs have allocated LLIs which increase the length to
a maximum of 64 links in HW.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c    |  315 +++++++++++++++++++++-----------------------
 drivers/dma/ste_dma40_ll.c |  161 ++++++++---------------
 drivers/dma/ste_dma40_ll.h |   51 ++-----
 3 files changed, 218 insertions(+), 309 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index ac325e9..c9f485e 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -11,6 +11,7 @@
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/err.h>
 
 #include <plat/ste_dma40.h>
 
@@ -29,6 +30,11 @@
 
 /* Hardware requirement on LCLA alignment */
 #define LCLA_ALIGNMENT 0x40000
+
+/* Max number of links per event group */
+#define D40_LCLA_LINK_PER_EVENT_GRP 128
+#define D40_LCLA_END D40_LCLA_LINK_PER_EVENT_GRP
+
 /* Attempts before giving up to trying to get pages that are aligned */
 #define MAX_LCLA_ALLOC_ATTEMPTS 256
 
@@ -81,9 +87,8 @@ struct d40_lli_pool {
  * @lli_log: Same as above but for logical channels.
  * @lli_pool: The pool with two entries pre-allocated.
  * @lli_len: Number of llis of current descriptor.
- * @lli_count: Number of transfered llis.
- * @lli_tx_len: Max number of LLIs per transfer, there can be
- * many transfer for one descriptor.
+ * @lli_current: Number of transfered llis.
+ * @lcla_alloc: Number of LCLA entries allocated.
  * @txd: DMA engine struct. Used for among other things for communication
  * during a transfer.
  * @node: List entry.
@@ -93,7 +98,6 @@ struct d40_lli_pool {
  *
  * This descriptor is used for both logical and physical transfers.
  */
-
 struct d40_desc {
 	/* LLI physical */
 	struct d40_phy_lli_bidir	 lli_phy;
@@ -102,8 +106,8 @@ struct d40_desc {
 
 	struct d40_lli_pool		 lli_pool;
 	int				 lli_len;
-	int				 lli_count;
-	u32				 lli_tx_len;
+	int				 lli_current;
+	int				 lcla_alloc;
 
 	struct dma_async_tx_descriptor	 txd;
 	struct list_head		 node;
@@ -121,17 +125,14 @@ struct d40_desc {
  * @pages: The number of pages needed for all physical channels.
  * Only used later for clean-up on error
  * @lock: Lock to protect the content in this struct.
- * @alloc_map: Bitmap mapping between physical channel and LCLA entries.
- * @num_blocks: The number of entries of alloc_map. Equals to the
- * number of physical channels.
+ * @alloc_map: big map over which LCLA entry is own by which job.
  */
 struct d40_lcla_pool {
 	void		*base;
 	void		*base_unaligned;
 	int		 pages;
 	spinlock_t	 lock;
-	u32		*alloc_map;
-	int		 num_blocks;
+	struct d40_desc	**alloc_map;
 };
 
 /**
@@ -202,7 +203,6 @@ struct d40_chan {
 	u32				 src_def_cfg;
 	u32				 dst_def_cfg;
 	struct d40_def_lcsp		 log_def;
-	struct d40_lcla_elem		 lcla;
 	struct d40_log_lli_full		*lcpa;
 	/* Runtime reconfiguration */
 	dma_addr_t			runtime_addr;
@@ -351,6 +351,67 @@ static void d40_pool_lli_free(struct d40_desc *d40d)
 	d40d->lli_phy.dst = NULL;
 }
 
+static int d40_lcla_alloc_one(struct d40_chan *d40c,
+			      struct d40_desc *d40d)
+{
+	unsigned long flags;
+	int i;
+	int ret = -EINVAL;
+	int p;
+
+	spin_lock_irqsave(&d40c->base->lcla_pool.lock, flags);
+
+	p = d40c->phy_chan->num * D40_LCLA_LINK_PER_EVENT_GRP;
+
+	/*
+	 * Allocate both src and dst at the same time, therefore the half
+	 * start on 1 since 0 can't be used since zero is used as end marker.
+	 */
+	for (i = 1 ; i < D40_LCLA_LINK_PER_EVENT_GRP / 2; i++) {
+		if (!d40c->base->lcla_pool.alloc_map[p + i]) {
+			d40c->base->lcla_pool.alloc_map[p + i] = d40d;
+			d40d->lcla_alloc++;
+			ret = i;
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(&d40c->base->lcla_pool.lock, flags);
+
+	return ret;
+}
+
+static int d40_lcla_free_all(struct d40_chan *d40c,
+			     struct d40_desc *d40d)
+{
+	unsigned long flags;
+	int i;
+	int ret = -EINVAL;
+
+	if (d40c->log_num == D40_PHY_CHAN)
+		return 0;
+
+	spin_lock_irqsave(&d40c->base->lcla_pool.lock, flags);
+
+	for (i = 1 ; i < D40_LCLA_LINK_PER_EVENT_GRP / 2; i++) {
+		if (d40c->base->lcla_pool.alloc_map[d40c->phy_chan->num *
+						    D40_LCLA_LINK_PER_EVENT_GRP + i] == d40d) {
+			d40c->base->lcla_pool.alloc_map[d40c->phy_chan->num *
+							D40_LCLA_LINK_PER_EVENT_GRP + i] = NULL;
+			d40d->lcla_alloc--;
+			if (d40d->lcla_alloc == 0) {
+				ret = 0;
+				break;
+			}
+		}
+	}
+
+	spin_unlock_irqrestore(&d40c->base->lcla_pool.lock, flags);
+
+	return ret;
+
+}
+
 static void d40_desc_remove(struct d40_desc *d40d)
 {
 	list_del(&d40d->node);
@@ -380,6 +441,8 @@ static struct d40_desc *d40_desc_get(struct d40_chan *d40c)
 
 static void d40_desc_free(struct d40_chan *d40c, struct d40_desc *d40d)
 {
+
+	d40_lcla_free_all(d40c, d40d);
 	kmem_cache_free(d40c->base->desc_slab, d40d);
 }
 
@@ -388,6 +451,59 @@ static void d40_desc_submit(struct d40_chan *d40c, struct d40_desc *desc)
 	list_add_tail(&desc->node, &d40c->active);
 }
 
+static void d40_desc_load(struct d40_chan *d40c, struct d40_desc *d40d)
+{
+	int curr_lcla = -EINVAL, next_lcla;
+
+	if (d40c->log_num == D40_PHY_CHAN) {
+		d40_phy_lli_write(d40c->base->virtbase,
+				  d40c->phy_chan->num,
+				  d40d->lli_phy.dst,
+				  d40d->lli_phy.src);
+		d40d->lli_current = d40d->lli_len;
+	} else {
+
+		if ((d40d->lli_len - d40d->lli_current) > 1)
+			curr_lcla = d40_lcla_alloc_one(d40c, d40d);
+
+		d40_log_lli_lcpa_write(d40c->lcpa,
+				       &d40d->lli_log.dst[d40d->lli_current],
+				       &d40d->lli_log.src[d40d->lli_current],
+				       curr_lcla);
+
+		d40d->lli_current++;
+		for (; d40d->lli_current < d40d->lli_len; d40d->lli_current++) {
+			struct d40_log_lli *lcla;
+
+			if (d40d->lli_current + 1 < d40d->lli_len)
+				next_lcla = d40_lcla_alloc_one(d40c, d40d);
+			else
+				next_lcla = -EINVAL;
+
+			lcla = d40c->base->lcla_pool.base +
+				d40c->phy_chan->num * 1024 +
+				8 * curr_lcla * 2;
+
+			d40_log_lli_lcla_write(lcla,
+					       &d40d->lli_log.dst[d40d->lli_current],
+					       &d40d->lli_log.src[d40d->lli_current],
+					       next_lcla);
+
+			(void) dma_map_single(d40c->base->dev, lcla,
+					      2 * sizeof(struct d40_log_lli),
+					      DMA_TO_DEVICE);
+
+			curr_lcla = next_lcla;
+
+			if (curr_lcla == -EINVAL) {
+				d40d->lli_current++;
+				break;
+			}
+
+		}
+	}
+}
+
 static struct d40_desc *d40_first_active_get(struct d40_chan *d40c)
 {
 	struct d40_desc *d;
@@ -433,61 +549,6 @@ static struct d40_desc *d40_last_queued(struct d40_chan *d40c)
 
 /* Support functions for logical channels */
 
-static int d40_lcla_id_get(struct d40_chan *d40c)
-{
-	int src_id = 0;
-	int dst_id = 0;
-	struct d40_log_lli *lcla_lidx_base =
-		d40c->base->lcla_pool.base + d40c->phy_chan->num * 1024;
-	int i;
-	int lli_per_log = d40c->base->plat_data->llis_per_log;
-	unsigned long flags;
-
-	if (d40c->lcla.src_id >= 0 && d40c->lcla.dst_id >= 0)
-		return 0;
-
-	if (d40c->base->lcla_pool.num_blocks > 32)
-		return -EINVAL;
-
-	spin_lock_irqsave(&d40c->base->lcla_pool.lock, flags);
-
-	for (i = 0; i < d40c->base->lcla_pool.num_blocks; i++) {
-		if (!(d40c->base->lcla_pool.alloc_map[d40c->phy_chan->num] &
-		      (0x1 << i))) {
-			d40c->base->lcla_pool.alloc_map[d40c->phy_chan->num] |=
-				(0x1 << i);
-			break;
-		}
-	}
-	src_id = i;
-	if (src_id >= d40c->base->lcla_pool.num_blocks)
-		goto err;
-
-	for (; i < d40c->base->lcla_pool.num_blocks; i++) {
-		if (!(d40c->base->lcla_pool.alloc_map[d40c->phy_chan->num] &
-		      (0x1 << i))) {
-			d40c->base->lcla_pool.alloc_map[d40c->phy_chan->num] |=
-				(0x1 << i);
-			break;
-		}
-	}
-
-	dst_id = i;
-	if (dst_id == src_id)
-		goto err;
-
-	d40c->lcla.src_id = src_id;
-	d40c->lcla.dst_id = dst_id;
-	d40c->lcla.dst = lcla_lidx_base + dst_id * lli_per_log + 1;
-	d40c->lcla.src = lcla_lidx_base + src_id * lli_per_log + 1;
-
-	spin_unlock_irqrestore(&d40c->base->lcla_pool.lock, flags);
-	return 0;
-err:
-	spin_unlock_irqrestore(&d40c->base->lcla_pool.lock, flags);
-	return -EINVAL;
-}
-
 
 static int d40_channel_execute_command(struct d40_chan *d40c,
 				       enum d40_command command)
@@ -556,7 +617,6 @@ done:
 static void d40_term_all(struct d40_chan *d40c)
 {
 	struct d40_desc *d40d;
-	unsigned long flags;
 
 	/* Release active descriptors */
 	while ((d40d = d40_first_active_get(d40c))) {
@@ -570,17 +630,6 @@ static void d40_term_all(struct d40_chan *d40c)
 		d40_desc_free(d40c, d40d);
 	}
 
-	spin_lock_irqsave(&d40c->base->lcla_pool.lock, flags);
-
-	d40c->base->lcla_pool.alloc_map[d40c->phy_chan->num] &=
-		(~(0x1 << d40c->lcla.dst_id));
-	d40c->base->lcla_pool.alloc_map[d40c->phy_chan->num] &=
-		(~(0x1 << d40c->lcla.src_id));
-
-	d40c->lcla.src_id = -1;
-	d40c->lcla.dst_id = -1;
-
-	spin_unlock_irqrestore(&d40c->base->lcla_pool.lock, flags);
 
 	d40c->pending_tx = 0;
 	d40c->busy = false;
@@ -682,38 +731,6 @@ static void d40_config_write(struct d40_chan *d40c)
 	}
 }
 
-static void d40_desc_load(struct d40_chan *d40c, struct d40_desc *d40d)
-{
-	if (d40c->log_num == D40_PHY_CHAN) {
-		d40_phy_lli_write(d40c->base->virtbase,
-				  d40c->phy_chan->num,
-				  d40d->lli_phy.dst,
-				  d40d->lli_phy.src);
-	} else {
-		struct d40_log_lli *src = d40d->lli_log.src;
-		struct d40_log_lli *dst = d40d->lli_log.dst;
-		int s;
-
-		src += d40d->lli_count;
-		dst += d40d->lli_count;
-		s = d40_log_lli_write(d40c->lcpa,
-				      d40c->lcla.src, d40c->lcla.dst,
-				      dst, src,
-				      d40c->base->plat_data->llis_per_log);
-
-		/* If s equals to zero, the job is not linked */
-		if (s > 0) {
-			(void) dma_map_single(d40c->base->dev, d40c->lcla.src,
-					      s * sizeof(struct d40_log_lli),
-					      DMA_TO_DEVICE);
-			(void) dma_map_single(d40c->base->dev, d40c->lcla.dst,
-					      s * sizeof(struct d40_log_lli),
-					      DMA_TO_DEVICE);
-		}
-	}
-	d40d->lli_count += d40d->lli_tx_len;
-}
-
 static u32 d40_residue(struct d40_chan *d40c)
 {
 	u32 num_elt;
@@ -942,6 +959,7 @@ static struct d40_desc *d40_queue_start(struct d40_chan *d40c)
 		 * If this job is already linked in hw,
 		 * do not submit it.
 		 */
+
 		if (!d40d->is_hw_linked) {
 			/* Initiate DMA job */
 			d40_desc_load(d40c, d40d);
@@ -968,8 +986,9 @@ static void dma_tc_handle(struct d40_chan *d40c)
 	if (d40d == NULL)
 		return;
 
-	if (d40d->lli_count < d40d->lli_len) {
+	d40_lcla_free_all(d40c, d40d);
 
+	if (d40d->lli_current < d40d->lli_len) {
 		d40_desc_load(d40c, d40d);
 		/* Start dma job */
 		(void) d40_start(d40c);
@@ -1022,6 +1041,7 @@ static void dma_tasklet(unsigned long data)
 	} else {
 		if (!d40d->is_in_client_list) {
 			d40_desc_remove(d40d);
+			d40_lcla_free_all(d40c, d40d);
 			list_add_tail(&d40d->node, &d40c->client);
 			d40d->is_in_client_list = true;
 		}
@@ -1247,7 +1267,6 @@ static bool d40_alloc_mask_free(struct d40_phy_res *phy, bool is_src,
 
 	spin_lock_irqsave(&phy->lock, flags);
 	if (!log_event_line) {
-		/* Physical interrupts are masked per physical full channel */
 		phy->allocated_dst = D40_ALLOC_FREE;
 		phy->allocated_src = D40_ALLOC_FREE;
 		is_free = true;
@@ -1633,21 +1652,10 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 		goto err;
 
 	d40d->lli_len = sgl_len;
-	d40d->lli_tx_len = d40d->lli_len;
+	d40d->lli_current = 0;
 	d40d->txd.flags = dma_flags;
 
 	if (d40c->log_num != D40_PHY_CHAN) {
-		if (d40d->lli_len > d40c->base->plat_data->llis_per_log)
-			d40d->lli_tx_len = d40c->base->plat_data->llis_per_log;
-
-		if (sgl_len > 1)
-			/*
-			 * Check if there is space available in lcla. If not,
-			 * split list into 1-length and run only in lcpa
-			 * space.
-			 */
-			if (d40_lcla_id_get(d40c) != 0)
-				d40d->lli_tx_len = 1;
 
 		if (d40_pool_lli_alloc(d40d, sgl_len, true) < 0) {
 			dev_err(&d40c->chan.dev->device,
@@ -1655,25 +1663,17 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 			goto err;
 		}
 
-		(void) d40_log_sg_to_lli(d40c->lcla.src_id,
-					 sgl_src,
+		(void) d40_log_sg_to_lli(sgl_src,
 					 sgl_len,
 					 d40d->lli_log.src,
 					 d40c->log_def.lcsp1,
-					 d40c->dma_cfg.src_info.data_width,
-					 d40d->lli_tx_len,
-					 d40c->base->plat_data->llis_per_log);
+					 d40c->dma_cfg.src_info.data_width);
 
-		(void) d40_log_sg_to_lli(d40c->lcla.dst_id,
-					 sgl_dst,
+		(void) d40_log_sg_to_lli(sgl_dst,
 					 sgl_len,
 					 d40d->lli_log.dst,
 					 d40c->log_def.lcsp3,
-					 d40c->dma_cfg.dst_info.data_width,
-					 d40d->lli_tx_len,
-					 d40c->base->plat_data->llis_per_log);
-
-
+					 d40c->dma_cfg.dst_info.data_width);
 	} else {
 		if (d40_pool_lli_alloc(d40d, sgl_len, false) < 0) {
 			dev_err(&d40c->chan.dev->device,
@@ -1869,23 +1869,21 @@ static struct dma_async_tx_descriptor *d40_prep_memcpy(struct dma_chan *chan,
 			goto err;
 		}
 		d40d->lli_len = 1;
-		d40d->lli_tx_len = 1;
+		d40d->lli_current = 0;
 
 		d40_log_fill_lli(d40d->lli_log.src,
 				 src,
 				 size,
-				 0,
 				 d40c->log_def.lcsp1,
 				 d40c->dma_cfg.src_info.data_width,
-				 false, true);
+				 true);
 
 		d40_log_fill_lli(d40d->lli_log.dst,
 				 dst,
 				 size,
-				 0,
 				 d40c->log_def.lcsp3,
 				 d40c->dma_cfg.dst_info.data_width,
-				 true, true);
+				 true);
 
 	} else {
 
@@ -1953,19 +1951,7 @@ static int d40_prep_slave_sg_log(struct d40_desc *d40d,
 	}
 
 	d40d->lli_len = sg_len;
-	if (d40d->lli_len <= d40c->base->plat_data->llis_per_log)
-		d40d->lli_tx_len = d40d->lli_len;
-	else
-		d40d->lli_tx_len = d40c->base->plat_data->llis_per_log;
-
-	if (sg_len > 1)
-		/*
-		 * Check if there is space available in lcla.
-		 * If not, split list into 1-length and run only
-		 * in lcpa space.
-		 */
-		if (d40_lcla_id_get(d40c) != 0)
-			d40d->lli_tx_len = 1;
+	d40d->lli_current = 0;
 
 	if (direction == DMA_FROM_DEVICE)
 		if (d40c->runtime_addr)
@@ -1981,15 +1967,13 @@ static int d40_prep_slave_sg_log(struct d40_desc *d40d,
 	else
 		return -EINVAL;
 
-	total_size = d40_log_sg_to_dev(&d40c->lcla,
-				       sgl, sg_len,
+	total_size = d40_log_sg_to_dev(sgl, sg_len,
 				       &d40d->lli_log,
 				       &d40c->log_def,
 				       d40c->dma_cfg.src_info.data_width,
 				       d40c->dma_cfg.dst_info.data_width,
 				       direction,
-				       dev_addr, d40d->lli_tx_len,
-				       d40c->base->plat_data->llis_per_log);
+				       dev_addr);
 
 	if (total_size < 0)
 		return -EINVAL;
@@ -2015,7 +1999,7 @@ static int d40_prep_slave_sg_phy(struct d40_desc *d40d,
 	}
 
 	d40d->lli_len = sgl_len;
-	d40d->lli_tx_len = sgl_len;
+	d40d->lli_current = 0;
 
 	if (direction == DMA_FROM_DEVICE) {
 		dst_dev_addr = 0;
@@ -2323,10 +2307,6 @@ static void __init d40_chan_init(struct d40_base *base, struct dma_device *dma,
 		d40c->base = base;
 		d40c->chan.device = dma;
 
-		/* Invalidate lcla element */
-		d40c->lcla.src_id = -1;
-		d40c->lcla.dst_id = -1;
-
 		spin_lock_init(&d40c->lock);
 
 		d40c->log_num = D40_PHY_CHAN;
@@ -2631,7 +2611,10 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 		if (!base->lookup_log_chans)
 			goto failure;
 	}
-	base->lcla_pool.alloc_map = kzalloc(num_phy_chans * sizeof(u32),
+
+	base->lcla_pool.alloc_map = kzalloc(num_phy_chans *
+					    sizeof(struct d40_desc *) *
+					    D40_LCLA_LINK_PER_EVENT_GRP,
 					    GFP_KERNEL);
 	if (!base->lcla_pool.alloc_map)
 		goto failure;
@@ -2878,8 +2861,6 @@ static int __init d40_probe(struct platform_device *pdev)
 
 	spin_lock_init(&base->lcla_pool.lock);
 
-	base->lcla_pool.num_blocks = base->num_phy_chans;
-
 	base->irq = platform_get_irq(pdev, 0);
 
 	ret = request_irq(base->irq, d40_handle_interrupt, 0, D40_NAME, base);
diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
index 92a0960..86a306d 100644
--- a/drivers/dma/ste_dma40_ll.c
+++ b/drivers/dma/ste_dma40_ll.c
@@ -37,16 +37,13 @@ void d40_log_cfg(struct stedma40_chan_cfg *cfg,
 	    cfg->dir ==  STEDMA40_PERIPH_TO_PERIPH)
 		l3 |= 1 << D40_MEM_LCSP3_DCFG_MST_POS;
 
-	l3 |= 1 << D40_MEM_LCSP3_DCFG_TIM_POS;
 	l3 |= 1 << D40_MEM_LCSP3_DCFG_EIM_POS;
 	l3 |= cfg->dst_info.psize << D40_MEM_LCSP3_DCFG_PSIZE_POS;
 	l3 |= cfg->dst_info.data_width << D40_MEM_LCSP3_DCFG_ESIZE_POS;
-	l3 |= 1 << D40_MEM_LCSP3_DTCP_POS;
 
 	l1 |= 1 << D40_MEM_LCSP1_SCFG_EIM_POS;
 	l1 |= cfg->src_info.psize << D40_MEM_LCSP1_SCFG_PSIZE_POS;
 	l1 |= cfg->src_info.data_width << D40_MEM_LCSP1_SCFG_ESIZE_POS;
-	l1 |= 1 << D40_MEM_LCSP1_STCP_POS;
 
 	*lcsp1 = l1;
 	*lcsp3 = l3;
@@ -235,7 +232,7 @@ int d40_phy_sg_to_lli(struct scatterlist *sg,
 	}
 
 	return total_size;
- err:
+err:
 	return err;
 }
 
@@ -268,11 +265,59 @@ void d40_phy_lli_write(void __iomem *virtbase,
 
 /* DMA logical lli operations */
 
+static void d40_log_lli_link(struct d40_log_lli *lli_dst,
+			     struct d40_log_lli *lli_src,
+			     int next)
+{
+	u32 slos = 0;
+	u32 dlos = 0;
+
+	if (next != -EINVAL) {
+		slos = next * 2;
+		dlos = next * 2 + 1;
+	} else {
+		lli_dst->lcsp13 |= D40_MEM_LCSP1_SCFG_TIM_MASK;
+		lli_dst->lcsp13 |= D40_MEM_LCSP3_DTCP_MASK;
+	}
+
+	lli_src->lcsp13 = (lli_src->lcsp13 & ~D40_MEM_LCSP1_SLOS_MASK) |
+		(slos << D40_MEM_LCSP1_SLOS_POS);
+
+	lli_dst->lcsp13 = (lli_dst->lcsp13 & ~D40_MEM_LCSP1_SLOS_MASK) |
+		(dlos << D40_MEM_LCSP1_SLOS_POS);
+}
+
+void d40_log_lli_lcpa_write(struct d40_log_lli_full *lcpa,
+			   struct d40_log_lli *lli_dst,
+			   struct d40_log_lli *lli_src,
+			   int next)
+{
+	d40_log_lli_link(lli_dst, lli_src, next);
+
+	writel(lli_src->lcsp02, &lcpa[0].lcsp0);
+	writel(lli_src->lcsp13, &lcpa[0].lcsp1);
+	writel(lli_dst->lcsp02, &lcpa[0].lcsp2);
+	writel(lli_dst->lcsp13, &lcpa[0].lcsp3);
+}
+
+void d40_log_lli_lcla_write(struct d40_log_lli *lcla,
+			   struct d40_log_lli *lli_dst,
+			   struct d40_log_lli *lli_src,
+			   int next)
+{
+	d40_log_lli_link(lli_dst, lli_src, next);
+
+	writel(lli_src->lcsp02, &lcla[0].lcsp02);
+	writel(lli_src->lcsp13, &lcla[0].lcsp13);
+	writel(lli_dst->lcsp02, &lcla[1].lcsp02);
+	writel(lli_dst->lcsp13, &lcla[1].lcsp13);
+}
+
 void d40_log_fill_lli(struct d40_log_lli *lli,
 		      dma_addr_t data, u32 data_size,
-		      u32 lli_next_off, u32 reg_cfg,
+		      u32 reg_cfg,
 		      u32 data_width,
-		      bool term_int, bool addr_inc)
+		      bool addr_inc)
 {
 	lli->lcsp13 = reg_cfg;
 
@@ -287,165 +332,69 @@ void d40_log_fill_lli(struct d40_log_lli *lli,
 	if (addr_inc)
 		lli->lcsp13 |= D40_MEM_LCSP1_SCFG_INCR_MASK;
 
-	lli->lcsp13 |= D40_MEM_LCSP3_DTCP_MASK;
-	/* If this scatter list entry is the last one, no next link */
-	lli->lcsp13 |= (lli_next_off << D40_MEM_LCSP1_SLOS_POS) &
-		D40_MEM_LCSP1_SLOS_MASK;
-
-	if (term_int)
-		lli->lcsp13 |= D40_MEM_LCSP1_SCFG_TIM_MASK;
-	else
-		lli->lcsp13 &= ~D40_MEM_LCSP1_SCFG_TIM_MASK;
 }
 
-int d40_log_sg_to_dev(struct d40_lcla_elem *lcla,
-		      struct scatterlist *sg,
+int d40_log_sg_to_dev(struct scatterlist *sg,
 		      int sg_len,
 		      struct d40_log_lli_bidir *lli,
 		      struct d40_def_lcsp *lcsp,
 		      u32 src_data_width,
 		      u32 dst_data_width,
 		      enum dma_data_direction direction,
-		      dma_addr_t dev_addr, int max_len,
-		      int llis_per_log)
+		      dma_addr_t dev_addr)
 {
 	int total_size = 0;
 	struct scatterlist *current_sg = sg;
 	int i;
-	u32 next_lli_off_dst = 0;
-	u32 next_lli_off_src = 0;
 
 	for_each_sg(sg, current_sg, sg_len, i) {
 		total_size += sg_dma_len(current_sg);
 
-		/*
-		 * If this scatter list entry is the last one or
-		 * max length, terminate link.
-		 */
-		if (sg_len - 1 == i || ((i+1) % max_len == 0)) {
-			next_lli_off_src = 0;
-			next_lli_off_dst = 0;
-		} else {
-			if (next_lli_off_dst == 0 &&
-			    next_lli_off_src == 0) {
-				/* The first lli will be at next_lli_off */
-				next_lli_off_dst = (lcla->dst_id *
-						    llis_per_log + 1);
-				next_lli_off_src = (lcla->src_id *
-						    llis_per_log + 1);
-			} else {
-				next_lli_off_dst++;
-				next_lli_off_src++;
-			}
-		}
-
 		if (direction == DMA_TO_DEVICE) {
 			d40_log_fill_lli(&lli->src[i],
 					 sg_phys(current_sg),
 					 sg_dma_len(current_sg),
-					 next_lli_off_src,
 					 lcsp->lcsp1, src_data_width,
-					 false,
 					 true);
 			d40_log_fill_lli(&lli->dst[i],
 					 dev_addr,
 					 sg_dma_len(current_sg),
-					 next_lli_off_dst,
 					 lcsp->lcsp3, dst_data_width,
-					 /* No next == terminal interrupt */
-					 !next_lli_off_dst,
 					 false);
 		} else {
 			d40_log_fill_lli(&lli->dst[i],
 					 sg_phys(current_sg),
 					 sg_dma_len(current_sg),
-					 next_lli_off_dst,
 					 lcsp->lcsp3, dst_data_width,
-					 /* No next == terminal interrupt */
-					 !next_lli_off_dst,
 					 true);
 			d40_log_fill_lli(&lli->src[i],
 					 dev_addr,
 					 sg_dma_len(current_sg),
-					 next_lli_off_src,
 					 lcsp->lcsp1, src_data_width,
-					 false,
 					 false);
 		}
 	}
 	return total_size;
 }
 
-int d40_log_sg_to_lli(int lcla_id,
-		      struct scatterlist *sg,
+int d40_log_sg_to_lli(struct scatterlist *sg,
 		      int sg_len,
 		      struct d40_log_lli *lli_sg,
 		      u32 lcsp13, /* src or dst*/
-		      u32 data_width,
-		      int max_len, int llis_per_log)
+		      u32 data_width)
 {
 	int total_size = 0;
 	struct scatterlist *current_sg = sg;
 	int i;
-	u32 next_lli_off = 0;
 
 	for_each_sg(sg, current_sg, sg_len, i) {
 		total_size += sg_dma_len(current_sg);
 
-		/*
-		 * If this scatter list entry is the last one or
-		 * max length, terminate link.
-		 */
-		if (sg_len - 1 == i || ((i+1) % max_len == 0))
-			next_lli_off = 0;
-		else {
-			if (next_lli_off == 0)
-				/* The first lli will be at next_lli_off */
-				next_lli_off = lcla_id * llis_per_log + 1;
-			else
-				next_lli_off++;
-		}
-
 		d40_log_fill_lli(&lli_sg[i],
 				 sg_phys(current_sg),
 				 sg_dma_len(current_sg),
-				 next_lli_off,
 				 lcsp13, data_width,
-				 !next_lli_off,
 				 true);
 	}
 	return total_size;
 }
-
-int d40_log_lli_write(struct d40_log_lli_full *lcpa,
-		       struct d40_log_lli *lcla_src,
-		       struct d40_log_lli *lcla_dst,
-		       struct d40_log_lli *lli_dst,
-		       struct d40_log_lli *lli_src,
-		       int llis_per_log)
-{
-	u32 slos;
-	u32 dlos;
-	int i;
-
-	writel(lli_src->lcsp02, &lcpa->lcsp0);
-	writel(lli_src->lcsp13, &lcpa->lcsp1);
-	writel(lli_dst->lcsp02, &lcpa->lcsp2);
-	writel(lli_dst->lcsp13, &lcpa->lcsp3);
-
-	slos = lli_src->lcsp13 & D40_MEM_LCSP1_SLOS_MASK;
-	dlos = lli_dst->lcsp13 & D40_MEM_LCSP3_DLOS_MASK;
-
-	for (i = 0; (i < llis_per_log) && slos && dlos; i++) {
-		writel(lli_src[i + 1].lcsp02, &lcla_src[i].lcsp02);
-		writel(lli_src[i + 1].lcsp13, &lcla_src[i].lcsp13);
-		writel(lli_dst[i + 1].lcsp02, &lcla_dst[i].lcsp02);
-		writel(lli_dst[i + 1].lcsp13, &lcla_dst[i].lcsp13);
-
-		slos = lli_src[i + 1].lcsp13 & D40_MEM_LCSP1_SLOS_MASK;
-		dlos = lli_dst[i + 1].lcsp13 & D40_MEM_LCSP3_DLOS_MASK;
-	}
-
-	return i;
-
-}
diff --git a/drivers/dma/ste_dma40_ll.h b/drivers/dma/ste_dma40_ll.h
index a51ec18..37f81e8 100644
--- a/drivers/dma/ste_dma40_ll.h
+++ b/drivers/dma/ste_dma40_ll.h
@@ -268,22 +268,6 @@ struct d40_def_lcsp {
 	u32 lcsp1;
 };
 
-/**
- * struct d40_lcla_elem - Info for one LCA element.
- *
- * @src_id: logical channel src id
- * @dst_id: logical channel dst id
- * @src: LCPA formated src parameters
- * @dst: LCPA formated dst parameters
- *
- */
-struct d40_lcla_elem {
-	int			src_id;
-	int			dst_id;
-	struct d40_log_lli     *src;
-	struct d40_log_lli     *dst;
-};
-
 /* Physical channels */
 
 void d40_phy_cfg(struct stedma40_chan_cfg *cfg,
@@ -324,38 +308,33 @@ void d40_phy_lli_write(void __iomem *virtbase,
 void d40_log_fill_lli(struct d40_log_lli *lli,
 		      dma_addr_t data,
 		      u32 data_size,
-		      u32 lli_next_off,
 		      u32 reg_cfg,
 		      u32 data_width,
-		      bool term_int,
 		      bool addr_inc);
 
-int d40_log_sg_to_dev(struct d40_lcla_elem *lcla,
-		      struct scatterlist *sg,
+int d40_log_sg_to_dev(struct scatterlist *sg,
 		      int sg_len,
 		      struct d40_log_lli_bidir *lli,
 		      struct d40_def_lcsp *lcsp,
 		      u32 src_data_width,
 		      u32 dst_data_width,
 		      enum dma_data_direction direction,
-		      dma_addr_t dev_addr,
-		      int max_len,
-		      int llis_per_log);
-
-int d40_log_lli_write(struct d40_log_lli_full *lcpa,
-		      struct d40_log_lli *lcla_src,
-		      struct d40_log_lli *lcla_dst,
-		      struct d40_log_lli *lli_dst,
-		      struct d40_log_lli *lli_src,
-		      int llis_per_log);
-
-int d40_log_sg_to_lli(int lcla_id,
-		      struct scatterlist *sg,
+		      dma_addr_t dev_addr);
+
+int d40_log_sg_to_lli(struct scatterlist *sg,
 		      int sg_len,
 		      struct d40_log_lli *lli_sg,
 		      u32 lcsp13, /* src or dst*/
-		      u32 data_width,
-		      int max_len,
-		      int llis_per_log);
+		      u32 data_width);
+
+void d40_log_lli_lcpa_write(struct d40_log_lli_full *lcpa,
+			    struct d40_log_lli *lli_dst,
+			    struct d40_log_lli *lli_src,
+			    int next);
+
+void d40_log_lli_lcla_write(struct d40_log_lli *lcla,
+			    struct d40_log_lli *lli_dst,
+			    struct d40_log_lli *lli_src,
+			    int next);
 
 #endif /* STE_DMA40_LLI_H */
-- 
1.6.3.3

