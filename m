Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab1EaVTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 17:19:09 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:43423 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932601Ab1EaVTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 17:19:07 -0400
X-Greylist: delayed 1408 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 May 2011 17:19:07 EDT
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] V4L/DVB: radio-si470x: fix memory leak in si470x_usb_driver_probe()
Date: Wed,  1 Jun 2011 00:54:40 +0400
Message-Id: <1306875280-9949-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

radio->int_in_urb is not deallocated on error paths in si470x_usb_driver_probe().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/radio/si470x/radio-si470x-usb.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index 392e84f..ccefdae 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -699,7 +699,7 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 	radio->videodev = video_device_alloc();
 	if (!radio->videodev) {
 		retval = -ENOMEM;
-		goto err_intbuffer;
+		goto err_urb;
 	}
 	memcpy(radio->videodev, &si470x_viddev_template,
 			sizeof(si470x_viddev_template));
@@ -790,6 +790,8 @@ err_all:
 	kfree(radio->buffer);
 err_video:
 	video_device_release(radio->videodev);
+err_urb:
+	usb_free_urb(radio->int_in_urb);
 err_intbuffer:
 	kfree(radio->int_in_buffer);
 err_radio:
-- 
1.7.4.1

