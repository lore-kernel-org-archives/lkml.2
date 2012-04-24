Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479Ab2DXWfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:35:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38637 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406Ab2DXWfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:35:14 -0400
Message-Id: <20120424223243.462239357@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:32:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
Subject: [ 17/62] USB: yurex: Remove allocation of coherent buffer for setup-packet buffer
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>

commit 523fc5c14f6cad283e5a266eba0e343aed6e73d5 upstream.

Removes allocation of coherent buffer for the control-request setup-packet
buffer from the yurex driver. Using coherent buffers for setup-packet is
obsolete and does not work with some USB host implementations.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/yurex.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -99,9 +99,7 @@ static void yurex_delete(struct kref *kr
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
@@ -234,9 +232,7 @@ static int yurex_probe(struct usb_interf
 	}
 
 	/* allocate buffer for control req */
-	dev->cntl_req = usb_alloc_coherent(dev->udev, YUREX_BUF_SIZE,
-					   GFP_KERNEL,
-					   &dev->cntl_urb->setup_dma);
+	dev->cntl_req = kmalloc(YUREX_BUF_SIZE, GFP_KERNEL);
 	if (!dev->cntl_req) {
 		err("Could not allocate cntl_req");
 		goto error;


