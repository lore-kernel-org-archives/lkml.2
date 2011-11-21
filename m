Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab1KUSyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 13:54:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab1KUSyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 13:54:16 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH -v2 2/3] x86/PCI: Infrastructure to maintain a list of
	FW-assigned BIOS BAR values
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, bhelgaas@google.com,
        linux-kernel@vger.kernel.org
Date: Mon, 21 Nov 2011 11:54:13 -0700
Message-ID: <20111121185413.9603.12314.stgit@amt.stowe>
In-Reply-To: <20111121185401.9603.34587.stgit@amt.stowe>
References: <20111121185401.9603.34587.stgit@amt.stowe>
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
'fw_addr' array unused under normal circumstances.  This functionality
is also currently architecture specific with an implementation limited
to x86.  As the use of struct pci_dev is so prevalent, having the
'fw_addr' array residing within such seems somewhat wasteful.

This patch introduces a stand alone data structure and interfacing
routines for maintaining a list of FW-assigned BIOS BAR value entries.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/x86/pci/i386.c |   79 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h |    1 +
 2 files changed, 80 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 494f2e7..bfb9d6a 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -38,6 +38,85 @@
 #include <asm/io_apic.h>
 
 
+/*
+ * This list of dynamic mappings is for temporarily maintaining
+ * original BIOS BAR addresses for possible reinstatement.
+ */
+struct pcibios_fwaddrmap {
+	struct list_head list;
+	struct pci_dev *dev;
+	resource_size_t fw_addr[DEVICE_COUNT_RESOURCE];
+};
+
+static LIST_HEAD(pcibios_fwaddrmappings);
+static DEFINE_SPINLOCK(pcibios_fwaddrmap_lock);
+
+/* Must be called with 'pcibios_fwaddrmap_lock' lock held. */
+static struct pcibios_fwaddrmap *pcibios_fwaddrmap_lookup(struct pci_dev *dev)
+{
+	struct pcibios_fwaddrmap *map;
+
+	list_for_each_entry(map, &pcibios_fwaddrmappings, list)
+		if (map->dev == dev)
+			return map;
+
+	return NULL;
+}
+
+static void
+pcibios_save_fw_addr(struct pci_dev *dev, int idx, resource_size_t fw_addr)
+{
+	unsigned long flags;
+	struct pcibios_fwaddrmap *map;
+
+	spin_lock_irqsave(&pcibios_fwaddrmap_lock, flags);
+	map = pcibios_fwaddrmap_lookup(dev);
+	if (!map) {
+		spin_unlock_irqrestore(&pcibios_fwaddrmap_lock, flags);
+		map = kzalloc(sizeof(*map), GFP_KERNEL);
+		if (!map)
+			return;
+
+		map->dev = pci_dev_get(dev);
+		map->fw_addr[idx] = fw_addr;
+		INIT_LIST_HEAD(&map->list);
+
+		spin_lock_irqsave(&pcibios_fwaddrmap_lock, flags);
+		list_add_tail(&map->list, &pcibios_fwaddrmappings);
+	} else
+		map->fw_addr[idx] = fw_addr;
+	spin_unlock_irqrestore(&pcibios_fwaddrmap_lock, flags);
+}
+
+resource_size_t pcibios_retrieve_fw_addr(struct pci_dev *dev, int idx)
+{
+	unsigned long flags;
+	struct pcibios_fwaddrmap *map;
+	resource_size_t fw_addr = 0;
+
+	spin_lock_irqsave(&pcibios_fwaddrmap_lock, flags);
+	map = pcibios_fwaddrmap_lookup(dev);
+	if (map)
+		fw_addr = map->fw_addr[idx];
+	spin_unlock_irqrestore(&pcibios_fwaddrmap_lock, flags);
+
+	return fw_addr;
+}
+
+static void pcibios_fw_addr_list_del(void)
+{
+	unsigned long flags;
+	struct pcibios_fwaddrmap *entry, *next;
+
+	spin_lock_irqsave(&pcibios_fwaddrmap_lock, flags);
+	list_for_each_entry_safe(entry, next, &pcibios_fwaddrmappings, list) {
+		list_del(&entry->list);
+		pci_dev_put(entry->dev);
+		kfree(entry);
+	}
+	spin_unlock_irqrestore(&pcibios_fwaddrmap_lock, flags);
+}
+
 static int
 skip_isa_ioresource_align(struct pci_dev *dev) {
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 84225c7..4545d23 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -889,6 +889,7 @@ ssize_t pci_write_vpd(struct pci_dev *dev, loff_t pos, size_t count, const void
 int pci_vpd_truncate(struct pci_dev *dev, size_t size);
 
 /* Helper functions for low-level code (drivers/pci/setup-[bus,res].c) */
+resource_size_t pcibios_retrieve_fw_addr(struct pci_dev *dev, int idx);
 void pci_bus_assign_resources(const struct pci_bus *bus);
 void pci_bus_size_bridges(struct pci_bus *bus);
 int pci_claim_resource(struct pci_dev *, int);

