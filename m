Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab1K1Tb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:31:57 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61072 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376Ab1K1Tby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:31:54 -0500
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        mingo@redhat.com, jonas@southpole.se, lennox.wu@gmail.com
Cc: Tejun Heo <tj@kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Michal Simek <monstr@monstr.eu>, Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [PATCH 06/23] memblock: Kill memblock_init()
Date: Mon, 28 Nov 2011 11:31:08 -0800
Message-Id: <1322508685-32532-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1322508685-32532-1-git-send-email-tj@kernel.org>
References: <1322508685-32532-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memblock_init() initializes arrays for regions and memblock itself;
however, all these can be done with struct initializers and
memblock_init() can be removed.  This patch kills memblock_init() and
initializes memblock with struct initializer.

The only difference is that the first dummy entries don't have .nid
set to MAX_NUMNODES initially.  This doesn't cause any behavior
difference.

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
 arch/arm/mm/init.c            |    1 -
 arch/microblaze/kernel/prom.c |    1 -
 arch/openrisc/kernel/prom.c   |    1 -
 arch/powerpc/kernel/prom.c    |    2 -
 arch/sh/mm/init.c             |    1 -
 arch/sparc/mm/init_64.c       |    2 -
 arch/unicore32/mm/init.c      |    1 -
 arch/x86/kernel/head32.c      |    2 -
 arch/x86/kernel/head64.c      |    2 -
 arch/x86/xen/enlighten.c      |    2 -
 include/linux/memblock.h      |    1 -
 mm/memblock.c                 |   48 ++++++++++++-----------------------------
 12 files changed, 14 insertions(+), 50 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 9863f03..4140843 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -333,7 +333,6 @@ void __init arm_memblock_init(struct meminfo *mi, struct machine_desc *mdesc)
 
 	sort(&meminfo.bank, meminfo.nr_banks, sizeof(meminfo.bank[0]), meminfo_cmp, NULL);
 
-	memblock_init();
 	for (i = 0; i < mi->nr_banks; i++)
 		memblock_add(mi->bank[i].start, mi->bank[i].size);
 
diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
index 977484a..4d65e97 100644
--- a/arch/microblaze/kernel/prom.c
+++ b/arch/microblaze/kernel/prom.c
@@ -122,7 +122,6 @@ void __init early_init_devtree(void *params)
 	of_scan_flat_dt(early_init_dt_scan_chosen, cmd_line);
 
 	/* Scan memory nodes and rebuild MEMBLOCKs */
-	memblock_init();
 	of_scan_flat_dt(early_init_dt_scan_root, NULL);
 	of_scan_flat_dt(early_init_dt_scan_memory, NULL);
 
diff --git a/arch/openrisc/kernel/prom.c b/arch/openrisc/kernel/prom.c
index 1bb58ba..7dbc6e0 100644
--- a/arch/openrisc/kernel/prom.c
+++ b/arch/openrisc/kernel/prom.c
@@ -76,7 +76,6 @@ void __init early_init_devtree(void *params)
 	of_scan_flat_dt(early_init_dt_scan_chosen, cmd_line);
 
 	/* Scan memory nodes and rebuild MEMBLOCKs */
-	memblock_init();
 	of_scan_flat_dt(early_init_dt_scan_root, NULL);
 	of_scan_flat_dt(early_init_dt_scan_memory, NULL);
 
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index fa1235b..a7ee83e 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -733,8 +733,6 @@ void __init early_init_devtree(void *params)
 	of_scan_flat_dt(early_init_dt_scan_chosen_ppc, cmd_line);
 
 	/* Scan memory nodes and rebuild MEMBLOCKs */
-	memblock_init();
-
 	of_scan_flat_dt(early_init_dt_scan_root, NULL);
 	of_scan_flat_dt(early_init_dt_scan_memory_ppc, NULL);
 
diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index 939ca0f..2528962 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -324,7 +324,6 @@ void __init paging_init(void)
 	unsigned long vaddr, end;
 	int nid;
 
-	memblock_init();
 	sh_mv.mv_mem_init();
 
 	early_reserve_mem();
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 8584a25..f42cc87 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -1769,8 +1769,6 @@ void __init paging_init(void)
 		sun4v_ktsb_init();
 	}
 
-	memblock_init();
-
 	/* Find available physical memory...
 	 *
 	 * Read it twice in order to work around a bug in openfirmware.
diff --git a/arch/unicore32/mm/init.c b/arch/unicore32/mm/init.c
index 5fb09e2..01e235b 100644
--- a/arch/unicore32/mm/init.c
+++ b/arch/unicore32/mm/init.c
@@ -246,7 +246,6 @@ void __init uc32_memblock_init(struct meminfo *mi)
 	sort(&meminfo.bank, meminfo.nr_banks, sizeof(meminfo.bank[0]),
 		meminfo_cmp, NULL);
 
-	memblock_init();
 	for (i = 0; i < mi->nr_banks; i++)
 		memblock_add(mi->bank[i].start, mi->bank[i].size);
 
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index be9282b..51ff186 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -31,8 +31,6 @@ static void __init i386_default_early_setup(void)
 
 void __init i386_start_kernel(void)
 {
-	memblock_init();
-
 	memblock_reserve(__pa_symbol(&_text),
 			 __pa_symbol(&__bss_stop) - __pa_symbol(&_text));
 
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index fd25b11..3a3b779 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -98,8 +98,6 @@ void __init x86_64_start_reservations(char *real_mode_data)
 {
 	copy_bootdata(__va(real_mode_data));
 
-	memblock_init();
-
 	memblock_reserve(__pa_symbol(&_text),
 			 __pa_symbol(&__bss_stop) - __pa_symbol(&_text));
 
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 1f92865..12eb07b 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1215,8 +1215,6 @@ asmlinkage void __init xen_start_kernel(void)
 	local_irq_disable();
 	early_boot_irqs_disabled = true;
 
-	memblock_init();
-
 	xen_raw_console_write("mapping kernel into physical memory\n");
 	pgd = xen_setup_kernel_pagetable(pgd, xen_start_info->nr_pages);
 	xen_ident_map_ISA();
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 1a3bee7..6ac91c5 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -52,7 +52,6 @@ phys_addr_t memblock_find_in_range(phys_addr_t start, phys_addr_t end,
 int memblock_free_reserved_regions(void);
 int memblock_reserve_reserved_regions(void);
 
-void memblock_init(void);
 void memblock_analyze(void);
 int memblock_add(phys_addr_t base, phys_addr_t size);
 int memblock_remove(phys_addr_t base, phys_addr_t size);
diff --git a/mm/memblock.c b/mm/memblock.c
index e808df8..5bbb87f 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -20,12 +20,23 @@
 #include <linux/seq_file.h>
 #include <linux/memblock.h>
 
-struct memblock memblock __initdata_memblock;
+static struct memblock_region memblock_memory_init_regions[INIT_MEMBLOCK_REGIONS] __initdata_memblock;
+static struct memblock_region memblock_reserved_init_regions[INIT_MEMBLOCK_REGIONS] __initdata_memblock;
+
+struct memblock memblock __initdata_memblock = {
+	.memory.regions		= memblock_memory_init_regions,
+	.memory.cnt		= 1,	/* empty dummy entry */
+	.memory.max		= INIT_MEMBLOCK_REGIONS,
+
+	.reserved.regions	= memblock_reserved_init_regions,
+	.reserved.cnt		= 1,	/* empty dummy entry */
+	.reserved.max		= INIT_MEMBLOCK_REGIONS,
+
+	.current_limit		= MEMBLOCK_ALLOC_ANYWHERE,
+};
 
 int memblock_debug __initdata_memblock;
 int memblock_can_resize __initdata_memblock;
-static struct memblock_region memblock_memory_init_regions[INIT_MEMBLOCK_REGIONS] __initdata_memblock;
-static struct memblock_region memblock_reserved_init_regions[INIT_MEMBLOCK_REGIONS] __initdata_memblock;
 
 /* inline so we don't get a warning when pr_debug is compiled out */
 static inline const char *memblock_type_name(struct memblock_type *type)
@@ -920,37 +931,6 @@ void __init memblock_analyze(void)
 	memblock_can_resize = 1;
 }
 
-void __init memblock_init(void)
-{
-	static int init_done __initdata = 0;
-
-	if (init_done)
-		return;
-	init_done = 1;
-
-	/* Hookup the initial arrays */
-	memblock.memory.regions	= memblock_memory_init_regions;
-	memblock.memory.max		= INIT_MEMBLOCK_REGIONS;
-	memblock.reserved.regions	= memblock_reserved_init_regions;
-	memblock.reserved.max	= INIT_MEMBLOCK_REGIONS;
-
-	/* Create a dummy zero size MEMBLOCK which will get coalesced away later.
-	 * This simplifies the memblock_add() code below...
-	 */
-	memblock.memory.regions[0].base = 0;
-	memblock.memory.regions[0].size = 0;
-	memblock_set_region_node(&memblock.memory.regions[0], MAX_NUMNODES);
-	memblock.memory.cnt = 1;
-
-	/* Ditto. */
-	memblock.reserved.regions[0].base = 0;
-	memblock.reserved.regions[0].size = 0;
-	memblock_set_region_node(&memblock.reserved.regions[0], MAX_NUMNODES);
-	memblock.reserved.cnt = 1;
-
-	memblock.current_limit = MEMBLOCK_ALLOC_ANYWHERE;
-}
-
 static int __init early_memblock(char *p)
 {
 	if (p && strstr(p, "debug"))
-- 
1.7.3.1

