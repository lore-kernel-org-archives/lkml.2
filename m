Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969Ab2CMH3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 03:29:51 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:49682 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759924Ab2CMH20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 03:28:26 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 08/12] PCI: Make quirk_io_region to use addon_resource support
Date: Tue, 13 Mar 2012 00:26:30 -0700
Message-Id: <1331623594-30543-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331623594-30543-1-git-send-email-yinghai@kernel.org>
References: <1331623594-30543-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F5EF717.008A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

after they are put in add-on resources, they will be safely claimed later.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/quirks.c |  155 ++++++++++++++++++++++---------------------------
 1 files changed, 70 insertions(+), 85 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index cbe7dd9..4561610 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -324,29 +324,61 @@ static void __devinit quirk_cs5536_vsa(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA, quirk_cs5536_vsa);
 
-static void __devinit quirk_io_region(struct pci_dev *dev, unsigned region,
-	unsigned size, int nr, const char *name)
+static int quirk_read_io(struct pci_dev *dev, struct resource *res, int port)
 {
-	region &= ~(size-1);
-	if (region) {
-		struct pci_bus_region bus_region;
-		struct resource *res = dev->resource + nr;
+	struct pci_bus_region bus_region;
+	u16 region;
+	unsigned size = to_pci_dev_addon_resource(res)->size;
 
-		res->name = pci_name(dev);
-		res->start = region;
-		res->end = region + size - 1;
-		res->flags = IORESOURCE_IO;
+	pci_read_config_word(dev, port, &region);
+	region &= ~(size - 1);
 
-		/* Convert from PCI bus to resource space.  */
-		bus_region.start = res->start;
-		bus_region.end = res->end;
-		pcibios_bus_to_resource(dev, res, &bus_region);
+	/* Convert from PCI bus to resource space.  */
+	bus_region.start = region;
+	bus_region.end = region + size - 1;
 
-		if (pci_claim_resource(dev, nr) == 0)
-			dev_info(&dev->dev, "quirk: %pR claimed by %s\n",
-				 res, name);
-	}
-}	
+	pcibios_bus_to_resource(dev, res, &bus_region);
+
+	res->flags |= IORESOURCE_IO;
+	dev_info(&dev->dev, "PIO at %pR\n", res);
+
+	return 0;
+}
+static int quirk_write_io(struct pci_dev *dev, struct resource *res, int port)
+{
+	struct pci_bus_region bus_region;
+	u16 region;
+	unsigned size = to_pci_dev_addon_resource(res)->size;
+
+	pci_read_config_word(dev, port, &region);
+	region &= size - 1;
+
+	/* Convert to PCI bus space.  */
+	pcibios_resource_to_bus(dev, &bus_region, res);
+	region |= bus_region.start & (~(size - 1));
+
+	pci_write_config_word(dev, port, region);
+
+	return 0;
+}
+static struct resource_ops quirk_io_ops = {
+	.read = quirk_read_io,
+	.write = quirk_write_io,
+};
+
+static void __devinit quirk_io_region(struct pci_dev *dev, int port,
+					unsigned size, char *name)
+{
+	u16 region;
+
+	pci_read_config_word(dev, port, &region);
+	region &= size - 1;
+
+	if (!region)
+		return;
+
+	add_pci_dev_addon_resource(dev, port, size, &quirk_io_ops, name);
+}
 
 /*
  *	ATI Northbridge setups MCE the processor if you even
@@ -374,12 +406,8 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI,	PCI_DEVICE_ID_ATI_RS100,   quirk_ati_
  */
 static void __devinit quirk_ali7101_acpi(struct pci_dev *dev)
 {
-	u16 region;
-
-	pci_read_config_word(dev, 0xE0, &region);
-	quirk_io_region(dev, region, 64, PCI_BRIDGE_RESOURCES, "ali7101 ACPI");
-	pci_read_config_word(dev, 0xE2, &region);
-	quirk_io_region(dev, region, 32, PCI_BRIDGE_RESOURCES+1, "ali7101 SMB");
+	quirk_io_region(dev, 0xE0, 64, "ali7101 ACPI");
+	quirk_io_region(dev, 0xE2, 32, "ali7101 SMB");
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AL,	PCI_DEVICE_ID_AL_M7101,		quirk_ali7101_acpi);
 
@@ -503,12 +531,10 @@ static void piix4_mem_quirk(struct pci_dev *dev, char *name, unsigned int port,
  */
 static void __devinit quirk_piix4_acpi(struct pci_dev *dev)
 {
-	u32 region, res_a;
+	u32 res_a;
 
-	pci_read_config_dword(dev, 0x40, &region);
-	quirk_io_region(dev, region, 64, PCI_BRIDGE_RESOURCES, "PIIX4 ACPI");
-	pci_read_config_dword(dev, 0x90, &region);
-	quirk_io_region(dev, region, 16, PCI_BRIDGE_RESOURCES+1, "PIIX4 SMB");
+	quirk_io_region(dev, 0x40, 64, "PIIX4 ACPI");
+	quirk_io_region(dev, 0x90, 16, "PIIX4 SMB");
 
 	/* Device resource A has enables for some of the other ones */
 	pci_read_config_dword(dev, 0x5c, &res_a);
@@ -552,7 +578,6 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82443MX_3,	qui
  */
 static void __devinit quirk_ich4_lpc_acpi(struct pci_dev *dev)
 {
-	u32 region;
 	u8 enable;
 
 	/*
@@ -564,22 +589,12 @@ static void __devinit quirk_ich4_lpc_acpi(struct pci_dev *dev)
 	*/
 
 	pci_read_config_byte(dev, ICH_ACPI_CNTL, &enable);
-	if (enable & ICH4_ACPI_EN) {
-		pci_read_config_dword(dev, ICH_PMBASE, &region);
-		region &= PCI_BASE_ADDRESS_IO_MASK;
-		if (region >= PCIBIOS_MIN_IO)
-			quirk_io_region(dev, region, 128, PCI_BRIDGE_RESOURCES,
-					"ICH4 ACPI/GPIO/TCO");
-	}
+	if (enable & ICH4_ACPI_EN)
+		quirk_io_region(dev, ICH_PMBASE, 128, "ICH4 ACPI/GPIO/TCO");
 
 	pci_read_config_byte(dev, ICH4_GPIO_CNTL, &enable);
-	if (enable & ICH4_GPIO_EN) {
-		pci_read_config_dword(dev, ICH4_GPIOBASE, &region);
-		region &= PCI_BASE_ADDRESS_IO_MASK;
-		if (region >= PCIBIOS_MIN_IO)
-			quirk_io_region(dev, region, 64,
-					PCI_BRIDGE_RESOURCES + 1, "ICH4 GPIO");
-	}
+	if (enable & ICH4_GPIO_EN)
+		quirk_io_region(dev, ICH4_GPIOBASE, 64, "ICH4 GPIO");
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,    PCI_DEVICE_ID_INTEL_82801AA_0,		quirk_ich4_lpc_acpi);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,    PCI_DEVICE_ID_INTEL_82801AB_0,		quirk_ich4_lpc_acpi);
@@ -594,26 +609,15 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,    PCI_DEVICE_ID_INTEL_ESB_1,		qui
 
 static void __devinit ich6_lpc_acpi_gpio(struct pci_dev *dev)
 {
-	u32 region;
 	u8 enable;
 
 	pci_read_config_byte(dev, ICH_ACPI_CNTL, &enable);
-	if (enable & ICH6_ACPI_EN) {
-		pci_read_config_dword(dev, ICH_PMBASE, &region);
-		region &= PCI_BASE_ADDRESS_IO_MASK;
-		if (region >= PCIBIOS_MIN_IO)
-			quirk_io_region(dev, region, 128, PCI_BRIDGE_RESOURCES,
-					"ICH6 ACPI/GPIO/TCO");
-	}
+	if (enable & ICH6_ACPI_EN)
+		quirk_io_region(dev, ICH_PMBASE, 128, "ICH6 ACPI/GPIO/TCO");
 
 	pci_read_config_byte(dev, ICH6_GPIO_CNTL, &enable);
-	if (enable & ICH6_GPIO_EN) {
-		pci_read_config_dword(dev, ICH6_GPIOBASE, &region);
-		region &= PCI_BASE_ADDRESS_IO_MASK;
-		if (region >= PCIBIOS_MIN_IO)
-			quirk_io_region(dev, region, 64,
-					PCI_BRIDGE_RESOURCES + 1, "ICH6 GPIO");
-	}
+	if (enable & ICH6_GPIO_EN)
+		quirk_io_region(dev, ICH6_GPIOBASE, 64, "ICH6 GPIO");
 }
 
 static void __devinit ich6_lpc_generic_decode(struct pci_dev *dev, unsigned reg, const char *name, int dynsize)
@@ -711,13 +715,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_ICH10_1, qui
  */
 static void __devinit quirk_vt82c586_acpi(struct pci_dev *dev)
 {
-	u32 region;
-
-	if (dev->revision & 0x10) {
-		pci_read_config_dword(dev, 0x48, &region);
-		region &= PCI_BASE_ADDRESS_IO_MASK;
-		quirk_io_region(dev, region, 256, PCI_BRIDGE_RESOURCES, "vt82c586 ACPI");
-	}
+	if (dev->revision & 0x10)
+		quirk_io_region(dev, 0x48, 256, "vt82c586 ACPI");
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_82C586_3,	quirk_vt82c586_acpi);
 
@@ -729,18 +728,11 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_82C586_3,	quirk_vt
  */
 static void __devinit quirk_vt82c686_acpi(struct pci_dev *dev)
 {
-	u16 hm;
-	u32 smb;
-
 	quirk_vt82c586_acpi(dev);
 
-	pci_read_config_word(dev, 0x70, &hm);
-	hm &= PCI_BASE_ADDRESS_IO_MASK;
-	quirk_io_region(dev, hm, 128, PCI_BRIDGE_RESOURCES + 1, "vt82c686 HW-mon");
+	quirk_io_region(dev, 0x70, 128, "vt82c686 HW-mon");
 
-	pci_read_config_dword(dev, 0x90, &smb);
-	smb &= PCI_BASE_ADDRESS_IO_MASK;
-	quirk_io_region(dev, smb, 16, PCI_BRIDGE_RESOURCES + 2, "vt82c686 SMB");
+	quirk_io_region(dev, 0x90, 16, "vt82c686 SMB");
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_82C686_4,	quirk_vt82c686_acpi);
 
@@ -751,15 +743,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_82C686_4,	quirk_vt
  */
 static void __devinit quirk_vt8235_acpi(struct pci_dev *dev)
 {
-	u16 pm, smb;
-
-	pci_read_config_word(dev, 0x88, &pm);
-	pm &= PCI_BASE_ADDRESS_IO_MASK;
-	quirk_io_region(dev, pm, 128, PCI_BRIDGE_RESOURCES, "vt8235 PM");
-
-	pci_read_config_word(dev, 0xd0, &smb);
-	smb &= PCI_BASE_ADDRESS_IO_MASK;
-	quirk_io_region(dev, smb, 16, PCI_BRIDGE_RESOURCES + 1, "vt8235 SMB");
+	quirk_io_region(dev, 0x88, 128, "vt8235 PM");
+	quirk_io_region(dev, 0xd0, 16, "vt8235 SMB");
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8235,	quirk_vt8235_acpi);
 
-- 
1.7.7

