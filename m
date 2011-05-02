Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326Ab1EBRWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 13:22:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62257 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab1EBRWn (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 2 May 2011 13:22:43 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, stefano.stabellini@eu.citrix.com,
        yinghai@kernel.org, hpa@zytor.com
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/2] xen/mmu: Add workaround "x86-64, mm: Put early page table high"
Date: Mon,  2 May 2011 13:22:21 -0400
Message-Id: <1304356942-17656-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304356942-17656-1-git-send-email-konrad.wilk@oracle.com>
References: <1304356942-17656-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4DBEE85C.000E:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a consequence of the commit:

commit 4b239f458c229de044d6905c2b0f9fe16ed9e01e
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Fri Dec 17 16:58:28 2010 -0800

    x86-64, mm: Put early page table high

it causes the Linux kernel to crash under Xen:

mapping kernel into physical memory
Xen: setup ISA identity maps
about to get started...
(XEN) mm.c:2466:d0 Bad type (saw 7400000000000001 != exp 1000000000000000) for mfn b1d89 (pfn bacf7)
(XEN) mm.c:3027:d0 Error while pinning mfn b1d89
(XEN) traps.c:481:d0 Unhandled invalid opcode fault/trap [#6] on VCPU 0 [ec=0000]
(XEN) domain_crash_sync called from entry.S
(XEN) Domain 0 (vcpu#0) crashed on cpu#0:
...

The reason is that at some point init_memory_mapping is going to reach
the pagetable pages area and map those pages too (mapping them as normal
memory that falls in the range of addresses passed to init_memory_mapping
as argument). Some of those pages are already pagetable pages (they are
in the range pgt_buf_start-pgt_buf_end) therefore they are going to be
mapped RO and everything is fine.
Some of these pages are not pagetable pages yet (they fall in the range
pgt_buf_end-pgt_buf_top; for example the page at pgt_buf_end) so they
are going to be mapped RW.  When these pages become pagetable pages and
are hooked into the pagetable, xen will find that the guest has already
a RW mapping of them somewhere and fail the operation.
The reason Xen requires pagetables to be RO is that the hypervisor needs
to verify that the pagetables are valid before using them. The validation
operations are called "pinning" (more details in arch/x86/xen/mmu.c).

In order to fix the issue we mark all the pages in the entire range
pgt_buf_start-pgt_buf_top as RO, however when the pagetable allocation
is completed only the range pgt_buf_start-pgt_buf_end is reserved by
init_memory_mapping. Hence the kernel is going to crash as soon as one
of the pages in the range pgt_buf_end-pgt_buf_top is reused (b/c those
ranges are RO).

For this reason, this function is introduced which is called _after_
the init_memory_mapping has completed (in a perfect world we would
call this function from init_memory_mapping, but lets ignore that).

Because we are called _after_ init_memory_mapping the pgt_buf_[start,
end,top] have all changed to new values (b/c another init_memory_mapping
is called). Hence, the first time we enter this function, we save
away the pgt_buf_start value and update the pgt_buf_[end,top].

When we detect that the "old" pgt_buf_start through pgt_buf_end
PFNs have been reserved (so memblock_x86_reserve_range has been called),
we immediately set out to RW the "old" pgt_buf_end through pgt_buf_top.

And then we update those "old" pgt_buf_[end|top] with the new ones
so that we can redo this on the next pagetable.

Reviewed-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
[v1: Updated with Jeremy's comments]
[v2: Added the crash output]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |  123 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 123 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index aef7af9..1bca25f 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1463,6 +1463,119 @@ static int xen_pgd_alloc(struct mm_struct *mm)
 	return ret;
 }
 
+#ifdef CONFIG_X86_64
+static __initdata u64 __last_pgt_set_rw = 0;
+static __initdata u64 __pgt_buf_start = 0;
+static __initdata u64 __pgt_buf_end = 0;
+static __initdata u64 __pgt_buf_top = 0;
+/*
+ * As a consequence of the commit:
+ * 
+ * commit 4b239f458c229de044d6905c2b0f9fe16ed9e01e
+ * Author: Yinghai Lu <yinghai@kernel.org>
+ * Date:   Fri Dec 17 16:58:28 2010 -0800
+ * 
+ *     x86-64, mm: Put early page table high
+ * 
+ * at some point init_memory_mapping is going to reach the pagetable pages
+ * area and map those pages too (mapping them as normal memory that falls
+ * in the range of addresses passed to init_memory_mapping as argument).
+ * Some of those pages are already pagetable pages (they are in the range
+ * pgt_buf_start-pgt_buf_end) therefore they are going to be mapped RO and
+ * everything is fine.
+ * Some of these pages are not pagetable pages yet (they fall in the range
+ * pgt_buf_end-pgt_buf_top; for example the page at pgt_buf_end) so they
+ * are going to be mapped RW.  When these pages become pagetable pages and
+ * are hooked into the pagetable, xen will find that the guest has already
+ * a RW mapping of them somewhere and fail the operation.
+ * The reason Xen requires pagetables to be RO is that the hypervisor needs
+ * to verify that the pagetables are valid before using them. The validation
+ * operations are called "pinning".
+ * 
+ * In order to fix the issue we mark all the pages in the entire range
+ * pgt_buf_start-pgt_buf_top as RO, however when the pagetable allocation
+ * is completed only the range pgt_buf_start-pgt_buf_end is reserved by
+ * init_memory_mapping. Hence the kernel is going to crash as soon as one
+ * of the pages in the range pgt_buf_end-pgt_buf_top is reused (b/c those
+ * ranges are RO).
+ * 
+ * For this reason, 'mark_rw_past_pgt' is introduced which is called _after_
+ * the init_memory_mapping has completed (in a perfect world we would
+ * call this function from init_memory_mapping, but lets ignore that).
+ * 
+ * Because we are called _after_ init_memory_mapping the pgt_buf_[start,
+ * end,top] have all changed to new values (b/c init_memory_mapping
+ * is called and setting up another new page-table). Hence, the first time
+ * we enter this function, we save away the pgt_buf_start value and update
+ * the pgt_buf_[end,top].
+ * 
+ * When we detect that the "old" pgt_buf_start through pgt_buf_end
+ * PFNs have been reserved (so memblock_x86_reserve_range has been called),
+ * we immediately set out to RW the "old" pgt_buf_end through pgt_buf_top.
+ * 
+ * And then we update those "old" pgt_buf_[end|top] with the new ones
+ * so that we can redo this on the next pagetable.
+ */
+static __init void mark_rw_past_pgt(void) {
+
+	if (pgt_buf_end > pgt_buf_start) {
+		u64 addr, size;
+
+		/* Save it away. */
+		if (!__pgt_buf_start) {
+			__pgt_buf_start = pgt_buf_start;
+			__pgt_buf_end = pgt_buf_end;
+			__pgt_buf_top = pgt_buf_top;
+			return;
+		}
+		/* If we get the range that starts at __pgt_buf_end that means
+		 * the range is reserved, and that in 'init_memory_mapping'
+		 * the 'memblock_x86_reserve_range' has been called with the
+		 * outdated __pgt_buf_start, __pgt_buf_end (the "new"
+		 * pgt_buf_[start|end|top] refer now to a new pagetable.
+		 * Note: we are called _after_ the pgt_buf_[..] have been
+		 * updated.*/
+
+		addr = memblock_x86_find_in_range_size(PFN_PHYS(__pgt_buf_start),
+						       &size, PAGE_SIZE);
+
+		/* Still not reserved, meaning 'memblock_x86_reserve_range'
+		 * hasn't been called yet. Update the _end and _top.*/
+		if (addr == PFN_PHYS(__pgt_buf_start)) {
+			__pgt_buf_end = pgt_buf_end;
+			__pgt_buf_top = pgt_buf_top;
+			return;
+		}
+
+		/* OK, the area is reserved, meaning it is time for us to
+		 * set RW for the old end->top PFNs. */
+
+		/* ..unless we had already done this. */
+		if (__pgt_buf_end == __last_pgt_set_rw)
+			return;
+
+		addr = PFN_PHYS(__pgt_buf_end);
+		
+		/* set as RW the rest */
+		printk(KERN_DEBUG "xen: setting RW the range %llx - %llx\n",
+			PFN_PHYS(__pgt_buf_end), PFN_PHYS(__pgt_buf_top));
+		
+		while (addr < PFN_PHYS(__pgt_buf_top)) {
+			make_lowmem_page_readwrite(__va(addr));
+			addr += PAGE_SIZE;
+		}
+		/* And update everything so that we are ready for the next
+		 * pagetable (the one created for regions past 4GB) */
+		__last_pgt_set_rw = __pgt_buf_end;
+		__pgt_buf_start = pgt_buf_start;
+		__pgt_buf_end = pgt_buf_end;
+		__pgt_buf_top = pgt_buf_top;
+	}
+	return;
+}
+#else
+static __init void mark_rw_past_pgt(void) { }
+#endif
 static void xen_pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
 #ifdef CONFIG_X86_64
@@ -1489,6 +1602,14 @@ static __init pte_t mask_rw_pte(pte_t *ptep, pte_t pte)
 	unsigned long pfn = pte_pfn(pte);
 
 	/*
+	 * A bit of optimization. We do not need to call the workaround
+	 * when xen_set_pte_init is called with a PTE with 0 as PFN.
+	 * That is b/c the pagetable at that point are just being populated
+	 * with empty values and we can save some cycles by not calling
+	 * the 'memblock' code.*/
+	if (pfn)
+		mark_rw_past_pgt();
+	/*
 	 * If the new pfn is within the range of the newly allocated
 	 * kernel pagetable, and it isn't being mapped into an
 	 * early_ioremap fixmap slot as a freshly allocated page, make sure
@@ -1997,6 +2118,8 @@ __init void xen_ident_map_ISA(void)
 
 static __init void xen_post_allocator_init(void)
 {
+	mark_rw_past_pgt();
+
 #ifdef CONFIG_XEN_DEBUG
 	pv_mmu_ops.make_pte = PV_CALLEE_SAVE(xen_make_pte_debug);
 #endif
-- 
1.7.1

