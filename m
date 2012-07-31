Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab2GaJWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 05:22:15 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:22475 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754249Ab2GaJVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 05:21:43 -0400
X-IronPort-AV: E=Sophos;i="4.77,682,1336341600"; 
   d="scan'208";a="168648784"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] drivers/media/radio/radio-si4713.c: use devm_ functions
Date: Tue, 31 Jul 2012 11:21:36 +0200
Message-Id: <1343726497-27379-2-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/media/radio/radio-si4713.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
index c54210c..5f366d1 100644
--- a/drivers/media/radio/radio-si4713.c
+++ b/drivers/media/radio/radio-si4713.c
@@ -268,7 +268,7 @@ static int radio_si4713_pdriver_probe(struct platform_device *pdev)
 		goto exit;
 	}
 
-	rsdev = kzalloc(sizeof *rsdev, GFP_KERNEL);
+	rsdev = devm_kzalloc(&pdev->dev, sizeof(*rsdev), GFP_KERNEL);
 	if (!rsdev) {
 		dev_err(&pdev->dev, "Failed to alloc video device.\n");
 		rval = -ENOMEM;
@@ -278,7 +278,7 @@ static int radio_si4713_pdriver_probe(struct platform_device *pdev)
 	rval = v4l2_device_register(&pdev->dev, &rsdev->v4l2_dev);
 	if (rval) {
 		dev_err(&pdev->dev, "Failed to register v4l2 device.\n");
-		goto free_rsdev;
+		goto exit;
 	}
 
 	adapter = i2c_get_adapter(pdata->i2c_bus);
@@ -322,8 +322,6 @@ put_adapter:
 	i2c_put_adapter(adapter);
 unregister_v4l2_dev:
 	v4l2_device_unregister(&rsdev->v4l2_dev);
-free_rsdev:
-	kfree(rsdev);
 exit:
 	return rval;
 }
@@ -342,7 +340,6 @@ static int __exit radio_si4713_pdriver_remove(struct platform_device *pdev)
 	video_unregister_device(rsdev->radio_dev);
 	i2c_put_adapter(client->adapter);
 	v4l2_device_unregister(&rsdev->v4l2_dev);
-	kfree(rsdev);
 
 	return 0;
 }

