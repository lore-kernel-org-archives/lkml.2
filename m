Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab1IGRaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:30:52 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:55401 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab1IGRau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:30:50 -0400
X-IronPort-AV: E=Sophos;i="4.68,346,1312156800"; 
   d="scan'208";a="7659668"
Date: Wed, 7 Sep 2011 18:38:57 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH v3 2/2] xen: modify kernel mappings corresponding to
 granted pages
In-Reply-To: <4E67A646.7000405@goop.org>
Message-ID: <alpine.DEB.2.00.1109071825180.12963@kaball-desktop>
References: <alpine.DEB.2.00.1109071723470.12963@kaball-desktop> <1315413571-10938-2-git-send-email-stefano.stabellini@eu.citrix.com> <4E67A646.7000405@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Sep 2011, Jeremy Fitzhardinge wrote:
> On 09/07/2011 09:39 AM, stefano.stabellini@eu.citrix.com wrote:
> > From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> >
> > If we want to use granted pages for AIO, changing the mappings of a user
> > vma and the corresponding p2m is not enough, we also need to update the
> > kernel mappings accordingly.
> > In order to avoid the complexity of dealing with highmem, we allocated
> > the pages lowmem.
> > We issue a HYPERVISOR_grant_table_op right away in
> > m2p_add_override and we remove the mappings using another
> > HYPERVISOR_grant_table_op in m2p_remove_override.
> > Considering that m2p_add_override and m2p_remove_override are called
> > once per page we use multicalls and hypercall batching.
> >
> > Use the kmap_op pointer directly as argument to do the mapping as it is
> > guaranteed to be present up until the unmapping is done.
> > Before issuing any unmapping multicalls, we need to make sure that the
> > mapping has already being done, because we need the kmap->handle to be
> > set correctly.
> >
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  arch/x86/include/asm/xen/page.h |    5 ++-
> >  arch/x86/xen/p2m.c              |   67 ++++++++++++++++++++++++++++++++------
> >  drivers/xen/gntdev.c            |   27 +++++++++++++++-
> >  drivers/xen/grant-table.c       |    4 +-
> >  include/xen/grant_table.h       |    1 +
> >  5 files changed, 89 insertions(+), 15 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
> > index 7ff4669..0ce1884 100644
> > --- a/arch/x86/include/asm/xen/page.h
> > +++ b/arch/x86/include/asm/xen/page.h
> > @@ -12,6 +12,7 @@
> >  #include <asm/pgtable.h>
> >  
> >  #include <xen/interface/xen.h>
> > +#include <xen/grant_table.h>
> >  #include <xen/features.h>
> >  
> >  /* Xen machine address */
> > @@ -31,8 +32,10 @@ typedef struct xpaddr {
> >  #define INVALID_P2M_ENTRY	(~0UL)
> >  #define FOREIGN_FRAME_BIT	(1UL<<(BITS_PER_LONG-1))
> >  #define IDENTITY_FRAME_BIT	(1UL<<(BITS_PER_LONG-2))
> > +#define GRANT_FRAME_BIT	(1UL<<(BITS_PER_LONG-3))
> >  #define FOREIGN_FRAME(m)	((m) | FOREIGN_FRAME_BIT)
> >  #define IDENTITY_FRAME(m)	((m) | IDENTITY_FRAME_BIT)
> > +#define GRANT_FRAME(m)	((m) | GRANT_FRAME_BIT)
> >  
> >  /* Maximum amount of memory we can handle in a domain in pages */
> >  #define MAX_DOMAIN_PAGES						\
> > @@ -48,7 +51,7 @@ extern unsigned long set_phys_range_identity(unsigned long pfn_s,
> >  					     unsigned long pfn_e);
> >  
> >  extern int m2p_add_override(unsigned long mfn, struct page *page,
> > -			    bool clear_pte);
> > +			    struct gnttab_map_grant_ref *kmap_op);
> >  extern int m2p_remove_override(struct page *page, bool clear_pte);
> >  extern struct page *m2p_find_override(unsigned long mfn);
> >  extern unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn);
> > diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> > index 58efeb9..6c26ac80 100644
> > --- a/arch/x86/xen/p2m.c
> > +++ b/arch/x86/xen/p2m.c
> > @@ -161,7 +161,9 @@
> >  #include <asm/xen/page.h>
> >  #include <asm/xen/hypercall.h>
> >  #include <asm/xen/hypervisor.h>
> > +#include <xen/grant_table.h>
> >  
> > +#include "multicalls.h"
> >  #include "xen-ops.h"
> >  
> >  static void __init m2p_override_init(void);
> > @@ -676,7 +678,8 @@ static unsigned long mfn_hash(unsigned long mfn)
> >  }
> >  
> >  /* Add an MFN override for a particular page */
> > -int m2p_add_override(unsigned long mfn, struct page *page, bool clear_pte)
> > +int m2p_add_override(unsigned long mfn, struct page *page,
> > +		struct gnttab_map_grant_ref *kmap_op)
> >  {
> >  	unsigned long flags;
> >  	unsigned long pfn;
> > @@ -699,9 +702,20 @@ int m2p_add_override(unsigned long mfn, struct page *page, bool clear_pte)
> >  	if (unlikely(!set_phys_to_machine(pfn, FOREIGN_FRAME(mfn))))
> >  		return -ENOMEM;
> >  
> > -	if (clear_pte && !PageHighMem(page))
> > -		/* Just zap old mapping for now */
> > -		pte_clear(&init_mm, address, ptep);
> > +	if (kmap_op != NULL) {
> > +		if (!PageHighMem(page)) {
> > +			struct multicall_space mcs = xen_mc_entry(sizeof(*kmap_op));
> > +
> > +			MULTI_grant_table_op(mcs.mc,
> > +					GNTTABOP_map_grant_ref, kmap_op, 1);
> > +
> > +			xen_mc_issue(PARAVIRT_LAZY_MMU);
> > +		}
> > +		page->private |= GRANT_FRAME_BIT;
> > +		/* let's use dev_bus_addr to record the old mfn instead */
> > +		kmap_op->dev_bus_addr = page->index;
> > +		page->index = (unsigned long) kmap_op;
> > +	}
> >  	spin_lock_irqsave(&m2p_override_lock, flags);
> >  	list_add(&page->lru,  &m2p_overrides[mfn_hash(mfn)]);
> >  	spin_unlock_irqrestore(&m2p_override_lock, flags);
> > @@ -735,13 +749,44 @@ int m2p_remove_override(struct page *page, bool clear_pte)
> >  	spin_lock_irqsave(&m2p_override_lock, flags);
> >  	list_del(&page->lru);
> >  	spin_unlock_irqrestore(&m2p_override_lock, flags);
> > -	set_phys_to_machine(pfn, page->index);
> >  
> > -	if (clear_pte && !PageHighMem(page))
> > -		set_pte_at(&init_mm, address, ptep,
> > -				pfn_pte(pfn, PAGE_KERNEL));
> > -		/* No tlb flush necessary because the caller already
> > -		 * left the pte unmapped. */
> > +	if (clear_pte) {
> > +		struct gnttab_map_grant_ref *map_op =
> > +			(struct gnttab_map_grant_ref *) page->index;
> > +		set_phys_to_machine(pfn, map_op->dev_bus_addr);
> > +		if (!PageHighMem(page)) {
> > +			struct multicall_space mcs =
> > +				xen_mc_entry(sizeof(struct gnttab_unmap_grant_ref));
> > +			struct gnttab_unmap_grant_ref *unmap_op = mcs.args;
> > +
> > +			/* 
> > +			 * Has the grant_op mapping multicall being issued? If not,
> > +			 * make sure it is called now.
> > +			 */
> > +			if (map_op->handle == -1)
> > +				xen_mc_flush();
> 
> Hm, this will end up flushing the empty uninitialized entry you just
> added, which also implicitly frees the space, so all the stuff below is
> - at best - a noop.

I'll have to move it earlier.


> But also, this pattern of getting results back from batched calls is
> unusual - actually, I think this is unique.  If you have batched up a
> map operation which has its map_op args allocated from the multicall
> buffer, then the flush will implicitly free them as well, so it isn't
> valid to read back from the structure later on.  If you want to have an
> args structure you can use once the hypercall has been issued, you need
> to manually manage its lifetime.

But I am not using the multicall buffer as argument, I am using the
kmap_op passed to m2p_add_override.
