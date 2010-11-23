Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab0KWWwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 17:52:07 -0500
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:41000 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753084Ab0KWWwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 17:52:05 -0500
Date: Wed, 24 Nov 2010 09:51:48 +1100
From: Dave Chinner <david@fromorbit.com>
To: npiggin@kernel.dk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 7/7] fs: fix or note I_DIRTY handling bugs in
 filesystems
Message-ID: <20101123225148.GZ22876@dastard>
References: <20101123140610.292941494@kernel.dk>
 <20101123140708.132861329@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101123140708.132861329@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 01:06:17AM +1100, npiggin@kernel.dk wrote:
> Comments?

How did you test the changes?

> +++ linux-2.6/fs/xfs/linux-2.6/xfs_file.c	2010-11-24 00:08:03.000000000 +1100
> @@ -99,6 +99,7 @@ xfs_file_fsync(
>  	struct xfs_trans	*tp;
>  	int			error = 0;
>  	int			log_flushed = 0;
> +	unsigned		dirty, mask;
>  
>  	trace_xfs_file_fsync(ip);
>  
> @@ -132,9 +133,16 @@ xfs_file_fsync(
>  	 * might gets cleared when the inode gets written out via the AIL
>  	 * or xfs_iflush_cluster.
>  	 */
> -	if (((inode->i_state & I_DIRTY_DATASYNC) ||
> -	    ((inode->i_state & I_DIRTY_SYNC) && !datasync)) &&
> -	    ip->i_update_core) {
> +	spin_lock(&inode_lock);
> +	inode_writeback_begin(inode, 1);
> +	if (datasync)
> +		mask = I_DIRTY_DATASYNC;
> +	else
> +		mask = I_DIRTY_SYNC | I_DIRTY_DATASYNC;
> +	dirty = inode->i_state & mask;
> +	inode->i_state &= ~mask;
> +	spin_unlock(&inode_lock);
> +	if (dirty && ip->i_update_core) {

It looks to me like the pattern "inode_writeback_begin(); get dirty
state from i_state" repeated for each filesystem is wrong. The
inode_writeback_begin() helper does this:

	inode->i_state &= ~I_DIRTY;

which clears all the dirty bits from the i_state, which means the
followup:

	dirty = inode->i_state & mask;

will always result in a zero value for dirty.  IOWs, this seems to
ensure that ->fsync never sees dirty inodes anymore. This will break
fsync on XFS, and probably on all the other filesystems you modified
to use this pattern as well.

Also, I think the pattern is racy with respect to concurrent page
cache dirtiers. i.e if the inode was dirtied between writeback and
->fsync() in vfs_fsync_range(), then this new code clears the
I_DIRTY_PAGES bit in i_state without writing back the dirty pages.

And FWIW, I'm not sure that we want to be propagating the inode_lock
into every filesystem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
