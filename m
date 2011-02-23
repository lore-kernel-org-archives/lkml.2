Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785Ab1BWVvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 16:51:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:57094 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932729Ab1BWVvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 16:51:51 -0500
Date: Wed, 23 Feb 2011 21:51:33 GMT
From: tip-bot for Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, hpa@zytor.com,
        mingo@redhat.com, dirk.brandewie@gmail.com, bigeasy@linutronix.de,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, dirk.brandewie@gmail.com,
        tglx@linutronix.de, bigeasy@linutronix.de
In-Reply-To: <1298405266-1624-8-git-send-email-bigeasy@linutronix.de>
References: <1298405266-1624-8-git-send-email-bigeasy@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: dtb: Add support for PCI devices backed by dtb nodes
Message-ID: <tip-96e0a0797eba35b5420c710b928f19094b2d5c45@git.kernel.org>
Git-Commit-ID: 96e0a0797eba35b5420c710b928f19094b2d5c45
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Feb 2011 21:51:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  96e0a0797eba35b5420c710b928f19094b2d5c45
Gitweb:     http://git.kernel.org/tip/96e0a0797eba35b5420c710b928f19094b2d5c45
Author:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
AuthorDate: Tue, 22 Feb 2011 21:07:42 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 23 Feb 2011 22:27:53 +0100

x86: dtb: Add support for PCI devices backed by dtb nodes

x86_of_pci_init() does two things:

- it provides a generic irq enable and disable function. enable queries
  the device tree for the interrupt information, calls ->xlate on the
  irq host and updates the pci->irq information for the device.

- it walks through PCI bus(es) in the device tree and adds its children
  (device) nodes to appropriate pci_dev nodes in kernel. So the dtb
  node information is available at probe time of the PCI device.

Adding a PCI bus based on the information in the device tree is
currently not supported. Right now direct access via ioports is used.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Dirk Brandewie <dirk.brandewie@gmail.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Cc: sodaville@linutronix.de
Cc: devicetree-discuss@lists.ozlabs.org
LKML-Reference: <1298405266-1624-8-git-send-email-bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/prom.h  |   14 +++++++
 arch/x86/kernel/devicetree.c |   83 ++++++++++++++++++++++++++++++++++++++++++
 drivers/of/Kconfig           |    2 +-
 drivers/of/of_pci.c          |    1 +
 4 files changed, 99 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
index 35ec32b..8fcd519 100644
--- a/arch/x86/include/asm/prom.h
+++ b/arch/x86/include/asm/prom.h
@@ -16,6 +16,7 @@
 
 #include <linux/of.h>
 #include <linux/types.h>
+#include <linux/pci.h>
 
 #include <asm/irq.h>
 #include <asm/atomic.h>
@@ -29,8 +30,21 @@ extern void add_dtb(u64 data);
 void x86_dtb_find_config(void);
 void x86_dtb_get_config(unsigned int unused);
 void add_interrupt_host(struct irq_domain *ih);
+void __cpuinit x86_of_pci_init(void);
+
+static inline struct device_node *pci_device_to_OF_node(struct pci_dev *pdev)
+{
+	return pdev ? pdev->dev.of_node : NULL;
+}
+
+static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
+{
+	return pci_device_to_OF_node(bus->self);
+}
+
 #else
 static inline void add_dtb(u64 data) { }
+static inline void x86_of_pci_init(void) { }
 #define x86_dtb_find_config x86_init_noop
 #define x86_dtb_get_config x86_init_uint_noop
 #define of_ioapic 0
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index dbb3bda..7b57422 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -9,11 +9,15 @@
 #include <linux/of_fdt.h>
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
+#include <linux/of_irq.h>
 #include <linux/slab.h>
+#include <linux/pci.h>
+#include <linux/of_pci.h>
 
 #include <asm/hpet.h>
 #include <asm/irq_controller.h>
 #include <asm/apic.h>
+#include <asm/pci_x86.h>
 
 __initdata u64 initial_dtb;
 char __initdata cmd_line[COMMAND_LINE_SIZE];
@@ -99,6 +103,85 @@ void __init add_dtb(u64 data)
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
diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index efabbf9..d06a637 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -71,7 +71,7 @@ config OF_MDIO
 
 config OF_PCI
 	def_tristate PCI
-	depends on PCI && (PPC || MICROBLAZE)
+	depends on PCI && (PPC || MICROBLAZE || X86)
 	help
 	  OpenFirmware PCI bus accessors
 
diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
index 314535f..ac1ec54 100644
--- a/drivers/of/of_pci.c
+++ b/drivers/of/of_pci.c
@@ -1,5 +1,6 @@
 #include <linux/kernel.h>
 #include <linux/of_pci.h>
+#include <linux/of_irq.h>
 #include <asm/prom.h>
 
 /**
