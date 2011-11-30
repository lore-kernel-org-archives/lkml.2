Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab1K3KHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 05:07:31 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:53538 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab1K3KHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 05:07:13 -0500
From: Josh Wu <josh.wu@atmel.com>
To: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
        nicolas.ferre@atmel.com, linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Josh Wu <josh.wu@atmel.com>
Subject: [PATCH 2/2] [media] V4L: atmel-isi: add clk_prepare()/clk_unprepare() functions
Date: Wed, 30 Nov 2011 18:06:44 +0800
Message-Id: <1322647604-30662-2-git-send-email-josh.wu@atmel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1322647604-30662-1-git-send-email-josh.wu@atmel.com>
References: <1322647604-30662-1-git-send-email-josh.wu@atmel.com>
X-OriginalArrivalTime: 30 Nov 2011 10:06:47.0337 (UTC) FILETIME=[C53A4190:01CCAF47]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
 drivers/media/video/atmel-isi.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
index ea4eef4..5da4381 100644
--- a/drivers/media/video/atmel-isi.c
+++ b/drivers/media/video/atmel-isi.c
@@ -922,7 +922,9 @@ static int __devexit atmel_isi_remove(struct platform_device *pdev)
 			isi->fb_descriptors_phys);
 
 	iounmap(isi->regs);
+	clk_unprepare(isi->mck);
 	clk_put(isi->mck);
+	clk_unprepare(isi->pclk);
 	clk_put(isi->pclk);
 	kfree(isi);
 
@@ -955,6 +957,12 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
 	if (IS_ERR(pclk))
 		return PTR_ERR(pclk);
 
+	ret = clk_prepare(pclk);
+	if (ret) {
+		clk_put(pclk);
+		return ret;
+	}
+
 	isi = kzalloc(sizeof(struct atmel_isi), GFP_KERNEL);
 	if (!isi) {
 		ret = -ENOMEM;
@@ -978,10 +986,14 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
 		goto err_clk_get;
 	}
 
+	ret = clk_prepare(isi->mck);
+	if (ret)
+		goto err_set_mck_rate;
+
 	/* Set ISI_MCK's frequency, it should be faster than pixel clock */
 	ret = clk_set_rate(isi->mck, pdata->mck_hz);
 	if (ret < 0)
-		goto err_set_mck_rate;
+		goto err_unprepare_mck;
 
 	isi->p_fb_descriptors = dma_alloc_coherent(&pdev->dev,
 				sizeof(struct fbd) * MAX_BUFFER_NUM,
@@ -1058,11 +1070,14 @@ err_alloc_ctx:
 			isi->p_fb_descriptors,
 			isi->fb_descriptors_phys);
 err_alloc_descriptors:
+err_unprepare_mck:
+	clk_unprepare(isi->mck);
 err_set_mck_rate:
 	clk_put(isi->mck);
 err_clk_get:
 	kfree(isi);
 err_alloc_isi:
+	clk_unprepare(pclk);
 	clk_put(pclk);
 
 	return ret;
-- 
1.6.3.3

