Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933611Ab1C3VIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:08:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:21480 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964890Ab1C3VIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903735574"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: Paul.Zimmerman@synopsys.com, paulz@synopsys.com,
        sarah.a.sharp@linux.intel.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [156/275] xhci: Fix errors in the running total calculations in the TRB math
Message-Id: <20110330210637.E9F6D3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/host/xhci-ring.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.35.y/drivers/usb/host/xhci-ring.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/host/xhci-ring.c	2011-03-29 23:03:01.485262166 -0700
+++ linux-2.6.35.y/drivers/usb/host/xhci-ring.c	2011-03-29 23:54:34.277125360 -0700
@@ -1891,6 +1891,7 @@
 		/* Scatter gather list entries may cross 64KB boundaries */
 		running_total = TRB_MAX_BUFF_SIZE -
 			(sg_dma_address(sg) & (TRB_MAX_BUFF_SIZE - 1));
+		running_total &= TRB_MAX_BUFF_SIZE - 1;
 		if (running_total != 0)
 			num_trbs++;
 
@@ -2171,6 +2172,7 @@
 	/* How much data is (potentially) left before the 64KB boundary? */
 	running_total = TRB_MAX_BUFF_SIZE -
 		(urb->transfer_dma & (TRB_MAX_BUFF_SIZE - 1));
+	running_total &= TRB_MAX_BUFF_SIZE - 1;
 
 	/* If there's some data on this 64KB chunk, or we have to send a
 	 * zero-length transfer, we need at least one TRB
