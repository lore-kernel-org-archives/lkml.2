Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab0C2CwK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 22:52:10 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:56569 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab0C2Cq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 22:46:29 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 22/31] x86: Use lmb to replace early_res
Date: Sun, 28 Mar 2010 19:43:15 -0700
Message-Id: <1269830604-26214-23-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BB01464.0094,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. replace find_e820_area with find_lmb_area
2. replace reserve_early with reserve_lmb
3. replace free_early with free_lmb.
4. NO_BOOTMEM will switch to use lmb too.
5. use _e820, _early wrap in the patch, in following patch, will
   replace them all
6. because free_lmb support partial free, we can remove some special care
7. Need to make sure that find_lmb_area() is called after fill_lmb_memory()
   so adjust some calling later in setup.c::setup_arch()
   -- corruption_check and mptable_update

-v2: Move reserve_brk() early
    Before fill_lmb_area, to avoid overlap between brk and find_lmb_area()
    that could happen We have more then 128 RAM entry in E820 tables, and
    fill_lmb_memory() could use find_lmb_area() to find a new place for
    lmb.memory.region array.
    and We don't need to use extend_brk() after fill_lmb_area()
-v3: Move find_smp_config early
    To make sure find_lmb_area not find wrong place, if BIOS doesn't put mptable
    in right place.
-v4: Treat RESERVED_KERN as RAM in lmb.memory. and they are already in
    lmb.reserved already..
    use __NOT_KEEP_LMB to make sure lmb related code could be freed later.

So move reserve_brk() early before fill_lmb_area().

Suggested-by: David S. Miller <davem@davemloft.net>
Suggested-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/Kconfig               |    9 +--
 arch/x86/include/asm/e820.h    |   15 +++--
 arch/x86/include/asm/lmb.h     |   10 +++
 arch/x86/kernel/check.c        |   14 ++--
 arch/x86/kernel/e820.c         |  139 +++++++++++-----------------------------
 arch/x86/kernel/head.c         |    3 +-
 arch/x86/kernel/head32.c       |    6 +-
 arch/x86/kernel/head64.c       |    3 +
 arch/x86/kernel/mpparse.c      |    5 +-
 arch/x86/kernel/setup.c        |   29 ++++++---
 arch/x86/kernel/setup_percpu.c |    6 --
 arch/x86/mm/numa_64.c          |    5 +-
 kernel/Makefile                |    1 -
 mm/bootmem.c                   |    1 +
 mm/page_alloc.c                |   35 ++--------
 mm/sparse-vmemmap.c            |   11 ---
 16 files changed, 111 insertions(+), 181 deletions(-)
 create mode 100644 arch/x86/include/asm/lmb.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6a80bce..3117de5 100644
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
@@ -192,9 +193,6 @@ config ARCH_SUPPORTS_OPTIMIZED_INLINING
 config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	def_bool y
 
-config HAVE_EARLY_RES
-	def_bool y
-
 config HAVE_INTEL_TXT
 	def_bool y
 	depends on EXPERIMENTAL && DMAR && ACPI
@@ -589,14 +587,13 @@ config NO_BOOTMEM
 	default y
 	bool "Disable Bootmem code"
 	---help---
-	  Use early_res directly instead of bootmem before slab is ready.
+	  Use lmb directly instead of bootmem before slab is ready.
 		- allocator (buddy) [generic]
 		- early allocator (bootmem) [generic]
-		- very early allocator (reserve_early*()) [x86]
+		- very early allocator (lmb) [some generic]
 		- very very early allocator (early brk model) [x86]
 	  So reduce one layer between early allocator to final allocator
 
-
 config MEMTEST
 	bool "Memtest"
 	---help---
diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 0457c49..396c849 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -116,24 +116,27 @@ extern unsigned long end_user_pfn;
 extern u64 find_e820_area(u64 start, u64 end, u64 size, u64 align);
 extern u64 find_e820_area_size(u64 start, u64 *sizep, u64 align);
 extern u64 early_reserve_e820(u64 startt, u64 sizet, u64 align);
-#include <linux/early_res.h>
 
 extern unsigned long e820_end_of_ram_pfn(void);
 extern unsigned long e820_end_of_low_ram_pfn(void);
-extern int e820_find_active_region(const struct e820entry *ei,
-				  unsigned long start_pfn,
-				  unsigned long last_pfn,
-				  unsigned long *ei_startpfn,
-				  unsigned long *ei_endpfn);
 extern void e820_register_active_regions(int nid, unsigned long start_pfn,
 					 unsigned long end_pfn);
 extern u64 e820_hole_size(u64 start, u64 end);
+
+extern u64 early_reserve_e820(u64 startt, u64 sizet, u64 align);
+
+void init_lmb_memory(void);
+void fill_lmb_memory(void);
+
 extern void finish_e820_parsing(void);
 extern void e820_reserve_resources(void);
 extern void e820_reserve_resources_late(void);
 extern void setup_memory_map(void);
 extern char *default_machine_specific_memory_setup(void);
 
+void reserve_early(u64 start, u64 end, char *name);
+void free_early(u64 start, u64 end);
+
 /*
  * Returns true iff the specified range [s,e) is completely contained inside
  * the ISA region.
diff --git a/arch/x86/include/asm/lmb.h b/arch/x86/include/asm/lmb.h
new file mode 100644
index 0000000..2fd1db4
--- /dev/null
+++ b/arch/x86/include/asm/lmb.h
@@ -0,0 +1,10 @@
+#ifndef _X86_LMB_H
+#define _X86_LMB_H
+
+#define LMB_DBG(fmt...) printk(fmt)
+
+#define LMB_REAL_LIMIT 0
+
+#define __NOT_KEEP_LMB
+
+#endif
diff --git a/arch/x86/kernel/check.c b/arch/x86/kernel/check.c
index fc999e6..90236af 100644
--- a/arch/x86/kernel/check.c
+++ b/arch/x86/kernel/check.c
@@ -2,7 +2,8 @@
 #include <linux/sched.h>
 #include <linux/kthread.h>
 #include <linux/workqueue.h>
-#include <asm/e820.h>
+#include <linux/lmb.h>
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
+		reserve_lmb(addr, addr + size, "SCAN RAM");
 		scan_areas[num_scan_areas].addr = addr;
 		scan_areas[num_scan_areas].size = size;
 		num_scan_areas++;
@@ -105,7 +108,6 @@ void __init setup_bios_corruption_check(void)
 
 	printk(KERN_INFO "Scanning %d areas for low memory corruption\n",
 	       num_scan_areas);
-	update_e820();
 }
 
 
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 0eb9830..c2a9ce4 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -15,6 +15,7 @@
 #include <linux/pfn.h>
 #include <linux/suspend.h>
 #include <linux/firmware-map.h>
+#include <linux/lmb.h>
 
 #include <asm/e820.h>
 #include <asm/proto.h>
@@ -731,30 +732,7 @@ core_initcall(e820_mark_nvs_memory);
  */
 u64 __init find_e820_area(u64 start, u64 end, u64 size, u64 align)
 {
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
+	return find_lmb_area(start, end, size, align);
 }
 
 u64 __init get_max_mapped(void)
@@ -770,30 +748,11 @@ u64 __init get_max_mapped(void)
  */
 u64 __init find_e820_area_size(u64 start, u64 *sizep, u64 align)
 {
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
+	return find_lmb_area_size(start, sizep, align);
 }
 
 /*
- * pre allocated 4k and reserved it in e820
+ * pre allocated 4k and reserved it in lmb and e820_saved
  */
 u64 __init early_reserve_e820(u64 startt, u64 sizet, u64 align)
 {
@@ -802,7 +761,7 @@ u64 __init early_reserve_e820(u64 startt, u64 sizet, u64 align)
 	u64 start;
 
 	for (start = startt; ; start += size) {
-		start = find_e820_area_size(start, &size, align);
+		start = find_lmb_area_size(start, &size, align);
 		if (!(start + 1))
 			return 0;
 		if (size >= sizet)
@@ -819,10 +778,9 @@ u64 __init early_reserve_e820(u64 startt, u64 sizet, u64 align)
 	addr = round_down(start + size - sizet, align);
 	if (addr < start)
 		return 0;
-	e820_update_range(addr, sizet, E820_RAM, E820_RESERVED);
+	reserve_lmb(addr, addr + sizet, "new next");
 	e820_update_range_saved(addr, sizet, E820_RAM, E820_RESERVED);
-	printk(KERN_INFO "update e820 for early_reserve_e820\n");
-	update_e820();
+	printk(KERN_INFO "update e820_saved for early_reserve_e820\n");
 	update_e820_saved();
 
 	return addr;
@@ -884,52 +842,12 @@ unsigned long __init e820_end_of_low_ram_pfn(void)
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
 
 /* Walk the e820 map and register active regions within a node */
 void __init e820_register_active_regions(int nid, unsigned long start_pfn,
 					 unsigned long last_pfn)
 {
-	unsigned long ei_startpfn;
-	unsigned long ei_endpfn;
-	int i;
-
-	for (i = 0; i < e820.nr_map; i++)
-		if (e820_find_active_region(&e820.map[i],
-					    start_pfn, last_pfn,
-					    &ei_startpfn, &ei_endpfn))
-			add_active_range(nid, ei_startpfn, ei_endpfn);
+	lmb_register_active_regions(nid, start_pfn, last_pfn);
 }
 
 /*
@@ -939,18 +857,16 @@ void __init e820_register_active_regions(int nid, unsigned long start_pfn,
  */
 u64 __init e820_hole_size(u64 start, u64 end)
 {
-	unsigned long start_pfn = start >> PAGE_SHIFT;
-	unsigned long last_pfn = end >> PAGE_SHIFT;
-	unsigned long ei_startpfn, ei_endpfn, ram = 0;
-	int i;
+	return lmb_hole_size(start, end);
+}
 
-	for (i = 0; i < e820.nr_map; i++) {
-		if (e820_find_active_region(&e820.map[i],
-					    start_pfn, last_pfn,
-					    &ei_startpfn, &ei_endpfn))
-			ram += ei_endpfn - ei_startpfn;
-	}
-	return end - start - ((u64)ram << PAGE_SHIFT);
+void reserve_early(u64 start, u64 end, char *name)
+{
+	reserve_lmb(start, end, name);
+}
+void free_early(u64 start, u64 end)
+{
+	free_lmb(start, end);
 }
 
 static void early_panic(char *msg)
@@ -1204,3 +1120,24 @@ void __init setup_memory_map(void)
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
+		if (ei->type != E820_RAM && ei->type != E820_RESERVED_KERN)
+			continue;
+		add_lmb_memory(ei->addr, ei->addr + ei->size);
+	}
+
+	lmb_analyze();
+	lmb_dump_all();
+}
diff --git a/arch/x86/kernel/head.c b/arch/x86/kernel/head.c
index 3e66bd3..0341b09 100644
--- a/arch/x86/kernel/head.c
+++ b/arch/x86/kernel/head.c
@@ -1,5 +1,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/lmb.h>
 
 #include <asm/setup.h>
 #include <asm/bios_ebda.h>
@@ -51,5 +52,5 @@ void __init reserve_ebda_region(void)
 		lowmem = 0x9f000;
 
 	/* reserve all memory between lowmem and the 1MB mark */
-	reserve_early_overlap_ok(lowmem, 0x100000, "BIOS reserved");
+	reserve_lmb_overlap_ok(lowmem, 0x100000, "BIOS reserved");
 }
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index 9a97504..cbab479 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -7,6 +7,7 @@
 
 #include <linux/init.h>
 #include <linux/start_kernel.h>
+#include <linux/lmb.h>
 
 #include <asm/setup.h>
 #include <asm/sections.h>
@@ -29,14 +30,15 @@ static void __init i386_default_early_setup(void)
 
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
+	reserve_lmb(PAGE_SIZE, PAGE_SIZE + PAGE_SIZE, "EX TRAMPOLINE");
 #endif
 
 	reserve_early(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 7147143..89dd2de 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -12,6 +12,7 @@
 #include <linux/percpu.h>
 #include <linux/start_kernel.h>
 #include <linux/io.h>
+#include <linux/lmb.h>
 
 #include <asm/processor.h>
 #include <asm/proto.h>
@@ -96,6 +97,8 @@ void __init x86_64_start_kernel(char * real_mode_data)
 
 void __init x86_64_start_reservations(char *real_mode_data)
 {
+	init_lmb_memory();
+
 	copy_bootdata(__va(real_mode_data));
 
 	reserve_early(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index a2c1edd..5779c27 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/bootmem.h>
+#include <linux/lmb.h>
 #include <linux/kernel_stat.h>
 #include <linux/mc146818rtc.h>
 #include <linux/bitops.h>
@@ -664,7 +665,7 @@ static void __init smp_reserve_memory(struct mpf_intel *mpf)
 {
 	unsigned long size = get_mpc_size(mpf->physptr);
 
-	reserve_early(mpf->physptr, mpf->physptr+size, "MP-table mpc");
+	reserve_lmb_overlap_ok(mpf->physptr, mpf->physptr+size, "MP-table mpc");
 }
 
 static int __init smp_scan_config(unsigned long base, unsigned long length)
@@ -693,7 +694,7 @@ static int __init smp_scan_config(unsigned long base, unsigned long length)
 			       mpf, (u64)virt_to_phys(mpf));
 
 			mem = virt_to_phys(mpf);
-			reserve_early(mem, mem + sizeof(*mpf), "MP-table mpf");
+			reserve_lmb_overlap_ok(mem, mem + sizeof(*mpf), "MP-table mpf");
 			if (mpf->physptr)
 				smp_reserve_memory(mpf);
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 7ca6878..a5c029f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -31,6 +31,7 @@
 #include <linux/apm_bios.h>
 #include <linux/initrd.h>
 #include <linux/bootmem.h>
+#include <linux/lmb.h>
 #include <linux/seq_file.h>
 #include <linux/console.h>
 #include <linux/mca.h>
@@ -870,8 +871,6 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	max_pfn = e820_end_of_ram_pfn();
 
-	/* preallocate 4k for mptable mpc */
-	early_reserve_e820_mpc_new();
 	/* update e820 for memory not covered by WB MTRRs */
 	mtrr_bp_init();
 	if (mtrr_trim_uncached_memory(max_pfn))
@@ -896,6 +895,23 @@ void __init setup_arch(char **cmdline_p)
 	max_pfn_mapped = KERNEL_IMAGE_SIZE >> PAGE_SHIFT;
 #endif
 
+	/*
+	 * Find and reserve possible boot-time SMP configuration:
+	 */
+	find_smp_config();
+
+	/*
+	 * Need to conclude brk, before fill_lmb_memory()
+	 *  it could use find_lmb_area, could overlap with
+	 *  brk area.
+	 */
+	reserve_brk();
+
+	fill_lmb_memory();
+
+	/* preallocate 4k for mptable mpc */
+	early_reserve_e820_mpc_new();
+
 #ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
 	setup_bios_corruption_check();
 #endif
@@ -903,13 +919,6 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_DEBUG "initial memory mapped : 0 - %08lx\n",
 			max_pfn_mapped<<PAGE_SHIFT);
 
-	reserve_brk();
-
-	/*
-	 * Find and reserve possible boot-time SMP configuration:
-	 */
-	find_smp_config();
-
 	reserve_trampoline_memory();
 
 #ifdef CONFIG_ACPI_SLEEP
@@ -972,7 +981,7 @@ void __init setup_arch(char **cmdline_p)
 
 	initmem_init(0, max_pfn, acpi, k8);
 #ifndef CONFIG_NO_BOOTMEM
-	early_res_to_bootmem(0, max_low_pfn<<PAGE_SHIFT);
+	lmb_to_bootmem(0, max_low_pfn<<PAGE_SHIFT);
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
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 8948f47..fc9a403 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -7,6 +7,7 @@
 #include <linux/string.h>
 #include <linux/init.h>
 #include <linux/bootmem.h>
+#include <linux/lmb.h>
 #include <linux/mmzone.h>
 #include <linux/ctype.h>
 #include <linux/module.h>
@@ -174,7 +175,7 @@ static void * __init early_node_mem(int nodeid, unsigned long start,
 	if (start < (MAX_DMA32_PFN<<PAGE_SHIFT) &&
 	    end > (MAX_DMA32_PFN<<PAGE_SHIFT))
 		start = MAX_DMA32_PFN<<PAGE_SHIFT;
-	mem = find_e820_area(start, end, size, align);
+	mem = find_lmb_area_node(nodeid, start, end, size, align);
 	if (mem != -1L)
 		return __va(mem);
 
@@ -184,7 +185,7 @@ static void * __init early_node_mem(int nodeid, unsigned long start,
 		start = MAX_DMA32_PFN<<PAGE_SHIFT;
 	else
 		start = MAX_DMA_PFN<<PAGE_SHIFT;
-	mem = find_e820_area(start, end, size, align);
+	mem = find_lmb_area_node(nodeid, start, end, size, align);
 	if (mem != -1L)
 		return __va(mem);
 
diff --git a/kernel/Makefile b/kernel/Makefile
index d5c3006..754bf79 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -11,7 +11,6 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o \
 	    async.o range.o
-obj-$(CONFIG_HAVE_EARLY_RES) += early_res.o
 obj-y += groups.o
 
 ifdef CONFIG_FUNCTION_TRACER
diff --git a/mm/bootmem.c b/mm/bootmem.c
index fadbc3b..81f9350 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/kmemleak.h>
 #include <linux/range.h>
+#include <linux/lmb.h>
 
 #include <asm/bug.h>
 #include <asm/io.h>
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index faae23a..42bc09e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3441,38 +3441,19 @@ int __init add_from_early_node_map(struct range *range, int az,
 void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
 					u64 goal, u64 limit)
 {
-	int i;
 	void *ptr;
 
-	/* need to go over early_node_map to find out good range for node */
-	for_each_active_range_index_in_nid(i, nid) {
-		u64 addr;
-		u64 ei_start, ei_last;
-
-		ei_last = early_node_map[i].end_pfn;
-		ei_last <<= PAGE_SHIFT;
-		ei_start = early_node_map[i].start_pfn;
-		ei_start <<= PAGE_SHIFT;
-		addr = find_early_area(ei_start, ei_last,
-					 goal, limit, size, align);
-
-		if (addr == -1ULL)
-			continue;
+	u64 addr;
 
-#if 0
-		printk(KERN_DEBUG "alloc (nid=%d %llx - %llx) (%llx - %llx) %llx %llx => %llx\n",
-				nid,
-				ei_start, ei_last, goal, limit, size,
-				align, addr);
-#endif
+	addr = find_memory_core_early(nid, size, align, goal, limit);
 
-		ptr = phys_to_virt(addr);
-		memset(ptr, 0, size);
-		reserve_early_without_check(addr, addr + size, "BOOTMEM");
-		return ptr;
-	}
+	if (addr == -1ULL)
+		return NULL;
 
-	return NULL;
+	ptr = phys_to_virt(addr);
+	memset(ptr, 0, size);
+	reserve_lmb(addr, addr + size, "BOOTMEM");
+	return ptr;
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

