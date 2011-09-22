Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668Ab1IVEOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 00:14:03 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:4387 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870Ab1IVEN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 00:13:58 -0400
From: Josh Wu <josh.wu@atmel.com>
To: g.liakhovetski@gmx.de, linux-media@vger.kernel.org, plagnioj@jcrosoft.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nicolas.ferre@atmel.com, s.nawrocki@samsung.com,
        Josh Wu <josh.wu@atmel.com>
Subject: [PATCH v3 1/2][media] Add code to enable/disable ISI_MCK clock.
Date: Thu, 22 Sep 2011 12:11:00 +0800
Message-Id: <1316664661-11383-1-git-send-email-josh.wu@atmel.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 22 Sep 2011 04:11:02.0620 (UTC) FILETIME=[A44829C0:01CC78DD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add code to enable/disable ISI_MCK clock when add/remove soc camera device.it also set ISI_MCK frequence before using it.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
 drivers/media/video/atmel-isi.c |   30 ++++++++++++++++++++++++++++--
 include/media/atmel-isi.h       |    2 ++
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
index 7b89f00..888234a 100644
--- a/drivers/media/video/atmel-isi.c
+++ b/drivers/media/video/atmel-isi.c
@@ -90,7 +90,10 @@ struct atmel_isi {
 	struct isi_dma_desc		dma_desc[MAX_BUFFER_NUM];
 
 	struct completion		complete;
+	/* ISI peripherial clock */
 	struct clk			*pclk;
+	/* ISI_MCK, provided by Programmable clock */
+	struct clk			*mck;
 	unsigned int			irq;
 
 	struct isi_platform_data	*pdata;
@@ -763,6 +766,12 @@ static int isi_camera_add_device(struct soc_camera_device *icd)
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
@@ -776,6 +785,7 @@ static void isi_camera_remove_device(struct soc_camera_device *icd)
 
 	BUG_ON(icd != isi->icd);
 
+	clk_disable(isi->mck);
 	clk_disable(isi->pclk);
 	isi->icd = NULL;
 
@@ -897,6 +907,7 @@ static int __devexit atmel_isi_remove(struct platform_device *pdev)
 			isi->fb_descriptors_phys);
 
 	iounmap(isi->regs);
+	clk_put(isi->mck);
 	clk_put(isi->pclk);
 	kfree(isi);
 
@@ -915,7 +926,7 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
 	struct isi_platform_data *pdata;
 
 	pdata = dev->platform_data;
-	if (!pdata || !pdata->data_width_flags) {
+	if (!pdata || !pdata->data_width_flags || !pdata->isi_mck_hz) {
 		dev_err(&pdev->dev,
 			"No config available for Atmel ISI\n");
 		return -EINVAL;
@@ -944,6 +955,19 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&isi->video_buffer_list);
 	INIT_LIST_HEAD(&isi->dma_desc_head);
 
+	/* Get ISI_MCK, which is provided by Programmable clock */
+	isi->mck = clk_get(dev, "isi_mck");
+	if (IS_ERR(isi->mck)) {
+		dev_err(dev, "Failed to get isi_mck\n");
+		ret = PTR_ERR(isi->mck);
+		goto err_alloc_descriptors;
+	}
+
+	/* Set ISI_MCK's frequency, it should be faster than pixel clock */
+	ret = clk_set_rate(isi->mck, pdata->isi_mck_hz);
+	if (ret < 0)
+		goto err_set_mck_rate;
+
 	isi->p_fb_descriptors = dma_alloc_coherent(&pdev->dev,
 				sizeof(struct fbd) * MAX_BUFFER_NUM,
 				&isi->fb_descriptors_phys,
@@ -951,7 +975,7 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
 	if (!isi->p_fb_descriptors) {
 		ret = -ENOMEM;
 		dev_err(&pdev->dev, "Can't allocate descriptors!\n");
-		goto err_alloc_descriptors;
+		goto err_set_mck_rate;
 	}
 
 	for (i = 0; i < MAX_BUFFER_NUM; i++) {
@@ -1013,6 +1037,8 @@ err_alloc_ctx:
 			sizeof(struct fbd) * MAX_BUFFER_NUM,
 			isi->p_fb_descriptors,
 			isi->fb_descriptors_phys);
+err_set_mck_rate:
+	clk_put(isi->mck);
 err_alloc_descriptors:
 	kfree(isi);
 err_alloc_isi:
diff --git a/include/media/atmel-isi.h b/include/media/atmel-isi.h
index 26cece5..a0229a6 100644
--- a/include/media/atmel-isi.h
+++ b/include/media/atmel-isi.h
@@ -114,6 +114,8 @@ struct isi_platform_data {
 	u32 data_width_flags;
 	/* Using for ISI_CFG1 */
 	u32 frate;
+	/* Using for ISI_MCK, provided by Programmable clock */
+	u32 isi_mck_hz;
 };
 
 #endif /* __ATMEL_ISI_H__ */
-- 
1.6.3.3

