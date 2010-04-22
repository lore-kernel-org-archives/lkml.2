Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab0DVRxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 13:53:25 -0400
Received: from mail2.shareable.org ([80.68.89.115]:56513 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab0DVRxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 13:53:23 -0400
Date: Thu, 22 Apr 2010 18:53:22 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: linux-fsdevel@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: readahead on directories
Message-ID: <20100422175322.GE6265@shareable.org>
References: <4BCC7C05.8000803@cfl.rr.com> <20100421004434.GA27420@shareable.org> <4BCF123C.6010400@cfl.rr.com> <20100421161211.GC27575@shareable.org> <4BCF3FAE.7090206@cfl.rr.com> <20100421202209.GV27575@shareable.org> <4BCF6731.1070404@cfl.rr.com> <20100421220612.GD27575@shareable.org> <4BD05C9C.9020101@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD05C9C.9020101@cfl.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi wrote:
> On 4/21/2010 6:06 PM, Jamie Lokier wrote:
> > Generically is not likely. It's not about blocking, it's about the
> > fact that directories don't always consist of data blocks on the store
> > organised similarly to a file.  For example NFS, CIFS, or (I'm not
> > sure), maybe even reiserfs/btrfs?
> 
> The contents are stored in blocks somewhere.  It doesn't really matter
> how or where as long as the fs figures out what it will need to resolve
> names in that directory and reads that into the cache.

Right, but finding those blocks is highly filesystem-dependent which
is why making it a generic feature would need support in each filesystem.

However, there could be generic readahead() support in the VFS for
filesystems with the right block-getting hook.  All those which
support FIEMAP on directories should work.  We're back to why not do
it yourself then, as very few programs need directory readahead.

> > Why am I reading all over the place that Linux AIO only works with O_DIRECT?
> > Is it out of date? :-)
> 
> Dunno, where did you read that?  If you are using O_DIRECT then you
> really should be using aio or you will suffer a pretty heavy performance
> loss from all of the sleeping, but strictly speaking the two do not have
> to be used together.

Linux AIO is fickle: Whether it's _really_ async depends on the
filesystem type, kernel version, distro-specific patches, and whether
you used O_DIRECT or not.  Unfortunately there is no API to find out.
Even when really async, it's not guaranteed to never block.

So it's a lot like the "compromise" readahead we've discussed: Mostly
async (if you've checked filesystem type etc.), but not fully async.

> As an added optimization, you only need to allocate one bio in
> readahead() since it is likely that only one will be needed if all of
> the blocks are sequential.  Then the callback can use the gfp_mask flags
> to prevent allocations from sleeping and if more can not be allocated,
> then you sumbit what you've got and when THAT completes, you try to
> build more requests.

True, you can use gfp_mask flags for allocations and stop readahead
where it fails.  Probably a good plan.  But you can't use it for, say,
taking mutexes.

> > Plus every little mutex / rwlock is another place where you need those
> > callback functions.  We don't even _have_ an async mutex facility in
> > the kernel.  So every user of a mutex has to be changed to use
> > waitqueues or something.  No more lockdep checking, no more RT
> > priority inheritance.
> 
> Yes, it looks like ext4_get_blocks() does use mutexes so it can't be
> called from bh context.  Perhaps it could be changed to avoid this if
> possible and if it must, return -EWOULDBLOCK and the completion callback
> would have to punt to a work queue to retry.  In the common case though,
> it looks like it would be possible for ext4_get_blocks() to avoid using
> mutexes and just parse the newly read indirect block and return, then
> the completion callback can queue its bios and be done.

If you're interested, try finding all the places which could sleep for
a write() call...  Note that POSIX requires a mutex for write; you
can't easily change that.  Reading is easier to make fully async than
writing.

> > To read an indirect block, you have to allocate memory: another
> > callback after you've slept waiting for memory to be freed up.
> 
> You allocate the cache pages in the initial readahead() before
> returning.  No need to do it from the bio completion callback.

Then readahead() isn't async, which was your request...  It can block
waiting for memory and other things when you call it.

So that would be the "compromise" version which you complain about
below.  So I don't know why you're suggesting it :-)

> > A compromise where just a few synchronisation points are made async is
> > ok.  But then it's a compromise... so you still need a multi-threaded
> > caller to keep the queues full in all situations.
> 
> Right, which tends to negate most of the gains of having any async at all.

Exactly.  And making it so it _never_ blocks when called is a ton of
work, more lines of code (in C anyway), a maintainability nightmare,
and adds some different bottlenecks you've not thought off.  At this
point I suggest you look up the 2007 discussions about fibrils which
are quite good: They cover the overheads of setting up state for async
calls when unnecessary, and the beautiful simplicty of treating stack
frames as states in their own right.

> For example, if we have multiple threads calling readahead()
> instead of just one since it may sleep reading an indirect block, then
> we can end up with this:
> 
> Thread 1 queues reads of the first 12 blocks of the first file, and the
> indirect block.  Thread then sleeps waiting for the indirect block.
> 
> Thread 2 queues reads of the first 12 blocks of the second file and its
> indirect block.  Thread then sleeps waiting for the indirect block.
> 
> Now we have the disk read 12 contiguous blocks of data + indirect from
> the first file, then 12 contiguous blocks of data + indirect from the
> second file, which are further down the disk, so the head has to seek
> forward.  Then thread 1 wakes up and parses the indirect block and
> queues reading of the subsequent sectors, which now requires a backwards
> seek since we skipped reading those sectors to move ahead to the second
> file.
> 
> So in our attempt to use threads to keep the queue full, we have
> introduced more seeking, which tends to have a higher penalty than just
> using a single thread and having the queue drain and the disk idle for a
> few ns while we wake up and parse the indirect block.
> 
> Come to think of it, I guess that is a good argument NOT to make
> readahead() fully async.

No: In that particular case, waiting while the indirect block is
parsed is advantageous.  But suppose the first indirect block is
located close to the second file's data blocks.  Or the second file's
data blocks are on a different MD backing disk.  Or the disk has
different seeking characteristics (flash, DRBD).

Then the I/O scheduler _should_ overlap the reads from both files.
The information to decide that is dependent on filesystem layout (and
block device layout if MD).  Forcing the order at the generic
readahead() level would be suboptimal, even if it sort of works out in
common situations.

Going a bit off-topic (the 'd' key if bored...)

What you've almost identified ;-) is a theoretical scheduling
advantage of AIO _sometimes_: If the original I/O submission order has
good properties _and_ the I/O queue is close to empty preventing
sorting, the hints implicit in the submission order are better
preserved with AIO.

For example: If you use O_DIRECT with AIO to read a file in
block-sequential order, the I/Os reach the disk in that order.  If you
implement a queue in userspace serviced by multiple threads to overlap
synchronous I/O, there will be _slight_ timing randomness which
shuffles the order.  It doesn't matter when the I/O queue has enough
entries, but it'll make a difference when starting up in that example
- but even than only rarely - most times even the threads will end up
queuing things in the preferred order.

But if your AIO submission order doesn't have any particularly special
properties anyway, or if you can submit enough in parallel that the
kernel can sort things, or if the randomness from threads is small
enough that it doesn't matter...  that AIO benefit is lost entirely.

With Linux AIO, because submission can block unpredictably, I'm
guessing the sweet spot is probably to use a small number of threads -
number not easy to determine, and dependent on many factors.

I reckon the same applies to your readahead() calls: A queue which you
make sure is always full enough that threads never block, sorted by
inode number or better hints where known, with a small number of
threads calling readahead() for files, and doing whatever is useful
for directories.

It is most unfortunate that such ideas are rather complicated to
implemented well, just to try them out :-)

Fwiw, my view of this is after writing userspace programs using a very
async-callback sort of structure and trying to make the most of
O_DIRECT + AIO (i.e. I'm not thinking like an "I love threads and
don't understand the point of state machines" sort of person), only to
read the fibril discussion and agree that the same issues occur in
userspace: There is a balance between thread-like scheduling and
event-like scheduling: Certain complex things are better using
coroutine-like call stacks, using explicit state callbacks only at
particular well-defined sleeping points.

In some ways (zoom way, way out of the picture...) the balance between
implicit state via threads and explicit state ("event-driven...") is
more fundamentally a continuum than it appears close up.  Both for
simplicity of code, and performance.  Neither extreme is optimal in general.

-- Jamie
