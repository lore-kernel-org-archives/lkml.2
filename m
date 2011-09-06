Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab1IFF5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 01:57:15 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:30690 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab1IFF5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 01:57:05 -0400
From: Josh Wu <josh.wu@atmel.com>
To: g.liakhovetski@gmx.de, linux-media@vger.kernel.org, plagnioj@jcrosoft.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Josh Wu <josh.wu@atmel.com>
Subject: [PATCH v2] [media] at91: add code to initialize and manage the ISI_MCK for Atmel ISI driver.
Date: Tue,  6 Sep 2011 13:56:41 +0800
Message-Id: <1315288601-22384-1-git-send-email-josh.wu@atmel.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 06 Sep 2011 05:56:42.0837 (UTC) FILETIME=[C0BC8050:01CC6C59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enable the configuration for ISI_MCK, which is provided by programmable clock.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
 drivers/media/video/atmel-isi.c |   60 ++++++++++++++++++++++++++++++++++++++-
 include/media/atmel-isi.h       |    4 ++
 2 files changed, 63 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
index 7b89f00..768bf59 100644
--- a/drivers/media/video/atmel-isi.c
+++ b/drivers/media/video/atmel-isi.c
@@ -90,7 +90,10 @@ struct atmel_isi {
 	struct isi_dma_desc		dma_desc[MAX_BUFFER_NUM];
 
 	struct completion		complete;
+	/* ISI peripherial clock */
 	struct clk			*pclk;
+	/* ISI_MCK, provided by PCK */
+	struct clk			*mck;
 	unsigned int			irq;
 
 	struct isi_platform_data	*pdata;
@@ -763,6 +766,10 @@ static int isi_camera_add_device(struct soc_camera_device *icd)
 	if (ret)
 		return ret;
 
+	ret = clk_enable(isi->mck);
+	if (ret)
+		return ret;
+
 	isi->icd = icd;
 	dev_dbg(icd->parent, "Atmel ISI Camera driver attached to camera %d\n",
 		 icd->devnum);
@@ -776,6 +783,7 @@ static void isi_camera_remove_device(struct soc_camera_device *icd)
 
 	BUG_ON(icd != isi->icd);
 
+	clk_disable(isi->mck);
 	clk_disable(isi->pclk);
 	isi->icd = NULL;
 
@@ -882,6 +890,49 @@ static struct soc_camera_host_ops isi_soc_camera_host_ops = {
 };
 
 /* -----------------------------------------------------------------------*/
+/* Initialize ISI_MCK clock, called by atmel_isi_probe() function */
+static int initialize_mck(struct platform_device *pdev,
+			struct atmel_isi *isi)
+{
+	struct device *dev = &pdev->dev;
+	struct isi_platform_data *pdata = dev->platform_data;
+	struct clk *pck_parent;
+	int ret;
+
+	if (!strlen(pdata->pck_name) || !strlen(pdata->pck_parent_name))
+		return -EINVAL;
+
+	/* ISI_MCK is provided by PCK clock */
+	isi->mck = clk_get(dev, pdata->pck_name);
+	if (IS_ERR(isi->mck)) {
+		dev_err(dev, "Failed to get PCK: %s\n", pdata->pck_name);
+		return PTR_ERR(isi->mck);
+	}
+
+	pck_parent = clk_get(dev, pdata->pck_parent_name);
+	if (IS_ERR(pck_parent)) {
+		ret = PTR_ERR(pck_parent);
+		dev_err(dev, "Failed to get PCK parent: %s\n",
+				pdata->pck_parent_name);
+		goto err_init_mck;
+	}
+
+	ret = clk_set_parent(isi->mck, pck_parent);
+	clk_put(pck_parent);
+	if (ret)
+		goto err_init_mck;
+
+	ret = clk_set_rate(isi->mck, pdata->isi_mck_hz);
+	if (ret < 0)
+		goto err_init_mck;
+
+	return 0;
+
+err_init_mck:
+	clk_put(isi->mck);
+	return ret;
+}
+
 static int __devexit atmel_isi_remove(struct platform_device *pdev)
 {
 	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
@@ -897,6 +948,7 @@ static int __devexit atmel_isi_remove(struct platform_device *pdev)
 			isi->fb_descriptors_phys);
 
 	iounmap(isi->regs);
+	clk_put(isi->mck);
 	clk_put(isi->pclk);
 	kfree(isi);
 
@@ -915,7 +967,8 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
 	struct isi_platform_data *pdata;
 
 	pdata = dev->platform_data;
-	if (!pdata || !pdata->data_width_flags) {
+	if (!pdata || !pdata->data_width_flags || !pdata->isi_mck_hz
+			|| !pdata->pck_name || !pdata->pck_parent_name) {
 		dev_err(&pdev->dev,
 			"No config available for Atmel ISI\n");
 		return -EINVAL;
@@ -944,6 +997,11 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&isi->video_buffer_list);
 	INIT_LIST_HEAD(&isi->dma_desc_head);
 
+	/* Initialize ISI_MCK clock */
+	ret = initialize_mck(pdev, isi);
+	if (ret)
+		goto err_alloc_descriptors;
+
 	isi->p_fb_descriptors = dma_alloc_coherent(&pdev->dev,
 				sizeof(struct fbd) * MAX_BUFFER_NUM,
 				&isi->fb_descriptors_phys,
diff --git a/include/media/atmel-isi.h b/include/media/atmel-isi.h
index 26cece5..dcbb822 100644
--- a/include/media/atmel-isi.h
+++ b/include/media/atmel-isi.h
@@ -114,6 +114,10 @@ struct isi_platform_data {
 	u32 data_width_flags;
 	/* Using for ISI_CFG1 */
 	u32 frate;
+	/* Using for ISI_MCK, provided by PCK */
+	u32 isi_mck_hz;
+	const char *pck_name;
+	const char *pck_parent_name;
 };
 
 #endif /* __ATMEL_ISI_H__ */
-- 
1.6.3.3

