Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793Ab1CRV5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:57:17 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47740 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932760Ab1CRV5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:57:10 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6289"; a="80648471"
X-IronPort-AV: E=Sophos;i="4.63,205,1299484800"; 
   d="scan'208";a="37044904"
From: Carl Vanderlip <carlv@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>, linux-fbdev@vger.kernel.org,
        Carl Vanderlip <carlv@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/20] video: msm: Split out MDP2.2 HW specific code.
Date: Fri, 18 Mar 2011 14:57:03 -0700
Message-Id: <1300485423-27281-1-git-send-email-carlv@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving MDP2.2 HW specific code allows for reuse of PPP code
when adding other MDP HW versions. Splitting also begins
simplification of mdp_probe function.

Authors:
Dima Zavin <dima@android.com>
Rebecca Schultz Zavin <rebecca@android.com>
Colin Cross <ccross@android.com>

Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig                          |    5 +
 drivers/video/msm/Makefile                         |    4 +-
 drivers/video/msm/mdp.c                            |   14 +-
 drivers/video/msm/mdp_ppp.c                        |  358 ++++----------------
 drivers/video/msm/mdp_ppp.h                        |   12 +
 .../video/msm/{mdp_scale_tables.c => mdp_ppp22.c}  |  333 ++++++++++++++++++-
 drivers/video/msm/mdp_scale_tables.h               |   38 --
 7 files changed, 417 insertions(+), 347 deletions(-)
 rename drivers/video/msm/{mdp_scale_tables.c => mdp_ppp22.c} (69%)
 delete mode 100644 drivers/video/msm/mdp_scale_tables.h

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index df9d74e..d6e75c3 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -76,6 +76,11 @@ config HAS_MSM_DEBUG_UART_PHYS
 config  MSM_VIC
 	bool
 
+config MSM_MDP22
+	bool
+	depends on ARCH_MSM7X00A
+	default y
+
 menu "Qualcomm MSM Board Type"
 
 config MACH_HALIBUT
diff --git a/drivers/video/msm/Makefile b/drivers/video/msm/Makefile
index 802d6ae..0666aef 100644
--- a/drivers/video/msm/Makefile
+++ b/drivers/video/msm/Makefile
@@ -5,7 +5,9 @@ obj-y := msm_fb.o
 
 # MDP DMA/PPP engine
 #
-obj-y += mdp.o mdp_scale_tables.o mdp_ppp.o
+obj-y += mdp.o mdp_ppp.o
+
+obj-$(CONFIG_MSM_MDP22) += mdp_ppp22.o
 
 # MDDI interface
 #
diff --git a/drivers/video/msm/mdp.c b/drivers/video/msm/mdp.c
index 765df06..6aa9ed5 100644
--- a/drivers/video/msm/mdp.c
+++ b/drivers/video/msm/mdp.c
@@ -30,6 +30,7 @@
 #include <linux/platform_device.h>
 
 #include "mdp_hw.h"
+#include "mdp_ppp.h"
 
 struct class *mdp_class;
 
@@ -453,7 +454,13 @@ int register_mdp_client(struct class_interface *cint)
 }
 
 #include "mdp_csc_table.h"
-#include "mdp_scale_tables.h"
+
+void mdp_hw_init(struct mdp_info *mdp)
+{
+#ifdef CONFIG_MSM_MDP22
+	mdp_ppp_init_scale(mdp);
+#endif
+}
 
 int mdp_probe(struct platform_device *pdev)
 {
@@ -551,15 +558,12 @@ int mdp_probe(struct platform_device *pdev)
 	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01e0);
 	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01e4);
 
-	for (n = 0; n < ARRAY_SIZE(mdp_upscale_table); n++)
-		mdp_writel(mdp, mdp_upscale_table[n].val,
-		       mdp_upscale_table[n].reg);
-
 	for (n = 0; n < 9; n++)
 		mdp_writel(mdp, mdp_default_ccs[n], 0x40440 + 4 * n);
 	mdp_writel(mdp, mdp_default_ccs[9], 0x40500 + 4 * 0);
 	mdp_writel(mdp, mdp_default_ccs[10], 0x40500 + 4 * 0);
 	mdp_writel(mdp, mdp_default_ccs[11], 0x40500 + 4 * 0);
+	mdp_hw_init(mdp);
 
 	/* register mdp device */
 	mdp->mdp_dev.dev.parent = &pdev->dev;
diff --git a/drivers/video/msm/mdp_ppp.c b/drivers/video/msm/mdp_ppp.c
index 05f3e33..3d190b9 100644
--- a/drivers/video/msm/mdp_ppp.c
+++ b/drivers/video/msm/mdp_ppp.c
@@ -20,14 +20,14 @@
 
 #include "mdp_hw.h"
 #include "mdp_ppp.h"
-#include "mdp_scale_tables.h"
 
 #define DLOG(x...) do {} while (0)
 
-#define MDP_DOWNSCALE_BLUR (MDP_DOWNSCALE_MAX + 1)
-static int downscale_y_table = MDP_DOWNSCALE_MAX;
-static int downscale_x_table = MDP_DOWNSCALE_MAX;
+#define IMG_LEN(rect_h, w, rect_w, bpp) (((rect_h) * w) * bpp)
 
+#define Y_TO_CRCB_RATIO(format) \
+	((format == MDP_Y_CBCR_H2V2 || format == MDP_Y_CRCB_H2V2) ?  2 :\
+	 (format == MDP_Y_CBCR_H2V1 || format == MDP_Y_CRCB_H2V1) ?  1 : 1)
 
 static uint32_t pack_pattern[] = {
 	PPP_ARRAY0(PACK_PATTERN)
@@ -67,6 +67,19 @@ static uint32_t bg_op_chroma[] = {
 	PPP_ARRAY1(CHROMA_SAMP, BG)
 };
 
+static void set_src_region(struct mdp_img *img, struct mdp_rect *rect,
+			   struct ppp_regs *regs)
+{
+	regs->src_rect = (rect->h << 16) | (rect->w & 0x1fff);
+
+}
+
+static inline void set_dst_region(struct mdp_rect *rect, struct ppp_regs *regs)
+{
+	regs->dst_rect = (rect->h << 16) | (rect->w & 0xfff);
+
+}
+
 static void rotate_dst_addr_x(struct mdp_blit_req *req,
 			      struct ppp_regs *regs)
 {
@@ -181,254 +194,30 @@ static void blit_blend(struct mdp_blit_req *req, struct ppp_regs *regs)
 	}
 
 	regs->op |= bg_op_chroma[req->dst.format];
-}
-
-#define ONE_HALF	(1LL << 32)
-#define ONE		(1LL << 33)
-#define TWO		(2LL << 33)
-#define THREE		(3LL << 33)
-#define FRAC_MASK (ONE - 1)
-#define INT_MASK (~FRAC_MASK)
-
-static int scale_params(uint32_t dim_in, uint32_t dim_out, uint32_t origin,
-			uint32_t *phase_init, uint32_t *phase_step)
-{
-	/* to improve precicsion calculations are done in U31.33 and converted
-	 * to U3.29 at the end */
-	int64_t k1, k2, k3, k4, tmp;
-	uint64_t n, d, os, os_p, od, od_p, oreq;
-	unsigned rpa = 0;
-	int64_t ip64, delta;
-
-	if (dim_out % 3 == 0)
-		rpa = !(dim_in % (dim_out / 3));
-
-	n = ((uint64_t)dim_out) << 34;
-	d = dim_in;
-	if (!d)
-		return -1;
-	do_div(n, d);
-	k3 = (n + 1) >> 1;
-	if ((k3 >> 4) < (1LL << 27) || (k3 >> 4) > (1LL << 31)) {
-		DLOG("crap bad scale\n");
-		return -1;
-	}
-	n = ((uint64_t)dim_in) << 34;
-	d = (uint64_t)dim_out;
-	if (!d)
-		return -1;
-	do_div(n, d);
-	k1 = (n + 1) >> 1;
-	k2 = (k1 - ONE) >> 1;
-
-	*phase_init = (int)(k2 >> 4);
-	k4 = (k3 - ONE) >> 1;
-
-	if (rpa) {
-		os = ((uint64_t)origin << 33) - ONE_HALF;
-		tmp = (dim_out * os) + ONE_HALF;
-		if (!dim_in)
-			return -1;
-		do_div(tmp, dim_in);
-		od = tmp - ONE_HALF;
-	} else {
-		os = ((uint64_t)origin << 1) - 1;
-		od = (((k3 * os) >> 1) + k4);
-	}
-
-	od_p = od & INT_MASK;
-	if (od_p != od)
-		od_p += ONE;
-
-	if (rpa) {
-		tmp = (dim_in * od_p) + ONE_HALF;
-		if (!dim_in)
-			return -1;
-		do_div(tmp, dim_in);
-		os_p = tmp - ONE_HALF;
-	} else {
-		os_p = ((k1 * (od_p >> 33)) + k2);
-	}
-
-	oreq = (os_p & INT_MASK) - ONE;
-
-	ip64 = os_p - oreq;
-	delta = ((int64_t)(origin) << 33) - oreq;
-	ip64 -= delta;
-	/* limit to valid range before the left shift */
-	delta = (ip64 & (1LL << 63)) ? 4 : -4;
-	delta <<= 33;
-	while (abs((int)(ip64 >> 33)) > 4)
-		ip64 += delta;
-	*phase_init = (int)(ip64 >> 4);
-	*phase_step = (uint32_t)(k1 >> 4);
-	return 0;
-}
-
-static void load_scale_table(const struct mdp_info *mdp,
-			     struct mdp_table_entry *table, int len)
-{
-	int i;
-	for (i = 0; i < len; i++)
-		mdp_writel(mdp, table[i].val, table[i].reg);
-}
-
-enum {
-IMG_LEFT,
-IMG_RIGHT,
-IMG_TOP,
-IMG_BOTTOM,
-};
-
-static void get_edge_info(uint32_t src, uint32_t src_coord, uint32_t dst,
-			  uint32_t *interp1, uint32_t *interp2,
-			  uint32_t *repeat1, uint32_t *repeat2) {
-	if (src > 3 * dst) {
-		*interp1 = 0;
-		*interp2 = src - 1;
-		*repeat1 = 0;
-		*repeat2 = 0;
-	} else if (src == 3 * dst) {
-		*interp1 = 0;
-		*interp2 = src;
-		*repeat1 = 0;
-		*repeat2 = 1;
-	} else if (src > dst && src < 3 * dst) {
-		*interp1 = -1;
-		*interp2 = src;
-		*repeat1 = 1;
-		*repeat2 = 1;
-	} else if (src == dst) {
-		*interp1 = -1;
-		*interp2 = src + 1;
-		*repeat1 = 1;
-		*repeat2 = 2;
-	} else {
-		*interp1 = -2;
-		*interp2 = src + 1;
-		*repeat1 = 2;
-		*repeat2 = 2;
-	}
-	*interp1 += src_coord;
-	*interp2 += src_coord;
-}
-
-static int get_edge_cond(struct mdp_blit_req *req, struct ppp_regs *regs)
-{
-	int32_t luma_interp[4];
-	int32_t luma_repeat[4];
-	int32_t chroma_interp[4];
-	int32_t chroma_bound[4];
-	int32_t chroma_repeat[4];
-	uint32_t dst_w, dst_h;
-
-	memset(&luma_interp, 0, sizeof(int32_t) * 4);
-	memset(&luma_repeat, 0, sizeof(int32_t) * 4);
-	memset(&chroma_interp, 0, sizeof(int32_t) * 4);
-	memset(&chroma_bound, 0, sizeof(int32_t) * 4);
-	memset(&chroma_repeat, 0, sizeof(int32_t) * 4);
-	regs->edge = 0;
-
-	if (req->flags & MDP_ROT_90) {
-		dst_w = req->dst_rect.h;
-		dst_h = req->dst_rect.w;
-	} else {
-		dst_w = req->dst_rect.w;
-		dst_h = req->dst_rect.h;
-	}
-
-	if (regs->op & (PPP_OP_SCALE_Y_ON | PPP_OP_SCALE_X_ON)) {
-		get_edge_info(req->src_rect.h, req->src_rect.y, dst_h,
-			      &luma_interp[IMG_TOP], &luma_interp[IMG_BOTTOM],
-			      &luma_repeat[IMG_TOP], &luma_repeat[IMG_BOTTOM]);
-		get_edge_info(req->src_rect.w, req->src_rect.x, dst_w,
-			      &luma_interp[IMG_LEFT], &luma_interp[IMG_RIGHT],
-			      &luma_repeat[IMG_LEFT], &luma_repeat[IMG_RIGHT]);
-	} else {
-		luma_interp[IMG_LEFT] = req->src_rect.x;
-		luma_interp[IMG_RIGHT] = req->src_rect.x + req->src_rect.w - 1;
-		luma_interp[IMG_TOP] = req->src_rect.y;
-		luma_interp[IMG_BOTTOM] = req->src_rect.y + req->src_rect.h - 1;
-		luma_repeat[IMG_LEFT] = 0;
-		luma_repeat[IMG_TOP] = 0;
-		luma_repeat[IMG_RIGHT] = 0;
-		luma_repeat[IMG_BOTTOM] = 0;
-	}
-
-	chroma_interp[IMG_LEFT] = luma_interp[IMG_LEFT];
-	chroma_interp[IMG_RIGHT] = luma_interp[IMG_RIGHT];
-	chroma_interp[IMG_TOP] = luma_interp[IMG_TOP];
-	chroma_interp[IMG_BOTTOM] = luma_interp[IMG_BOTTOM];
-
-	chroma_bound[IMG_LEFT] = req->src_rect.x;
-	chroma_bound[IMG_RIGHT] = req->src_rect.x + req->src_rect.w - 1;
-	chroma_bound[IMG_TOP] = req->src_rect.y;
-	chroma_bound[IMG_BOTTOM] = req->src_rect.y + req->src_rect.h - 1;
-
-	if (IS_YCRCB(req->src.format)) {
-		chroma_interp[IMG_LEFT] = chroma_interp[IMG_LEFT] >> 1;
-		chroma_interp[IMG_RIGHT] = (chroma_interp[IMG_RIGHT] + 1) >> 1;
-
-		chroma_bound[IMG_LEFT] = chroma_bound[IMG_LEFT] >> 1;
-		chroma_bound[IMG_RIGHT] = chroma_bound[IMG_RIGHT] >> 1;
-	}
 
-	if (req->src.format == MDP_Y_CBCR_H2V2 ||
-	    req->src.format == MDP_Y_CRCB_H2V2) {
-		chroma_interp[IMG_TOP] = (chroma_interp[IMG_TOP] - 1) >> 1;
-		chroma_interp[IMG_BOTTOM] = (chroma_interp[IMG_BOTTOM] + 1)
-					    >> 1;
-		chroma_bound[IMG_TOP] = (chroma_bound[IMG_TOP] + 1) >> 1;
-		chroma_bound[IMG_BOTTOM] = chroma_bound[IMG_BOTTOM] >> 1;
-	}
-
-	chroma_repeat[IMG_LEFT] = chroma_bound[IMG_LEFT] -
-				  chroma_interp[IMG_LEFT];
-	chroma_repeat[IMG_RIGHT] = chroma_interp[IMG_RIGHT] -
-				  chroma_bound[IMG_RIGHT];
-	chroma_repeat[IMG_TOP] = chroma_bound[IMG_TOP] -
-				  chroma_interp[IMG_TOP];
-	chroma_repeat[IMG_BOTTOM] = chroma_interp[IMG_BOTTOM] -
-				  chroma_bound[IMG_BOTTOM];
-
-	if (chroma_repeat[IMG_LEFT] < 0 || chroma_repeat[IMG_LEFT] > 3 ||
-	    chroma_repeat[IMG_RIGHT] < 0 || chroma_repeat[IMG_RIGHT] > 3 ||
-	    chroma_repeat[IMG_TOP] < 0 || chroma_repeat[IMG_TOP] > 3 ||
-	    chroma_repeat[IMG_BOTTOM] < 0 || chroma_repeat[IMG_BOTTOM] > 3 ||
-	    luma_repeat[IMG_LEFT] < 0 || luma_repeat[IMG_LEFT] > 3 ||
-	    luma_repeat[IMG_RIGHT] < 0 || luma_repeat[IMG_RIGHT] > 3 ||
-	    luma_repeat[IMG_TOP] < 0 || luma_repeat[IMG_TOP] > 3 ||
-	    luma_repeat[IMG_BOTTOM] < 0 || luma_repeat[IMG_BOTTOM] > 3)
-		return -1;
-
-	regs->edge |= (chroma_repeat[IMG_LEFT] & 3) << MDP_LEFT_CHROMA;
-	regs->edge |= (chroma_repeat[IMG_RIGHT] & 3) << MDP_RIGHT_CHROMA;
-	regs->edge |= (chroma_repeat[IMG_TOP] & 3) << MDP_TOP_CHROMA;
-	regs->edge |= (chroma_repeat[IMG_BOTTOM] & 3) << MDP_BOTTOM_CHROMA;
-	regs->edge |= (luma_repeat[IMG_LEFT] & 3) << MDP_LEFT_LUMA;
-	regs->edge |= (luma_repeat[IMG_RIGHT] & 3) << MDP_RIGHT_LUMA;
-	regs->edge |= (luma_repeat[IMG_TOP] & 3) << MDP_TOP_LUMA;
-	regs->edge |= (luma_repeat[IMG_BOTTOM] & 3) << MDP_BOTTOM_LUMA;
-	return 0;
+	/* since we always blend src + dst -> dst, copy most of the
+	 * configuration from dest to bg */
+	regs->bg0 = regs->dst0;
+	regs->bg1 = regs->dst1;
+	regs->bg_cfg = src_img_cfg[req->dst.format];
+	regs->bg_bpp = regs->dst_bpp;
+	regs->bg_pack = pack_pattern[req->dst.format];
+	regs->bg_ystride = regs->dst_ystride;
 }
 
 static int blit_scale(const struct mdp_info *mdp, struct mdp_blit_req *req,
 		      struct ppp_regs *regs)
 {
-	uint32_t phase_init_x, phase_init_y, phase_step_x, phase_step_y;
-	uint32_t scale_factor_x, scale_factor_y;
-	uint32_t downscale;
-	uint32_t dst_w, dst_h;
+	struct mdp_rect dst_rect;
 
+	memcpy(&dst_rect, &req->dst_rect, sizeof(dst_rect));
 	if (req->flags & MDP_ROT_90) {
-		dst_w = req->dst_rect.h;
-		dst_h = req->dst_rect.w;
-	} else {
-		dst_w = req->dst_rect.w;
-		dst_h = req->dst_rect.h;
+		dst_rect.w = req->dst_rect.h;
+		dst_rect.h = req->dst_rect.w;
 	}
-	if ((req->src_rect.w == dst_w)  && (req->src_rect.h == dst_h) &&
-	    !(req->flags & MDP_BLUR)) {
+
+	if ((req->src_rect.w == dst_rect.w) && (req->src_rect.h == dst_rect.h)
+	    && !(req->flags & MDP_BLUR)) {
 		regs->phasex_init = 0;
 		regs->phasey_init = 0;
 		regs->phasex_step = 0;
@@ -436,73 +225,35 @@ static int blit_scale(const struct mdp_info *mdp, struct mdp_blit_req *req,
 		return 0;
 	}
 
-	if (scale_params(req->src_rect.w, dst_w, 1, &phase_init_x,
-			 &phase_step_x) ||
-	    scale_params(req->src_rect.h, dst_h, 1, &phase_init_y,
-			 &phase_step_y))
+#ifdef CONFIG_MSM_MDP22
+	if (mdp_ppp_cfg_scale(mdp, regs, &req->src_rect, &dst_rect,
+			      req->src.format, req->dst.format)) {
+		DLOG("crap, bad scale\n");
 		return -1;
-
-	scale_factor_x = (dst_w * 10) / req->src_rect.w;
-	scale_factor_y = (dst_h * 10) / req->src_rect.h;
-
-	if (scale_factor_x > 8)
-		downscale = MDP_DOWNSCALE_PT8TO1;
-	else if (scale_factor_x > 6)
-		downscale = MDP_DOWNSCALE_PT6TOPT8;
-	else if (scale_factor_x > 4)
-		downscale = MDP_DOWNSCALE_PT4TOPT6;
-	else
-		downscale = MDP_DOWNSCALE_PT2TOPT4;
-	if (downscale != downscale_x_table) {
-		load_scale_table(mdp, mdp_downscale_x_table[downscale], 64);
-		downscale_x_table = downscale;
 	}
+#endif
 
-	if (scale_factor_y > 8)
-		downscale = MDP_DOWNSCALE_PT8TO1;
-	else if (scale_factor_y > 6)
-		downscale = MDP_DOWNSCALE_PT6TOPT8;
-	else if (scale_factor_y > 4)
-		downscale = MDP_DOWNSCALE_PT4TOPT6;
-	else
-		downscale = MDP_DOWNSCALE_PT2TOPT4;
-	if (downscale != downscale_y_table) {
-		load_scale_table(mdp, mdp_downscale_y_table[downscale], 64);
-		downscale_y_table = downscale;
-	}
-
-	regs->phasex_init = phase_init_x;
-	regs->phasey_init = phase_init_y;
-	regs->phasex_step = phase_step_x;
-	regs->phasey_step = phase_step_y;
 	regs->op |= (PPP_OP_SCALE_Y_ON | PPP_OP_SCALE_X_ON);
 	return 0;
-
 }
 
 static void blit_blur(const struct mdp_info *mdp, struct mdp_blit_req *req,
 		      struct ppp_regs *regs)
 {
+#ifdef CONFIG_MSM_MDP22
+	int ret;
+#endif
 	if (!(req->flags & MDP_BLUR))
 		return;
 
-	if (!(downscale_x_table == MDP_DOWNSCALE_BLUR &&
-	      downscale_y_table == MDP_DOWNSCALE_BLUR)) {
-		load_scale_table(mdp, mdp_gaussian_blur_table, 128);
-		downscale_x_table = MDP_DOWNSCALE_BLUR;
-		downscale_y_table = MDP_DOWNSCALE_BLUR;
-	}
-
+#ifdef CONFIG_MSM_MDP22
+	ret = mdp_ppp_load_blur(mdp);
+	if (ret)
+		return;
+#endif
 	regs->op |= (PPP_OP_SCALE_Y_ON | PPP_OP_SCALE_X_ON);
 }
 
-
-#define IMG_LEN(rect_h, w, rect_w, bpp) (((rect_h) * w) * bpp)
-
-#define Y_TO_CRCB_RATIO(format) \
-	((format == MDP_Y_CBCR_H2V2 || format == MDP_Y_CRCB_H2V2) ?  2 :\
-	 (format == MDP_Y_CBCR_H2V1 || format == MDP_Y_CRCB_H2V1) ?  1 : 1)
-
 static void get_len(struct mdp_img *img, struct mdp_rect *rect, uint32_t bpp,
 		    uint32_t *len0, uint32_t *len1)
 {
@@ -555,7 +306,6 @@ static int valid_src_dst(unsigned long src_start, unsigned long src_len,
 	return 1;
 }
 
-
 static void flush_imgs(struct mdp_blit_req *req, struct ppp_regs *regs,
 		       struct file *src_file, struct file *dst_file)
 {
@@ -643,22 +393,29 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 		return -EINVAL;
 	}
 
+	if (unlikely(req->src_rect.x + req->src_rect.w > req->src.width ||
+		     req->src_rect.y + req->src_rect.h > req->src.height ||
+		     req->dst_rect.x + req->dst_rect.w > req->dst.width ||
+		     req->dst_rect.y + req->dst_rect.h > req->dst.height)) {
+		printk(KERN_ERR "mdp_ppp: img rect extends outside of img!\n");
+		return -EINVAL;
+	}
+
 	/* set the src image configuration */
 	regs.src_cfg = src_img_cfg[req->src.format];
 	regs.src_cfg |= (req->src_rect.x & 0x1) ? PPP_SRC_BPP_ROI_ODD_X : 0;
 	regs.src_cfg |= (req->src_rect.y & 0x1) ? PPP_SRC_BPP_ROI_ODD_Y : 0;
-	regs.src_rect = (req->src_rect.h << 16) | req->src_rect.w;
 	regs.src_pack = pack_pattern[req->src.format];
 
 	/* set the dest image configuration */
 	regs.dst_cfg = dst_img_cfg[req->dst.format] | PPP_DST_OUT_SEL_AXI;
-	regs.dst_rect = (req->dst_rect.h << 16) | req->dst_rect.w;
 	regs.dst_pack = pack_pattern[req->dst.format];
 
 	/* set src, bpp, start pixel and ystride */
 	regs.src_bpp = bytes_per_pixel[req->src.format];
 	regs.src0 = src_start + req->src.offset;
 	regs.src_ystride = req->src.width * regs.src_bpp;
+	set_src_region(&req->src, &req->src_rect, &regs);
 	get_chroma_addr(&req->src, &req->src_rect, regs.src0, regs.src_bpp,
 			regs.src_cfg, &regs.src1, &regs.src_ystride);
 	regs.src0 += (req->src_rect.x + (req->src_rect.y * req->src.width)) *
@@ -668,6 +425,7 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 	regs.dst_bpp = bytes_per_pixel[req->dst.format];
 	regs.dst0 = dst_start + req->dst.offset;
 	regs.dst_ystride = req->dst.width * regs.dst_bpp;
+	set_dst_region(&req->dst_rect, &regs);
 	get_chroma_addr(&req->dst, &req->dst_rect, regs.dst0, regs.dst_bpp,
 			regs.dst_cfg, &regs.dst1, &regs.dst_ystride);
 	regs.dst0 += (req->dst_rect.x + (req->dst_rect.y * req->dst.width)) *
@@ -703,9 +461,11 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 		req->dst_rect.x = req->dst_rect.x & (~0x1);
 		req->dst_rect.w = req->dst_rect.w & (~0x1);
 	}
-	if (get_edge_cond(req, &regs))
-		return -EINVAL;
 
+#ifdef CONFIG_MSM_MDP22
+	if (mdp_ppp_cfg_edge_cond(req, &regs))
+		return -EINVAL;
+#endif
 	send_blit(mdp, req, &regs, src_file, dst_file);
 	return 0;
 }
diff --git a/drivers/video/msm/mdp_ppp.h b/drivers/video/msm/mdp_ppp.h
index ef3b125..c3cd895 100644
--- a/drivers/video/msm/mdp_ppp.h
+++ b/drivers/video/msm/mdp_ppp.h
@@ -47,4 +47,16 @@ struct ppp_regs {
 	uint32_t bg_ystride;
 };
 
+struct mdp_info;
+struct mdp_rect;
+struct mdp_blit_req;
+
+void mdp_ppp_init_scale(const struct mdp_info *mdp);
+int mdp_ppp_cfg_scale(const struct mdp_info *mdp, struct ppp_regs *regs,
+		      struct mdp_rect *src_rect, struct mdp_rect *dst_rect,
+		      uint32_t src_format, uint32_t dst_format);
+int mdp_ppp_load_blur(const struct mdp_info *mdp);
+
+int mdp_ppp_cfg_edge_cond(struct mdp_blit_req *req, struct ppp_regs *regs);
+
 #endif /* _VIDEO_MSM_MDP_PPP_H_ */
diff --git a/drivers/video/msm/mdp_scale_tables.c b/drivers/video/msm/mdp_ppp22.c
similarity index 69%
rename from drivers/video/msm/mdp_scale_tables.c
rename to drivers/video/msm/mdp_ppp22.c
index 604783b..8cfcff2 100644
--- a/drivers/video/msm/mdp_scale_tables.c
+++ b/drivers/video/msm/mdp_ppp22.c
@@ -1,6 +1,6 @@
-/* drivers/video/msm_fb/mdp_scale_tables.c
+/* drivers/video/msm/mdp_ppp22.c
  *
- * Copyright (C) 2007 QUALCOMM Incorporated
+ * Copyright (C) 2007, 2011 Code Aurora Forum. All rights reserved.
  * Copyright (C) 2007 Google Incorporated
  *
  * This software is licensed under the terms of the GNU General Public
@@ -13,10 +13,33 @@
  * GNU General Public License for more details.
  */
 
-#include "mdp_scale_tables.h"
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <linux/msm_mdp.h>
+
 #include "mdp_hw.h"
+#include "mdp_ppp.h"
+
+struct mdp_table_entry {
+	uint32_t reg;
+	uint32_t val;
+};
+
+enum {
+	MDP_DOWNSCALE_PT2TOPT4,
+	MDP_DOWNSCALE_PT4TOPT6,
+	MDP_DOWNSCALE_PT6TOPT8,
+	MDP_DOWNSCALE_PT8TO1,
+	MDP_DOWNSCALE_MAX,
+
+	/* not technically in the downscale table list */
+	MDP_DOWNSCALE_BLUR,
+};
 
-struct mdp_table_entry mdp_upscale_table[] = {
+static int downscale_x_table;
+static int downscale_y_table;
+
+static struct mdp_table_entry mdp_upscale_table[] = {
 	{ 0x5fffc, 0x0 },
 	{ 0x50200, 0x7fc00000 },
 	{ 0x5fffc, 0xff80000d },
@@ -764,3 +787,305 @@ struct mdp_table_entry mdp_gaussian_blur_table[] = {
 	{ 0x5fffc, 0x20000080 },
 	{ 0x5037c, 0x20000080 },
 };
+
+static void load_table(const struct mdp_info *mdp,
+		       struct mdp_table_entry *table, int len)
+{
+	int i;
+	for (i = 0; i < len; i++)
+		mdp_writel(mdp, table[i].val, table[i].reg);
+}
+
+enum {
+	IMG_LEFT,
+	IMG_RIGHT,
+	IMG_TOP,
+	IMG_BOTTOM,
+};
+
+static void get_edge_info(uint32_t src, uint32_t src_coord, uint32_t dst,
+			  uint32_t *interp1, uint32_t *interp2,
+			  uint32_t *repeat1, uint32_t *repeat2) {
+	if (src > 3 * dst) {
+		*interp1 = 0;
+		*interp2 = src - 1;
+		*repeat1 = 0;
+		*repeat2 = 0;
+	} else if (src == 3 * dst) {
+		*interp1 = 0;
+		*interp2 = src;
+		*repeat1 = 0;
+		*repeat2 = 1;
+	} else if (src > dst && src < 3 * dst) {
+		*interp1 = -1;
+		*interp2 = src;
+		*repeat1 = 1;
+		*repeat2 = 1;
+	} else if (src == dst) {
+		*interp1 = -1;
+		*interp2 = src + 1;
+		*repeat1 = 1;
+		*repeat2 = 2;
+	} else {
+		*interp1 = -2;
+		*interp2 = src + 1;
+		*repeat1 = 2;
+		*repeat2 = 2;
+	}
+	*interp1 += src_coord;
+	*interp2 += src_coord;
+}
+
+int mdp_ppp_cfg_edge_cond(struct mdp_blit_req *req, struct ppp_regs *regs)
+{
+	int32_t luma_interp[4];
+	int32_t luma_repeat[4];
+	int32_t chroma_interp[4];
+	int32_t chroma_bound[4];
+	int32_t chroma_repeat[4];
+	uint32_t dst_w, dst_h;
+
+	memset(&luma_interp, 0, sizeof(int32_t) * 4);
+	memset(&luma_repeat, 0, sizeof(int32_t) * 4);
+	memset(&chroma_interp, 0, sizeof(int32_t) * 4);
+	memset(&chroma_bound, 0, sizeof(int32_t) * 4);
+	memset(&chroma_repeat, 0, sizeof(int32_t) * 4);
+	regs->edge = 0;
+
+	if (req->flags & MDP_ROT_90) {
+		dst_w = req->dst_rect.h;
+		dst_h = req->dst_rect.w;
+	} else {
+		dst_w = req->dst_rect.w;
+		dst_h = req->dst_rect.h;
+	}
+
+	if (regs->op & (PPP_OP_SCALE_Y_ON | PPP_OP_SCALE_X_ON)) {
+		get_edge_info(req->src_rect.h, req->src_rect.y, dst_h,
+			      &luma_interp[IMG_TOP], &luma_interp[IMG_BOTTOM],
+			      &luma_repeat[IMG_TOP], &luma_repeat[IMG_BOTTOM]);
+		get_edge_info(req->src_rect.w, req->src_rect.x, dst_w,
+			      &luma_interp[IMG_LEFT], &luma_interp[IMG_RIGHT],
+			      &luma_repeat[IMG_LEFT], &luma_repeat[IMG_RIGHT]);
+	} else {
+		luma_interp[IMG_LEFT] = req->src_rect.x;
+		luma_interp[IMG_RIGHT] = req->src_rect.x + req->src_rect.w - 1;
+		luma_interp[IMG_TOP] = req->src_rect.y;
+		luma_interp[IMG_BOTTOM] = req->src_rect.y + req->src_rect.h - 1;
+		luma_repeat[IMG_LEFT] = 0;
+		luma_repeat[IMG_TOP] = 0;
+		luma_repeat[IMG_RIGHT] = 0;
+		luma_repeat[IMG_BOTTOM] = 0;
+	}
+
+	chroma_interp[IMG_LEFT] = luma_interp[IMG_LEFT];
+	chroma_interp[IMG_RIGHT] = luma_interp[IMG_RIGHT];
+	chroma_interp[IMG_TOP] = luma_interp[IMG_TOP];
+	chroma_interp[IMG_BOTTOM] = luma_interp[IMG_BOTTOM];
+
+	chroma_bound[IMG_LEFT] = req->src_rect.x;
+	chroma_bound[IMG_RIGHT] = req->src_rect.x + req->src_rect.w - 1;
+	chroma_bound[IMG_TOP] = req->src_rect.y;
+	chroma_bound[IMG_BOTTOM] = req->src_rect.y + req->src_rect.h - 1;
+
+	if (IS_YCRCB(req->src.format)) {
+		chroma_interp[IMG_LEFT] = chroma_interp[IMG_LEFT] >> 1;
+		chroma_interp[IMG_RIGHT] = (chroma_interp[IMG_RIGHT] + 1) >> 1;
+
+		chroma_bound[IMG_LEFT] = chroma_bound[IMG_LEFT] >> 1;
+		chroma_bound[IMG_RIGHT] = chroma_bound[IMG_RIGHT] >> 1;
+	}
+
+	if (req->src.format == MDP_Y_CBCR_H2V2 ||
+	    req->src.format == MDP_Y_CRCB_H2V2) {
+		chroma_interp[IMG_TOP] = (chroma_interp[IMG_TOP] - 1) >> 1;
+		chroma_interp[IMG_BOTTOM] = (chroma_interp[IMG_BOTTOM] + 1)
+					    >> 1;
+		chroma_bound[IMG_TOP] = (chroma_bound[IMG_TOP] + 1) >> 1;
+		chroma_bound[IMG_BOTTOM] = chroma_bound[IMG_BOTTOM] >> 1;
+	}
+
+	chroma_repeat[IMG_LEFT] = chroma_bound[IMG_LEFT] -
+				  chroma_interp[IMG_LEFT];
+	chroma_repeat[IMG_RIGHT] = chroma_interp[IMG_RIGHT] -
+				  chroma_bound[IMG_RIGHT];
+	chroma_repeat[IMG_TOP] = chroma_bound[IMG_TOP] -
+				  chroma_interp[IMG_TOP];
+	chroma_repeat[IMG_BOTTOM] = chroma_interp[IMG_BOTTOM] -
+				  chroma_bound[IMG_BOTTOM];
+
+	if (chroma_repeat[IMG_LEFT] < 0 || chroma_repeat[IMG_LEFT] > 3 ||
+	    chroma_repeat[IMG_RIGHT] < 0 || chroma_repeat[IMG_RIGHT] > 3 ||
+	    chroma_repeat[IMG_TOP] < 0 || chroma_repeat[IMG_TOP] > 3 ||
+	    chroma_repeat[IMG_BOTTOM] < 0 || chroma_repeat[IMG_BOTTOM] > 3 ||
+	    luma_repeat[IMG_LEFT] < 0 || luma_repeat[IMG_LEFT] > 3 ||
+	    luma_repeat[IMG_RIGHT] < 0 || luma_repeat[IMG_RIGHT] > 3 ||
+	    luma_repeat[IMG_TOP] < 0 || luma_repeat[IMG_TOP] > 3 ||
+	    luma_repeat[IMG_BOTTOM] < 0 || luma_repeat[IMG_BOTTOM] > 3)
+		return -1;
+
+	regs->edge |= (chroma_repeat[IMG_LEFT] & 3) << MDP_LEFT_CHROMA;
+	regs->edge |= (chroma_repeat[IMG_RIGHT] & 3) << MDP_RIGHT_CHROMA;
+	regs->edge |= (chroma_repeat[IMG_TOP] & 3) << MDP_TOP_CHROMA;
+	regs->edge |= (chroma_repeat[IMG_BOTTOM] & 3) << MDP_BOTTOM_CHROMA;
+	regs->edge |= (luma_repeat[IMG_LEFT] & 3) << MDP_LEFT_LUMA;
+	regs->edge |= (luma_repeat[IMG_RIGHT] & 3) << MDP_RIGHT_LUMA;
+	regs->edge |= (luma_repeat[IMG_TOP] & 3) << MDP_TOP_LUMA;
+	regs->edge |= (luma_repeat[IMG_BOTTOM] & 3) << MDP_BOTTOM_LUMA;
+	return 0;
+}
+
+#define ONE_HALF	(1LL << 32)
+#define ONE		(1LL << 33)
+#define TWO		(2LL << 33)
+#define THREE		(3LL << 33)
+#define FRAC_MASK (ONE - 1)
+#define INT_MASK (~FRAC_MASK)
+
+static int scale_params(uint32_t dim_in, uint32_t dim_out, uint32_t origin,
+			uint32_t *phase_init, uint32_t *phase_step)
+{
+	/* to improve precicsion calculations are done in U31.33 and converted
+	 * to U3.29 at the end */
+	int64_t k1, k2, k3, k4, tmp;
+	uint64_t n, d, os, os_p, od, od_p, oreq;
+	unsigned rpa = 0;
+	int64_t ip64, delta;
+
+	if (dim_out % 3 == 0)
+		rpa = !(dim_in % (dim_out / 3));
+
+	n = ((uint64_t)dim_out) << 34;
+	d = dim_in;
+	if (!d)
+		return -1;
+	do_div(n, d);
+	k3 = (n + 1) >> 1;
+	if ((k3 >> 4) < (1LL << 27) || (k3 >> 4) > (1LL << 31))
+		return -1;
+
+	n = ((uint64_t)dim_in) << 34;
+	d = (uint64_t)dim_out;
+	if (!d)
+		return -1;
+	do_div(n, d);
+	k1 = (n + 1) >> 1;
+	k2 = (k1 - ONE) >> 1;
+
+	*phase_init = (int)(k2 >> 4);
+	k4 = (k3 - ONE) >> 1;
+
+	if (rpa) {
+		os = ((uint64_t)origin << 33) - ONE_HALF;
+		tmp = (dim_out * os) + ONE_HALF;
+		if (!dim_in)
+			return -1;
+		do_div(tmp, dim_in);
+		od = tmp - ONE_HALF;
+	} else {
+		os = ((uint64_t)origin << 1) - 1;
+		od = (((k3 * os) >> 1) + k4);
+	}
+
+	od_p = od & INT_MASK;
+	if (od_p != od)
+		od_p += ONE;
+
+	if (rpa) {
+		tmp = (dim_in * od_p) + ONE_HALF;
+		if (!dim_in)
+			return -1;
+		do_div(tmp, dim_in);
+		os_p = tmp - ONE_HALF;
+	} else {
+		os_p = ((k1 * (od_p >> 33)) + k2);
+	}
+
+	oreq = (os_p & INT_MASK) - ONE;
+
+	ip64 = os_p - oreq;
+	delta = ((int64_t)(origin) << 33) - oreq;
+	ip64 -= delta;
+	/* limit to valid range before the left shift */
+	delta = (ip64 & (1LL << 63)) ? 4 : -4;
+	delta <<= 33;
+	while (abs((int)(ip64 >> 33)) > 4)
+		ip64 += delta;
+	*phase_init = (int)(ip64 >> 4);
+	*phase_step = (uint32_t)(k1 >> 4);
+	return 0;
+}
+
+int mdp_ppp_cfg_scale(const struct mdp_info *mdp, struct ppp_regs *regs,
+		      struct mdp_rect *src_rect, struct mdp_rect *dst_rect,
+		      uint32_t src_format, uint32_t dst_format)
+{
+	int downscale;
+	uint32_t phase_init_x, phase_init_y, phase_step_x, phase_step_y;
+	uint32_t scale_factor_x, scale_factor_y;
+
+	if (scale_params(src_rect->w, dst_rect->w, 1, &phase_init_x,
+			 &phase_step_x) ||
+	    scale_params(src_rect->h, dst_rect->h, 1, &phase_init_y,
+			 &phase_step_y))
+		return -1;
+
+	regs->phasex_init = phase_init_x;
+	regs->phasey_init = phase_init_y;
+	regs->phasex_step = phase_step_x;
+	regs->phasey_step = phase_step_y;
+
+	scale_factor_x = (dst_rect->w * 10) / src_rect->w;
+	scale_factor_y = (dst_rect->h * 10) / src_rect->h;
+
+	if (scale_factor_x > 8)
+		downscale = MDP_DOWNSCALE_PT8TO1;
+	else if (scale_factor_x > 6)
+		downscale = MDP_DOWNSCALE_PT6TOPT8;
+	else if (scale_factor_x > 4)
+		downscale = MDP_DOWNSCALE_PT4TOPT6;
+	else
+		downscale = MDP_DOWNSCALE_PT2TOPT4;
+
+	if (downscale != downscale_x_table) {
+		load_table(mdp, mdp_downscale_x_table[downscale], 64);
+		downscale_x_table = downscale;
+	}
+
+	if (scale_factor_y > 8)
+		downscale = MDP_DOWNSCALE_PT8TO1;
+	else if (scale_factor_y > 6)
+		downscale = MDP_DOWNSCALE_PT6TOPT8;
+	else if (scale_factor_y > 4)
+		downscale = MDP_DOWNSCALE_PT4TOPT6;
+	else
+		downscale = MDP_DOWNSCALE_PT2TOPT4;
+
+	if (downscale != downscale_y_table) {
+		load_table(mdp, mdp_downscale_y_table[downscale], 64);
+		downscale_y_table = downscale;
+	}
+
+	return 0;
+}
+
+
+int mdp_ppp_load_blur(const struct mdp_info *mdp)
+{
+	if (!(downscale_x_table == MDP_DOWNSCALE_BLUR &&
+		downscale_y_table == MDP_DOWNSCALE_BLUR)) {
+		load_table(mdp, mdp_gaussian_blur_table, 128);
+		downscale_x_table = MDP_DOWNSCALE_BLUR;
+		downscale_y_table = MDP_DOWNSCALE_BLUR;
+	}
+
+	return 0;
+}
+
+void mdp_ppp_init_scale(const struct mdp_info *mdp)
+{
+	downscale_x_table = MDP_DOWNSCALE_MAX;
+	downscale_y_table = MDP_DOWNSCALE_MAX;
+
+	load_table(mdp, mdp_upscale_table, ARRAY_SIZE(mdp_upscale_table));
+}
diff --git a/drivers/video/msm/mdp_scale_tables.h b/drivers/video/msm/mdp_scale_tables.h
deleted file mode 100644
index 34077b1..0000000
--- a/drivers/video/msm/mdp_scale_tables.h
+++ /dev/null
@@ -1,38 +0,0 @@
-/* drivers/video/msm_fb/mdp_scale_tables.h
- *
- * Copyright (C) 2007 QUALCOMM Incorporated
- * Copyright (C) 2007 Google Incorporated
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-#ifndef _MDP_SCALE_TABLES_H_
-#define _MDP_SCALE_TABLES_H_
-
-#include <linux/types.h>
-struct mdp_table_entry {
-	uint32_t reg;
-	uint32_t val;
-};
-
-extern struct mdp_table_entry mdp_upscale_table[64];
-
-enum {
-	MDP_DOWNSCALE_PT2TOPT4,
-	MDP_DOWNSCALE_PT4TOPT6,
-	MDP_DOWNSCALE_PT6TOPT8,
-	MDP_DOWNSCALE_PT8TO1,
-	MDP_DOWNSCALE_MAX,
-};
-
-extern struct mdp_table_entry *mdp_downscale_x_table[MDP_DOWNSCALE_MAX];
-extern struct mdp_table_entry *mdp_downscale_y_table[MDP_DOWNSCALE_MAX];
-extern struct mdp_table_entry mdp_gaussian_blur_table[];
-
-#endif
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

