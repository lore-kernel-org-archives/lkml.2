Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933435Ab1KJAn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 19:43:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756904Ab1KJAnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 19:43:53 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 2/3] PCI: Maintain a list of FW-assigned BIOS BAR values
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, bhelgaas@google.com,
        linux-kernel@vger.kernel.org
Date: Wed, 09 Nov 2011 17:43:51 -0700
Message-ID: <20111110004351.5866.40960.stgit@amt.stowe>
In-Reply-To: <20111110004339.5866.28478.stgit@amt.stowe>
References: <20111110004339.5866.28478.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Myron Stowe <mstowe@redhat.com>

Commit 58c84eda075 introduced functionality to try and reinstate the
original BIOS BAR addresses of a PCI device when normal resource
assignment attempts fail.  To keep track of the BIOS BAR addresses,
struct pci_dev was augmented with an array to hold the BAR addresses
of the PCI device: 'resource_size_t fw_addr[DEVICE_COUNT_RESOURCE]'.

The reinstatement of BAR addresses is an uncommon event leaving the
'fw_addr' array unused normally.  As the use of struct pci_dev is so
prevalent, this seems wasteful.

This patch introduces a stand alone data structure and corresponding set
of interfacing routines for maintaining a list of FW-assigned BIOS BAR
value temporary entries.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/pci/setup-res.c |   73 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h     |    1 +
 2 files changed, 74 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index ad8c4ae..ab45c11 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -26,6 +26,79 @@
 #include "pci.h"
 
 
+/*
+ * This list of dynamic mappings is for temporarly maintaining
+ * original BIOS BAR addresses for possbile reinstatement.
+ */
+struct pci_fwaddrmap {
+	struct list_head list;
+	struct pci_dev *dev;
+	resource_size_t fw_addr[DEVICE_COUNT_RESOURCE];
+	unsigned long refcount;
+};
+
+static LIST_HEAD(pci_fwaddrmappings);
+static DEFINE_SPINLOCK(pci_fwaddrmap_lock);
+
+/* Must be called with 'pci_fwaddrmap_lock' lock held. */
+static struct pci_fwaddrmap *pci_fwaddrmap_lookup(struct pci_dev *dev)
+{
+	struct pci_fwaddrmap *map;
+
+	list_for_each_entry(map, &pci_fwaddrmappings, list)
+		if (map->dev == dev)
+			return map;
+
+	return NULL;
+}
+
+void pci_save_fw_addr(struct pci_dev *dev, int idx, resource_size_t fw_addr)
+{
+	unsigned long flags;
+	struct pci_fwaddrmap *map;
+
+	spin_lock_irqsave(&pci_fwaddrmap_lock, flags);
+	map = pci_fwaddrmap_lookup(dev);
+	if (!map) {
+		spin_unlock_irqrestore(&pci_fwaddrmap_lock, flags);
+		map = kzalloc(sizeof(*map), GFP_KERNEL);
+		if (!map)
+			return;
+
+		INIT_LIST_HEAD(&map->list);
+		map->dev = dev;
+		map->fw_addr[idx] = fw_addr;
+
+		spin_lock_irqsave(&pci_fwaddrmap_lock, flags);
+		list_add_tail(&map->list, &pci_fwaddrmappings);
+	} else {
+		map->fw_addr[idx] = fw_addr;
+	}
+	map->refcount++;
+	spin_unlock_irqrestore(&pci_fwaddrmap_lock, flags);
+}
+
+static resource_size_t pci_retrieve_fw_addr(struct pci_dev *dev, int idx)
+{
+	unsigned long flags;
+	resource_size_t fw_addr = 0;
+	struct pci_fwaddrmap *map;
+
+	spin_lock_irqsave(&pci_fwaddrmap_lock, flags);
+	map = pci_fwaddrmap_lookup(dev);
+	if (map) {
+		fw_addr = map->fw_addr[idx];
+
+		if (!--map->refcount) {
+			list_del(&map->list);
+			kfree(map);
+		}
+	}
+	spin_unlock_irqrestore(&pci_fwaddrmap_lock, flags);
+
+	return fw_addr;
+}
+
 void pci_update_resource(struct pci_dev *dev, int resno)
 {
 	struct pci_bus_region region;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 84225c7..14f2492 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -889,6 +889,7 @@ ssize_t pci_write_vpd(struct pci_dev *dev, loff_t pos, size_t count, const void
 int pci_vpd_truncate(struct pci_dev *dev, size_t size);
 
 /* Helper functions for low-level code (drivers/pci/setup-[bus,res].c) */
+void pci_save_fw_addr(struct pci_dev *dev, int idx, resource_size_t fw_addr);
 void pci_bus_assign_resources(const struct pci_bus *bus);
 void pci_bus_size_bridges(struct pci_bus *bus);
 int pci_claim_resource(struct pci_dev *, int);

