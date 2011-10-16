Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab1JPBcd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 21:32:33 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:47567 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab1JPBca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 21:32:30 -0400
Message-ID: <4E9A3423.8060907@oracle.com>
Date: Sat, 15 Oct 2011 18:32:19 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/8] PCI: Make rescan bus could increase bridge resource size
 if needed
References: <4E9A3092.4080309@oracle.com>
In-Reply-To: <4E9A3092.4080309@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090203.4E9A342E.0060,ss=1,re=0.000,fgs=0
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
 3 files changed, 29 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/pci-sysfs.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-sysfs.c
+++ linux-2.6/drivers/pci/pci-sysfs.c
@@ -365,7 +365,10 @@ dev_bus_rescan_store(struct device *dev,
 
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
Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -1601,6 +1601,30 @@ EXPORT_SYMBOL(pci_scan_bus_parented);
 
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
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -875,6 +875,7 @@ void set_pcie_hotplug_bridge(struct pci_
 /* Functions for PCI Hotplug drivers to use */
 int pci_bus_find_capability(struct pci_bus *bus, unsigned int devfn, int cap);
 #ifdef CONFIG_HOTPLUG
+unsigned int pci_rescan_bus_bridge_resize(struct pci_dev *bridge);
 unsigned int pci_rescan_bus(struct pci_bus *bus);
 #endif
 
