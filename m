Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759932Ab2CMH23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 03:28:29 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:28401 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172Ab2CMH2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 03:28:23 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 07/12] PCI: Make piix4 quirk to use addon_resource support
Date: Tue, 13 Mar 2012 00:26:29 -0700
Message-Id: <1331623594-30543-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331623594-30543-1-git-send-email-yinghai@kernel.org>
References: <1331623594-30543-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4F5EF714.0022,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

after they are put in add-on resources, they will be safely claimed later.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/quirks.c |   93 +++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 77 insertions(+), 16 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 7ef4183..cbe7dd9 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -383,14 +383,14 @@ static void __devinit quirk_ali7101_acpi(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AL,	PCI_DEVICE_ID_AL_M7101,		quirk_ali7101_acpi);
 
-static void piix4_io_quirk(struct pci_dev *dev, const char *name, unsigned int port, unsigned int enable)
+static int piix4_read_io(struct pci_dev *dev, struct resource *res, int port)
 {
 	u32 devres;
 	u32 mask, size, base;
+	struct pci_bus_region bus_region;
 
 	pci_read_config_dword(dev, port, &devres);
-	if ((devres & enable) != enable)
-		return;
+
 	mask = (devres >> 16) & 15;
 	base = devres & 0xffff;
 	size = 16;
@@ -400,23 +400,53 @@ static void piix4_io_quirk(struct pci_dev *dev, const char *name, unsigned int p
 			break;
 		size = bit;
 	}
-	/*
-	 * For now we only print it out. Eventually we'll want to
-	 * reserve it (at least if it's in the 0x1000+ range), but
-	 * let's get enough confirmation reports first. 
-	 */
 	base &= -size;
-	dev_info(&dev->dev, "%s PIO at %04x-%04x\n", name, base, base + size - 1);
+
+	bus_region.start = base;
+	bus_region.end = base + size - 1;
+	res->flags |= IORESOURCE_IO;
+	pcibios_bus_to_resource(dev, res, &bus_region);
+	dev_info(&dev->dev, "PIO at %pR\n", res);
+
+	return 0;
 }
+static int piix4_write_io(struct pci_dev *dev, struct resource *res, int port)
+{
+	u32 devres;
+	struct pci_bus_region bus_region;
+
+	pcibios_resource_to_bus(dev, &bus_region, res);
 
-static void piix4_mem_quirk(struct pci_dev *dev, const char *name, unsigned int port, unsigned int enable)
+	pci_read_config_dword(dev, port, &devres);
+	devres &= 0xffff0000;
+	devres |= bus_region.start & 0xffff;
+	pci_write_config_dword(dev, port, devres);
+
+	return 0;
+}
+static struct resource_ops piix4_io_ops = {
+	.read = piix4_read_io,
+	.write = piix4_write_io,
+};
+static void piix4_io_quirk(struct pci_dev *dev, char *name, unsigned int port,
+				unsigned int enable)
 {
 	u32 devres;
-	u32 mask, size, base;
 
 	pci_read_config_dword(dev, port, &devres);
 	if ((devres & enable) != enable)
 		return;
+
+	add_pci_dev_addon_resource(dev, port, 0, &piix4_io_ops, name);
+}
+
+static int piix4_read_mem(struct pci_dev *dev, struct resource *res, int port)
+{
+	u32 devres;
+	u32 mask, size, base;
+	struct pci_bus_region bus_region;
+
+	pci_read_config_dword(dev, port, &devres);
 	base = devres & 0xffff0000;
 	mask = (devres & 0x3f) << 16;
 	size = 128 << 16;
@@ -426,12 +456,43 @@ static void piix4_mem_quirk(struct pci_dev *dev, const char *name, unsigned int
 			break;
 		size = bit;
 	}
-	/*
-	 * For now we only print it out. Eventually we'll want to
-	 * reserve it, but let's get enough confirmation reports first. 
-	 */
 	base &= -size;
-	dev_info(&dev->dev, "%s MMIO at %04x-%04x\n", name, base, base + size - 1);
+	bus_region.start = base;
+	bus_region.end = base + size - 1;
+	res->flags |= IORESOURCE_MEM;
+	pcibios_bus_to_resource(dev, res, &bus_region);
+	dev_info(&dev->dev, "MMIO at %pR\n", res);
+
+	return 0;
+}
+static int piix4_write_mem(struct pci_dev *dev, struct resource *res, int port)
+{
+	u32 devres;
+	struct pci_bus_region bus_region;
+
+	pcibios_resource_to_bus(dev, &bus_region, res);
+
+	pci_read_config_dword(dev, port, &devres);
+	devres &= 0x0000ffff;
+	devres |= bus_region.start & 0xffff0000;
+	pci_write_config_dword(dev, port, devres);
+
+	return 0;
+}
+static struct resource_ops piix4_mem_ops = {
+	.read = piix4_read_mem,
+	.write = piix4_write_mem,
+};
+static void piix4_mem_quirk(struct pci_dev *dev, char *name, unsigned int port,
+				unsigned int enable)
+{
+	u32 devres;
+
+	pci_read_config_dword(dev, port, &devres);
+	if ((devres & enable) != enable)
+		return;
+
+	add_pci_dev_addon_resource(dev, port, 0, &piix4_mem_ops, name);
 }
 
 /*
-- 
1.7.7

