Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab0LBQSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 11:18:07 -0500
Received: from www.tglx.de ([62.245.132.106]:56494 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756829Ab0LBQSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 11:18:05 -0500
Date: Thu, 2 Dec 2010 17:17:44 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 07/11] x86/dtb: add support for PCI devices backed by dtb nodes
Message-ID: <20101202161744.GA11797@www.tglx.de>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de> <1290706801-7323-8-git-send-email-bigeasy@linutronix.de> <1290897231.32570.168.camel@pasglop> <20101128140436.GB30784@www.tglx.de> <1290983526.32570.187.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1290983526.32570.187.camel@pasglop>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Benjamin Herrenschmidt | 2010-11-29 09:32:06 [+1100]:

>Hehe yeah :-) It's actually not a simple problem. For example, we can't
>just move the powerpc variant over to generic code as-is bcs ... we have
>2 completely different ways of doing it between ppc32 and ppc64 for
>historical reasons :-) They also have different "features". This is
>something I need to reconcile at some stage.
>
>For example our ppc32 variant support bus renumbering (ie, Linux
>assigning different bus numbers than what the DT encodes) while our
>ppc64 doesn't, but our ppc64 variant has additional "stuff" to deal with
>hotplug for example etc...

With this patch I can get rid of my custom of_irq_map_pci() in x86 tree.
The remaining thing would be the inferior pci_device <=> of_node match
code.
This is only x86 tested.

>From 8c7eeae45f28ea6737a8f5c5c32026a02432d5cc Mon Sep 17 00:00:00 2001
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Wed, 1 Dec 2010 21:55:12 +0100
Subject: [PATCH] of: move of_irq_map_pci() into generic code

There is a tiny difference between PPC32 and PPC64. Microblaze uses the
PPC32 variant.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/microblaze/include/asm/prom.h  |   15 -----
 arch/microblaze/kernel/prom_parse.c |   77 ---------------------------
 arch/microblaze/pci/pci-common.c    |    1 +
 arch/powerpc/include/asm/prom.h     |   15 -----
 arch/powerpc/kernel/pci-common.c    |    1 +
 arch/powerpc/kernel/prom_parse.c    |   84 ------------------------------
 drivers/of/Makefile                 |    1 +
 drivers/of/of_pci.c                 |   97 +++++++++++++++++++++++++++++++++++
 include/linux/of_pci.h              |   24 +++++++++
 9 files changed, 124 insertions(+), 191 deletions(-)
 create mode 100644 drivers/of/of_pci.c
 create mode 100644 include/linux/of_pci.h

diff --git a/arch/microblaze/include/asm/prom.h b/arch/microblaze/include/asm/prom.h
index bdc3831..aa3ab12 100644
--- a/arch/microblaze/include/asm/prom.h
+++ b/arch/microblaze/include/asm/prom.h
@@ -67,21 +67,6 @@ struct device_node *of_get_cpu_node(int cpu, unsigned int *thread);
 /* Get the MAC address */
 extern const void *of_get_mac_address(struct device_node *np);
 
-/**
- * of_irq_map_pci - Resolve the interrupt for a PCI device
- * @pdev:	the device whose interrupt is to be resolved
- * @out_irq:	structure of_irq filled by this function
- *
- * This function resolves the PCI interrupt for a given PCI device. If a
- * device-node exists for a given pci_dev, it will use normal OF tree
- * walking. If not, it will implement standard swizzling and walk up the
- * PCI tree until an device-node is found, at which point it will finish
- * resolving using the OF tree walking.
- */
-struct pci_dev;
-struct of_irq;
-extern int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq);
-
 #endif /* __ASSEMBLY__ */
 #endif /* __KERNEL__ */
 
diff --git a/arch/microblaze/kernel/prom_parse.c b/arch/microblaze/kernel/prom_parse.c
index 99d9b61..306f41d 100644
--- a/arch/microblaze/kernel/prom_parse.c
+++ b/arch/microblaze/kernel/prom_parse.c
@@ -2,88 +2,11 @@
 
 #include <linux/kernel.h>
 #include <linux/string.h>
-#include <linux/pci_regs.h>
 #include <linux/module.h>
 #include <linux/ioport.h>
 #include <linux/etherdevice.h>
 #include <linux/of_address.h>
 #include <asm/prom.h>
-#include <asm/pci-bridge.h>
-
-#ifdef CONFIG_PCI
-int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq)
-{
-	struct device_node *dn, *ppnode;
-	struct pci_dev *ppdev;
-	u32 lspec;
-	u32 laddr[3];
-	u8 pin;
-	int rc;
-
-	/* Check if we have a device node, if yes, fallback to standard OF
-	 * parsing
-	 */
-	dn = pci_device_to_OF_node(pdev);
-	if (dn)
-		return of_irq_map_one(dn, 0, out_irq);
-
-	/* Ok, we don't, time to have fun. Let's start by building up an
-	 * interrupt spec.  we assume #interrupt-cells is 1, which is standard
-	 * for PCI. If you do different, then don't use that routine.
-	 */
-	rc = pci_read_config_byte(pdev, PCI_INTERRUPT_PIN, &pin);
-	if (rc != 0)
-		return rc;
-	/* No pin, exit */
-	if (pin == 0)
-		return -ENODEV;
-
-	/* Now we walk up the PCI tree */
-	lspec = pin;
-	for (;;) {
-		/* Get the pci_dev of our parent */
-		ppdev = pdev->bus->self;
-
-		/* Ouch, it's a host bridge... */
-		if (ppdev == NULL) {
-			struct pci_controller *host;
-			host = pci_bus_to_host(pdev->bus);
-			ppnode = host ? host->dn : NULL;
-			/* No node for host bridge ? give up */
-			if (ppnode == NULL)
-				return -EINVAL;
-		} else
-			/* We found a P2P bridge, check if it has a node */
-			ppnode = pci_device_to_OF_node(ppdev);
-
-		/* Ok, we have found a parent with a device-node, hand over to
-		 * the OF parsing code.
-		 * We build a unit address from the linux device to be used for
-		 * resolution. Note that we use the linux bus number which may
-		 * not match your firmware bus numbering.
-		 * Fortunately, in most cases, interrupt-map-mask doesn't
-		 * include the bus number as part of the matching.
-		 * You should still be careful about that though if you intend
-		 * to rely on this function (you ship  a firmware that doesn't
-		 * create device nodes for all PCI devices).
-		 */
-		if (ppnode)
-			break;
-
-		/* We can only get here if we hit a P2P bridge with no node,
-		 * let's do standard swizzling and try again
-		 */
-		lspec = pci_swizzle_interrupt_pin(pdev, lspec);
-		pdev = ppdev;
-	}
-
-	laddr[0] = (pdev->bus->number << 16)
-		| (pdev->devfn << 8);
-	laddr[1]  = laddr[2] = 0;
-	return of_irq_map_raw(ppnode, &lspec, 1, laddr, out_irq);
-}
-EXPORT_SYMBOL_GPL(of_irq_map_pci);
-#endif /* CONFIG_PCI */
 
 void of_parse_dma_window(struct device_node *dn, const void *dma_window_prop,
 		unsigned long *busno, unsigned long *phys, unsigned long *size)
diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index e363615..1e01a12 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -29,6 +29,7 @@
 #include <linux/slab.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/of_pci.h>
 
 #include <asm/processor.h>
 #include <asm/io.h>
diff --git a/arch/powerpc/include/asm/prom.h b/arch/powerpc/include/asm/prom.h
index ae26f2e..01c3302 100644
--- a/arch/powerpc/include/asm/prom.h
+++ b/arch/powerpc/include/asm/prom.h
@@ -73,21 +73,6 @@ static inline int of_node_to_nid(struct device_node *device) { return 0; }
 #endif
 #define of_node_to_nid of_node_to_nid
 
-/**
- * of_irq_map_pci - Resolve the interrupt for a PCI device
- * @pdev:	the device whose interrupt is to be resolved
- * @out_irq:	structure of_irq filled by this function
- *
- * This function resolves the PCI interrupt for a given PCI device. If a
- * device-node exists for a given pci_dev, it will use normal OF tree
- * walking. If not, it will implement standard swizzling and walk up the
- * PCI tree until an device-node is found, at which point it will finish
- * resolving using the OF tree walking.
- */
-struct pci_dev;
-struct of_irq;
-extern int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq);
-
 extern void of_instantiate_rtc(void);
 
 /* These includes are put at the bottom because they may contain things
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index 10a44e6..eb341be 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/bootmem.h>
 #include <linux/of_address.h>
+#include <linux/of_pci.h>
 #include <linux/mm.h>
 #include <linux/list.h>
 #include <linux/syscalls.h>
diff --git a/arch/powerpc/kernel/prom_parse.c b/arch/powerpc/kernel/prom_parse.c
index 88334af..306f41d 100644
--- a/arch/powerpc/kernel/prom_parse.c
+++ b/arch/powerpc/kernel/prom_parse.c
@@ -2,95 +2,11 @@
 
 #include <linux/kernel.h>
 #include <linux/string.h>
-#include <linux/pci_regs.h>
 #include <linux/module.h>
 #include <linux/ioport.h>
 #include <linux/etherdevice.h>
 #include <linux/of_address.h>
 #include <asm/prom.h>
-#include <asm/pci-bridge.h>
-
-#ifdef CONFIG_PCI
-int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq)
-{
-	struct device_node *dn, *ppnode;
-	struct pci_dev *ppdev;
-	u32 lspec;
-	u32 laddr[3];
-	u8 pin;
-	int rc;
-
-	/* Check if we have a device node, if yes, fallback to standard OF
-	 * parsing
-	 */
-	dn = pci_device_to_OF_node(pdev);
-	if (dn) {
-		rc = of_irq_map_one(dn, 0, out_irq);
-		if (!rc)
-			return rc;
-	}
-
-	/* Ok, we don't, time to have fun. Let's start by building up an
-	 * interrupt spec.  we assume #interrupt-cells is 1, which is standard
-	 * for PCI. If you do different, then don't use that routine.
-	 */
-	rc = pci_read_config_byte(pdev, PCI_INTERRUPT_PIN, &pin);
-	if (rc != 0)
-		return rc;
-	/* No pin, exit */
-	if (pin == 0)
-		return -ENODEV;
-
-	/* Now we walk up the PCI tree */
-	lspec = pin;
-	for (;;) {
-		/* Get the pci_dev of our parent */
-		ppdev = pdev->bus->self;
-
-		/* Ouch, it's a host bridge... */
-		if (ppdev == NULL) {
-#ifdef CONFIG_PPC64
-			ppnode = pci_bus_to_OF_node(pdev->bus);
-#else
-			struct pci_controller *host;
-			host = pci_bus_to_host(pdev->bus);
-			ppnode = host ? host->dn : NULL;
-#endif
-			/* No node for host bridge ? give up */
-			if (ppnode == NULL)
-				return -EINVAL;
-		} else
-			/* We found a P2P bridge, check if it has a node */
-			ppnode = pci_device_to_OF_node(ppdev);
-
-		/* Ok, we have found a parent with a device-node, hand over to
-		 * the OF parsing code.
-		 * We build a unit address from the linux device to be used for
-		 * resolution. Note that we use the linux bus number which may
-		 * not match your firmware bus numbering.
-		 * Fortunately, in most cases, interrupt-map-mask doesn't include
-		 * the bus number as part of the matching.
-		 * You should still be careful about that though if you intend
-		 * to rely on this function (you ship  a firmware that doesn't
-		 * create device nodes for all PCI devices).
-		 */
-		if (ppnode)
-			break;
-
-		/* We can only get here if we hit a P2P bridge with no node,
-		 * let's do standard swizzling and try again
-		 */
-		lspec = pci_swizzle_interrupt_pin(pdev, lspec);
-		pdev = ppdev;
-	}
-
-	laddr[0] = (pdev->bus->number << 16)
-		| (pdev->devfn << 8);
-	laddr[1]  = laddr[2] = 0;
-	return of_irq_map_raw(ppnode, &lspec, 1, laddr, out_irq);
-}
-EXPORT_SYMBOL_GPL(of_irq_map_pci);
-#endif /* CONFIG_PCI */
 
 void of_parse_dma_window(struct device_node *dn, const void *dma_window_prop,
 		unsigned long *busno, unsigned long *phys, unsigned long *size)
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index 7888155..4dcb177 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_OF_GPIO)   += gpio.o
 obj-$(CONFIG_OF_I2C)	+= of_i2c.o
 obj-$(CONFIG_OF_SPI)	+= of_spi.o
 obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
+obj-$(CONFIG_PCI)	+= of_pci.o
diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
new file mode 100644
index 0000000..136fef8
--- /dev/null
+++ b/drivers/of/of_pci.c
@@ -0,0 +1,97 @@
+#include <linux/kernel.h>
+#include <linux/pci_regs.h>
+#include <asm/prom.h>
+
+#if defined(CONFIG_PPC64) || defined(CONFIG_X86)
+static struct device_node *pci_get_parent_node(struct pci_dev *pdev)
+{
+	return pci_bus_to_OF_node(pdev->bus);
+}
+#endif
+
+#if defined(CONFIG_PPC32) || defined(CONFIG_MICROBLAZE)
+static struct device_node *pci_get_parent_node(struct pci_dev *pdev)
+{
+	struct pci_controller *host;
+
+	host = pci_bus_to_host(pdev->bus);
+	ppnode = host ? host->dn : NULL;
+}
+#endif
+
+int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq)
+{
+	struct device_node *dn, *ppnode;
+	struct pci_dev *ppdev;
+	u32 lspec;
+	__be32 lspec_be;
+	__be32 laddr[3];
+	u8 pin;
+	int rc;
+
+	/* Check if we have a device node, if yes, fallback to standard OF
+	 * parsing
+	 */
+	dn = pci_device_to_OF_node(pdev);
+	if (dn) {
+		rc = of_irq_map_one(dn, 0, out_irq);
+		if (!rc)
+			return rc;
+	}
+
+	/* Ok, we don't, time to have fun. Let's start by building up an
+	 * interrupt spec.  we assume #interrupt-cells is 1, which is standard
+	 * for PCI. If you do different, then don't use that routine.
+	 */
+	rc = pci_read_config_byte(pdev, PCI_INTERRUPT_PIN, &pin);
+	if (rc != 0)
+		return rc;
+	/* No pin, exit */
+	if (pin == 0)
+		return -ENODEV;
+
+	/* Now we walk up the PCI tree */
+	lspec = pin;
+	for (;;) {
+		/* Get the pci_dev of our parent */
+		ppdev = pdev->bus->self;
+
+		/* Ouch, it's a host bridge... */
+		if (ppdev == NULL) {
+			ppnode = pci_get_parent_node(pdev);
+
+			/* No node for host bridge ? give up */
+			if (ppnode == NULL)
+				return -EINVAL;
+		} else {
+			/* We found a P2P bridge, check if it has a node */
+			ppnode = pci_device_to_OF_node(ppdev);
+		}
+
+		/* Ok, we have found a parent with a device-node, hand over to
+		 * the OF parsing code.
+		 * We build a unit address from the linux device to be used for
+		 * resolution. Note that we use the linux bus number which may
+		 * not match your firmware bus numbering.
+		 * Fortunately, in most cases, interrupt-map-mask doesn't include
+		 * the bus number as part of the matching.
+		 * You should still be careful about that though if you intend
+		 * to rely on this function (you ship  a firmware that doesn't
+		 * create device nodes for all PCI devices).
+		 */
+		if (ppnode)
+			break;
+
+		/* We can only get here if we hit a P2P bridge with no node,
+		 * let's do standard swizzling and try again
+		 */
+		lspec = pci_swizzle_interrupt_pin(pdev, lspec);
+		pdev = ppdev;
+	}
+
+	lspec_be = cpu_to_be32(lspec);
+	laddr[0] = cpu_to_be32((pdev->bus->number << 16) | (pdev->devfn << 8));
+	laddr[1]  = laddr[2] = cpu_to_be32(0);
+	return of_irq_map_raw(ppnode, &lspec_be, 1, laddr, out_irq);
+}
+EXPORT_SYMBOL_GPL(of_irq_map_pci);
diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
new file mode 100644
index 0000000..36b3cfa
--- /dev/null
+++ b/include/linux/of_pci.h
@@ -0,0 +1,24 @@
+#ifndef __OF_PCI_H
+#define __OF_PCI_H
+
+#include <linux/pci.h>
+
+#ifdef CONFIG_PPC_OF
+#include <asm/pci-bridge.h>
+#endif
+
+/**
+ * of_irq_map_pci - Resolve the interrupt for a PCI device
+ * @pdev:       the device whose interrupt is to be resolved
+ * @out_irq:    structure of_irq filled by this function
+ *
+ * This function resolves the PCI interrupt for a given PCI device. If a
+ * device-node exists for a given pci_dev, it will use normal OF tree
+ * walking. If not, it will implement standard swizzling and walk up the
+ * PCI tree until an device-node is found, at which point it will finish
+ * resolving using the OF tree walking.
+ */
+struct pci_dev;
+struct of_irq;
+int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq);
+#endif
-- 
1.7.3.2

Sebastian
