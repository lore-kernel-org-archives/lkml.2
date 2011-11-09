Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142Ab1KJEJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:09:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44630 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936068Ab1KJDo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:44:27 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:00 2011
Message-Id: <20111109213200.026791362@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:33:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andiry Xu <andiry.xu@amd.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [177/264] xHCI: Clear PLC for USB2 root hub ports
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andiry Xu <andiry.xu@amd.com>

commit 6fd4562178508a0949c9fdecd8558d8b10d671bd upstream.

When the link state changes, xHC will report a port status change event
and set the PORT_PLC bit, for both USB3 and USB2 root hub ports.

The PLC will be cleared by usbcore for USB3 root hub ports, but not for
USB2 ports, because they do not report USB_PORT_STAT_C_LINK_STATE in
wPortChange.

Clear it for USB2 root hub ports in handle_port_status().

Signed-off-by: Andiry Xu <andiry.xu@amd.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-ring.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1356,6 +1356,10 @@ static void handle_port_status(struct xh
 		}
 	}
 
+	if (hcd->speed != HCD_USB3)
+		xhci_test_and_clear_bit(xhci, port_array, faked_port_index,
+					PORT_PLC);
+
 cleanup:
 	/* Update event ring dequeue pointer before dropping the lock */
 	inc_deq(xhci, xhci->event_ring, true);


