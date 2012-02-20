Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab2BTQHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 11:07:44 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:32098 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab2BTQHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 11:07:24 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        x86@kernel.org
Cc: jeremy@goop.org
Subject: [PATCH] Disable PAT support when running under Xen (v1).
Date: Mon, 20 Feb 2012 11:01:25 -0500
Message-Id: <1329753687-29218-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F426FB2.023D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The issue at hand is that any prolonged usage of radeon or nouveau driver
ends up corrupting the file system or we end up with mysterious crashes of
applications.

There are three ways of fixing it:
 a). A proper fix: https://lkml.org/lkml/2012/2/10/228 . I posted the same
   fix for 3.2 way back in December but it got nowhere. The recent posting
   has also been meet with silence. Not being happy with this laying
   around and corrupting folks file systems (and in my case my git tree):

 b). Disable PAT when run under Xen. At least until we get the a) moving
   or alternative solutions are found.

 c). Use the 'nopat' argument on the Linux command line (which is what
   this patch set (b) forces unconditionally) and has been recommended on the
   BZs for users.

In summary this patch set:
  - fixes corruption issues
  - makes graphic drivers not able to use Write-Combine - meaning you can't
    get super-fast performance using graphic drivers.

Konrad Rzeszutek Wilk (2):
      xen/setup: Remove redundant filtering of PTE masks.
      xen/pat: Disable PAT support for now.

 arch/x86/xen/enlighten.c |    6 ++----
 arch/x86/xen/mmu.c       |    8 ++++----
 2 files changed, 6 insertions(+), 8 deletions(-)


diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 12eb07b..4172af8 100644
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
@@ -1204,10 +1206,6 @@ asmlinkage void __init xen_start_kernel(void)
 
 	pgd = (pgd_t *)xen_start_info->pt_base;
 
-	if (!xen_initial_domain())
-		__supported_pte_mask &= ~(_PAGE_PWT | _PAGE_PCD);
-
-	__supported_pte_mask |= _PAGE_IOMAP;
 	/* Don't do the full vcpu_info placement stuff until we have a
 	   possible map and a non-dummy shared_info. */
 	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
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
