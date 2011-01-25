Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab1AYKTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:19:44 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:46708 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753395Ab1AYKTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:19:42 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 23/32] dma40: unify d40_log_sg_to_lli funcs for mem and slave
Date: Tue, 25 Jan 2011 11:18:26 +0100
Message-ID: <1295950715-22340-24-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
References: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

Acked-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c    |   45 ++++++++++++-------------------
 drivers/dma/ste_dma40_ll.c |   63 ++++++++-----------------------------------
 drivers/dma/ste_dma40_ll.h |   10 +------
 3 files changed, 31 insertions(+), 87 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 6a7a00d..c597dba 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1638,37 +1638,28 @@ d40_prep_sg_log(struct d40_chan *chan, struct d40_desc *desc,
 		unsigned int sg_len, enum dma_data_direction direction,
 		dma_addr_t dev_addr)
 {
+	dma_addr_t src_dev_addr = direction == DMA_FROM_DEVICE ? dev_addr : 0;
+	dma_addr_t dst_dev_addr = direction == DMA_TO_DEVICE ? dev_addr : 0;
 	struct stedma40_chan_cfg *cfg = &chan->dma_cfg;
 	struct stedma40_half_channel_info *src_info = &cfg->src_info;
 	struct stedma40_half_channel_info *dst_info = &cfg->dst_info;
+	int ret;
 
-	if (direction == DMA_NONE) {
-		/* memcpy */
-		(void) d40_log_sg_to_lli(sg_src, sg_len,
-					 desc->lli_log.src,
-					 chan->log_def.lcsp1,
-					 src_info->data_width,
-					 dst_info->data_width);
-
-		(void) d40_log_sg_to_lli(sg_dst, sg_len,
-					 desc->lli_log.dst,
-					 chan->log_def.lcsp3,
-					 dst_info->data_width,
-					 src_info->data_width);
-	} else {
-		unsigned int total_size;
+	ret = d40_log_sg_to_lli(sg_src, sg_len,
+				src_dev_addr,
+				desc->lli_log.src,
+				chan->log_def.lcsp1,
+				src_info->data_width,
+				dst_info->data_width);
 
-		total_size = d40_log_sg_to_dev(sg_src, sg_len,
-					       &desc->lli_log,
-					       &chan->log_def,
-					       src_info->data_width,
-					       dst_info->data_width,
-					       direction, dev_addr);
-		if (total_size < 0)
-			return -EINVAL;
-	}
+	ret = d40_log_sg_to_lli(sg_dst, sg_len,
+				dst_dev_addr,
+				desc->lli_log.dst,
+				chan->log_def.lcsp3,
+				dst_info->data_width,
+				src_info->data_width);
 
-	return 0;
+	return ret < 0 ? ret : 0;
 }
 
 static int
diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
index fa6c3ab..9935c6d 100644
--- a/drivers/dma/ste_dma40_ll.c
+++ b/drivers/dma/ste_dma40_ll.c
@@ -369,53 +369,6 @@ static void d40_log_fill_lli(struct d40_log_lli *lli,
 
 }
 
-int d40_log_sg_to_dev(struct scatterlist *sg,
-		      int sg_len,
-		      struct d40_log_lli_bidir *lli,
-		      struct d40_def_lcsp *lcsp,
-		      u32 src_data_width,
-		      u32 dst_data_width,
-		      enum dma_data_direction direction,
-		      dma_addr_t dev_addr)
-{
-	int total_size = 0;
-	struct scatterlist *current_sg = sg;
-	int i;
-	struct d40_log_lli *lli_src = lli->src;
-	struct d40_log_lli *lli_dst = lli->dst;
-
-	for_each_sg(sg, current_sg, sg_len, i) {
-		dma_addr_t sg_addr = sg_dma_address(current_sg);
-		unsigned int len = sg_dma_len(current_sg);
-		dma_addr_t src;
-		dma_addr_t dst;
-
-		total_size += len;
-
-		if (direction == DMA_TO_DEVICE) {
-			src = sg_addr;
-			dst = dev_addr;
-		} else {
-			src = dev_addr;
-			dst = sg_addr;
-		}
-
-		lli_src = d40_log_buf_to_lli(lli_src, src, len,
-					     lcsp->lcsp1,
-					     src_data_width,
-					     dst_data_width,
-					     src == sg_addr);
-
-		lli_dst = d40_log_buf_to_lli(lli_dst, dst, len,
-					     lcsp->lcsp3,
-					     dst_data_width,
-					     src_data_width,
-					     dst == sg_addr);
-	}
-
-	return total_size;
-}
-
 struct d40_log_lli *d40_log_buf_to_lli(struct d40_log_lli *lli_sg,
 				       dma_addr_t addr,
 				       int size,
@@ -447,6 +400,7 @@ struct d40_log_lli *d40_log_buf_to_lli(struct d40_log_lli *lli_sg,
 
 int d40_log_sg_to_lli(struct scatterlist *sg,
 		      int sg_len,
+		      dma_addr_t dev_addr,
 		      struct d40_log_lli *lli_sg,
 		      u32 lcsp13, /* src or dst*/
 		      u32 data_width1, u32 data_width2)
@@ -455,14 +409,21 @@ int d40_log_sg_to_lli(struct scatterlist *sg,
 	struct scatterlist *current_sg = sg;
 	int i;
 	struct d40_log_lli *lli = lli_sg;
+	bool autoinc = !dev_addr;
 
 	for_each_sg(sg, current_sg, sg_len, i) {
+		dma_addr_t sg_addr = sg_dma_address(current_sg);
+		unsigned int len = sg_dma_len(current_sg);
+		dma_addr_t addr = dev_addr ?: sg_addr;
+
 		total_size += sg_dma_len(current_sg);
-		lli = d40_log_buf_to_lli(lli,
-					 sg_dma_address(current_sg),
-					 sg_dma_len(current_sg),
+
+		lli = d40_log_buf_to_lli(lli, addr, len,
 					 lcsp13,
-					 data_width1, data_width2, true);
+					 data_width1,
+					 data_width2,
+					 autoinc);
 	}
+
 	return total_size;
 }
diff --git a/drivers/dma/ste_dma40_ll.h b/drivers/dma/ste_dma40_ll.h
index 46578a66..867f23f 100644
--- a/drivers/dma/ste_dma40_ll.h
+++ b/drivers/dma/ste_dma40_ll.h
@@ -321,17 +321,9 @@ struct d40_log_lli *d40_log_buf_to_lli(struct d40_log_lli *lli_sg,
 				       u32 data_width1, u32 data_width2,
 				       bool addr_inc);
 
-int d40_log_sg_to_dev(struct scatterlist *sg,
-		      int sg_len,
-		      struct d40_log_lli_bidir *lli,
-		      struct d40_def_lcsp *lcsp,
-		      u32 src_data_width,
-		      u32 dst_data_width,
-		      enum dma_data_direction direction,
-		      dma_addr_t dev_addr);
-
 int d40_log_sg_to_lli(struct scatterlist *sg,
 		      int sg_len,
+		      dma_addr_t dev_addr,
 		      struct d40_log_lli *lli_sg,
 		      u32 lcsp13, /* src or dst*/
 		      u32 data_width1, u32 data_width2);
-- 
1.7.3.2

