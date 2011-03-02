Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab1CBPXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 10:23:53 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:45642 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab1CBPXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 10:23:52 -0500
X-IronPort-AV: E=Sophos;i="4.62,253,1297036800"; 
   d="scan'208";a="4579864"
Date: Wed, 2 Mar 2011 15:23:48 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Yinghai Lu <yinghai@kernel.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: "x86-64, mm: Put early page table high" causes crash on Xen
In-Reply-To: <4D6D6980.7060304@kernel.org>
Message-ID: <alpine.DEB.2.00.1103021123140.2968@kaball-desktop>
References: <alpine.DEB.2.00.1103011517280.2917@kaball-desktop> <4D6D6980.7060304@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Mar 2011, Yinghai Lu wrote:
> We do need map_low_page ( BTW, that name is totally misleading...)
> 
> the reason is we put page_table high and at that time is not under max_pfn_mapped. (aka not mapped).
> 
> So have to use 
> 	adr = early_memremap(phys & PAGE_MASK, PAGE_SIZE);
> to early map it and Read/Write to it.
 
I think I have figured out a way to update the logic of mask_rw_pte to
account for the new way of allocating kernel pagetables.
The appended patch fix the boot crash for me.

---

xen: update mask_rw_pte after kernel page tables init changes

Already existing kernel page table pages can now be mapped using
early_ioremap too so we need to update mask_rw_pte to make sure these
pages are still mapped RO.
We do that by mapping RO all the pages mapped using early_ioremap apart
from the last one that has been allocated because it is not a page table
page yet (it has been hooked into the page tables yet).

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 62192cd..2ff68be 100644
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
