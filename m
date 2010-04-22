Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab0DVWna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 18:43:30 -0400
Received: from mail2.shareable.org ([80.68.89.115]:54389 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab0DVWn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 18:43:28 -0400
Date: Thu, 22 Apr 2010 23:43:27 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: linux-fsdevel@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: readahead on directories
Message-ID: <20100422224327.GE13951@shareable.org>
References: <20100421161211.GC27575@shareable.org> <4BCF3FAE.7090206@cfl.rr.com> <20100421202209.GV27575@shareable.org> <4BCF6731.1070404@cfl.rr.com> <20100421220612.GD27575@shareable.org> <4BD05C9C.9020101@cfl.rr.com> <20100422175322.GE6265@shareable.org> <4BD0A24B.4060209@cfl.rr.com> <20100422203555.GA13951@shareable.org> <4BD0BE20.4030908@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD0BE20.4030908@cfl.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi wrote:
> On 4/22/2010 4:35 PM, Jamie Lokier wrote:
> > POSIX requires concurrent, overlapping writes don't interleave the
> > data (at least, I have read that numerous times), which is usually
> > implemented with a mutex even though there are other ways.
> 
> I think what you are getting at here is that write() needs to atomically
> update the file pointer, which does not need a mutex.

No, that is not the reason.  pwrite needs the mutex too.

> > The trickier stuff in proper AIO is sleeping waiting for memory to be
> > freed up, sleeping waiting for a rate-limited request queue entry
> > repeatedly, prior to each of the triple, double, single indirect
> > blocks, which you then sleep waiting to complete, sleeping waiting for
> > an atime update journal node, sleeping on requests and I/O on every
> 
> There's no reason to wait for updating the atime, and 

> Whether it's reading indirect blocks or b-trees
> doesn't make much difference; the fs ->get_blocks() tries not to sleep
> if possible, and if it must, returns -EAGAIN and the calling code can
> punt to a work queue to try again in a context that can sleep.

Now you are describing using threads in the blocking cases.  (Work
queues, thread pools, same thing.)  Earlier you were saying threads
are the wrong approach....  Good, good :-)

> The fs specific code just needs to support a flag like gfp_mask so it
> can be told we aren't in a context that can sleep; do your best and if
> you must block, return -EAGAIN.  It looks like it almost already does
> something like that based on this comment from fs/mpage.c:

Yes, it's not a bad pattern.  Simple to understand.

There's a slight overhead compared with saving the stack frame
fibril-style: The second, sleepable call has to redo much of the work
done in the non-sleepable call, and queuing the work queue requires
serialising etc. plus extra code for that.  Plus the work queue is a
bit more scheduling

On the other hand, the queue uses less memory than a stack frame.

For the in-cache cases, there's no overhead so it's fine.

A big problem with it, apart from having to change lots of places in
all the filesystems, is that the work-queues run with the wrong
security and I/O context.  Network filesystems break permissions, quotas
break, ionice doesn't work, etc.  It's obviously fixable but more
involved than just putting a read request on a work queue.

That's why the fibril/acall discussions talked about spawning threads
from the caller's context or otherwise magically swizzling contexts
around to do it with the efficiency of a preexisting thread pool.

Once you're doing task security & I/O context swizzling (which turns
out to be quite fiddly), the choice between swizzling stack frames or
using EAGAIN and work queue type objects becomes a less radical design
decision, and could even be a per-filesystem, per-operation choice.

> > Oh, and fine-grained locking makes the async transformation harder,
> > not easier :-)
> 
> How so?  With fine grained locking you can avoid the use of mutexes and
> opt for atomic functions or spin locks, so no need to sleep.

Fine-grained locking isn't the same thing as using non-sleepable locks.

> > For readahead yes because it's just an abortable hint.
> > For general AIO, no.
> 
> Why not?  aio_read() is perfectly allowed to fail if there is not enough
> memory to satisfy the request.

So is read().  And then the calling application usually exits, because
there's nothing else it can do usefully.  Same if aio_read() ever returns ENOMEM.

That way lies an application getting ENOMEM often and having to retry
aio_read in a loop, probably a busy one, which isn't how the interface
is supposed to work, and is not efficient either.

The only atomic allocation you might conceivably want is a small one
to enqueue the AIO and return immediately.  But really even that
should sleep.  That's the one case where you actually do want
aio_read() to sleep.

> That still leaves the problem of all the open() calls blocking to read
> one disk directory block at a time, since ureadahead opens all of the
> files first, then calls readahead() on each of them.  This is where it
> would really help to be able to readahead() the directories first, then
> try to open all of the files.

Put open() in threads too!  Actually I don't have any idea how well
that really goes.

> > Also, having defragged readahead files into a few compact zones, and
> > gotten the last boot's I/O trace, why not readahead those areas of the
> > blockdev first in perfect order, before finishing the job with
> > filesystem operations?  The redundancy from no-longer needed blocks is
> > probably small compared with the gain from perfect order in few big
> > zones, and if you store the I/O trace of the filesystem stage every
> > time to use for the block stage next time, the redundancy should stay low.
> 
> Good point, though I was hoping to be able to accomplish effectively the
> same thing purely with readahead() and other filesystem calls instead of
> going direct to the block device.

It depends on how accurate your block-level traces are, but if the
blocks are consolidated into few contiguous zones, readahead on the
blockdev should give perfect seek order, minimal IOPS and maximum I/O
sizes.  It won't even need any particular order from the defrag.  It's
hard to see even file readahead() approaching that for speed because
it's so simple.

Consider: Boot may read 50MB data in countless files including
scripts, parts of shared libs etc.  Just 0.5 second on any modern
system.  How long does the ureadahead run take?

-- Jamie

