Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab1B1Qi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:38:59 -0500
Received: from kroah.org ([198.145.64.141]:48298 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755836Ab1B1QiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:38:25 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:12 2011
Message-Id: <20110228162412.309763811@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:23:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Zimmerman <paulz@synopsys.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [66/68] xhci: Clarify some expressions in the TRB math
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>

commit a2490187011cc2263117626615a581927d19f1d3 upstream.

This makes it easier to spot some problems, which will be fixed by the
next patch in the series. Also change dev_dbg to dev_err in
check_trb_math(), so any math errors will be visible even when running
with debug disabled.

Note: This patch changes the expressions containing
"((1 << TRB_MAX_BUFF_SHIFT) - 1)" to use the equivalent
"(TRB_MAX_BUFF_SIZE - 1)". No change in behavior is intended for
those expressions.

This patch should be queued for stable kernels back to 2.6.31.

Signed-off-by: Paul Zimmerman <paulz@synopsys.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-ring.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1490,7 +1490,7 @@ static unsigned int count_sg_trbs_needed
 
 		/* Scatter gather list entries may cross 64KB boundaries */
 		running_total = TRB_MAX_BUFF_SIZE -
-			(sg_dma_address(sg) & ((1 << TRB_MAX_BUFF_SHIFT) - 1));
+			(sg_dma_address(sg) & (TRB_MAX_BUFF_SIZE - 1));
 		if (running_total != 0)
 			num_trbs++;
 
@@ -1520,11 +1520,11 @@ static unsigned int count_sg_trbs_needed
 static void check_trb_math(struct urb *urb, int num_trbs, int running_total)
 {
 	if (num_trbs != 0)
-		dev_dbg(&urb->dev->dev, "%s - ep %#x - Miscalculated number of "
+		dev_err(&urb->dev->dev, "%s - ep %#x - Miscalculated number of "
 				"TRBs, %d left\n", __func__,
 				urb->ep->desc.bEndpointAddress, num_trbs);
 	if (running_total != urb->transfer_buffer_length)
-		dev_dbg(&urb->dev->dev, "%s - ep %#x - Miscalculated tx length, "
+		dev_err(&urb->dev->dev, "%s - ep %#x - Miscalculated tx length, "
 				"queued %#x (%d), asked for %#x (%d)\n",
 				__func__,
 				urb->ep->desc.bEndpointAddress,
@@ -1631,8 +1631,7 @@ static int queue_bulk_sg_tx(struct xhci_
 	sg = urb->sg->sg;
 	addr = (u64) sg_dma_address(sg);
 	this_sg_len = sg_dma_len(sg);
-	trb_buff_len = TRB_MAX_BUFF_SIZE -
-		(addr & ((1 << TRB_MAX_BUFF_SHIFT) - 1));
+	trb_buff_len = TRB_MAX_BUFF_SIZE - (addr & (TRB_MAX_BUFF_SIZE - 1));
 	trb_buff_len = min_t(int, trb_buff_len, this_sg_len);
 	if (trb_buff_len > urb->transfer_buffer_length)
 		trb_buff_len = urb->transfer_buffer_length;
@@ -1667,7 +1666,7 @@ static int queue_bulk_sg_tx(struct xhci_
 				(unsigned int) (addr + TRB_MAX_BUFF_SIZE) & ~(TRB_MAX_BUFF_SIZE - 1),
 				(unsigned int) addr + trb_buff_len);
 		if (TRB_MAX_BUFF_SIZE -
-				(addr & ((1 << TRB_MAX_BUFF_SHIFT) - 1)) < trb_buff_len) {
+				(addr & (TRB_MAX_BUFF_SIZE - 1)) < trb_buff_len) {
 			xhci_warn(xhci, "WARN: sg dma xfer crosses 64KB boundaries!\n");
 			xhci_dbg(xhci, "Next boundary at %#x, end dma = %#x\n",
 					(unsigned int) (addr + TRB_MAX_BUFF_SIZE) & ~(TRB_MAX_BUFF_SIZE - 1),
@@ -1705,7 +1704,7 @@ static int queue_bulk_sg_tx(struct xhci_
 		}
 
 		trb_buff_len = TRB_MAX_BUFF_SIZE -
-			(addr & ((1 << TRB_MAX_BUFF_SHIFT) - 1));
+			(addr & (TRB_MAX_BUFF_SIZE - 1));
 		trb_buff_len = min_t(int, trb_buff_len, this_sg_len);
 		if (running_total + trb_buff_len > urb->transfer_buffer_length)
 			trb_buff_len =
@@ -1740,7 +1739,7 @@ int xhci_queue_bulk_tx(struct xhci_hcd *
 	num_trbs = 0;
 	/* How much data is (potentially) left before the 64KB boundary? */
 	running_total = TRB_MAX_BUFF_SIZE -
-		(urb->transfer_dma & ((1 << TRB_MAX_BUFF_SHIFT) - 1));
+		(urb->transfer_dma & (TRB_MAX_BUFF_SIZE - 1));
 
 	/* If there's some data on this 64KB chunk, or we have to send a
 	 * zero-length transfer, we need at least one TRB
@@ -1779,8 +1778,8 @@ int xhci_queue_bulk_tx(struct xhci_hcd *
 	/* How much data is in the first TRB? */
 	addr = (u64) urb->transfer_dma;
 	trb_buff_len = TRB_MAX_BUFF_SIZE -
-		(urb->transfer_dma & ((1 << TRB_MAX_BUFF_SHIFT) - 1));
-	if (urb->transfer_buffer_length < trb_buff_len)
+		(urb->transfer_dma & (TRB_MAX_BUFF_SIZE - 1));
+	if (trb_buff_len > urb->transfer_buffer_length)
 		trb_buff_len = urb->transfer_buffer_length;
 
 	first_trb = true;


