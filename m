Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab0FUWaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 18:30:30 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61133 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab0FUWa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 18:30:26 -0400
Subject: [PATCH v2 1/5] of/irq: Move irq_of_parse_and_map() to common code
To: microblaze-uclinux@itee.uq.edu.au, devicetree-discuss@lists.ozlabs.org,
       linuxppc-dev@lists.ozlabs.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: sfr@canb.auug.org.au, monstr@monstr.eu, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org
Date: Mon, 21 Jun 2010 16:30:22 -0600
Message-ID: <20100621223016.18925.13518.stgit@angua>
In-Reply-To: <20100621222052.18925.61569.stgit@angua>
References: <20100621222052.18925.61569.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge common code between PowerPC and Microblaze.  SPARC implements
irq_of_parse_and_map(), but the implementation is different, so it
does not use this code.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
---
 arch/microblaze/include/asm/irq.h  |   13 -----------
 arch/microblaze/include/asm/prom.h |   26 +----------------------
 arch/microblaze/kernel/irq.c       |   14 ++----------
 arch/powerpc/include/asm/irq.h     |   13 -----------
 arch/powerpc/include/asm/prom.h    |   27 +-----------------------
 arch/powerpc/kernel/irq.c          |   14 ++----------
 arch/sparc/include/asm/prom.h      |    1 -
 drivers/of/Kconfig                 |    4 ++++
 drivers/of/Makefile                |    1 +
 drivers/of/irq.c                   |   37 ++++++++++++++++++++++++++++++++
 drivers/of/of_mdio.c               |    1 +
 include/linux/of_irq.h             |   41 ++++++++++++++++++++++++++++++++++++
 12 files changed, 90 insertions(+), 102 deletions(-)
 create mode 100644 drivers/of/irq.c
 create mode 100644 include/linux/of_irq.h

diff --git a/arch/microblaze/include/asm/irq.h b/arch/microblaze/include/asm/irq.h
index 31a35c3..10d75c1 100644
--- a/arch/microblaze/include/asm/irq.h
+++ b/arch/microblaze/include/asm/irq.h
@@ -62,17 +62,4 @@ struct irq_host;
 extern unsigned int irq_create_mapping(struct irq_host *host,
 					irq_hw_number_t hwirq);
 
-/**
- * irq_create_of_mapping - Map a hardware interrupt into linux virq space
- * @controller: Device node of the interrupt controller
- * @inspec: Interrupt specifier from the device-tree
- * @intsize: Size of the interrupt specifier from the device-tree
- *
- * This function is identical to irq_create_mapping except that it takes
- * as input informations straight from the device-tree (typically the results
- * of the of_irq_map_*() functions.
- */
-extern unsigned int irq_create_of_mapping(struct device_node *controller,
-					u32 *intspec, unsigned int intsize);
-
 #endif /* _ASM_MICROBLAZE_IRQ_H */
diff --git a/arch/microblaze/include/asm/prom.h b/arch/microblaze/include/asm/prom.h
index e7d67a3..e9fb2eb 100644
--- a/arch/microblaze/include/asm/prom.h
+++ b/arch/microblaze/include/asm/prom.h
@@ -20,6 +20,7 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/types.h>
+#include <linux/of_irq.h>
 #include <linux/of_fdt.h>
 #include <linux/proc_fs.h>
 #include <linux/platform_device.h>
@@ -92,18 +93,6 @@ extern const void *of_get_mac_address(struct device_node *np);
  * OF interrupt mapping
  */
 
-/* This structure is returned when an interrupt is mapped. The controller
- * field needs to be put() after use
- */
-
-#define OF_MAX_IRQ_SPEC		4 /* We handle specifiers of at most 4 cells */
-
-struct of_irq {
-	struct device_node *controller; /* Interrupt controller node */
-	u32 size; /* Specifier size */
-	u32 specifier[OF_MAX_IRQ_SPEC]; /* Specifier copy */
-};
-
 /**
  * of_irq_map_init - Initialize the irq remapper
  * @flags:	flags defining workarounds to enable
@@ -139,19 +128,6 @@ extern int of_irq_map_raw(struct device_node *parent, const u32 *intspec,
 			struct of_irq *out_irq);
 
 /**
- * of_irq_map_one - Resolve an interrupt for a device
- * @device:	the device whose interrupt is to be resolved
- * @index:	index of the interrupt to resolve
- * @out_irq:	structure of_irq filled by this function
- *
- * This function resolves an interrupt, walking the tree, for a given
- * device-tree node. It's the high level pendant to of_irq_map_raw().
- * It also implements the workarounds for OldWolrd Macs.
- */
-extern int of_irq_map_one(struct device_node *device, int index,
-			struct of_irq *out_irq);
-
-/**
  * of_irq_map_pci - Resolve the interrupt for a PCI device
  * @pdev:	the device whose interrupt is to be resolved
  * @out_irq:	structure of_irq filled by this function
diff --git a/arch/microblaze/kernel/irq.c b/arch/microblaze/kernel/irq.c
index 8f120ac..dd32b09 100644
--- a/arch/microblaze/kernel/irq.c
+++ b/arch/microblaze/kernel/irq.c
@@ -17,20 +17,10 @@
 #include <linux/seq_file.h>
 #include <linux/kernel_stat.h>
 #include <linux/irq.h>
+#include <linux/of_irq.h>
 
 #include <asm/prom.h>
 
-unsigned int irq_of_parse_and_map(struct device_node *dev, int index)
-{
-	struct of_irq oirq;
-
-	if (of_irq_map_one(dev, index, &oirq))
-		return NO_IRQ;
-
-	return oirq.specifier[0];
-}
-EXPORT_SYMBOL_GPL(irq_of_parse_and_map);
-
 static u32 concurrent_irq;
 
 void __irq_entry do_IRQ(struct pt_regs *regs)
@@ -104,7 +94,7 @@ unsigned int irq_create_mapping(struct irq_host *host, irq_hw_number_t hwirq)
 EXPORT_SYMBOL_GPL(irq_create_mapping);
 
 unsigned int irq_create_of_mapping(struct device_node *controller,
-					u32 *intspec, unsigned int intsize)
+				   const u32 *intspec, unsigned int intsize)
 {
 	return intspec[0];
 }
diff --git a/arch/powerpc/include/asm/irq.h b/arch/powerpc/include/asm/irq.h
index e054bae..a3b5124 100644
--- a/arch/powerpc/include/asm/irq.h
+++ b/arch/powerpc/include/asm/irq.h
@@ -304,19 +304,6 @@ extern void irq_free_virt(unsigned int virq, unsigned int count);
 /* -- OF helpers -- */
 
 /**
- * irq_create_of_mapping - Map a hardware interrupt into linux virq space
- * @controller: Device node of the interrupt controller
- * @inspec: Interrupt specifier from the device-tree
- * @intsize: Size of the interrupt specifier from the device-tree
- *
- * This function is identical to irq_create_mapping except that it takes
- * as input informations straight from the device-tree (typically the results
- * of the of_irq_map_*() functions.
- */
-extern unsigned int irq_create_of_mapping(struct device_node *controller,
-					  const u32 *intspec, unsigned int intsize);
-
-/**
  * irq_of_parse_and_map - Parse and Map an interrupt into linux virq space
  * @device: Device node of the device whose interrupt is to be mapped
  * @index: Index of the interrupt to map
diff --git a/arch/powerpc/include/asm/prom.h b/arch/powerpc/include/asm/prom.h
index ddd408a..47d41b6 100644
--- a/arch/powerpc/include/asm/prom.h
+++ b/arch/powerpc/include/asm/prom.h
@@ -18,6 +18,7 @@
  */
 #include <linux/types.h>
 #include <linux/of_fdt.h>
+#include <linux/of_irq.h>
 #include <linux/proc_fs.h>
 #include <linux/platform_device.h>
 #include <asm/irq.h>
@@ -108,18 +109,6 @@ extern const void *of_get_mac_address(struct device_node *np);
  * OF interrupt mapping
  */
 
-/* This structure is returned when an interrupt is mapped. The controller
- * field needs to be put() after use
- */
-
-#define OF_MAX_IRQ_SPEC		 4 /* We handle specifiers of at most 4 cells */
-
-struct of_irq {
-	struct device_node *controller;	/* Interrupt controller node */
-	u32 size;			/* Specifier size */
-	u32 specifier[OF_MAX_IRQ_SPEC];	/* Specifier copy */
-};
-
 /**
  * of_irq_map_init - Initialize the irq remapper
  * @flags:	flags defining workarounds to enable
@@ -154,20 +143,6 @@ extern int of_irq_map_raw(struct device_node *parent, const u32 *intspec,
 			  u32 ointsize, const u32 *addr,
 			  struct of_irq *out_irq);
 
-
-/**
- * of_irq_map_one - Resolve an interrupt for a device
- * @device:	the device whose interrupt is to be resolved
- * @index:     	index of the interrupt to resolve
- * @out_irq:	structure of_irq filled by this function
- *
- * This function resolves an interrupt, walking the tree, for a given
- * device-tree node. It's the high level pendant to of_irq_map_raw().
- * It also implements the workarounds for OldWolrd Macs.
- */
-extern int of_irq_map_one(struct device_node *device, int index,
-			  struct of_irq *out_irq);
-
 /**
  * of_irq_map_pci - Resolve the interrupt for a PCI device
  * @pdev:	the device whose interrupt is to be resolved
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 30817d9..2676ef2 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -53,6 +53,8 @@
 #include <linux/bootmem.h>
 #include <linux/pci.h>
 #include <linux/debugfs.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -813,18 +815,6 @@ unsigned int irq_create_of_mapping(struct device_node *controller,
 }
 EXPORT_SYMBOL_GPL(irq_create_of_mapping);
 
-unsigned int irq_of_parse_and_map(struct device_node *dev, int index)
-{
-	struct of_irq oirq;
-
-	if (of_irq_map_one(dev, index, &oirq))
-		return NO_IRQ;
-
-	return irq_create_of_mapping(oirq.controller, oirq.specifier,
-				     oirq.size);
-}
-EXPORT_SYMBOL_GPL(irq_of_parse_and_map);
-
 void irq_dispose_mapping(unsigned int virq)
 {
 	struct irq_host *host;
diff --git a/arch/sparc/include/asm/prom.h b/arch/sparc/include/asm/prom.h
index f845828..ac69574 100644
--- a/arch/sparc/include/asm/prom.h
+++ b/arch/sparc/include/asm/prom.h
@@ -56,7 +56,6 @@ extern void of_fill_in_cpu_data(void);
  * register them in the of_device objects, whereas powerpc computes them
  * on request.
  */
-extern unsigned int irq_of_parse_and_map(struct device_node *node, int index);
 static inline void irq_dispose_mapping(unsigned int virq)
 {
 }
diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index 7cecc8f..b87495e 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -6,6 +6,10 @@ config OF_DYNAMIC
 	def_bool y
 	depends on OF && PPC_OF
 
+config OF_IRQ
+	def_bool y
+	depends on OF && !SPARC
+
 config OF_DEVICE
 	def_bool y
 	depends on OF && (SPARC || PPC_OF || MICROBLAZE)
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index f232cc9..3631a5e 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -1,5 +1,6 @@
 obj-y = base.o
 obj-$(CONFIG_OF_FLATTREE) += fdt.o
+obj-$(CONFIG_OF_IRQ)    += irq.o
 obj-$(CONFIG_OF_DEVICE) += device.o platform.o
 obj-$(CONFIG_OF_GPIO)   += gpio.o
 obj-$(CONFIG_OF_I2C)	+= of_i2c.o
diff --git a/drivers/of/irq.c b/drivers/of/irq.c
new file mode 100644
index 0000000..56ad1aa
--- /dev/null
+++ b/drivers/of/irq.c
@@ -0,0 +1,37 @@
+/*
+ *  Derived from arch/i386/kernel/irq.c
+ *    Copyright (C) 1992 Linus Torvalds
+ *  Adapted from arch/i386 by Gary Thomas
+ *    Copyright (C) 1995-1996 Gary Thomas (gdt@linuxppc.org)
+ *  Updated and modified by Cort Dougan <cort@fsmlabs.com>
+ *    Copyright (C) 1996-2001 Cort Dougan
+ *  Adapted for Power Macintosh by Paul Mackerras
+ *    Copyright (C) 1996 Paul Mackerras (paulus@cs.anu.edu.au)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ * This file contains the code used to make IRQ descriptions in the
+ * device tree to actual irq numbers on an interrupt controller
+ * driver.
+ */
+
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/string.h>
+
+unsigned int irq_of_parse_and_map(struct device_node *dev, int index)
+{
+	struct of_irq oirq;
+
+	if (of_irq_map_one(dev, index, &oirq))
+		return NO_IRQ;
+
+	return irq_create_of_mapping(oirq.controller, oirq.specifier,
+				     oirq.size);
+}
+EXPORT_SYMBOL_GPL(irq_of_parse_and_map);
diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index 42a6715..1fce00e 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -15,6 +15,7 @@
 #include <linux/err.h>
 #include <linux/phy.h>
 #include <linux/of.h>
+#include <linux/of_irq.h>
 #include <linux/of_mdio.h>
 #include <linux/module.h>
 
diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
new file mode 100644
index 0000000..0e37c05
--- /dev/null
+++ b/include/linux/of_irq.h
@@ -0,0 +1,41 @@
+#ifndef __OF_IRQ_H
+#define __OF_IRQ_H
+
+#if defined(CONFIG_OF)
+struct of_irq;
+#include <linux/types.h>
+#include <linux/of.h>
+
+/*
+ * irq_of_parse_and_map() is used ba all OF enabled platforms; but SPARC
+ * implements it differently.  However, the prototype is the same for all,
+ * so declare it here regardless of the CONFIG_OF_IRQ setting.
+ */
+extern unsigned int irq_of_parse_and_map(struct device_node *node, int index);
+
+#if defined(CONFIG_OF_IRQ)
+/**
+ * of_irq - container for device_node/irq_specifier pair for an irq controller
+ * @controller: pointer to interrupt controller device tree node
+ * @size: size of interrupt specifier
+ * @specifier: array of cells @size long specifing the specific interrupt
+ *
+ * This structure is returned when an interrupt is mapped. The controller
+ * field needs to be put() after use
+ */
+#define OF_MAX_IRQ_SPEC		4 /* We handle specifiers of at most 4 cells */
+struct of_irq {
+	struct device_node *controller; /* Interrupt controller node */
+	u32 size; /* Specifier size */
+	u32 specifier[OF_MAX_IRQ_SPEC]; /* Specifier copy */
+};
+
+extern int of_irq_map_one(struct device_node *device, int index,
+			  struct of_irq *out_irq);
+extern unsigned int irq_create_of_mapping(struct device_node *controller,
+					  const u32 *intspec,
+					  unsigned int intsize);
+
+#endif /* CONFIG_OF_IRQ */
+#endif /* CONFIG_OF */
+#endif /* __OF_IRQ_H */

