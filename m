Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256Ab2JSRy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 13:54:28 -0400
Received: from realvnc.com ([146.101.60.83]:48602 "EHLO realvnc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab2JSRy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 13:54:26 -0400
X-Greylist: delayed 2083 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Oct 2012 13:54:26 EDT
From: Simon Haggett <simon.haggett@realvnc.com>
To: Li Yang <leoli@freescale.com>, Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Simon Haggett <simon.haggett@realvnc.com>
Subject: [PATCH 1/1] usb: gadget: Don't attempt to dequeue requests for a disabled USB endpoint on Freescale hardware
Date: Fri, 19 Oct 2012 18:19:26 +0100
Message-Id: <1350667166-3559-1-git-send-email-simon.haggett@realvnc.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some gadget drivers may attempt to dequeue requests for an endpoint that has
already been disabled. For example, in the UVC gadget driver, uvc_function_set_alt()
will call usb_ep_disable() when alt setting 0 is selected. When the userspace
application subsequently issues the VIDIOC_STREAMOFF ioctl, uvc_video_enable()
invokes usb_ep_dequeue() to ensure that all requests have been cancelled.

For the Freescale High Speed Dual-Role USB controller, fsl_ep_dequeue() provides
the implementation of usb_ep_dequeue(). If this is called for a disabled endpoint,
a kernel oops will occur when the ep->ep.desc field is dereferenced (by ep_index()).
fsl_ep_disable() sets this field to NULL, as well as deleting all pending requests
for the endpoint.

This patch adds an additional check to fsl_ep_dequeue() to ensure that the
endpoint has not already been disabled before attempting to dequeue requests.

Signed-off-by: Simon Haggett <simon.haggett@realvnc.com>
---
 drivers/usb/gadget/fsl_udc_core.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index 6ae70cb..acd513b 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -955,7 +955,10 @@ static int fsl_ep_dequeue(struct usb_ep *_ep, struct usb_request *_req)
 	int ep_num, stopped, ret = 0;
 	u32 epctrl;
 
-	if (!_ep || !_req)
+	/* Ensure that the ep and request are valid, and the ep is not
+	 * disabled
+	 */
+	if (!_ep || !_req || !ep->ep.desc)
 		return -EINVAL;
 
 	spin_lock_irqsave(&ep->udc->lock, flags);
-- 
1.7.4.1

