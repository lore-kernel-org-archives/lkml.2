Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab0KYRnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 12:43:33 -0500
Received: from www.tglx.de ([62.245.132.106]:50892 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422Ab0KYRn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 12:43:28 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: sodaville@linutronix.de, x86@kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        devicetree-discuss@lists.ozlabs.org,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 09/11] x86/ioapic: Add OF bindings for IO-APIC
Date: Thu, 25 Nov 2010 18:39:59 +0100
Message-Id: <1290706801-7323-10-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioapic_xlate provides a translation from the information in device tree
to ioapic related informations. This includes
- obtaining hw irq which is the vector number "=> pin number + gsi"
- obtaining type (level/edge/..)
- programming this information into ioapic

ioapic_add_ofnode adds an irq_host based on informations from the device
tree. The memory address is obtained from the phys_reg property instead
of reg. On the PCI bus we use reg property for the PCI address. We can't
use the PCI functions because we need the ioapic before the PCI bus is
up. This information (irq_host) is required  in order to map a device to
its proper interrupt controller.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: x86@kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 arch/x86/include/asm/io_apic.h |    7 +++
 arch/x86/kernel/apic/io_apic.c |  100 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/prom.c         |    8 +++
 3 files changed, 115 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index d854b90..dc1169f 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -175,6 +175,13 @@ struct mp_ioapic_gsi{
 	u32 gsi_base;
 	u32 gsi_end;
 };
+#ifdef CONFIG_X86_OF
+struct mp_of_ioapic {
+	struct device_node *node;
+};
+extern struct mp_of_ioapic mp_of_ioapic[MAX_IO_APICS];
+void __init ioapic_add_ofnode(struct device_node *np);
+#endif
 extern struct mp_ioapic_gsi  mp_gsi_routing[];
 extern u32 gsi_top;
 int mp_find_ioapic(u32 gsi);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ea51151..27a5709 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -43,6 +43,7 @@
 #include <linux/bootmem.h>
 #include <linux/dmar.h>
 #include <linux/hpet.h>
+#include <linux/of_address.h>
 
 #include <asm/idle.h>
 #include <asm/io.h>
@@ -60,6 +61,7 @@
 #include <asm/irq_remapping.h>
 #include <asm/hpet.h>
 #include <asm/hw_irq.h>
+#include <asm/irq_controller.h>
 
 #include <asm/apic.h>
 
@@ -88,6 +90,10 @@ int nr_ioapics;
 /* IO APIC gsi routing info */
 struct mp_ioapic_gsi  mp_gsi_routing[MAX_IO_APICS];
 
+#ifdef CONFIG_X86_OF
+/* OF -> IO APIC lookup */
+struct mp_of_ioapic mp_of_ioapic[MAX_IO_APICS];
+#endif
 /* The one past the highest gsi number used */
 u32 gsi_top;
 
@@ -4052,6 +4058,100 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	nr_ioapics++;
 }
 
+#ifdef CONFIG_X86_OF
+static int ioapic_xlate(struct irq_host *h, const u32 *intspec, u32 intsize,
+		u32 *out_hwirq, u32 *out_type)
+{
+	u32 line;
+	u32 idx;
+	u32 type;
+	u32 trigger;
+	u32 polarity;
+	struct irq_cfg *cfg;
+	struct irq_desc *desc;
+
+	if (intsize < 1)
+		return -EINVAL;
+
+	line = *intspec;
+	idx = (u32) h->priv;
+	*out_hwirq = line + mp_gsi_routing[idx].gsi_base;
+	if (intsize > 1) {
+		intspec++;
+		type = *intspec;
+		switch (type) {
+		case 0:
+			*out_type = IRQ_TYPE_EDGE_RISING;
+			trigger = IOAPIC_EDGE;
+			polarity = 1;
+			break;
+		case 1:
+			*out_type = IRQ_TYPE_LEVEL_LOW;
+			trigger = IOAPIC_LEVEL;
+			polarity = 0;
+			break;
+		case 2:
+			*out_type = IRQ_TYPE_LEVEL_HIGH;
+			trigger = IOAPIC_LEVEL;
+			polarity = 1;
+			break;
+		case 3:
+			*out_type = IRQ_TYPE_EDGE_FALLING;
+			trigger = IOAPIC_EDGE;
+			polarity = 0;
+			break;
+		default:
+			*out_type = IRQ_TYPE_NONE;
+			trigger = IOAPIC_AUTO;
+			polarity = 0;
+			break;
+		};
+	} else {
+		*out_type = IRQ_TYPE_NONE;
+		trigger = IOAPIC_AUTO;
+		polarity = 0;
+	}
+	/* And now tell the IO APIC to make the line ready */
+	desc = irq_to_desc_alloc_node(*out_hwirq, 0);
+	cfg = irq_cfg(*out_hwirq);
+	add_pin_to_irq_node(cfg, 0, idx, line);
+	/* make it edge by default, settype will update it */
+	setup_ioapic_irq(idx, line, *out_hwirq, cfg, trigger, polarity);
+	return 0;
+}
+
+void __init ioapic_add_ofnode(struct device_node *np)
+{
+	int i;
+	const __be32 *prop;
+	u32 addr;
+
+	prop = of_get_property(np, "phys_reg", NULL);
+	if (!prop) {
+		printk(KERN_ERR "IO APIC %s missing phys_reg property.\n",
+				np->full_name);
+		return;
+	}
+	addr = be32_to_cpup(prop);
+
+	for (i = 0; i < nr_ioapics; i++) {
+		if (addr == mp_ioapics[i].apicaddr) {
+			struct irq_host *ih;
+
+			mp_of_ioapic[i].node = np;
+			ih = kzalloc(sizeof(*ih), GFP_KERNEL);
+			BUG_ON(!ih);
+			ih->controller = np;
+			ih->xlate = ioapic_xlate;
+			ih->priv = (void *)i;
+			add_interrupt_host(ih);
+			return;
+		}
+	}
+	printk(KERN_ERR "IO APIC at 0x%08x is not registered.\n", addr);
+}
+#endif
+
 /* Enable IOAPIC early just for system timer */
 void __init pre_init_apic_IRQ0(void)
 {
diff --git a/arch/x86/kernel/prom.c b/arch/x86/kernel/prom.c
index bbd6064..e9ff517 100644
--- a/arch/x86/kernel/prom.c
+++ b/arch/x86/kernel/prom.c
@@ -9,9 +9,11 @@
 #include <linux/of_platform.h>
 #include <linux/slab.h>
 #include <linux/pci.h>
+#include <linux/of_fdt.h>
 
 #include <asm/hpet.h>
 #include <asm/irq_controller.h>
+#include <asm/apic.h>
 #include <asm/io_apic.h>
 #include <asm/pci_x86.h>
 
@@ -355,8 +357,14 @@ void __init x86_early_of_parse(void)
 
 void __init init_dtb(void)
 {
+	struct device_node *dp;
+
 	if (!initial_boot_params)
 		return;
 
 	unflatten_device_tree();
+	for_each_node_by_type(dp, "interrupt-controller") {
+		if (of_device_is_compatible(dp, "intel,ioapic"))
+			ioapic_add_ofnode(dp);
+	}
 }
-- 
1.7.3.2

