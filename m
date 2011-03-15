Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab1COIxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 04:53:52 -0400
Received: from ist.d-labs.de ([213.239.218.44]:47671 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755856Ab1COIx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 04:53:28 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: oliver@neukum.org, jwjstone@fastmail.fm,
        Florian Mickler <florian@mickler.org>, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 05/16] [media] ec168: get rid of on stack dma buffers
Date: Tue, 15 Mar 2011 09:43:37 +0100
Message-Id: <1300178655-24832-5-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <1300178655-24832-1-git-send-email-florian@mickler.org>
References: <20110315093632.5fc9fb77@schatten.dmk.lab>
 <1300178655-24832-1-git-send-email-florian@mickler.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb_control_msg initiates (and waits for completion of) a dma transfer using
the supplied buffer. That buffer thus has to be seperately allocated on
the heap.

In lib/dma_debug.c the function check_for_stack even warns about it:
	WARNING: at lib/dma-debug.c:866 check_for_stack

Note: This change is tested to compile only, as I don't have the hardware.

Signed-off-by: Florian Mickler <florian@mickler.org>
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
1.7.4.rc3

