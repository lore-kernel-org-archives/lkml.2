Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab1COIxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 04:53:33 -0400
Received: from ist.d-labs.de ([213.239.218.44]:47603 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007Ab1COIx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 04:53:26 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: oliver@neukum.org, jwjstone@fastmail.fm,
        Florian Mickler <florian@mickler.org>, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 06/16] [media] ce6230: get rid of on-stack dma buffer
Date: Tue, 15 Mar 2011 09:43:38 +0100
Message-Id: <1300178655-24832-6-git-send-email-florian@mickler.org>
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
 drivers/media/dvb/dvb-usb/ce6230.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/ce6230.c b/drivers/media/dvb/dvb-usb/ce6230.c
index 3df2045..6d1a304 100644
--- a/drivers/media/dvb/dvb-usb/ce6230.c
+++ b/drivers/media/dvb/dvb-usb/ce6230.c
@@ -39,7 +39,7 @@ static int ce6230_rw_udev(struct usb_device *udev, struct req_t *req)
 	u8 requesttype;
 	u16 value;
 	u16 index;
-	u8 buf[req->data_len];
+	u8 *buf;
 
 	request = req->cmd;
 	value = req->value;
@@ -62,6 +62,12 @@ static int ce6230_rw_udev(struct usb_device *udev, struct req_t *req)
 		goto error;
 	}
 
+	buf = kmalloc(req->data_len, GFP_KERNEL);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
 	if (requesttype == (USB_TYPE_VENDOR | USB_DIR_OUT)) {
 		/* write */
 		memcpy(buf, req->data, req->data_len);
@@ -74,7 +80,7 @@ static int ce6230_rw_udev(struct usb_device *udev, struct req_t *req)
 	msleep(1); /* avoid I2C errors */
 
 	ret = usb_control_msg(udev, pipe, request, requesttype, value, index,
-				buf, sizeof(buf), CE6230_USB_TIMEOUT);
+				buf, req->data_len, CE6230_USB_TIMEOUT);
 
 	ce6230_debug_dump(request, requesttype, value, index, buf,
 		req->data_len, deb_xfer);
@@ -88,6 +94,7 @@ static int ce6230_rw_udev(struct usb_device *udev, struct req_t *req)
 	if (!ret && requesttype == (USB_TYPE_VENDOR | USB_DIR_IN))
 		memcpy(req->data, buf, req->data_len);
 
+	kfree(buf);
 error:
 	return ret;
 }
-- 
1.7.4.rc3

