Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617Ab1CXFFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 01:05:39 -0400
Received: from the.earth.li ([46.43.34.31]:44508 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab1CXFFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 01:05:37 -0400
X-Greylist: delayed 1725 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Mar 2011 01:05:37 EDT
Date: Wed, 23 Mar 2011 21:36:52 -0700
From: Jonathan McDowell <noodles@earth.li>
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Re-add quirk for ServerWorks bridge secondary buses
Message-ID: <20110324043652.GA4835@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a board with a ServerWorks CIOB-X2 bridge on it (2 in fact) that
is not having the secondary buses off it correctly discovered with
2.6.38. There seems to have been some discussion about this back in
2001, when a patch very similar to the below was being discussed about
2.4. As far as I can tell the opinion was that the PCI BIOS should be
providing this information, and I can't see this quirk in git history at
all.

My board does not have a standard BIOS, so pcibios_last_bus is not
appropriately updated by the PCI BIOS routines. This quirk allows the
detection of the 8 buses that are behind the 2 bridges on my board.
Without it none of them are discovered.

(Unfortunately the unique PCI device I could potentially use as a more
specific quirk hook is behind one of these bridges, and the only useful
identifying info from the BIOS is in the MPTABLE, which doesn't appear
to be easily usable for quirks. This quirk could be tightened up to just
the CIOB-X2 entry and suit my needs, but I left the fuller table as
that's what the original patch I found had associated with it.)

Signed-Off-By: Jonathan McDowell <noodles@earth.li>

-----
diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index 6dd8955..12a0305f 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -521,3 +521,35 @@ static void sb600_disable_hpet_bar(struct pci_dev *dev)
 	}
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_ATI, 0x4385, sb600_disable_hpet_bar);
+
+/*
+ * ServerWorks host bridges -- Find and scan all secondary buses.
+ * Register 0x44 contains first, 0x45 last bus number routed there.
+ *
+ */
+static void __init pci_fixup_serverworks(struct pci_dev *dev)
+{
+	u8 busno1, busno2;
+
+	pci_read_config_byte(dev, 0x44, &busno1);
+	pci_read_config_byte(dev, 0x45, &busno2);
+	if (busno2 < busno1)
+		busno2 = busno1;
+	if (busno2 > pcibios_last_bus) {
+		pcibios_last_bus = busno2;
+		dev_info(&dev->dev, "ServerWorks host bridge: last bus %02x\n",
+			pcibios_last_bus);
+	}
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SERVERWORKS,
+		PCI_DEVICE_ID_SERVERWORKS_HE, pci_fixup_serverworks);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SERVERWORKS,
+		/* CIOB */ 0x006, pci_fixup_serverworks);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SERVERWORKS,
+		PCI_DEVICE_ID_SERVERWORKS_LE, pci_fixup_serverworks);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SERVERWORKS,
+		/* CMIC_HE */ 0x0011,  pci_fixup_serverworks);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SERVERWORKS,
+		/* CMIC_LE_IMBB */ 0x0000, pci_fixup_serverworks);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SERVERWORKS,
+		/* CIOBX2 */ 0x0101, pci_fixup_serverworks);
-----

J.

-- 
Most people are descended from apes. Redheads are descended from cats.
