Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161090Ab2I1U4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:56:17 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49961 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422991Ab2I1UsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:48:13 -0400
X-Sasl-enc: yfqH1W+UgqtcW9/mWV57v21g8zWvXsbz0o8Uwp6miwRD 1348865292
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        James Ettle <theholyettlz@googlemail.com>,
        Matthew Hall <mhall@mhcomputing.net>
Subject: [ 083/127] xhci: Fix bug after deq ptr set to link TRB.
Date: Fri, 28 Sep 2012 13:34:16 -0700
Message-Id: <20120928203055.626098148@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 50d0206fcaea3e736f912fd5b00ec6233fb4ce44 upstream.

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

This patch should be backported to kernels as old as 2.6.31.  A separate
patch will be created for kernels older than 3.4, since inc_deq was
modified in 3.4 and this patch will not apply.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Tested-by: James Ettle <theholyettlz@googlemail.com>
Tested-by: Matthew Hall <mhall@mhcomputing.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-ring.c |   39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -147,25 +147,34 @@ static void next_trb(struct xhci_hcd *xh
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
 


