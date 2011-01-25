Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab1AYKUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:20:03 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:42787 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753468Ab1AYKT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:19:58 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 32/32] dma40: cyclic xfer support
Date: Tue, 25 Jan 2011 11:18:35 +0100
Message-ID: <1295950715-22340-33-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
References: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

Support cyclic transfers, which are useful for ALSA drivers.

Acked-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c    |  172 +++++++++++++++++++++++++++++++++++--------
 drivers/dma/ste_dma40_ll.c |   35 ++++++----
 drivers/dma/ste_dma40_ll.h |    9 ++-
 3 files changed, 167 insertions(+), 49 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 8fd0bb9..af955de 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -115,6 +115,7 @@ struct d40_desc {
 	struct list_head		 node;
 
 	bool				 is_in_client_list;
+	bool				 cyclic;
 };
 
 /**
@@ -527,17 +528,45 @@ static void d40_log_lli_to_lcxa(struct d40_chan *chan, struct d40_desc *desc)
 	struct d40_log_lli_bidir *lli = &desc->lli_log;
 	int lli_current = desc->lli_current;
 	int lli_len = desc->lli_len;
+	bool cyclic = desc->cyclic;
 	int curr_lcla = -EINVAL;
+	int first_lcla = 0;
+	bool linkback;
 
-	if (lli_len - lli_current > 1)
+	/*
+	 * We may have partially running cyclic transfers, in case we did't get
+	 * enough LCLA entries.
+	 */
+	linkback = cyclic && lli_current == 0;
+
+	/*
+	 * For linkback, we need one LCLA even with only one link, because we
+	 * can't link back to the one in LCPA space
+	 */
+	if (linkback || (lli_len - lli_current > 1)) {
 		curr_lcla = d40_lcla_alloc_one(chan, desc);
+		first_lcla = curr_lcla;
+	}
+
+	/*
+	 * For linkback, we normally load the LCPA in the loop since we need to
+	 * link it to the second LCLA and not the first.  However, if we
+	 * couldn't even get a first LCLA, then we have to run in LCPA and
+	 * reload manually.
+	 */
+	if (!linkback || curr_lcla == -EINVAL) {
+		unsigned int flags = 0;
 
-	d40_log_lli_lcpa_write(chan->lcpa,
-			       &lli->dst[lli_current],
-			       &lli->src[lli_current],
-			       curr_lcla);
+		if (curr_lcla == -EINVAL)
+			flags |= LLI_TERM_INT;
 
-	lli_current++;
+		d40_log_lli_lcpa_write(chan->lcpa,
+				       &lli->dst[lli_current],
+				       &lli->src[lli_current],
+				       curr_lcla,
+				       flags);
+		lli_current++;
+	}
 
 	if (curr_lcla < 0)
 		goto out;
@@ -546,17 +575,33 @@ static void d40_log_lli_to_lcxa(struct d40_chan *chan, struct d40_desc *desc)
 		unsigned int lcla_offset = chan->phy_chan->num * 1024 +
 					   8 * curr_lcla * 2;
 		struct d40_log_lli *lcla = pool->base + lcla_offset;
+		unsigned int flags = 0;
 		int next_lcla;
 
 		if (lli_current + 1 < lli_len)
 			next_lcla = d40_lcla_alloc_one(chan, desc);
 		else
-			next_lcla = -EINVAL;
+			next_lcla = linkback ? first_lcla : -EINVAL;
+
+		if (cyclic || next_lcla == -EINVAL)
+			flags |= LLI_TERM_INT;
 
+		if (linkback && curr_lcla == first_lcla) {
+			/* First link goes in both LCPA and LCLA */
+			d40_log_lli_lcpa_write(chan->lcpa,
+					       &lli->dst[lli_current],
+					       &lli->src[lli_current],
+					       next_lcla, flags);
+		}
+
+		/*
+		 * One unused LCLA in the cyclic case if the very first
+		 * next_lcla fails...
+		 */
 		d40_log_lli_lcla_write(lcla,
 				       &lli->dst[lli_current],
 				       &lli->src[lli_current],
-				       next_lcla);
+				       next_lcla, flags);
 
 		dma_sync_single_range_for_device(chan->base->dev,
 					pool->dma_addr, lcla_offset,
@@ -565,7 +610,7 @@ static void d40_log_lli_to_lcxa(struct d40_chan *chan, struct d40_desc *desc)
 
 		curr_lcla = next_lcla;
 
-		if (curr_lcla == -EINVAL) {
+		if (curr_lcla == -EINVAL || curr_lcla == first_lcla) {
 			lli_current++;
 			break;
 		}
@@ -1074,17 +1119,36 @@ static void dma_tc_handle(struct d40_chan *d40c)
 	if (d40d == NULL)
 		return;
 
-	d40_lcla_free_all(d40c, d40d);
+	if (d40d->cyclic) {
+		/*
+		 * If this was a paritially loaded list, we need to reloaded
+		 * it, and only when the list is completed.  We need to check
+		 * for done because the interrupt will hit for every link, and
+		 * not just the last one.
+		 */
+		if (d40d->lli_current < d40d->lli_len
+		    && !d40_tx_is_linked(d40c)
+		    && !d40_residue(d40c)) {
+			d40_lcla_free_all(d40c, d40d);
+			d40_desc_load(d40c, d40d);
+			(void) d40_start(d40c);
 
-	if (d40d->lli_current < d40d->lli_len) {
-		d40_desc_load(d40c, d40d);
-		/* Start dma job */
-		(void) d40_start(d40c);
-		return;
-	}
+			if (d40d->lli_current == d40d->lli_len)
+				d40d->lli_current = 0;
+		}
+	} else {
+		d40_lcla_free_all(d40c, d40d);
 
-	if (d40_queue_start(d40c) == NULL)
-		d40c->busy = false;
+		if (d40d->lli_current < d40d->lli_len) {
+			d40_desc_load(d40c, d40d);
+			/* Start dma job */
+			(void) d40_start(d40c);
+			return;
+		}
+
+		if (d40_queue_start(d40c) == NULL)
+			d40c->busy = false;
+	}
 
 	d40c->pending_tx++;
 	tasklet_schedule(&d40c->tasklet);
@@ -1103,11 +1167,11 @@ static void dma_tasklet(unsigned long data)
 
 	/* Get first active entry from list */
 	d40d = d40_first_active_get(d40c);
-
 	if (d40d == NULL)
 		goto err;
 
-	d40c->completed = d40d->txd.cookie;
+	if (!d40d->cyclic)
+		d40c->completed = d40d->txd.cookie;
 
 	/*
 	 * If terminating a channel pending_tx is set to zero.
@@ -1122,16 +1186,18 @@ static void dma_tasklet(unsigned long data)
 	callback = d40d->txd.callback;
 	callback_param = d40d->txd.callback_param;
 
-	if (async_tx_test_ack(&d40d->txd)) {
-		d40_pool_lli_free(d40c, d40d);
-		d40_desc_remove(d40d);
-		d40_desc_free(d40c, d40d);
-	} else {
-		if (!d40d->is_in_client_list) {
+	if (!d40d->cyclic) {
+		if (async_tx_test_ack(&d40d->txd)) {
+			d40_pool_lli_free(d40c, d40d);
 			d40_desc_remove(d40d);
-			d40_lcla_free_all(d40c, d40d);
-			list_add_tail(&d40d->node, &d40c->client);
-			d40d->is_in_client_list = true;
+			d40_desc_free(d40c, d40d);
+		} else {
+			if (!d40d->is_in_client_list) {
+				d40_desc_remove(d40d);
+				d40_lcla_free_all(d40c, d40d);
+				list_add_tail(&d40d->node, &d40c->client);
+				d40d->is_in_client_list = true;
+			}
 		}
 	}
 
@@ -1694,19 +1760,23 @@ d40_prep_sg_phy(struct d40_chan *chan, struct d40_desc *desc,
 	struct stedma40_chan_cfg *cfg = &chan->dma_cfg;
 	struct stedma40_half_channel_info *src_info = &cfg->src_info;
 	struct stedma40_half_channel_info *dst_info = &cfg->dst_info;
+	unsigned long flags = 0;
 	int ret;
 
+	if (desc->cyclic)
+		flags |= LLI_CYCLIC | LLI_TERM_INT;
+
 	ret = d40_phy_sg_to_lli(sg_src, sg_len, src_dev_addr,
 				desc->lli_phy.src,
 				virt_to_phys(desc->lli_phy.src),
 				chan->src_def_cfg,
-				src_info, dst_info);
+				src_info, dst_info, flags);
 
 	ret = d40_phy_sg_to_lli(sg_dst, sg_len, dst_dev_addr,
 				desc->lli_phy.dst,
 				virt_to_phys(desc->lli_phy.dst),
 				chan->dst_def_cfg,
-				dst_info, src_info);
+				dst_info, src_info, flags);
 
 	dma_sync_single_for_device(chan->base->dev, desc->lli_pool.dma_addr,
 				   desc->lli_pool.size, DMA_TO_DEVICE);
@@ -1789,12 +1859,16 @@ d40_prep_sg(struct dma_chan *dchan, struct scatterlist *sg_src,
 		return NULL;
 	}
 
+
 	spin_lock_irqsave(&chan->lock, flags);
 
 	desc = d40_prep_desc(chan, sg_src, sg_len, dma_flags);
 	if (desc == NULL)
 		goto err;
 
+	if (sg_next(&sg_src[sg_len - 1]) == sg_src)
+		desc->cyclic = true;
+
 	if (direction != DMA_NONE) {
 		dma_addr_t dev_addr = d40_get_dev_addr(chan, direction);
 
@@ -2007,6 +2081,36 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 	return d40_prep_sg(chan, sgl, sgl, sg_len, direction, dma_flags);
 }
 
+static struct dma_async_tx_descriptor *
+dma40_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t dma_addr,
+		     size_t buf_len, size_t period_len,
+		     enum dma_data_direction direction)
+{
+	unsigned int periods = buf_len / period_len;
+	struct dma_async_tx_descriptor *txd;
+	struct scatterlist *sg;
+	int i;
+
+	sg = kcalloc(periods + 1, sizeof(struct scatterlist), GFP_KERNEL);
+	for (i = 0; i < periods; i++) {
+		sg_dma_address(&sg[i]) = dma_addr;
+		sg_dma_len(&sg[i]) = period_len;
+		dma_addr += period_len;
+	}
+
+	sg[periods].offset = 0;
+	sg[periods].length = 0;
+	sg[periods].page_link =
+		((unsigned long)sg | 0x01) & ~0x02;
+
+	txd = d40_prep_sg(chan, sg, sg, periods, direction,
+			  DMA_PREP_INTERRUPT);
+
+	kfree(sg);
+
+	return txd;
+}
+
 static enum dma_status d40_tx_status(struct dma_chan *chan,
 				     dma_cookie_t cookie,
 				     struct dma_tx_state *txstate)
@@ -2264,6 +2368,9 @@ static void d40_ops_init(struct d40_base *base, struct dma_device *dev)
 	if (dma_has_cap(DMA_SG, dev->cap_mask))
 		dev->device_prep_dma_sg = d40_prep_memcpy_sg;
 
+	if (dma_has_cap(DMA_CYCLIC, dev->cap_mask))
+		dev->device_prep_dma_cyclic = dma40_prep_dma_cyclic;
+
 	dev->device_alloc_chan_resources = d40_alloc_chan_resources;
 	dev->device_free_chan_resources = d40_free_chan_resources;
 	dev->device_issue_pending = d40_issue_pending;
@@ -2282,6 +2389,7 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 
 	dma_cap_zero(base->dma_slave.cap_mask);
 	dma_cap_set(DMA_SLAVE, base->dma_slave.cap_mask);
+	dma_cap_set(DMA_CYCLIC, base->dma_slave.cap_mask);
 
 	d40_ops_init(base, &base->dma_slave);
 
@@ -2316,9 +2424,9 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 	dma_cap_set(DMA_SLAVE, base->dma_both.cap_mask);
 	dma_cap_set(DMA_MEMCPY, base->dma_both.cap_mask);
 	dma_cap_set(DMA_SG, base->dma_both.cap_mask);
+	dma_cap_set(DMA_CYCLIC, base->dma_slave.cap_mask);
 
 	d40_ops_init(base, &base->dma_both);
-
 	err = dma_async_device_register(&base->dma_both);
 
 	if (err) {
diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
index 88b9e37..cad9e1d 100644
--- a/drivers/dma/ste_dma40_ll.c
+++ b/drivers/dma/ste_dma40_ll.c
@@ -202,13 +202,15 @@ static int d40_seg_size(int size, int data_width1, int data_width2)
 
 static struct d40_phy_lli *
 d40_phy_buf_to_lli(struct d40_phy_lli *lli, dma_addr_t addr, u32 size,
-		   dma_addr_t lli_phys, u32 reg_cfg,
+		   dma_addr_t lli_phys, dma_addr_t first_phys, u32 reg_cfg,
 		   struct stedma40_half_channel_info *info,
 		   struct stedma40_half_channel_info *otherinfo,
 		   unsigned long flags)
 {
+	bool lastlink = flags & LLI_LAST_LINK;
 	bool addr_inc = flags & LLI_ADDR_INC;
 	bool term_int = flags & LLI_TERM_INT;
+	bool cyclic = flags & LLI_CYCLIC;
 	int err;
 	dma_addr_t next = lli_phys;
 	int size_rest = size;
@@ -226,10 +228,12 @@ d40_phy_buf_to_lli(struct d40_phy_lli *lli, dma_addr_t addr, u32 size,
 					otherinfo->data_width);
 		size_rest -= size_seg;
 
-		if (term_int && size_rest == 0) {
-			next = 0;
+		if (size_rest == 0 && term_int)
 			flags |= LLI_TERM_INT;
-		} else
+
+		if (size_rest == 0 && lastlink)
+			next = cyclic ? first_phys : 0;
+		else
 			next = ALIGN(next + sizeof(struct d40_phy_lli),
 				     D40_LLI_ALIGN);
 
@@ -257,14 +261,14 @@ int d40_phy_sg_to_lli(struct scatterlist *sg,
 		      dma_addr_t lli_phys,
 		      u32 reg_cfg,
 		      struct stedma40_half_channel_info *info,
-		      struct stedma40_half_channel_info *otherinfo)
+		      struct stedma40_half_channel_info *otherinfo,
+		      unsigned long flags)
 {
 	int total_size = 0;
 	int i;
 	struct scatterlist *current_sg = sg;
 	struct d40_phy_lli *lli = lli_sg;
 	dma_addr_t l_phys = lli_phys;
-	unsigned long flags = 0;
 
 	if (!target)
 		flags |= LLI_ADDR_INC;
@@ -277,12 +281,12 @@ int d40_phy_sg_to_lli(struct scatterlist *sg,
 		total_size += sg_dma_len(current_sg);
 
 		if (i == sg_len - 1)
-			flags |= LLI_TERM_INT;
+			flags |= LLI_TERM_INT | LLI_LAST_LINK;
 
 		l_phys = ALIGN(lli_phys + (lli - lli_sg) *
 			       sizeof(struct d40_phy_lli), D40_LLI_ALIGN);
 
-		lli = d40_phy_buf_to_lli(lli, dst, len, l_phys,
+		lli = d40_phy_buf_to_lli(lli, dst, len, l_phys, lli_phys,
 					 reg_cfg, info, otherinfo, flags);
 
 		if (lli == NULL)
@@ -297,15 +301,18 @@ int d40_phy_sg_to_lli(struct scatterlist *sg,
 
 static void d40_log_lli_link(struct d40_log_lli *lli_dst,
 			     struct d40_log_lli *lli_src,
-			     int next)
+			     int next, unsigned int flags)
 {
+	bool interrupt = flags & LLI_TERM_INT;
 	u32 slos = 0;
 	u32 dlos = 0;
 
 	if (next != -EINVAL) {
 		slos = next * 2;
 		dlos = next * 2 + 1;
-	} else {
+	}
+
+	if (interrupt) {
 		lli_dst->lcsp13 |= D40_MEM_LCSP1_SCFG_TIM_MASK;
 		lli_dst->lcsp13 |= D40_MEM_LCSP3_DTCP_MASK;
 	}
@@ -320,9 +327,9 @@ static void d40_log_lli_link(struct d40_log_lli *lli_dst,
 void d40_log_lli_lcpa_write(struct d40_log_lli_full *lcpa,
 			   struct d40_log_lli *lli_dst,
 			   struct d40_log_lli *lli_src,
-			   int next)
+			   int next, unsigned int flags)
 {
-	d40_log_lli_link(lli_dst, lli_src, next);
+	d40_log_lli_link(lli_dst, lli_src, next, flags);
 
 	writel(lli_src->lcsp02, &lcpa[0].lcsp0);
 	writel(lli_src->lcsp13, &lcpa[0].lcsp1);
@@ -333,9 +340,9 @@ void d40_log_lli_lcpa_write(struct d40_log_lli_full *lcpa,
 void d40_log_lli_lcla_write(struct d40_log_lli *lcla,
 			   struct d40_log_lli *lli_dst,
 			   struct d40_log_lli *lli_src,
-			   int next)
+			   int next, unsigned int flags)
 {
-	d40_log_lli_link(lli_dst, lli_src, next);
+	d40_log_lli_link(lli_dst, lli_src, next, flags);
 
 	writel(lli_src->lcsp02, &lcla[0].lcsp02);
 	writel(lli_src->lcsp13, &lcla[0].lcsp13);
diff --git a/drivers/dma/ste_dma40_ll.h b/drivers/dma/ste_dma40_ll.h
index 59e72f0..195ee65 100644
--- a/drivers/dma/ste_dma40_ll.h
+++ b/drivers/dma/ste_dma40_ll.h
@@ -296,6 +296,8 @@ struct d40_def_lcsp {
 enum d40_lli_flags {
 	LLI_ADDR_INC	= 1 << 0,
 	LLI_TERM_INT	= 1 << 1,
+	LLI_CYCLIC	= 1 << 2,
+	LLI_LAST_LINK	= 1 << 3,
 };
 
 void d40_phy_cfg(struct stedma40_chan_cfg *cfg,
@@ -314,7 +316,8 @@ int d40_phy_sg_to_lli(struct scatterlist *sg,
 		      dma_addr_t lli_phys,
 		      u32 reg_cfg,
 		      struct stedma40_half_channel_info *info,
-		      struct stedma40_half_channel_info *otherinfo);
+		      struct stedma40_half_channel_info *otherinfo,
+		      unsigned long flags);
 
 /* Logical channels */
 
@@ -328,11 +331,11 @@ int d40_log_sg_to_lli(struct scatterlist *sg,
 void d40_log_lli_lcpa_write(struct d40_log_lli_full *lcpa,
 			    struct d40_log_lli *lli_dst,
 			    struct d40_log_lli *lli_src,
-			    int next);
+			    int next, unsigned int flags);
 
 void d40_log_lli_lcla_write(struct d40_log_lli *lcla,
 			    struct d40_log_lli *lli_dst,
 			    struct d40_log_lli *lli_src,
-			    int next);
+			    int next, unsigned int flags);
 
 #endif /* STE_DMA40_LLI_H */
-- 
1.7.3.2

