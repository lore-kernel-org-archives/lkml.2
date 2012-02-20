Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab2BTQHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 11:07:46 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:19504 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab2BTQH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 11:07:28 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        x86@kernel.org
Cc: jeremy@goop.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/2] xen/pat: Disable PAT support for now.
Date: Mon, 20 Feb 2012 11:01:27 -0500
Message-Id: <1329753687-29218-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1329753687-29218-1-git-send-email-konrad.wilk@oracle.com>
References: <1329753687-29218-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4F426FB4.0013,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Pls also look at https://lkml.org/lkml/2012/2/10/228]

Using of PAT to change pages from WB to WC works quite nicely.
Changing it back to WB - not so much. The crux of the matter is
that the code that does this (__page_change_att_set_clr) has only
limited information so when it tries to the change it gets
the "raw" unfiltered information instead of the properly filtered one -
and the "raw" one tell it that PSE bit is on (while infact it
is not).  As a result when the PTE is set to be WB from WC, we get
tons of:

:WARNING: at arch/x86/xen/mmu.c:475 xen_make_pte+0x67/0xa0()
:Hardware name: HP xw4400 Workstation
.. snip..
:Pid: 27, comm: kswapd0 Tainted: G        W    3.2.2-1.fc16.x86_64 #1
:Call Trace:
: [<ffffffff8106dd1f>] warn_slowpath_common+0x7f/0xc0
: [<ffffffff8106dd7a>] warn_slowpath_null+0x1a/0x20
: [<ffffffff81005a17>] xen_make_pte+0x67/0xa0
: [<ffffffff810051bd>] __raw_callee_save_xen_make_pte+0x11/0x1e
: [<ffffffff81040e15>] ? __change_page_attr_set_clr+0x9d5/0xc00
: [<ffffffff8114c2e8>] ? __purge_vmap_area_lazy+0x158/0x1d0
: [<ffffffff8114cca5>] ? vm_unmap_aliases+0x175/0x190
: [<ffffffff81041168>] change_page_attr_set_clr+0x128/0x4c0
: [<ffffffff81041542>] set_pages_array_wb+0x42/0xa0
: [<ffffffff8100a9b2>] ? check_events+0x12/0x20
: [<ffffffffa0074d4c>] ttm_pages_put+0x1c/0x70 [ttm]
: [<ffffffffa0074e98>] ttm_page_pool_free+0xf8/0x180 [ttm]
: [<ffffffffa0074f78>] ttm_pool_mm_shrink+0x58/0x90 [ttm]
: [<ffffffff8112ba04>] shrink_slab+0x154/0x310
: [<ffffffff8112f17a>] balance_pgdat+0x4fa/0x6c0
: [<ffffffff8112f4b8>] kswapd+0x178/0x3d0
: [<ffffffff815df134>] ? __schedule+0x3d4/0x8c0
: [<ffffffff81090410>] ? remove_wait_queue+0x50/0x50
: [<ffffffff8112f340>] ? balance_pgdat+0x6c0/0x6c0
: [<ffffffff8108fb6c>] kthread+0x8c/0xa0

for every page. The fix for this is has been posted
and is https://lkml.org/lkml/2012/2/10/228
"x86/cpa: Use pte_attrs instead of pte_flags on CPA/set_p.._wb/wc operations."
along with a detailed description of the problem and solution.

But since that posting has gone nowhere I am proposing
this band-aid solution so that at least users don't get
the page corruption (the pages that are WC don't get changed to WB
and end up being recycled for filesystem or other things causing
mysterious crashes).

The negative impact of this patch is that users of WC flag
(which are InfiniBand, radeon, nouveau drivers) won't be able
to set that flag - so they are going to see performance degradation.
But stability is more important here.

Fixes RH BZ# 742032, 787403, and 745574
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c |    2 ++
 arch/x86/xen/mmu.c       |    8 ++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 7c44e1b..4172af8 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1141,7 +1141,9 @@ asmlinkage void __init xen_start_kernel(void)
 
 	/* Prevent unwanted bits from being set in PTEs. */
 	__supported_pte_mask &= ~_PAGE_GLOBAL;
+#if 0
 	if (!xen_initial_domain())
+#endif
 		__supported_pte_mask &= ~(_PAGE_PWT | _PAGE_PCD);
 
 	__supported_pte_mask |= _PAGE_IOMAP;
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 58a0e46..95c1cf6 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -415,13 +415,13 @@ static pteval_t iomap_pte(pteval_t val)
 static pteval_t xen_pte_val(pte_t pte)
 {
 	pteval_t pteval = pte.pte;
-
+#if 0
 	/* If this is a WC pte, convert back from Xen WC to Linux WC */
 	if ((pteval & (_PAGE_PAT | _PAGE_PCD | _PAGE_PWT)) == _PAGE_PAT) {
 		WARN_ON(!pat_enabled);
 		pteval = (pteval & ~_PAGE_PAT) | _PAGE_PWT;
 	}
-
+#endif
 	if (xen_initial_domain() && (pteval & _PAGE_IOMAP))
 		return pteval;
 
@@ -463,7 +463,7 @@ void xen_set_pat(u64 pat)
 static pte_t xen_make_pte(pteval_t pte)
 {
 	phys_addr_t addr = (pte & PTE_PFN_MASK);
-
+#if 0
 	/* If Linux is trying to set a WC pte, then map to the Xen WC.
 	 * If _PAGE_PAT is set, then it probably means it is really
 	 * _PAGE_PSE, so avoid fiddling with the PAT mapping and hope
@@ -476,7 +476,7 @@ static pte_t xen_make_pte(pteval_t pte)
 		if ((pte & (_PAGE_PCD | _PAGE_PWT)) == _PAGE_PWT)
 			pte = (pte & ~(_PAGE_PCD | _PAGE_PWT)) | _PAGE_PAT;
 	}
-
+#endif
 	/*
 	 * Unprivileged domains are allowed to do IOMAPpings for
 	 * PCI passthrough, but not map ISA space.  The ISA
-- 
1.7.9.48.g85da4d

