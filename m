Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab1B1JpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 04:45:21 -0500
Received: from mail.pripojeni.net ([217.66.174.14]:35263 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab1B1JpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 04:45:18 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Renninger <trenn@suse.de>
Subject: [PATCH 1/2] PCI: add more checking to ICH region quirks
Date: Mon, 28 Feb 2011 10:45:09 +0100
Message-Id: <1298886310-11381-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per ICH4 and ICH6 specs, ACPI and GPIO regions are valid iff ACPI_EN
and GPIO_EN bits are set to 1. Add checks for these bits into the
quirks prior to the region creation.

While at it, name the constants by macros.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Renninger <trenn@suse.de>
---
 drivers/pci/quirks.c |   45 +++++++++++++++++++++++++++++++++++++--------
 1 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 53a786f..8db2426 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -533,6 +533,17 @@ static void __devinit quirk_piix4_acpi(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82371AB_3,	quirk_piix4_acpi);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82443MX_3,	quirk_piix4_acpi);
 
+#define ICH_PMBASE	0x40
+#define ICH_ACPI_CNTL	0x44
+#define  ICH4_ACPI_EN	0x10
+#define  ICH6_ACPI_EN	0x80
+#define ICH4_GPIOBASE	0x58
+#define ICH4_GPIO_CNTL	0x5c
+#define  ICH4_GPIO_EN	0x10
+#define ICH6_GPIOBASE	0x48
+#define ICH6_GPIO_CNTL	0x4c
+#define  ICH6_GPIO_EN	0x10
+
 /*
  * ICH4, ICH4-M, ICH5, ICH5-M ACPI: Three IO regions pointed to by longwords at
  *	0x40 (128 bytes of ACPI, GPIO & TCO registers)
@@ -541,12 +552,21 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82443MX_3,	qui
 static void __devinit quirk_ich4_lpc_acpi(struct pci_dev *dev)
 {
 	u32 region;
+	u8 enable;
 
-	pci_read_config_dword(dev, 0x40, &region);
-	quirk_io_region(dev, region, 128, PCI_BRIDGE_RESOURCES, "ICH4 ACPI/GPIO/TCO");
+	pci_read_config_byte(dev, ICH_ACPI_CNTL, &enable);
+	if (enable & ICH4_ACPI_EN) {
+		pci_read_config_dword(dev, ICH_PMBASE, &region);
+		quirk_io_region(dev, region, 128, PCI_BRIDGE_RESOURCES,
+				"ICH4 ACPI/GPIO/TCO");
+	}
 
-	pci_read_config_dword(dev, 0x58, &region);
-	quirk_io_region(dev, region, 64, PCI_BRIDGE_RESOURCES+1, "ICH4 GPIO");
+	pci_read_config_byte(dev, ICH4_GPIO_CNTL, &enable);
+	if (enable & ICH4_GPIO_EN) {
+		pci_read_config_dword(dev, ICH4_GPIOBASE, &region);
+		quirk_io_region(dev, region, 64, PCI_BRIDGE_RESOURCES + 1,
+				"ICH4 GPIO");
+	}
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,    PCI_DEVICE_ID_INTEL_82801AA_0,		quirk_ich4_lpc_acpi);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,    PCI_DEVICE_ID_INTEL_82801AB_0,		quirk_ich4_lpc_acpi);
@@ -562,12 +582,21 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,    PCI_DEVICE_ID_INTEL_ESB_1,		qui
 static void __devinit ich6_lpc_acpi_gpio(struct pci_dev *dev)
 {
 	u32 region;
+	u8 enable;
 
-	pci_read_config_dword(dev, 0x40, &region);
-	quirk_io_region(dev, region, 128, PCI_BRIDGE_RESOURCES, "ICH6 ACPI/GPIO/TCO");
+	pci_read_config_byte(dev, ICH_ACPI_CNTL, &enable);
+	if (enable & ICH6_ACPI_EN) {
+		pci_read_config_dword(dev, ICH_PMBASE, &region);
+		quirk_io_region(dev, region, 128, PCI_BRIDGE_RESOURCES,
+				"ICH6 ACPI/GPIO/TCO");
+	}
 
-	pci_read_config_dword(dev, 0x48, &region);
-	quirk_io_region(dev, region, 64, PCI_BRIDGE_RESOURCES+1, "ICH6 GPIO");
+	pci_read_config_byte(dev, ICH6_GPIO_CNTL, &enable);
+	if (enable & ICH4_GPIO_EN) {
+		pci_read_config_dword(dev, ICH6_GPIOBASE, &region);
+		quirk_io_region(dev, region, 64, PCI_BRIDGE_RESOURCES + 1,
+				"ICH6 GPIO");
+	}
 }
 
 static void __devinit ich6_lpc_generic_decode(struct pci_dev *dev, unsigned reg, const char *name, int dynsize)
-- 
1.7.4.1


