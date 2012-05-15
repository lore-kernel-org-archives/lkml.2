Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965364Ab2EOCRu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:17:50 -0400
Received: from mail.windriver.com ([147.11.1.11]:49158 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964888Ab2EOCQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:25 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 031/179] xhci: Fix full speed bInterval encoding.
Date: Mon, 14 May 2012 22:12:07 -0400
Message-ID: <1337048075-6132-32-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/host/xhci-mem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 54a538d..05b5c34 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -608,12 +608,12 @@ static inline unsigned int xhci_get_endpoint_interval(struct usb_device *udev,
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
-- 
1.7.9.6

