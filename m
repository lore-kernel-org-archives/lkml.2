Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab1LSKbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 05:31:24 -0500
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:35419 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751568Ab1LSKbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 05:31:21 -0500
From: Felipe Balbi <balbi@ti.com>
To: Linux USB Mailing List <linux-usb@vger.kernel.org>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de> (supporter:USB SUBSYSTEM 
	,commit_signer:28/50=56%),
        Thomas Dahlmann <dahlmann.thomas@arcor.de> (supporter:AMD GEODE
	CS5536...),
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com> (commit_signer:43/50=86%),
        linux-omap@vger.kernel.org (open list:DESIGNWARE USB3 D...),
        linux-kernel@vger.kernel.org (open list),
        linux-geode@lists.infradead.org (open list:AMD GEODE CS5536...)
Subject: [PATCH 5/9] usb: gadget: amd5536: use generic map/unmap routines
Date: Mon, 19 Dec 2011 12:30:27 +0200
Message-Id: <1324290632-23758-6-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.8.rc3
In-Reply-To: <1324290632-23758-1-git-send-email-balbi@ti.com>
References: <1324290632-23758-1-git-send-email-balbi@ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

those routines have everything we need to map/unmap
USB requests and it's better to use them.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/gadget/amd5536udc.c |   32 +++++---------------------------
 1 files changed, 5 insertions(+), 27 deletions(-)

diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index e9a2c5c..d3d0282 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -831,20 +831,7 @@ __acquires(ep->dev->lock)
 
 	dev = ep->dev;
 	/* unmap DMA */
-	if (req->dma_mapping) {
-		if (ep->in)
-			pci_unmap_single(dev->pdev,
-					req->req.dma,
-					req->req.length,
-					PCI_DMA_TODEVICE);
-		else
-			pci_unmap_single(dev->pdev,
-					req->req.dma,
-					req->req.length,
-					PCI_DMA_FROMDEVICE);
-		req->dma_mapping = 0;
-		req->req.dma = DMA_DONT_USE;
-	}
+	usb_gadget_unmap_request(&dev->gadget, &req->req, ep->in);
 
 	halted = ep->halted;
 	ep->halted = 1;
@@ -1095,20 +1082,11 @@ udc_queue(struct usb_ep *usbep, struct usb_request *usbreq, gfp_t gfp)
 		return -ESHUTDOWN;
 
 	/* map dma (usually done before) */
-	if (ep->dma && usbreq->length != 0
-			&& (usbreq->dma == DMA_DONT_USE || usbreq->dma == 0)) {
+	if (ep->dma) {
 		VDBG(dev, "DMA map req %p\n", req);
-		if (ep->in)
-			usbreq->dma = pci_map_single(dev->pdev,
-						usbreq->buf,
-						usbreq->length,
-						PCI_DMA_TODEVICE);
-		else
-			usbreq->dma = pci_map_single(dev->pdev,
-						usbreq->buf,
-						usbreq->length,
-						PCI_DMA_FROMDEVICE);
-		req->dma_mapping = 1;
+		retval = usb_gadget_map_request(&udc->gadget, &req->req, ep->in);
+		if (retval)
+			return retval;
 	}
 
 	VDBG(dev, "%s queue req %p, len %d req->td_data=%p buf %p\n",
-- 
1.7.8.rc3

