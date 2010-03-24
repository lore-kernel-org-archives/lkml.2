Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab0CXKkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 06:40:41 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:25857 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab0CXKkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 06:40:39 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 5/8] x86: use lmb to replace early_res
Date: Wed, 24 Mar 2010 03:37:06 -0700
Message-Id: <1269427029-21000-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269427029-21000-1-git-send-email-yinghai@kernel.org>
References: <1269427029-21000-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4BA9EC00.0137,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

still keep kernel/early_res.c for the extension.

should move those file to lib/lmb.c later?

in early_res.c
1. change find_e820_area_xxx, to find_lmb_area_xxx
2. e820_register_active_regions to lmb_register_active_regions.
3. reserve_early will call lmb_reserve directly.
4. free_early will call lmb_free directly.
5. remove functions that are used by old reserve_early and free_early
6. get_free_all_memory_range use lmb.reserved.
7. early_res_to_bootmem use lmb.reserved
8. add fill_lmb_memory() to fill lmb.memory according e820 RAM entries

-v2: fix NO_BOOTMEM hang with printk
-v4: add add_lmb_memory that could increase lmb.memory.region size
     change region_array_size to nr_regions
     make sure some find_lmb_area<_size> are called after fill_lmb_memory

todo:
1. make early_memtest to depend on early_res. and move it to mm/
2. make all lmb user to use extend early_res/nobootmem
3. merge lmb.c and early_res.c, move it to mm/
4. make other platform to use lmb/early_res/nobootmem
5. remove BOOTMEM related code

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/Kconfig               |    1 +
 arch/x86/include/asm/e820.h    |   38 ++-
 arch/x86/include/asm/lmb.h     |    8 +
 arch/x86/kernel/check.c        |   14 +-
 arch/x86/kernel/e820.c         |  171 ++---------
 arch/x86/kernel/head.c         |    2 +-
 arch/x86/kernel/head32.c       |    5 +-
 arch/x86/kernel/head64.c       |    2 +
 arch/x86/kernel/setup.c        |    9 +-
 arch/x86/kernel/setup_percpu.c |    6 -
 arch/x86/mm/memtest.c          |    5 +-
 arch/x86/mm/numa_64.c          |    4 +-
 include/linux/early_res.h      |   19 +-
 kernel/early_res.c             |  631 ++++++++++++++++------------------------
 mm/page_alloc.c                |    2 +-
 mm/sparse-vmemmap.c            |   11 -
 16 files changed, 344 insertions(+), 584 deletions(-)
 create mode 100644 arch/x86/include/asm/lmb.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6a80bce..585f611 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -27,6 +27,7 @@ config X86
 	select HAVE_PERF_EVENTS if (!M386 && !M486)
 	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
+	select HAVE_LMB
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_WANT_FRAME_POINTERS
 	select HAVE_DMA_ATTRS
diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 01bc987..e957101 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -111,24 +111,30 @@ static inline void early_memtest(unsigned long start, unsigned long end)
 }
 #endif
 
-extern unsigned long end_user_pfn;
-
-extern u64 find_e820_area(u64 start, u64 end, u64 size, u64 align);
-extern u64 find_e820_area_size(u64 start, u64 *sizep, u64 align);
-u64 find_e820_area_node(int nid, u64 start, u64 end, u64 size, u64 align);
-extern u64 early_reserve_e820(u64 startt, u64 sizet, u64 align);
-#include <linux/early_res.h>
-
 extern unsigned long e820_end_of_ram_pfn(void);
 extern unsigned long e820_end_of_low_ram_pfn(void);
-extern int e820_find_active_region(const struct e820entry *ei,
-				  unsigned long start_pfn,
-				  unsigned long last_pfn,
-				  unsigned long *ei_startpfn,
-				  unsigned long *ei_endpfn);
-extern void e820_register_active_regions(int nid, unsigned long start_pfn,
-					 unsigned long end_pfn);
-extern u64 e820_hole_size(u64 start, u64 end);
+#include <linux/early_res.h>
+extern u64 early_reserve_e820(u64 startt, u64 sizet, u64 align);
+
+/*
+ * next three functions will be removed, esp find_e820_area()
+ * can not be used before fill_lmb_memory()
+ */
+static inline u64 find_e820_area(u64 start, u64 end, u64 size, u64 align)
+{
+	return find_lmb_area(start, end, size, align);
+}
+static inline void e820_register_active_regions(int nid, unsigned long start_pfn, unsigned long end_pfn)
+{
+	lmb_register_active_regions(nid, start_pfn, end_pfn);
+}
+static inline u64 e820_hole_size(u64 start, u64 end)
+{
+	return lmb_hole_size(start, end);
+}
+
+void init_lmb_memory(void);
+void fill_lmb_memory(void);
 extern void finish_e820_parsing(void);
 extern void e820_reserve_resources(void);
 extern void e820_reserve_resources_late(void);
diff --git a/arch/x86/include/asm/lmb.h b/arch/x86/include/asm/lmb.h
new file mode 100644
index 0000000..d8fbdbd
--- /dev/null
+++ b/arch/x86/include/asm/lmb.h
@@ -0,0 +1,8 @@
+#ifndef _X86_LMB_H
+#define _X86_LMB_H
+
+#define LMB_DBG(fmt...) printk(fmt)
+
+#define LMB_REAL_LIMIT	0
+
+#endif
diff --git a/arch/x86/kernel/check.c b/arch/x86/kernel/check.c
index fc999e6..e16952b 100644
--- a/arch/x86/kernel/check.c
+++ b/arch/x86/kernel/check.c
@@ -2,7 +2,8 @@
 #include <linux/sched.h>
 #include <linux/kthread.h>
 #include <linux/workqueue.h>
-#include <asm/e820.h>
+#include <linux/early_res.h>
+
 #include <asm/proto.h>
 
 /*
@@ -18,10 +19,12 @@ static int __read_mostly memory_corruption_check = -1;
 static unsigned __read_mostly corruption_check_size = 64*1024;
 static unsigned __read_mostly corruption_check_period = 60; /* seconds */
 
-static struct e820entry scan_areas[MAX_SCAN_AREAS];
+static struct scan_area {
+	u64 addr;
+	u64 size;
+} scan_areas[MAX_SCAN_AREAS];
 static int num_scan_areas;
 
-
 static __init int set_corruption_check(char *arg)
 {
 	char *end;
@@ -81,7 +84,7 @@ void __init setup_bios_corruption_check(void)
 
 	while (addr < corruption_check_size && num_scan_areas < MAX_SCAN_AREAS) {
 		u64 size;
-		addr = find_e820_area_size(addr, &size, PAGE_SIZE);
+		addr = find_lmb_area_size(addr, &size, PAGE_SIZE);
 
 		if (!(addr + 1))
 			break;
@@ -92,7 +95,7 @@ void __init setup_bios_corruption_check(void)
 		if ((addr + size) > corruption_check_size)
 			size = corruption_check_size - addr;
 
-		e820_update_range(addr, size, E820_RAM, E820_RESERVED);
+		reserve_early(addr, addr + size, "SCAN RAM");
 		scan_areas[num_scan_areas].addr = addr;
 		scan_areas[num_scan_areas].size = size;
 		num_scan_areas++;
@@ -105,7 +108,6 @@ void __init setup_bios_corruption_check(void)
 
 	printk(KERN_INFO "Scanning %d areas for low memory corruption\n",
 	       num_scan_areas);
-	update_e820();
 }
 
 
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 0c7143b..8381b1b 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -15,6 +15,7 @@
 #include <linux/pfn.h>
 #include <linux/suspend.h>
 #include <linux/firmware-map.h>
+#include <linux/lmb.h>
 
 #include <asm/e820.h>
 #include <asm/proto.h>
@@ -726,37 +727,6 @@ static int __init e820_mark_nvs_memory(void)
 core_initcall(e820_mark_nvs_memory);
 #endif
 
-/*
- * Find a free area with specified alignment in a specific range.
- */
-u64 __init find_e820_area(u64 start, u64 end, u64 size, u64 align)
-{
-	int i;
-
-	for (i = 0; i < e820.nr_map; i++) {
-		struct e820entry *ei = &e820.map[i];
-		u64 addr;
-		u64 ei_start, ei_last;
-
-		if (ei->type != E820_RAM)
-			continue;
-
-		ei_last = ei->addr + ei->size;
-		ei_start = ei->addr;
-		addr = find_early_area(ei_start, ei_last, start, end,
-					 size, align);
-
-		if (addr != -1ULL)
-			return addr;
-	}
-	return -1ULL;
-}
-
-u64 __init find_fw_memmap_area(u64 start, u64 end, u64 size, u64 align)
-{
-	return find_e820_area(start, end, size, align);
-}
-
 u64 __init get_max_mapped(void)
 {
 	u64 end = max_pfn_mapped;
@@ -765,50 +735,9 @@ u64 __init get_max_mapped(void)
 
 	return end;
 }
-/*
- * Find next free range after *start
- */
-u64 __init find_e820_area_size(u64 start, u64 *sizep, u64 align)
-{
-	int i;
-
-	for (i = 0; i < e820.nr_map; i++) {
-		struct e820entry *ei = &e820.map[i];
-		u64 addr;
-		u64 ei_start, ei_last;
-
-		if (ei->type != E820_RAM)
-			continue;
-
-		ei_last = ei->addr + ei->size;
-		ei_start = ei->addr;
-		addr = find_early_area_size(ei_start, ei_last, start,
-					 sizep, align);
-
-		if (addr != -1ULL)
-			return addr;
-	}
-
-	return -1ULL;
-}
-
-u64 __init find_e820_area_node(int nid, u64 start, u64 end, u64 size, u64 align)
-{
-	u64 addr;
-	/*
-	 * need to call this function after e820_register_active_regions
-	 * so early_node_map[] is set
-	 */
-	addr = find_memory_core_early(nid, size, align, start, end);
-	if (addr != -1ULL)
-		return addr;
-
-	/* fallback, should already have start end in the node range */
-	return find_e820_area(start, end, size, align);
-}
 
 /*
- * pre allocated 4k and reserved it in e820
+ * pre allocated 4k and reserved it in lmb and e820_saved
  */
 u64 __init early_reserve_e820(u64 startt, u64 sizet, u64 align)
 {
@@ -817,7 +746,7 @@ u64 __init early_reserve_e820(u64 startt, u64 sizet, u64 align)
 	u64 start;
 
 	for (start = startt; ; start += size) {
-		start = find_e820_area_size(start, &size, align);
+		start = find_lmb_area_size(start, &size, align);
 		if (!(start + 1))
 			return 0;
 		if (size >= sizet)
@@ -834,10 +763,9 @@ u64 __init early_reserve_e820(u64 startt, u64 sizet, u64 align)
 	addr = round_down(start + size - sizet, align);
 	if (addr < start)
 		return 0;
-	e820_update_range(addr, sizet, E820_RAM, E820_RESERVED);
+	reserve_early(addr, addr + sizet, "new next");
 	e820_update_range_saved(addr, sizet, E820_RAM, E820_RESERVED);
-	printk(KERN_INFO "update e820 for early_reserve_e820\n");
-	update_e820();
+	printk(KERN_INFO "update e820_saved for early_reserve_e820\n");
 	update_e820_saved();
 
 	return addr;
@@ -899,74 +827,6 @@ unsigned long __init e820_end_of_low_ram_pfn(void)
 {
 	return e820_end_pfn(1UL<<(32 - PAGE_SHIFT), E820_RAM);
 }
-/*
- * Finds an active region in the address range from start_pfn to last_pfn and
- * returns its range in ei_startpfn and ei_endpfn for the e820 entry.
- */
-int __init e820_find_active_region(const struct e820entry *ei,
-				  unsigned long start_pfn,
-				  unsigned long last_pfn,
-				  unsigned long *ei_startpfn,
-				  unsigned long *ei_endpfn)
-{
-	u64 align = PAGE_SIZE;
-
-	*ei_startpfn = round_up(ei->addr, align) >> PAGE_SHIFT;
-	*ei_endpfn = round_down(ei->addr + ei->size, align) >> PAGE_SHIFT;
-
-	/* Skip map entries smaller than a page */
-	if (*ei_startpfn >= *ei_endpfn)
-		return 0;
-
-	/* Skip if map is outside the node */
-	if (ei->type != E820_RAM || *ei_endpfn <= start_pfn ||
-				    *ei_startpfn >= last_pfn)
-		return 0;
-
-	/* Check for overlaps */
-	if (*ei_startpfn < start_pfn)
-		*ei_startpfn = start_pfn;
-	if (*ei_endpfn > last_pfn)
-		*ei_endpfn = last_pfn;
-
-	return 1;
-}
-
-/* Walk the e820 map and register active regions within a node */
-void __init e820_register_active_regions(int nid, unsigned long start_pfn,
-					 unsigned long last_pfn)
-{
-	unsigned long ei_startpfn;
-	unsigned long ei_endpfn;
-	int i;
-
-	for (i = 0; i < e820.nr_map; i++)
-		if (e820_find_active_region(&e820.map[i],
-					    start_pfn, last_pfn,
-					    &ei_startpfn, &ei_endpfn))
-			add_active_range(nid, ei_startpfn, ei_endpfn);
-}
-
-/*
- * Find the hole size (in bytes) in the memory range.
- * @start: starting address of the memory range to scan
- * @end: ending address of the memory range to scan
- */
-u64 __init e820_hole_size(u64 start, u64 end)
-{
-	unsigned long start_pfn = start >> PAGE_SHIFT;
-	unsigned long last_pfn = end >> PAGE_SHIFT;
-	unsigned long ei_startpfn, ei_endpfn, ram = 0;
-	int i;
-
-	for (i = 0; i < e820.nr_map; i++) {
-		if (e820_find_active_region(&e820.map[i],
-					    start_pfn, last_pfn,
-					    &ei_startpfn, &ei_endpfn))
-			ram += ei_endpfn - ei_startpfn;
-	}
-	return end - start - ((u64)ram << PAGE_SHIFT);
-}
 
 static void early_panic(char *msg)
 {
@@ -1219,3 +1079,24 @@ void __init setup_memory_map(void)
 	printk(KERN_INFO "BIOS-provided physical RAM map:\n");
 	e820_print_map(who);
 }
+
+void __init init_lmb_memory(void)
+{
+	lmb_init();
+}
+
+void __init fill_lmb_memory(void)
+{
+	int i;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+
+		if (ei->type != E820_RAM)
+			continue;
+		add_lmb_memory(ei->addr, ei->addr + ei->size);
+	}
+
+	lmb_analyze();
+	lmb_dump_all();
+}
diff --git a/arch/x86/kernel/head.c b/arch/x86/kernel/head.c
index 3e66bd3..e0d0ce5 100644
--- a/arch/x86/kernel/head.c
+++ b/arch/x86/kernel/head.c
@@ -51,5 +51,5 @@ void __init reserve_ebda_region(void)
 		lowmem = 0x9f000;
 
 	/* reserve all memory between lowmem and the 1MB mark */
-	reserve_early_overlap_ok(lowmem, 0x100000, "BIOS reserved");
+	reserve_early(lowmem, 0x100000, "BIOS reserved");
 }
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index adedeef..8983422 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -29,14 +29,15 @@ static void __init i386_default_early_setup(void)
 
 void __init i386_start_kernel(void)
 {
+	init_lmb_memory();
+
 #ifdef CONFIG_X86_TRAMPOLINE
 	/*
 	 * But first pinch a few for the stack/trampoline stuff
 	 * FIXME: Don't need the extra page at 4K, but need to fix
 	 * trampoline before removing it. (see the GDT stuff)
 	 */
-	reserve_early_overlap_ok(PAGE_SIZE, PAGE_SIZE + PAGE_SIZE,
-					 "EX TRAMPOLINE");
+	reserve_early(PAGE_SIZE, PAGE_SIZE + PAGE_SIZE, "EX TRAMPOLINE");
 #endif
 
 	reserve_early(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index b5a9896..86e6a9b 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -96,6 +96,8 @@ void __init x86_64_start_kernel(char * real_mode_data)
 
 void __init x86_64_start_reservations(char *real_mode_data)
 {
+	init_lmb_memory();
+
 	copy_bootdata(__va(real_mode_data));
 
 	reserve_early(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 3787a82..a9e99e6 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -868,8 +868,6 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	max_pfn = e820_end_of_ram_pfn();
 
-	/* preallocate 4k for mptable mpc */
-	early_reserve_e820_mpc_new();
 	/* update e820 for memory not covered by WB MTRRs */
 	mtrr_bp_init();
 	if (mtrr_trim_uncached_memory(max_pfn))
@@ -894,6 +892,11 @@ void __init setup_arch(char **cmdline_p)
 	max_pfn_mapped = KERNEL_IMAGE_SIZE >> PAGE_SHIFT;
 #endif
 
+	fill_lmb_memory();
+
+	/* preallocate 4k for mptable mpc */
+	early_reserve_e820_mpc_new();
+
 #ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
 	setup_bios_corruption_check();
 #endif
@@ -970,7 +973,7 @@ void __init setup_arch(char **cmdline_p)
 
 	initmem_init(0, max_pfn, acpi, k8);
 #ifndef CONFIG_NO_BOOTMEM
-	early_res_to_bootmem(0, max_low_pfn<<PAGE_SHIFT);
+	lmb_reserved_to_bootmem(0, max_low_pfn<<PAGE_SHIFT);
 #endif
 
 	dma32_reserve_bootmem();
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index ef6370b..35abcb8 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -137,13 +137,7 @@ static void * __init pcpu_fc_alloc(unsigned int cpu, size_t size, size_t align)
 
 static void __init pcpu_fc_free(void *ptr, size_t size)
 {
-#ifdef CONFIG_NO_BOOTMEM
-	u64 start = __pa(ptr);
-	u64 end = start + size;
-	free_early_partial(start, end);
-#else
 	free_bootmem(__pa(ptr), size);
-#endif
 }
 
 static int __init pcpu_cpu_distance(unsigned int from, unsigned int to)
diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index 18d244f..216f832 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -6,8 +6,7 @@
 #include <linux/smp.h>
 #include <linux/init.h>
 #include <linux/pfn.h>
-
-#include <asm/e820.h>
+#include <linux/early_res.h>
 
 static u64 patterns[] __initdata = {
 	0,
@@ -74,7 +73,7 @@ static void __init do_one_pass(u64 pattern, u64 start, u64 end)
 	u64 size = 0;
 
 	while (start < end) {
-		start = find_e820_area_size(start, &size, 1);
+		start = find_lmb_area_size(start, &size, 1);
 
 		/* done ? */
 		if (start >= end)
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index ffc5ad5..45ac950 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -174,7 +174,7 @@ static void * __init early_node_mem(int nodeid, unsigned long start,
 	if (start < (MAX_DMA32_PFN<<PAGE_SHIFT) &&
 	    end > (MAX_DMA32_PFN<<PAGE_SHIFT))
 		start = MAX_DMA32_PFN<<PAGE_SHIFT;
-	mem = find_e820_area_node(nodeid, start, end, size, align);
+	mem = find_lmb_area_node(nodeid, start, end, size, align);
 	if (mem != -1L)
 		return __va(mem);
 
@@ -184,7 +184,7 @@ static void * __init early_node_mem(int nodeid, unsigned long start,
 		start = MAX_DMA32_PFN<<PAGE_SHIFT;
 	else
 		start = MAX_DMA_PFN<<PAGE_SHIFT;
-	mem = find_e820_area_node(nodeid, start, end, size, align);
+	mem = find_lmb_area_node(nodeid, start, end, size, align);
 	if (mem != -1L)
 		return __va(mem);
 
diff --git a/include/linux/early_res.h b/include/linux/early_res.h
index 29c09f5..4fac619 100644
--- a/include/linux/early_res.h
+++ b/include/linux/early_res.h
@@ -3,19 +3,22 @@
 #ifdef __KERNEL__
 
 extern void reserve_early(u64 start, u64 end, char *name);
-extern void reserve_early_overlap_ok(u64 start, u64 end, char *name);
 extern void free_early(u64 start, u64 end);
-void free_early_partial(u64 start, u64 end);
-extern void early_res_to_bootmem(u64 start, u64 end);
+void lmb_reserved_to_bootmem(u64 start, u64 end);
 
-void reserve_early_without_check(u64 start, u64 end, char *name);
 u64 find_early_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
 			 u64 size, u64 align);
-u64 find_early_area_size(u64 ei_start, u64 ei_last, u64 start,
-			 u64 *sizep, u64 align);
-u64 find_fw_memmap_area(u64 start, u64 end, u64 size, u64 align);
+
+void add_lmb_memory(u64 start, u64 end);
+
+u64 find_lmb_area(u64 start, u64 end, u64 size, u64 align);
+u64 find_lmb_area_size(u64 start, u64 *sizep, u64 align);
+u64 find_lmb_area_node(int nid, u64 start, u64 end, u64 size, u64 align);
+void lmb_register_active_regions(int nid, unsigned long start_pfn,
+					 unsigned long last_pfn);
+u64 lmb_hole_size(u64 start, u64 end);
 u64 get_max_mapped(void);
-#include <linux/range.h>
+struct range;
 int get_free_all_memory_range(struct range **rangep, int nodeid);
 
 #endif /* __KERNEL__ */
diff --git a/kernel/early_res.c b/kernel/early_res.c
index 69bed5b..a793393 100644
--- a/kernel/early_res.c
+++ b/kernel/early_res.c
@@ -6,404 +6,140 @@
 #include <linux/init.h>
 #include <linux/bootmem.h>
 #include <linux/mm.h>
+#include <linux/lmb.h>
+#include <linux/range.h>
 #include <linux/early_res.h>
 
 /*
  * Early reserved memory areas.
  */
-/*
- * need to make sure this one is bigger enough before
- * find_fw_memmap_area could be used
- */
-#define MAX_EARLY_RES_X 32
-
-struct early_res {
-	u64 start, end;
-	char name[15];
-	char overlap_ok;
-};
-static struct early_res early_res_x[MAX_EARLY_RES_X] __initdata;
-
-static int max_early_res __initdata = MAX_EARLY_RES_X;
-static struct early_res *early_res __initdata = &early_res_x[0];
-static int early_res_count __initdata;
-
-static int __init find_overlapped_early(u64 start, u64 end)
-{
-	int i;
-	struct early_res *r;
-
-	for (i = 0; i < max_early_res && early_res[i].end; i++) {
-		r = &early_res[i];
-		if (end > r->start && start < r->end)
-			break;
-	}
 
-	return i;
-}
-
-/*
- * Drop the i-th range from the early reservation map,
- * by copying any higher ranges down one over it, and
- * clearing what had been the last slot.
- */
-static void __init drop_range(int i)
-{
-	int j;
-
-	for (j = i + 1; j < max_early_res && early_res[j].end; j++)
-		;
-
-	memmove(&early_res[i], &early_res[i + 1],
-	       (j - 1 - i) * sizeof(struct early_res));
-
-	early_res[j - 1].end = 0;
-	early_res_count--;
-}
-
-static void __init drop_range_partial(int i, u64 start, u64 end)
-{
-	u64 common_start, common_end;
-	u64 old_start, old_end;
-
-	old_start = early_res[i].start;
-	old_end = early_res[i].end;
-	common_start = max(old_start, start);
-	common_end = min(old_end, end);
-
-	/* no overlap ? */
-	if (common_start >= common_end)
-		return;
-
-	if (old_start < common_start) {
-		/* make head segment */
-		early_res[i].end = common_start;
-		if (old_end > common_end) {
-			char name[15];
-
-			/*
-			 * Save a local copy of the name, since the
-			 * early_res array could get resized inside
-			 * reserve_early_without_check() ->
-			 * __check_and_double_early_res(), which would
-			 * make the current name pointer invalid.
-			 */
-			strncpy(name, early_res[i].name,
-					 sizeof(early_res[i].name) - 1);
-			/* add another for left over on tail */
-			reserve_early_without_check(common_end, old_end, name);
-		}
-		return;
-	} else {
-		if (old_end > common_end) {
-			/* reuse the entry for tail left */
-			early_res[i].start = common_end;
-			return;
-		}
-		/* all covered */
-		drop_range(i);
-	}
-}
-
-/*
- * Split any existing ranges that:
- *  1) are marked 'overlap_ok', and
- *  2) overlap with the stated range [start, end)
- * into whatever portion (if any) of the existing range is entirely
- * below or entirely above the stated range.  Drop the portion
- * of the existing range that overlaps with the stated range,
- * which will allow the caller of this routine to then add that
- * stated range without conflicting with any existing range.
- */
-static void __init drop_overlaps_that_are_ok(u64 start, u64 end)
-{
-	int i;
-	struct early_res *r;
-	u64 lower_start, lower_end;
-	u64 upper_start, upper_end;
-	char name[15];
-
-	for (i = 0; i < max_early_res && early_res[i].end; i++) {
-		r = &early_res[i];
-
-		/* Continue past non-overlapping ranges */
-		if (end <= r->start || start >= r->end)
-			continue;
-
-		/*
-		 * Leave non-ok overlaps as is; let caller
-		 * panic "Overlapping early reservations"
-		 * when it hits this overlap.
-		 */
-		if (!r->overlap_ok)
-			return;
-
-		/*
-		 * We have an ok overlap.  We will drop it from the early
-		 * reservation map, and add back in any non-overlapping
-		 * portions (lower or upper) as separate, overlap_ok,
-		 * non-overlapping ranges.
-		 */
-
-		/* 1. Note any non-overlapping (lower or upper) ranges. */
-		strncpy(name, r->name, sizeof(name) - 1);
-
-		lower_start = lower_end = 0;
-		upper_start = upper_end = 0;
-		if (r->start < start) {
-			lower_start = r->start;
-			lower_end = start;
-		}
-		if (r->end > end) {
-			upper_start = end;
-			upper_end = r->end;
-		}
-
-		/* 2. Drop the original ok overlapping range */
-		drop_range(i);
-
-		i--;		/* resume for-loop on copied down entry */
-
-		/* 3. Add back in any non-overlapping ranges. */
-		if (lower_end)
-			reserve_early_overlap_ok(lower_start, lower_end, name);
-		if (upper_end)
-			reserve_early_overlap_ok(upper_start, upper_end, name);
-	}
-}
-
-static void __init __reserve_early(u64 start, u64 end, char *name,
-						int overlap_ok)
-{
-	int i;
-	struct early_res *r;
-
-	i = find_overlapped_early(start, end);
-	if (i >= max_early_res)
-		panic("Too many early reservations");
-	r = &early_res[i];
-	if (r->end)
-		panic("Overlapping early reservations "
-		      "%llx-%llx %s to %llx-%llx %s\n",
-		      start, end - 1, name ? name : "", r->start,
-		      r->end - 1, r->name);
-	r->start = start;
-	r->end = end;
-	r->overlap_ok = overlap_ok;
-	if (name)
-		strncpy(r->name, name, sizeof(r->name) - 1);
-	early_res_count++;
-}
-
-/*
- * A few early reservtations come here.
- *
- * The 'overlap_ok' in the name of this routine does -not- mean it
- * is ok for these reservations to overlap an earlier reservation.
- * Rather it means that it is ok for subsequent reservations to
- * overlap this one.
- *
- * Use this entry point to reserve early ranges when you are doing
- * so out of "Paranoia", reserving perhaps more memory than you need,
- * just in case, and don't mind a subsequent overlapping reservation
- * that is known to be needed.
- *
- * The drop_overlaps_that_are_ok() call here isn't really needed.
- * It would be needed if we had two colliding 'overlap_ok'
- * reservations, so that the second such would not panic on the
- * overlap with the first.  We don't have any such as of this
- * writing, but might as well tolerate such if it happens in
- * the future.
- */
-void __init reserve_early_overlap_ok(u64 start, u64 end, char *name)
-{
-	drop_overlaps_that_are_ok(start, end);
-	__reserve_early(start, end, name, 1);
-}
-
-static void __init __check_and_double_early_res(u64 ex_start, u64 ex_end)
+static void __init __check_and_double_region_array(struct lmb_region *type,
+			 struct lmb_property *static_region,
+			 u64 ex_start, u64 ex_end)
 {
 	u64 start, end, size, mem;
-	struct early_res *new;
+	struct lmb_property *new, *old;
+	unsigned long rgnsz = type->nr_regions;
 
 	/* do we have enough slots left ? */
-	if ((max_early_res - early_res_count) > max(max_early_res/8, 2))
+	if ((rgnsz - type->cnt) > max_t(unsigned long, rgnsz/8, 2))
 		return;
 
+	old = type->region;
 	/* double it */
 	mem = -1ULL;
-	size = sizeof(struct early_res) * max_early_res * 2;
-	if (early_res == early_res_x)
+	size = sizeof(struct lmb_property) * rgnsz * 2;
+	if (old == static_region)
 		start = 0;
 	else
-		start = early_res[0].end;
+		start = __pa(old) + sizeof(struct lmb_property) * rgnsz;
 	end = ex_start;
 	if (start + size < end)
-		mem = find_fw_memmap_area(start, end, size,
-					 sizeof(struct early_res));
+		mem = find_lmb_area(start, end, size,
+					 sizeof(struct lmb_property));
 	if (mem == -1ULL) {
 		start = ex_end;
 		end = get_max_mapped();
 		if (start + size < end)
-			mem = find_fw_memmap_area(start, end, size,
-						 sizeof(struct early_res));
+			mem = find_lmb_area(start, end, size, sizeof(struct lmb_property));
 	}
 	if (mem == -1ULL)
-		panic("can not find more space for early_res array");
+		panic("can not find more space for lmb.reserved.region array");
 
 	new = __va(mem);
-	/* save the first one for own */
-	new[0].start = mem;
-	new[0].end = mem + size;
-	new[0].overlap_ok = 0;
 	/* copy old to new */
-	if (early_res == early_res_x) {
-		memcpy(&new[1], &early_res[0],
-			 sizeof(struct early_res) * max_early_res);
-		memset(&new[max_early_res+1], 0,
-			 sizeof(struct early_res) * (max_early_res - 1));
-		early_res_count++;
-	} else {
-		memcpy(&new[1], &early_res[1],
-			 sizeof(struct early_res) * (max_early_res - 1));
-		memset(&new[max_early_res], 0,
-			 sizeof(struct early_res) * max_early_res);
-	}
-	memset(&early_res[0], 0, sizeof(struct early_res) * max_early_res);
-	early_res = new;
-	max_early_res *= 2;
-	printk(KERN_DEBUG "early_res array is doubled to %d at [%llx - %llx]\n",
-		max_early_res, mem, mem + size - 1);
+	memcpy(&new[0], &old[0], sizeof(struct lmb_property) * rgnsz);
+	memset(&new[rgnsz], 0, sizeof(struct lmb_property) * rgnsz);
+
+	memset(&old[0], 0, sizeof(struct lmb_property) * rgnsz);
+	type->region = new;
+	type->nr_regions = rgnsz * 2;
+	printk(KERN_DEBUG "lmb.reserved.region array is doubled to %ld at [%llx - %llx]\n",
+		type->nr_regions, mem, mem + size - 1);
+
+	/* reserve new array and free old one */
+	lmb_reserve(mem, sizeof(struct lmb_property) * rgnsz * 2);
+	if (old != static_region)
+		lmb_free(__pa(old), sizeof(struct lmb_property) * rgnsz);
 }
 
-/*
- * Most early reservations come here.
- *
- * We first have drop_overlaps_that_are_ok() drop any pre-existing
- * 'overlap_ok' ranges, so that we can then reserve this memory
- * range without risk of panic'ing on an overlapping overlap_ok
- * early reservation.
- */
-void __init reserve_early(u64 start, u64 end, char *name)
+void __init add_lmb_memory(u64 start, u64 end)
 {
-	if (start >= end)
-		return;
-
-	__check_and_double_early_res(start, end);
-
-	drop_overlaps_that_are_ok(start, end);
-	__reserve_early(start, end, name, 0);
+	__check_and_double_region_array(&lmb.memory, &lmb_memory_region[0], start, end);
+	lmb_add(start, end - start);
 }
 
-void __init reserve_early_without_check(u64 start, u64 end, char *name)
+void __init reserve_early(u64 start, u64 end, char *name)
 {
-	struct early_res *r;
-
-	if (start >= end)
+	if (start == end)
 		return;
 
-	__check_and_double_early_res(start, end);
-
-	r = &early_res[early_res_count];
+	if (WARN_ONCE(start > end, "reserve_early: wrong range [%#llx, %#llx]\n", start, end))
+		return;
 
-	r->start = start;
-	r->end = end;
-	r->overlap_ok = 0;
-	if (name)
-		strncpy(r->name, name, sizeof(r->name) - 1);
-	early_res_count++;
+	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[0], start, end);
+	lmb_reserve(start, end - start);
 }
 
 void __init free_early(u64 start, u64 end)
 {
-	struct early_res *r;
-	int i;
-
-	i = find_overlapped_early(start, end);
-	r = &early_res[i];
-	if (i >= max_early_res || r->end != end || r->start != start)
-		panic("free_early on not reserved area: %llx-%llx!",
-			 start, end - 1);
-
-	drop_range(i);
-}
-
-void __init free_early_partial(u64 start, u64 end)
-{
-	struct early_res *r;
-	int i;
-
 	if (start == end)
 		return;
 
-	if (WARN_ONCE(start > end, "free_early_partial: wrong range [%#llx, %#llx]\n", start, end))
-		return;
-
-try_next:
-	i = find_overlapped_early(start, end);
-	if (i >= max_early_res)
-		return;
-
-	r = &early_res[i];
-	/* hole ? */
-	if (r->end >= end && r->start <= start) {
-		drop_range_partial(i, start, end);
+	if (WARN_ONCE(start > end, "free_early: wrong range [%#llx, %#llx]\n", start, end))
 		return;
-	}
 
-	drop_range_partial(i, start, end);
-	goto try_next;
+	/* keep punching hole, could run out of slots too */
+	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[0], start, end);
+	lmb_free(start, end - start);
 }
 
 #ifdef CONFIG_NO_BOOTMEM
-static void __init subtract_early_res(struct range *range, int az)
+static void __init subtract_lmb_reserved(struct range *range, int az)
 {
 	int i, count;
 	u64 final_start, final_end;
-	int idx = 0;
 
-	count  = 0;
-	for (i = 0; i < max_early_res && early_res[i].end; i++)
-		count++;
+	/*take out region array at first*/
+	if (lmb.reserved.region != lmb_reserved_region)
+		lmb_free(__pa(lmb.reserved.region), sizeof(struct lmb_property) * lmb.reserved.nr_regions);
 
-	/* need to skip first one ?*/
-	if (early_res != early_res_x)
-		idx = 1;
+	count  = lmb.reserved.cnt;
 
 #define DEBUG_PRINT_EARLY_RES 1
 
 #if DEBUG_PRINT_EARLY_RES
 	printk(KERN_INFO "Subtract (%d early reservations)\n", count);
 #endif
-	for (i = idx; i < count; i++) {
-		struct early_res *r = &early_res[i];
+
+	for (i = 0; i < count; i++) {
+		struct lmb_property *r = &lmb.reserved.region[i];
 #if DEBUG_PRINT_EARLY_RES
-		printk(KERN_INFO "  #%d [%010llx - %010llx] %15s\n", i,
-			r->start, r->end, r->name);
+		printk(KERN_INFO "  #%d [%010llx - %010llx]\n", i,
+			r->base, r->base + r->size);
 #endif
-		final_start = PFN_DOWN(r->start);
-		final_end = PFN_UP(r->end);
+		final_start = PFN_DOWN(r->base);
+		final_end = PFN_UP(r->base + r->size);
 		if (final_start >= final_end)
 			continue;
 		subtract_range(range, az, final_start, final_end);
 	}
-
+	/* put region array back */
+	if (lmb.reserved.region != lmb_reserved_region)
+		lmb_reserve(__pa(lmb.reserved.region), sizeof(struct lmb_property) * lmb.reserved.nr_regions);
 }
 
 int __init get_free_all_memory_range(struct range **rangep, int nodeid)
 {
-	int i, count;
+	int count;
 	u64 start = 0, end;
 	u64 size;
 	u64 mem;
 	struct range *range;
 	int nr_range;
 
-	count  = 0;
-	for (i = 0; i < max_early_res && early_res[i].end; i++)
-		count++;
-
-	count *= 2;
+	count = lmb.reserved.cnt * 2;
 
 	size = sizeof(struct range) * count;
 	end = get_max_mapped();
@@ -411,12 +147,15 @@ int __init get_free_all_memory_range(struct range **rangep, int nodeid)
 	if (end > (MAX_DMA32_PFN << PAGE_SHIFT))
 		start = MAX_DMA32_PFN << PAGE_SHIFT;
 #endif
-	mem = find_fw_memmap_area(start, end, size, sizeof(struct range));
+	mem = find_lmb_area(start, end, size, sizeof(struct range));
 	if (mem == -1ULL)
 		panic("can not find more space for range free");
 
 	range = __va(mem);
-	/* use early_node_map[] and early_res to get range array at first */
+	/*
+	 * use early_node_map[] and lmb.reserved.region to get range array
+	 * at first
+	 */
 	memset(range, 0, size);
 	nr_range = 0;
 
@@ -425,43 +164,39 @@ int __init get_free_all_memory_range(struct range **rangep, int nodeid)
 #ifdef CONFIG_X86_32
 	subtract_range(range, count, max_low_pfn, -1ULL);
 #endif
-	subtract_early_res(range, count);
+	subtract_lmb_reserved(range, count);
 	nr_range = clean_sort_range(range, count);
 
 	/* need to clear it ? */
 	if (nodeid == MAX_NUMNODES) {
-		memset(&early_res[0], 0,
-			 sizeof(struct early_res) * max_early_res);
-		early_res = NULL;
-		max_early_res = 0;
+		memset(&lmb.reserved.region[0], 0, sizeof(struct lmb_property) * lmb.reserved.nr_regions);
+		lmb.reserved.region = NULL;
+		lmb.reserved.nr_regions = 0;
+		lmb.reserved.cnt = 0;
 	}
 
 	*rangep = range;
 	return nr_range;
 }
 #else
-void __init early_res_to_bootmem(u64 start, u64 end)
+void __init lmb_reserved_to_bootmem(u64 start, u64 end)
 {
 	int i, count;
 	u64 final_start, final_end;
-	int idx = 0;
-
-	count  = 0;
-	for (i = 0; i < max_early_res && early_res[i].end; i++)
-		count++;
-
-	/* need to skip first one ?*/
-	if (early_res != early_res_x)
-		idx = 1;
-
-	printk(KERN_INFO "(%d/%d early reservations) ==> bootmem [%010llx - %010llx]\n",
-			 count - idx, max_early_res, start, end);
-	for (i = idx; i < count; i++) {
-		struct early_res *r = &early_res[i];
-		printk(KERN_INFO "  #%d [%010llx - %010llx] %16s", i,
-			r->start, r->end, r->name);
-		final_start = max(start, r->start);
-		final_end = min(end, r->end);
+
+	/*take out region array */
+	if (lmb.reserved.region != lmb_reserved_region)
+		lmb_free(__pa(lmb.reserved.region), sizeof(struct lmb_property) * lmb.reserved.nr_regions);
+
+	count  = lmb.reserved.cnt;
+	printk(KERN_INFO "(%d early reservations) ==> bootmem [%010llx - %010llx]\n",
+			 count, start, end);
+	for (i = 0; i < count; i++) {
+		struct lmb_property *r = &lmb.reserved.region[i];
+		printk(KERN_INFO "  #%d [%010llx - %010llx] ", i,
+			r->base, r->base + r->size);
+		final_start = max(start, r->base);
+		final_end = min(end, r->base + r->size);
 		if (final_start >= final_end) {
 			printk(KERN_CONT "\n");
 			continue;
@@ -471,57 +206,71 @@ void __init early_res_to_bootmem(u64 start, u64 end)
 		reserve_bootmem_generic(final_start, final_end - final_start,
 				BOOTMEM_DEFAULT);
 	}
-	/* clear them */
-	memset(&early_res[0], 0, sizeof(struct early_res) * max_early_res);
-	early_res = NULL;
-	max_early_res = 0;
-	early_res_count = 0;
+	/* clear them to avoid misuse */
+	memset(&lmb.reserved.region[0], 0, sizeof(struct lmb_property) * lmb.reserved.nr_regions);
+	lmb.reserved.region = NULL;
+	lmb.reserved.nr_regions = 0;
+	lmb.reserved.cnt = 0;
 }
 #endif
 
+static int __init find_overlapped_early(u64 start, u64 end)
+{
+	int i;
+	struct lmb_property *r;
+
+	for (i = 0; i < lmb.reserved.cnt && lmb.reserved.region[i].size; i++) {
+		r = &lmb.reserved.region[i];
+		if (end > r->base && start < (r->base + r->size))
+			break;
+	}
+
+	return i;
+}
+
 /* Check for already reserved areas */
-static inline int __init bad_addr(u64 *addrp, u64 size, u64 align)
+static inline bool __init bad_addr(u64 *addrp, u64 size, u64 align)
 {
 	int i;
 	u64 addr = *addrp;
-	int changed = 0;
-	struct early_res *r;
+	bool changed = false;
+	struct lmb_property *r;
 again:
 	i = find_overlapped_early(addr, addr + size);
-	r = &early_res[i];
-	if (i < max_early_res && r->end) {
-		*addrp = addr = round_up(r->end, align);
-		changed = 1;
+	r = &lmb.reserved.region[i];
+	if (i < lmb.reserved.cnt && r->size) {
+		*addrp = addr = round_up(r->base + r->size, align);
+		changed = true;
 		goto again;
 	}
 	return changed;
 }
 
 /* Check for already reserved areas */
-static inline int __init bad_addr_size(u64 *addrp, u64 *sizep, u64 align)
+static inline bool __init bad_addr_size(u64 *addrp, u64 *sizep, u64 align)
 {
 	int i;
 	u64 addr = *addrp, last;
 	u64 size = *sizep;
-	int changed = 0;
+	bool changed = false;
 again:
 	last = addr + size;
-	for (i = 0; i < max_early_res && early_res[i].end; i++) {
-		struct early_res *r = &early_res[i];
-		if (last > r->start && addr < r->start) {
-			size = r->start - addr;
-			changed = 1;
+	for (i = 0; i < lmb.reserved.cnt && lmb.reserved.region[i].size; i++) {
+		struct lmb_property *r = &lmb.reserved.region[i];
+		if (last > r->base && addr < r->base) {
+			size = r->base - addr;
+			changed = true;
 			goto again;
 		}
-		if (last > r->end && addr < r->end) {
-			addr = round_up(r->end, align);
+		if (last > (r->base + r->size) && addr < (r->base + r->size)) {
+			addr = round_up(r->base + r->size, align);
 			size = last - addr;
-			changed = 1;
+			changed = true;
 			goto again;
 		}
-		if (last <= r->end && addr >= r->start) {
+		if (last <= (r->base + r->size) && addr >= r->base) {
 			(*sizep)++;
-			return 0;
+			return false;
 		}
 	}
 	if (changed) {
@@ -531,13 +280,8 @@ again:
 	return changed;
 }
 
-/*
- * Find a free area with specified alignment in a specific range.
- * only with the area.between start to end is active range from early_node_map
- * so they are good as RAM
- */
 u64 __init find_early_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
-			 u64 size, u64 align)
+				 u64 size, u64 align)
 {
 	u64 addr, last;
 
@@ -560,7 +304,7 @@ out:
 	return -1ULL;
 }
 
-u64 __init find_early_area_size(u64 ei_start, u64 ei_last, u64 start,
+static u64 __init find_early_area_size(u64 ei_start, u64 ei_last, u64 start,
 			 u64 *sizep, u64 align)
 {
 	u64 addr, last;
@@ -582,3 +326,130 @@ u64 __init find_early_area_size(u64 ei_start, u64 ei_last, u64 start,
 out:
 	return -1ULL;
 }
+
+/*
+ * Find a free area with specified alignment in a specific range.
+ */
+u64 __init find_lmb_area(u64 start, u64 end, u64 size, u64 align)
+{
+	int i;
+
+	for (i = 0; i < lmb.memory.cnt; i++) {
+		u64 ei_start = lmb.memory.region[i].base;
+		u64 ei_last = ei_start + lmb.memory.region[i].size;
+		u64 addr;
+
+		addr = find_early_area(ei_start, ei_last, start, end,
+					 size, align);
+
+		if (addr != -1ULL)
+			return addr;
+	}
+	return -1ULL;
+}
+
+/*
+ * Find next free range after *start
+ */
+u64 __init find_lmb_area_size(u64 start, u64 *sizep, u64 align)
+{
+	int i;
+
+	for (i = 0; i < lmb.memory.cnt; i++) {
+		u64 ei_start = lmb.memory.region[i].base;
+		u64 ei_last = ei_start + lmb.memory.region[i].size;
+		u64 addr;
+
+		addr = find_early_area_size(ei_start, ei_last, start,
+					 sizep, align);
+
+		if (addr != -1ULL)
+			return addr;
+	}
+
+	return -1ULL;
+}
+
+u64 __init find_lmb_area_node(int nid, u64 start, u64 end, u64 size, u64 align)
+{
+	u64 addr;
+	/*
+	 * need to call this function after lmb_register_active_regions
+	 * so early_node_map[] is set
+	 */
+	addr = find_memory_core_early(nid, size, align, start, end);
+	if (addr != -1ULL)
+		return addr;
+
+	/* fallback, should already have start end in the node range */
+	return find_lmb_area(start, end, size, align);
+}
+
+/*
+ * Finds an active region in the address range from start_pfn to last_pfn and
+ * returns its range in ei_startpfn and ei_endpfn for the lmb entry.
+ */
+static int __init lmb_find_active_region(const struct lmb_property *ei,
+				  unsigned long start_pfn,
+				  unsigned long last_pfn,
+				  unsigned long *ei_startpfn,
+				  unsigned long *ei_endpfn)
+{
+	u64 align = PAGE_SIZE;
+
+	*ei_startpfn = round_up(ei->base, align) >> PAGE_SHIFT;
+	*ei_endpfn = round_down(ei->base + ei->size, align) >> PAGE_SHIFT;
+
+	/* Skip map entries smaller than a page */
+	if (*ei_startpfn >= *ei_endpfn)
+		return 0;
+
+	/* Skip if map is outside the node */
+	if (*ei_endpfn <= start_pfn || *ei_startpfn >= last_pfn)
+		return 0;
+
+	/* Check for overlaps */
+	if (*ei_startpfn < start_pfn)
+		*ei_startpfn = start_pfn;
+	if (*ei_endpfn > last_pfn)
+		*ei_endpfn = last_pfn;
+
+	return 1;
+}
+
+/* Walk the lmb.memory map and register active regions within a node */
+void __init lmb_register_active_regions(int nid, unsigned long start_pfn,
+					 unsigned long last_pfn)
+{
+	unsigned long ei_startpfn;
+	unsigned long ei_endpfn;
+	int i;
+
+	for (i = 0; i < lmb.memory.cnt; i++)
+		if (lmb_find_active_region(&lmb.memory.region[i],
+					    start_pfn, last_pfn,
+					    &ei_startpfn, &ei_endpfn))
+			add_active_range(nid, ei_startpfn, ei_endpfn);
+}
+
+/*
+ * Find the hole size (in bytes) in the memory range.
+ * @start: starting address of the memory range to scan
+ * @end: ending address of the memory range to scan
+ */
+u64 __init lmb_hole_size(u64 start, u64 end)
+{
+	unsigned long start_pfn = start >> PAGE_SHIFT;
+	unsigned long last_pfn = end >> PAGE_SHIFT;
+	unsigned long ei_startpfn, ei_endpfn, ram = 0;
+	int i;
+
+	for (i = 0; i < lmb.memory.cnt; i++) {
+		if (lmb_find_active_region(&lmb.memory.region[i],
+					    start_pfn, last_pfn,
+					    &ei_startpfn, &ei_endpfn))
+			ram += ei_endpfn - ei_startpfn;
+	}
+	return end - start - ((u64)ram << PAGE_SHIFT);
+}
+
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index eef3757..04c241a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3451,7 +3451,7 @@ void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
 
 	ptr = phys_to_virt(addr);
 	memset(ptr, 0, size);
-	reserve_early_without_check(addr, addr + size, "BOOTMEM");
+	reserve_early(addr, addr + size, "BOOTMEM");
 	return ptr;
 }
 #endif
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 392b9bb..cb917d5 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -219,18 +219,7 @@ void __init sparse_mem_maps_populate_node(struct page **map_map,
 
 	if (vmemmap_buf_start) {
 		/* need to free left buf */
-#ifdef CONFIG_NO_BOOTMEM
-		free_early(__pa(vmemmap_buf_start), __pa(vmemmap_buf_end));
-		if (vmemmap_buf_start < vmemmap_buf) {
-			char name[15];
-
-			snprintf(name, sizeof(name), "MEMMAP %d", nodeid);
-			reserve_early_without_check(__pa(vmemmap_buf_start),
-						    __pa(vmemmap_buf), name);
-		}
-#else
 		free_bootmem(__pa(vmemmap_buf), vmemmap_buf_end - vmemmap_buf);
-#endif
 		vmemmap_buf = NULL;
 		vmemmap_buf_end = NULL;
 	}
-- 
1.6.4.2

