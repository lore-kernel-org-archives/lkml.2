Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab1LGGCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 01:02:24 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:60650 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab1LGGCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 01:02:23 -0500
From: Josh Wu <josh.wu@atmel.com>
To: g.liakhovetski@gmx.de, linux-media@vger.kernel.org, linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nicolas.ferre@atmel.com, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH v2 2/2] [media] V4L: atmel-isi: add clk_prepare()/clk_unprepare() functions
Date: Wed,  7 Dec 2011 14:01:53 +0800
Message-Id: <1323237713-25734-2-git-send-email-josh.wu@atmel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1323237713-25734-1-git-send-email-josh.wu@atmel.com>
References: <1323237713-25734-1-git-send-email-josh.wu@atmel.com>
X-OriginalArrivalTime: 07 Dec 2011 06:01:56.0077 (UTC) FILETIME=[B97221D0:01CCB4A5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
in v2 version, made the label name to be consistent

 drivers/media/video/atmel-isi.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
index ea4eef4..91ebcfb 100644
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
@@ -978,6 +986,10 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
 		goto err_clk_get;
 	}
 
+	ret = clk_prepare(isi->mck);
+	if (ret)
+		goto err_clk_prepare_mck;
+
 	/* Set ISI_MCK's frequency, it should be faster than pixel clock */
 	ret = clk_set_rate(isi->mck, pdata->mck_hz);
 	if (ret < 0)
@@ -1059,10 +1071,13 @@ err_alloc_ctx:
 			isi->fb_descriptors_phys);
 err_alloc_descriptors:
 err_set_mck_rate:
+	clk_unprepare(isi->mck);
+err_clk_prepare_mck:
 	clk_put(isi->mck);
 err_clk_get:
 	kfree(isi);
 err_alloc_isi:
+	clk_unprepare(pclk);
 	clk_put(pclk);
 
 	return ret;
-- 
1.6.3.3

