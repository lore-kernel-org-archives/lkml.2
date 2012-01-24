Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab2AXLsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 06:48:17 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:52086 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756294Ab2AXLsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 06:48:14 -0500
MIME-Version: 1.0
From: Felipe Balbi <balbi@ti.com>
To: Linux USB Mailing List <linux-usb@vger.kernel.org>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de> (supporter:USB SUBSYSTEM 
	,commit_signer:28/51=55%),
        Thomas Dahlmann <dahlmann.thomas@arcor.de> (supporter:AMD GEODE
	CS5536...),
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com> (commit_signer:43/51=84%),
        linux-omap@vger.kernel.org (open list:DESIGNWARE USB3 D...),
        linux-kernel@vger.kernel.org (open list),
        linux-geode@lists.infradead.org (open list:AMD GEODE CS5536...)
Subject: [PATCH 9/9] usb: gadget: goku: use generic map/unmap routines
Date: Tue, 24 Jan 2012 13:45:30 +0200
Message-Id: <1327405543-27589-10-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.8.2
In-Reply-To: <1327405543-27589-1-git-send-email-balbi@ti.com>
References: <1327405543-27589-1-git-send-email-balbi@ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

those routines have everything we need to map/unmap
USB requests and it's better to use them.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/gadget/goku_udc.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/gadget/goku_udc.c b/drivers/usb/gadget/goku_udc.c
index 5af70fcc..5e1b766 100644
--- a/drivers/usb/gadget/goku_udc.c
+++ b/drivers/usb/gadget/goku_udc.c
@@ -310,12 +310,9 @@ done(struct goku_ep *ep, struct goku_request *req, int status)
 		status = req->req.status;
 
 	dev = ep->dev;
-	if (req->mapped) {
-		pci_unmap_single(dev->pdev, req->req.dma, req->req.length,
-			ep->is_in ? PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);
-		req->req.dma = DMA_ADDR_INVALID;
-		req->mapped = 0;
-	}
+
+	if (ep->dma)
+		usb_gadget_unmap_request(&dev->gadget, &req->req, ep->is_in);
 
 #ifndef USB_TRACE
 	if (status && status != -ESHUTDOWN)
@@ -736,10 +733,11 @@ goku_queue(struct usb_ep *_ep, struct usb_request *_req, gfp_t gfp_flags)
 		return -EBUSY;
 
 	/* set up dma mapping in case the caller didn't */
-	if (ep->dma && _req->dma == DMA_ADDR_INVALID) {
-		_req->dma = pci_map_single(dev->pdev, _req->buf, _req->length,
-			ep->is_in ? PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);
-		req->mapped = 1;
+	if (ep->dma) {
+		status = usb_gadget_map_request(&dev->gadget, &req->req,
+				ep->is_in);
+		if (status)
+			return status;
 	}
 
 #ifdef USB_TRACE
-- 
1.7.8.2

