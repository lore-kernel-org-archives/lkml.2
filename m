Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878Ab1DYUsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:48:53 -0400
Received: from 1wt.eu ([62.212.114.60]:34192 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932234Ab1DYUYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:35 -0400
Message-Id: <20110425200236.990908279@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:04 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Jiri Slaby <jslaby@suse.cz>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Renninger <trenn@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 092/173] PCI: add more checking to ICH region quirks
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/quirks.c |   49 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 39 insertions(+), 10 deletions(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -506,6 +506,17 @@ static void __devinit quirk_piix4_acpi(s
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
@@ -514,12 +525,21 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
 static void __devinit quirk_ich4_lpc_acpi(struct pci_dev *dev)
 {
 	u32 region;
+	u8 enable;
 
-	pci_read_config_dword(dev, 0x40, &region);
-	quirk_io_region(dev, region, 128, PCI_BRIDGE_RESOURCES, "ICH4 ACPI/GPIO/TCO");
-
-	pci_read_config_dword(dev, 0x58, &region);
-	quirk_io_region(dev, region, 64, PCI_BRIDGE_RESOURCES+1, "ICH4 GPIO");
+	pci_read_config_byte(dev, ICH_ACPI_CNTL, &enable);
+	if (enable & ICH4_ACPI_EN) {
+		pci_read_config_dword(dev, ICH_PMBASE, &region);
+		quirk_io_region(dev, region, 128, PCI_BRIDGE_RESOURCES,
+				"ICH4 ACPI/GPIO/TCO");
+	}
+
+	pci_read_config_byte(dev, ICH4_GPIO_CNTL, &enable);
+	if (enable & ICH4_GPIO_EN) {
+		pci_read_config_dword(dev, ICH4_GPIOBASE, &region);
+		quirk_io_region(dev, region, 64, PCI_BRIDGE_RESOURCES + 1,
+				"ICH4 GPIO");
+	}
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,    PCI_DEVICE_ID_INTEL_82801AA_0,		quirk_ich4_lpc_acpi);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,    PCI_DEVICE_ID_INTEL_82801AB_0,		quirk_ich4_lpc_acpi);
@@ -535,12 +555,21 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
 static void __devinit ich6_lpc_acpi_gpio(struct pci_dev *dev)
 {
 	u32 region;
+	u8 enable;
 
-	pci_read_config_dword(dev, 0x40, &region);
-	quirk_io_region(dev, region, 128, PCI_BRIDGE_RESOURCES, "ICH6 ACPI/GPIO/TCO");
-
-	pci_read_config_dword(dev, 0x48, &region);
-	quirk_io_region(dev, region, 64, PCI_BRIDGE_RESOURCES+1, "ICH6 GPIO");
+	pci_read_config_byte(dev, ICH_ACPI_CNTL, &enable);
+	if (enable & ICH6_ACPI_EN) {
+		pci_read_config_dword(dev, ICH_PMBASE, &region);
+		quirk_io_region(dev, region, 128, PCI_BRIDGE_RESOURCES,
+				"ICH6 ACPI/GPIO/TCO");
+	}
+
+	pci_read_config_byte(dev, ICH6_GPIO_CNTL, &enable);
+	if (enable & ICH4_GPIO_EN) {
+		pci_read_config_dword(dev, ICH6_GPIOBASE, &region);
+		quirk_io_region(dev, region, 64, PCI_BRIDGE_RESOURCES + 1,
+				"ICH6 GPIO");
+	}
 }
 
 static void __devinit ich6_lpc_generic_decode(struct pci_dev *dev, unsigned reg, const char *name, int dynsize)


