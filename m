Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760703Ab1CEBOg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:14:36 -0500
Received: from kroah.org ([198.145.64.141]:50242 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760370Ab1CEBAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:15 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:37 2011
Message-Id: <20110305005637.427392087@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Zimmerman <paulz@synopsys.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [29/73] xhci: Avoid BUG() in interrupt context
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>

commit 68e41c5d032668e2905404afbef75bc58be179d6 upstream.

Change the BUGs in xhci_find_new_dequeue_state() to WARN_ONs, to avoid
bringing down the box if one of them is hit

This patch should be queued for stable kernels back to 2.6.31.

Signed-off-by: Paul Zimmerman <paulz@synopsys.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-ring.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -479,8 +479,11 @@ void xhci_find_new_dequeue_state(struct
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
@@ -491,8 +494,10 @@ void xhci_find_new_dequeue_state(struct
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


