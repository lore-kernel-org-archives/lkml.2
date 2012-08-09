Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142Ab2HIJcC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 05:32:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37245 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab2HIJb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 05:31:59 -0400
From: Keng-Yu Lin <kengyu@canonical.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Keng-Yu Lin <kengyu@canonical.com>
Subject: [PATCH] Intel xhci: Only switch the switchable ports
Date: Thu,  9 Aug 2012 17:31:51 +0800
Message-Id: <1344504711-10916-1-git-send-email-kengyu@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a previous patch to enable the EHCI/XHCI port switching, it switches
all the available ports.

The assumption is not correct because the BIOS may expect some ports
not switchable by the OS.

There are two more registers that contains the information of the switchable
and non-switchable ports.

This patch adds the checking code for the two register so that only the
switchable ports are altered.

Signed-off-by: Keng-Yu Lin <kengyu@canonical.com>
---
 drivers/usb/host/pci-quirks.c |   27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index 833b3c6..89f62f2 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -75,7 +75,9 @@
 #define	NB_PIF0_PWRDOWN_1	0x01100013
 
 #define USB_INTEL_XUSB2PR      0xD0
+#define USB_INTEL_USB2PRM      0xD4
 #define USB_INTEL_USB3_PSSEN   0xD8
+#define USB_INTEL_USB3PRM      0xDC
 
 static struct amd_chipset_info {
 	struct pci_dev	*nb_dev;
@@ -772,10 +774,18 @@ void usb_enable_xhci_ports(struct pci_dev *xhci_pdev)
 		return;
 	}
 
-	ports_available = 0xffffffff;
+	/* Read USB3PRM, the USB 3.0 Port Routing Mask Register
+	 * Indicate the ports that can be changed from OS.
+	 */
+	pci_read_config_dword(xhci_pdev, USB_INTEL_USB3PRM,
+			&ports_available);
+
+	dev_dbg(&xhci_pdev->dev, "Configurable ports to enable SuperSpeed: 0x%x\n",
+			ports_available);
+
 	/* Write USB3_PSSEN, the USB 3.0 Port SuperSpeed Enable
-	 * Register, to turn on SuperSpeed terminations for all
-	 * available ports.
+	 * Register, to turn on SuperSpeed terminations for the
+	 * switchable ports.
 	 */
 	pci_write_config_dword(xhci_pdev, USB_INTEL_USB3_PSSEN,
 			cpu_to_le32(ports_available));
@@ -785,7 +795,16 @@ void usb_enable_xhci_ports(struct pci_dev *xhci_pdev)
 	dev_dbg(&xhci_pdev->dev, "USB 3.0 ports that are now enabled "
 			"under xHCI: 0x%x\n", ports_available);
 
-	ports_available = 0xffffffff;
+	/* Read XUSB2PRM, xHCI USB 2.0 Port Routing Mask Register
+	 * Indicate the port to be controlled by the EHCI host.
+	 */
+
+	pci_read_config_dword(xhci_pdev, USB_INTEL_USB2PRM,
+			&ports_available);
+
+	dev_dbg(&xhci_pdev->dev, "Configurable ports to hand over the ECHI host:
+			0x%x\n", ports_available);
+
 	/* Write XUSB2PR, the xHC USB 2.0 Port Routing Register, to
 	 * switch the USB 2.0 power and data lines over to the xHCI
 	 * host.
-- 
1.7.9.5

