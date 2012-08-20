Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab2HTIad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 04:30:33 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:42135 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754026Ab2HTIa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 04:30:28 -0400
From: Roland Stigge <stigge@antcom.de>
To: bigeasy@linutronix.de, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, aletes.xgr@gmail.com, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 2/3] usb: gadget: lpc32xx_udc: Remove usb_endpoint_descriptor
Date: Mon, 20 Aug 2012 10:30:13 +0200
Message-Id: <1345451414-9290-2-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1345451414-9290-1-git-send-email-stigge@antcom.de>
References: <1345451414-9290-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the utilization of struct usb_endpoint_descriptor, as done
by other drivers also. This was done on request by the USB gadget maintainers,
since this API is obsoleted.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---

Changes since v1:
* None

 drivers/usb/gadget/lpc32xx_udc.c |   23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

--- linux-2.6.orig/drivers/usb/gadget/lpc32xx_udc.c
+++ linux-2.6/drivers/usb/gadget/lpc32xx_udc.c
@@ -141,8 +141,6 @@ struct lpc32xx_ep {
 	u32                     totalints;
 
 	bool			wedge;
-
-	const struct usb_endpoint_descriptor *desc;
 };
 
 /*
@@ -556,10 +554,8 @@ static int proc_udc_show(struct seq_file
 
 	if (udc->enabled && udc->vbus) {
 		proc_ep_show(s, &udc->ep[0]);
-		list_for_each_entry(ep, &udc->gadget.ep_list, ep.ep_list) {
-			if (ep->desc)
-				proc_ep_show(s, ep);
-		}
+		list_for_each_entry(ep, &udc->gadget.ep_list, ep.ep_list)
+			proc_ep_show(s, ep);
 	}
 
 	spin_unlock_irqrestore(&udc->lock, flags);
@@ -1453,7 +1449,6 @@ static void udc_reinit(struct lpc32xx_ud
 
 		if (i != 0)
 			list_add_tail(&ep->ep.ep_list, &udc->gadget.ep_list);
-		ep->desc = NULL;
 		ep->ep.maxpacket = ep->maxpacket;
 		INIT_LIST_HEAD(&ep->queue);
 		ep->req_pending = 0;
@@ -1515,7 +1510,7 @@ static void nuke(struct lpc32xx_ep *ep,
 		done(ep, req, status);
 	}
 
-	if (ep->desc && status == -ESHUTDOWN) {
+	if (status == -ESHUTDOWN) {
 		uda_disable_hwepint(ep->udc, ep->hwep_num);
 		udc_disable_hwep(ep->udc, ep->hwep_num);
 	}
@@ -1658,9 +1653,6 @@ static int lpc32xx_ep_disable(struct usb
 
 	nuke(ep, -ESHUTDOWN);
 
-	/* restore the endpoint's pristine config */
-	ep->desc = NULL;
-
 	/* Clear all DMA statuses for this EP */
 	udc_ep_dma_disable(udc, ep->hwep_num);
 	writel(1 << ep->hwep_num, USBD_EOTINTCLR(udc->udp_baseaddr));
@@ -1696,7 +1688,7 @@ static int lpc32xx_ep_enable(struct usb_
 	unsigned long flags;
 
 	/* Verify EP data */
-	if ((!_ep) || (!ep) || (!desc) || (ep->desc) ||
+	if ((!_ep) || (!ep) || (!desc) ||
 	    (desc->bDescriptorType != USB_DT_ENDPOINT)) {
 		dev_dbg(udc->dev, "bad ep or descriptor\n");
 		return -EINVAL;
@@ -1754,7 +1746,6 @@ static int lpc32xx_ep_enable(struct usb_
 
 	/* Initialize endpoint to match the selected descriptor */
 	ep->is_in = (desc->bEndpointAddress & USB_DIR_IN) != 0;
-	ep->desc = desc;
 	ep->ep.maxpacket = maxpacket;
 
 	/* Map hardware endpoint from base and direction */
@@ -1837,7 +1828,7 @@ static int lpc32xx_ep_queue(struct usb_e
 
 	udc = ep->udc;
 
-	if (!_ep || (!ep->desc && ep->hwep_num_base != 0)) {
+	if (!_ep) {
 		dev_dbg(udc->dev, "invalid ep\n");
 		return -EINVAL;
 	}
@@ -1976,7 +1967,7 @@ static int lpc32xx_ep_set_halt(struct us
 	struct lpc32xx_udc *udc = ep->udc;
 	unsigned long flags;
 
-	if ((!ep) || (ep->desc == NULL) || (ep->hwep_num <= 1))
+	if ((!ep) || (ep->hwep_num <= 1))
 		return -EINVAL;
 
 	/* Don't halt an IN EP */
@@ -2262,7 +2253,7 @@ static int udc_get_status(struct lpc32xx
 	case USB_RECIP_ENDPOINT:
 		tmp = wIndex & USB_ENDPOINT_NUMBER_MASK;
 		ep = &udc->ep[tmp];
-		if ((tmp == 0) || (tmp >= NUM_ENDPOINTS) || (tmp && !ep->desc))
+		if ((tmp == 0) || (tmp >= NUM_ENDPOINTS))
 			return -EOPNOTSUPP;
 
 		if (wIndex & USB_DIR_IN) {
