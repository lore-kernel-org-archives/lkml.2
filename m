Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab1FPHdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:33:18 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:56914 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755825Ab1FPHBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:01:19 -0400
X-Sasl-enc: lDIdMHOjW+KDd5ZeqcegFkHyq6qlb0yUrYxVwdhsO8yx 1308207678
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:35 2011
Message-Id: <20110616000235.083305813@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [62/89] xhci: Disable MSI for some Fresco Logic hosts.
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit f5182b4155b9d686c5540a6822486400e34ddd98 upstream.

Some Fresco Logic hosts, including those found in the AUAU N533V laptop,
advertise MSI, but fail to actually generate MSI interrupts.  Add a new
xHCI quirk to skip MSI enabling for the Fresco Logic host controllers.
Fresco Logic confirms that all chips with PCI vendor ID 0x1b73 and device
ID 0x1000, regardless of PCI revision ID, do not support MSI.

This should be backported to stable kernels as far back as 2.6.36, which
was the first kernel to support MSI on xHCI hosts.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reported-by: Sergey Galanov <sergey.e.galanov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-pci.c |   14 ++++++++++++--
 drivers/usb/host/xhci.c     |    7 +++++++
 drivers/usb/host/xhci.h     |    1 +
 3 files changed, 20 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -105,12 +105,22 @@ static int xhci_pci_setup(struct usb_hcd
 
 	/* Look for vendor-specific quirks */
 	if (pdev->vendor == PCI_VENDOR_ID_FRESCO_LOGIC &&
-			pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_PDK &&
-			pdev->revision == 0x0) {
+			pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_PDK) {
+		if (pdev->revision == 0x0) {
 			xhci->quirks |= XHCI_RESET_EP_QUIRK;
 			xhci_dbg(xhci, "QUIRK: Fresco Logic xHC needs configure"
 					" endpoint cmd after reset endpoint\n");
+		}
+		/* Fresco Logic confirms: all revisions of this chip do not
+		 * support MSI, even though some of them claim to in their PCI
+		 * capabilities.
+		 */
+		xhci->quirks |= XHCI_BROKEN_MSI;
+		xhci_dbg(xhci, "QUIRK: Fresco Logic revision %u "
+				"has broken MSI implementation\n",
+				pdev->revision);
 	}
+
 	if (pdev->vendor == PCI_VENDOR_ID_NEC)
 		xhci->quirks |= XHCI_NEC_HOST;
 
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -430,12 +430,19 @@ int xhci_run(struct usb_hcd *hcd)
 		free_irq(hcd->irq, hcd);
 	hcd->irq = -1;
 
+	/* Some Fresco Logic host controllers advertise MSI, but fail to
+	 * generate interrupts.  Don't even try to enable MSI.
+	 */
+	if (xhci->quirks & XHCI_BROKEN_MSI)
+		goto legacy_irq;
+
 	ret = xhci_setup_msix(xhci);
 	if (ret)
 		/* fall back to msi*/
 		ret = xhci_setup_msi(xhci);
 
 	if (ret) {
+legacy_irq:
 		/* fall back to legacy interrupt*/
 		ret = request_irq(pdev->irq, &usb_hcd_irq, IRQF_SHARED,
 					hcd->irq_descr, hcd);
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1286,6 +1286,7 @@ struct xhci_hcd {
 #define XHCI_RESET_EP_QUIRK	(1 << 1)
 #define XHCI_NEC_HOST		(1 << 2)
 #define XHCI_AMD_PLL_FIX	(1 << 3)
+#define XHCI_BROKEN_MSI		(1 << 6)
 	/* There are two roothubs to keep track of bus suspend info for */
 	struct xhci_bus_state   bus_state[2];
 	/* Is each xHCI roothub port a USB 3.0, USB 2.0, or USB 1.1 port? */


