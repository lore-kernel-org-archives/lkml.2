Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab2HGQUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:20:04 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51881 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524Ab2HGQT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:19:59 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v1 09/22] PCI: enhance PCI probe logic to support PCI bus lock mechanism
Date: Wed,  8 Aug 2012 00:10:49 +0800
Message-Id: <1344355862-2726-10-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
References: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enhances PCI probe logic to support PCI bus lock mechanism.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/probe.c |   65 +++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 50 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 1f64e8d..e6b40d0 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -460,6 +460,8 @@ static struct pci_bus * pci_alloc_bus(void)
 		b->max_bus_speed = PCI_SPEED_UNKNOWN;
 		b->cur_bus_speed = PCI_SPEED_UNKNOWN;
 		device_initialize(&b->dev);
+		atomic_set(&b->state,
+			   PCI_BUS_STATE_INITIALIZED | PCI_BUS_STATE_LOCK);
 	}
 	return b;
 }
@@ -753,14 +755,21 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 		 * However, we continue to descend down the hierarchy and
 		 * scan remaining child buses.
 		 */
-		child = pci_find_bus(pci_domain_nr(bus), secondary);
-		if (!child) {
+		child = __pci_get_and_lock_bus(pci_domain_nr(bus), secondary,
+					       PCI_BUS_STATE_MASK);
+		if (child) {
+			if (pci_bus_get_state(child) > PCI_BUS_STATE_WORKING) {
+				pci_unlock_and_put_bus(child);
+				goto out;
+			}
+		} else {
 			child = pci_add_new_bus(bus, dev, secondary);
 			if (!child)
 				goto out;
 			child->primary = primary;
 			pci_bus_insert_busn_res(child, secondary, subordinate);
 			child->bridge_ctl = bctl;
+			pci_bus_get(child);
 		}
 
 		cmax = pci_scan_child_bus(child);
@@ -792,12 +801,19 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 		/* Prevent assigning a bus number that already exists.
 		 * This can happen when a bridge is hot-plugged, so in
 		 * this case we only re-scan this bus. */
-		child = pci_find_bus(pci_domain_nr(bus), max+1);
-		if (!child) {
+		child = __pci_get_and_lock_bus(pci_domain_nr(bus), secondary,
+					       PCI_BUS_STATE_MASK);
+		if (child) {
+			if (pci_bus_get_state(child) > PCI_BUS_STATE_WORKING) {
+				pci_unlock_and_put_bus(child);
+				goto out;
+			}
+		} else {
 			child = pci_add_new_bus(bus, dev, ++max);
 			if (!child)
 				goto out;
 			pci_bus_insert_busn_res(child, max, 0xff);
+			pci_bus_get(child);
 		}
 		buses = (buses & 0xff000000)
 		      | ((unsigned int)(child->primary)     <<  0)
@@ -896,6 +912,8 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 		bus = bus->parent;
 	}
 
+	pci_unlock_and_put_bus(child);
+
 out:
 	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, bctl);
 
@@ -1605,11 +1623,14 @@ unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus)
 	 * After performing arch-dependent fixup of the bus, look behind
 	 * all PCI-to-PCI bridges on this bus.
 	 */
-	if (!bus->is_added) {
+	if (pci_bus_get_state(bus) < PCI_BUS_STATE_WORKING) {
 		dev_dbg(&bus->dev, "fixups for bus\n");
 		pcibios_fixup_bus(bus);
-		if (pci_is_root_bus(bus))
+		if (pci_is_root_bus(bus)) {
+			pci_bus_change_state(bus, PCI_BUS_STATE_REGISTERED,
+					     PCI_BUS_STATE_WORKING, false);
 			bus->is_added = 1;
+		}
 	}
 
 	for (pass=0; pass < 2; pass++)
@@ -1630,6 +1651,11 @@ unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus)
 	return max;
 }
 
+/*
+ * Create a PCI root bus and return with the new root bus locked.
+ * Caller needs to call pci_bus_unlock() to unlock the new root bus after
+ * scanning and configuring children under the new root bus.
+ */
 struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 		struct pci_ops *ops, void *sysdata, struct list_head *resources)
 {
@@ -1716,6 +1742,9 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 	list_add_tail(&b->node, &pci_root_buses);
 	up_write(&pci_bus_sem);
 
+	pci_bus_change_state(b, PCI_BUS_STATE_INITIALIZED,
+			     PCI_BUS_STATE_REGISTERED, false);
+
 	return b;
 
 class_dev_reg_err:
@@ -1724,7 +1753,7 @@ class_dev_reg_err:
 bridge_dev_reg_err:
 	kfree(bridge);
 err_out:
-	kfree(b);
+	pci_unlock_and_put_bus(b);
 	return NULL;
 }
 
@@ -1827,6 +1856,8 @@ struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
 		pci_bus_update_busn_res_end(b, max);
 
 	pci_bus_add_devices(b);
+	pci_bus_unlock(b);
+
 	return b;
 }
 EXPORT_SYMBOL(pci_scan_root_bus);
@@ -1842,10 +1873,12 @@ struct pci_bus * __devinit pci_scan_bus_parented(struct device *parent,
 	pci_add_resource(&resources, &iomem_resource);
 	pci_add_resource(&resources, &busn_resource);
 	b = pci_create_root_bus(parent, bus, ops, sysdata, &resources);
-	if (b)
+	if (b) {
 		pci_scan_child_bus(b);
-	else
+		pci_bus_unlock(b);
+	} else {
 		pci_free_resource_list(&resources);
+	}
 	return b;
 }
 EXPORT_SYMBOL(pci_scan_bus_parented);
@@ -1863,6 +1896,7 @@ struct pci_bus * __devinit pci_scan_bus(int bus, struct pci_ops *ops,
 	if (b) {
 		pci_scan_child_bus(b);
 		pci_bus_add_devices(b);
+		pci_bus_unlock(b);
 	} else {
 		pci_free_resource_list(&resources);
 	}
@@ -1884,14 +1918,15 @@ EXPORT_SYMBOL(pci_scan_bus);
  */
 unsigned int __ref pci_rescan_bus_bridge_resize(struct pci_dev *bridge)
 {
-	unsigned int max;
+	unsigned int max = -1;
 	struct pci_bus *bus = bridge->subordinate;
 
-	max = pci_scan_child_bus(bus);
-
-	pci_assign_unassigned_bridge_resources(bridge);
-
-	pci_bus_add_devices(bus);
+	if (pci_bus_lock_states(bus, PCI_BUS_STATE_WORKING) > 0) {
+		max = pci_scan_child_bus(bus);
+		pci_assign_unassigned_bridge_resources(bridge);
+		pci_bus_add_devices(bus);
+		pci_bus_unlock(bus);
+	}
 
 	return max;
 }
-- 
1.7.9.5

