Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265Ab1KVUwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 15:52:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab1KVUwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 15:52:11 -0500
Date: Tue, 22 Nov 2011 12:52:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Robert Love <rlove@google.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mel@csn.ul.ie>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Eric Anholt <eric@anholt.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and
 _NONVOLATILE flags
Message-Id: <20111122125209.7f70f3a7.akpm@linux-foundation.org>
In-Reply-To: <1321932788-18043-1-git-send-email-john.stultz@linaro.org>
References: <1321932788-18043-1-git-send-email-john.stultz@linaro.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Tue__22_Nov_2011_12_52_09_-0800_uK78b52sesJjsgbF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Tue__22_Nov_2011_12_52_09_-0800_uK78b52sesJjsgbF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 21 Nov 2011 19:33:08 -0800
John Stultz <john.stultz@linaro.org> wrote:

> This patch provides new fadvise flags that can be used to mark
> file pages as volatile, which will allow it to be discarded if the
> kernel wants to reclaim memory.
> 
> This is useful for userspace to allocate things like caches, and lets
> the kernel destructively (but safely) reclaim them when there's memory
> pressure.
> 
> Right now, we can simply throw away pages if they are clean (backed
> by a current on-disk copy).  That only happens for anonymous/tmpfs/shmfs
> pages when they're swapped out.  This patch lets userspace select
> dirty pages which can be simply thrown away instead of writing them
> to disk first.  See the mm/shmem.c for this bit of code.  It's
> different from FADV_DONTNEED since the pages are not immediately
> discarded; they are only discarded under pressure.
> 
> This is very much influenced by the Android Ashmem interface by
> Robert Love so credits to him and the Android developers.
> In many cases the code & logic come directly from the ashmem patch.
> The intent of this patch is to allow for ashmem-like behavior, but
> embeds the idea a little deeper into the VM code, instead of isolating
> it into a specific driver.
> 
> I'm very much a newbie at the VM code, so At this point, I just want
> to try to get some input on the patch, so if you have another idea
> for using something other then fadvise, or other thoughts on how the
> volatile ranges are stored, I'd be really interested in hearing them.
> So let me know if you have any comments for feedback!
> 
> Also many thanks to Dave Hansen who helped design and develop the
> initial version of this patch, and has provided continued review and
> mentoring for me in the VM code.

I'm interestedly watching the design/use-case discussion.  Meanwhile,
some comments on the implementation.

>
> ...
>
> +#define POSIX_FADV_VOLATILE	8  /* _can_ toss, but don't toss now */
> +#define POSIX_FADV_NONVOLATILE	9  /* Remove VOLATILE flag */
> +#define POSIX_FADV_ISVOLATILE	10 /* Returns volatile flag for region */

linux-man@vger.kernel.org will want to be told all about these at some
stage.

> +
> +
>  #endif	/* FADVISE_H_INCLUDED */
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index e313022..4f15ade 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -10,6 +10,7 @@
>  #include <linux/ioctl.h>
>  #include <linux/blk_types.h>
>  #include <linux/types.h>
> +#include <linux/volatile.h>

volatile is a C keyword.  This is a bit confusing/misleading.

>  /*
>   * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
> @@ -650,6 +651,7 @@ struct address_space {
>  	spinlock_t		private_lock;	/* for use by the address_space */
>  	struct list_head	private_list;	/* ditto */
>  	struct address_space	*assoc_mapping;	/* ditto */
> +	struct list_head	volatile_list;	/* volatile range list */

Comment should tell us what lock protects this.

It appers to be i_mmap_lock, which is weird.

>  } __attribute__((aligned(sizeof(long))));
>  	/*
>  	 * On most architectures that alignment is already the case; but
> diff --git a/include/linux/volatile.h b/include/linux/volatile.h
> new file mode 100644
> index 0000000..11e8a3e
> --- /dev/null
> +++ b/include/linux/volatile.h
> @@ -0,0 +1,34 @@
> +#ifndef _LINUX_VOLATILE_H
> +#define _LINUX_VOLATILE_H
> +
> +struct address_space;
> +
> +
> +struct volatile_range {
> +	/*
> +	 * List is sorted, and no two ranges

sorted by pgoff_t, it appears.

> +	 * on the same list should overlap.
> +	 */
> +	struct list_head unpinned;

What's this do?  It appears to be the list anchored in
address_space.volatile_list and protected by i_mmap_lock to maintain
all these things.  "unpinned" is a strange name for such a thing.

> +	pgoff_t start_page;
> +	pgoff_t end_page;
> +	unsigned int purged;

Some description here would be good.  What's it for, when is it set and
cleared.

> +};
> +
> +static inline bool page_in_range(struct volatile_range *range,
> +					pgoff_t page_index)
> +{
> +	return (range->start_page <= page_index) &&
> +					(range->end_page >= page_index);
> +}

"page_in_range" is too vague a name for this...

> +extern long mapping_range_volatile(struct address_space *mapping,
> +				pgoff_t start_index, pgoff_t end_index);
> +extern long mapping_range_nonvolatile(struct address_space *mapping,
> +				pgoff_t start_index, pgoff_t end_index);
> +extern long mapping_range_isvolatile(struct address_space *mapping,
> +				pgoff_t start_index, pgoff_t end_index);
> +extern void mapping_clear_volatile_ranges(struct address_space *mapping);
> +
> +
> +#endif /* _LINUX_VOLATILE_H */
>
> ...
>
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -679,6 +679,20 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
>  	index = page->index;
>  	inode = mapping->host;
>  	info = SHMEM_I(inode);
> +
> +	/* Check if page is in volatile range */
> +	if (!list_empty(&mapping->volatile_list)) {
> +		struct volatile_range *range, *next;
> +		list_for_each_entry_safe(range, next, &mapping->volatile_list,
> +					unpinned) {
> +			if (page_in_range(range, index)) {
> +				range->purged = 1;
> +				unlock_page(page);
> +				return 0;
> +			}
> +		}
> +	}

That's very optimistic code :(

We've handed users a way in which to consume arbitrarily vast amounts
of kernel CPU time.  Putting a cond_resched() in there won't fix this.

Also, the volatile_range's are kmalloced so we have also given the user
a way of quickly consuming unlimited amounts of kernel memory.  Not
good.

>
> ...
>
> +/*
> + * Allocates a volatile_range, and adds it to the address_space's
> + * volatile list
> + */
> +static int volatile_range_alloc(struct volatile_range *prev_range,
> +                               unsigned int purged,
> +			       pgoff_t start_index, pgoff_t end_index)
> +{
> +       struct volatile_range *range;
> +
> +       range = kzalloc(sizeof(struct volatile_range), GFP_KERNEL);
> +       if (!range)
> +               return -ENOMEM;
> +
> +       range->start_page = start_index;
> +       range->end_page = end_index;
> +       range->purged = purged;
> +
> +       list_add_tail(&range->unpinned, &prev_range->unpinned);
> +
> +       return 0;
> +}

Back in, ahem, 1999 I wrote a piece of tree code which I think does
this.  Each node represents a span and the nodes are kept sorted in the
tree and it does merging and splitting of nodes as ranges are added. 
Removal and lookup don't appear to be implemented yet, but they're easy
enough.  Pretty complex but everything is O(log(n)) and I think it
could be made to work here.  

<rummage rummage>

OK, see attached.



Also, do you know what this code is like?  Posix and BSD file locking. 
It has the same requirement to maintain state about arbitrary spans of
a single file.

The locking code is an utter pig and has well known (?) O(N^2) and even
O(N^3) failure modes.  But don't let that deter you ;) We should
strenuously avoid duplicating such a similar thing.


--Multipart=_Tue__22_Nov_2011_12_52_09_-0800_uK78b52sesJjsgbF
Content-Type: application/octet-stream;
 name="mumbletree.tar.gz"
Content-Disposition: attachment;
 filename="mumbletree.tar.gz"
Content-Transfer-Encoding: base64

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
eJJIAKAAAA==

--Multipart=_Tue__22_Nov_2011_12_52_09_-0800_uK78b52sesJjsgbF--
