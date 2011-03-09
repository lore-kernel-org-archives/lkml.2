Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045Ab1CIOdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 09:33:15 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:47113 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961Ab1CIOdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 09:33:14 -0500
X-IronPort-AV: E=Sophos;i="4.62,290,1297036800"; 
   d="scan'208";a="4697964"
Date: Wed, 9 Mar 2011 14:32:52 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <yinghai@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: [PATCH] xen: update mask_rw_pte after kernel page tables init
 changes
Message-ID: <alpine.DEB.2.00.1103091429300.2968@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After "x86-64, mm: Put early page table high" already existing kernel
page table pages can be mapped using early_ioremap too so we need to
update mask_rw_pte to make sure these pages are still mapped RO.
The reason why we have to do that is explain by the commit message of
fef5ba797991f9335bcfc295942b684f9bf613a1:

"Xen requires that all pages containing pagetable entries to be mapped
read-only.  If pages used for the initial pagetable are already mapped
then we can change the mapping to RO.  However, if they are initially
unmapped, we need to make sure that when they are later mapped, they
are also mapped RO.

..SNIP..

the pagetable setup code early_ioremaps the pages to write their
entries, so we must make sure that mappings created in the early_ioremap
fixmap area are mapped RW.  (Those mappings are removed before the pages
are presented to Xen as pagetable pages.)"

We accomplish all this in mask_rw_pte by mapping RO all the pages mapped
using early_ioremap apart from the last one that has been allocated
because it is not a page table page yet (it has not been hooked into the
page tables yet).

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/mmu.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 13783a1..5190af6 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1440,10 +1440,12 @@ static __init pte_t mask_rw_pte(pte_t *ptep, pte_t pte)
 	/*
 	 * If the new pfn is within the range of the newly allocated
 	 * kernel pagetable, and it isn't being mapped into an
-	 * early_ioremap fixmap slot, make sure it is RO.
+	 * early_ioremap fixmap slot as a freshly allocated page, make sure
+	 * it is RO.
 	 */
-	if (!is_early_ioremap_ptep(ptep) &&
-	    pfn >= pgt_buf_start && pfn < pgt_buf_end)
+	if (((!is_early_ioremap_ptep(ptep) &&
+			pfn >= pgt_buf_start && pfn < pgt_buf_end)) ||
+			(is_early_ioremap_ptep(ptep) && pfn != (pgt_buf_end - 1)))
 		pte = pte_wrprotect(pte);
 
 	return pte;
-- 
1.5.6.5

