Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab1FTWQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:16:54 -0400
Received: from claw.goop.org ([74.207.240.146]:53651 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755972Ab1FTWP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:15:27 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Xen Devel <Xen-devel@lists.xensource.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 11/15] xen/mmu: tune pgtable alloc/release
Date: Mon, 20 Jun 2011 15:15:07 -0700
Message-Id: <52e5abf03b2f294b0c5cafe14306b11fd6cf67f2.1308607697.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Make sure the fastpath code is inlined.  Batch the page permission change
and the pin/unpin, and make sure that it can be batched with any
adjacent set_pte/pmd/etc operations.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |   49 ++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 42 insertions(+), 7 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 112259f..ebfdc3d 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1492,22 +1492,52 @@ static void __init xen_release_pmd_init(unsigned long pfn)
 	make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
 }
 
+static inline void __pin_pagetable_pfn(unsigned cmd, unsigned long pfn)
+{
+	struct multicall_space mcs;
+	struct mmuext_op *op;
+
+	mcs = __xen_mc_entry(sizeof(*op));
+	op = mcs.args;
+	op->cmd = cmd;
+	op->arg1.mfn = pfn_to_mfn(pfn);
+
+	MULTI_mmuext_op(mcs.mc, mcs.args, 1, NULL, DOMID_SELF);
+}
+
+static inline void __set_pfn_prot(unsigned long pfn, pgprot_t prot)
+{
+	struct multicall_space mcs;
+	unsigned long addr = (unsigned long)__va(pfn << PAGE_SHIFT);
+
+	mcs = __xen_mc_entry(0);
+	MULTI_update_va_mapping(mcs.mc, (unsigned long)addr,
+				pfn_pte(pfn, prot), 0);
+}
+
 /* This needs to make sure the new pte page is pinned iff its being
    attached to a pinned pagetable. */
-static void xen_alloc_ptpage(struct mm_struct *mm, unsigned long pfn, unsigned level)
+static inline void xen_alloc_ptpage(struct mm_struct *mm, unsigned long pfn,
+				    unsigned level)
 {
-	struct page *page = pfn_to_page(pfn);
 	int pinned = PagePinned(virt_to_page(mm->pgd));
  
 	trace_xen_mmu_alloc_ptpage(mm, pfn, level, pinned);
 
 	if (pinned) {
+		struct page *page = pfn_to_page(pfn);
+
 		SetPagePinned(page);
 
 		if (!PageHighMem(page)) {
-			make_lowmem_page_readonly(__va(PFN_PHYS((unsigned long)pfn)));
+			xen_mc_batch();
+
+			__set_pfn_prot(pfn, PAGE_KERNEL_RO);
+
 			if (level == PT_PTE && USE_SPLIT_PTLOCKS)
-				pin_pagetable_pfn(MMUEXT_PIN_L1_TABLE, pfn);
+				__pin_pagetable_pfn(MMUEXT_PIN_L1_TABLE, pfn);
+
+			xen_mc_issue(PARAVIRT_LAZY_MMU);
 		} else {
 			/* make sure there are no stray mappings of
 			   this page */
@@ -1527,7 +1557,7 @@ static void xen_alloc_pmd(struct mm_struct *mm, unsigned long pfn)
 }
 
 /* This should never happen until we're OK to use struct page */
-static void xen_release_ptpage(unsigned long pfn, unsigned level)
+static inline void xen_release_ptpage(unsigned long pfn, unsigned level)
 {
 	struct page *page = pfn_to_page(pfn);
 	bool pinned = PagePinned(page);
@@ -1536,9 +1566,14 @@ static void xen_release_ptpage(unsigned long pfn, unsigned level)
 
 	if (pinned) {
 		if (!PageHighMem(page)) {
+			xen_mc_batch();
+
 			if (level == PT_PTE && USE_SPLIT_PTLOCKS)
-				pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, pfn);
-			make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
+				__pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, pfn);
+
+			__set_pfn_prot(pfn, PAGE_KERNEL);
+
+			xen_mc_issue(PARAVIRT_LAZY_MMU);
 		}
 		ClearPagePinned(page);
 	}
-- 
1.7.5.4

