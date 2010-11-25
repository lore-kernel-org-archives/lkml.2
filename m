Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab0KYRnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 12:43:25 -0500
Received: from www.tglx.de ([62.245.132.106]:50862 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993Ab0KYRnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 12:43:19 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: sodaville@linutronix.de, x86@kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 05/11] x86/dtb: add early parsing of APIC and IO APIC
Date: Thu, 25 Nov 2010 18:39:55 +0100
Message-Id: <1290706801-7323-6-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The apic & ioapic have to be added to system early because
native_init_IRQ() requires it.
The phys_reg preoperty is used instead of the reg property because in
case of a PCI device this property is not holding the address of the
chip. In this case we can't query the PCI bar information because the
PCI bus is not (yet) up.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: x86@kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
Tested-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 arch/x86/include/asm/prom.h |    4 ++
 arch/x86/kernel/irqinit.c   |    2 +-
 arch/x86/kernel/prom.c      |  105 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 110 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
index 6c80e53..b74a49f 100644
--- a/arch/x86/include/asm/prom.h
+++ b/arch/x86/include/asm/prom.h
@@ -23,12 +23,16 @@
 #include <asm/irq_controller.h>
 
 #ifdef CONFIG_OF
+extern int of_ioapic;
 extern void init_dtb(void);
 extern void add_dtb(u64 data);
+void x86_early_of_parse(void);
 void add_interrupt_host(struct irq_host *ih);
 #else
 static inline void init_dtb(void) { }
 static inline void add_dtb(u64 data) { }
+static inline void x86_early_of_parse(void) { }
+#define of_ioapic 0
 #endif
 
 extern char cmd_line[COMMAND_LINE_SIZE];
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index d5970e2..8030193 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -250,7 +250,7 @@ void __init native_init_IRQ(void)
 			set_intr_gate(i, interrupt[i-FIRST_EXTERNAL_VECTOR]);
 	}
 
-	if (!acpi_ioapic)
+	if (!acpi_ioapic && !of_ioapic)
 		setup_irq(2, &irq2);
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/prom.c b/arch/x86/kernel/prom.c
index 996fd05..9551f2f 100644
--- a/arch/x86/kernel/prom.c
+++ b/arch/x86/kernel/prom.c
@@ -10,11 +10,14 @@
 #include <linux/slab.h>
 
 #include <asm/irq_controller.h>
+#include <asm/io_apic.h>
 
 char __initdata cmd_line[COMMAND_LINE_SIZE];
 static LIST_HEAD(irq_hosts);
 static DEFINE_RAW_SPINLOCK(big_irq_lock);
 
+int __initdata of_ioapic;
+
 void add_interrupt_host(struct irq_host *ih)
 {
 	unsigned long flags;
@@ -96,6 +99,108 @@ void __init add_dtb(u64 data)
 				offsetof(struct setup_data, data));
 }
 
+static void __init of_lapic_setup(void)
+{
+#ifdef CONFIG_X86_LOCAL_APIC
+	if (apic_force_enable())
+		return ;
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
+static int __init early_scan_ioapic(unsigned long node, const char *uname,
+				   int depth, void *data)
+{
+	unsigned long l;
+	int ret;
+	__be32 *cell;
+	int ioapic_id;
+	phys_addr_t ioapic_addr;
+
+	ret = of_flat_dt_is_compatible(node, "intel,ioapic");
+	if (!ret)
+		return 0;
+
+	cell = of_get_flat_dt_prop(node, "phys_reg", &l);
+	if (!cell)
+		return 0;
+
+	ioapic_addr = of_read_ulong(cell, l / 4);
+	cell = of_get_flat_dt_prop(node, "id", &l);
+	if (!cell)
+		return 0;
+	ioapic_id = of_read_ulong(cell, l / 4);
+
+	mp_register_ioapic(ioapic_id, ioapic_addr, gsi_top);
+	return 0;
+}
+
+static void __init of_ioapic_setup(void)
+{
+	if (!smp_found_config)
+		return;
+
+	of_scan_flat_dt(early_scan_ioapic, NULL);
+	if (nr_ioapics) {
+		of_ioapic = 1;
+		return;
+	}
+	printk(KERN_ERR "Error: No information about IO-APIC in OF.\n");
+	smp_found_config = 0;
+}
+#else
+static void __init of_ioapic_setup(void) {}
+#endif
+
+static void __init of_apic_setup(void)
+{
+	of_lapic_setup();
+	of_ioapic_setup();
+}
+
+void __init x86_early_of_parse(void)
+{
+	void *virt_dtb;
+	resource_size_t phys_dtb;
+	u32 size;
+
+	if (!initial_boot_params)
+		return;
+	/*
+	 * Here we grab some early informations before we the kernel mapping
+	 * covers the complete lowmem. We setup a temporary fixmap for it and
+	 * once we have what we were looking for we revert the address to its
+	 * initial value. It will be used during unflattering and later during
+	 * string lookups etc.
+	 */
+
+	virt_dtb = initial_boot_params;
+	phys_dtb = virt_to_phys(virt_dtb);
+
+	initial_boot_params = early_memremap(phys_dtb, PAGE_SIZE);
+	size = be32_to_cpu(initial_boot_params->totalsize);
+	early_iounmap(initial_boot_params, PAGE_SIZE);
+
+	initial_boot_params = early_memremap(phys_dtb, size);
+
+	/* root level address cells */
+	of_scan_flat_dt(early_init_dt_scan_root, NULL);
+	of_apic_setup();
+
+	early_iounmap(initial_boot_params, size);
+	initial_boot_params = virt_dtb;
+}
+
 void __init init_dtb(void)
 {
 	if (!initial_boot_params)
-- 
1.7.3.2

