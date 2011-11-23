Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab1KWAgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:36:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42466 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932532Ab1KWAfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:35:54 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:25:56 2011
Message-Id: <20111123002556.016284343@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:25:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [33/53] USB: XHCI: resume root hubs when the controller resumes
In-Reply-To: <20111123002601.GA14467@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit f69e3120df82391a0ee8118e0a156239a06b2afb upstream.

This patch (as1494) fixes a problem in xhci-hcd's resume routine.
When the controller is runtime-resumed, this can only mean that one of
the two root hubs has made a wakeup request and therefore needs to be
resumed as well.  Rather than try to determine which root hub requires
attention (which might be difficult in the case where a new
non-SuperSpeed device has been plugged in), the patch simply resumes
both root hubs.

Without this change, there is a race: The controller might be put back
to sleep before it can activate its IRQ line, and the wakeup condition
might never get handled.

The patch also simplifies the logic in xhci_resume a little, combining
some repeated flag settings into a single pair of statements.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Tested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -749,7 +749,7 @@ int xhci_resume(struct xhci_hcd *xhci, b
 	u32			command, temp = 0;
 	struct usb_hcd		*hcd = xhci_to_hcd(xhci);
 	struct usb_hcd		*secondary_hcd;
-	int			retval;
+	int			retval = 0;
 
 	/* Wait a bit if either of the roothubs need to settle from the
 	 * transition into bus suspend.
@@ -759,6 +759,9 @@ int xhci_resume(struct xhci_hcd *xhci, b
 				xhci->bus_state[1].next_statechange))
 		msleep(100);
 
+	set_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
+	set_bit(HCD_FLAG_HW_ACCESSIBLE, &xhci->shared_hcd->flags);
+
 	spin_lock_irq(&xhci->lock);
 	if (xhci->quirks & XHCI_RESET_ON_RESUME)
 		hibernated = true;
@@ -828,20 +831,13 @@ int xhci_resume(struct xhci_hcd *xhci, b
 			return retval;
 		xhci_dbg(xhci, "Start the primary HCD\n");
 		retval = xhci_run(hcd->primary_hcd);
-		if (retval)
-			goto failed_restart;
-
-		xhci_dbg(xhci, "Start the secondary HCD\n");
-		retval = xhci_run(secondary_hcd);
 		if (!retval) {
-			set_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
-			set_bit(HCD_FLAG_HW_ACCESSIBLE,
-					&xhci->shared_hcd->flags);
+			xhci_dbg(xhci, "Start the secondary HCD\n");
+			retval = xhci_run(secondary_hcd);
 		}
-failed_restart:
 		hcd->state = HC_STATE_SUSPENDED;
 		xhci->shared_hcd->state = HC_STATE_SUSPENDED;
-		return retval;
+		goto done;
 	}
 
 	/* step 4: set Run/Stop bit */
@@ -860,11 +856,14 @@ failed_restart:
 	 * Running endpoints by ringing their doorbells
 	 */
 
-	set_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
-	set_bit(HCD_FLAG_HW_ACCESSIBLE, &xhci->shared_hcd->flags);
-
 	spin_unlock_irq(&xhci->lock);
-	return 0;
+
+ done:
+	if (retval == 0) {
+		usb_hcd_resume_root_hub(hcd);
+		usb_hcd_resume_root_hub(xhci->shared_hcd);
+	}
+	return retval;
 }
 #endif	/* CONFIG_PM */
 


