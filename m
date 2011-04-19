Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab1DSNrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 09:47:07 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:11477 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab1DSNrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 09:47:04 -0400
X-IronPort-AV: E=Sophos;i="4.64,239,1301875200"; 
   d="scan'208";a="5375506"
Date: Tue, 19 Apr 2011 14:47:31 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Ian Campbell <Ian.Campbell@citrix.com>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: xen: mask_rw_pte: do not apply the early_ioremap checks on x86_32
Message-ID: <alpine.DEB.2.00.1104191446090.10886@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two "is_early_ioremap_ptep" checks in mask_rw_pte are only used on
x86_64, in fact early_ioremap is not used at all to setup the initial
pagetable on x86_32.
Moreover on x86_32 the two checks are wrong because the range
pgt_buf_start..pgt_buf_end initially should be mapped RW because
the pages in the range are not pagetable pages yet and haven't been
cleared yet. Afterwards considering the pgt_buf_start..pgt_buf_end is
part of the initial mapping, xen_alloc_pte is capable of turning
the ptes RO when they become pagetable pages.

Fix the issue and improve the readability of the code providing two
different implementation of mask_rw_pte for x86_32 and x86_64.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 7ad0292..1e1808d 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1487,16 +1487,20 @@ static void xen_pgd_free(struct mm_struct *mm, pgd_t *pgd)
 #endif
 }
 
+#ifdef CONFIG_X86_32
 static __init pte_t mask_rw_pte(pte_t *ptep, pte_t pte)
 {
-	unsigned long pfn = pte_pfn(pte);
-
-#ifdef CONFIG_X86_32
 	/* If there's an existing pte, then don't allow _PAGE_RW to be set */
 	if (pte_val_ma(*ptep) & _PAGE_PRESENT)
 		pte = __pte_ma(((pte_val_ma(*ptep) & _PAGE_RW) | ~_PAGE_RW) &
 			       pte_val_ma(pte));
-#endif
+
+	return pte;
+}
+#else /* CONFIG_X86_64 */
+static __init pte_t mask_rw_pte(pte_t *ptep, pte_t pte)
+{
+	unsigned long pfn = pte_pfn(pte);
 
 	/*
 	 * If the new pfn is within the range of the newly allocated
@@ -1511,6 +1515,7 @@ static __init pte_t mask_rw_pte(pte_t *ptep, pte_t pte)
 
 	return pte;
 }
+#endif /* CONFIG_X86_64 */
 
 /* Init-time set_pte while constructing initial pagetables, which
    doesn't allow RO pagetable pages to be remapped RW */
