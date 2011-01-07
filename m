Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab1AGErw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 23:47:52 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:25904 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753137Ab1AGErv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 23:47:51 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAN8oJk15LcNW/2dsb2JhbACkHnS9CoVMBJAw
Date: Fri, 7 Jan 2011 15:47:34 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 8/8] fs: add i_op->sync_inode
Message-ID: <20110107044734.GA4552@amd>
References: <20101218014634.943276411@kernel.dk>
 <20101218015117.759480620@kernel.dk>
 <20101229151246.GA22033@infradead.org>
 <20110104062725.GD3402@amd>
 <20110104065736.GA8013@infradead.org>
 <20110104080323.GC4090@amd>
 <20110104092501.GB2760@infradead.org>
 <20110104094922.GA4812@amd>
 <20110106204510.GA2872@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110106204510.GA2872@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 03:45:10PM -0500, Christoph Hellwig wrote:
> > > The problem is that currently we almost never do a pure blocking
> > > ->write_inode.  The way the sync code is written we always do a
> > > non-blocking one first, then a blocking one.  If you always do the
> > > synchronous one we'll get a lot more overhead - the first previous
> > > asynchronous one will write the inode (be it just into the log, or for
> > > real), then we write back data, and then we'll have to write it again
> > > becaus it has usually been redirtied again due to the data writeback in
> > > the meantime.
> > 
> > It doesn't matter, the integrity still has to be enforced in .sync_fs,
> > because sync .write_inode may *never* get called, because of the fact
> > that async .write_inode also clears the inode metadata dirty bits.
> > 
> > So if .sync_fs has to enforce integrity anyway, then you don't ever need
> > to do any actual waiting in your sync .write_inode. See?
> 
> I'm not talking about the actual waiting.  Right now we have two
> different use cases for ->write_inode:
> 
>  1) sync_mode == WB_SYNC_NONE
> 
> 	This tells the filesystem to start an opportunistic writeout.
> 
>  2) sync_mode == WB_SYNC_ALL
> 
> 	This tells the filesystem it needs to to a mandatory writeout.
> 
> Note that writeout is losely defined.  If a filesystems isn't
> exportable or implements the commit_metadata operation it's indeed
> enough to synchronize the state into internal fs data just enough for
> ->sync_fs.
> 
> Or that's how it should be.  As you pointed out the way the writeback
> code treats the WB_SYNC_NONE writeouts makes this not work as expected.
> 
> There's various ways to fix this:
> 
>  1) the one you advocate, that is treating all ->write_inode calls as
>     if they were WB_SYNC_ALL.  This does fix the issue of incorrectly
>     updating the dirty state, but causes a lot of additional I/O -
>     the way the sync process is designed we basically always call
>     ->write_inode with WB_SYNC_NONE first, and then with WB_SYNC_ALL
>  2) keep the WB_SYNC_NONE calls, but never update dirty state for them.
>     This also fixes the i_dirty state updates, but allows filesystems
>     that keep internal dirty state to be smarted about avoiding I/O
>  3) remove the calls to ->write_inode with WB_SYNC_NONE.  This might
>     work well for calls from the sync() callchain, but we rely on
>     inode background writeback from the flusher threads in lots of
>     places.  Note that we really do not want to block the flusher
>     threads with blocking writes, which is another argument against
>     (1).
>  4) require ->write_inode to update the dirty state itself after
>     the inode is on disk or in a data structure caught by ->sync_fs.
>     This keeps optimal behaviour, but requires a lot of code changes.
> 
> If we want a quick fix only (2) seems feasibly to me, with the option
> of implementing (4) and parts of (3) later on.

No, you misunderstand 1. I am saying they should be treated as
WB_SYNC_NONE.

In fact 2 would cause much more IO, because dirty writeout would
never clean them so it will just keep writing them out. I don't
know how 2 could be feasible.


> > > We need to propagate the VFS dirty state into the fs-internal state,
> > > e.g. for XFS start a transaction.  The reason for that is that the VFS
> > > simply writes timestamps into the inode and marks it dirty instead of
> > > telling the filesystem about timestamp updates.  For XFS in
> > > 2.6.38+ timestamp updates and i_size updates are the only unlogged
> > > metadata changes, and thus now the only thing going through
> > > ->write_inode.
> > 
> > Well then you have a bug, because a sync .write_inode *may never get
> > called*. You may only get an async one, even in the case of fsync,
> > because async writeback clears the vfs dirty bits.
> 
> Yes, the bug about updating the dirty state for WB_SYNC_NONE affects

So, back to my original question: what is the performance problem
with treating write_inode as WB_SYNC_NONE, and then having .fsync
and .sync_fs do the integrity?

