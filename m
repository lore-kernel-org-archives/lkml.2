Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684Ab2EWRiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 13:38:08 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:13277 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab2EWRiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 13:38:05 -0400
X-IronPort-AV: E=Sophos;i="4.75,645,1330905600"; 
   d="scan'208";a="12634301"
Date: Wed, 23 May 2012 18:37:16 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: mark local pages as FOREIGN in the m2p_override
In-Reply-To: <20120523142057.GA7598@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1205231551360.26786@kaball-desktop>
References: <1336994587-10203-1-git-send-email-stefano.stabellini@eu.citrix.com> <20120523142057.GA7598@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, Konrad Rzeszutek Wilk wrote:
> On Mon, May 14, 2012 at 12:23:07PM +0100, Stefano Stabellini wrote:
> > When the frontend and the backend reside on the same domain, even if we
> > add pages to the m2p_override, these pages will never be returned by
> > mfn_to_pfn because the check "get_phys_to_machine(pfn) != mfn" will
> > always fail, so the pfn of the frontend will be returned instead
> > (resulting in a deadlock because the frontend pages are already locked).
> > 
> > However m2p_add_override can easily find out whether another pfn
> > corresponding to the mfn exists in the m2p, and can set the FOREIGN bit
> > in the p2m, making sure that mfn_to_pfn returns the pfn of the backend.
> > 
> > This allows the backend to perform direct_IO on these pages, but as a
> > side effect prevents the frontend from using get_user_pages_fast on
> > them while they are being shared with the backend.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  arch/x86/xen/p2m.c |   18 ++++++++++++++++++
> >  1 files changed, 18 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> > index 7ece122..c62ae5c 100644
> > --- a/arch/x86/xen/p2m.c
> > +++ b/arch/x86/xen/p2m.c
> > @@ -687,6 +687,7 @@ int m2p_add_override(unsigned long mfn, struct page *page,
> >  	unsigned long uninitialized_var(address);
> >  	unsigned level;
> >  	pte_t *ptep = NULL;
> > +	int ret = 0;
> >  
> >  	pfn = page_to_pfn(page);
> >  	if (!PageHighMem(page)) {
> > @@ -722,6 +723,16 @@ int m2p_add_override(unsigned long mfn, struct page *page,
> >  	list_add(&page->lru,  &m2p_overrides[mfn_hash(mfn)]);
> >  	spin_unlock_irqrestore(&m2p_override_lock, flags);
> >  
> > +	/* p2m(m2p(mfn)) == mfn: the mfn is already present somewhere in
> > +	 * this domain. Set the FOREIGN_FRAME_BIT in the p2m for the other
> 
> <nods> In other words, the MFN is local. And you want it to be forced
> to be !local - foreign right.

Yes


> > +	 * pfn so that the following mfn_to_pfn(mfn) calls will return the
> 
> .. the other pfn being. So we want to override p2m(m2p(mfn)) == mfn[frontend]
> so that it becomes p2m(m2p(mfn)) == mfn[backend]? (nods)

Exactly


> What happens if multiple m2p_add_override are called on the same page?
> This would be possible if the xen-blkfront is setup shared for the same
> disk, right?

It is possible even with a single disk, I can see the frontend sharing
three times the same page, before the first request has completed, when
mounting an ext4 partition.

But it is completely safe: m2p_add_override is going to set the page as
FOREIGN the first time and m2p_remove_override is going to remove the
bit only when the last page is unshared (it does so by checking
m2p_find_override(mfn) == NULL).


> Won't we loose the old frontend PFN -> backend MFN information then as
> we would overwrite the old P2M relationship?

No, we are just changing it to be:

old frontend PFN -> (backend MFN | FOREIGN_FRAME_BIT)


> > +	 * pfn from the m2p_override (the backend pfn) instead.
> 
> Can you explain in the comment why we want to do that. I think
> I know, but I am not going to remember it in a month.

Good point.
The reason is that the pages that have been shared by xen-blkfront
are locked (lock_page, called by do_read_cache_page).
When the userspace backend tries to use them with direct_IO, mfn_to_pfn
returns the pfn of the frontend, so do_blockdev_direct_IO is going to
try to lock the same pages again.
I'll add this comment to the commit message.


> > +	 * As a side effect GUPF might not be safe on the frontend pages
> > +	 * while they are being shared with the backend. */
> 
> How is it not safe?

Because get_user_pages_fast ends up calling mfn_to_pfn that would now
return the backend pfn rather than the frontend pfn.


> > +	ret = __get_user(pfn, &machine_to_phys_mapping[mfn]);
> > +	if (ret >= 0 && get_phys_to_machine(pfn) == mfn)
> 
> if (ret == 0)
> 
> [get_user only provides -EFAULT or 0]

OK, I'll change the check.


> > +		set_phys_to_machine(pfn, FOREIGN_FRAME(mfn));
> > +
> >  	return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(m2p_add_override);
> > @@ -733,6 +744,7 @@ int m2p_remove_override(struct page *page, bool clear_pte)
> >  	unsigned long uninitialized_var(address);
> >  	unsigned level;
> >  	pte_t *ptep = NULL;
> > +	int ret = 0;
> >  
> >  	pfn = page_to_pfn(page);
> >  	mfn = get_phys_to_machine(pfn);
> > @@ -802,6 +814,12 @@ int m2p_remove_override(struct page *page, bool clear_pte)
> >  	} else
> >  		set_phys_to_machine(pfn, page->index);
> >  
> 
> You also need a comment here.

OK, I'll add one.


> > +	mfn &= ~FOREIGN_FRAME_BIT;
> > +	ret = __get_user(pfn, &machine_to_phys_mapping[mfn]);
> > +	if (ret >= 0 && get_phys_to_machine(pfn) == FOREIGN_FRAME(mfn) &&
> 
> ret == 0

OK

> > +			m2p_find_override(mfn) == NULL)
> > +		set_phys_to_machine(pfn, mfn);
> > +
> >  	return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(m2p_remove_override);
> > -- 
> > 1.7.2.5
> 
