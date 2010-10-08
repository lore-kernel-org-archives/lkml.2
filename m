Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab0JHHiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 03:38:13 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:38082 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754414Ab0JHHiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 03:38:12 -0400
Date: Fri, 8 Oct 2010 18:38:08 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/18] fs: inode split IO and LRU lists
Message-ID: <20101008073808.GR4681@dastard>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-6-git-send-email-david@fromorbit.com>
 <20101008071417.GD23595@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008071417.GD23595@lst.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 03:14:17AM -0400, Christoph Hellwig wrote:
> On Fri, Oct 08, 2010 at 04:21:19PM +1100, Dave Chinner wrote:
> > From: Nick Piggin <npiggin@suse.de>
> > 
> > The use of the same inode list structure (inode->i_list) for two
> > different list constructs with different lifecycles and purposes
> > makes it impossible to separate the locking of the different
> > operations. Therefore, to enable the separation of the locking of
> > the writeback and reclaim lists, split the inode->i_list into two
> > separate lists dedicated to their specific tracking functions.
> 
> > @@ -410,7 +410,11 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
> >  			redirty_tail(inode);
> >  		} else {
> >  			/* The inode is clean */
> > -			list_move(&inode->i_list, &inode_unused);
> > +			list_del_init(&inode->i_io);
> > +			if (list_empty(&inode->i_lru)) {
> > +				list_add(&inode->i_lru, &inode_unused);
> > +				percpu_counter_inc(&nr_inodes_unused);
> > +			}
> 
> This looks like it belongs into the earlier patch.

I'm not sure it can be moved to an earlier patch. Until the LRU is
separated, we cannot tell what list the inode is on when we get
here. Yes, it means that the nr_inodes_unused counter is probably
broken for a couple of patches in this series. I'll look at it a bit
more, but I don't think it's a huge deal....

> Also instead of
> making nr_inodes_unused non-static a helper to manipulate it might
> be a better idea.

That happens later in the series as more code gets converted to be
identical.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
