Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934169Ab1FWSGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:06:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:34690 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933447Ab1FWRgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:54 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Paul Zimmerman <paulz@synopsys.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 134/247] xhci: Clarify some expressions in the TRB math
Date: Thu, 23 Jun 2011 13:33:22 -0400
Message-Id: <1308850515-15242-75-git-send-email-paul.gortmaker@windriver.com>
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

[PG: 34 doesn't have count_isoc_trbs_needed() hence this has
 one less instance to change vs. the originating release]

Signed-off-by: Paul Zimmerman <paulz@synopsys.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/host/xhci-ring.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 6ead609..8bf5563 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1710,7 +1710,7 @@ static unsigned int count_sg_trbs_needed(struct xhci_hcd *xhci, struct urb *urb)
 
 		/* Scatter gather list entries may cross 64KB boundaries */
 		running_total = TRB_MAX_BUFF_SIZE -
-			(sg_dma_address(sg) & ((1 << TRB_MAX_BUFF_SHIFT) - 1));
+			(sg_dma_address(sg) & (TRB_MAX_BUFF_SIZE - 1));
 		if (running_total != 0)
 			num_trbs++;
 
@@ -1740,11 +1740,11 @@ static unsigned int count_sg_trbs_needed(struct xhci_hcd *xhci, struct urb *urb)
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
@@ -1866,8 +1866,7 @@ static int queue_bulk_sg_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 	sg = urb->sg->sg;
 	addr = (u64) sg_dma_address(sg);
 	this_sg_len = sg_dma_len(sg);
-	trb_buff_len = TRB_MAX_BUFF_SIZE -
-		(addr & ((1 << TRB_MAX_BUFF_SHIFT) - 1));
+	trb_buff_len = TRB_MAX_BUFF_SIZE - (addr & (TRB_MAX_BUFF_SIZE - 1));
 	trb_buff_len = min_t(int, trb_buff_len, this_sg_len);
 	if (trb_buff_len > urb->transfer_buffer_length)
 		trb_buff_len = urb->transfer_buffer_length;
@@ -1903,7 +1902,7 @@ static int queue_bulk_sg_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 				(unsigned int) (addr + TRB_MAX_BUFF_SIZE) & ~(TRB_MAX_BUFF_SIZE - 1),
 				(unsigned int) addr + trb_buff_len);
 		if (TRB_MAX_BUFF_SIZE -
-				(addr & ((1 << TRB_MAX_BUFF_SHIFT) - 1)) < trb_buff_len) {
+				(addr & (TRB_MAX_BUFF_SIZE - 1)) < trb_buff_len) {
 			xhci_warn(xhci, "WARN: sg dma xfer crosses 64KB boundaries!\n");
 			xhci_dbg(xhci, "Next boundary at %#x, end dma = %#x\n",
 					(unsigned int) (addr + TRB_MAX_BUFF_SIZE) & ~(TRB_MAX_BUFF_SIZE - 1),
@@ -1943,7 +1942,7 @@ static int queue_bulk_sg_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 		}
 
 		trb_buff_len = TRB_MAX_BUFF_SIZE -
-			(addr & ((1 << TRB_MAX_BUFF_SHIFT) - 1));
+			(addr & (TRB_MAX_BUFF_SIZE - 1));
 		trb_buff_len = min_t(int, trb_buff_len, this_sg_len);
 		if (running_total + trb_buff_len > urb->transfer_buffer_length)
 			trb_buff_len =
@@ -1978,7 +1977,7 @@ int xhci_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 	num_trbs = 0;
 	/* How much data is (potentially) left before the 64KB boundary? */
 	running_total = TRB_MAX_BUFF_SIZE -
-		(urb->transfer_dma & ((1 << TRB_MAX_BUFF_SHIFT) - 1));
+		(urb->transfer_dma & (TRB_MAX_BUFF_SIZE - 1));
 
 	/* If there's some data on this 64KB chunk, or we have to send a
 	 * zero-length transfer, we need at least one TRB
@@ -2017,8 +2016,8 @@ int xhci_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 	/* How much data is in the first TRB? */
 	addr = (u64) urb->transfer_dma;
 	trb_buff_len = TRB_MAX_BUFF_SIZE -
-		(urb->transfer_dma & ((1 << TRB_MAX_BUFF_SHIFT) - 1));
-	if (urb->transfer_buffer_length < trb_buff_len)
+		(urb->transfer_dma & (TRB_MAX_BUFF_SIZE - 1));
+	if (trb_buff_len > urb->transfer_buffer_length)
 		trb_buff_len = urb->transfer_buffer_length;
 
 	first_trb = true;
-- 
1.7.4.4

