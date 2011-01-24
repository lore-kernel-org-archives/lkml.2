Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab1AXEc2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 23:32:28 -0500
Received: from www.tglx.de ([62.245.132.106]:55601 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614Ab1AXE3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 23:29:35 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH TIP 05/14] x86/dtb: add early parsing of APIC and IO APIC
Date: Mon, 24 Jan 2011 09:58:53 +0530
Message-Id: <1295843342-1122-6-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de>
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
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/include/asm/prom.h |    7 +++
 arch/x86/kernel/irqinit.c   |    2 +-
 arch/x86/kernel/prom.c      |  112 +++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 117 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
index ed7bb62..bd67ab2 100644
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
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index 149c87f..4cadf86 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -244,7 +244,7 @@ void __init native_init_IRQ(void)
 			set_intr_gate(i, interrupt[i-FIRST_EXTERNAL_VECTOR]);
 	}
 
-	if (!acpi_ioapic)
+	if (!acpi_ioapic && !of_ioapic)
 		setup_irq(2, &irq2);
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/prom.c b/arch/x86/kernel/prom.c
index 95f9551..e4d53bf 100644
--- a/arch/x86/kernel/prom.c
+++ b/arch/x86/kernel/prom.c
@@ -6,15 +6,20 @@
 #include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <linux/slab.h>
 
 #include <asm/irq_controller.h>
+#include <asm/io_apic.h>
 
+__initdata u64 initial_dtb;
 char __initdata cmd_line[COMMAND_LINE_SIZE];
 static LIST_HEAD(irq_domains);
 static DEFINE_RAW_SPINLOCK(big_irq_lock);
 
+int __initdata of_ioapic;
+
 void add_interrupt_host(struct irq_domain *ih)
 {
 	unsigned long flags;
@@ -90,7 +95,108 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 
 void __init add_dtb(u64 data)
 {
-	initial_boot_params = (struct boot_param_header *)
-		phys_to_virt((u64) (u32) data +
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
+	for_each_compatible_node(dn, NULL, "intel,ioapic")
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
-- 
1.7.3.2

