Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965113Ab1C3V0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:26:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:43902 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965068Ab1C3VJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411278643"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: sarah.a.sharp@linux.intel.com, tiwai@suse.de, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [201/275] xhci: Fix cycle bit calculation during stall handling.
Message-Id: <20110330210725.58EE43E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 01a1fdb9a7afa5e3c14c9316d6f380732750b4e4 upstream.

When an endpoint stalls, we need to update the xHCI host's internal
dequeue pointer to move it past the stalled transfer.  This includes
updating the cycle bit (TRB ownership bit) if we have moved the dequeue
pointer past a link TRB with the toggle cycle bit set.

When we're trying to find the new dequeue segment, find_trb_seg() is
supposed to keep track of whether we've passed any link TRBs with the
toggle cycle bit set.  However, this while loop's body

	while (cur_seg->trbs > trb ||
			&cur_seg->trbs[TRBS_PER_SEGMENT - 1] < trb) {

Will never get executed if the ring only contains one segment.
find_trb_seg() will return immediately, without updating the new cycle
bit.  Since find_trb_seg() has no idea where in the segment the TD that
stalled was, make the caller, xhci_find_new_dequeue_state(), check for
this special case and update the cycle bit accordingly.

This patch should be queued to kernels all the way back to 2.6.31.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Tested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/host/xhci-ring.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: linux-2.6.35.y/drivers/usb/host/xhci-ring.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/host/xhci-ring.c	2011-03-29 23:03:01.523261194 -0700
+++ linux-2.6.35.y/drivers/usb/host/xhci-ring.c	2011-03-29 23:53:39.667522684 -0700
@@ -483,6 +483,20 @@
 		state->new_cycle_state = ~(state->new_cycle_state) & 0x1;
 	next_trb(xhci, ep_ring, &state->new_deq_seg, &state->new_deq_ptr);
 
+	/*
+	 * If there is only one segment in a ring, find_trb_seg()'s while loop
+	 * will not run, and it will return before it has a chance to see if it
+	 * needs to toggle the cycle bit.  It can't tell if the stalled transfer
+	 * ended just before the link TRB on a one-segment ring, or if the TD
+	 * wrapped around the top of the ring, because it doesn't have the TD in
+	 * question.  Look for the one-segment case where stalled TRB's address
+	 * is greater than the new dequeue pointer address.
+	 */
+	if (ep_ring->first_seg == ep_ring->first_seg->next &&
+			state->new_deq_ptr < dev->eps[ep_index].stopped_trb)
+		state->new_cycle_state ^= 0x1;
+	xhci_dbg(xhci, "Cycle state = 0x%x\n", state->new_cycle_state);
+
 	/* Don't update the ring cycle state for the producer (us). */
 	xhci_dbg(xhci, "New dequeue segment = %p (virtual)\n",
 			state->new_deq_seg);
