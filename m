Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964924Ab1C3VI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:08:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:61838 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964914Ab1C3VIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621237746"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: Paul.Zimmerman@synopsys.com, paulz@synopsys.com,
        sarah.a.sharp@linux.intel.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [157/275] xhci: Fix an error in count_sg_trbs_needed()
Message-Id: <20110330210639.0267D3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>

commit bcd2fde05341cef0052e49566ec88b406a521cf3 upstream.

The expression

	while (running_total < sg_dma_len(sg))

does not take into account that the remaining data length can be less
than sg_dma_len(sg). In that case, running_total can end up being
greater than the total data length, so an extra TRB is counted.
Changing the expression to

	while (running_total < sg_dma_len(sg) && running_total < temp)

fixes that.

This patch should be queued for stable kernels back to 2.6.31.

Signed-off-by: Paul Zimmerman <paulz@synopsys.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/host/xhci-ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/usb/host/xhci-ring.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/host/xhci-ring.c	2011-03-29 23:03:01.504261681 -0700
+++ linux-2.6.35.y/drivers/usb/host/xhci-ring.c	2011-03-29 23:54:12.392685328 -0700
@@ -1896,7 +1896,7 @@
 			num_trbs++;
 
 		/* How many more 64KB chunks to transfer, how many more TRBs? */
-		while (running_total < sg_dma_len(sg)) {
+		while (running_total < sg_dma_len(sg) && running_total < temp) {
 			num_trbs++;
 			running_total += TRB_MAX_BUFF_SIZE;
 		}
