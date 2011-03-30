Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933771Ab1C3V0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:26:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:51977 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965077Ab1C3VJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673448422"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: jslaby@suse.cz, ak@linux.intel.com, bjorn.helgaas@hp.com,
        davem@davemloft.net, trenn@suse.de, jbarnes@virtuousgeek.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [204/275] PCI: do not create quirk I/O regions below PCIBIOS_MIN_IO for ICH
Message-Id: <20110330210728.7B7963E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/quirks.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

Index: linux-2.6.35.y/drivers/pci/quirks.c
===================================================================
--- linux-2.6.35.y.orig/drivers/pci/quirks.c	2011-03-29 23:03:02.500236196 -0700
+++ linux-2.6.35.y/drivers/pci/quirks.c	2011-03-29 23:03:02.520235684 -0700
@@ -540,18 +540,30 @@
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
@@ -573,15 +585,19 @@
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
 
