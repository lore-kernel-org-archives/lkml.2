Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab1G0WIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:08:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:26124 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755421Ab1G0VsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="33043527"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: sarah.a.sharp@linux.intel.com, dtor@vmware.com, thomas.lindroth@gmail.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [19/99] xhci: Fix full speed bInterval encoding.
Message-Id: <20110727214817.A4DC22403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit b513d44751bfb609a3c20463f764c8ce822d63e9 upstream.

Dmitry's patch

dfa49c4ad120a784ef1ff0717168aa79f55a483a USB: xhci - fix math in xhci_get_endpoint_interval()

introduced a bug.  The USB 2.0 spec says that full speed isochronous endpoints'
bInterval must be decoded as an exponent to a power of two (e.g. interval =
2^(bInterval - 1)).  Full speed interrupt endpoints, on the other hand, don't
use exponents, and the interval in frames is encoded straight into bInterval.

Dmitry's patch was supposed to fix up the full speed isochronous to parse
bInterval as an exponent, but instead it changed the *interrupt* endpoint
bInterval decoding.  The isochronous endpoint encoding was the same.

This caused full speed devices with interrupt endpoints (including mice, hubs,
and USB to ethernet devices) to fail under NEC 0.96 xHCI host controllers:

[  100.909818] xhci_hcd 0000:06:00.0: add ep 0x83, slot id 1, new drop flags = 0x0, new add flags = 0x99, new slot info = 0x38100000
[  100.909821] xhci_hcd 0000:06:00.0: xhci_check_bandwidth called for udev ffff88011f0ea000
...
[  100.910187] xhci_hcd 0000:06:00.0: ERROR: unexpected command completion code 0x11.
[  100.910190] xhci_hcd 0000:06:00.0: xhci_reset_bandwidth called for udev ffff88011f0ea000

When the interrupt endpoint was added and a Configure Endpoint command was
issued to the host, the host controller would return a very odd error message
(0x11 means "Slot Not Enabled", which isn't true because the slot was enabled).
Probably the host controller was getting very confused with the bad encoding.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Dmitry Torokhov <dtor@vmware.com>
Reported-by: Thomas Lindroth <thomas.lindroth@gmail.com>
Tested-by: Thomas Lindroth <thomas.lindroth@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/host/xhci-mem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/usb/host/xhci-mem.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/host/xhci-mem.c
+++ linux-2.6.35.y/drivers/usb/host/xhci-mem.c
@@ -1034,12 +1034,12 @@ static inline unsigned int xhci_get_endp
 	 * nearest power of 2.
 	 */
 	case USB_SPEED_FULL:
-		if (usb_endpoint_xfer_int(&ep->desc)) {
+		if (usb_endpoint_xfer_isoc(&ep->desc)) {
 			interval = xhci_parse_exponent_interval(udev, ep);
 			break;
 		}
 		/*
-		 * Fall through for isochronous endpoint interval decoding
+		 * Fall through for interrupt endpoint interval decoding
 		 * since it uses the same rules as low speed interrupt
 		 * endpoints.
 		 */
