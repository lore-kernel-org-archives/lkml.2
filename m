Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab1I1Wh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:37:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53478 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755354Ab1I1Whz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:37:55 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:28 2011
Message-Id: <20110928220127.971419646@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 14:59:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Andiry Xu <andiry.xu@amd.com>
Subject: [026/244] xhci: Remove TDs from TD lists when URBs are canceled.
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 585df1d90cb07a02ca6c7a7d339e56e46d50dafb upstream.

When a driver tries to cancel an URB, and the host controller is dying,
xhci_urb_dequeue will giveback the URB without removing the xhci_tds
that comprise that URB from the td_list or the cancelled_td_list.  This
can cause a race condition between the driver calling URB dequeue and
the stop endpoint command watchdog timer.

If the timer fires on a dying host, and a driver attempts to resubmit
while the watchdog timer has dropped the xhci->lock to giveback a
cancelled URB, URBs may be given back by the xhci_urb_dequeue() function.
At that point, the URB's priv pointer will be freed and set to NULL, but
the TDs will remain on the td_list.  This will cause an oops in
xhci_giveback_urb_in_irq() when the watchdog timer attempts to loop
through the endpoints' td_lists, giving back killed URBs.

Make sure that xhci_urb_dequeue() removes TDs from the TD lists and
canceled TD lists before it gives back the URB.

This patch should be backported to kernels as old as 2.6.36.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Andiry Xu <andiry.xu@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-ring.c |   16 ++++++++--------
 drivers/usb/host/xhci.c      |    7 +++++++
 2 files changed, 15 insertions(+), 8 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -744,7 +744,7 @@ remove_finished_td:
 		 * so remove it from the endpoint ring's TD list.  Keep it in
 		 * the cancelled TD list for URB completion later.
 		 */
-		list_del(&cur_td->td_list);
+		list_del_init(&cur_td->td_list);
 	}
 	last_unlinked_td = cur_td;
 	xhci_stop_watchdog_timer_in_irq(xhci, ep);
@@ -772,7 +772,7 @@ remove_finished_td:
 	do {
 		cur_td = list_entry(ep->cancelled_td_list.next,
 				struct xhci_td, cancelled_td_list);
-		list_del(&cur_td->cancelled_td_list);
+		list_del_init(&cur_td->cancelled_td_list);
 
 		/* Clean up the cancelled URB */
 		/* Doesn't matter what we pass for status, since the core will
@@ -880,9 +880,9 @@ void xhci_stop_endpoint_command_watchdog
 				cur_td = list_first_entry(&ring->td_list,
 						struct xhci_td,
 						td_list);
-				list_del(&cur_td->td_list);
+				list_del_init(&cur_td->td_list);
 				if (!list_empty(&cur_td->cancelled_td_list))
-					list_del(&cur_td->cancelled_td_list);
+					list_del_init(&cur_td->cancelled_td_list);
 				xhci_giveback_urb_in_irq(xhci, cur_td,
 						-ESHUTDOWN, "killed");
 			}
@@ -891,7 +891,7 @@ void xhci_stop_endpoint_command_watchdog
 						&temp_ep->cancelled_td_list,
 						struct xhci_td,
 						cancelled_td_list);
-				list_del(&cur_td->cancelled_td_list);
+				list_del_init(&cur_td->cancelled_td_list);
 				xhci_giveback_urb_in_irq(xhci, cur_td,
 						-ESHUTDOWN, "killed");
 			}
@@ -1582,10 +1582,10 @@ td_cleanup:
 			else
 				*status = 0;
 		}
-		list_del(&td->td_list);
+		list_del_init(&td->td_list);
 		/* Was this TD slated to be cancelled but completed anyway? */
 		if (!list_empty(&td->cancelled_td_list))
-			list_del(&td->cancelled_td_list);
+			list_del_init(&td->cancelled_td_list);
 
 		urb_priv->td_cnt++;
 		/* Giveback the urb when all the tds are completed */
@@ -3370,7 +3370,7 @@ cleanup:
 	/* Clean up a partially enqueued isoc transfer. */
 
 	for (i--; i >= 0; i--)
-		list_del(&urb_priv->td[i]->td_list);
+		list_del_init(&urb_priv->td[i]->td_list);
 
 	/* Use the first TD as a temporary variable to turn the TDs we've queued
 	 * into No-ops with a software-owned cycle bit. That way the hardware
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1252,6 +1252,13 @@ int xhci_urb_dequeue(struct usb_hcd *hcd
 	if (temp == 0xffffffff || (xhci->xhc_state & XHCI_STATE_HALTED)) {
 		xhci_dbg(xhci, "HW died, freeing TD.\n");
 		urb_priv = urb->hcpriv;
+		for (i = urb_priv->td_cnt; i < urb_priv->length; i++) {
+			td = urb_priv->td[i];
+			if (!list_empty(&td->td_list))
+				list_del_init(&td->td_list);
+			if (!list_empty(&td->cancelled_td_list))
+				list_del_init(&td->cancelled_td_list);
+		}
 
 		usb_hcd_unlink_urb_from_ep(hcd, urb);
 		spin_unlock_irqrestore(&xhci->lock, flags);


