Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705Ab0LHBXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:23:44 -0500
Received: from kroah.org ([198.145.64.141]:33531 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932554Ab0LHBCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:02:49 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:40 2010
Message-Id: <20101208005740.766708010@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andiry Xu <andiry.xu@amd.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [193/289] xHCI: fix wMaxPacketSize mask
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/usb/host/xhci-mem.c |    4 ++--
 drivers/usb/host/xhci.h     |    5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1043,7 +1043,7 @@ static inline u32 xhci_get_max_esit_payl
 	if (udev->speed == USB_SPEED_SUPER)
 		return ep->ss_ep_comp.wBytesPerInterval;
 
-	max_packet = ep->desc.wMaxPacketSize & 0x3ff;
+	max_packet = GET_MAX_PACKET(ep->desc.wMaxPacketSize);
 	max_burst = (ep->desc.wMaxPacketSize & 0x1800) >> 11;
 	/* A 0 in max burst means 1 transfer per ESIT */
 	return max_packet * (max_burst + 1);
@@ -1133,7 +1133,7 @@ int xhci_endpoint_init(struct xhci_hcd *
 		/* Fall through */
 	case USB_SPEED_FULL:
 	case USB_SPEED_LOW:
-		max_packet = ep->desc.wMaxPacketSize & 0x3ff;
+		max_packet = GET_MAX_PACKET(ep->desc.wMaxPacketSize);
 		ep_ctx->ep_info2 |= MAX_PACKET(max_packet);
 		break;
 	default:
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
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


