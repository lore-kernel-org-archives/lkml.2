Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab2KZKYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 05:24:20 -0500
Received: from smtp1.goneo.de ([212.90.139.80]:45311 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655Ab2KZKYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 05:24:16 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.697
From: Lars Poeschel <poeschel@lemonage.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH for-next] mfd: viperboard: do version query in dma memory
Date: Mon, 26 Nov 2012 11:24:53 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201211261124.53774.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Poeschel <poeschel@lemonage.de>

The query for the viperboard version was done with memory buffer
on the stack but usb transfers need dma capable memory buffer.
This is fixed now.

Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
 drivers/mfd/viperboard.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
index 276122b..af2a670 100644
--- a/drivers/mfd/viperboard.c
+++ b/drivers/mfd/viperboard.c
@@ -56,7 +56,6 @@ static int vprbrd_probe(struct usb_interface *interface,
 
 	u16 version = 0;
 	int pipe, ret;
-	unsigned char buf[1];
 
 	/* allocate memory for our device state and initialize it */
 	vb = kzalloc(sizeof(*vb), GFP_KERNEL);
@@ -76,17 +75,17 @@ static int vprbrd_probe(struct usb_interface *interface,
 	/* get version information, major first, minor then */
 	pipe = usb_rcvctrlpipe(vb->usb_dev, 0);
 	ret = usb_control_msg(vb->usb_dev, pipe, VPRBRD_USB_REQUEST_MAJOR,
-		VPRBRD_USB_TYPE_IN, 0x0000, 0x0000, buf, 1,
+		VPRBRD_USB_TYPE_IN, 0x0000, 0x0000, vb->buf, 1,
 		VPRBRD_USB_TIMEOUT_MS);
 	if (ret == 1)
-		version = buf[0];
+		version = vb->buf[0];
 
 	ret = usb_control_msg(vb->usb_dev, pipe, VPRBRD_USB_REQUEST_MINOR,
-		VPRBRD_USB_TYPE_IN, 0x0000, 0x0000, buf, 1,
+		VPRBRD_USB_TYPE_IN, 0x0000, 0x0000, vb->buf, 1,
 		VPRBRD_USB_TIMEOUT_MS);
 	if (ret == 1) {
 		version <<= 8;
-		version = version | buf[0];
+		version = version | vb->buf[0];
 	}
 
 	dev_info(&interface->dev,
-- 
1.7.10.4

