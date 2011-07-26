Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab1GZPkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:40:32 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:60404 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab1GZPgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 11:36:05 -0400
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@redhat.com, Tejun Heo <tj@kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Michal Simek <monstr@monstr.eu>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [PATCH 13/23] memblock: s/memblock_analyze()/memblock_allow_resize()/ and update users
Date: Tue, 26 Jul 2011 17:35:24 +0200
Message-Id: <1311694534-5161-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311694534-5161-1-git-send-email-tj@kernel.org>
References: <1311694534-5161-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only function of memblock_analyze() is now allowing resize of
memblock region arrays.  Rename it to memblock_allow_resize() and
update its users.

* The following users remain the same other than renaming.

  arm/mm/init.c::arm_memblock_init()
  microblaze/kernel/prom.c::early_init_devtree()
  powerpc/kernel/prom.c::early_init_devtree()
  sh/mm/init.c::paging_init()
  sparc/mm/init_64.c::paging_init()
  unicore32/mm/init.c::uc32_memblock_init()

* In the following users, analyze was used to update total size which
  is no longer necessary.

  powerpc/kernel/machine_kexec.c::reserve_crashkernel()
  powerpc/kernel/prom.c::early_init_devtree()
  powerpc/mm/init_32.c::MMU_init()
  powerpc/mm/tlb_nohash.c::__early_init_mmu()
  powerpc/platforms/ps3/mm.c::ps3_mm_add_memory()
  powerpc/platforms/embedded6xx/wii.c::wii_memory_fixups()
  sh/kernel/machine_kexec.c::reserve_crashkernel()

* x86/kernel/e820.c::memblock_x86_fill() was directly setting
  memblock_can_resize before populating memblock and calling analyze
  afterwards.  Call memblock_allow_resize() before start populating.

memblock_can_resize is now static inside memblock.c.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/arm/mm/init.c                       |    2 +-
 arch/microblaze/kernel/prom.c            |    2 +-
 arch/powerpc/kernel/machine_kexec.c      |    3 ---
 arch/powerpc/kernel/prom.c               |    3 +--
 arch/powerpc/mm/init_32.c                |    2 --
 arch/powerpc/mm/tlb_nohash.c             |    1 -
 arch/powerpc/platforms/embedded6xx/wii.c |    1 -
 arch/powerpc/platforms/ps3/mm.c          |    1 -
 arch/sh/kernel/machine_kexec.c           |    3 ---
 arch/sh/mm/init.c                        |    2 +-
 arch/sparc/mm/init_64.c                  |    2 +-
 arch/unicore32/mm/init.c                 |    2 +-
 arch/x86/kernel/e820.c                   |    3 +--
 include/linux/memblock.h                 |    3 +--
 mm/memblock.c                            |    5 ++---
 15 files changed, 10 insertions(+), 25 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index f040b75..daf9420 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -357,7 +357,7 @@ void __init arm_memblock_init(struct meminfo *mi, struct machine_desc *mdesc)
 	if (mdesc->reserve)
 		mdesc->reserve();
 
-	memblock_analyze();
+	memblock_allow_resize();
 	memblock_dump_all();
 }
 
diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
index 9d8608a..6433fe2 100644
--- a/arch/microblaze/kernel/prom.c
+++ b/arch/microblaze/kernel/prom.c
@@ -140,7 +140,7 @@ void __init early_init_devtree(void *params)
 	strlcpy(boot_command_line, cmd_line, COMMAND_LINE_SIZE);
 	parse_early_param();
 
-	memblock_analyze();
+	memblock_allow_resize();
 
 	pr_debug("Phys. mem: %lx\n", (unsigned long) memblock_phys_mem_size());
 
diff --git a/arch/powerpc/kernel/machine_kexec.c b/arch/powerpc/kernel/machine_kexec.c
index 7ee50f0..7fa942f 100644
--- a/arch/powerpc/kernel/machine_kexec.c
+++ b/arch/powerpc/kernel/machine_kexec.c
@@ -107,9 +107,6 @@ void __init reserve_crashkernel(void)
 	unsigned long long crash_size, crash_base;
 	int ret;
 
-	/* this is necessary because of memblock_phys_mem_size() */
-	memblock_analyze();
-
 	/* use common parsing */
 	ret = parse_crashkernel(boot_command_line, memblock_phys_mem_size(),
 			&crash_size, &crash_base);
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 16a632f..c0c9504 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -740,11 +740,10 @@ void __init early_init_devtree(void *params)
 	 * Ensure that total memory size is page-aligned, because otherwise
 	 * mark_bootmem() gets upset.
 	 */
-	memblock_analyze();
 	limit = ALIGN(memory_limit ?: memblock_phys_mem_size(), PAGE_SIZE);
 	memblock_enforce_memory_limit(limit);
 
-	memblock_analyze();
+	memblock_allow_resize();
 	memblock_dump_all();
 
 	DBG("Phys. mem: %llx\n", memblock_phys_mem_size());
diff --git a/arch/powerpc/mm/init_32.c b/arch/powerpc/mm/init_32.c
index d6c2607..6105894 100644
--- a/arch/powerpc/mm/init_32.c
+++ b/arch/powerpc/mm/init_32.c
@@ -126,7 +126,6 @@ void __init MMU_init(void)
 	if (memblock.memory.cnt > 1) {
 #ifndef CONFIG_WII
 		memblock_enforce_memory_limit(memblock.memory.regions[0].size);
-		memblock_analyze();
 		printk(KERN_WARNING "Only using first contiguous memory region");
 #else
 		wii_memory_fixups();
@@ -149,7 +148,6 @@ void __init MMU_init(void)
 #ifndef CONFIG_HIGHMEM
 		total_memory = total_lowmem;
 		memblock_enforce_memory_limit(total_lowmem);
-		memblock_analyze();
 #endif /* CONFIG_HIGHMEM */
 	}
 
diff --git a/arch/powerpc/mm/tlb_nohash.c b/arch/powerpc/mm/tlb_nohash.c
index 0bdad3a..cde8770 100644
--- a/arch/powerpc/mm/tlb_nohash.c
+++ b/arch/powerpc/mm/tlb_nohash.c
@@ -548,7 +548,6 @@ static void __early_init_mmu(int boot_cpu)
 
 		/* limit memory so we dont have linear faults */
 		memblock_enforce_memory_limit(linear_map_top);
-		memblock_analyze();
 	}
 #endif
 
diff --git a/arch/powerpc/platforms/embedded6xx/wii.c b/arch/powerpc/platforms/embedded6xx/wii.c
index 1cbe9d3..6d8dadf 100644
--- a/arch/powerpc/platforms/embedded6xx/wii.c
+++ b/arch/powerpc/platforms/embedded6xx/wii.c
@@ -88,7 +88,6 @@ void __init wii_memory_fixups(void)
 	wii_hole_size = p[1].base - wii_hole_start;
 	memblock_add(wii_hole_start, wii_hole_size);
 	memblock_reserve(wii_hole_start, wii_hole_size);
-	memblock_analyze();
 
 	BUG_ON(memblock.memory.cnt != 1);
 	__memblock_dump_all();
diff --git a/arch/powerpc/platforms/ps3/mm.c b/arch/powerpc/platforms/ps3/mm.c
index c204588..81c40b9 100644
--- a/arch/powerpc/platforms/ps3/mm.c
+++ b/arch/powerpc/platforms/ps3/mm.c
@@ -319,7 +319,6 @@ static int __init ps3_mm_add_memory(void)
 	}
 
 	memblock_add(start_addr, map.r1.size);
-	memblock_analyze();
 
 	result = online_pages(start_pfn, nr_pages);
 
diff --git a/arch/sh/kernel/machine_kexec.c b/arch/sh/kernel/machine_kexec.c
index e2a3af3..cbc233e 100644
--- a/arch/sh/kernel/machine_kexec.c
+++ b/arch/sh/kernel/machine_kexec.c
@@ -157,9 +157,6 @@ void __init reserve_crashkernel(void)
 	unsigned long long crash_size, crash_base;
 	int ret;
 
-	/* this is necessary because of memblock_phys_mem_size() */
-	memblock_analyze();
-
 	ret = parse_crashkernel(boot_command_line, memblock_phys_mem_size(),
 			&crash_size, &crash_base);
 	if (ret == 0 && crash_size > 0) {
diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index 99d7ea3..5125ab0 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -335,7 +335,7 @@ void __init paging_init(void)
 		sh_mv.mv_mem_reserve();
 
 	memblock_enforce_memory_limit(memory_limit);
-	memblock_analyze();
+	memblock_allow_resize();
 
 	memblock_dump_all();
 
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index a7a525a..ae9bab4 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -1749,7 +1749,7 @@ void __init paging_init(void)
 
 	memblock_enforce_memory_limit(cmdline_memory_size);
 
-	memblock_analyze();
+	memblock_allow_resize();
 	memblock_dump_all();
 
 	set_bit(0, mmu_context_bmap);
diff --git a/arch/unicore32/mm/init.c b/arch/unicore32/mm/init.c
index c3265f3..64a2835 100644
--- a/arch/unicore32/mm/init.c
+++ b/arch/unicore32/mm/init.c
@@ -262,7 +262,7 @@ void __init uc32_memblock_init(struct meminfo *mi)
 
 	uc32_mm_memblock_reserve();
 
-	memblock_analyze();
+	memblock_allow_resize();
 	memblock_dump_all();
 }
 
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 84475f1..0b05eb0 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1071,7 +1071,7 @@ void __init memblock_x86_fill(void)
 	 * We are safe to enable resizing, beause memblock_x86_fill()
 	 * is rather later for x86
 	 */
-	memblock_can_resize = 1;
+	memblock_allow_resize();
 
 	for (i = 0; i < e820.nr_map; i++) {
 		struct e820entry *ei = &e820.map[i];
@@ -1086,7 +1086,6 @@ void __init memblock_x86_fill(void)
 		memblock_add(ei->addr, ei->size);
 	}
 
-	memblock_analyze();
 	memblock_dump_all();
 }
 
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 3d3c8ce..208bfc9 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -42,7 +42,6 @@ struct memblock {
 
 extern struct memblock memblock;
 extern int memblock_debug;
-extern int memblock_can_resize;
 
 #define memblock_dbg(fmt, ...) \
 	if (memblock_debug) printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
@@ -52,7 +51,7 @@ phys_addr_t memblock_find_in_range(phys_addr_t start, phys_addr_t end,
 int memblock_free_reserved_regions(void);
 int memblock_reserve_reserved_regions(void);
 
-void memblock_analyze(void);
+void memblock_allow_resize(void);
 int memblock_add(phys_addr_t base, phys_addr_t size);
 int memblock_remove(phys_addr_t base, phys_addr_t size);
 int memblock_free(phys_addr_t base, phys_addr_t size);
diff --git a/mm/memblock.c b/mm/memblock.c
index 051bc4e..d74efa3 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -36,7 +36,7 @@ struct memblock memblock __initdata_memblock = {
 };
 
 int memblock_debug __initdata_memblock;
-int memblock_can_resize __initdata_memblock;
+static int memblock_can_resize __initdata_memblock;
 
 /* inline so we don't get a warning when pr_debug is compiled out */
 static inline const char *memblock_type_name(struct memblock_type *type)
@@ -912,9 +912,8 @@ void __init_memblock __memblock_dump_all(void)
 	memblock_dump(&memblock.reserved, "reserved");
 }
 
-void __init memblock_analyze(void)
+void __init memblock_allow_resize(void)
 {
-	/* We allow resizing from there */
 	memblock_can_resize = 1;
 }
 
-- 
1.7.6

