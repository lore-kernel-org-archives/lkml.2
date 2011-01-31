Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab1AaXJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:09:17 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:22692 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689Ab1AaXJO (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 31 Jan 2011 18:09:14 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Xen-devel@lists.xensource.com,
        konrad@kernel.org, jeremy@goop.org
Cc: hpa@zytor.com, stefano.stabellini@eu.citrix.com,
        Ian.Campbell@eu.citrix.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 09/11] xen/debug: WARN_ON when identity PFN has no _PAGE_IOMAP flag set.
Date: Mon, 31 Jan 2011 17:44:34 -0500
Message-Id: <1296513876-31415-10-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com>
References: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only enabled if XEN_DEBUG is enabled. We print a warning
when:

 pfn_to_mfn(pfn) == pfn, but no VM_IO (_PAGE_IOMAP) flag set
	(and pfn is an identity mapped pfn)
 pfn_to_mfn(pfn) != pfn, and VM_IO flag is set.
	(ditto, pfn is an identity mapped pfn)

[v2: Make it dependent on CONFIG_XEN_DEBUG instead of ..DEBUG_FS]
[v3: Fix compiler warning]

Reviewed-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/Kconfig |    8 ++++++++
 arch/x86/xen/mmu.c   |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 5b54892..e4343fe 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -48,3 +48,11 @@ config XEN_DEBUG_FS
 	help
 	  Enable statistics output and various tuning options in debugfs.
 	  Enabling this option may incur a significant performance overhead.
+
+config XEN_DEBUG
+	bool "Enable Xen debug checks"
+	depends on XEN
+	default n
+	help
+	  Enable various WARN_ON checks in the Xen MMU code.
+	  Enabling this option WILL incur a significant performance overhead.
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index b13b6ca..0c376a2 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -547,6 +547,41 @@ pte_t xen_make_pte(pteval_t pte)
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_make_pte);
 
+#ifdef CONFIG_XEN_DEBUG
+pte_t xen_make_pte_debug(pteval_t pte)
+{
+	phys_addr_t addr = (pte & PTE_PFN_MASK);
+	phys_addr_t other_addr;
+	bool io_page = false;
+	pte_t _pte;
+
+	if (pte & _PAGE_IOMAP)
+		io_page = true;
+
+	_pte = xen_make_pte(pte);
+
+	if (!addr)
+		return _pte;
+
+	if (io_page &&
+	    (xen_initial_domain() || addr >= ISA_END_ADDRESS)) {
+		other_addr = pfn_to_mfn(addr >> PAGE_SHIFT) << PAGE_SHIFT;
+		WARN(addr != other_addr,
+			"0x%lx is using VM_IO, but it is 0x%lx!\n",
+			(unsigned long)addr, (unsigned long)other_addr);
+	} else {
+		pteval_t iomap_set = (_pte.pte & PTE_FLAGS_MASK) & _PAGE_IOMAP;
+		other_addr = (_pte.pte & PTE_PFN_MASK);
+		WARN((addr == other_addr) && (!io_page) && (!iomap_set),
+			"0x%lx is missing VM_IO (and wasn't fixed)!\n",
+			(unsigned long)addr);
+	}
+
+	return _pte;
+}
+PV_CALLEE_SAVE_REGS_THUNK(xen_make_pte_debug);
+#endif
+
 pgd_t xen_make_pgd(pgdval_t pgd)
 {
 	pgd = pte_pfn_to_mfn(pgd);
@@ -1957,6 +1992,9 @@ __init void xen_ident_map_ISA(void)
 
 static __init void xen_post_allocator_init(void)
 {
+#ifdef CONFIG_XEN_DEBUG
+	pv_mmu_ops.make_pte = PV_CALLEE_SAVE(xen_make_pte_debug);
+#endif
 	pv_mmu_ops.set_pte = xen_set_pte;
 	pv_mmu_ops.set_pmd = xen_set_pmd;
 	pv_mmu_ops.set_pud = xen_set_pud;
-- 
1.7.1

