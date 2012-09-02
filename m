Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab2IBVtP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:49:15 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:32884 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359Ab2IBVsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:48:01 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH part1 4/4] PCI: Split out stop_bus_device and remove_bus_dev again.
Date: Sun,  2 Sep 2012 14:47:38 -0700
Message-Id: <1346622458-30595-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346622458-30595-1-git-send-email-yinghai@kernel.org>
References: <1346622458-30595-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So add back some functions that are needed for pci root bus hotplug support.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/remove.c |   77 +++++++++++++++++++++++++++++++++++++++----------
 include/linux/pci.h  |    2 +
 2 files changed, 63 insertions(+), 16 deletions(-)

diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 4f9ca91..aaae16e 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -56,25 +56,13 @@ void pci_remove_bus(struct pci_bus *bus)
 }
 EXPORT_SYMBOL(pci_remove_bus);
 
-/**
- * pci_stop_and_remove_bus_device - remove a PCI device and any children
- * @dev: the device to remove
- *
- * Remove a PCI device from the device lists, informing the drivers
- * that the device has been removed.  We also remove any subordinate
- * buses and children in a depth-first manner.
- *
- * For each device we remove, delete the device structure from the
- * device lists, remove the /proc entry, and notify userspace
- * (/sbin/hotplug).
- */
-void pci_stop_and_remove_bus_device(struct pci_dev *dev)
+static void pci_stop_bus_device(struct pci_dev *dev)
 {
 	struct pci_bus *bus = dev->subordinate;
 	struct pci_dev *child, *tmp;
 
 	/*
-	 * Removing an SR-IOV PF device removes all the associated VFs,
+	 * Stopping an SR-IOV PF device removes all the associated VFs,
 	 * which will update the bus->devices list and confuse the
 	 * iterator.  Therefore, iterate in reverse so we remove the VFs
 	 * first, then the PF.
@@ -82,13 +70,70 @@ void pci_stop_and_remove_bus_device(struct pci_dev *dev)
 	if (bus) {
 		list_for_each_entry_safe_reverse(child, tmp,
 						 &bus->devices, bus_list)
-			pci_stop_and_remove_bus_device(child);
+			pci_stop_bus_device(child);
+	}
+
+	pci_stop_dev(dev);
+}
+
+static void pci_remove_bus_device(struct pci_dev *dev)
+{
+	struct pci_bus *bus = dev->subordinate;
+	struct pci_dev *child, *tmp;
+
+	if (bus) {
+		list_for_each_entry_safe(child, tmp,
+					 &bus->devices, bus_list)
+			pci_remove_bus_device(child);
 
 		pci_remove_bus(bus);
 		dev->subordinate = NULL;
 	}
 
-	pci_stop_dev(dev);
 	pci_destroy_dev(dev);
 }
+
+/**
+ * pci_stop_and_remove_bus_device - remove a PCI device and any children
+ * @dev: the device to remove
+ *
+ * Remove a PCI device from the device lists, informing the drivers
+ * that the device has been removed.  We also remove any subordinate
+ * buses and children in a depth-first manner.
+ *
+ * For each device we remove, delete the device structure from the
+ * device lists, remove the /proc entry, and notify userspace
+ * (/sbin/hotplug).
+ */
+void pci_stop_and_remove_bus_device(struct pci_dev *dev)
+{
+	pci_stop_bus_device(dev);
+	pci_remove_bus_device(dev);
+}
 EXPORT_SYMBOL(pci_stop_and_remove_bus_device);
+
+void pci_stop_bus_devices(struct pci_bus *bus)
+{
+	struct pci_dev *child, *tmp;
+
+	list_for_each_entry_safe_reverse(child, tmp,
+					 &bus->devices, bus_list)
+		pci_stop_bus_device(child);
+}
+
+static void pci_remove_bus_devices(struct pci_bus *bus)
+{
+	struct pci_dev *child, *tmp;
+
+	list_for_each_entry_safe(child, tmp,
+				 &bus->devices, bus_list)
+		pci_remove_bus_device(child);
+}
+
+void pci_stop_and_remove_behind_bridge(struct pci_dev *dev)
+{
+	pci_stop_bus_device(dev);
+
+	if (dev->subordinate)
+		pci_remove_bus_devices(dev->subordinate);
+}
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 0d87189..1b460e1 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -734,6 +734,8 @@ extern struct pci_dev *pci_dev_get(struct pci_dev *dev);
 extern void pci_dev_put(struct pci_dev *dev);
 extern void pci_remove_bus(struct pci_bus *b);
 extern void pci_stop_and_remove_bus_device(struct pci_dev *dev);
+void pci_stop_bus_devices(struct pci_bus *bus);
+void pci_stop_and_remove_behind_bridge(struct pci_dev *dev);
 void pci_setup_cardbus(struct pci_bus *bus);
 extern void pci_sort_breadthfirst(void);
 #define dev_is_pci(d) ((d)->bus == &pci_bus_type)
-- 
1.7.7

