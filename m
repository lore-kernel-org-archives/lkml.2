Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992Ab1FPNcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 09:32:12 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7142 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955Ab1FPNcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 09:32:08 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6378"; a="98075672"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH/RFC 4/5] usb:dummy_hcd: Disable single-request fifo in dummy hcd
Date: Thu, 16 Jun 2011 16:31:06 +0300
Message-Id: <1308231068-24038-5-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1308231068-24038-2-git-send-email-tlinder@codeaurora.org>
References: <1308231068-24038-2-git-send-email-tlinder@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not the actual behavior of the udc, thus it's removed.

This patch is needed for several of UAS test to pass.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

---
 drivers/usb/gadget/dummy_hcd.c |   26 +-------------------------
 1 files changed, 1 insertions(+), 25 deletions(-)

diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index 7d0a6fe..41c7961 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -608,11 +608,6 @@ dummy_free_request (struct usb_ep *_ep, struct usb_request *_req)
 	kfree (req);
 }
 
-static void
-fifo_complete (struct usb_ep *ep, struct usb_request *req)
-{
-}
-
 static int
 dummy_queue (struct usb_ep *_ep, struct usb_request *_req,
 		gfp_t mem_flags)
@@ -648,26 +643,7 @@ dummy_queue (struct usb_ep *_ep, struct usb_request *_req,
 	_req->actual = 0;
 	spin_lock_irqsave (&dum->lock, flags);
 
-	/* implement an emulated single-request FIFO */
-	if (ep->desc && (ep->desc->bEndpointAddress & USB_DIR_IN) &&
-			list_empty (&dum->fifo_req.queue) &&
-			list_empty (&ep->queue) &&
-			_req->length <= FIFO_SIZE) {
-		req = &dum->fifo_req;
-		req->req = *_req;
-		req->req.buf = dum->fifo_buf;
-		memcpy (dum->fifo_buf, _req->buf, _req->length);
-		req->req.context = dum;
-		req->req.complete = fifo_complete;
-
-		list_add_tail(&req->queue, &ep->queue);
-		spin_unlock (&dum->lock);
-		_req->actual = _req->length;
-		_req->status = 0;
-		_req->complete (_ep, _req);
-		spin_lock (&dum->lock);
-	}  else
-		list_add_tail(&req->queue, &ep->queue);
+	list_add_tail(&req->queue, &ep->queue);
 	spin_unlock_irqrestore (&dum->lock, flags);
 
 	/* real hardware would likely enable transfers here, in case
-- 
1.7.3.3

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
