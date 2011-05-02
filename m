Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab1EBXJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 19:09:32 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:54332 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab1EBXJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 19:09:28 -0400
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 May 2011 19:09:25 EDT
Message-Id: <201105022254.p42MsPFB030352@farm-0023.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 2 May 2011 15:09:42 -0400
Subject: [PATCH] arch/tile: improve support for PCI hotplug
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
X-OriginalArrivalTime: 02 May 2011 22:54:25.0909 (UTC) FILETIME=[E2B39A50:01CC091B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note that this is not complete hot-plug support; hot-unplug is not included.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/pci.h |    3 +-
 arch/tile/kernel/pci.c      |  207 ++++++++++++++++++++++++-------------------
 2 files changed, 119 insertions(+), 91 deletions(-)

diff --git a/arch/tile/include/asm/pci.h b/arch/tile/include/asm/pci.h
index c3fc458..7f03cef 100644
--- a/arch/tile/include/asm/pci.h
+++ b/arch/tile/include/asm/pci.h
@@ -46,7 +46,8 @@ struct pci_controller {
  */
 #define PCI_DMA_BUS_IS_PHYS     1
 
-int __init tile_pci_init(void);
+int __devinit tile_pci_init(void);
+int __devinit pcibios_init(void);
 
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
 static inline void pci_iounmap(struct pci_dev *dev, void __iomem *addr) {}
diff --git a/arch/tile/kernel/pci.c b/arch/tile/kernel/pci.c
index ea38f0c..65add02 100644
--- a/arch/tile/kernel/pci.c
+++ b/arch/tile/kernel/pci.c
@@ -1,5 +1,5 @@
 /*
- * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ * Copyright 2011 Tilera Corporation. All Rights Reserved.
  *
  *   This program is free software; you can redistribute it and/or
  *   modify it under the terms of the GNU General Public License
@@ -59,6 +59,7 @@ int __write_once tile_plx_gen1;
 
 static struct pci_controller controllers[TILE_NUM_PCIE];
 static int num_controllers;
+static int pci_scan_flags[TILE_NUM_PCIE];
 
 static struct pci_ops tile_cfg_ops;
 
@@ -79,7 +80,7 @@ EXPORT_SYMBOL(pcibios_align_resource);
  * controller_id is the controller number, config type is 0 or 1 for
  * config0 or config1 operations.
  */
-static int __init tile_pcie_open(int controller_id, int config_type)
+static int __devinit tile_pcie_open(int controller_id, int config_type)
 {
 	char filename[32];
 	int fd;
@@ -95,7 +96,7 @@ static int __init tile_pcie_open(int controller_id, int config_type)
 /*
  * Get the IRQ numbers from the HV and set up the handlers for them.
  */
-static int __init tile_init_irqs(int controller_id,
+static int __devinit tile_init_irqs(int controller_id,
 				 struct pci_controller *controller)
 {
 	char filename[32];
@@ -139,71 +140,80 @@ static int __init tile_init_irqs(int controller_id,
  *
  * Returns the number of controllers discovered.
  */
-int __init tile_pci_init(void)
+int __devinit tile_pci_init(void)
 {
 	int i;
 
 	pr_info("PCI: Searching for controllers...\n");
 
+	/* Re-init number of PCIe controllers to support hot-plug feature. */
+	num_controllers = 0;
+
 	/* Do any configuration we need before using the PCIe */
 
 	for (i = 0; i < TILE_NUM_PCIE; i++) {
-		int hv_cfg_fd0 = -1;
-		int hv_cfg_fd1 = -1;
-		int hv_mem_fd = -1;
-		char name[32];
-		struct pci_controller *controller;
-
 		/*
-		 * Open the fd to the HV.  If it fails then this
-		 * device doesn't exist.
+		 * To see whether we need a real config op based on
+		 * the results of pcibios_init(), to support PCIe hot-plug.
 		 */
-		hv_cfg_fd0 = tile_pcie_open(i, 0);
-		if (hv_cfg_fd0 < 0)
-			continue;
-		hv_cfg_fd1 = tile_pcie_open(i, 1);
-		if (hv_cfg_fd1 < 0) {
-			pr_err("PCI: Couldn't open config fd to HV "
-			    "for controller %d\n", i);
-			goto err_cont;
-		}
+		if (pci_scan_flags[i] == 0) {
+			int hv_cfg_fd0 = -1;
+			int hv_cfg_fd1 = -1;
+			int hv_mem_fd = -1;
+			char name[32];
+			struct pci_controller *controller;
+
+			/*
+			 * Open the fd to the HV.  If it fails then this
+			 * device doesn't exist.
+			 */
+			hv_cfg_fd0 = tile_pcie_open(i, 0);
+			if (hv_cfg_fd0 < 0)
+				continue;
+			hv_cfg_fd1 = tile_pcie_open(i, 1);
+			if (hv_cfg_fd1 < 0) {
+				pr_err("PCI: Couldn't open config fd to HV "
+				    "for controller %d\n", i);
+				goto err_cont;
+			}
 
-		sprintf(name, "pcie/%d/mem", i);
-		hv_mem_fd = hv_dev_open((HV_VirtAddr)name, 0);
-		if (hv_mem_fd < 0) {
-			pr_err("PCI: Could not open mem fd to HV!\n");
-			goto err_cont;
-		}
+			sprintf(name, "pcie/%d/mem", i);
+			hv_mem_fd = hv_dev_open((HV_VirtAddr)name, 0);
+			if (hv_mem_fd < 0) {
+				pr_err("PCI: Could not open mem fd to HV!\n");
+				goto err_cont;
+			}
 
-		pr_info("PCI: Found PCI controller #%d\n", i);
+			pr_info("PCI: Found PCI controller #%d\n", i);
 
-		controller = &controllers[num_controllers];
+			controller = &controllers[i];
 
-		if (tile_init_irqs(i, controller)) {
-			pr_err("PCI: Could not initialize "
-			       "IRQs, aborting.\n");
-			goto err_cont;
-		}
+			if (tile_init_irqs(i, controller)) {
+				pr_err("PCI: Could not initialize "
+				       "IRQs, aborting.\n");
+				goto err_cont;
+			}
 
-		controller->index = num_controllers;
-		controller->hv_cfg_fd[0] = hv_cfg_fd0;
-		controller->hv_cfg_fd[1] = hv_cfg_fd1;
-		controller->hv_mem_fd = hv_mem_fd;
-		controller->first_busno = 0;
-		controller->last_busno = 0xff;
-		controller->ops = &tile_cfg_ops;
+			controller->index = i;
+			controller->hv_cfg_fd[0] = hv_cfg_fd0;
+			controller->hv_cfg_fd[1] = hv_cfg_fd1;
+			controller->hv_mem_fd = hv_mem_fd;
+			controller->first_busno = 0;
+			controller->last_busno = 0xff;
+			controller->ops = &tile_cfg_ops;
 
-		num_controllers++;
-		continue;
+			num_controllers++;
+			continue;
 
 err_cont:
-		if (hv_cfg_fd0 >= 0)
-			hv_dev_close(hv_cfg_fd0);
-		if (hv_cfg_fd1 >= 0)
-			hv_dev_close(hv_cfg_fd1);
-		if (hv_mem_fd >= 0)
-			hv_dev_close(hv_mem_fd);
-		continue;
+			if (hv_cfg_fd0 >= 0)
+				hv_dev_close(hv_cfg_fd0);
+			if (hv_cfg_fd1 >= 0)
+				hv_dev_close(hv_cfg_fd1);
+			if (hv_mem_fd >= 0)
+				hv_dev_close(hv_mem_fd);
+			continue;
+		}
 	}
 
 	/*
@@ -232,7 +242,7 @@ static int tile_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
 }
 
 
-static void __init fixup_read_and_payload_sizes(void)
+static void __devinit fixup_read_and_payload_sizes(void)
 {
 	struct pci_dev *dev = NULL;
 	int smallest_max_payload = 0x1; /* Tile maxes out at 256 bytes. */
@@ -282,7 +292,7 @@ static void __init fixup_read_and_payload_sizes(void)
  * The controllers have been set up by the time we get here, by a call to
  * tile_pci_init.
  */
-static int __init pcibios_init(void)
+int __devinit pcibios_init(void)
 {
 	int i;
 
@@ -296,25 +306,31 @@ static int __init pcibios_init(void)
 	mdelay(250);
 
 	/* Scan all of the recorded PCI controllers.  */
-	for (i = 0; i < num_controllers; i++) {
-		struct pci_controller *controller = &controllers[i];
-		struct pci_bus *bus;
-
-		pr_info("PCI: initializing controller #%d\n", i);
-
+	for (i = 0; i < TILE_NUM_PCIE; i++) {
 		/*
-		 * This comes from the generic Linux PCI driver.
-		 *
-		 * It reads the PCI tree for this bus into the Linux
-		 * data structures.
-		 *
-		 * This is inlined in linux/pci.h and calls into
-		 * pci_scan_bus_parented() in probe.c.
+		 * Do real pcibios init ops if the controller is initialized
+		 * by tile_pci_init() successfully and not initialized by
+		 * pcibios_init() yet to support PCIe hot-plug.
 		 */
-		bus = pci_scan_bus(0, controller->ops, controller);
-		controller->root_bus = bus;
-		controller->last_busno = bus->subordinate;
-
+		if (pci_scan_flags[i] == 0 && controllers[i].ops != NULL) {
+			struct pci_controller *controller = &controllers[i];
+			struct pci_bus *bus;
+
+			pr_info("PCI: initializing controller #%d\n", i);
+
+			/*
+			 * This comes from the generic Linux PCI driver.
+			 *
+			 * It reads the PCI tree for this bus into the Linux
+			 * data structures.
+			 *
+			 * This is inlined in linux/pci.h and calls into
+			 * pci_scan_bus_parented() in probe.c.
+			 */
+			bus = pci_scan_bus(0, controller->ops, controller);
+			controller->root_bus = bus;
+			controller->last_busno = bus->subordinate;
+		}
 	}
 
 	/* Do machine dependent PCI interrupt routing */
@@ -326,34 +342,45 @@ static int __init pcibios_init(void)
 	 * It allocates all of the resources (I/O memory, etc)
 	 * associated with the devices read in above.
 	 */
-
 	pci_assign_unassigned_resources();
 
 	/* Configure the max_read_size and max_payload_size values. */
 	fixup_read_and_payload_sizes();
 
 	/* Record the I/O resources in the PCI controller structure. */
-	for (i = 0; i < num_controllers; i++) {
-		struct pci_bus *root_bus = controllers[i].root_bus;
-		struct pci_bus *next_bus;
-		struct pci_dev *dev;
-
-		list_for_each_entry(dev, &root_bus->devices, bus_list) {
-			/* Find the PCI host controller, ie. the 1st bridge. */
-			if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI &&
-				(PCI_SLOT(dev->devfn) == 0)) {
-				next_bus = dev->subordinate;
-				controllers[i].mem_resources[0] =
-					*next_bus->resource[0];
-				controllers[i].mem_resources[1] =
-					 *next_bus->resource[1];
-				controllers[i].mem_resources[2] =
-					 *next_bus->resource[2];
-
-				break;
+	for (i = 0; i < TILE_NUM_PCIE; i++) {
+		/*
+		 * Do real pcibios init ops if the controller is initialized
+		 * by tile_pci_init() successfully and not initialized by
+		 * pcibios_init() yet to support PCIe hot-plug.
+		 */
+		if (pci_scan_flags[i] == 0 && controllers[i].ops != NULL) {
+			struct pci_bus *root_bus = controllers[i].root_bus;
+			struct pci_bus *next_bus;
+			struct pci_dev *dev;
+
+			list_for_each_entry(dev, &root_bus->devices, bus_list) {
+				/*
+				 * Find the PCI host controller, ie. the 1st
+				 * bridge.
+				 */
+				if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI &&
+					(PCI_SLOT(dev->devfn) == 0)) {
+					next_bus = dev->subordinate;
+					controllers[i].mem_resources[0] =
+						*next_bus->resource[0];
+					controllers[i].mem_resources[1] =
+						 *next_bus->resource[1];
+					controllers[i].mem_resources[2] =
+						 *next_bus->resource[2];
+
+					/* Setup flags. */
+					pci_scan_flags[i] = 1;
+
+					break;
+				}
 			}
 		}
-
 	}
 
 	return 0;
@@ -381,7 +408,7 @@ char __devinit *pcibios_setup(char *str)
 /*
  * This is called from the generic Linux layer.
  */
-void __init pcibios_update_irq(struct pci_dev *dev, int irq)
+void __devinit pcibios_update_irq(struct pci_dev *dev, int irq)
 {
 	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
 }
-- 
1.6.5.2

