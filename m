Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab2GaJVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 05:21:44 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:22475 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753526Ab2GaJVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 05:21:42 -0400
X-IronPort-AV: E=Sophos;i="4.77,682,1336341600"; 
   d="scan'208";a="168648783"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] drivers/media/radio/radio-wl1273.c: use devm_ functions
Date: Tue, 31 Jul 2012 11:21:35 +0200
Message-Id: <1343726497-27379-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The various devm_ functions allocate memory that is released when a driver
detaches.  This patch uses these functions for data that is allocated in
the probe function of a platform device and is only freed in the remove
function.

In two cases, the original memory allocation function was kmalloc, which
has been changed to a zeroing allocation to benefit from the devm function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/radio/radio-wl1273.c |   23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index e8428f5..a22ad1c 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -1983,9 +1983,6 @@ static int wl1273_fm_radio_remove(struct platform_device *pdev)
 	v4l2_ctrl_handler_free(&radio->ctrl_handler);
 	video_unregister_device(&radio->videodev);
 	v4l2_device_unregister(&radio->v4l2dev);
-	kfree(radio->buffer);
-	kfree(radio->write_buf);
-	kfree(radio);
 
 	return 0;
 }
@@ -2005,7 +2002,7 @@ static int __devinit wl1273_fm_radio_probe(struct platform_device *pdev)
 		goto pdata_err;
 	}
 
-	radio = kzalloc(sizeof(*radio), GFP_KERNEL);
+	radio = devm_kzalloc(&pdev->dev, sizeof(*radio), GFP_KERNEL);
 	if (!radio) {
 		r = -ENOMEM;
 		goto pdata_err;
@@ -2013,11 +2010,11 @@ static int __devinit wl1273_fm_radio_probe(struct platform_device *pdev)
 
 	/* RDS buffer allocation */
 	radio->buf_size = rds_buf * RDS_BLOCK_SIZE;
-	radio->buffer = kmalloc(radio->buf_size, GFP_KERNEL);
+	radio->buffer = devm_kzalloc(&pdev->dev, radio->buf_size, GFP_KERNEL);
 	if (!radio->buffer) {
 		pr_err("Cannot allocate memory for RDS buffer.\n");
 		r = -ENOMEM;
-		goto err_kmalloc;
+		goto pdata_err;
 	}
 
 	radio->core = *core;
@@ -2043,7 +2040,7 @@ static int __devinit wl1273_fm_radio_probe(struct platform_device *pdev)
 		if (r) {
 			dev_err(radio->dev, WL1273_FM_DRIVER_NAME
 				": Cannot get platform data\n");
-			goto err_resources;
+			goto pdata_err;
 		}
 
 		dev_dbg(radio->dev, "irq: %d\n", radio->core->client->irq);
@@ -2061,13 +2058,13 @@ static int __devinit wl1273_fm_radio_probe(struct platform_device *pdev)
 		dev_err(radio->dev, WL1273_FM_DRIVER_NAME ": Core WL1273 IRQ"
 			" not configured");
 		r = -EINVAL;
-		goto err_resources;
+		goto pdata_err;
 	}
 
 	init_completion(&radio->busy);
 	init_waitqueue_head(&radio->read_queue);
 
-	radio->write_buf = kmalloc(256, GFP_KERNEL);
+	radio->write_buf = devm_kzalloc(&pdev->dev, 256, GFP_KERNEL);
 	if (!radio->write_buf) {
 		r = -ENOMEM;
 		goto write_buf_err;
@@ -2080,7 +2077,7 @@ static int __devinit wl1273_fm_radio_probe(struct platform_device *pdev)
 	r = v4l2_device_register(&pdev->dev, &radio->v4l2dev);
 	if (r) {
 		dev_err(&pdev->dev, "Cannot register v4l2_device.\n");
-		goto device_register_err;
+		goto write_buf_err;
 	}
 
 	/* V4L2 configuration */
@@ -2135,16 +2132,10 @@ static int __devinit wl1273_fm_radio_probe(struct platform_device *pdev)
 handler_init_err:
 	v4l2_ctrl_handler_free(&radio->ctrl_handler);
 	v4l2_device_unregister(&radio->v4l2dev);
-device_register_err:
-	kfree(radio->write_buf);
 write_buf_err:
 	free_irq(radio->core->client->irq, radio);
 err_request_irq:
 	radio->core->pdata->free_resources();
-err_resources:
-	kfree(radio->buffer);
-err_kmalloc:
-	kfree(radio);
 pdata_err:
 	return r;
 }

