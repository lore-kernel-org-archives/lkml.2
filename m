Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab1IUPEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:04:48 -0400
Received: from mail-ew0-f42.google.com ([209.85.215.42]:59116 "EHLO
	mail-ew0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab1IUPEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:04:46 -0400
X-Greylist: delayed 435 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Sep 2011 11:04:45 EDT
From: Arvydas Sidorenko <asido4@gmail.com>
To: mchehab@infradead.org
Cc: asido4@gmail.com, hverkuil@xs4all.nl, arnd@arndb.de,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrea Anacleto <andreaanacleto@libero.it>
Subject: [PATCH] drivers/media/video/stk-webcam.c: webcam LED bug fix [IMPROVED]
Date: Wed, 21 Sep 2011 16:58:31 +0200
Message-Id: <1316617111-14548-1-git-send-email-asido4@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an improved version of the patch I sent a little ago.

The problem was:
	On my DC-1125 webcam chip from Syntek, whenever the webcam turns
	on, the LED light on it is turned on also and never turns off again unless
	system is shut downed or restarted.

The previous version seemed to break some other laptop webcam work. Thanks
to Andrea Anacleto for the bug report and solution.

Signed-off-by: Andrea Anacleto <andreaanacleto@libero.it>
Signed-off-by: Arvydas Sidorenko <asido4@gmail.com>
---
 drivers/media/video/stk-webcam.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index d1a2cef..af57d80 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -55,6 +55,8 @@ MODULE_AUTHOR("Jaime Velasco Juan <jsagarribay@gmail.com> and Nicolas VIVIEN");
 MODULE_DESCRIPTION("Syntek DC1125 webcam driver");
 
 
+/* bool for webcam LED management */
+int first_init = 1;
 
 /* Some cameras have audio interfaces, we aren't interested in those */
 static struct usb_device_id stkwebcam_table[] = {
@@ -561,6 +563,12 @@ static int v4l_stk_open(struct file *fp)
 	if (dev == NULL || !is_present(dev)) {
 		return -ENXIO;
 	}
+
+	if (!first_init)
+		stk_camera_write_reg(dev, 0x0, 0x24);
+	else
+		first_init = 0;
+
 	fp->private_data = dev;
 	usb_autopm_get_interface(dev->interface);
 
@@ -574,6 +582,7 @@ static int v4l_stk_release(struct file *fp)
 	if (dev->owner == fp) {
 		stk_stop_stream(dev);
 		stk_free_buffers(dev);
+		stk_camera_write_reg(dev, 0x0, 0x49); /* turn off the LED */
 		dev->owner = NULL;
 	}
 
@@ -1350,6 +1359,7 @@ static int stk_camera_resume(struct usb_interface *intf)
 		return 0;
 	unset_initialised(dev);
 	stk_initialise(dev);
+	stk_camera_write_reg(dev, 0x0, 0x49);
 	stk_setup_format(dev);
 	if (is_streaming(dev))
 		stk_start_stream(dev);
-- 
1.7.4.4

