Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab0HIMIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 08:08:48 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:53915 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756469Ab0HIMIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 08:08:44 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Jonas Aaberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 08/14] DMAENGINE: ste_dma40: code clean-up
Date: Mon, 9 Aug 2010 14:08:34 +0200
Message-ID: <1281355714-13363-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

This patch includes non functional code clean up changes,
file header updates and a few magic numbers got defined.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |   13 ++--
 drivers/dma/ste_dma40.c                        |   72 ++++++++++--------------
 drivers/dma/ste_dma40_ll.c                     |    8 +--
 drivers/dma/ste_dma40_ll.h                     |   30 ++++++----
 4 files changed, 57 insertions(+), 66 deletions(-)

diff --git a/arch/arm/plat-nomadik/include/plat/ste_dma40.h b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
index ee5d8b2..879a6c1 100644
--- a/arch/arm/plat-nomadik/include/plat/ste_dma40.h
+++ b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
@@ -1,10 +1,8 @@
 /*
- * arch/arm/plat-nomadik/include/plat/ste_dma40.h
- *
- * Copyright (C) ST-Ericsson 2007-2010
+ * Copyright (C) ST-Ericsson SA 2007-2010
+ * Author: Per Friden <per.friden@stericsson.com> for ST-Ericsson
+ * Author: Jonas Aaberg <jonas.aberg@stericsson.com> for ST-Ericsson
  * License terms: GNU General Public License (GPL) version 2
- * Author: Per Friden <per.friden@stericsson.com>
- * Author: Jonas Aaberg <jonas.aberg@stericsson.com>
  */
 
 
@@ -73,6 +71,9 @@
 #define STEDMA40_PSIZE_LOG_8  STEDMA40_PSIZE_PHY_8
 #define STEDMA40_PSIZE_LOG_16 STEDMA40_PSIZE_PHY_16
 
+/* Maximum number of possible physical channels */
+#define STEDMA40_MAX_PHYS 32
+
 enum stedma40_flow_ctrl {
 	STEDMA40_NO_FLOW_CTRL,
 	STEDMA40_FLOW_CTRL,
@@ -160,7 +161,7 @@ struct stedma40_platform_data {
 	struct stedma40_chan_cfg	*memcpy_conf_phy;
 	struct stedma40_chan_cfg	*memcpy_conf_log;
 	unsigned int			 llis_per_log;
-	int				 disabled_channels[8];
+	int				 disabled_channels[STEDMA40_MAX_PHYS];
 };
 
 /**
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index b8987e7..7a4919b 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1,11 +1,8 @@
 /*
- * driver/dma/ste_dma40.c
- *
- * Copyright (C) ST-Ericsson 2007-2010
+ * Copyright (C) ST-Ericsson SA 2007-2010
+ * Author: Per Friden <per.friden@stericsson.com> for ST-Ericsson
+ * Author: Jonas Aaberg <jonas.aberg@stericsson.com> for ST-Ericsson
  * License terms: GNU General Public License (GPL) version 2
- * Author: Per Friden <per.friden@stericsson.com>
- * Author: Jonas Aaberg <jonas.aberg@stericsson.com>
- *
  */
 
 #include <linux/kernel.h>
@@ -90,7 +87,6 @@ struct d40_lli_pool {
  * @txd: DMA engine struct. Used for among other things for communication
  * during a transfer.
  * @node: List entry.
- * @dir: The transfer direction of this job.
  * @is_in_client_list: true if the client owns this descriptor.
  * @is_hw_linked: true if this job will automatically be continued for
  * the previous one.
@@ -112,7 +108,6 @@ struct d40_desc {
 	struct dma_async_tx_descriptor	 txd;
 	struct list_head		 node;
 
-	enum dma_data_direction		 dir;
 	bool				 is_in_client_list;
 	bool				 is_hw_linked;
 };
@@ -149,9 +144,7 @@ struct d40_lcla_pool {
  * this physical channel. Can also be free or physically allocated.
  * @allocated_dst: Same as for src but is dst.
  * allocated_dst and allocated_src uses the D40_ALLOC* defines as well as
- * event line number. Both allocated_src and allocated_dst can not be
- * allocated to a physical channel, since the interrupt handler has then
- * no way of figure out which one the interrupt belongs to.
+ * event line number.
  */
 struct d40_phy_res {
 	spinlock_t lock;
@@ -237,7 +230,6 @@ struct d40_chan {
  * @dma_both: dma_device channels that can do both memcpy and slave transfers.
  * @dma_slave: dma_device channels that can do only do slave transfers.
  * @dma_memcpy: dma_device channels that can do only do memcpy transfers.
- * @phy_chans: Room for all possible physical channels in system.
  * @log_chans: Room for all possible logical channels in system.
  * @lookup_log_chans: Used to map interrupt number to logical channel. Points
  * to log_chans entries.
@@ -500,7 +492,8 @@ err:
 static int d40_channel_execute_command(struct d40_chan *d40c,
 				       enum d40_command command)
 {
-	int status, i;
+	u32 status;
+	int i;
 	void __iomem *active_reg;
 	int ret = 0;
 	unsigned long flags;
@@ -568,16 +561,12 @@ static void d40_term_all(struct d40_chan *d40c)
 	/* Release active descriptors */
 	while ((d40d = d40_first_active_get(d40c))) {
 		d40_desc_remove(d40d);
-
-		/* Return desc to free-list */
 		d40_desc_free(d40c, d40d);
 	}
 
 	/* Release queued descriptors waiting for transfer */
 	while ((d40d = d40_first_queued(d40c))) {
 		d40_desc_remove(d40d);
-
-		/* Return desc to free-list */
 		d40_desc_free(d40c, d40d);
 	}
 
@@ -973,9 +962,6 @@ static void dma_tc_handle(struct d40_chan *d40c)
 {
 	struct d40_desc *d40d;
 
-	if (!d40c->phy_chan)
-		return;
-
 	/* Get first active entry from list */
 	d40d = d40_first_active_get(d40c);
 
@@ -1001,7 +987,7 @@ static void dma_tc_handle(struct d40_chan *d40c)
 static void dma_tasklet(unsigned long data)
 {
 	struct d40_chan *d40c = (struct d40_chan *) data;
-	struct d40_desc *d40d_fin;
+	struct d40_desc *d40d;
 	unsigned long flags;
 	dma_async_tx_callback callback;
 	void *callback_param;
@@ -1009,12 +995,12 @@ static void dma_tasklet(unsigned long data)
 	spin_lock_irqsave(&d40c->lock, flags);
 
 	/* Get first active entry from list */
-	d40d_fin = d40_first_active_get(d40c);
+	d40d = d40_first_active_get(d40c);
 
-	if (d40d_fin == NULL)
+	if (d40d == NULL)
 		goto err;
 
-	d40c->completed = d40d_fin->txd.cookie;
+	d40c->completed = d40d->txd.cookie;
 
 	/*
 	 * If terminating a channel pending_tx is set to zero.
@@ -1026,19 +1012,18 @@ static void dma_tasklet(unsigned long data)
 	}
 
 	/* Callback to client */
-	callback = d40d_fin->txd.callback;
-	callback_param = d40d_fin->txd.callback_param;
-
-	if (async_tx_test_ack(&d40d_fin->txd)) {
-		d40_pool_lli_free(d40d_fin);
-		d40_desc_remove(d40d_fin);
-		/* Return desc to free-list */
-		d40_desc_free(d40c, d40d_fin);
+	callback = d40d->txd.callback;
+	callback_param = d40d->txd.callback_param;
+
+	if (async_tx_test_ack(&d40d->txd)) {
+		d40_pool_lli_free(d40d);
+		d40_desc_remove(d40d);
+		d40_desc_free(d40c, d40d);
 	} else {
-		if (!d40d_fin->is_in_client_list) {
-			d40_desc_remove(d40d_fin);
-			list_add_tail(&d40d_fin->node, &d40c->client);
-			d40d_fin->is_in_client_list = true;
+		if (!d40d->is_in_client_list) {
+			d40_desc_remove(d40d);
+			list_add_tail(&d40d->node, &d40c->client);
+			d40d->is_in_client_list = true;
 		}
 	}
 
@@ -1049,7 +1034,7 @@ static void dma_tasklet(unsigned long data)
 
 	spin_unlock_irqrestore(&d40c->lock, flags);
 
-	if (callback && (d40d_fin->txd.flags & DMA_PREP_INTERRUPT))
+	if (callback && (d40d->txd.flags & DMA_PREP_INTERRUPT))
 		callback(callback_param);
 
 	return;
@@ -1127,7 +1112,6 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-
 static int d40_validate_conf(struct d40_chan *d40c,
 			     struct stedma40_chan_cfg *conf)
 {
@@ -1432,7 +1416,6 @@ static int d40_free_dma(struct d40_chan *d40c)
 		list_for_each_entry_safe(d, _d, &d40c->client, node) {
 			d40_pool_lli_free(d);
 			d40_desc_remove(d);
-			/* Return desc to free-list */
 			d40_desc_free(d40c, d);
 		}
 
@@ -2793,8 +2776,10 @@ static int __init d40_lcla_allocate(struct d40_base *base)
 	if (i < MAX_LCLA_ALLOC_ATTEMPTS) {
 		base->lcla_pool.base = (void *)page_list[i];
 	} else {
-		/* After many attempts, no succees with finding the correct
-		 * alignment try with allocating a big buffer */
+		/*
+		 * After many attempts and no succees with finding the correct
+		 * alignment, try with allocating a big buffer.
+		 */
 		dev_warn(base->dev,
 			 "[%s] Failed to get %d pages @ 18 bit align.\n",
 			 __func__, base->lcla_pool.pages);
@@ -2916,8 +2901,9 @@ failure:
 		if (!base->lcla_pool.base_unaligned && base->lcla_pool.base)
 			free_pages((unsigned long)base->lcla_pool.base,
 				   base->lcla_pool.pages);
-		if (base->lcla_pool.base_unaligned)
-			kfree(base->lcla_pool.base_unaligned);
+
+		kfree(base->lcla_pool.base_unaligned);
+
 		if (base->phy_lcpa)
 			release_mem_region(base->phy_lcpa,
 					   base->lcpa_size);
diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
index 6707672..92a0960 100644
--- a/drivers/dma/ste_dma40_ll.c
+++ b/drivers/dma/ste_dma40_ll.c
@@ -1,10 +1,8 @@
 /*
- * driver/dma/ste_dma40_ll.c
- *
- * Copyright (C) ST-Ericsson 2007-2010
+ * Copyright (C) ST-Ericsson SA 2007-2010
+ * Author: Per Friden <per.friden@stericsson.com> for ST-Ericsson
+ * Author: Jonas Aaberg <jonas.aberg@stericsson.com> for ST-Ericsson
  * License terms: GNU General Public License (GPL) version 2
- * Author: Per Friden <per.friden@stericsson.com>
- * Author: Jonas Aaberg <jonas.aberg@stericsson.com>
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/dma/ste_dma40_ll.h b/drivers/dma/ste_dma40_ll.h
index be35fad..a51ec18 100644
--- a/drivers/dma/ste_dma40_ll.h
+++ b/drivers/dma/ste_dma40_ll.h
@@ -1,10 +1,8 @@
 /*
- * driver/dma/ste_dma40_ll.h
- *
- * Copyright (C) ST-Ericsson 2007-2010
+ * Copyright (C) ST-Ericsson SA 2007-2010
+ * Author: Per Friden <per.friden@stericsson.com> for ST-Ericsson SA
+ * Author: Jonas Aaberg <jonas.aberg@stericsson.com> for ST-Ericsson SA
  * License terms: GNU General Public License (GPL) version 2
- * Author: Per Friden <per.friden@stericsson.com>
- * Author: Jonas Aaberg <jonas.aberg@stericsson.com>
  */
 #ifndef STE_DMA40_LL_H
 #define STE_DMA40_LL_H
@@ -289,10 +287,13 @@ struct d40_lcla_elem {
 /* Physical channels */
 
 void d40_phy_cfg(struct stedma40_chan_cfg *cfg,
-		 u32 *src_cfg, u32 *dst_cfg, bool is_log);
+		 u32 *src_cfg,
+		 u32 *dst_cfg,
+		 bool is_log);
 
 void d40_log_cfg(struct stedma40_chan_cfg *cfg,
-		 u32 *lcsp1, u32 *lcsp2);
+		 u32 *lcsp1,
+		 u32 *lcsp2);
 
 int d40_phy_sg_to_lli(struct scatterlist *sg,
 		      int sg_len,
@@ -321,10 +322,13 @@ void d40_phy_lli_write(void __iomem *virtbase,
 /* Logical channels */
 
 void d40_log_fill_lli(struct d40_log_lli *lli,
-		      dma_addr_t data, u32 data_size,
-		      u32 lli_next_off, u32 reg_cfg,
+		      dma_addr_t data,
+		      u32 data_size,
+		      u32 lli_next_off,
+		      u32 reg_cfg,
 		      u32 data_width,
-		      bool term_int, bool addr_inc);
+		      bool term_int,
+		      bool addr_inc);
 
 int d40_log_sg_to_dev(struct d40_lcla_elem *lcla,
 		      struct scatterlist *sg,
@@ -334,7 +338,8 @@ int d40_log_sg_to_dev(struct d40_lcla_elem *lcla,
 		      u32 src_data_width,
 		      u32 dst_data_width,
 		      enum dma_data_direction direction,
-		      dma_addr_t dev_addr, int max_len,
+		      dma_addr_t dev_addr,
+		      int max_len,
 		      int llis_per_log);
 
 int d40_log_lli_write(struct d40_log_lli_full *lcpa,
@@ -350,6 +355,7 @@ int d40_log_sg_to_lli(int lcla_id,
 		      struct d40_log_lli *lli_sg,
 		      u32 lcsp13, /* src or dst*/
 		      u32 data_width,
-		      int max_len, int llis_per_log);
+		      int max_len,
+		      int llis_per_log);
 
 #endif /* STE_DMA40_LLI_H */
-- 
1.6.3.3

