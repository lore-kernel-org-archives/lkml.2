Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965427Ab2CAVuX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:50:23 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46239 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965266Ab2CAVuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:50:19 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.130.7 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120301213925.657021504@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Thu, 01 Mar 2012 13:39:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Oliver Neukum <oneukum@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [ 21/34] USB: Fix handoff when BIOS disables host PCI device.
In-Reply-To: <20120301214654.GA13231@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit cab928ee1f221c9cc48d6615070fefe2e444384a upstream.

On some systems with an Intel Panther Point xHCI host controller, the
BIOS disables the xHCI PCI device during boot, and switches the xHCI
ports over to EHCI.  This allows the BIOS to access USB devices without
having xHCI support.

The downside is that the xHCI BIOS handoff mechanism will fail because
memory mapped I/O is not enabled for the disabled PCI device.
Jesse Barnes says this is expected behavior.  The PCI core will enable
BARs before quirks run, but it will leave it in an undefined state, and
it may not have memory mapped I/O enabled.

Make the generic USB quirk handler call pci_enable_device() to re-enable
MMIO, and call pci_disable_device() once the host-specific BIOS handoff
is finished.  This will balance the ref counts in the PCI core.  When
the PCI probe function is called, usb_hcd_pci_probe() will call
pci_enable_device() again.

This should be back ported to kernels as old as 2.6.31.  That was the
first kernel with xHCI support, and no one has complained about BIOS
handoffs failing due to memory mapped I/O being disabled on other hosts
(EHCI, UHCI, or OHCI).

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Acked-by: Oliver Neukum <oneukum@suse.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/pci-quirks.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -503,7 +503,17 @@ static void __devinit quirk_usb_early_ha
 	 */
 	if (pdev->vendor == 0x184e)	/* vendor Netlogic */
 		return;
+	if (pdev->class != PCI_CLASS_SERIAL_USB_UHCI &&
+			pdev->class != PCI_CLASS_SERIAL_USB_OHCI &&
+			pdev->class != PCI_CLASS_SERIAL_USB_EHCI &&
+			pdev->class != PCI_CLASS_SERIAL_USB_XHCI)
+		return;
 
+	if (pci_enable_device(pdev) < 0) {
+		dev_warn(&pdev->dev, "Can't enable PCI device, "
+				"BIOS handoff failed.\n");
+		return;
+	}
 	if (pdev->class == PCI_CLASS_SERIAL_USB_UHCI)
 		quirk_usb_handoff_uhci(pdev);
 	else if (pdev->class == PCI_CLASS_SERIAL_USB_OHCI)
@@ -512,5 +522,6 @@ static void __devinit quirk_usb_early_ha
 		quirk_usb_disable_ehci(pdev);
 	else if (pdev->class == PCI_CLASS_SERIAL_USB_XHCI)
 		quirk_usb_handoff_xhci(pdev);
+	pci_disable_device(pdev);
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, quirk_usb_early_handoff);


