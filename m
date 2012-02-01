Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941Ab2BAVmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:42:01 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44850 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757151Ab2BAVJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:09:27 -0500
X-Sasl-enc: fnvNZ8pshLatQHLnhCvoyPgMh6PYPLP/Yl6I9IEi0USO 1328130565
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:41 2012
Message-Id: <20120201205741.146941014@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:56:22 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andiry Xu <andiry.xu@amd.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [42/65] xHCI: Cleanup isoc transfer ring when TD length mismatch found
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3382,7 +3382,8 @@ static int xhci_queue_isoc_tx(struct xhc
 		/* Check TD length */
 		if (running_total != td_len) {
 			xhci_err(xhci, "ISOC TD length unmatch\n");
-			return -EINVAL;
+			ret = -EINVAL;
+			goto cleanup;
 		}
 	}
 


