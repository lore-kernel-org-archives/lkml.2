Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab1LSKd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 05:33:27 -0500
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:59805 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752345Ab1LSKbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 05:31:12 -0500
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
Subject: [PATCH 3/9] usb: gadget: langwell: use generic map/unmap functions
Date: Mon, 19 Dec 2011 12:30:25 +0200
Message-Id: <1324290632-23758-4-git-send-email-balbi@ti.com>
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
 drivers/usb/gadget/langwell_udc.c |   45 +++++-------------------------------
 1 files changed, 7 insertions(+), 38 deletions(-)

diff --git a/drivers/usb/gadget/langwell_udc.c b/drivers/usb/gadget/langwell_udc.c
index fa0fcc1..fe7fbe3 100644
--- a/drivers/usb/gadget/langwell_udc.c
+++ b/drivers/usb/gadget/langwell_udc.c
@@ -406,16 +406,7 @@ static void done(struct langwell_ep *ep, struct langwell_request *req,
 		dma_pool_free(dev->dtd_pool, curr_dtd, curr_dtd->dtd_dma);
 	}
 
-	if (req->mapped) {
-		dma_unmap_single(&dev->pdev->dev,
-			req->req.dma, req->req.length,
-			is_in(ep) ? PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);
-		req->req.dma = DMA_ADDR_INVALID;
-		req->mapped = 0;
-	} else
-		dma_sync_single_for_cpu(&dev->pdev->dev, req->req.dma,
-				req->req.length,
-				is_in(ep) ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
+	usb_gadget_unmap_request(&dev->gadget, &req->req, is_in(ep));
 
 	if (status != -ESHUTDOWN)
 		dev_dbg(&dev->pdev->dev,
@@ -754,7 +745,8 @@ static int langwell_ep_queue(struct usb_ep *_ep, struct usb_request *_req,
 	struct langwell_ep	*ep;
 	struct langwell_udc	*dev;
 	unsigned long		flags;
-	int			is_iso = 0, zlflag = 0;
+	int			is_iso = 0;
+	int			ret;
 
 	/* always require a cpu-view buffer */
 	req = container_of(_req, struct langwell_request, req);
@@ -781,33 +773,10 @@ static int langwell_ep_queue(struct usb_ep *_ep, struct usb_request *_req,
 	if (unlikely(!dev->driver || dev->gadget.speed == USB_SPEED_UNKNOWN))
 		return -ESHUTDOWN;
 
-	/* set up dma mapping in case the caller didn't */
-	if (_req->dma == DMA_ADDR_INVALID) {
-		/* WORKAROUND: WARN_ON(size == 0) */
-		if (_req->length == 0) {
-			dev_vdbg(&dev->pdev->dev, "req->length: 0->1\n");
-			zlflag = 1;
-			_req->length++;
-		}
-
-		_req->dma = dma_map_single(&dev->pdev->dev,
-				_req->buf, _req->length,
-				is_in(ep) ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
-		if (zlflag && (_req->length == 1)) {
-			dev_vdbg(&dev->pdev->dev, "req->length: 1->0\n");
-			zlflag = 0;
-			_req->length = 0;
-		}
-
-		req->mapped = 1;
-		dev_vdbg(&dev->pdev->dev, "req->mapped = 1\n");
-	} else {
-		dma_sync_single_for_device(&dev->pdev->dev,
-				_req->dma, _req->length,
-				is_in(ep) ?  DMA_TO_DEVICE : DMA_FROM_DEVICE);
-		req->mapped = 0;
-		dev_vdbg(&dev->pdev->dev, "req->mapped = 0\n");
-	}
+	/* set up dma mapping */
+	ret = usb_gadget_map_request(&dev->gadget, &req->req, is_in(ep));
+	if (ret)
+		return ret;
 
 	dev_dbg(&dev->pdev->dev,
 			"%s queue req %p, len %u, buf %p, dma 0x%08x\n",
-- 
1.7.8.rc3

