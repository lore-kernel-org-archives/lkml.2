Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab1CTVvh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 17:51:37 -0400
Received: from ist.d-labs.de ([213.239.218.44]:51941 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab1CTVvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 17:51:32 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, crope@iki.fi,
        tvboxspy@gmail.com, Florian Mickler <florian@mickler.org>
Subject: [PATCH 1/5] [media] ec168: get rid of on-stack dma buffers
Date: Sun, 20 Mar 2011 22:50:48 +0100
Message-Id: <1300657852-29318-2-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300657852-29318-1-git-send-email-florian@mickler.org>
References: <1300657852-29318-1-git-send-email-florian@mickler.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb_control_msg initiates (and waits for completion of) a dma transfer using
the supplied buffer. That buffer thus has to be seperately allocated on
the heap.

In lib/dma_debug.c the function check_for_stack even warns about it:
	WARNING: at lib/dma-debug.c:866 check_for_stack

Signed-off-by: Florian Mickler <florian@mickler.org>
Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>
Tested-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/dvb-usb/ec168.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/ec168.c b/drivers/media/dvb/dvb-usb/ec168.c
index 52f5d4f..1ba3e5d 100644
--- a/drivers/media/dvb/dvb-usb/ec168.c
+++ b/drivers/media/dvb/dvb-usb/ec168.c
@@ -36,7 +36,9 @@ static int ec168_rw_udev(struct usb_device *udev, struct ec168_req *req)
 	int ret;
 	unsigned int pipe;
 	u8 request, requesttype;
-	u8 buf[req->size];
+	u8 *buf;
+
+
 
 	switch (req->cmd) {
 	case DOWNLOAD_FIRMWARE:
@@ -72,6 +74,12 @@ static int ec168_rw_udev(struct usb_device *udev, struct ec168_req *req)
 		goto error;
 	}
 
+	buf = kmalloc(req->size, GFP_KERNEL);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
 	if (requesttype == (USB_TYPE_VENDOR | USB_DIR_OUT)) {
 		/* write */
 		memcpy(buf, req->data, req->size);
@@ -84,13 +92,13 @@ static int ec168_rw_udev(struct usb_device *udev, struct ec168_req *req)
 	msleep(1); /* avoid I2C errors */
 
 	ret = usb_control_msg(udev, pipe, request, requesttype, req->value,
-		req->index, buf, sizeof(buf), EC168_USB_TIMEOUT);
+		req->index, buf, req->size, EC168_USB_TIMEOUT);
 
 	ec168_debug_dump(request, requesttype, req->value, req->index, buf,
 		req->size, deb_xfer);
 
 	if (ret < 0)
-		goto error;
+		goto err_dealloc;
 	else
 		ret = 0;
 
@@ -98,7 +106,11 @@ static int ec168_rw_udev(struct usb_device *udev, struct ec168_req *req)
 	if (!ret && requesttype == (USB_TYPE_VENDOR | USB_DIR_IN))
 		memcpy(req->data, buf, req->size);
 
+	kfree(buf);
 	return ret;
+
+err_dealloc:
+	kfree(buf);
 error:
 	deb_info("%s: failed:%d\n", __func__, ret);
 	return ret;
-- 
1.7.4.1

