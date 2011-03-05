Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760414Ab1CEBAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:00:22 -0500
Received: from kroah.org ([198.145.64.141]:50251 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760380Ab1CEBAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:16 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:37 2011
Message-Id: <20110305005637.606737417@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Zimmerman <paulz@synopsys.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [31/73] xhci: Fix errors in the running total calculations in the TRB math
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>

commit 5807795bd4dececdf553719cc02869e633395787 upstream.

Calculations like

	running_total = TRB_MAX_BUFF_SIZE -
		(sg_dma_address(sg) & (TRB_MAX_BUFF_SIZE - 1));
	if (running_total != 0)
		num_trbs++;

are incorrect, because running_total can never be zero, so the if()
expression will never be true. I think the intention was that
running_total be in the range of 0 to TRB_MAX_BUFF_SIZE-1, not 1
to TRB_MAX_BUFF_SIZE. So adding a

	running_total &= TRB_MAX_BUFF_SIZE - 1;

fixes the problem.

This patch should be queued for stable kernels back to 2.6.31.

Signed-off-by: Paul Zimmerman <paulz@synopsys.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-ring.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2375,6 +2375,7 @@ static unsigned int count_sg_trbs_needed
 		/* Scatter gather list entries may cross 64KB boundaries */
 		running_total = TRB_MAX_BUFF_SIZE -
 			(sg_dma_address(sg) & (TRB_MAX_BUFF_SIZE - 1));
+		running_total &= TRB_MAX_BUFF_SIZE - 1;
 		if (running_total != 0)
 			num_trbs++;
 
@@ -2661,6 +2662,7 @@ int xhci_queue_bulk_tx(struct xhci_hcd *
 	/* How much data is (potentially) left before the 64KB boundary? */
 	running_total = TRB_MAX_BUFF_SIZE -
 		(urb->transfer_dma & (TRB_MAX_BUFF_SIZE - 1));
+	running_total &= TRB_MAX_BUFF_SIZE - 1;
 
 	/* If there's some data on this 64KB chunk, or we have to send a
 	 * zero-length transfer, we need at least one TRB
@@ -2877,6 +2879,7 @@ static int count_isoc_trbs_needed(struct
 	td_len = urb->iso_frame_desc[i].length;
 
 	running_total = TRB_MAX_BUFF_SIZE - (addr & (TRB_MAX_BUFF_SIZE - 1));
+	running_total &= TRB_MAX_BUFF_SIZE - 1;
 	if (running_total != 0)
 		num_trbs++;
 


