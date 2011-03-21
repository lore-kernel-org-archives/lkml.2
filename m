Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab1CUX7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:59:15 -0400
Received: from kroah.org ([198.145.64.141]:49016 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755009Ab1CUXNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:13:50 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:10:52 2011
Message-Id: <20110321231052.702711333@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:09:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [19/44] xhci: Fix cycle bit calculation during stall handling.
In-Reply-To: <20110321231105.GA1744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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

---
 drivers/usb/host/xhci-ring.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -417,6 +417,20 @@ void xhci_find_new_dequeue_state(struct
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


