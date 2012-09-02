Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab2IBWAw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 18:00:52 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:19777 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741Ab2IBVwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:52:33 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH part3 01/11] PCI: Separate out pci_assign_unassigned_bus_resources()
Date: Sun,  2 Sep 2012 14:52:11 -0700
Message-Id: <1346622741-30799-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346622741-30799-1-git-send-email-yinghai@kernel.org>
References: <1346622741-30799-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is main portion of pci_rescan_bus().

Separate it out and need to use it for pci root bus hot add later.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |   32 ++++++++++++++++++--------------
 include/linux/pci.h     |    1 +
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index f0e959c..e5c45c8 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1511,25 +1511,12 @@ enable_all:
 }
 EXPORT_SYMBOL_GPL(pci_assign_unassigned_bridge_resources);
 
-#ifdef CONFIG_HOTPLUG
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
+void pci_assign_unassigned_bus_resources(struct pci_bus *bus)
 {
-	unsigned int max;
 	struct pci_dev *dev;
 	LIST_HEAD(add_list); /* list of resources that
 					want additional resources */
 
-	max = pci_scan_child_bus(bus);
-
 	down_read(&pci_bus_sem);
 	list_for_each_entry(dev, &bus->devices, bus_list)
 		if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
@@ -1542,6 +1529,23 @@ unsigned int __ref pci_rescan_bus(struct pci_bus *bus)
 	BUG_ON(!list_empty(&add_list));
 
 	pci_enable_bridges(bus);
+}
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
+
+	max = pci_scan_child_bus(bus);
+	pci_assign_unassigned_bus_resources(bus);
 	pci_bus_add_devices(bus);
 
 	return max;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 29a4704..1bd7559 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -983,6 +983,7 @@ void pci_bus_size_bridges(struct pci_bus *bus);
 int pci_claim_resource(struct pci_dev *, int);
 void pci_assign_unassigned_resources(void);
 void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge);
+void pci_assign_unassigned_bus_resources(struct pci_bus *bus);
 void pdev_enable_device(struct pci_dev *);
 int pci_enable_resources(struct pci_dev *, int mask);
 void pci_fixup_irqs(u8 (*)(struct pci_dev *, u8 *),
-- 
1.7.7

