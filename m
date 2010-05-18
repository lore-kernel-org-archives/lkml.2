Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab0ERGhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 02:37:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58355 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756873Ab0ERGgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 02:36:54 -0400
Date: Tue, 18 May 2010 16:36:47 +1000
From: Nick Piggin <npiggin@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] new ->perform_write fop
Message-ID: <20100518063647.GD2516@laptop>
References: <20100512212403.GE3597@localhost.localdomain>
 <20100513013926.GD27011@dhcp231-156.rdu.redhat.com>
 <20100514010042.GI13617@dastard>
 <20100514033057.GL27011@dhcp231-156.rdu.redhat.com>
 <20100514064145.GJ13617@dastard>
 <20100514072219.GC4706@laptop>
 <20100514083821.GL13617@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100514083821.GL13617@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 06:38:21PM +1000, Dave Chinner wrote:
> On Fri, May 14, 2010 at 05:22:19PM +1000, Nick Piggin wrote:
> > On Fri, May 14, 2010 at 04:41:45PM +1000, Dave Chinner wrote:
> > > On Thu, May 13, 2010 at 11:30:57PM -0400, Josef Bacik wrote:
> > > > So this is what I had envisioned, we make write_begin take a nr_pages pointer
> > > > and tell it how much data we have to write, then in the filesystem we allocate
> > > > as many pages as we feel like, idealy something like
> > > > 
> > > > min(number of pages we need for the write, some arbitrary limit for security)
> > > 
> > > Actually, i was thinking that the RESERVE call determines the size
> > > of the chunk (in the order of 1-4MB maximum). IOWs, we pass in the
> > > start offset of the write, the entire length remaining, and the
> > > RESERVE call determines how much it will allow in one loop.
> > > 
> > > 	written = 0;
> > > 	while (bytes_remaining > 0) {
> > > 		chunklen = ->allocate(off, bytes_remaining, RESERVE);
> > > 		write_begin(&pages, off, chunklen);
> > > 		copied = copy_pages(&pages, iov_iter, chunklen);
> > > 		.....
> > > 		bytes_remaining -= copied;
> > > 		off += copied;
> > > 		written += copied;
> > > 	}
> > 
> > How much benefit are you expecting to get?
> 
> If the max chunk size is 4MB, then three orders of magnitudes fewer
> allocation calls for x86_64 (i.e. one instead of 1024).  For
> filesystems with significant allocation overhead (like gaining
> cluster locks in gfs2), this will be a *massive* win.
> 
> > I have no problems with
> > non-pagecache block allocation/freeing APIs to get the most out of
> > amortising expensive locking or tree manipulations, but I don't
> > know if it is a good idea to pin a big chunk of pagecache like that.
> > I'd say just do the per-page manipulations like we currently do.
> 
> Can you expand on this?

Well you could do a large span block allocation at the beginning,
and then dirty the pagecache one by one like we do right now.

The only reason to do operations on multiple pages at once is if
we need to lock them all. Now the fs might well have that requirement
(if it is not using i_mutex for block (de)allocation serialisation),
but I don't think generic code needs to be doing that.


> > > > and then we allocate all those pages.  Then you can pass them into
> > > > block_write_begin, which will walk the pages, allocating buffer heads and
> > > > allocating the space as needed.
> > > 
> > > Close - except that I'd like like to move the block allocation out of
> > > ->write_begin until after the copy into the pages has completed.
> > > Hence write_begin only deals with populating the page cache and
> > > anything filesystem specific like locking or allocating/populating
> > > per-page structures like bufferheads.  i.e. ->write_begin does not
> > > do anything that cannot be undone easily if the copy fails.
> > 
> > Hmm, not so sure. You run into other problems.
> > 
> > Write to a hole? Then you have to clear page uptodate and unmap
> > any potential mmaps on it before the copy to pagecache, in case
> > the allocation fails (otherwise you have exposed inconsistent
> > state to userspace).
> 
> Good call. I think that checking page_mapped() on each page as they
> are grabbed and locked, and if any are mapped call
> unmap_mapping_range() on them will work. New faults will serialise
> on the page locks and because we hold the page lock across the
> entire operation,

That is supposed to be enough to prevent concurrent faults setting
up the mapping again (which is how the fault vs truncate race was
fixed). So yes that would be fine (so long as the fs DTRT in its
fault API of course).


> I don't think we need to clear the uptodate flag
> unless we fail the write.

read(2) is performed without page lock though, so it could equally
expose transient data that way.

 
> > Write to a hole, then to a non-hole? Then your write to the non
> > hole pagecache cannot be recovered in case the block allocation
> > for the hole fails and we need to return a short write.
> 
> The pages covering non-holes are locked, so nobody else can access
> them. We could simply invalidate them so the next access would force
> a re-read from disk.  The problem I see with this, though, is
> multiple partial overwrites of the allocated block - we could lose
> changes invalidating it.
> 
> I think the simplest way to deal with it is to ensure that
> ->allocate(RESERVE) is not allowed to return ranges that span
> allocated and unallocated regions. i.e. it can return an allocated
> region or a hole, but not a region that combines both. The worst
> case is that we fall back to current behaviour (an allocation call
> per block), but for the case we're trying to optimise (large writes
> into large holes) we'd still see the benefit of fewer allocation
> calls.  FWIW, I think this simplifies error handling as well (see
> below).

Possibly is the right way to go. But why is error handling of block
allocation the hard part? Probably I look at it from the other side
of the equation, but publishing modifications to the pagecache seems
much harder to recover from than block allocations.

I don't see what changes when you go to multi-page allocation spans.
Can you explain?


> > > > Now since we're coming into write_begin with "we want to write X bytes" we can
> > > > go ahead and do the enospc checks for X bytes, and then if we are good to go,
> > > > chances are we won't fail.
> > > 
> > > Well, the "RESERVE" callout I proposed should mean that the
> > > allocation that follows the copy should never fail with ENOSPC. i.e.
> > > if there isn't space, the RESERVE call will fail with ENOSPC, not
> > > the actual ALLOCATE call that occurs after the data is copied.
> > > 
> > > Basically I was thinking that in the XFS case, RESERVE would scan the
> > > range for holes, and reserve all blocks needed to fill all the holes
> > > in the range. Then the ALLOCATE call would mark them all delalloc.
> > > The space reservation and delalloc is done in a single call right
> > > now, but splitting them is not hard...
> > > 
> > > > Except if we're overwriting a holey section of the file, we're going to be
> > > > screwed in both your way and my way.  My way probably would be the most likely
> > > > to fail, since we could fail to do the copy_from_user, but hopefully the segment
> > > > checks and doing the fault_in_readable before all of this would keep those
> > > > problems to a minimum.
> > > 
> > > fault_in_readable() only faults the first page of the first iov
> > > passed in. It can still fail on any other page the iov points to.
> > > And even then, fault_in_readable() does not pin the page it faulted
> > > in memory, so even that can get recycled before we start the copy
> > > and we'd still get EFAULT.
> > > 
> > > > In your case the only failure point is in the allocate step.  If we fail on down
> > > > the line after we've done some hole filling, we'll be hard pressed to go back
> > > > and free up those blocks.  Is that what you are talking about, having the
> > > > allocate(UNRESERVE) thing being able to go back and figure out what should have
> > > > been holes needs to be holes again?
> > > 
> > > Yeah, that's kind of what I was thinking of. After a bit more
> > > thought, if the allocation only covers part of the range (for
> > > whatever reason), we can still allow that allocated part of the
> > > write to complete succesfully, and the UNRESERVE call simply returns
> > > the unused part of the space reservation. This would be a partial
> > > write and be much simpler to deal with than punching out the
> > > allocations that succeeded.
> > 
> > Do we really need to restore holes inside i_size in error cases?
> 
> No, we don't. That's what I was trying to say - holes that were

OK good.

> allocated are full of good data, so we only need to deal with the
> holes that didn't get allocated. The range of the write that failed
> is only stale in memory now, so we can just invalidate pages in the
> range that is considered failed.

Well invalidate isn't a good way to do this IMO. It is very hairy to
put data tentatively into PageUptodate pagecache and then try to recover
afterwards.

Basically, once pagecache is marked uptodate, I don't think we should
ever put maybe-invalid data into it -- the way to do it is to invalidate
that page and put a *new* page in there.

Why? Because user mappings are just one problem, but once you had a
user mapping, you can have been subject to get_user_pages, so it could
be in the middle of a DMA operation or something.

 
> If we limit RESERVE to return ranges of a single type of block, then
> this whole cleanup problem will also go away - it's back to a simple
> succeed or fail-and-rollback state per execution of the loop, and
> partial writes are those that have made at least one successful pass
> of the loop.
> 
> > Current code does not. It just leaves the blocks allocated and
> > zeroes them.
> 
> Yup, error handling is easy when you're only dealing with one page
> at a time. ;)

Humour me; why? :)

