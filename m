Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab0KWUlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 15:41:49 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:51243 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab0KWUlr (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 23 Nov 2010 15:41:47 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH] xen/mmu, x86-32: Make swapper_pg_dir writeable before calling setup_arch.
Date: Tue, 23 Nov 2010 15:41:36 -0500
Message-Id: <1290544896-20754-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290544896-20754-1-git-send-email-konrad.wilk@oracle.com>
References: <1290544896-20754-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

git commit b40827fa7268fda8a62490728a61c2856f33830b ("x86-32, mm: Add an initial
page table for core bootstrapping") makes swapper_pg_dir be empty during
early bootup and uses initial_page_table for the startup code. In setup_arch()
it copies the contents of initial_page_table to swapper_pg_dir and pivots the
cr3 to use swapper_pg_dir. Later on, at the end of setup_arch() it copies
swapper_pg_dir contents to initial_page_table.

While that works for baremetal, under Xen, before the setup_arch is called we
setup swapper_pg_dir to be RO and also load it in %cr3, and initial_page_table is empty.

To work with with the requirement of copying the contents of initial_page_table
to swapper_pg_dir, and then latter vice-versa this patch introduces a new mechanism
to pivot over to initial_page_table right before calling setup_arch and also set
swapper_pg_dir to be writeable. Then right before setup_arch calls clone_pg_dir to copy
swapper_pg_dir to initial_page_table (so back) we pivot our PGD from initial_page_table
to swapper_pg_dir and set initial_page_table writeable.

There is an extra piece of logic where we inhibit loading of cr3 between
the start of setup_arch() up to x86_init.paging.pagetable_setup_start(). This
is b/c Xen requires the PGD to be _RO and there are no calls in between
those code paths that does that - so we end up with a nasty error from Xen with
no updates to cr3.

This patch makes it possible to bootup PAE Xen PV guest. 2.6.36 did not have
this issues as it did not have git commit b40827fa7268fda8a62490728a61c2856f33830b.

CC: Borislav Petkov <bp@alien8.de>
CC: H. Peter Anvin <hpa@linux.intel.com>
CC: Ian Campbell <Ian.Campbell@eu.citrix.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c |    1 +
 arch/x86/xen/mmu.c       |  100 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/xen/xen-ops.h   |    2 +
 3 files changed, 103 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 7250bef..8114fdb 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1256,6 +1256,7 @@ asmlinkage void __init xen_start_kernel(void)
 
 	/* Start the world */
 #ifdef CONFIG_X86_32
+	xen_mk_swapper_pg_dir_writeable();
 	i386_start_kernel();
 #else
 	x86_64_start_reservations((char *)__pa_symbol(&boot_params));
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index bd2713a..b4b03cd 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1590,6 +1590,9 @@ void xen_exit_mmap(struct mm_struct *mm)
 
 static __init void xen_pagetable_setup_start(pgd_t *base)
 {
+#ifdef CONFIG_X86_32
+	xen_mk_swapper_pg_dir_writeable_fixup();
+#endif
 }
 
 static void xen_post_allocator_init(void);
@@ -2264,7 +2267,104 @@ __init void xen_ident_map_ISA(void)
 
 	xen_flush_tlb();
 }
+#ifdef CONFIG_X86_64
+__init void xen_mk_swapper_pg_dir_writeable(void) { }
+#else
+static RESERVE_BRK_ARRAY(pmd_t, level2_kernel_pgt_bak, PTRS_PER_PMD);
+
+static void xen_mk_swapper_pg_dir_writeable_write_cr3(unsigned long cr3)
+{
+}
+
+__init void xen_mk_swapper_pg_dir_writeable(void)
+{
+	/* The purpose of this code is to make swapper_pg_dir writeable.
+	 * 
+	 * We need that b/c in setup_arch clone_pgd_range is used to copy
+	 * from initial_page_table to swapper_pg_dir and we fault early.
+	 *
+	 * To make swapper_pg_dir writeable we need to stop using the
+	 * swapper_pg_dir as PGD and create a whole new pgd with puds copied
+	 * from the swapper_pg_dir. For that we deep-copy (one level) the
+	 * swapper_pg_dir to initial_page_table and swap over to that one.
+	 */
 
+	/* Inhibit the write_cr3 as Xen requires the pagetable that is to be
+	 * the PGD to be RO and the code in arch_setup does not set it as so,
+	 * so to inhibit Xen hypervisor from throwing errors.  We set this to
+	 * stub (later in xen_mk_swapper_pg_dir_writeable_done we restore it). */
+	pv_mmu_ops.write_cr3 = xen_mk_swapper_pg_dir_writeable_write_cr3;
+
+	/* Create a deep (one-level) copy of swapper_pg_dir */
+	level2_kernel_pgt_bak = extend_brk(sizeof(pmd_t) * PTRS_PER_PMD, PAGE_SIZE);
+
+	memcpy(level2_kernel_pgt_bak,
+		m2v(swapper_pg_dir[KERNEL_PGD_BOUNDARY].pgd),
+		sizeof(pmd_t) * PTRS_PER_PMD);
+
+	memcpy(initial_page_table, swapper_pg_dir, sizeof(pgd_t) * PTRS_PER_PGD);
+	set_pgd(&initial_page_table[KERNEL_PGD_BOUNDARY],
+			__pgd(__pa(level2_kernel_pgt_bak) | _PAGE_PRESENT));
+
+	/* L3 and the slot it points to _MUST_ be RO */
+	set_page_prot(initial_page_table, PAGE_KERNEL_RO);
+	set_page_prot(level2_kernel_pgt_bak, PAGE_KERNEL_RO);
+
+	/* Pivot over to the new PGD. */
+	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(swapper_pg_dir)));
+
+	xen_write_cr3(__pa(initial_page_table));
+
+	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE, PFN_DOWN(__pa(initial_page_table)));
+
+	/* And now swapper_pg_dir + level2_kernel_pgt is writeable. */
+	set_page_prot(swapper_pg_dir, PAGE_KERNEL);
+	set_page_prot(level2_kernel_pgt, PAGE_KERNEL);
+
+	printk(KERN_INFO "Pivoting from PGD: 0x%lx to 0x%lx\n",
+			PFN_DOWN(__pa(swapper_pg_dir)),
+			PFN_DOWN(__pa(initial_page_table)));
+}
+__init void xen_mk_swapper_pg_dir_writeable_fixup(void)
+{
+	int i;
+	/* We MUST copy over the new L2 data as it has been updated. */
+	memcpy(level2_kernel_pgt, level2_kernel_pgt_bak,
+		sizeof(pmd_t) * PTRS_PER_PMD);
+
+	set_pgd(&swapper_pg_dir[KERNEL_PGD_BOUNDARY],
+			__pgd(__pa(level2_kernel_pgt) | _PAGE_PRESENT));
+
+	for (i = 0; i < KERNEL_PGD_PTRS; i++) {
+		if (swapper_pg_dir[i].pgd != initial_page_table[i].pgd)
+			xen_raw_printk("[%3d] 0x%lx != 0x%lx\n", i, swapper_pg_dir[i],
+				initial_page_table[i]);
+		if (swapper_pg_dir[i].pgd != 0)
+			xen_raw_printk("[%3d] 0x%lx\n", i, swapper_pg_dir[i]);
+	}
+
+	set_page_prot(swapper_pg_dir, PAGE_KERNEL_RO);
+	set_page_prot(level2_kernel_pgt, PAGE_KERNEL_RO);
+
+	/* Swap PGD over to swapper_pg_dir. */
+	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(initial_page_table)));
+
+	xen_write_cr3(__pa(swapper_pg_dir));
+
+	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE, PFN_DOWN(__pa(swapper_pg_dir)));
+
+	/* And now initial page table is writeable. */
+	set_page_prot(initial_page_table, PAGE_KERNEL);
+	set_page_prot(level2_kernel_pgt_bak, PAGE_KERNEL);
+
+	/* Restore the CR3 operation. */
+	pv_mmu_ops.write_cr3 = xen_write_cr3;
+
+	printk(KERN_INFO "Pivoting back from PGD: 0x%lx to 0x%lx\n",
+			PFN_DOWN(__pa(initial_page_table)),
+			PFN_DOWN(__pa(swapper_pg_dir)));
+}
+#endif
 static __init void xen_post_allocator_init(void)
 {
 	pv_mmu_ops.set_pte = xen_set_pte;
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 6404474..11e4aec 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -30,6 +30,8 @@ void xen_setup_machphys_mapping(void);
 pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn);
 void xen_ident_map_ISA(void);
 void xen_reserve_top(void);
+void xen_mk_swapper_pg_dir_writeable(void);
+void xen_mk_swapper_pg_dir_writeable_fixup(void);
 extern unsigned long xen_max_p2m_pfn;
 
 void xen_set_pat(u64);
-- 
1.7.1

