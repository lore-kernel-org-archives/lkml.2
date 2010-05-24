Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab0EXGz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 02:55:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:37339 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654Ab0EXGzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 02:55:25 -0400
Date: Mon, 24 May 2010 16:55:19 +1000
From: Nick Piggin <npiggin@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Josef Bacik <josef@redhat.com>,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] new ->perform_write fop
Message-ID: <20100524065519.GT2516@laptop>
References: <20100513013926.GD27011@dhcp231-156.rdu.redhat.com>
 <20100514010042.GI13617@dastard>
 <20100514033057.GL27011@dhcp231-156.rdu.redhat.com>
 <20100514064145.GJ13617@dastard>
 <20100514072219.GC4706@laptop>
 <20100521151518.GA12752@infradead.org>
 <20100522023102.GP2516@laptop>
 <20100522083703.GA12087@dastard>
 <20100524030943.GQ2516@laptop>
 <20100524055329.GD12087@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100524055329.GD12087@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 03:53:29PM +1000, Dave Chinner wrote:
> On Mon, May 24, 2010 at 01:09:43PM +1000, Nick Piggin wrote:
> > On Sat, May 22, 2010 at 06:37:03PM +1000, Dave Chinner wrote:
> > > On Sat, May 22, 2010 at 12:31:02PM +1000, Nick Piggin wrote:
> > > > On Fri, May 21, 2010 at 11:15:18AM -0400, Christoph Hellwig wrote:
> > > > > Nick, what exactly is the problem with the reserve + allocate design?
> > > > > 
> > > > > In a delalloc filesystem (which is all those that will care about high
> > > > > performance large writes) the write path fundamentally consists of those
> > > > > two operations.  Getting rid of the get_blocks mess and replacing it
> > > > > with a dedicated operations vector will simplify things a lot.
> > > > 
> > > > Nothing wrong with it, I think it's a fine idea (although you may still
> > > > need a per-bh call to connect the fs metadata to each page).
> > > > 
> > > > I just much prefer to have operations after the copy not able to fail,
> > > > otherwise you get into all those pagecache corner cases.
> > > > 
> > > > BTW. when you say reserve + allocate, this is in the page-dirty path,
> > > > right? I thought delalloc filesystems tend to do the actual allocation
> > > > in the page-cleaning path? Or am I confused?
> > > 
> > > See my reply to Jan - delayed allocate has two parts to it - space
> > > reservation (accounting for ENOSPC) and recording of the delalloc extents
> > > (allocate). This is separate to the writeback path where we convert
> > > delalloc extents to real extents....
> > 
> > Yes I saw that. I'm sure we'll want clearer terminology in the core
> > code. But I don't quite know why you need to do it in 2 parts
> > (reserve, then "allocate").
> 
> Because reserve/allocate are the two steps that allocation is
> generally broken down into, even in filesystems that don't do
> delayed allocation. That's because....
> 
> > Surely even reservation failures are
> > very rare
> 
> ... ENOSPC and EDQUOT are not at all rare, and they are generated
> during the reservation stage. i.e. before any real allocation or

I meant "rare" as-in not critical for performance. Not that they don't
have to be handled properly.


> state changes are made. Just about every filesystem does this
> because failing half way through an allocation not being able to
> allocate a block due to ENOSPC or EDQUOT is pretty much impossible
> to undo reliably in most filesystems.
> 
> > , and obviously the error handling is required, so why not
> > just do a single call?
> 
> Because if we fail after the allocation then ensuring we handle the
> error *correctly* and *without further failures* is *fucking hard*.

I don't think you really answered my question. Let me put it in concrete
terms. In your proposal, why not just do the reserve+allocate *after*
the pagecache copy? What does the "reserve" part add?

> 
> IMO, the fundamental issue with using hole punching or direct IO
> from the zero page to handle errors is that they are complex enough
> that there is *no guarantee that they will succeed*. e.g. Both can
> get ENOSPC/EDQUOT because they may end up with metadata allocation
> requirements above and beyond what was originally reserved. If the
> error handling fails to handle the error, then where do we go from
> there?

There are already fundamental issues that seems like they are not
handled properly if your filesystem may allocate uninitialized blocks
over holes for writeback cache without somehow marking them as
uninitialized.

If you get a power failure or IO error before the pagecache can be
written out, you're left with uninitialized data there, aren't you?
Simple buffer head based filesystems are already subject to this.


> In comparison, undoing a reservation is simple - maybe incrementing
> a couple of counters - and is effectively guaranteed never to fail.
> This is a good characteristic to have in an error handling
> function...

Yes of course.

 
> > > > > Punching holes is a rather problematic operation, and as mentioned not
> > > > > actually implemented for most filesystems - just decrementing counters
> > > > > on errors increases the chances that our error handling will actually
> > > > > work massively.
> > > > 
> > > > It's just harder for the pagecache. Invalidating and throwing out old
> > > > pagecache and splicing in new pages seems a bit of a hack.
> > > 
> > > Hardly a hack - it turns a buffered write into an operation that
> > > does not expose transient page state and hence prevents torn writes.
> > > That will allow us to use DIF enabled storage paths for buffered
> > > filesystem IO(*), perhaps even allow us to generate checksums during
> > > copy-in to do end-to-end checksum protection of data....
> > 
> > It is a hack. Invalidating is inherently racy and isn't guaranteed
> > to succeed.
> > 
> > You do not need to invalidate the pagecache to do this (which as I said
> > is racy). You need to lock the page to prevent writes, and then unmap
> > user mappings.
> 
> Which is the major part of invalidating a page. The other part of
> invalidation is removing the page from the page cache, so if
> invalidation is inherently too racy to use safely here, then I fail
> to see why the above isn't also too racy to use safely....

I don't know what you mean by the major part of invalidating the page.
Taking the page out of the pagecache is indeed the fallable part of
the operation.

 
> > You'd also need to have done some magic so writable mmaps
> > don't leak into get_user_pages.
> 
> Which means what, and why don't we have to do any special magic now
> to prevent it?

We do, but filesystems don't tend to use it.

 
> > But this should be a different discussion anyway. Don't forget, your
> > approach is forced into the invalidation requirement because of
> > downsides in its error handling sequence.
> 
> I wouldn't say forced into it, Nick - it's a deliberate design
> choice to make the overall stack simpler and more likely to function
> correctly.

Your design is forced to do it when I pointed out that writes into the
pagecache should not be made visiable if the process can subsequently
fail. copy-last is not subject to this.

So you can't say invalidation is an advantage of copy-first, because
if it is advantageous in other areas, copy-last can implement it too.

 
> Besides, all it takes to avoid the requirement of invalidation is to
> provide the guarantee that the allocation after reservation will
> either succeed or the filesystem shuts down in a corrupted state.
> If we provide that guarantee then the fact that transient page cache
> data might appear on allocation error is irrelevant, because it
> will never get written to disk and applications will error out
> pretty quickly.

Sure. IO errors and writeback cache means that we don't guarantee
without fsync that the data will come back after a crash.

This could be an answer to my above question (what is the 2-call
sequence for?)

All that is required upon write(2) completion (or partial completion)
is that the data can actually be found and written back at a later
date.

 
> I'm quite happy with that requirement, because of two things.
> Firstly, after the reservation nothing but a corruption or IO error
> should prevent the allocation from succeeding. In that case, the
> filesystem should already be in a shutdown state by the time the
> failed allocation returns.  Secondly, filesystems using delayed
> allocation are already making this promise successfully from
> get_blocks to ->writepage, hence I don't see any issues with
> encoding it into an allocation interface....

Well it's already there, and not just for delalloc filesystems,
because a lot of filesystems do writeback on their metadata too,
so it's all subject to IO errors.

 
> > That cannot be construed as
> > positive, because you are forced into it, wheras other approaches
> > *could* use it, but do not have to.
> 
> Except for the fact the other alternatives have much, much worse
> downsides. Yes, they could also use such a write path, but that
> doesn't reduce the complexity of those solutions or prevent any of
> the problems they have.

Let's just carefully look at the alternatives. This alternative of
zeroing out uninitialized blocks (via pagecache) is what we have
today.

What we should do is carefully consider exactly what error semantics
and guarantees we want, and then implement the best API taking those
into account.

If we are happy with the existing state of error handling, copy-first is
clearly better because the fast path is faster.

