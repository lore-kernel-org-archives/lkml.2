Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab2HGQUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:20:45 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:58061 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666Ab2HGQUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:20:42 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v1 14/22] PCI/sysfs: use PCI bus lock to avoid race conditions
Date: Wed,  8 Aug 2012 00:10:54 +0800
Message-Id: <1344355862-2726-15-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
References: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses PCI bus lock mechanism to avoid race conditions when doing
PCI device/host bridge hotplug through PCI sysfs interfaces.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/pci-sysfs.c |   26 +++++++++++++++++++++-----
 drivers/pci/probe.c     |   17 +++++++++++------
 2 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 99fefbe..11043b4 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -298,7 +298,10 @@ static ssize_t bus_rescan_store(struct bus_type *bus, const char *buf,
 		pci_host_bridge_hotplug_lock();
 		mutex_lock(&pci_remove_rescan_mutex);
 		while ((b = pci_find_next_bus(b)) != NULL)
-			pci_rescan_bus(b);
+			if (pci_bus_lock_states(b, PCI_BUS_STATE_WORKING) > 0) {
+				pci_rescan_bus(b);
+				pci_bus_unlock(b);
+			}
 		mutex_unlock(&pci_remove_rescan_mutex);
 		pci_host_bridge_hotplug_unlock();
 	}
@@ -321,8 +324,14 @@ dev_rescan_store(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 
 	if (val) {
+		struct pci_bus *bus = pdev->bus;
+
 		mutex_lock(&pci_remove_rescan_mutex);
-		pci_rescan_bus(pdev->bus);
+		if (pci_bus_lock_states(bus, PCI_BUS_STATE_WORKING) > 0) {
+			if (pdev->is_added)
+				pci_rescan_bus(bus);
+			pci_bus_unlock(bus);
+		}
 		mutex_unlock(&pci_remove_rescan_mutex);
 	}
 	return count;
@@ -331,9 +340,14 @@ dev_rescan_store(struct device *dev, struct device_attribute *attr,
 static void remove_callback(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
+	struct pci_bus *bus = pdev->bus;
 
 	mutex_lock(&pci_remove_rescan_mutex);
-	pci_stop_and_remove_bus_device(pdev);
+	if (pci_bus_lock_states(bus, PCI_BUS_STATE_WORKING) > 0) {
+		pci_bus_get(bus);
+		pci_stop_and_remove_bus_device(pdev);
+		pci_unlock_and_put_bus(bus);
+	}
 	mutex_unlock(&pci_remove_rescan_mutex);
 }
 
@@ -369,10 +383,12 @@ dev_bus_rescan_store(struct device *dev, struct device_attribute *attr,
 
 	if (val) {
 		mutex_lock(&pci_remove_rescan_mutex);
-		if (!pci_is_root_bus(bus) && list_empty(&bus->devices))
+		if (!pci_is_root_bus(bus))
 			pci_rescan_bus_bridge_resize(bus->self);
-		else
+		else if (pci_bus_lock_states(bus, PCI_BUS_STATE_WORKING) > 0) {
 			pci_rescan_bus(bus);
+			pci_bus_unlock(bus);
+		}
 		mutex_unlock(&pci_remove_rescan_mutex);
 	}
 	return count;
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 47bf071..da6f04c 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1919,12 +1919,17 @@ EXPORT_SYMBOL(pci_scan_bus);
 unsigned int __ref pci_rescan_bus_bridge_resize(struct pci_dev *bridge)
 {
 	unsigned int max = -1;
-	struct pci_bus *bus = bridge->subordinate;
-
-	if (pci_bus_lock_states(bus, PCI_BUS_STATE_WORKING) > 0) {
-		max = pci_scan_child_bus(bus);
-		pci_assign_unassigned_bridge_resources(bridge);
-		pci_bus_add_devices(bus);
+	struct pci_bus *bus;
+
+	bus = pci_lock_subordinate(bridge, PCI_BUS_STATE_WORKING);
+	if (bus) {
+		if (list_empty(&bus->devices)) {
+			max = pci_scan_child_bus(bus);
+			pci_assign_unassigned_bridge_resources(bridge);
+			pci_bus_add_devices(bus);
+		} else {
+			pci_rescan_bus(bus);
+		}
 		pci_bus_unlock(bus);
 	}
 
-- 
1.7.9.5

