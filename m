Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab2E1Drt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:47:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52007 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753369Ab2E1D3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:25 -0400
Message-Id: <20120528031211.712437567@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:06 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 064/117] xhci: Reset reserved command ring TRBs on cleanup.
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-mem.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 0b5ff26..497ed77 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1815,6 +1815,7 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	xhci->event_ring = NULL;
 	xhci_dbg(xhci, "Freed event ring\n");
 
+	xhci->cmd_ring_reserved_trbs = 0;
 	if (xhci->cmd_ring)
 		xhci_ring_free(xhci, xhci->cmd_ring);
 	xhci->cmd_ring = NULL;


