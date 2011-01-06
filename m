Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab1AFJok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 04:44:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42550 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab1AFJog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 04:44:36 -0500
Date: Thu, 6 Jan 2011 10:44:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/apic changes for v2.6.38
Message-ID: <20110106094423.GA17565@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-apic-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-apic-for-linus


out-of-topic modifications in x86-apic-for-linus:
-------------------------------------------------
drivers/acpi/numa.c                # d3bd058: x86, acpi: Parse all SRAT cpu ent

 Thanks,

	Ingo

------------------>
Sebastian Andrzej Siewior (1):
      x86: io_apic: Split setup_ioapic_ids_from_mpc()

Thomas Gleixner (3):
      x86: Allow platforms to force enable apic
      x86: apic: Move probe_nr_irqs_gsi() into ioapic_init_mappings()
      x86: io_apic: Fix CONFIG_X86_IO_APIC=n breakage

Yinghai Lu (3):
      x86, acpi: Add MAX_LOCAL_APIC for 32bit
      x86, acpi: Parse all SRAT cpu entries even above the cpu number limitation
      x86: Fix APIC ID sizing bug on larger systems, clean up MAX_APICS confusion


 arch/x86/include/asm/apic.h            |    1 +
 arch/x86/include/asm/apicdef.h         |    1 +
 arch/x86/include/asm/io_apic.h         |    8 +--
 arch/x86/include/asm/mpspec.h          |   31 ++++-------
 arch/x86/include/asm/mpspec_def.h      |    7 ---
 arch/x86/kernel/acpi/boot.c            |   11 +++-
 arch/x86/kernel/apic/apic.c            |   89 ++++++++++++++++++++------------
 arch/x86/kernel/apic/io_apic.c         |   37 ++++++++-----
 arch/x86/kernel/setup.c                |    5 +--
 arch/x86/mm/srat_32.c                  |    1 +
 arch/x86/mm/srat_64.c                  |   10 ++++
 arch/x86/platform/sfi/sfi.c            |    4 +-
 arch/x86/platform/visws/visws_quirks.c |    2 +-
 drivers/acpi/numa.c                    |   14 ++++-
 14 files changed, 129 insertions(+), 92 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index f6ce0bd..cf12007 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -238,6 +238,7 @@ extern void setup_boot_APIC_clock(void);
 extern void setup_secondary_APIC_clock(void);
 extern int APIC_init_uniprocessor(void);
 extern void enable_NMI_through_LVT0(void);
+extern int apic_force_enable(void);
 
 /*
  * On 32bit this is mach-xxx local
diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index a859ca4..47a30ff 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -145,6 +145,7 @@
 
 #ifdef CONFIG_X86_32
 # define MAX_IO_APICS 64
+# define MAX_LOCAL_APIC 256
 #else
 # define MAX_IO_APICS 128
 # define MAX_LOCAL_APIC 32768
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index a6b28d0..0c5ca4e 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -159,7 +159,7 @@ struct io_apic_irq_attr;
 extern int io_apic_set_pci_routing(struct device *dev, int irq,
 		 struct io_apic_irq_attr *irq_attr);
 void setup_IO_APIC_irq_extra(u32 gsi);
-extern void ioapic_init_mappings(void);
+extern void ioapic_and_gsi_init(void);
 extern void ioapic_insert_resources(void);
 
 extern struct IO_APIC_route_entry **alloc_ioapic_entries(void);
@@ -168,10 +168,9 @@ extern int save_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
 extern void mask_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
 extern int restore_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
 
-extern void probe_nr_irqs_gsi(void);
 extern int get_nr_irqs_gsi(void);
-
 extern void setup_ioapic_ids_from_mpc(void);
+extern void setup_ioapic_ids_from_mpc_nocheck(void);
 
 struct mp_ioapic_gsi{
 	u32 gsi_base;
@@ -189,9 +188,8 @@ extern void __init pre_init_apic_IRQ0(void);
 #define io_apic_assign_pci_irqs 0
 #define setup_ioapic_ids_from_mpc x86_init_noop
 static const int timer_through_8259 = 0;
-static inline void ioapic_init_mappings(void)	{ }
+static inline void ioapic_and_gsi_init(void) { }
 static inline void ioapic_insert_resources(void) { }
-static inline void probe_nr_irqs_gsi(void)	{ }
 #define gsi_top (NR_IRQS_LEGACY)
 static inline int mp_find_ioapic(u32 gsi) { return 0; }
 
diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index c82868e..0c90dd9 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -5,8 +5,9 @@
 
 #include <asm/mpspec_def.h>
 #include <asm/x86_init.h>
+#include <asm/apicdef.h>
 
-extern int apic_version[MAX_APICS];
+extern int apic_version[];
 extern int pic_mode;
 
 #ifdef CONFIG_X86_32
@@ -107,7 +108,7 @@ extern int mp_register_gsi(struct device *dev, u32 gsi, int edge_level,
 				 int active_high_low);
 #endif /* CONFIG_ACPI */
 
-#define PHYSID_ARRAY_SIZE	BITS_TO_LONGS(MAX_APICS)
+#define PHYSID_ARRAY_SIZE	BITS_TO_LONGS(MAX_LOCAL_APIC)
 
 struct physid_mask {
 	unsigned long mask[PHYSID_ARRAY_SIZE];
@@ -122,31 +123,31 @@ typedef struct physid_mask physid_mask_t;
 	test_and_set_bit(physid, (map).mask)
 
 #define physids_and(dst, src1, src2)					\
-	bitmap_and((dst).mask, (src1).mask, (src2).mask, MAX_APICS)
+	bitmap_and((dst).mask, (src1).mask, (src2).mask, MAX_LOCAL_APIC)
 
 #define physids_or(dst, src1, src2)					\
-	bitmap_or((dst).mask, (src1).mask, (src2).mask, MAX_APICS)
+	bitmap_or((dst).mask, (src1).mask, (src2).mask, MAX_LOCAL_APIC)
 
 #define physids_clear(map)					\
-	bitmap_zero((map).mask, MAX_APICS)
+	bitmap_zero((map).mask, MAX_LOCAL_APIC)
 
 #define physids_complement(dst, src)				\
-	bitmap_complement((dst).mask, (src).mask, MAX_APICS)
+	bitmap_complement((dst).mask, (src).mask, MAX_LOCAL_APIC)
 
 #define physids_empty(map)					\
-	bitmap_empty((map).mask, MAX_APICS)
+	bitmap_empty((map).mask, MAX_LOCAL_APIC)
 
 #define physids_equal(map1, map2)				\
-	bitmap_equal((map1).mask, (map2).mask, MAX_APICS)
+	bitmap_equal((map1).mask, (map2).mask, MAX_LOCAL_APIC)
 
 #define physids_weight(map)					\
-	bitmap_weight((map).mask, MAX_APICS)
+	bitmap_weight((map).mask, MAX_LOCAL_APIC)
 
 #define physids_shift_right(d, s, n)				\
-	bitmap_shift_right((d).mask, (s).mask, n, MAX_APICS)
+	bitmap_shift_right((d).mask, (s).mask, n, MAX_LOCAL_APIC)
 
 #define physids_shift_left(d, s, n)				\
-	bitmap_shift_left((d).mask, (s).mask, n, MAX_APICS)
+	bitmap_shift_left((d).mask, (s).mask, n, MAX_LOCAL_APIC)
 
 static inline unsigned long physids_coerce(physid_mask_t *map)
 {
@@ -159,14 +160,6 @@ static inline void physids_promote(unsigned long physids, physid_mask_t *map)
 	map->mask[0] = physids;
 }
 
-/* Note: will create very large stack frames if physid_mask_t is big */
-#define physid_mask_of_physid(physid)					\
-	({								\
-		physid_mask_t __physid_mask = PHYSID_MASK_NONE;		\
-		physid_set(physid, __physid_mask);			\
-		__physid_mask;						\
-	})
-
 static inline void physid_set_mask_of_physid(int physid, physid_mask_t *map)
 {
 	physids_clear(*map);
diff --git a/arch/x86/include/asm/mpspec_def.h b/arch/x86/include/asm/mpspec_def.h
index 4a7f96d..c0a955a 100644
--- a/arch/x86/include/asm/mpspec_def.h
+++ b/arch/x86/include/asm/mpspec_def.h
@@ -15,13 +15,6 @@
 
 #ifdef CONFIG_X86_32
 # define MAX_MPC_ENTRY 1024
-# define MAX_APICS      256
-#else
-# if NR_CPUS <= 255
-#  define MAX_APICS     255
-# else
-#  define MAX_APICS   32768
-# endif
 #endif
 
 /* Intel MP Floating Pointer Structure */
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 71232b9..17c8090 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -198,6 +198,11 @@ static void __cpuinit acpi_register_lapic(int id, u8 enabled)
 {
 	unsigned int ver = 0;
 
+	if (id >= (MAX_LOCAL_APIC-1)) {
+		printk(KERN_INFO PREFIX "skipped apicid that is too big\n");
+		return;
+	}
+
 	if (!enabled) {
 		++disabled_cpus;
 		return;
@@ -910,13 +915,13 @@ static int __init acpi_parse_madt_lapic_entries(void)
 	acpi_register_lapic_address(acpi_lapic_addr);
 
 	count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_SAPIC,
-				      acpi_parse_sapic, MAX_APICS);
+				      acpi_parse_sapic, MAX_LOCAL_APIC);
 
 	if (!count) {
 		x2count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_X2APIC,
-						acpi_parse_x2apic, MAX_APICS);
+					acpi_parse_x2apic, MAX_LOCAL_APIC);
 		count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC,
-					      acpi_parse_lapic, MAX_APICS);
+					acpi_parse_lapic, MAX_LOCAL_APIC);
 	}
 	if (!count && !x2count) {
 		printk(KERN_ERR PREFIX "No LAPIC entries present\n");
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 7821813..30fdce8 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1538,13 +1538,60 @@ static int __init detect_init_APIC(void)
 	return 0;
 }
 #else
+
+static int apic_verify(void)
+{
+	u32 features, h, l;
+
+	/*
+	 * The APIC feature bit should now be enabled
+	 * in `cpuid'
+	 */
+	features = cpuid_edx(1);
+	if (!(features & (1 << X86_FEATURE_APIC))) {
+		pr_warning("Could not enable APIC!\n");
+		return -1;
+	}
+	set_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
+	mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
+
+	/* The BIOS may have set up the APIC at some other address */
+	rdmsr(MSR_IA32_APICBASE, l, h);
+	if (l & MSR_IA32_APICBASE_ENABLE)
+		mp_lapic_addr = l & MSR_IA32_APICBASE_BASE;
+
+	pr_info("Found and enabled local APIC!\n");
+	return 0;
+}
+
+int apic_force_enable(void)
+{
+	u32 h, l;
+
+	if (disable_apic)
+		return -1;
+
+	/*
+	 * Some BIOSes disable the local APIC in the APIC_BASE
+	 * MSR. This can only be done in software for Intel P6 or later
+	 * and AMD K7 (Model > 1) or later.
+	 */
+	rdmsr(MSR_IA32_APICBASE, l, h);
+	if (!(l & MSR_IA32_APICBASE_ENABLE)) {
+		pr_info("Local APIC disabled by BIOS -- reenabling.\n");
+		l &= ~MSR_IA32_APICBASE_BASE;
+		l |= MSR_IA32_APICBASE_ENABLE | APIC_DEFAULT_PHYS_BASE;
+		wrmsr(MSR_IA32_APICBASE, l, h);
+		enabled_via_apicbase = 1;
+	}
+	return apic_verify();
+}
+
 /*
  * Detect and initialize APIC
  */
 static int __init detect_init_APIC(void)
 {
-	u32 h, l, features;
-
 	/* Disabled by kernel option? */
 	if (disable_apic)
 		return -1;
@@ -1574,38 +1621,12 @@ static int __init detect_init_APIC(void)
 				"you can enable it with \"lapic\"\n");
 			return -1;
 		}
-		/*
-		 * Some BIOSes disable the local APIC in the APIC_BASE
-		 * MSR. This can only be done in software for Intel P6 or later
-		 * and AMD K7 (Model > 1) or later.
-		 */
-		rdmsr(MSR_IA32_APICBASE, l, h);
-		if (!(l & MSR_IA32_APICBASE_ENABLE)) {
-			pr_info("Local APIC disabled by BIOS -- reenabling.\n");
-			l &= ~MSR_IA32_APICBASE_BASE;
-			l |= MSR_IA32_APICBASE_ENABLE | APIC_DEFAULT_PHYS_BASE;
-			wrmsr(MSR_IA32_APICBASE, l, h);
-			enabled_via_apicbase = 1;
-		}
-	}
-	/*
-	 * The APIC feature bit should now be enabled
-	 * in `cpuid'
-	 */
-	features = cpuid_edx(1);
-	if (!(features & (1 << X86_FEATURE_APIC))) {
-		pr_warning("Could not enable APIC!\n");
-		return -1;
+		if (apic_force_enable())
+			return -1;
+	} else {
+		if (apic_verify())
+			return -1;
 	}
-	set_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
-	mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
-
-	/* The BIOS may have set up the APIC at some other address */
-	rdmsr(MSR_IA32_APICBASE, l, h);
-	if (l & MSR_IA32_APICBASE_ENABLE)
-		mp_lapic_addr = l & MSR_IA32_APICBASE_BASE;
-
-	pr_info("Found and enabled local APIC!\n");
 
 	apic_pm_activate();
 
@@ -1693,7 +1714,7 @@ void __init init_apic_mappings(void)
  * This initializes the IO-APIC and APIC hardware if this is
  * a UP kernel.
  */
-int apic_version[MAX_APICS];
+int apic_version[MAX_LOCAL_APIC];
 
 int __init APIC_init_uniprocessor(void)
 {
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index fadcd74..2fc696e 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1934,8 +1934,7 @@ void disable_IO_APIC(void)
  *
  * by Matt Domsch <Matt_Domsch@dell.com>  Tue Dec 21 12:25:05 CST 1999
  */
-
-void __init setup_ioapic_ids_from_mpc(void)
+void __init setup_ioapic_ids_from_mpc_nocheck(void)
 {
 	union IO_APIC_reg_00 reg_00;
 	physid_mask_t phys_id_present_map;
@@ -1944,15 +1943,6 @@ void __init setup_ioapic_ids_from_mpc(void)
 	unsigned char old_id;
 	unsigned long flags;
 
-	if (acpi_ioapic)
-		return;
-	/*
-	 * Don't check I/O APIC IDs for xAPIC systems.  They have
-	 * no meaning without the serial APIC bus.
-	 */
-	if (!(boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
-		|| APIC_XAPIC(apic_version[boot_cpu_physical_apicid]))
-		return;
 	/*
 	 * This is broken; anything with a real cpu count has to
 	 * circumvent this idiocy regardless.
@@ -2006,7 +1996,6 @@ void __init setup_ioapic_ids_from_mpc(void)
 			physids_or(phys_id_present_map, phys_id_present_map, tmp);
 		}
 
-
 		/*
 		 * We need to adjust the IRQ routing table
 		 * if the ID changed.
@@ -2042,6 +2031,21 @@ void __init setup_ioapic_ids_from_mpc(void)
 			apic_printk(APIC_VERBOSE, " ok.\n");
 	}
 }
+
+void __init setup_ioapic_ids_from_mpc(void)
+{
+
+	if (acpi_ioapic)
+		return;
+	/*
+	 * Don't check I/O APIC IDs for xAPIC systems.  They have
+	 * no meaning without the serial APIC bus.
+	 */
+	if (!(boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
+		|| APIC_XAPIC(apic_version[boot_cpu_physical_apicid]))
+		return;
+	setup_ioapic_ids_from_mpc_nocheck();
+}
 #endif
 
 int no_timer_check __initdata;
@@ -3639,7 +3643,7 @@ int __init io_apic_get_redir_entries (int ioapic)
 	return reg_01.bits.entries + 1;
 }
 
-void __init probe_nr_irqs_gsi(void)
+static void __init probe_nr_irqs_gsi(void)
 {
 	int nr;
 
@@ -3956,7 +3960,7 @@ static struct resource * __init ioapic_setup_resources(int nr_ioapics)
 	return res;
 }
 
-void __init ioapic_init_mappings(void)
+void __init ioapic_and_gsi_init(void)
 {
 	unsigned long ioapic_phys, idx = FIX_IO_APIC_BASE_0;
 	struct resource *ioapic_res;
@@ -3994,6 +3998,8 @@ fake_ioapic_page:
 		ioapic_res->end = ioapic_phys + IO_APIC_SLOT_SIZE - 1;
 		ioapic_res++;
 	}
+
+	probe_nr_irqs_gsi();
 }
 
 void __init ioapic_insert_resources(void)
@@ -4103,7 +4109,8 @@ void __init pre_init_apic_IRQ0(void)
 
 	printk(KERN_INFO "Early APIC setup for system timer0\n");
 #ifndef CONFIG_SMP
-	phys_cpu_present_map = physid_mask_of_physid(boot_cpu_physical_apicid);
+	physid_set_mask_of_physid(boot_cpu_physical_apicid,
+					 &phys_cpu_present_map);
 #endif
 	/* Make sure the irq descriptor is set up */
 	cfg = alloc_irq_and_cfg_at(0, 0);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index a0f52af..a25ce88 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1045,10 +1045,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 	init_apic_mappings();
-	ioapic_init_mappings();
-
-	/* need to wait for io_apic is mapped */
-	probe_nr_irqs_gsi();
+	ioapic_and_gsi_init();
 
 	kvm_guest_init();
 
diff --git a/arch/x86/mm/srat_32.c b/arch/x86/mm/srat_32.c
index a17dffd..f164345 100644
--- a/arch/x86/mm/srat_32.c
+++ b/arch/x86/mm/srat_32.c
@@ -92,6 +92,7 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *cpu_affinity)
 	/* mark this node as "seen" in node bitmap */
 	BMAP_SET(pxm_bitmap, cpu_affinity->proximity_domain_lo);
 
+	/* don't need to check apic_id here, because it is always 8 bits */
 	apicid_to_pxm[cpu_affinity->apic_id] = cpu_affinity->proximity_domain_lo;
 
 	printk(KERN_DEBUG "CPU %02x in proximity domain %02x\n",
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index a35cb9d..171a0aa 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -134,6 +134,10 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 	}
 
 	apic_id = pa->apic_id;
+	if (apic_id >= MAX_LOCAL_APIC) {
+		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
+		return;
+	}
 	apicid_to_node[apic_id] = node;
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
@@ -168,6 +172,12 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 		apic_id = (pa->apic_id << 8) | pa->local_sapic_eid;
 	else
 		apic_id = pa->apic_id;
+
+	if (apic_id >= MAX_LOCAL_APIC) {
+		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%02x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
+		return;
+	}
+
 	apicid_to_node[apic_id] = node;
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
diff --git a/arch/x86/platform/sfi/sfi.c b/arch/x86/platform/sfi/sfi.c
index dd4c281..ca54875 100644
--- a/arch/x86/platform/sfi/sfi.c
+++ b/arch/x86/platform/sfi/sfi.c
@@ -48,9 +48,9 @@ static void __init mp_sfi_register_lapic_address(unsigned long address)
 /* All CPUs enumerated by SFI must be present and enabled */
 static void __cpuinit mp_sfi_register_lapic(u8 id)
 {
-	if (MAX_APICS - id <= 0) {
+	if (MAX_LOCAL_APIC - id <= 0) {
 		pr_warning("Processor #%d invalid (max %d)\n",
-			id, MAX_APICS);
+			id, MAX_LOCAL_APIC);
 		return;
 	}
 
diff --git a/arch/x86/platform/visws/visws_quirks.c b/arch/x86/platform/visws/visws_quirks.c
index 3371bd0..6320376 100644
--- a/arch/x86/platform/visws/visws_quirks.c
+++ b/arch/x86/platform/visws/visws_quirks.c
@@ -171,7 +171,7 @@ static void __init MP_processor_info(struct mpc_cpu *m)
 	ver = m->apicver;
 	if ((ver >= 0x14 && m->apicid >= 0xff) || m->apicid >= 0xf) {
 		printk(KERN_ERR "Processor #%d INVALID. (Max ID: %d).\n",
-			m->apicid, MAX_APICS);
+			m->apicid, MAX_LOCAL_APIC);
 		return;
 	}
 
diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index 5718566..d9926af 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -275,13 +275,23 @@ acpi_table_parse_srat(enum acpi_srat_type id,
 int __init acpi_numa_init(void)
 {
 	int ret = 0;
+	int nr_cpu_entries = nr_cpu_ids;
+
+#ifdef CONFIG_X86
+	/*
+	 * Should not limit number with cpu num that is from NR_CPUS or nr_cpus=
+	 * SRAT cpu entries could have different order with that in MADT.
+	 * So go over all cpu entries in SRAT to get apicid to node mapping.
+	 */
+	nr_cpu_entries = MAX_LOCAL_APIC;
+#endif
 
 	/* SRAT: Static Resource Affinity Table */
 	if (!acpi_table_parse(ACPI_SIG_SRAT, acpi_parse_srat)) {
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY,
-				     acpi_parse_x2apic_affinity, nr_cpu_ids);
+				     acpi_parse_x2apic_affinity, nr_cpu_entries);
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
-				     acpi_parse_processor_affinity, nr_cpu_ids);
+				     acpi_parse_processor_affinity, nr_cpu_entries);
 		ret = acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
 					    acpi_parse_memory_affinity,
 					    NR_NODE_MEMBLKS);
