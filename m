Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759772Ab2HKBZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 21:25:59 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57429 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759506Ab2HKBZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 21:25:47 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <arnd@arndb.de>, <catalin.marinas@arm.com>, <grant.likely@secretlab.ca>,
        <nico@linaro.org>, <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        Cyril Chemparathy <cyril@ti.com>, Vitaly Andrianov <vitalya@ti.com>
Subject: [PATCH v2 19/22] ARM: recreate kernel mappings in early_paging_init()
Date: Fri, 10 Aug 2012 21:25:02 -0400
Message-ID: <1344648306-15619-20-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344648306-15619-1-git-send-email-cyril@ti.com>
References: <1344648306-15619-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a step in the init sequence, in order to recreate the kernel
code/data page table mappings prior to full paging initialization.  This is
necessary on LPAE systems that run out of a physical address space outside the
4G limit.  On these systems, this implementation provides a machine descriptor
hook that allows the PHYS_OFFSET to be overridden in a machine specific
fashion.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
---
 arch/arm/include/asm/mach/arch.h |    1 +
 arch/arm/kernel/setup.c          |    3 ++
 arch/arm/mm/mmu.c                |   65 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+)

diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
index 0b1c94b..2b9ecc5 100644
--- a/arch/arm/include/asm/mach/arch.h
+++ b/arch/arm/include/asm/mach/arch.h
@@ -37,6 +37,7 @@ struct machine_desc {
 	char			restart_mode;	/* default restart mode	*/
 	void			(*fixup)(struct tag *, char **,
 					 struct meminfo *);
+	void			(*init_meminfo)(void);
 	void			(*reserve)(void);/* reserve mem blocks	*/
 	void			(*map_io)(void);/* IO mapping function	*/
 	void			(*init_early)(void);
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index edb4f42..e37cbaf 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -79,6 +79,7 @@ static int __init fpe_setup(char *line)
 __setup("fpe=", fpe_setup);
 #endif
 
+extern void early_paging_init(struct machine_desc *, struct proc_info_list *);
 extern void paging_init(struct machine_desc *desc);
 extern void sanity_check_meminfo(void);
 extern void reboot_setup(char *str);
@@ -978,6 +979,8 @@ void __init setup_arch(char **cmdline_p)
 	parse_early_param();
 
 	sort(&meminfo.bank, meminfo.nr_banks, sizeof(meminfo.bank[0]), meminfo_cmp, NULL);
+
+	early_paging_init(mdesc, lookup_processor_type(read_cpuid_id()));
 	sanity_check_meminfo();
 	arm_memblock_init(&meminfo, mdesc);
 
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 662684b..5d240da 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -28,6 +28,7 @@
 #include <asm/highmem.h>
 #include <asm/system_info.h>
 #include <asm/traps.h>
+#include <asm/procinfo.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -1168,6 +1169,70 @@ static void __init map_lowmem(void)
 	}
 }
 
+#ifdef CONFIG_ARM_LPAE
+/*
+ * early_paging_init() recreates boot time page table setup, allowing machines
+ * to switch over to a high (>4G) address space on LPAE systems
+ */
+void __init early_paging_init(struct machine_desc *mdesc,
+			      struct proc_info_list *procinfo)
+{
+	pmdval_t pmdprot = procinfo->__cpu_mm_mmu_flags;
+	unsigned long map_start, map_end;
+	pgd_t *pgd0, *pgdk;
+	pud_t *pud0, *pudk;
+	pmd_t *pmd0, *pmdk;
+	phys_addr_t phys;
+	int i;
+
+	/* remap kernel code and data */
+	map_start = init_mm.start_code;
+	map_end   = init_mm.brk;
+
+	/* get a handle on things... */
+	pgd0 = pgd_offset_k(0);
+	pud0 = pud_offset(pgd0, 0);
+	pmd0 = pmd_offset(pud0, 0);
+
+	pgdk = pgd_offset_k(map_start);
+	pudk = pud_offset(pgdk, map_start);
+	pmdk = pmd_offset(pudk, map_start);
+
+	phys = PHYS_OFFSET;
+
+	if (mdesc->init_meminfo)
+		mdesc->init_meminfo();
+
+	/* remap level 1 table */
+	for (i = 0; i < PTRS_PER_PGD; i++) {
+		*pud0++ = __pud(__pa(pmd0) | PMD_TYPE_TABLE | L_PGD_SWAPPER);
+		pmd0 += PTRS_PER_PMD;
+	}
+
+	/* remap pmds for kernel mapping */
+	phys = __pa(map_start) & PMD_MASK;
+	do {
+		*pmdk++ = __pmd(phys | pmdprot);
+		phys += PMD_SIZE;
+	} while (phys < map_end);
+
+	flush_cache_all();
+	cpu_set_ttbr(0, __pa(pgd0));
+	cpu_set_ttbr(1, __pa(pgd0) + TTBR1_OFFSET);
+	local_flush_tlb_all();
+}
+
+#else
+
+void __init early_paging_init(struct machine_desc *mdesc,
+			      struct proc_info_list *procinfo)
+{
+	if (mdesc->init_meminfo)
+		mdesc->init_meminfo();
+}
+
+#endif
+
 /*
  * paging_init() sets up the page tables, initialises the zone memory
  * maps, and sets up the zero page, bad page and bad page tables.
-- 
1.7.9.5

