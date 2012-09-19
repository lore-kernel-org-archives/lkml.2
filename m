Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab2ISTGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 15:06:07 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:19491 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233Ab2ISSzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 14:55:15 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 06/40] PCI: Split out stop_bus_device and remove_bus_dev again.
Date: Wed, 19 Sep 2012 11:54:20 -0700
Message-Id: <1348080894-23412-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1348080894-23412-1-git-send-email-yinghai@kernel.org>
References: <CAE9FiQWFcVNKMnV1qaHchwCXfZuMpyxf_f7GQy3FZid9YuLD3w@mail.gmail.com>
 <1348080894-23412-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So later could use them for pci root bus hotplug support.

Also restore old behavoir: stop all at first then remove all.

-v2: only split the functions.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/remove.c |   51 ++++++++++++++++++++++++++++++++++---------------
 1 files changed, 35 insertions(+), 16 deletions(-)

diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 4f9ca91..513972f 100644
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
@@ -82,13 +70,44 @@ void pci_stop_and_remove_bus_device(struct pci_dev *dev)
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
-- 
1.7.7

