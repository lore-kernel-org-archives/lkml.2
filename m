Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760419Ab2BKEHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 23:07:08 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:16410 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758649Ab2BKEG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 23:06:59 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 03/22] PCI: Add busn_res tracking in core
Date: Fri, 10 Feb 2012 20:06:06 -0800
Message-Id: <1328933185-15154-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1328933185-15154-1-git-send-email-yinghai@kernel.org>
References: <1328933185-15154-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4F35E95B.0075,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update pci_scan_root_bus, and pci_scan_bus to insert root bus busn into
iobusn_resource tree.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c  |   30 ++++++++++++++++++++++++++----
 drivers/pci/remove.c |    1 +
 include/linux/pci.h  |    4 ++++
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 480670f..33cc54e 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1669,8 +1669,9 @@ void pci_bus_release_busn_res(struct pci_bus *b)
 			res, ret ? "can not be" : "is");
 }
 
-struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
-		struct pci_ops *ops, void *sysdata, struct list_head *resources)
+struct pci_bus * __devinit pci_scan_root_bus_max(struct device *parent, int bus,
+		int bus_max, struct pci_ops *ops, void *sysdata,
+		struct list_head *resources)
 {
 	struct pci_bus *b;
 
@@ -1678,10 +1679,26 @@ struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
 	if (!b)
 		return NULL;
 
+	pci_bus_insert_busn_res(b, bus, bus_max);
 	b->subordinate = pci_scan_child_bus(b);
 	pci_bus_add_devices(b);
 	return b;
 }
+EXPORT_SYMBOL(pci_scan_root_bus_max);
+
+struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
+		struct pci_ops *ops, void *sysdata,
+		struct list_head *resources)
+{
+	struct pci_bus *b;
+
+	b = pci_scan_root_bus_max(parent, bus, 255, ops, sysdata, resources);
+
+	if (b)
+		pci_bus_update_busn_res_end(b, b->subordinate);
+
+	return b;
+}
 EXPORT_SYMBOL(pci_scan_root_bus);
 
 /* Deprecated; use pci_scan_root_bus() instead */
@@ -1694,9 +1711,11 @@ struct pci_bus * __devinit pci_scan_bus_parented(struct device *parent,
 	pci_add_resource(&resources, &ioport_resource);
 	pci_add_resource(&resources, &iomem_resource);
 	b = pci_create_root_bus(parent, bus, ops, sysdata, &resources);
-	if (b)
+	if (b) {
+		pci_bus_insert_busn_res(b, bus, 255);
 		b->subordinate = pci_scan_child_bus(b);
-	else
+		pci_bus_update_busn_res_end(b, b->subordinate);
+	} else
 		pci_free_resource_list(&resources);
 	return b;
 }
@@ -1712,7 +1731,10 @@ struct pci_bus * __devinit pci_scan_bus(int bus, struct pci_ops *ops,
 	pci_add_resource(&resources, &iomem_resource);
 	b = pci_create_root_bus(NULL, bus, ops, sysdata, &resources);
 	if (b) {
+		pci_bus_insert_busn_res(b, bus, 255);
 		b->subordinate = pci_scan_child_bus(b);
+		pci_bus_update_busn_res_end(b, b->subordinate);
+
 		pci_bus_add_devices(b);
 	} else {
 		pci_free_resource_list(&resources);
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index bd70f23..8056e6a 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -68,6 +68,7 @@ void pci_remove_bus(struct pci_bus *pci_bus)
 
 	down_write(&pci_bus_sem);
 	list_del(&pci_bus->node);
+	pci_bus_release_busn_res(pci_bus);
 	up_write(&pci_bus_sem);
 	if (!pci_bus->is_added)
 		return;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 3da935c..d5b6786 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -668,6 +668,10 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 void pci_bus_insert_busn_res(struct pci_bus *b, int bus, int busmax);
 void pci_bus_update_busn_res_end(struct pci_bus *b, int busmax);
 void pci_bus_release_busn_res(struct pci_bus *b);
+struct pci_bus * __devinit pci_scan_root_bus_max(struct device *parent, int bus,
+					     int busmax, struct pci_ops *ops,
+					     void *sysdata,
+					     struct list_head *resources);
 struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
 					     struct pci_ops *ops, void *sysdata,
 					     struct list_head *resources);
-- 
1.7.7

