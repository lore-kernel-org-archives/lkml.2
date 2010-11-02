Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab0KBQWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 12:22:08 -0400
Received: from king.tilera.com ([72.1.168.226]:13155 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110Ab0KBQVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 12:21:54 -0400
Message-Id: <201011021621.oA2GLpkM024150@farm-0010.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 2 Nov 2010 12:05:10 -0400
Subject: [PATCH] pci root complex: support for tile architecture
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
X-OriginalArrivalTime: 02 Nov 2010 16:21:52.0279 (UTC) FILETIME=[0EE02270:01CB7AAA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change enables PCI root complex support for TILEPro.  Unlike
TILE-Gx, TILEPro has no support for memory-mapped I/O, so the PCI
support consists of hypervisor upcalls for PIO, DMA, etc.  However,
the performance is fine for the devices we have tested with so far
(1Gb Ethernet, SATA, etc.).

The <asm/io.h> header was tweaked to be a little bit more aggressive
about disabling attempts to map/unmap IO port space.  The hacky
<asm/pci-bridge.h> header was rolled into the <asm/pci.h> header
and the result was simplified.  Both of the latter two headers were
preliminary versions not meant for release before now - oh well.

There is one quirk for our TILEmpower platform, which accidentally
negotiates up to 5GT and needs to be kicked down to 2.5GT.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig                  |   12 +
 arch/tile/include/asm/io.h         |   15 +-
 arch/tile/include/asm/pci-bridge.h |  117 -------
 arch/tile/include/asm/pci.h        |  107 +++----
 arch/tile/kernel/Makefile          |    1 +
 arch/tile/kernel/pci.c             |  621 ++++++++++++++++++++++++++++++++++++
 drivers/pci/Makefile               |    1 +
 drivers/pci/quirks.c               |   18 +
 8 files changed, 705 insertions(+), 187 deletions(-)
 delete mode 100644 arch/tile/include/asm/pci-bridge.h
 create mode 100644 arch/tile/kernel/pci.c

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 07ec8a8..e11b5fc 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -329,6 +329,18 @@ endmenu  # Tilera-specific configuration
 
 menu "Bus options"
 
+config PCI
+	bool "PCI support"
+	default y
+	select PCI_DOMAINS
+	---help---
+	  Enable PCI root complex support, so PCIe endpoint devices can
+	  be attached to the Tile chip.  Many, but not all, PCI devices
+	  are supported under Tilera's root complex driver.
+
+config PCI_DOMAINS
+	bool
+
 config NO_IOMEM
 	def_bool !PCI
 
diff --git a/arch/tile/include/asm/io.h b/arch/tile/include/asm/io.h
index ee43328..d3cbb9b 100644
--- a/arch/tile/include/asm/io.h
+++ b/arch/tile/include/asm/io.h
@@ -55,9 +55,6 @@ extern void iounmap(volatile void __iomem *addr);
 #define ioremap_writethrough(physaddr, size)	ioremap(physaddr, size)
 #define ioremap_fullcache(physaddr, size)	ioremap(physaddr, size)
 
-void __iomem *ioport_map(unsigned long port, unsigned int len);
-extern inline void ioport_unmap(void __iomem *addr) {}
-
 #define mmiowb()
 
 /* Conversion between virtual and physical mappings.  */
@@ -189,12 +186,22 @@ static inline void memcpy_toio(volatile void __iomem *dst, const void *src,
  * we never run, uses them unconditionally.
  */
 
-static inline int ioport_panic(void)
+static inline long ioport_panic(void)
 {
 	panic("inb/outb and friends do not exist on tile");
 	return 0;
 }
 
+static inline void __iomem *ioport_map(unsigned long port, unsigned int len)
+{
+	return (void __iomem *) ioport_panic();
+}
+
+static inline void ioport_unmap(void __iomem *addr)
+{
+	ioport_panic();
+}
+
 static inline u8 inb(unsigned long addr)
 {
 	return ioport_panic();
diff --git a/arch/tile/include/asm/pci-bridge.h b/arch/tile/include/asm/pci-bridge.h
deleted file mode 100644
index e853b0e..0000000
--- a/arch/tile/include/asm/pci-bridge.h
+++ /dev/null
@@ -1,117 +0,0 @@
-/*
- * Copyright 2010 Tilera Corporation. All Rights Reserved.
- *
- *   This program is free software; you can redistribute it and/or
- *   modify it under the terms of the GNU General Public License
- *   as published by the Free Software Foundation, version 2.
- *
- *   This program is distributed in the hope that it will be useful, but
- *   WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- *   NON INFRINGEMENT.  See the GNU General Public License for
- *   more details.
- */
-
-#ifndef _ASM_TILE_PCI_BRIDGE_H
-#define _ASM_TILE_PCI_BRIDGE_H
-
-#include <linux/ioport.h>
-#include <linux/pci.h>
-
-struct device_node;
-struct pci_controller;
-
-/*
- * pci_io_base returns the memory address at which you can access
- * the I/O space for PCI bus number `bus' (or NULL on error).
- */
-extern void __iomem *pci_bus_io_base(unsigned int bus);
-extern unsigned long pci_bus_io_base_phys(unsigned int bus);
-extern unsigned long pci_bus_mem_base_phys(unsigned int bus);
-
-/* Allocate a new PCI host bridge structure */
-extern struct pci_controller *pcibios_alloc_controller(void);
-
-/* Helper function for setting up resources */
-extern void pci_init_resource(struct resource *res, unsigned long start,
-			      unsigned long end, int flags, char *name);
-
-/* Get the PCI host controller for a bus */
-extern struct pci_controller *pci_bus_to_hose(int bus);
-
-/*
- * Structure of a PCI controller (host bridge)
- */
-struct pci_controller {
-	int index;		/* PCI domain number */
-	struct pci_bus *root_bus;
-
-	int first_busno;
-	int last_busno;
-
-	int hv_cfg_fd[2];	/* config{0,1} fds for this PCIe controller */
-	int hv_mem_fd;		/* fd to Hypervisor for MMIO operations */
-
-	struct pci_ops *ops;
-
-	int irq_base;		/* Base IRQ from the Hypervisor	*/
-	int plx_gen1;		/* flag for PLX Gen 1 configuration */
-
-	/* Address ranges that are routed to this controller/bridge. */
-	struct resource mem_resources[3];
-};
-
-static inline struct pci_controller *pci_bus_to_host(struct pci_bus *bus)
-{
-	return bus->sysdata;
-}
-
-extern void setup_indirect_pci_nomap(struct pci_controller *hose,
-			       void __iomem *cfg_addr, void __iomem *cfg_data);
-extern void setup_indirect_pci(struct pci_controller *hose,
-			       u32 cfg_addr, u32 cfg_data);
-extern void setup_grackle(struct pci_controller *hose);
-
-extern unsigned char common_swizzle(struct pci_dev *, unsigned char *);
-
-/*
- *   The following code swizzles for exactly one bridge.  The routine
- *   common_swizzle below handles multiple bridges.  But there are a
- *   some boards that don't follow the PCI spec's suggestion so we
- *   break this piece out separately.
- */
-static inline unsigned char bridge_swizzle(unsigned char pin,
-		unsigned char idsel)
-{
-	return (((pin-1) + idsel) % 4) + 1;
-}
-
-/*
- * The following macro is used to lookup irqs in a standard table
- * format for those PPC systems that do not already have PCI
- * interrupts properly routed.
- */
-/* FIXME - double check this */
-#define PCI_IRQ_TABLE_LOOKUP ({ \
-	long _ctl_ = -1; \
-	if (idsel >= min_idsel && idsel <= max_idsel && pin <= irqs_per_slot) \
-		_ctl_ = pci_irq_table[idsel - min_idsel][pin-1]; \
-	_ctl_; \
-})
-
-/*
- * Scan the buses below a given PCI host bridge and assign suitable
- * resources to all devices found.
- */
-extern int pciauto_bus_scan(struct pci_controller *, int);
-
-#ifdef CONFIG_PCI
-extern unsigned long pci_address_to_pio(phys_addr_t address);
-#else
-static inline unsigned long pci_address_to_pio(phys_addr_t address)
-{
-	return (unsigned long)-1;
-}
-#endif
-
-#endif /* _ASM_TILE_PCI_BRIDGE_H */
diff --git a/arch/tile/include/asm/pci.h b/arch/tile/include/asm/pci.h
index b0c15da..c3fc458 100644
--- a/arch/tile/include/asm/pci.h
+++ b/arch/tile/include/asm/pci.h
@@ -15,7 +15,29 @@
 #ifndef _ASM_TILE_PCI_H
 #define _ASM_TILE_PCI_H
 
-#include <asm/pci-bridge.h>
+#include <linux/pci.h>
+
+/*
+ * Structure of a PCI controller (host bridge)
+ */
+struct pci_controller {
+	int index;		/* PCI domain number */
+	struct pci_bus *root_bus;
+
+	int first_busno;
+	int last_busno;
+
+	int hv_cfg_fd[2];	/* config{0,1} fds for this PCIe controller */
+	int hv_mem_fd;		/* fd to Hypervisor for MMIO operations */
+
+	struct pci_ops *ops;
+
+	int irq_base;		/* Base IRQ from the Hypervisor	*/
+	int plx_gen1;		/* flag for PLX Gen 1 configuration */
+
+	/* Address ranges that are routed to this controller/bridge. */
+	struct resource mem_resources[3];
+};
 
 /*
  * The hypervisor maps the entirety of CPA-space as bus addresses, so
@@ -24,56 +46,12 @@
  */
 #define PCI_DMA_BUS_IS_PHYS     1
 
-struct pci_controller *pci_bus_to_hose(int bus);
-unsigned char __init common_swizzle(struct pci_dev *dev, unsigned char *pinp);
 int __init tile_pci_init(void);
-void pci_iounmap(struct pci_dev *dev, void __iomem *addr);
-void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
-void __devinit pcibios_fixup_bus(struct pci_bus *bus);
 
-int __devinit _tile_cfg_read(struct pci_controller *hose,
-				    int bus,
-				    int slot,
-				    int function,
-				    int offset,
-				    int size,
-				    u32 *val);
-int __devinit _tile_cfg_write(struct pci_controller *hose,
-				     int bus,
-				     int slot,
-				     int function,
-				     int offset,
-				     int size,
-				     u32 val);
+void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
+static inline void pci_iounmap(struct pci_dev *dev, void __iomem *addr) {}
 
-/*
- * These are used to to config reads and writes in the early stages of
- * setup before the driver infrastructure has been set up enough to be
- * able to do config reads and writes.
- */
-#define early_cfg_read(where, size, value) \
-	_tile_cfg_read(controller, \
-		       current_bus, \
-		       pci_slot, \
-		       pci_fn, \
-		       where, \
-		       size, \
-		       value)
-
-#define early_cfg_write(where, size, value) \
-	_tile_cfg_write(controller, \
-		       current_bus, \
-		       pci_slot, \
-		       pci_fn, \
-		       where, \
-		       size, \
-		       value)
-
-
-
-#define PCICFG_BYTE	1
-#define PCICFG_WORD	2
-#define PCICFG_DWORD	4
+void __devinit pcibios_fixup_bus(struct pci_bus *bus);
 
 #define	TILE_NUM_PCIE	2
 
@@ -88,33 +66,33 @@ static inline int pci_proc_domain(struct pci_bus *bus)
 }
 
 /*
- * I/O space is currently not supported.
+ * pcibios_assign_all_busses() tells whether or not the bus numbers
+ * should be reassigned, in case the BIOS didn't do it correctly, or
+ * in case we don't have a BIOS and we want to let Linux do it.
  */
+static inline int pcibios_assign_all_busses(void)
+{
+	return 1;
+}
 
-#define TILE_PCIE_LOWER_IO		0x0
-#define TILE_PCIE_UPPER_IO		0x10000
-#define TILE_PCIE_PCIE_IO_SIZE		0x0000FFFF
-
-#define _PAGE_NO_CACHE		0
-#define _PAGE_GUARDED		0
-
-
-#define pcibios_assign_all_busses()    pci_assign_all_buses
-extern int pci_assign_all_buses;
-
+/*
+ * No special bus mastering setup handling.
+ */
 static inline void pcibios_set_master(struct pci_dev *dev)
 {
-	/* No special bus mastering setup handling */
 }
 
 #define PCIBIOS_MIN_MEM		0
-#define PCIBIOS_MIN_IO		TILE_PCIE_LOWER_IO
+#define PCIBIOS_MIN_IO		0
 
 /*
  * This flag tells if the platform is TILEmpower that needs
  * special configuration for the PLX switch chip.
  */
-extern int blade_pci;
+extern int tile_plx_gen1;
+
+/* Use any cpu for PCI. */
+#define cpumask_of_pcibus(bus) cpu_online_mask
 
 /* implement the pci_ DMA API in terms of the generic device dma_ one */
 #include <asm-generic/pci-dma-compat.h>
@@ -122,7 +100,4 @@ extern int blade_pci;
 /* generic pci stuff */
 #include <asm-generic/pci.h>
 
-/* Use any cpu for PCI. */
-#define cpumask_of_pcibus(bus) cpu_online_mask
-
 #endif /* _ASM_TILE_PCI_H */
diff --git a/arch/tile/kernel/Makefile b/arch/tile/kernel/Makefile
index 112b1e2..b4c8e8e 100644
--- a/arch/tile/kernel/Makefile
+++ b/arch/tile/kernel/Makefile
@@ -15,3 +15,4 @@ obj-$(CONFIG_SMP)		+= smpboot.o smp.o tlb.o
 obj-$(CONFIG_MODULES)		+= module.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
+obj-$(CONFIG_PCI)		+= pci.o
diff --git a/arch/tile/kernel/pci.c b/arch/tile/kernel/pci.c
new file mode 100644
index 0000000..a1ee25b
--- /dev/null
+++ b/arch/tile/kernel/pci.c
@@ -0,0 +1,621 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/delay.h>
+#include <linux/string.h>
+#include <linux/init.h>
+#include <linux/capability.h>
+#include <linux/sched.h>
+#include <linux/errno.h>
+#include <linux/bootmem.h>
+#include <linux/irq.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+
+#include <asm/processor.h>
+#include <asm/sections.h>
+#include <asm/byteorder.h>
+#include <asm/hv_driver.h>
+#include <hv/drv_pcie_rc_intf.h>
+
+
+/*
+ * Initialization flow and process
+ * -------------------------------
+ *
+ * This files containes the routines to search for PCI buses,
+ * enumerate the buses, and configure any attached devices.
+ *
+ * There are two entry points here:
+ * 1) tile_pci_init
+ *    This sets up the pci_controller structs, and opens the
+ *    FDs to the hypervisor.  This is called from setup_arch() early
+ *    in the boot process.
+ * 2) pcibios_init
+ *    This probes the PCI bus(es) for any attached hardware.  It's
+ *    called by subsys_initcall.  All of the real work is done by the
+ *    generic Linux PCI layer.
+ *
+ */
+
+/*
+ * This flag tells if the platform is TILEmpower that needs
+ * special configuration for the PLX switch chip.
+ */
+int __write_once tile_plx_gen1;
+
+static struct pci_controller controllers[TILE_NUM_PCIE];
+static int num_controllers;
+
+static struct pci_ops tile_cfg_ops;
+
+
+/*
+ * We don't need to worry about the alignment of resources.
+ */
+resource_size_t pcibios_align_resource(void *data, const struct resource *res,
+			    resource_size_t size, resource_size_t align)
+{
+	return res->start;
+}
+EXPORT_SYMBOL(pcibios_align_resource);
+
+/*
+ * Open a FD to the hypervisor PCI device.
+ *
+ * controller_id is the controller number, config type is 0 or 1 for
+ * config0 or config1 operations.
+ */
+static int __init tile_pcie_open(int controller_id, int config_type)
+{
+	char filename[32];
+	int fd;
+
+	sprintf(filename, "pcie/%d/config%d", controller_id, config_type);
+
+	fd = hv_dev_open((HV_VirtAddr)filename, 0);
+
+	return fd;
+}
+
+
+/*
+ * Get the IRQ numbers from the HV and set up the handlers for them.
+ */
+static int __init tile_init_irqs(int controller_id,
+				 struct pci_controller *controller)
+{
+	char filename[32];
+	int fd;
+	int ret;
+	int x;
+	struct pcie_rc_config rc_config;
+
+	sprintf(filename, "pcie/%d/ctl", controller_id);
+	fd = hv_dev_open((HV_VirtAddr)filename, 0);
+	if (fd < 0) {
+		pr_err("PCI: hv_dev_open(%s) failed\n", filename);
+		return -1;
+	}
+	ret = hv_dev_pread(fd, 0, (HV_VirtAddr)(&rc_config),
+			   sizeof(rc_config), PCIE_RC_CONFIG_MASK_OFF);
+	hv_dev_close(fd);
+	if (ret != sizeof(rc_config)) {
+		pr_err("PCI: wanted %zd bytes, got %d\n",
+		       sizeof(rc_config), ret);
+		return -1;
+	}
+	/* Record irq_base so that we can map INTx to IRQ # later. */
+	controller->irq_base = rc_config.intr;
+
+	for (x = 0; x < 4; x++)
+		tile_irq_activate(rc_config.intr + x,
+				  TILE_IRQ_HW_CLEAR);
+
+	if (rc_config.plx_gen1)
+		controller->plx_gen1 = 1;
+
+	return 0;
+}
+
+/*
+ * First initialization entry point, called from setup_arch().
+ *
+ * Find valid controllers and fill in pci_controller structs for each
+ * of them.
+ *
+ * Returns the number of controllers discovered.
+ */
+int __init tile_pci_init(void)
+{
+	int i;
+
+	pr_info("PCI: Searching for controllers...\n");
+
+	/* Do any configuration we need before using the PCIe */
+
+	for (i = 0; i < TILE_NUM_PCIE; i++) {
+		int hv_cfg_fd0 = -1;
+		int hv_cfg_fd1 = -1;
+		int hv_mem_fd = -1;
+		char name[32];
+		struct pci_controller *controller;
+
+		/*
+		 * Open the fd to the HV.  If it fails then this
+		 * device doesn't exist.
+		 */
+		hv_cfg_fd0 = tile_pcie_open(i, 0);
+		if (hv_cfg_fd0 < 0)
+			continue;
+		hv_cfg_fd1 = tile_pcie_open(i, 1);
+		if (hv_cfg_fd1 < 0) {
+			pr_err("PCI: Couldn't open config fd to HV "
+			    "for controller %d\n", i);
+			goto err_cont;
+		}
+
+		sprintf(name, "pcie/%d/mem", i);
+		hv_mem_fd = hv_dev_open((HV_VirtAddr)name, 0);
+		if (hv_mem_fd < 0) {
+			pr_err("PCI: Could not open mem fd to HV!\n");
+			goto err_cont;
+		}
+
+		pr_info("PCI: Found PCI controller #%d\n", i);
+
+		controller = &controllers[num_controllers];
+
+		if (tile_init_irqs(i, controller)) {
+			pr_err("PCI: Could not initialize "
+			       "IRQs, aborting.\n");
+			goto err_cont;
+		}
+
+		controller->index = num_controllers;
+		controller->hv_cfg_fd[0] = hv_cfg_fd0;
+		controller->hv_cfg_fd[1] = hv_cfg_fd1;
+		controller->hv_mem_fd = hv_mem_fd;
+		controller->first_busno = 0;
+		controller->last_busno = 0xff;
+		controller->ops = &tile_cfg_ops;
+
+		num_controllers++;
+		continue;
+
+err_cont:
+		if (hv_cfg_fd0 >= 0)
+			hv_dev_close(hv_cfg_fd0);
+		if (hv_cfg_fd1 >= 0)
+			hv_dev_close(hv_cfg_fd1);
+		if (hv_mem_fd >= 0)
+			hv_dev_close(hv_mem_fd);
+		continue;
+	}
+
+	/*
+	 * Before using the PCIe, see if we need to do any platform-specific
+	 * configuration, such as the PLX switch Gen 1 issue on TILEmpower.
+	 */
+	for (i = 0; i < num_controllers; i++) {
+		struct pci_controller *controller = &controllers[i];
+
+		if (controller->plx_gen1)
+			tile_plx_gen1 = 1;
+	}
+
+	return num_controllers;
+}
+
+/*
+ * (pin - 1) converts from the PCI standard's [1:4] convention to
+ * a normal [0:3] range.
+ */
+static int tile_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+{
+	struct pci_controller *controller =
+		(struct pci_controller *)dev->sysdata;
+	return (pin - 1) + controller->irq_base;
+}
+
+
+static void __init fixup_read_and_payload_sizes(void)
+{
+	struct pci_dev *dev = NULL;
+	int smallest_max_payload = 0x1; /* Tile maxes out at 256 bytes. */
+	int max_read_size = 0x2; /* Limit to 512 byte reads. */
+	u16 new_values;
+
+	/* Scan for the smallest maximum payload size. */
+	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
+		int pcie_caps_offset;
+		u32 devcap;
+		int max_payload;
+
+		pcie_caps_offset = pci_find_capability(dev, PCI_CAP_ID_EXP);
+		if (pcie_caps_offset == 0)
+			continue;
+
+		pci_read_config_dword(dev, pcie_caps_offset + PCI_EXP_DEVCAP,
+				      &devcap);
+		max_payload = devcap & PCI_EXP_DEVCAP_PAYLOAD;
+		if (max_payload < smallest_max_payload)
+			smallest_max_payload = max_payload;
+	}
+
+	/* Now, set the max_payload_size for all devices to that value. */
+	new_values = (max_read_size << 12) | (smallest_max_payload << 5);
+	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
+		int pcie_caps_offset;
+		u16 devctl;
+
+		pcie_caps_offset = pci_find_capability(dev, PCI_CAP_ID_EXP);
+		if (pcie_caps_offset == 0)
+			continue;
+
+		pci_read_config_word(dev, pcie_caps_offset + PCI_EXP_DEVCTL,
+				     &devctl);
+		devctl &= ~(PCI_EXP_DEVCTL_PAYLOAD | PCI_EXP_DEVCTL_READRQ);
+		devctl |= new_values;
+		pci_write_config_word(dev, pcie_caps_offset + PCI_EXP_DEVCTL,
+				      devctl);
+	}
+}
+
+
+/*
+ * Second PCI initialization entry point, called by subsys_initcall.
+ *
+ * The controllers have been set up by the time we get here, by a call to
+ * tile_pci_init.
+ */
+static int __init pcibios_init(void)
+{
+	int i;
+
+	pr_info("PCI: Probing PCI hardware\n");
+
+	/*
+	 * Delay a bit in case devices aren't ready.  Some devices are
+	 * known to require at least 20ms here, but we use a more
+	 * conservative value.
+	 */
+	mdelay(250);
+
+	/* Scan all of the recorded PCI controllers.  */
+	for (i = 0; i < num_controllers; i++) {
+		struct pci_controller *controller = &controllers[i];
+		struct pci_bus *bus;
+
+		pr_info("PCI: initializing controller #%d\n", i);
+
+		/*
+		 * This comes from the generic Linux PCI driver.
+		 *
+		 * It reads the PCI tree for this bus into the Linux
+		 * data structures.
+		 *
+		 * This is inlined in linux/pci.h and calls into
+		 * pci_scan_bus_parented() in probe.c.
+		 */
+		bus = pci_scan_bus(0, controller->ops, controller);
+		controller->root_bus = bus;
+		controller->last_busno = bus->subordinate;
+
+	}
+
+	/* Do machine dependent PCI interrupt routing */
+	pci_fixup_irqs(pci_common_swizzle, tile_map_irq);
+
+	/*
+	 * This comes from the generic Linux PCI driver.
+	 *
+	 * It allocates all of the resources (I/O memory, etc)
+	 * associated with the devices read in above.
+	 */
+
+	pci_assign_unassigned_resources();
+
+	/* Configure the max_read_size and max_payload_size values. */
+	fixup_read_and_payload_sizes();
+
+	/* Record the I/O resources in the PCI controller structure. */
+	for (i = 0; i < num_controllers; i++) {
+		struct pci_bus *root_bus = controllers[i].root_bus;
+		struct pci_bus *next_bus;
+		struct pci_dev *dev;
+
+		list_for_each_entry(dev, &root_bus->devices, bus_list) {
+			/* Find the PCI host controller, ie. the 1st bridge. */
+			if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI &&
+				(PCI_SLOT(dev->devfn) == 0)) {
+				next_bus = dev->subordinate;
+				controllers[i].mem_resources[0] =
+					*next_bus->resource[0];
+				controllers[i].mem_resources[1] =
+					 *next_bus->resource[1];
+				controllers[i].mem_resources[2] =
+					 *next_bus->resource[2];
+
+				break;
+			}
+		}
+
+	}
+
+	return 0;
+}
+subsys_initcall(pcibios_init);
+
+/*
+ * No bus fixups needed.
+ */
+void __devinit pcibios_fixup_bus(struct pci_bus *bus)
+{
+	/* Nothing needs to be done. */
+}
+
+/*
+ * This can be called from the generic PCI layer, but doesn't need to
+ * do anything.
+ */
+char __devinit *pcibios_setup(char *str)
+{
+	/* Nothing needs to be done. */
+	return str;
+}
+
+/*
+ * This is called from the generic Linux layer.
+ */
+void __init pcibios_update_irq(struct pci_dev *dev, int irq)
+{
+	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
+}
+
+/*
+ * Enable memory and/or address decoding, as appropriate, for the
+ * device described by the 'dev' struct.
+ *
+ * This is called from the generic PCI layer, and can be called
+ * for bridges or endpoints.
+ */
+int pcibios_enable_device(struct pci_dev *dev, int mask)
+{
+	u16 cmd, old_cmd;
+	u8 header_type;
+	int i;
+	struct resource *r;
+
+	pci_read_config_byte(dev, PCI_HEADER_TYPE, &header_type);
+
+	pci_read_config_word(dev, PCI_COMMAND, &cmd);
+	old_cmd = cmd;
+	if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE) {
+		/*
+		 * For bridges, we enable both memory and I/O decoding
+		 * in call cases.
+		 */
+		cmd |= PCI_COMMAND_IO;
+		cmd |= PCI_COMMAND_MEMORY;
+	} else {
+		/*
+		 * For endpoints, we enable memory and/or I/O decoding
+		 * only if they have a memory resource of that type.
+		 */
+		for (i = 0; i < 6; i++) {
+			r = &dev->resource[i];
+			if (r->flags & IORESOURCE_UNSET) {
+				pr_err("PCI: Device %s not available "
+				       "because of resource collisions\n",
+				       pci_name(dev));
+				return -EINVAL;
+			}
+			if (r->flags & IORESOURCE_IO)
+				cmd |= PCI_COMMAND_IO;
+			if (r->flags & IORESOURCE_MEM)
+				cmd |= PCI_COMMAND_MEMORY;
+		}
+	}
+
+	/*
+	 * We only write the command if it changed.
+	 */
+	if (cmd != old_cmd)
+		pci_write_config_word(dev, PCI_COMMAND, cmd);
+	return 0;
+}
+
+void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max)
+{
+	unsigned long start = pci_resource_start(dev, bar);
+	unsigned long len = pci_resource_len(dev, bar);
+	unsigned long flags = pci_resource_flags(dev, bar);
+
+	if (!len)
+		return NULL;
+	if (max && len > max)
+		len = max;
+
+	if (!(flags & IORESOURCE_MEM)) {
+		pr_info("PCI: Trying to map invalid resource %#lx\n", flags);
+		start = 0;
+	}
+
+	return (void __iomem *)start;
+}
+EXPORT_SYMBOL(pci_iomap);
+
+
+/****************************************************************
+ *
+ * Tile PCI config space read/write routines
+ *
+ ****************************************************************/
+
+/*
+ * These are the normal read and write ops
+ * These are expanded with macros from  pci_bus_read_config_byte() etc.
+ *
+ * devfn is the combined PCI slot & function.
+ *
+ * offset is in bytes, from the start of config space for the
+ * specified bus & slot.
+ */
+
+static int __devinit tile_cfg_read(struct pci_bus *bus,
+				   unsigned int devfn,
+				   int offset,
+				   int size,
+				   u32 *val)
+{
+	struct pci_controller *controller = bus->sysdata;
+	int busnum = bus->number & 0xff;
+	int slot = (devfn >> 3) & 0x1f;
+	int function = devfn & 0x7;
+	u32 addr;
+	int config_mode = 1;
+
+	/*
+	 * There is no bridge between the Tile and bus 0, so we
+	 * use config0 to talk to bus 0.
+	 *
+	 * If we're talking to a bus other than zero then we
+	 * must have found a bridge.
+	 */
+	if (busnum == 0) {
+		/*
+		 * We fake an empty slot for (busnum == 0) && (slot > 0),
+		 * since there is only one slot on bus 0.
+		 */
+		if (slot) {
+			*val = 0xFFFFFFFF;
+			return 0;
+		}
+		config_mode = 0;
+	}
+
+	addr = busnum << 20;		/* Bus in 27:20 */
+	addr |= slot << 15;		/* Slot (device) in 19:15 */
+	addr |= function << 12;		/* Function is in 14:12 */
+	addr |= (offset & 0xFFF);	/* byte address in 0:11 */
+
+	return hv_dev_pread(controller->hv_cfg_fd[config_mode], 0,
+			    (HV_VirtAddr)(val), size, addr);
+}
+
+
+/*
+ * See tile_cfg_read() for relevent comments.
+ * Note that "val" is the value to write, not a pointer to that value.
+ */
+static int __devinit tile_cfg_write(struct pci_bus *bus,
+				    unsigned int devfn,
+				    int offset,
+				    int size,
+				    u32 val)
+{
+	struct pci_controller *controller = bus->sysdata;
+	int busnum = bus->number & 0xff;
+	int slot = (devfn >> 3) & 0x1f;
+	int function = devfn & 0x7;
+	u32 addr;
+	int config_mode = 1;
+	HV_VirtAddr valp = (HV_VirtAddr)&val;
+
+	/*
+	 * For bus 0 slot 0 we use config 0 accesses.
+	 */
+	if (busnum == 0) {
+		/*
+		 * We fake an empty slot for (busnum == 0) && (slot > 0),
+		 * since there is only one slot on bus 0.
+		 */
+		if (slot)
+			return 0;
+		config_mode = 0;
+	}
+
+	addr = busnum << 20;		/* Bus in 27:20 */
+	addr |= slot << 15;		/* Slot (device) in 19:15 */
+	addr |= function << 12;		/* Function is in 14:12 */
+	addr |= (offset & 0xFFF);	/* byte address in 0:11 */
+
+#ifdef __BIG_ENDIAN
+	/* Point to the correct part of the 32-bit "val". */
+	valp += 4 - size;
+#endif
+
+	return hv_dev_pwrite(controller->hv_cfg_fd[config_mode], 0,
+			     valp, size, addr);
+}
+
+
+static struct pci_ops tile_cfg_ops = {
+	.read =         tile_cfg_read,
+	.write =        tile_cfg_write,
+};
+
+
+/*
+ * In the following, each PCI controller's mem_resources[1]
+ * represents its (non-prefetchable) PCI memory resource.
+ * mem_resources[0] and mem_resources[2] refer to its PCI I/O and
+ * prefetchable PCI memory resources, respectively.
+ * For more details, see pci_setup_bridge() in setup-bus.c.
+ * By comparing the target PCI memory address against the
+ * end address of controller 0, we can determine the controller
+ * that should accept the PCI memory access.
+ */
+#define TILE_READ(size, type)						\
+type _tile_read##size(unsigned long addr)				\
+{									\
+	type val;							\
+	int idx = 0;							\
+	if (addr > controllers[0].mem_resources[1].end &&		\
+	    addr > controllers[0].mem_resources[2].end)			\
+		idx = 1;                                                \
+	if (hv_dev_pread(controllers[idx].hv_mem_fd, 0,			\
+			 (HV_VirtAddr)(&val), sizeof(type), addr))	\
+		pr_err("PCI: read %zd bytes at 0x%lX failed\n",		\
+		       sizeof(type), addr);				\
+	return val;							\
+}									\
+EXPORT_SYMBOL(_tile_read##size)
+
+TILE_READ(b, u8);
+TILE_READ(w, u16);
+TILE_READ(l, u32);
+TILE_READ(q, u64);
+
+#define TILE_WRITE(size, type)						\
+void _tile_write##size(type val, unsigned long addr)			\
+{									\
+	int idx = 0;							\
+	if (addr > controllers[0].mem_resources[1].end &&		\
+	    addr > controllers[0].mem_resources[2].end)			\
+		idx = 1;                                                \
+	if (hv_dev_pwrite(controllers[idx].hv_mem_fd, 0,		\
+			  (HV_VirtAddr)(&val), sizeof(type), addr))	\
+		pr_err("PCI: write %zd bytes at 0x%lX failed\n",	\
+		       sizeof(type), addr);				\
+}									\
+EXPORT_SYMBOL(_tile_write##size)
+
+TILE_WRITE(b, u8);
+TILE_WRITE(w, u16);
+TILE_WRITE(l, u32);
+TILE_WRITE(q, u64);
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index f01e344..98e6fdf 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_MIPS) += setup-bus.o setup-irq.o
 obj-$(CONFIG_X86_VISWS) += setup-irq.o
 obj-$(CONFIG_MN10300) += setup-bus.o
 obj-$(CONFIG_MICROBLAZE) += setup-bus.o
+obj-$(CONFIG_TILE) += setup-bus.o setup-irq.o
 
 #
 # ACPI Related PCI FW Functions
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index f5c63fe..6f9350c 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2136,6 +2136,24 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82865_HB,
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82875_HB,
 			quirk_unhide_mch_dev6);
 
+#ifdef CONFIG_TILE
+/*
+ * The Tilera TILEmpower platform needs to set the link speed
+ * to 2.5GT(Giga-Transfers)/s (Gen 1). The default link speed
+ * setting is 5GT/s (Gen 2). 0x98 is the Link Control2 PCIe
+ * capability register of the PEX8624 PCIe switch. The switch
+ * supports link speed auto negotiation, but falsely sets
+ * the link speed to 5GT/s.
+ */
+static void __devinit quirk_tile_plx_gen1(struct pci_dev *dev)
+{
+	if (tile_plx_gen1) {
+		pci_write_config_dword(dev, 0x98, 0x1);
+		mdelay(50);
+	}
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_PLX, 0x8624, quirk_tile_plx_gen1);
+#endif /* CONFIG_TILE */
 
 #ifdef CONFIG_PCI_MSI
 /* Some chipsets do not support MSI. We cannot easily rely on setting
-- 
1.6.5.2

