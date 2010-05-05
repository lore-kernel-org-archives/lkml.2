Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934157Ab0EEPzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 11:55:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55322 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932407Ab0EEPzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 11:55:48 -0400
Date: Wed, 5 May 2010 11:55:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Du, Alek" <alek.du@intel.com>
cc: Ondrej Zary <linux@rainbow-software.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH v2] [RFC] ehci: Disable wake on overcurrent
 (WKOC_E) and disconnect (WKDISC_E)
In-Reply-To: <20100505111245.2c480ea1@dxy2>
Message-ID: <Pine.LNX.4.44L0.1005051144490.1885-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 May 2010, Du, Alek wrote:

> On Fri, 30 Apr 2010 01:45:33 +0800
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> 
> > This patch fixes the problem on my system.  Does it work for you?
> > I still think that disabling wakeup at the PCI or platform level should 
> > override the port wakeup flags, but apparently it doesn't.
> > 
> > Alek, can you confirm that the changes in this patch are okay for the
> > Moorestown EHCI controller?  I had to guess at how to handle the
> > HOSTPCx register settings.
> > 
> > Alan Stern
> 
> 
> Alan,
> 
> As I tested, the patch breaks phy low power mode, the EHCI works, but it never
> enter phy low power mode when suspending port...
> 
> I guess this part of the diff breaks it.
> 
> 
>  -			/* only enable appropriate wake bits, otherwise the
>  -			 * hardware can not go phy low power mode. If a race
>  -			 * condition happens here(connection change during bits
>  -			 * set), the port change detection will finally fix it.
>  -			 */
>  -			if (t1 & PORT_CONNECT) {
>  -				t2 |= PORT_WKOC_E | PORT_WKDISC_E;
>  -				t2 &= ~PORT_WKCONN_E;
>  -			} else {
>  -				t2 |= PORT_WKOC_E | PORT_WKCONN_E;
>  -				t2 &= ~PORT_WKDISC_E;
>  -			}

That seems very odd.  Why should removing code that enables wakeup bits
cause the suspend to fail?  Can't the phy go into low-power mode when
all the wakeup bits are disabled?

Does applying this additional patch on top of the previous one help?

Alan Stern



Index: usb-2.6/drivers/usb/host/ehci-hub.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci-hub.c
+++ usb-2.6/drivers/usb/host/ehci-hub.c
@@ -200,7 +200,7 @@ static int ehci_bus_suspend (struct usb_
 	while (port--) {
 		u32 __iomem	*reg = &ehci->regs->port_status [port];
 		u32		t1 = ehci_readl(ehci, reg) & ~PORT_RWC_BITS;
-		u32		t2 = t1;
+		u32		t2;
 
 		if (ehci->has_hostpc)
 			hostpc_reg = (u32 __iomem *)((u8 *)ehci->regs
@@ -209,6 +209,7 @@ static int ehci_bus_suspend (struct usb_
 		if (t1 & PORT_OWNER)
 			set_bit(port, &ehci->owned_ports);
 		else if ((t1 & PORT_PE) && !(t1 & PORT_SUSPEND)) {
+			t2 = t1 & ~PORT_WAKE_BITS;
 			t2 |= PORT_SUSPEND;
 			set_bit(port, &ehci->bus_suspended);
 			ehci_vdbg (ehci, "port %d, %08x -> %08x\n",

