Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744Ab0LTRee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 12:34:34 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:59964 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757659Ab0LTRed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 12:34:33 -0500
From: Per Forlin <per.forlin@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Per Forlin <per.forlin@stericsson.com>,
        Per Forlin <per.forlin@linaro.org>
Subject: [PATCH] dmaengine: dma40: Add support to split up large elements
Date: Mon, 20 Dec 2010 18:31:38 +0100
Message-ID: <1292866298-8585-1-git-send-email-per.forlin@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The maximum transfer size of the stedma40 is (64k-1) x data-width.
If the transfer size of one element exceeds this limit
the job is split up and sent as linked transfer.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |    8 +
 drivers/dma/ste_dma40.c                        |  191 +++++++++++++++----
 drivers/dma/ste_dma40_ll.c                     |  246 +++++++++++++++++-------
 drivers/dma/ste_dma40_ll.h                     |   36 ++--
 4 files changed, 351 insertions(+), 130 deletions(-)

diff --git a/arch/arm/plat-nomadik/include/plat/ste_dma40.h b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
index 74b62f1..4d6dd4c 100644
--- a/arch/arm/plat-nomadik/include/plat/ste_dma40.h
+++ b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
@@ -13,6 +13,14 @@
 #include <linux/workqueue.h>
 #include <linux/interrupt.h>
 
+/*
+ * Maxium size for a single dma descriptor
+ * Size is limited to 16 bits.
+ * Size is in the units of addr-widths (1,2,4,8 bytes)
+ * Larger transfers will be split up to multiple linked desc
+ */
+#define STEDMA40_MAX_SEG_SIZE 0xFFFF
+
 /* dev types for memcpy */
 #define STEDMA40_DEV_DST_MEMORY (-1)
 #define	STEDMA40_DEV_SRC_MEMORY (-1)
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index fab68a5..6e1d46a 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1,5 +1,6 @@
 /*
- * Copyright (C) ST-Ericsson SA 2007-2010
+ * Copyright (C) Ericsson AB 2007-2008
+ * Copyright (C) ST-Ericsson SA 2008-2010
  * Author: Per Forlin <per.forlin@stericsson.com> for ST-Ericsson
  * Author: Jonas Aaberg <jonas.aberg@stericsson.com> for ST-Ericsson
  * License terms: GNU General Public License (GPL) version 2
@@ -554,8 +555,66 @@ static struct d40_desc *d40_last_queued(struct d40_chan *d40c)
 	return d;
 }
 
-/* Support functions for logical channels */
+static int d40_psize_2_burst_size(bool is_log, int psize)
+{
+	if (is_log) {
+		if (psize == STEDMA40_PSIZE_LOG_1)
+			return 1;
+	} else {
+		if (psize == STEDMA40_PSIZE_PHY_1)
+			return 1;
+	}
+
+	return 2 << psize;
+}
+
+/*
+ * The dma only supports transmitting packages up to
+ * STEDMA40_MAX_SEG_SIZE << data_width. Calculate the total number of
+ * dma elements required to send the entire sg list
+ */
+static int d40_size_2_dmalen(int size, u32 data_width1, u32 data_width2)
+{
+	int dmalen;
+	u32 max_w = max(data_width1, data_width2);
+	u32 min_w = min(data_width1, data_width2);
+	u32 seg_max = ALIGN(STEDMA40_MAX_SEG_SIZE << min_w, 1 << max_w);
+
+	if (seg_max > STEDMA40_MAX_SEG_SIZE)
+		seg_max -= (1 << max_w);
+
+	if (!IS_ALIGNED(size, 1 << max_w))
+		return -EINVAL;
+
+	if (size <= seg_max)
+		dmalen = 1;
+	else {
+		dmalen = size / seg_max;
+		if (dmalen * seg_max < size)
+			dmalen++;
+	}
+	return dmalen;
+}
+
+static int d40_sg_2_dmalen(struct scatterlist *sgl, int sg_len,
+			   u32 data_width1, u32 data_width2)
+{
+	struct scatterlist *sg;
+	int i;
+	int len = 0;
+	int ret;
+
+	for_each_sg(sgl, sg, sg_len, i) {
+		ret = d40_size_2_dmalen(sg_dma_len(sg),
+					data_width1, data_width2);
+		if (ret < 0)
+			return ret;
+		len += ret;
+	}
+	return len;
+}
 
+/* Support functions for logical channels */
 
 static int d40_channel_execute_command(struct d40_chan *d40c,
 				       enum d40_command command)
@@ -1241,6 +1300,21 @@ static int d40_validate_conf(struct d40_chan *d40c,
 		res = -EINVAL;
 	}
 
+	if (d40_psize_2_burst_size(is_log, conf->src_info.psize) *
+	    (1 << conf->src_info.data_width) !=
+	    d40_psize_2_burst_size(is_log, conf->dst_info.psize) *
+	    (1 << conf->dst_info.data_width)) {
+		/*
+		 * The DMAC hardware only supports
+		 * src (burst x width) == dst (burst x width)
+		 */
+
+		dev_err(&d40c->chan.dev->device,
+			"[%s] src (burst x width) != dst (burst x width)\n",
+			__func__);
+		res = -EINVAL;
+	}
+
 	return res;
 }
 
@@ -1638,13 +1712,21 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 	if (d40d == NULL)
 		goto err;
 
-	d40d->lli_len = sgl_len;
+	d40d->lli_len = d40_sg_2_dmalen(sgl_dst, sgl_len,
+					d40c->dma_cfg.src_info.data_width,
+					d40c->dma_cfg.dst_info.data_width);
+	if (d40d->lli_len < 0) {
+		dev_err(&d40c->chan.dev->device,
+			"[%s] Unaligned size\n", __func__);
+		goto err;
+	}
+
 	d40d->lli_current = 0;
 	d40d->txd.flags = dma_flags;
 
 	if (d40c->log_num != D40_PHY_CHAN) {
 
-		if (d40_pool_lli_alloc(d40d, sgl_len, true) < 0) {
+		if (d40_pool_lli_alloc(d40d, d40d->lli_len, true) < 0) {
 			dev_err(&d40c->chan.dev->device,
 				"[%s] Out of memory\n", __func__);
 			goto err;
@@ -1654,15 +1736,17 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 					 sgl_len,
 					 d40d->lli_log.src,
 					 d40c->log_def.lcsp1,
-					 d40c->dma_cfg.src_info.data_width);
+					 d40c->dma_cfg.src_info.data_width,
+					 d40c->dma_cfg.dst_info.data_width);
 
 		(void) d40_log_sg_to_lli(sgl_dst,
 					 sgl_len,
 					 d40d->lli_log.dst,
 					 d40c->log_def.lcsp3,
-					 d40c->dma_cfg.dst_info.data_width);
+					 d40c->dma_cfg.dst_info.data_width,
+					 d40c->dma_cfg.src_info.data_width);
 	} else {
-		if (d40_pool_lli_alloc(d40d, sgl_len, false) < 0) {
+		if (d40_pool_lli_alloc(d40d, d40d->lli_len, false) < 0) {
 			dev_err(&d40c->chan.dev->device,
 				"[%s] Out of memory\n", __func__);
 			goto err;
@@ -1675,6 +1759,7 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 					virt_to_phys(d40d->lli_phy.src),
 					d40c->src_def_cfg,
 					d40c->dma_cfg.src_info.data_width,
+					d40c->dma_cfg.dst_info.data_width,
 					d40c->dma_cfg.src_info.psize);
 
 		if (res < 0)
@@ -1687,6 +1772,7 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 					virt_to_phys(d40d->lli_phy.dst),
 					d40c->dst_def_cfg,
 					d40c->dma_cfg.dst_info.data_width,
+					d40c->dma_cfg.src_info.data_width,
 					d40c->dma_cfg.dst_info.psize);
 
 		if (res < 0)
@@ -1826,7 +1912,6 @@ static struct dma_async_tx_descriptor *d40_prep_memcpy(struct dma_chan *chan,
 	struct d40_chan *d40c = container_of(chan, struct d40_chan,
 					     chan);
 	unsigned long flags;
-	int err = 0;
 
 	if (d40c->phy_chan == NULL) {
 		dev_err(&d40c->chan.dev->device,
@@ -1844,6 +1929,15 @@ static struct dma_async_tx_descriptor *d40_prep_memcpy(struct dma_chan *chan,
 	}
 
 	d40d->txd.flags = dma_flags;
+	d40d->lli_len = d40_size_2_dmalen(size,
+					  d40c->dma_cfg.src_info.data_width,
+					  d40c->dma_cfg.dst_info.data_width);
+	if (d40d->lli_len < 0) {
+		dev_err(&d40c->chan.dev->device,
+			"[%s] Unaligned size\n", __func__);
+		goto err;
+	}
+
 
 	dma_async_tx_descriptor_init(&d40d->txd, chan);
 
@@ -1851,37 +1945,40 @@ static struct dma_async_tx_descriptor *d40_prep_memcpy(struct dma_chan *chan,
 
 	if (d40c->log_num != D40_PHY_CHAN) {
 
-		if (d40_pool_lli_alloc(d40d, 1, true) < 0) {
+		if (d40_pool_lli_alloc(d40d, d40d->lli_len, true) < 0) {
 			dev_err(&d40c->chan.dev->device,
 				"[%s] Out of memory\n", __func__);
 			goto err;
 		}
-		d40d->lli_len = 1;
 		d40d->lli_current = 0;
 
-		d40_log_fill_lli(d40d->lli_log.src,
-				 src,
-				 size,
-				 d40c->log_def.lcsp1,
-				 d40c->dma_cfg.src_info.data_width,
-				 true);
+		if (d40_log_buf_to_lli(d40d->lli_log.src,
+				       src,
+				       size,
+				       d40c->log_def.lcsp1,
+				       d40c->dma_cfg.src_info.data_width,
+				       d40c->dma_cfg.dst_info.data_width,
+				       true) == NULL)
+			goto err;
 
-		d40_log_fill_lli(d40d->lli_log.dst,
-				 dst,
-				 size,
-				 d40c->log_def.lcsp3,
-				 d40c->dma_cfg.dst_info.data_width,
-				 true);
+		if (d40_log_buf_to_lli(d40d->lli_log.dst,
+				       dst,
+				       size,
+				       d40c->log_def.lcsp3,
+				       d40c->dma_cfg.dst_info.data_width,
+				       d40c->dma_cfg.src_info.data_width,
+				       true) == NULL)
+			goto err;
 
 	} else {
 
-		if (d40_pool_lli_alloc(d40d, 1, false) < 0) {
+		if (d40_pool_lli_alloc(d40d, d40d->lli_len, false) < 0) {
 			dev_err(&d40c->chan.dev->device,
 				"[%s] Out of memory\n", __func__);
 			goto err;
 		}
 
-		err = d40_phy_fill_lli(d40d->lli_phy.src,
+		if (d40_phy_buf_to_lli(d40d->lli_phy.src,
 				       src,
 				       size,
 				       d40c->dma_cfg.src_info.psize,
@@ -1889,11 +1986,11 @@ static struct dma_async_tx_descriptor *d40_prep_memcpy(struct dma_chan *chan,
 				       d40c->src_def_cfg,
 				       true,
 				       d40c->dma_cfg.src_info.data_width,
-				       false);
-		if (err)
-			goto err_fill_lli;
+				       d40c->dma_cfg.dst_info.data_width,
+				       false) == NULL)
+			goto err;
 
-		err = d40_phy_fill_lli(d40d->lli_phy.dst,
+		if (d40_phy_buf_to_lli(d40d->lli_phy.dst,
 				       dst,
 				       size,
 				       d40c->dma_cfg.dst_info.psize,
@@ -1901,10 +1998,9 @@ static struct dma_async_tx_descriptor *d40_prep_memcpy(struct dma_chan *chan,
 				       d40c->dst_def_cfg,
 				       true,
 				       d40c->dma_cfg.dst_info.data_width,
-				       false);
-
-		if (err)
-			goto err_fill_lli;
+				       d40c->dma_cfg.src_info.data_width,
+				       false) == NULL)
+			goto err;
 
 		(void) dma_map_single(d40c->base->dev, d40d->lli_phy.src,
 				      d40d->lli_pool.size, DMA_TO_DEVICE);
@@ -1913,9 +2009,6 @@ static struct dma_async_tx_descriptor *d40_prep_memcpy(struct dma_chan *chan,
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return &d40d->txd;
 
-err_fill_lli:
-	dev_err(&d40c->chan.dev->device,
-		"[%s] Failed filling in PHY LLI\n", __func__);
 err:
 	if (d40d)
 		d40_desc_free(d40c, d40d);
@@ -1945,13 +2038,21 @@ static int d40_prep_slave_sg_log(struct d40_desc *d40d,
 	dma_addr_t dev_addr = 0;
 	int total_size;
 
-	if (d40_pool_lli_alloc(d40d, sg_len, true) < 0) {
+	d40d->lli_len = d40_sg_2_dmalen(sgl, sg_len,
+					d40c->dma_cfg.src_info.data_width,
+					d40c->dma_cfg.dst_info.data_width);
+	if (d40d->lli_len < 0) {
+		dev_err(&d40c->chan.dev->device,
+			"[%s] Unaligned size\n", __func__);
+		return -EINVAL;
+	}
+
+	if (d40_pool_lli_alloc(d40d, d40d->lli_len, true) < 0) {
 		dev_err(&d40c->chan.dev->device,
 			"[%s] Out of memory\n", __func__);
 		return -ENOMEM;
 	}
 
-	d40d->lli_len = sg_len;
 	d40d->lli_current = 0;
 
 	if (direction == DMA_FROM_DEVICE)
@@ -1993,13 +2094,21 @@ static int d40_prep_slave_sg_phy(struct d40_desc *d40d,
 	dma_addr_t dst_dev_addr;
 	int res;
 
-	if (d40_pool_lli_alloc(d40d, sgl_len, false) < 0) {
+	d40d->lli_len = d40_sg_2_dmalen(sgl, sgl_len,
+					d40c->dma_cfg.src_info.data_width,
+					d40c->dma_cfg.dst_info.data_width);
+	if (d40d->lli_len < 0) {
+		dev_err(&d40c->chan.dev->device,
+			"[%s] Unaligned size\n", __func__);
+		return -EINVAL;
+	}
+
+	if (d40_pool_lli_alloc(d40d, d40d->lli_len, false) < 0) {
 		dev_err(&d40c->chan.dev->device,
 			"[%s] Out of memory\n", __func__);
 		return -ENOMEM;
 	}
 
-	d40d->lli_len = sgl_len;
 	d40d->lli_current = 0;
 
 	if (direction == DMA_FROM_DEVICE) {
@@ -2024,6 +2133,7 @@ static int d40_prep_slave_sg_phy(struct d40_desc *d40d,
 				virt_to_phys(d40d->lli_phy.src),
 				d40c->src_def_cfg,
 				d40c->dma_cfg.src_info.data_width,
+				d40c->dma_cfg.dst_info.data_width,
 				d40c->dma_cfg.src_info.psize);
 	if (res < 0)
 		return res;
@@ -2035,6 +2145,7 @@ static int d40_prep_slave_sg_phy(struct d40_desc *d40d,
 				virt_to_phys(d40d->lli_phy.dst),
 				d40c->dst_def_cfg,
 				d40c->dma_cfg.dst_info.data_width,
+				d40c->dma_cfg.src_info.data_width,
 				d40c->dma_cfg.dst_info.psize);
 	if (res < 0)
 		return res;
@@ -2244,6 +2355,8 @@ static void d40_set_runtime_config(struct dma_chan *chan,
 			psize = STEDMA40_PSIZE_PHY_8;
 		else if (config_maxburst >= 4)
 			psize = STEDMA40_PSIZE_PHY_4;
+		else if (config_maxburst >= 2)
+			psize = STEDMA40_PSIZE_PHY_2;
 		else
 			psize = STEDMA40_PSIZE_PHY_1;
 	}
diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
index 8557cb8..0b096a3 100644
--- a/drivers/dma/ste_dma40_ll.c
+++ b/drivers/dma/ste_dma40_ll.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) ST-Ericsson SA 2007-2010
- * Author: Per Friden <per.friden@stericsson.com> for ST-Ericsson
+ * Author: Per Forlin <per.forlin@stericsson.com> for ST-Ericsson
  * Author: Jonas Aaberg <jonas.aberg@stericsson.com> for ST-Ericsson
  * License terms: GNU General Public License (GPL) version 2
  */
@@ -122,15 +122,15 @@ void d40_phy_cfg(struct stedma40_chan_cfg *cfg,
 	*dst_cfg = dst;
 }
 
-int d40_phy_fill_lli(struct d40_phy_lli *lli,
-		     dma_addr_t data,
-		     u32 data_size,
-		     int psize,
-		     dma_addr_t next_lli,
-		     u32 reg_cfg,
-		     bool term_int,
-		     u32 data_width,
-		     bool is_device)
+static int d40_phy_fill_lli(struct d40_phy_lli *lli,
+			    dma_addr_t data,
+			    u32 data_size,
+			    int psize,
+			    dma_addr_t next_lli,
+			    u32 reg_cfg,
+			    bool term_int,
+			    u32 data_width,
+			    bool is_device)
 {
 	int num_elems;
 
@@ -139,13 +139,6 @@ int d40_phy_fill_lli(struct d40_phy_lli *lli,
 	else
 		num_elems = 2 << psize;
 
-	/*
-	 * Size is 16bit. data_width is 8, 16, 32 or 64 bit
-	 * Block large than 64 KiB must be split.
-	 */
-	if (data_size > (0xffff << data_width))
-		return -EINVAL;
-
 	/* Must be aligned */
 	if (!IS_ALIGNED(data, 0x1 << data_width))
 		return -EINVAL;
@@ -187,55 +180,118 @@ int d40_phy_fill_lli(struct d40_phy_lli *lli,
 	return 0;
 }
 
+static int d40_seg_size(int size, int data_width1, int data_width2)
+{
+	u32 max_w = max(data_width1, data_width2);
+	u32 min_w = min(data_width1, data_width2);
+	u32 seg_max = ALIGN(STEDMA40_MAX_SEG_SIZE << min_w, 1 << max_w);
+
+	if (seg_max > STEDMA40_MAX_SEG_SIZE)
+		seg_max -= (1 << max_w);
+
+	if (size <= seg_max)
+		return size;
+
+	if (size <= 2 * seg_max)
+		return ALIGN(size / 2, 1 << max_w);
+
+	return seg_max;
+}
+
+struct d40_phy_lli *d40_phy_buf_to_lli(struct d40_phy_lli *lli,
+				       dma_addr_t addr,
+				       u32 size,
+				       int psize,
+				       dma_addr_t lli_phys,
+				       u32 reg_cfg,
+				       bool term_int,
+				       u32 data_width1,
+				       u32 data_width2,
+				       bool is_device)
+{
+	int err;
+	dma_addr_t next = lli_phys;
+	int size_rest = size;
+	int size_seg = 0;
+
+	do {
+		size_seg = d40_seg_size(size_rest, data_width1, data_width2);
+		size_rest -= size_seg;
+
+		if (term_int && size_rest == 0)
+			next = 0;
+		else
+			next = ALIGN(next + sizeof(struct d40_phy_lli),
+				     D40_LLI_ALIGN);
+
+		err = d40_phy_fill_lli(lli,
+				       addr,
+				       size_seg,
+				       psize,
+				       next,
+				       reg_cfg,
+				       !next,
+				       data_width1,
+				       is_device);
+
+		if (err)
+			goto err;
+
+		lli++;
+		if (!is_device)
+			addr += size_seg;
+	} while (size_rest);
+
+	return lli;
+
+ err:
+	return NULL;
+}
+
 int d40_phy_sg_to_lli(struct scatterlist *sg,
 		      int sg_len,
 		      dma_addr_t target,
-		      struct d40_phy_lli *lli,
+		      struct d40_phy_lli *lli_sg,
 		      dma_addr_t lli_phys,
 		      u32 reg_cfg,
-		      u32 data_width,
+		      u32 data_width1,
+		      u32 data_width2,
 		      int psize)
 {
 	int total_size = 0;
 	int i;
 	struct scatterlist *current_sg = sg;
-	dma_addr_t next_lli_phys;
 	dma_addr_t dst;
-	int err = 0;
+	struct d40_phy_lli *lli = lli_sg;
+	dma_addr_t l_phys = lli_phys;
 
 	for_each_sg(sg, current_sg, sg_len, i) {
 
 		total_size += sg_dma_len(current_sg);
 
-		/* If this scatter list entry is the last one, no next link */
-		if (sg_len - 1 == i)
-			next_lli_phys = 0;
-		else
-			next_lli_phys = ALIGN(lli_phys + (i + 1) *
-					      sizeof(struct d40_phy_lli),
-					      D40_LLI_ALIGN);
-
 		if (target)
 			dst = target;
 		else
 			dst = sg_phys(current_sg);
 
-		err = d40_phy_fill_lli(&lli[i],
-				       dst,
-				       sg_dma_len(current_sg),
-				       psize,
-				       next_lli_phys,
-				       reg_cfg,
-				       !next_lli_phys,
-				       data_width,
-				       target == dst);
-		if (err)
-			goto err;
+		l_phys = ALIGN(lli_phys + (lli - lli_sg) *
+			       sizeof(struct d40_phy_lli), D40_LLI_ALIGN);
+
+		lli = d40_phy_buf_to_lli(lli,
+					 dst,
+					 sg_dma_len(current_sg),
+					 psize,
+					 l_phys,
+					 reg_cfg,
+					 sg_len - 1 == i,
+					 data_width1,
+					 data_width2,
+					 target == dst);
+		if (lli == NULL)
+			return -EINVAL;
 	}
 
 	return total_size;
-err:
-	return err;
 }
 
 
@@ -315,17 +371,20 @@ void d40_log_lli_lcla_write(struct d40_log_lli *lcla,
 	writel(lli_dst->lcsp13, &lcla[1].lcsp13);
 }
 
-void d40_log_fill_lli(struct d40_log_lli *lli,
-		      dma_addr_t data, u32 data_size,
-		      u32 reg_cfg,
-		      u32 data_width,
-		      bool addr_inc)
+static void d40_log_fill_lli(struct d40_log_lli *lli,
+			     dma_addr_t data, u32 data_size,
+			     u32 reg_cfg,
+			     u32 data_width,
+			     bool addr_inc)
 {
 	lli->lcsp13 = reg_cfg;
 
 	/* The number of elements to transfer */
 	lli->lcsp02 = ((data_size >> data_width) <<
 		       D40_MEM_LCSP0_ECNT_POS) & D40_MEM_LCSP0_ECNT_MASK;
+
+	BUG_ON((data_size >> data_width) > STEDMA40_MAX_SEG_SIZE);
+
 	/* 16 LSBs address of the current element */
 	lli->lcsp02 |= data & D40_MEM_LCSP0_SPTR_MASK;
 	/* 16 MSBs address of the current element */
@@ -348,55 +407,94 @@ int d40_log_sg_to_dev(struct scatterlist *sg,
 	int total_size = 0;
 	struct scatterlist *current_sg = sg;
 	int i;
+	struct d40_log_lli *lli_src = lli->src;
+	struct d40_log_lli *lli_dst = lli->dst;
 
 	for_each_sg(sg, current_sg, sg_len, i) {
 		total_size += sg_dma_len(current_sg);
 
 		if (direction == DMA_TO_DEVICE) {
-			d40_log_fill_lli(&lli->src[i],
-					 sg_phys(current_sg),
-					 sg_dma_len(current_sg),
-					 lcsp->lcsp1, src_data_width,
-					 true);
-			d40_log_fill_lli(&lli->dst[i],
-					 dev_addr,
-					 sg_dma_len(current_sg),
-					 lcsp->lcsp3, dst_data_width,
-					 false);
+			lli_src =
+				d40_log_buf_to_lli(lli_src,
+						   sg_phys(current_sg),
+						   sg_dma_len(current_sg),
+						   lcsp->lcsp1, src_data_width,
+						   dst_data_width,
+						   true);
+			lli_dst =
+				d40_log_buf_to_lli(lli_dst,
+						   dev_addr,
+						   sg_dma_len(current_sg),
+						   lcsp->lcsp3, dst_data_width,
+						   src_data_width,
+						   false);
 		} else {
-			d40_log_fill_lli(&lli->dst[i],
-					 sg_phys(current_sg),
-					 sg_dma_len(current_sg),
-					 lcsp->lcsp3, dst_data_width,
-					 true);
-			d40_log_fill_lli(&lli->src[i],
-					 dev_addr,
-					 sg_dma_len(current_sg),
-					 lcsp->lcsp1, src_data_width,
-					 false);
+			lli_dst =
+				d40_log_buf_to_lli(lli_dst,
+						   sg_phys(current_sg),
+						   sg_dma_len(current_sg),
+						   lcsp->lcsp3, dst_data_width,
+						   src_data_width,
+						   true);
+			lli_src =
+				d40_log_buf_to_lli(lli_src,
+						   dev_addr,
+						   sg_dma_len(current_sg),
+						   lcsp->lcsp1, src_data_width,
+						   dst_data_width,
+						   false);
 		}
 	}
 	return total_size;
 }
 
+struct d40_log_lli *d40_log_buf_to_lli(struct d40_log_lli *lli_sg,
+				       dma_addr_t addr,
+				       int size,
+				       u32 lcsp13, /* src or dst*/
+				       u32 data_width1,
+				       u32 data_width2,
+				       bool addr_inc)
+{
+	struct d40_log_lli *lli = lli_sg;
+	int size_rest = size;
+	int size_seg = 0;
+
+	do {
+		size_seg = d40_seg_size(size_rest, data_width1, data_width2);
+		size_rest -= size_seg;
+
+		d40_log_fill_lli(lli,
+				 addr,
+				 size_seg,
+				 lcsp13, data_width1,
+				 addr_inc);
+		if (addr_inc)
+			addr += size_seg;
+		lli++;
+	} while (size_rest);
+
+	return lli;
+}
+
 int d40_log_sg_to_lli(struct scatterlist *sg,
 		      int sg_len,
 		      struct d40_log_lli *lli_sg,
 		      u32 lcsp13, /* src or dst*/
-		      u32 data_width)
+		      u32 data_width1, u32 data_width2)
 {
 	int total_size = 0;
 	struct scatterlist *current_sg = sg;
 	int i;
+	struct d40_log_lli *lli = lli_sg;
 
 	for_each_sg(sg, current_sg, sg_len, i) {
 		total_size += sg_dma_len(current_sg);
-
-		d40_log_fill_lli(&lli_sg[i],
-				 sg_phys(current_sg),
-				 sg_dma_len(current_sg),
-				 lcsp13, data_width,
-				 true);
+		lli = d40_log_buf_to_lli(lli,
+					 sg_phys(current_sg),
+					 sg_dma_len(current_sg),
+					 lcsp13,
+					 data_width1, data_width2, true);
 	}
 	return total_size;
 }
diff --git a/drivers/dma/ste_dma40_ll.h b/drivers/dma/ste_dma40_ll.h
index 9e419b9..9cc4349 100644
--- a/drivers/dma/ste_dma40_ll.h
+++ b/drivers/dma/ste_dma40_ll.h
@@ -292,18 +292,20 @@ int d40_phy_sg_to_lli(struct scatterlist *sg,
 		      struct d40_phy_lli *lli,
 		      dma_addr_t lli_phys,
 		      u32 reg_cfg,
-		      u32 data_width,
+		      u32 data_width1,
+		      u32 data_width2,
 		      int psize);
 
-int d40_phy_fill_lli(struct d40_phy_lli *lli,
-		     dma_addr_t data,
-		     u32 data_size,
-		     int psize,
-		     dma_addr_t next_lli,
-		     u32 reg_cfg,
-		     bool term_int,
-		     u32 data_width,
-		     bool is_device);
+struct d40_phy_lli *d40_phy_buf_to_lli(struct d40_phy_lli *lli,
+				       dma_addr_t data,
+				       u32 data_size,
+				       int psize,
+				       dma_addr_t next_lli,
+				       u32 reg_cfg,
+				       bool term_int,
+				       u32 data_width1,
+				       u32 data_width2,
+				       bool is_device);
 
 void d40_phy_lli_write(void __iomem *virtbase,
 		       u32 phy_chan_num,
@@ -312,12 +314,12 @@ void d40_phy_lli_write(void __iomem *virtbase,
 
 /* Logical channels */
 
-void d40_log_fill_lli(struct d40_log_lli *lli,
-		      dma_addr_t data,
-		      u32 data_size,
-		      u32 reg_cfg,
-		      u32 data_width,
-		      bool addr_inc);
+struct d40_log_lli *d40_log_buf_to_lli(struct d40_log_lli *lli_sg,
+				       dma_addr_t addr,
+				       int size,
+				       u32 lcsp13, /* src or dst*/
+				       u32 data_width1, u32 data_width2,
+				       bool addr_inc);
 
 int d40_log_sg_to_dev(struct scatterlist *sg,
 		      int sg_len,
@@ -332,7 +334,7 @@ int d40_log_sg_to_lli(struct scatterlist *sg,
 		      int sg_len,
 		      struct d40_log_lli *lli_sg,
 		      u32 lcsp13, /* src or dst*/
-		      u32 data_width);
+		      u32 data_width1, u32 data_width2);
 
 void d40_log_lli_lcpa_write(struct d40_log_lli_full *lcpa,
 			    struct d40_log_lli *lli_dst,
-- 
1.6.3.3

