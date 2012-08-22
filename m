Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab2HVHGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 03:06:53 -0400
Received: from mail.telros.ru ([83.136.244.21]:57870 "EHLO mail.telros.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab2HVHGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 03:06:51 -0400
X-Greylist: delayed 1414 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Aug 2012 03:06:51 EDT
From: Volokh Konstantin <volokh84@gmail.com>
To: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, volokh@telros.ru
Cc: Volokh Konstantin <volokh84@gmail.com>
Subject: [PATCH 08/10] staging: media: go7007: some additional functionality for sub.
Date: Wed, 22 Aug 2012 14:45:17 +0400
Message-Id: <1345632319-23224-8-git-send-email-volokh84@gmail.com>
In-Reply-To: <1345632319-23224-1-git-send-email-volokh84@gmail.com>
References: <1345632319-23224-1-git-send-email-volokh84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zero cleaning allocation for fix.
unregistering bug fixing.

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
---
 drivers/staging/media/go7007/go7007-driver.c |    2 +-
 drivers/staging/media/go7007/go7007-usb.c    |    2 +-
 drivers/staging/media/go7007/go7007-v4l2.c   |    7 +++++--
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
index ece2dd1..a66e339 100644
--- a/drivers/staging/media/go7007/go7007-driver.c
+++ b/drivers/staging/media/go7007/go7007-driver.c
@@ -571,7 +571,7 @@ struct go7007 *go7007_alloc(struct go7007_board_info *board, struct device *dev)
 	struct go7007 *go;
 	int i;
 
-	go = kmalloc(sizeof(struct go7007), GFP_KERNEL);
+	go = kzalloc(sizeof(struct go7007), GFP_KERNEL);
 	if (go == NULL)
 		return NULL;
 	go->dev = dev;
diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index 5443e25..a6cad15 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -1245,7 +1245,6 @@ static void go7007_usb_disconnect(struct usb_interface *intf)
 	struct urb *vurb, *aurb;
 	int i;
 
-	go->status = STATUS_SHUTDOWN;
 	usb_kill_urb(usb->intr_urb);
 
 	/* Free USB-related structs */
@@ -1269,6 +1268,7 @@ static void go7007_usb_disconnect(struct usb_interface *intf)
 	kfree(go->hpi_context);
 
 	go7007_remove(go);
+	go->status = STATUS_SHUTDOWN;
 }
 
 static struct usb_driver go7007_usb_driver = {
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index c184ad3..b8f2eb6 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -98,7 +98,7 @@ static int go7007_open(struct file *file)
 
 	if (go->status != STATUS_ONLINE)
 		return -EBUSY;
-	gofh = kmalloc(sizeof(struct go7007_file), GFP_KERNEL);
+	gofh = kzalloc(sizeof(struct go7007_file), GFP_KERNEL);
 	if (gofh == NULL)
 		return -ENOMEM;
 	++go->ref_count;
@@ -953,6 +953,7 @@ static int vidioc_streamon(struct file *file, void *priv,
 	}
 	mutex_unlock(&go->hw_lock);
 	mutex_unlock(&gofh->lock);
+	call_all(&go->v4l2_dev, video, s_stream, 1);
 
 	return retval;
 }
@@ -968,6 +969,7 @@ static int vidioc_streamoff(struct file *file, void *priv,
 	mutex_lock(&gofh->lock);
 	go7007_streamoff(go);
 	mutex_unlock(&gofh->lock);
+	call_all(&go->v4l2_dev, video, s_stream, 0);
 
 	return 0;
 }
@@ -1832,5 +1834,6 @@ void go7007_v4l2_remove(struct go7007 *go)
 	mutex_unlock(&go->hw_lock);
 	if (go->video_dev)
 		video_unregister_device(go->video_dev);
-	v4l2_device_unregister(&go->v4l2_dev);
+	if (go->status != STATUS_SHUTDOWN)
+		v4l2_device_unregister(&go->v4l2_dev);
 }
-- 
1.7.7.6

