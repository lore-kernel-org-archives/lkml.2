Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab1AYKVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:21:35 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:52344 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753450Ab1AYKTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:19:49 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 24/32] dma40: pass the info pointer all the way to reduce argument count
Date: Tue, 25 Jan 2011 11:18:27 +0100
Message-ID: <1295950715-22340-25-git-send-email-linus.walleij@stericsson.com>
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
 drivers/dma/ste_dma40.c    |    8 ++------
 drivers/dma/ste_dma40_ll.c |   42 ++++++++++++++++++------------------------
 drivers/dma/ste_dma40_ll.h |    5 ++---
 3 files changed, 22 insertions(+), 33 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index c597dba..3c61c58 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1679,17 +1679,13 @@ d40_prep_sg_phy(struct d40_chan *chan, struct d40_desc *desc,
 				desc->lli_phy.src,
 				virt_to_phys(desc->lli_phy.src),
 				chan->src_def_cfg,
-				src_info->data_width,
-				dst_info->data_width,
-				src_info->psize);
+				src_info, dst_info);
 
 	ret = d40_phy_sg_to_lli(sg_dst, sg_len, dst_dev_addr,
 				desc->lli_phy.dst,
 				virt_to_phys(desc->lli_phy.dst),
 				chan->dst_def_cfg,
-				dst_info->data_width,
-				src_info->data_width,
-				dst_info->psize);
+				dst_info, src_info);
 
 	dma_sync_single_for_device(chan->base->dev, desc->lli_pool.dma_addr,
 				   desc->lli_pool.size, DMA_TO_DEVICE);
diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
index 9935c6d..509a130 100644
--- a/drivers/dma/ste_dma40_ll.c
+++ b/drivers/dma/ste_dma40_ll.c
@@ -125,13 +125,14 @@ void d40_phy_cfg(struct stedma40_chan_cfg *cfg,
 static int d40_phy_fill_lli(struct d40_phy_lli *lli,
 			    dma_addr_t data,
 			    u32 data_size,
-			    int psize,
 			    dma_addr_t next_lli,
 			    u32 reg_cfg,
 			    bool term_int,
-			    u32 data_width,
-			    bool is_device)
+			    bool is_device,
+			    struct stedma40_half_channel_info *info)
 {
+	unsigned int data_width = info->data_width;
+	int psize = info->psize;
 	int num_elems;
 
 	if (psize == STEDMA40_PSIZE_PHY_1)
@@ -198,16 +199,11 @@ static int d40_seg_size(int size, int data_width1, int data_width2)
 	return seg_max;
 }
 
-static struct d40_phy_lli *d40_phy_buf_to_lli(struct d40_phy_lli *lli,
-				       dma_addr_t addr,
-				       u32 size,
-				       int psize,
-				       dma_addr_t lli_phys,
-				       u32 reg_cfg,
-				       bool term_int,
-				       u32 data_width1,
-				       u32 data_width2,
-				       bool is_device)
+static struct d40_phy_lli *
+d40_phy_buf_to_lli(struct d40_phy_lli *lli, dma_addr_t addr, u32 size,
+		   dma_addr_t lli_phys, u32 reg_cfg, bool term_int,
+		   bool is_device, struct stedma40_half_channel_info *info,
+		   struct stedma40_half_channel_info *otherinfo)
 {
 	int err;
 	dma_addr_t next = lli_phys;
@@ -215,7 +211,8 @@ static struct d40_phy_lli *d40_phy_buf_to_lli(struct d40_phy_lli *lli,
 	int size_seg = 0;
 
 	do {
-		size_seg = d40_seg_size(size_rest, data_width1, data_width2);
+		size_seg = d40_seg_size(size_rest, info->data_width,
+					otherinfo->data_width);
 		size_rest -= size_seg;
 
 		if (term_int && size_rest == 0)
@@ -227,12 +224,11 @@ static struct d40_phy_lli *d40_phy_buf_to_lli(struct d40_phy_lli *lli,
 		err = d40_phy_fill_lli(lli,
 				       addr,
 				       size_seg,
-				       psize,
 				       next,
 				       reg_cfg,
 				       !next,
-				       data_width1,
-				       is_device);
+				       is_device,
+				       info);
 
 		if (err)
 			goto err;
@@ -254,9 +250,8 @@ int d40_phy_sg_to_lli(struct scatterlist *sg,
 		      struct d40_phy_lli *lli_sg,
 		      dma_addr_t lli_phys,
 		      u32 reg_cfg,
-		      u32 data_width1,
-		      u32 data_width2,
-		      int psize)
+		      struct stedma40_half_channel_info *info,
+		      struct stedma40_half_channel_info *otherinfo)
 {
 	int total_size = 0;
 	int i;
@@ -280,13 +275,12 @@ int d40_phy_sg_to_lli(struct scatterlist *sg,
 		lli = d40_phy_buf_to_lli(lli,
 					 dst,
 					 sg_dma_len(current_sg),
-					 psize,
 					 l_phys,
 					 reg_cfg,
 					 sg_len - 1 == i,
-					 data_width1,
-					 data_width2,
-					 target == dst);
+					 target == dst,
+					 info,
+					 otherinfo);
 		if (lli == NULL)
 			return -EINVAL;
 	}
diff --git a/drivers/dma/ste_dma40_ll.h b/drivers/dma/ste_dma40_ll.h
index 867f23f..cd94afd 100644
--- a/drivers/dma/ste_dma40_ll.h
+++ b/drivers/dma/ste_dma40_ll.h
@@ -308,9 +308,8 @@ int d40_phy_sg_to_lli(struct scatterlist *sg,
 		      struct d40_phy_lli *lli,
 		      dma_addr_t lli_phys,
 		      u32 reg_cfg,
-		      u32 data_width1,
-		      u32 data_width2,
-		      int psize);
+		      struct stedma40_half_channel_info *info,
+		      struct stedma40_half_channel_info *otherinfo);
 
 /* Logical channels */
 
-- 
1.7.3.2

