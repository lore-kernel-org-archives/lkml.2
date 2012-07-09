Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab2GIKji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 06:39:38 -0400
Received: from smtp.citrix.com ([66.165.176.89]:6124 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab2GIKjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 06:39:36 -0400
X-IronPort-AV: E=Sophos;i="4.77,551,1336363200"; 
   d="scan'208";a="30818187"
From: David Vrabel <david.vrabel@citrix.com>
To: xen-devel@lists.xensource.com
CC: "David Vrabel" <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] xen/mm: do direct hypercall in xen_set_pte() if batching is unavailable
Date: Mon, 9 Jul 2012 11:39:05 +0100
Message-ID: <1341830348-15529-2-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1341830348-15529-1-git-send-email-david.vrabel@citrix.com>
References: <1341830348-15529-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

In xen_set_pte() if batching is unavailable (because the caller is in
an interrupt context such as handling a page fault) it would fall back
to using native_set_pte() and trapping and emulating the PTE write.

On 32-bit guests this requires two traps for each PTE write (one for
each dword of the PTE).  Instead, do one mmu_update hypercall
directly.

During construction of the initial page tables, continue to use
native_set_pte() because most of the PTEs being set are in writable
and unpinned pages (see phys_pmd_init() in arch/x86/mm/init_64.c) and
using a hypercall for this is very expensive.

This significantly improves page fault performance in 32-bit PV
guests.

lmbench3 test  Before    After     Improvement
----------------------------------------------
lat_pagefault  3.18 us   2.32 us   27%
lat_proc fork  356 us    313.3 us  11%

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/xen/mmu.c |   30 +++++++++++++++++++++++++-----
 1 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 3a73785..3f1783a 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -308,8 +308,20 @@ static bool xen_batched_set_pte(pte_t *ptep, pte_t pteval)
 
 static inline void __xen_set_pte(pte_t *ptep, pte_t pteval)
 {
-	if (!xen_batched_set_pte(ptep, pteval))
-		native_set_pte(ptep, pteval);
+	if (!xen_batched_set_pte(ptep, pteval)) {
+		/*
+		 * Could call native_set_pte() here and trap and
+		 * emulate the PTE write but with 32-bit guests this
+		 * needs two traps (one for each of the two 32-bit
+		 * words in the PTE) so do one hypercall directly
+		 * instead.
+		 */
+		struct mmu_update u;
+
+		u.ptr = virt_to_machine(ptep).maddr | MMU_NORMAL_PT_UPDATE;
+		u.val = pte_val_ma(pteval);
+		HYPERVISOR_mmu_update(&u, 1, NULL, DOMID_SELF);
+	}
 }
 
 static void xen_set_pte(pte_t *ptep, pte_t pteval)
@@ -1416,13 +1428,21 @@ static pte_t __init mask_rw_pte(pte_t *ptep, pte_t pte)
 }
 #endif /* CONFIG_X86_64 */
 
-/* Init-time set_pte while constructing initial pagetables, which
-   doesn't allow RO pagetable pages to be remapped RW */
+/*
+ * Init-time set_pte while constructing initial pagetables, which
+ * doesn't allow RO page table pages to be remapped RW.
+ *
+ * Many of these PTE updates are done on unpinned and writable pages
+ * and doing a hypercall for these is unnecessary and expensive.  At
+ * this point it is not possible to tell if a page is pinned or not,
+ * so always write the PTE directly and rely on Xen trapping and
+ * emulating any updates as necessary.
+ */
 static void __init xen_set_pte_init(pte_t *ptep, pte_t pte)
 {
 	pte = mask_rw_pte(ptep, pte);
 
-	xen_set_pte(ptep, pte);
+	native_set_pte(ptep, pte);
 }
 
 static void pin_pagetable_pfn(unsigned cmd, unsigned long pfn)
-- 
1.7.2.5

