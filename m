Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab1JQPG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 11:06:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59791 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1JQPG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 11:06:56 -0400
Date: Mon, 17 Oct 2011 17:04:17 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Josh Wu <josh.wu@atmel.com>
cc: linux-media@vger.kernel.org, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nicolas.ferre@atmel.com, s.nawrocki@samsung.com
Subject: Re: [PATCH v4 1/3] [media] at91: add code to enable/disable ISI_MCK
 clock
In-Reply-To: <1318331020-22031-2-git-send-email-josh.wu@atmel.com>
Message-ID: <Pine.LNX.4.64.1110171702370.18438@axis700.grange>
References: <1318331020-22031-1-git-send-email-josh.wu@atmel.com>
 <1318331020-22031-2-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:LTZ5nMGZndO9mDBT8hsB7fZpnP+Db5W0p47tjLprO6M
 dmCMRXfWLp1MlCiAUc2CbFUmqT4kjBp3CSsBUrMwno9vk2hr/Y
 CnjAtrwJ1hvc8Kc9QS45p5FUduKMJeGrWo7Uf5dTrAUZaH87IE
 4ZzHG2+LroLAjMU993BqyqdS445a3QYDAxR7OWXtWkiFmwvNig
 +LSFqj9pft5WCh+YnmDXdQ6elacZ8wtI4xhc3WpgUqYSlK0HMh
 cq88k9FhfIugs70I3A95+Gd/HG9JkTFXrNJ6Yhp0kT8+5FJofi
 s5jvJAQfu/PFHf9Eh6QxMmyiIXjngd9rKxV5merhAmOhlEJUje
 2Otveblt6hbut5tTU4vGImtpA02678HOe8tMo7tt6ej22Ombt/
 GgMr7DDo5FV4w==
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
---

Josh, I missed a slight hick-up in the previous version of this your 
patch, so, I fixed it myself. Please confirm, that this version is ok with 
you.

Thanks
Guennadi

 drivers/media/video/atmel-isi.c |   31 +++++++++++++++++++++++++++++--
 include/media/atmel-isi.h       |    4 +++-
 2 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
index 7b89f00..c42ec6e 100644
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
 
@@ -859,7 +869,7 @@ static int isi_camera_set_bus_param(struct soc_camera_device *icd, u32 pixfmt)
 
 	if (isi->pdata->has_emb_sync)
 		cfg1 |= ISI_CFG1_EMB_SYNC;
-	if (isi->pdata->isi_full_mode)
+	if (isi->pdata->full_mode)
 		cfg1 |= ISI_CFG1_FULL_MODE;
 
 	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
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
+	if (!pdata || !pdata->data_width_flags || !pdata->mck_hz) {
 		dev_err(&pdev->dev,
 			"No config available for Atmel ISI\n");
 		return -EINVAL;
@@ -944,6 +955,19 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
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
@@ -1014,6 +1038,9 @@ err_alloc_ctx:
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
1.7.2.5

