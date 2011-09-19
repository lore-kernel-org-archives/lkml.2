Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864Ab1ISXKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 19:10:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55327 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932686Ab1ISXK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 19:10:27 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Sep 19 16:08:33 2011
Message-Id: <20110919230833.469891151@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 19 Sep 2011 16:05:11 -0700
From: Greg KH <gregkh@suse.de>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, stable@kernel.org
Cc: Andiry Xu <andiry.xu@amd.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Subject: [patch 2/3] USB: xhci: Set change bit when warm reset change is set.
In-Reply-To: <20110919230920.GA6555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes, when a USB 3.0 device is disconnected, the Intel Panther Point
xHCI host controller will report a link state change with the state set
to "SS.Inactive".  This causes the xHCI host controller to issue a warm
port reset, which doesn't finish before the USB core times out while
waiting for it to complete.

When the warm port reset does complete, and the xHC gives back a port
status change event, the xHCI driver kicks khubd.  However, it fails to
set the bit indicating there is a change event for that port because the
logic in xhci-hub.c doesn't check for the warm port reset bit.

After that, the warm port status change bit is never cleared by the USB
core, and the xHC stops reporting port status change bits.  (The xHCI spec
says it shouldn't report more port events until all change bits are
cleared.)  This means any port changes when a new device is connected will
never be reported, and the port will seem "dead" until the xHCI driver is
unloaded and reloaded, or the computer is rebooted.  Fix this by making
the xHCI driver set the port change bit when a warm port reset change bit
is set.

A better solution would be to make the USB core handle warm port reset in
differently, merging the current code with the standard port reset code
that does an incremental backoff on the timeout, and tries to complete the
port reset two more times before giving up.  That more complicated fix
will be merged next window, and this fix will be backported to stable.

This should be backported to kernels as old as 3.0, since that was the
first kernel with commit a11496ebf37534177d67222285e8debed7a39788
"xHCI: warm reset support".

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-hub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -761,7 +761,7 @@ int xhci_hub_status_data(struct usb_hcd
 	memset(buf, 0, retval);
 	status = 0;
 
-	mask = PORT_CSC | PORT_PEC | PORT_OCC | PORT_PLC;
+	mask = PORT_CSC | PORT_PEC | PORT_OCC | PORT_PLC | PORT_WRC;
 
 	spin_lock_irqsave(&xhci->lock, flags);
 	/* For each port, did anything change?  If so, set that bit in buf. */


