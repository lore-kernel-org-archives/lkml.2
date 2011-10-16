Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1JPBck (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 21:32:40 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:47571 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab1JPBcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 21:32:36 -0400
Message-ID: <4E9A3429.1060506@oracle.com>
Date: Sat, 15 Oct 2011 18:32:25 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/8] PCI: Make pci_rescan_bus handle add_list
References: <4E9A3092.4080309@oracle.com>
In-Reply-To: <4E9A3092.4080309@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4E9A3433.00D8:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So it will allocate resource to hotplug bridge during remove/rescan.

Need to move that function to setup-bus.c so it could use
  __pci_bus_size_bridges and __pci_bus_assign_resources
directly to take add_list.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/probe.c     |   32 --------------------------------
 drivers/pci/setup-bus.c |   39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 32 deletions(-)

Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -1624,38 +1624,6 @@ unsigned int __ref pci_rescan_bus_bridge
 	return max;
 }
 
-/**
- * pci_rescan_bus - scan a PCI bus for devices.
- * @bus: PCI bus to scan
- *
- * Scan a PCI bus and child buses for new devices, adds them,
- * and enables them.
- *
- * Returns the max number of subordinate bus discovered.
- */
-unsigned int __ref pci_rescan_bus(struct pci_bus *bus)
-{
-	unsigned int max;
-	struct pci_dev *dev;
-
-	max = pci_scan_child_bus(bus);
-
-	down_read(&pci_bus_sem);
-	list_for_each_entry(dev, &bus->devices, bus_list)
-		if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
-		    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)
-			if (dev->subordinate)
-				pci_bus_size_bridges(dev->subordinate);
-	up_read(&pci_bus_sem);
-
-	pci_bus_assign_resources(bus);
-	pci_enable_bridges(bus);
-	pci_bus_add_devices(bus);
-
-	return max;
-}
-EXPORT_SYMBOL_GPL(pci_rescan_bus);
-
 EXPORT_SYMBOL(pci_add_new_bus);
 EXPORT_SYMBOL(pci_scan_slot);
 EXPORT_SYMBOL(pci_scan_bridge);
Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -1354,3 +1354,42 @@ enable_all:
 	pci_enable_bridges(parent);
 }
 EXPORT_SYMBOL_GPL(pci_assign_unassigned_bridge_resources);
+
+#ifdef CONFIG_HOTPLUG
+/**
+ * pci_rescan_bus - scan a PCI bus for devices.
+ * @bus: PCI bus to scan
+ *
+ * Scan a PCI bus and child buses for new devices, adds them,
+ * and enables them.
+ *
+ * Returns the max number of subordinate bus discovered.
+ */
+unsigned int __ref pci_rescan_bus(struct pci_bus *bus)
+{
+	unsigned int max;
+	struct pci_dev *dev;
+	struct resource_list_x add_list; /* list of resources that
+					want additional resources */
+
+	max = pci_scan_child_bus(bus);
+
+	add_list.next = NULL;
+	down_read(&pci_bus_sem);
+	list_for_each_entry(dev, &bus->devices, bus_list)
+		if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
+		    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)
+			if (dev->subordinate)
+				__pci_bus_size_bridges(dev->subordinate,
+							 &add_list);
+	up_read(&pci_bus_sem);
+	__pci_bus_assign_resources(bus, &add_list, NULL);
+	BUG_ON(add_list.next);
+
+	pci_enable_bridges(bus);
+	pci_bus_add_devices(bus);
+
+	return max;
+}
+EXPORT_SYMBOL_GPL(pci_rescan_bus);
+#endif
