Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302Ab2FQSjM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:39:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50189 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758038Ab2FQSWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:34 -0400
Message-Id: <20120617175950.473751280@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:44 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andiry Xu <andiry.xu@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Ming Lei <ming.lei@canonical.com>
Subject: [ 63/69] xHCI: Increase the timeout for controller save/restore state
 operation
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andiry Xu <andiry.xu@gmail.com>

commit 622eb783fe6ff4c1baa47db16c3a5db97f9e6e50 upstream.

When system software decides to power down the xHC with the intent of
resuming operation at a later time, it will ask xHC to save the internal
state and restore it when resume to correctly recover from a power event.
Two bits are used to enable this operation: Save State and Restore State.

xHCI spec 4.23.2 says software should "Set the Controller Save/Restore
State flag in the USBCMD register and wait for the Save/Restore State
Status flag in the USBSTS register to transition to '0'". However, it does
not define how long software should wait for the SSS/RSS bit to transition
to 0.

Currently the timeout is set to 1ms. There is bug report
(https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1002697)
indicates that the timeout is too short for ASMedia ASM1042 host controller
to save/restore the state successfully. Increase the timeout to 10ms helps to
resolve the issue.

This patch should be backported to stable kernels as old as 2.6.37, that
contain the commit 5535b1d5f8885695c6ded783c692e3c0d0eda8ca "USB: xHCI:
PCI power management implementation"

Signed-off-by: Andiry Xu <andiry.xu@gmail.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 1d4958f..a979cd0 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -795,8 +795,8 @@ int xhci_suspend(struct xhci_hcd *xhci)
 	command = xhci_readl(xhci, &xhci->op_regs->command);
 	command |= CMD_CSS;
 	xhci_writel(xhci, command, &xhci->op_regs->command);
-	if (handshake(xhci, &xhci->op_regs->status, STS_SAVE, 0, 10*100)) {
-		xhci_warn(xhci, "WARN: xHC CMD_CSS timeout\n");
+	if (handshake(xhci, &xhci->op_regs->status, STS_SAVE, 0, 10 * 1000)) {
+		xhci_warn(xhci, "WARN: xHC save state timeout\n");
 		spin_unlock_irq(&xhci->lock);
 		return -ETIMEDOUT;
 	}
@@ -848,8 +848,8 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 		command |= CMD_CRS;
 		xhci_writel(xhci, command, &xhci->op_regs->command);
 		if (handshake(xhci, &xhci->op_regs->status,
-			      STS_RESTORE, 0, 10*100)) {
-			xhci_dbg(xhci, "WARN: xHC CMD_CSS timeout\n");
+			      STS_RESTORE, 0, 10 * 1000)) {
+			xhci_warn(xhci, "WARN: xHC restore state timeout\n");
 			spin_unlock_irq(&xhci->lock);
 			return -ETIMEDOUT;
 		}


