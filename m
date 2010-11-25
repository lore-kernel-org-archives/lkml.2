Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab0KYRnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 12:43:32 -0500
Received: from www.tglx.de ([62.245.132.106]:50891 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754416Ab0KYRn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 12:43:28 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: sodaville@linutronix.de, x86@kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 07/11] x86/dtb: add support for PCI devices backed by dtb nodes
Date: Thu, 25 Nov 2010 18:39:57 +0100
Message-Id: <1290706801-7323-8-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
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

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: x86@kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
Tested-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 arch/x86/include/asm/prom.h |    1 +
 arch/x86/kernel/prom.c      |  110 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 111 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
index b74a49f..794c6a1 100644
--- a/arch/x86/include/asm/prom.h
+++ b/arch/x86/include/asm/prom.h
@@ -28,6 +28,7 @@ extern void init_dtb(void);
 extern void add_dtb(u64 data);
 void x86_early_of_parse(void);
 void add_interrupt_host(struct irq_host *ih);
+void __cpuinit x86_of_pci_init(void);
 #else
 static inline void init_dtb(void) { }
 static inline void add_dtb(u64 data) { }
diff --git a/arch/x86/kernel/prom.c b/arch/x86/kernel/prom.c
index f61c541..c02777d 100644
--- a/arch/x86/kernel/prom.c
+++ b/arch/x86/kernel/prom.c
@@ -8,10 +8,12 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/slab.h>
+#include <linux/pci.h>
 
 #include <asm/hpet.h>
 #include <asm/irq_controller.h>
 #include <asm/io_apic.h>
+#include <asm/pci_x86.h>
 
 char __initdata cmd_line[COMMAND_LINE_SIZE];
 static LIST_HEAD(irq_hosts);
@@ -100,6 +102,114 @@ void __init add_dtb(u64 data)
 				offsetof(struct setup_data, data));
 }
 
+static int of_irq_map_pci(struct pci_dev *dev, struct of_irq *oirq)
+{
+	struct device_node *node;
+	__be32 laddr[3];
+	__be32 lspec[2];
+	int ret;
+	u8 pin;
+
+	node = dev->dev.of_node;
+	if (!node) {
+		node = dev->bus->dev.of_node;
+		if (node) {
+			ret = of_irq_map_one(node, 0, oirq);
+			if (!ret)
+				return ret;
+		}
+	}
+
+	ret = pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
+	if (ret)
+		return ret;
+	if (!pin)
+		return -EINVAL;
+
+	laddr[0] = cpu_to_be32((dev->bus->number << 16) | (dev->devfn << 8));
+	laddr[1] = 0;
+	laddr[2] = 0;
+
+	lspec[0] = cpu_to_be32(pin);
+	lspec[1] = cpu_to_be32(0);
+	ret = of_irq_map_raw(node, lspec, 1, laddr, oirq);
+	if (ret)
+		return ret;
+	return 0;
+}
+
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
+	if (virq == NO_IRQ)
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
+		bus->dev.of_node = np;
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
+		}
+	}
+}
+
 static int __init early_scan_hpet(unsigned long node, const char *uname,
 				   int depth, void *data)
 {
-- 
1.7.3.2

