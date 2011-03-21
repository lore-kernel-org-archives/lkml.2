Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab1CUX2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:28:45 -0400
Received: from kroah.org ([198.145.64.141]:52619 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932265Ab1CUXR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:17:57 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:25 2011
Message-Id: <20110321230325.078694429@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:01:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Matthew Garrett <mjg@redhat.com>
Subject: [33/78] ehci: Check individual port status registers on resume
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matthew Garrett <mjg@redhat.com>

commit 294d95f2cbc2aef5346258f216cd9df570e271a5 upstream.

If a device plug/unplug is detected on an ATI SB700 USB controller in D3,
it appears to set the port status register but not the controller status
register. As a result we'll fail to detect the plug event. Check the port
status register on resume as well in order to catch this case.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-hub.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -106,6 +106,27 @@ static void ehci_handover_companion_port
 	ehci->owned_ports = 0;
 }
 
+static int ehci_port_change(struct ehci_hcd *ehci)
+{
+	int i = HCS_N_PORTS(ehci->hcs_params);
+
+	/* First check if the controller indicates a change event */
+
+	if (ehci_readl(ehci, &ehci->regs->status) & STS_PCD)
+		return 1;
+
+	/*
+	 * Not all controllers appear to update this while going from D3 to D0,
+	 * so check the individual port status registers as well
+	 */
+
+	while (i--)
+		if (ehci_readl(ehci, &ehci->regs->port_status[i]) & PORT_CSC)
+			return 1;
+
+	return 0;
+}
+
 static void ehci_adjust_port_wakeup_flags(struct ehci_hcd *ehci,
 		bool suspending, bool do_wakeup)
 {
@@ -173,7 +194,7 @@ static void ehci_adjust_port_wakeup_flag
 	}
 
 	/* Does the root hub have a port wakeup pending? */
-	if (!suspending && (ehci_readl(ehci, &ehci->regs->status) & STS_PCD))
+	if (!suspending && ehci_port_change(ehci))
 		usb_hcd_resume_root_hub(ehci_to_hcd(ehci));
 
 	spin_unlock_irqrestore(&ehci->lock, flags);


