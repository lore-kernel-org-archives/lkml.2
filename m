Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865Ab0DVVXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 17:23:31 -0400
Received: from exhub016-3.exch016.msoutlookonline.net ([207.5.72.226]:14707
	"EHLO EXHUB016-3.exch016.msoutlookonline.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757045Ab0DVVX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 17:23:28 -0400
Message-ID: <4BD0BE20.4030908@cfl.rr.com>
Date: Thu, 22 Apr 2010 17:22:40 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: linux-fsdevel@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: readahead on directories
References: <20100421004434.GA27420@shareable.org> <4BCF123C.6010400@cfl.rr.com> <20100421161211.GC27575@shareable.org> <4BCF3FAE.7090206@cfl.rr.com> <20100421202209.GV27575@shareable.org> <4BCF6731.1070404@cfl.rr.com> <20100421220612.GD27575@shareable.org> <4BD05C9C.9020101@cfl.rr.com> <20100422175322.GE6265@shareable.org> <4BD0A24B.4060209@cfl.rr.com> <20100422203555.GA13951@shareable.org>
In-Reply-To: <20100422203555.GA13951@shareable.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/22/2010 4:35 PM, Jamie Lokier wrote:
> POSIX requires concurrent, overlapping writes don't interleave the
> data (at least, I have read that numerous times), which is usually
> implemented with a mutex even though there are other ways.

I think what you are getting at here is that write() needs to atomically
update the file pointer, which does not need a mutex.

> The trickier stuff in proper AIO is sleeping waiting for memory to be
> freed up, sleeping waiting for a rate-limited request queue entry
> repeatedly, prior to each of the triple, double, single indirect
> blocks, which you then sleep waiting to complete, sleeping waiting for
> an atime update journal node, sleeping on requests and I/O on every

There's no reason to wait for updating the atime, and I already said if
there isn't enough memory then you just return -EAGAIN or -ENOMEM
instead of waiting.  Whether it's reading indirect blocks or b-trees
doesn't make much difference; the fs ->get_blocks() tries not to sleep
if possible, and if it must, returns -EAGAIN and the calling code can
punt to a work queue to try again in a context that can sleep.

> step through b-trees, etc...  That's just reads; writing adds just as
> much again.  Changing those to async callbacks in every
> filesystem - it's not worth it and it'd be a maintainability
> nightmare.  We're talking about changes to the kernel
> memory allocator among other things.  You can't gfp_mask it away -
> except for readahead() because it's an abortable hint.

The fs specific code just needs to support a flag like gfp_mask so it
can be told we aren't in a context that can sleep; do your best and if
you must block, return -EAGAIN.  It looks like it almost already does
something like that based on this comment from fs/mpage.c:

 * We pass a buffer_head back and forth and use its buffer_mapped() flag to
 * represent the validity of its disk mapping and to decide when to do
the next
 * get_block() call.
 */

If it fixes up a buffer_head for the blocks it needs to finish and
returns, then do_mpage_readpage() could queue those reads with a
completion routine that would call get_block() again when the data has
been read, and when get_block() maps the blocks, then queue reads for
those blocks.

> Oh, and fine-grained locking makes the async transformation harder,
> not easier :-)

How so?  With fine grained locking you can avoid the use of mutexes and
opt for atomic functions or spin locks, so no need to sleep.

> For readahead yes because it's just an abortable hint.
> For general AIO, no.

Why not?  aio_read() is perfectly allowed to fail if there is not enough
memory to satisfy the request.

> Ah, you didn't mention defragging for optimising readahead before.
> 
> In that case, just trace the I/O done a few times and order your
> defrag to match the trace, it should handle consistent patterns
> without special defrag rules.  I'm surprised it doesn't already.
> Does ureadahead not use prior I/O traces for guidance?

Yes, it traces the IO then on the next boot calls readahead() on the
files that were read during the trace, after sorting them by on disk
block location.  I've been trying to improve things by having defrag
pack those files tightly at the start of the disk, and have run into the
problem with the indirect blocks and the open() calls blocking because
the directories have not been read yet, hence, my desire to readahead()
on the directories.

Right now defrag lays down the indirect block immediately after the 12
direct blocks, which makes the most sense if you are just reading that
one file.  Threading the readahead() calls and moving the indirect block
to after the next file's direct blocks would make ureadahead faster, at
the expense of any one single file read.  Probably a good tradeoff that
I will have to try.

That still leaves the problem of all the open() calls blocking to read
one disk directory block at a time, since ureadahead opens all of the
files first, then calls readahead() on each of them.  This is where it
would really help to be able to readahead() the directories first, then
try to open all of the files.

> Also, having defragged readahead files into a few compact zones, and
> gotten the last boot's I/O trace, why not readahead those areas of the
> blockdev first in perfect order, before finishing the job with
> filesystem operations?  The redundancy from no-longer needed blocks is
> probably small compared with the gain from perfect order in few big
> zones, and if you store the I/O trace of the filesystem stage every
> time to use for the block stage next time, the redundancy should stay low.

Good point, though I was hoping to be able to accomplish effectively the
same thing purely with readahead() and other filesystem calls instead of
going direct to the block device.
