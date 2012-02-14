Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab2BNF4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 00:56:20 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34493 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186Ab2BNF4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 00:56:18 -0500
Message-ID: <1329198932.2753.62.camel@work-vm>
Subject: Re: [PATCH 2/2] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and
 _NONVOLATILE flags
From: John Stultz <john.stultz@linaro.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>
Date: Mon, 13 Feb 2012 21:55:32 -0800
In-Reply-To: <20120214051659.GH14132@dastard>
References: <1328832993-23228-1-git-send-email-john.stultz@linaro.org>
	 <1328832993-23228-2-git-send-email-john.stultz@linaro.org>
	 <20120214051659.GH14132@dastard>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12021405-3534-0000-0000-0000059457F1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-14 at 16:16 +1100, Dave Chinner wrote:
> On Thu, Feb 09, 2012 at 04:16:33PM -0800, John Stultz wrote:
> > This patch provides new fadvise flags that can be used to mark
> > file pages as volatile, which will allow it to be discarded if the
> > kernel wants to reclaim memory.
> > 
> > This is useful for userspace to allocate things like caches, and lets
> > the kernel destructively (but safely) reclaim them when there's memory
> > pressure.
> .....
> > @@ -655,6 +656,8 @@ struct address_space {
> >  	spinlock_t		private_lock;	/* for use by the address_space */
> >  	struct list_head	private_list;	/* ditto */
> >  	struct address_space	*assoc_mapping;	/* ditto */
> > +	struct range_tree_node	*volatile_root;	/* volatile range list */
> > +	struct mutex		vlist_mutex;	/* protect volatile_list */
> >  } __attribute__((aligned(sizeof(long))));
> 
> So you're adding roughly 32 bytes to every cached inode in the
> system? This will increasing the memory footprint of the inode cache
> by 2-5% (depending on the filesystem). Almost no-one will be using
> this functionality on most inodes that are cached in the system, so
> that seems like a pretty bad trade-off to me...

Yea. Bloating the address_space is a concern I'm aware of, but for the
initial passes I left it to see where folks would rather I keep it.
Pushing the mutex into a range_tree_root structure or something could
cut this down, but I still suspect it won't be loved. Another idea would
be to manage the mapping -> range tree separately via something like a
hash.  Do you have any preferences or suggestions here?


> > +static int volatile_shrink(struct shrinker *ignored, struct shrink_control *sc)
> > +{
> > +	struct volatile_range *range, *next;
> > +	unsigned long nr_to_scan = sc->nr_to_scan;
> > +	const gfp_t gfp_mask = sc->gfp_mask;
> > +
> > +	/* We might recurse into filesystem code, so bail out if necessary */
> > +	if (nr_to_scan && !(gfp_mask & __GFP_FS))
> > +		return -1;
> > +	if (!nr_to_scan)
> > +		return lru_count;
> > +
> > +	mutex_lock(&volatile_lru_mutex);
> > +	list_for_each_entry_safe(range, next, &volatile_lru_list, lru) {
> > +		struct inode *inode = range->mapping->host;
> > +		loff_t start, end;
> > +
> > +
> > +		start = range->range_node.start * PAGE_SIZE;
> > +		end = (range->range_node.end + 1) * PAGE_SIZE - 1;
> > +
> > +		/*
> > +		 * XXX - calling vmtruncate_range from a shrinker causes
> > +		 * lockdep warnings. Revisit this!
> > +		 */
> > +		vmtruncate_range(inode, start, end);
> 
> That function vmtruncate_range, I don't think it does what you think
> it does.
> 
> Firstly, it's only implemented for shmfs/tmpfs, so this can't have
> been tested for caching files on any real filesystem. If it's only
> for shm/tmpfs, then the applications cwcan just as easily use their
> own memory for caching their volatile data...

Yep you're right, this started as being shm only, and has only been
tested on tmpfs mounts. In this verison, I had left the shm checks off
so that it could be possibly more generic, but I admittedly haven't
thought that through enough. 

> Secondly, vmtruncate_range() is actually a hole punching function,
> not a page cache invalidation function.  You should be using
> invalidate_inode_pages2_range() to invalidate and tear down the page
> cache. If you really want to punch holes in files, then you should
> be using the fallocate syscall with direct application control, not
> trying to hide it until memory pressure occurs via fadvise because
> hole punching requires memory for the transactions necessary to run
> extent freeing operations.

Thanks for the tip on invalidate_inode_pages2_range()! I'll look it over
and rework the patch using that.

Thanks so much for the review!
-john



