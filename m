Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933600Ab2JAXcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:32:17 -0400
Received: from 1wt.eu ([62.212.114.60]:35172 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932651Ab2JAXAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:31 -0400
Message-Id: <20121001225201.335232009@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:25 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 088/180] xhci: Reset reserved command ring TRBs on cleanup.
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 33b2831ac870d50cc8e01c317b07fb1e69c13fe1 upstream.

When the xHCI driver needs to clean up memory (perhaps due to a failed
register restore on resume from S3 or resume from S4), it needs to reset
the number of reserved TRBs on the command ring to zero.  Otherwise,
several resume cycles (about 30) with a UAS device attached will
continually increment the number of reserved TRBs, until all command
submissions fail because there isn't enough room on the command ring.

This patch should be backported to kernels as old as 2.6.32,
that contain the commit 913a8a344ffcaf0b4a586d6662a2c66a7106557d
"USB: xhci: Change how xHCI commands are handled."

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/usb/host/xhci-mem.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index d486bb8..776fd43 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -945,6 +945,7 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	xhci->event_ring = NULL;
 	xhci_dbg(xhci, "Freed event ring\n");
 
+	xhci->cmd_ring_reserved_trbs = 0;
 	if (xhci->cmd_ring)
 		xhci_ring_free(xhci, xhci->cmd_ring);
 	xhci->cmd_ring = NULL;
-- 
1.7.2.1.45.g54fbc



