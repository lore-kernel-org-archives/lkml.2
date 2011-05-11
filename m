Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab1EKQYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:24:47 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9930 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757348Ab1EKQYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:24:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 11 May 2011 09:24:41 -0700
Date: Wed, 11 May 2011 09:24:41 -0700
From: rmorell@nvidia.com
To: Jan Kara <jack@suse.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: mmap vs. ctime bug?
Message-ID: <20110511162441.GC22847@morell.nvidia.com>
References: <20110510012348.GJ3848@morell.nvidia.com>
 <20110511104358.GD5057@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511104358.GD5057@quack.suse.cz>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 03:43:58AM -0700, Jan Kara wrote:
>   Hello,
> 
> On Mon 09-05-11 18:23:48, rmorell@nvidia.com wrote:

[...]

> > 
> > I was able to reproduce the behavior with a simple test case (attached) with
> > the latest git kernel built from 26822eebb25.  To run the test, simply
> > put test.c and the Makefile in a new directory and run "make runtest".
> > Note that the filesystem blocks and ctime change between the two stat
> > invocations, although the mtime remains the same:
> > 
> > # make runtest
> > gcc test.c -o test
> > rm -f out
> > ./test out
> > stat out
> >   File: `out'
> >   Size: 268435456 	Blocks: 377096     IO Block: 4096   regular file
> > Device: 304h/772d	Inode: 655367      Links: 1
> > Access: (0600/-rw-------)  Uid: (    0/    root)   Gid: (    0/    root)
> > Access: 2011-05-09 18:06:24.000000000 -0700
> > Modify: 2011-05-09 18:06:27.000000000 -0700
> > Change: 2011-05-09 18:06:27.000000000 -0700
> > sync
> > stat out
> >   File: `out'
> >   Size: 268435456 	Blocks: 524808     IO Block: 4096   regular file
> > Device: 304h/772d	Inode: 655367      Links: 1
> > Access: (0600/-rw-------)  Uid: (    0/    root)   Gid: (    0/    root)
> > Access: 2011-05-09 18:06:24.000000000 -0700
> > Modify: 2011-05-09 18:06:27.000000000 -0700
> > Change: 2011-05-09 18:06:28.000000000 -0700
> > 
> > (note: depending on your system, you may need to tweak the "SIZE" constant in
> > test.c up to see ctime actually change at a resolution of 1s)
> > 
> > 
> > Does this seem like a bug to anyone else?  For the normal "make" flow to work
> > properly, files really need to be done changing by the time a process exits and
> > wait(3) returns to the parent.  The heavy-hammer workaround of adding a
> > sync(1) throws away a ton of potential benefit from the filesystem cache.
> > Adding an msync(MS_SYNC) in the toy test app also "fixes" the problem, but
> > that's not feasible in the production environment since libelf is doing the
> > modification internally and besides, it seems like it shouldn't be necessary.
> > 
> > If it matters, the filesystem is a dead simple ext3 with no special mount
> > flags, but I suspect this is not specific to FS:
>   OK, so let me explain what happens: When a sparse file is created and
> written to via mmap, we just store the data in memory. Later, we decide
> it's time to store the data on disk and thus we allocate blocks for the
> data. At this point we also update ctime and mtime - naturally since the

Note that mtime has not changed, only ctime.

> amount of space occupied by the file has changed. I've looked at the
> specification and it says:
> The st_ctime and st_mtime field for a file mapped with  PROT_WRITE  and
> MAP_SHARED  will  be  updated  after  a write to the mapped region, and
> before a subsequent msync(2) with the MS_SYNC or MS_ASYNC flag, if one
> occurs.

Sure, that makes sense while the file is still mapped.  But after
munmap and close, it seems like all updates should at least be updated
as far as software is concerned (the cache and dirty page writeback
should be transparent).

If we want to quote specifications, see:
http://pubs.opengroup.org/onlinepubs/9699919799/

"Section 4.8 "File Times Update"
[...]
An implementation may update timestamps that are marked for update
immediately, or it may update such timestamps periodically. At the point
in time when an update occurs, any marked timestamps shall be set to the
current time and the update marks shall be cleared. All timestamps that
are marked for update shall be updated when the file ceases to be open
by any process or before a fstat(), fstatat(), fsync(), futimens(),
lstat(), stat(), utime(), utimensat(), or utimes() is successfully
performed on the file."

> So although I can see why the combination of this behavior and your
> libelf+tar usecase causes problems the kernel behaves according to the spec
> and I don't think changing the kernel is the right solution. I'd rather
> think that you should be able to disable the ctime check in tar.

This really breaks basic assumptions about process lifetime and I/O.  In
the basic shell flow:
$ ./a && ./b
When b is invoked, it is assumed that a has been terminated and any
I/O it has performed will be reflected if b tries to read it.  (I assume
the shell achieves this with wait(pid)?()).  Again, it is not guaranteed
that the output be flushed to disk, but the cache should be transparent
to software.

- Robert
