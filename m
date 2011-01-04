Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab1ADIDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:03:41 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:57344 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751203Ab1ADIDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:03:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEADNhIk15Ldpx/2dsb2JhbACkNnS7WoVKBJAq
Date: Tue, 4 Jan 2011 19:03:23 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 8/8] fs: add i_op->sync_inode
Message-ID: <20110104080323.GC4090@amd>
References: <20101218014634.943276411@kernel.dk>
 <20101218015117.759480620@kernel.dk>
 <20101229151246.GA22033@infradead.org>
 <20110104062725.GD3402@amd>
 <20110104065736.GA8013@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104065736.GA8013@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 01:57:37AM -0500, Christoph Hellwig wrote:
> On Tue, Jan 04, 2011 at 05:27:25PM +1100, Nick Piggin wrote:
> > Basically the blocking or non blocking behaviour of ->write_inode is
> > irrelevant and will go away. Specific behaviour cannot be relied upon from
> > generic code, only filesystems. But even filesystems should not
> > differentiate between blocking and non-blocking (where they do, they
> > have been buggy). That is the *other* big bug in the code (the first one
> > being syncing code not waiting for writeback).
> >
> > So after my series, we guarantee ->write_inode is called after the inode
> > has been dirtied. We make no guarantees about what mode it is called in
> > (blocking or non blocking). So the filesystem should either have _all_
> > write_inode calls do sync writeout, or have them all do part of the op
> > (eg. clean struct inode by dirtying pagecache) and then syncing in fsync
> > and sync_fs. In the latter scheme, it doesn't make sense to do anything
> > more in the case of a "sync" call.
> 
> There is absolutely no problem with writing out inodes asynchronously,
> it's just that the writeback code can't really cope with it right now.
> The fix is to only update i_state on I/O completion.

I don't know what you mean by this. As a filesystem generic API,
.write_inode says almost nothing. Some filesystems will do one thing,
some may do something in future after patches to the vfs to allow more
fancy work, others do other things, generic code can't assume any of
that.

 
> The blocking vs non-blocking difference is actually quite important for
> performance still.

I don't see how it could be. All integrity points still have to wait for
all potentially non blocking write_inode, so if that's the case just make
*all* the write_inode non blocking to begin with. Simpler code and
you'd get more performance at least in the sync(3) case where writeback
and waiting of multiple inodes can be batched.


>  In fact for most modern filesystems we simply don't
> every want to do a normal writeout for the !sync case.  Either it would
> be a no-op, or do something like we do in xfs currently, where we make
> sure to read the inode to start the read/modify/write cycle early, and
> put it at the end of the delayed write queue.  The sync one on the other
> hand just logs the inode, so that the log force in ->sync_fs/etc can
> write them all out in one go.

Great, so why would you ever do a sync .write_inode?

 
> > > As for the actualy sync_inode operation:  I don't think it's helpful.
> > > The *_sync_inode helpers in ext2 and fat are fine, but there's little
> > > point in going through an iops vector for it.  Also adding the file
> > > syncing really complicates the API for now reason, epecially with
> > > the range interface.
> > 
> > It does have a reason, which is the nfsd syncing callback -- using
> > sync_inode_metadata there is actually wrong and should really be
> > replaced with a warning that the fs cannot support such syncing.
> > 
> > See the problem I explained above -- it really needs to do a full
> > fsync call. But it doesn't have a file descriptor, and most filesystems
> > don't need one, so I think a sync_inode operation is nice.
> 
> It doesn't need to do an fsync, it's actually a quite different
> operations.  That's why we added the ->commit_metadata operations.  What
> NFSD really wants is to guarantee synchronous metadata operations.
> Traditionally unix required the filesystems to be mounted using -o wsync
> for that, but we try to emulate that from NFSD without affecting other
> access to the filesystem.  The ->commit_metadata is there to ensure any
> previously started async operations completes.  It does not have to
> push all dirty state to disk like fsync.  Just compare the complexities
> of xfs_file_fsync and xfs_fs_nfs_commit_metadata - the latter simply
> checks if the inode has been logged, and if yes forces the log to disk
> up to the last operation on this inode.  fsync does the same force if
> the inode is not dirty, but otherwise has to start a new transactions.
> It also has to wait for pending I/O completions before dealing with
> metadata, and issue barriers to data devices, which is completly
> superflous for nfs operations.

Thanks for the interesting comments, but I didn't say it needs an fsync,
I said sync_inode_metadata is not sufficient by definition because it
guarantees nothing.

 
> > Also giving filesystems the flexibility to do the data writeout can
> > be more optimal by doing all writeout at once or ordering to suit their
> > writeback patterns. Having range data could give some performance
> > advantages writing back mappings or commit operations over network. I
> > don't see it as a big complexity. It gives a chance to do range fsyncs
> > and sync_file_range and such properly too.
> 
> We currently do all that just fine before calling into ->fsync.

What do you mean we do all that just fine? A filesystem can't schedule
data submission and waiting optimally versus metadata, it can't do
metadata operations or remote commits corresponding to data ranges, and
it doesn't support nfs sync operations.

