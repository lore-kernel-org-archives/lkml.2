Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab0EFOqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 10:46:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43451 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753333Ab0EFOqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 10:46:48 -0400
Date: Thu, 6 May 2010 10:46:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Du, Alek" <alek.du@intel.com>
cc: Ondrej Zary <linux@rainbow-software.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: RE: [linux-pm] [PATCH v2] [RFC] ehci: Disable wake on overcurrent
 (WKOC_E) and disconnect (WKDISC_E)
In-Reply-To: <1865303E0DED764181A9D882DEF65FB61A82A6DA3B@shsmsx502.ccr.corp.intel.com>
Message-ID: <Pine.LNX.4.44L0.1005061013510.1708-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 May 2010, Du, Alek wrote:

> Alan,
> 
> This would be better, but before entering phy low power mode, the HW
> need the exact wakeup bits to be set, that's why we have:
> 
> 			/* only enable appropriate wake bits, otherwise the
> 			 * hardware can not go phy low power mode. If a race
> 			 * condition happens here(connection change during bits
> 			 * set), the port change detection will finally fix it.
> 			 */
> In the code. When port is connected, we must only enable PORT_WKOC_E
> | PORT_WKDISC_E, and when port is disconnected, we must only enable
> PORT_WKOC_E | PORT_WKCONN_E. Enable all wakeup bits won't work.

With this patch, _none_ of the wakeup bits are enabled.  That should
work, right?

But it leads to another question: Later on, when the controller is put
into D3hot, the new code will try to turn on wakeup bits for ports that
have already been suspended.  It should be safe because
ehci_set_wakeup_flags() will enable PORT_WKDISC_E | PORT_WKOC_E for
connected ports, and PORT_WKCONN_E | PORT_WKOC_E for unconnected ports.  
Still, since this happens _after_ the ports are suspended and the phy
is put into low-power mode, I wanted to check with you about it.

> I think the problem is: For the original code, once t2 != t1, the HCD
> will try to put into phy low power mode. While after the patch, the
> HCD will only enter phy low power mode if PORT_PE is set and
> PORT_SUSPEND is not set.

Okay, I understand.  Then consider _this_ patch on top of the first 
one.  It sets the hostpc register for every port that wasn't already 
suspended, so each phy should end up in low-power mode.

Alan Stern



Index: usb-2.6/drivers/usb/host/ehci-hub.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci-hub.c
+++ usb-2.6/drivers/usb/host/ehci-hub.c
@@ -152,7 +152,6 @@ static int ehci_bus_suspend (struct usb_
 	struct ehci_hcd		*ehci = hcd_to_ehci (hcd);
 	int			port;
 	int			mask;
-	u32 __iomem		*hostpc_reg = NULL;
 
 	ehci_dbg(ehci, "suspend root hub\n");
 
@@ -200,23 +199,25 @@ static int ehci_bus_suspend (struct usb_
 	while (port--) {
 		u32 __iomem	*reg = &ehci->regs->port_status [port];
 		u32		t1 = ehci_readl(ehci, reg) & ~PORT_RWC_BITS;
-		u32		t2 = t1;
+		u32		t2 = t1 & ~PORT_WAKE_BITS;
 
-		if (ehci->has_hostpc)
-			hostpc_reg = (u32 __iomem *)((u8 *)ehci->regs
-				+ HOSTPC0 + 4 * (port & 0xff));
 		/* keep track of which ports we suspend */
-		if (t1 & PORT_OWNER)
-			set_bit(port, &ehci->owned_ports);
-		else if ((t1 & PORT_PE) && !(t1 & PORT_SUSPEND)) {
-			t2 |= PORT_SUSPEND;
-			set_bit(port, &ehci->bus_suspended);
-			ehci_vdbg (ehci, "port %d, %08x -> %08x\n",
-				port + 1, t1, t2);
-			ehci_writel(ehci, t2, reg);
-			if (hostpc_reg) {
-				u32	t3;
+		if (!(t1 & PORT_SUSPEND)) {
+			if (t1 & PORT_OWNER) {
+				set_bit(port, &ehci->owned_ports);
+			} else if (t1 & PORT_PE) {
+				t2 |= PORT_SUSPEND;
+				set_bit(port, &ehci->bus_suspended);
+				ehci_vdbg (ehci, "port %d, %08x -> %08x\n",
+					port + 1, t1, t2);
+				ehci_writel(ehci, t2, reg);
+			}
+			if (ehci->has_hostpc) {
+				u32 __iomem	*hostpc_reg;
+				u32		t3;
 
+				hostpc_reg = (u32 __iomem *)((u8 *)ehci->regs
+					+ HOSTPC0 + 4 * (port & 0xff));
 				spin_unlock_irq(&ehci->lock);
 				msleep(5);/* 5ms for HCD enter low pwr mode */
 				spin_lock_irq(&ehci->lock);

