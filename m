Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab0ENFvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 01:51:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:41329 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186Ab0ENFvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 01:51:13 -0400
Date: Fri, 14 May 2010 15:50:54 +1000
From: Nick Piggin <npiggin@suse.de>
To: Josef Bacik <josef@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] new ->perform_write fop
Message-ID: <20100514055054.GA4706@laptop>
References: <20100512212403.GE3597@localhost.localdomain>
 <20100513013926.GD27011@dhcp231-156.rdu.redhat.com>
 <20100514010042.GI13617@dastard>
 <20100514033057.GL27011@dhcp231-156.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100514033057.GL27011@dhcp231-156.rdu.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 11:30:57PM -0400, Josef Bacik wrote:
> On Fri, May 14, 2010 at 11:00:42AM +1000, Dave Chinner wrote:
> > On Wed, May 12, 2010 at 09:39:27PM -0400, Josef Bacik wrote:
> > > On Wed, May 12, 2010 at 05:24:04PM -0400, Josef Bacik wrote:
> > > > Hello,
> > > > 
> > > > I just started adding aio_write to Btrfs and I noticed we're duplicating _alot_
> > > > of the generic stuff in mm/filemap.c, even though the only thing thats really
> > > > unique is the fact that we copy userspace pages in chunks rather than one page a
> > > > t a time.  What would be best is instead of doing write_begin/write_end with
> > > > Btrfs, it would be nice if we could just do our own perform_write instead of
> > > > generic_perform_write.  This way we can drop all of these generic checks we have
> > > > that we copied from filemap.c and just got to the business of actually writing
> > > > the data.  I hate to add another file operation, but it would _greatly_ reduce
> > > > the amount of duplicate code we have.  If there is no violent objection to this
> > > > I can put something together quickly for review.  Thanks,
> > > >
> > > 
> > > I just got a suggestion from hpa about instead just moving what BTRFS does into
> > > the generic_perform_write.  What btrfs does is allocates a chunk of pages to
> > > cover the entirety of the write, sets everything up, does the copy from user
> > > into the pages, and tears everything down, so essentially what
> > > generic_perform_write does, just with more pages.

Yeah we basically decided that perform_write is not a good entry point.
BTW. can you wrap up this generic code into libfs and so you don't have
to duplicate so much of it?


> > 
> > Except that btrfs does things in a very different manner to most
> > other filesystems ;)
> > 
> > > I could modify
> > > generic_perform_write and the write_begin/write_end aops to do this, where
> > > write_begin will return how many pages it allocated, copy in all of the
> > > userpages into the pages we allocated at once, and then call write_end with the
> > > pages we allocated in write begin.  Then I could just make btrfs do
> > > write_being/write_end.  So which option seems more palatable?  Thanks,
> > 
> > I can see how this would work for btrfs, but the issue is how any
> > other filesystem would handle it.
> > 
> > I've been trying to get my head around how any filesystem using
> > bufferheads and generic code can do multipage writes using
> > write_begin/write_end without modifying the interface, and I just
> > threw away my second attempt because the error handling just
> > couldn't be handled cleanly without duplicating the entire
> > block_write_begin path in each filesystem that wanted to do
> > multipage writes.
> > 
> > The biggest problem is that block allocation is intermingled with
> > allocating and attaching bufferheads to pages, hence error handling
> > can get really nasty and is split across a call chain 3 or 4
> > functions deep.  The error handling is where I'm finding all the
> > dangerous and hard-to-kill demons lurking in dark corners. I suspect
> > there's a grue in there somewhere, too. ;)
> > 
> > Separating the page+bufferhead allocation and block allocation would
> > make this much simpler but I can't fit that easily into the existing
> > interfaces.
> >
> > Hence I think that write_begin/copy pages/write_end is not really
> > suited to multipage writes when allocation is done in write_begin
> > and the write can then fail in a later stage without a simple method
> > of undoing the allocation. We don't have any hole punch interfaces
> > to the filesystems (and I think only XFS supports that functionality
> > right now), so handling errors after allocation becomes rather
> > complex, especially when you have multiple blocks per page. 
> > 
> > Hence I've independently come to the conclusion that delaying the
> > allocation until *after* the copy as btrfs does is probably the best
> > approach to take here.  This largely avoids the error handling
> > complexity because the write operation is an all-or-nothing
> > operation. btrfs has separate hooks for space reservation and
> > releasing the reservation and doesn't commit to actually allocating
> > anything until the copying is complete. Hence cleanup is simple no
> > matter where a failure occurs.
> > 
> > Personally, I'm tending towards killing the get_blocks() callback as
> > the first step in this process - turn it into a real inode/address
> > space operation (say ->allocate) so we can untangle the write path
> > somewhat (lots of filesystem just provide operations as wrappers to
> > provide a fs-specific get_blocks callback to generic code.  If the
> > "create" flag is then converted to a "command" field, the interface
> > can pass "RESERVE", "ALLOC", "CREATE", etc to allow different
> > operations to be clearly handled.
> > 
> > e.g.:
> > 
> > 	->allocate(mapping, NULL, off, len, RESERVE)
> > 		reserves necessary space for write
> > 	->write_begin
> > 		grab pages into page cache
> > 		attach bufferheads (if required)
> > 	fail -> goto drop pages
> > 	copy data into pages
> > 	fail -> goto drop pages
> > 	->allocate(mapping, pages, off, len, ALLOC)
> > 		allocates reserved space (if required)
> > 		sets up/maps/updates bufferheads/extents
> > 	fail -> goto drop pages
> > 	->write_end
> > 		set pages dirty + uptodate
> > 	done
> > 
> > drop_pages:
> > 	->allocate(mapping, NULL, off, len, UNRESERVE)
> > 	if needed, zero partial pages
> > 	release pages, clears uptodate.
> > 
> > Basically this allows the copying of data before any allocation is
> > actually done, but also allows ENOSPC to be detected before starting
> > the copy. The filesystem can call whatver helpers it needs inside
> > ->get_blocks(ALLOC) to set up bufferhead/extent state to match
> > what has been reserved/allocated/mapped in the RESERVE call.
> > 
> > This will work for btrfs, and it will work for XFS and I think it
> > will work for other filesystems that are using bufferheads as well.
> > For those filesystems that will only support a page at a time, then
> > they can continue to use the current code, but should be able to be
> > converted to the multipage code by making RESERVE and UNRESERVE
> > no-ops, and ALLOC does what write_begin+get_blocks currently does to
> > set up block mappings.
> > 
> > Thoughts?
> >
> So this is what I had envisioned, we make write_begin take a nr_pages pointer
> and tell it how much data we have to write, then in the filesystem we allocate
> as many pages as we feel like, idealy something like
> 
> min(number of pages we need for the write, some arbitrary limit for security)
> 
> and then we allocate all those pages.  Then you can pass them into
> block_write_begin, which will walk the pages, allocating buffer heads and
> allocating the space as needed.
> 
> Now since we're coming into write_begin with "we want to write X bytes" we can
> go ahead and do the enospc checks for X bytes, and then if we are good to go,
> chances are we won't fail.
> 
> Except if we're overwriting a holey section of the file, we're going to be
> screwed in both your way and my way.  My way probably would be the most likely
> to fail, since we could fail to do the copy_from_user, but hopefully the segment
> checks and doing the fault_in_readable before all of this would keep those
> problems to a minimum.
> 
> In your case the only failure point is in the allocate step.  If we fail on down
> the line after we've done some hole filling, we'll be hard pressed to go back
> and free up those blocks.  Is that what you are talking about, having the
> allocate(UNRESERVE) thing being able to go back and figure out what should have
> been holes needs to be holes again?  If thats the case then I think your idea
> will work and is probably the best way to move forward.  But from what I can
> remember about how all this works with buffer heads, there's not a way to say
> "we _just_ allocated this recently".  Thanks,

Now is there really a good reason to go this way and add more to the
write_begin/write_end paths? Rather than having filesystems just
implement their own write file_operations in order to do multi-block
operations?

>From what I can see, the generic code is not going to be able to be
much help with error handling etc. so I would prefer to keep it as
simple as possible. I think it is still adequate for most cases.

Take a look at how fuse does multi-page write operations. It is about
the simplest case you can get, but it still requires all the generic
checks etc. and it is quite neat -- I don't see a big issue with
duplicating generic code?

