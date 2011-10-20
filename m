Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab1JTXYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 19:24:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47617 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab1JTXYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 19:24:16 -0400
Date: Fri, 21 Oct 2011 01:24:14 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] writeback: avoid redirtying when ->write_inode
 failed to clear I_DIRTY
Message-ID: <20111020232414.GD20542@quack.suse.cz>
References: <20111020152240.751936131@intel.com>
 <20111020153705.882281372@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111020153705.882281372@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20-10-11 23:22:42, Wu Fengguang wrote:
> From: Christoph Hellwig <hch@infradead.org>
> 
> Right now ->write_inode has no way to safely return a EAGAIN without explicitly
> redirtying the inode, as we would lose the dirty state otherwise.  Most
> filesystems get this wrong, but XFS makes heavy use of it to avoid blocking
> the flusher thread when ->write_inode hits contentended inode locks.  A
> contended ilock is something XFS can hit very easibly when extending files, as
> the data I/O completion handler takes the lock to update the size, and the
> ->write_inode call can race with it fairly easily if writing enough data
> in one go so that the completion for the first write come in just before
> we call ->write_inode.
> 
> Change the handling of this case to use requeue_io_wait for a quick retry instead
> of redirty_tail, which keeps moving out the dirtied_when data and thus keeps
> delaying the writeout more and more with every failed attempt to get the lock.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
  You can add:
Acked-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/fs-writeback.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> --- linux-next.orig/fs/fs-writeback.c	2011-10-08 13:30:25.000000000 +0800
> +++ linux-next/fs/fs-writeback.c	2011-10-08 13:30:41.000000000 +0800
> @@ -488,8 +488,18 @@ writeback_single_inode(struct inode *ino
>  			 * operations, such as delayed allocation during
>  			 * submission or metadata updates after data IO
>  			 * completion.
> +			 *
> +			 * For the latter case it is very important to give
> +			 * the inode another turn on b_more_io instead of
> +			 * redirtying it.  Constantly moving dirtied_when
> +			 * forward will prevent us from ever writing out
> +			 * the metadata dirtied in the I/O completion handler.
> +			 *
> +			 * For files on XFS that constantly get appended to
> +			 * calling redirty_tail means they will never get
> +			 * their updated i_size written out.
>  			 */
> -			redirty_tail(inode, wb);
> +			requeue_io_wait(inode, wb);
>  		} else {
>  			/*
>  			 * The inode is clean.  At this point we either have
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
