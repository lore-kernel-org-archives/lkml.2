Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab2CARRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 12:17:38 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:25378 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab2CARRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 12:17:36 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [RFC PATCH] usb, PCI: split quirk for usb host controller to three
Date: Thu,  1 Mar 2012 09:17:07 -0800
Message-Id: <1330622227-4209-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F4FAF2A.0015,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so we avoid checking class again and again in that quirk.

need to be applied after pci/linux-next and usb/usb-next

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/usb/host/pci-quirks.c |   42 ++++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

Index: linux-2.6/drivers/usb/host/pci-quirks.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/pci-quirks.c
+++ linux-2.6/drivers/usb/host/pci-quirks.c
@@ -884,33 +884,47 @@ static void __devinit quirk_usb_handoff_
 	iounmap(base);
 }
 
-static void __devinit quirk_usb_early_handoff(struct pci_dev *pdev)
+static void __devinit quirk_usb_early_handoff_uhci(struct pci_dev *pdev)
+{
+	quirk_usb_handoff_uhci(pdev);
+}
+DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_ANY_ID, PCI_ANY_ID,
+		PCI_CLASS_SERIAL_USB_UHCI, 0, quirk_usb_early_handoff_uhci);
+
+static void __devinit quirk_usb_early_handoff_ohci(struct pci_dev *pdev)
 {
 	/* Skip Netlogic mips SoC's internal PCI USB controller.
 	 * This device does not need/support EHCI/OHCI handoff
 	 */
 	if (pdev->vendor == 0x184e)	/* vendor Netlogic */
 		return;
-	if (pdev->class != PCI_CLASS_SERIAL_USB_UHCI &&
-			pdev->class != PCI_CLASS_SERIAL_USB_OHCI &&
-			pdev->class != PCI_CLASS_SERIAL_USB_EHCI &&
-			pdev->class != PCI_CLASS_SERIAL_USB_XHCI)
+
+	quirk_usb_handoff_ohci(pdev);
+}
+DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_ANY_ID, PCI_ANY_ID,
+		PCI_CLASS_SERIAL_USB_OHCI, 0, quirk_usb_early_handoff_ohci);
+
+static void __devinit quirk_usb_early_handoff_ehci(struct pci_dev *pdev)
+{
+	if (pdev->vendor == 0x184e)	/* vendor Netlogic */
 		return;
 
+	quirk_usb_handoff_ehci(pdev);
+}
+DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_ANY_ID, PCI_ANY_ID,
+		PCI_CLASS_SERIAL_USB_EHCI, 0, quirk_usb_early_handoff_ehci);
+
+static void __devinit quirk_usb_early_handoff_xhci(struct pci_dev *pdev)
+{
 	if (pci_enable_device(pdev) < 0) {
 		dev_warn(&pdev->dev, "Can't enable PCI device, "
 				"BIOS handoff failed.\n");
 		return;
 	}
-	if (pdev->class == PCI_CLASS_SERIAL_USB_UHCI)
-		quirk_usb_handoff_uhci(pdev);
-	else if (pdev->class == PCI_CLASS_SERIAL_USB_OHCI)
-		quirk_usb_handoff_ohci(pdev);
-	else if (pdev->class == PCI_CLASS_SERIAL_USB_EHCI)
-		quirk_usb_handoff_ehci(pdev);
-	else if (pdev->class == PCI_CLASS_SERIAL_USB_XHCI)
-		quirk_usb_handoff_xhci(pdev);
+
+	quirk_usb_handoff_xhci(pdev);
+
 	pci_disable_device(pdev);
 }
 DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_ANY_ID, PCI_ANY_ID,
-			PCI_CLASS_SERIAL_USB, 8, quirk_usb_early_handoff);
+		PCI_CLASS_SERIAL_USB_XHCI, 0, quirk_usb_early_handoff_xhci);
