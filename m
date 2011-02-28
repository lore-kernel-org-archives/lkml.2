Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab1B1Qiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:38:46 -0500
Received: from kroah.org ([198.145.64.141]:48305 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841Ab1B1Qi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:38:26 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:12 2011
Message-Id: <20110228162412.397726637@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:23:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Zimmerman <paulz@synopsys.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [67/68] xhci: Fix errors in the running total calculations in the TRB math
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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
 drivers/usb/host/xhci-ring.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1491,6 +1491,7 @@ static unsigned int count_sg_trbs_needed
 		/* Scatter gather list entries may cross 64KB boundaries */
 		running_total = TRB_MAX_BUFF_SIZE -
 			(sg_dma_address(sg) & (TRB_MAX_BUFF_SIZE - 1));
+		running_total &= TRB_MAX_BUFF_SIZE - 1;
 		if (running_total != 0)
 			num_trbs++;
 
@@ -1740,6 +1741,7 @@ int xhci_queue_bulk_tx(struct xhci_hcd *
 	/* How much data is (potentially) left before the 64KB boundary? */
 	running_total = TRB_MAX_BUFF_SIZE -
 		(urb->transfer_dma & (TRB_MAX_BUFF_SIZE - 1));
+	running_total &= TRB_MAX_BUFF_SIZE - 1;
 
 	/* If there's some data on this 64KB chunk, or we have to send a
 	 * zero-length transfer, we need at least one TRB


