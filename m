Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab0LPWFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 17:05:06 -0500
Received: from mail-px0-f179.google.com ([209.85.212.179]:49593 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab0LPWFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 17:05:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gnYnXnH9Y2hTK1gRBo/lJ0t5M1Jm0DR5nRkXoyOEpzEBNAC4C1XSc9c4rjPmK0jsx2
         hxMxXRC1niuN3WIjHvMRkcmNkTPOlje42AjVRt0FS/WAp/CsaqcuexBuodShGr1hsz2i
         ftqq8z2VThd2wmgIAY09pOehXaI77OnG3l1S8=
Date: Fri, 17 Dec 2010 07:04:57 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: add replace_page_cache_page() function
Message-ID: <20101216220457.GA3450@barrios-desktop>
References: <E1PStc6-0006Cd-0Z@pomaz-ex.szeredi.hu>
 <AANLkTikXQmsgZ8Ea-GoQ4k2St6yCJj8Z3XthuBQ9u+EV@mail.gmail.com>
 <E1PTCV4-0007sR-SO@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1PTCV4-0007sR-SO@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 12:59:58PM +0100, Miklos Szeredi wrote:
> On Thu, 16 Dec 2010, Minchan Kim wrote:
> > > +int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask)
> > > +{
> > > + ?? ?? ?? int error;
> > > +
> > > + ?? ?? ?? VM_BUG_ON(!PageLocked(old));
> > > + ?? ?? ?? VM_BUG_ON(!PageLocked(new));
> > > + ?? ?? ?? VM_BUG_ON(new->mapping);
> > > +
> > > + ?? ?? ?? error = mem_cgroup_cache_charge(new, current->mm,
> > > + ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? gfp_mask & GFP_RECLAIM_MASK);
> > > + ?? ?? ?? if (error)
> > > + ?? ?? ?? ?? ?? ?? ?? goto out;
> > > +
> > > + ?? ?? ?? error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
> > > + ?? ?? ?? if (error == 0) {
> > > + ?? ?? ?? ?? ?? ?? ?? struct address_space *mapping = old->mapping;
> > > + ?? ?? ?? ?? ?? ?? ?? pgoff_t offset = old->index;
> > > +
> > > + ?? ?? ?? ?? ?? ?? ?? page_cache_get(new);
> > > + ?? ?? ?? ?? ?? ?? ?? new->mapping = mapping;
> > > + ?? ?? ?? ?? ?? ?? ?? new->index = offset;
> > > +
> > > + ?? ?? ?? ?? ?? ?? ?? spin_lock_irq(&mapping->tree_lock);
> > > + ?? ?? ?? ?? ?? ?? ?? __remove_from_page_cache(old);
> > > + ?? ?? ?? ?? ?? ?? ?? error = radix_tree_insert(&mapping->page_tree, offset, new);
> > > + ?? ?? ?? ?? ?? ?? ?? BUG_ON(error);
> > > + ?? ?? ?? ?? ?? ?? ?? mapping->nrpages++;
> > > + ?? ?? ?? ?? ?? ?? ?? __inc_zone_page_state(new, NR_FILE_PAGES);
> > > + ?? ?? ?? ?? ?? ?? ?? if (PageSwapBacked(new))
> > > + ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? __inc_zone_page_state(new, NR_SHMEM);
> > > + ?? ?? ?? ?? ?? ?? ?? spin_unlock_irq(&mapping->tree_lock);
> > > + ?? ?? ?? ?? ?? ?? ?? radix_tree_preload_end();
> > > + ?? ?? ?? ?? ?? ?? ?? mem_cgroup_uncharge_cache_page(old);
> > > + ?? ?? ?? ?? ?? ?? ?? page_cache_release(old);
> > 
> > Why do you release reference of old?
> 
> That's the page cache reference we release.  Just like we acquire the
> page cache reference for "new" above.

I mean current page cache handling semantic and page reference counting semantic
is separeated. For example, remove_from_page_cache doesn't drop the reference of page.
That's because we need more works after drop the page from page cache.
Look at shmem_writepage, truncate_complete_page.

You makes the general API and caller might need works before the old page 
is free. So how about this?

err = replace_page_cache_page(oldpage, newpage, GFP_KERNEL);
if (err) {
        ...
}

page_cache_release(oldpage); /* drop ref of page cache */


> 
> I suspect it's historic that page_cache_release() doesn't drop the
> page cache ref.

Sorry I can't understand your words.

> 
> Thanks for the review.
> 
> Miklos
-- 
Kind regards,
Minchan Kim
