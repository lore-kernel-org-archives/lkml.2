Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab2BPFPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 00:15:24 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:38812 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab2BPFPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 00:15:19 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 2/4] PCI: Specify class for quirk entry with PCI_ANY_ID
Date: Wed, 15 Feb 2012 21:14:54 -0800
Message-Id: <1329369296-4255-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1329369296-4255-1-git-send-email-yinghai@kernel.org>
References: <1329369296-4255-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4F3C90E4.00AF,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use quirk framework class checking instead check class inside every quirk func.

That reduce quirk calling significent esp on Intel 8 sockets systems that have
lots of device.
- quirk_e100_interrupt
- quirk_usb_early_handoff
- pci_fixup_video
- quirk_mmio_always_on
- quirk_cardbus_legacy

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/pci-dma.c     |    5 ++--
 arch/x86/pci/fixup.c          |   12 ++++-------
 drivers/pci/quirks.c          |   43 ++++++++++++++++++++++--------------------
 drivers/usb/host/pci-quirks.c |    3 +-
 4 files changed, 33 insertions(+), 30 deletions(-)

Index: linux-2.6/arch/x86/kernel/pci-dma.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/pci-dma.c
+++ linux-2.6/arch/x86/kernel/pci-dma.c
@@ -262,10 +262,11 @@ rootfs_initcall(pci_iommu_init);
 
 static __devinit void via_no_dac(struct pci_dev *dev)
 {
-	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI && forbid_dac == 0) {
+	if (forbid_dac == 0) {
 		dev_info(&dev->dev, "disabling DAC on VIA PCI bridge\n");
 		forbid_dac = 1;
 	}
 }
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_ANY_ID, via_no_dac);
+DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_VIA, PCI_ANY_ID,
+				PCI_CLASS_BRIDGE_PCI, 8, via_no_dac);
 #endif
Index: linux-2.6/arch/x86/pci/fixup.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/fixup.c
+++ linux-2.6/arch/x86/pci/fixup.c
@@ -164,11 +164,11 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_V
  */
 static void __devinit pci_fixup_transparent_bridge(struct pci_dev *dev)
 {
-	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI &&
-	    (dev->device & 0xff00) == 0x2400)
+	if ((dev->device & 0xff00) == 0x2400)
 		dev->transparent = 1;
 }
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_ANY_ID, pci_fixup_transparent_bridge);
+DECLARE_PCI_FIXUP_CLASS_HEADER(PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
+			 PCI_CLASS_BRIDGE_PCI, 8, pci_fixup_transparent_bridge);
 
 /*
  * Fixup for C1 Halt Disconnect problem on nForce2 systems.
@@ -322,9 +322,6 @@ static void __devinit pci_fixup_video(st
 	struct pci_bus *bus;
 	u16 config;
 
-	if ((pdev->class >> 8) != PCI_CLASS_DISPLAY_VGA)
-		return;
-
 	/* Is VGA routed to us? */
 	bus = pdev->bus;
 	while (bus) {
@@ -353,7 +350,8 @@ static void __devinit pci_fixup_video(st
 		dev_printk(KERN_DEBUG, &pdev->dev, "Boot video device\n");
 	}
 }
-DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, pci_fixup_video);
+DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_ANY_ID, PCI_ANY_ID,
+				PCI_CLASS_DISPLAY_VGA, 8, pci_fixup_video);
 
 
 static const struct dmi_system_id __devinitconst msi_k8t_dmi_table[] = {
Index: linux-2.6/drivers/pci/quirks.c
===================================================================
--- linux-2.6.orig/drivers/pci/quirks.c
+++ linux-2.6/drivers/pci/quirks.c
@@ -102,10 +102,10 @@ DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI
  */
 static void __devinit quirk_mmio_always_on(struct pci_dev *dev)
 {
-	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_HOST)
-		dev->mmio_always_on = 1;
+	dev->mmio_always_on = 1;
 }
-DECLARE_PCI_FIXUP_EARLY(PCI_ANY_ID, PCI_ANY_ID, quirk_mmio_always_on);
+DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_ANY_ID, PCI_ANY_ID,
+				PCI_CLASS_BRIDGE_HOST, 8, quirk_mmio_always_on);
 
 /* The Mellanox Tavor device gives false positive parity errors
  * Mark this device with a broken_parity_status, to allow
@@ -1004,12 +1004,12 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_V
  */
 static void quirk_cardbus_legacy(struct pci_dev *dev)
 {
-	if ((PCI_CLASS_BRIDGE_CARDBUS << 8) ^ dev->class)
-		return;
 	pci_write_config_dword(dev, PCI_CB_LEGACY_MODE_BASE, 0);
 }
-DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, quirk_cardbus_legacy);
-DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_ANY_ID, PCI_ANY_ID, quirk_cardbus_legacy);
+DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_ANY_ID, PCI_ANY_ID,
+			PCI_CLASS_BRIDGE_CARDBUS, 8, quirk_cardbus_legacy);
+DECLARE_PCI_FIXUP_CLASS_RESUME_EARLY(PCI_ANY_ID, PCI_ANY_ID,
+			PCI_CLASS_BRIDGE_CARDBUS, 8, quirk_cardbus_legacy);
 
 /*
  * Following the PCI ordering rules is optional on the AMD762. I'm not
@@ -1166,17 +1166,20 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_IN
 
 static void __devinit quirk_no_ata_d3(struct pci_dev *pdev)
 {
-	/* Quirk the legacy ATA devices only. The AHCI ones are ok */
-	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE)
-		pdev->dev_flags |= PCI_DEV_FLAGS_NO_D3;
+	pdev->dev_flags |= PCI_DEV_FLAGS_NO_D3;
 }
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, PCI_ANY_ID, quirk_no_ata_d3);
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_ATI, PCI_ANY_ID, quirk_no_ata_d3);
+/* Quirk the legacy ATA devices only. The AHCI ones are ok */
+DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_SERVERWORKS, PCI_ANY_ID,
+				PCI_CLASS_STORAGE_IDE, 8, quirk_no_ata_d3);
+DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_ATI, PCI_ANY_ID,
+				PCI_CLASS_STORAGE_IDE, 8, quirk_no_ata_d3);
 /* ALi loses some register settings that we cannot then restore */
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AL, PCI_ANY_ID, quirk_no_ata_d3);
+DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_AL, PCI_ANY_ID,
+				PCI_CLASS_STORAGE_IDE, 8, quirk_no_ata_d3);
 /* VIA comes back fine but we need to keep it alive or ACPI GTM failures
    occur when mode detecting */
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_VIA, PCI_ANY_ID, quirk_no_ata_d3);
+DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_VIA, PCI_ANY_ID,
+				PCI_CLASS_STORAGE_IDE, 8, quirk_no_ata_d3);
 
 /* This was originally an Alpha specific thing, but it really fits here.
  * The i82375 PCI/EISA bridge appears as non-classified. Fix that.
@@ -1954,7 +1957,8 @@ static void __devinit quirk_e100_interru
 
 	iounmap(csr);
 }
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, PCI_ANY_ID, quirk_e100_interrupt);
+DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
+			PCI_CLASS_NETWORK_ETHERNET, 8, quirk_e100_interrupt);
 
 /*
  * The 82575 and 82598 may experience data corruption issues when transitioning
@@ -2818,12 +2822,11 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_IN
 static void __devinit fixup_ti816x_class(struct pci_dev* dev)
 {
 	/* TI 816x devices do not have class code set when in PCIe boot mode */
-	if (dev->class == PCI_CLASS_NOT_DEFINED) {
-		dev_info(&dev->dev, "Setting PCI class for 816x PCIe device\n");
-		dev->class = PCI_CLASS_MULTIMEDIA_VIDEO;
-	}
+	dev_info(&dev->dev, "Setting PCI class for 816x PCIe device\n");
+	dev->class = PCI_CLASS_MULTIMEDIA_VIDEO;
 }
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_TI, 0xb800, fixup_ti816x_class);
+DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_TI, 0xb800,
+				 PCI_CLASS_NOT_DEFINED, 0, fixup_ti816x_class);
 
 /* Some PCIe devices do not work reliably with the claimed maximum
  * payload size supported.
Index: linux-2.6/drivers/usb/host/pci-quirks.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/pci-quirks.c
+++ linux-2.6/drivers/usb/host/pci-quirks.c
@@ -901,4 +901,5 @@ static void __devinit quirk_usb_early_ha
 	else if (pdev->class == PCI_CLASS_SERIAL_USB_XHCI)
 		quirk_usb_handoff_xhci(pdev);
 }
-DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, quirk_usb_early_handoff);
+DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_ANY_ID, PCI_ANY_ID,
+			PCI_CLASS_SERIAL_USB, 8, quirk_usb_early_handoff);
