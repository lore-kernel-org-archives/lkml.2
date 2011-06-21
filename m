Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab1FUUhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 16:37:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:39443 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757455Ab1FUUht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 16:37:49 -0400
Date: Tue, 21 Jun 2011 20:37:39 GMT
From: tip-bot for Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Message-ID: <tip-d8ca7b16cfc1496d57287caa12ade8a8e4d0c0f8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        konrad.wilk@oracle.com, tglx@linutronix.de, hpa@linux.intel.com,
        stefano.stabellini@eu.citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, tglx@linutronix.de, hpa@linux.intel.com,
        stefano.stabellini@eu.citrix.com
In-Reply-To: <1307470409-7654-2-git-send-email-stefano.stabellini@eu.citrix.com>
References: <1307470409-7654-2-git-send-email-stefano.stabellini@eu.citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] Revert "x86,xen: introduce x86_init.mapping.pagetable_reserve"
Git-Commit-ID: d8ca7b16cfc1496d57287caa12ade8a8e4d0c0f8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 21 Jun 2011 20:37:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8ca7b16cfc1496d57287caa12ade8a8e4d0c0f8
Gitweb:     http://git.kernel.org/tip/d8ca7b16cfc1496d57287caa12ade8a8e4d0c0f8
Author:     Stefano Stabellini <stefano.stabellini@eu.citrix.com>
AuthorDate: Tue, 7 Jun 2011 19:13:28 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 21 Jun 2011 13:07:11 -0700

Revert "x86,xen: introduce x86_init.mapping.pagetable_reserve"

This reverts commit 279b706bf800b5967037f492dbe4fc5081ad5d0f.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Link: http://lkml.kernel.org/r/1307470409-7654-2-git-send-email-stefano.stabellini@eu.citrix.com
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/pgtable_types.h |    1 -
 arch/x86/include/asm/x86_init.h      |   12 ------------
 arch/x86/kernel/x86_init.c           |    4 ----
 arch/x86/mm/init.c                   |   25 +++----------------------
 arch/x86/xen/mmu.c                   |   15 ---------------
 5 files changed, 3 insertions(+), 54 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index d56187c..7db7723 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -299,7 +299,6 @@ int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 /* Install a pte for a particular vaddr in kernel space. */
 void set_pte_vaddr(unsigned long vaddr, pte_t pte);
 
-extern void native_pagetable_reserve(u64 start, u64 end);
 #ifdef CONFIG_X86_32
 extern void native_pagetable_setup_start(pgd_t *base);
 extern void native_pagetable_setup_done(pgd_t *base);
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index d3d8590..643ebf2 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -68,17 +68,6 @@ struct x86_init_oem {
 };
 
 /**
- * struct x86_init_mapping - platform specific initial kernel pagetable setup
- * @pagetable_reserve:	reserve a range of addresses for kernel pagetable usage
- *
- * For more details on the purpose of this hook, look in
- * init_memory_mapping and the commit that added it.
- */
-struct x86_init_mapping {
-	void (*pagetable_reserve)(u64 start, u64 end);
-};
-
-/**
  * struct x86_init_paging - platform specific paging functions
  * @pagetable_setup_start:	platform specific pre paging_init() call
  * @pagetable_setup_done:	platform specific post paging_init() call
@@ -134,7 +123,6 @@ struct x86_init_ops {
 	struct x86_init_mpparse		mpparse;
 	struct x86_init_irqs		irqs;
 	struct x86_init_oem		oem;
-	struct x86_init_mapping		mapping;
 	struct x86_init_paging		paging;
 	struct x86_init_timers		timers;
 	struct x86_init_iommu		iommu;
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 6f164bd..6eee082 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -61,10 +61,6 @@ struct x86_init_ops x86_init __initdata = {
 		.banner			= default_banner,
 	},
 
-	.mapping = {
-		.pagetable_reserve		= native_pagetable_reserve,
-	},
-
 	.paging = {
 		.pagetable_setup_start	= native_pagetable_setup_start,
 		.pagetable_setup_done	= native_pagetable_setup_done,
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 0cfe8d4..15590fd 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -106,11 +106,6 @@ static void __init find_early_table_space(unsigned long start,
 		end, pgt_buf_start << PAGE_SHIFT, pgt_buf_top << PAGE_SHIFT);
 }
 
-void __init native_pagetable_reserve(u64 start, u64 end)
-{
-	memblock_x86_reserve_range(start, end, "PGTABLE");
-}
-
 struct map_range {
 	unsigned long start;
 	unsigned long end;
@@ -305,24 +300,10 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	if (pgt_buf_end != pgt_buf_top)
 		printk(KERN_DEBUG "initial kernel pagetable allocation wasted %lx"
 				" pages\n", pgt_buf_top - pgt_buf_end);
-	/*
-	 * Reserve the kernel pagetable pages we used (pgt_buf_start -
-	 * pgt_buf_end) and free the other ones (pgt_buf_end - pgt_buf_top)
-	 * so that they can be reused for other purposes.
-	 *
-	 * On native it just means calling memblock_x86_reserve_range, on Xen it
-	 * also means marking RW the pagetable pages that we allocated before
-	 * but that haven't been used.
-	 *
-	 * In fact on xen we mark RO the whole range pgt_buf_start -
-	 * pgt_buf_top, because we have to make sure that when
-	 * init_memory_mapping reaches the pagetable pages area, it maps
-	 * RO all the pagetable pages, including the ones that are beyond
-	 * pgt_buf_end at that time.
-	 */
+
 	if (!after_bootmem && pgt_buf_end > pgt_buf_start)
-		x86_init.mapping.pagetable_reserve(PFN_PHYS(pgt_buf_start),
-				PFN_PHYS(pgt_buf_end));
+		memblock_x86_reserve_range(pgt_buf_start << PAGE_SHIFT,
+				 pgt_buf_end << PAGE_SHIFT, "PGTABLE");
 
 	if (!after_bootmem)
 		early_memtest(start, end);
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index dc708dc..2004f1e 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1153,20 +1153,6 @@ static void __init xen_pagetable_setup_start(pgd_t *base)
 {
 }
 
-static __init void xen_mapping_pagetable_reserve(u64 start, u64 end)
-{
-	/* reserve the range used */
-	native_pagetable_reserve(start, end);
-
-	/* set as RW the rest */
-	printk(KERN_DEBUG "xen: setting RW the range %llx - %llx\n", end,
-			PFN_PHYS(pgt_buf_top));
-	while (end < PFN_PHYS(pgt_buf_top)) {
-		make_lowmem_page_readwrite(__va(end));
-		end += PAGE_SIZE;
-	}
-}
-
 static void xen_post_allocator_init(void);
 
 static void __init xen_pagetable_setup_done(pgd_t *base)
@@ -1997,7 +1983,6 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
 
 void __init xen_init_mmu_ops(void)
 {
-	x86_init.mapping.pagetable_reserve = xen_mapping_pagetable_reserve;
 	x86_init.paging.pagetable_setup_start = xen_pagetable_setup_start;
 	x86_init.paging.pagetable_setup_done = xen_pagetable_setup_done;
 	pv_mmu_ops = xen_mmu_ops;
