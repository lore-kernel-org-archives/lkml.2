Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754Ab1BDLd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 06:33:29 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:15259 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab1BDLd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 06:33:28 -0500
X-IronPort-AV: E=Sophos;i="4.60,425,1291593600"; 
   d="scan'208";a="4150055"
Date: Fri, 4 Feb 2011 11:35:15 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH] x86/mm/init: respect memblock reserved regions when
 destroying mappings
In-Reply-To: <4D4ADFAD.7060507@zytor.com>
Message-ID: <alpine.DEB.2.00.1102041130060.7277@kaball-desktop>
References: <alpine.DEB.2.00.1101311514580.7277@kaball-desktop> <4D4A3782.3050702@zytor.com> <alpine.DEB.2.00.1102031114030.7277@kaball-desktop> <4D4ADFAD.7060507@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Feb 2011, H. Peter Anvin wrote:
> On 02/03/2011 03:25 AM, Stefano Stabellini wrote:
> >>
> >> How on Earth would you end up with a reserved region *inside the BRK*?
> > 
> > I think in practice you cannot, but you can have reserved regions at
> > _end, that is the main problem I am trying to solve.
> > If we have a reserved region at _end and _end is not PMD aligned, then
> > we have a problem.
> > 
> > I thought that checking for reserved regions before destroying the
> > mapping would be a decent solution (because it wouldn't affect the
> > normal case); so I ended up checking between _brk_end and _end too.
> > 
> > Other alternative solutions I thought about but that I discarded because
> > they also affect the normal case are:
> > 
> > - never destroy mappings that could go over _end;
> > - always PMD align _end.
> > 
> > If none of the above are acceptable, I welcome other suggestions :-)
> > 
> 
> Sounds like the code does the right thing, but the description needs to
> be improved.
> 

I tried to improve both the commit message and the comments within the
code, this is the result:


commit d0136be7b48953f27202dbde285a7379d06cfe98
Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date:   Tue Jan 25 12:05:11 2011 +0000

    x86/mm/init: respect memblock reserved regions when destroying mappings
    
    In init_memory_mapping we destroy the mappings between _brk_end and
    _end, but if _end is not PMD aligned we also destroy mappings for
    potentially reserved regions between _end and the following PMD.
    
    In order to avoid this problem, before clearing any PMDs we check if the
    corresponding memory area has been reserved and we only destroy the
    mapping if hasn't.
    
    We found this issue because under Xen we have a valid mapping at _end,
    and if _end is not PMD aligned the current code destroys the initial
    part of it.
    
    In practice this fix does not have any impact on native.
    
    Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 947f42a..65c34f4 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -283,6 +283,8 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	if (!after_bootmem && !start) {
 		pud_t *pud;
 		pmd_t *pmd;
+		unsigned long addr;
+		u64 size, memblock_addr;
 
 		mmu_cr4_features = read_cr4();
 
@@ -291,11 +293,22 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 		 * located on different 2M pages. cleanup_highmap(), however,
 		 * can only consider _end when it runs, so destroy any
 		 * mappings beyond _brk_end here.
+		 *
+		 * If _end is not PMD aligned, we also destroy the mapping of
+		 * the memory area between _end the next PMD, so before clearing
+		 * the PMD we make sure that the corresponding memory region has
+		 * not been reserved.
 		 */
 		pud = pud_offset(pgd_offset_k(_brk_end), _brk_end);
 		pmd = pmd_offset(pud, _brk_end - 1);
-		while (++pmd <= pmd_offset(pud, (unsigned long)_end - 1))
-			pmd_clear(pmd);
+		addr = (_brk_end + PMD_SIZE - 1) & PMD_MASK;
+		while (++pmd <= pmd_offset(pud, (unsigned long)_end - 1)) {
+			memblock_addr = memblock_x86_find_in_range_size(__pa(addr),
+					&size, PMD_SIZE);
+			if (memblock_addr == (u64) __pa(addr) && size >= PMD_SIZE)
+				pmd_clear(pmd);
+			addr += PMD_SIZE;
+		}
 	}
 #endif
 	__flush_tlb_all();
