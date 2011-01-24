Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab1AXE3n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 23:29:43 -0500
Received: from www.tglx.de ([62.245.132.106]:55669 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519Ab1AXE3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 23:29:42 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH TIP 08/14] x86/dtb: add support for PCI devices backed by dtb nodes
Date: Mon, 24 Jan 2011 09:58:56 +0530
Message-Id: <1295843342-1122-9-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_of_pci_init() does two things:
- it provides a generic irq enable and disable function. enable queries
  the device tree for the interrupt information, calls ->xlate on the
  irq host and updates the pci->irq information for the device.

- it walks through PCI buss(es) in the device tree and adds its children
  (devices) nodes to appropriate pci_dev nodes in kernel. So the dtb
  node information is available at probe time of the PCI device.

Adding a PCI bus based on the information in the device tree is
currently not supported. Right now direct access via ioports is used.

Cc: devicetree-discuss@lists.ozlabs.org
Tested-by: Dirk Brandewie <dirk.brandewie@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/include/asm/prom.h |   17 +++++++++
 arch/x86/kernel/prom.c      |   82 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
index bd67ab2..3ed0bd6 100644
--- a/arch/x86/include/asm/prom.h
+++ b/arch/x86/include/asm/prom.h
@@ -16,6 +16,7 @@
 
 #include <linux/of.h>
 #include <linux/types.h>
+#include <linux/pci.h>
 #include <asm/irq.h>
 #include <asm/atomic.h>
 #include <asm/setup.h>
@@ -28,8 +29,24 @@ extern void add_dtb(u64 data);
 void x86_dtb_find_config(void);
 void x86_dtb_get_config(unsigned int unused);
 void add_interrupt_host(struct irq_domain *ih);
+void __cpuinit x86_of_pci_init(void);
+
+static inline struct device_node *pci_device_to_OF_node(struct pci_dev *pdev)
+{
+	return pdev->dev.of_node;
+}
+
+static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
+{
+	if (bus->self)
+		return pci_device_to_OF_node(bus->self);
+	else
+		return NULL;
+}
+
 #else
 static inline void add_dtb(u64 data) { }
+static inline void x86_of_pci_init(void) { }
 #define x86_dtb_find_config x86_init_noop
 #define x86_dtb_get_config x86_init_uint_noop
 #define of_ioapic 0
diff --git a/arch/x86/kernel/prom.c b/arch/x86/kernel/prom.c
index 16c124e..8525ca0 100644
--- a/arch/x86/kernel/prom.c
+++ b/arch/x86/kernel/prom.c
@@ -9,10 +9,13 @@
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <linux/slab.h>
+#include <linux/pci.h>
+#include <linux/of_pci.h>
 
 #include <asm/hpet.h>
 #include <asm/irq_controller.h>
 #include <asm/io_apic.h>
+#include <asm/pci_x86.h>
 
 __initdata u64 initial_dtb;
 char __initdata cmd_line[COMMAND_LINE_SIZE];
@@ -99,6 +102,85 @@ void __init add_dtb(u64 data)
 	initial_dtb = data + offsetof(struct setup_data, data);
 }
 
+#ifdef CONFIG_PCI
+static int x86_of_pci_irq_enable(struct pci_dev *dev)
+{
+	struct of_irq oirq;
+	u32 virq;
+	int ret;
+	u8 pin;
+
+	ret = pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
+	if (ret)
+		return ret;
+	if (!pin)
+		return 0;
+
+	ret = of_irq_map_pci(dev, &oirq);
+	if (ret)
+		return ret;
+
+	virq = irq_create_of_mapping(oirq.controller, oirq.specifier,
+			oirq.size);
+	if (virq == 0)
+		return -EINVAL;
+	dev->irq = virq;
+	return 0;
+}
+
+static void x86_of_pci_irq_disable(struct pci_dev *dev)
+{
+}
+
+void __cpuinit x86_of_pci_init(void)
+{
+	struct device_node *np;
+
+	pcibios_enable_irq = x86_of_pci_irq_enable;
+	pcibios_disable_irq = x86_of_pci_irq_disable;
+
+	for_each_node_by_type(np, "pci") {
+		const void *prop;
+		struct pci_bus *bus;
+		unsigned int bus_min;
+		struct device_node *child;
+
+		prop = of_get_property(np, "bus-range", NULL);
+		if (!prop)
+			continue;
+		bus_min = be32_to_cpup(prop);
+
+		bus = pci_find_bus(0, bus_min);
+		if (!bus) {
+			printk(KERN_ERR "Can't find a node for bus %s.\n",
+					np->full_name);
+			continue;
+		}
+
+		if (bus->self)
+			bus->self->dev.of_node = np;
+		else
+			bus->dev.of_node = np;
+
+		for_each_child_of_node(np, child) {
+			struct pci_dev *dev;
+			u32 devfn;
+
+			prop = of_get_property(child, "reg", NULL);
+			if (!prop)
+				continue;
+
+			devfn = (be32_to_cpup(prop) >> 8) & 0xff;
+			dev = pci_get_slot(bus, devfn);
+			if (!dev)
+				continue;
+			dev->dev.of_node = child;
+			pci_dev_put(dev);
+		}
+	}
+}
+#endif
+
 static void __init dtb_setup_hpet(void)
 {
 	struct device_node *dn;
-- 
1.7.3.2

