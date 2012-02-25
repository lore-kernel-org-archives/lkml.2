Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab2BYHcy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 02:32:54 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:30515 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab2BYHcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 02:32:53 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 1/2] PCI: Separate host_bridge code out from probe.c
Date: Fri, 24 Feb 2012 23:32:26 -0800
Message-Id: <1330155147-15118-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F488EA2.0031,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/Makefile      |    2 
 drivers/pci/host-bridge.c |   93 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.h         |    2 
 drivers/pci/probe.c       |   81 ----------------------------------------
 4 files changed, 97 insertions(+), 81 deletions(-)

Index: linux-2.6/drivers/pci/host-bridge.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/pci/host-bridge.c
@@ -0,0 +1,93 @@
+/*
+ * host_bridge.c - host bridge related code
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/module.h>
+
+#include "pci.h"
+
+static LIST_HEAD(pci_host_bridges);
+
+void add_to_pci_host_bridges(struct list_head *list)
+{
+	list_add_tail(list, &pci_host_bridges);
+}
+
+static struct pci_host_bridge *pci_host_bridge(struct pci_dev *dev)
+{
+	struct pci_bus *bus;
+	struct pci_host_bridge *bridge;
+
+	bus = dev->bus;
+	while (bus->parent)
+		bus = bus->parent;
+
+	list_for_each_entry(bridge, &pci_host_bridges, list) {
+		if (bridge->bus == bus)
+			return bridge;
+	}
+
+	return NULL;
+}
+
+static bool resource_contains(struct resource *res1, struct resource *res2)
+{
+	return res1->start <= res2->start && res1->end >= res2->end;
+}
+
+void pcibios_resource_to_bus(struct pci_dev *dev, struct pci_bus_region *region,
+			     struct resource *res)
+{
+	struct pci_host_bridge *bridge = pci_host_bridge(dev);
+	struct pci_host_bridge_window *window;
+	resource_size_t offset = 0;
+
+	list_for_each_entry(window, &bridge->windows, list) {
+		if (resource_type(res) != resource_type(window->res))
+			continue;
+
+		if (resource_contains(window->res, res)) {
+			offset = window->offset;
+			break;
+		}
+	}
+
+	region->start = res->start - offset;
+	region->end = res->end - offset;
+}
+EXPORT_SYMBOL(pcibios_resource_to_bus);
+
+static bool region_contains(struct pci_bus_region *region1,
+			    struct pci_bus_region *region2)
+{
+	return region1->start <= region2->start && region1->end >= region2->end;
+}
+
+void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
+			     struct pci_bus_region *region)
+{
+	struct pci_host_bridge *bridge = pci_host_bridge(dev);
+	struct pci_host_bridge_window *window;
+	struct pci_bus_region bus_region;
+	resource_size_t offset = 0;
+
+	list_for_each_entry(window, &bridge->windows, list) {
+		if (resource_type(res) != resource_type(window->res))
+			continue;
+
+		bus_region.start = window->res->start - window->offset;
+		bus_region.end = window->res->end - window->offset;
+
+		if (region_contains(&bus_region, region)) {
+			offset = window->offset;
+			break;
+		}
+	}
+
+	res->start = region->start + offset;
+	res->end = region->end + offset;
+}
+EXPORT_SYMBOL(pcibios_bus_to_resource);
Index: linux-2.6/drivers/pci/pci.h
===================================================================
--- linux-2.6.orig/drivers/pci/pci.h
+++ linux-2.6/drivers/pci/pci.h
@@ -231,6 +231,8 @@ static inline int pci_ari_enabled(struct
 void pci_reassigndev_resource_alignment(struct pci_dev *dev);
 extern void pci_disable_bridge_window(struct pci_dev *dev);
 
+void add_to_pci_host_bridges(struct list_head *list);
+
 /* Single Root I/O Virtualization */
 struct pci_sriov {
 	int pos;		/* capability position */
Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -15,13 +15,10 @@
 #define CARDBUS_LATENCY_TIMER	176	/* secondary latency timer */
 #define CARDBUS_RESERVE_BUSNR	3
 
-static LIST_HEAD(pci_host_bridges);
-
 /* Ugh.  Need to stop exporting this to modules. */
 LIST_HEAD(pci_root_buses);
 EXPORT_SYMBOL(pci_root_buses);
 
-
 static int find_anything(struct device *dev, void *data)
 {
 	return 1;
@@ -44,82 +41,6 @@ int no_pci_devices(void)
 }
 EXPORT_SYMBOL(no_pci_devices);
 
-static struct pci_host_bridge *pci_host_bridge(struct pci_dev *dev)
-{
-	struct pci_bus *bus;
-	struct pci_host_bridge *bridge;
-
-	bus = dev->bus;
-	while (bus->parent)
-		bus = bus->parent;
-
-	list_for_each_entry(bridge, &pci_host_bridges, list) {
-		if (bridge->bus == bus)
-			return bridge;
-	}
-
-	return NULL;
-}
-
-static bool resource_contains(struct resource *res1, struct resource *res2)
-{
-	return res1->start <= res2->start && res1->end >= res2->end;
-}
-
-void pcibios_resource_to_bus(struct pci_dev *dev, struct pci_bus_region *region,
-			     struct resource *res)
-{
-	struct pci_host_bridge *bridge = pci_host_bridge(dev);
-	struct pci_host_bridge_window *window;
-	resource_size_t offset = 0;
-
-	list_for_each_entry(window, &bridge->windows, list) {
-		if (resource_type(res) != resource_type(window->res))
-			continue;
-
-		if (resource_contains(window->res, res)) {
-			offset = window->offset;
-			break;
-		}
-	}
-
-	region->start = res->start - offset;
-	region->end = res->end - offset;
-}
-EXPORT_SYMBOL(pcibios_resource_to_bus);
-
-static bool region_contains(struct pci_bus_region *region1,
-			    struct pci_bus_region *region2)
-{
-	return region1->start <= region2->start && region1->end >= region2->end;
-}
-
-void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
-			     struct pci_bus_region *region)
-{
-	struct pci_host_bridge *bridge = pci_host_bridge(dev);
-	struct pci_host_bridge_window *window;
-	struct pci_bus_region bus_region;
-	resource_size_t offset = 0;
-
-	list_for_each_entry(window, &bridge->windows, list) {
-		if (resource_type(res) != resource_type(window->res))
-			continue;
-
-		bus_region.start = window->res->start - window->offset;
-		bus_region.end = window->res->end - window->offset;
-
-		if (region_contains(&bus_region, region)) {
-			offset = window->offset;
-			break;
-		}
-	}
-
-	res->start = region->start + offset;
-	res->end = region->end + offset;
-}
-EXPORT_SYMBOL(pcibios_bus_to_resource);
-
 /*
  * PCI Bus Class
  */
@@ -1731,7 +1652,7 @@ struct pci_bus *pci_create_root_bus(stru
 	}
 
 	down_write(&pci_bus_sem);
-	list_add_tail(&bridge->list, &pci_host_bridges);
+	add_to_pci_host_bridges(&bridge->list);
 	list_add_tail(&b->node, &pci_root_buses);
 	up_write(&pci_bus_sem);
 
Index: linux-2.6/drivers/pci/Makefile
===================================================================
--- linux-2.6.orig/drivers/pci/Makefile
+++ linux-2.6/drivers/pci/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the PCI bus specific drivers.
 #
 
-obj-y		+= access.o bus.o probe.o remove.o pci.o \
+obj-y		+= access.o bus.o probe.o host-bridge.o remove.o pci.o \
 			pci-driver.o search.o pci-sysfs.o rom.o setup-res.o \
 			irq.o vpd.o
 obj-$(CONFIG_PROC_FS) += proc.o
