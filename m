Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553Ab0KCPfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:35:53 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:64835 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932539Ab0KCPfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:35:48 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Borislav Petkov <bp@alien8.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
In-Reply-To: <1288257797.8361.1545.camel@zakaz.uk.xensource.com>
References: <1288169413-29065-1-git-send-email-ian.campbell@citrix.com>
	 <20101027104020.GA16954@a1.tnic> <4CC85839.4000507@goop.org>
	 <4CC85EE6.7030608@linux.intel.com> <4CC861F9.8080200@goop.org>
	 <20101027174417.GA19194@a1.tnic>
	 <1288202321.10179.102.camel@localhost.localdomain>
	 <1288257797.8361.1545.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 15:35:25 +0000
Message-ID: <1288798525.9309.16.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 12.157.84.6
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] x86: use pgd accessors when cloning a pgd range.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=DhNl2YeytwJssBBGe49HJX82LNDFEEVkpVB34RXKaPo= c=1 sm=0 a=x6_g0RJVswgA:10 a=IkcTkHD0fZMA:10 a=tHz9FfFoAAAA:8 a=QyXUC8HyAAAA:8 a=ZfRw4ET0AAAA:8 a=AZCxh-bZPuAZI9u3a0sA:9 a=79t97-9-YAWT6mG8tk8A:7 a=XD78aAUyRJWWbIgCShIKiE1QWDgA:4 a=QEXdDO2ut3YA:10 a=6O0IECtVFhoA:10 a=1JvJEtVdGvUA:10 a=KciULlu47koA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-28 at 10:23 +0100, Ian Campbell wrote:
> I'm also going to look into switching Xen to startup on
> initial_page_table, since I think the consistency with native would be
> useful from a principle of least surprise PoV.

Here it is.

8<---------------

>From 1aa3d8dc160bcee9bd92940853fad509df38d1a2 Mon Sep 17 00:00:00 2001
From: Ian Campbell <ian.campbell@citrix.com>
Date: Wed, 3 Nov 2010 15:32:21 +0000
Subject: [PATCH] xen: x86/32: perform initial startup on initial_page_table

Only make swapper_pg_dir readonly and pinned when generic x86 architecture code
(which also starts on initial_page_table) switches to it.  This helps ensure
that the generic setup paths work on Xen unmodified. In particular
clone_pgd_range writes directly to the destination pgd entries and is used to
initialise swapper_pg_dir so we need to ensure that it remains writeable until
the last possible moment during bring up.

This is complicated slightly by the need to avoid sharing kernel PMD entries
when running under Xen, therefore the Xen implementation must make a copy of
the kernel PMD (which is otherwise referred to by both intial_page_table and
swapper_pg_dir) before switching to swapper_pg_dir.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
---
 arch/x86/xen/enlighten.c |    2 -
 arch/x86/xen/mmu.c       |   69 +++++++++++++++++++++++++++++++++++++--------
 2 files changed, 56 insertions(+), 15 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index bd35549..e977d37 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1198,8 +1198,6 @@ asmlinkage void __init xen_start_kernel(void)
 	/* Allocate and initialize top and mid mfn levels for p2m structure */
 	xen_build_mfn_list_list();
 
-	init_mm.pgd = pgd;
-
 	/* keep using Xen gdt for now; no urgent need to change it */
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index bd2713a..cc507cb 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2133,44 +2133,83 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 	return pgd;
 }
 #else	/* !CONFIG_X86_64 */
-static RESERVE_BRK_ARRAY(pmd_t, level2_kernel_pgt, PTRS_PER_PMD);
+static RESERVE_BRK_ARRAY(pmd_t, initial_kernel_pmd, PTRS_PER_PMD);
+static RESERVE_BRK_ARRAY(pmd_t, swapper_kernel_pmd, PTRS_PER_PMD);
+
+static __init void xen_write_cr3_init(unsigned long cr3)
+{
+	unsigned long pfn = PFN_DOWN(__pa(swapper_pg_dir));
+
+	BUG_ON(read_cr3() != __pa(initial_page_table));
+	BUG_ON(cr3 != __pa(swapper_pg_dir));
+
+	/*
+	 * We are switching to swapper_pg_dir for the first time (from
+	 * initial_page_table) and therefore need to mark that page
+	 * read-only and then pin it.
+	 *
+	 * Xen disallows sharing of kernel PMDs for PAE
+	 * guests. Therefore we must copy the kernel PMD from
+	 * initial_page_table into a new kernel PMD to be used in
+	 * swapper_pg_dir.
+	 */
+	swapper_kernel_pmd =
+		extend_brk(sizeof(pmd_t) * PTRS_PER_PMD, PAGE_SIZE);
+	memcpy(swapper_kernel_pmd, initial_kernel_pmd,
+	       sizeof(pmd_t) * PTRS_PER_PMD);
+	swapper_pg_dir[KERNEL_PGD_BOUNDARY] =
+		__pgd(__pa(swapper_kernel_pmd) | _PAGE_PRESENT);
+	set_page_prot(swapper_kernel_pmd, PAGE_KERNEL_RO);
+
+	set_page_prot(swapper_pg_dir, PAGE_KERNEL_RO);
+	xen_write_cr3(cr3);
+	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE, pfn);
+
+	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE,
+			  PFN_DOWN(__pa(initial_page_table)));
+	set_page_prot(initial_page_table, PAGE_KERNEL);
+	set_page_prot(initial_kernel_pmd, PAGE_KERNEL);
+
+	pv_mmu_ops.write_cr3 = &xen_write_cr3;
+}
 
 __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 					 unsigned long max_pfn)
 {
 	pmd_t *kernel_pmd;
 
-	level2_kernel_pgt = extend_brk(sizeof(pmd_t) * PTRS_PER_PMD, PAGE_SIZE);
+	initial_kernel_pmd =
+		extend_brk(sizeof(pmd_t) * PTRS_PER_PMD, PAGE_SIZE);
 
 	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->pt_base) +
 				  xen_start_info->nr_pt_frames * PAGE_SIZE +
 				  512*1024);
 
 	kernel_pmd = m2v(pgd[KERNEL_PGD_BOUNDARY].pgd);
-	memcpy(level2_kernel_pgt, kernel_pmd, sizeof(pmd_t) * PTRS_PER_PMD);
+	memcpy(initial_kernel_pmd, kernel_pmd, sizeof(pmd_t) * PTRS_PER_PMD);
 
-	xen_map_identity_early(level2_kernel_pgt, max_pfn);
+	xen_map_identity_early(initial_kernel_pmd, max_pfn);
 
-	memcpy(swapper_pg_dir, pgd, sizeof(pgd_t) * PTRS_PER_PGD);
-	set_pgd(&swapper_pg_dir[KERNEL_PGD_BOUNDARY],
-			__pgd(__pa(level2_kernel_pgt) | _PAGE_PRESENT));
+	memcpy(initial_page_table, pgd, sizeof(pgd_t) * PTRS_PER_PGD);
+	initial_page_table[KERNEL_PGD_BOUNDARY] =
+		__pgd(__pa(initial_kernel_pmd) | _PAGE_PRESENT);
 
-	set_page_prot(level2_kernel_pgt, PAGE_KERNEL_RO);
-	set_page_prot(swapper_pg_dir, PAGE_KERNEL_RO);
+	set_page_prot(initial_kernel_pmd, PAGE_KERNEL_RO);
+	set_page_prot(initial_page_table, PAGE_KERNEL_RO);
 	set_page_prot(empty_zero_page, PAGE_KERNEL_RO);
 
 	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(pgd)));
 
-	xen_write_cr3(__pa(swapper_pg_dir));
-
-	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE, PFN_DOWN(__pa(swapper_pg_dir)));
+	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE,
+			  PFN_DOWN(__pa(initial_page_table)));
+	xen_write_cr3(__pa(initial_page_table));
 
 	memblock_x86_reserve_range(__pa(xen_start_info->pt_base),
 		      __pa(xen_start_info->pt_base +
 			   xen_start_info->nr_pt_frames * PAGE_SIZE),
 		      "XEN PAGETABLES");
 
-	return swapper_pg_dir;
+	return initial_page_table;
 }
 #endif	/* CONFIG_X86_64 */
 
@@ -2304,7 +2343,11 @@ static const struct pv_mmu_ops xen_mmu_ops __initdata = {
 	.write_cr2 = xen_write_cr2,
 
 	.read_cr3 = xen_read_cr3,
+#ifdef CONFIG_X86_32
+	.write_cr3 = xen_write_cr3_init,
+#else
 	.write_cr3 = xen_write_cr3,
+#endif
 
 	.flush_tlb_user = xen_flush_tlb,
 	.flush_tlb_kernel = xen_flush_tlb,
-- 
1.5.6.5




-- 
Ian Campbell

Booze is the answer.  I don't remember the question.

