Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab2HGQUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:20:20 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51881 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618Ab2HGQUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:20:16 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v1 11/22] PCI: enhance PCI resource assignment logic to support PCI bus lock mechanism
Date: Wed,  8 Aug 2012 00:10:51 +0800
Message-Id: <1344355862-2726-12-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
References: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enhances PCI resource assignemnt logic to support PCI bus lock
mechanism.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/setup-bus.c |   65 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 49 insertions(+), 16 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 192172c..08bac37 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -47,6 +47,7 @@ static void free_list(struct list_head *head)
 
 	list_for_each_entry_safe(dev_res, tmp, head, list) {
 		list_del(&dev_res->list);
+		pci_dev_put(dev_res->dev);
 		kfree(dev_res);
 	}
 }
@@ -73,7 +74,7 @@ static int add_to_list(struct list_head *head,
 	}
 
 	tmp->res = res;
-	tmp->dev = dev;
+	tmp->dev = pci_dev_get(dev);
 	tmp->start = res->start;
 	tmp->end = res->end;
 	tmp->flags = res->flags;
@@ -93,6 +94,7 @@ static void remove_from_list(struct list_head *head,
 	list_for_each_entry_safe(dev_res, tmp, head, list) {
 		if (dev_res->res == res) {
 			list_del(&dev_res->list);
+			pci_dev_put(dev_res->dev);
 			kfree(dev_res);
 			break;
 		}
@@ -151,7 +153,7 @@ static void pdev_sort_resources(struct pci_dev *dev, struct list_head *head)
 			panic("pdev_sort_resources(): "
 			      "kmalloc() failed!\n");
 		tmp->res = r;
-		tmp->dev = dev;
+		tmp->dev = pci_dev_get(dev);
 
 		/* fallback is smallest one or list is empty*/
 		n = head;
@@ -257,6 +259,7 @@ static void reassign_resources_sorted(struct list_head *realloc_head,
 		}
 out:
 		list_del(&add_res->list);
+		pci_dev_put(add_res->dev);
 		kfree(add_res);
 	}
 }
@@ -982,15 +985,16 @@ handle_done:
 	;
 }
 
-void __ref __pci_bus_size_bridges(struct pci_bus *bus,
+static void __ref __pci_bus_size_bridges(struct pci_bus *bus,
 			struct list_head *realloc_head)
 {
 	struct pci_dev *dev;
+	struct pci_bus *b;
 	unsigned long mask, prefmask;
 	resource_size_t additional_mem_size = 0, additional_io_size = 0;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
-		struct pci_bus *b = dev->subordinate;
+		b = pci_lock_subordinate(dev, PCI_BUS_STATE_STOPPING - 1);
 		if (!b)
 			continue;
 
@@ -1004,6 +1008,8 @@ void __ref __pci_bus_size_bridges(struct pci_bus *bus,
 			__pci_bus_size_bridges(b, realloc_head);
 			break;
 		}
+
+		pci_bus_unlock(b);
 	}
 
 	/* The root bus? */
@@ -1063,7 +1069,7 @@ static void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
 	pbus_assign_resources_sorted(bus, realloc_head, fail_head);
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
-		b = dev->subordinate;
+		b = pci_lock_subordinate(dev, PCI_BUS_STATE_STOPPING - 1);
 		if (!b)
 			continue;
 
@@ -1084,6 +1090,8 @@ static void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
 				 "%04x:%02x\n", pci_domain_nr(b), b->number);
 			break;
 		}
+
+		pci_bus_unlock(b);
 	}
 }
 
@@ -1098,11 +1106,11 @@ static void __ref __pci_bridge_assign_resources(const struct pci_dev *bridge,
 					 struct list_head *fail_head)
 {
 	struct pci_bus *b;
+	struct pci_dev *dev = (struct pci_dev *)bridge;
 
-	pdev_assign_resources_sorted((struct pci_dev *)bridge,
-					 add_head, fail_head);
+	pdev_assign_resources_sorted(dev, add_head, fail_head);
 
-	b = bridge->subordinate;
+	b = pci_lock_subordinate(dev, PCI_BUS_STATE_STOPPING - 1);
 	if (!b)
 		return;
 
@@ -1122,7 +1130,10 @@ static void __ref __pci_bridge_assign_resources(const struct pci_dev *bridge,
 			 "%04x:%02x\n", pci_domain_nr(b), b->number);
 		break;
 	}
+
+	pci_bus_unlock(b);
 }
+
 static void pci_bridge_release_resources(struct pci_bus *bus,
 					  unsigned long type)
 {
@@ -1169,6 +1180,7 @@ enum release_type {
 	leaf_only,
 	whole_subtree,
 };
+
 /*
  * try to release pci bridge resources that is from leaf bridge,
  * so we can allocate big new one later
@@ -1190,9 +1202,14 @@ static void __ref pci_bus_release_bridge_resources(struct pci_bus *bus,
 		if ((dev->class >> 8) != PCI_CLASS_BRIDGE_PCI)
 			continue;
 
-		if (rel_type == whole_subtree)
+		if (rel_type != whole_subtree)
+			continue;
+
+		if (pci_bus_lock_states(b, PCI_BUS_STATE_STOPPING - 1) > 0) {
 			pci_bus_release_bridge_resources(b, type,
 						 whole_subtree);
+			pci_bus_unlock(b);
+		}
 	}
 
 	if (pci_is_root_bus(bus))
@@ -1253,6 +1270,7 @@ static int __init pci_bus_get_depth(struct pci_bus *bus)
 
 	return depth;
 }
+
 static int __init pci_get_max_depth(void)
 {
 	int depth = 0;
@@ -1285,6 +1303,7 @@ enum enable_type {
 };
 
 static enum enable_type pci_realloc_enable __initdata = undefined;
+
 void __init pci_realloc_get_opt(char *str)
 {
 	if (!strncmp(str, "off", 3))
@@ -1292,6 +1311,7 @@ void __init pci_realloc_get_opt(char *str)
 	else if (!strncmp(str, "on", 2))
 		pci_realloc_enable = user_enabled;
 }
+
 static bool __init pci_realloc_enabled(void)
 {
 	return pci_realloc_enable >= user_enabled;
@@ -1428,7 +1448,7 @@ enable_and_dump:
 
 void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
 {
-	struct pci_bus *parent = bridge->subordinate;
+	struct pci_bus *parent;
 	LIST_HEAD(add_list); /* list of resources that
 					want additional resources */
 	int tried_times = 0;
@@ -1438,6 +1458,10 @@ void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
 				  IORESOURCE_PREFETCH;
 
+	parent = pci_lock_subordinate(bridge, PCI_BUS_STATE_STOPPING - 1);
+	if (!parent)
+		return;
+
 again:
 	__pci_bus_size_bridges(parent, &add_list);
 	__pci_bridge_assign_resources(bridge, &add_list, &fail_head);
@@ -1464,8 +1488,13 @@ again:
 		struct pci_bus *bus = fail_res->dev->bus;
 		unsigned long flags = fail_res->flags;
 
+		if (bus != parent && pci_bus_lock_states(bus,
+					PCI_BUS_STATE_STOPPING - 1) < 0)
+			continue;
 		pci_bus_release_bridge_resources(bus, flags & type_mask,
 						 whole_subtree);
+		if (bus != parent)
+			pci_bus_unlock(bus);
 	}
 	/* restore size and flags */
 	list_for_each_entry(fail_res, &fail_head, list) {
@@ -1485,6 +1514,7 @@ enable_all:
 	retval = pci_reenable_device(bridge);
 	pci_set_master(bridge);
 	pci_enable_bridges(parent);
+	pci_bus_unlock(parent);
 }
 EXPORT_SYMBOL_GPL(pci_assign_unassigned_bridge_resources);
 
@@ -1502,19 +1532,22 @@ unsigned int __ref pci_rescan_bus(struct pci_bus *bus)
 {
 	unsigned int max;
 	struct pci_dev *dev;
+	struct pci_bus *b;
 	LIST_HEAD(add_list); /* list of resources that
 					want additional resources */
 
 	max = pci_scan_child_bus(bus);
 
-	down_read(&pci_bus_sem);
 	list_for_each_entry(dev, &bus->devices, bus_list)
 		if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
-		    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)
-			if (dev->subordinate)
-				__pci_bus_size_bridges(dev->subordinate,
-							 &add_list);
-	up_read(&pci_bus_sem);
+		    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS) {
+			b = pci_lock_subordinate(dev,
+					PCI_BUS_STATE_STOPPING - 1);
+			if (b) {
+				__pci_bus_size_bridges(b, &add_list);
+				pci_bus_unlock(b);
+			}
+		}
 	__pci_bus_assign_resources(bus, &add_list, NULL);
 	BUG_ON(!list_empty(&add_list));
 
-- 
1.7.9.5

