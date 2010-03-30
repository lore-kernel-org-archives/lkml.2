Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab0CaAlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:41:52 -0400
Received: from kroah.org ([198.145.64.141]:48410 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755570Ab0C3XIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:08:55 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:49:45 2010
Message-Id: <20100330224945.416568413@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Corey Wright <undefined@pobox.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [10/45] EHCI: fix bug in keeping track of resuming ports
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------


This patch fixes a bug caused by backporting commit
cec3a53c7fe794237b582e8e77fc0e48465e65ee (USB: EHCI & UHCI: fix race
between root-hub suspend and port resume) to 2.6.27.stable without
also backporting commit eafe5b99f2135488b21cf17a262c54997c44f784 (USB:
EHCI: fix remote-wakeup support for ARC/TDI core).  This extracts the
necessary changes from the earlier patch and backports them.

The symptom of the bug is that the system will fail to suspend more
than once.  The problem is caused by setting ehci->reset_done[i] but
never clearing it.  When ehci_bus_suspend() sees a nonzero value
there, it assumes this means the port is in the middle of resuming so
it aborts the bus suspend.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Corey Wright <undefined@pobox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-hub.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -254,10 +254,8 @@ static int ehci_bus_resume (struct usb_h
 		temp = ehci_readl(ehci, &ehci->regs->port_status [i]);
 		temp &= ~(PORT_RWC_BITS | PORT_WAKE_BITS);
 		if (test_bit(i, &ehci->bus_suspended) &&
-				(temp & PORT_SUSPEND)) {
-			ehci->reset_done [i] = jiffies + msecs_to_jiffies (20);
+				(temp & PORT_SUSPEND))
 			temp |= PORT_RESUME;
-		}
 		ehci_writel(ehci, temp, &ehci->regs->port_status [i]);
 	}
 	i = HCS_N_PORTS (ehci->hcs_params);
@@ -752,6 +750,9 @@ static int ehci_hub_control (
 					ehci_readl(ehci, status_reg));
 		}
 
+		if (!(temp & (PORT_RESUME|PORT_RESET)))
+			ehci->reset_done[wIndex] = 0;
+
 		/* transfer dedicated ports to the companion hc */
 		if ((temp & PORT_CONNECT) &&
 				test_bit(wIndex, &ehci->companion_ports)) {


