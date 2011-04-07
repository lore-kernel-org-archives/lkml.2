Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab1DGD13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 23:27:29 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:59539 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab1DGD0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 23:26:53 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-pci@vger.kernel.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, bheglaas@google.com, monstr@monstr.eu,
        tglx@linuxtronix.de, bigeasy@linuxtronix.de,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3/5] microblaze/pci: Move the remains of pci_32.c to pci-common.c
Date: Thu,  7 Apr 2011 13:26:34 +1000
Message-Id: <1302146796-26825-4-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302146796-26825-1-git-send-email-benh@kernel.crashing.org>
References: <1302146796-26825-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no point in keeping this separate. Even if microblaze grows
a 64-bit variant, it will probably be able to re-use that code as-is

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/microblaze/pci/Makefile     |    2 +-
 arch/microblaze/pci/pci-common.c |  113 +++++++++++++++++++++++++++++++
 arch/microblaze/pci/pci_32.c     |  138 --------------------------------------
 3 files changed, 114 insertions(+), 139 deletions(-)
 delete mode 100644 arch/microblaze/pci/pci_32.c

diff --git a/arch/microblaze/pci/Makefile b/arch/microblaze/pci/Makefile
index 9889cc2..d1114fb 100644
--- a/arch/microblaze/pci/Makefile
+++ b/arch/microblaze/pci/Makefile
@@ -2,5 +2,5 @@
 # Makefile
 #
 
-obj-$(CONFIG_PCI)		+= pci_32.o pci-common.o indirect_pci.o iomap.o
+obj-$(CONFIG_PCI)		+= pci-common.o indirect_pci.o iomap.o
 obj-$(CONFIG_PCI_XILINX)	+= xilinx_pci.o
diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index 5359906..b908378 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -50,6 +50,11 @@ unsigned int pci_flags;
 
 static struct dma_map_ops *pci_dma_ops = &dma_direct_ops;
 
+unsigned long isa_io_base;
+unsigned long pci_dram_offset;
+static int pci_bus_count;
+
+
 void set_pci_dma_ops(struct dma_map_ops *dma_ops)
 {
 	pci_dma_ops = dma_ops;
@@ -1558,6 +1563,113 @@ void __devinit pcibios_setup_phb_resources(struct pci_controller *hose)
 		 (unsigned long)hose->io_base_virt - _IO_BASE);
 }
 
+struct device_node * pcibios_get_phb_of_node(struct pci_bus *bus)
+{
+	struct pci_controller *hose = bus->sysdata;
+
+	return of_node_get(hose->dn);
+}
+
+static void __devinit pcibios_scan_phb(struct pci_controller *hose)
+{
+	struct pci_bus *bus;
+	struct device_node *node = hose->dn;
+	unsigned long io_offset;
+	struct resource *res = &hose->io_resource;
+
+	pr_debug("PCI: Scanning PHB %s\n",
+		 node ? node->full_name : "<NO NAME>");
+
+	/* Create an empty bus for the toplevel */
+	bus = pci_create_bus(hose->parent, hose->first_busno, hose->ops, hose);
+	if (bus == NULL) {
+		printk(KERN_ERR "Failed to create bus for PCI domain %04x\n",
+		       hose->global_number);
+		return;
+	}
+	bus->secondary = hose->first_busno;
+	hose->bus = bus;
+
+	/* Fixup IO space offset */
+	io_offset = (unsigned long)hose->io_base_virt - isa_io_base;
+	res->start = (res->start + io_offset) & 0xffffffffu;
+	res->end = (res->end + io_offset) & 0xffffffffu;
+
+	/* Wire up PHB bus resources */
+	pcibios_setup_phb_resources(hose);
+
+	/* Scan children */
+	hose->last_busno = bus->subordinate = pci_scan_child_bus(bus);
+}
+
+static int __init pcibios_init(void)
+{
+	struct pci_controller *hose, *tmp;
+	int next_busno = 0;
+
+	printk(KERN_INFO "PCI: Probing PCI hardware\n");
+
+	/* Scan all of the recorded PCI controllers.  */
+	list_for_each_entry_safe(hose, tmp, &hose_list, list_node) {
+		hose->last_busno = 0xff;
+		pcibios_scan_phb(hose);
+		printk(KERN_INFO "calling pci_bus_add_devices()\n");
+		pci_bus_add_devices(hose->bus);
+		if (next_busno <= hose->last_busno)
+			next_busno = hose->last_busno + 1;
+	}
+	pci_bus_count = next_busno;
+
+	/* Call common code to handle resource allocation */
+	pcibios_resource_survey();
+
+	return 0;
+}
+
+subsys_initcall(pcibios_init);
+
+static struct pci_controller*
+pci_bus_to_hose(int bus)
+{
+	struct pci_controller *hose, *tmp;
+
+	list_for_each_entry_safe(hose, tmp, &hose_list, list_node)
+		if (bus >= hose->first_busno && bus <= hose->last_busno)
+			return hose;
+	return NULL;
+}
+
+/* Provide information on locations of various I/O regions in physical
+ * memory.  Do this on a per-card basis so that we choose the right
+ * root bridge.
+ * Note that the returned IO or memory base is a physical address
+ */
+
+long sys_pciconfig_iobase(long which, unsigned long bus, unsigned long devfn)
+{
+	struct pci_controller *hose;
+	long result = -EOPNOTSUPP;
+
+	hose = pci_bus_to_hose(bus);
+	if (!hose)
+		return -ENODEV;
+
+	switch (which) {
+	case IOBASE_BRIDGE_NUMBER:
+		return (long)hose->first_busno;
+	case IOBASE_MEMORY:
+		return (long)hose->pci_mem_offset;
+	case IOBASE_IO:
+		return (long)hose->io_base_phys;
+	case IOBASE_ISA_IO:
+		return (long)isa_io_base;
+	case IOBASE_ISA_MEM:
+		return (long)isa_mem_base;
+	}
+
+	return result;
+}
+
 /*
  * Null PCI config access functions, for the case when we can't
  * find a hose.
@@ -1626,3 +1738,4 @@ int early_find_capability(struct pci_controller *hose, int bus, int devfn,
 {
 	return pci_bus_find_capability(fake_pci_bus(hose, bus), devfn, cap);
 }
+
diff --git a/arch/microblaze/pci/pci_32.c b/arch/microblaze/pci/pci_32.c
deleted file mode 100644
index 9128f15..0000000
--- a/arch/microblaze/pci/pci_32.c
+++ /dev/null
@@ -1,138 +0,0 @@
-/*
- * Common pmac/prep/chrp pci routines. -- Cort
- */
-
-#include <linux/kernel.h>
-#include <linux/pci.h>
-#include <linux/delay.h>
-#include <linux/string.h>
-#include <linux/init.h>
-#include <linux/capability.h>
-#include <linux/sched.h>
-#include <linux/errno.h>
-#include <linux/bootmem.h>
-#include <linux/irq.h>
-#include <linux/list.h>
-#include <linux/of.h>
-#include <linux/slab.h>
-
-#include <asm/processor.h>
-#include <asm/io.h>
-#include <asm/prom.h>
-#include <asm/sections.h>
-#include <asm/pci-bridge.h>
-#include <asm/byteorder.h>
-#include <asm/uaccess.h>
-
-#undef DEBUG
-
-unsigned long isa_io_base;
-unsigned long pci_dram_offset;
-static int pci_bus_count;
-
-struct device_node * pcibios_get_phb_of_node(struct pci_bus *bus)
-{
-	struct pci_controller *hose = bus->sysdata;
-
-	return of_node_get(hose->dn);
-}
-
-static void __devinit pcibios_scan_phb(struct pci_controller *hose)
-{
-	struct pci_bus *bus;
-	struct device_node *node = hose->dn;
-	unsigned long io_offset;
-	struct resource *res = &hose->io_resource;
-
-	pr_debug("PCI: Scanning PHB %s\n",
-		 node ? node->full_name : "<NO NAME>");
-
-	/* Create an empty bus for the toplevel */
-	bus = pci_create_bus(hose->parent, hose->first_busno, hose->ops, hose);
-	if (bus == NULL) {
-		printk(KERN_ERR "Failed to create bus for PCI domain %04x\n",
-		       hose->global_number);
-		return;
-	}
-	bus->secondary = hose->first_busno;
-	hose->bus = bus;
-
-	/* Fixup IO space offset */
-	io_offset = (unsigned long)hose->io_base_virt - isa_io_base;
-	res->start = (res->start + io_offset) & 0xffffffffu;
-	res->end = (res->end + io_offset) & 0xffffffffu;
-
-	/* Wire up PHB bus resources */
-	pcibios_setup_phb_resources(hose);
-
-	/* Scan children */
-	hose->last_busno = bus->subordinate = pci_scan_child_bus(bus);
-}
-
-static int __init pcibios_init(void)
-{
-	struct pci_controller *hose, *tmp;
-	int next_busno = 0;
-
-	printk(KERN_INFO "PCI: Probing PCI hardware\n");
-
-	/* Scan all of the recorded PCI controllers.  */
-	list_for_each_entry_safe(hose, tmp, &hose_list, list_node) {
-		hose->last_busno = 0xff;
-		pcibios_scan_phb(hose);
-		printk(KERN_INFO "calling pci_bus_add_devices()\n");
-		pci_bus_add_devices(hose->bus);
-		if (next_busno <= hose->last_busno)
-			next_busno = hose->last_busno + 1;
-	}
-	pci_bus_count = next_busno;
-
-	/* Call common code to handle resource allocation */
-	pcibios_resource_survey();
-
-	return 0;
-}
-
-subsys_initcall(pcibios_init);
-
-static struct pci_controller*
-pci_bus_to_hose(int bus)
-{
-	struct pci_controller *hose, *tmp;
-
-	list_for_each_entry_safe(hose, tmp, &hose_list, list_node)
-		if (bus >= hose->first_busno && bus <= hose->last_busno)
-			return hose;
-	return NULL;
-}
-
-/* Provide information on locations of various I/O regions in physical
- * memory.  Do this on a per-card basis so that we choose the right
- * root bridge.
- * Note that the returned IO or memory base is a physical address
- */
-
-long sys_pciconfig_iobase(long which, unsigned long bus, unsigned long devfn)
-{
-	struct pci_controller *hose;
-	long result = -EOPNOTSUPP;
-
-	hose = pci_bus_to_hose(bus);
-	if (!hose)
-		return -ENODEV;
-
-	switch (which) {
-	case IOBASE_BRIDGE_NUMBER:
-		return (long)hose->first_busno;
-	case IOBASE_MEMORY:
-		return (long)hose->pci_mem_offset;
-	case IOBASE_IO:
-		return (long)hose->io_base_phys;
-	case IOBASE_ISA_IO:
-		return (long)isa_io_base;
-	case IOBASE_ISA_MEM:
-		return (long)isa_mem_base;
-	}
-
-	return result;
-}
-- 
1.7.1

