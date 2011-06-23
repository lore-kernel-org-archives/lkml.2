Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933641Ab1FWR5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:57:31 -0400
Received: from mail.windriver.com ([147.11.1.11]:35154 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933622Ab1FWRhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:43 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 183/247] xhci: Fix cycle bit calculation during stall handling.
Date: Thu, 23 Jun 2011 13:34:11 -0400
Message-Id: <1308850515-15242-124-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/host/xhci-ring.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 34ce5d4..3aa5c29 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -418,6 +418,20 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
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
-- 
1.7.4.4

