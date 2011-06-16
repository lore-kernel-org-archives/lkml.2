Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab1FPHK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:10:59 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:37247 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756885Ab1FPHKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:10:49 -0400
X-Sasl-enc: pmuVmuP88VW9NvmhevfnFZRwwF7vAArLxD7GFBJYzb5+ 1308208248
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:07 2011
Message-Id: <20110616002907.219011528@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:28:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Dmitry Torokhov <dtor@vmware.com>
Subject: [34/85] xhci: Fix full speed bInterval encoding.
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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

---
 drivers/usb/host/xhci-mem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -564,12 +564,12 @@ static inline unsigned int xhci_get_endp
 		break;
 
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


