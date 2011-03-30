Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964938Ab1C3VIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:08:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:21480 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964911Ab1C3VIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903735560"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: Paul.Zimmerman@synopsys.com, paulz@synopsys.com,
        sarah.a.sharp@linux.intel.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [155/275] xhci: Clarify some expressions in the TRB math
Message-Id: <20110330210636.DF0B53E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/host/xhci-ring.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

Index: linux-2.6.35.y/drivers/usb/host/xhci-ring.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/host/xhci-ring.c	2011-03-29 23:03:01.466262652 -0700
+++ linux-2.6.35.y/drivers/usb/host/xhci-ring.c	2011-03-29 23:54:34.753113182 -0700
@@ -1890,7 +1890,7 @@
 
 		/* Scatter gather list entries may cross 64KB boundaries */
 		running_total = TRB_MAX_BUFF_SIZE -
-			(sg_dma_address(sg) & ((1 << TRB_MAX_BUFF_SHIFT) - 1));
+			(sg_dma_address(sg) & (TRB_MAX_BUFF_SIZE - 1));
 		if (running_total != 0)
 			num_trbs++;
 
@@ -1920,11 +1920,11 @@
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
@@ -2051,8 +2051,7 @@
 	sg = urb->sg;
 	addr = (u64) sg_dma_address(sg);
 	this_sg_len = sg_dma_len(sg);
-	trb_buff_len = TRB_MAX_BUFF_SIZE -
-		(addr & ((1 << TRB_MAX_BUFF_SHIFT) - 1));
+	trb_buff_len = TRB_MAX_BUFF_SIZE - (addr & (TRB_MAX_BUFF_SIZE - 1));
 	trb_buff_len = min_t(int, trb_buff_len, this_sg_len);
 	if (trb_buff_len > urb->transfer_buffer_length)
 		trb_buff_len = urb->transfer_buffer_length;
@@ -2088,7 +2087,7 @@
 				(unsigned int) (addr + TRB_MAX_BUFF_SIZE) & ~(TRB_MAX_BUFF_SIZE - 1),
 				(unsigned int) addr + trb_buff_len);
 		if (TRB_MAX_BUFF_SIZE -
-				(addr & ((1 << TRB_MAX_BUFF_SHIFT) - 1)) < trb_buff_len) {
+				(addr & (TRB_MAX_BUFF_SIZE - 1)) < trb_buff_len) {
 			xhci_warn(xhci, "WARN: sg dma xfer crosses 64KB boundaries!\n");
 			xhci_dbg(xhci, "Next boundary at %#x, end dma = %#x\n",
 					(unsigned int) (addr + TRB_MAX_BUFF_SIZE) & ~(TRB_MAX_BUFF_SIZE - 1),
@@ -2132,7 +2131,7 @@
 		}
 
 		trb_buff_len = TRB_MAX_BUFF_SIZE -
-			(addr & ((1 << TRB_MAX_BUFF_SHIFT) - 1));
+			(addr & (TRB_MAX_BUFF_SIZE - 1));
 		trb_buff_len = min_t(int, trb_buff_len, this_sg_len);
 		if (running_total + trb_buff_len > urb->transfer_buffer_length)
 			trb_buff_len =
@@ -2171,7 +2170,7 @@
 	num_trbs = 0;
 	/* How much data is (potentially) left before the 64KB boundary? */
 	running_total = TRB_MAX_BUFF_SIZE -
-		(urb->transfer_dma & ((1 << TRB_MAX_BUFF_SHIFT) - 1));
+		(urb->transfer_dma & (TRB_MAX_BUFF_SIZE - 1));
 
 	/* If there's some data on this 64KB chunk, or we have to send a
 	 * zero-length transfer, we need at least one TRB
@@ -2211,8 +2210,8 @@
 	/* How much data is in the first TRB? */
 	addr = (u64) urb->transfer_dma;
 	trb_buff_len = TRB_MAX_BUFF_SIZE -
-		(urb->transfer_dma & ((1 << TRB_MAX_BUFF_SHIFT) - 1));
-	if (urb->transfer_buffer_length < trb_buff_len)
+		(urb->transfer_dma & (TRB_MAX_BUFF_SIZE - 1));
+	if (trb_buff_len > urb->transfer_buffer_length)
 		trb_buff_len = urb->transfer_buffer_length;
 
 	first_trb = true;
