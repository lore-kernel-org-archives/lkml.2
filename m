Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab0CWKig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 06:38:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:55371 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848Ab0CWKie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 06:38:34 -0400
Message-ID: <4BA899D5.90806@kernel.org>
Date: Tue, 23 Mar 2010 03:37:09 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [RFC PATCH -v3 2/2] x86: use lmb to replace early_res
References: <1269333587-1866-1-git-send-email-yinghai@kernel.org> <1269333587-1866-5-git-send-email-yinghai@kernel.org>
In-Reply-To: <1269333587-1866-5-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/Kconfig               |    1 
 arch/x86/include/asm/e820.h    |   38 +-
 arch/x86/include/asm/lmb.h     |    8 
 arch/x86/kernel/e820.c         |  163 +----------
 arch/x86/kernel/head.c         |    2 
 arch/x86/kernel/head32.c       |    5 
 arch/x86/kernel/head64.c       |    2 
 arch/x86/kernel/setup.c        |    2 
 arch/x86/kernel/setup_percpu.c |    6 
 include/linux/early_res.h      |    9 
 kernel/early_res.c             |  592 +++++++++++++++--------------------------
 mm/page_alloc.c                |    2 
 mm/sparse-vmemmap.c            |    4 
 13 files changed, 301 insertions(+), 533 deletions(-)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -27,6 +27,7 @@ config X86
 	select HAVE_PERF_EVENTS if (!M386 && !M486)
 	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
+	select HAVE_LMB
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_WANT_FRAME_POINTERS
 	select HAVE_DMA_ATTRS
Index: linux-2.6/arch/x86/include/asm/e820.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/e820.h
+++ linux-2.6/arch/x86/include/asm/e820.h
@@ -113,22 +113,36 @@ static inline void early_memtest(unsigne
 
 extern unsigned long end_user_pfn;
 
-extern u64 find_e820_area(u64 start, u64 end, u64 size, u64 align);
-extern u64 find_e820_area_size(u64 start, u64 *sizep, u64 align);
-u64 find_e820_area_node(int nid, u64 start, u64 end, u64 size, u64 align);
-extern u64 early_reserve_e820(u64 startt, u64 sizet, u64 align);
 #include <linux/early_res.h>
+static inline u64 find_e820_area(u64 start, u64 end, u64 size, u64 align)
+{
+	return find_lmb_area(start, end, size, align);
+}
+static inline u64 find_e820_area_size(u64 start, u64 *sizep, u64 align)
+{
+	return find_lmb_area_size(start, sizep, align);
+}
+static inline u64
+find_e820_area_node(int nid, u64 start, u64 end, u64 size, u64 align)
+{
+	return find_lmb_area_node(nid, start, end, size, align);
+}
+extern u64 early_reserve_e820(u64 startt, u64 sizet, u64 align);
 
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
+static inline void e820_register_active_regions(int nid,
+					 unsigned long start_pfn,
+					 unsigned long end_pfn)
+{
+	lmb_register_active_regions(nid, start_pfn, end_pfn);
+}
+static inline u64 e820_hole_size(u64 start, u64 end)
+{
+	return lmb_hole_size(start, end);
+}
+void init_lmb_memory(void);
+void fill_lmb_memory(void);
 extern void finish_e820_parsing(void);
 extern void e820_reserve_resources(void);
 extern void e820_reserve_resources_late(void);
Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -15,6 +15,7 @@
 #include <linux/pfn.h>
 #include <linux/suspend.h>
 #include <linux/firmware-map.h>
+#include <linux/lmb.h>
 
 #include <asm/e820.h>
 #include <asm/proto.h>
@@ -726,37 +727,6 @@ static int __init e820_mark_nvs_memory(v
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
@@ -765,47 +735,6 @@ u64 __init get_max_mapped(void)
 
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
  * pre allocated 4k and reserved it in e820
@@ -899,74 +828,6 @@ unsigned long __init e820_end_of_low_ram
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
@@ -1057,6 +918,28 @@ void __init finish_e820_parsing(void)
 	}
 }
 
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
+		lmb_add(ei->addr, ei->size);
+	}
+
+	lmb_analyze();
+
+	lmb_dump_all();
+}
+
 static inline const char *e820_type_to_string(int e820_type)
 {
 	switch (e820_type) {
Index: linux-2.6/arch/x86/kernel/head.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head.c
+++ linux-2.6/arch/x86/kernel/head.c
@@ -51,5 +51,5 @@ void __init reserve_ebda_region(void)
 		lowmem = 0x9f000;
 
 	/* reserve all memory between lowmem and the 1MB mark */
-	reserve_early_overlap_ok(lowmem, 0x100000, "BIOS reserved");
+	reserve_early(lowmem, 0x100000, "BIOS reserved");
 }
Index: linux-2.6/arch/x86/kernel/head32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head32.c
+++ linux-2.6/arch/x86/kernel/head32.c
@@ -29,14 +29,15 @@ static void __init i386_default_early_se
 
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
Index: linux-2.6/arch/x86/kernel/head64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head64.c
+++ linux-2.6/arch/x86/kernel/head64.c
@@ -96,6 +96,8 @@ void __init x86_64_start_kernel(char * r
 
 void __init x86_64_start_reservations(char *real_mode_data)
 {
+	init_lmb_memory();
+
 	copy_bootdata(__va(real_mode_data));
 
 	reserve_early(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -894,6 +894,8 @@ void __init setup_arch(char **cmdline_p)
 	max_pfn_mapped = KERNEL_IMAGE_SIZE >> PAGE_SHIFT;
 #endif
 
+	fill_lmb_memory();
+
 #ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
 	setup_bios_corruption_check();
 #endif
Index: linux-2.6/arch/x86/kernel/setup_percpu.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6/arch/x86/kernel/setup_percpu.c
@@ -137,13 +137,7 @@ static void * __init pcpu_fc_alloc(unsig
 
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
Index: linux-2.6/include/linux/early_res.h
===================================================================
--- linux-2.6.orig/include/linux/early_res.h
+++ linux-2.6/include/linux/early_res.h
@@ -5,15 +5,18 @@
 extern void reserve_early(u64 start, u64 end, char *name);
 extern void reserve_early_overlap_ok(u64 start, u64 end, char *name);
 extern void free_early(u64 start, u64 end);
-void free_early_partial(u64 start, u64 end);
 extern void early_res_to_bootmem(u64 start, u64 end);
 
-void reserve_early_without_check(u64 start, u64 end, char *name);
 u64 find_early_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
 			 u64 size, u64 align);
 u64 find_early_area_size(u64 ei_start, u64 ei_last, u64 start,
 			 u64 *sizep, u64 align);
-u64 find_fw_memmap_area(u64 start, u64 end, u64 size, u64 align);
+u64 find_lmb_area(u64 start, u64 end, u64 size, u64 align);
+u64 find_lmb_area_size(u64 start, u64 *sizep, u64 align);
+u64 find_lmb_area_node(int nid, u64 start, u64 end, u64 size, u64 align);
+void lmb_register_active_regions(int nid, unsigned long start_pfn,
+					 unsigned long last_pfn);
+u64 lmb_hole_size(u64 start, u64 end);
 u64 get_max_mapped(void);
 #include <linux/range.h>
 int get_free_all_memory_range(struct range **rangep, int nodeid);
Index: linux-2.6/kernel/early_res.c
===================================================================
--- linux-2.6.orig/kernel/early_res.c
+++ linux-2.6/kernel/early_res.c
@@ -6,353 +6,82 @@
 #include <linux/init.h>
 #include <linux/bootmem.h>
 #include <linux/mm.h>
+#include <linux/lmb.h>
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
-
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
 
 static void __init __check_and_double_early_res(u64 ex_start, u64 ex_end)
 {
 	u64 start, end, size, mem;
-	struct early_res *new;
+	struct lmb_property *new, *old;
+	struct lmb_region *type = &lmb.reserved;
+	unsigned long rgnsz = type->region_array_size;
 
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
+	if (old == lmb_reserved_region)
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
-}
-
-/*
- * Most early reservations come here.
- *
- * We first have drop_overlaps_that_are_ok() drop any pre-existing
- * 'overlap_ok' ranges, so that we can then reserve this memory
- * range without risk of panic'ing on an overlapping overlap_ok
- * early reservation.
- */
-void __init reserve_early(u64 start, u64 end, char *name)
-{
-	if (start >= end)
-		return;
-
-	__check_and_double_early_res(start, end);
+	memcpy(&new[0], &old[0], sizeof(struct lmb_property) * rgnsz);
+	memset(&new[rgnsz], 0, sizeof(struct lmb_property) * rgnsz);
 
-	drop_overlaps_that_are_ok(start, end);
-	__reserve_early(start, end, name, 0);
+	memset(&old[0], 0, sizeof(struct lmb_property) * rgnsz);
+	type->region = new;
+	type->region_array_size = rgnsz * 2;
+	printk(KERN_DEBUG "lmb.reserved.region array is doubled to %ld at [%llx - %llx]\n",
+		type->region_array_size, mem, mem + size - 1);
+	lmb_reserve(mem, sizeof(struct lmb_property) * rgnsz * 2);
+	if (old != lmb_reserved_region)
+		lmb_free(__pa(old), sizeof(struct lmb_property) * rgnsz);
 }
 
-void __init reserve_early_without_check(u64 start, u64 end, char *name)
+void __init reserve_early(u64 start, u64 end, char *name)
 {
-	struct early_res *r;
-
 	if (start >= end)
 		return;
 
 	__check_and_double_early_res(start, end);
 
-	r = &early_res[early_res_count];
-
-	r->start = start;
-	r->end = end;
-	r->overlap_ok = 0;
-	if (name)
-		strncpy(r->name, name, sizeof(r->name) - 1);
-	early_res_count++;
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
+	if (WARN_ONCE(start > end, "free_early: wrong range [%#llx, %#llx]\n", start, end))
 		return;
 
-try_next:
-	i = find_overlapped_early(start, end);
-	if (i >= max_early_res)
-		return;
-
-	r = &early_res[i];
-	/* hole ? */
-	if (r->end >= end && r->start <= start) {
-		drop_range_partial(i, start, end);
-		return;
-	}
+	/* keep punching hole, could run out of slots too */
+	__check_and_double_early_res(start, end);
 
-	drop_range_partial(i, start, end);
-	goto try_next;
+	lmb_free(start, end - start);
 }
 
 #ifdef CONFIG_NO_BOOTMEM
@@ -360,50 +89,46 @@ static void __init subtract_early_res(st
 {
 	int i, count;
 	u64 final_start, final_end;
-	int idx = 0;
 
-	count  = 0;
-	for (i = 0; i < max_early_res && early_res[i].end; i++)
-		count++;
-
-	/* need to skip first one ?*/
-	if (early_res != early_res_x)
-		idx = 1;
+	/*take out region array at first*/
+	if (lmb.reserved.region != lmb_reserved_region)
+		lmb_free(__pa(lmb.reserved.region), sizeof(struct lmb_property) * lmb.reserved.region_array_size);
+
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
+		lmb_reserve(__pa(lmb.reserved.region), sizeof(struct lmb_property) * lmb.reserved.region_array_size);
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
@@ -411,12 +136,15 @@ int __init get_free_all_memory_range(str
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
 
@@ -430,10 +158,10 @@ int __init get_free_all_memory_range(str
 
 	/* need to clear it ? */
 	if (nodeid == MAX_NUMNODES) {
-		memset(&early_res[0], 0,
-			 sizeof(struct early_res) * max_early_res);
-		early_res = NULL;
-		max_early_res = 0;
+		memset(&lmb.reserved.region[0], 0, sizeof(struct lmb_property) * lmb.reserved.region_array_size);
+		lmb.reserved.region = NULL;
+		lmb.reserved.region_array_size = 0;
+		lmb.reserved.cnt = 0;
 	}
 
 	*rangep = range;
@@ -444,24 +172,20 @@ void __init early_res_to_bootmem(u64 sta
 {
 	int i, count;
 	u64 final_start, final_end;
-	int idx = 0;
 
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
+	/*take out region array */
+	if (lmb.reserved.region != lmb_reserved_region)
+		lmb_free(__pa(lmb.reserved.region), sizeof(struct lmb_property) * lmb.reserved.region_array_size);
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
@@ -471,26 +195,40 @@ void __init early_res_to_bootmem(u64 sta
 		reserve_bootmem_generic(final_start, final_end - final_start,
 				BOOTMEM_DEFAULT);
 	}
-	/* clear them */
-	memset(&early_res[0], 0, sizeof(struct early_res) * max_early_res);
-	early_res = NULL;
-	max_early_res = 0;
-	early_res_count = 0;
+	/* clear them to avoid misuse */
+	memset(&lmb.reserved.region[0], 0, sizeof(struct lmb_property) * lmb.reserved.region_array_size);
+	lmb.reserved.region = NULL;
+	lmb.reserved.region_array_size = 0;
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
 static inline int __init bad_addr(u64 *addrp, u64 size, u64 align)
 {
 	int i;
 	u64 addr = *addrp;
 	int changed = 0;
-	struct early_res *r;
+	struct lmb_property *r;
 again:
 	i = find_overlapped_early(addr, addr + size);
-	r = &early_res[i];
-	if (i < max_early_res && r->end) {
-		*addrp = addr = round_up(r->end, align);
+	r = &lmb.reserved.region[i];
+	if (i < lmb.reserved.cnt && r->size) {
+		*addrp = addr = round_up(r->base + r->size, align);
 		changed = 1;
 		goto again;
 	}
@@ -506,20 +244,20 @@ static inline int __init bad_addr_size(u
 	int changed = 0;
 again:
 	last = addr + size;
-	for (i = 0; i < max_early_res && early_res[i].end; i++) {
-		struct early_res *r = &early_res[i];
-		if (last > r->start && addr < r->start) {
-			size = r->start - addr;
+	for (i = 0; i < lmb.reserved.cnt && lmb.reserved.region[i].size; i++) {
+		struct lmb_property *r = &lmb.reserved.region[i];
+		if (last > r->base && addr < r->base) {
+			size = r->base - addr;
 			changed = 1;
 			goto again;
 		}
-		if (last > r->end && addr < r->end) {
-			addr = round_up(r->end, align);
+		if (last > (r->base + r->size) && addr < (r->base + r->size)) {
+			addr = round_up(r->base + r->size, align);
 			size = last - addr;
 			changed = 1;
 			goto again;
 		}
-		if (last <= r->end && addr >= r->start) {
+		if (last <= (r->base + r->size) && addr >= r->base) {
 			(*sizep)++;
 			return 0;
 		}
@@ -531,13 +269,8 @@ again:
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
 
@@ -582,3 +315,130 @@ u64 __init find_early_area_size(u64 ei_s
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
+	 * need to call this function after e820_register_active_regions
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
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -3451,7 +3451,7 @@ void * __init __alloc_memory_core_early(
 
 	ptr = phys_to_virt(addr);
 	memset(ptr, 0, size);
-	reserve_early_without_check(addr, addr + size, "BOOTMEM");
+	reserve_early(addr, addr + size, "BOOTMEM");
 	return ptr;
 }
 #endif
Index: linux-2.6/mm/sparse-vmemmap.c
===================================================================
--- linux-2.6.orig/mm/sparse-vmemmap.c
+++ linux-2.6/mm/sparse-vmemmap.c
@@ -225,8 +225,8 @@ void __init sparse_mem_maps_populate_nod
 			char name[15];
 
 			snprintf(name, sizeof(name), "MEMMAP %d", nodeid);
-			reserve_early_without_check(__pa(vmemmap_buf_start),
-						    __pa(vmemmap_buf), name);
+			reserve_early(__pa(vmemmap_buf_start),
+					 __pa(vmemmap_buf), name);
 		}
 #else
 		free_bootmem(__pa(vmemmap_buf), vmemmap_buf_end - vmemmap_buf);
Index: linux-2.6/arch/x86/include/asm/lmb.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/include/asm/lmb.h
@@ -0,0 +1,8 @@
+#ifndef _X86_LMB_H
+#define _X86_LMB_H
+
+#define LMB_DBG(fmt...) printk(fmt)
+
+#define LMB_REAL_LIMIT	0
+
+#endif
