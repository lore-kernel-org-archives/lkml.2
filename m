Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760701Ab1CEBOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:14:18 -0500
Received: from kroah.org ([198.145.64.141]:50247 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760371Ab1CEBAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:16 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:37 2011
Message-Id: <20110305005637.511201005@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Zimmerman <paulz@synopsys.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [30/73] xhci: Clarify some expressions in the TRB math
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

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
 drivers/usb/host/xhci-ring.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2374,7 +2374,7 @@ static unsigned int count_sg_trbs_needed
 
 		/* Scatter gather list entries may cross 64KB boundaries */
 		running_total = TRB_MAX_BUFF_SIZE -
-			(sg_dma_address(sg) & ((1 << TRB_MAX_BUFF_SHIFT) - 1));
+			(sg_dma_address(sg) & (TRB_MAX_BUFF_SIZE - 1));
 		if (running_total != 0)
 			num_trbs++;
 
@@ -2404,11 +2404,11 @@ static unsigned int count_sg_trbs_needed
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
@@ -2540,8 +2540,7 @@ static int queue_bulk_sg_tx(struct xhci_
 	sg = urb->sg;
 	addr = (u64) sg_dma_address(sg);
 	this_sg_len = sg_dma_len(sg);
-	trb_buff_len = TRB_MAX_BUFF_SIZE -
-		(addr & ((1 << TRB_MAX_BUFF_SHIFT) - 1));
+	trb_buff_len = TRB_MAX_BUFF_SIZE - (addr & (TRB_MAX_BUFF_SIZE - 1));
 	trb_buff_len = min_t(int, trb_buff_len, this_sg_len);
 	if (trb_buff_len > urb->transfer_buffer_length)
 		trb_buff_len = urb->transfer_buffer_length;
@@ -2577,7 +2576,7 @@ static int queue_bulk_sg_tx(struct xhci_
 				(unsigned int) (addr + TRB_MAX_BUFF_SIZE) & ~(TRB_MAX_BUFF_SIZE - 1),
 				(unsigned int) addr + trb_buff_len);
 		if (TRB_MAX_BUFF_SIZE -
-				(addr & ((1 << TRB_MAX_BUFF_SHIFT) - 1)) < trb_buff_len) {
+				(addr & (TRB_MAX_BUFF_SIZE - 1)) < trb_buff_len) {
 			xhci_warn(xhci, "WARN: sg dma xfer crosses 64KB boundaries!\n");
 			xhci_dbg(xhci, "Next boundary at %#x, end dma = %#x\n",
 					(unsigned int) (addr + TRB_MAX_BUFF_SIZE) & ~(TRB_MAX_BUFF_SIZE - 1),
@@ -2621,7 +2620,7 @@ static int queue_bulk_sg_tx(struct xhci_
 		}
 
 		trb_buff_len = TRB_MAX_BUFF_SIZE -
-			(addr & ((1 << TRB_MAX_BUFF_SHIFT) - 1));
+			(addr & (TRB_MAX_BUFF_SIZE - 1));
 		trb_buff_len = min_t(int, trb_buff_len, this_sg_len);
 		if (running_total + trb_buff_len > urb->transfer_buffer_length)
 			trb_buff_len =
@@ -2661,7 +2660,7 @@ int xhci_queue_bulk_tx(struct xhci_hcd *
 	num_trbs = 0;
 	/* How much data is (potentially) left before the 64KB boundary? */
 	running_total = TRB_MAX_BUFF_SIZE -
-		(urb->transfer_dma & ((1 << TRB_MAX_BUFF_SHIFT) - 1));
+		(urb->transfer_dma & (TRB_MAX_BUFF_SIZE - 1));
 
 	/* If there's some data on this 64KB chunk, or we have to send a
 	 * zero-length transfer, we need at least one TRB
@@ -2704,8 +2703,8 @@ int xhci_queue_bulk_tx(struct xhci_hcd *
 	/* How much data is in the first TRB? */
 	addr = (u64) urb->transfer_dma;
 	trb_buff_len = TRB_MAX_BUFF_SIZE -
-		(urb->transfer_dma & ((1 << TRB_MAX_BUFF_SHIFT) - 1));
-	if (urb->transfer_buffer_length < trb_buff_len)
+		(urb->transfer_dma & (TRB_MAX_BUFF_SIZE - 1));
+	if (trb_buff_len > urb->transfer_buffer_length)
 		trb_buff_len = urb->transfer_buffer_length;
 
 	first_trb = true;
@@ -2877,8 +2876,7 @@ static int count_isoc_trbs_needed(struct
 	addr = (u64) (urb->transfer_dma + urb->iso_frame_desc[i].offset);
 	td_len = urb->iso_frame_desc[i].length;
 
-	running_total = TRB_MAX_BUFF_SIZE -
-			(addr & ((1 << TRB_MAX_BUFF_SHIFT) - 1));
+	running_total = TRB_MAX_BUFF_SIZE - (addr & (TRB_MAX_BUFF_SIZE - 1));
 	if (running_total != 0)
 		num_trbs++;
 


