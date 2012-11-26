Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934191Ab2KZRPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:15:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48261 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934111Ab2KZRPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:15:45 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 254/270] xhci: Fix potential NULL ptr deref in command cancellation.
Date: Mon, 26 Nov 2012 14:59:04 -0200
Message-Id: <1353949160-26803-255-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 43a09f7fb01fa1e091416a2aa49b6c666458c1ee upstream.

The command cancellation code doesn't check whether find_trb_seg()
couldn't find the segment that contains the TRB to be canceled.  This
could cause a NULL pointer deference later in the function when next_trb
is called.  It's unlikely to happen unless something is wrong with the
command ring pointers, so add some debugging in case it happens.

This patch should be backported to stable kernels as old as 3.0, that
contain the commit b63f4053cc8aa22a98e3f9a97845afe6c15d0a0d "xHCI:
handle command after aborting the command ring".

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/host/xhci-ring.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 47b6bb6..755858e 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1228,6 +1228,17 @@ static void xhci_cmd_to_noop(struct xhci_hcd *xhci, struct xhci_cd *cur_cd)
 	cur_seg = find_trb_seg(xhci->cmd_ring->first_seg,
 			xhci->cmd_ring->dequeue, &cycle_state);
 
+	if (!cur_seg) {
+		xhci_warn(xhci, "Command ring mismatch, dequeue = %p %llx (dma)\n",
+				xhci->cmd_ring->dequeue,
+				(unsigned long long)
+				xhci_trb_virt_to_dma(xhci->cmd_ring->deq_seg,
+					xhci->cmd_ring->dequeue));
+		xhci_debug_ring(xhci, xhci->cmd_ring);
+		xhci_dbg_ring_ptrs(xhci, xhci->cmd_ring);
+		return;
+	}
+
 	/* find the command trb matched by cd from command ring */
 	for (cmd_trb = xhci->cmd_ring->dequeue;
 			cmd_trb != xhci->cmd_ring->enqueue;
-- 
1.7.9.5

