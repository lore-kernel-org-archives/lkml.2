Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab0DUUWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:22:13 -0400
Received: from mail2.shareable.org ([80.68.89.115]:33874 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394Ab0DUUWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:22:10 -0400
Date: Wed, 21 Apr 2010 21:22:09 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: linux-fsdevel@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: readahead on directories
Message-ID: <20100421202209.GV27575@shareable.org>
References: <4BCC7C05.8000803@cfl.rr.com> <20100421004434.GA27420@shareable.org> <4BCF123C.6010400@cfl.rr.com> <20100421161211.GC27575@shareable.org> <4BCF3FAE.7090206@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCF3FAE.7090206@cfl.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi wrote:
> On 4/21/2010 12:12 PM, Jamie Lokier wrote:
> > Asynchronous is available: Use clone or pthreads.
> 
> Synchronous in another process is not the same as async.  It seems I'm
> going to have to do this for now as a workaround, but one of the reasons
> that aio was created was to avoid the inefficiencies this introduces.
> Why create a new thread context, switch to it, put a request in the
> queue, then sleep, when you could just drop the request in the queue in
> the original thread and move on?

Because tests have found that it's sometimes faster than AIO anyway!

...for those things where AIO is supported at all.  The problem with
more complicated fs operations (like, say, buffered file reads and
directory operations) is you can't just put a request in a queue.

Some of it has to be done in a context with stack and occasional
sleeping.  It's just too complicated to make all filesystem operations
_entirely_ async, and that is the reason Linux AIO has never gotten
very far trying to do that.

Those things where putting a request on a queue works tend to move the
sleepable metadata fetching to the code _before_ the request is queued
to get around that.  Which is one reason why Linux O_DIRECT AIO can
still block when submitting a request... :-/

The most promising direction for AIO at the moment is in fact spawning
kernel threads on demand to do the work that needs a context, and
swizzling some pointers so that it doesn't look like threads were used
to userspace.

Kernel threads on demand, especially magical demand at the point where
the thread would block, are faster than clone() in userspace - but not
expected to be much faster if you're reading from cold cache anyway,
with lots of blocking happening.

You might even find that calling readahead() on *files* goes a bit
faster if you have several threads working in parallel calling it,
because of the ability to parallelise metadata I/O.

> > A quick skim of fs/{ext3,ext4}/dir.c finds a call to
> > page_cache_sync_readahead.  Doesn't that do any reading ahead? :-)
> 
> Unfortunately it does not help when it is synchronous.  The process
> still sleeps until it has fetched the blocks it needs.  I believe that
> code just ends up doing a single 4kb read if the directory is no larger
> than that, or if it is, then it reads up to readahead_size.  It puts the
> request in the queue then sleeps until all the data has been read, even
> if only the first 4kb was required before readdir() could return.

So you're saying it _does_ readahead_size if needed.  That's great!
Evigny's concern about sequantially reading blocks one by one
isn't anything to care about then. That's one problem solved. :-)

> This means that a single thread calling readdir() is still going to
> block reading the directory before it can move on to trying to read
> other directories that are also needed.

Of course.

> > If not, fs/ext4/namei.c:ext4_dir_inode_operations points to
> > ext4_fiemap.  So you may have luck calling FIEMAP or FIBMAP on the
> > directory, and then reading blocks using the block device.  I'm not
> > sure if the cache loaded via the block device (when mounted) will then
> > be used for directory lookups.
> 
> Yes, I had considered that.  ureadahead already makes use of ext2fslibs
> to open the block device and read the inode tables so they are already
> in the cache for later use.  It seems a bit silly to do that though,
> when that is exactly what readahead() SHOULD do for you.

Don't bother with FIEMAP then.  It sounds like all the preloadable
metadata is already loaded.  FIEMAP would have still needed to be
threaded for parallel directories.

Filesystem-independent readahead() on directories is out of the
question (except by using a kernel background thread, which is
pointless because you can do that yourself.)

Some filesystems have directories which aren't stored like a file's
data, and the process of reading the directory needs to work through
its logic, and needs a sleepable context to work in.  Generic page
reading won't work for all of them.

readahead() on directories in specific filesystem types may be possible.
It would have to be implemented in each fs.

-- Jamie
