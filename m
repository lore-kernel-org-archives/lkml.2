Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab1CUSeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 14:34:09 -0400
Received: from ist.d-labs.de ([213.239.218.44]:43651 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab1CUSeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 14:34:06 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, js@linuxtv.org,
        tskd2@yahoo.co.jp, liplianin@me.by, g.marco@freenet.de,
        aet@rasterburn.org, pb@linuxtv.org, mkrufky@linuxtv.org,
        nick@nick-andrew.net, max@veneto.com, janne-dvb@grunau.be,
        Florian Mickler <florian@mickler.org>
Subject: [PATCH 4/6] [media] dw2102: get rid of on-stack dma buffer
Date: Mon, 21 Mar 2011 19:33:44 +0100
Message-Id: <1300732426-18958-5-git-send-email-florian@mickler.org>
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
 drivers/media/dvb/dvb-usb/dw2102.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dw2102.c b/drivers/media/dvb/dvb-usb/dw2102.c
index 2c307ba..4c8ff39 100644
--- a/drivers/media/dvb/dvb-usb/dw2102.c
+++ b/drivers/media/dvb/dvb-usb/dw2102.c
@@ -101,12 +101,16 @@ static int dw210x_op_rw(struct usb_device *dev, u8 request, u16 value,
 			u16 index, u8 * data, u16 len, int flags)
 {
 	int ret;
-	u8 u8buf[len];
-
+	u8 *u8buf;
 	unsigned int pipe = (flags == DW210X_READ_MSG) ?
 				usb_rcvctrlpipe(dev, 0) : usb_sndctrlpipe(dev, 0);
 	u8 request_type = (flags == DW210X_READ_MSG) ? USB_DIR_IN : USB_DIR_OUT;
 
+	u8buf = kmalloc(len, GFP_KERNEL);
+	if (!u8buf)
+		return -ENOMEM;
+
+
 	if (flags == DW210X_WRITE_MSG)
 		memcpy(u8buf, data, len);
 	ret = usb_control_msg(dev, pipe, request, request_type | USB_TYPE_VENDOR,
@@ -114,6 +118,8 @@ static int dw210x_op_rw(struct usb_device *dev, u8 request, u16 value,
 
 	if (flags == DW210X_READ_MSG)
 		memcpy(data, u8buf, len);
+
+	kfree(u8buf);
 	return ret;
 }
 
-- 
1.7.4.1

