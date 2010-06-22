Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab0FVTqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 15:46:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51715 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab0FVTqp (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 22 Jun 2010 15:46:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es,
       x86@kernel.org
Cc: Alex Nixon <alex.nixon@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 02/19] xen: Allow unprivileged Xen domains to create iomap pages
Date: Tue, 22 Jun 2010 15:42:35 -0400
Message-Id: <1277235772-26757-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
References: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4C2112D9.018A:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Nixon <alex.nixon@citrix.com>

PV DomU domains are allowed to map hardware MFNs for PCI passthrough,
but are not generally allowed to map raw machine pages.  In particular,
various pieces of code try to map DMI and ACPI tables in the ISA ROM
range.  We disallow _PAGE_IOMAP for those mappings, so that they are
redirected to a set of local zeroed pages we reserve for that purpose.

[ Impact: prevent passthrough of ISA space, as we only allow PCI ]

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c |    4 ++++
 arch/x86/xen/mmu.c       |   18 +++++++++++++++---
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 65d8d79..3254e8b 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1145,6 +1145,10 @@ asmlinkage void __init xen_start_kernel(void)
 
 	pgd = (pgd_t *)xen_start_info->pt_base;
 
+	if (!xen_initial_domain())
+		__supported_pte_mask &= ~(_PAGE_PWT | _PAGE_PCD);
+
+	__supported_pte_mask |= _PAGE_IOMAP;
 	/* Don't do the full vcpu_info placement stuff until we have a
 	   possible map and a non-dummy shared_info. */
 	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index a4dea9d..a5577f5 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -51,6 +51,7 @@
 #include <asm/mmu_context.h>
 #include <asm/setup.h>
 #include <asm/paravirt.h>
+#include <asm/e820.h>
 #include <asm/linkage.h>
 
 #include <asm/xen/hypercall.h>
@@ -381,7 +382,7 @@ static bool xen_page_pinned(void *ptr)
 
 static bool xen_iomap_pte(pte_t pte)
 {
-	return xen_initial_domain() && (pte_flags(pte) & _PAGE_IOMAP);
+	return pte_flags(pte) & _PAGE_IOMAP;
 }
 
 static void xen_set_iomap_pte(pte_t *ptep, pte_t pteval)
@@ -583,10 +584,21 @@ PV_CALLEE_SAVE_REGS_THUNK(xen_pgd_val);
 
 pte_t xen_make_pte(pteval_t pte)
 {
-	if (unlikely(xen_initial_domain() && (pte & _PAGE_IOMAP)))
+	phys_addr_t addr = (pte & PTE_PFN_MASK);
+
+	/*
+	 * Unprivileged domains are allowed to do IOMAPpings for
+	 * PCI passthrough, but not map ISA space.  The ISA
+	 * mappings are just dummy local mappings to keep other
+	 * parts of the kernel happy.
+	 */
+	if (unlikely(pte & _PAGE_IOMAP) &&
+	    (xen_initial_domain() || addr >= ISA_END_ADDRESS)) {
 		pte = iomap_pte(pte);
-	else
+	} else {
+		pte &= ~_PAGE_IOMAP;
 		pte = pte_pfn_to_mfn(pte);
+	}
 
 	return native_make_pte(pte);
 }
-- 
1.7.0.1

