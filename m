Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417Ab0EJXmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:42:06 -0400
Received: from kroah.org ([198.145.64.141]:32986 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320Ab0EJWv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:51:58 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:19 2010
Message-Id: <20100510223319.815178996@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:32:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [029/117] USB: xhci: properly set the "Mult" field of the endpoint context.
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 1cf62246c0e394021e494e0a8f1013e80db1a1a9 upstream.

A SuperSpeed interrupt or isochronous endpoint can define the number of
"burst transactions" it can handle in a service interval.  This is
indicated by the "Mult" bits in the bmAttributes of the SuperSpeed
Endpoint Companion Descriptor.  For example, if it has a max packet size
of 1024, a max burst of 11, and a mult of 3, the host may send 33
1024-byte packets in one service interval.

We must tell the xHCI host controller the number of multiple service
opportunities (mults) the device can handle when the endpoint is
installed.  We do that by setting the Mult field of the Endpoint Context
before a configure endpoint command is sent down.  The Mult field is
invalid for control or bulk SuperSpeed endpoints.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-mem.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -549,6 +549,19 @@ static inline unsigned int xhci_get_endp
 	return EP_INTERVAL(interval);
 }
 
+/* The "Mult" field in the endpoint context is only set for SuperSpeed devices.
+ * High speed endpoint descriptors can define "the number of additional
+ * transaction opportunities per microframe", but that goes in the Max Burst
+ * endpoint context field.
+ */
+static inline u32 xhci_get_endpoint_mult(struct usb_device *udev,
+		struct usb_host_endpoint *ep)
+{
+	if (udev->speed != USB_SPEED_SUPER || !ep->ss_ep_comp)
+		return 0;
+	return ep->ss_ep_comp->desc.bmAttributes;
+}
+
 static inline u32 xhci_get_endpoint_type(struct usb_device *udev,
 		struct usb_host_endpoint *ep)
 {
@@ -611,6 +624,7 @@ int xhci_endpoint_init(struct xhci_hcd *
 	ep_ctx->deq = ep_ring->first_seg->dma | ep_ring->cycle_state;
 
 	ep_ctx->ep_info = xhci_get_endpoint_interval(udev, ep);
+	ep_ctx->ep_info |= EP_MULT(xhci_get_endpoint_mult(udev, ep));
 
 	/* FIXME dig Mult and streams info out of ep companion desc */
 


