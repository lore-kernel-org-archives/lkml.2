Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab2BAVRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:17:15 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48772 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932567Ab2BAVKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:10:19 -0500
X-Sasl-enc: PMcpTSYC+2G7ecJ0ZwZR3bS2bwc0or9e2mfam8RHJQbg 1328130617
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:48 2012
Message-Id: <20120201210048.129713369@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:12 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Felipe Balbi <balbi@ti.com>
Subject: [48/89] usb: dwc3: ep0: tidy up Pending Request handling
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit 68d8a781575d7be490f97eb2c403fb13b083da6a upstream.

The way our code was written, we should never have
a DWC3_EP_PENDING_REQUEST flag set out of a Data Phase
and the code in __dwc3_gadget_ep0_queue() did not
reflect that situation properly.

Tidy up that case to avoid any possible mistakes
when starting requests for IRQs which are long
gone.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/ep0.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -149,20 +149,14 @@ static int __dwc3_gadget_ep0_queue(struc
 
 		direction = !!(dep->flags & DWC3_EP0_DIR_IN);
 
-		if (dwc->ep0state == EP0_STATUS_PHASE) {
-			type = dwc->three_stage_setup
-				? DWC3_TRBCTL_CONTROL_STATUS3
-				: DWC3_TRBCTL_CONTROL_STATUS2;
-		} else if (dwc->ep0state == EP0_DATA_PHASE) {
-			type = DWC3_TRBCTL_CONTROL_DATA;
-		} else {
-			/* should never happen */
-			WARN_ON(1);
+		if (dwc->ep0state != EP0_DATA_PHASE) {
+			dev_WARN(dwc->dev, "Unexpected pending request\n");
 			return 0;
 		}
 
 		ret = dwc3_ep0_start_trans(dwc, direction,
-				req->request.dma, req->request.length, type);
+				req->request.dma, req->request.length,
+				DWC3_TRBCTL_CONTROL_DATA);
 		dep->flags &= ~(DWC3_EP_PENDING_REQUEST |
 				DWC3_EP0_DIR_IN);
 	}


