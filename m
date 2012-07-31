Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab2GaJVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 05:21:47 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:47864 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754725Ab2GaJVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 05:21:44 -0400
X-IronPort-AV: E=Sophos;i="4.77,682,1336341600"; 
   d="scan'208";a="168648785"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] drivers/media/radio/radio-timb.c: use devm_ functions
Date: Tue, 31 Jul 2012 11:21:37 +0200
Message-Id: <1343726497-27379-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The various devm_ functions allocate memory that is released when a driver
detaches.  This patch uses these functions for data that is allocated in
the probe function of a platform device and is only freed in the remove
function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/radio/radio-timb.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
index 7052adc..09fc560 100644
--- a/drivers/media/radio/radio-timb.c
+++ b/drivers/media/radio/radio-timb.c
@@ -157,7 +157,7 @@ static int __devinit timbradio_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	tr = kzalloc(sizeof(*tr), GFP_KERNEL);
+	tr = devm_kzalloc(&pdev->dev, sizeof(*tr), GFP_KERNEL);
 	if (!tr) {
 		err = -ENOMEM;
 		goto err;
@@ -177,7 +177,7 @@ static int __devinit timbradio_probe(struct platform_device *pdev)
 	strlcpy(tr->v4l2_dev.name, DRIVER_NAME, sizeof(tr->v4l2_dev.name));
 	err = v4l2_device_register(NULL, &tr->v4l2_dev);
 	if (err)
-		goto err_v4l2_dev;
+		goto err;
 
 	tr->video_dev.v4l2_dev = &tr->v4l2_dev;
 
@@ -195,8 +195,6 @@ static int __devinit timbradio_probe(struct platform_device *pdev)
 err_video_req:
 	video_device_release_empty(&tr->video_dev);
 	v4l2_device_unregister(&tr->v4l2_dev);
-err_v4l2_dev:
-	kfree(tr);
 err:
 	dev_err(&pdev->dev, "Failed to register: %d\n", err);
 
@@ -212,8 +210,6 @@ static int __devexit timbradio_remove(struct platform_device *pdev)
 
 	v4l2_device_unregister(&tr->v4l2_dev);
 
-	kfree(tr);
-
 	return 0;
 }
 

