Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878Ab0G3R6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:58:10 -0400
Received: from kroah.org ([198.145.64.141]:58882 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760067Ab0G3R4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:56:55 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:46 2010
Message-Id: <20100730175146.604637917@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [139/205] USB: xhci: Set Mult field in endpoint context correctly.
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit c30c791c946a14a03e87819eced562ed28711961 upstream.

The bmAttributes field of the SuperSpeed Endpoint Companion Descriptor has
different meanings, depending on the endpoint type.  If the endpoint is
isochronous, the bmAttributes field is the maximum number of packets
within a service interval that this endpoint supports.  If the endpoint is
bulk, it's the number of stream IDs this endpoint supports.

Only set the Mult field of the xHCI endpoint context using the
bmAttributes field if the endpoint is isochronous, and the device is a
SuperSpeed device.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-mem.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -582,7 +582,7 @@ static inline unsigned int xhci_get_endp
 	return EP_INTERVAL(interval);
 }
 
-/* The "Mult" field in the endpoint context is only set for SuperSpeed devices.
+/* The "Mult" field in the endpoint context is only set for SuperSpeed isoc eps.
  * High speed endpoint descriptors can define "the number of additional
  * transaction opportunities per microframe", but that goes in the Max Burst
  * endpoint context field.
@@ -590,7 +590,8 @@ static inline unsigned int xhci_get_endp
 static inline u32 xhci_get_endpoint_mult(struct usb_device *udev,
 		struct usb_host_endpoint *ep)
 {
-	if (udev->speed != USB_SPEED_SUPER || !ep->ss_ep_comp)
+	if (udev->speed != USB_SPEED_SUPER || !ep->ss_ep_comp ||
+			!usb_endpoint_xfer_isoc(&ep->desc))
 		return 0;
 	return ep->ss_ep_comp->desc.bmAttributes;
 }


