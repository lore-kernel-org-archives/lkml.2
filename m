Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077Ab0GASYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:24:04 -0400
Received: from kroah.org ([198.145.64.141]:40682 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758050Ab0GASX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:23:59 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:15 2010
Message-Id: <20100701173215.403017080@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:32:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [patch 102/149] USB: xhci: Wait for host to start running.
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit ed07453fd356025cc25272629e982f5e4607632c upstream.

When the run bit is set in the xHCI command register, it may take a few
microseconds for the host to start running.  We cannot ring any doorbells
until the host is actually running, so wait until the status register says
the host is running.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reported-by: Shinya Saito <shinya.saito.sx@renesas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-hcd.c |   39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

--- a/drivers/usb/host/xhci-hcd.c
+++ b/drivers/usb/host/xhci-hcd.c
@@ -97,6 +97,33 @@ int xhci_halt(struct xhci_hcd *xhci)
 }
 
 /*
+ * Set the run bit and wait for the host to be running.
+ */
+int xhci_start(struct xhci_hcd *xhci)
+{
+	u32 temp;
+	int ret;
+
+	temp = xhci_readl(xhci, &xhci->op_regs->command);
+	temp |= (CMD_RUN);
+	xhci_dbg(xhci, "// Turn on HC, cmd = 0x%x.\n",
+			temp);
+	xhci_writel(xhci, temp, &xhci->op_regs->command);
+
+	/*
+	 * Wait for the HCHalted Status bit to be 0 to indicate the host is
+	 * running.
+	 */
+	ret = handshake(xhci, &xhci->op_regs->status,
+			STS_HALT, 0, XHCI_MAX_HALT_USEC);
+	if (ret == -ETIMEDOUT)
+		xhci_err(xhci, "Host took too long to start, "
+				"waited %u microseconds.\n",
+				XHCI_MAX_HALT_USEC);
+	return ret;
+}
+
+/*
  * Reset a halted HC, and set the internal HC state to HC_STATE_HALT.
  *
  * This resets pipelines, timers, counters, state machines, etc.
@@ -460,13 +487,11 @@ int xhci_run(struct usb_hcd *hcd)
 	if (NUM_TEST_NOOPS > 0)
 		doorbell = xhci_setup_one_noop(xhci);
 
-	temp = xhci_readl(xhci, &xhci->op_regs->command);
-	temp |= (CMD_RUN);
-	xhci_dbg(xhci, "// Turn on HC, cmd = 0x%x.\n",
-			temp);
-	xhci_writel(xhci, temp, &xhci->op_regs->command);
-	/* Flush PCI posted writes */
-	temp = xhci_readl(xhci, &xhci->op_regs->command);
+	if (xhci_start(xhci)) {
+		xhci_halt(xhci);
+		return -ENODEV;
+	}
+
 	xhci_dbg(xhci, "// @%p = 0x%x\n", &xhci->op_regs->command, temp);
 	if (doorbell)
 		(*doorbell)(xhci);


