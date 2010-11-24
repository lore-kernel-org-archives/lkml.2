Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab0KXAXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:23:13 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:23167 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755332Ab0KXAXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:23:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAP/o60x5LdQd/2dsb2JhbACia3K+BYVLBI9x
Date: Wed, 24 Nov 2010 11:23:05 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: npiggin@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 7/7] fs: fix or note I_DIRTY handling bugs in
  filesystems
Message-ID: <20101124002305.GA3168@amd>
References: <20101123140610.292941494@kernel.dk>
 <20101123140708.132861329@kernel.dk>
 <20101123225148.GZ22876@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101123225148.GZ22876@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 09:51:48AM +1100, Dave Chinner wrote:
> On Wed, Nov 24, 2010 at 01:06:17AM +1100, npiggin@kernel.dk wrote:
> > Comments?
> 
> How did you test the changes?

Not widely as yet, just tested a few filesystems passed deadlock and
bug tests. It's just in RFC state as yet.

 
> > +++ linux-2.6/fs/xfs/linux-2.6/xfs_file.c	2010-11-24 00:08:03.000000000 +1100
> > @@ -99,6 +99,7 @@ xfs_file_fsync(
> >  	struct xfs_trans	*tp;
> >  	int			error = 0;
> >  	int			log_flushed = 0;
> > +	unsigned		dirty, mask;
> >  
> >  	trace_xfs_file_fsync(ip);
> >  
> > @@ -132,9 +133,16 @@ xfs_file_fsync(
> >  	 * might gets cleared when the inode gets written out via the AIL
> >  	 * or xfs_iflush_cluster.
> >  	 */
> > -	if (((inode->i_state & I_DIRTY_DATASYNC) ||
> > -	    ((inode->i_state & I_DIRTY_SYNC) && !datasync)) &&
> > -	    ip->i_update_core) {
> > +	spin_lock(&inode_lock);
> > +	inode_writeback_begin(inode, 1);
> > +	if (datasync)
> > +		mask = I_DIRTY_DATASYNC;
> > +	else
> > +		mask = I_DIRTY_SYNC | I_DIRTY_DATASYNC;
> > +	dirty = inode->i_state & mask;
> > +	inode->i_state &= ~mask;
> > +	spin_unlock(&inode_lock);
> > +	if (dirty && ip->i_update_core) {
> 
> It looks to me like the pattern "inode_writeback_begin(); get dirty
> state from i_state" repeated for each filesystem is wrong. The
> inode_writeback_begin() helper does this:
> 
> 	inode->i_state &= ~I_DIRTY;
> 
> which clears all the dirty bits from the i_state, which means the
> followup:
> 
> 	dirty = inode->i_state & mask;
> 
> will always result in a zero value for dirty.  IOWs, this seems to
> ensure that ->fsync never sees dirty inodes anymore. This will break
> fsync on XFS, and probably on all the other filesystems you modified
> to use this pattern as well.

Yes, the helper needs to do inode->i_state &= ~I_DIRTY_PAGES. Good
catch, thanks.

I had I_DIRTY there because I was initially going to return the
dirty bits, however some cases want to check/clear bits at different
times (eg. background writeout wants to clear DIRTY_PAGES then do
the pagecache writeback, and then test/clear the metadata dirty bits).

 
> Also, I think the pattern is racy with respect to concurrent page
> cache dirtiers. i.e if the inode was dirtied between writeback and
> ->fsync() in vfs_fsync_range(), then this new code clears the
> I_DIRTY_PAGES bit in i_state without writing back the dirty pages.

That gets caught in the writeback_end helper, same way as for background
writeout. It's useful to do this for the fsync helper so that the inode
actually gets marked clean if the pagecache writeback cleaned
everything.

> 
> And FWIW, I'm not sure that we want to be propagating the inode_lock
> into every filesystem...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
