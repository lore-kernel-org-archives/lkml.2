Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547Ab1BPA0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:26:06 -0500
Received: from kroah.org ([198.145.64.141]:49968 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932512Ab1BPAZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:25:43 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:51 2011
Message-Id: <20110216001451.884605870@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:15:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [268/272] xhci: Resume bus on any port status change.
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 7111ebc97ed53a32314011c85a6f235f0dab8ae8 upstream.

The original code that resumed the USB bus on a port status change would
only do so when there was a device connected to the port.  If a device was
just disconnected, the event would be queued for khubd, but khubd wouldn't
run.  That would leave the connect status change (CSC) bit set.

If a USB device was plugged into that same port, the xHCI host controller
would set the current connect status (CCS) bit.  But since the CSC bit was
already set, it would not generate an interrupt for a port status change
event.  That would mean the user could "Safely Remove" a device, have the
bus suspend, disconnect the device, re-plug it in, and then the device
would never be enumerated.

Plugging in a different device on another port would cause the bus to
resume, and khubd would notice the re-connected device.  Running lsusb
would also resume the bus, leading users to report the problem "went away"
when using diagnostic tools.

The solution is to resume the bus when a port status change event is
received, regardless of the port status.

Thank you very much to Maddog for helping me track down this Heisenbug.

This patch should be queued for the 2.6.37 stable tree.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reported-by: Jon 'maddog' Hall <maddog@li.org>
Tested-by: Andiry Xu <andiry.xu@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1188,7 +1188,7 @@ static void handle_port_status(struct xh
 
 	addr = &xhci->op_regs->port_status_base + NUM_PORT_REGS * (port_id - 1);
 	temp = xhci_readl(xhci, addr);
-	if ((temp & PORT_CONNECT) && (hcd->state == HC_STATE_SUSPENDED)) {
+	if (hcd->state == HC_STATE_SUSPENDED) {
 		xhci_dbg(xhci, "resume root hub\n");
 		usb_hcd_resume_root_hub(hcd);
 	}


