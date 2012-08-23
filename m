Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934109Ab2HWPug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:50:36 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:33632 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab2HWPuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:50:32 -0400
Date: Thu, 23 Aug 2012 11:40:13 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 06/11] xen/mmu: For 64-bit do not call
 xen_map_identity_early
Message-ID: <20120823154012.GA18845@phenom.dumpdata.com>
References: <1345133009-21941-1-git-send-email-konrad.wilk@oracle.com>
 <1345133009-21941-7-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1208171839590.15568@kaball.uk.xensource.com>
 <20120817174549.GA14257@phenom.dumpdata.com>
 <alpine.DEB.2.02.1208201243180.15568@kaball.uk.xensource.com>
 <1345463624.28762.67.camel@zakaz.uk.xensource.com>
 <alpine.DEB.2.02.1208201257420.15568@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1208201257420.15568@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 12:58:37PM +0100, Stefano Stabellini wrote:
> On Mon, 20 Aug 2012, Ian Campbell wrote:
> > On Mon, 2012-08-20 at 12:45 +0100, Stefano Stabellini wrote:
> > > On Fri, 17 Aug 2012, Konrad Rzeszutek Wilk wrote:
> > > > On Fri, Aug 17, 2012 at 06:41:23PM +0100, Stefano Stabellini wrote:
> > > > > On Thu, 16 Aug 2012, Konrad Rzeszutek Wilk wrote:
> > > > > > B/c we do not need it. During the startup the Xen provides
> > > > > > us with all the memory mapped that we need to function.
> > > > > 
> > > > > Shouldn't we check to make sure that is actually true (I am thinking at
> > > > > nr_pt_frames)?
> > > > 
> > > > I was looking at the source code (hypervisor) to figure it out and
> > > > that is certainly true.
> > > > 
> > > > 
> > > > > Or is it actually stated somewhere in the Xen headers?
> > > > 
> > > > Couldn't find it, but after looking so long at the source code
> > > > I didn't even bother looking for it.
> > > > 
> > > > Thought to be honest - I only looked at how the 64-bit pagetables
> > > > were set up, so I didn't dare to touch the 32-bit. Hence the #ifdef
> > > 
> > > I think that we need to involve some Xen maintainers and get this
> > > written down somewhere in the public headers, otherwise we have no
> > > guarantees that it is going to stay as it is in the next Xen versions.
> > > 
> > > Maybe we just need to add a couple of lines of comment to
> > > xen/include/public/xen.h.
> > 
> > The start of day memory layout for PV guests is written down in the
> > comment just before struct start_info at
> > http://xenbits.xen.org/docs/unstable/hypercall/include,public,xen.h.html#Struct_start_info
> > 
> > (I haven't read this thread to determine if what is documented matches
> > what you guys are talking about relying on)
> 
> but it is not written down how much physical memory is going to be
> mapped in the bootstrap page tables.

How about this:


>From 43fd7a5d9ecd31c2fc26851523cd4b5f7650fb39 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Thu, 12 Jul 2012 13:59:36 -0400
Subject: [PATCH] xen/mmu: For 64-bit do not call xen_map_identity_early

B/c we do not need it. During the startup the Xen provides
us with all the initial memory mapped that we need to function.

The initial memory mapped is up to the bootstack, which means
we can reference using __ka up to 4.f):

(from xen/interface/xen.h):

 4. This the order of bootstrap elements in the initial virtual region:
   a. relocated kernel image
   b. initial ram disk              [mod_start, mod_len]
   c. list of allocated page frames [mfn_list, nr_pages]
   d. start_info_t structure        [register ESI (x86)]
   e. bootstrap page tables         [pt_base, CR3 (x86)]
   f. bootstrap stack               [register ESP (x86)]

(initial ram disk may be ommitted).

[v1: More comments in git commit]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 7247e5a..a59070b 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -84,6 +84,7 @@
  */
 DEFINE_SPINLOCK(xen_reservation_lock);
 
+#ifdef CONFIG_X86_32
 /*
  * Identity map, in addition to plain kernel map.  This needs to be
  * large enough to allocate page table pages to allocate the rest.
@@ -91,7 +92,7 @@ DEFINE_SPINLOCK(xen_reservation_lock);
  */
 #define LEVEL1_IDENT_ENTRIES	(PTRS_PER_PTE * 4)
 static RESERVE_BRK_ARRAY(pte_t, level1_ident_pgt, LEVEL1_IDENT_ENTRIES);
-
+#endif
 #ifdef CONFIG_X86_64
 /* l3 pud for userspace vsyscall mapping */
 static pud_t level3_user_vsyscall[PTRS_PER_PUD] __page_aligned_bss;
@@ -1628,7 +1629,7 @@ static void set_page_prot(void *addr, pgprot_t prot)
 	if (HYPERVISOR_update_va_mapping((unsigned long)addr, pte, 0))
 		BUG();
 }
-
+#ifdef CONFIG_X86_32
 static void __init xen_map_identity_early(pmd_t *pmd, unsigned long max_pfn)
 {
 	unsigned pmdidx, pteidx;
@@ -1679,7 +1680,7 @@ static void __init xen_map_identity_early(pmd_t *pmd, unsigned long max_pfn)
 
 	set_page_prot(pmd, PAGE_KERNEL_RO);
 }
-
+#endif
 void __init xen_setup_machphys_mapping(void)
 {
 	struct xen_machphys_mapping mapping;
@@ -1765,14 +1766,12 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
 	/* Note that we don't do anything with level1_fixmap_pgt which
 	 * we don't need. */
 
-	/* Set up identity map */
-	xen_map_identity_early(level2_ident_pgt, max_pfn);
-
 	/* Make pagetable pieces RO */
 	set_page_prot(init_level4_pgt, PAGE_KERNEL_RO);
 	set_page_prot(level3_ident_pgt, PAGE_KERNEL_RO);
 	set_page_prot(level3_kernel_pgt, PAGE_KERNEL_RO);
 	set_page_prot(level3_user_vsyscall, PAGE_KERNEL_RO);
+	set_page_prot(level2_ident_pgt, PAGE_KERNEL_RO);
 	set_page_prot(level2_kernel_pgt, PAGE_KERNEL_RO);
 	set_page_prot(level2_fixmap_pgt, PAGE_KERNEL_RO);
 
-- 
1.7.7.6

