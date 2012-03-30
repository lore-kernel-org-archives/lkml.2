Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965580Ab2C3VR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:17:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965536Ab2C3VRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:17:51 -0400
Message-Id: <20120330194829.151895709@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:48:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ido Shayevitz <idos@codeaurora.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 023/175] usb: gadget: Clear usb_endpoint_descriptor inside the struct usb_ep on disable
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Shayevitz <idos@codeaurora.org>

commit f9c56cdd3905c96c600456203637bd7ec8ec6383 upstream.

This fix a bug in f_serial, which expect the ep->desc to be NULL after
disabling an endpoint.

Signed-off-by: Ido Shayevitz <idos@codeaurora.org>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/gadget.c           |    1 +
 drivers/usb/gadget/amd5536udc.c     |    1 +
 drivers/usb/gadget/at91_udc.c       |    1 +
 drivers/usb/gadget/atmel_usba_udc.c |    1 +
 drivers/usb/gadget/ci13xxx_udc.c    |    1 +
 drivers/usb/gadget/fsl_qe_udc.c     |    1 +
 drivers/usb/gadget/fsl_udc_core.c   |    1 +
 drivers/usb/gadget/goku_udc.c       |    1 +
 drivers/usb/gadget/langwell_udc.c   |    1 +
 drivers/usb/gadget/mv_udc_core.c    |    1 +
 drivers/usb/gadget/omap_udc.c       |    1 +
 drivers/usb/gadget/pch_udc.c        |    1 +
 drivers/usb/gadget/pxa25x_udc.c     |    2 ++
 drivers/usb/gadget/s3c-hsudc.c      |    2 ++
 drivers/usb/gadget/s3c2410_udc.c    |    2 ++
 15 files changed, 18 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -440,6 +440,7 @@ static int __dwc3_gadget_ep_disable(stru
 
 	dep->stream_capable = false;
 	dep->desc = NULL;
+	dep->endpoint.desc = NULL;
 	dep->comp_desc = NULL;
 	dep->type = 0;
 	dep->flags = 0;
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -445,6 +445,7 @@ static void ep_init(struct udc_regs __io
 
 	VDBG(ep->dev, "ep-%d reset\n", ep->num);
 	ep->desc = NULL;
+	ep->ep.desc = NULL;
 	ep->ep.ops = &udc_ep_ops;
 	INIT_LIST_HEAD(&ep->queue);
 
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -558,6 +558,7 @@ static int at91_ep_disable (struct usb_e
 
 	/* restore the endpoint's pristine config */
 	ep->desc = NULL;
+	ep->ep.desc = NULL;
 	ep->ep.maxpacket = ep->maxpacket;
 
 	/* reset fifos and endpoint */
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -659,6 +659,7 @@ static int usba_ep_disable(struct usb_ep
 		return -EINVAL;
 	}
 	ep->desc = NULL;
+	ep->ep.desc = NULL;
 
 	list_splice_init(&ep->queue, &req_list);
 	if (ep->can_dma) {
--- a/drivers/usb/gadget/ci13xxx_udc.c
+++ b/drivers/usb/gadget/ci13xxx_udc.c
@@ -2181,6 +2181,7 @@ static int ep_disable(struct usb_ep *ep)
 	} while (mEp->dir != direction);
 
 	mEp->desc = NULL;
+	mEp->ep.desc = NULL;
 
 	spin_unlock_irqrestore(mEp->lock, flags);
 	return retval;
--- a/drivers/usb/gadget/fsl_qe_udc.c
+++ b/drivers/usb/gadget/fsl_qe_udc.c
@@ -1638,6 +1638,7 @@ static int qe_ep_disable(struct usb_ep *
 	/* Nuke all pending requests (does flush) */
 	nuke(ep, -ESHUTDOWN);
 	ep->desc = NULL;
+	ep->ep.desc = NULL;
 	ep->stopped = 1;
 	ep->tx_req = NULL;
 	qe_ep_reset(udc, ep->epnum);
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -659,6 +659,7 @@ static int fsl_ep_disable(struct usb_ep
 	nuke(ep, -ESHUTDOWN);
 
 	ep->desc = NULL;
+	ep->ep.desc = NULL;
 	ep->stopped = 1;
 	spin_unlock_irqrestore(&udc->lock, flags);
 
--- a/drivers/usb/gadget/goku_udc.c
+++ b/drivers/usb/gadget/goku_udc.c
@@ -235,6 +235,7 @@ static void ep_reset(struct goku_udc_reg
 
 	ep->ep.maxpacket = MAX_FIFO_SIZE;
 	ep->desc = NULL;
+	ep->ep.desc = NULL;
 	ep->stopped = 1;
 	ep->irqs = 0;
 	ep->dma = 0;
--- a/drivers/usb/gadget/langwell_udc.c
+++ b/drivers/usb/gadget/langwell_udc.c
@@ -487,6 +487,7 @@ static int langwell_ep_disable(struct us
 	nuke(ep, -ESHUTDOWN);
 
 	ep->desc = NULL;
+	ep->ep.desc = NULL;
 	ep->stopped = 1;
 
 	spin_unlock_irqrestore(&dev->lock, flags);
--- a/drivers/usb/gadget/mv_udc_core.c
+++ b/drivers/usb/gadget/mv_udc_core.c
@@ -608,6 +608,7 @@ static int  mv_ep_disable(struct usb_ep
 	nuke(ep, -ESHUTDOWN);
 
 	ep->desc = NULL;
+	ep->ep.desc = NULL;
 	ep->stopped = 1;
 
 	spin_unlock_irqrestore(&udc->lock, flags);
--- a/drivers/usb/gadget/omap_udc.c
+++ b/drivers/usb/gadget/omap_udc.c
@@ -251,6 +251,7 @@ static int omap_ep_disable(struct usb_ep
 
 	spin_lock_irqsave(&ep->udc->lock, flags);
 	ep->desc = NULL;
+	ep->ep.desc = NULL;
 	nuke (ep, -ESHUTDOWN);
 	ep->ep.maxpacket = ep->maxpacket;
 	ep->has_dma = 0;
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -1493,6 +1493,7 @@ static int pch_udc_pcd_ep_disable(struct
 	pch_udc_ep_disable(ep);
 	pch_udc_disable_ep_interrupts(ep->dev, PCH_UDC_EPINT(ep->in, ep->num));
 	ep->desc = NULL;
+	ep->ep.desc = NULL;
 	INIT_LIST_HEAD(&ep->queue);
 	spin_unlock_irqrestore(&ep->dev->lock, iflags);
 	return 0;
--- a/drivers/usb/gadget/pxa25x_udc.c
+++ b/drivers/usb/gadget/pxa25x_udc.c
@@ -283,6 +283,7 @@ static int pxa25x_ep_disable (struct usb
 	pxa25x_ep_fifo_flush (_ep);
 
 	ep->desc = NULL;
+	ep->ep.desc = NULL;
 	ep->stopped = 1;
 
 	local_irq_restore(flags);
@@ -1192,6 +1193,7 @@ static void udc_reinit(struct pxa25x_udc
 			list_add_tail (&ep->ep.ep_list, &dev->gadget.ep_list);
 
 		ep->desc = NULL;
+		ep->ep.desc = NULL;
 		ep->stopped = 0;
 		INIT_LIST_HEAD (&ep->queue);
 		ep->pio_irqs = 0;
--- a/drivers/usb/gadget/s3c-hsudc.c
+++ b/drivers/usb/gadget/s3c-hsudc.c
@@ -816,6 +816,7 @@ static int s3c_hsudc_ep_disable(struct u
 	s3c_hsudc_nuke_ep(hsep, -ESHUTDOWN);
 
 	hsep->desc = 0;
+	hsep->ep.desc = NULL;
 	hsep->stopped = 1;
 
 	spin_unlock_irqrestore(&hsudc->lock, flags);
@@ -1005,6 +1006,7 @@ static void s3c_hsudc_initep(struct s3c_
 	hsep->ep.ops = &s3c_hsudc_ep_ops;
 	hsep->fifo = hsudc->regs + S3C_BR(epnum);
 	hsep->desc = 0;
+	hsep->ep.desc = NULL;
 	hsep->stopped = 0;
 	hsep->wedge = 0;
 
--- a/drivers/usb/gadget/s3c2410_udc.c
+++ b/drivers/usb/gadget/s3c2410_udc.c
@@ -1148,6 +1148,7 @@ static int s3c2410_udc_ep_disable(struct
 	dprintk(DEBUG_NORMAL, "ep_disable: %s\n", _ep->name);
 
 	ep->desc = NULL;
+	ep->ep.desc = NULL;
 	ep->halted = 1;
 
 	s3c2410_udc_nuke (ep->dev, ep, -ESHUTDOWN);
@@ -1630,6 +1631,7 @@ static void s3c2410_udc_reinit(struct s3
 
 		ep->dev = dev;
 		ep->desc = NULL;
+		ep->ep.desc = NULL;
 		ep->halted = 0;
 		INIT_LIST_HEAD (&ep->queue);
 	}


