Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760500Ab1LQBAF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 20:00:05 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:33996 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab1LQBAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 20:00:00 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v8] x86: Disable x2apic if nox2apic is specified or intr-remap can not be enabled
Date: Fri, 16 Dec 2011 16:59:06 -0800
Message-Id: <1324083546-1003-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.1
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4EEBE978.0141,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For
1. x2apic preenabled system
2. first kernel have x2apic enabled, and try to kexec second kernel with "nox2apic"

Will put back cpu with apic id < 255 into xapic mode, instead of panic.

-v2: use variable x2apic_disabled instead of variable nox2apic, Suggested by Thomas
     update x2apic_supported with x2apic_disabled, Suggested by Thomas

-v3: add checking for boot cpu apic id > 255. in that case will just panic
     --- pointed out by Suresh.

-v4: according to Ingo, for x2apic pre-enabled system, if intr-remap can not
	be enabled, try to disable x2apic instead of panic and request to
	specify nox2apic for next boot.

-v5: fix the lapic mapping for falling path.

-v6: add warning when check_timer fails in strange case when BIOS enable x2apic
     and intr_remapping but does not provide dmar table. requested by Suresh.

-v7: fix compiling with x2apic_preenabled

-v8: fix compiling with x2apic_disabled assigned with !X86_X2APIC

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Tested-by: "Berck E. Nash" <flyboy@gmail.com>

---
 arch/x86/include/asm/apic.h         |    9 +++-
 arch/x86/include/asm/apicdef.h      |    1 
 arch/x86/include/asm/processor.h    |    1 
 arch/x86/kernel/acpi/boot.c         |   10 +++-
 arch/x86/kernel/apic/apic.c         |   79 ++++++++++++++++++++++++++----------
 arch/x86/kernel/apic/apic_flat_64.c |    7 ++-
 arch/x86/kernel/apic/io_apic.c      |    4 +
 arch/x86/kernel/cpu/topology.c      |   21 +++++++++
 arch/x86/mm/srat.c                  |    7 ++-
 9 files changed, 112 insertions(+), 27 deletions(-)

Index: linux-2.6/arch/x86/include/asm/apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/apic.h
+++ linux-2.6/arch/x86/include/asm/apic.h
@@ -176,6 +176,8 @@ static inline u64 native_x2apic_icr_read
 }
 
 extern int x2apic_phys;
+extern int x2apic_preenabled;
+extern int x2apic_disabled;
 extern void check_x2apic(void);
 extern void enable_x2apic(void);
 extern void x2apic_icr_write(u32 low, u32 id);
@@ -183,7 +185,7 @@ static inline int x2apic_enabled(void)
 {
 	u64 msr;
 
-	if (!cpu_has_x2apic)
+	if (!cpu_has_x2apic || x2apic_disabled)
 		return 0;
 
 	rdmsrl(MSR_IA32_APICBASE, msr);
@@ -192,12 +194,15 @@ static inline int x2apic_enabled(void)
 	return 0;
 }
 
-#define x2apic_supported()	(cpu_has_x2apic)
+#define x2apic_supported()	(cpu_has_x2apic && !x2apic_disabled)
 static inline void x2apic_force_phys(void)
 {
 	x2apic_phys = 1;
 }
 #else
+static inline void disable_x2apic(void)
+{
+}
 static inline void check_x2apic(void)
 {
 }
@@ -214,6 +219,7 @@ static inline void x2apic_force_phys(voi
 
 #define	x2apic_preenabled 0
 #define	x2apic_supported()	0
+#define	x2apic_disabled	1
 #endif
 
 extern void enable_IR_x2apic(void);
Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -219,6 +219,8 @@ static int __init
 acpi_parse_x2apic(struct acpi_subtable_header *header, const unsigned long end)
 {
 	struct acpi_madt_local_x2apic *processor = NULL;
+	int apic_id;
+	u8 enabled;
 
 	processor = (struct acpi_madt_local_x2apic *)header;
 
@@ -227,6 +229,8 @@ acpi_parse_x2apic(struct acpi_subtable_h
 
 	acpi_table_print_madt_entry(header);
 
+	apic_id = processor->local_apic_id;
+	enabled = processor->lapic_flags & ACPI_MADT_ENABLED;
 #ifdef CONFIG_X86_X2APIC
 	/*
 	 * We need to register disabled CPU as well to permit
@@ -235,8 +239,10 @@ acpi_parse_x2apic(struct acpi_subtable_h
 	 * to not preallocating memory for all NR_CPUS
 	 * when we use CPU hotplug.
 	 */
-	acpi_register_lapic(processor->local_apic_id,	/* APIC ID */
-			    processor->lapic_flags & ACPI_MADT_ENABLED);
+	if (x2apic_disabled && (apic_id >= 0xff) && enabled)
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
@@ -151,16 +151,15 @@ __setup("apicpmtimer", setup_apicpmtimer
 int x2apic_mode;
 #ifdef CONFIG_X86_X2APIC
 /* x2apic enabled before OS handover */
-static int x2apic_preenabled;
+int x2apic_preenabled;
+int x2apic_disabled;
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
+	x2apic_disabled = 1;
 
-	setup_clear_cpu_cap(X86_FEATURE_X2APIC);
 	return 0;
 }
 early_param("nox2apic", setup_nox2apic);
@@ -1437,8 +1436,40 @@ void __init bsp_end_local_APIC_setup(voi
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
+		u32 x2apic_id = x2apic_cpuid_initial_apicid();
+
+		if (x2apic_id > 255)
+			panic("Can not disable x2apic, id: %08x\n", x2apic_id);
+
+		pr_info("Disabling x2apic\n");
+		/*
+		 * Need to disable xapic and x2apic at the same time at first
+		 *  then enable xapic
+		 */
+		wrmsr(MSR_IA32_APICBASE, msr & ~(X2APIC_ENABLE | XAPIC_ENABLE),
+			 0);
+		wrmsr(MSR_IA32_APICBASE, msr & ~X2APIC_ENABLE, 0);
+
+		x2apic_disabled = 1;
+	}
+}
 void check_x2apic(void)
 {
+	if (x2apic_disabled) {
+		disable_x2apic();
+		return;
+	}
+
 	if (x2apic_enabled()) {
 		pr_info("x2apic enabled by BIOS, switching to x2apic ops\n");
 		x2apic_preenabled = x2apic_mode = 1;
@@ -1449,6 +1480,11 @@ void enable_x2apic(void)
 {
 	int msr, msr2;
 
+	if (x2apic_disabled) {
+		disable_x2apic();
+		return;
+	}
+
 	if (!x2apic_mode)
 		return;
 
@@ -1499,7 +1535,7 @@ void __init enable_IR_x2apic(void)
 	ret = save_ioapic_entries();
 	if (ret) {
 		pr_info("Saving IO-APIC state failed: %d\n", ret);
-		goto out;
+		return;
 	}
 
 	local_irq_save(flags);
@@ -1511,13 +1547,23 @@ void __init enable_IR_x2apic(void)
 	else
 		ret = enable_IR();
 
+	if (x2apic_disabled)
+		goto nox2apic;
+
 	if (ret < 0) {
 		/* IR is required if there is APIC ID > 255 even when running
 		 * under KVM
 		 */
 		if (max_physical_apicid > 255 ||
-		    !hypervisor_x2apic_available())
+		    !hypervisor_x2apic_available()) {
+			if (x2apic_preenabled) {
+				disable_x2apic();
+				x2apic_mode = 0;
+				/* need to map lapic address */
+				register_lapic_address(mp_lapic_addr);
+			}
 			goto nox2apic;
+		}
 		/*
 		 * without IR all CPUs can be addressed by IOAPIC/MSI
 		 * only in physical mode
@@ -1525,8 +1571,10 @@ void __init enable_IR_x2apic(void)
 		x2apic_force_phys();
 	}
 
-	if (ret == IRQ_REMAP_XAPIC_MODE)
+	if (ret == IRQ_REMAP_XAPIC_MODE) {
+		pr_info("x2apic not enabled, IRQ remapping is in xapic mode\n");
 		goto nox2apic;
+	}
 
 	x2apic_enabled = 1;
 
@@ -1541,17 +1589,6 @@ nox2apic:
 		restore_ioapic_entries();
 	legacy_pic->restore_mask();
 	local_irq_restore(flags);
-
-out:
-	if (x2apic_enabled || !x2apic_supported())
-		return;
-
-	if (x2apic_preenabled)
-		panic("x2apic: enabled by BIOS but kernel init failed.");
-	else if (ret == IRQ_REMAP_XAPIC_MODE)
-		pr_info("x2apic not enabled, IRQ remapping is in xapic mode\n");
-	else if (ret < 0)
-		pr_info("x2apic not enabled, IRQ remapping init failed\n");
 }
 
 #ifdef CONFIG_X86_64
Index: linux-2.6/arch/x86/mm/srat.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat.c
+++ linux-2.6/arch/x86/mm/srat.c
@@ -69,6 +69,12 @@ acpi_numa_x2apic_affinity_init(struct ac
 	if ((pa->flags & ACPI_SRAT_CPU_ENABLED) == 0)
 		return;
 	pxm = pa->proximity_domain;
+	apic_id = pa->apic_id;
+	if (x2apic_disabled && (apic_id >= 0xff)) {
+		printk(KERN_INFO "SRAT: PXM %u -> X2APIC 0x%04x ignored\n",
+			 pxm, apic_id);
+		return;
+	}
 	node = setup_node(pxm);
 	if (node < 0) {
 		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
@@ -76,7 +82,6 @@ acpi_numa_x2apic_affinity_init(struct ac
 		return;
 	}
 
-	apic_id = pa->apic_id;
 	if (apic_id >= MAX_LOCAL_APIC) {
 		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
 		return;
Index: linux-2.6/arch/x86/include/asm/apicdef.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/apicdef.h
+++ linux-2.6/arch/x86/include/asm/apicdef.h
@@ -144,6 +144,7 @@
 
 #define APIC_BASE (fix_to_virt(FIX_APIC_BASE))
 #define APIC_BASE_MSR	0x800
+#define XAPIC_ENABLE	(1UL << 11)
 #define X2APIC_ENABLE	(1UL << 10)
 
 #ifdef CONFIG_X86_32
Index: linux-2.6/arch/x86/include/asm/processor.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/processor.h
+++ linux-2.6/arch/x86/include/asm/processor.h
@@ -168,6 +168,7 @@ extern void init_scattered_cpuid_feature
 extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
 extern unsigned short num_cache_leaves;
 
+u32 x2apic_cpuid_initial_apicid(void);
 extern void detect_extended_topology(struct cpuinfo_x86 *c);
 extern void detect_ht(struct cpuinfo_x86 *c);
 
Index: linux-2.6/arch/x86/kernel/cpu/topology.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/topology.c
+++ linux-2.6/arch/x86/kernel/cpu/topology.c
@@ -21,6 +21,27 @@
 #define BITS_SHIFT_NEXT_LEVEL(eax)	((eax) & 0x1f)
 #define LEVEL_MAX_SIBLINGS(ebx)		((ebx) & 0xffff)
 
+u32 x2apic_cpuid_initial_apicid(void)
+{
+	unsigned int eax, ebx, ecx, edx;
+
+	if (boot_cpu_data.cpuid_level < 0xb)
+		return 0;
+
+	cpuid_count(0xb, SMT_LEVEL, &eax, &ebx, &ecx, &edx);
+
+	/*
+	 * check if the cpuid leaf 0xb is actually implemented.
+	 */
+	if (ebx == 0 || (LEAFB_SUBTYPE(ecx) != SMT_TYPE))
+		return 0;
+
+	/*
+	 * initial apic id, which also represents 32-bit extended x2apic id.
+	 */
+	return edx;
+}
+
 /*
  * Check for extended topology enumeration cpuid leaf 0xb and if it
  * exists, use it for populating initial_apicid and cpu topology
Index: linux-2.6/arch/x86/kernel/apic/apic_flat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic_flat_64.c
+++ linux-2.6/arch/x86/kernel/apic/apic_flat_64.c
@@ -171,9 +171,14 @@ static int flat_phys_pkg_id(int initial_
 	return initial_apic_id >> index_msb;
 }
 
+static int flat_probe(void)
+{
+	return 1;
+}
+
 static struct apic apic_flat =  {
 	.name				= "flat",
-	.probe				= NULL,
+	.probe				= flat_probe,
 	.acpi_madt_oem_check		= flat_acpi_madt_oem_check,
 	.apic_id_registered		= flat_apic_id_registered,
 
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -2947,6 +2947,10 @@ static inline void __init check_timer(vo
 	}
 	local_irq_disable();
 	apic_printk(APIC_QUIET, KERN_INFO "..... failed :(.\n");
+	if (x2apic_preenabled && !x2apic_mode)
+		pr_info("Your system has x2apic pre-enabled, but kernel can not enable intr-remapping.\n"
+			"So kernel try to disable x2apic, but interrupt still have problem.\n"
+			"You could disable x2apic from BIOS setup\n");
 	panic("IO-APIC + timer doesn't work!  Boot with apic=debug and send a "
 		"report.  Then try booting with the 'noapic' option.\n");
 out:
