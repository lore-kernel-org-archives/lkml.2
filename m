Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab1CUXSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:18:39 -0400
Received: from kroah.org ([198.145.64.141]:52690 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932326Ab1CUXSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:18:12 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:26 2011
Message-Id: <20110321230326.659837477@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:02:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Renninger <trenn@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [48/78] PCI: do not create quirk I/O regions below PCIBIOS_MIN_IO for ICH
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit 87e3dc3855430bd254370afc79f2ed92250f5b7c upstream.

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
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/quirks.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -554,18 +554,30 @@ static void __devinit quirk_ich4_lpc_acp
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
@@ -587,15 +599,19 @@ static void __devinit ich6_lpc_acpi_gpio
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
 


