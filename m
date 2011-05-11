Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab1EKRBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:01:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35553 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757434Ab1EKRBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:01:32 -0400
Date: Wed, 11 May 2011 19:01:30 +0200
From: Jan Kara <jack@suse.cz>
To: rmorell@nvidia.com
Cc: Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: mmap vs. ctime bug?
Message-ID: <20110511170130.GL5057@quack.suse.cz>
References: <20110510012348.GJ3848@morell.nvidia.com>
 <20110511104358.GD5057@quack.suse.cz>
 <20110511162441.GC22847@morell.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511162441.GC22847@morell.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 11-05-11 09:24:41, rmorell@nvidia.com wrote:
> On Wed, May 11, 2011 at 03:43:58AM -0700, Jan Kara wrote:
> > > I was able to reproduce the behavior with a simple test case (attached) with
> > > the latest git kernel built from 26822eebb25.  To run the test, simply
> > > put test.c and the Makefile in a new directory and run "make runtest".
> > > Note that the filesystem blocks and ctime change between the two stat
> > > invocations, although the mtime remains the same:
> > > 
> > > # make runtest
> > > gcc test.c -o test
> > > rm -f out
> > > ./test out
> > > stat out
> > >   File: `out'
> > >   Size: 268435456 	Blocks: 377096     IO Block: 4096   regular file
> > > Device: 304h/772d	Inode: 655367      Links: 1
> > > Access: (0600/-rw-------)  Uid: (    0/    root)   Gid: (    0/    root)
> > > Access: 2011-05-09 18:06:24.000000000 -0700
> > > Modify: 2011-05-09 18:06:27.000000000 -0700
> > > Change: 2011-05-09 18:06:27.000000000 -0700
> > > sync
> > > stat out
> > >   File: `out'
> > >   Size: 268435456 	Blocks: 524808     IO Block: 4096   regular file
> > > Device: 304h/772d	Inode: 655367      Links: 1
> > > Access: (0600/-rw-------)  Uid: (    0/    root)   Gid: (    0/    root)
> > > Access: 2011-05-09 18:06:24.000000000 -0700
> > > Modify: 2011-05-09 18:06:27.000000000 -0700
> > > Change: 2011-05-09 18:06:28.000000000 -0700
> > > 
> > > (note: depending on your system, you may need to tweak the "SIZE" constant in
> > > test.c up to see ctime actually change at a resolution of 1s)
> > > 
> > > 
> > > Does this seem like a bug to anyone else?  For the normal "make" flow to work
> > > properly, files really need to be done changing by the time a process exits and
> > > wait(3) returns to the parent.  The heavy-hammer workaround of adding a
> > > sync(1) throws away a ton of potential benefit from the filesystem cache.
> > > Adding an msync(MS_SYNC) in the toy test app also "fixes" the problem, but
> > > that's not feasible in the production environment since libelf is doing the
> > > modification internally and besides, it seems like it shouldn't be necessary.
> > > 
> > > If it matters, the filesystem is a dead simple ext3 with no special mount
> > > flags, but I suspect this is not specific to FS:
> >   OK, so let me explain what happens: When a sparse file is created and
> > written to via mmap, we just store the data in memory. Later, we decide
> > it's time to store the data on disk and thus we allocate blocks for the
> > data. At this point we also update ctime and mtime - naturally since the
> 
> Note that mtime has not changed, only ctime.
  Yep, because the data was not modified. Only the inode has been modified
by the writeback.

> > amount of space occupied by the file has changed. I've looked at the
> > specification and it says:
> > The st_ctime and st_mtime field for a file mapped with  PROT_WRITE  and
> > MAP_SHARED  will  be  updated  after  a write to the mapped region, and
> > before a subsequent msync(2) with the MS_SYNC or MS_ASYNC flag, if one
> > occurs.
> 
> Sure, that makes sense while the file is still mapped.  But after
> munmap and close, it seems like all updates should at least be updated
> as far as software is concerned (the cache and dirty page writeback
> should be transparent).
  I agree with the transparency as far as data is concerned. But it simply
cannot work for metadata - we don't know some things (like the number of
used blocks) in advance until the file is written. 

> If we want to quote specifications, see:
> http://pubs.opengroup.org/onlinepubs/9699919799/
> 
> "Section 4.8 "File Times Update"
> [...]
> An implementation may update timestamps that are marked for update
> immediately, or it may update such timestamps periodically. At the point
> in time when an update occurs, any marked timestamps shall be set to the
> current time and the update marks shall be cleared. All timestamps that
> are marked for update shall be updated when the file ceases to be open
> by any process or before a fstat(), fstatat(), fsync(), futimens(),
> lstat(), stat(), utime(), utimensat(), or utimes() is successfully
> performed on the file."
  But the allocation of a disk block (and thus a change to the inode) happens
after the file is closed. So the timestamp is marked for update after the
file is closed and we are consistent with the above paragraph. In fact we
should not avoid updating the time stamp because then applications would
miss that the metadata information in inode has actually changed.

> > So although I can see why the combination of this behavior and your
> > libelf+tar usecase causes problems the kernel behaves according to the spec
> > and I don't think changing the kernel is the right solution. I'd rather
> > think that you should be able to disable the ctime check in tar.
> 
> This really breaks basic assumptions about process lifetime and I/O.  In
> the basic shell flow:
> $ ./a && ./b
> When b is invoked, it is assumed that a has been terminated and any
> I/O it has performed will be reflected if b tries to read it.  (I assume
> the shell achieves this with wait(pid)?()).  Again, it is not guaranteed
> that the output be flushed to disk, but the cache should be transparent
> to software.
  Again, cache is transparent for data, not for metadata. So if b is
dependent on metadata changed by a, things get complicated. There are some
basic things defined by POSIX but apart from that all bets are off. Basically
the only way to get some guarantees is to use fsync/sync which is dumb but
that's how it is. Sorry. If you wanted that perfectly metadata consistent
behavior, kernel would have to basically fsync the file behind the scenes
and people certainly would not like that.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
