Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab0ENHW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 03:22:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42566 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756765Ab0ENHWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 03:22:25 -0400
Date: Fri, 14 May 2010 17:22:19 +1000
From: Nick Piggin <npiggin@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] new ->perform_write fop
Message-ID: <20100514072219.GC4706@laptop>
References: <20100512212403.GE3597@localhost.localdomain>
 <20100513013926.GD27011@dhcp231-156.rdu.redhat.com>
 <20100514010042.GI13617@dastard>
 <20100514033057.GL27011@dhcp231-156.rdu.redhat.com>
 <20100514064145.GJ13617@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100514064145.GJ13617@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 04:41:45PM +1000, Dave Chinner wrote:
> On Thu, May 13, 2010 at 11:30:57PM -0400, Josef Bacik wrote:
> > So this is what I had envisioned, we make write_begin take a nr_pages pointer
> > and tell it how much data we have to write, then in the filesystem we allocate
> > as many pages as we feel like, idealy something like
> > 
> > min(number of pages we need for the write, some arbitrary limit for security)
> 
> Actually, i was thinking that the RESERVE call determines the size
> of the chunk (in the order of 1-4MB maximum). IOWs, we pass in the
> start offset of the write, the entire length remaining, and the
> RESERVE call determines how much it will allow in one loop.
> 
> 	written = 0;
> 	while (bytes_remaining > 0) {
> 		chunklen = ->allocate(off, bytes_remaining, RESERVE);
> 		write_begin(&pages, off, chunklen);
> 		copied = copy_pages(&pages, iov_iter, chunklen);
> 		.....
> 		bytes_remaining -= copied;
> 		off += copied;
> 		written += copied;
> 	}

How much benefit are you expecting to get? I have no problems with
non-pagecache block allocation/freeing APIs to get the most out of
amortising expensive locking or tree manipulations, but I don't
know if it is a good idea to pin a big chunk of pagecache like that.

I'd say just do the per-page manipulations like we currently do.


> > and then we allocate all those pages.  Then you can pass them into
> > block_write_begin, which will walk the pages, allocating buffer heads and
> > allocating the space as needed.
> 
> Close - except that I'd like like to move the block allocation out of
> ->write_begin until after the copy into the pages has completed.
> Hence write_begin only deals with populating the page cache and
> anything filesystem specific like locking or allocating/populating
> per-page structures like bufferheads.  i.e. ->write_begin does not
> do anything that cannot be undone easily if the copy fails.

Hmm, not so sure. You run into other problems.

Write to a hole? Then you have to clear page uptodate and unmap
any potential mmaps on it before the copy to pagecache, in case
the allocation fails (otherwise you have exposed inconsistent
state to userspace).

Write to a hole, then to a non-hole? Then your write to the non
hole pagecache cannot be recovered in case the block allocation
for the hole fails and we need to return a short write.


> > Now since we're coming into write_begin with "we want to write X bytes" we can
> > go ahead and do the enospc checks for X bytes, and then if we are good to go,
> > chances are we won't fail.
> 
> Well, the "RESERVE" callout I proposed should mean that the
> allocation that follows the copy should never fail with ENOSPC. i.e.
> if there isn't space, the RESERVE call will fail with ENOSPC, not
> the actual ALLOCATE call that occurs after the data is copied.
> 
> Basically I was thinking that in the XFS case, RESERVE would scan the
> range for holes, and reserve all blocks needed to fill all the holes
> in the range. Then the ALLOCATE call would mark them all delalloc.
> The space reservation and delalloc is done in a single call right
> now, but splitting them is not hard...
> 
> > Except if we're overwriting a holey section of the file, we're going to be
> > screwed in both your way and my way.  My way probably would be the most likely
> > to fail, since we could fail to do the copy_from_user, but hopefully the segment
> > checks and doing the fault_in_readable before all of this would keep those
> > problems to a minimum.
> 
> fault_in_readable() only faults the first page of the first iov
> passed in. It can still fail on any other page the iov points to.
> And even then, fault_in_readable() does not pin the page it faulted
> in memory, so even that can get recycled before we start the copy
> and we'd still get EFAULT.
> 
> > In your case the only failure point is in the allocate step.  If we fail on down
> > the line after we've done some hole filling, we'll be hard pressed to go back
> > and free up those blocks.  Is that what you are talking about, having the
> > allocate(UNRESERVE) thing being able to go back and figure out what should have
> > been holes needs to be holes again?
> 
> Yeah, that's kind of what I was thinking of. After a bit more
> thought, if the allocation only covers part of the range (for
> whatever reason), we can still allow that allocated part of the
> write to complete succesfully, and the UNRESERVE call simply returns
> the unused part of the space reservation. This would be a partial
> write and be much simpler to deal with than punching out the
> allocations that succeeded.

Do we really need to restore holes inside i_size in error cases?
Current code does not. It just leaves the blocks allocated and
zeroes them.

 
