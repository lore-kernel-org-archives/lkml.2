Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab2AUKJs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 05:09:48 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:22203 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab2AUKJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 05:09:00 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 06/21] PCI: Make rescan bus could increase bridge resource size if needed
Date: Sat, 21 Jan 2012 02:08:22 -0800
Message-Id: <1327140517-14811-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
References: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4F1A8EB7.004B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current rescan will not touch bridge MMIO and IO.

Try to reuse pci_assign_unassigned_bridge_resources(bridge) to update bridge
resource, if child devices need more resource.

only do that for bridges that all children get removed before. So do not
release resources that could already be used by drivers of child devices.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/pci-sysfs.c |    5 ++++-
 drivers/pci/probe.c     |   24 ++++++++++++++++++++++++
 include/linux/pci.h     |    1 +
 3 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 106be0d..87ddbca 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -366,7 +366,10 @@ dev_bus_rescan_store(struct device *dev, struct device_attribute *attr,
 
 	if (val) {
 		mutex_lock(&pci_remove_rescan_mutex);
-		pci_rescan_bus(bus);
+		if (!pci_is_root_bus(bus) && list_empty(&bus->devices))
+			pci_rescan_bus_bridge_resize(bus->self);
+		else
+			pci_rescan_bus(bus);
 		mutex_unlock(&pci_remove_rescan_mutex);
 	}
 	return count;
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 04e74f4..24c8710 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1608,6 +1608,30 @@ EXPORT_SYMBOL(pci_scan_bus_parented);
 
 #ifdef CONFIG_HOTPLUG
 /**
+ * pci_rescan_bus_bridge_resize - scan a PCI bus for devices.
+ * @bridge: PCI bridge for the bus to scan
+ *
+ * Scan a PCI bus and child buses for new devices, adds them,
+ * and enables them, it will resize bridge mmio/io resource if it is possible
+ * for safe, caller should make sure that children get removed already.
+ *
+ * Returns the max number of subordinate bus discovered.
+ */
+unsigned int __ref pci_rescan_bus_bridge_resize(struct pci_dev *bridge)
+{
+	unsigned int max;
+	struct pci_bus *bus = bridge->subordinate;
+
+	max = pci_scan_child_bus(bus);
+
+	pci_assign_unassigned_bridge_resources(bridge);
+
+	pci_bus_add_devices(bus);
+
+	return max;
+}
+
+/**
  * pci_rescan_bus - scan a PCI bus for devices.
  * @bus: PCI bus to scan
  *
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 7cda65b..841ba6f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -879,6 +879,7 @@ void set_pcie_hotplug_bridge(struct pci_dev *pdev);
 /* Functions for PCI Hotplug drivers to use */
 int pci_bus_find_capability(struct pci_bus *bus, unsigned int devfn, int cap);
 #ifdef CONFIG_HOTPLUG
+unsigned int pci_rescan_bus_bridge_resize(struct pci_dev *bridge);
 unsigned int pci_rescan_bus(struct pci_bus *bus);
 #endif
 
-- 
1.7.7

