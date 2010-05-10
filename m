Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933456Ab0EJXlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:41:18 -0400
Received: from kroah.org ([198.145.64.141]:32990 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932363Ab0EJWv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:51:59 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:19 2010
Message-Id: <20100510223319.906430914@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:32:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [030/117] USB: xhci: properly set endpoint context fields for periodic eps.
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 9238f25d5d32a435277eb234ec82bacdd5daed41 upstream.

For periodic endpoints, we must let the xHCI hardware know the maximum
payload an endpoint can transfer in one service interval.  The xHCI
specification refers to this as the Maximum Endpoint Service Interval Time
Payload (Max ESIT Payload).  This is used by the hardware for bandwidth
management and scheduling of packets.

For SuperSpeed endpoints, the maximum is calculated by multiplying the max
packet size by the number of bursts and the number of opportunities to
transfer within a service interval (the Mult field of the SuperSpeed
Endpoint companion descriptor).  Devices advertise this in the
wBytesPerInterval field of their SuperSpeed Endpoint Companion Descriptor.

For high speed devices, this is taken by multiplying the max packet size by the
"number of additional transaction opportunities per microframe" (the high
bits of the wMaxPacketSize field in the endpoint descriptor).

For FS/LS devices, this is just the max packet size.

The other thing we must set in the endpoint context is the Average TRB
Length.  This is supposed to be the average of the total bytes in the
transfer descriptor (TD), divided by the number of transfer request blocks
(TRBs) it takes to describe the TD.  This gives the host controller an
indication of whether the driver will be enqueuing a scatter gather list
with many entries comprised of small buffers, or one contiguous buffer.

It also takes into account the number of extra TRBs you need for every TD.
This includes No-op TRBs and Link TRBs used to link ring segments
together.  Some drivers may choose to chain an Event Data TRB on the end
of every TD, thus increasing the average number of TRBs per TD.  The Linux
xHCI driver does not use Event Data TRBs.

In theory, if there was an API to allow drivers to state what their
bandwidth requirements are, we could set this field accurately.  For now,
we set it to the same number as the Max ESIT payload.

The Average TRB Length should also be set for bulk and control endpoints,
but I have no idea how to guess what it should be.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-mem.c |   51 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/usb/host/xhci.h     |    4 +++
 2 files changed, 55 insertions(+)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -592,6 +592,36 @@ static inline u32 xhci_get_endpoint_type
 	return type;
 }
 
+/* Return the maximum endpoint service interval time (ESIT) payload.
+ * Basically, this is the maxpacket size, multiplied by the burst size
+ * and mult size.
+ */
+static inline u32 xhci_get_max_esit_payload(struct xhci_hcd *xhci,
+		struct usb_device *udev,
+		struct usb_host_endpoint *ep)
+{
+	int max_burst;
+	int max_packet;
+
+	/* Only applies for interrupt or isochronous endpoints */
+	if (usb_endpoint_xfer_control(&ep->desc) ||
+			usb_endpoint_xfer_bulk(&ep->desc))
+		return 0;
+
+	if (udev->speed == USB_SPEED_SUPER) {
+		if (ep->ss_ep_comp)
+			return ep->ss_ep_comp->desc.wBytesPerInterval;
+		xhci_warn(xhci, "WARN no SS endpoint companion descriptor.\n");
+		/* Assume no bursts, no multiple opportunities to send. */
+		return ep->desc.wMaxPacketSize;
+	}
+
+	max_packet = ep->desc.wMaxPacketSize & 0x3ff;
+	max_burst = (ep->desc.wMaxPacketSize & 0x1800) >> 11;
+	/* A 0 in max burst means 1 transfer per ESIT */
+	return max_packet * (max_burst + 1);
+}
+
 int xhci_endpoint_init(struct xhci_hcd *xhci,
 		struct xhci_virt_device *virt_dev,
 		struct usb_device *udev,
@@ -603,6 +633,7 @@ int xhci_endpoint_init(struct xhci_hcd *
 	struct xhci_ring *ep_ring;
 	unsigned int max_packet;
 	unsigned int max_burst;
+	u32 max_esit_payload;
 
 	ep_index = xhci_get_endpoint_index(&ep->desc);
 	ep_ctx = xhci_get_ep_ctx(xhci, virt_dev->in_ctx, ep_index);
@@ -670,6 +701,26 @@ int xhci_endpoint_init(struct xhci_hcd *
 	default:
 		BUG();
 	}
+	max_esit_payload = xhci_get_max_esit_payload(xhci, udev, ep);
+	ep_ctx->tx_info = MAX_ESIT_PAYLOAD_FOR_EP(max_esit_payload);
+
+	/*
+	 * XXX no idea how to calculate the average TRB buffer length for bulk
+	 * endpoints, as the driver gives us no clue how big each scatter gather
+	 * list entry (or buffer) is going to be.
+	 *
+	 * For isochronous and interrupt endpoints, we set it to the max
+	 * available, until we have new API in the USB core to allow drivers to
+	 * declare how much bandwidth they actually need.
+	 *
+	 * Normally, it would be calculated by taking the total of the buffer
+	 * lengths in the TD and then dividing by the number of TRBs in a TD,
+	 * including link TRBs, No-op TRBs, and Event data TRBs.  Since we don't
+	 * use Event Data TRBs, and we don't chain in a link TRB on short
+	 * transfers, we're basically dividing by 1.
+	 */
+	ep_ctx->tx_info |= AVG_TRB_LENGTH_FOR_EP(max_esit_payload);
+
 	/* FIXME Debug endpoint context */
 	return 0;
 }
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -609,6 +609,10 @@ struct xhci_ep_ctx {
 #define MAX_PACKET_MASK		(0xffff << 16)
 #define MAX_PACKET_DECODED(p)	(((p) >> 16) & 0xffff)
 
+/* tx_info bitmasks */
+#define AVG_TRB_LENGTH_FOR_EP(p)	((p) & 0xffff)
+#define MAX_ESIT_PAYLOAD_FOR_EP(p)	(((p) & 0xffff) << 16)
+
 
 /**
  * struct xhci_input_control_context


