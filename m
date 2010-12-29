Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab0L2BJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 20:09:26 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:7874 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752658Ab0L2BJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 20:09:25 -0500
Message-ID: <4D1A89D5.5010203@dsn.okisemi.com>
Date: Wed, 29 Dec 2010 10:07:33 +0900
From: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-usb <linux-usb@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>, "Wang, Qi" <qi.wang@intel.com>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        Andrew <andrew.chih.howe.khor@intel.com>,
        Intel OTC <joel.clark@intel.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>
Subject: [PATCH] usb: pch_udc: Fixed issue which does not work with g_serial
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This PCH_UDC driver does not work normally when "Serial gadget" is used.
The receiving data of control transmission (EP0 Control OUT Transaction)
has not received correctly.

This patch fixed this issue.
The following was modified.
 - The buffer size.
 - The change processing of a receiving buffer
   (The temporary buffer and the buffer prepared by gadget).
 - The setup processing of a DMA descriptor.

Currently the PCH_UDC driver can work normally with "Serial gadget"
or "File-backed Storage Gadget".

Signed-off-by: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
---
 drivers/usb/gadget/pch_udc.c |  117 ++++++++++++++++++++++++------------------
 1 files changed, 67 insertions(+), 50 deletions(-)

diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index 0c8dd81..dfe927b 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -198,10 +198,10 @@
 #define PCH_UDC_BRLEN		0x0F	/* Burst length */
 #define PCH_UDC_THLEN		0x1F	/* Threshold length */
 /* Value of EP Buffer Size */
-#define UDC_EP0IN_BUFF_SIZE	64
-#define UDC_EPIN_BUFF_SIZE	512
-#define UDC_EP0OUT_BUFF_SIZE	64
-#define UDC_EPOUT_BUFF_SIZE	512
+#define UDC_EP0IN_BUFF_SIZE	16
+#define UDC_EPIN_BUFF_SIZE	256
+#define UDC_EP0OUT_BUFF_SIZE	16
+#define UDC_EPOUT_BUFF_SIZE	256
 /* Value of EP maximum packet size */
 #define UDC_EP0IN_MAX_PKT_SIZE	64
 #define UDC_EP0OUT_MAX_PKT_SIZE	64
@@ -351,7 +351,7 @@ struct pch_udc_dev {
 	struct pci_pool		*data_requests;
 	struct pci_pool		*stp_requests;
 	dma_addr_t			dma_addr;
-	unsigned long			ep0out_buf[64];
+	void				*ep0out_buf;
 	struct usb_ctrlrequest		setup_data;
 	unsigned long			phys_addr;
 	void __iomem			*base_addr;
@@ -1219,11 +1219,11 @@ static void complete_req(struct pch_udc_ep *ep, struct pch_udc_request *req,
 	dev = ep->dev;
 	if (req->dma_mapped) {
 		if (ep->in)
-			pci_unmap_single(dev->pdev, req->req.dma,
-					 req->req.length, PCI_DMA_TODEVICE);
+			dma_unmap_single(&dev->pdev->dev, req->req.dma,
+					 req->req.length, DMA_TO_DEVICE);
 		else
-			pci_unmap_single(dev->pdev, req->req.dma,
-					 req->req.length, PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&dev->pdev->dev, req->req.dma,
+					 req->req.length, DMA_FROM_DEVICE);
 		req->dma_mapped = 0;
 		req->req.dma = DMA_ADDR_INVALID;
 	}
@@ -1414,7 +1414,6 @@ static void pch_udc_start_rxrequest(struct pch_udc_ep *ep,
 
 	pch_udc_clear_dma(ep->dev, DMA_DIR_RX);
 	td_data = req->td_data;
-	ep->td_data = req->td_data;
 	/* Set the status bits for all descriptors */
 	while (1) {
 		td_data->status = (td_data->status & ~PCH_UDC_BUFF_STS) |
@@ -1613,15 +1612,19 @@ static int pch_udc_pcd_queue(struct usb_ep *usbep, struct usb_request *usbreq,
 	if (usbreq->length &&
 	    ((usbreq->dma == DMA_ADDR_INVALID) || !usbreq->dma)) {
 		if (ep->in)
-			usbreq->dma = pci_map_single(dev->pdev, usbreq->buf,
-					usbreq->length, PCI_DMA_TODEVICE);
+			usbreq->dma = dma_map_single(&dev->pdev->dev,
+						     usbreq->buf,
+						     usbreq->length,
+						     DMA_TO_DEVICE);
 		else
-			usbreq->dma = pci_map_single(dev->pdev, usbreq->buf,
-					usbreq->length, PCI_DMA_FROMDEVICE);
+			usbreq->dma = dma_map_single(&dev->pdev->dev,
+						     usbreq->buf,
+						     usbreq->length,
+						     DMA_FROM_DEVICE);
 		req->dma_mapped = 1;
 	}
 	if (usbreq->length > 0) {
-		retval = prepare_dma(ep, req, gfp);
+		retval = prepare_dma(ep, req, GFP_ATOMIC);
 		if (retval)
 			goto probe_end;
 	}
@@ -1646,7 +1649,6 @@ static int pch_udc_pcd_queue(struct usb_ep *usbep, struct usb_request *usbreq,
 			pch_udc_wait_ep_stall(ep);
 			pch_udc_ep_clear_nak(ep);
 			pch_udc_enable_ep_interrupts(ep->dev, (1 << ep->num));
-			pch_udc_set_dma(dev, DMA_DIR_TX);
 		}
 	}
 	/* Now add this request to the ep's pending requests */
@@ -1926,6 +1928,7 @@ static void pch_udc_complete_receiver(struct pch_udc_ep *ep)
 	    PCH_UDC_BS_DMA_DONE)
 		return;
 	pch_udc_clear_dma(ep->dev, DMA_DIR_RX);
+	pch_udc_ep_set_ddptr(ep, 0);
 	if ((req->td_data_last->status & PCH_UDC_RXTX_STS) !=
 	    PCH_UDC_RTS_SUCC) {
 		dev_err(&dev->pdev->dev, "Invalid RXTX status (0x%08x) "
@@ -1963,7 +1966,7 @@ static void pch_udc_svc_data_in(struct pch_udc_dev *dev, int ep_num)
 	u32	epsts;
 	struct pch_udc_ep	*ep;
 
-	ep = &dev->ep[2*ep_num];
+	ep = &dev->ep[UDC_EPIN_IDX(ep_num)];
 	epsts = ep->epsts;
 	ep->epsts = 0;
 
@@ -2008,7 +2011,7 @@ static void pch_udc_svc_data_out(struct pch_udc_dev *dev, int ep_num)
 	struct pch_udc_ep		*ep;
 	struct pch_udc_request		*req = NULL;
 
-	ep = &dev->ep[2*ep_num + 1];
+	ep = &dev->ep[UDC_EPOUT_IDX(ep_num)];
 	epsts = ep->epsts;
 	ep->epsts = 0;
 
@@ -2025,10 +2028,11 @@ static void pch_udc_svc_data_out(struct pch_udc_dev *dev, int ep_num)
 	}
 	if (epsts & UDC_EPSTS_HE)
 		return;
-	if (epsts & UDC_EPSTS_RSS)
+	if (epsts & UDC_EPSTS_RSS) {
 		pch_udc_ep_set_stall(ep);
 		pch_udc_enable_ep_interrupts(ep->dev,
 					     PCH_UDC_EPINT(ep->in, ep->num));
+	}
 	if (epsts & UDC_EPSTS_RCS) {
 		if (!dev->prot_stall) {
 			pch_udc_ep_clear_stall(ep);
@@ -2060,8 +2064,10 @@ static void pch_udc_svc_control_in(struct pch_udc_dev *dev)
 {
 	u32	epsts;
 	struct pch_udc_ep	*ep;
+	struct pch_udc_ep	*ep_out;
 
 	ep = &dev->ep[UDC_EP0IN_IDX];
+	ep_out = &dev->ep[UDC_EP0OUT_IDX];
 	epsts = ep->epsts;
 	ep->epsts = 0;
 
@@ -2073,8 +2079,16 @@ static void pch_udc_svc_control_in(struct pch_udc_dev *dev)
 		return;
 	if (epsts & UDC_EPSTS_HE)
 		return;
-	if ((epsts & UDC_EPSTS_TDC) && (!dev->stall))
+	if ((epsts & UDC_EPSTS_TDC) && (!dev->stall)) {
 		pch_udc_complete_transfer(ep);
+		pch_udc_clear_dma(dev, DMA_DIR_RX);
+		ep_out->td_data->status = (ep_out->td_data->status &
+					~PCH_UDC_BUFF_STS) |
+					PCH_UDC_BS_HST_RDY;
+		pch_udc_ep_clear_nak(ep_out);
+		pch_udc_set_dma(dev, DMA_DIR_RX);
+		pch_udc_ep_set_rrdy(ep_out);
+	}
 	/* On IN interrupt, provide data if we have any */
 	if ((epsts & UDC_EPSTS_IN) && !(epsts & UDC_EPSTS_TDC) &&
 	     !(epsts & UDC_EPSTS_TXEMPTY))
@@ -2102,11 +2116,9 @@ static void pch_udc_svc_control_out(struct pch_udc_dev *dev)
 		dev->stall = 0;
 		dev->ep[UDC_EP0IN_IDX].halted = 0;
 		dev->ep[UDC_EP0OUT_IDX].halted = 0;
-		/* In data not ready */
-		pch_udc_ep_set_nak(&(dev->ep[UDC_EP0IN_IDX]));
 		dev->setup_data = ep->td_stp->request;
 		pch_udc_init_setup_buff(ep->td_stp);
-		pch_udc_clear_dma(dev, DMA_DIR_TX);
+		pch_udc_clear_dma(dev, DMA_DIR_RX);
 		pch_udc_ep_fifo_flush(&(dev->ep[UDC_EP0IN_IDX]),
 				      dev->ep[UDC_EP0IN_IDX].in);
 		if ((dev->setup_data.bRequestType & USB_DIR_IN))
@@ -2122,14 +2134,23 @@ static void pch_udc_svc_control_out(struct pch_udc_dev *dev)
 		setup_supported = dev->driver->setup(&dev->gadget,
 						     &dev->setup_data);
 		spin_lock(&dev->lock);
+
+		if (dev->setup_data.bRequestType & USB_DIR_IN) {
+			ep->td_data->status = (ep->td_data->status &
+						~PCH_UDC_BUFF_STS) |
+						PCH_UDC_BS_HST_RDY;
+			pch_udc_ep_set_ddptr(ep, ep->td_data_phys);
+		}
 		/* ep0 in returns data on IN phase */
 		if (setup_supported >= 0 && setup_supported <
 					    UDC_EP0IN_MAX_PKT_SIZE) {
 			pch_udc_ep_clear_nak(&(dev->ep[UDC_EP0IN_IDX]));
 			/* Gadget would have queued a request when
 			 * we called the setup */
-			pch_udc_set_dma(dev, DMA_DIR_RX);
-			pch_udc_ep_clear_nak(ep);
+			if (!(dev->setup_data.bRequestType & USB_DIR_IN)) {
+				pch_udc_set_dma(dev, DMA_DIR_RX);
+				pch_udc_ep_clear_nak(ep);
+			}
 		} else if (setup_supported < 0) {
 			/* if unsupported request, then stall */
 			pch_udc_ep_set_stall(&(dev->ep[UDC_EP0IN_IDX]));
@@ -2142,22 +2163,13 @@ static void pch_udc_svc_control_out(struct pch_udc_dev *dev)
 		}
 	} else if ((((stat & UDC_EPSTS_OUT_MASK) >> UDC_EPSTS_OUT_SHIFT) ==
 		     UDC_EPSTS_OUT_DATA) && !dev->stall) {
-		if (list_empty(&ep->queue)) {
-			dev_err(&dev->pdev->dev, "%s: No request\n", __func__);
-			ep->td_data->status = (ep->td_data->status &
-					       ~PCH_UDC_BUFF_STS) |
-					       PCH_UDC_BS_HST_RDY;
-			pch_udc_set_dma(dev, DMA_DIR_RX);
-		} else {
-			/* control write */
-			/* next function will pickuo an clear the status */
+		pch_udc_clear_dma(dev, DMA_DIR_RX);
+		pch_udc_ep_set_ddptr(ep, 0);
+		if (!list_empty(&ep->queue)) {
 			ep->epsts = stat;
-
-			pch_udc_svc_data_out(dev, 0);
-			/* re-program desc. pointer for possible ZLPs */
-			pch_udc_ep_set_ddptr(ep, ep->td_data_phys);
-			pch_udc_set_dma(dev, DMA_DIR_RX);
+			pch_udc_svc_data_out(dev, PCH_UDC_EP0);
 		}
+		pch_udc_set_dma(dev, DMA_DIR_RX);
 	}
 	pch_udc_ep_set_rrdy(ep);
 }
@@ -2174,7 +2186,7 @@ static void pch_udc_postsvc_epinters(struct pch_udc_dev *dev, int ep_num)
 	struct pch_udc_ep	*ep;
 	struct pch_udc_request *req;
 
-	ep = &dev->ep[2*ep_num];
+	ep = &dev->ep[UDC_EPIN_IDX(ep_num)];
 	if (!list_empty(&ep->queue)) {
 		req = list_entry(ep->queue.next, struct pch_udc_request, queue);
 		pch_udc_enable_ep_interrupts(ep->dev,
@@ -2196,13 +2208,13 @@ static void pch_udc_read_all_epstatus(struct pch_udc_dev *dev, u32 ep_intr)
 	for (i = 0; i < PCH_UDC_USED_EP_NUM; i++) {
 		/* IN */
 		if (ep_intr & (0x1 << i)) {
-			ep = &dev->ep[2*i];
+			ep = &dev->ep[UDC_EPIN_IDX(i)];
 			ep->epsts = pch_udc_read_ep_status(ep);
 			pch_udc_clear_ep_status(ep, ep->epsts);
 		}
 		/* OUT */
 		if (ep_intr & (0x10000 << i)) {
-			ep = &dev->ep[2*i+1];
+			ep = &dev->ep[UDC_EPOUT_IDX(i)];
 			ep->epsts = pch_udc_read_ep_status(ep);
 			pch_udc_clear_ep_status(ep, ep->epsts);
 		}
@@ -2563,9 +2575,6 @@ static void pch_udc_pcd_reinit(struct pch_udc_dev *dev)
 	dev->ep[UDC_EP0IN_IDX].ep.maxpacket = UDC_EP0IN_MAX_PKT_SIZE;
 	dev->ep[UDC_EP0OUT_IDX].ep.maxpacket = UDC_EP0OUT_MAX_PKT_SIZE;
 
-	dev->dma_addr = pci_map_single(dev->pdev, dev->ep0out_buf, 256,
-				  PCI_DMA_FROMDEVICE);
-
 	/* remove ep0 in and out from the list.  They have own pointer */
 	list_del_init(&dev->ep[UDC_EP0IN_IDX].ep.ep_list);
 	list_del_init(&dev->ep[UDC_EP0OUT_IDX].ep.ep_list);
@@ -2637,6 +2646,13 @@ static int init_dma_pools(struct pch_udc_dev *dev)
 	dev->ep[UDC_EP0IN_IDX].td_stp_phys = 0;
 	dev->ep[UDC_EP0IN_IDX].td_data = NULL;
 	dev->ep[UDC_EP0IN_IDX].td_data_phys = 0;
+
+	dev->ep0out_buf = kzalloc(UDC_EP0OUT_BUFF_SIZE * 4, GFP_KERNEL);
+	if (!dev->ep0out_buf)
+		return -ENOMEM;
+	dev->dma_addr = dma_map_single(&dev->pdev->dev, dev->ep0out_buf,
+				       UDC_EP0OUT_BUFF_SIZE * 4,
+				       DMA_FROM_DEVICE);
 	return 0;
 }
 
@@ -2750,6 +2766,11 @@ static void pch_udc_remove(struct pci_dev *pdev)
 		pci_pool_destroy(dev->stp_requests);
 	}
 
+	if (dev->dma_addr)
+		dma_unmap_single(&dev->pdev->dev, dev->dma_addr,
+				 UDC_EP0OUT_BUFF_SIZE * 4, DMA_FROM_DEVICE);
+	kfree(dev->ep0out_buf);
+
 	pch_udc_exit(dev);
 
 	if (dev->irq_registered)
@@ -2792,11 +2813,7 @@ static int pch_udc_resume(struct pci_dev *pdev)
 	int ret;
 
 	pci_set_power_state(pdev, PCI_D0);
-	ret = pci_restore_state(pdev);
-	if (ret) {
-		dev_err(&pdev->dev, "%s: pci_restore_state failed\n", __func__);
-		return ret;
-	}
+	pci_restore_state(pdev);
 	ret = pci_enable_device(pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "%s: pci_enable_device failed\n", __func__);
-- 
1.6.2.5
