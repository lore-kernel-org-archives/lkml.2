Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab2KSQlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 11:41:35 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:52276 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753774Ab2KSQld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 11:41:33 -0500
Date: Mon, 19 Nov 2012 11:41:33 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Udo van den Heuvel <udovdh@xs4all.nl>
cc: linux-usb@vger.kernel.org, Jan Ceuleers <jan.ceuleers@computer.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Simon Jones <sijones2010@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: 3.4.4: disabling irq
In-Reply-To: <50A7849C.6080502@xs4all.nl>
Message-ID: <Pine.LNX.4.44L0.1211191139140.1598-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Nov 2012, Udo van den Heuvel wrote:

> The problem still happens. irq 18 is dsiabled every now and then.
> This time on different, new hardware.
> The motherboard is now a Gigabyte F2A85X-UP4.
> Camera is the same pwc cam.
> 
> Recently I removed the USB printer that was attached to the same USB
> controller.
> So probably it is not a hardware issue related to board or printer.
> 
> How to proceed next?

Firstly, what does /proc/interrupts say?

Secondly, try building a kernel with the patch below and 
CONFIG_USB_DEBUG enabled.  Let's see what the dmesg log says when the 
problem occurs.

Alan Stern



Index: usb-3.7/drivers/usb/host/ohci-hcd.c
===================================================================
--- usb-3.7.orig/drivers/usb/host/ohci-hcd.c
+++ usb-3.7/drivers/usb/host/ohci-hcd.c
@@ -777,6 +777,7 @@ static irqreturn_t ohci_irq (struct usb_
 	struct ohci_hcd		*ohci = hcd_to_ohci (hcd);
 	struct ohci_regs __iomem *regs = ohci->regs;
 	int			ints;
+	int			i, j;
 
 	/* Read interrupt status (and flush pending writes).  We ignore the
 	 * optimization of checking the LSB of hcca->done_head; it doesn't
@@ -795,11 +796,15 @@ static irqreturn_t ohci_irq (struct usb_
 	}
 
 	/* We only care about interrupts that are enabled */
-	ints &= ohci_readl(ohci, &regs->intrenable);
+	i = ints;
+	j = ohci_readl(ohci, &regs->intrenable);
+	ints &= j;
 
 	/* interrupt for some other device? */
-	if (ints == 0 || unlikely(ohci->rh_state == OHCI_RH_HALTED))
+	if (ints == 0 || unlikely(ohci->rh_state == OHCI_RH_HALTED)) {
+		ohci_dbg(ohci, "IRQ: %x %x\n", i, j);
 		return IRQ_NOTMINE;
+	}
 
 	if (ints & OHCI_INTR_UE) {
 		// e.g. due to PCI Master/Target Abort

