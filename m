Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab0HWUuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 16:50:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:42268 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab0HWUuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 16:50:16 -0400
Message-ID: <4C72DE94.1040006@kernel.org>
Date: Mon, 23 Aug 2010 13:48:20 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Len Brown <len.brown@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Disabling x2apic if nox2apic is specified
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


for
1. x2apic preenabled system
2. first kernel have x2apic enabled, and try to boot second kernel with "nox2apic"

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/apic.h    |    6 ++++
 arch/x86/include/asm/apicdef.h |    1 
 arch/x86/kernel/acpi/boot.c    |   10 ++++++-
 arch/x86/kernel/apic/apic.c    |   54 ++++++++++++++++++++++++++++++++---------
 arch/x86/mm/srat_64.c          |   12 ++++++++-
 5 files changed, 69 insertions(+), 14 deletions(-)

Index: linux-2.6/arch/x86/include/asm/apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/apic.h
+++ linux-2.6/arch/x86/include/asm/apic.h
@@ -176,6 +176,7 @@ static inline u64 native_x2apic_icr_read
 }
 
 extern int x2apic_phys;
+extern int nox2apic;
 extern void check_x2apic(void);
 extern void enable_x2apic(void);
 extern void x2apic_icr_write(u32 low, u32 id);
@@ -186,6 +187,10 @@ static inline int x2apic_enabled(void)
 	if (!cpu_has_x2apic)
 		return 0;
 
+	/* avoid to read msr */
+	if (nox2apic)
+		return 0;
+
 	rdmsr(MSR_IA32_APICBASE, msr, msr2);
 	if (msr & X2APIC_ENABLE)
 		return 1;
@@ -214,6 +219,7 @@ static inline void x2apic_force_phys(voi
 
 #define	x2apic_preenabled 0
 #define	x2apic_supported()	0
+#define	nox2apic	1
 #endif
 
 extern void enable_IR_x2apic(void);
Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -213,6 +213,8 @@ static int __init
 acpi_parse_x2apic(struct acpi_subtable_header *header, const unsigned long end)
 {
 	struct acpi_madt_local_x2apic *processor = NULL;
+	int apic_id;
+	u8 enabled;
 
 	processor = (struct acpi_madt_local_x2apic *)header;
 
@@ -221,6 +223,8 @@ acpi_parse_x2apic(struct acpi_subtable_h
 
 	acpi_table_print_madt_entry(header);
 
+	apic_id = processor->local_apic_id;
+	enabled = processor->lapic_flags & ACPI_MADT_ENABLED;
 #ifdef CONFIG_X86_X2APIC
 	/*
 	 * We need to register disabled CPU as well to permit
@@ -229,8 +233,10 @@ acpi_parse_x2apic(struct acpi_subtable_h
 	 * to not preallocating memory for all NR_CPUS
 	 * when we use CPU hotplug.
 	 */
-	acpi_register_lapic(processor->local_apic_id,	/* APIC ID */
-			    processor->lapic_flags & ACPI_MADT_ENABLED);
+	if (nox2apic && (apic_id >= 0xff) && enabled)
+		printk(KERN_WARNING PREFIX "x2apic entry ignored\n");
+	else
+		acpi_register_lapic(apic_id, enabled);
 #else
 	printk(KERN_WARNING PREFIX "x2apic entry ignored\n");
 #endif
Index: linux-2.6/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6/arch/x86/kernel/apic/apic.c
@@ -137,15 +137,14 @@ int x2apic_mode;
 #ifdef CONFIG_X86_X2APIC
 /* x2apic enabled before OS handover */
 static int x2apic_preenabled;
+int nox2apic;
 static __init int setup_nox2apic(char *str)
 {
-	if (x2apic_enabled()) {
-		pr_warning("Bios already enabled x2apic, "
-			   "can't enforce nox2apic");
-		return 0;
-	}
+	if (x2apic_enabled())
+		pr_warning("Bios already enabled x2apic, will disable it");
+
+	nox2apic = 1;
 
-	setup_clear_cpu_cap(X86_FEATURE_X2APIC);
 	return 0;
 }
 early_param("nox2apic", setup_nox2apic);
@@ -1343,8 +1342,33 @@ void __cpuinit end_local_APIC_setup(void
 }
 
 #ifdef CONFIG_X86_X2APIC
+
+static void disable_x2apic(void)
+{
+	int msr, msr2;
+
+	if (!cpu_has_x2apic)
+		return;
+
+	rdmsr(MSR_IA32_APICBASE, msr, msr2);
+	if (msr & X2APIC_ENABLE) {
+		pr_info("Disabling x2apic\n");
+		/*
+		 * Need to disable xapic and x2apic at the same time at first
+		 *  then enable xapic
+		 */
+		wrmsr(MSR_IA32_APICBASE, msr & ~(X2APIC_ENABLE | XAPIC_ENABLE),
+			 0);
+		wrmsr(MSR_IA32_APICBASE, msr & ~X2APIC_ENABLE, 0);
+	}
+}
 void check_x2apic(void)
 {
+	if (nox2apic) {
+		disable_x2apic();
+		return;
+	}
+
 	if (x2apic_enabled()) {
 		pr_info("x2apic enabled by BIOS, switching to x2apic ops\n");
 		x2apic_preenabled = x2apic_mode = 1;
@@ -1355,6 +1379,11 @@ void enable_x2apic(void)
 {
 	int msr, msr2;
 
+	if (nox2apic) {
+		disable_x2apic();
+		return;
+	}
+
 	if (!x2apic_mode)
 		return;
 
@@ -1380,7 +1409,7 @@ int __init enable_IR(void)
 		return 0;
 	}
 
-	if (enable_intr_remapping(x2apic_supported()))
+	if (enable_intr_remapping(x2apic_supported() && !nox2apic))
 		return 0;
 
 	pr_info("Enabled Interrupt-remapping\n");
@@ -1399,7 +1428,7 @@ void __init enable_IR_x2apic(void)
 	int dmar_table_init_ret;
 
 	dmar_table_init_ret = dmar_table_init();
-	if (dmar_table_init_ret && !x2apic_supported())
+	if (dmar_table_init_ret && (!x2apic_supported() || nox2apic))
 		return;
 
 	ioapic_entries = alloc_ioapic_entries();
@@ -1423,12 +1452,15 @@ void __init enable_IR_x2apic(void)
 	else
 		ret = enable_IR();
 
+	if (nox2apic)
+		goto without_x2apic;
+
 	if (!ret) {
 		/* IR is required if there is APIC ID > 255 even when running
 		 * under KVM
 		 */
 		if (max_physical_apicid > 255 || !kvm_para_available())
-			goto nox2apic;
+			goto without_x2apic;
 		/*
 		 * without IR all CPUs can be addressed by IOAPIC/MSI
 		 * only in physical mode
@@ -1444,7 +1476,7 @@ void __init enable_IR_x2apic(void)
 		pr_info("Enabled x2apic\n");
 	}
 
-nox2apic:
+without_x2apic:
 	if (!ret) /* IR enabling failed */
 		restore_IO_APIC_setup(ioapic_entries);
 	legacy_pic->restore_mask();
@@ -1459,7 +1491,7 @@ out:
 
 	if (x2apic_preenabled)
 		panic("x2apic: enabled by BIOS but kernel init failed.");
-	else if (cpu_has_x2apic)
+	else if (cpu_has_x2apic && !nox2apic)
 		pr_info("Not enabling x2apic, Intr-remapping init failed.\n");
 }
 
Index: linux-2.6/arch/x86/mm/srat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat_64.c
+++ linux-2.6/arch/x86/mm/srat_64.c
@@ -125,6 +125,13 @@ acpi_numa_x2apic_affinity_init(struct ac
 	if ((pa->flags & ACPI_SRAT_CPU_ENABLED) == 0)
 		return;
 	pxm = pa->proximity_domain;
+	apic_id = pa->apic_id;
+#ifdef CONFIG_X86_X2APIC
+	if (nox2apic && (apic_id >= 0xff)) {
+		printk(KERN_INFO "SRAT: PXM %u -> X2APIC 0x%04x ignored\n",
+			 pxm, apic_id);
+		return;
+	}
 	node = setup_node(pxm);
 	if (node < 0) {
 		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
@@ -132,12 +139,15 @@ acpi_numa_x2apic_affinity_init(struct ac
 		return;
 	}
 
-	apic_id = pa->apic_id;
 	apicid_to_node[apic_id] = node;
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
 	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u\n",
 	       pxm, apic_id, node);
+#else
+	printk(KERN_INFO "SRAT: PXM %u -> X2APIC 0x%04x ignored\n",
+		 pxm, apic_id);
+#endif
 }
 
 /* Callback for Proximity Domain -> LAPIC mapping */
Index: linux-2.6/arch/x86/include/asm/apicdef.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/apicdef.h
+++ linux-2.6/arch/x86/include/asm/apicdef.h
@@ -140,6 +140,7 @@
 
 #define APIC_BASE (fix_to_virt(FIX_APIC_BASE))
 #define APIC_BASE_MSR	0x800
+#define XAPIC_ENABLE	(1UL << 11)
 #define X2APIC_ENABLE	(1UL << 10)
 
 #ifdef CONFIG_X86_32
