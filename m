Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759779Ab0GAWPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:15:19 -0400
Received: from kroah.org ([198.145.64.141]:47304 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932594Ab0GAUtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:49:55 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:30 2010
Message-Id: <20100701173430.388574857@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:33:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andiry Xu <andiry.xu@amd.com>,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [patch 042/164] USB: xHCI: Fix wrong usage of macro TRB_TYPE
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andiry Xu <andiry.xu@amd.com>

commit 54b5acf3acb7a1f83ec281d111d3e2812cd7ad9d upstream.

Macro TRB_TYPE is misused in some places. Fix the wrong usage.


Signed-off-by: Andiry Xu <andiry.xu@amd.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-ring.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -350,7 +350,8 @@ static struct xhci_segment *find_trb_seg
 	while (cur_seg->trbs > trb ||
 			&cur_seg->trbs[TRBS_PER_SEGMENT - 1] < trb) {
 		generic_trb = &cur_seg->trbs[TRBS_PER_SEGMENT - 1].generic;
-		if (TRB_TYPE(generic_trb->field[3]) == TRB_LINK &&
+		if ((generic_trb->field[3] & TRB_TYPE_BITMASK) ==
+				TRB_TYPE(TRB_LINK) &&
 				(generic_trb->field[3] & LINK_TOGGLE))
 			*cycle_state = ~(*cycle_state) & 0x1;
 		cur_seg = cur_seg->next;
@@ -406,7 +407,7 @@ void xhci_find_new_dequeue_state(struct
 		BUG();
 
 	trb = &state->new_deq_ptr->generic;
-	if (TRB_TYPE(trb->field[3]) == TRB_LINK &&
+	if ((trb->field[3] & TRB_TYPE_BITMASK) == TRB_TYPE(TRB_LINK) &&
 				(trb->field[3] & LINK_TOGGLE))
 		state->new_cycle_state = ~(state->new_cycle_state) & 0x1;
 	next_trb(xhci, ep_ring, &state->new_deq_seg, &state->new_deq_ptr);
@@ -1394,8 +1395,10 @@ static int handle_tx_event(struct xhci_h
 			for (cur_trb = ep_ring->dequeue, cur_seg = ep_ring->deq_seg;
 					cur_trb != event_trb;
 					next_trb(xhci, ep_ring, &cur_seg, &cur_trb)) {
-				if (TRB_TYPE(cur_trb->generic.field[3]) != TRB_TR_NOOP &&
-						TRB_TYPE(cur_trb->generic.field[3]) != TRB_LINK)
+				if ((cur_trb->generic.field[3] &
+				 TRB_TYPE_BITMASK) != TRB_TYPE(TRB_TR_NOOP) &&
+				    (cur_trb->generic.field[3] &
+				 TRB_TYPE_BITMASK) != TRB_TYPE(TRB_LINK))
 					td->urb->actual_length +=
 						TRB_LEN(cur_trb->generic.field[2]);
 			}


