Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab0LLXra (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:47:30 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36401 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab0LLXr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:26 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: andiry.xu@amd.com, sarah.a.sharp@linux.intel.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [142/223] xHCI: fix wMaxPacketSize mask
Message-Id: <20101212234724.DC4F7B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:24 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Andiry Xu <andiry.xu@amd.com>

commit dc07c91b9b4067022210e68d914a6890a4d70622 upstream.

USB2.0 spec 9.6.6 says: For all endpoints, bit 10..0 specify the maximum
packet size(in bytes).

So the wMaxPacketSize mask should be 0x7ff rather than 0x3ff.

This patch should be queued for the stable tree.  The bug in
xhci_endpoint_init() was present as far back as 2.6.31, and the bug in
xhci_get_max_esit_payload() was present when the function was introduced
in 2.6.34.

Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: Andiry Xu <andiry.xu@amd.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/host/xhci-mem.c |    4 ++--
 drivers/usb/host/xhci.h     |    5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

Index: linux/drivers/usb/host/xhci-mem.c
===================================================================
--- linux.orig/drivers/usb/host/xhci-mem.c
+++ linux/drivers/usb/host/xhci-mem.c
@@ -1086,7 +1086,7 @@ static inline u32 xhci_get_max_esit_payl
 	if (udev->speed == USB_SPEED_SUPER)
 		return ep->ss_ep_comp.wBytesPerInterval;
 
-	max_packet = ep->desc.wMaxPacketSize & 0x3ff;
+	max_packet = GET_MAX_PACKET(ep->desc.wMaxPacketSize);
 	max_burst = (ep->desc.wMaxPacketSize & 0x1800) >> 11;
 	/* A 0 in max burst means 1 transfer per ESIT */
 	return max_packet * (max_burst + 1);
@@ -1165,7 +1165,7 @@ int xhci_endpoint_init(struct xhci_hcd *
 		/* Fall through */
 	case USB_SPEED_FULL:
 	case USB_SPEED_LOW:
-		max_packet = ep->desc.wMaxPacketSize & 0x3ff;
+		max_packet = GET_MAX_PACKET(ep->desc.wMaxPacketSize);
 		ep_ctx->ep_info2 |= MAX_PACKET(max_packet);
 		break;
 	default:
Index: linux/drivers/usb/host/xhci.h
===================================================================
--- linux.orig/drivers/usb/host/xhci.h
+++ linux/drivers/usb/host/xhci.h
@@ -614,6 +614,11 @@ struct xhci_ep_ctx {
 #define MAX_PACKET_MASK		(0xffff << 16)
 #define MAX_PACKET_DECODED(p)	(((p) >> 16) & 0xffff)
 
+/* Get max packet size from ep desc. Bit 10..0 specify the max packet size.
+ * USB2.0 spec 9.6.6.
+ */
+#define GET_MAX_PACKET(p)	((p) & 0x7ff)
+
 /* tx_info bitmasks */
 #define AVG_TRB_LENGTH_FOR_EP(p)	((p) & 0xffff)
 #define MAX_ESIT_PAYLOAD_FOR_EP(p)	(((p) & 0xffff) << 16)
