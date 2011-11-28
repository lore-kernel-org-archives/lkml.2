Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab1K1NhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 08:37:17 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:43438 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab1K1NfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 08:35:05 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de
Cc: linux-kernel@vger.kernel.org, josh.wu@atmel.com,
        linux-media@vger.kernel.org
Subject: [PATCH] [media] V4L: atmel-isi: add code to enable/disable ISI_MCK clock
Date: Mon, 28 Nov 2011 14:34:44 +0100
Message-Id: <1322487284-3381-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Wu <josh.wu@atmel.com>

This patch
- add ISI_MCK clock enable/disable code.
- change field name in isi_platform_data structure

Signed-off-by: Josh Wu <josh.wu@atmel.com>
[g.liakhovetski@gmx.de: fix label names]
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Guennadi,

Here is the pach form Josh and yourself about the Atmel ISI driver
modifications. I have rebased it on top of 3.2-rc3 (and tested it on
linux-next also).
I plan to submit the board/device related patches (2-3/3 of this series) to
the arm-soc tree real soon. Do you whant me to include this one or can you
schedulle an inclusion in mainline for 3.3?

Best regards,

 drivers/media/video/atmel-isi.c |   31 +++++++++++++++++++++++++++++--
 include/media/atmel-isi.h       |    4 +++-
 2 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
index 8c775c5..5a7ab84 100644
--- a/drivers/media/video/atmel-isi.c
+++ b/drivers/media/video/atmel-isi.c
@@ -90,7 +90,10 @@ struct atmel_isi {
 	struct isi_dma_desc		dma_desc[MAX_BUFFER_NUM];
 
 	struct completion		complete;
+	/* ISI peripherial clock */
 	struct clk			*pclk;
+	/* ISI_MCK, feed to camera sensor to generate pixel clock */
+	struct clk			*mck;
 	unsigned int			irq;
 
 	struct isi_platform_data	*pdata;
@@ -766,6 +769,12 @@ static int isi_camera_add_device(struct soc_camera_device *icd)
 	if (ret)
 		return ret;
 
+	ret = clk_enable(isi->mck);
+	if (ret) {
+		clk_disable(isi->pclk);
+		return ret;
+	}
+
 	isi->icd = icd;
 	dev_dbg(icd->parent, "Atmel ISI Camera driver attached to camera %d\n",
 		 icd->devnum);
@@ -779,6 +788,7 @@ static void isi_camera_remove_device(struct soc_camera_device *icd)
 
 	BUG_ON(icd != isi->icd);
 
+	clk_disable(isi->mck);
 	clk_disable(isi->pclk);
 	isi->icd = NULL;
 
@@ -874,7 +884,7 @@ static int isi_camera_set_bus_param(struct soc_camera_device *icd, u32 pixfmt)
 
 	if (isi->pdata->has_emb_sync)
 		cfg1 |= ISI_CFG1_EMB_SYNC;
-	if (isi->pdata->isi_full_mode)
+	if (isi->pdata->full_mode)
 		cfg1 |= ISI_CFG1_FULL_MODE;
 
 	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
@@ -912,6 +922,7 @@ static int __devexit atmel_isi_remove(struct platform_device *pdev)
 			isi->fb_descriptors_phys);
 
 	iounmap(isi->regs);
+	clk_put(isi->mck);
 	clk_put(isi->pclk);
 	kfree(isi);
 
@@ -930,7 +941,7 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
 	struct isi_platform_data *pdata;
 
 	pdata = dev->platform_data;
-	if (!pdata || !pdata->data_width_flags) {
+	if (!pdata || !pdata->data_width_flags || !pdata->mck_hz) {
 		dev_err(&pdev->dev,
 			"No config available for Atmel ISI\n");
 		return -EINVAL;
@@ -959,6 +970,19 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&isi->video_buffer_list);
 	INIT_LIST_HEAD(&isi->dma_desc_head);
 
+	/* Get ISI_MCK, provided by programmable clock or external clock */
+	isi->mck = clk_get(dev, "isi_mck");
+	if (IS_ERR_OR_NULL(isi->mck)) {
+		dev_err(dev, "Failed to get isi_mck\n");
+		ret = isi->mck ? PTR_ERR(isi->mck) : -EINVAL;
+		goto err_clk_get;
+	}
+
+	/* Set ISI_MCK's frequency, it should be faster than pixel clock */
+	ret = clk_set_rate(isi->mck, pdata->mck_hz);
+	if (ret < 0)
+		goto err_set_mck_rate;
+
 	isi->p_fb_descriptors = dma_alloc_coherent(&pdev->dev,
 				sizeof(struct fbd) * MAX_BUFFER_NUM,
 				&isi->fb_descriptors_phys,
@@ -1034,6 +1058,9 @@ err_alloc_ctx:
 			isi->p_fb_descriptors,
 			isi->fb_descriptors_phys);
 err_alloc_descriptors:
+err_set_mck_rate:
+	clk_put(isi->mck);
+err_clk_get:
 	kfree(isi);
 err_alloc_isi:
 	clk_put(isi->pclk);
diff --git a/include/media/atmel-isi.h b/include/media/atmel-isi.h
index 26cece5..6568230 100644
--- a/include/media/atmel-isi.h
+++ b/include/media/atmel-isi.h
@@ -110,10 +110,12 @@ struct isi_platform_data {
 	u8 hsync_act_low;
 	u8 vsync_act_low;
 	u8 pclk_act_falling;
-	u8 isi_full_mode;
+	u8 full_mode;
 	u32 data_width_flags;
 	/* Using for ISI_CFG1 */
 	u32 frate;
+	/* Using for ISI_MCK */
+	u32 mck_hz;
 };
 
 #endif /* __ATMEL_ISI_H__ */
-- 
1.7.5.4

