Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596Ab0DVUgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:36:07 -0400
Received: from mail2.shareable.org ([80.68.89.115]:47294 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab0DVUf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:35:57 -0400
Date: Thu, 22 Apr 2010 21:35:55 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: linux-fsdevel@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: readahead on directories
Message-ID: <20100422203555.GA13951@shareable.org>
References: <20100421004434.GA27420@shareable.org> <4BCF123C.6010400@cfl.rr.com> <20100421161211.GC27575@shareable.org> <4BCF3FAE.7090206@cfl.rr.com> <20100421202209.GV27575@shareable.org> <4BCF6731.1070404@cfl.rr.com> <20100421220612.GD27575@shareable.org> <4BD05C9C.9020101@cfl.rr.com> <20100422175322.GE6265@shareable.org> <4BD0A24B.4060209@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD0A24B.4060209@cfl.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi wrote:
> > If you're interested, try finding all the places which could sleep for
> > a write() call...  Note that POSIX requires a mutex for write; you
> > can't easily change that.  Reading is easier to make fully async than
> > writing.
> 
> POSIX doesn't say anything about how write() must be implemented
> internally.  You can do without mutexes just fine.

POSIX requires concurrent, overlapping writes don't interleave the
data (at least, I have read that numerous times), which is usually
implemented with a mutex even though there are other ways.

Many implementations relax this for O_DIRECT, because it's non-POSIX
and concurrent writes are good.

> A good deal of the current code does use mutexes, but does not have
> to.  If your data is organized well then the critical sections of
> code that modify it can be kept very small, and guarded with either
> atomic access functions or a spin lock.  A mutex is more convenient
> since it it allows you to have much larger critical sections and
> sleep, but we don't really like having coarse grained locking in the
> kernel.

The trickier stuff in proper AIO is sleeping waiting for memory to be
freed up, sleeping waiting for a rate-limited request queue entry
repeatedly, prior to each of the triple, double, single indirect
blocks, which you then sleep waiting to complete, sleeping waiting for
an atime update journal node, sleeping on requests and I/O on every
step through b-trees, etc...  That's just reads; writing adds just as
much again.  Changing those to async callbacks in every
filesystem - it's not worth it and it'd be a maintainability
nightmare.  We're talking about changes to the kernel
memory allocator among other things.  You can't gfp_mask it away -
except for readahead() because it's an abortable hint.

Oh, and fine-grained locking makes the async transformation harder,
not easier :-)

> > Then readahead() isn't async, which was your request...  It can block
> > waiting for memory and other things when you call it.
> 
> It doesn't have to block; it can return -ENOMEM or -EWOULDBLOCK.

For readahead yes because it's just an abortable hint.
For general AIO, no.

> > No: In that particular case, waiting while the indirect block is
> > parsed is advantageous.  But suppose the first indirect block is
> > located close to the second file's data blocks.  Or the second file's
> > data blocks are on a different MD backing disk.  Or the disk has
> > different seeking characteristics (flash, DRBD).
> 
> Hrm... true, so knowing this, defrag could lay out the indirect block of
> the first file after the first 12 blocks of the second file to maintain
> optimal reading.  Hrm... I might have to try that.
> 
> > I reckon the same applies to your readahead() calls: A queue which you
> > make sure is always full enough that threads never block, sorted by
> > inode number or better hints where known, with a small number of
> > threads calling readahead() for files, and doing whatever is useful
> > for directories.
> 
> Yes, and ureadahead already orders the calls to readahead() based on
> disk block order.  Multithreading it leads the problem with backward
> seeks right now but a tweak to the way defrag lays out the indirect
> blocks, should fix that.  The more I think about it the better this idea
> sounds.

Ah, you didn't mention defragging for optimising readahead before.

In that case, just trace the I/O done a few times and order your
defrag to match the trace, it should handle consistent patterns
without special defrag rules.  I'm surprised it doesn't already.
Does ureadahead not use prior I/O traces for guidance?

Also, having defragged readahead files into a few compact zones, and
gotten the last boot's I/O trace, why not readahead those areas of the
blockdev first in perfect order, before finishing the job with
filesystem operations?  The redundancy from no-longer needed blocks is
probably small compared with the gain from perfect order in few big
zones, and if you store the I/O trace of the filesystem stage every
time to use for the block stage next time, the redundancy should stay low.

Just a few ideas.

-- Jamie
