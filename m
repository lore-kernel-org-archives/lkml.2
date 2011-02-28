Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab1CATkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:40:33 -0500
Received: from 206.83.70.71.ptr.us.xo.net ([206.83.70.71]:52545 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171Ab1CAThX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:37:23 -0500
Message-Id: <201103011934.p21JYdCi010307@farm-0010.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 28 Feb 2011 15:30:16 -0500
Subject: [PATCH] arch/tile: fix two bugs in the backtracer code
To: linux-kernel@vger.kernel.org
In-Reply-To: <201103011931.p21JVtqp010237@farm-0010.internal.tilera.com>
X-OriginalArrivalTime: 01 Mar 2011 19:34:39.0842 (UTC) FILETIME=[B4D66C20:01CBD847]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first is that we were using an incorrect hand-rolled variant
of __kernel_text_address() which didn't handle module PCs.  We now
just use the standard API.

The second was that we weren't accounting for the three-level
page table when we were trying to pre-verify the addresses on
the 64-bit TILE-Gx processor; we now do that correctly.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/stack.c |   28 +++++++++++++++++++---------
 1 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/tile/kernel/stack.c b/arch/tile/kernel/stack.c
index 0d54106..dd81713 100644
--- a/arch/tile/kernel/stack.c
+++ b/arch/tile/kernel/stack.c
@@ -44,13 +44,6 @@ static int in_kernel_stack(struct KBacktraceIterator *kbt, VirtualAddress sp)
 	return sp >= kstack_base && sp < kstack_base + THREAD_SIZE;
 }
 
-/* Is address in the specified kernel code? */
-static int in_kernel_text(VirtualAddress address)
-{
-	return (address >= MEM_SV_INTRPT &&
-		address < MEM_SV_INTRPT + HPAGE_SIZE);
-}
-
 /* Is address valid for reading? */
 static int valid_address(struct KBacktraceIterator *kbt, VirtualAddress address)
 {
@@ -63,6 +56,23 @@ static int valid_address(struct KBacktraceIterator *kbt, VirtualAddress address)
 	if (l1_pgtable == NULL)
 		return 0;	/* can't read user space in other tasks */
 
+#ifdef CONFIG_64BIT
+	/* Find the real l1_pgtable by looking in the l0_pgtable. */
+	pte = l1_pgtable[HV_L0_INDEX(address)];
+	if (!hv_pte_get_present(pte))
+		return 0;
+	pfn = hv_pte_get_pfn(pte);
+	if (pte_huge(pte)) {
+		if (!pfn_valid(pfn)) {
+			pr_err("L0 huge page has bad pfn %#lx\n", pfn);
+			return 0;
+		}
+		return hv_pte_get_present(pte) && hv_pte_get_readable(pte);
+	}
+	page = pfn_to_page(pfn);
+	BUG_ON(PageHighMem(page));  /* No HIGHMEM on 64-bit. */
+	l1_pgtable = (HV_PTE *)pfn_to_kaddr(pfn);
+#endif
 	pte = l1_pgtable[HV_L1_INDEX(address)];
 	if (!hv_pte_get_present(pte))
 		return 0;
@@ -92,7 +102,7 @@ static bool read_memory_func(void *result, VirtualAddress address,
 {
 	int retval;
 	struct KBacktraceIterator *kbt = (struct KBacktraceIterator *)vkbt;
-	if (in_kernel_text(address)) {
+	if (__kernel_text_address(address)) {
 		/* OK to read kernel code. */
 	} else if (address >= PAGE_OFFSET) {
 		/* We only tolerate kernel-space reads of this task's stack */
@@ -132,7 +142,7 @@ static struct pt_regs *valid_fault_handler(struct KBacktraceIterator* kbt)
 		}
 	}
 	if (EX1_PL(p->ex1) == KERNEL_PL &&
-	    in_kernel_text(p->pc) &&
+	    __kernel_text_address(p->pc) &&
 	    in_kernel_stack(kbt, p->sp) &&
 	    p->sp >= sp) {
 		if (kbt->verbose)
-- 
1.6.5.2

