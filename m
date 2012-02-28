Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab2B1CEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 21:04:53 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:20005 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab2B1CEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 21:04:50 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 05/11] PCI: add generic device into pci_host_bridge struct
Date: Mon, 27 Feb 2012 18:03:45 -0800
Message-Id: <1330394631-28978-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330394631-28978-1-git-send-email-yinghai@kernel.org>
References: <1330394631-28978-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090207.4F4C363F.00A9,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use that device for pci_root_bus bridge pointer.

With that make code more simple.

Also we can use pci_release_bus_bridge_dev() to release allocated
pci_host_bridge during removing path.

At last, we can use root bus bridge pointer to get host bridge pointer instead
of going over host bridge list, so could kill that host bridge list.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/host-bridge.c |   15 +---------
 drivers/pci/pci.h         |    2 -
 drivers/pci/probe.c       |   65 +++++++++++++++++++++++---------------------
 include/linux/pci.h       |    4 ++-
 4 files changed, 38 insertions(+), 48 deletions(-)

diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
index b3ddcc5..03d8db1 100644
--- a/drivers/pci/host-bridge.c
+++ b/drivers/pci/host-bridge.c
@@ -9,13 +9,6 @@
 
 #include "pci.h"
 
-static LIST_HEAD(pci_host_bridges);
-
-void add_to_pci_host_bridges(struct pci_host_bridge *bridge)
-{
-	list_add_tail(&bridge->list, &pci_host_bridges);
-}
-
 static struct pci_bus *find_pci_root_bus(struct pci_dev *dev)
 {
 	struct pci_bus *bus;
@@ -30,14 +23,8 @@ static struct pci_bus *find_pci_root_bus(struct pci_dev *dev)
 static struct pci_host_bridge *find_pci_host_bridge(struct pci_dev *dev)
 {
 	struct pci_bus *bus = find_pci_root_bus(dev);
-	struct pci_host_bridge *bridge;
-
-	list_for_each_entry(bridge, &pci_host_bridges, list) {
-		if (bridge->bus == bus)
-			return bridge;
-	}
 
-	return NULL;
+	return to_pci_host_bridge(bus->bridge);
 }
 
 static bool resource_contains(struct resource *res1, struct resource *res2)
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index c695a92..e494347 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -231,8 +231,6 @@ static inline int pci_ari_enabled(struct pci_bus *bus)
 void pci_reassigndev_resource_alignment(struct pci_dev *dev);
 extern void pci_disable_bridge_window(struct pci_dev *dev);
 
-void add_to_pci_host_bridges(struct pci_host_bridge *bridge);
-
 /* Single Root I/O Virtualization */
 struct pci_sriov {
 	int pos;		/* capability position */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 89a82a3..fb3dd4b 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -421,6 +421,19 @@ static struct pci_bus * pci_alloc_bus(void)
 	return b;
 }
 
+static struct pci_host_bridge *pci_alloc_host_bridge(struct pci_bus *b)
+{
+	struct pci_host_bridge *bridge;
+
+	bridge = kzalloc(sizeof(*bridge), GFP_KERNEL);
+	if (bridge) {
+		INIT_LIST_HEAD(&bridge->windows);
+		bridge->bus = b;
+	}
+
+	return bridge;
+}
+
 static unsigned char pcix_bus_speed[] = {
 	PCI_SPEED_UNKNOWN,		/* 0 */
 	PCI_SPEED_66MHz_PCIX,		/* 1 */
@@ -1121,7 +1134,13 @@ int pci_cfg_space_size(struct pci_dev *dev)
 
 static void pci_release_bus_bridge_dev(struct device *dev)
 {
-	kfree(dev);
+	struct pci_host_bridge *bridge = to_pci_host_bridge(dev);
+
+	/* TODO: need to free window->res */
+
+	pci_free_resource_list(&bridge->windows);
+
+	kfree(bridge);
 }
 
 struct pci_dev *alloc_pci_dev(void)
@@ -1570,28 +1589,19 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 	int error;
 	struct pci_host_bridge *bridge;
 	struct pci_bus *b, *b2;
-	struct device *dev;
 	struct pci_host_bridge_window *window, *n;
 	struct resource *res;
 	resource_size_t offset;
 	char bus_addr[64];
 	char *fmt;
 
-	bridge = kzalloc(sizeof(*bridge), GFP_KERNEL);
-	if (!bridge)
-		return NULL;
 
 	b = pci_alloc_bus();
 	if (!b)
-		goto err_bus;
-
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (!dev)
-		goto err_dev;
+		return NULL;
 
 	b->sysdata = sysdata;
 	b->ops = ops;
-
 	b2 = pci_find_bus(pci_domain_nr(b), bus);
 	if (b2) {
 		/* If we already got to this bus through a different bridge, ignore it */
@@ -1599,13 +1609,17 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 		goto err_out;
 	}
 
-	dev->parent = parent;
-	dev->release = pci_release_bus_bridge_dev;
-	dev_set_name(dev, "pci%04x:%02x", pci_domain_nr(b), bus);
-	error = device_register(dev);
+	bridge = pci_alloc_host_bridge(b);
+	if (!bridge)
+		goto err_out;
+
+	bridge->dev.parent = parent;
+	bridge->dev.release = pci_release_bus_bridge_dev;
+	dev_set_name(&bridge->dev, "pci%04x:%02x", pci_domain_nr(b), bus);
+	error = device_register(&bridge->dev);
 	if (error)
-		goto dev_reg_err;
-	b->bridge = get_device(dev);
+		goto bridge_dev_reg_err;
+	b->bridge = get_device(&bridge->dev);
 	device_enable_async_suspend(b->bridge);
 	pci_set_bus_of_node(b);
 
@@ -1624,9 +1638,6 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 
 	b->number = b->secondary = bus;
 
-	bridge->bus = b;
-	INIT_LIST_HEAD(&bridge->windows);
-
 	if (parent)
 		dev_info(parent, "PCI host bridge to bus %s\n", dev_name(&b->dev));
 	else
@@ -1652,25 +1663,17 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 	}
 
 	down_write(&pci_bus_sem);
-	add_to_pci_host_bridges(bridge);
 	list_add_tail(&b->node, &pci_root_buses);
 	up_write(&pci_bus_sem);
 
 	return b;
 
 class_dev_reg_err:
-	device_unregister(dev);
-dev_reg_err:
-	down_write(&pci_bus_sem);
-	list_del(&bridge->list);
-	list_del(&b->node);
-	up_write(&pci_bus_sem);
+	device_unregister(&bridge->dev);
+bridge_dev_reg_err:
+	kfree(bridge);
 err_out:
-	kfree(dev);
-err_dev:
 	kfree(b);
-err_bus:
-	kfree(bridge);
 	return NULL;
 }
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 5584aac..310610e 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -375,11 +375,13 @@ struct pci_host_bridge_window {
 };
 
 struct pci_host_bridge {
-	struct list_head list;
+	struct device dev;
 	struct pci_bus *bus;		/* root bus */
 	struct list_head windows;	/* pci_host_bridge_windows */
 };
 
+#define	to_pci_host_bridge(n) container_of(n, struct pci_host_bridge, dev)
+
 /*
  * The first PCI_BRIDGE_RESOURCE_NUM PCI bus resources (those that correspond
  * to P2P or CardBus bridge windows) go in a table.  Additional ones (for
-- 
1.7.7

