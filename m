Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab2IIXZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:25:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51392 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756194Ab2IIXQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:51 -0400
Message-Id: <20120909224152.322785974@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:00 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Edwin Klein Mentink <e.kleinmentink@zonnet.nl>
Subject: [ 10/95] xhci: Increase reset timeout for Renesas 720201 host.
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 22ceac191211cf6688b1bf6ecd93c8b6bf80ed9b upstream.

The NEC/Renesas 720201 xHCI host controller does not complete its reset
within 250 milliseconds.  In fact, it takes about 9 seconds to reset the
host controller, and 1 second for the host to be ready for doorbell
rings.  Extend the reset and CNR polling timeout to 10 seconds each.

This patch should be backported to kernels as old as 2.6.31, that
contain the commit 66d4eadd8d067269ea8fead1a50fe87c2979a80d "USB: xhci:
BIOS handoff and HW initialization."

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reported-by: Edwin Klein Mentink <e.kleinmentink@zonnet.nl>
[bwh: Backported to 3.2: result of second handshake call is returned directly]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -163,7 +163,7 @@ int xhci_reset(struct xhci_hcd *xhci)
 	xhci_writel(xhci, command, &xhci->op_regs->command);
 
 	ret = handshake(xhci, &xhci->op_regs->command,
-			CMD_RESET, 0, 250 * 1000);
+			CMD_RESET, 0, 10 * 1000 * 1000);
 	if (ret)
 		return ret;
 
@@ -172,7 +172,8 @@ int xhci_reset(struct xhci_hcd *xhci)
 	 * xHCI cannot write to any doorbells or operational registers other
 	 * than status until the "Controller Not Ready" flag is cleared.
 	 */
-	return handshake(xhci, &xhci->op_regs->status, STS_CNR, 0, 250 * 1000);
+	return handshake(xhci, &xhci->op_regs->status,
+			 STS_CNR, 0, 10 * 1000 * 1000);
 }
 
 #ifdef CONFIG_PCI


