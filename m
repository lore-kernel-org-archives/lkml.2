Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642Ab0JXBFI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 21:05:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48178 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758972Ab0JXBFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 21:05:02 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 15/15] x86: Disabling x2apic if nox2apic is specified
Date: Sat, 23 Oct 2010 18:02:29 -0700
Message-Id: <1287882149-29275-16-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287882149-29275-1-git-send-email-yinghai@kernel.org>
References: <1287882149-29275-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For
1. x2apic preenabled system
2. first kernel have x2apic enabled, and try to boot second kernel with "nox2apic"

Will put back cpu with apic id < 255 into xapic mode, instead of panic.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/apic.h    |    6 ++++
 arch/x86/include/asm/apicdef.h |    1 +
 arch/x86/kernel/acpi/boot.c    |   10 ++++++-
 arch/x86/kernel/apic/apic.c    |   54 +++++++++++++++++++++++++++++++--------
 arch/x86/mm/srat_64.c          |   12 ++++++++-
 5 files changed, 69 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 69879dd..522f39b 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -176,6 +176,7 @@ static inline u64 native_x2apic_icr_read(void)
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
@@ -214,6 +219,7 @@ static inline void x2apic_force_phys(void)
 
 #define	x2apic_preenabled 0
 #define	x2apic_supported()	0
+#define	nox2apic	1
 #endif
 
 extern void enable_IR_x2apic(void);
diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index a859ca4..f28feba 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -141,6 +141,7 @@
 
 #define APIC_BASE (fix_to_virt(FIX_APIC_BASE))
 #define APIC_BASE_MSR	0x800
+#define XAPIC_ENABLE	(1UL << 11)
 #define X2APIC_ENABLE	(1UL << 10)
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 8e13ec8..5a4e67e 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -213,6 +213,8 @@ static int __init
 acpi_parse_x2apic(struct acpi_subtable_header *header, const unsigned long end)
 {
 	struct acpi_madt_local_x2apic *processor = NULL;
+	int apic_id;
+	u8 enabled;
 
 	processor = (struct acpi_madt_local_x2apic *)header;
 
@@ -221,6 +223,8 @@ acpi_parse_x2apic(struct acpi_subtable_header *header, const unsigned long end)
 
 	acpi_table_print_madt_entry(header);
 
+	apic_id = processor->local_apic_id;
+	enabled = processor->lapic_flags & ACPI_MADT_ENABLED;
 #ifdef CONFIG_X86_X2APIC
 	/*
 	 * We need to register disabled CPU as well to permit
@@ -229,8 +233,10 @@ acpi_parse_x2apic(struct acpi_subtable_header *header, const unsigned long end)
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
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index d286db1..ebb13e8 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -138,15 +138,14 @@ int x2apic_mode;
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
@@ -1393,8 +1392,33 @@ void __cpuinit end_local_APIC_setup(void)
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
@@ -1405,6 +1429,11 @@ void enable_x2apic(void)
 {
 	int msr, msr2;
 
+	if (nox2apic) {
+		disable_x2apic();
+		return;
+	}
+
 	if (!x2apic_mode)
 		return;
 
@@ -1430,7 +1459,7 @@ int __init enable_IR(void)
 		return 0;
 	}
 
-	if (enable_intr_remapping(x2apic_supported()))
+	if (enable_intr_remapping(x2apic_supported() && !nox2apic))
 		return 0;
 
 	pr_info("Enabled Interrupt-remapping\n");
@@ -1449,7 +1478,7 @@ void __init enable_IR_x2apic(void)
 	int dmar_table_init_ret;
 
 	dmar_table_init_ret = dmar_table_init();
-	if (dmar_table_init_ret && !x2apic_supported())
+	if (dmar_table_init_ret && (!x2apic_supported() || nox2apic))
 		return;
 
 	ioapic_entries = alloc_ioapic_entries();
@@ -1473,12 +1502,15 @@ void __init enable_IR_x2apic(void)
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
@@ -1494,7 +1526,7 @@ void __init enable_IR_x2apic(void)
 		pr_info("Enabled x2apic\n");
 	}
 
-nox2apic:
+without_x2apic:
 	if (!ret) /* IR enabling failed */
 		restore_IO_APIC_setup(ioapic_entries);
 	legacy_pic->restore_mask();
@@ -1509,7 +1541,7 @@ out:
 
 	if (x2apic_preenabled)
 		panic("x2apic: enabled by BIOS but kernel init failed.");
-	else if (cpu_has_x2apic)
+	else if (cpu_has_x2apic && !nox2apic)
 		pr_info("Not enabling x2apic, Intr-remapping init failed.\n");
 }
 
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index a35cb9d..baa9eab 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -126,6 +126,13 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
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
@@ -133,12 +140,15 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
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
-- 
1.7.1

