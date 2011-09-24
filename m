Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab1IXE5R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 00:57:17 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:54770 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab1IXE5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 00:57:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        jeremy@goop.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/3] Revert "xen/debug: WARN_ON when identity PFN has no _PAGE_IOMAP flag set."
Date: Fri, 23 Sep 2011 22:28:17 -0400
Message-Id: <1316831299-4144-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316831299-4144-1-git-send-email-konrad.wilk@oracle.com>
References: <1316831299-4144-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090208.4E7D631D.0069,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don' use it anymore and there are more false positives.

This reverts commit fc25151d9ac7d809239fe68de0a1490b504bb94a.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/Kconfig |    8 --------
 arch/x86/xen/mmu.c   |   38 --------------------------------------
 2 files changed, 0 insertions(+), 46 deletions(-)

diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 5cc821c..ae559fe 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -49,11 +49,3 @@ config XEN_DEBUG_FS
 	help
 	  Enable statistics output and various tuning options in debugfs.
 	  Enabling this option may incur a significant performance overhead.
-
-config XEN_DEBUG
-	bool "Enable Xen debug checks"
-	depends on XEN
-	default n
-	help
-	  Enable various WARN_ON checks in the Xen MMU code.
-	  Enabling this option WILL incur a significant performance overhead.
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index f987bde..3c9aecd 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -495,41 +495,6 @@ static pte_t xen_make_pte(pteval_t pte)
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_make_pte);
 
-#ifdef CONFIG_XEN_DEBUG
-pte_t xen_make_pte_debug(pteval_t pte)
-{
-	phys_addr_t addr = (pte & PTE_PFN_MASK);
-	phys_addr_t other_addr;
-	bool io_page = false;
-	pte_t _pte;
-
-	if (pte & _PAGE_IOMAP)
-		io_page = true;
-
-	_pte = xen_make_pte(pte);
-
-	if (!addr)
-		return _pte;
-
-	if (io_page &&
-	    (xen_initial_domain() || addr >= ISA_END_ADDRESS)) {
-		other_addr = pfn_to_mfn(addr >> PAGE_SHIFT) << PAGE_SHIFT;
-		WARN_ONCE(addr != other_addr,
-			"0x%lx is using VM_IO, but it is 0x%lx!\n",
-			(unsigned long)addr, (unsigned long)other_addr);
-	} else {
-		pteval_t iomap_set = (_pte.pte & PTE_FLAGS_MASK) & _PAGE_IOMAP;
-		other_addr = (_pte.pte & PTE_PFN_MASK);
-		WARN_ONCE((addr == other_addr) && (!io_page) && (!iomap_set),
-			"0x%lx is missing VM_IO (and wasn't fixed)!\n",
-			(unsigned long)addr);
-	}
-
-	return _pte;
-}
-PV_CALLEE_SAVE_REGS_THUNK(xen_make_pte_debug);
-#endif
-
 static pgd_t xen_make_pgd(pgdval_t pgd)
 {
 	pgd = pte_pfn_to_mfn(pgd);
@@ -1988,9 +1953,6 @@ void __init xen_ident_map_ISA(void)
 
 static void __init xen_post_allocator_init(void)
 {
-#ifdef CONFIG_XEN_DEBUG
-	pv_mmu_ops.make_pte = PV_CALLEE_SAVE(xen_make_pte_debug);
-#endif
 	pv_mmu_ops.set_pte = xen_set_pte;
 	pv_mmu_ops.set_pmd = xen_set_pmd;
 	pv_mmu_ops.set_pud = xen_set_pud;
-- 
1.7.4.1

