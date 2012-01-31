Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab2AaHoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 02:44:25 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:47246 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab2AaHnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 02:43:40 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 14/14] PCI: Seperate child bus scanning to two passes overall
Date: Mon, 30 Jan 2012 23:42:52 -0800
Message-Id: <1327995772-11388-15-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327995772-11388-1-git-send-email-yinghai@kernel.org>
References: <1327995772-11388-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090204.4F279BA5.002C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In extreme case: Two bridges are properly setup.
       bridge A
               bridge AA
               bridge AB
       bridge B
	       bridge BA
	       bridge BB
   but AA, AB are not setup properly.
   bridge A has small range, and bridge AB could need more, when do the
       first pass0 for bridge A, it will do pass0 and pass1 for AA and AB,
	during that process, it will extend range of A for AB blindly.
	because bridge B is not registered yet.
       that could overlap range that is used by bridge B.

Right way should be:
       do pass0 for all good bridges at first.
So we could do pass0 for bridge B before pass1 for bridge AB.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   50 ++++++++++++++++++++++++++++++++++----------------
 1 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 86a4402..2907b74 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -793,6 +793,9 @@ static int __devinit pci_bridge_check_busn_broken(struct pci_bus *bus,
 
 	return broken;
 }
+
+static unsigned int __devinit __pci_scan_child_bus(struct pci_bus *bus,
+						 int pass);
 /*
  * If it's a bridge, configure it and scan the bus behind it.
  * For CardBus bridges, we don't scan behind as the devices will
@@ -844,11 +847,10 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 	    !is_cardbus && !broken) {
 		unsigned int cmax;
 		/*
-		 * Bus already configured by firmware, process it in the first
-		 * pass and just note the configuration.
+		 * Bus already configured by firmware, still process it in two
+		 * passes in extreme case like two adjaced bridges have children
+		 * bridges that are not setup properly.
 		 */
-		if (pass)
-			goto out;
 
 		/*
 		 * If we already got to this bus through a different bridge,
@@ -869,7 +871,7 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 			pci_bus_insert_busn_res(child, secondary, subordinate);
 		}
 
-		cmax = pci_scan_child_bus(child);
+		cmax = __pci_scan_child_bus(child, pass);
 		if (cmax > max)
 			max = cmax;
 		if (child->subordinate > max)
@@ -1659,12 +1661,13 @@ void pcie_bus_configure_settings(struct pci_bus *bus, u8 mpss)
 }
 EXPORT_SYMBOL_GPL(pcie_bus_configure_settings);
 
-unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus)
+static unsigned int __devinit __pci_scan_child_bus(struct pci_bus *bus,
+						 int pass)
 {
-	unsigned int devfn, pass, max = bus->secondary;
+	unsigned int devfn, max = bus->secondary;
 	struct pci_dev *dev;
 
-	dev_dbg(&bus->dev, "scanning bus\n");
+	dev_dbg(&bus->dev, "scanning bus pass %d\n", pass);
 
 	/* Go find them, Rover! */
 	for (devfn = 0; devfn < 0x100; devfn += 8)
@@ -1678,18 +1681,16 @@ unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus)
 	 * all PCI-to-PCI bridges on this bus.
 	 */
 	if (!bus->is_added) {
-		dev_dbg(&bus->dev, "fixups for bus\n");
+		dev_dbg(&bus->dev, "fixups for bus pass %d\n", pass);
 		pcibios_fixup_bus(bus);
 		if (pci_is_root_bus(bus))
 			bus->is_added = 1;
 	}
 
-	for (pass=0; pass < 2; pass++)
-		list_for_each_entry(dev, &bus->devices, bus_list) {
-			if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
-			    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)
-				max = pci_scan_bridge(bus, dev, max, pass);
-		}
+	list_for_each_entry(dev, &bus->devices, bus_list)
+		if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
+		    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)
+			max = pci_scan_bridge(bus, dev, max, pass);
 
 	/*
 	 * We've scanned the bus and so we know all about what's on
@@ -1698,7 +1699,24 @@ unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus)
 	 *
 	 * Return how far we've got finding sub-buses.
 	 */
-	dev_dbg(&bus->dev, "bus scan returning with max=%02x\n", max);
+	dev_dbg(&bus->dev, "bus scan returning with max=%02x pass %d\n",
+			max, pass);
+
+	return max;
+}
+
+unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus)
+{
+	int pass;
+	unsigned int max = 0, tmp;
+
+	for (pass = 0; pass < 2;  pass++) {
+		tmp = __pci_scan_child_bus(bus, pass);
+
+		if (tmp > max)
+			max = tmp;
+	}
+
 	return max;
 }
 
-- 
1.7.7

