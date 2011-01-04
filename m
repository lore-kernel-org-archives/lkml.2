Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab1ADJZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 04:25:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60517 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab1ADJZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 04:25:02 -0500
Date: Tue, 4 Jan 2011 04:25:01 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 8/8] fs: add i_op->sync_inode
Message-ID: <20110104092501.GB2760@infradead.org>
References: <20101218014634.943276411@kernel.dk>
 <20101218015117.759480620@kernel.dk>
 <20101229151246.GA22033@infradead.org>
 <20110104062725.GD3402@amd>
 <20110104065736.GA8013@infradead.org>
 <20110104080323.GC4090@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104080323.GC4090@amd>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 07:03:23PM +1100, Nick Piggin wrote:
> > There is absolutely no problem with writing out inodes asynchronously,
> > it's just that the writeback code can't really cope with it right now.
> > The fix is to only update i_state on I/O completion.
> 
> I don't know what you mean by this. As a filesystem generic API,
> .write_inode says almost nothing. Some filesystems will do one thing,
> some may do something in future after patches to the vfs to allow more
> fancy work, others do other things, generic code can't assume any of
> that.

There is no problem with having a method (let's call it write_inode for
simplicity, it could be sync_inode or got knows what else) to write
clear the dirty state of the VFS inode asynchronously, as long as we
make sure the bits are only updated once it's been successfull.  That
is for an async call we can't let the caller of ->write_inode update
it, but need to do it in an I/O completion callback.

> > The blocking vs non-blocking difference is actually quite important for
> > performance still.
> 
> I don't see how it could be. All integrity points still have to wait for
> all potentially non blocking write_inode, so if that's the case just make
> *all* the write_inode non blocking to begin with. Simpler code and
> you'd get more performance at least in the sync(3) case where writeback
> and waiting of multiple inodes can be batched.

The problem is that currently we almost never do a pure blocking
->write_inode.  The way the sync code is written we always do a
non-blocking one first, then a blocking one.  If you always do the
synchronous one we'll get a lot more overhead - the first previous
asynchronous one will write the inode (be it just into the log, or for
real), then we write back data, and then we'll have to write it again
becaus it has usually been redirtied again due to the data writeback in
the meantime.  If you want to get rid of the asynchronous ones you need
to get rid of the callers, and not just change the behaviour in the
implementations.

> >  In fact for most modern filesystems we simply don't
> > every want to do a normal writeout for the !sync case.  Either it would
> > be a no-op, or do something like we do in xfs currently, where we make
> > sure to read the inode to start the read/modify/write cycle early, and
> > put it at the end of the delayed write queue.  The sync one on the other
> > hand just logs the inode, so that the log force in ->sync_fs/etc can
> > write them all out in one go.
> 
> Great, so why would you ever do a sync .write_inode?

We need to propagate the VFS dirty state into the fs-internal state,
e.g. for XFS start a transaction.  The reason for that is that the VFS
simply writes timestamps into the inode and marks it dirty instead of
telling the filesystem about timestamp updates.  For XFS in
2.6.38+ timestamp updates and i_size updates are the only unlogged
metadata changes, and thus now the only thing going through
->write_inode.

> > > Also giving filesystems the flexibility to do the data writeout can
> > > be more optimal by doing all writeout at once or ordering to suit their
> > > writeback patterns. Having range data could give some performance
> > > advantages writing back mappings or commit operations over network. I
> > > don't see it as a big complexity. It gives a chance to do range fsyncs
> > > and sync_file_range and such properly too.
> > 
> > We currently do all that just fine before calling into ->fsync.
> 
> What do you mean we do all that just fine? A filesystem can't schedule
> data submission and waiting optimally versus metadata, it can't do
> metadata operations or remote commits corresponding to data ranges, and
> it doesn't support nfs sync operations.

A normal filesystems needs to wait for data I/O to finish before updating
the metadata for data integrity reasons - otherwise we can expose stale
data in case of a crash - that's one of the things we fixed a couple of
kernel releases ago.  As I said I have no problems moving the
data operations into ->fsync or adding range information if we actually
need it.  Show me a filesystem that really needs this to get good
performance and we can adapt the ->fsync prototype.  If we need it at
all we'll need it for network/distributed filesystems, though - which
have a tendency to actually require the file argument and won't be
able to use an inode operations.  Nevermind the fact that
file_operations are what we use for all data I/O operations, and messing
this up for the sake of it doesn't seem like an overly useful idea.

Care to explain what you mean with nfs sync operations?

> 
---end quoted text---
