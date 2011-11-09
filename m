Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935077Ab1KJD3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:29:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934695Ab1KJD3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:29:14 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:17 2011
Message-Id: <20111109212717.771997052@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andiry Xu <andiry.xu@amd.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [171/262] USB: xHCI: prevent infinite loop when processing MSE event
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andiry Xu <andiry.xu@amd.com>

commit c2d7b49f42f50d7fc5cbfd195b785a128723fdf4 upstream.

When a xHC host is unable to handle isochronous transfer in the
interval, it reports a Missed Service Error event and skips some tds.

Currently xhci driver handles MSE event in the following ways:

1. When encounter a MSE event, set ep->skip flag, update event ring
   dequeue pointer and return.

2. When encounter the next event on this ep, the driver will run the
   do-while loop, fetch td from ep's td_list to find the td
   corresponding to this event.  All tds missed are marked as short
   transfer(-EXDEV).

The do-while loop will end in two ways:

1. If the td pointed by the event trb is found;

2. If the ep ring's td_list is empty.

However, if a buggy HW reports some unpredicted event (for example, an
overrun event following a MSE event while the ep ring is actually not
empty), the driver will never find the td, and it will loop until the
td_list is empty.

Unfortunately, the spinlock is dropped when give back a urb in the
do-while loop.  During the spinlock released period, the class driver
may still submit urbs and add tds to the td_list.  This may cause
disaster, since the td_list will never be empty and the loop never ends,
and the system hangs.

To fix this, count the number of TDs on the ep ring before skipping TDs,
and quit the loop when skipped that number of tds.  This guarantees the
do-while loop will end after certain number of cycles, and driver will
not be trapped in an infinite loop.

Signed-off-by: Andiry Xu <andiry.xu@amd.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

---
 drivers/usb/host/xhci-ring.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1942,8 +1942,10 @@ static int handle_tx_event(struct xhci_h
 	int status = -EINPROGRESS;
 	struct urb_priv *urb_priv;
 	struct xhci_ep_ctx *ep_ctx;
+	struct list_head *tmp;
 	u32 trb_comp_code;
 	int ret = 0;
+	int td_num = 0;
 
 	slot_id = TRB_TO_SLOT_ID(le32_to_cpu(event->flags));
 	xdev = xhci->devs[slot_id];
@@ -1965,6 +1967,12 @@ static int handle_tx_event(struct xhci_h
 		return -ENODEV;
 	}
 
+	/* Count current td numbers if ep->skip is set */
+	if (ep->skip) {
+		list_for_each(tmp, &ep_ring->td_list)
+			td_num++;
+	}
+
 	event_dma = le64_to_cpu(event->buffer);
 	trb_comp_code = GET_COMP_CODE(le32_to_cpu(event->transfer_len));
 	/* Look for common error cases */
@@ -2076,7 +2084,18 @@ static int handle_tx_event(struct xhci_h
 			goto cleanup;
 		}
 
+		/* We've skipped all the TDs on the ep ring when ep->skip set */
+		if (ep->skip && td_num == 0) {
+			ep->skip = false;
+			xhci_dbg(xhci, "All tds on the ep_ring skipped. "
+						"Clear skip flag.\n");
+			ret = 0;
+			goto cleanup;
+		}
+
 		td = list_entry(ep_ring->td_list.next, struct xhci_td, td_list);
+		if (ep->skip)
+			td_num--;
 
 		/* Is this a TRB in the currently executing TD? */
 		event_seg = trb_in_td(ep_ring->deq_seg, ep_ring->dequeue,


