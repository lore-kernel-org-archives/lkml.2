Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200Ab2C2Xvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 19:51:40 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53289 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932511Ab2C2Xvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 19:51:33 -0400
Message-ID: <4F74F580.2060004@gmail.com>
Date: Fri, 30 Mar 2012 08:51:28 +0900
From: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] USB: yurex: Remove allocation of coherent buffer for
 setup-packet buffer
References: <4F739CBB.8060602@gmail.com> <4F744E23.3040207@mvista.com> <CAM1upfMY=fh_XgYuY69SOZEz7y0G3hdqvZxoBWTDVGH5j7ixyQ@mail.gmail.com>
In-Reply-To: <CAM1upfMY=fh_XgYuY69SOZEz7y0G3hdqvZxoBWTDVGH5j7ixyQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes allocation of coherent buffer for the control-request setup-packet
buffer from the yurex driver. Using coherent buffers for setup-packet is
obsolete and does not work with some USB host implementations.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
---
 drivers/usb/misc/yurex.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

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
1.7.7.6
