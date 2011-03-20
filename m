Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab1CTVvi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 17:51:38 -0400
Received: from ist.d-labs.de ([213.239.218.44]:51928 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186Ab1CTVvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 17:51:32 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, crope@iki.fi,
        tvboxspy@gmail.com, Florian Mickler <florian@mickler.org>
Subject: [PATCH 5/5 v2] [media] lmedm04: get rid of on-stack dma buffers
Date: Sun, 20 Mar 2011 22:50:52 +0100
Message-Id: <1300657852-29318-6-git-send-email-florian@mickler.org>
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

Tested-By: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Florian Mickler <florian@mickler.org>

---

[v2: fix use after free as noted by Malcom]

drivers/media/dvb/dvb-usb/lmedm04.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index 0a3e88f..8a79354 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -314,13 +314,19 @@ static int lme2510_int_read(struct dvb_usb_adapter *adap)
 static int lme2510_return_status(struct usb_device *dev)
 {
 	int ret = 0;
-	u8 data[10] = {0};
+	u8 *data;
+
+	data = kzalloc(10, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
 
 	ret |= usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
 			0x06, 0x80, 0x0302, 0x00, data, 0x0006, 200);
 	info("Firmware Status: %x (%x)", ret , data[2]);
 
-	return (ret < 0) ? -ENODEV : data[2];
+	ret = (ret < 0) ? -ENODEV : data[2];
+	kfree(data);
+	return ret;
 }
 
 static int lme2510_msg(struct dvb_usb_device *d,
@@ -603,7 +609,7 @@ static int lme2510_download_firmware(struct usb_device *dev,
 					const struct firmware *fw)
 {
 	int ret = 0;
-	u8 data[512] = {0};
+	u8 *data;
 	u16 j, wlen, len_in, start, end;
 	u8 packet_size, dlen, i;
 	u8 *fw_data;
@@ -611,6 +617,11 @@ static int lme2510_download_firmware(struct usb_device *dev,
 	packet_size = 0x31;
 	len_in = 1;
 
+	data = kzalloc(512, GFP_KERNEL);
+	if (!data) {
+		info("FRM Could not start Firmware Download (Buffer allocation failed)");
+		return -ENOMEM;
+	}
 
 	info("FRM Starting Firmware Download");
 
@@ -654,7 +665,7 @@ static int lme2510_download_firmware(struct usb_device *dev,
 	else
 		info("FRM Firmware Download Completed - Resetting Device");
 
-
+	kfree(data);
 	return (ret < 0) ? -ENODEV : 0;
 }
 
-- 
1.7.4.1

