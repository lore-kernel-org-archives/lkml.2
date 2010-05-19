Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab0ESK0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 06:26:40 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:42771 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab0ESK0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 06:26:38 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Jiri Slaby <jslaby@suse.cz>, Dmitry Torokhov <dtor@mail.ru>,
       Devin Heitmueller <dheitmueller@kernellabs.com>,
       linux-media@vger.kernel.org
Subject: [PATCH] drivers/media/dvb/dvb-usb/dib0700: fix return values
Date: Wed, 19 May 2010 12:26:12 +0200
Message-Id: <1274264772-19292-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Propagte correct error values instead of returning -1 which just means
-EPERM ("Permission denied")

While at it, also fix some coding style violations.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/dvb/dvb-usb/dib0700_core.c |   47 ++++++++++++++---------------
 1 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
index d5e2c23..c73da6b 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_core.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
@@ -111,23 +111,24 @@ int dib0700_set_gpio(struct dvb_usb_device *d, enum dib07x0_gpios gpio, u8 gpio_
 
 static int dib0700_set_usb_xfer_len(struct dvb_usb_device *d, u16 nb_ts_packets)
 {
-    struct dib0700_state *st = d->priv;
-    u8 b[3];
-    int ret;
-
-    if (st->fw_version >= 0x10201) {
-	b[0] = REQUEST_SET_USB_XFER_LEN;
-	b[1] = (nb_ts_packets >> 8)&0xff;
-	b[2] = nb_ts_packets & 0xff;
-
-	deb_info("set the USB xfer len to %i Ts packet\n", nb_ts_packets);
-
-	ret = dib0700_ctrl_wr(d, b, 3);
-    } else {
-	deb_info("this firmware does not allow to change the USB xfer len\n");
-	ret = -EIO;
-    }
-    return ret;
+	struct dib0700_state *st = d->priv;
+	u8 b[3];
+	int ret;
+
+	if (st->fw_version >= 0x10201) {
+		b[0] = REQUEST_SET_USB_XFER_LEN;
+		b[1] = (nb_ts_packets >> 8)&0xff;
+		b[2] = nb_ts_packets & 0xff;
+
+		deb_info("set the USB xfer len to %i Ts packet\n", nb_ts_packets);
+
+		ret = dib0700_ctrl_wr(d, b, 3);
+	} else {
+		deb_info("this firmware does not allow to change the USB xfer len\n");
+		ret = -EIO;
+	}
+
+	return ret;
 }
 
 /*
@@ -642,7 +643,7 @@ int dib0700_rc_setup(struct dvb_usb_device *d)
 	i = dib0700_ctrl_wr(d, rc_setup, 3);
 	if (i<0) {
 		err("ir protocol setup failed");
-		return -1;
+		return i;
 	}
 
 	if (st->fw_version < 0x10200)
@@ -652,7 +653,7 @@ int dib0700_rc_setup(struct dvb_usb_device *d)
 	purb = usb_alloc_urb(0, GFP_KERNEL);
 	if (purb == NULL) {
 		err("rc usb alloc urb failed\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	purb->transfer_buffer = usb_buffer_alloc(d->udev, RC_MSG_SIZE_V1_20,
@@ -661,7 +662,7 @@ int dib0700_rc_setup(struct dvb_usb_device *d)
 	if (purb->transfer_buffer == NULL) {
 		err("rc usb_buffer_alloc() failed\n");
 		usb_free_urb(purb);
-		return -1;
+		return -ENOMEM;
 	}
 
 	purb->status = -EINPROGRESS;
@@ -670,12 +671,10 @@ int dib0700_rc_setup(struct dvb_usb_device *d)
 			  dib0700_rc_urb_completion, d);
 
 	ret = usb_submit_urb(purb, GFP_ATOMIC);
-	if (ret != 0) {
+	if (ret != 0)
 		err("rc submit urb failed\n");
-		return -1;
-	}
 
-	return 0;
+	return ret;
 }
 
 static int dib0700_probe(struct usb_interface *intf,
-- 
1.7.1

