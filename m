Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab2DVLyv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 07:54:51 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:37352 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab2DVLyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 07:54:49 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/media/video/au0828/au0828-video.c: add missing video_device_release
Date: Sun, 22 Apr 2012 13:54:42 +0200
Message-Id: <1335095682-16530-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

At the point of the call to video_register_device, both dev->vbi_dev and
dev->vdev have been allocated, and so should be freed on failure.  The
error-handling code is moved to the end of the function, to avoid code
duplication.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/video/au0828/au0828-video.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/au0828/au0828-video.c b/drivers/media/video/au0828/au0828-video.c
index 0b3e481..141f9c2 100644
--- a/drivers/media/video/au0828/au0828-video.c
+++ b/drivers/media/video/au0828/au0828-video.c
@@ -1881,7 +1881,7 @@ int au0828_analog_register(struct au0828_dev *dev,
 	int retval = -ENOMEM;
 	struct usb_host_interface *iface_desc;
 	struct usb_endpoint_descriptor *endpoint;
-	int i;
+	int i, ret;
 
 	dprintk(1, "au0828_analog_register called!\n");
 
@@ -1951,8 +1951,8 @@ int au0828_analog_register(struct au0828_dev *dev,
 	dev->vbi_dev = video_device_alloc();
 	if (NULL == dev->vbi_dev) {
 		dprintk(1, "Can't allocate vbi_device.\n");
-		kfree(dev->vdev);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_vdev;
 	}
 
 	/* Fill the video capture device struct */
@@ -1971,8 +1971,8 @@ int au0828_analog_register(struct au0828_dev *dev,
 	if (retval != 0) {
 		dprintk(1, "unable to register video device (error = %d).\n",
 			retval);
-		video_device_release(dev->vdev);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_vbi_dev;
 	}
 
 	/* Register the vbi device */
@@ -1981,13 +1981,18 @@ int au0828_analog_register(struct au0828_dev *dev,
 	if (retval != 0) {
 		dprintk(1, "unable to register vbi device (error = %d).\n",
 			retval);
-		video_device_release(dev->vbi_dev);
-		video_device_release(dev->vdev);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_vbi_dev;
 	}
 
 	dprintk(1, "%s completed!\n", __func__);
 
 	return 0;
+
+err_vbi_dev:
+	video_device_release(dev->vbi_dev);
+err_vdev:
+	video_device_release(dev->vdev);
+	return ret;
 }
 

