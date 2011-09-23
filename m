Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab1IWNzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 09:55:23 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:1657 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab1IWNzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 09:55:19 -0400
X-IronPort-AV: E=Sophos;i="4.68,430,1312156800"; 
   d="scan'208";a="8031315"
Date: Fri, 23 Sep 2011 14:55:09 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH v4 2/2] xen: modify kernel mappings corresponding to
 granted pages
In-Reply-To: <20110921145853.GA541@phenom.oracle.com>
Message-ID: <alpine.DEB.2.00.1109231412220.8700@kaball-desktop>
References: <alpine.DEB.2.00.1109081944150.12963@kaball-desktop> <20110921145853.GA541@phenom.oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Sep 2011, konrad.wilk@oracle.com wrote:
> On Thu, Sep 08, 2011 at 07:45:29PM +0100, Stefano Stabellini wrote:
> > If we want to use granted pages for AIO, changing the mappings of a user
> > vma and the corresponding p2m is not enough, we also need to update the
> > kernel mappings accordingly.
> 
> Please add:"
> 
> But only for pages that are created for user usages through /dev/xen/gntdev.
> As in, pages that have been in use by the kernel and use the P2M will not need
> this special mapping."
> 
> Just so that it is quite clear when in a year somebody wants to debug
> this code and wants to figure out if this patch causes issues.
> 
> .. more comments below.

OK, even though in the future it might happen that the kernel starts
accessing pages through the 1:1 even for internal usage. Right now the
only case in which this happens is on the user AIO code path but it
doesn't mean that the problem is always going to be limited to pages
used for user AIO.


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
> >  arch/x86/include/asm/xen/page.h     |    5 ++-
> >  arch/x86/xen/p2m.c                  |   68 +++++++++++++++++++++++++++++------
> >  drivers/block/xen-blkback/blkback.c |    2 +-
> >  drivers/xen/gntdev.c                |   27 +++++++++++++-
> >  drivers/xen/grant-table.c           |    6 ++--
> >  include/xen/grant_table.h           |    1 +
> >  6 files changed, 92 insertions(+), 17 deletions(-)
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
> >  #define INVALID_P2M_ENTRY    (~0UL)
> >  #define FOREIGN_FRAME_BIT    (1UL<<(BITS_PER_LONG-1))
> >  #define IDENTITY_FRAME_BIT   (1UL<<(BITS_PER_LONG-2))
> > +#define GRANT_FRAME_BIT      (1UL<<(BITS_PER_LONG-3))
> >  #define FOREIGN_FRAME(m)     ((m) | FOREIGN_FRAME_BIT)
> >  #define IDENTITY_FRAME(m)    ((m) | IDENTITY_FRAME_BIT)
> > +#define GRANT_FRAME(m)       ((m) | GRANT_FRAME_BIT)
> >
> >  /* Maximum amount of memory we can handle in a domain in pages */
> >  #define MAX_DOMAIN_PAGES                                             \
> > @@ -48,7 +51,7 @@ extern unsigned long set_phys_range_identity(unsigned long pfn_s,
> >                                            unsigned long pfn_e);
> >
> >  extern int m2p_add_override(unsigned long mfn, struct page *page,
> > -                         bool clear_pte);
> > +                         struct gnttab_map_grant_ref *kmap_op);
> >  extern int m2p_remove_override(struct page *page, bool clear_pte);
> >  extern struct page *m2p_find_override(unsigned long mfn);
> >  extern unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn);
> > diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> > index 58efeb9..23f8465 100644
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
> > +             struct gnttab_map_grant_ref *kmap_op)
> >  {
> >       unsigned long flags;
> >       unsigned long pfn;
> > @@ -699,9 +702,20 @@ int m2p_add_override(unsigned long mfn, struct page *page, bool clear_pte)
> >       if (unlikely(!set_phys_to_machine(pfn, FOREIGN_FRAME(mfn))))
> >               return -ENOMEM;
> >
> > -     if (clear_pte && !PageHighMem(page))
> > -             /* Just zap old mapping for now */
> > -             pte_clear(&init_mm, address, ptep);
> > +     if (kmap_op != NULL) {
> > +             if (!PageHighMem(page)) {
> > +                     struct multicall_space mcs = xen_mc_entry(sizeof(*kmap_op));
> > +
> > +                     MULTI_grant_table_op(mcs.mc,
> > +                                     GNTTABOP_map_grant_ref, kmap_op, 1);
> > +
> > +                     xen_mc_issue(PARAVIRT_LAZY_MMU);
> > +             }
> > +             page->private |= GRANT_FRAME_BIT;
> > +             /* let's use dev_bus_addr to record the old mfn instead */
> > +             kmap_op->dev_bus_addr = page->index;
> > +             page->index = (unsigned long) kmap_op;
> > +     }
> >       spin_lock_irqsave(&m2p_override_lock, flags);
> >       list_add(&page->lru,  &m2p_overrides[mfn_hash(mfn)]);
> >       spin_unlock_irqrestore(&m2p_override_lock, flags);
> > @@ -735,13 +749,45 @@ int m2p_remove_override(struct page *page, bool clear_pte)
> >       spin_lock_irqsave(&m2p_override_lock, flags);
> >       list_del(&page->lru);
> >       spin_unlock_irqrestore(&m2p_override_lock, flags);
> > -     set_phys_to_machine(pfn, page->index);
> >
> > -     if (clear_pte && !PageHighMem(page))
> > -             set_pte_at(&init_mm, address, ptep,
> > -                             pfn_pte(pfn, PAGE_KERNEL));
> > -             /* No tlb flush necessary because the caller already
> > -              * left the pte unmapped. */
> > +     if (clear_pte) {
> > +             struct gnttab_map_grant_ref *map_op =
> > +                     (struct gnttab_map_grant_ref *) page->index;
> > +             set_phys_to_machine(pfn, map_op->dev_bus_addr);
> > +             if (!PageHighMem(page)) {
> > +                     struct multicall_space mcs;
> > +                     struct gnttab_unmap_grant_ref *unmap_op;
> > +
> > +                     /*
> > +                      * Has the grant_op mapping multicall being issued? If not,
> > +                      * make sure it is called now.
> > +                      */
> > +                     if (map_op->handle == -1)
> > +                             xen_mc_flush();
> 
> How do you trigger this case? The mapping looks to be set by "gntdev_add_map"
> which is happening right after in gntdev_alloc_map..
> 
> If it had failed from the gntdev_alloc_map to gntdev_add_map this page would
> have never been used in the m2p as we would not have provided the proper
> op.index value to the user. Which mean that the user could not have mmaped
> and gotten to this code.

The problem is that all the grant table mappings are done through
multicalls now, and we are not really sure when the multicall is going
to be actually issued.
It might be that we queued all the m2p grant table hypercalls in a
multicall, then m2p_remove_override gets called before the multicall has
actually been issued. In this case handle is going to -1 because it hasn't
been modified yet.
This is the case we are trying to handle here.


> > +                     if (map_op->handle == -1) {
> 
> The other one I can understand, but this one I am baffled by. How
> would the xen_mc_flush trigger the handle to be set to -1?
> 
> Is the hypercall writting that value in the op.handle after it has completed?

Yes. The hypercall might return -1 in the handle in case of errors.


> Also, we might want to document somwhere -1 now that I think of it.
> It does not look like that is a value that is defined anywhere.

It is already documented in the hypercall interface in
include/xen/interface/grant_table.h


> > +                             printk(KERN_WARNING "m2p_remove_override: pfn %lx mfn %lx, "
> > +                                             "failed to modify kernel mappings", pfn, mfn);
> > +                             return -1;
> > +                     }
> > +
> > +                     mcs = xen_mc_entry(sizeof(struct gnttab_unmap_grant_ref));
> > +                     unmap_op = mcs.args;
> > +                     unmap_op->host_addr = map_op->host_addr;
> > +                     unmap_op->handle = map_op->handle;
> > +                     unmap_op->dev_bus_addr = 0;
> > +
> > +                     MULTI_grant_table_op(mcs.mc,
> > +                                     GNTTABOP_unmap_grant_ref, unmap_op, 1);
> > +
> > +                     xen_mc_issue(PARAVIRT_LAZY_MMU);
> > +
> > +                     set_pte_at(&init_mm, address, ptep,
> > +                                     pfn_pte(pfn, PAGE_KERNEL));
> > +                     __flush_tlb_single(address);
> > +                     map_op->host_addr = 0;
> 
> I am not sure that is neccesseray? When we are done, err, when we end
> up calling here that means the region has been unmapped or
> IOCTL_GNTDEV_UNMAP_GRANT_REF called right?

Yes.

> And when we do end up here, then the a whole bunch of those pages
> get free-ed? Don't they?

Right. However considering that map_op is a parameter passed by the
caller, it makes sense to set it back to a consistent state, no matter
if the caller is just going to free map_op right after.


> > +             }
> > +     } else
> > +             set_phys_to_machine(pfn, page->index);
> >
> >       return 0;
> >  }
> > @@ -758,7 +804,7 @@ struct page *m2p_find_override(unsigned long mfn)
> >       spin_lock_irqsave(&m2p_override_lock, flags);
> >
> >       list_for_each_entry(p, bucket, lru) {
> > -             if (p->private == mfn) {
> > +             if ((p->private & (~GRANT_FRAME_BIT)) == mfn) {
> >                       ret = p;
> >                       break;
> >               }
> > diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> > index 2330a9a..1540792 100644
> > --- a/drivers/block/xen-blkback/blkback.c
> > +++ b/drivers/block/xen-blkback/blkback.c
> > @@ -396,7 +396,7 @@ static int xen_blkbk_map(struct blkif_request *req,
> >                       continue;
> >
> >               ret = m2p_add_override(PFN_DOWN(map[i].dev_bus_addr),
> > -                     blkbk->pending_page(pending_req, i), false);
> > +                     blkbk->pending_page(pending_req, i), NULL);
> >               if (ret) {
> >                       pr_alert(DRV_PFX "Failed to install M2P override for %lx (ret: %d)\n",
> >                                (unsigned long)map[i].dev_bus_addr, ret);
> > diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
> > index 7b9b1d1..bfe1271 100644
> > --- a/drivers/xen/gntdev.c
> > +++ b/drivers/xen/gntdev.c
> > @@ -83,6 +83,7 @@ struct grant_map {
> >       struct ioctl_gntdev_grant_ref *grants;
> >       struct gnttab_map_grant_ref   *map_ops;
> >       struct gnttab_unmap_grant_ref *unmap_ops;
> > +     struct gnttab_map_grant_ref   *kmap_ops;
> >       struct page **pages;
> >  };
> >
> > @@ -116,10 +117,12 @@ static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
> >       add->grants    = kzalloc(sizeof(add->grants[0])    * count, GFP_KERNEL);
> >       add->map_ops   = kzalloc(sizeof(add->map_ops[0])   * count, GFP_KERNEL);
> >       add->unmap_ops = kzalloc(sizeof(add->unmap_ops[0]) * count, GFP_KERNEL);
> > +     add->kmap_ops  = kzalloc(sizeof(add->kmap_ops[0])  * count, GFP_KERNEL);
> >       add->pages     = kzalloc(sizeof(add->pages[0])     * count, GFP_KERNEL);
> >       if (NULL == add->grants    ||
> >           NULL == add->map_ops   ||
> >           NULL == add->unmap_ops ||
> > +         NULL == add->kmap_ops  ||
> >           NULL == add->pages)
> >               goto err;
> >
> > @@ -129,6 +132,7 @@ static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
> >       for (i = 0; i < count; i++) {
> >               add->map_ops[i].handle = -1;
> >               add->unmap_ops[i].handle = -1;
> > +             add->kmap_ops[i].handle = -1;
> >       }
> >
> >       add->index = 0;
> > @@ -142,6 +146,7 @@ err:
> >       kfree(add->grants);
> >       kfree(add->map_ops);
> >       kfree(add->unmap_ops);
> > +     kfree(add->kmap_ops);
> >       kfree(add);
> >       return NULL;
> >  }
> > @@ -243,10 +248,30 @@ static int map_grant_pages(struct grant_map *map)
> >                       gnttab_set_unmap_op(&map->unmap_ops[i], addr,
> >                               map->flags, -1 /* handle */);
> >               }
> > +     } else {
> > +             for (i = 0; i < map->count; i++) {
> > +                     unsigned level;
> > +                     unsigned long address = (unsigned long)
> > +                             pfn_to_kaddr(page_to_pfn(map->pages[i]));
> > +                     pte_t *ptep;
> > +                     u64 pte_maddr = 0;
> > +                     if (!PageHighMem(map->pages[i])) {
> > +                             ptep = lookup_address(address, &level);
> > +                             pte_maddr =
> > +                                     arbitrary_virt_to_machine(ptep).maddr;
> > +                     }
> 
> And it looks like having kmap->ops.host_addr = 0 is valid
> so that is good on the chance it is high map... but that begs
> the question whether we should the hypercall at all?
> As in, can we do anything with the grants if there is no PTE
> or MFN associated with it - just the handle? Does Xen do something
> special - like a relaxed "oh ok, we can handle that later on" ?

map->pages[i] cannot be highmap pages anymore, thanks to the previous
patch that changes alloc_xenballooned_pages.
We could even remove the if (!PageHighMem(map->pages[i])) at this
point...


> > +                     gnttab_set_map_op(&map->kmap_ops[i], pte_maddr,
> > +                             map->flags |
> > +                             GNTMAP_host_map |
> > +                             GNTMAP_contains_pte,
> > +                             map->grants[i].ref,
> > +                             map->grants[i].domid);
> > +             }
> 
> So, on startup.. (before this function is called) the
> find_grant_ptes is called which pretty much does the exact thing for
> each virtual address.  Except its flags are GNTMAP_application_map
> instead of GNTMAP_host_map.
> 
> It even uses the same type structure.. It fills out map_ops[i] one.
> 
> Can we use that instead of adding a new structure?

Do you mean moving this code inside find_grant_ptes?
I don't think that can be done because find_grant_ptes is called on a
range of virtual addresses while this is called on an array of struct
pages. It is true that the current implementation of
alloc_xenballooned_pages is going to return a consecutive set of pages
but it might not always be the case.
