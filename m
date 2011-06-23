Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934182Ab1FWSIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:08:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:34665 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933366Ab1FWRgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:52 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Paul Zimmerman <paulz@synopsys.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 133/247] xhci: Avoid BUG() in interrupt context
Date: Thu, 23 Jun 2011 13:33:21 -0400
Message-Id: <1308850515-15242-74-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 68e41c5d032668e2905404afbef75bc58be179d6 upstream.

Change the BUGs in xhci_find_new_dequeue_state() to WARN_ONs, to avoid
bringing down the box if one of them is hit

This patch should be queued for stable kernels back to 2.6.31.

Signed-off-by: Paul Zimmerman <paulz@synopsys.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/host/xhci-ring.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 632a7b6..6ead609 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -392,8 +392,11 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
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
@@ -404,8 +407,10 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
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
-- 
1.7.4.4

