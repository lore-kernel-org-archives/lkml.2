Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810Ab1CRV5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:57:39 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47774 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932524Ab1CRV5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:57:34 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6289"; a="80648538"
X-IronPort-AV: E=Sophos;i="4.63,205,1299484800"; 
   d="scan'208";a="37044918"
From: Carl Vanderlip <carlv@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>, linux-fbdev@vger.kernel.org,
        Carl Vanderlip <carlv@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/20] video: msm: Separate more MDP HW specific code
Date: Fri, 18 Mar 2011 14:57:27 -0700
Message-Id: <1300485447-27320-1-git-send-email-carlv@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplifies mdp_probe by moving register initialization to
mdp_hw_init

Authors:
Dima Zavin <dima@android.com>
Rebecca Schultz Zavin <rebecca@android.com>
Colin Cross <ccross@android.com>

Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>
---
 drivers/video/msm/mdp.c           |   96 ++++++++++++++++++-------------------
 drivers/video/msm/mdp_csc_table.h |   95 ++++++++++++++++--------------------
 drivers/video/msm/mdp_hw.h        |    9 ++++
 3 files changed, 98 insertions(+), 102 deletions(-)

diff --git a/drivers/video/msm/mdp.c b/drivers/video/msm/mdp.c
index 6aa9ed5..95e19e5 100644
--- a/drivers/video/msm/mdp.c
+++ b/drivers/video/msm/mdp.c
@@ -36,11 +36,6 @@ struct class *mdp_class;
 
 #define MDP_CMD_DEBUG_ACCESS_BASE (0x10000)
 
-static uint16_t mdp_default_ccs[] = {
-	0x254, 0x000, 0x331, 0x254, 0xF38, 0xE61, 0x254, 0x409, 0x000,
-	0x010, 0x080, 0x080
-};
-
 static DECLARE_WAIT_QUEUE_HEAD(mdp_ppp_waitqueue);
 static unsigned int mdp_irq_mask;
 DEFINE_MUTEX(mdp_mutex);
@@ -457,6 +452,52 @@ int register_mdp_client(struct class_interface *cint)
 
 void mdp_hw_init(struct mdp_info *mdp)
 {
+	int n;
+
+	mdp_irq_mask = 0;
+
+	mdp_writel(mdp, 0, MDP_INTR_ENABLE);
+
+	/* debug interface write access */
+	mdp_writel(mdp, 1, 0x60);
+	mdp_writel(mdp, 1, MDP_EBI2_PORTMAP_MODE);
+
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01f8);
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01fc);
+	mdp_writel(mdp, 1, 0x60);
+
+	for (n = 0; n < ARRAY_SIZE(csc_color_lut); n++)
+		mdp_writel(mdp, csc_color_lut[n].val, csc_color_lut[n].reg);
+
+	/* clear up unused fg/main registers */
+	/* comp.plane 2&3 ystride */
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0120);
+
+	/* unpacked pattern */
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x012c);
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0130);
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0134);
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0158);
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x015c);
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0160);
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0170);
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0174);
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x017c);
+
+	/* comp.plane 2 & 3 */
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0114);
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0118);
+
+	/* clear unused bg registers */
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01c8);
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01d0);
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01dc);
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01e0);
+	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01e4);
+
+	for (n = 0; n < ARRAY_SIZE(csc_matrix_config_table); n++)
+		mdp_writel(mdp, csc_matrix_config_table[n].val,
+			   csc_matrix_config_table[n].reg);
 #ifdef CONFIG_MSM_MDP22
 	mdp_ppp_init_scale(mdp);
 #endif
@@ -466,7 +507,6 @@ int mdp_probe(struct platform_device *pdev)
 {
 	struct resource *resource;
 	int ret;
-	int n;
 	struct mdp_info *mdp;
 
 	resource = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -517,52 +557,8 @@ int mdp_probe(struct platform_device *pdev)
 	if (ret)
 		goto error_request_irq;
 	disable_irq(mdp->irq);
-	mdp_irq_mask = 0;
-
-	/* debug interface write access */
-	mdp_writel(mdp, 1, 0x60);
-
-	mdp_writel(mdp, MDP_ANY_INTR_MASK, MDP_INTR_ENABLE);
-	mdp_writel(mdp, 1, MDP_EBI2_PORTMAP_MODE);
-
-	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01f8);
-	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01fc);
-
-	for (n = 0; n < ARRAY_SIZE(csc_table); n++)
-		mdp_writel(mdp, csc_table[n].val, csc_table[n].reg);
-
-	/* clear up unused fg/main registers */
-	/* comp.plane 2&3 ystride */
-	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0120);
-
-	/* unpacked pattern */
-	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x012c);
-	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0130);
-	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0134);
-	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0158);
-	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x015c);
-	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0160);
-	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0170);
-	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0174);
-	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x017c);
 
 	clk_enable(mdp->clk);
-	/* comp.plane 2 & 3 */
-	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0114);
-	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x0118);
-
-	/* clear unused bg registers */
-	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01c8);
-	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01d0);
-	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01dc);
-	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01e0);
-	mdp_writel(mdp, 0, MDP_CMD_DEBUG_ACCESS_BASE + 0x01e4);
-
-	for (n = 0; n < 9; n++)
-		mdp_writel(mdp, mdp_default_ccs[n], 0x40440 + 4 * n);
-	mdp_writel(mdp, mdp_default_ccs[9], 0x40500 + 4 * 0);
-	mdp_writel(mdp, mdp_default_ccs[10], 0x40500 + 4 * 0);
-	mdp_writel(mdp, mdp_default_ccs[11], 0x40500 + 4 * 0);
 	mdp_hw_init(mdp);
 
 	/* register mdp device */
diff --git a/drivers/video/msm/mdp_csc_table.h b/drivers/video/msm/mdp_csc_table.h
index d1cde30..6eb0fc3 100644
--- a/drivers/video/msm/mdp_csc_table.h
+++ b/drivers/video/msm/mdp_csc_table.h
@@ -1,6 +1,6 @@
 /* drivers/video/msm_fb/mdp_csc_table.h
  *
- * Copyright (C) 2007 QUALCOMM Incorporated
+ * Copyright (C) 2007, 2011 Code Aurora Forum. All rights reserved.
  * Copyright (C) 2007 Google Incorporated
  *
  * This software is licensed under the terms of the GNU General Public
@@ -16,57 +16,48 @@
 static struct {
 	uint32_t reg;
 	uint32_t val;
-} csc_table[] = {
-	{ 0x40400, 0x83 },
-	{ 0x40404, 0x102 },
-	{ 0x40408, 0x32 },
-	{ 0x4040c, 0xffffffb5 },
-	{ 0x40410, 0xffffff6c },
-	{ 0x40414, 0xe1 },
-	{ 0x40418, 0xe1 },
-	{ 0x4041c, 0xffffff45 },
-	{ 0x40420, 0xffffffdc },
-	{ 0x40440, 0x254 },
-	{ 0x40444, 0x0 },
-	{ 0x40448, 0x331 },
-	{ 0x4044c, 0x254 },
-	{ 0x40450, 0xffffff38 },
-	{ 0x40454, 0xfffffe61 },
-	{ 0x40458, 0x254 },
-	{ 0x4045c, 0x409 },
-	{ 0x40460, 0x0 },
-	{ 0x40480, 0x5d },
-	{ 0x40484, 0x13a },
-	{ 0x40488, 0x20 },
-	{ 0x4048c, 0xffffffcd },
-	{ 0x40490, 0xffffff54 },
-	{ 0x40494, 0xe1 },
-	{ 0x40498, 0xe1 },
-	{ 0x4049c, 0xffffff35 },
-	{ 0x404a0, 0xffffffec },
-	{ 0x404c0, 0x254 },
-	{ 0x404c4, 0x0 },
-	{ 0x404c8, 0x396 },
-	{ 0x404cc, 0x254 },
-	{ 0x404d0, 0xffffff94 },
-	{ 0x404d4, 0xfffffef0 },
-	{ 0x404d8, 0x254 },
-	{ 0x404dc, 0x43a },
-	{ 0x404e0, 0x0 },
-	{ 0x40500, 0x10 },
-	{ 0x40504, 0x80 },
-	{ 0x40508, 0x80 },
-	{ 0x40540, 0x10 },
-	{ 0x40544, 0x80 },
-	{ 0x40548, 0x80 },
-	{ 0x40580, 0x10 },
-	{ 0x40584, 0xeb },
-	{ 0x40588, 0x10 },
-	{ 0x4058c, 0xf0 },
-	{ 0x405c0, 0x10 },
-	{ 0x405c4, 0xeb },
-	{ 0x405c8, 0x10 },
-	{ 0x405cc, 0xf0 },
+} csc_matrix_config_table[] = {
+	/* RGB -> YUV primary forward matrix (set1). */
+	{ MDP_CSC_PFMVn(0), 0x83 },
+	{ MDP_CSC_PFMVn(1), 0x102 },
+	{ MDP_CSC_PFMVn(2), 0x32 },
+	{ MDP_CSC_PFMVn(3), 0xffffffb5 },
+	{ MDP_CSC_PFMVn(4), 0xffffff6c },
+	{ MDP_CSC_PFMVn(5), 0xe1 },
+	{ MDP_CSC_PFMVn(6), 0xe1 },
+	{ MDP_CSC_PFMVn(7), 0xffffff45 },
+	{ MDP_CSC_PFMVn(8), 0xffffffdc },
+
+	/* YUV -> RGB primary reverse matrix (set2) */
+	{ MDP_CSC_PRMVn(0), 0x254 },
+	{ MDP_CSC_PRMVn(1), 0x0 },
+	{ MDP_CSC_PRMVn(2), 0x331 },
+	{ MDP_CSC_PRMVn(3), 0x254 },
+	{ MDP_CSC_PRMVn(4), 0xffffff38 },
+	{ MDP_CSC_PRMVn(5), 0xfffffe61 },
+	{ MDP_CSC_PRMVn(6), 0x254 },
+	{ MDP_CSC_PRMVn(7), 0x409 },
+	{ MDP_CSC_PRMVn(8), 0x0 },
+
+	/* For MDP 2.2/3.0 */
+
+	/* primary limit vector */
+	{ MDP_CSC_PLVn(0), 0x10 },
+	{ MDP_CSC_PLVn(1), 0xeb },
+	{ MDP_CSC_PLVn(2), 0x10 },
+	{ MDP_CSC_PLVn(3), 0xf0 },
+
+	/* primary bias vector */
+	{ MDP_CSC_PBVn(0), 0x10 },
+	{ MDP_CSC_PBVn(1), 0x80 },
+	{ MDP_CSC_PBVn(2), 0x80 },
+
+};
+
+static struct {
+	uint32_t reg;
+	uint32_t val;
+} csc_color_lut[] = {
 	{ 0x40800, 0x0 },
 	{ 0x40804, 0x151515 },
 	{ 0x40808, 0x1d1d1d },
diff --git a/drivers/video/msm/mdp_hw.h b/drivers/video/msm/mdp_hw.h
index 05deac8..34a204e 100644
--- a/drivers/video/msm/mdp_hw.h
+++ b/drivers/video/msm/mdp_hw.h
@@ -608,6 +608,15 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 #define PPP_ADDR_BG_CFG			MDP_FULL_BYPASS_WORD53
 #define PPP_ADDR_BG_PACK_PATTERN	MDP_FULL_BYPASS_WORD54
 
+/* color conversion matrix configuration registers */
+/* pfmv is mv1, prmv is mv2 */
+#define MDP_CSC_PFMVn(n)		(0x40400 + (4 * (n)))
+#define MDP_CSC_PRMVn(n)		(0x40440 + (4 * (n)))
+#define MDP_CSC_PBVn(n)			(0x40500 + (4 * (n)))
+#define MDP_CSC_SBVn(n)			(0x40540 + (4 * (n)))
+#define MDP_CSC_PLVn(n)			(0x40580 + (4 * (n)))
+#define MDP_CSC_SLVn(n)			(0x405c0 + (4 * (n)))
+
 /* MDP_DMA_CONFIG / MDP_FULL_BYPASS_WORD32 */
 #define DMA_DSTC0G_6BITS (1<<1)
 #define DMA_DSTC1B_6BITS (1<<3)
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

