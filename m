Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab2E1Dvs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:51:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51941 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753599Ab2E1D3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:15 -0400
Message-Id: <20120528031209.091493588@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:47 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 045/117] xhci: Add Lynx Point to list of Intel switchable hosts.
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 1c12443ab8eba71a658fae4572147e56d1f84f66 upstream.

The upcoming Intel Lynx Point chipset includes an xHCI host controller
that can have ports switched from the EHCI host controller, just like
the Intel Panther Point xHCI host.  This time, ports from both EHCI
hosts can be switched to the xHCI host controller.  The PCI config
registers to do the port switching are in the exact same place in the
xHCI PCI configuration registers, with the same semantics.

Hooray for shipping patches for next-gen hardware before the current gen
hardware is even available for purchase!

This patch should be backported to stable kernels as old as 3.0,
that contain commit 69e848c2090aebba5698a1620604c7dccb448684
"Intel xhci: Support EHCI/xHCI port switching."

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/ehci-pci.c   |    4 +++-
 drivers/usb/host/pci-quirks.c |   18 +++++++++++++++++-
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index 01bb7241d..1234817 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -360,7 +360,9 @@ static bool usb_is_intel_switchable_ehci(struct pci_dev *pdev)
 {
 	return pdev->class == PCI_CLASS_SERIAL_USB_EHCI &&
 		pdev->vendor == PCI_VENDOR_ID_INTEL &&
-		pdev->device == 0x1E26;
+		(pdev->device == 0x1E26 ||
+		 pdev->device == 0x8C2D ||
+		 pdev->device == 0x8C26);
 }
 
 static void ehci_enable_xhci_companion(void)
diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index 39b2612..df0828c 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -713,12 +713,28 @@ static int handshake(void __iomem *ptr, u32 mask, u32 done,
 	return -ETIMEDOUT;
 }
 
-bool usb_is_intel_switchable_xhci(struct pci_dev *pdev)
+#define PCI_DEVICE_ID_INTEL_LYNX_POINT_XHCI	0x8C31
+
+bool usb_is_intel_ppt_switchable_xhci(struct pci_dev *pdev)
 {
 	return pdev->class == PCI_CLASS_SERIAL_USB_XHCI &&
 		pdev->vendor == PCI_VENDOR_ID_INTEL &&
 		pdev->device == PCI_DEVICE_ID_INTEL_PANTHERPOINT_XHCI;
 }
+
+/* The Intel Lynx Point chipset also has switchable ports. */
+bool usb_is_intel_lpt_switchable_xhci(struct pci_dev *pdev)
+{
+	return pdev->class == PCI_CLASS_SERIAL_USB_XHCI &&
+		pdev->vendor == PCI_VENDOR_ID_INTEL &&
+		pdev->device == PCI_DEVICE_ID_INTEL_LYNX_POINT_XHCI;
+}
+
+bool usb_is_intel_switchable_xhci(struct pci_dev *pdev)
+{
+	return usb_is_intel_ppt_switchable_xhci(pdev) ||
+		usb_is_intel_lpt_switchable_xhci(pdev);
+}
 EXPORT_SYMBOL_GPL(usb_is_intel_switchable_xhci);
 
 /*


