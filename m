Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab1GNVhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:37:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:59901 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232Ab1GNVhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:37:46 -0400
Date: Thu, 14 Jul 2011 21:37:36 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-24aa07882b672fff2da2f5c955759f0bd13d32d5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        benh@kernel.crashing.org, yinghai@kernel.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, benh@kernel.crashing.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1310462166-31469-14-git-send-email-tj@kernel.org>
References: <1310462166-31469-14-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/memblock] memblock, x86: Replace memblock_x86_reserve/free_range() with generic ones
Git-Commit-ID: 24aa07882b672fff2da2f5c955759f0bd13d32d5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Jul 2011 21:37:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  24aa07882b672fff2da2f5c955759f0bd13d32d5
Gitweb:     http://git.kernel.org/tip/24aa07882b672fff2da2f5c955759f0bd13d32d5
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 12 Jul 2011 11:16:06 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 14 Jul 2011 11:47:53 -0700

memblock, x86: Replace memblock_x86_reserve/free_range() with generic ones

Other than sanity check and debug message, the x86 specific version of
memblock reserve/free functions are simple wrappers around the generic
versions - memblock_reserve/free().

This patch adds debug messages with caller identification to the
generic versions and replaces x86 specific ones and kills them.
arch/x86/include/asm/memblock.h and arch/x86/mm/memblock.c are empty
after this change and removed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1310462166-31469-14-git-send-email-tj@kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/memblock.h |    7 -------
 arch/x86/kernel/aperture_64.c   |    2 +-
 arch/x86/kernel/check.c         |    2 +-
 arch/x86/kernel/head.c          |    2 +-
 arch/x86/kernel/head32.c        |    5 +++--
 arch/x86/kernel/head64.c        |    5 +++--
 arch/x86/kernel/mpparse.c       |    6 ++----
 arch/x86/kernel/setup.c         |   17 ++++++++---------
 arch/x86/kernel/trampoline.c    |    2 +-
 arch/x86/mm/Makefile            |    2 --
 arch/x86/mm/init.c              |    6 +++---
 arch/x86/mm/memblock.c          |   34 ----------------------------------
 arch/x86/mm/memtest.c           |    2 +-
 arch/x86/mm/numa.c              |    5 ++---
 arch/x86/mm/numa_32.c           |    6 +++---
 arch/x86/mm/numa_emulation.c    |    4 ++--
 arch/x86/platform/efi/efi.c     |    6 ++----
 arch/x86/xen/mmu.c              |   12 ++++--------
 arch/x86/xen/setup.c            |    7 +++----
 include/linux/memblock.h        |    2 --
 mm/memblock.c                   |    5 +++++
 mm/nobootmem.c                  |    6 +++---
 22 files changed, 48 insertions(+), 97 deletions(-)

diff --git a/arch/x86/include/asm/memblock.h b/arch/x86/include/asm/memblock.h
deleted file mode 100644
index bc56670..0000000
--- a/arch/x86/include/asm/memblock.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _X86_MEMBLOCK_H
-#define _X86_MEMBLOCK_H
-
-void memblock_x86_reserve_range(u64 start, u64 end, char *name);
-void memblock_x86_free_range(u64 start, u64 end);
-
-#endif
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 5636308..6e76c19 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -94,7 +94,7 @@ static u32 __init allocate_aperture(void)
 				addr, aper_size>>10);
 		return 0;
 	}
-	memblock_x86_reserve_range(addr, addr + aper_size, "aperture64");
+	memblock_reserve(addr, aper_size);
 	/*
 	 * Kmemleak should not scan this block as it may not be mapped via the
 	 * kernel direct mapping.
diff --git a/arch/x86/kernel/check.c b/arch/x86/kernel/check.c
index 621cd23..5da1269 100644
--- a/arch/x86/kernel/check.c
+++ b/arch/x86/kernel/check.c
@@ -91,7 +91,7 @@ void __init setup_bios_corruption_check(void)
 		if (start >= end)
 			continue;
 
-		memblock_x86_reserve_range(start, end, "SCAN RAM");
+		memblock_reserve(start, end - start);
 		scan_areas[num_scan_areas].addr = start;
 		scan_areas[num_scan_areas].size = end - start;
 
diff --git a/arch/x86/kernel/head.c b/arch/x86/kernel/head.c
index af0699b..48d9d4e 100644
--- a/arch/x86/kernel/head.c
+++ b/arch/x86/kernel/head.c
@@ -52,5 +52,5 @@ void __init reserve_ebda_region(void)
 		lowmem = 0x9f000;
 
 	/* reserve all memory between lowmem and the 1MB mark */
-	memblock_x86_reserve_range(lowmem, 0x100000, "* BIOS reserved");
+	memblock_reserve(lowmem, 0x100000 - lowmem);
 }
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index 3bb0850..be9282b 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -33,7 +33,8 @@ void __init i386_start_kernel(void)
 {
 	memblock_init();
 
-	memblock_x86_reserve_range(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
+	memblock_reserve(__pa_symbol(&_text),
+			 __pa_symbol(&__bss_stop) - __pa_symbol(&_text));
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	/* Reserve INITRD */
@@ -42,7 +43,7 @@ void __init i386_start_kernel(void)
 		u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 		u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
 		u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
-		memblock_x86_reserve_range(ramdisk_image, ramdisk_end, "RAMDISK");
+		memblock_reserve(ramdisk_image, ramdisk_end - ramdisk_image);
 	}
 #endif
 
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 5655c22..fd25b11 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -100,7 +100,8 @@ void __init x86_64_start_reservations(char *real_mode_data)
 
 	memblock_init();
 
-	memblock_x86_reserve_range(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
+	memblock_reserve(__pa_symbol(&_text),
+			 __pa_symbol(&__bss_stop) - __pa_symbol(&_text));
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	/* Reserve INITRD */
@@ -109,7 +110,7 @@ void __init x86_64_start_reservations(char *real_mode_data)
 		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
 		unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
 		unsigned long ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
-		memblock_x86_reserve_range(ramdisk_image, ramdisk_end, "RAMDISK");
+		memblock_reserve(ramdisk_image, ramdisk_end - ramdisk_image);
 	}
 #endif
 
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 8faeaa0..a6b79c1 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -564,9 +564,7 @@ void __init default_get_smp_config(unsigned int early)
 
 static void __init smp_reserve_memory(struct mpf_intel *mpf)
 {
-	unsigned long size = get_mpc_size(mpf->physptr);
-
-	memblock_x86_reserve_range(mpf->physptr, mpf->physptr+size, "* MP-table mpc");
+	memblock_reserve(mpf->physptr, get_mpc_size(mpf->physptr));
 }
 
 static int __init smp_scan_config(unsigned long base, unsigned long length)
@@ -595,7 +593,7 @@ static int __init smp_scan_config(unsigned long base, unsigned long length)
 			       mpf, (u64)virt_to_phys(mpf));
 
 			mem = virt_to_phys(mpf);
-			memblock_x86_reserve_range(mem, mem + sizeof(*mpf), "* MP-table mpf");
+			memblock_reserve(mem, sizeof(*mpf));
 			if (mpf->physptr)
 				smp_reserve_memory(mpf);
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 31ffe20..97d227e 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -306,7 +306,8 @@ static void __init cleanup_highmap(void)
 static void __init reserve_brk(void)
 {
 	if (_brk_end > _brk_start)
-		memblock_x86_reserve_range(__pa(_brk_start), __pa(_brk_end), "BRK");
+		memblock_reserve(__pa(_brk_start),
+				 __pa(_brk_end) - __pa(_brk_start));
 
 	/* Mark brk area as locked down and no longer taking any
 	   new allocations */
@@ -337,7 +338,7 @@ static void __init relocate_initrd(void)
 
 	/* Note: this includes all the lowmem currently occupied by
 	   the initrd, we rely on that fact to keep the data intact. */
-	memblock_x86_reserve_range(ramdisk_here, ramdisk_here + area_size, "NEW RAMDISK");
+	memblock_reserve(ramdisk_here, area_size);
 	initrd_start = ramdisk_here + PAGE_OFFSET;
 	initrd_end   = initrd_start + ramdisk_size;
 	printk(KERN_INFO "Allocated new RAMDISK: %08llx - %08llx\n",
@@ -393,7 +394,7 @@ static void __init reserve_initrd(void)
 	initrd_start = 0;
 
 	if (ramdisk_size >= (end_of_lowmem>>1)) {
-		memblock_x86_free_range(ramdisk_image, ramdisk_end);
+		memblock_free(ramdisk_image, ramdisk_end - ramdisk_image);
 		printk(KERN_ERR "initrd too large to handle, "
 		       "disabling initrd\n");
 		return;
@@ -416,7 +417,7 @@ static void __init reserve_initrd(void)
 
 	relocate_initrd();
 
-	memblock_x86_free_range(ramdisk_image, ramdisk_end);
+	memblock_free(ramdisk_image, ramdisk_end - ramdisk_image);
 }
 #else
 static void __init reserve_initrd(void)
@@ -490,15 +491,13 @@ static void __init memblock_x86_reserve_range_setup_data(void)
 {
 	struct setup_data *data;
 	u64 pa_data;
-	char buf[32];
 
 	if (boot_params.hdr.version < 0x0209)
 		return;
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
 		data = early_memremap(pa_data, sizeof(*data));
-		sprintf(buf, "setup data %x", data->type);
-		memblock_x86_reserve_range(pa_data, pa_data+sizeof(*data)+data->len, buf);
+		memblock_reserve(pa_data, sizeof(*data) + data->len);
 		pa_data = data->next;
 		early_iounmap(data, sizeof(*data));
 	}
@@ -568,7 +567,7 @@ static void __init reserve_crashkernel(void)
 			return;
 		}
 	}
-	memblock_x86_reserve_range(crash_base, crash_base + crash_size, "CRASH KERNEL");
+	memblock_reserve(crash_base, crash_size);
 
 	printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
 			"for crashkernel (System RAM: %ldMB)\n",
@@ -626,7 +625,7 @@ static __init void reserve_ibft_region(void)
 	addr = find_ibft_region(&size);
 
 	if (size)
-		memblock_x86_reserve_range(addr, addr + size, "* ibft");
+		memblock_reserve(addr, size);
 }
 
 static unsigned reserve_low = CONFIG_X86_RESERVE_LOW << 10;
diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
index a1f13dd..a73b610 100644
--- a/arch/x86/kernel/trampoline.c
+++ b/arch/x86/kernel/trampoline.c
@@ -18,7 +18,7 @@ void __init setup_trampolines(void)
 		panic("Cannot allocate trampoline\n");
 
 	x86_trampoline_base = __va(mem);
-	memblock_x86_reserve_range(mem, mem + size, "TRAMPOLINE");
+	memblock_reserve(mem, size);
 
 	printk(KERN_DEBUG "Base memory trampoline at [%p] %llx size %zu\n",
 	       x86_trampoline_base, (unsigned long long)mem, size);
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 3d11327..23d8e5f 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -27,6 +27,4 @@ obj-$(CONFIG_AMD_NUMA)		+= amdtopology.o
 obj-$(CONFIG_ACPI_NUMA)		+= srat.o
 obj-$(CONFIG_NUMA_EMU)		+= numa_emulation.o
 
-obj-$(CONFIG_HAVE_MEMBLOCK)		+= memblock.o
-
 obj-$(CONFIG_MEMTEST)		+= memtest.o
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 13cf05a..0b736b9 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -81,7 +81,7 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 
 void __init native_pagetable_reserve(u64 start, u64 end)
 {
-	memblock_x86_reserve_range(start, end, "PGTABLE");
+	memblock_reserve(start, end - start);
 }
 
 struct map_range {
@@ -280,8 +280,8 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	 * pgt_buf_end) and free the other ones (pgt_buf_end - pgt_buf_top)
 	 * so that they can be reused for other purposes.
 	 *
-	 * On native it just means calling memblock_x86_reserve_range, on Xen it
-	 * also means marking RW the pagetable pages that we allocated before
+	 * On native it just means calling memblock_reserve, on Xen it also
+	 * means marking RW the pagetable pages that we allocated before
 	 * but that haven't been used.
 	 *
 	 * In fact on xen we mark RO the whole range pgt_buf_start -
diff --git a/arch/x86/mm/memblock.c b/arch/x86/mm/memblock.c
deleted file mode 100644
index 7325c5d..0000000
--- a/arch/x86/mm/memblock.c
+++ /dev/null
@@ -1,34 +0,0 @@
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/bitops.h>
-#include <linux/memblock.h>
-#include <linux/bootmem.h>
-#include <linux/mm.h>
-#include <linux/range.h>
-
-void __init memblock_x86_reserve_range(u64 start, u64 end, char *name)
-{
-	if (start == end)
-		return;
-
-	if (WARN_ONCE(start > end, "memblock_x86_reserve_range: wrong range [%#llx, %#llx)\n", start, end))
-		return;
-
-	memblock_dbg("    memblock_x86_reserve_range: [%#010llx-%#010llx] %16s\n", start, end - 1, name);
-
-	memblock_reserve(start, end - start);
-}
-
-void __init memblock_x86_free_range(u64 start, u64 end)
-{
-	if (start == end)
-		return;
-
-	if (WARN_ONCE(start > end, "memblock_x86_free_range: wrong range [%#llx, %#llx)\n", start, end))
-		return;
-
-	memblock_dbg("       memblock_x86_free_range: [%#010llx-%#010llx]\n", start, end - 1);
-
-	memblock_free(start, end - start);
-}
diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index 46a5ff2..c80b9fb 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -34,7 +34,7 @@ static void __init reserve_bad_mem(u64 pattern, u64 start_bad, u64 end_bad)
 	       (unsigned long long) pattern,
 	       (unsigned long long) start_bad,
 	       (unsigned long long) end_bad);
-	memblock_x86_reserve_range(start_bad, end_bad, "BAD RAM");
+	memblock_reserve(start_bad, end_bad - start_bad);
 }
 
 static void __init memtest(u64 pattern, u64 start_phys, u64 size)
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 88e5627..496f494 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -364,8 +364,7 @@ void __init numa_reset_distance(void)
 
 	/* numa_distance could be 1LU marking allocation failure, test cnt */
 	if (numa_distance_cnt)
-		memblock_x86_free_range(__pa(numa_distance),
-					__pa(numa_distance) + size);
+		memblock_free(__pa(numa_distance), size);
 	numa_distance_cnt = 0;
 	numa_distance = NULL;	/* enable table creation */
 }
@@ -394,7 +393,7 @@ static int __init numa_alloc_distance(void)
 		numa_distance = (void *)1LU;
 		return -ENOMEM;
 	}
-	memblock_x86_reserve_range(phys, phys + size, "NUMA DIST");
+	memblock_reserve(phys, size);
 
 	numa_distance = __va(phys);
 	numa_distance_cnt = cnt;
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 58878b5..534255a 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -204,7 +204,7 @@ void __init init_alloc_remap(int nid, u64 start, u64 end)
 			   size, nid);
 		return;
 	}
-	memblock_x86_reserve_range(node_pa, node_pa + size, "KVA RAM");
+	memblock_reserve(node_pa, size);
 
 	remap_pa = memblock_find_in_range(min_low_pfn << PAGE_SHIFT,
 					  max_low_pfn << PAGE_SHIFT,
@@ -212,10 +212,10 @@ void __init init_alloc_remap(int nid, u64 start, u64 end)
 	if (!remap_pa) {
 		pr_warning("remap_alloc: failed to allocate %lu bytes remap area for node %d\n",
 			   size, nid);
-		memblock_x86_free_range(node_pa, node_pa + size);
+		memblock_free(node_pa, size);
 		return;
 	}
-	memblock_x86_reserve_range(remap_pa, remap_pa + size, "KVA PG");
+	memblock_reserve(remap_pa, size);
 	remap_va = phys_to_virt(remap_pa);
 
 	/* perform actual remap */
diff --git a/arch/x86/mm/numa_emulation.c b/arch/x86/mm/numa_emulation.c
index 971fe70..46db568 100644
--- a/arch/x86/mm/numa_emulation.c
+++ b/arch/x86/mm/numa_emulation.c
@@ -361,7 +361,7 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 			pr_warning("NUMA: Warning: can't allocate copy of distance table, disabling emulation\n");
 			goto no_emu;
 		}
-		memblock_x86_reserve_range(phys, phys + phys_size, "TMP NUMA DIST");
+		memblock_reserve(phys, phys_size);
 		phys_dist = __va(phys);
 
 		for (i = 0; i < numa_dist_cnt; i++)
@@ -430,7 +430,7 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 
 	/* free the copied physical distance table */
 	if (phys_dist)
-		memblock_x86_free_range(__pa(phys_dist), __pa(phys_dist) + phys_size);
+		memblock_free(__pa(phys_dist), phys_size);
 	return;
 
 no_emu:
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index a4c322c..3b4e86b 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -280,8 +280,7 @@ void __init efi_memblock_x86_reserve_range(void)
 		boot_params.efi_info.efi_memdesc_size;
 	memmap.desc_version = boot_params.efi_info.efi_memdesc_version;
 	memmap.desc_size = boot_params.efi_info.efi_memdesc_size;
-	memblock_x86_reserve_range(pmap, pmap + memmap.nr_map * memmap.desc_size,
-		      "EFI memmap");
+	memblock_reserve(pmap, memmap.nr_map * memmap.desc_size);
 }
 
 #if EFI_DEBUG
@@ -332,8 +331,7 @@ void __init efi_reserve_boot_services(void)
 					"[0x%010llx-0x%010llx]\n",
 						start, start+size-1);
 		} else
-			memblock_x86_reserve_range(start, start+size,
-							"EFI Boot");
+			memblock_reserve(start, size);
 	}
 }
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 0ccccb6..ad54fa1 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1720,10 +1720,8 @@ pgd_t * __init xen_setup_kernel_pagetable(pgd_t *pgd,
 	__xen_write_cr3(true, __pa(pgd));
 	xen_mc_issue(PARAVIRT_LAZY_CPU);
 
-	memblock_x86_reserve_range(__pa(xen_start_info->pt_base),
-		      __pa(xen_start_info->pt_base +
-			   xen_start_info->nr_pt_frames * PAGE_SIZE),
-		      "XEN PAGETABLES");
+	memblock_reserve(__pa(xen_start_info->pt_base),
+			 xen_start_info->nr_pt_frames * PAGE_SIZE);
 
 	return pgd;
 }
@@ -1799,10 +1797,8 @@ pgd_t * __init xen_setup_kernel_pagetable(pgd_t *pgd,
 			  PFN_DOWN(__pa(initial_page_table)));
 	xen_write_cr3(__pa(initial_page_table));
 
-	memblock_x86_reserve_range(__pa(xen_start_info->pt_base),
-		      __pa(xen_start_info->pt_base +
-			   xen_start_info->nr_pt_frames * PAGE_SIZE),
-		      "XEN PAGETABLES");
+	memblock_reserve(__pa(xen_start_info->pt_base),
+			 xen_start_info->nr_pt_frames * PAGE_SIZE));
 
 	return initial_page_table;
 }
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 60aeeb5..73daaf7 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -63,7 +63,7 @@ static void __init xen_add_extra_mem(unsigned long pages)
 	e820_add_region(extra_start, size, E820_RAM);
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 
-	memblock_x86_reserve_range(extra_start, extra_start + size, "XEN EXTRA");
+	memblock_reserve(extra_start, size);
 
 	xen_extra_mem_size += size;
 
@@ -287,9 +287,8 @@ char * __init xen_memory_setup(void)
 	 *  - xen_start_info
 	 * See comment above "struct start_info" in <xen/interface/xen.h>
 	 */
-	memblock_x86_reserve_range(__pa(xen_start_info->mfn_list),
-		      __pa(xen_start_info->pt_base),
-			"XEN START INFO");
+	memblock_reserve(__pa(xen_start_info->mfn_list),
+			 xen_start_info->pt_base - xen_start_info->mfn_list);
 
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 2491355..9074631 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -17,8 +17,6 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 
-#include <asm/memblock.h>
-
 #define INIT_MEMBLOCK_REGIONS	128
 
 struct memblock_region {
diff --git a/mm/memblock.c b/mm/memblock.c
index ebc6119..0cb4da6 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -449,6 +449,9 @@ long __init_memblock memblock_remove(phys_addr_t base, phys_addr_t size)
 
 long __init_memblock memblock_free(phys_addr_t base, phys_addr_t size)
 {
+	memblock_dbg("   memblock_free: [%#016llx-%#016llx] %pF\n",
+		     base, base + size, (void *)_RET_IP_);
+
 	return __memblock_remove(&memblock.reserved, base, size);
 }
 
@@ -456,6 +459,8 @@ long __init_memblock memblock_reserve(phys_addr_t base, phys_addr_t size)
 {
 	struct memblock_type *_rgn = &memblock.reserved;
 
+	memblock_dbg("memblock_reserve: [%#016llx-%#016llx] %pF\n",
+		     base, base + size, (void *)_RET_IP_);
 	BUG_ON(0 == size);
 
 	return memblock_add_region(_rgn, base, size);
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 7075bc0..29d948c 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -47,7 +47,7 @@ static void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
 
 	ptr = phys_to_virt(addr);
 	memset(ptr, 0, size);
-	memblock_x86_reserve_range(addr, addr + size, "BOOTMEM");
+	memblock_reserve(addr, size);
 	/*
 	 * The min_count is set to 0 so that bootmem allocated blocks
 	 * are never reported as leaks.
@@ -175,7 +175,7 @@ void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 			      unsigned long size)
 {
 	kmemleak_free_part(__va(physaddr), size);
-	memblock_x86_free_range(physaddr, physaddr + size);
+	memblock_free(physaddr, size);
 }
 
 /**
@@ -190,7 +190,7 @@ void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 void __init free_bootmem(unsigned long addr, unsigned long size)
 {
 	kmemleak_free_part(__va(addr), size);
-	memblock_x86_free_range(addr, addr + size);
+	memblock_free(addr, size);
 }
 
 static void * __init ___alloc_bootmem_nopanic(unsigned long size,
