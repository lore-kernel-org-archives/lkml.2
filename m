Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab0KBWbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 18:31:44 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:65315 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0KBWbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 18:31:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Kd4yE9GEzm7A242hwgH7wlBvsDg+DGtqs74EOLA10G1KkRUOA1wcAuRLUfAAebFx72
         +Nvru64+/5E5ST1DSAZ6A/h3oiEiRlxMCQCc4bi1LaUsEvv0Bve7nnKGAX1GwV2CzY0W
         aOIDDA44LRmHrHRqeQzyKZO5Slt3qs98IB7TE=
Message-ID: <4CD09166.4060202@lwfinger.net>
Date: Tue, 02 Nov 2010 17:32:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.14) Gecko/20101013 SUSE/3.0.9 Thunderbird/3.0.9
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Regression in 2.6.37-rc1 - logs spammed with "unable to enumerate
 USB port" - bisected to commit 3df7169e
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3df7169e73fc1d71a39cffeacc969f6840cdf52b causes my system to spam the
logs with messages of the form "hub 2-0:1.0: unable to enumerate USB device on
port 5". Bisection was used to locate the faulty commit.


Author: Alan Stern <stern@rowland.harvard.edu>
Date:   Fri Sep 10 16:37:05 2010 -0400

    OHCI: work around for nVidia shutdown problem

    This patch (as1417) fixes a problem affecting some (or all) nVidia
    chipsets.  When the computer is shut down, the OHCI controllers
    continue to power the USB buses and evidently they drive a Reset
    signal out all their ports.  This prevents attached devices from going
    to low power.  Mouse LEDs stay on, for example, which is disconcerting
    for users and a drain on laptop batteries.

    The fix involves leaving each OHCI controller in the OPERATIONAL state
    during system shutdown rather than putting it in the RESET state.
    Although this nominally means the controller is running, in fact it's
    not doing very much since all the schedules are all disabled.  However
    there is ongoing DMA to the Host Controller Communications Area, so
    the patch also disables the bus-master capability of all PCI USB
    controllers after the shutdown routine runs.

    The fix is applied only to nVidia-based PCI OHCI controllers, so it
    shouldn't cause problems on systems using other hardware.  As an added
    safety measure, in case the kernel encounters one of these running
    controllers during boot, the patch changes quirk_usb_handoff_ohci()
    (which runs early on during PCI discovery) to reset the controller
    before anything bad can happen.

    Reported-by: Pali Rohár <pali.rohar@gmail.com>
    Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
    CC: David Brownell <david-b@pacbell.net>
    Tested-by: Pali Rohár <pali.rohar@gmail.com>
    CC: stable <stable@kernel.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

The lspci output for the PCI interfaces of the USB controllers are as follows:

00:02.0 USB Controller [0c03]: nVidia Corporation MCP67 OHCI USB 1.1 Controller
[10de:055e] (rev a2) (prog-if 10 [OHCI])
        Subsystem: Hewlett-Packard Company Device [103c:30d6]
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 17
        Memory at fc486000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [44] Power Management version 2
        Kernel driver in use: ohci_hcd

00:02.1 USB Controller [0c03]: nVidia Corporation MCP67 EHCI USB 2.0 Controller
[10de:055f] (rev a2) (prog-if 20 [EHCI])
        Subsystem: Hewlett-Packard Company Device [103c:30d6]
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 17
        Memory at fc489000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [44] Debug port: BAR=1 offset=0098
        Capabilities: [80] Power Management version 2
        Kernel driver in use: ehci_hcd

00:04.0 USB Controller [0c03]: nVidia Corporation MCP67 OHCI USB 1.1 Controller
[10de:055e] (rev a2) (prog-if 10 [OHCI])
        Subsystem: Hewlett-Packard Company Device [103c:30d6]
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 16
        Memory at fc487000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [44] Power Management version 2
        Kernel driver in use: ohci_hcd

00:04.1 USB Controller [0c03]: nVidia Corporation MCP67 EHCI USB 2.0 Controller
[10de:055f] (rev a2) (prog-if 20 [EHCI])
        Subsystem: Hewlett-Packard Company Device [103c:30d6]
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 16
        Memory at fc489400 (32-bit, non-prefetchable) [size=256]
        Capabilities: [44] Debug port: BAR=1 offset=0098
        Capabilities: [80] Power Management version 2
        Kernel driver in use: ehci_hcd

The problem will go away when the following patch is applied:

Index: linux-realtek/drivers/usb/host/pci-quirks.c
===================================================================
--- linux-realtek.orig/drivers/usb/host/pci-quirks.c
+++ linux-realtek/drivers/usb/host/pci-quirks.c
@@ -203,7 +203,8 @@ static void __devinit quirk_usb_handoff_
 #endif

        /* reset controller, preserving RWC (and possibly IR) */
-       writel(control & OHCI_CTRL_MASK, base + OHCI_CONTROL);
+//     writel(control & OHCI_CTRL_MASK, base + OHCI_CONTROL);
+       dev_warn(&pdev->dev, "OHCI: control value 0x%x\n", control);

        /*
         * disable interrupts

The outputs of that dev_warn statement are

pci 0000:00:02.0: OHCI: control value 0x683
pci 0000:00:04.0: OHCI: control value 0x640

The section of dmesg that concerns the USB system is:

 usbcore: registered new interface driver hub
 usbcore: registered new device driver usb
 ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
 ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 17
 ehci_hcd 0000:00:02.1: PCI INT B -> Link[LUS2] -> GSI 17 (level, low) -> IRQ 17
 ehci_hcd 0000:00:02.1: setting latency timer to 64
 ehci_hcd 0000:00:02.1: EHCI Host Controller
 ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
 ehci_hcd 0000:00:02.1: debug port 1
 ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
 ehci_hcd 0000:00:02.1: irq 17, io mem 0xfc489000
 ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
 hub 1-0:1.0: USB hub found
 hub 1-0:1.0: 5 ports detected
 ACPI: PCI Interrupt Link [Z013] enabled at IRQ 16
 ehci_hcd 0000:00:04.1: PCI INT B -> Link[Z013] -> GSI 16 (level, low) -> IRQ 16
 ehci_hcd 0000:00:04.1: setting latency timer to 64
 ehci_hcd 0000:00:04.1: EHCI Host Controller
 ehci_hcd 0000:00:04.1: new USB bus registered, assigned bus number 2
 ehci_hcd 0000:00:04.1: debug port 1
 ehci_hcd 0000:00:04.1: cache line size of 64 is not supported
 ehci_hcd 0000:00:04.1: irq 16, io mem 0xfc489400
 ehci_hcd 0000:00:04.1: USB 2.0 started, EHCI 1.00
 hub 2-0:1.0: USB hub found
 hub 2-0:1.0: 5 ports detected
 ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
 ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 17
 ohci_hcd 0000:00:02.0: PCI INT A -> Link[LUS0] -> GSI 17 (level, low) -> IRQ 17
 ohci_hcd 0000:00:02.0: setting latency timer to 64
 ohci_hcd 0000:00:02.0: OHCI Host Controller
 ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 3
 ohci_hcd 0000:00:02.0: irq 17, io mem 0xfc486000
 hub 3-0:1.0: USB hub found
 hub 3-0:1.0: 5 ports detected
 ACPI: PCI Interrupt Link [Z012] enabled at IRQ 16
 ohci_hcd 0000:00:04.0: PCI INT A -> Link[Z012] -> GSI 16 (level, low) -> IRQ 16
 ohci_hcd 0000:00:04.0: setting latency timer to 64
 ohci_hcd 0000:00:04.0: OHCI Host Controller
 ohci_hcd 0000:00:04.0: new USB bus registered, assigned bus number 4
 ohci_hcd 0000:00:04.0: irq 16, io mem 0xfc487000
 hub 4-0:1.0: USB hub found
 hub 4-0:1.0: 5 ports detected
 usb 1-1: new high speed USB device using ehci_hcd and address 2
 hub 1-1:1.0: USB hub found
 hub 1-1:1.0: 4 ports detected
 usb 1-4: new high speed USB device using ehci_hcd and address 3
 usb 1-5: new high speed USB device using ehci_hcd and address 4

A majority of the messages (75 %) are for hub 2-0:1.0, with the rest for hub
4-0:1.0. Port 5 is indicated for all of them on both hubs.

Please let me know if you need further info on my system.

Larry


