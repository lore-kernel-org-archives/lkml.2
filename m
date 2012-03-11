Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab2CKRx6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 13:53:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55385 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab2CKRxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 13:53:31 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Ashok Raj <ashok.raj@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Youquan Song <youquan.song@intel.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, chenkeping@huawei.com
Subject: [RFC PATCH 4/5] PCI: Introduce hotplug-safe pci bus searching interfaces
Date: Mon, 12 Mar 2012 01:48:28 +0800
Message-Id: <1331488109-13466-5-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1331488109-13466-1-git-send-email-jiang.liu@huawei.com>
References: <1331488109-13466-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By design, pci_find_bus() and pci_find_next_bus() should be used at boot
time only. But currently these two interfaces have been used at runtime
by other components. With the introduction of pci root bus hotplug,
the situation becomes more serious. So introduce several hotplug-safe pci
bus searching interfaces to be used at runtime.  The new interfaces use
rculist instead of the pci_bus_sem to protect themselves from dynamic changes.
The proposed interfaces are straight-forward replacement of the old ones:
pci_bus_get()/put(), pci_get_bus(), pci_get_next_bus() and pci_bus_present().
And the old interface may be deprecated or marked as __init in future.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/pci/bus.c    |   20 ++++++-
 drivers/pci/probe.c  |    5 +-
 drivers/pci/remove.c |    5 +-
 drivers/pci/search.c |  165 ++++++++++++++++++++++++++++++++++++++++++--------
 include/linux/pci.h  |    8 +++
 5 files changed, 173 insertions(+), 30 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 1eb7944..0543d47 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -15,6 +15,7 @@
 #include <linux/proc_fs.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/rculist.h>
 
 #include "pci.h"
 
@@ -238,7 +239,7 @@ void pci_bus_add_devices(const struct pci_bus *bus)
 			continue;
 		if (list_empty(&child->node)) {
 			down_write(&pci_bus_sem);
-			list_add_tail(&child->node, &dev->bus->children);
+			list_add_tail_rcu(&child->node, &dev->bus->children);
 			up_write(&pci_bus_sem);
 		}
 		pci_bus_add_devices(child);
@@ -277,7 +278,7 @@ void pci_bus_add_single_device(struct pci_dev *dev)
 	if (child) {
 		if (list_empty(&child->node)) {
 			down_write(&pci_bus_sem);
-			list_add_tail(&child->node, &dev->bus->children);
+			list_add_tail_rcu(&child->node, &dev->bus->children);
 			up_write(&pci_bus_sem);
 		}
 		pci_bus_add_devices(child);
@@ -364,6 +365,21 @@ void pci_walk_bus(struct pci_bus *top, int (*cb)(struct pci_dev *, void *),
 }
 EXPORT_SYMBOL_GPL(pci_walk_bus);
 
+struct pci_bus *pci_bus_get(struct pci_bus *bus)
+{
+	if (bus)
+		get_device(&bus->dev);
+	return bus;
+}
+EXPORT_SYMBOL(pci_bus_get);
+
+void pci_bus_put(struct pci_bus *bus)
+{
+	if (bus)
+		put_device(&bus->dev);
+}
+EXPORT_SYMBOL(pci_bus_put);
+
 EXPORT_SYMBOL(pci_bus_alloc_resource);
 EXPORT_SYMBOL_GPL(pci_bus_add_device);
 EXPORT_SYMBOL(pci_bus_add_devices);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 0ca213c..273c387 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/cpumask.h>
 #include <linux/pci-aspm.h>
+#include <linux/rculist.h>
 #include "pci.h"
 
 #define CARDBUS_LATENCY_TIMER	176	/* secondary latency timer */
@@ -633,7 +634,7 @@ struct pci_bus *__ref pci_add_new_bus(struct pci_bus *parent, struct pci_dev *de
 	child = pci_alloc_child_bus(parent, dev, busnr);
 	if (child) {
 		down_write(&pci_bus_sem);
-		list_add_tail(&child->node, &parent->children);
+		list_add_tail_rcu(&child->node, &parent->children);
 		up_write(&pci_bus_sem);
 	}
 	return child;
@@ -1889,7 +1890,7 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 	}
 
 	down_write(&pci_bus_sem);
-	list_add_tail(&b->node, &pci_root_buses);
+	list_add_tail_rcu(&b->node, &pci_root_buses);
 	up_write(&pci_bus_sem);
 
 	return b;
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 25f368e..120bee9 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -1,6 +1,7 @@
 #include <linux/pci.h>
 #include <linux/module.h>
 #include <linux/pci-aspm.h>
+#include <linux/rculist.h>
 #include "pci.h"
 
 static void pci_free_resources(struct pci_dev *dev)
@@ -67,9 +68,11 @@ void pci_remove_bus(struct pci_bus *pci_bus)
 	pci_proc_detach_bus(pci_bus);
 
 	down_write(&pci_bus_sem);
-	list_del(&pci_bus->node);
+	list_del_rcu(&pci_bus->node);
 	pci_bus_release_busn_res(pci_bus);
 	up_write(&pci_bus_sem);
+	synchronize_rcu();
+
 	if (pci_bus->is_added || pci_is_root_bus(pci_bus)) {
 		pci_remove_legacy_files(pci_bus);
 		device_unregister(&pci_bus->dev);
diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index b572730..de31957 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
+#include <linux/rculist.h>
 #include "pci.h"
 
 DECLARE_RWSEM(pci_bus_sem);
@@ -52,20 +53,63 @@ pci_find_upstream_pcie_bridge(struct pci_dev *pdev)
 
 static struct pci_bus *pci_do_find_bus(struct pci_bus *bus, unsigned char busnr)
 {
-	struct pci_bus* child;
-	struct list_head *tmp;
+	struct pci_bus *child;
+	struct pci_bus *tmp_bus;
 
 	if(bus->number == busnr)
 		return bus;
 
-	list_for_each(tmp, &bus->children) {
-		child = pci_do_find_bus(pci_bus_b(tmp), busnr);
-		if(child)
-			return child;
+	list_for_each_entry_rcu(child, &bus->children, node) {
+		tmp_bus = pci_do_find_bus(child, busnr);
+		if(tmp_bus)
+			return tmp_bus;
 	}
 	return NULL;
 }
 
+static struct pci_bus *__pci_find_bus(int domain, int busnr)
+{
+	struct pci_bus *bus;
+	struct pci_bus *tmp_bus;
+
+	list_for_each_entry_rcu(bus, &pci_root_buses, node) {
+		if (pci_domain_nr(bus) != domain)
+			continue;
+		tmp_bus = pci_do_find_bus(bus, busnr);
+		if (tmp_bus)
+			return tmp_bus;
+	}
+
+	return NULL;
+}
+
+static struct pci_bus *__pci_find_next_bus(const struct pci_bus *from)
+{
+	struct list_head *n;
+	struct pci_bus *b = NULL;
+
+	/* First search, start from the pci root bus list */
+	if (from == NULL) {
+		n = rcu_dereference(list_next_rcu(&pci_root_buses));
+		if (n != &pci_root_buses)
+			b = pci_bus_b(n);
+	/* Continue on the pci root bus list */
+	} else if (pci_is_root_bus((struct pci_bus *)from)) {
+		n = rcu_dereference(list_next_rcu(&from->node));
+		if (n != &pci_root_buses)
+			b = pci_bus_b(n);
+	/* Continue on other non pci root bus list */
+	} else {
+		struct pci_bus *parent = from->self->bus;
+
+		n = rcu_dereference(list_next_rcu(&from->node));
+		if (n != &parent->children)
+			b = pci_bus_b(n);
+	}
+
+	return b;
+}
+
 /**
  * pci_find_bus - locate PCI bus from a given domain and bus number
  * @domain: number of PCI domain to search
@@ -74,20 +118,19 @@ static struct pci_bus *pci_do_find_bus(struct pci_bus *bus, unsigned char busnr)
  * Given a PCI bus number and domain number, the desired PCI bus is located
  * in the global list of PCI buses.  If the bus is found, a pointer to its
  * data structure is returned.  If no bus is found, %NULL is returned.
+ *
+ * TODO: By design, this function should only be called at boot time.
+ * So either mark it as __init or deprecate it.
  */
 struct pci_bus * pci_find_bus(int domain, int busnr)
 {
-	struct pci_bus *bus = NULL;
-	struct pci_bus *tmp_bus;
+	struct pci_bus *bus;
 
-	while ((bus = pci_find_next_bus(bus)) != NULL)  {
-		if (pci_domain_nr(bus) != domain)
-			continue;
-		tmp_bus = pci_do_find_bus(bus, busnr);
-		if (tmp_bus)
-			return tmp_bus;
-	}
-	return NULL;
+	rcu_read_lock();
+	bus = __pci_find_bus(domain, busnr);
+	rcu_read_unlock();
+
+	return bus;
 }
 
 /**
@@ -98,21 +141,93 @@ struct pci_bus * pci_find_bus(int domain, int busnr)
  * initiated by passing %NULL as the @from argument.  Otherwise if
  * @from is not %NULL, searches continue from next device on the
  * global list.
+ *
+ * TODO: By design, this function should only be called at boot time.
+ * So either mark it as __init or deprecate it.
  */
 struct pci_bus * 
 pci_find_next_bus(const struct pci_bus *from)
 {
-	struct list_head *n;
-	struct pci_bus *b = NULL;
+	struct pci_bus *bus;
 
-	WARN_ON(in_interrupt());
-	down_read(&pci_bus_sem);
-	n = from ? from->node.next : pci_root_buses.next;
-	if (n != &pci_root_buses)
-		b = pci_bus_b(n);
-	up_read(&pci_bus_sem);
-	return b;
+	rcu_read_lock();
+	bus = __pci_find_next_bus(from);
+	rcu_read_unlock();
+
+	return bus;
+}
+
+/**
+ * pci_get_bus - locate PCI bus from a given domain and bus number
+ * @domain: number of PCI domain to search
+ * @busnr: number of desired PCI bus
+ *
+ * Given a PCI bus number and domain number, the desired PCI bus is located
+ * in the global list of PCI buses. If the bus is found, a pointer to its
+ * data structure is returned, and the reference count to the bus is increased.
+ * Otherwise, %NULL is returned.
+ */
+struct pci_bus *
+pci_get_bus(int domain, int busnr)
+{
+	struct pci_bus *bus;
+
+	rcu_read_lock();
+	bus = pci_bus_get(__pci_find_bus(domain, busnr));
+	rcu_read_unlock();
+
+	return bus;
+}
+EXPORT_SYMBOL(pci_get_bus);
+
+/**
+ * pci_get_next_bus - begin or continue searching for a PCI bus
+ * @from: Previous PCI bus found, or %NULL for new search.
+ *
+ * Iterates through the list of known PCI busses.  A new search is
+ * initiated by passing %NULL as the @from argument.  Otherwise if
+ * @from is not %NULL, searches continue from next device on the
+ * global list. If a bus is found, a pointer to its data structure
+ * is returned, and the reference count to the bus is increased.
+ * Otherwise, %NULL is returned.
+ * The reference count for @from is always decremented if it is not %NULL.
+ */
+struct pci_bus *
+pci_get_next_bus(struct pci_bus *from)
+{
+	struct pci_bus *bus;
+
+	rcu_read_lock();
+	bus = pci_bus_get(__pci_find_next_bus(from));
+	rcu_read_unlock();
+
+	return bus;
+}
+EXPORT_SYMBOL(pci_get_next_bus);
+
+/**
+ * pci_bus_present - Returns true if a bus with the (@domain, @busnr)
+ * is present, false if not.
+ * @domain: number of PCI domain to search
+ * @busnr: number of desired PCI bus
+ *
+ * Obvious fact: You do not have a reference to any bus that might be found
+ * by this function, so if that bus is removed from the system right after
+ * this function is finished, the value will be stale.  Use this function to
+ * find buses that are usually built into a system, or for a general hint as
+ * to if another device happens to be present at this specific moment in time.
+ */
+bool pci_bus_present(int domain, int busnr)
+{
+	struct pci_bus *bus;
+
+	rcu_read_lock();
+	bus = __pci_find_bus(domain, busnr);
+	rcu_read_unlock();
+
+	return !!bus;
 }
+EXPORT_SYMBOL(pci_bus_present);
 
 /**
  * pci_get_slot - locate PCI device for a given PCI slot
diff --git a/include/linux/pci.h b/include/linux/pci.h
index ec8c4cf..222bc88 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -731,6 +731,11 @@ int pci_find_ht_capability(struct pci_dev *dev, int ht_cap);
 int pci_find_next_ht_capability(struct pci_dev *dev, int pos, int ht_cap);
 struct pci_bus *pci_find_next_bus(const struct pci_bus *from);
 
+struct pci_bus *pci_bus_get(struct pci_bus *bus);
+void pci_bus_put(struct pci_bus *bus);
+struct pci_bus *pci_get_bus(int domain, int busnr);
+struct pci_bus *pci_get_next_bus(struct pci_bus *from);
+bool pci_bus_present(int domain, int busnr);
 struct pci_dev *pci_get_device(unsigned int vendor, unsigned int device,
 				struct pci_dev *from);
 struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
@@ -1321,6 +1326,9 @@ static inline void pci_unblock_cfg_access(struct pci_dev *dev)
 static inline struct pci_bus *pci_find_next_bus(const struct pci_bus *from)
 { return NULL; }
 
+static inline struct pci_bus *pci_get_next_bus(const struct pci_bus *from)
+{ return NULL; }
+
 static inline struct pci_dev *pci_get_slot(struct pci_bus *bus,
 						unsigned int devfn)
 { return NULL; }
-- 
1.7.5.4

