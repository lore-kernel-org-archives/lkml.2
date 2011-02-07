Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab1BGHze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 02:55:34 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:48921 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752601Ab1BGHzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 02:55:31 -0500
Message-ID: <4D4FA6D6.8080309@dsn.okisemi.com>
Date: Mon, 07 Feb 2011 17:01:26 +0900
From: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-usb <linux-usb@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>, "Wang, Qi" <qi.wang@intel.com>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        Andrew <andrew.chih.howe.khor@intel.com>,
        Intel OTC <joel.clark@intel.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>
Subject: [PATCH] usb: pch_udc: Fixed issue which does not work with g_ether
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This PCH_UDC driver does not work normally when "Ethernet gadget" is used.

This patch fixed this issue.
The following was modified.
 - The FIFO flush process.
 - The descriptor creation process.
 - The adjustment of DMA buffer align.

Currently the PCH_UDC driver can work normally with "Ethernet gadget",
"Serial gadget" or "File-backed Storage Gadget".

Signed-off-by: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
---
 drivers/usb/gadget/pch_udc.c |  178 ++++++++++++++++++++++++-----------------
 1 files changed, 104 insertions(+), 74 deletions(-)

diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index b120dbb..3e4b35e 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -367,7 +367,6 @@ struct pch_udc_dev {
 static const char	ep0_string[] = "ep0in";
 static DEFINE_SPINLOCK(udc_stall_spinlock);	/* stall spin lock */
 struct pch_udc_dev *pch_udc;		/* pointer to device object */
-
 static int speed_fs;
 module_param_named(speed_fs, speed_fs, bool, S_IRUGO);
 MODULE_PARM_DESC(speed_fs, "true for Full speed operation");
@@ -383,6 +382,8 @@ MODULE_PARM_DESC(speed_fs, "true for Full speed operation");
  * @dma_mapped:		DMA memory mapped for request
  * @dma_done:		DMA completed for request
  * @chain_len:		chain length
+ * @buf:		Buffer memory for align adjustment
+ * @dma:		DMA memory for align adjustment
  */
 struct pch_udc_request {
 	struct usb_request		req;
@@ -394,6 +395,8 @@ struct pch_udc_request {
 					dma_mapped:1,
 					dma_done:1;
 	unsigned			chain_len;
+	void				*buf;
+	dma_addr_t			dma;
 };
 
 static inline u32 pch_udc_readl(struct pch_udc_dev *dev, unsigned long reg)
@@ -615,7 +618,7 @@ static inline void pch_udc_ep_set_trfr_type(struct pch_udc_ep *ep,
 /**
  * pch_udc_ep_set_bufsz() - Set the maximum packet size for the endpoint
  * @ep:		Reference to structure of type pch_udc_ep_regs
- * @buf_size:	The buffer size
+ * @buf_size:	The buffer word size
  */
 static void pch_udc_ep_set_bufsz(struct pch_udc_ep *ep,
 						 u32 buf_size, u32 ep_in)
@@ -635,7 +638,7 @@ static void pch_udc_ep_set_bufsz(struct pch_udc_ep *ep,
 /**
  * pch_udc_ep_set_maxpkt() - Set the Max packet size for the endpoint
  * @ep:		Reference to structure of type pch_udc_ep_regs
- * @pkt_size:	The packet size
+ * @pkt_size:	The packet byte size
  */
 static void pch_udc_ep_set_maxpkt(struct pch_udc_ep *ep, u32 pkt_size)
 {
@@ -920,25 +923,10 @@ static void pch_udc_ep_clear_nak(struct pch_udc_ep *ep)
  */
 static void pch_udc_ep_fifo_flush(struct pch_udc_ep *ep, int dir)
 {
-	unsigned int loopcnt = 0;
-	struct pch_udc_dev *dev = ep->dev;
-
 	if (dir) {	/* IN ep */
 		pch_udc_ep_bit_set(ep, UDC_EPCTL_ADDR, UDC_EPCTL_F);
 		return;
 	}
-
-	if (pch_udc_read_ep_status(ep) & UDC_EPSTS_MRXFIFO_EMP)
-		return;
-	pch_udc_ep_bit_set(ep, UDC_EPCTL_ADDR, UDC_EPCTL_MRXFLUSH);
-	/* Wait for RxFIFO Empty */
-	loopcnt = 10000;
-	while (!(pch_udc_read_ep_status(ep) & UDC_EPSTS_MRXFIFO_EMP) &&
-		--loopcnt)
-		udelay(5);
-	if (!loopcnt)
-		dev_err(&dev->pdev->dev, "RxFIFO not Empty\n");
-	pch_udc_ep_bit_clr(ep, UDC_EPCTL_ADDR, UDC_EPCTL_MRXFLUSH);
 }
 
 /**
@@ -1220,14 +1208,31 @@ static void complete_req(struct pch_udc_ep *ep, struct pch_udc_request *req,
 
 	dev = ep->dev;
 	if (req->dma_mapped) {
-		if (ep->in)
-			dma_unmap_single(&dev->pdev->dev, req->req.dma,
-					 req->req.length, DMA_TO_DEVICE);
-		else
-			dma_unmap_single(&dev->pdev->dev, req->req.dma,
-					 req->req.length, DMA_FROM_DEVICE);
+		if (req->dma == DMA_ADDR_INVALID) {
+			if (ep->in)
+				dma_unmap_single(&dev->pdev->dev, req->req.dma,
+						 req->req.length,
+						 DMA_TO_DEVICE);
+			else
+				dma_unmap_single(&dev->pdev->dev, req->req.dma,
+						 req->req.length,
+						 DMA_FROM_DEVICE);
+			req->req.dma = DMA_ADDR_INVALID;
+		} else {
+			if (ep->in)
+				dma_unmap_single(&dev->pdev->dev, req->dma,
+						 req->req.length,
+						 DMA_TO_DEVICE);
+			else {
+				dma_unmap_single(&dev->pdev->dev, req->dma,
+						 req->req.length,
+						 DMA_FROM_DEVICE);
+				memcpy(req->req.buf, req->buf, req->req.length);
+			}
+			kfree(req->buf);
+			req->dma = DMA_ADDR_INVALID;
+		}
 		req->dma_mapped = 0;
-		req->req.dma = DMA_ADDR_INVALID;
 	}
 	ep->halted = 1;
 	spin_unlock(&dev->lock);
@@ -1268,12 +1273,18 @@ static void pch_udc_free_dma_chain(struct pch_udc_dev *dev,
 	struct pch_udc_data_dma_desc *td = req->td_data;
 	unsigned i = req->chain_len;
 
+	dma_addr_t addr2;
+	dma_addr_t addr = (dma_addr_t)td->next;
+	td->next = 0x00;
 	for (; i > 1; --i) {
-		dma_addr_t addr = (dma_addr_t)td->next;
 		/* do not free first desc., will be done by free for request */
 		td = phys_to_virt(addr);
+		addr2 = (dma_addr_t)td->next;
 		pci_pool_free(dev->data_requests, td, addr);
+		td->next = 0x00;
+		addr = addr2;
 	}
+	req->chain_len = 1;
 }
 
 /**
@@ -1301,23 +1312,23 @@ static int pch_udc_create_dma_chain(struct pch_udc_ep *ep,
 	if (req->chain_len > 1)
 		pch_udc_free_dma_chain(ep->dev, req);
 
-	for (; ; bytes -= buf_len, ++len) {
-		if (ep->in)
-			td->status = PCH_UDC_BS_HST_BSY | min(buf_len, bytes);
-		else
-			td->status = PCH_UDC_BS_HST_BSY;
+	if (req->dma == DMA_ADDR_INVALID)
+		td->dataptr = req->req.dma;
+	else
+		td->dataptr = req->dma;
 
+	td->status = PCH_UDC_BS_HST_BSY;
+	for (; ; bytes -= buf_len, ++len) {
+		td->status = PCH_UDC_BS_HST_BSY | min(buf_len, bytes);
 		if (bytes <= buf_len)
 			break;
-
 		last = td;
 		td = pci_pool_alloc(ep->dev->data_requests, gfp_flags,
 				    &dma_addr);
 		if (!td)
 			goto nomem;
-
 		i += buf_len;
-		td->dataptr = req->req.dma + i;
+		td->dataptr = req->td_data->dataptr + i;
 		last->next = dma_addr;
 	}
 
@@ -1352,28 +1363,15 @@ static int prepare_dma(struct pch_udc_ep *ep, struct pch_udc_request *req,
 {
 	int	retval;
 
-	req->td_data->dataptr = req->req.dma;
-	req->td_data->status |= PCH_UDC_DMA_LAST;
 	/* Allocate and create a DMA chain */
 	retval = pch_udc_create_dma_chain(ep, req, ep->ep.maxpacket, gfp);
 	if (retval) {
-		pr_err("%s: could not create DMA chain: %d\n",
-		       __func__, retval);
+		pr_err("%s: could not create DMA chain:%d\n", __func__, retval);
 		return retval;
 	}
-	if (!ep->in)
-		return 0;
-	if (req->req.length <= ep->ep.maxpacket)
-		req->td_data->status = PCH_UDC_DMA_LAST | PCH_UDC_BS_HST_BSY |
-				       req->req.length;
-	/* if bytes < max packet then tx bytes must
-	 * be written in packet per buffer mode
-	 */
-	if ((req->req.length < ep->ep.maxpacket) || !ep->num)
+	if (ep->in)
 		req->td_data->status = (req->td_data->status &
-					~PCH_UDC_RXTX_BYTES) | req->req.length;
-	req->td_data->status = (req->td_data->status &
-				~PCH_UDC_BUFF_STS) | PCH_UDC_BS_HST_BSY;
+				~PCH_UDC_BUFF_STS) | PCH_UDC_BS_HST_RDY;
 	return 0;
 }
 
@@ -1529,6 +1527,7 @@ static struct usb_request *pch_udc_alloc_request(struct usb_ep *usbep,
 	if (!req)
 		return NULL;
 	req->req.dma = DMA_ADDR_INVALID;
+	req->dma = DMA_ADDR_INVALID;
 	INIT_LIST_HEAD(&req->queue);
 	if (!ep->dev->dma_addr)
 		return &req->req;
@@ -1613,16 +1612,33 @@ static int pch_udc_pcd_queue(struct usb_ep *usbep, struct usb_request *usbreq,
 	/* map the buffer for dma */
 	if (usbreq->length &&
 	    ((usbreq->dma == DMA_ADDR_INVALID) || !usbreq->dma)) {
-		if (ep->in)
-			usbreq->dma = dma_map_single(&dev->pdev->dev,
-						     usbreq->buf,
-						     usbreq->length,
-						     DMA_TO_DEVICE);
-		else
-			usbreq->dma = dma_map_single(&dev->pdev->dev,
-						     usbreq->buf,
-						     usbreq->length,
-						     DMA_FROM_DEVICE);
+		if (!((unsigned long)(usbreq->buf) & 0x03)) {
+			if (ep->in)
+				usbreq->dma = dma_map_single(&dev->pdev->dev,
+							     usbreq->buf,
+							     usbreq->length,
+							     DMA_TO_DEVICE);
+			else
+				usbreq->dma = dma_map_single(&dev->pdev->dev,
+							     usbreq->buf,
+							     usbreq->length,
+							     DMA_FROM_DEVICE);
+		} else {
+			req->buf = kzalloc(usbreq->length, GFP_ATOMIC);
+			if (!req->buf)
+				return -ENOMEM;
+			if (ep->in) {
+				memcpy(req->buf, usbreq->buf, usbreq->length);
+				req->dma = dma_map_single(&dev->pdev->dev,
+							  req->buf,
+							  usbreq->length,
+							  DMA_TO_DEVICE);
+			} else
+				req->dma = dma_map_single(&dev->pdev->dev,
+							  req->buf,
+							  usbreq->length,
+							  DMA_FROM_DEVICE);
+		}
 		req->dma_mapped = 1;
 	}
 	if (usbreq->length > 0) {
@@ -1920,32 +1936,46 @@ static void pch_udc_complete_receiver(struct pch_udc_ep *ep)
 	struct pch_udc_request *req;
 	struct pch_udc_dev *dev = ep->dev;
 	unsigned int count;
+	struct pch_udc_data_dma_desc *td;
+	dma_addr_t addr;
 
 	if (list_empty(&ep->queue))
 		return;
-
 	/* next request */
 	req = list_entry(ep->queue.next, struct pch_udc_request, queue);
-	if ((req->td_data_last->status & PCH_UDC_BUFF_STS) !=
-	    PCH_UDC_BS_DMA_DONE)
-		return;
 	pch_udc_clear_dma(ep->dev, DMA_DIR_RX);
 	pch_udc_ep_set_ddptr(ep, 0);
-	if ((req->td_data_last->status & PCH_UDC_RXTX_STS) !=
-	    PCH_UDC_RTS_SUCC) {
-		dev_err(&dev->pdev->dev, "Invalid RXTX status (0x%08x) "
-			"epstatus=0x%08x\n",
-			(req->td_data_last->status & PCH_UDC_RXTX_STS),
-			(int)(ep->epsts));
-		return;
-	}
-	count = req->td_data_last->status & PCH_UDC_RXTX_BYTES;
+	if ((req->td_data_last->status & PCH_UDC_BUFF_STS) ==
+	    PCH_UDC_BS_DMA_DONE)
+		td = req->td_data_last;
+	else
+		td = req->td_data;
 
+	while (1) {
+		if ((td->status & PCH_UDC_RXTX_STS) != PCH_UDC_RTS_SUCC) {
+			dev_err(&dev->pdev->dev, "Invalid RXTX status=0x%08x "
+				"epstatus=0x%08x\n",
+				(req->td_data->status & PCH_UDC_RXTX_STS),
+				(int)(ep->epsts));
+			return;
+		}
+		if ((td->status & PCH_UDC_BUFF_STS) == PCH_UDC_BS_DMA_DONE)
+			if (td->status | PCH_UDC_DMA_LAST) {
+				count = td->status & PCH_UDC_RXTX_BYTES;
+				break;
+			}
+		if (td == req->td_data_last) {
+			dev_err(&dev->pdev->dev, "Not complete RX descriptor");
+			return;
+		}
+		addr = (dma_addr_t)td->next;
+		td = phys_to_virt(addr);
+	}
 	/* on 64k packets the RXBYTES field is zero */
 	if (!count && (req->req.length == UDC_DMA_MAXPACKET))
 		count = UDC_DMA_MAXPACKET;
 	req->td_data->status |= PCH_UDC_DMA_LAST;
-	req->td_data_last->status |= PCH_UDC_BS_HST_BSY;
+	td->status |= PCH_UDC_BS_HST_BSY;
 
 	req->dma_going = 0;
 	req->req.actual = count;
-- 
1.6.2.5
