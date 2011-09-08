Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804Ab1IHMsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 08:48:52 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:20663 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932704Ab1IHMsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 08:48:05 -0400
X-IronPort-AV: E=Sophos;i="4.68,350,1312156800"; 
   d="scan'208";a="7675647"
Date: Thu, 8 Sep 2011 13:56:05 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH v3 2/2] xen: modify kernel mappings corresponding to
 granted pages
In-Reply-To: <20110907222749.GA23258@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1109081352161.12963@kaball-desktop>
References: <alpine.DEB.2.00.1109071723470.12963@kaball-desktop> <1315413571-10938-2-git-send-email-stefano.stabellini@eu.citrix.com> <20110907222749.GA23258@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Sep 2011, Konrad Rzeszutek Wilk wrote:
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
> 
> So how come you ripped out 'clear_pte' here but left it in
> m2p_remove_override? Is it b/c you aren't doing the pte_clear in
> the first place?

Because the "clear_pte" has been replaced with a proper update of the
kernel mappings for these pages. If the caller doesn't need that, it can
just pass NULL.


> Also there are other users of 'm2p_add_override' that you hadn't modified
> (blkback.c) so it will cause an compile failure.
> 
> Please also test this patchset with the blkback in the picture to make
> sure this: cf8d91633ddef9e816ccbf3da833c79ce508988d
> does not happen.

I think I didn't find a compilation problem because false becomes NULL
with my compiler. Fixed now.


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
> 
> scripts/checkpath.pl will throw a fit at the above.
> 

right, fixed.
