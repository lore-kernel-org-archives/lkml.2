Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab0G0RUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 13:20:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36451 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab0G0RUh (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 27 Jul 2010 13:20:37 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, alex.williamson@redhat.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 6/9] xen/mmu: inhibit vmap aliases rather than trying to clear them out
Date: Tue, 27 Jul 2010 12:59:59 -0400
Message-Id: <1280250002-20279-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1280250002-20279-1-git-send-email-konrad.wilk@oracle.com>
References: <1280250002-20279-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C4F1534.002A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Rather than trying to deal with aliases once they appear, just completely
inhibit them.  Mostly the removal of aliases was managable, but it comes
unstuck in xen_create_contiguous_region() because it gets executed at
interrupt time (as a result of dma_alloc_coherent()), which causes all
sorts of confusion in the vmap code, as it was never intended to be run
in interrupt context.

This has the unfortunate side effect of removing all the unmap batching
the vmap code so carefully added, but that can't be helped.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index eb51402..ef5728d 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -42,6 +42,7 @@
 #include <linux/highmem.h>
 #include <linux/debugfs.h>
 #include <linux/bug.h>
+#include <linux/vmalloc.h>
 #include <linux/module.h>
 #include <linux/gfp.h>
 
@@ -1015,8 +1016,6 @@ static int xen_pin_page(struct mm_struct *mm, struct page *page,
    read-only, and can be pinned. */
 static void __xen_pgd_pin(struct mm_struct *mm, pgd_t *pgd)
 {
-	vm_unmap_aliases();
-
 	xen_mc_batch();
 
 	if (__xen_pgd_walk(mm, pgd, xen_pin_page, USER_LIMIT)) {
@@ -1580,7 +1579,6 @@ static void xen_alloc_ptpage(struct mm_struct *mm, unsigned long pfn, unsigned l
 	if (PagePinned(virt_to_page(mm->pgd))) {
 		SetPagePinned(page);
 
-		vm_unmap_aliases();
 		if (!PageHighMem(page)) {
 			make_lowmem_page_readonly(__va(PFN_PHYS((unsigned long)pfn)));
 			if (level == PT_PTE && USE_SPLIT_PTLOCKS)
@@ -2026,6 +2024,8 @@ void __init xen_init_mmu_ops(void)
 	x86_init.paging.pagetable_setup_start = xen_pagetable_setup_start;
 	x86_init.paging.pagetable_setup_done = xen_pagetable_setup_done;
 	pv_mmu_ops = xen_mmu_ops;
+
+	vmap_lazy_unmap = false;
 }
 
 /* Protected by xen_reservation_lock. */
@@ -2165,8 +2165,6 @@ int xen_create_contiguous_region(unsigned long vstart, unsigned int order,
 
 	memset((void *) vstart, 0, PAGE_SIZE << order);
 
-	vm_unmap_aliases();
-
 	spin_lock_irqsave(&xen_reservation_lock, flags);
 
 	/* 1. Zap current PTEs, remembering MFNs. */
@@ -2204,8 +2202,6 @@ void xen_destroy_contiguous_region(unsigned long vstart, unsigned int order)
 
 	memset((void *) vstart, 0, PAGE_SIZE << order);
 
-	vm_unmap_aliases();
-
 	spin_lock_irqsave(&xen_reservation_lock, flags);
 
 	/* 1. Find start MFN of contiguous extent. */
-- 
1.7.0.1

