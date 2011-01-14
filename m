Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab1ANKcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 05:32:54 -0500
Received: from mail.pripojeni.net ([217.66.174.14]:42216 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab1ANKcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 05:32:36 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Renninger <trenn@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH option B 2/2] PCI: do not create quirk I/O regions below PCIBIOS_MIN_IO for ICH
Date: Fri, 14 Jan 2011 11:32:25 +0100
Message-Id: <1295001146-14910-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <4D3025F4.6020001@gmail.com>
References: <4D3025F4.6020001@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some broken BIOSes on ICH4 chipset report an ACPI region which is in
conflict with legacy IDE ports when ACPI is disabled. Even though the
regions overlap, IDE ports are working correctly (we cannot find out
the decoding rules on chipsets).

So the only problem is the reported region itself, if we don't reserve
the region in the quirk everything works as expected.

This patch avoids reserving any quirk regions below PCIBIOS_MIN_IO
which is 0x1000. Some regions might be (and are by a fast google
query) below this border, but the only difference is that they won't
be reserved anymore. They should still work though the same as before.

The conflicts look like (1f.0 is bridge, 1f.1 is IDE ctrl):
pci 0000:00:1f.1: address space collision: [io 0x0170-0x0177] conflicts with 0000:00:1f.0 [io  0x0100-0x017f]

At 0x0100 a 128 bytes long ACPI region is reported in the quirk for
ICH4. ata_piix then fails to find disks because the IDE legacy ports
are zeroed:
ata_piix 0000:00:1f.1: device not available (can't reserve [io 0x0000-0x0007])

References: https://bugzilla.novell.com/show_bug.cgi?id=558740
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 drivers/pci/quirks.c |   32 ++++++++++++++++++++++++--------
 1 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 8db2426..b3ab2f7 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -554,18 +554,30 @@ static void __devinit quirk_ich4_lpc_acpi(struct pci_dev *dev)
 	u32 region;
 	u8 enable;
 
+	/*
+	 * The check for PCIBIOS_MIN_IO is to ensure we won't create a conflict
+	 * with low legacy (and fixed) ports. We don't know the decoding
+	 * priority and can't tell whether the legacy device or the one created
+	 * here is really at that address.  This happens on boards with broken
+	 * BIOSes.
+	*/
+
 	pci_read_config_byte(dev, ICH_ACPI_CNTL, &enable);
 	if (enable & ICH4_ACPI_EN) {
 		pci_read_config_dword(dev, ICH_PMBASE, &region);
-		quirk_io_region(dev, region, 128, PCI_BRIDGE_RESOURCES,
-				"ICH4 ACPI/GPIO/TCO");
+		region &= PCI_BASE_ADDRESS_IO_MASK;
+		if (region >= PCIBIOS_MIN_IO)
+			quirk_io_region(dev, region, 128, PCI_BRIDGE_RESOURCES,
+					"ICH4 ACPI/GPIO/TCO");
 	}
 
 	pci_read_config_byte(dev, ICH4_GPIO_CNTL, &enable);
 	if (enable & ICH4_GPIO_EN) {
 		pci_read_config_dword(dev, ICH4_GPIOBASE, &region);
-		quirk_io_region(dev, region, 64, PCI_BRIDGE_RESOURCES + 1,
-				"ICH4 GPIO");
+		region &= PCI_BASE_ADDRESS_IO_MASK;
+		if (region >= PCIBIOS_MIN_IO)
+			quirk_io_region(dev, region, 64,
+					PCI_BRIDGE_RESOURCES + 1, "ICH4 GPIO");
 	}
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,    PCI_DEVICE_ID_INTEL_82801AA_0,		quirk_ich4_lpc_acpi);
@@ -587,15 +599,19 @@ static void __devinit ich6_lpc_acpi_gpio(struct pci_dev *dev)
 	pci_read_config_byte(dev, ICH_ACPI_CNTL, &enable);
 	if (enable & ICH6_ACPI_EN) {
 		pci_read_config_dword(dev, ICH_PMBASE, &region);
-		quirk_io_region(dev, region, 128, PCI_BRIDGE_RESOURCES,
-				"ICH6 ACPI/GPIO/TCO");
+		region &= PCI_BASE_ADDRESS_IO_MASK;
+		if (region >= PCIBIOS_MIN_IO)
+			quirk_io_region(dev, region, 128, PCI_BRIDGE_RESOURCES,
+					"ICH6 ACPI/GPIO/TCO");
 	}
 
 	pci_read_config_byte(dev, ICH6_GPIO_CNTL, &enable);
 	if (enable & ICH4_GPIO_EN) {
 		pci_read_config_dword(dev, ICH6_GPIOBASE, &region);
-		quirk_io_region(dev, region, 64, PCI_BRIDGE_RESOURCES + 1,
-				"ICH6 GPIO");
+		region &= PCI_BASE_ADDRESS_IO_MASK;
+		if (region >= PCIBIOS_MIN_IO)
+			quirk_io_region(dev, region, 64,
+					PCI_BRIDGE_RESOURCES + 1, "ICH6 GPIO");
 	}
 }
 
-- 
1.7.3.4


