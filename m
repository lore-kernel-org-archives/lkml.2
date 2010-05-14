Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab0ENTuB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:50:01 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59914 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932376Ab0ENTsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:48:55 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 21/37] x86: Replace e820_/_early string with lmb_
Date: Fri, 14 May 2010 12:45:47 -0700
Message-Id: <1273866363-14249-22-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273866363-14249-1-git-send-email-yinghai@kernel.org>
References: <1273866363-14249-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090204.4BEDA8E9.0110,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1.include linux/lmb.h directly. so later could reduce e820.h reference.
2 this patch is done by sed scripts mainly

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/efi.h      |    2 +-
 arch/x86/kernel/acpi/sleep.c    |    5 +++--
 arch/x86/kernel/apic/numaq_32.c |    3 ++-
 arch/x86/kernel/efi.c           |    5 +++--
 arch/x86/kernel/head32.c        |    4 ++--
 arch/x86/kernel/head64.c        |    4 ++--
 arch/x86/kernel/setup.c         |   25 ++++++++++++-------------
 arch/x86/kernel/trampoline.c    |    6 +++---
 arch/x86/mm/init.c              |    5 +++--
 arch/x86/mm/init_32.c           |   10 ++++++----
 arch/x86/mm/init_64.c           |    9 +++++----
 arch/x86/mm/k8topology_64.c     |    4 +++-
 arch/x86/mm/memtest.c           |    7 +++----
 arch/x86/mm/numa_32.c           |   17 +++++++++--------
 arch/x86/mm/numa_64.c           |   32 ++++++++++++++++----------------
 arch/x86/mm/srat_32.c           |    3 ++-
 arch/x86/mm/srat_64.c           |    9 +++++----
 arch/x86/xen/mmu.c              |    5 +++--
 arch/x86/xen/setup.c            |    3 ++-
 mm/bootmem.c                    |    4 ++--
 20 files changed, 87 insertions(+), 75 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 8406ed7..06703f3 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -90,7 +90,7 @@ extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
 #endif /* CONFIG_X86_32 */
 
 extern int add_efi_memmap;
-extern void efi_reserve_early(void);
+extern void efi_lmb_reserve_area(void);
 extern void efi_call_phys_prelog(void);
 extern void efi_call_phys_epilog(void);
 
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 82e5086..86be7ba 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -7,6 +7,7 @@
 
 #include <linux/acpi.h>
 #include <linux/bootmem.h>
+#include <linux/lmb.h>
 #include <linux/dmi.h>
 #include <linux/cpumask.h>
 #include <asm/segment.h>
@@ -133,7 +134,7 @@ void __init acpi_reserve_wakeup_memory(void)
 		return;
 	}
 
-	mem = find_e820_area(0, 1<<20, WAKEUP_SIZE, PAGE_SIZE);
+	mem = lmb_find_area(0, 1<<20, WAKEUP_SIZE, PAGE_SIZE);
 
 	if (mem == -1L) {
 		printk(KERN_ERR "ACPI: Cannot allocate lowmem, S3 disabled.\n");
@@ -141,7 +142,7 @@ void __init acpi_reserve_wakeup_memory(void)
 	}
 	acpi_realmode = (unsigned long) phys_to_virt(mem);
 	acpi_wakeup_address = mem;
-	reserve_early(mem, mem + WAKEUP_SIZE, "ACPI WAKEUP");
+	lmb_reserve_area(mem, mem + WAKEUP_SIZE, "ACPI WAKEUP");
 }
 
 
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index 3e28401..c71e494 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -26,6 +26,7 @@
 #include <linux/nodemask.h>
 #include <linux/topology.h>
 #include <linux/bootmem.h>
+#include <linux/lmb.h>
 #include <linux/threads.h>
 #include <linux/cpumask.h>
 #include <linux/kernel.h>
@@ -88,7 +89,7 @@ static inline void numaq_register_node(int node, struct sys_cfg_data *scd)
 	node_end_pfn[node] =
 		 MB_TO_PAGES(eq->hi_shrd_mem_start + eq->hi_shrd_mem_size);
 
-	e820_register_active_regions(node, node_start_pfn[node],
+	lmb_register_active_regions(node, node_start_pfn[node],
 						node_end_pfn[node]);
 
 	memory_present(node, node_start_pfn[node], node_end_pfn[node]);
diff --git a/arch/x86/kernel/efi.c b/arch/x86/kernel/efi.c
index c2fa9b8..ebe7c09 100644
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -30,6 +30,7 @@
 #include <linux/init.h>
 #include <linux/efi.h>
 #include <linux/bootmem.h>
+#include <linux/lmb.h>
 #include <linux/spinlock.h>
 #include <linux/uaccess.h>
 #include <linux/time.h>
@@ -275,7 +276,7 @@ static void __init do_add_efi_memmap(void)
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 }
 
-void __init efi_reserve_early(void)
+void __init efi_lmb_reserve_area(void)
 {
 	unsigned long pmap;
 
@@ -290,7 +291,7 @@ void __init efi_reserve_early(void)
 		boot_params.efi_info.efi_memdesc_size;
 	memmap.desc_version = boot_params.efi_info.efi_memdesc_version;
 	memmap.desc_size = boot_params.efi_info.efi_memdesc_size;
-	reserve_early(pmap, pmap + memmap.nr_map * memmap.desc_size,
+	lmb_reserve_area(pmap, pmap + memmap.nr_map * memmap.desc_size,
 		      "EFI memmap");
 }
 
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index ab3e366..ecd12a9 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -42,7 +42,7 @@ void __init i386_start_kernel(void)
 	lmb_reserve_area(PAGE_SIZE, PAGE_SIZE + PAGE_SIZE, "EX TRAMPOLINE");
 #endif
 
-	reserve_early(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
+	lmb_reserve_area(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	/* Reserve INITRD */
@@ -51,7 +51,7 @@ void __init i386_start_kernel(void)
 		u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 		u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
 		u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
-		reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
+		lmb_reserve_area(ramdisk_image, ramdisk_end, "RAMDISK");
 	}
 #endif
 
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 89dd2de..4063134 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -101,7 +101,7 @@ void __init x86_64_start_reservations(char *real_mode_data)
 
 	copy_bootdata(__va(real_mode_data));
 
-	reserve_early(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
+	lmb_reserve_area(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	/* Reserve INITRD */
@@ -110,7 +110,7 @@ void __init x86_64_start_reservations(char *real_mode_data)
 		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
 		unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
 		unsigned long ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
-		reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
+		lmb_reserve_area(ramdisk_image, ramdisk_end, "RAMDISK");
 	}
 #endif
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b23da32..1a8888f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -302,7 +302,7 @@ static inline void init_gbpages(void)
 static void __init reserve_brk(void)
 {
 	if (_brk_end > _brk_start)
-		reserve_early(__pa(_brk_start), __pa(_brk_end), "BRK");
+		lmb_reserve_area(__pa(_brk_start), __pa(_brk_end), "BRK");
 
 	/* Mark brk area as locked down and no longer taking any
 	   new allocations */
@@ -324,7 +324,7 @@ static void __init relocate_initrd(void)
 	char *p, *q;
 
 	/* We need to move the initrd down into lowmem */
-	ramdisk_here = find_e820_area(0, end_of_lowmem, area_size,
+	ramdisk_here = lmb_find_area(0, end_of_lowmem, area_size,
 					 PAGE_SIZE);
 
 	if (ramdisk_here == -1ULL)
@@ -333,8 +333,7 @@ static void __init relocate_initrd(void)
 
 	/* Note: this includes all the lowmem currently occupied by
 	   the initrd, we rely on that fact to keep the data intact. */
-	reserve_early(ramdisk_here, ramdisk_here + area_size,
-			 "NEW RAMDISK");
+	lmb_reserve_area(ramdisk_here, ramdisk_here + area_size, "NEW RAMDISK");
 	initrd_start = ramdisk_here + PAGE_OFFSET;
 	initrd_end   = initrd_start + ramdisk_size;
 	printk(KERN_INFO "Allocated new RAMDISK: %08llx - %08llx\n",
@@ -390,7 +389,7 @@ static void __init reserve_initrd(void)
 	initrd_start = 0;
 
 	if (ramdisk_size >= (end_of_lowmem>>1)) {
-		free_early(ramdisk_image, ramdisk_end);
+		lmb_free_area(ramdisk_image, ramdisk_end);
 		printk(KERN_ERR "initrd too large to handle, "
 		       "disabling initrd\n");
 		return;
@@ -413,7 +412,7 @@ static void __init reserve_initrd(void)
 
 	relocate_initrd();
 
-	free_early(ramdisk_image, ramdisk_end);
+	lmb_free_area(ramdisk_image, ramdisk_end);
 }
 #else
 static void __init reserve_initrd(void)
@@ -469,7 +468,7 @@ static void __init e820_reserve_setup_data(void)
 	e820_print_map("reserve setup_data");
 }
 
-static void __init reserve_early_setup_data(void)
+static void __init lmb_reserve_area_setup_data(void)
 {
 	struct setup_data *data;
 	u64 pa_data;
@@ -481,7 +480,7 @@ static void __init reserve_early_setup_data(void)
 	while (pa_data) {
 		data = early_memremap(pa_data, sizeof(*data));
 		sprintf(buf, "setup data %x", data->type);
-		reserve_early(pa_data, pa_data+sizeof(*data)+data->len, buf);
+		lmb_reserve_area(pa_data, pa_data+sizeof(*data)+data->len, buf);
 		pa_data = data->next;
 		early_iounmap(data, sizeof(*data));
 	}
@@ -519,7 +518,7 @@ static void __init reserve_crashkernel(void)
 	if (crash_base <= 0) {
 		const unsigned long long alignment = 16<<20;	/* 16M */
 
-		crash_base = find_e820_area(alignment, ULONG_MAX, crash_size,
+		crash_base = lmb_find_area(alignment, ULONG_MAX, crash_size,
 				 alignment);
 		if (crash_base == -1ULL) {
 			pr_info("crashkernel reservation failed - No suitable area found.\n");
@@ -528,14 +527,14 @@ static void __init reserve_crashkernel(void)
 	} else {
 		unsigned long long start;
 
-		start = find_e820_area(crash_base, ULONG_MAX, crash_size,
+		start = lmb_find_area(crash_base, ULONG_MAX, crash_size,
 				 1<<20);
 		if (start != crash_base) {
 			pr_info("crashkernel reservation failed - memory is in use.\n");
 			return;
 		}
 	}
-	reserve_early(crash_base, crash_base + crash_size, "CRASH KERNEL");
+	lmb_reserve_area(crash_base, crash_base + crash_size, "CRASH KERNEL");
 
 	printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
 			"for crashkernel (System RAM: %ldMB)\n",
@@ -774,7 +773,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
 	 4)) {
 		efi_enabled = 1;
-		efi_reserve_early();
+		efi_lmb_reserve_area();
 	}
 #endif
 
@@ -834,7 +833,7 @@ void __init setup_arch(char **cmdline_p)
 	vmi_activate();
 
 	/* after early param, so could get panic from serial */
-	reserve_early_setup_data();
+	lmb_reserve_area_setup_data();
 
 	if (acpi_mps_check()) {
 #ifdef CONFIG_X86_LOCAL_APIC
diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
index c652ef6..1192dcb 100644
--- a/arch/x86/kernel/trampoline.c
+++ b/arch/x86/kernel/trampoline.c
@@ -1,7 +1,7 @@
 #include <linux/io.h>
+#include <linux/lmb.h>
 
 #include <asm/trampoline.h>
-#include <asm/e820.h>
 
 #if defined(CONFIG_X86_64) && defined(CONFIG_ACPI_SLEEP)
 #define __trampinit
@@ -19,12 +19,12 @@ void __init reserve_trampoline_memory(void)
 	unsigned long mem;
 
 	/* Has to be in very low memory so we can execute real-mode AP code. */
-	mem = find_e820_area(0, 1<<20, TRAMPOLINE_SIZE, PAGE_SIZE);
+	mem = lmb_find_area(0, 1<<20, TRAMPOLINE_SIZE, PAGE_SIZE);
 	if (mem == -1L)
 		panic("Cannot allocate trampoline\n");
 
 	trampoline_base = __va(mem);
-	reserve_early(mem, mem + TRAMPOLINE_SIZE, "TRAMPOLINE");
+	lmb_reserve_area(mem, mem + TRAMPOLINE_SIZE, "TRAMPOLINE");
 }
 
 /*
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index b278535..94f7cb9 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -2,6 +2,7 @@
 #include <linux/initrd.h>
 #include <linux/ioport.h>
 #include <linux/swap.h>
+#include <linux/lmb.h>
 
 #include <asm/cacheflush.h>
 #include <asm/e820.h>
@@ -75,7 +76,7 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 #else
 	start = 0x8000;
 #endif
-	e820_table_start = find_e820_area(start, max_pfn_mapped<<PAGE_SHIFT,
+	e820_table_start = lmb_find_area(start, max_pfn_mapped<<PAGE_SHIFT,
 					tables, PAGE_SIZE);
 	if (e820_table_start == -1UL)
 		panic("Cannot find space for the kernel page tables");
@@ -299,7 +300,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	__flush_tlb_all();
 
 	if (!after_bootmem && e820_table_end > e820_table_start)
-		reserve_early(e820_table_start << PAGE_SHIFT,
+		lmb_reserve_area(e820_table_start << PAGE_SHIFT,
 				 e820_table_end << PAGE_SHIFT, "PGTABLE");
 
 	if (!after_bootmem)
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 90e0545..c01c711 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -25,6 +25,7 @@
 #include <linux/pfn.h>
 #include <linux/poison.h>
 #include <linux/bootmem.h>
+#include <linux/lmb.h>
 #include <linux/proc_fs.h>
 #include <linux/memory_hotplug.h>
 #include <linux/initrd.h>
@@ -712,14 +713,14 @@ void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
 	highstart_pfn = highend_pfn = max_pfn;
 	if (max_pfn > max_low_pfn)
 		highstart_pfn = max_low_pfn;
-	e820_register_active_regions(0, 0, highend_pfn);
+	lmb_register_active_regions(0, 0, highend_pfn);
 	sparse_memory_present_with_active_regions(0);
 	printk(KERN_NOTICE "%ldMB HIGHMEM available.\n",
 		pages_to_mb(highend_pfn - highstart_pfn));
 	num_physpages = highend_pfn;
 	high_memory = (void *) __va(highstart_pfn * PAGE_SIZE - 1) + 1;
 #else
-	e820_register_active_regions(0, 0, max_low_pfn);
+	lmb_register_active_regions(0, 0, max_low_pfn);
 	sparse_memory_present_with_active_regions(0);
 	num_physpages = max_low_pfn;
 	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE - 1) + 1;
@@ -781,11 +782,11 @@ void __init setup_bootmem_allocator(void)
 	 * Initialize the boot-time allocator (with low memory only):
 	 */
 	bootmap_size = bootmem_bootmap_pages(max_low_pfn)<<PAGE_SHIFT;
-	bootmap = find_e820_area(0, max_pfn_mapped<<PAGE_SHIFT, bootmap_size,
+	bootmap = lmb_find_area(0, max_pfn_mapped<<PAGE_SHIFT, bootmap_size,
 				 PAGE_SIZE);
 	if (bootmap == -1L)
 		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
-	reserve_early(bootmap, bootmap + bootmap_size, "BOOTMAP");
+	lmb_reserve_area(bootmap, bootmap + bootmap_size, "BOOTMAP");
 #endif
 
 	printk(KERN_INFO "  mapped low ram: 0 - %08lx\n",
@@ -1069,3 +1070,4 @@ void mark_rodata_ro(void)
 #endif
 }
 #endif
+
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 634fa08..0d2252c 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -21,6 +21,7 @@
 #include <linux/initrd.h>
 #include <linux/pagemap.h>
 #include <linux/bootmem.h>
+#include <linux/lmb.h>
 #include <linux/proc_fs.h>
 #include <linux/pci.h>
 #include <linux/pfn.h>
@@ -577,18 +578,18 @@ void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
 	unsigned long bootmap_size, bootmap;
 
 	bootmap_size = bootmem_bootmap_pages(end_pfn)<<PAGE_SHIFT;
-	bootmap = find_e820_area(0, end_pfn<<PAGE_SHIFT, bootmap_size,
+	bootmap = lmb_find_area(0, end_pfn<<PAGE_SHIFT, bootmap_size,
 				 PAGE_SIZE);
 	if (bootmap == -1L)
 		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
-	reserve_early(bootmap, bootmap + bootmap_size, "BOOTMAP");
+	lmb_reserve_area(bootmap, bootmap + bootmap_size, "BOOTMAP");
 	/* don't touch min_low_pfn */
 	bootmap_size = init_bootmem_node(NODE_DATA(0), bootmap >> PAGE_SHIFT,
 					 0, end_pfn);
-	e820_register_active_regions(0, start_pfn, end_pfn);
+	lmb_register_active_regions(0, start_pfn, end_pfn);
 	free_bootmem_with_active_regions(0, end_pfn);
 #else
-	e820_register_active_regions(0, start_pfn, end_pfn);
+	lmb_register_active_regions(0, start_pfn, end_pfn);
 #endif
 }
 #endif
diff --git a/arch/x86/mm/k8topology_64.c b/arch/x86/mm/k8topology_64.c
index 970ed57..d7d031b 100644
--- a/arch/x86/mm/k8topology_64.c
+++ b/arch/x86/mm/k8topology_64.c
@@ -11,6 +11,8 @@
 #include <linux/string.h>
 #include <linux/module.h>
 #include <linux/nodemask.h>
+#include <linux/lmb.h>
+
 #include <asm/io.h>
 #include <linux/pci_ids.h>
 #include <linux/acpi.h>
@@ -222,7 +224,7 @@ int __init k8_scan_nodes(void)
 	for_each_node_mask(i, node_possible_map) {
 		int j;
 
-		e820_register_active_regions(i,
+		lmb_register_active_regions(i,
 				nodes[i].start >> PAGE_SHIFT,
 				nodes[i].end >> PAGE_SHIFT);
 		for (j = apicid_base; j < cores + apicid_base; j++)
diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index 18d244f..0e4a006 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -6,8 +6,7 @@
 #include <linux/smp.h>
 #include <linux/init.h>
 #include <linux/pfn.h>
-
-#include <asm/e820.h>
+#include <linux/lmb.h>
 
 static u64 patterns[] __initdata = {
 	0,
@@ -35,7 +34,7 @@ static void __init reserve_bad_mem(u64 pattern, u64 start_bad, u64 end_bad)
 	       (unsigned long long) pattern,
 	       (unsigned long long) start_bad,
 	       (unsigned long long) end_bad);
-	reserve_early(start_bad, end_bad, "BAD RAM");
+	lmb_reserve_area(start_bad, end_bad, "BAD RAM");
 }
 
 static void __init memtest(u64 pattern, u64 start_phys, u64 size)
@@ -74,7 +73,7 @@ static void __init do_one_pass(u64 pattern, u64 start, u64 end)
 	u64 size = 0;
 
 	while (start < end) {
-		start = find_e820_area_size(start, &size, 1);
+		start = lmb_find_area_size(start, &size, 1);
 
 		/* done ? */
 		if (start >= end)
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 809baaa..d8d655f 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -24,6 +24,7 @@
 
 #include <linux/mm.h>
 #include <linux/bootmem.h>
+#include <linux/lmb.h>
 #include <linux/mmzone.h>
 #include <linux/highmem.h>
 #include <linux/initrd.h>
@@ -120,7 +121,7 @@ int __init get_memcfg_numa_flat(void)
 
 	node_start_pfn[0] = 0;
 	node_end_pfn[0] = max_pfn;
-	e820_register_active_regions(0, 0, max_pfn);
+	lmb_register_active_regions(0, 0, max_pfn);
 	memory_present(0, 0, max_pfn);
 	node_remap_size[0] = node_memmap_size_bytes(0, 0, max_pfn);
 
@@ -161,14 +162,14 @@ static void __init allocate_pgdat(int nid)
 		NODE_DATA(nid) = (pg_data_t *)node_remap_start_vaddr[nid];
 	else {
 		unsigned long pgdat_phys;
-		pgdat_phys = find_e820_area(min_low_pfn<<PAGE_SHIFT,
+		pgdat_phys = lmb_find_area(min_low_pfn<<PAGE_SHIFT,
 				 max_pfn_mapped<<PAGE_SHIFT,
 				 sizeof(pg_data_t),
 				 PAGE_SIZE);
 		NODE_DATA(nid) = (pg_data_t *)(pfn_to_kaddr(pgdat_phys>>PAGE_SHIFT));
 		memset(buf, 0, sizeof(buf));
 		sprintf(buf, "NODE_DATA %d",  nid);
-		reserve_early(pgdat_phys, pgdat_phys + sizeof(pg_data_t), buf);
+		lmb_reserve_area(pgdat_phys, pgdat_phys + sizeof(pg_data_t), buf);
 	}
 	printk(KERN_DEBUG "allocate_pgdat: node %d NODE_DATA %08lx\n",
 		nid, (unsigned long)NODE_DATA(nid));
@@ -291,7 +292,7 @@ static __init unsigned long calculate_numa_remap_pages(void)
 						 PTRS_PER_PTE);
 		node_kva_target <<= PAGE_SHIFT;
 		do {
-			node_kva_final = find_e820_area(node_kva_target,
+			node_kva_final = lmb_find_area(node_kva_target,
 					((u64)node_end_pfn[nid])<<PAGE_SHIFT,
 						((u64)size)<<PAGE_SHIFT,
 						LARGE_PAGE_BYTES);
@@ -318,9 +319,9 @@ static __init unsigned long calculate_numa_remap_pages(void)
 		 *  but we could have some hole in high memory, and it will only
 		 *  check page_is_ram(pfn) && !page_is_reserved_early(pfn) to decide
 		 *  to use it as free.
-		 *  So reserve_early here, hope we don't run out of that array
+		 *  So lmb_reserve_area here, hope we don't run out of that array
 		 */
-		reserve_early(node_kva_final,
+		lmb_reserve_area(node_kva_final,
 			      node_kva_final+(((u64)size)<<PAGE_SHIFT),
 			      "KVA RAM");
 
@@ -367,7 +368,7 @@ void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
 
 	kva_target_pfn = round_down(max_low_pfn - kva_pages, PTRS_PER_PTE);
 	do {
-		kva_start_pfn = find_e820_area(kva_target_pfn<<PAGE_SHIFT,
+		kva_start_pfn = lmb_find_area(kva_target_pfn<<PAGE_SHIFT,
 					max_low_pfn<<PAGE_SHIFT,
 					kva_pages<<PAGE_SHIFT,
 					PTRS_PER_PTE<<PAGE_SHIFT) >> PAGE_SHIFT;
@@ -382,7 +383,7 @@ void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
 	printk(KERN_INFO "max_pfn = %lx\n", max_pfn);
 
 	/* avoid clash with initrd */
-	reserve_early(kva_start_pfn<<PAGE_SHIFT,
+	lmb_reserve_area(kva_start_pfn<<PAGE_SHIFT,
 		      (kva_start_pfn + kva_pages)<<PAGE_SHIFT,
 		     "KVA PG");
 #ifdef CONFIG_HIGHMEM
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 6e0f896..18d2296 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -90,7 +90,7 @@ static int __init allocate_cachealigned_memnodemap(void)
 
 	addr = 0x8000;
 	nodemap_size = roundup(sizeof(s16) * memnodemapsize, L1_CACHE_BYTES);
-	nodemap_addr = find_e820_area(addr, max_pfn<<PAGE_SHIFT,
+	nodemap_addr = lmb_find_area(addr, max_pfn<<PAGE_SHIFT,
 				      nodemap_size, L1_CACHE_BYTES);
 	if (nodemap_addr == -1UL) {
 		printk(KERN_ERR
@@ -99,7 +99,7 @@ static int __init allocate_cachealigned_memnodemap(void)
 		return -1;
 	}
 	memnodemap = phys_to_virt(nodemap_addr);
-	reserve_early(nodemap_addr, nodemap_addr + nodemap_size, "MEMNODEMAP");
+	lmb_reserve_area(nodemap_addr, nodemap_addr + nodemap_size, "MEMNODEMAP");
 
 	printk(KERN_DEBUG "NUMA: Allocated memnodemap from %lx - %lx\n",
 	       nodemap_addr, nodemap_addr + nodemap_size);
@@ -230,7 +230,7 @@ setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
 	if (node_data[nodeid] == NULL)
 		return;
 	nodedata_phys = __pa(node_data[nodeid]);
-	reserve_early(nodedata_phys, nodedata_phys + pgdat_size, "NODE_DATA");
+	lmb_reserve_area(nodedata_phys, nodedata_phys + pgdat_size, "NODE_DATA");
 	printk(KERN_INFO "  NODE_DATA [%016lx - %016lx]\n", nodedata_phys,
 		nodedata_phys + pgdat_size - 1);
 	nid = phys_to_nid(nodedata_phys);
@@ -249,7 +249,7 @@ setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
 	 * Find a place for the bootmem map
 	 * nodedata_phys could be on other nodes by alloc_bootmem,
 	 * so need to sure bootmap_start not to be small, otherwise
-	 * early_node_mem will get that with find_e820_area instead
+	 * early_node_mem will get that with lmb_find_area instead
 	 * of alloc_bootmem, that could clash with reserved range
 	 */
 	bootmap_pages = bootmem_bootmap_pages(last_pfn - start_pfn);
@@ -261,12 +261,12 @@ setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
 	bootmap = early_node_mem(nodeid, bootmap_start, end,
 				 bootmap_pages<<PAGE_SHIFT, PAGE_SIZE);
 	if (bootmap == NULL)  {
-		free_early(nodedata_phys, nodedata_phys + pgdat_size);
+		lmb_free_area(nodedata_phys, nodedata_phys + pgdat_size);
 		node_data[nodeid] = NULL;
 		return;
 	}
 	bootmap_start = __pa(bootmap);
-	reserve_early(bootmap_start, bootmap_start+(bootmap_pages<<PAGE_SHIFT),
+	lmb_reserve_area(bootmap_start, bootmap_start+(bootmap_pages<<PAGE_SHIFT),
 			"BOOTMAP");
 
 	bootmap_size = init_bootmem_node(NODE_DATA(nodeid),
@@ -420,7 +420,7 @@ static int __init split_nodes_interleave(u64 addr, u64 max_addr,
 		nr_nodes = MAX_NUMNODES;
 	}
 
-	size = (max_addr - addr - e820_hole_size(addr, max_addr)) / nr_nodes;
+	size = (max_addr - addr - lmb_hole_size(addr, max_addr)) / nr_nodes;
 	/*
 	 * Calculate the number of big nodes that can be allocated as a result
 	 * of consolidating the remainder.
@@ -456,7 +456,7 @@ static int __init split_nodes_interleave(u64 addr, u64 max_addr,
 			 * non-reserved memory is less than the per-node size.
 			 */
 			while (end - physnodes[i].start -
-				e820_hole_size(physnodes[i].start, end) < size) {
+				lmb_hole_size(physnodes[i].start, end) < size) {
 				end += FAKE_NODE_MIN_SIZE;
 				if (end > physnodes[i].end) {
 					end = physnodes[i].end;
@@ -470,7 +470,7 @@ static int __init split_nodes_interleave(u64 addr, u64 max_addr,
 			 * this one must extend to the boundary.
 			 */
 			if (end < dma32_end && dma32_end - end -
-			    e820_hole_size(end, dma32_end) < FAKE_NODE_MIN_SIZE)
+			    lmb_hole_size(end, dma32_end) < FAKE_NODE_MIN_SIZE)
 				end = dma32_end;
 
 			/*
@@ -479,7 +479,7 @@ static int __init split_nodes_interleave(u64 addr, u64 max_addr,
 			 * physical node.
 			 */
 			if (physnodes[i].end - end -
-			    e820_hole_size(end, physnodes[i].end) < size)
+			    lmb_hole_size(end, physnodes[i].end) < size)
 				end = physnodes[i].end;
 
 			/*
@@ -507,7 +507,7 @@ static u64 __init find_end_of_node(u64 start, u64 max_addr, u64 size)
 {
 	u64 end = start + size;
 
-	while (end - start - e820_hole_size(start, end) < size) {
+	while (end - start - lmb_hole_size(start, end) < size) {
 		end += FAKE_NODE_MIN_SIZE;
 		if (end > max_addr) {
 			end = max_addr;
@@ -536,7 +536,7 @@ static int __init split_nodes_size_interleave(u64 addr, u64 max_addr, u64 size)
 	 * creates a uniform distribution of node sizes across the entire
 	 * machine (but not necessarily over physical nodes).
 	 */
-	min_size = (max_addr - addr - e820_hole_size(addr, max_addr)) /
+	min_size = (max_addr - addr - lmb_hole_size(addr, max_addr)) /
 						MAX_NUMNODES;
 	min_size = max(min_size, FAKE_NODE_MIN_SIZE);
 	if ((min_size & FAKE_NODE_MIN_HASH_MASK) < min_size)
@@ -569,7 +569,7 @@ static int __init split_nodes_size_interleave(u64 addr, u64 max_addr, u64 size)
 			 * this one must extend to the boundary.
 			 */
 			if (end < dma32_end && dma32_end - end -
-			    e820_hole_size(end, dma32_end) < FAKE_NODE_MIN_SIZE)
+			    lmb_hole_size(end, dma32_end) < FAKE_NODE_MIN_SIZE)
 				end = dma32_end;
 
 			/*
@@ -578,7 +578,7 @@ static int __init split_nodes_size_interleave(u64 addr, u64 max_addr, u64 size)
 			 * physical node.
 			 */
 			if (physnodes[i].end - end -
-			    e820_hole_size(end, physnodes[i].end) < size)
+			    lmb_hole_size(end, physnodes[i].end) < size)
 				end = physnodes[i].end;
 
 			/*
@@ -642,7 +642,7 @@ static int __init numa_emulation(unsigned long start_pfn,
 	 */
 	remove_all_active_ranges();
 	for_each_node_mask(i, node_possible_map) {
-		e820_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
+		lmb_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
 						nodes[i].end >> PAGE_SHIFT);
 		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
 	}
@@ -695,7 +695,7 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
 	node_set(0, node_possible_map);
 	for (i = 0; i < nr_cpu_ids; i++)
 		numa_set_node(i, 0);
-	e820_register_active_regions(0, start_pfn, last_pfn);
+	lmb_register_active_regions(0, start_pfn, last_pfn);
 	setup_node_bootmem(0, start_pfn << PAGE_SHIFT, last_pfn << PAGE_SHIFT);
 }
 
diff --git a/arch/x86/mm/srat_32.c b/arch/x86/mm/srat_32.c
index 9324f13..68dd606 100644
--- a/arch/x86/mm/srat_32.c
+++ b/arch/x86/mm/srat_32.c
@@ -25,6 +25,7 @@
  */
 #include <linux/mm.h>
 #include <linux/bootmem.h>
+#include <linux/lmb.h>
 #include <linux/mmzone.h>
 #include <linux/acpi.h>
 #include <linux/nodemask.h>
@@ -264,7 +265,7 @@ int __init get_memcfg_from_srat(void)
 		if (node_read_chunk(chunk->nid, chunk))
 			continue;
 
-		e820_register_active_regions(chunk->nid, chunk->start_pfn,
+		lmb_register_active_regions(chunk->nid, chunk->start_pfn,
 					     min(chunk->end_pfn, max_pfn));
 	}
 	/* for out of order entries in SRAT */
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index f9897f7..23f274c 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/topology.h>
 #include <linux/bootmem.h>
+#include <linux/lmb.h>
 #include <linux/mm.h>
 #include <asm/proto.h>
 #include <asm/numa.h>
@@ -98,7 +99,7 @@ void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
 	unsigned long phys;
 
 	length = slit->header.length;
-	phys = find_e820_area(0, max_pfn_mapped<<PAGE_SHIFT, length,
+	phys = lmb_find_area(0, max_pfn_mapped<<PAGE_SHIFT, length,
 		 PAGE_SIZE);
 
 	if (phys == -1L)
@@ -106,7 +107,7 @@ void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
 
 	acpi_slit = __va(phys);
 	memcpy(acpi_slit, slit, length);
-	reserve_early(phys, phys + length, "ACPI SLIT");
+	lmb_reserve_area(phys, phys + length, "ACPI SLIT");
 }
 
 /* Callback for Proximity Domain -> x2APIC mapping */
@@ -324,7 +325,7 @@ static int __init nodes_cover_memory(const struct bootnode *nodes)
 			pxmram = 0;
 	}
 
-	e820ram = max_pfn - (e820_hole_size(0, max_pfn<<PAGE_SHIFT)>>PAGE_SHIFT);
+	e820ram = max_pfn - (lmb_hole_size(0, max_pfn<<PAGE_SHIFT)>>PAGE_SHIFT);
 	/* We seem to lose 3 pages somewhere. Allow 1M of slack. */
 	if ((long)(e820ram - pxmram) >= (1<<(20 - PAGE_SHIFT))) {
 		printk(KERN_ERR
@@ -421,7 +422,7 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 	}
 
 	for_each_node_mask(i, nodes_parsed)
-		e820_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
+		lmb_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
 						nodes[i].end >> PAGE_SHIFT);
 	/* for out of order entries in SRAT */
 	sort_node_map();
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 914f046..28185a8 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -44,6 +44,7 @@
 #include <linux/bug.h>
 #include <linux/module.h>
 #include <linux/gfp.h>
+#include <linux/lmb.h>
 
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
@@ -1735,7 +1736,7 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 	__xen_write_cr3(true, __pa(pgd));
 	xen_mc_issue(PARAVIRT_LAZY_CPU);
 
-	reserve_early(__pa(xen_start_info->pt_base),
+	lmb_reserve_area(__pa(xen_start_info->pt_base),
 		      __pa(xen_start_info->pt_base +
 			   xen_start_info->nr_pt_frames * PAGE_SIZE),
 		      "XEN PAGETABLES");
@@ -1773,7 +1774,7 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 
 	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE, PFN_DOWN(__pa(swapper_pg_dir)));
 
-	reserve_early(__pa(xen_start_info->pt_base),
+	lmb_reserve_area(__pa(xen_start_info->pt_base),
 		      __pa(xen_start_info->pt_base +
 			   xen_start_info->nr_pt_frames * PAGE_SIZE),
 		      "XEN PAGETABLES");
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index ad0047f..be3fcf3 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -8,6 +8,7 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/pm.h>
+#include <linux/lmb.h>
 
 #include <asm/elf.h>
 #include <asm/vdso.h>
@@ -61,7 +62,7 @@ char * __init xen_memory_setup(void)
 	 *  - xen_start_info
 	 * See comment above "struct start_info" in <xen/interface/xen.h>
 	 */
-	reserve_early(__pa(xen_start_info->mfn_list),
+	lmb_reserve_area(__pa(xen_start_info->mfn_list),
 		      __pa(xen_start_info->pt_base),
 			"XEN START INFO");
 
diff --git a/mm/bootmem.c b/mm/bootmem.c
index dac3f56..2a4c8b5 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -435,7 +435,7 @@ void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 			      unsigned long size)
 {
 #ifdef CONFIG_NO_BOOTMEM
-	free_early(physaddr, physaddr + size);
+	lmb_free_area(physaddr, physaddr + size);
 #else
 	unsigned long start, end;
 
@@ -460,7 +460,7 @@ void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 void __init free_bootmem(unsigned long addr, unsigned long size)
 {
 #ifdef CONFIG_NO_BOOTMEM
-	free_early(addr, addr + size);
+	lmb_free_area(addr, addr + size);
 #else
 	unsigned long start, end;
 
-- 
1.6.4.2

