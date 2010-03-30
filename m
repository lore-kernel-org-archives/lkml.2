Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689Ab0CaA2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:28:22 -0400
Received: from kroah.org ([198.145.64.141]:48914 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755992Ab0C3XMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:22 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:29 2010
Message-Id: <20100330225828.832053695@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [33/89] USB: EHCI & UHCI: fix race between root-hub suspend and port resume
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit cec3a53c7fe794237b582e8e77fc0e48465e65ee upstream.

This patch (as1321) fixes a problem with EHCI and UHCI root-hub
suspends: If the suspend occurs while a port is trying to resume, the
resume doesn't finish and simply gets lost.  When remote wakeup is
enabled, this is undesirable behavior.

The patch checks first to see if any port resumes are in progress, and
if they are then it fails the root-hub suspend with -EBUSY.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-hub.c |   20 +++++++++++++++++++-
 drivers/usb/host/uhci-hcd.c |   15 ++++++++++++++-
 2 files changed, 33 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -119,9 +119,26 @@ static int ehci_bus_suspend (struct usb_
 	del_timer_sync(&ehci->watchdog);
 	del_timer_sync(&ehci->iaa_watchdog);
 
-	port = HCS_N_PORTS (ehci->hcs_params);
 	spin_lock_irq (&ehci->lock);
 
+	/* Once the controller is stopped, port resumes that are already
+	 * in progress won't complete.  Hence if remote wakeup is enabled
+	 * for the root hub and any ports are in the middle of a resume or
+	 * remote wakeup, we must fail the suspend.
+	 */
+	if (hcd->self.root_hub->do_remote_wakeup) {
+		port = HCS_N_PORTS(ehci->hcs_params);
+		while (port--) {
+			if (ehci->reset_done[port] != 0) {
+				spin_unlock_irq(&ehci->lock);
+				ehci_dbg(ehci, "suspend failed because "
+						"port %d is resuming\n",
+						port + 1);
+				return -EBUSY;
+			}
+		}
+	}
+
 	/* stop schedules, clean any completed work */
 	if (HC_IS_RUNNING(hcd->state)) {
 		ehci_quiesce (ehci);
@@ -137,6 +154,7 @@ static int ehci_bus_suspend (struct usb_
 	 */
 	ehci->bus_suspended = 0;
 	ehci->owned_ports = 0;
+	port = HCS_N_PORTS(ehci->hcs_params);
 	while (port--) {
 		u32 __iomem	*reg = &ehci->regs->port_status [port];
 		u32		t1 = ehci_readl(ehci, reg) & ~PORT_RWC_BITS;
--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -749,7 +749,20 @@ static int uhci_rh_suspend(struct usb_hc
 	spin_lock_irq(&uhci->lock);
 	if (!test_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags))
 		rc = -ESHUTDOWN;
-	else if (!uhci->dead)
+	else if (uhci->dead)
+		;		/* Dead controllers tell no tales */
+
+	/* Once the controller is stopped, port resumes that are already
+	 * in progress won't complete.  Hence if remote wakeup is enabled
+	 * for the root hub and any ports are in the middle of a resume or
+	 * remote wakeup, we must fail the suspend.
+	 */
+	else if (hcd->self.root_hub->do_remote_wakeup &&
+			uhci->resuming_ports) {
+		dev_dbg(uhci_dev(uhci), "suspend failed because a port "
+				"is resuming\n");
+		rc = -EBUSY;
+	} else
 		suspend_rh(uhci, UHCI_RH_SUSPENDED);
 	spin_unlock_irq(&uhci->lock);
 	return rc;


