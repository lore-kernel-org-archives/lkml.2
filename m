Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920Ab1CRWAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 18:00:32 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6325 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932859Ab1CRWAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 18:00:25 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6289"; a="80850745"
X-IronPort-AV: E=Sophos;i="4.63,205,1299484800"; 
   d="scan'208";a="37045172"
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
Subject: [PATCH 20/20] video: msm: Add support for MDP 3.1 (qsd8k)
Date: Fri, 18 Mar 2011 15:00:17 -0700
Message-Id: <1300485617-28222-1-git-send-email-carlv@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Includes support for the PPP which does scale, rotate, blend,
color-convert , etc.

Authors:
Dima Zavin <dima@android.com>
Rebecca Schultz Zavin <rebecca@android.com>
Colin Cross <ccross@android.com>

Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig         |    7 +-
 drivers/video/msm/Makefile        |    1 +
 drivers/video/msm/mdp.c           |  114 ++++++++++---
 drivers/video/msm/mdp_csc_table.h |   68 ++++++++
 drivers/video/msm/mdp_hw.h        |  140 ++++++++++++----
 drivers/video/msm/mdp_ppp.c       |  117 ++++++++++++-
 drivers/video/msm/mdp_ppp.h       |   20 +++
 drivers/video/msm/mdp_ppp31.c     |  335 +++++++++++++++++++++++++++++++++++++
 8 files changed, 731 insertions(+), 71 deletions(-)
 create mode 100644 drivers/video/msm/mdp_ppp31.c

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index d6e75c3..83c4838 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -13,6 +13,7 @@ config ARCH_MSM7X00A
 	select CPU_V6
 	select MSM_PROC_COMM
 	select HAS_MSM_DEBUG_UART_PHYS
+	select MSM_MDP22
 
 config ARCH_MSM7X30
 	bool "MSM7x30"
@@ -35,6 +36,7 @@ config ARCH_QSD8X50
 	select MSM_GPIOMUX
 	select MSM_PROC_COMM
 	select HAS_MSM_DEBUG_UART_PHYS
+	select MSM_MDP31
 
 config ARCH_MSM8X60
 	bool "MSM8X60"
@@ -78,8 +80,9 @@ config  MSM_VIC
 
 config MSM_MDP22
 	bool
-	depends on ARCH_MSM7X00A
-	default y
+
+config MSM_MDP31
+	bool
 
 menu "Qualcomm MSM Board Type"
 
diff --git a/drivers/video/msm/Makefile b/drivers/video/msm/Makefile
index 0666aef..b0a07d1 100644
--- a/drivers/video/msm/Makefile
+++ b/drivers/video/msm/Makefile
@@ -8,6 +8,7 @@ obj-y := msm_fb.o
 obj-y += mdp.o mdp_ppp.o
 
 obj-$(CONFIG_MSM_MDP22) += mdp_ppp22.o
+obj-$(CONFIG_MSM_MDP31) += mdp_ppp31.o
 
 # MDDI interface
 #
diff --git a/drivers/video/msm/mdp.c b/drivers/video/msm/mdp.c
index 49d956a..057b6fa 100644
--- a/drivers/video/msm/mdp.c
+++ b/drivers/video/msm/mdp.c
@@ -240,15 +240,16 @@ static void mdp_dma_to_mddi(void *priv, uint32_t addr, uint32_t stride,
 
 	dma2_cfg |= DMA_DITHER_EN;
 
+	/* 666 18BPP */
+	dma2_cfg |= DMA_DSTC0G_6BITS | DMA_DSTC1B_6BITS | DMA_DSTC2R_6BITS;
+
+#ifdef CONFIG_MSM_MDP22
 	/* setup size, address, and stride */
 	mdp_writel(mdp, (height << 16) | (width),
 		   MDP_CMD_DEBUG_ACCESS_BASE + 0x0184);
 	mdp_writel(mdp, addr, MDP_CMD_DEBUG_ACCESS_BASE + 0x0188);
 	mdp_writel(mdp, stride, MDP_CMD_DEBUG_ACCESS_BASE + 0x018C);
 
-	/* 666 18BPP */
-	dma2_cfg |= DMA_DSTC0G_6BITS | DMA_DSTC1B_6BITS | DMA_DSTC2R_6BITS;
-
 	/* set y & x offset and MDDI transaction parameters */
 	mdp_writel(mdp, (y << 16) | (x), MDP_CMD_DEBUG_ACCESS_BASE + 0x0194);
 	mdp_writel(mdp, ld_param, MDP_CMD_DEBUG_ACCESS_BASE + 0x01a0);
@@ -259,6 +260,21 @@ static void mdp_dma_to_mddi(void *priv, uint32_t addr, uint32_t stride,
 
 	/* start DMA2 */
 	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0044);
+#else
+	/* setup size, address, and stride */
+	mdp_writel(mdp, (height << 16) | (width), MDP_DMA_P_SIZE);
+	mdp_writel(mdp, addr, MDP_DMA_P_IBUF_ADDR);
+	mdp_writel(mdp, stride, MDP_DMA_P_IBUF_Y_STRIDE);
+
+	/* set y & x offset and MDDI transaction parameters */
+	mdp_writel(mdp, (y << 16) | (x), MDP_DMA_P_OUT_XY);
+	mdp_writel(mdp, ld_param, MDP_MDDI_PARAM_WR_SEL);
+	mdp_writel(mdp, (MDDI_VDO_PACKET_DESC << 16) | MDDI_VDO_PACKET_PRIM,
+		   MDP_MDDI_PARAM);
+
+	mdp_writel(mdp, dma2_cfg, MDP_DMA_P_CONFIG);
+	mdp_writel(mdp, 0, MDP_DMA_P_START);
+#endif
 }
 
 void mdp_dma(struct mdp_device *mdp_dev, uint32_t addr, uint32_t stride,
@@ -353,10 +369,21 @@ int mdp_set_output_format(struct mdp_device *mdp_dev, int bpp)
 		format = DMA_IBUF_FORMAT_RGB565;
 		pack_pattern = DMA_PACK_PATTERN_RGB;
 		break;
+#ifdef CONFIG_MSM_MDP22
 	case 24:
 	case 32:
 		format = DMA_IBUF_FORMAT_RGB888_OR_ARGB8888;
 		break;
+#else
+	case 24:
+		format = DMA_IBUF_FORMAT_RGB888;
+		pack_pattern = DMA_PACK_PATTERN_BGR;
+		break;
+	case 32:
+		format = DMA_IBUF_FORMAT_XRGB8888;
+		pack_pattern = DMA_PACK_PATTERN_BGR;
+		break;
+#endif
 	default:
 		return -EINVAL;
 	}
@@ -392,6 +419,51 @@ int mdp_blit_and_wait(struct mdp_info *mdp, struct mdp_blit_req *req,
 	return 0;
 }
 
+#ifndef CONFIG_MSM_MDP31
+static int mdp_blit_tiles(struct mdp_device *mdp_dev, struct mdp_blit_req *req,
+			  struct file *src_file, struct file *dst_file)
+{
+	int ret;
+	if (unlikely((req->transp_mask != MDP_TRANSP_NOP ||
+		      req->alpha != MDP_ALPHA_NOP ||
+		      HAS_ALPHA(req->src.format)) &&
+		     (req->flags & MDP_ROT_90 &&
+		      req->dst_rect.w <= 16 && req->dst_rect.h >= 16))) {
+		int i;
+		struct mdp_info *mdp = container_of(mdp_dev,
+						struct mdp_info, mdp_dev);
+		unsigned long src_start = 0, src_len = 0;
+		unsigned long dst_start = 0, dst_len = 0;
+		unsigned int tiles = req->dst_rect.h / 16;
+		unsigned int remainder = req->dst_rect.h % 16;
+		req->src_rect.w = 16*req->src_rect.w / req->dst_rect.h;
+		req->dst_rect.h = 16;
+		for (i = 0; i < tiles; i++) {
+			ret = mdp_blit_and_wait(mdp, req,
+						src_file, src_start, src_len,
+						dst_file, dst_start, dst_len);
+			if (ret)
+				return 1;
+			req->dst_rect.y += 16;
+			req->src_rect.x += req->src_rect.w;
+		}
+		if (!remainder)
+			return 1;
+		req->src_rect.w = remainder*req->src_rect.w / req->dst_rect.h;
+		req->dst_rect.h = remainder;
+	}
+	return 0;
+
+}
+#else
+static int mdp_blit_tiles(struct mdp_device *mdp_dev, struct mdp_blit_req *req,
+			  struct file *src_file, struct file *dst_file)
+{
+	return 0;
+}
+#endif
+
+
 int mdp_blit(struct mdp_device *mdp_dev, struct fb_info *fb,
 	     struct mdp_blit_req *req)
 {
@@ -427,30 +499,12 @@ int mdp_blit(struct mdp_device *mdp_dev, struct fb_info *fb,
 
 	/* transp_masking unimplemented */
 	req->transp_mask = MDP_TRANSP_NOP;
-	if (unlikely((req->transp_mask != MDP_TRANSP_NOP ||
-		      req->alpha != MDP_ALPHA_NOP ||
-		      HAS_ALPHA(req->src.format)) &&
-		     (req->flags & MDP_ROT_90 &&
-		      req->dst_rect.w <= 16 && req->dst_rect.h >= 16))) {
-		int i;
-		unsigned int tiles = req->dst_rect.h / 16;
-		unsigned int remainder = req->dst_rect.h % 16;
-		req->src_rect.w = 16*req->src_rect.w / req->dst_rect.h;
-		req->dst_rect.h = 16;
-		for (i = 0; i < tiles; i++) {
-			ret = mdp_blit_and_wait(mdp, req,
-						src_file, src_start, src_len,
-						dst_file, dst_start, dst_len);
-			if (ret)
-				goto end;
-			req->dst_rect.y += 16;
-			req->src_rect.x += req->src_rect.w;
-		}
-		if (!remainder)
-			goto end;
-		req->src_rect.w = remainder*req->src_rect.w / req->dst_rect.h;
-		req->dst_rect.h = remainder;
+
+	if (mdp_blit_tiles(mdp_dev, req, src_file, dst_file)) {
+		ret = 1;
+		goto end;
 	}
+
 	ret = mdp_blit_and_wait(mdp, req,
 				src_file, src_start, src_len,
 				dst_file, dst_start, dst_len);
@@ -564,12 +618,14 @@ void mdp_hw_init(struct mdp_info *mdp)
 	mdp_writel(mdp, 1, 0x60);
 	mdp_writel(mdp, 1, MDP_EBI2_PORTMAP_MODE);
 
+#ifndef CONFIG_MSM_MDP22
 	/* disable lcdc */
 	mdp_writel(mdp, 0, MDP_LCDC_CTL);
 	/* enable auto clock gating for all blocks by default */
 	mdp_writel(mdp, 0xffffffff, MDP_CGC_EN);
 	/* reset color/gamma correct parms */
 	mdp_writel(mdp, 0, MDP_DMA_P_COLOR_CORRECT_CONFIG);
+#endif
 
 	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01f8);
 	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01fc);
@@ -607,9 +663,13 @@ void mdp_hw_init(struct mdp_info *mdp)
 	for (n = 0; n < ARRAY_SIZE(csc_matrix_config_table); n++)
 		mdp_writel(mdp, csc_matrix_config_table[n].val,
 			   csc_matrix_config_table[n].reg);
-#ifdef CONFIG_MSM_MDP22
+#if defined(CONFIG_MSM_MDP31) || defined(CONFIG_MSM_MDP22)
 	mdp_ppp_init_scale(mdp);
 #endif
+
+#ifndef CONFIG_MSM_MDP31
+	mdp_writel(mdp, 0x04000400, MDP_COMMAND_CONFIG);
+#endif
 }
 
 int mdp_probe(struct platform_device *pdev)
diff --git a/drivers/video/msm/mdp_csc_table.h b/drivers/video/msm/mdp_csc_table.h
index 6eb0fc3..81abc5d 100644
--- a/drivers/video/msm/mdp_csc_table.h
+++ b/drivers/video/msm/mdp_csc_table.h
@@ -39,6 +39,7 @@ static struct {
 	{ MDP_CSC_PRMVn(7), 0x409 },
 	{ MDP_CSC_PRMVn(8), 0x0 },
 
+#ifndef CONFIG_MSM_MDP31
 	/* For MDP 2.2/3.0 */
 
 	/* primary limit vector */
@@ -52,6 +53,73 @@ static struct {
 	{ MDP_CSC_PBVn(1), 0x80 },
 	{ MDP_CSC_PBVn(2), 0x80 },
 
+#else /* CONFIG_MSM_MDP31 */
+
+	/* limit vectors configuration */
+	/* rgb -> yuv (set1) pre-limit vector */
+	{ MDP_PPP_CSC_PRE_LV1n(0), 0x10 },
+	{ MDP_PPP_CSC_PRE_LV1n(1), 0xeb },
+	{ MDP_PPP_CSC_PRE_LV1n(2), 0x10 },
+	{ MDP_PPP_CSC_PRE_LV1n(3), 0xf0 },
+	{ MDP_PPP_CSC_PRE_LV1n(4), 0x10 },
+	{ MDP_PPP_CSC_PRE_LV1n(5), 0xf0 },
+
+	/* rgb -> yuv (set1) post-limit vector */
+	{ MDP_PPP_CSC_POST_LV1n(0), 0x0 },
+	{ MDP_PPP_CSC_POST_LV1n(1), 0xff },
+	{ MDP_PPP_CSC_POST_LV1n(2), 0x0 },
+	{ MDP_PPP_CSC_POST_LV1n(3), 0xff },
+	{ MDP_PPP_CSC_POST_LV1n(4), 0x0 },
+	{ MDP_PPP_CSC_POST_LV1n(5), 0xff },
+
+	/* yuv -> rgb (set2) pre-limit vector */
+	{ MDP_PPP_CSC_PRE_LV2n(0), 0x0 },
+	{ MDP_PPP_CSC_PRE_LV2n(1), 0xff },
+	{ MDP_PPP_CSC_PRE_LV2n(2), 0x0 },
+	{ MDP_PPP_CSC_PRE_LV2n(3), 0xff },
+	{ MDP_PPP_CSC_PRE_LV2n(4), 0x0 },
+	{ MDP_PPP_CSC_PRE_LV2n(5), 0xff },
+
+	/* yuv -> rgb (set2) post-limit vector */
+	{ MDP_PPP_CSC_POST_LV2n(0), 0x10 },
+	{ MDP_PPP_CSC_POST_LV2n(1), 0xeb },
+	{ MDP_PPP_CSC_POST_LV2n(2), 0x10 },
+	{ MDP_PPP_CSC_POST_LV2n(3), 0xf0 },
+	{ MDP_PPP_CSC_POST_LV2n(4), 0x10 },
+	{ MDP_PPP_CSC_POST_LV2n(5), 0xf0 },
+
+	/* bias vectors configuration */
+
+	/* XXX: why is set2 used for rgb->yuv, but set1 */
+	/* used for yuv -> rgb??!? Seems to be the reverse of the
+	 * other vectors. */
+
+	/* RGB -> YUV pre-bias vector... */
+	{ MDP_PPP_CSC_PRE_BV2n(0), 0 },
+	{ MDP_PPP_CSC_PRE_BV2n(1), 0 },
+	{ MDP_PPP_CSC_PRE_BV2n(2), 0 },
+
+	/* RGB -> YUV post-bias vector */
+	{ MDP_PPP_CSC_POST_BV2n(0), 0x10 },
+	{ MDP_PPP_CSC_POST_BV2n(1), 0x80 },
+	{ MDP_PPP_CSC_POST_BV2n(2), 0x80 },
+
+	/* YUV -> RGB pre-bias vector... */
+	{ MDP_PPP_CSC_PRE_BV1n(0), 0x1f0 },
+	{ MDP_PPP_CSC_PRE_BV1n(1), 0x180 },
+	{ MDP_PPP_CSC_PRE_BV1n(2), 0x180 },
+
+	/* YUV -> RGB post-bias vector */
+	{ MDP_PPP_CSC_POST_BV1n(0), 0 },
+	{ MDP_PPP_CSC_POST_BV1n(1), 0 },
+	{ MDP_PPP_CSC_POST_BV1n(2), 0 },
+
+	/* luma filter coefficients */
+	{ MDP_PPP_DEINT_COEFFn(0), 0x3e0 },
+	{ MDP_PPP_DEINT_COEFFn(1), 0x360 },
+	{ MDP_PPP_DEINT_COEFFn(2), 0x120 },
+	{ MDP_PPP_DEINT_COEFFn(3), 0x140 },
+#endif
 };
 
 static struct {
diff --git a/drivers/video/msm/mdp_hw.h b/drivers/video/msm/mdp_hw.h
index 7485a9e..d20952c 100644
--- a/drivers/video/msm/mdp_hw.h
+++ b/drivers/video/msm/mdp_hw.h
@@ -85,10 +85,18 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 #define MDP_DISPLAY_STATUS               (0x00038)
 #define MDP_EBI2_LCD0                    (0x0003c)
 #define MDP_EBI2_LCD1                    (0x00040)
+#define MDP_EBI2_PORTMAP_MODE            (0x0005c)
+
+#ifndef CONFIG_MSM_MDP31
 #define MDP_DISPLAY0_ADDR                (0x00054)
 #define MDP_DISPLAY1_ADDR                (0x00058)
-#define MDP_EBI2_PORTMAP_MODE            (0x0005c)
 #define MDP_PPP_CMD_MODE                 (0x00060)
+#else
+#define MDP_DISPLAY0_ADDR                (0x10000)
+#define MDP_DISPLAY1_ADDR                (0x10004)
+#define MDP_PPP_CMD_MODE                 (0x10060)
+#endif
+
 #define MDP_TV_OUT_STATUS                (0x00064)
 #define MDP_HW_VERSION                   (0x00070)
 #define MDP_SW_RESET                     (0x00074)
@@ -98,6 +106,8 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 #define MDP_SECONDARY_VSYNC_OUT_CTRL     (0x00084)
 #define MDP_EXTERNAL_VSYNC_OUT_CTRL      (0x00088)
 #define MDP_VSYNC_CTRL                   (0x0008c)
+#define MDP_MDDI_PARAM_WR_SEL            (0x00090)
+#define MDP_MDDI_PARAM                   (0x00094)
 #define MDP_CGC_EN                       (0x00100)
 #define MDP_CMD_STATUS                   (0x10008)
 #define MDP_PROFILE_EN                   (0x10010)
@@ -144,6 +154,7 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 #define MDP_FULL_BYPASS_WORD35           (0x1018c)
 #define MDP_FULL_BYPASS_WORD37           (0x10194)
 #define MDP_FULL_BYPASS_WORD39           (0x1019c)
+#define MDP_PPP_OUT_XY                   (0x1019c)
 #define MDP_FULL_BYPASS_WORD40           (0x101a0)
 #define MDP_FULL_BYPASS_WORD41           (0x101a4)
 #define MDP_FULL_BYPASS_WORD43           (0x101ac)
@@ -166,11 +177,26 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 #define MDP_FULL_BYPASS_WORD61           (0x101f4)
 #define MDP_FULL_BYPASS_WORD62           (0x101f8)
 #define MDP_FULL_BYPASS_WORD63           (0x101fc)
+
+/* used only for MDP 3.1 */
+#define MDP_PPP_SRC_XY                   (0x10200)
+#define MDP_PPP_BG_XY                    (0x10204)
+#define MDP_PPP_SRC_IMAGE_SIZE           (0x10208)
+#define MDP_PPP_BG_IMAGE_SIZE            (0x1020c)
+#define MDP_PPP_SCALE_CONFIG             (0x10230)
+#define MDP_PPP_CSC_CONFIG               (0x10240)
+#define MDP_PPP_BLEND_BG_ALPHA_SEL       (0x70010)
+
 #define MDP_TFETCH_TEST_MODE             (0x20004)
 #define MDP_TFETCH_STATUS                (0x20008)
 #define MDP_TFETCH_TILE_COUNT            (0x20010)
 #define MDP_TFETCH_FETCH_COUNT           (0x20014)
 #define MDP_TFETCH_CONSTANT_COLOR        (0x20040)
+#define MDP_BGTFETCH_TEST_MODE           (0x28004)
+#define MDP_BGTFETCH_STATUS              (0x28008)
+#define MDP_BGTFETCH_TILE_COUNT          (0x28010)
+#define MDP_BGTFETCH_FETCH_COUNT         (0x28014)
+#define MDP_BGTFETCH_CONSTANT_COLOR      (0x28040)
 #define MDP_CSC_BYPASS                   (0x40004)
 #define MDP_SCALE_COEFF_LSB              (0x5fffc)
 #define MDP_TV_OUT_CTL                   (0xc0000)
@@ -222,39 +248,22 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 #define MDP_LCDC_DMA_IBUF_ADDR           (0xe1008)
 #define MDP_LCDC_DMA_IBUF_Y_STRIDE       (0xe100c)
 
+#define MDP_PPP_SCALE_STATUS             (0x50000)
+#define MDP_PPP_BLEND_STATUS             (0x70000)
 
-#define MDP_DMA2_TERM 0x1
-#define MDP_DMA3_TERM 0x2
-#define MDP_PPP_TERM 0x3
+/* MDP_SW_RESET */
+#define MDP_PPP_SW_RESET                (1<<4)
 
 /* MDP_INTR_ENABLE */
-#define DL0_ROI_DONE           (1<<0)
-#define DL1_ROI_DONE           (1<<1)
-#define DL0_DMA2_TERM_DONE     (1<<2)
-#define DL1_DMA2_TERM_DONE     (1<<3)
-#define DL0_PPP_TERM_DONE      (1<<4)
-#define DL1_PPP_TERM_DONE      (1<<5)
-#define TV_OUT_DMA3_DONE       (1<<6)
-#define TV_ENC_UNDERRUN        (1<<7)
-#define DL0_FETCH_DONE         (1<<11)
-#define DL1_FETCH_DONE         (1<<12)
-
-#define MDP_PPP_BUSY_STATUS (DL0_ROI_DONE| \
-			   DL1_ROI_DONE| \
-			   DL0_PPP_TERM_DONE| \
-			   DL1_PPP_TERM_DONE)
-
-#define MDP_ANY_INTR_MASK (DL0_ROI_DONE| \
-			   DL1_ROI_DONE| \
-			   DL0_DMA2_TERM_DONE| \
-			   DL1_DMA2_TERM_DONE| \
-			   DL0_PPP_TERM_DONE| \
-			   DL1_PPP_TERM_DONE| \
-			   DL0_FETCH_DONE| \
-			   DL1_FETCH_DONE| \
-			   TV_ENC_UNDERRUN)
+#define DL0_ROI_DONE			(1<<0)
+#define TV_OUT_DMA3_DONE		(1<<6)
+#define TV_ENC_UNDERRUN			(1<<7)
 
+#ifdef CONFIG_MSM_MDP22
 #define MDP_DMA_P_DONE			(1 << 2)
+#else /* CONFIG_MSM_MDP31 */
+#define MDP_DMA_P_DONE			(1 << 14)
+#endif
 
 #define MDP_TOP_LUMA       16
 #define MDP_TOP_CHROMA     0
@@ -364,7 +373,12 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 #define PPP_OP_SCALE_X_ON (1<<0)
 #define PPP_OP_SCALE_Y_ON (1<<1)
 
+#ifndef CONFIG_MSM_MDP31
 #define PPP_OP_CONVERT_RGB2YCBCR 0
+#else
+#define PPP_OP_CONVERT_RGB2YCBCR (1<<30)
+#endif
+
 #define PPP_OP_CONVERT_YCBCR2RGB (1<<2)
 #define PPP_OP_CONVERT_ON (1<<3)
 
@@ -420,6 +434,13 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 #define PPP_OP_BG_CHROMA_SITE_COSITE 0
 #define PPP_OP_BG_CHROMA_SITE_OFFSITE (1<<27)
 
+#define PPP_BLEND_BG_USE_ALPHA_SEL      (1 << 0)
+#define PPP_BLEND_BG_ALPHA_REVERSE      (1 << 3)
+#define PPP_BLEND_BG_SRCPIXEL_ALPHA     (0 << 1)
+#define PPP_BLEND_BG_DSTPIXEL_ALPHA     (1 << 1)
+#define PPP_BLEND_BG_CONSTANT_ALPHA     (2 << 1)
+#define PPP_BLEND_BG_CONST_ALPHA_VAL(x) ((x) << 24)
+
 /* MDP_PPP_DESTINATION_CONFIG / MDP_FULL_BYPASS_WORD20 */
 #define PPP_DST_C0G_8BIT ((1<<0)|(1<<1))
 #define PPP_DST_C1B_8BIT ((1<<3)|(1<<2))
@@ -634,19 +655,53 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 /* pfmv is mv1, prmv is mv2 */
 #define MDP_CSC_PFMVn(n)		(0x40400 + (4 * (n)))
 #define MDP_CSC_PRMVn(n)		(0x40440 + (4 * (n)))
+
+#ifdef CONFIG_MSM_MDP31
+#define MDP_PPP_CSC_PRE_BV1n(n)		(0x40500 + (4 * (n)))
+#define MDP_PPP_CSC_PRE_BV2n(n)		(0x40540 + (4 * (n)))
+#define MDP_PPP_CSC_POST_BV1n(n)	(0x40580 + (4 * (n)))
+#define MDP_PPP_CSC_POST_BV2n(n)	(0x405c0 + (4 * (n)))
+
+#define MDP_PPP_CSC_PRE_LV1n(n)		(0x40600 + (4 * (n)))
+#define MDP_PPP_CSC_PRE_LV2n(n)		(0x40640 + (4 * (n)))
+#define MDP_PPP_CSC_POST_LV1n(n)	(0x40680 + (4 * (n)))
+#define MDP_PPP_CSC_POST_LV2n(n)	(0x406c0 + (4 * (n)))
+
+#define MDP_PPP_SCALE_COEFF_D0_SET	(0)
+#define MDP_PPP_SCALE_COEFF_D1_SET	(1)
+#define MDP_PPP_SCALE_COEFF_D2_SET	(2)
+#define MDP_PPP_SCALE_COEFF_U1_SET	(3)
+#define MDP_PPP_SCALE_COEFF_LSBn(n)	(0x50400 + (8 * (n)))
+#define MDP_PPP_SCALE_COEFF_MSBn(n)	(0x50404 + (8 * (n)))
+
+#define MDP_PPP_DEINT_COEFFn(n)		(0x30010 + (4 * (n)))
+
+#define MDP_PPP_SCALER_FIR		(0)
+#define MDP_PPP_SCALER_MN		(1)
+
+#else /* !defined(CONFIG_MSM_MDP31) */
 #define MDP_CSC_PBVn(n)			(0x40500 + (4 * (n)))
 #define MDP_CSC_SBVn(n)			(0x40540 + (4 * (n)))
 #define MDP_CSC_PLVn(n)			(0x40580 + (4 * (n)))
 #define MDP_CSC_SLVn(n)			(0x405c0 + (4 * (n)))
 
+#endif
+
 /* MDP_DMA_CONFIG / MDP_FULL_BYPASS_WORD32 */
-#define DMA_DSTC0G_6BITS (1<<1)
-#define DMA_DSTC1B_6BITS (1<<3)
-#define DMA_DSTC2R_6BITS (1<<5)
 #define DMA_DSTC0G_5BITS (1<<0)
 #define DMA_DSTC1B_5BITS (1<<2)
 #define DMA_DSTC2R_5BITS (1<<4)
 
+#define DMA_DSTC0G_6BITS (2<<0)
+#define DMA_DSTC1B_6BITS (2<<2)
+#define DMA_DSTC2R_6BITS (2<<4)
+
+#define DMA_DSTC0G_8BITS (3<<0)
+#define DMA_DSTC1B_8BITS (3<<2)
+#define DMA_DSTC2R_8BITS (3<<4)
+
+#define DMA_DST_BITS_MASK 0x3F
+
 #define DMA_PACK_TIGHT (1<<6)
 #define DMA_PACK_LOOSE 0
 #define DMA_PACK_ALIGN_LSB 0
@@ -657,23 +712,38 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 #define DMA_PACK_PATTERN_BGR \
 	(MDP_GET_PACK_PATTERN(0, CLR_B, CLR_G, CLR_R, 2)<<8)
 
+#ifdef CONFIG_MSM_MDP22
+
 #define DMA_OUT_SEL_AHB  0
 #define DMA_OUT_SEL_MDDI (1<<14)
 #define DMA_AHBM_LCD_SEL_PRIMARY 0
 #define DMA_AHBM_LCD_SEL_SECONDARY (1<<15)
 #define DMA_IBUF_C3ALPHA_EN (1<<16)
 #define DMA_DITHER_EN (1<<17)
-
 #define DMA_MDDI_DMAOUT_LCD_SEL_PRIMARY 0
 #define DMA_MDDI_DMAOUT_LCD_SEL_SECONDARY (1<<18)
 #define DMA_MDDI_DMAOUT_LCD_SEL_EXTERNAL (1<<19)
-
 #define DMA_IBUF_FORMAT_RGB565 (1<<20)
 #define DMA_IBUF_FORMAT_RGB888_OR_ARGB8888 0
 #define DMA_IBUF_FORMAT_MASK (1 << 20)
-
 #define DMA_IBUF_NONCONTIGUOUS (1<<21)
 
+#else /* CONFIG_MSM_MDP31 */
+
+#define DMA_OUT_SEL_AHB				(0 << 19)
+#define DMA_OUT_SEL_MDDI			(1 << 19)
+#define DMA_OUT_SEL_LCDC			(2 << 19)
+#define DMA_OUT_SEL_LCDC_MDDI			(3 << 19)
+#define DMA_DITHER_EN				(1 << 24)
+#define DMA_IBUF_FORMAT_RGB888			(0 << 25)
+#define DMA_IBUF_FORMAT_RGB565			(1 << 25)
+#define DMA_IBUF_FORMAT_XRGB8888		(2 << 25)
+#define DMA_IBUF_FORMAT_MASK			(3 << 25)
+#define DMA_IBUF_NONCONTIGUOUS			(0)
+#define DMA_MDDI_DMAOUT_LCD_SEL_PRIMARY		(0)
+#define DMA_MDDI_DMAOUT_LCD_SEL_SECONDARY	(0)
+#define DMA_MDDI_DMAOUT_LCD_SEL_EXTERNAL	(0)
+#endif
 /* MDDI REGISTER ? */
 #define MDDI_VDO_PACKET_DESC  0x5666
 #define MDDI_VDO_PACKET_PRIM  0xC3
diff --git a/drivers/video/msm/mdp_ppp.c b/drivers/video/msm/mdp_ppp.c
index 6d14c4f..8261f5a 100644
--- a/drivers/video/msm/mdp_ppp.c
+++ b/drivers/video/msm/mdp_ppp.c
@@ -67,17 +67,62 @@ static uint32_t bg_op_chroma[] = {
 	PPP_ARRAY1(CHROMA_SAMP, BG)
 };
 
+#ifdef CONFIG_MSM_MDP31
+static uint32_t get_luma_offset(struct mdp_img *img,
+				struct mdp_rect *rect, uint32_t bpp)
+{
+	return (rect->x + (rect->y * img->width)) * bpp;
+}
+
+static uint32_t get_chroma_offset(struct mdp_img *img,
+				  struct mdp_rect *rect, uint32_t bpp)
+{
+	uint32_t compress_v = Y_TO_CRCB_RATIO(img->format);
+	uint32_t compress_h = 2;
+	uint32_t offset = 0;
+
+	if (IS_PSEUDOPLNR(img->format)) {
+		offset = (rect->x / compress_h) * compress_h;
+		offset += rect->y == 0 ? 0 :
+			  ((rect->y + 1) / compress_v) * img->width;
+		offset *= bpp;
+	}
+	return offset;
+}
+
 static void set_src_region(struct mdp_img *img, struct mdp_rect *rect,
 			   struct ppp_regs *regs)
 {
 	regs->src_rect = (rect->h << 16) | (rect->w & 0x1fff);
-
+	regs->src_xy = (rect->y << 16) | (rect->x & 0x1fff);
+	regs->src_img_sz = (img->height << 16) | (img->width & 0x1fff);
 }
 
 static inline void set_dst_region(struct mdp_rect *rect, struct ppp_regs *regs)
 {
 	regs->dst_rect = (rect->h << 16) | (rect->w & 0xfff);
+	regs->dst_xy = (rect->y << 16) | (rect->x & 0x1fff);
+}
+
+static void set_blend_region(struct mdp_img *img, struct mdp_rect *rect,
+			     struct ppp_regs *regs)
+{
+	uint32_t rect_x = rect->x;
+	uint32_t rect_y = rect->y;
+	uint32_t img_w = img->width;
+	uint32_t img_h = img->height;
+
+	/* HW bug workaround */
+	if (img->format == MDP_YCRYCB_H2V1) {
+		regs->bg0 += (rect_x + (rect_y * img_w)) * regs->bg_bpp;
+		rect_x = 0;
+		rect_y = 0;
+		img_w = rect->w;
+		img_h = rect->h;
+	}
 
+	regs->bg_xy = (rect_y << 16) | (rect_x & 0x1fff);
+	regs->bg_img_sz = (img_h << 16) | (img_w & 0x1fff);
 }
 
 static void rotate_dst_addr_x(struct mdp_blit_req *req,
@@ -100,6 +145,8 @@ static void rotate_dst_addr_y(struct mdp_blit_req *req,
 		       regs->dst_ystride;
 }
 
+#else
+
 static uint32_t get_luma_offset(struct mdp_img *img,
 				struct mdp_rect *rect, uint32_t bpp)
 {
@@ -111,6 +158,31 @@ static uint32_t get_chroma_offset(struct mdp_img *img,
 {
 	return 0;
 }
+
+static void set_src_region(struct mdp_img *img, struct mdp_rect *rect,
+			   struct ppp_regs *regs)
+{
+	regs->src_rect = (rect->h << 16) | (rect->w & 0x1fff);
+}
+
+static inline void set_dst_region(struct mdp_rect *rect, struct ppp_regs *regs)
+{
+	regs->dst_rect = (rect->h << 16) | (rect->w & 0xfff);
+}
+
+static void set_blend_region(struct mdp_img *img, struct mdp_rect *rect,
+			     struct ppp_regs *regs)
+{}
+
+static void rotate_dst_addr_x(struct mdp_blit_req *req,
+			      struct ppp_regs *regs)
+{}
+
+static void rotate_dst_addr_y(struct mdp_blit_req *req,
+			      struct ppp_regs *regs)
+{}
+#endif
+
 static void blit_rotate(struct mdp_blit_req *req,
 			struct ppp_regs *regs)
 {
@@ -137,10 +209,18 @@ static void blit_convert(struct mdp_blit_req *req, struct ppp_regs *regs)
 		return;
 	if (IS_RGB(req->src.format) && IS_YCRCB(req->dst.format)) {
 		regs->op |= PPP_OP_CONVERT_RGB2YCBCR | PPP_OP_CONVERT_ON;
+#ifdef CONFIG_MSM_MDP31
+		/* primary really means set1 */
+		regs->op |= PPP_OP_CONVERT_MATRIX_PRIMARY;
+		regs->csc_cfg = 0x1e;
+#endif
 	} else if (IS_YCRCB(req->src.format) && IS_RGB(req->dst.format)) {
 		regs->op |= PPP_OP_CONVERT_YCBCR2RGB | PPP_OP_CONVERT_ON;
-		if (req->dst.format == MDP_RGB_565)
-			regs->op |= PPP_OP_CONVERT_MATRIX_SECONDARY;
+#ifdef CONFIG_MSM_MDP31
+		/* secondary really means set2 */
+		regs->op |= PPP_OP_CONVERT_MATRIX_SECONDARY;
+		regs->csc_cfg = 0;
+#endif
 	}
 }
 
@@ -214,6 +294,7 @@ static void blit_blend(struct mdp_blit_req *req, struct ppp_regs *regs)
 	regs->bg_bpp = regs->dst_bpp;
 	regs->bg_pack = pack_pattern[req->dst.format];
 	regs->bg_ystride = regs->dst_ystride;
+	set_blend_region(&req->dst, &req->dst_rect, regs);
 }
 
 static int blit_scale(const struct mdp_info *mdp, struct mdp_blit_req *req,
@@ -236,7 +317,7 @@ static int blit_scale(const struct mdp_info *mdp, struct mdp_blit_req *req,
 		return 0;
 	}
 
-#ifdef CONFIG_MSM_MDP22
+#if defined(CONFIG_MSM_MDP31) || defined(CONFIG_MSM_MDP22)
 	if (mdp_ppp_cfg_scale(mdp, regs, &req->src_rect, &dst_rect,
 			      req->src.format, req->dst.format)) {
 		DLOG("crap, bad scale\n");
@@ -251,13 +332,13 @@ static int blit_scale(const struct mdp_info *mdp, struct mdp_blit_req *req,
 static void blit_blur(const struct mdp_info *mdp, struct mdp_blit_req *req,
 		      struct ppp_regs *regs)
 {
-#ifdef CONFIG_MSM_MDP22
+#if defined(CONFIG_MSM_MDP31) || defined(CONFIG_MSM_MDP22)
 	int ret;
 #endif
 	if (!(req->flags & MDP_BLUR))
 		return;
 
-#ifdef CONFIG_MSM_MDP22
+#if defined(CONFIG_MSM_MDP31) || defined(CONFIG_MSM_MDP22)
 	ret = mdp_ppp_load_blur(mdp);
 	if (ret)
 		return;
@@ -354,7 +435,17 @@ static int send_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 	mdp_writel_dbg(mdp, regs->phasex_step, PPP_ADDR_PHASEX_STEP);
 	mdp_writel_dbg(mdp, regs->phasey_step, PPP_ADDR_PHASEY_STEP);
 
+#ifdef CONFIG_MSM_MDP31
+	mdp_writel_dbg(mdp, regs->scale_cfg, MDP_PPP_SCALE_CONFIG);
+	mdp_writel_dbg(mdp, regs->csc_cfg, MDP_PPP_CSC_CONFIG);
+	mdp_writel_dbg(mdp, regs->src_xy, MDP_PPP_SRC_XY);
+	mdp_writel_dbg(mdp, regs->src_img_sz, MDP_PPP_SRC_IMAGE_SIZE);
+	mdp_writel_dbg(mdp, regs->dst_xy, MDP_PPP_OUT_XY);
+#else
+	/* no edge conditions to set for MDP 3.1 */
 	mdp_writel_dbg(mdp, regs->edge, PPP_ADDR_EDGE);
+#endif
+
 	mdp_writel_dbg(mdp, (req->alpha << 24) | (req->transp_mask & 0xffffff),
 	       PPP_ADDR_ALPHA_TRANSP);
 
@@ -371,6 +462,12 @@ static int send_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 		mdp_writel_dbg(mdp, regs->bg_ystride, PPP_ADDR_BG_YSTRIDE);
 		mdp_writel_dbg(mdp, regs->bg_cfg, PPP_ADDR_BG_CFG);
 		mdp_writel_dbg(mdp, regs->bg_pack, PPP_ADDR_BG_PACK_PATTERN);
+#ifdef CONFIG_MSM_MDP31
+		mdp_writel_dbg(mdp, regs->bg_xy, MDP_PPP_BG_XY);
+		mdp_writel_dbg(mdp, regs->bg_img_sz, MDP_PPP_BG_IMAGE_SIZE);
+		mdp_writel_dbg(mdp, regs->bg_alpha_sel,
+			       MDP_PPP_BLEND_BG_ALPHA_SEL);
+#endif
 	}
 	flush_imgs(req, regs, src_file, dst_file);
 	mdp_writel_dbg(mdp, 0x1000, MDP_DISPLAY0_START);
@@ -436,6 +533,12 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 	regs.dst_ystride = req->dst.width * regs.dst_bpp;
 	set_dst_region(&req->dst_rect, &regs);
 
+	/* for simplicity, always write the chroma stride */
+	regs.src_ystride &= 0x3fff;
+	regs.src_ystride |= regs.src_ystride << 16;
+	regs.dst_ystride &= 0x3fff;
+	regs.dst_ystride |= regs.dst_ystride << 16;
+
 	if (!valid_src_dst(src_start, src_len, dst_start, dst_len, req,
 			   &regs)) {
 		printk(KERN_ERR "mdp_ppp: final src or dst location is "
@@ -467,7 +570,7 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 		req->dst_rect.w = req->dst_rect.w & (~0x1);
 	}
 
-#ifdef CONFIG_MSM_MDP22
+#if defined(CONFIG_MSM_MDP31) || defined(CONFIG_MSM_MDP22)
 	if (mdp_ppp_cfg_edge_cond(req, &regs))
 		return -EINVAL;
 #endif
diff --git a/drivers/video/msm/mdp_ppp.h b/drivers/video/msm/mdp_ppp.h
index c3cd895..e045643 100644
--- a/drivers/video/msm/mdp_ppp.h
+++ b/drivers/video/msm/mdp_ppp.h
@@ -45,6 +45,18 @@ struct ppp_regs {
 	uint32_t bg_bpp;
 	uint32_t bg_pack;
 	uint32_t bg_ystride;
+
+#ifdef CONFIG_MSM_MDP31
+	uint32_t src_xy;
+	uint32_t src_img_sz;
+	uint32_t dst_xy;
+	uint32_t bg_xy;
+	uint32_t bg_img_sz;
+	uint32_t bg_alpha_sel;
+
+	uint32_t scale_cfg;
+	uint32_t csc_cfg;
+#endif
 };
 
 struct mdp_info;
@@ -57,6 +69,14 @@ int mdp_ppp_cfg_scale(const struct mdp_info *mdp, struct ppp_regs *regs,
 		      uint32_t src_format, uint32_t dst_format);
 int mdp_ppp_load_blur(const struct mdp_info *mdp);
 
+#ifndef CONFIG_MSM_MDP31
 int mdp_ppp_cfg_edge_cond(struct mdp_blit_req *req, struct ppp_regs *regs);
+#else
+static inline int mdp_ppp_cfg_edge_cond(struct mdp_blit_req *req,
+				 struct ppp_regs *regs)
+{
+	return 0;
+}
+#endif
 
 #endif /* _VIDEO_MSM_MDP_PPP_H_ */
diff --git a/drivers/video/msm/mdp_ppp31.c b/drivers/video/msm/mdp_ppp31.c
new file mode 100644
index 0000000..ad81b00
--- /dev/null
+++ b/drivers/video/msm/mdp_ppp31.c
@@ -0,0 +1,335 @@
+/* drivers/video/msm/mdp_ppp31.c
+ *
+ * Copyright (C) 2009, 2011 Code Aurora Forum. All rights reserved.
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
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <linux/msm_mdp.h>
+
+#include "mdp_hw.h"
+#include "mdp_ppp.h"
+
+#define NUM_COEFFS			32
+
+struct mdp_scale_coeffs {
+	/*
+	 * signed 10-bit coeffs that need to be be 16-bit aligned
+	 */
+	uint16_t	c[4][NUM_COEFFS];
+};
+
+struct mdp_scale_tbl_info {
+	uint16_t			offset;
+	uint32_t			set:2;
+	int				use_pr;
+	struct mdp_scale_coeffs		coeffs;
+};
+
+enum {
+	MDP_SCALE_PT2TOPT4,
+	MDP_SCALE_PT4TOPT6,
+	MDP_SCALE_PT6TOPT8,
+	MDP_SCALE_PT8TO8,
+	MDP_SCALE_MAX,
+};
+
+static struct mdp_scale_coeffs mdp_scale_pr_coeffs = {
+	.c = {
+		[0] = {
+			0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0, 0,
+		},
+		[1] = {
+			511, 511, 511, 511, 511, 511, 511, 511,
+			511, 511, 511, 511, 511, 511, 511, 511,
+			0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0, 0,
+		},
+		[2] = {
+			0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0, 0,
+			511, 511, 511, 511, 511, 511, 511, 511,
+			511, 511, 511, 511, 511, 511, 511, 511,
+		},
+		[3] = {
+			0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0, 0,
+		},
+	},
+};
+
+static struct mdp_scale_tbl_info mdp_scale_tbl[MDP_SCALE_MAX] = {
+	[MDP_SCALE_PT2TOPT4]	= {
+		.offset		= 0,
+		.set		= MDP_PPP_SCALE_COEFF_D0_SET,
+		.use_pr		= -1,
+		.coeffs.c	= {
+			[0] = {
+				131, 131, 130, 129, 128, 127, 127, 126,
+				125, 125, 124, 123, 123, 121, 120, 119,
+				119, 118, 117, 117, 116, 115, 115, 114,
+				113, 112, 111, 110, 109, 109, 108, 107,
+			},
+			[1] = {
+				141, 140, 140, 140, 140, 139, 138, 138,
+				138, 137, 137, 137, 136, 137, 137, 137,
+				136, 136, 136, 135, 135, 135, 134, 134,
+				134, 134, 134, 133, 133, 132, 132, 132,
+			},
+			[2] = {
+				132, 132, 132, 133, 133, 134, 134, 134,
+				134, 134, 135, 135, 135, 136, 136, 136,
+				137, 137, 137, 136, 137, 137, 137, 138,
+				138, 138, 139, 140, 140, 140, 140, 141,
+			},
+			[3] = {
+				107, 108, 109, 109, 110, 111, 112, 113,
+				114, 115, 115, 116, 117, 117, 118, 119,
+				119, 120, 121, 123, 123, 124, 125, 125,
+				126, 127, 127, 128, 129, 130, 131, 131,
+			}
+		},
+	},
+	[MDP_SCALE_PT4TOPT6] = {
+		.offset		= 32,
+		.set		= MDP_PPP_SCALE_COEFF_D1_SET,
+		.use_pr		= -1,
+		.coeffs.c	= {
+			[0] = {
+				136, 132, 128, 123, 119, 115, 111, 107,
+				103, 98, 95, 91, 87, 84, 80, 76,
+				73, 69, 66, 62, 59, 57, 54, 50,
+				47, 44, 41, 39, 36, 33, 32, 29,
+			},
+			[1] = {
+				206, 205, 204, 204, 201, 200, 199, 197,
+				196, 194, 191, 191, 189, 185, 184, 182,
+				180, 178, 176, 173, 170, 168, 165, 162,
+				160, 157, 155, 152, 148, 146, 142, 140,
+			},
+			[2] = {
+				140, 142, 146, 148, 152, 155, 157, 160,
+				162, 165, 168, 170, 173, 176, 178, 180,
+				182, 184, 185, 189, 191, 191, 194, 196,
+				197, 199, 200, 201, 204, 204, 205, 206,
+			},
+			[3] = {
+				29, 32, 33, 36, 39, 41, 44, 47,
+				50, 54, 57, 59, 62, 66, 69, 73,
+				76, 80, 84, 87, 91, 95, 98, 103,
+				107, 111, 115, 119, 123, 128, 132, 136,
+			},
+		},
+	},
+	[MDP_SCALE_PT6TOPT8] = {
+		.offset		= 64,
+		.set		= MDP_PPP_SCALE_COEFF_D2_SET,
+		.use_pr		= -1,
+		.coeffs.c	= {
+			[0] = {
+				104, 96, 89, 82, 75, 68, 61, 55,
+				49, 43, 38, 33, 28, 24, 20, 16,
+				12, 9, 6, 4, 2, 0, -2, -4,
+				-5, -6, -7, -7, -8, -8, -8, -8,
+			},
+			[1] = {
+				303, 303, 302, 300, 298, 296, 293, 289,
+				286, 281, 276, 270, 265, 258, 252, 245,
+				238, 230, 223, 214, 206, 197, 189, 180,
+				172, 163, 154, 145, 137, 128, 120, 112,
+			},
+			[2] = {
+				112, 120, 128, 137, 145, 154, 163, 172,
+				180, 189, 197, 206, 214, 223, 230, 238,
+				245, 252, 258, 265, 270, 276, 281, 286,
+				289, 293, 296, 298, 300, 302, 303, 303,
+			},
+			[3] = {
+				-8, -8, -8, -8, -7, -7, -6, -5,
+				-4, -2, 0, 2, 4, 6, 9, 12,
+				16, 20, 24, 28, 33, 38, 43, 49,
+				55, 61, 68, 75, 82, 89, 96, 104,
+			},
+		},
+	},
+	[MDP_SCALE_PT8TO8] = {
+		.offset		= 96,
+		.set		= MDP_PPP_SCALE_COEFF_U1_SET,
+		.use_pr		= -1,
+		.coeffs.c	= {
+			[0] = {
+				0, -7, -13, -19, -24, -28, -32, -34,
+				-37, -39, -40, -41, -41, -41, -40, -40,
+				-38, -37, -35, -33, -31, -29, -26, -24,
+				-21, -18, -15, -13, -10, -7, -5, -2,
+			},
+			[1] = {
+				511, 507, 501, 494, 485, 475, 463, 450,
+				436, 422, 405, 388, 370, 352, 333, 314,
+				293, 274, 253, 233, 213, 193, 172, 152,
+				133, 113, 95, 77, 60, 43, 28, 13,
+			},
+			[2] = {
+				0, 13, 28, 43, 60, 77, 95, 113,
+				133, 152, 172, 193, 213, 233, 253, 274,
+				294, 314, 333, 352, 370, 388, 405, 422,
+				436, 450, 463, 475, 485, 494, 501, 507,
+			},
+			[3] = {
+				0, -2, -5, -7, -10, -13, -15, -18,
+				-21, -24, -26, -29, -31, -33, -35, -37,
+				-38, -40, -40, -41, -41, -41, -40, -39,
+				-37, -34, -32, -28, -24, -19, -13, -7,
+			},
+		},
+	},
+};
+
+static void load_table(const struct mdp_info *mdp, int scale, int use_pr)
+{
+	int i;
+	uint32_t val;
+	struct mdp_scale_coeffs *coeffs;
+	struct mdp_scale_tbl_info *tbl = &mdp_scale_tbl[scale];
+
+	if (use_pr == tbl->use_pr)
+		return;
+
+	tbl->use_pr = use_pr;
+	if (!use_pr)
+		coeffs = &tbl->coeffs;
+	else
+		coeffs = &mdp_scale_pr_coeffs;
+
+	for (i = 0; i < NUM_COEFFS; ++i) {
+		val = ((coeffs->c[1][i] & 0x3ff) << 16) |
+			(coeffs->c[0][i] & 0x3ff);
+		mdp_writel(mdp, val, MDP_PPP_SCALE_COEFF_LSBn(tbl->offset + i));
+
+		val = ((coeffs->c[3][i] & 0x3ff) << 16) |
+			(coeffs->c[2][i] & 0x3ff);
+		mdp_writel(mdp, val, MDP_PPP_SCALE_COEFF_MSBn(tbl->offset + i));
+	}
+}
+
+#define SCALER_PHASE_BITS		29
+static void scale_params(uint32_t dim_in, uint32_t dim_out, uint32_t scaler,
+			 uint32_t *phase_init, uint32_t *phase_step)
+{
+	uint64_t src = dim_in;
+	uint64_t dst = dim_out;
+	uint64_t numer;
+	uint64_t denom;
+
+	*phase_init = 0;
+
+	if (dst == 1) {
+		/* if destination is 1 pixel wide, the value of phase_step
+		 * is unimportant. */
+		*phase_step = (uint32_t) (src << SCALER_PHASE_BITS);
+		if (scaler == MDP_PPP_SCALER_FIR)
+			*phase_init =
+				(uint32_t) ((src - 1) << SCALER_PHASE_BITS);
+		return;
+	}
+
+	if (scaler == MDP_PPP_SCALER_FIR) {
+		numer = (src - 1) << SCALER_PHASE_BITS;
+		denom = dst - 1;
+		/* we want to round up the result*/
+		numer += denom - 1;
+	} else {
+		numer = src << SCALER_PHASE_BITS;
+		denom = dst;
+	}
+
+	do_div(numer, denom);
+	*phase_step = (uint32_t) numer;
+}
+
+static int scale_idx(int factor)
+{
+	int idx;
+
+	if (factor > 80)
+		idx = MDP_SCALE_PT8TO8;
+	else if (factor > 60)
+		idx = MDP_SCALE_PT6TOPT8;
+	else if (factor > 40)
+		idx = MDP_SCALE_PT4TOPT6;
+	else
+		idx = MDP_SCALE_PT2TOPT4;
+
+	return idx;
+}
+
+int mdp_ppp_cfg_scale(const struct mdp_info *mdp, struct ppp_regs *regs,
+		      struct mdp_rect *src_rect, struct mdp_rect *dst_rect,
+		      uint32_t src_format, uint32_t dst_format)
+{
+	uint32_t x_fac;
+	uint32_t y_fac;
+	uint32_t scaler_x = MDP_PPP_SCALER_FIR;
+	uint32_t scaler_y = MDP_PPP_SCALER_FIR;
+	/* Don't use pixel repeat mode, it looks bad */
+	int use_pr = 0;
+	int x_idx;
+	int y_idx;
+
+	if (unlikely(src_rect->w > 2048 || src_rect->h > 2048))
+		return -ENOTSUPP;
+
+	x_fac = (dst_rect->w * 100) / src_rect->w;
+	y_fac = (dst_rect->h * 100) / src_rect->h;
+
+	/* if down-scaling by a factor smaller than 1/4, use M/N */
+	scaler_x = x_fac <= 25 ? MDP_PPP_SCALER_MN : MDP_PPP_SCALER_FIR;
+	scaler_y = y_fac <= 25 ? MDP_PPP_SCALER_MN : MDP_PPP_SCALER_FIR;
+	scale_params(src_rect->w, dst_rect->w, scaler_x, &regs->phasex_init,
+		     &regs->phasex_step);
+	scale_params(src_rect->h, dst_rect->h, scaler_y, &regs->phasey_init,
+		     &regs->phasey_step);
+
+	x_idx = scale_idx(x_fac);
+	y_idx = scale_idx(y_fac);
+	load_table(mdp, x_idx, use_pr);
+	load_table(mdp, y_idx, use_pr);
+
+	regs->scale_cfg = 0;
+	/* Enable SVI when source or destination is YUV */
+	if (!IS_RGB(src_format) && !IS_RGB(dst_format))
+		regs->scale_cfg |= (1 << 6);
+	regs->scale_cfg |= (mdp_scale_tbl[x_idx].set << 2) |
+		(mdp_scale_tbl[x_idx].set << 4);
+	regs->scale_cfg |= (scaler_x << 0) | (scaler_y << 1);
+
+	return 0;
+}
+
+int mdp_ppp_load_blur(const struct mdp_info *mdp)
+{
+	return -ENOTSUPP;
+}
+
+void mdp_ppp_init_scale(const struct mdp_info *mdp)
+{
+	int scale;
+	for (scale = 0; scale < MDP_SCALE_MAX; ++scale)
+		load_table(mdp, scale, 0);
+}
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

