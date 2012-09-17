Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab2IQAus (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:50:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33389 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753058Ab2IQAtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:41 -0400
Message-Id: <20120917003637.572293386@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:47 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 082/135] xhci: Fix bug after deq ptr set to link TRB.
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

This patch fixes a particularly nasty bug that was revealed by the ring
expansion patches.  The bug has been present since the very beginning of
the xHCI driver history, and could have caused general protection faults
from bad memory accesses.

The first thing to note is that a Set TR Dequeue Pointer command can
move the dequeue pointer to a link TRB, if the canceled or stalled
transfer TD ended just before a link TRB.  The function to increment the
dequeue pointer, inc_deq, was written before cancellation and stall
support was added.  It assumed that the dequeue pointer could never
point to a link TRB.  It would unconditionally increment the dequeue
pointer at the start of the function, check if the pointer was now on a
link TRB, and move it to the top of the next segment if so.

This means that if a Set TR Dequeue Point command moved the dequeue
pointer to a link TRB, a subsequent call to inc_deq() would move the
pointer off the segment and into la-la-land.  It would then read from
that memory to determine if it was a link TRB.  Other functions would
often call inc_deq() until the dequeue pointer matched some other
pointer, which means this function would quite happily read all of
system memory before wrapping around to the right pointer value.

Often, there would be another endpoint segment from a different ring
allocated from the same DMA pool, which would be contiguous to the
segment inc_deq just stepped off of.  inc_deq would eventually find the
link TRB in that segment, and blindly move the dequeue pointer back to
the top of the correct ring segment.

The only reason the original code worked at all is because there was
only one ring segment.  With the ring expansion patches, the dequeue
pointer would eventually wrap into place, but the dequeue segment would
be out-of-sync.  On the second TD after the dequeue pointer was moved to
a link TRB, trb_in_td() would fail (because the dequeue pointer and
dequeue segment were out-of-sync), and this message would appear:

ERROR Transfer event TRB DMA ptr not part of current TD

This fixes bugzilla entry 4333 (option-based modem unhappy on USB 3.0
port: "Transfer event TRB DMA ptr not part of current TD", "rejecting
I/O to offline device"),

	https://bugzilla.kernel.org/show_bug.cgi?id=43333

and possibly other general protection fault bugs as well.

This patch should be backported to kernels as old as 2.6.31.  The
original upstream commit is 50d0206fcaea3e736f912fd5b00ec6233fb4ce44,
but it does not apply to kernels older than 3.4, because inc_deq was
changed in 3.3 and 3.4.  This patch should apply to the 3.2 kernel and
older.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
---
 drivers/usb/host/xhci-ring.c |   39 ++++++++++++++++++++++++---------------
 1 files changed, 24 insertions(+), 15 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -145,25 +145,34 @@ static void next_trb(struct xhci_hcd *xh
  */
 static void inc_deq(struct xhci_hcd *xhci, struct xhci_ring *ring, bool consumer)
 {
-	union xhci_trb *next = ++(ring->dequeue);
 	unsigned long long addr;
 
 	ring->deq_updates++;
-	/* Update the dequeue pointer further if that was a link TRB or we're at
-	 * the end of an event ring segment (which doesn't have link TRBS)
-	 */
-	while (last_trb(xhci, ring, ring->deq_seg, next)) {
-		if (consumer && last_trb_on_last_seg(xhci, ring, ring->deq_seg, next)) {
-			ring->cycle_state = (ring->cycle_state ? 0 : 1);
-			if (!in_interrupt())
-				xhci_dbg(xhci, "Toggle cycle state for ring %p = %i\n",
-						ring,
-						(unsigned int) ring->cycle_state);
+
+	do {
+		/*
+		 * Update the dequeue pointer further if that was a link TRB or
+		 * we're at the end of an event ring segment (which doesn't have
+		 * link TRBS)
+		 */
+		if (last_trb(xhci, ring, ring->deq_seg, ring->dequeue)) {
+			if (consumer && last_trb_on_last_seg(xhci, ring,
+						ring->deq_seg, ring->dequeue)) {
+				if (!in_interrupt())
+					xhci_dbg(xhci, "Toggle cycle state "
+							"for ring %p = %i\n",
+							ring,
+							(unsigned int)
+							ring->cycle_state);
+				ring->cycle_state = (ring->cycle_state ? 0 : 1);
+			}
+			ring->deq_seg = ring->deq_seg->next;
+			ring->dequeue = ring->deq_seg->trbs;
+		} else {
+			ring->dequeue++;
 		}
-		ring->deq_seg = ring->deq_seg->next;
-		ring->dequeue = ring->deq_seg->trbs;
-		next = ring->dequeue;
-	}
+	} while (last_trb(xhci, ring, ring->deq_seg, ring->dequeue));
+
 	addr = (unsigned long long) xhci_trb_virt_to_dma(ring->deq_seg, ring->dequeue);
 }
 


