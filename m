Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819Ab1CRV6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:58:00 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47794 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932524Ab1CRV5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:57:53 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6289"; a="80648567"
X-IronPort-AV: E=Sophos;i="4.63,205,1299484800"; 
   d="scan'208";a="37044928"
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
Subject: [PATCH 11/20] video: msm: Add MDP FB DMA configuration
Date: Fri, 18 Mar 2011 14:57:50 -0700
Message-Id: <1300485470-27360-1-git-send-email-carlv@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setup configure_dma, check_output_format and set_output_format functions.

Authors:
Dima Zavin <dima@android.com>
Rebecca Schultz Zavin <rebecca@android.com>
Colin Cross <ccross@android.com>

Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/msm_fb.h |    3 ++
 drivers/video/msm/mdp.c                 |   61 ++++++++++++++++++++++++++++++-
 drivers/video/msm/mdp_hw.h              |   16 ++++++++
 drivers/video/msm/msm_fb.c              |    5 ++-
 4 files changed, 83 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/msm_fb.h b/arch/arm/mach-msm/include/mach/msm_fb.h
index 2d0899c..238ea2a 100644
--- a/arch/arm/mach-msm/include/mach/msm_fb.h
+++ b/arch/arm/mach-msm/include/mach/msm_fb.h
@@ -123,6 +123,9 @@ struct mdp_device {
 	int (*blit)(struct mdp_device *mdp, struct fb_info *fb,
 		    struct mdp_blit_req *req);
 	void (*set_grp_disp)(struct mdp_device *mdp, uint32_t disp_id);
+	void (*configure_dma)(struct mdp_device *mdp);
+	int (*check_output_format)(struct mdp_device *mdp, int bpp);
+	int (*set_output_format)(struct mdp_device *mdp, int bpp);
 };
 
 struct class_interface;
diff --git a/drivers/video/msm/mdp.c b/drivers/video/msm/mdp.c
index 95e19e5..15241b4 100644
--- a/drivers/video/msm/mdp.c
+++ b/drivers/video/msm/mdp.c
@@ -223,7 +223,7 @@ static void mdp_dma_to_mddi(void *priv, uint32_t addr, uint32_t stride,
 		DMA_OUT_SEL_AHB |
 		DMA_IBUF_NONCONTIGUOUS;
 
-	dma2_cfg |= DMA_IBUF_FORMAT_RGB565;
+	dma2_cfg |= mdp->format;
 
 	dma2_cfg |= DMA_OUT_SEL_MDDI;
 
@@ -304,6 +304,62 @@ void put_img(struct file *src_file, struct file *dst_file)
 {
 }
 
+void mdp_configure_dma(struct mdp_device *mdp_dev)
+{
+	struct mdp_info *mdp = container_of(mdp_dev, struct mdp_info, mdp_dev);
+	uint32_t dma_cfg;
+
+	if (!mdp->dma_config_dirty)
+		return;
+	dma_cfg = mdp_readl(mdp, MDP_DMA_P_CONFIG);
+	dma_cfg &= ~DMA_IBUF_FORMAT_MASK;
+	dma_cfg &= ~DMA_PACK_PATTERN_MASK;
+	dma_cfg |= (mdp->format | mdp->pack_pattern);
+	mdp_writel(mdp, dma_cfg, MDP_DMA_P_CONFIG);
+	mdp->dma_config_dirty = false;
+
+	return;
+}
+
+int mdp_check_output_format(struct mdp_device *mdp_dev, int bpp)
+{
+	switch (bpp) {
+	case 16:
+	case 24:
+	case 32:
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+int mdp_set_output_format(struct mdp_device *mdp_dev, int bpp)
+{
+	struct mdp_info *mdp = container_of(mdp_dev, struct mdp_info, mdp_dev);
+	uint32_t format, pack_pattern;
+
+	switch (bpp) {
+	case 16:
+		format = DMA_IBUF_FORMAT_RGB565;
+		pack_pattern = DMA_PACK_PATTERN_RGB;
+		break;
+	case 24:
+	case 32:
+		format = DMA_IBUF_FORMAT_RGB888_OR_ARGB8888;
+		break;
+	default:
+		return -EINVAL;
+	}
+	if (format != mdp->format || pack_pattern != mdp->pack_pattern) {
+		mdp->format = format;
+		mdp->pack_pattern = pack_pattern;
+		mdp->dma_config_dirty = true;
+	}
+
+	return 0;
+}
+
 int mdp_blit_and_wait(struct mdp_info *mdp, struct mdp_blit_req *req,
 		struct file *src_file, unsigned long src_start,
 		unsigned long src_len, struct file *dst_file,
@@ -540,6 +596,9 @@ int mdp_probe(struct platform_device *pdev)
 	mdp->mdp_dev.dma_wait = mdp_dma_wait;
 	mdp->mdp_dev.blit = mdp_blit;
 	mdp->mdp_dev.set_grp_disp = mdp_set_grp_disp;
+	mdp->mdp_dev.set_output_format = mdp_set_output_format;
+	mdp->mdp_dev.check_output_format = mdp_check_output_format;
+	mdp->mdp_dev.configure_dma = mdp_configure_dma;
 
 	ret = mdp_out_if_register(&mdp->mdp_dev, MSM_MDDI_PMDH_INTERFACE, mdp,
 				  MDP_DMA_P_DONE, mdp_dma_to_mddi);
diff --git a/drivers/video/msm/mdp_hw.h b/drivers/video/msm/mdp_hw.h
index 34a204e..cc48218 100644
--- a/drivers/video/msm/mdp_hw.h
+++ b/drivers/video/msm/mdp_hw.h
@@ -42,6 +42,9 @@ struct mdp_info {
 	int irq;
 	struct clk *clk;
 	struct mdp_out_interface out_if[MSM_MDP_NUM_INTERFACES];
+	int format;
+	int pack_pattern;
+	bool dma_config_dirty;
 };
 
 extern int mdp_out_if_register(struct mdp_device *mdp_dev, int interface,
@@ -183,6 +186,15 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 #define MDP_TEST_CAPTURED_DCLK           (0xd0210)
 #define MDP_TEST_MISR_CAPT_VAL_DCLK      (0xd0214)
 #define MDP_LCDC_CTL                     (0xe0000)
+
+#define MDP_DMA_P_START                  (0x00044)
+#define MDP_DMA_P_CONFIG                 (0x90000)
+#define MDP_DMA_P_SIZE                   (0x90004)
+#define MDP_DMA_P_IBUF_ADDR              (0x90008)
+#define MDP_DMA_P_IBUF_Y_STRIDE          (0x9000c)
+#define MDP_DMA_P_OUT_XY                 (0x90010)
+#define MDP_DMA_P_COLOR_CORRECT_CONFIG   (0x90070)
+
 #define MDP_LCDC_HSYNC_CTL               (0xe0004)
 #define MDP_LCDC_VSYNC_CTL               (0xe0008)
 #define MDP_LCDC_ACTIVE_HCTL             (0xe000c)
@@ -629,8 +641,11 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 #define DMA_PACK_LOOSE 0
 #define DMA_PACK_ALIGN_LSB 0
 #define DMA_PACK_ALIGN_MSB (1<<7)
+#define DMA_PACK_PATTERN_MASK (0x3f<<8)
 #define DMA_PACK_PATTERN_RGB \
 	(MDP_GET_PACK_PATTERN(0, CLR_R, CLR_G, CLR_B, 2)<<8)
+#define DMA_PACK_PATTERN_BGR \
+	(MDP_GET_PACK_PATTERN(0, CLR_B, CLR_G, CLR_R, 2)<<8)
 
 #define DMA_OUT_SEL_AHB  0
 #define DMA_OUT_SEL_MDDI (1<<14)
@@ -645,6 +660,7 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 
 #define DMA_IBUF_FORMAT_RGB565 (1<<20)
 #define DMA_IBUF_FORMAT_RGB888_OR_ARGB8888 0
+#define DMA_IBUF_FORMAT_MASK (1 << 20)
 
 #define DMA_IBUF_NONCONTIGUOUS (1<<21)
 
diff --git a/drivers/video/msm/msm_fb.c b/drivers/video/msm/msm_fb.c
index 6af8b41..ccd7417 100644
--- a/drivers/video/msm/msm_fb.c
+++ b/drivers/video/msm/msm_fb.c
@@ -332,7 +332,7 @@ static int msmfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 	if ((var->xres != info->var.xres) ||
 	    (var->yres != info->var.yres) ||
 	    (var->xoffset != info->var.xoffset) ||
-	    (var->bits_per_pixel != info->var.bits_per_pixel) ||
+	    (mdp->check_output_format(mdp, var->bits_per_pixel)) ||
 	    (var->grayscale != info->var.grayscale))
 		 return -EINVAL;
 
@@ -365,6 +365,7 @@ static int msmfb_set_par(struct fb_info *info)
 		var->blue.length = 5;
 	} else
 		return -1;
+	mdp->set_output_format(mdp, var->bits_per_pixel);
 	fix->line_length = var->xres * var->bits_per_pixel / 8;
 
 	return 0;
@@ -519,6 +520,8 @@ static void setup_fb_info(struct msmfb_info *msmfb)
 	fb_info->var.blue.length = 5;
 	fb_info->var.blue.msb_right = 0;
 
+	mdp->set_output_format(mdp, fb_info->var.bits_per_pixel);
+
 	r = fb_alloc_cmap(&fb_info->cmap, 16, 0);
 	fb_info->pseudo_palette = PP;
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

