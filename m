Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab0LPMAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 07:00:19 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44432 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab0LPMAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 07:00:13 -0500
To: Minchan Kim <minchan.kim@gmail.com>
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-reply-to: <AANLkTikXQmsgZ8Ea-GoQ4k2St6yCJj8Z3XthuBQ9u+EV@mail.gmail.com>
	(message from Minchan Kim on Thu, 16 Dec 2010 08:22:55 +0900)
Subject: Re: [PATCH] mm: add replace_page_cache_page() function
References: <E1PStc6-0006Cd-0Z@pomaz-ex.szeredi.hu> <AANLkTikXQmsgZ8Ea-GoQ4k2St6yCJj8Z3XthuBQ9u+EV@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1PTCV4-0007sR-SO@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 16 Dec 2010 12:59:58 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Dec 2010, Minchan Kim wrote:
> On Thu, Dec 16, 2010 at 12:49 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> >
> > This function basically does:
> >
> >     remove_from_page_cache(old);
> >     page_cache_release(old);
> >     add_to_page_cache_locked(new);
> >
> > Except it does this atomically, so there's no possibility for the
> > "add" to fail because of a race.
> >
> > This is used by fuse to move pages into the page cache.
> 
> Please write down why fuse need this new atomic function in description.

Okay.

> >
> > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> > ---
> >  fs/fuse/dev.c           |   10 ++++------
> >  include/linux/pagemap.h |    1 +
> >  mm/filemap.c            |   41 +++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 46 insertions(+), 6 deletions(-)
> >
> > Index: linux-2.6/mm/filemap.c
> > ===================================================================
> > --- linux-2.6.orig/mm/filemap.c 2010-12-15 16:39:55.000000000 +0100
> > +++ linux-2.6/mm/filemap.c      2010-12-15 16:41:24.000000000 +0100
> > @@ -389,6 +389,47 @@ int filemap_write_and_wait_range(struct
> >  }
> >  EXPORT_SYMBOL(filemap_write_and_wait_range);
> >
> 
> This function is exported.
> Please, add function description

Right, will do.

> > +int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask)
> > +{
> > +       int error;
> > +
> > +       VM_BUG_ON(!PageLocked(old));
> > +       VM_BUG_ON(!PageLocked(new));
> > +       VM_BUG_ON(new->mapping);
> > +
> > +       error = mem_cgroup_cache_charge(new, current->mm,
> > +                                       gfp_mask & GFP_RECLAIM_MASK);
> > +       if (error)
> > +               goto out;
> > +
> > +       error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
> > +       if (error == 0) {
> > +               struct address_space *mapping = old->mapping;
> > +               pgoff_t offset = old->index;
> > +
> > +               page_cache_get(new);
> > +               new->mapping = mapping;
> > +               new->index = offset;
> > +
> > +               spin_lock_irq(&mapping->tree_lock);
> > +               __remove_from_page_cache(old);
> > +               error = radix_tree_insert(&mapping->page_tree, offset, new);
> > +               BUG_ON(error);
> > +               mapping->nrpages++;
> > +               __inc_zone_page_state(new, NR_FILE_PAGES);
> > +               if (PageSwapBacked(new))
> > +                       __inc_zone_page_state(new, NR_SHMEM);
> > +               spin_unlock_irq(&mapping->tree_lock);
> > +               radix_tree_preload_end();
> > +               mem_cgroup_uncharge_cache_page(old);
> > +               page_cache_release(old);
> 
> Why do you release reference of old?

That's the page cache reference we release.  Just like we acquire the
page cache reference for "new" above.

I suspect it's historic that page_cache_release() doesn't drop the
page cache ref.

Thanks for the review.

Miklos

> > +       } else
> > +               mem_cgroup_uncharge_cache_page(new);
> > +out:
> > +       return error;
> > +}
> > +EXPORT_SYMBOL_GPL(replace_page_cache_page);
> > +
> >  /**
> >  * add_to_page_cache_locked - add a locked page to the pagecache
> >  * @page:      page to add
> > Index: linux-2.6/include/linux/pagemap.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/pagemap.h      2010-12-15 16:39:39.000000000 +0100
> > +++ linux-2.6/include/linux/pagemap.h   2010-12-15 16:41:24.000000000 +0100
> > @@ -457,6 +457,7 @@ int add_to_page_cache_lru(struct page *p
> >                                pgoff_t index, gfp_t gfp_mask);
> >  extern void remove_from_page_cache(struct page *page);
> >  extern void __remove_from_page_cache(struct page *page);
> > +int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask);
> >
> >  /*
> >  * Like add_to_page_cache_locked, but used to add newly allocated pages:
> > Index: linux-2.6/fs/fuse/dev.c
> > ===================================================================
> > --- linux-2.6.orig/fs/fuse/dev.c        2010-12-15 16:39:39.000000000 +0100
> > +++ linux-2.6/fs/fuse/dev.c     2010-12-15 16:41:24.000000000 +0100
> > @@ -729,14 +729,12 @@ static int fuse_try_move_page(struct fus
> >        if (WARN_ON(PageMlocked(oldpage)))
> >                goto out_fallback_unlock;
> >
> > -       remove_from_page_cache(oldpage);
> > -       page_cache_release(oldpage);
> > -
> > -       err = add_to_page_cache_locked(newpage, mapping, index, GFP_KERNEL);
> > +       err = replace_page_cache_page(oldpage, newpage, GFP_KERNEL);
> >        if (err) {
> > -               printk(KERN_WARNING "fuse_try_move_page: failed to add page");
> > -               goto out_fallback_unlock;
> > +               unlock_page(newpage);
> > +               return err;
> >        }
> > +
> >        page_cache_get(newpage);
> >
> >        if (!(buf->flags & PIPE_BUF_FLAG_LRU))
> >
> > --
> > To unsubscribe, send a message with 'unsubscribe linux-mm' in
> > the body to majordomo@kvack.org.  For more info on Linux MM,
> > see: http://www.linux-mm.org/ .
> > Fight unfair telecom policy in Canada: sign http://dissolvethecrtc.ca/
> > Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> >
> 
> 
> 
> -- 
> Kind regards,
> Minchan Kim
> 
