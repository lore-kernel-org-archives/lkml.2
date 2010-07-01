Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489Ab0GAVzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:55:49 -0400
Received: from kroah.org ([198.145.64.141]:60777 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758910Ab0GAVNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:25 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:50 2010
Message-Id: <20100701174250.740034372@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:42:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [051/200] USB: xhci: Fix issue with set interface after stall.
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 1624ae1c19e227096ba85bfc389d9b99cb6f7dde upstream.

When the USB core installs a new interface, it unconditionally clears the
halts on all the endpoints on the new interface.  Usually the xHCI host
needs to know when an endpoint is reset, so it can change its internal
endpoint state.  In this case, it doesn't care, because the endpoints were
never halted in the first place.

To avoid issuing a redundant Reset Endpoint command, the xHCI driver looks
at xhci_virt_ep->stopped_td to determine if the endpoint was actually
halted.  However, the functions that handle the stall never set that
variable to NULL after it dealt with the stall.  So if an endpoint stalled
and a Reset Endpoint command completed, and then the class driver tried to
install a new alternate setting, the xHCI driver would access the old
xhci_virt_ep->stopped_td pointer.  A similar problem occurs if the
endpoint has been stopped to cancel a transfer.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-ring.c |    7 +++++++
 drivers/usb/host/xhci.c      |    2 ++
 2 files changed, 9 insertions(+)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -578,6 +578,8 @@ static void handle_stopped_endpoint(stru
 		/* Otherwise just ring the doorbell to restart the ring */
 		ring_ep_doorbell(xhci, slot_id, ep_index);
 	}
+	ep->stopped_td = NULL;
+	ep->stopped_trb = NULL;
 
 	/*
 	 * Drop the lock and complete the URBs in the cancelled TD list.
@@ -1061,8 +1063,13 @@ static void xhci_cleanup_halted_endpoint
 	ep->ep_state |= EP_HALTED;
 	ep->stopped_td = td;
 	ep->stopped_trb = event_trb;
+
 	xhci_queue_reset_ep(xhci, slot_id, ep_index);
 	xhci_cleanup_stalled_ring(xhci, td->urb->dev, ep_index);
+
+	ep->stopped_td = NULL;
+	ep->stopped_trb = NULL;
+
 	xhci_ring_cmd_db(xhci);
 }
 
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1438,6 +1438,8 @@ void xhci_endpoint_reset(struct usb_hcd
 		kfree(virt_ep->stopped_td);
 		xhci_ring_cmd_db(xhci);
 	}
+	virt_ep->stopped_td = NULL;
+	virt_ep->stopped_trb = NULL;
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
 	if (ret)


