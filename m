Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591Ab1KVVcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 16:32:47 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:34787 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab1KVVcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 16:32:46 -0500
Message-ID: <1321997538.6445.90.camel@work-vm>
Subject: Re: [PATCH] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and
 _NONVOLATILE flags
From: John Stultz <john.stultz@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Robert Love <rlove@google.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mel@csn.ul.ie>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Eric Anholt <eric@anholt.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Tue, 22 Nov 2011 13:32:18 -0800
In-Reply-To: <20111122125209.7f70f3a7.akpm@linux-foundation.org>
References: <1321932788-18043-1-git-send-email-john.stultz@linaro.org>
	 <20111122125209.7f70f3a7.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11112221-4242-0000-0000-0000002D5A55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 12:52 -0800, Andrew Morton wrote:
> On Mon, 21 Nov 2011 19:33:08 -0800
> John Stultz <john.stultz@linaro.org> wrote:
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index e313022..4f15ade 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -10,6 +10,7 @@
> >  #include <linux/ioctl.h>
> >  #include <linux/blk_types.h>
> >  #include <linux/types.h>
> > +#include <linux/volatile.h>
> 
> volatile is a C keyword.  This is a bit confusing/misleading.

Yea. This struck me as well, but I didn't have a better name, so I went
ahead and sent it out. I'd be happy with any suggestions, or ideas for
where such code should live.

> >  /*
> >   * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
> > @@ -650,6 +651,7 @@ struct address_space {
> >  	spinlock_t		private_lock;	/* for use by the address_space */
> >  	struct list_head	private_list;	/* ditto */
> >  	struct address_space	*assoc_mapping;	/* ditto */
> > +	struct list_head	volatile_list;	/* volatile range list */
> 
> Comment should tell us what lock protects this.
> 
> It appers to be i_mmap_lock, which is weird.

Yea. I need a mutex connected to the address_space, so i_mmap_lock
looked possibly useful for this. It was really a last minute stab. 

Any suggestions? I can introduce my own, but Dave was already grumbling
about the list_head living on the address_space structure.


> >  } __attribute__((aligned(sizeof(long))));
> >  	/*
> >  	 * On most architectures that alignment is already the case; but
> > diff --git a/include/linux/volatile.h b/include/linux/volatile.h
> > new file mode 100644
> > index 0000000..11e8a3e
> > --- /dev/null
> > +++ b/include/linux/volatile.h
> > @@ -0,0 +1,34 @@
> > +#ifndef _LINUX_VOLATILE_H
> > +#define _LINUX_VOLATILE_H
> > +
> > +struct address_space;
> > +
> > +
> > +struct volatile_range {
> > +	/*
> > +	 * List is sorted, and no two ranges
> 
> sorted by pgoff_t, it appears.
> 
> > +	 * on the same list should overlap.
> > +	 */
> > +	struct list_head unpinned;
> 
> What's this do?  It appears to be the list anchored in
> address_space.volatile_list and protected by i_mmap_lock to maintain
> all these things.  "unpinned" is a strange name for such a thing.

Unpinned comes from the ashmem patch. Assuming folks think this basic
approach is worth continuing, I'll try to come up with a more sane name
for the next version.

> > +	pgoff_t start_page;
> > +	pgoff_t end_page;
> > +	unsigned int purged;
> 
> Some description here would be good.  What's it for, when is it set and
> cleared.
> 
> > +};
> > +
> > +static inline bool page_in_range(struct volatile_range *range,
> > +					pgoff_t page_index)
> > +{
> > +	return (range->start_page <= page_index) &&
> > +					(range->end_page >= page_index);
> > +}
> 
> "page_in_range" is too vague a name for this...

Agreed.

> > +extern long mapping_range_volatile(struct address_space *mapping,
> > +				pgoff_t start_index, pgoff_t end_index);
> > +extern long mapping_range_nonvolatile(struct address_space *mapping,
> > +				pgoff_t start_index, pgoff_t end_index);
> > +extern long mapping_range_isvolatile(struct address_space *mapping,
> > +				pgoff_t start_index, pgoff_t end_index);
> > +extern void mapping_clear_volatile_ranges(struct address_space *mapping);
> > +
> > +
> > +#endif /* _LINUX_VOLATILE_H */
> >
> > ...
> >
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -679,6 +679,20 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
> >  	index = page->index;
> >  	inode = mapping->host;
> >  	info = SHMEM_I(inode);
> > +
> > +	/* Check if page is in volatile range */
> > +	if (!list_empty(&mapping->volatile_list)) {
> > +		struct volatile_range *range, *next;
> > +		list_for_each_entry_safe(range, next, &mapping->volatile_list,
> > +					unpinned) {
> > +			if (page_in_range(range, index)) {
> > +				range->purged = 1;
> > +				unlock_page(page);
> > +				return 0;
> > +			}
> > +		}
> > +	}
> 
> That's very optimistic code :(
>
> We've handed users a way in which to consume arbitrarily vast amounts
> of kernel CPU time.  Putting a cond_resched() in there won't fix this.
> 
> Also, the volatile_range's are kmalloced so we have also given the user
> a way of quickly consuming unlimited amounts of kernel memory.  Not
> good.

Indeed. Besides the missing locking, this is a very good critique and
probably a very good argument for not-pushing such functionality too
deeply down into the VM.  Maybe the shrinker strategy used in the ashmem
patch is the better approach, as its a less critical path?


> > +/*
> > + * Allocates a volatile_range, and adds it to the address_space's
> > + * volatile list
> > + */
> > +static int volatile_range_alloc(struct volatile_range *prev_range,
> > +                               unsigned int purged,
> > +			       pgoff_t start_index, pgoff_t end_index)
> > +{
> > +       struct volatile_range *range;
> > +
> > +       range = kzalloc(sizeof(struct volatile_range), GFP_KERNEL);
> > +       if (!range)
> > +               return -ENOMEM;
> > +
> > +       range->start_page = start_index;
> > +       range->end_page = end_index;
> > +       range->purged = purged;
> > +
> > +       list_add_tail(&range->unpinned, &prev_range->unpinned);
> > +
> > +       return 0;
> > +}
> 
> Back in, ahem, 1999 I wrote a piece of tree code which I think does
> this.  Each node represents a span and the nodes are kept sorted in the
> tree and it does merging and splitting of nodes as ranges are added. 
> Removal and lookup don't appear to be implemented yet, but they're easy
> enough.  Pretty complex but everything is O(log(n)) and I think it
> could be made to work here.  
> 
> <rummage rummage>
> 
> OK, see attached.

Very cool!  Yea. Dave brought up that the list was fairly inefficient,
but I figured I'd get more feedback on the mechanism before spending too
much time optimizing the structure. I'll look at your mumbletree code
and see how it can be adapted. Other then apparently being a nod to the
"original neo-grunge/indie-rock band from Rochester", is there a story
to the name? :)

Again, I appreciate the feedback! Thanks so much!
-john

