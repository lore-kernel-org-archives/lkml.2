Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934069Ab1FWRwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:52:53 -0400
Received: from mail.windriver.com ([147.11.1.11]:35338 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933653Ab1FWRiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:38:07 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 186/247] PCI: add more checking to ICH region quirks
Date: Thu, 23 Jun 2011 13:34:14 -0400
Message-Id: <1308850515-15242-127-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit cdb9755849fbaf2bb9c0a009ba5baa817a0f152d upstream.

Per ICH4 and ICH6 specs, ACPI and GPIO regions are valid iff ACPI_EN
and GPIO_EN bits are set to 1. Add checks for these bits into the
quirks prior to the region creation.

While at it, name the constants by macros.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/pci/quirks.c |   45 +++++++++++++++++++++++++++++++++++++--------
 1 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index c5f5f44..48b13bb 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -519,6 +519,17 @@ static void __devinit quirk_piix4_acpi(struct pci_dev *dev)
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
@@ -527,12 +538,21 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82443MX_3,	qui
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
@@ -548,12 +568,21 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,    PCI_DEVICE_ID_INTEL_ESB_1,		qui
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
1.7.4.4

