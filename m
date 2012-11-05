Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab2KETFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 14:05:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:24521 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552Ab2KETFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 14:05:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,716,1344236400"; 
   d="scan'208";a="242810023"
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH v3 6/8] x86/xen: Use __pa_symbol instead of __pa on C visible
	symbols
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>
Date: Mon, 05 Nov 2012 11:06:00 -0800
Message-ID: <20121105190558.10205.84483.stgit@gitlad.jf.intel.com>
In-Reply-To: <20121105185657.10205.27419.stgit@gitlad.jf.intel.com>
References: <20121105185657.10205.27419.stgit@gitlad.jf.intel.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change updates a few of the functions to use __pa_symbol when
translating C visible symbols instead of __pa.  By using __pa_symbol we are
able to drop a few extra lines of code as don't have to test to see if the
virtual pointer is a part of the kernel text or just standard virtual memory.

Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---

 arch/x86/xen/mmu.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 4a05b39..a63e5f9 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1486,7 +1486,8 @@ static int xen_pgd_alloc(struct mm_struct *mm)
 
 		if (user_pgd != NULL) {
 			user_pgd[pgd_index(VSYSCALL_START)] =
-				__pgd(__pa(level3_user_vsyscall) | _PAGE_TABLE);
+				__pgd(__pa_symbol(level3_user_vsyscall) |
+				      _PAGE_TABLE);
 			ret = 0;
 		}
 
@@ -1958,10 +1959,10 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
 	 * pgd.
 	 */
 	if (xen_feature(XENFEAT_writable_page_tables)) {
-		native_write_cr3(__pa(init_level4_pgt));
+		native_write_cr3(__pa_symbol(init_level4_pgt));
 	} else {
 		xen_mc_batch();
-		__xen_write_cr3(true, __pa(init_level4_pgt));
+		__xen_write_cr3(true, __pa_symbol(init_level4_pgt));
 		xen_mc_issue(PARAVIRT_LAZY_CPU);
 	}
 	/* We can't that easily rip out L3 and L2, as the Xen pagetables are
@@ -1984,10 +1985,10 @@ static RESERVE_BRK_ARRAY(pmd_t, swapper_kernel_pmd, PTRS_PER_PMD);
 
 static void __init xen_write_cr3_init(unsigned long cr3)
 {
-	unsigned long pfn = PFN_DOWN(__pa(swapper_pg_dir));
+	unsigned long pfn = PFN_DOWN(__pa_symbol(swapper_pg_dir));
 
-	BUG_ON(read_cr3() != __pa(initial_page_table));
-	BUG_ON(cr3 != __pa(swapper_pg_dir));
+	BUG_ON(read_cr3() != __pa_symbol(initial_page_table));
+	BUG_ON(cr3 != __pa_symbol(swapper_pg_dir));
 
 	/*
 	 * We are switching to swapper_pg_dir for the first time (from
@@ -2011,7 +2012,7 @@ static void __init xen_write_cr3_init(unsigned long cr3)
 	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE, pfn);
 
 	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE,
-			  PFN_DOWN(__pa(initial_page_table)));
+			  PFN_DOWN(__pa_symbol(initial_page_table)));
 	set_page_prot(initial_page_table, PAGE_KERNEL);
 	set_page_prot(initial_kernel_pmd, PAGE_KERNEL);
 
@@ -2036,7 +2037,7 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
 
 	copy_page(initial_page_table, pgd);
 	initial_page_table[KERNEL_PGD_BOUNDARY] =
-		__pgd(__pa(initial_kernel_pmd) | _PAGE_PRESENT);
+		__pgd(__pa_symbol(initial_kernel_pmd) | _PAGE_PRESENT);
 
 	set_page_prot(initial_kernel_pmd, PAGE_KERNEL_RO);
 	set_page_prot(initial_page_table, PAGE_KERNEL_RO);
@@ -2045,8 +2046,8 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
 	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(pgd)));
 
 	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE,
-			  PFN_DOWN(__pa(initial_page_table)));
-	xen_write_cr3(__pa(initial_page_table));
+			  PFN_DOWN(__pa_symbol(initial_page_table)));
+	xen_write_cr3(__pa_symbol(initial_page_table));
 
 	memblock_reserve(__pa(xen_start_info->pt_base),
 			 xen_start_info->nr_pt_frames * PAGE_SIZE);

