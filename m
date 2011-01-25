Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab1AYKVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:21:33 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:41029 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753454Ab1AYKTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:19:49 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 27/32] dma40: use flags to reduce parameter count
Date: Tue, 25 Jan 2011 11:18:30 +0100
Message-ID: <1295950715-22340-28-git-send-email-linus.walleij@stericsson.com>
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
 drivers/dma/ste_dma40_ll.c |   84 ++++++++++++++++++++++++-------------------
 drivers/dma/ste_dma40_ll.h |    5 +++
 2 files changed, 52 insertions(+), 37 deletions(-)

diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
index 876aad2..88b9e37 100644
--- a/drivers/dma/ste_dma40_ll.c
+++ b/drivers/dma/ste_dma40_ll.c
@@ -127,10 +127,11 @@ static int d40_phy_fill_lli(struct d40_phy_lli *lli,
 			    u32 data_size,
 			    dma_addr_t next_lli,
 			    u32 reg_cfg,
-			    bool term_int,
-			    bool is_device,
-			    struct stedma40_half_channel_info *info)
+			    struct stedma40_half_channel_info *info,
+			    unsigned int flags)
 {
+	bool addr_inc = flags & LLI_ADDR_INC;
+	bool term_int = flags & LLI_TERM_INT;
 	unsigned int data_width = info->data_width;
 	int psize = info->psize;
 	int num_elems;
@@ -155,7 +156,7 @@ static int d40_phy_fill_lli(struct d40_phy_lli *lli,
 	 * Distance to next element sized entry.
 	 * Usually the size of the element unless you want gaps.
 	 */
-	if (!is_device)
+	if (addr_inc)
 		lli->reg_elt |= (0x1 << data_width) <<
 			D40_SREG_ELEM_PHY_EIDX_POS;
 
@@ -201,40 +202,45 @@ static int d40_seg_size(int size, int data_width1, int data_width2)
 
 static struct d40_phy_lli *
 d40_phy_buf_to_lli(struct d40_phy_lli *lli, dma_addr_t addr, u32 size,
-		   dma_addr_t lli_phys, u32 reg_cfg, bool term_int,
-		   bool is_device, struct stedma40_half_channel_info *info,
-		   struct stedma40_half_channel_info *otherinfo)
+		   dma_addr_t lli_phys, u32 reg_cfg,
+		   struct stedma40_half_channel_info *info,
+		   struct stedma40_half_channel_info *otherinfo,
+		   unsigned long flags)
 {
+	bool addr_inc = flags & LLI_ADDR_INC;
+	bool term_int = flags & LLI_TERM_INT;
 	int err;
 	dma_addr_t next = lli_phys;
 	int size_rest = size;
 	int size_seg = 0;
 
+	/*
+	 * This piece may be split up based on d40_seg_size(); we only want the
+	 * term int on the last part.
+	 */
+	if (term_int)
+		flags &= ~LLI_TERM_INT;
+
 	do {
 		size_seg = d40_seg_size(size_rest, info->data_width,
 					otherinfo->data_width);
 		size_rest -= size_seg;
 
-		if (term_int && size_rest == 0)
+		if (term_int && size_rest == 0) {
 			next = 0;
-		else
+			flags |= LLI_TERM_INT;
+		} else
 			next = ALIGN(next + sizeof(struct d40_phy_lli),
 				     D40_LLI_ALIGN);
 
-		err = d40_phy_fill_lli(lli,
-				       addr,
-				       size_seg,
-				       next,
-				       reg_cfg,
-				       !next,
-				       is_device,
-				       info);
+		err = d40_phy_fill_lli(lli, addr, size_seg, next,
+				       reg_cfg, info, flags);
 
 		if (err)
 			goto err;
 
 		lli++;
-		if (!is_device)
+		if (addr_inc)
 			addr += size_seg;
 	} while (size_rest);
 
@@ -256,31 +262,29 @@ int d40_phy_sg_to_lli(struct scatterlist *sg,
 	int total_size = 0;
 	int i;
 	struct scatterlist *current_sg = sg;
-	dma_addr_t dst;
 	struct d40_phy_lli *lli = lli_sg;
 	dma_addr_t l_phys = lli_phys;
+	unsigned long flags = 0;
+
+	if (!target)
+		flags |= LLI_ADDR_INC;
 
 	for_each_sg(sg, current_sg, sg_len, i) {
+		dma_addr_t sg_addr = sg_dma_address(current_sg);
+		unsigned int len = sg_dma_len(current_sg);
+		dma_addr_t dst = target ?: sg_addr;
 
 		total_size += sg_dma_len(current_sg);
 
-		if (target)
-			dst = target;
-		else
-			dst = sg_dma_address(current_sg);
+		if (i == sg_len - 1)
+			flags |= LLI_TERM_INT;
 
 		l_phys = ALIGN(lli_phys + (lli - lli_sg) *
 			       sizeof(struct d40_phy_lli), D40_LLI_ALIGN);
 
-		lli = d40_phy_buf_to_lli(lli,
-					 dst,
-					 sg_dma_len(current_sg),
-					 l_phys,
-					 reg_cfg,
-					 sg_len - 1 == i,
-					 target == dst,
-					 info,
-					 otherinfo);
+		lli = d40_phy_buf_to_lli(lli, dst, len, l_phys,
+					 reg_cfg, info, otherinfo, flags);
+
 		if (lli == NULL)
 			return -EINVAL;
 	}
@@ -343,8 +347,10 @@ static void d40_log_fill_lli(struct d40_log_lli *lli,
 			     dma_addr_t data, u32 data_size,
 			     u32 reg_cfg,
 			     u32 data_width,
-			     bool addr_inc)
+			     unsigned int flags)
 {
+	bool addr_inc = flags & LLI_ADDR_INC;
+
 	lli->lcsp13 = reg_cfg;
 
 	/* The number of elements to transfer */
@@ -369,8 +375,9 @@ static struct d40_log_lli *d40_log_buf_to_lli(struct d40_log_lli *lli_sg,
 				       u32 lcsp13, /* src or dst*/
 				       u32 data_width1,
 				       u32 data_width2,
-				       bool addr_inc)
+				       unsigned int flags)
 {
+	bool addr_inc = flags & LLI_ADDR_INC;
 	struct d40_log_lli *lli = lli_sg;
 	int size_rest = size;
 	int size_seg = 0;
@@ -383,7 +390,7 @@ static struct d40_log_lli *d40_log_buf_to_lli(struct d40_log_lli *lli_sg,
 				 addr,
 				 size_seg,
 				 lcsp13, data_width1,
-				 addr_inc);
+				 flags);
 		if (addr_inc)
 			addr += size_seg;
 		lli++;
@@ -403,7 +410,10 @@ int d40_log_sg_to_lli(struct scatterlist *sg,
 	struct scatterlist *current_sg = sg;
 	int i;
 	struct d40_log_lli *lli = lli_sg;
-	bool autoinc = !dev_addr;
+	unsigned long flags = 0;
+
+	if (!dev_addr)
+		flags |= LLI_ADDR_INC;
 
 	for_each_sg(sg, current_sg, sg_len, i) {
 		dma_addr_t sg_addr = sg_dma_address(current_sg);
@@ -416,7 +426,7 @@ int d40_log_sg_to_lli(struct scatterlist *sg,
 					 lcsp13,
 					 data_width1,
 					 data_width2,
-					 autoinc);
+					 flags);
 	}
 
 	return total_size;
diff --git a/drivers/dma/ste_dma40_ll.h b/drivers/dma/ste_dma40_ll.h
index 4626c88..59e72f0 100644
--- a/drivers/dma/ste_dma40_ll.h
+++ b/drivers/dma/ste_dma40_ll.h
@@ -293,6 +293,11 @@ struct d40_def_lcsp {
 
 /* Physical channels */
 
+enum d40_lli_flags {
+	LLI_ADDR_INC	= 1 << 0,
+	LLI_TERM_INT	= 1 << 1,
+};
+
 void d40_phy_cfg(struct stedma40_chan_cfg *cfg,
 		 u32 *src_cfg,
 		 u32 *dst_cfg,
-- 
1.7.3.2

