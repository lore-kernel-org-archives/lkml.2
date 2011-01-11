Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab1AKNuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 08:50:19 -0500
Received: from www.tglx.de ([62.245.132.106]:34858 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540Ab1AKNuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 08:50:17 -0500
Date: Tue, 11 Jan 2011 14:49:58 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] x86 updates for 2.6.38
Message-ID: <alpine.LFD.2.00.1101111448310.12146@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-urgent-for-linus


out-of-topic modifications in x86-urgent-for-linus:
---------------------------------------------------
include/linux/pci_ids.h            # ca86828: x86, AMD, PCI: Add AMD northbridg


Thanks,

	tglx

------------------>
Alek Du (1):
      x86/gpio: Implement x86 gpio_to_irq convert function

Arjan van de Ven (1):
      x86: Fix Moorestown VRTC fixmap placement

David Rientjes (6):
      x86, numa: Reduce minimum fake node size to 32M
      x86, numa: Avoid compiling NUMA emulation functions without CONFIG_NUMA_EMU
      x86, numa: Fake apicid and pxm mappings for NUMA emulation
      x86, numa: Fake node-to-cpumask for NUMA emulation
      x86, numa: Fix cpu to node mapping for sparse node ids
      x86, numa: Fix CONFIG_DEBUG_PER_CPU_MAPS without NUMA emulation

Jack Steiner (1):
      x86, UV: Fix APICID shift for Westmere processors

Jan Beulich (1):
      x86: Use PCI method for enabling AMD extended config space before MSR method

Pierre Tardy (1):
      x86, lapic-timer: Increase the max_delta to 31 bits

Randy Dunlap (1):
      x86: Fix sparse non-ANSI function warnings in smpboot.c

Robert Richter (1):
      x86, AMD, PCI: Add AMD northbridge PCI device id for CPU families 12h and 14h

Thomas Gleixner (1):
      x86: tsc: Prevent delayed init if initial tsc calibration failed


 arch/x86/include/asm/acpi.h        |   11 +--
 arch/x86/include/asm/amd_nb.h      |   13 +++-
 arch/x86/include/asm/fixmap.h      |    4 +-
 arch/x86/include/asm/gpio.h        |    5 +-
 arch/x86/include/asm/numa_64.h     |    2 +-
 arch/x86/kernel/amd_nb.c           |    7 ++
 arch/x86/kernel/aperture_64.c      |   44 ++++-------
 arch/x86/kernel/apic/apic.c        |    2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c |    2 +-
 arch/x86/kernel/smpboot.c          |    4 +-
 arch/x86/kernel/tsc.c              |    2 +-
 arch/x86/mm/amdtopology_64.c       |   86 ++++++++++++++++---
 arch/x86/mm/numa_64.c              |  157 ++++++++++++++++++++++++++++--------
 arch/x86/mm/srat_64.c              |   26 ++++--
 arch/x86/pci/amd_bus.c             |   33 ++++++++
 include/linux/pci_ids.h            |    1 +
 16 files changed, 297 insertions(+), 102 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 55d106b..211ca3f 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -185,17 +185,16 @@ struct bootnode;
 
 #ifdef CONFIG_ACPI_NUMA
 extern int acpi_numa;
-extern int acpi_get_nodes(struct bootnode *physnodes);
+extern void acpi_get_nodes(struct bootnode *physnodes, unsigned long start,
+				unsigned long end);
 extern int acpi_scan_nodes(unsigned long start, unsigned long end);
 #define NR_NODE_MEMBLKS (MAX_NUMNODES*2)
+
+#ifdef CONFIG_NUMA_EMU
 extern void acpi_fake_nodes(const struct bootnode *fake_nodes,
 				   int num_nodes);
-#else
-static inline void acpi_fake_nodes(const struct bootnode *fake_nodes,
-				   int num_nodes)
-{
-}
 #endif
+#endif /* CONFIG_ACPI_NUMA */
 
 #define acpi_unlazy_tlb(x)	leave_mm(x)
 
diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index 6aee50d..64dc82e 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -3,16 +3,27 @@
 
 #include <linux/pci.h>
 
+struct amd_nb_bus_dev_range {
+	u8 bus;
+	u8 dev_base;
+	u8 dev_limit;
+};
+
 extern struct pci_device_id amd_nb_misc_ids[];
+extern const struct amd_nb_bus_dev_range amd_nb_bus_dev_ranges[];
 struct bootnode;
 
 extern int early_is_amd_nb(u32 value);
 extern int amd_cache_northbridges(void);
 extern void amd_flush_garts(void);
-extern int amd_get_nodes(struct bootnode *nodes);
 extern int amd_numa_init(unsigned long start_pfn, unsigned long end_pfn);
 extern int amd_scan_nodes(void);
 
+#ifdef CONFIG_NUMA_EMU
+extern void amd_fake_nodes(const struct bootnode *nodes, int nr_nodes);
+extern void amd_get_nodes(struct bootnode *nodes);
+#endif
+
 struct amd_northbridge {
 	struct pci_dev *misc;
 };
diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 0141b23..4729b2b 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -116,11 +116,11 @@ enum fixed_addresses {
 #endif
 	FIX_TEXT_POKE1,	/* reserve 2 pages for text_poke() */
 	FIX_TEXT_POKE0, /* first page is last, because allocation is backward */
-	__end_of_permanent_fixed_addresses,
-
 #ifdef	CONFIG_X86_MRST
 	FIX_LNW_VRTC,
 #endif
+	__end_of_permanent_fixed_addresses,
+
 	/*
 	 * 256 temporary boot-time mappings, used by early_ioremap(),
 	 * before ioremap() is functional.
diff --git a/arch/x86/include/asm/gpio.h b/arch/x86/include/asm/gpio.h
index 49dbfdf..91d915a 100644
--- a/arch/x86/include/asm/gpio.h
+++ b/arch/x86/include/asm/gpio.h
@@ -38,12 +38,9 @@ static inline int gpio_cansleep(unsigned int gpio)
 	return __gpio_cansleep(gpio);
 }
 
-/*
- * Not implemented, yet.
- */
 static inline int gpio_to_irq(unsigned int gpio)
 {
-	return -ENOSYS;
+	return __gpio_to_irq(gpio);
 }
 
 static inline int irq_to_gpio(unsigned int irq)
diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index 823e070..5ae8728 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -38,7 +38,7 @@ extern void __cpuinit numa_add_cpu(int cpu);
 extern void __cpuinit numa_remove_cpu(int cpu);
 
 #ifdef CONFIG_NUMA_EMU
-#define FAKE_NODE_MIN_SIZE	((u64)64 << 20)
+#define FAKE_NODE_MIN_SIZE	((u64)32 << 20)
 #define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1UL))
 #endif /* CONFIG_NUMA_EMU */
 #else
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index affacb5..0a99f71 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -20,6 +20,13 @@ struct pci_device_id amd_nb_misc_ids[] = {
 };
 EXPORT_SYMBOL(amd_nb_misc_ids);
 
+const struct amd_nb_bus_dev_range amd_nb_bus_dev_ranges[] __initconst = {
+	{ 0x00, 0x18, 0x20 },
+	{ 0xff, 0x00, 0x20 },
+	{ 0xfe, 0x00, 0x20 },
+	{ }
+};
+
 struct amd_northbridge_info amd_northbridges;
 EXPORT_SYMBOL(amd_northbridges);
 
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index dcd7c83..5955a78 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -39,18 +39,6 @@ int fallback_aper_force __initdata;
 
 int fix_aperture __initdata = 1;
 
-struct bus_dev_range {
-	int bus;
-	int dev_base;
-	int dev_limit;
-};
-
-static struct bus_dev_range bus_dev_ranges[] __initdata = {
-	{ 0x00, 0x18, 0x20},
-	{ 0xff, 0x00, 0x20},
-	{ 0xfe, 0x00, 0x20}
-};
-
 static struct resource gart_resource = {
 	.name	= "GART",
 	.flags	= IORESOURCE_MEM,
@@ -294,13 +282,13 @@ void __init early_gart_iommu_check(void)
 	search_agp_bridge(&agp_aper_order, &valid_agp);
 
 	fix = 0;
-	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
+	for (i = 0; amd_nb_bus_dev_ranges[i].dev_limit; i++) {
 		int bus;
 		int dev_base, dev_limit;
 
-		bus = bus_dev_ranges[i].bus;
-		dev_base = bus_dev_ranges[i].dev_base;
-		dev_limit = bus_dev_ranges[i].dev_limit;
+		bus = amd_nb_bus_dev_ranges[i].bus;
+		dev_base = amd_nb_bus_dev_ranges[i].dev_base;
+		dev_limit = amd_nb_bus_dev_ranges[i].dev_limit;
 
 		for (slot = dev_base; slot < dev_limit; slot++) {
 			if (!early_is_amd_nb(read_pci_config(bus, slot, 3, 0x00)))
@@ -349,13 +337,13 @@ void __init early_gart_iommu_check(void)
 		return;
 
 	/* disable them all at first */
-	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
+	for (i = 0; i < amd_nb_bus_dev_ranges[i].dev_limit; i++) {
 		int bus;
 		int dev_base, dev_limit;
 
-		bus = bus_dev_ranges[i].bus;
-		dev_base = bus_dev_ranges[i].dev_base;
-		dev_limit = bus_dev_ranges[i].dev_limit;
+		bus = amd_nb_bus_dev_ranges[i].bus;
+		dev_base = amd_nb_bus_dev_ranges[i].dev_base;
+		dev_limit = amd_nb_bus_dev_ranges[i].dev_limit;
 
 		for (slot = dev_base; slot < dev_limit; slot++) {
 			if (!early_is_amd_nb(read_pci_config(bus, slot, 3, 0x00)))
@@ -390,14 +378,14 @@ int __init gart_iommu_hole_init(void)
 
 	fix = 0;
 	node = 0;
-	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
+	for (i = 0; i < amd_nb_bus_dev_ranges[i].dev_limit; i++) {
 		int bus;
 		int dev_base, dev_limit;
 		u32 ctl;
 
-		bus = bus_dev_ranges[i].bus;
-		dev_base = bus_dev_ranges[i].dev_base;
-		dev_limit = bus_dev_ranges[i].dev_limit;
+		bus = amd_nb_bus_dev_ranges[i].bus;
+		dev_base = amd_nb_bus_dev_ranges[i].dev_base;
+		dev_limit = amd_nb_bus_dev_ranges[i].dev_limit;
 
 		for (slot = dev_base; slot < dev_limit; slot++) {
 			if (!early_is_amd_nb(read_pci_config(bus, slot, 3, 0x00)))
@@ -505,7 +493,7 @@ out:
 	}
 
 	/* Fix up the north bridges */
-	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
+	for (i = 0; i < amd_nb_bus_dev_ranges[i].dev_limit; i++) {
 		int bus, dev_base, dev_limit;
 
 		/*
@@ -514,9 +502,9 @@ out:
 		 */
 		u32 ctl = DISTLBWALKPRB | aper_order << 1;
 
-		bus = bus_dev_ranges[i].bus;
-		dev_base = bus_dev_ranges[i].dev_base;
-		dev_limit = bus_dev_ranges[i].dev_limit;
+		bus = amd_nb_bus_dev_ranges[i].bus;
+		dev_base = amd_nb_bus_dev_ranges[i].dev_base;
+		dev_limit = amd_nb_bus_dev_ranges[i].dev_limit;
 		for (slot = dev_base; slot < dev_limit; slot++) {
 			if (!early_is_amd_nb(read_pci_config(bus, slot, 3, 0x00)))
 				continue;
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index ce65d44..1efd378 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -684,7 +684,7 @@ static int __init calibrate_APIC_clock(void)
 	lapic_clockevent.mult = div_sc(delta, TICK_NSEC * LAPIC_CAL_LOOPS,
 				       lapic_clockevent.shift);
 	lapic_clockevent.max_delta_ns =
-		clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
+		clockevent_delta2ns(0x7FFFFFFF, &lapic_clockevent);
 	lapic_clockevent.min_delta_ns =
 		clockevent_delta2ns(0xF, &lapic_clockevent);
 
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 2a3f2a7..f4f9e95 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -378,7 +378,7 @@ struct apic __refdata apic_x2apic_uv_x = {
 
 static __cpuinit void set_x2apic_extra_bits(int pnode)
 {
-	__get_cpu_var(x2apic_extra_bits) = (pnode << 6);
+	__get_cpu_var(x2apic_extra_bits) = (pnode << uvh_apicid.s.pnode_shift);
 }
 
 /*
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index ee886fe..5fdc095 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -97,12 +97,12 @@ static DEFINE_PER_CPU(struct task_struct *, idle_thread_array);
  */
 static DEFINE_MUTEX(x86_cpu_hotplug_driver_mutex);
 
-void cpu_hotplug_driver_lock()
+void cpu_hotplug_driver_lock(void)
 {
         mutex_lock(&x86_cpu_hotplug_driver_mutex);
 }
 
-void cpu_hotplug_driver_unlock()
+void cpu_hotplug_driver_unlock(void)
 {
         mutex_unlock(&x86_cpu_hotplug_driver_mutex);
 }
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 356a0d4..463901e 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -965,7 +965,7 @@ out:
 
 static int __init init_tsc_clocksource(void)
 {
-	if (!cpu_has_tsc || tsc_disabled > 0)
+	if (!cpu_has_tsc || tsc_disabled > 0 || !tsc_khz)
 		return 0;
 
 	if (tsc_clocksource_reliable)
diff --git a/arch/x86/mm/amdtopology_64.c b/arch/x86/mm/amdtopology_64.c
index 08a0069..f21962c 100644
--- a/arch/x86/mm/amdtopology_64.c
+++ b/arch/x86/mm/amdtopology_64.c
@@ -27,6 +27,7 @@
 #include <asm/amd_nb.h>
 
 static struct bootnode __initdata nodes[8];
+static unsigned char __initdata nodeids[8];
 static nodemask_t __initdata nodes_parsed = NODE_MASK_NONE;
 
 static __init int find_northbridge(void)
@@ -68,19 +69,6 @@ static __init void early_get_boot_cpu_id(void)
 #endif
 }
 
-int __init amd_get_nodes(struct bootnode *physnodes)
-{
-	int i;
-	int ret = 0;
-
-	for_each_node_mask(i, nodes_parsed) {
-		physnodes[ret].start = nodes[i].start;
-		physnodes[ret].end = nodes[i].end;
-		ret++;
-	}
-	return ret;
-}
-
 int __init amd_numa_init(unsigned long start_pfn, unsigned long end_pfn)
 {
 	unsigned long start = PFN_PHYS(start_pfn);
@@ -113,7 +101,7 @@ int __init amd_numa_init(unsigned long start_pfn, unsigned long end_pfn)
 		base = read_pci_config(0, nb, 1, 0x40 + i*8);
 		limit = read_pci_config(0, nb, 1, 0x44 + i*8);
 
-		nodeid = limit & 7;
+		nodeids[i] = nodeid = limit & 7;
 		if ((base & 3) == 0) {
 			if (i < numnodes)
 				pr_info("Skipping disabled node %d\n", i);
@@ -193,6 +181,76 @@ int __init amd_numa_init(unsigned long start_pfn, unsigned long end_pfn)
 	return 0;
 }
 
+#ifdef CONFIG_NUMA_EMU
+static s16 fake_apicid_to_node[MAX_LOCAL_APIC] __initdata = {
+	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
+};
+
+void __init amd_get_nodes(struct bootnode *physnodes)
+{
+	int i;
+
+	for_each_node_mask(i, nodes_parsed) {
+		physnodes[i].start = nodes[i].start;
+		physnodes[i].end = nodes[i].end;
+	}
+}
+
+static int __init find_node_by_addr(unsigned long addr)
+{
+	int ret = NUMA_NO_NODE;
+	int i;
+
+	for (i = 0; i < 8; i++)
+		if (addr >= nodes[i].start && addr < nodes[i].end) {
+			ret = i;
+			break;
+		}
+	return ret;
+}
+
+/*
+ * For NUMA emulation, fake proximity domain (_PXM) to node id mappings must be
+ * setup to represent the physical topology but reflect the emulated
+ * environment.  For each emulated node, the real node which it appears on is
+ * found and a fake pxm to nid mapping is created which mirrors the actual
+ * locality.  node_distance() then represents the correct distances between
+ * emulated nodes by using the fake acpi mappings to pxms.
+ */
+void __init amd_fake_nodes(const struct bootnode *nodes, int nr_nodes)
+{
+	unsigned int bits;
+	unsigned int cores;
+	unsigned int apicid_base = 0;
+	int i;
+
+	bits = boot_cpu_data.x86_coreid_bits;
+	cores = 1 << bits;
+	early_get_boot_cpu_id();
+	if (boot_cpu_physical_apicid > 0)
+		apicid_base = boot_cpu_physical_apicid;
+
+	for (i = 0; i < nr_nodes; i++) {
+		int index;
+		int nid;
+		int j;
+
+		nid = find_node_by_addr(nodes[i].start);
+		if (nid == NUMA_NO_NODE)
+			continue;
+
+		index = nodeids[nid] << bits;
+		if (fake_apicid_to_node[index + apicid_base] == NUMA_NO_NODE)
+			for (j = apicid_base; j < cores + apicid_base; j++)
+				fake_apicid_to_node[index + j] = i;
+#ifdef CONFIG_ACPI_NUMA
+		__acpi_map_pxm_to_node(nid, i);
+#endif
+	}
+	memcpy(apicid_to_node, fake_apicid_to_node, sizeof(apicid_to_node));
+}
+#endif /* CONFIG_NUMA_EMU */
+
 int __init amd_scan_nodes(void)
 {
 	unsigned int bits;
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 7762a51..1e72102 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -260,30 +260,30 @@ void __init numa_init_array(void)
 #ifdef CONFIG_NUMA_EMU
 /* Numa emulation */
 static struct bootnode nodes[MAX_NUMNODES] __initdata;
-static struct bootnode physnodes[MAX_NUMNODES] __initdata;
+static struct bootnode physnodes[MAX_NUMNODES] __cpuinitdata;
 static char *cmdline __initdata;
 
 static int __init setup_physnodes(unsigned long start, unsigned long end,
 					int acpi, int amd)
 {
-	int nr_nodes = 0;
 	int ret = 0;
 	int i;
 
+	memset(physnodes, 0, sizeof(physnodes));
 #ifdef CONFIG_ACPI_NUMA
 	if (acpi)
-		nr_nodes = acpi_get_nodes(physnodes);
+		acpi_get_nodes(physnodes, start, end);
 #endif
 #ifdef CONFIG_AMD_NUMA
 	if (amd)
-		nr_nodes = amd_get_nodes(physnodes);
+		amd_get_nodes(physnodes);
 #endif
 	/*
 	 * Basic sanity checking on the physical node map: there may be errors
 	 * if the SRAT or AMD code incorrectly reported the topology or the mem=
 	 * kernel parameter is used.
 	 */
-	for (i = 0; i < nr_nodes; i++) {
+	for (i = 0; i < MAX_NUMNODES; i++) {
 		if (physnodes[i].start == physnodes[i].end)
 			continue;
 		if (physnodes[i].start > end) {
@@ -298,17 +298,6 @@ static int __init setup_physnodes(unsigned long start, unsigned long end,
 			physnodes[i].start = start;
 		if (physnodes[i].end > end)
 			physnodes[i].end = end;
-	}
-
-	/*
-	 * Remove all nodes that have no memory or were truncated because of the
-	 * limited address range.
-	 */
-	for (i = 0; i < nr_nodes; i++) {
-		if (physnodes[i].start == physnodes[i].end)
-			continue;
-		physnodes[ret].start = physnodes[i].start;
-		physnodes[ret].end = physnodes[i].end;
 		ret++;
 	}
 
@@ -324,6 +313,24 @@ static int __init setup_physnodes(unsigned long start, unsigned long end,
 	return ret;
 }
 
+static void __init fake_physnodes(int acpi, int amd, int nr_nodes)
+{
+	int i;
+
+	BUG_ON(acpi && amd);
+#ifdef CONFIG_ACPI_NUMA
+	if (acpi)
+		acpi_fake_nodes(nodes, nr_nodes);
+#endif
+#ifdef CONFIG_AMD_NUMA
+	if (amd)
+		amd_fake_nodes(nodes, nr_nodes);
+#endif
+	if (!acpi && !amd)
+		for (i = 0; i < nr_cpu_ids; i++)
+			numa_set_node(i, 0);
+}
+
 /*
  * Setups up nid to range from addr to addr + size.  If the end
  * boundary is greater than max_addr, then max_addr is used instead.
@@ -352,8 +359,7 @@ static int __init setup_node_range(int nid, u64 *addr, u64 size, u64 max_addr)
  * Sets up nr_nodes fake nodes interleaved over physical nodes ranging from addr
  * to max_addr.  The return value is the number of nodes allocated.
  */
-static int __init split_nodes_interleave(u64 addr, u64 max_addr,
-						int nr_phys_nodes, int nr_nodes)
+static int __init split_nodes_interleave(u64 addr, u64 max_addr, int nr_nodes)
 {
 	nodemask_t physnode_mask = NODE_MASK_NONE;
 	u64 size;
@@ -384,7 +390,7 @@ static int __init split_nodes_interleave(u64 addr, u64 max_addr,
 		return -1;
 	}
 
-	for (i = 0; i < nr_phys_nodes; i++)
+	for (i = 0; i < MAX_NUMNODES; i++)
 		if (physnodes[i].start != physnodes[i].end)
 			node_set(i, physnode_mask);
 
@@ -553,11 +559,9 @@ static int __init numa_emulation(unsigned long start_pfn,
 {
 	u64 addr = start_pfn << PAGE_SHIFT;
 	u64 max_addr = last_pfn << PAGE_SHIFT;
-	int num_phys_nodes;
 	int num_nodes;
 	int i;
 
-	num_phys_nodes = setup_physnodes(addr, max_addr, acpi, amd);
 	/*
 	 * If the numa=fake command-line contains a 'M' or 'G', it represents
 	 * the fixed node size.  Otherwise, if it is just a single number N,
@@ -572,7 +576,7 @@ static int __init numa_emulation(unsigned long start_pfn,
 		unsigned long n;
 
 		n = simple_strtoul(cmdline, NULL, 0);
-		num_nodes = split_nodes_interleave(addr, max_addr, num_phys_nodes, n);
+		num_nodes = split_nodes_interleave(addr, max_addr, n);
 	}
 
 	if (num_nodes < 0)
@@ -595,7 +599,8 @@ static int __init numa_emulation(unsigned long start_pfn,
 						nodes[i].end >> PAGE_SHIFT);
 		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
 	}
-	acpi_fake_nodes(nodes, num_nodes);
+	setup_physnodes(addr, max_addr, acpi, amd);
+	fake_physnodes(acpi, amd, num_nodes);
 	numa_init_array();
 	return 0;
 }
@@ -610,8 +615,12 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
 	nodes_clear(node_online_map);
 
 #ifdef CONFIG_NUMA_EMU
+	setup_physnodes(start_pfn << PAGE_SHIFT, last_pfn << PAGE_SHIFT,
+			acpi, amd);
 	if (cmdline && !numa_emulation(start_pfn, last_pfn, acpi, amd))
 		return;
+	setup_physnodes(start_pfn << PAGE_SHIFT, last_pfn << PAGE_SHIFT,
+			acpi, amd);
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
 #endif
@@ -767,6 +776,7 @@ void __cpuinit numa_clear_node(int cpu)
 
 #ifndef CONFIG_DEBUG_PER_CPU_MAPS
 
+#ifndef CONFIG_NUMA_EMU
 void __cpuinit numa_add_cpu(int cpu)
 {
 	cpumask_set_cpu(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
@@ -776,34 +786,115 @@ void __cpuinit numa_remove_cpu(int cpu)
 {
 	cpumask_clear_cpu(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
 }
+#else
+void __cpuinit numa_add_cpu(int cpu)
+{
+	unsigned long addr;
+	u16 apicid;
+	int physnid;
+	int nid = NUMA_NO_NODE;
+
+	apicid = early_per_cpu(x86_cpu_to_apicid, cpu);
+	if (apicid != BAD_APICID)
+		nid = apicid_to_node[apicid];
+	if (nid == NUMA_NO_NODE)
+		nid = early_cpu_to_node(cpu);
+	BUG_ON(nid == NUMA_NO_NODE || !node_online(nid));
+
+	/*
+	 * Use the starting address of the emulated node to find which physical
+	 * node it is allocated on.
+	 */
+	addr = node_start_pfn(nid) << PAGE_SHIFT;
+	for (physnid = 0; physnid < MAX_NUMNODES; physnid++)
+		if (addr >= physnodes[physnid].start &&
+		    addr < physnodes[physnid].end)
+			break;
+
+	/*
+	 * Map the cpu to each emulated node that is allocated on the physical
+	 * node of the cpu's apic id.
+	 */
+	for_each_online_node(nid) {
+		addr = node_start_pfn(nid) << PAGE_SHIFT;
+		if (addr >= physnodes[physnid].start &&
+		    addr < physnodes[physnid].end)
+			cpumask_set_cpu(cpu, node_to_cpumask_map[nid]);
+	}
+}
+
+void __cpuinit numa_remove_cpu(int cpu)
+{
+	int i;
+
+	for_each_online_node(i)
+		cpumask_clear_cpu(cpu, node_to_cpumask_map[i]);
+}
+#endif /* !CONFIG_NUMA_EMU */
 
 #else /* CONFIG_DEBUG_PER_CPU_MAPS */
+static struct cpumask __cpuinit *debug_cpumask_set_cpu(int cpu, int enable)
+{
+	int node = early_cpu_to_node(cpu);
+	struct cpumask *mask;
+	char buf[64];
+
+	mask = node_to_cpumask_map[node];
+	if (!mask) {
+		pr_err("node_to_cpumask_map[%i] NULL\n", node);
+		dump_stack();
+		return NULL;
+	}
+
+	cpulist_scnprintf(buf, sizeof(buf), mask);
+	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
+		enable ? "numa_add_cpu" : "numa_remove_cpu",
+		cpu, node, buf);
+	return mask;
+}
 
 /*
  * --------- debug versions of the numa functions ---------
  */
+#ifndef CONFIG_NUMA_EMU
 static void __cpuinit numa_set_cpumask(int cpu, int enable)
 {
-	int node = early_cpu_to_node(cpu);
 	struct cpumask *mask;
-	char buf[64];
 
-	mask = node_to_cpumask_map[node];
-	if (mask == NULL) {
-		printk(KERN_ERR "node_to_cpumask_map[%i] NULL\n", node);
-		dump_stack();
+	mask = debug_cpumask_set_cpu(cpu, enable);
+	if (!mask)
 		return;
-	}
 
 	if (enable)
 		cpumask_set_cpu(cpu, mask);
 	else
 		cpumask_clear_cpu(cpu, mask);
+}
+#else
+static void __cpuinit numa_set_cpumask(int cpu, int enable)
+{
+	int node = early_cpu_to_node(cpu);
+	struct cpumask *mask;
+	int i;
 
-	cpulist_scnprintf(buf, sizeof(buf), mask);
-	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
-		enable ? "numa_add_cpu" : "numa_remove_cpu", cpu, node, buf);
+	for_each_online_node(i) {
+		unsigned long addr;
+
+		addr = node_start_pfn(i) << PAGE_SHIFT;
+		if (addr < physnodes[node].start ||
+					addr >= physnodes[node].end)
+			continue;
+		mask = debug_cpumask_set_cpu(cpu, enable);
+		if (!mask)
+			return;
+
+		if (enable)
+			cpumask_set_cpu(cpu, mask);
+		else
+			cpumask_clear_cpu(cpu, mask);
+	}
 }
+#endif /* CONFIG_NUMA_EMU */
 
 void __cpuinit numa_add_cpu(int cpu)
 {
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 171a0aa..603d285 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -349,18 +349,19 @@ static int __init nodes_cover_memory(const struct bootnode *nodes)
 
 void __init acpi_numa_arch_fixup(void) {}
 
-int __init acpi_get_nodes(struct bootnode *physnodes)
+#ifdef CONFIG_NUMA_EMU
+void __init acpi_get_nodes(struct bootnode *physnodes, unsigned long start,
+				unsigned long end)
 {
 	int i;
-	int ret = 0;
 
 	for_each_node_mask(i, nodes_parsed) {
-		physnodes[ret].start = nodes[i].start;
-		physnodes[ret].end = nodes[i].end;
-		ret++;
+		cutoff_node(i, start, end);
+		physnodes[i].start = nodes[i].start;
+		physnodes[i].end = nodes[i].end;
 	}
-	return ret;
 }
+#endif /* CONFIG_NUMA_EMU */
 
 /* Use the information discovered above to actually set up the nodes. */
 int __init acpi_scan_nodes(unsigned long start, unsigned long end)
@@ -505,8 +506,6 @@ void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
 {
 	int i, j;
 
-	printk(KERN_INFO "Faking PXM affinity for fake nodes on real "
-			 "topology.\n");
 	for (i = 0; i < num_nodes; i++) {
 		int nid, pxm;
 
@@ -526,6 +525,17 @@ void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
 			    fake_apicid_to_node[j] == NUMA_NO_NODE)
 				fake_apicid_to_node[j] = i;
 	}
+
+	/*
+	 * If there are apicid-to-node mappings for physical nodes that do not
+	 * have a corresponding emulated node, it should default to a guaranteed
+	 * value.
+	 */
+	for (i = 0; i < MAX_LOCAL_APIC; i++)
+		if (apicid_to_node[i] != NUMA_NO_NODE &&
+		    fake_apicid_to_node[i] == NUMA_NO_NODE)
+			fake_apicid_to_node[i] = 0;
+
 	for (i = 0; i < num_nodes; i++)
 		__acpi_map_pxm_to_node(fake_node_to_pxm_map[i], i);
 	memcpy(apicid_to_node, fake_apicid_to_node, sizeof(apicid_to_node));
diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index fc1e8fe..e27dffb 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -4,6 +4,7 @@
 #include <linux/cpu.h>
 #include <linux/range.h>
 
+#include <asm/amd_nb.h>
 #include <asm/pci_x86.h>
 
 #include <asm/pci-direct.h>
@@ -378,6 +379,34 @@ static struct notifier_block __cpuinitdata amd_cpu_notifier = {
 	.notifier_call	= amd_cpu_notify,
 };
 
+static void __init pci_enable_pci_io_ecs(void)
+{
+#ifdef CONFIG_AMD_NB
+	unsigned int i, n;
+
+	for (n = i = 0; !n && amd_nb_bus_dev_ranges[i].dev_limit; ++i) {
+		u8 bus = amd_nb_bus_dev_ranges[i].bus;
+		u8 slot = amd_nb_bus_dev_ranges[i].dev_base;
+		u8 limit = amd_nb_bus_dev_ranges[i].dev_limit;
+
+		for (; slot < limit; ++slot) {
+			u32 val = read_pci_config(bus, slot, 3, 0);
+
+			if (!early_is_amd_nb(val))
+				continue;
+
+			val = read_pci_config(bus, slot, 3, 0x8c);
+			if (!(val & (ENABLE_CF8_EXT_CFG >> 32))) {
+				val |= ENABLE_CF8_EXT_CFG >> 32;
+				write_pci_config(bus, slot, 3, 0x8c, val);
+			}
+			++n;
+		}
+	}
+	pr_info("Extended Config Space enabled on %u nodes\n", n);
+#endif
+}
+
 static int __init pci_io_ecs_init(void)
 {
 	int cpu;
@@ -386,6 +415,10 @@ static int __init pci_io_ecs_init(void)
         if (boot_cpu_data.x86 < 0x10)
 		return 0;
 
+	/* Try the PCI method first. */
+	if (early_pci_allowed())
+		pci_enable_pci_io_ecs();
+
 	register_cpu_notifier(&amd_cpu_notifier);
 	for_each_online_cpu(cpu)
 		amd_cpu_notify(&amd_cpu_notifier, (unsigned long)CPU_ONLINE,
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index cb845c1..dd7d4e2 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -518,6 +518,7 @@
 #define PCI_DEVICE_ID_AMD_11H_NB_MISC	0x1303
 #define PCI_DEVICE_ID_AMD_11H_NB_LINK	0x1304
 #define PCI_DEVICE_ID_AMD_15H_NB_MISC	0x1603
+#define PCI_DEVICE_ID_AMD_CNB17H_F3	0x1703
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
 #define PCI_DEVICE_ID_AMD_SCSI		0x2020
