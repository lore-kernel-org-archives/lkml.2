Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab1BVUIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:08:24 -0500
Received: from www.tglx.de ([62.245.132.106]:38522 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755503Ab1BVUIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:08:21 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: sodaville@linutronix.de, devicetree-discuss@lists.ozlabs.org,
        x86@kernel.org, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 05/11] x86/dtb: add early parsing of IO APIC
Date: Tue, 22 Feb 2011 21:07:40 +0100
Message-Id: <1298405266-1624-6-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298405266-1624-1-git-send-email-bigeasy@linutronix.de>
References: <1298405266-1624-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The apic & ioapic have to be added to system early because
native_init_IRQ() requires it. In order to obtain the address of the
ioapic the device tree has to be unflattened because
of_address_to_resource() has to work.
The device tree is relocated to ensure it is always covered by the
kernel and the boot loader does not have to make assumptions about
kernel's memory layout.

Cc: devicetree-discuss@lists.ozlabs.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/include/asm/prom.h  |    7 +++
 arch/x86/kernel/devicetree.c |  111 +++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/irqinit.c    |    3 +-
 3 files changed, 118 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
index 70467d1..5aa2c32 100644
--- a/arch/x86/include/asm/prom.h
+++ b/arch/x86/include/asm/prom.h
@@ -22,10 +22,17 @@
 #include <asm/irq_controller.h>
 
 #ifdef CONFIG_OF
+extern int of_ioapic;
+extern u64 initial_dtb;
 extern void add_dtb(u64 data);
+void x86_dtb_find_config(void);
+void x86_dtb_get_config(unsigned int unused);
 void add_interrupt_host(struct irq_domain *ih);
 #else
 static inline void add_dtb(u64 data) { }
+#define x86_dtb_find_config x86_init_noop
+#define x86_dtb_get_config x86_init_uint_noop
+#define of_ioapic 0
 #endif
 
 extern char cmd_line[COMMAND_LINE_SIZE];
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index f2f159c..72cc3e2 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -7,15 +7,20 @@
 #include <linux/list.h>
 #include <linux/of.h>
 #include <linux/of_fdt.h>
+#include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <linux/slab.h>
 
 #include <asm/irq_controller.h>
+#include <asm/apic.h>
 
+__initdata u64 initial_dtb;
 char __initdata cmd_line[COMMAND_LINE_SIZE];
 static LIST_HEAD(irq_domains);
 static DEFINE_RAW_SPINLOCK(big_irq_lock);
 
+int __initdata of_ioapic;
+
 void add_interrupt_host(struct irq_domain *ih)
 {
 	unsigned long flags;
@@ -91,6 +96,108 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 
 void __init add_dtb(u64 data)
 {
-	initial_boot_params = phys_to_virt((u64) (u32) data +
-				offsetof(struct setup_data, data));
+	initial_dtb = data + offsetof(struct setup_data, data);
+}
+
+static void __init dtb_lapic_setup(void)
+{
+#ifdef CONFIG_X86_LOCAL_APIC
+	if (apic_force_enable())
+		return;
+
+	smp_found_config = 1;
+	pic_mode = 1;
+	/* Required for ioapic registration */
+	set_fixmap_nocache(FIX_APIC_BASE, mp_lapic_addr);
+	if (boot_cpu_physical_apicid == -1U)
+		boot_cpu_physical_apicid = read_apic_id();
+
+	generic_processor_info(boot_cpu_physical_apicid,
+			GET_APIC_VERSION(apic_read(APIC_LVR)));
+#endif
+}
+
+#ifdef CONFIG_X86_IO_APIC
+static unsigned int ioapic_id;
+
+static void __init dtb_add_ioapic(struct device_node *dn)
+{
+	struct resource r;
+	int ret;
+
+	ret = of_address_to_resource(dn, 0, &r);
+	if (ret) {
+		printk(KERN_ERR "Can't obtain address from node %s.\n",
+				dn->full_name);
+		return;
+	}
+	mp_register_ioapic(++ioapic_id, r.start, gsi_top);
+}
+
+static void __init dtb_ioapic_setup(void)
+{
+	struct device_node *dn;
+
+	if (!smp_found_config)
+		return;
+
+	for_each_compatible_node(dn, NULL, "intel,ce4100-ioapic")
+		dtb_add_ioapic(dn);
+
+	if (nr_ioapics) {
+		of_ioapic = 1;
+		return;
+	}
+	printk(KERN_ERR "Error: No information about IO-APIC in OF.\n");
+	smp_found_config = 0;
+}
+#else
+static void __init dtb_ioapic_setup(void) {}
+#endif
+
+static void __init dtb_apic_setup(void)
+{
+	dtb_lapic_setup();
+	dtb_ioapic_setup();
+}
+
+void __init x86_dtb_find_config(void)
+{
+	if (initial_dtb)
+		smp_found_config = 1;
+	else
+		printk(KERN_ERR "Missing device tree!.\n");
+}
+
+void __init x86_dtb_get_config(unsigned int unused)
+{
+	u32 size;
+	u32 map_len;
+	void *new_dtb;
+
+	if (!initial_dtb)
+		return;
+
+	map_len = max(PAGE_SIZE - (initial_dtb & ~PAGE_MASK),
+			(u64)sizeof(struct boot_param_header));
+
+	initial_boot_params = early_memremap(initial_dtb, map_len);
+	size = be32_to_cpu(initial_boot_params->totalsize);
+	if (map_len < size) {
+		early_iounmap(initial_boot_params, map_len);
+		initial_boot_params = early_memremap(initial_dtb, size);
+		map_len = size;
+	}
+
+	new_dtb = alloc_bootmem(size);
+	memcpy(new_dtb, initial_boot_params, size);
+	early_iounmap(initial_boot_params, map_len);
+
+	initial_boot_params = new_dtb;
+
+	/* root level address cells */
+	of_scan_flat_dt(early_init_dt_scan_root, NULL);
+
+	unflatten_device_tree();
+	dtb_apic_setup();
 }
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index c752e97..4cadf86 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -25,6 +25,7 @@
 #include <asm/setup.h>
 #include <asm/i8259.h>
 #include <asm/traps.h>
+#include <asm/prom.h>
 
 /*
  * ISA PIC or low IO-APIC triggered (INTA-cycle or APIC) interrupts:
@@ -243,7 +244,7 @@ void __init native_init_IRQ(void)
 			set_intr_gate(i, interrupt[i-FIRST_EXTERNAL_VECTOR]);
 	}
 
-	if (!acpi_ioapic)
+	if (!acpi_ioapic && !of_ioapic)
 		setup_irq(2, &irq2);
 
 #ifdef CONFIG_X86_32
-- 
1.7.4

