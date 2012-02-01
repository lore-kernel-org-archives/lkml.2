Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850Ab2BAVdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:33:51 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:60452 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757331Ab2BAVRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:17:35 -0500
X-Sasl-enc: Mh4v36KycZm7XNzNPr8ITAE/9QCWdHZRI3nJdRTIjx9L 1328131054
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:49 2012
Message-Id: <20120201210049.261335775@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:25 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andiry Xu <andiry.xu@amd.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [61/89] xHCI: Cleanup isoc transfer ring when TD length mismatch found
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andiry Xu <andiry.xu@amd.com>

commit cf840551a884360841bd3d3ce1ad0868ff0b759a upstream.

When a TD length mismatch is found during isoc TRB enqueue, it directly
returns -EINVAL. However, isoc transfer is partially enqueued at this time,
and the ring should be cleared.

This should be backported to kernels as old as 2.6.36, which contain the
commit 522989a27c7badb608155b1f1dea3487ed431f74 "xhci: Fix failed
enqueue in the middle of isoch TD."

Signed-off-by: Andiry Xu <andiry.xu@amd.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-ring.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3373,7 +3373,8 @@ static int xhci_queue_isoc_tx(struct xhc
 		/* Check TD length */
 		if (running_total != td_len) {
 			xhci_err(xhci, "ISOC TD length unmatch\n");
-			return -EINVAL;
+			ret = -EINVAL;
+			goto cleanup;
 		}
 	}
 


