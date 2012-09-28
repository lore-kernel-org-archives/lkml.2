Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031188Ab2I1Uz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:55:59 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37459 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423003Ab2I1UsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:48:17 -0400
X-Sasl-enc: sq835KaW/iKWvxeQ37Sb1FvA5UXgdytjTW5FWgMCr/nv 1348865296
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Keng-Yu Lin <kengyu@canonical.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 078/127] Intel xhci: Only switch the switchable ports
Date: Fri, 28 Sep 2012 13:34:11 -0700
Message-Id: <20120928203054.999088035@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keng-Yu Lin <kengyu@canonical.com>

commit a96874a2a92feaef607ddd3137277a788cb927a6 upstream.

With a previous patch to enable the EHCI/XHCI port switching, it switches
all the available ports.

The assumption is not correct because the BIOS may expect some ports
not switchable by the OS.

There are two more registers that contains the information of the switchable
and non-switchable ports.

This patch adds the checking code for the two register so that only the
switchable ports are altered.

This patch should be backported to kernels as old as 3.0, that contain
commit ID 69e848c2090aebba5698a1620604c7dccb448684 "Intel xhci: Support
EHCI/xHCI port switching."

Signed-off-by: Keng-Yu Lin <kengyu@canonical.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/pci-quirks.c |   27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -73,7 +73,9 @@
 #define	NB_PIF0_PWRDOWN_1	0x01100013
 
 #define USB_INTEL_XUSB2PR      0xD0
+#define USB_INTEL_USB2PRM      0xD4
 #define USB_INTEL_USB3_PSSEN   0xD8
+#define USB_INTEL_USB3PRM      0xDC
 
 static struct amd_chipset_info {
 	struct pci_dev	*nb_dev;
@@ -758,10 +760,18 @@ void usb_enable_xhci_ports(struct pci_de
 #if defined(CONFIG_USB_XHCI_HCD) || defined(CONFIG_USB_XHCI_HCD_MODULE)
 	u32		ports_available;
 
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
@@ -771,7 +781,16 @@ void usb_enable_xhci_ports(struct pci_de
 	dev_dbg(&xhci_pdev->dev, "USB 3.0 ports that are now enabled "
 			"under xHCI: 0x%x\n", ports_available);
 
-	ports_available = 0xffffffff;
+	/* Read XUSB2PRM, xHCI USB 2.0 Port Routing Mask Register
+	 * Indicate the USB 2.0 ports to be controlled by the xHCI host.
+	 */
+
+	pci_read_config_dword(xhci_pdev, USB_INTEL_USB2PRM,
+			&ports_available);
+
+	dev_dbg(&xhci_pdev->dev, "Configurable USB 2.0 ports to hand over to xCHI: 0x%x\n",
+			ports_available);
+
 	/* Write XUSB2PR, the xHC USB 2.0 Port Routing Register, to
 	 * switch the USB 2.0 power and data lines over to the xHCI
 	 * host.


