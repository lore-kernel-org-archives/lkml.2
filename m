Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab2AUKJv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 05:09:51 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:22218 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab2AUKJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 05:09:01 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 07/21] PCI: Make pci_rescan_bus handle add_list
Date: Sat, 21 Jan 2012 02:08:23 -0800
Message-Id: <1327140517-14811-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
References: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4F1A8EB9.008F,ss=1,re=0.000,fgs=0
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

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 24c8710..7232fc8 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1631,38 +1631,6 @@ unsigned int __ref pci_rescan_bus_bridge_resize(struct pci_dev *bridge)
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
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 97c1eda..c09c67a 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1357,3 +1357,42 @@ enable_all:
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
-- 
1.7.7

