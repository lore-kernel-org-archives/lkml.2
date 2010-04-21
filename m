Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab0DUWGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 18:06:14 -0400
Received: from mail2.shareable.org ([80.68.89.115]:39781 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886Ab0DUWGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 18:06:13 -0400
Date: Wed, 21 Apr 2010 23:06:12 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: linux-fsdevel@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: readahead on directories
Message-ID: <20100421220612.GD27575@shareable.org>
References: <4BCC7C05.8000803@cfl.rr.com> <20100421004434.GA27420@shareable.org> <4BCF123C.6010400@cfl.rr.com> <20100421161211.GC27575@shareable.org> <4BCF3FAE.7090206@cfl.rr.com> <20100421202209.GV27575@shareable.org> <4BCF6731.1070404@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCF6731.1070404@cfl.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi wrote:
> > ...for those things where AIO is supported at all.  The problem with
> > more complicated fs operations (like, say, buffered file reads and
> > directory operations) is you can't just put a request in a queue.
> 
> Unfortunately there aren't async versions of the calls that make
> directory operations, but aio_read() performs a buffered file read
> asynchronously just fine.

Why am I reading all over the place that Linux AIO only works with O_DIRECT?
Is it out of date? :-)

I admit I haven't even _tried_ buffered files with Linux AIO due to
the evil propaganda.

> > The most promising direction for AIO at the moment is in fact spawning
> > kernel threads on demand to do the work that needs a context, and
> > swizzling some pointers so that it doesn't look like threads were used
> > to userspace.
> 
> NO!  This is how aio was implemented at first and it was terrible.
> Context is only required because it is easier to write the code linearly
> instead of as a state machine.  It would be better for example, to have
> readahead() register a callback function to be called when the read of
> the indirect block completes, and the callback needs zero context to
> queue reads of the data blocks referred to by the indirect block.

To read an indirect block, you have to allocate memory: another
callback after you've slept waiting for memory to be freed up.

Then you allocate a request: another callback while you wait for the
request queue to drain.

Then you submit the request: that's the callback you mentioned,
waiting for the result.

But then triple, double, single indirect blocks: each of the above
steps repeated.

In the case of writing, another group of steps for bitmap blocks,
inode updates, and heaven knows how fiddly it gets with ordered
updates to the journal, synchronised with other writes.

Plus every little mutex / rwlock is another place where you need those
callback functions.  We don't even _have_ an async mutex facility in
the kernel.  So every user of a mutex has to be changed to use
waitqueues or something.  No more lockdep checking, no more RT
priority inheritance.

There are a _lot_ of places that can sleep on the way to a trivial
file I/O, and quite a lot of state to be past along the continuation
functions.

It's possible but by no means obvious that it's better.

I think people have mostly given up on that approach due to the how
much it complicates all the filesystem code, and how much goodness
there is in being able to call things which can sleep when you look at
all the different places.  It seemed like a good idea for a while.

And it's not _that_ certain that it would be faster at high
loads after all the work.

A compromise where just a few synchronisation points are made async is
ok.  But then it's a compromise... so you still need a multi-threaded
caller to keep the queues full in all situations.

> > Filesystem-independent readahead() on directories is out of the
> > question (except by using a kernel background thread, which is
> > pointless because you can do that yourself.)
> 
> No need for a thread.  readahead() does not need one for files, reading
> the contents of a directory should be no different.
>
> > Some filesystems have directories which aren't stored like a file's
> > data, and the process of reading the directory needs to work through
> > its logic, and needs a sleepable context to work in.  Generic page
> > reading won't work for all of them.
> 
> If the fs absolutely has to block that's ok, since that is no different
> from the way readahead() works on files, but most of the time it
> shouldn't have to and should be able to throw the read in the queue and
> return.

For specific filesystems, you could do it.  readahead() on directories
is not an unreasonable thing to add on.

Generically is not likely. It's not about blocking, it's about the
fact that directories don't always consist of data blocks on the store
organised similarly to a file.  For example NFS, CIFS, or (I'm not
sure), maybe even reiserfs/btrfs?

-- Jamie

