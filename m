Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab1CTVwy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 17:52:54 -0400
Received: from ist.d-labs.de ([213.239.218.44]:51951 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab1CTVvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 17:51:33 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, crope@iki.fi,
        tvboxspy@gmail.com, Florian Mickler <florian@mickler.org>
Subject: [PATCH 3/5] [media] au6610: get rid of on-stack dma buffer
Date: Sun, 20 Mar 2011 22:50:50 +0100
Message-Id: <1300657852-29318-4-git-send-email-florian@mickler.org>
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
 drivers/media/dvb/dvb-usb/au6610.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/au6610.c b/drivers/media/dvb/dvb-usb/au6610.c
index eb34cc3..2351077 100644
--- a/drivers/media/dvb/dvb-usb/au6610.c
+++ b/drivers/media/dvb/dvb-usb/au6610.c
@@ -33,8 +33,16 @@ static int au6610_usb_msg(struct dvb_usb_device *d, u8 operation, u8 addr,
 {
 	int ret;
 	u16 index;
-	u8 usb_buf[6]; /* enough for all known requests,
-			  read returns 5 and write 6 bytes */
+	u8 *usb_buf;
+
+	/*
+	 * allocate enough for all known requests,
+	 * read returns 5 and write 6 bytes
+	 */
+	usb_buf = kmalloc(6, GFP_KERNEL);
+	if (!usb_buf)
+		return -ENOMEM;
+
 	switch (wlen) {
 	case 1:
 		index = wbuf[0] << 8;
@@ -45,14 +53,15 @@ static int au6610_usb_msg(struct dvb_usb_device *d, u8 operation, u8 addr,
 		break;
 	default:
 		warn("wlen = %x, aborting.", wlen);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto error;
 	}
 
 	ret = usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0), operation,
 			      USB_TYPE_VENDOR|USB_DIR_IN, addr << 1, index,
-			      usb_buf, sizeof(usb_buf), AU6610_USB_TIMEOUT);
+			      usb_buf, 6, AU6610_USB_TIMEOUT);
 	if (ret < 0)
-		return ret;
+		goto error;
 
 	switch (operation) {
 	case AU6610_REQ_I2C_READ:
@@ -60,7 +69,8 @@ static int au6610_usb_msg(struct dvb_usb_device *d, u8 operation, u8 addr,
 		/* requested value is always 5th byte in buffer */
 		rbuf[0] = usb_buf[4];
 	}
-
+error:
+	kfree(usb_buf);
 	return ret;
 }
 
-- 
1.7.4.1

