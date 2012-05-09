Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab2EIFwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:52:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38643 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752939Ab2EIFwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:36 -0400
Message-Id: <20120509055031.256414470@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:50:41 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tomoki Sekiyama <tomoki.sekiyama@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 012/167] [PATCH] USB: yurex: Remove allocation of coherent buffer for
 setup-packet buffer
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>

commit 523fc5c14f6cad283e5a266eba0e343aed6e73d5 upstream.

Removes allocation of coherent buffer for the control-request setup-packet
buffer from the yurex driver. Using coherent buffers for setup-packet is
obsolete and does not work with some USB host implementations.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/misc/yurex.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
index 897edda..a4a76fc 100644
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
-- 
1.7.10



