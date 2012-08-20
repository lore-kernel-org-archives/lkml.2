Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab2HTEGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:06:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42117 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab2HTEBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:01:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Edwin Klein Mentink <e.kleinmentink@zonnet.nl>
Subject: [ 28/46] xhci: Increase reset timeout for Renesas 720201 host.
Date: Sun, 19 Aug 2012 20:59:04 -0700
Message-Id: <20120820035836.172530757@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035832.274275502@linuxfoundation.org>
References: <20120820035832.274275502@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -166,7 +166,7 @@ int xhci_reset(struct xhci_hcd *xhci)
 	xhci_writel(xhci, command, &xhci->op_regs->command);
 
 	ret = handshake(xhci, &xhci->op_regs->command,
-			CMD_RESET, 0, 250 * 1000);
+			CMD_RESET, 0, 10 * 1000 * 1000);
 	if (ret)
 		return ret;
 
@@ -175,7 +175,8 @@ int xhci_reset(struct xhci_hcd *xhci)
 	 * xHCI cannot write to any doorbells or operational registers other
 	 * than status until the "Controller Not Ready" flag is cleared.
 	 */
-	ret = handshake(xhci, &xhci->op_regs->status, STS_CNR, 0, 250 * 1000);
+	ret = handshake(xhci, &xhci->op_regs->status,
+			STS_CNR, 0, 10 * 1000 * 1000);
 
 	for (i = 0; i < 2; ++i) {
 		xhci->bus_state[i].port_c_suspend = 0;


