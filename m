Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab0L3TuX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 14:50:23 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:39091 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab0L3TuW (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 30 Dec 2010 14:50:22 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        <hpa@zytor.com>, Ian Campbell <Ian.Campbell@citrix.com>
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 6/8] xen/debug: WARN_ON when 1-1 but no _PAGE_IOMAP flag set.
Date: Thu, 30 Dec 2010 14:48:35 -0500
Message-Id: <1293738517-7287-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1293738517-7287-1-git-send-email-konrad.wilk@oracle.com>
References: <1293738517-7287-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only enabled if XEN_DEBUG_FS is enabled. We print a warning
when:

 pfn_to_mfn(pfn) == pfn, but no VM_IO (_PAGE_IOMAP) flag
 pfn_to_mfn(pfn) != pfn, and VM_IO flag is set.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index e9dfdd6..d98bd43 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -944,6 +944,40 @@ pte_t xen_make_pte(pteval_t pte)
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_make_pte);
 
+#ifdef CONFIG_XEN_DEBUG_FS
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
+		other_addr = (_pte.pte & PTE_PFN_MASK);
+		WARN((addr == other_addr) && (!io_page),
+			"0x%lx is missing VM_IO!\n",
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
@@ -2354,6 +2388,9 @@ __init void xen_ident_map_ISA(void)
 
 static __init void xen_post_allocator_init(void)
 {
+#ifdef CONFIG_XEN_DEBUG_FS
+	pv_mmu_ops.make_pte = PV_CALLEE_SAVE(xen_make_pte_debug);
+#endif
 	pv_mmu_ops.set_pte = xen_set_pte;
 	pv_mmu_ops.set_pmd = xen_set_pmd;
 	pv_mmu_ops.set_pud = xen_set_pud;
-- 
1.7.1

