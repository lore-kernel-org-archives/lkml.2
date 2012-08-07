Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab2HGQTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:19:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51364 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab2HGQTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:19:49 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v1 08/22] PCI: introduce hotplug safe search interfaces for PCI bus/device
Date: Wed,  8 Aug 2012 00:10:48 +0800
Message-Id: <1344355862-2726-9-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
References: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function pci_find_bus() is not hotplug safe because it doesn't hold any
reference on the returned bus, so the bus may be destroyed by hotplug
operations just after returning from pci_find_bus.

This patch introduces a hotplug safe interface to get and lock a specific
PCI bus. It also provides several help interfaces to reduce code complexity.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/bus.c    |   34 ++++++++++++++++++++++++++++++++++
 drivers/pci/search.c |   44 ++++++++++++++++++++++++++++++++++----------
 include/linux/pci.h  |   10 ++++++++++
 3 files changed, 78 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index aa25fcf..b6aacaa 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -426,6 +426,40 @@ void pci_bus_change_state(struct pci_bus *bus, int old, int new, bool unlock)
 }
 EXPORT_SYMBOL(pci_bus_change_state);
 
+struct pci_bus *__pci_get_and_lock_bus(int domain, int busnr, int states)
+{
+	struct pci_bus *bus;
+
+	bus = pci_get_bus(domain, busnr);
+	if (bus && pci_bus_lock_states(bus, states) < 0) {
+		pci_bus_put(bus);
+		bus = NULL;
+	}
+
+	return bus;
+}
+EXPORT_SYMBOL(__pci_get_and_lock_bus);
+
+struct pci_bus *pci_lock_subordinate(struct pci_dev *dev, int states)
+{
+	struct pci_bus *bus = dev->subordinate;
+
+	if (bus && pci_bus_lock_states(bus, states) > 0)
+		return bus;
+
+	return NULL;
+}
+EXPORT_SYMBOL(pci_lock_subordinate);
+
+void pci_unlock_and_put_bus(struct pci_bus *bus)
+{
+	if (bus) {
+		pci_bus_unlock(bus);
+		pci_bus_put(bus);
+	}
+}
+EXPORT_SYMBOL(pci_unlock_and_put_bus);
+
 EXPORT_SYMBOL(pci_bus_alloc_resource);
 EXPORT_SYMBOL_GPL(pci_bus_add_device);
 EXPORT_SYMBOL(pci_bus_add_devices);
diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index f1147a7..c0a8a2b 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -69,6 +69,35 @@ static struct pci_bus *pci_do_find_bus(struct pci_bus *bus, unsigned char busnr)
 }
 
 /**
+ * pci_get_bus - get PCI bus from a given domain and bus number
+ * @domain: number of PCI domain to search
+ * @busnr: number of desired PCI bus
+ *
+ * Given a PCI bus number and domain number, the desired PCI bus is located
+ * in the global list of PCI buses. If the bus is found, a reference count
+ * is held on the returned PCI bus. If no bus is found, %NULL is returned.
+ */
+struct pci_bus *pci_get_bus(int domain, int busnr)
+{
+	struct pci_bus *bus;
+	struct pci_bus *tmp_bus = NULL;
+
+	down_read(&pci_bus_sem);
+	list_for_each_entry(bus, &pci_root_buses, node)
+		if (pci_domain_nr(bus) == domain) {
+			tmp_bus = pci_do_find_bus(bus, busnr);
+			if (tmp_bus) {
+				pci_bus_get(tmp_bus);
+				break;
+			}
+		}
+	up_read(&pci_bus_sem);
+
+	return tmp_bus;
+}
+EXPORT_SYMBOL(pci_get_bus);
+
+/**
  * pci_find_bus - locate PCI bus from a given domain and bus number
  * @domain: number of PCI domain to search
  * @busnr: number of desired PCI bus
@@ -79,17 +108,12 @@ static struct pci_bus *pci_do_find_bus(struct pci_bus *bus, unsigned char busnr)
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
+	bus = pci_get_bus(domain, busnr);
+	pci_bus_put(bus);
+
+	return bus;
 }
 
 /**
diff --git a/include/linux/pci.h b/include/linux/pci.h
index e2ef517..9e52e88 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -488,6 +488,15 @@ extern int pci_bus_lock_states(struct pci_bus *bus, int states);
 extern void pci_bus_unlock(struct pci_bus *bus);
 extern void pci_bus_change_state(struct pci_bus *bus, int new, int old,
 				 bool unlock);
+extern struct pci_bus *pci_lock_subordinate(struct pci_dev *dev, int states);
+extern struct pci_bus *__pci_get_and_lock_bus(int domain, int busnr,
+					      int states);
+extern void pci_unlock_and_put_bus(struct pci_bus *bus);
+
+static inline struct pci_bus *pci_get_and_lock_bus(int domain, int busnr)
+{
+	return __pci_get_and_lock_bus(domain, busnr, PCI_BUS_STATE_WORKING);
+}
 
 #define pci_bus_b(n)	list_entry(n, struct pci_bus, node)
 #define to_pci_bus(n)	container_of(n, struct pci_bus, dev)
@@ -734,6 +743,7 @@ void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
 			     struct pci_bus_region *region);
 void pcibios_scan_specific_bus(int busn);
 extern struct pci_bus *pci_find_bus(int domain, int busnr);
+struct pci_bus *pci_get_bus(int domain, int busnr);
 void pci_bus_add_devices(const struct pci_bus *bus);
 struct pci_bus *pci_scan_bus_parented(struct device *parent, int bus,
 				      struct pci_ops *ops, void *sysdata);
-- 
1.7.9.5

