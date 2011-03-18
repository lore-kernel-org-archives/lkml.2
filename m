Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797Ab1CRV4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:56:54 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17737 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932760Ab1CRV4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:56:49 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6289"; a="80849999"
X-IronPort-AV: E=Sophos;i="4.63,205,1299484800"; 
   d="scan'208";a="37044861"
From: Carl Vanderlip <carlv@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>, linux-fbdev@vger.kernel.org,
        Carl Vanderlip <carlv@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/20] video: msm: Refactor mdp_regs
Date: Fri, 18 Mar 2011 14:56:44 -0700
Message-Id: <1300485404-27241-1-git-send-email-carlv@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To begin splitting hw specific PPP operations into different files,
the mdp_regs struct will be moved into a new generic header file
for PPP operations.

Authors:
Dima Zavin <dima@android.com>
Rebecca Schultz Zavin <rebecca@android.com>
Colin Cross <ccross@android.com>

Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>
---
 drivers/video/msm/mdp_ppp.c |   49 +++++++++++++-----------------------------
 drivers/video/msm/mdp_ppp.h |   50 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+), 34 deletions(-)
 create mode 100644 drivers/video/msm/mdp_ppp.h

diff --git a/drivers/video/msm/mdp_ppp.c b/drivers/video/msm/mdp_ppp.c
index 2b04027..05f3e33 100644
--- a/drivers/video/msm/mdp_ppp.c
+++ b/drivers/video/msm/mdp_ppp.c
@@ -19,6 +19,7 @@
 #include <mach/msm_fb.h>
 
 #include "mdp_hw.h"
+#include "mdp_ppp.h"
 #include "mdp_scale_tables.h"
 
 #define DLOG(x...) do {} while (0)
@@ -27,28 +28,6 @@
 static int downscale_y_table = MDP_DOWNSCALE_MAX;
 static int downscale_x_table = MDP_DOWNSCALE_MAX;
 
-struct mdp_regs {
-	uint32_t src0;
-	uint32_t src1;
-	uint32_t dst0;
-	uint32_t dst1;
-	uint32_t src_cfg;
-	uint32_t dst_cfg;
-	uint32_t src_pack;
-	uint32_t dst_pack;
-	uint32_t src_rect;
-	uint32_t dst_rect;
-	uint32_t src_ystride;
-	uint32_t dst_ystride;
-	uint32_t op;
-	uint32_t src_bpp;
-	uint32_t dst_bpp;
-	uint32_t edge;
-	uint32_t phasex_init;
-	uint32_t phasey_init;
-	uint32_t phasex_step;
-	uint32_t phasey_step;
-};
 
 static uint32_t pack_pattern[] = {
 	PPP_ARRAY0(PACK_PATTERN)
@@ -88,7 +67,8 @@ static uint32_t bg_op_chroma[] = {
 	PPP_ARRAY1(CHROMA_SAMP, BG)
 };
 
-static void rotate_dst_addr_x(struct mdp_blit_req *req, struct mdp_regs *regs)
+static void rotate_dst_addr_x(struct mdp_blit_req *req,
+			      struct ppp_regs *regs)
 {
 	regs->dst0 += (req->dst_rect.w -
 		       min((uint32_t)16, req->dst_rect.w)) * regs->dst_bpp;
@@ -96,7 +76,8 @@ static void rotate_dst_addr_x(struct mdp_blit_req *req, struct mdp_regs *regs)
 		       min((uint32_t)16, req->dst_rect.w)) * regs->dst_bpp;
 }
 
-static void rotate_dst_addr_y(struct mdp_blit_req *req, struct mdp_regs *regs)
+static void rotate_dst_addr_y(struct mdp_blit_req *req,
+			      struct ppp_regs *regs)
 {
 	regs->dst0 += (req->dst_rect.h -
 		       min((uint32_t)16, req->dst_rect.h)) *
@@ -107,7 +88,7 @@ static void rotate_dst_addr_y(struct mdp_blit_req *req, struct mdp_regs *regs)
 }
 
 static void blit_rotate(struct mdp_blit_req *req,
-			struct mdp_regs *regs)
+			struct ppp_regs *regs)
 {
 	if (req->flags == MDP_ROT_NOP)
 		return;
@@ -126,7 +107,7 @@ static void blit_rotate(struct mdp_blit_req *req,
 		regs->op |= PPP_OP_FLIP_LR;
 }
 
-static void blit_convert(struct mdp_blit_req *req, struct mdp_regs *regs)
+static void blit_convert(struct mdp_blit_req *req, struct ppp_regs *regs)
 {
 	if (req->src.format == req->dst.format)
 		return;
@@ -165,7 +146,7 @@ static uint32_t transp_convert(struct mdp_blit_req *req)
 }
 #undef GET_BIT_RANGE
 
-static void blit_blend(struct mdp_blit_req *req, struct mdp_regs *regs)
+static void blit_blend(struct mdp_blit_req *req, struct ppp_regs *regs)
 {
 	/* TRANSP BLEND */
 	if (req->transp_mask != MDP_TRANSP_NOP) {
@@ -332,7 +313,7 @@ static void get_edge_info(uint32_t src, uint32_t src_coord, uint32_t dst,
 	*interp2 += src_coord;
 }
 
-static int get_edge_cond(struct mdp_blit_req *req, struct mdp_regs *regs)
+static int get_edge_cond(struct mdp_blit_req *req, struct ppp_regs *regs)
 {
 	int32_t luma_interp[4];
 	int32_t luma_repeat[4];
@@ -432,7 +413,7 @@ static int get_edge_cond(struct mdp_blit_req *req, struct mdp_regs *regs)
 }
 
 static int blit_scale(const struct mdp_info *mdp, struct mdp_blit_req *req,
-		      struct mdp_regs *regs)
+		      struct ppp_regs *regs)
 {
 	uint32_t phase_init_x, phase_init_y, phase_step_x, phase_step_y;
 	uint32_t scale_factor_x, scale_factor_y;
@@ -500,7 +481,7 @@ static int blit_scale(const struct mdp_info *mdp, struct mdp_blit_req *req,
 }
 
 static void blit_blur(const struct mdp_info *mdp, struct mdp_blit_req *req,
-		      struct mdp_regs *regs)
+		      struct ppp_regs *regs)
 {
 	if (!(req->flags & MDP_BLUR))
 		return;
@@ -534,7 +515,7 @@ static void get_len(struct mdp_img *img, struct mdp_rect *rect, uint32_t bpp,
 
 static int valid_src_dst(unsigned long src_start, unsigned long src_len,
 			 unsigned long dst_start, unsigned long dst_len,
-			 struct mdp_blit_req *req, struct mdp_regs *regs)
+			 struct mdp_blit_req *req, struct ppp_regs *regs)
 {
 	unsigned long src_min_ok = src_start;
 	unsigned long src_max_ok = src_start + src_len;
@@ -575,7 +556,7 @@ static int valid_src_dst(unsigned long src_start, unsigned long src_len,
 }
 
 
-static void flush_imgs(struct mdp_blit_req *req, struct mdp_regs *regs,
+static void flush_imgs(struct mdp_blit_req *req, struct ppp_regs *regs,
 		       struct file *src_file, struct file *dst_file)
 {
 }
@@ -601,7 +582,7 @@ static void get_chroma_addr(struct mdp_img *img, struct mdp_rect *rect,
 }
 
 static int send_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
-		     struct mdp_regs *regs, struct file *src_file,
+		     struct ppp_regs *regs, struct file *src_file,
 		     struct file *dst_file)
 {
 	mdp_writel(mdp, 1, 0x060);
@@ -646,7 +627,7 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 		 struct file *src_file, unsigned long src_start, unsigned long src_len,
 		 struct file *dst_file, unsigned long dst_start, unsigned long dst_len)
 {
-	struct mdp_regs regs = {0};
+	struct ppp_regs regs = {0};
 
 	if (unlikely(req->src.format >= MDP_IMGTYPE_LIMIT ||
 		     req->dst.format >= MDP_IMGTYPE_LIMIT)) {
diff --git a/drivers/video/msm/mdp_ppp.h b/drivers/video/msm/mdp_ppp.h
new file mode 100644
index 0000000..ef3b125
--- /dev/null
+++ b/drivers/video/msm/mdp_ppp.h
@@ -0,0 +1,50 @@
+/* drivers/video/msm/mdp_ppp.h
+ *
+ * Copyright (C) 2009 Google Incorporated
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _VIDEO_MSM_MDP_PPP_H_
+#define _VIDEO_MSM_MDP_PPP_H_
+
+#include <linux/types.h>
+
+struct ppp_regs {
+	uint32_t src0;
+	uint32_t src1;
+	uint32_t dst0;
+	uint32_t dst1;
+	uint32_t src_cfg;
+	uint32_t dst_cfg;
+	uint32_t src_pack;
+	uint32_t dst_pack;
+	uint32_t src_rect;
+	uint32_t dst_rect;
+	uint32_t src_ystride;
+	uint32_t dst_ystride;
+	uint32_t op;
+	uint32_t src_bpp;
+	uint32_t dst_bpp;
+	uint32_t edge;
+	uint32_t phasex_init;
+	uint32_t phasey_init;
+	uint32_t phasex_step;
+	uint32_t phasey_step;
+
+	uint32_t bg0;
+	uint32_t bg1;
+	uint32_t bg_cfg;
+	uint32_t bg_bpp;
+	uint32_t bg_pack;
+	uint32_t bg_ystride;
+};
+
+#endif /* _VIDEO_MSM_MDP_PPP_H_ */
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

