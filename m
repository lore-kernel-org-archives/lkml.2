Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034Ab0GAUwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:52:46 -0400
Received: from kroah.org ([198.145.64.141]:47790 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932802Ab0GAUvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:51:03 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:36 2010
Message-Id: <20100701173436.572142632@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:35:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [patch 116/164] USB: xhci: Wait for controller to be ready after reset.
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 2d62f3eea98354d61f90d6b115eecf9be5f4bdfe upstream.

After software resets an xHCI host controller, it must wait for the
"Controller Not Ready" (CNR) bit in the status register to be cleared.
Software is not supposed to ring any doorbells or write to any registers
except the status register until this bit is cleared.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-hcd.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-hcd.c
+++ b/drivers/usb/host/xhci-hcd.c
@@ -141,6 +141,7 @@ int xhci_reset(struct xhci_hcd *xhci)
 {
 	u32 command;
 	u32 state;
+	int ret;
 
 	state = xhci_readl(xhci, &xhci->op_regs->status);
 	if ((state & STS_HALT) == 0) {
@@ -155,7 +156,17 @@ int xhci_reset(struct xhci_hcd *xhci)
 	/* XXX: Why does EHCI set this here?  Shouldn't other code do this? */
 	xhci_to_hcd(xhci)->state = HC_STATE_HALT;
 
-	return handshake(xhci, &xhci->op_regs->command, CMD_RESET, 0, 250 * 1000);
+	ret = handshake(xhci, &xhci->op_regs->command,
+			CMD_RESET, 0, 250 * 1000);
+	if (ret)
+		return ret;
+
+	xhci_dbg(xhci, "Wait for controller to be ready for doorbell rings\n");
+	/*
+	 * xHCI cannot write to any doorbells or operational registers other
+	 * than status until the "Controller Not Ready" flag is cleared.
+	 */
+	return handshake(xhci, &xhci->op_regs->status, STS_CNR, 0, 250 * 1000);
 }
 
 


