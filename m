Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326Ab2C1XUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 19:20:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35274 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758463Ab2C1XUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 19:20:30 -0400
Message-ID: <4F739CBB.8060602@gmail.com>
Date: Thu, 29 Mar 2012 08:20:27 +0900
From: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] USB: yurex: remove allocation of coherent buffer for setup-packet
 buffer
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes allocation of coherent buffer for the control-request setup-packet
buffer from the yurex driver. Using coherent buffers for setup-packet is
obsoleted and does not work with some USB host implementations.

This patch also fixes missing URB_NO_TRANSFER_DMA_MAP flag in urb.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
---
 drivers/usb/misc/yurex.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
index 897edda..7020146 100644
--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -99,9 +99,7 @@ static void yurex_delete(struct kref *kref)
 	usb_put_dev(dev->udev);
 	if (dev->cntl_urb) {
 		usb_kill_urb(dev->cntl_urb);
-		if (dev->cntl_req)
-			usb_free_coherent(dev->udev, YUREX_BUF_SIZE,
-				dev->cntl_req, dev->cntl_urb->setup_dma);
+		kfree(dev->cntl_req);
 		if (dev->cntl_buffer)
 			usb_free_coherent(dev->udev, YUREX_BUF_SIZE,
 				dev->cntl_buffer, dev->cntl_urb->transfer_dma);
@@ -234,9 +232,7 @@ static int yurex_probe(struct usb_interface *interface, const struct usb_device_
 	}
 
 	/* allocate buffer for control req */
-	dev->cntl_req = usb_alloc_coherent(dev->udev, YUREX_BUF_SIZE,
-					   GFP_KERNEL,
-					   &dev->cntl_urb->setup_dma);
+	dev->cntl_req = kmalloc(YUREX_BUF_SIZE, GFP_KERNEL);
 	if (!dev->cntl_req) {
 		err("Could not allocate cntl_req");
 		goto error;
@@ -286,7 +282,7 @@ static int yurex_probe(struct usb_interface *interface, const struct usb_device_
 			 usb_rcvintpipe(dev->udev, dev->int_in_endpointAddr),
 			 dev->int_buffer, YUREX_BUF_SIZE, yurex_interrupt,
 			 dev, 1);
-	dev->cntl_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+	dev->urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 	if (usb_submit_urb(dev->urb, GFP_KERNEL)) {
 		retval = -EIO;
 		err("Could not submitting URB");
-- 
1.7.7.6

