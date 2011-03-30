Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965304Ab1C3Vh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:37:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:55627 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964907Ab1C3VIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411278117"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: Paul.Zimmerman@synopsys.com, paulz@synopsys.com,
        sarah.a.sharp@linux.intel.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [154/275] xhci: Avoid BUG() in interrupt context
Message-Id: <20110330210635.D275D3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>

commit 68e41c5d032668e2905404afbef75bc58be179d6 upstream.

Change the BUGs in xhci_find_new_dequeue_state() to WARN_ONs, to avoid
bringing down the box if one of them is hit

This patch should be queued for stable kernels back to 2.6.31.

Signed-off-by: Paul Zimmerman <paulz@synopsys.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/host/xhci-ring.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

Index: linux-2.6.35.y/drivers/usb/host/xhci-ring.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/host/xhci-ring.c	2011-03-29 22:51:04.398610620 -0700
+++ linux-2.6.35.y/drivers/usb/host/xhci-ring.c	2011-03-29 23:54:35.235100848 -0700
@@ -457,8 +457,11 @@
 	state->new_deq_seg = find_trb_seg(cur_td->start_seg,
 			dev->eps[ep_index].stopped_trb,
 			&state->new_cycle_state);
-	if (!state->new_deq_seg)
-		BUG();
+	if (!state->new_deq_seg) {
+		WARN_ON(1);
+		return;
+	}
+
 	/* Dig out the cycle state saved by the xHC during the stop ep cmd */
 	xhci_dbg(xhci, "Finding endpoint context\n");
 	ep_ctx = xhci_get_ep_ctx(xhci, dev->out_ctx, ep_index);
@@ -469,8 +472,10 @@
 	state->new_deq_seg = find_trb_seg(state->new_deq_seg,
 			state->new_deq_ptr,
 			&state->new_cycle_state);
-	if (!state->new_deq_seg)
-		BUG();
+	if (!state->new_deq_seg) {
+		WARN_ON(1);
+		return;
+	}
 
 	trb = &state->new_deq_ptr->generic;
 	if ((trb->field[3] & TRB_TYPE_BITMASK) == TRB_TYPE(TRB_LINK) &&
