Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab2AXLra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 06:47:30 -0500
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:51602 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751325Ab2AXLr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 06:47:27 -0500
MIME-Version: 1.0
From: Felipe Balbi <balbi@ti.com>
To: Linux USB Mailing List <linux-usb@vger.kernel.org>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de> (supporter:USB SUBSYSTEM 
	,commit_signer:27/51=53%),
        Thomas Dahlmann <dahlmann.thomas@arcor.de> (supporter:AMD GEODE
	CS5536...),
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com> (commit_signer:44/51=86%),
        linux-omap@vger.kernel.org (open list:DESIGNWARE USB3 D...),
        linux-kernel@vger.kernel.org (open list),
        linux-geode@lists.infradead.org (open list:AMD GEODE CS5536...)
Subject: [PATCH 2/9] usb: dwc3: gadget: use generic map/unmap routines
Date: Tue, 24 Jan 2012 13:45:23 +0200
Message-Id: <1327405543-27589-3-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.8.2
In-Reply-To: <1327405543-27589-1-git-send-email-balbi@ti.com>
References: <1327405543-27589-1-git-send-email-balbi@ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

those routines have everything we need to map/unmap
USB requests and it's better to use them.

In order to achieve that, we had to add a simple
change on how we allocate and use our setup buffer;
we cannot allocate it from coherent anymore otherwise
the generic map/unmap routines won't be able to easily
know that the GetStatus request already has a DMA
address.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/dwc3/core.h   |    2 -
 drivers/usb/dwc3/ep0.c    |   16 ++++++-
 drivers/usb/dwc3/gadget.c |   93 ++++++++------------------------------------
 drivers/usb/dwc3/gadget.h |    2 -
 4 files changed, 30 insertions(+), 83 deletions(-)

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 9e57f8e..a72f42f 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -572,7 +572,6 @@ struct dwc3_request {
  * @ctrl_req_addr: dma address of ctrl_req
  * @ep0_trb: dma address of ep0_trb
  * @ep0_usb_req: dummy req used while handling STD USB requests
- * @setup_buf_addr: dma address of setup_buf
  * @ep0_bounce_addr: dma address of ep0_bounce
  * @lock: for synchronizing
  * @dev: pointer to our struct device
@@ -609,7 +608,6 @@ struct dwc3 {
 	u8			*setup_buf;
 	dma_addr_t		ctrl_req_addr;
 	dma_addr_t		ep0_trb_addr;
-	dma_addr_t		setup_buf_addr;
 	dma_addr_t		ep0_bounce_addr;
 	struct dwc3_request	ep0_usb_req;
 	/* device lock */
diff --git a/drivers/usb/dwc3/ep0.c b/drivers/usb/dwc3/ep0.c
index 2f51de5..24137d8 100644
--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -309,7 +309,7 @@ static int dwc3_ep0_handle_status(struct dwc3 *dwc,
 	dep = dwc->eps[0];
 	dwc->ep0_usb_req.dep = dep;
 	dwc->ep0_usb_req.request.length = sizeof(*response_pkt);
-	dwc->ep0_usb_req.request.dma = dwc->setup_buf_addr;
+	dwc->ep0_usb_req.request.buf = dwc->setup_buf;
 	dwc->ep0_usb_req.request.complete = dwc3_ep0_status_cmpl;
 
 	return __dwc3_gadget_ep0_queue(dep, &dwc->ep0_usb_req);
@@ -686,7 +686,12 @@ static void dwc3_ep0_do_control_data(struct dwc3 *dwc,
 				DWC3_TRBCTL_CONTROL_DATA);
 	} else if ((req->request.length % dep->endpoint.maxpacket)
 			&& (event->endpoint_number == 0)) {
-		dwc3_map_buffer_to_dma(req);
+		ret = usb_gadget_map_request(&dwc->gadget, &req->request,
+				event->endpoint_number);
+		if (ret) {
+			dev_dbg(dwc->dev, "failed to map request\n");
+			return;
+		}
 
 		WARN_ON(req->request.length > dep->endpoint.maxpacket);
 
@@ -701,7 +706,12 @@ static void dwc3_ep0_do_control_data(struct dwc3 *dwc,
 				dwc->ep0_bounce_addr, dep->endpoint.maxpacket,
 				DWC3_TRBCTL_CONTROL_DATA);
 	} else {
-		dwc3_map_buffer_to_dma(req);
+		ret = usb_gadget_map_request(&dwc->gadget, &req->request,
+				event->endpoint_number);
+		if (ret) {
+			dev_dbg(dwc->dev, "failed to map request\n");
+			return;
+		}
 
 		ret = dwc3_ep0_start_trans(dwc, event->endpoint_number,
 				req->request.dma, req->request.length,
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index a696bde..76036d0 100644
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
@@ -144,14 +80,15 @@ void dwc3_gadget_giveback(struct dwc3_ep *dep, struct dwc3_request *req,
 	if (req->request.status == -EINPROGRESS)
 		req->request.status = status;
 
-	dwc3_unmap_buffer_from_dma(req);
+	usb_gadget_unmap_request(&dwc->gadget, &req->request,
+			req->direction);
 
 	dev_dbg(dwc->dev, "request %p from %s completed %d/%d ===> %d\n",
 			req, dep->name, req->request.actual,
 			req->request.length, status);
 
 	spin_unlock(&dwc->lock);
-	req->request.complete(&req->dep->endpoint, &req->request);
+	req->request.complete(&dep->endpoint, &req->request);
 	spin_lock(&dwc->lock);
 }
 
@@ -562,7 +499,6 @@ static struct usb_request *dwc3_gadget_ep_alloc_request(struct usb_ep *ep,
 
 	req->epnum	= dep->number;
 	req->dep	= dep;
-	req->request.dma = DMA_ADDR_INVALID;
 
 	return &req->request;
 }
@@ -821,7 +757,8 @@ static int __dwc3_gadget_kick_transfer(struct dwc3_ep *dep, u16 cmd_param,
 		 * here and stop, unmap, free and del each of the linked
 		 * requests instead of we do now.
 		 */
-		dwc3_unmap_buffer_from_dma(req);
+		usb_gadget_unmap_request(&dwc->gadget, &req->request,
+				req->direction);
 		list_del(&req->list);
 		return ret;
 	}
@@ -837,6 +774,9 @@ static int __dwc3_gadget_kick_transfer(struct dwc3_ep *dep, u16 cmd_param,
 
 static int __dwc3_gadget_ep_queue(struct dwc3_ep *dep, struct dwc3_request *req)
 {
+	struct dwc3		*dwc = dep->dwc;
+	int			ret;
+
 	req->request.actual	= 0;
 	req->request.status	= -EINPROGRESS;
 	req->direction		= dep->direction;
@@ -854,7 +794,11 @@ static int __dwc3_gadget_ep_queue(struct dwc3_ep *dep, struct dwc3_request *req)
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
@@ -2149,9 +2093,8 @@ int __devinit dwc3_gadget_init(struct dwc3 *dwc)
 		goto err1;
 	}
 
-	dwc->setup_buf = dma_alloc_coherent(dwc->dev,
-			sizeof(*dwc->setup_buf) * 2,
-			&dwc->setup_buf_addr, GFP_KERNEL);
+	dwc->setup_buf = kzalloc(sizeof(*dwc->setup_buf) * 2,
+			GFP_KERNEL);
 	if (!dwc->setup_buf) {
 		dev_err(dwc->dev, "failed to allocate setup buffer\n");
 		ret = -ENOMEM;
@@ -2242,8 +2185,7 @@ err4:
 			dwc->ep0_bounce_addr);
 
 err3:
-	dma_free_coherent(dwc->dev, sizeof(*dwc->setup_buf) * 2,
-			dwc->setup_buf, dwc->setup_buf_addr);
+	kfree(dwc->setup_buf);
 
 err2:
 	dma_free_coherent(dwc->dev, sizeof(*dwc->ep0_trb),
@@ -2272,8 +2214,7 @@ void dwc3_gadget_exit(struct dwc3 *dwc)
 	dma_free_coherent(dwc->dev, 512, dwc->ep0_bounce,
 			dwc->ep0_bounce_addr);
 
-	dma_free_coherent(dwc->dev, sizeof(*dwc->setup_buf) * 2,
-			dwc->setup_buf, dwc->setup_buf_addr);
+	kfree(dwc->setup_buf);
 
 	dma_free_coherent(dwc->dev, sizeof(*dwc->ep0_trb),
 			dwc->ep0_trb, dwc->ep0_trb_addr);
diff --git a/drivers/usb/dwc3/gadget.h b/drivers/usb/dwc3/gadget.h
index d97f467..12f1e10 100644
--- a/drivers/usb/dwc3/gadget.h
+++ b/drivers/usb/dwc3/gadget.h
@@ -108,8 +108,6 @@ int dwc3_gadget_ep0_queue(struct usb_ep *ep, struct usb_request *request,
 int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value);
 int dwc3_send_gadget_ep_cmd(struct dwc3 *dwc, unsigned ep,
 		unsigned cmd, struct dwc3_gadget_ep_cmd_params *params);
-void dwc3_map_buffer_to_dma(struct dwc3_request *req);
-void dwc3_unmap_buffer_from_dma(struct dwc3_request *req);
 
 /**
  * dwc3_gadget_ep_get_transfer_index - Gets transfer index from HW
-- 
1.7.8.2

