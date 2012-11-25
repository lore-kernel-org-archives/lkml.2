Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab2KYCE6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 21:04:58 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:53876 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab2KYCE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 21:04:57 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, gregkh@linuxfoundation.org, balbi@ti.com,
        laurent.pinchart@ideasonboard.com, kernel-janitors@vger.kernel.org,
        Cyril Roelandt <tipecaml@gmail.com>
Subject: [PATCH v2] UVC: use GFP_ATOMIC under spin lock.
Date: Sun, 25 Nov 2012 02:58:19 +0100
Message-Id: <1353808699-17224-1-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <50ADDDD5.1080709@bfs.de>
References: <50ADDDD5.1080709@bfs.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found using the following semantic patch:
<spml>
@@
@@
spin_lock_irqsave(...);
... when != spin_unlock_irqrestore(...);
* GFP_KERNEL
</spml>

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/usb/gadget/uvc_video.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/uvc_video.c b/drivers/usb/gadget/uvc_video.c
index b0e53a8..cd067a6 100644
--- a/drivers/usb/gadget/uvc_video.c
+++ b/drivers/usb/gadget/uvc_video.c
@@ -309,7 +309,8 @@ uvc_video_pump(struct uvc_video *video)
 		video->encode(req, video, buf);
 
 		/* Queue the USB request */
-		if ((ret = usb_ep_queue(video->ep, req, GFP_KERNEL)) < 0) {
+		ret = usb_ep_queue(video->ep, req, GFP_ATOMIC);
+		if (ret < 0) {
 			printk(KERN_INFO "Failed to queue request (%d)\n", ret);
 			usb_ep_set_halt(video->ep);
 			spin_unlock_irqrestore(&video->queue.irqlock, flags);
-- 
1.7.10.4

