Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743Ab1LGGCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 01:02:25 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:18492 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab1LGGCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 01:02:23 -0500
From: Josh Wu <josh.wu@atmel.com>
To: g.liakhovetski@gmx.de, linux-media@vger.kernel.org, linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nicolas.ferre@atmel.com, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH v2 1/2] [media] V4L: atmel-isi: add code to enable/disable ISI_MCK clock
Date: Wed,  7 Dec 2011 14:01:52 +0800
Message-Id: <1323237713-25734-1-git-send-email-josh.wu@atmel.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 07 Dec 2011 06:01:54.0983 (UTC) FILETIME=[B8CB3370:01CCB4A5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch
- add ISI_MCK clock enable/disable code.
- change field name in isi_platform_data structure

Signed-off-by: Josh Wu <josh.wu@atmel.com>
[g.liakhovetski@gmx.de: fix label names]
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Hi, Guennadi

this is the v2 version of the patch series. it is based on staging/for_v3.3.
The second patch add clk_prepare()/clk_unprepare() functions, and fix the label name issues.

Best Regards,
Josh Wu

 drivers/media/video/atmel-isi.c |   31 +++++++++++++++++++++++++++++--
 include/media/atmel-isi.h       |    4 +++-
 2 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
index fbc904f..ea4eef4 100644
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
 	clk_put(pclk);
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
1.6.3.3

