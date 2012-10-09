Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab2JIEk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 00:40:58 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:45513 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab2JIEky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 00:40:54 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 08/10] x86, xen, mm: fix mapping_pagetable_reserve logic
Date: Mon,  8 Oct 2012 21:39:16 -0700
Message-Id: <1349757558-10856-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
References: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code has hidden usage for pgt_buf_top, so we can not call that with
different pgt_buf_top continuous.

Acutully its main purpose is set some page back to RW.

Split that to make_range_readwrite that is reflecting the real thing is
done by that function.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
---
 arch/x86/include/asm/pgtable_types.h |    1 -
 arch/x86/include/asm/x86_init.h      |    2 +-
 arch/x86/kernel/x86_init.c           |    3 ++-
 arch/x86/mm/init.c                   |   16 ++++++++--------
 arch/x86/xen/mmu.c                   |   18 +++++++-----------
 5 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index db8fec6..b1a7107 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -301,7 +301,6 @@ int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 /* Install a pte for a particular vaddr in kernel space. */
 void set_pte_vaddr(unsigned long vaddr, pte_t pte);
 
-extern void native_pagetable_reserve(u64 start, u64 end);
 #ifdef CONFIG_X86_32
 extern void native_pagetable_init(void);
 #else
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 5769349..357d055 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -76,7 +76,7 @@ struct x86_init_oem {
  * init_memory_mapping and the commit that added it.
  */
 struct x86_init_mapping {
-	void (*pagetable_reserve)(u64 start, u64 end);
+	void (*make_range_readwrite)(u64 start, u64 end);
 };
 
 /**
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 7a3d075..dee4021 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -28,6 +28,7 @@ void __cpuinit x86_init_noop(void) { }
 void __init x86_init_uint_noop(unsigned int unused) { }
 int __init iommu_init_noop(void) { return 0; }
 void iommu_shutdown_noop(void) { }
+static void make_range_readwrite_noop(u64 start, u64 end) { }
 
 /*
  * The platform setup functions are preset with the default functions
@@ -63,7 +64,7 @@ struct x86_init_ops x86_init __initdata = {
 	},
 
 	.mapping = {
-		.pagetable_reserve		= native_pagetable_reserve,
+		.make_range_readwrite	= make_range_readwrite_noop,
 	},
 
 	.paging = {
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index a89f485..6622d35 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -61,10 +61,6 @@ static void __init probe_page_size_mask(void)
 		__supported_pte_mask |= _PAGE_GLOBAL;
 	}
 }
-void __init native_pagetable_reserve(u64 start, u64 end)
-{
-	memblock_reserve(start, end - start);
-}
 
 #ifdef CONFIG_X86_32
 #define NR_RANGE_MR 3
@@ -329,9 +325,11 @@ static void __init find_early_table_space(unsigned long start,
 			base, base + tables - 1, pgt_buf_start << PAGE_SHIFT,
 			(pgt_buf_end << PAGE_SHIFT) - 1);
 
-		x86_init.mapping.pagetable_reserve(PFN_PHYS(pgt_buf_start),
-						PFN_PHYS(pgt_buf_end));
+		memblock_reserve(PFN_PHYS(pgt_buf_start),
+				 PFN_PHYS(pgt_buf_end) - PFN_PHYS(pgt_buf_start));
 	}
+	x86_init.mapping.make_range_readwrite(PFN_PHYS(pgt_buf_end),
+					PFN_PHYS(pgt_buf_top));
 
 	pgt_buf_start = base >> PAGE_SHIFT;
 	pgt_buf_end = pgt_buf_start;
@@ -469,9 +467,11 @@ void __init init_mem_mapping(void)
 		printk(KERN_DEBUG "kernel direct mapping tables up to %#lx @ [mem %#010lx-%#010lx] final\n",
 			end - 1, pgt_buf_start << PAGE_SHIFT,
 			(pgt_buf_end << PAGE_SHIFT) - 1);
-		x86_init.mapping.pagetable_reserve(PFN_PHYS(pgt_buf_start),
-				PFN_PHYS(pgt_buf_end));
+		memblock_reserve(PFN_PHYS(pgt_buf_start),
+				 PFN_PHYS(pgt_buf_end) - PFN_PHYS(pgt_buf_start));
 	}
+	x86_init.mapping.make_range_readwrite(PFN_PHYS(pgt_buf_end),
+						PFN_PHYS(pgt_buf_top));
 
 	/* stop the wrong using */
 	pgt_buf_top = 0;
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 9c0956c..7607a33 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1183,17 +1183,13 @@ static void __init xen_pagetable_init(void)
 	xen_post_allocator_init();
 }
 
-static __init void xen_mapping_pagetable_reserve(u64 start, u64 end)
+static __init void xen_make_range_readwrite(u64 start, u64 end)
 {
-	/* reserve the range used */
-	native_pagetable_reserve(start, end);
-
-	/* set as RW the rest */
-	printk(KERN_DEBUG "xen: setting RW the range %llx - %llx\n", end,
-			PFN_PHYS(pgt_buf_top));
-	while (end < PFN_PHYS(pgt_buf_top)) {
-		make_lowmem_page_readwrite(__va(end));
-		end += PAGE_SIZE;
+	printk(KERN_DEBUG "xen: setting RW the range %llx - %llx\n",
+		start, end);
+	while (start < end) {
+		make_lowmem_page_readwrite(__va(start));
+		start += PAGE_SIZE;
 	}
 }
 
@@ -2060,7 +2056,7 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
 
 void __init xen_init_mmu_ops(void)
 {
-	x86_init.mapping.pagetable_reserve = xen_mapping_pagetable_reserve;
+	x86_init.mapping.make_range_readwrite = xen_make_range_readwrite;
 	x86_init.paging.pagetable_init = xen_pagetable_init;
 	pv_mmu_ops = xen_mmu_ops;
 
-- 
1.7.7

