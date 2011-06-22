Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab1FVRMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 13:12:20 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:20915 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377Ab1FVRMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 13:12:18 -0400
X-IronPort-AV: E=Sophos;i="4.65,407,1304294400"; 
   d="scan'208";a="6431521"
Date: Wed, 22 Jun 2011 18:16:11 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Ingo Molnar <mingo@elte.hu>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 0/3] x86: remove x86_init.mapping.pagetable_reserve
In-Reply-To: <20110621205859.GA2446@elte.hu>
Message-ID: <alpine.DEB.2.00.1106221224100.12963@kaball-desktop>
References: <alpine.DEB.2.00.1106071849290.12963@kaball-desktop> <20110621205859.GA2446@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jun 2011, Ingo Molnar wrote:
> 
> -tip testing found that these patches cause the following boot crash 
> on native:
> 
> [    0.000000] Base memory trampoline at [ffff88000009d000] 9d000 size 8192
> [    0.000000] init_memory_mapping: 0000000000000000-000000003fff0000
> [    0.000000]  0000000000 - 003fff0000 page 4k
> [    0.000000] kernel direct mapping tables up to 3fff0000 @ 3fef0000-3fff0000
> [    0.000000] Kernel panic - not syncing: alloc_low_page: ran out of memory
> 
> Config attached, full bootlog below. I've excluded the commits for 
> now.
> 

Thanks for the logs; I was able to reproduce the problem and I know what
the issue is: CONFIG_DEBUG_PAGEALLOC forces use_pse to 0 while
on x86_64 cpu_has_pse is 1.
As a consequence the initial pagetable allocator in head_64.S didn't
allocate any pte pages but find_early_table_space assumes it did.
The issue doesn't happen on x86_32 (PAE and non-PAE) because head_32.S
always uses 4KB pages.

The patch below fixes the problem: on x86_64 we should not limit the
memory size we need to cover with 4KB ptes depending on the initial
allocation, because head_64.S always uses 2MB pages.

Ingo, if you know any other debug config options that might affect
page table allocations, please let me know.

---

commit 2b66a94cf8dbbf4cf2148456381b8674ed8191f0
Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date:   Wed Jun 22 11:46:23 2011 +0000

    x86_64: do not assume head_64.S used 4KB pages when !use_pse
    
    head_64.S, which sets up the initial page table on x86_64, is not aware
    of PSE being enabled or disabled and it always allocates the initial
    mapping using 2MB pages.
    
    Therefore on x86_64 find_early_table_space shouldn't update the amount
    of pages needed for pte pages depending on the size of the initial
    mapping, because we know for sure that no pte pages have been allocated
    yet.
    
    Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
    Reported-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 36bacfe..1e3098b 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -42,12 +42,19 @@ static void __init find_early_table_space(unsigned long start,
 			(PMD_SIZE * PTRS_PER_PMD));
 	pmd_mapped *= (PMD_SIZE * PTRS_PER_PMD);
 
+	/* 
+	 * On x86_64 do not limit the size we need to cover with 4KB pages
+	 * depending on the initial allocation because head_64.S always uses
+	 * 2MB pages.
+	 */
+#ifdef CONFIG_X86_32
 	if (start < PFN_PHYS(max_pfn_mapped)) {
 		if (PFN_PHYS(max_pfn_mapped) < end)
 			size -= PFN_PHYS(max_pfn_mapped) - start;
 		else
 			size = 0;
 	}
+#endif
 
 #ifndef __PAGETABLE_PUD_FOLDED
 	if (end > pud_mapped) {
