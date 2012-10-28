Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab2J1X1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:27:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41874 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756419Ab2J1X1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:16 -0400
Message-Id: <20121028231605.598223284@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:17:08 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 092/105] xhci: Fix potential NULL ptr deref in command cancellation.
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-ring.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index c6ebb17..4e1a894 100644
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


