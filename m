Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab2HGQUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:20:33 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:58061 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637Ab2HGQU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:20:28 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v1 12/22] PCI: enhance PCI remove logic to support PCI bus lock mechanism
Date: Wed,  8 Aug 2012 00:10:52 +0800
Message-Id: <1344355862-2726-13-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
References: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enhances PCI remove logic to support PCI bus lock mechanism.
It implements the major part of the PCI bus state machine.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/remove.c |  146 +++++++++++++++++++++++++++++---------------------
 1 file changed, 85 insertions(+), 61 deletions(-)

diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index ba03059..a26a841 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -26,21 +26,25 @@ static void pci_stop_dev(struct pci_dev *dev)
 		dev->is_added = 0;
 	}
 
+	/* TODO: check whether it's safe to call aspm here */
 	if (dev->bus->self)
 		pcie_aspm_exit_link_state(dev);
 }
 
 static void pci_destroy_dev(struct pci_dev *dev)
 {
-	/* Remove the device from the device lists, and prevent any further
-	 * list accesses from this device */
 	down_write(&pci_bus_sem);
-	list_del(&dev->bus_list);
-	dev->bus_list.next = dev->bus_list.prev = NULL;
-	up_write(&pci_bus_sem);
-
-	pci_free_resources(dev);
-	put_device(&dev->dev);
+	if (dev->bus_list.next == NULL) {
+		up_write(&pci_bus_sem);
+	} else {
+		/* Remove the device from the device lists, and prevent any
+		 * further list accesses from this device */
+		list_del(&dev->bus_list);
+		dev->bus_list.next = dev->bus_list.prev = NULL;
+		up_write(&pci_bus_sem);
+		pci_free_resources(dev);
+		put_device(&dev->dev);
+	}
 }
 
 /**
@@ -64,29 +68,44 @@ int pci_remove_device_safe(struct pci_dev *dev)
 
 void pci_remove_bus(struct pci_bus *pci_bus)
 {
-	pci_proc_detach_bus(pci_bus);
+	int state = pci_bus_get_state(pci_bus);
 
-	down_write(&pci_bus_sem);
-	list_del(&pci_bus->node);
-	pci_bus_release_busn_res(pci_bus);
-	up_write(&pci_bus_sem);
-	if (pci_bus->is_added) {
+	switch (state) {
+	case PCI_BUS_STATE_STOPPED:
+	case PCI_BUS_STATE_REGISTERED:
 		pci_remove_legacy_files(pci_bus);
 		device_del(&pci_bus->dev);
+	case PCI_BUS_STATE_STOPPING:
+	case PCI_BUS_STATE_INITIALIZED:
+		pci_proc_detach_bus(pci_bus);
+		down_write(&pci_bus_sem);
+		list_del(&pci_bus->node);
+		pci_bus_release_busn_res(pci_bus);
+		up_write(&pci_bus_sem);
+		pci_bus_change_state(pci_bus, state,
+				     PCI_BUS_STATE_REMOVED, true);
+		pci_bus_put(pci_bus);
+		break;
+	case PCI_BUS_STATE_REMOVED:
+		pci_bus_unlock(pci_bus);
+		break;
+	default:
+		BUG_ON(state);
+		break;
 	}
-	put_device(&pci_bus->dev);
 }
 EXPORT_SYMBOL(pci_remove_bus);
 
-static void pci_remove_behind_bridge(struct pci_dev *dev);
-
 void __pci_remove_bus_device(struct pci_dev *dev)
 {
-	if (dev->subordinate) {
-		struct pci_bus *b = dev->subordinate;
+	struct list_head *l, *n;
+	struct pci_bus *bus;
 
-		pci_remove_behind_bridge(dev);
-		pci_remove_bus(b);
+	bus = pci_lock_subordinate(dev, PCI_BUS_STATE_DESTROYED - 1);
+	if (bus) {
+		list_for_each_safe(l, n, &bus->devices)
+			__pci_remove_bus_device(pci_dev_b(l));
+		pci_remove_bus(bus);
 		dev->subordinate = NULL;
 	}
 
@@ -111,24 +130,7 @@ void pci_stop_and_remove_bus_device(struct pci_dev *dev)
 	pci_stop_bus_device(dev);
 	__pci_remove_bus_device(dev);
 }
-
-static void pci_remove_behind_bridge(struct pci_dev *dev)
-{
-	struct list_head *l, *n;
-
-	if (dev->subordinate)
-		list_for_each_safe(l, n, &dev->subordinate->devices)
-			__pci_remove_bus_device(pci_dev_b(l));
-}
-
-static void pci_stop_behind_bridge(struct pci_dev *dev)
-{
-	struct list_head *l, *n;
-
-	if (dev->subordinate)
-		list_for_each_safe(l, n, &dev->subordinate->devices)
-			pci_stop_bus_device(pci_dev_b(l));
-}
+EXPORT_SYMBOL(pci_stop_and_remove_bus_device);
 
 /**
  * pci_stop_and_remove_behind_bridge - stop and remove all devices behind
@@ -141,27 +143,17 @@ static void pci_stop_behind_bridge(struct pci_dev *dev)
  */
 void pci_stop_and_remove_behind_bridge(struct pci_dev *dev)
 {
-	pci_stop_behind_bridge(dev);
-	pci_remove_behind_bridge(dev);
-}
-
-static void pci_stop_bus_devices(struct pci_bus *bus)
-{
 	struct list_head *l, *n;
+	struct pci_bus *bus;
 
-	/*
-	 * VFs could be removed by pci_stop_and_remove_bus_device() in the
-	 *  pci_stop_bus_devices() code path for PF.
-	 *  aka, bus->devices get updated in the process.
-	 * but VFs are inserted after PFs when SRIOV is enabled for PF,
-	 * We can iterate the list backwards to get prev valid PF instead
-	 *  of removed VF.
-	 */
-	list_for_each_prev_safe(l, n, &bus->devices) {
-		struct pci_dev *dev = pci_dev_b(l);
-		pci_stop_bus_device(dev);
+	bus = pci_lock_subordinate(dev, PCI_BUS_STATE_REMOVED - 1);
+	if (bus) {
+		list_for_each_safe(l, n, &bus->devices)
+			pci_stop_and_remove_bus_device(pci_dev_b(l));
+		pci_bus_unlock(bus);
 	}
 }
+EXPORT_SYMBOL(pci_stop_and_remove_behind_bridge);
 
 /**
  * pci_stop_bus_device - stop a PCI device and any children
@@ -173,12 +165,44 @@ static void pci_stop_bus_devices(struct pci_bus *bus)
  */
 void pci_stop_bus_device(struct pci_dev *dev)
 {
-	if (dev->subordinate)
-		pci_stop_bus_devices(dev->subordinate);
+	int state;
+	struct pci_bus *bus;
+	struct list_head *l, *n;
+
+	bus = pci_lock_subordinate(dev, PCI_BUS_STATE_REMOVED - 1);
+	if (!bus)
+		goto out;
+
+	state = pci_bus_get_state(bus);
+	switch (state) {
+	case PCI_BUS_STATE_INITIALIZED:
+		pci_bus_change_state(bus, state, PCI_BUS_STATE_STOPPING, true);
+		break;
+	case PCI_BUS_STATE_WORKING:
+	case PCI_BUS_STATE_REGISTERED:
+		pci_bus_change_state(bus, state, PCI_BUS_STATE_STOPPING, false);
+		/*
+		 * VFs could be removed by pci_stop_and_remove_bus_device()
+		 * in the pci_stop_bus_devices() code path for PF.
+		 * aka, bus->devices get updated in the process.
+		 * but VFs are inserted after PFs when SRIOV is enabled for PF,
+		 * We can iterate the list backwards to get prev valid PF
+		 * instead of removed VF.
+		 */
+		list_for_each_prev_safe(l, n, &bus->devices)
+			pci_stop_bus_device(pci_dev_b(l));
+		pci_bus_change_state(bus, PCI_BUS_STATE_STOPPING,
+				     PCI_BUS_STATE_STOPPED, true);
+		break;
+	case PCI_BUS_STATE_STOPPING:
+	case PCI_BUS_STATE_STOPPED:
+		pci_bus_unlock(bus);
+		break;
+	default:
+		BUG_ON(state);
+	}
 
+out:
 	pci_stop_dev(dev);
 }
-
-EXPORT_SYMBOL(pci_stop_and_remove_bus_device);
-EXPORT_SYMBOL(pci_stop_and_remove_behind_bridge);
 EXPORT_SYMBOL_GPL(pci_stop_bus_device);
-- 
1.7.9.5

