Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab1CUSei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 14:34:38 -0400
Received: from ist.d-labs.de ([213.239.218.44]:43669 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218Ab1CUSeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 14:34:08 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, js@linuxtv.org,
        tskd2@yahoo.co.jp, liplianin@me.by, g.marco@freenet.de,
        aet@rasterburn.org, pb@linuxtv.org, mkrufky@linuxtv.org,
        nick@nick-andrew.net, max@veneto.com, janne-dvb@grunau.be,
        Florian Mickler <florian@mickler.org>
Subject: [PATCH 6/6] [media] opera1: get rid of on-stack dma buffer
Date: Mon, 21 Mar 2011 19:33:46 +0100
Message-Id: <1300732426-18958-7-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300732426-18958-1-git-send-email-florian@mickler.org>
References: <1300732426-18958-1-git-send-email-florian@mickler.org>
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
 drivers/media/dvb/dvb-usb/opera1.c |   31 ++++++++++++++++++++-----------
 1 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/opera1.c b/drivers/media/dvb/dvb-usb/opera1.c
index 1f1b7d6..2ca6e87 100644
--- a/drivers/media/dvb/dvb-usb/opera1.c
+++ b/drivers/media/dvb/dvb-usb/opera1.c
@@ -53,27 +53,36 @@ static int opera1_xilinx_rw(struct usb_device *dev, u8 request, u16 value,
 			    u8 * data, u16 len, int flags)
 {
 	int ret;
-	u8 r;
-	u8 u8buf[len];
-
+	u8 tmp;
+	u8 *buf;
 	unsigned int pipe = (flags == OPERA_READ_MSG) ?
 		usb_rcvctrlpipe(dev,0) : usb_sndctrlpipe(dev, 0);
 	u8 request_type = (flags == OPERA_READ_MSG) ? USB_DIR_IN : USB_DIR_OUT;
 
+	buf = kmalloc(len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
 	if (flags == OPERA_WRITE_MSG)
-		memcpy(u8buf, data, len);
-	ret =
-		usb_control_msg(dev, pipe, request, request_type | USB_TYPE_VENDOR,
-			value, 0x0, u8buf, len, 2000);
+		memcpy(buf, data, len);
+	ret = usb_control_msg(dev, pipe, request,
+			request_type | USB_TYPE_VENDOR, value, 0x0,
+			buf, len, 2000);
 
 	if (request == OPERA_TUNER_REQ) {
+		tmp = buf[0];
 		if (usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
-				OPERA_TUNER_REQ, USB_DIR_IN | USB_TYPE_VENDOR,
-				0x01, 0x0, &r, 1, 2000)<1 || r!=0x08)
-					return 0;
+			    OPERA_TUNER_REQ, USB_DIR_IN | USB_TYPE_VENDOR,
+			    0x01, 0x0, buf, 1, 2000) < 1 || buf[0] != 0x08) {
+			ret = 0;
+			goto out;
+		}
+		buf[0] = tmp;
 	}
 	if (flags == OPERA_READ_MSG)
-		memcpy(data, u8buf, len);
+		memcpy(data, buf, len);
+out:
+	kfree(buf);
 	return ret;
 }
 
-- 
1.7.4.1

