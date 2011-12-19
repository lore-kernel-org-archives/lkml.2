Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab1LSKbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 05:31:18 -0500
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:54212 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752326Ab1LSKbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 05:31:10 -0500
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
Subject: [PATCH 2/9] usb: dwc3: gadget: use generic map/unmap routines
Date: Mon, 19 Dec 2011 12:30:24 +0200
Message-Id: <1324290632-23758-3-git-send-email-balbi@ti.com>
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
 drivers/usb/dwc3/gadget.c |   80 +++++++--------------------------------------
 1 files changed, 12 insertions(+), 68 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index d228188..50e955f 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -54,70 +54,6 @@
 #include "gadget.h"
 #include "io.h"
 
-#define	DMA_ADDR_INVALID	(~(dma_addr_t)0)
-
-void dwc3_map_buffer_to_dma(struct dwc3_request *req)
-{
-	struct dwc3			*dwc = req->dep->dwc;
-
-	if (req->request.length == 0) {
-		/* req->request.dma = dwc->setup_buf_addr; */
-		return;
-	}
-
-	if (req->request.num_sgs) {
-		int	mapped;
-
-		mapped = dma_map_sg(dwc->dev, req->request.sg,
-				req->request.num_sgs,
-				req->direction ? DMA_TO_DEVICE
-				: DMA_FROM_DEVICE);
-		if (mapped < 0) {
-			dev_err(dwc->dev, "failed to map SGs\n");
-			return;
-		}
-
-		req->request.num_mapped_sgs = mapped;
-		return;
-	}
-
-	if (req->request.dma == DMA_ADDR_INVALID) {
-		req->request.dma = dma_map_single(dwc->dev, req->request.buf,
-				req->request.length, req->direction
-				? DMA_TO_DEVICE : DMA_FROM_DEVICE);
-		req->mapped = true;
-	}
-}
-
-void dwc3_unmap_buffer_from_dma(struct dwc3_request *req)
-{
-	struct dwc3			*dwc = req->dep->dwc;
-
-	if (req->request.length == 0) {
-		req->request.dma = DMA_ADDR_INVALID;
-		return;
-	}
-
-	if (req->request.num_mapped_sgs) {
-		req->request.dma = DMA_ADDR_INVALID;
-		dma_unmap_sg(dwc->dev, req->request.sg,
-				req->request.num_sgs,
-				req->direction ? DMA_TO_DEVICE
-				: DMA_FROM_DEVICE);
-
-		req->request.num_mapped_sgs = 0;
-		return;
-	}
-
-	if (req->mapped) {
-		dma_unmap_single(dwc->dev, req->request.dma,
-				req->request.length, req->direction
-				? DMA_TO_DEVICE : DMA_FROM_DEVICE);
-		req->mapped = 0;
-		req->request.dma = DMA_ADDR_INVALID;
-	}
-}
-
 void dwc3_gadget_giveback(struct dwc3_ep *dep, struct dwc3_request *req,
 		int status)
 {
@@ -144,7 +80,8 @@ void dwc3_gadget_giveback(struct dwc3_ep *dep, struct dwc3_request *req,
 	if (req->request.status == -EINPROGRESS)
 		req->request.status = status;
 
-	dwc3_unmap_buffer_from_dma(req);
+	usb_gadget_unmap_request(&dwc->gadget, &req->request,
+			req->direction);
 
 	dev_dbg(dwc->dev, "request %p from %s completed %d/%d ===> %d\n",
 			req, dep->name, req->request.actual,
@@ -558,7 +495,6 @@ static struct usb_request *dwc3_gadget_ep_alloc_request(struct usb_ep *ep,
 
 	req->epnum	= dep->number;
 	req->dep	= dep;
-	req->request.dma = DMA_ADDR_INVALID;
 
 	return &req->request;
 }
@@ -817,7 +753,8 @@ static int __dwc3_gadget_kick_transfer(struct dwc3_ep *dep, u16 cmd_param,
 		 * here and stop, unmap, free and del each of the linked
 		 * requests instead of we do now.
 		 */
-		dwc3_unmap_buffer_from_dma(req);
+		usb_gadget_unmap_request(&dwc->gadget, &req->request,
+				req->direction);
 		list_del(&req->list);
 		return ret;
 	}
@@ -832,6 +769,9 @@ static int __dwc3_gadget_kick_transfer(struct dwc3_ep *dep, u16 cmd_param,
 
 static int __dwc3_gadget_ep_queue(struct dwc3_ep *dep, struct dwc3_request *req)
 {
+	struct dwc3		*dwc = dep->dwc;
+	int			ret;
+
 	req->request.actual	= 0;
 	req->request.status	= -EINPROGRESS;
 	req->direction		= dep->direction;
@@ -849,7 +789,11 @@ static int __dwc3_gadget_ep_queue(struct dwc3_ep *dep, struct dwc3_request *req)
 	 * This will also avoid Host cancelling URBs due to too
 	 * many NACKs.
 	 */
-	dwc3_map_buffer_to_dma(req);
+	ret = usb_gadget_map_request(&dwc->gadget, &req->request,
+			dep->direction);
+	if (ret)
+		return ret;
+
 	list_add_tail(&req->list, &dep->request_list);
 
 	/*
-- 
1.7.8.rc3

