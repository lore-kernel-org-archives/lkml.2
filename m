Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab0DVO0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 10:26:43 -0400
Received: from exhub016-4.exch016.msoutlookonline.net ([207.5.72.225]:11513
	"EHLO EXHUB016-4.exch016.msoutlookonline.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754875Ab0DVO0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 10:26:42 -0400
Message-ID: <4BD05C9C.9020101@cfl.rr.com>
Date: Thu, 22 Apr 2010 10:26:36 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: linux-fsdevel@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: readahead on directories
References: <4BCC7C05.8000803@cfl.rr.com> <20100421004434.GA27420@shareable.org> <4BCF123C.6010400@cfl.rr.com> <20100421161211.GC27575@shareable.org> <4BCF3FAE.7090206@cfl.rr.com> <20100421202209.GV27575@shareable.org> <4BCF6731.1070404@cfl.rr.com> <20100421220612.GD27575@shareable.org>
In-Reply-To: <20100421220612.GD27575@shareable.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/21/2010 6:06 PM, Jamie Lokier wrote:
> Why am I reading all over the place that Linux AIO only works with O_DIRECT?
> Is it out of date? :-)

Dunno, where did you read that?  If you are using O_DIRECT then you
really should be using aio or you will suffer a pretty heavy performance
loss from all of the sleeping, but strictly speaking the two do not have
to be used together.

Personally I wish there was another flag besides O_DIRECT that split the
two semantics O_DIRECT now carries.  Right now it FORCES the cache to be
bypassed and the IO to go to the disk, even if it's already in the
cache.  It would be nice if you could ask a read to done such that IF
it's already cached, then copy it from there, otherwise, send the read
direct down to the disk to dma into my buffer.

> To read an indirect block, you have to allocate memory: another
> callback after you've slept waiting for memory to be freed up.

You allocate the cache pages in the initial readahead() before
returning.  No need to do it from the bio completion callback.

> Then you allocate a request: another callback while you wait for the
> request queue to drain.

Same thing.  Get everything set up and ready to go in readahead() and
the only thing that has to wait on the indirect block to be read is
filling in the block addresses of the bios and submitting them.  This
last part can be done in the bio completion callback.

As an added optimization, you only need to allocate one bio in
readahead() since it is likely that only one will be needed if all of
the blocks are sequential.  Then the callback can use the gfp_mask flags
to prevent allocations from sleeping and if more can not be allocated,
then you sumbit what you've got and when THAT completes, you try to
build more requests.

> Plus every little mutex / rwlock is another place where you need those
> callback functions.  We don't even _have_ an async mutex facility in
> the kernel.  So every user of a mutex has to be changed to use
> waitqueues or something.  No more lockdep checking, no more RT
> priority inheritance.

Yes, it looks like ext4_get_blocks() does use mutexes so it can't be
called from bh context.  Perhaps it could be changed to avoid this if
possible and if it must, return -EWOULDBLOCK and the completion callback
would have to punt to a work queue to retry.  In the common case though,
it looks like it would be possible for ext4_get_blocks() to avoid using
mutexes and just parse the newly read indirect block and return, then
the completion callback can queue its bios and be done.

> A compromise where just a few synchronisation points are made async is
> ok.  But then it's a compromise... so you still need a multi-threaded
> caller to keep the queues full in all situations.

Right, which tends to negate most of the gains of having any async at
all.  For example, if we have multiple threads calling readahead()
instead of just one since it may sleep reading an indirect block, then
we can end up with this:

Thread 1 queues reads of the first 12 blocks of the first file, and the
indirect block.  Thread then sleeps waiting for the indirect block.

Thread 2 queues reads of the first 12 blocks of the second file and its
indirect block.  Thread then sleeps waiting for the indirect block.

Now we have the disk read 12 contiguous blocks of data + indirect from
the first file, then 12 contiguous blocks of data + indirect from the
second file, which are further down the disk, so the head has to seek
forward.  Then thread 1 wakes up and parses the indirect block and
queues reading of the subsequent sectors, which now requires a backwards
seek since we skipped reading those sectors to move ahead to the second
file.

So in our attempt to use threads to keep the queue full, we have
introduced more seeking, which tends to have a higher penalty than just
using a single thread and having the queue drain and the disk idle for a
few ns while we wake up and parse the indirect block.

Come to think of it, I guess that is a good argument NOT to make
readahead() fully async.

> Generically is not likely. It's not about blocking, it's about the
> fact that directories don't always consist of data blocks on the store
> organised similarly to a file.  For example NFS, CIFS, or (I'm not
> sure), maybe even reiserfs/btrfs?

The contents are stored in blocks somewhere.  It doesn't really matter
how or where as long as the fs figures out what it will need to resolve
names in that directory and reads that into the cache.
