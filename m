Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933697Ab1C3VOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:14:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:45379 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965272Ab1C3VKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:10:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411279293"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: sarah.a.sharp@linux.intel.com, tiwai@suse.de, ak@linux.intel.com,
        stable@kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [262/275] xhci: Update internal dequeue pointers after stalls.
Message-Id: <20110330210829.7C9113E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

[ upstream commit bf161e85fb153c0dd5a95faca73fd6a9d237c389 ]

When an endpoint stalls, the xHCI driver must move the endpoint ring's
dequeue pointer past the stalled transfer.  To do that, the driver issues
a Set TR Dequeue Pointer command, which will complete some time later.

Takashi was having issues with USB 1.1 audio devices that stalled, and his
analysis of the code was that the old code would not update the xHCI
driver's ring dequeue pointer after the command completes.  However, the
dequeue pointer is set in xhci_find_new_dequeue_state(), just before the
set command is issued to the hardware.

Setting the dequeue pointer before the Set TR Dequeue Pointer command
completes is a dangerous thing to do, since the xHCI hardware can fail the
command.  Instead, store the new dequeue pointer in the xhci_virt_ep
structure, and update the ring's dequeue pointer when the Set TR dequeue
pointer command completes.

While we're at it, make sure we can't queue another Set TR Dequeue Command
while the first one is still being processed.  This just won't work with
the internal xHCI state code.  I'm still not sure if this is the right
thing to do, since we might have a case where a driver queues multiple
URBs to a control ring, one of the URBs Stalls, and then the driver tries
to cancel the second URB.  There may be a race condition there where the
xHCI driver might try to issue multiple Set TR Dequeue Pointer commands,
but I would have to think very hard about how the Stop Endpoint and
cancellation code works.  Keep the fix simple until when/if we run into
that case.

This patch should be queued to kernels all the way back to 2.6.31.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Tested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: stable@kernel.org

---
 drivers/usb/host/xhci-ring.c |   29 ++++++++++++++++++++++++++---
 drivers/usb/host/xhci.h      |    9 +++++++++
 2 files changed, 35 insertions(+), 3 deletions(-)

Index: linux-2.6.35.y/drivers/usb/host/xhci-ring.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/host/xhci-ring.c	2011-03-29 23:03:02.000000000 -0700
+++ linux-2.6.35.y/drivers/usb/host/xhci-ring.c	2011-03-29 23:23:25.477943255 -0700
@@ -503,9 +503,6 @@
 	addr = xhci_trb_virt_to_dma(state->new_deq_seg, state->new_deq_ptr);
 	xhci_dbg(xhci, "New dequeue pointer = 0x%llx (DMA)\n",
 			(unsigned long long) addr);
-	xhci_dbg(xhci, "Setting dequeue pointer in internal ring state.\n");
-	ep_ring->dequeue = state->new_deq_ptr;
-	ep_ring->deq_seg = state->new_deq_seg;
 }
 
 static void td_to_noop(struct xhci_hcd *xhci, struct xhci_ring *ep_ring,
@@ -924,9 +921,26 @@
 	} else {
 		xhci_dbg(xhci, "Successful Set TR Deq Ptr cmd, deq = @%08llx\n",
 				ep_ctx->deq);
+		if (xhci_trb_virt_to_dma(dev->eps[ep_index].queued_deq_seg,
+					dev->eps[ep_index].queued_deq_ptr) ==
+				(ep_ctx->deq & ~(EP_CTX_CYCLE_MASK))) {
+			/* Update the ring's dequeue segment and dequeue pointer
+			 * to reflect the new position.
+			 */
+			ep_ring->deq_seg = dev->eps[ep_index].queued_deq_seg;
+			ep_ring->dequeue = dev->eps[ep_index].queued_deq_ptr;
+		} else {
+			xhci_warn(xhci, "Mismatch between completed Set TR Deq "
+					"Ptr command & xHCI internal state.\n");
+			xhci_warn(xhci, "ep deq seg = %p, deq ptr = %p\n",
+					dev->eps[ep_index].queued_deq_seg,
+					dev->eps[ep_index].queued_deq_ptr);
+		}
 	}
 
 	dev->eps[ep_index].ep_state &= ~SET_DEQ_PENDING;
+	dev->eps[ep_index].queued_deq_seg = NULL;
+	dev->eps[ep_index].queued_deq_ptr = NULL;
 	/* Restart any rings with pending URBs */
 	ring_doorbell_for_active_rings(xhci, slot_id, ep_index);
 }
@@ -2512,6 +2526,7 @@
 	u32 trb_ep_index = EP_ID_FOR_TRB(ep_index);
 	u32 trb_stream_id = STREAM_ID_FOR_TRB(stream_id);
 	u32 type = TRB_TYPE(TRB_SET_DEQ);
+	struct xhci_virt_ep *ep;
 
 	addr = xhci_trb_virt_to_dma(deq_seg, deq_ptr);
 	if (addr == 0) {
@@ -2520,6 +2535,14 @@
 				deq_seg, deq_ptr);
 		return 0;
 	}
+	ep = &xhci->devs[slot_id]->eps[ep_index];
+	if ((ep->ep_state & SET_DEQ_PENDING)) {
+		xhci_warn(xhci, "WARN Cannot submit Set TR Deq Ptr\n");
+		xhci_warn(xhci, "A Set TR Deq Ptr command is pending.\n");
+		return 0;
+	}
+	ep->queued_deq_seg = deq_seg;
+	ep->queued_deq_ptr = deq_ptr;
 	return queue_command(xhci, lower_32_bits(addr) | cycle_state,
 			upper_32_bits(addr), trb_stream_id,
 			trb_slot_id | trb_ep_index | type, false);
Index: linux-2.6.35.y/drivers/usb/host/xhci.h
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/host/xhci.h	2011-01-13 09:47:51.000000000 -0800
+++ linux-2.6.35.y/drivers/usb/host/xhci.h	2011-03-29 23:24:07.639864128 -0700
@@ -641,6 +641,9 @@
 #define AVG_TRB_LENGTH_FOR_EP(p)	((p) & 0xffff)
 #define MAX_ESIT_PAYLOAD_FOR_EP(p)	(((p) & 0xffff) << 16)
 
+/* deq bitmasks */
+#define EP_CTX_CYCLE_MASK		(1 << 0)
+
 
 /**
  * struct xhci_input_control_context
@@ -743,6 +746,12 @@
 	struct timer_list	stop_cmd_timer;
 	int			stop_cmds_pending;
 	struct xhci_hcd		*xhci;
+	/* Dequeue pointer and dequeue segment for a submitted Set TR Dequeue
+	 * command.  We'll need to update the ring's dequeue segment and dequeue
+	 * pointer after the command completes.
+	 */
+	struct xhci_segment	*queued_deq_seg;
+	union xhci_trb		*queued_deq_ptr;
 };
 
 struct xhci_virt_device {
