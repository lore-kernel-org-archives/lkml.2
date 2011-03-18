Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770Ab1CRVyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:54:55 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53052 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932691Ab1CRVys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:54:48 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6289"; a="80849046"
X-IronPort-AV: E=Sophos;i="4.63,205,1299484800"; 
   d="scan'208";a="37044699"
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
Subject: [PATCH 05/20] video: msm: Setup framework for multiple output interfaces
Date: Fri, 18 Mar 2011 14:54:39 -0700
Message-Id: <1300485279-27084-1-git-send-email-carlv@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving the dma waitqueue into a struct that is uniquely
configurable for each output interface allows for
multiple displays using different callback and irq masks.

Authors:
Dima Zavin <dima@android.com>
Rebecca Schultz Zavin <rebecca@android.com>
Colin Cross <ccross@android.com>

Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/msm_fb.h |    6 +-
 drivers/video/msm/mdp.c                 |  111 +++++++++++++++++++++++++------
 drivers/video/msm/mdp_hw.h              |   24 +++++++
 3 files changed, 117 insertions(+), 24 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/msm_fb.h b/arch/arm/mach-msm/include/mach/msm_fb.h
index da11719..2d0899c 100644
--- a/arch/arm/mach-msm/include/mach/msm_fb.h
+++ b/arch/arm/mach-msm/include/mach/msm_fb.h
@@ -34,9 +34,11 @@ struct msmfb_callback {
 };
 
 enum {
-	MSM_MDDI_PMDH_INTERFACE,
+	MSM_MDDI_PMDH_INTERFACE = 0,
 	MSM_MDDI_EMDH_INTERFACE,
 	MSM_EBI2_INTERFACE,
+
+	MSM_MDP_NUM_INTERFACES = MSM_EBI2_INTERFACE + 1,
 };
 
 #define MSMFB_CAP_PARTIAL_UPDATES	(1 << 0)
@@ -117,7 +119,7 @@ struct mdp_device {
 	void (*dma)(struct mdp_device *mdp, uint32_t addr,
 		    uint32_t stride, uint32_t w, uint32_t h, uint32_t x,
 		    uint32_t y, struct msmfb_callback *callback, int interface);
-	void (*dma_wait)(struct mdp_device *mdp);
+	void (*dma_wait)(struct mdp_device *mdp, int interface);
 	int (*blit)(struct mdp_device *mdp, struct fb_info *fb,
 		    struct mdp_blit_req *req);
 	void (*set_grp_disp)(struct mdp_device *mdp, uint32_t disp_id);
diff --git a/drivers/video/msm/mdp.c b/drivers/video/msm/mdp.c
index e68df14..c046982 100644
--- a/drivers/video/msm/mdp.c
+++ b/drivers/video/msm/mdp.c
@@ -40,9 +40,7 @@ static uint16_t mdp_default_ccs[] = {
 	0x010, 0x080, 0x080
 };
 
-static DECLARE_WAIT_QUEUE_HEAD(mdp_dma2_waitqueue);
 static DECLARE_WAIT_QUEUE_HEAD(mdp_ppp_waitqueue);
-static struct msmfb_callback *dma_callback;
 static unsigned int mdp_irq_mask;
 DEFINE_MUTEX(mdp_mutex);
 
@@ -118,6 +116,7 @@ static irqreturn_t mdp_isr(int irq, void *data)
 	uint32_t status;
 	unsigned long irq_flags;
 	struct mdp_info *mdp = data;
+	int i;
 
 	spin_lock_irqsave(&mdp->lock, irq_flags);
 
@@ -125,12 +124,16 @@ static irqreturn_t mdp_isr(int irq, void *data)
 	mdp_writel(mdp, status, MDP_INTR_CLEAR);
 
 	status &= mdp_irq_mask;
-	if (status & DL0_DMA2_TERM_DONE) {
-		if (dma_callback) {
-			dma_callback->func(dma_callback);
-			dma_callback = NULL;
+
+	for (i = 0; i < MSM_MDP_NUM_INTERFACES; ++i) {
+		struct mdp_out_interface *out_if = &mdp->out_if[i];
+		if (status & out_if->dma_mask) {
+			if (out_if->dma_cb) {
+				out_if->dma_cb->func(out_if->dma_cb);
+				out_if->dma_cb = NULL;
+			}
+			wake_up(&out_if->dma_waitqueue);
 		}
-		wake_up(&mdp_dma2_waitqueue);
 	}
 
 	if (status & DL0_ROI_DONE)
@@ -173,13 +176,27 @@ static int mdp_wait(struct mdp_info *mdp, uint32_t mask, wait_queue_head_t *wq)
 	return ret;
 }
 
-void mdp_dma_wait(struct mdp_device *mdp_dev)
+void mdp_dma_wait(struct mdp_device *mdp_dev, int interface)
 {
 #define MDP_MAX_TIMEOUTS 20
 	static int timeout_count;
 	struct mdp_info *mdp = container_of(mdp_dev, struct mdp_info, mdp_dev);
+	unsigned int mask = 0;
+	wait_queue_head_t *wq;
+
+	switch (interface) {
+	case MSM_MDDI_PMDH_INTERFACE:
+	case MSM_MDDI_EMDH_INTERFACE:
+		BUG_ON(!mdp->out_if[interface].registered);
+		mask = mdp->out_if[interface].dma_mask;
+		wq = &mdp->out_if[interface].dma_waitqueue;
+		break;
+	default:
+		pr_err("%s: Unknown interface %d\n", __func__, interface);
+		BUG();
+	}
 
-	if (mdp_wait(mdp, DL0_DMA2_TERM_DONE, &mdp_dma2_waitqueue) == -ETIMEDOUT)
+	if (mdp_wait(mdp, mask, wq) == -ETIMEDOUT)
 		timeout_count++;
 	else
 		timeout_count = 0;
@@ -196,20 +213,14 @@ static int mdp_ppp_wait(struct mdp_info *mdp)
 	return mdp_wait(mdp, DL0_ROI_DONE, &mdp_ppp_waitqueue);
 }
 
-void mdp_dma_to_mddi(struct mdp_info *mdp, uint32_t addr, uint32_t stride,
-		     uint32_t width, uint32_t height, uint32_t x, uint32_t y,
-		     struct msmfb_callback *callback)
+static void mdp_dma_to_mddi(void *priv, uint32_t addr, uint32_t stride,
+			    uint32_t width, uint32_t height, uint32_t x,
+			    uint32_t y)
 {
+	struct mdp_info *mdp = priv;
 	uint32_t dma2_cfg;
 	uint16_t ld_param = 0; /* 0=PRIM, 1=SECD, 2=EXT */
 
-	if (enable_mdp_irq(mdp, DL0_DMA2_TERM_DONE)) {
-		printk(KERN_ERR "mdp_dma_to_mddi: busy\n");
-		return;
-	}
-
-	dma_callback = callback;
-
 	dma2_cfg = DMA_PACK_TIGHT |
 		DMA_PACK_ALIGN_LSB |
 		DMA_PACK_PATTERN_RGB |
@@ -250,11 +261,26 @@ void mdp_dma(struct mdp_device *mdp_dev, uint32_t addr, uint32_t stride,
 	     struct msmfb_callback *callback, int interface)
 {
 	struct mdp_info *mdp = container_of(mdp_dev, struct mdp_info, mdp_dev);
+	struct mdp_out_interface *out_if;
+	unsigned long flags;
+
+	if (interface < 0 || interface > MSM_MDP_NUM_INTERFACES ||
+	    !mdp->out_if[interface].registered) {
+		pr_err("%s: Unknown interface: %d\n", __func__, interface);
+		BUG();
+	}
+	out_if = &mdp->out_if[interface];
 
-	if (interface == MSM_MDDI_PMDH_INTERFACE) {
-		mdp_dma_to_mddi(mdp, addr, stride, width, height, x, y,
-				callback);
+	spin_lock_irqsave(&mdp->lock, flags);
+	if (locked_enable_mdp_irq(mdp, out_if->dma_mask)) {
+		pr_err("%s: busy\n", __func__);
+		goto done;
 	}
+
+	out_if->dma_cb = callback;
+	out_if->dma_start(out_if->priv, addr, stride, width, height, x, y);
+done:
+	spin_unlock_irqrestore(&mdp->lock, flags);
 }
 
 int get_img(struct mdp_img *img, struct fb_info *info,
@@ -374,6 +400,41 @@ void mdp_set_grp_disp(struct mdp_device *mdp_dev, unsigned disp_id)
 	mdp_writel(mdp, disp_id, MDP_FULL_BYPASS_WORD43);
 }
 
+/* used by output interface drivers like mddi and lcdc */
+int mdp_out_if_register(struct mdp_device *mdp_dev, int interface,
+			void *private_data, uint32_t dma_mask,
+			mdp_dma_start_func_t dma_start)
+{
+	struct mdp_info *mdp = container_of(mdp_dev, struct mdp_info, mdp_dev);
+	unsigned long flags;
+	int ret = 0;
+
+	if (interface < 0 || interface >= MSM_MDP_NUM_INTERFACES) {
+		pr_err("%s: invalid interface (%d)\n", __func__, interface);
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&mdp->lock, flags);
+
+	if (mdp->out_if[interface].registered) {
+		pr_err("%s: interface (%d) already registered\n", __func__,
+		       interface);
+		ret = -EINVAL;
+		goto done;
+	}
+
+	init_waitqueue_head(&mdp->out_if[interface].dma_waitqueue);
+	mdp->out_if[interface].registered = 1;
+	mdp->out_if[interface].priv = private_data;
+	mdp->out_if[interface].dma_mask = dma_mask;
+	mdp->out_if[interface].dma_start = dma_start;
+	mdp->out_if[interface].dma_cb = NULL;
+
+done:
+	spin_unlock_irqrestore(&mdp->lock, flags);
+	return ret;
+}
+
 int register_mdp_client(struct class_interface *cint)
 {
 	if (!mdp_class) {
@@ -426,6 +487,11 @@ int mdp_probe(struct platform_device *pdev)
 	mdp->mdp_dev.blit = mdp_blit;
 	mdp->mdp_dev.set_grp_disp = mdp_set_grp_disp;
 
+	ret = mdp_out_if_register(&mdp->mdp_dev, MSM_MDDI_PMDH_INTERFACE, mdp,
+				  MDP_DMA_P_DONE, mdp_dma_to_mddi);
+	if (ret)
+		goto error_mddi_pmdh_register;
+
 	mdp->clk = clk_get(&pdev->dev, "mdp_clk");
 	if (IS_ERR(mdp->clk)) {
 		printk(KERN_INFO "mdp: failed to get mdp clk");
@@ -506,6 +572,7 @@ error_device_register:
 	free_irq(mdp->irq, mdp);
 error_request_irq:
 error_get_mdp_clk:
+error_mddi_pmdh_register:
 	iounmap(mdp->base);
 error_get_irq:
 error_ioremap:
diff --git a/drivers/video/msm/mdp_hw.h b/drivers/video/msm/mdp_hw.h
index 54b3934..05deac8 100644
--- a/drivers/video/msm/mdp_hw.h
+++ b/drivers/video/msm/mdp_hw.h
@@ -15,16 +15,38 @@
 #ifndef _MDP_HW_H_
 #define _MDP_HW_H_
 
+#include <linux/wait.h>
 #include <mach/msm_iomap.h>
 #include <mach/msm_fb.h>
 
+typedef void (*mdp_dma_start_func_t)(void *private_data, uint32_t addr,
+				     uint32_t stride, uint32_t width,
+				     uint32_t height, uint32_t x, uint32_t y);
+
+struct mdp_out_interface {
+	uint32_t		registered:1;
+	void			*priv;
+
+	/* If the interface client wants to get DMA_DONE events */
+	uint32_t		dma_mask;
+	mdp_dma_start_func_t	dma_start;
+
+	struct msmfb_callback	*dma_cb;
+	wait_queue_head_t	dma_waitqueue;
+};
+
 struct mdp_info {
 	spinlock_t lock;
 	struct mdp_device mdp_dev;
 	char * __iomem base;
 	int irq;
 	struct clk *clk;
+	struct mdp_out_interface out_if[MSM_MDP_NUM_INTERFACES];
 };
+
+extern int mdp_out_if_register(struct mdp_device *mdp_dev, int interface,
+			       void *private_data, uint32_t dma_mask,
+			       mdp_dma_start_func_t dma_start);
 struct mdp_blit_req;
 struct mdp_device;
 int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
@@ -210,6 +232,8 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 			   DL1_FETCH_DONE| \
 			   TV_ENC_UNDERRUN)
 
+#define MDP_DMA_P_DONE			(1 << 2)
+
 #define MDP_TOP_LUMA       16
 #define MDP_TOP_CHROMA     0
 #define MDP_BOTTOM_LUMA    19
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

