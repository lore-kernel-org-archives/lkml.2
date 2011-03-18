Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932898Ab1CRWAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 18:00:20 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28903 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932889Ab1CRWAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 18:00:02 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6289"; a="80850625"
X-IronPort-AV: E=Sophos;i="4.63,205,1299484800"; 
   d="scan'208";a="37045096"
From: Carl Vanderlip <carlv@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>, linux-fbdev@vger.kernel.org,
        Carl Vanderlip <carlv@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 19/20] video: msm: Separate calculation of base and offset
Date: Fri, 18 Mar 2011 14:59:59 -0700
Message-Id: <1300485599-27680-1-git-send-email-carlv@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separating the calculation of base and offset for luma and chroma allows
for easier specialization for HW targets.

Authors:
Dima Zavin <dima@android.com>
Rebecca Schultz Zavin <rebecca@android.com>
Colin Cross <ccross@android.com>

Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>
---
 drivers/video/msm/mdp_ppp.c |   56 ++++++++++++++++++++++--------------------
 1 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/drivers/video/msm/mdp_ppp.c b/drivers/video/msm/mdp_ppp.c
index 290c29a..6d14c4f 100644
--- a/drivers/video/msm/mdp_ppp.c
+++ b/drivers/video/msm/mdp_ppp.c
@@ -100,6 +100,17 @@ static void rotate_dst_addr_y(struct mdp_blit_req *req,
 		       regs->dst_ystride;
 }
 
+static uint32_t get_luma_offset(struct mdp_img *img,
+				struct mdp_rect *rect, uint32_t bpp)
+{
+	return 0;
+}
+
+static uint32_t get_chroma_offset(struct mdp_img *img,
+				  struct mdp_rect *rect, uint32_t bpp)
+{
+	return 0;
+}
 static void blit_rotate(struct mdp_blit_req *req,
 			struct ppp_regs *regs)
 {
@@ -311,24 +322,14 @@ static void flush_imgs(struct mdp_blit_req *req, struct ppp_regs *regs,
 {
 }
 
-static void get_chroma_addr(struct mdp_img *img, struct mdp_rect *rect,
-			    uint32_t base, uint32_t bpp, uint32_t cfg,
-			    uint32_t *addr, uint32_t *ystride)
+static uint32_t get_chroma_base(struct mdp_img *img, uint32_t base,
+				uint32_t bpp)
 {
-	uint32_t compress_v = Y_TO_CRCB_RATIO(img->format);
-	uint32_t compress_h = 2;
-	uint32_t  offset;
-
-	if (IS_PSEUDOPLNR(img->format)) {
-		offset = (rect->x / compress_h) * compress_h;
-		offset += rect->y == 0 ? 0 :
-			  ((rect->y + 1) / compress_v) * img->width;
-		*addr = base + (img->width * img->height * bpp);
-		*addr += offset * bpp;
-		*ystride |= *ystride << 16;
-	} else {
-		*addr = 0;
-	}
+	uint32_t addr = 0;
+
+	if (IS_PSEUDOPLNR(img->format))
+		addr = base + (img->width * img->height * bpp);
+	return addr;
 }
 
 #define mdp_writel_dbg(mdp, val, reg) mdp_writel((mdp), (val), (reg))
@@ -381,6 +382,7 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 		 struct file *dst_file, unsigned long dst_start, unsigned long dst_len)
 {
 	struct ppp_regs regs = {0};
+	uint32_t luma_base;
 
 	if (unlikely(req->src.format >= MDP_IMGTYPE_LIMIT ||
 		     req->dst.format >= MDP_IMGTYPE_LIMIT)) {
@@ -416,23 +418,23 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 
 	/* set src, bpp, start pixel and ystride */
 	regs.src_bpp = bytes_per_pixel[req->src.format];
-	regs.src0 = src_start + req->src.offset;
+	luma_base = src_start + req->src.offset;
+	regs.src0 = luma_base +
+		get_luma_offset(&req->src, &req->src_rect, regs.src_bpp);
+	regs.src1 = get_chroma_base(&req->src, luma_base, regs.src_bpp);
+	regs.src1 += get_chroma_offset(&req->src, &req->src_rect, regs.src_bpp);
 	regs.src_ystride = req->src.width * regs.src_bpp;
 	set_src_region(&req->src, &req->src_rect, &regs);
-	get_chroma_addr(&req->src, &req->src_rect, regs.src0, regs.src_bpp,
-			regs.src_cfg, &regs.src1, &regs.src_ystride);
-	regs.src0 += (req->src_rect.x + (req->src_rect.y * req->src.width)) *
-		      regs.src_bpp;
 
 	/* set dst, bpp, start pixel and ystride */
 	regs.dst_bpp = bytes_per_pixel[req->dst.format];
-	regs.dst0 = dst_start + req->dst.offset;
+	luma_base = dst_start + req->dst.offset;
+	regs.dst0 = luma_base +
+		get_luma_offset(&req->dst, &req->dst_rect, regs.dst_bpp);
+	regs.dst1 = get_chroma_base(&req->dst, luma_base, regs.dst_bpp);
+	regs.dst1 += get_chroma_offset(&req->dst, &req->dst_rect, regs.dst_bpp);
 	regs.dst_ystride = req->dst.width * regs.dst_bpp;
 	set_dst_region(&req->dst_rect, &regs);
-	get_chroma_addr(&req->dst, &req->dst_rect, regs.dst0, regs.dst_bpp,
-			regs.dst_cfg, &regs.dst1, &regs.dst_ystride);
-	regs.dst0 += (req->dst_rect.x + (req->dst_rect.y * req->dst.width)) *
-		      regs.dst_bpp;
 
 	if (!valid_src_dst(src_start, src_len, dst_start, dst_len, req,
 			   &regs)) {
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

