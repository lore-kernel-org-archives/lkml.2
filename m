Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab0GARVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 13:21:53 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:43184 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab0GARVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 13:21:52 -0400
X-Auth-Info: /kP1rwwUC76nK+p/QuZAwYJ0xWuiOEbQyspQAth8d9E=
From: Anatolij Gustschin <agust@denx.de>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Hans Verkuil <hverkuil@xs4all.nl>, Detlev Zundel <dzu@denx.de>,
       Anatolij Gustschin <agust@denx.de>
Subject: [PATCH] V4L/DVB: v4l2-dev: fix memory leak
Date: Thu,  1 Jul 2010 19:21:39 +0200
Message-Id: <1278004899-16940-1-git-send-email-agust@denx.de>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit b4028437876866aba4747a655ede00f892089e14
the 'driver_data' field resides in device's struct device_private
which may be allocated by dev_set_drvdata() if device_private
struct was not allocated previously.

dev_set_drvdata() is used in video_set_drvdata() to set
the driver's private data pointer in v4l2 drivers. Setting
the private data _before_ registering the v4l2 device results
in a memory leak since __video_register_device() also calls
video_set_drvdata(), but after zeroing the device structure.
Thus, the reference to the previously allocated device_private
struct goes lost and a new device_private will be allocated.

All v4l drivers which call video_set_drvdata() _before_
calling video_register_device() are affected. The patch fixes
__video_register_device() to preserve previously allocated
device_private reference.

Caught by kmemleak.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 drivers/media/video/v4l2-dev.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 0ca7ec9..9e89bf6 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -410,7 +410,7 @@ static int __video_register_device(struct video_device *vdev, int type, int nr,
 	int minor_offset = 0;
 	int minor_cnt = VIDEO_NUM_DEVICES;
 	const char *name_base;
-	void *priv = video_get_drvdata(vdev);
+	void *priv = vdev->dev.p;
 
 	/* A minor value of -1 marks this video device as never
 	   having been registered */
@@ -536,9 +536,9 @@ static int __video_register_device(struct video_device *vdev, int type, int nr,
 
 	/* Part 4: register the device with sysfs */
 	memset(&vdev->dev, 0, sizeof(vdev->dev));
-	/* The memset above cleared the device's drvdata, so
+	/* The memset above cleared the device's device_private, so
 	   put back the copy we made earlier. */
-	video_set_drvdata(vdev, priv);
+	vdev->dev.p = priv;
 	vdev->dev.class = &video_class;
 	vdev->dev.devt = MKDEV(VIDEO_MAJOR, vdev->minor);
 	if (vdev->parent)
-- 
1.7.0.4

