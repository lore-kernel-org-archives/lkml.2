Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599Ab2J2WSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:18:37 -0400
Received: from mail.kernel.org ([198.145.19.201]:47239 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761069Ab2J2Vgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:36:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 021/101] xhci: Fix potential NULL ptr deref in command cancellation.
Date: Mon, 29 Oct 2012 14:34:34 -0700
Message-Id: <20121029213242.532279334@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-ring.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1228,6 +1228,17 @@ static void xhci_cmd_to_noop(struct xhci
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


