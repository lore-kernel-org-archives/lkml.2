Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab2HGQUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:20:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51364 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601Ab2HGQUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:20:07 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v1 10/22] PCI: enhance PCI bus specific logic to support PCI bus lock mechanism
Date: Wed,  8 Aug 2012 00:10:50 +0800
Message-Id: <1344355862-2726-11-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
References: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enhances PCI bus specific logic to support PCI bus lock mechanism.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/bus.c |   54 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 23 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index b6aacaa..371f20a 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -185,19 +185,20 @@ int pci_bus_add_device(struct pci_dev *dev)
  */
 int pci_bus_add_child(struct pci_bus *bus)
 {
-	int retval;
-
-	if (bus->bridge)
-		bus->dev.parent = bus->bridge;
-
-	retval = device_add(&bus->dev);
-	if (retval)
-		return retval;
-
-	bus->is_added = 1;
-
-	/* Create legacy_io and legacy_mem files for this bus */
-	pci_create_legacy_files(bus);
+	int retval = -EBUSY;
+
+	if (pci_bus_get_state(bus) == PCI_BUS_STATE_INITIALIZED) {
+		if (bus->bridge)
+			bus->dev.parent = bus->bridge;
+		retval = device_add(&bus->dev);
+		if (retval == 0) {
+			/* Create legacy_io and legacy_mem files for this bus */
+			pci_create_legacy_files(bus);
+			pci_bus_change_state(bus, PCI_BUS_STATE_INITIALIZED,
+					PCI_BUS_STATE_WORKING, false);
+			bus->is_added = 1;
+		}
+	}
 
 	return retval;
 }
@@ -232,13 +233,14 @@ void pci_bus_add_devices(const struct pci_bus *bus)
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		BUG_ON(!dev->is_added);
 
-		child = dev->subordinate;
+		child = pci_lock_subordinate(dev, PCI_BUS_STATE_STOPPING - 1);
+		if (!child)
+			continue;
+
 		/*
 		 * If there is an unattached subordinate bus, attach
 		 * it and then scan for unattached PCI devices.
 		 */
-		if (!child)
-			continue;
 		if (list_empty(&child->node)) {
 			down_write(&pci_bus_sem);
 			list_add_tail(&child->node, &dev->bus->children);
@@ -250,28 +252,34 @@ void pci_bus_add_devices(const struct pci_bus *bus)
 		 * register the bus with sysfs as the parent is now
 		 * properly registered.
 		 */
-		if (child->is_added)
-			continue;
-		retval = pci_bus_add_child(child);
-		if (retval)
-			dev_err(&dev->dev, "Error adding bus, continuing\n");
+		if (pci_bus_get_state(child) == PCI_BUS_STATE_INITIALIZED) {
+			retval = pci_bus_add_child(child);
+			if (retval)
+				dev_err(&dev->dev,
+					"Error adding bus, continuing\n");
+		}
+
+		pci_bus_unlock(child);
 	}
 }
 
 void pci_enable_bridges(struct pci_bus *bus)
 {
 	struct pci_dev *dev;
+	struct pci_bus *child;
 	int retval;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
-		if (dev->subordinate) {
+		child = pci_lock_subordinate(dev, PCI_BUS_STATE_STOPPING - 1);
+		if (child) {
 			if (!pci_is_enabled(dev)) {
 				retval = pci_enable_device(dev);
 				if (retval)
 					dev_err(&dev->dev, "Error enabling bridge (%d), continuing\n", retval);
 				pci_set_master(dev);
 			}
-			pci_enable_bridges(dev->subordinate);
+			pci_enable_bridges(child);
+			pci_bus_unlock(child);
 		}
 	}
 }
-- 
1.7.9.5

