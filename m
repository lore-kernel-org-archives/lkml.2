Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab2AXLsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 06:48:13 -0500
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:50041 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755075Ab2AXLsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 06:48:10 -0500
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
Subject: [PATCH 8/9] usb: gadget: net2280: use generic map/unmap routines
Date: Tue, 24 Jan 2012 13:45:29 +0200
Message-Id: <1327405543-27589-9-git-send-email-balbi@ti.com>
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
 drivers/usb/gadget/net2280.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index cdedd13..a5ccabc 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -806,12 +806,8 @@ done (struct net2280_ep *ep, struct net2280_request *req, int status)
 		status = req->req.status;
 
 	dev = ep->dev;
-	if (req->mapped) {
-		pci_unmap_single (dev->pdev, req->req.dma, req->req.length,
-			ep->is_in ? PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);
-		req->req.dma = DMA_ADDR_INVALID;
-		req->mapped = 0;
-	}
+	if (ep->dma)
+		usb_gadget_unmap_request(&dev->gadget, &req->req, ep->is_in);
 
 	if (status && status != -ESHUTDOWN)
 		VDEBUG (dev, "complete %s req %p stat %d len %u/%u\n",
@@ -857,10 +853,13 @@ net2280_queue (struct usb_ep *_ep, struct usb_request *_req, gfp_t gfp_flags)
 		return -EOPNOTSUPP;
 
 	/* set up dma mapping in case the caller didn't */
-	if (ep->dma && _req->dma == DMA_ADDR_INVALID) {
-		_req->dma = pci_map_single (dev->pdev, _req->buf, _req->length,
-			ep->is_in ? PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);
-		req->mapped = 1;
+	if (ep->dma) {
+		int ret;
+
+		ret = usb_gadget_map_request(&dev->gadget, _req,
+				ep->is_in);
+		if (ret)
+			return ret;
 	}
 
 #if 0
-- 
1.7.8.2

