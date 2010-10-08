Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab0JHKwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:52:55 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:54486 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753031Ab0JHKwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:52:54 -0400
Date: Fri, 8 Oct 2010 21:52:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/18] fs: Reduce inode I_FREEING and factor inode
 disposal
Message-ID: <20101008105249.GE4681@dastard>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-19-git-send-email-david@fromorbit.com>
 <20101008101819.GC19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008101819.GC19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 11:18:19AM +0100, Al Viro wrote:
> On Fri, Oct 08, 2010 at 04:21:32PM +1100, Dave Chinner wrote:
> 
> > +			spin_unlock(&sb->s_inodes_lock);
> >  
> > -			spin_lock(&inode_lru_lock);
> > -			list_move(&inode->i_lru, dispose);
> > -			spin_unlock(&inode_lru_lock);
> > +			dispose_one_inode(inode);
> >  
> > -			percpu_counter_dec(&nr_inodes_unused);
> > +			spin_lock(&sb->s_inodes_lock);
> 
> And now you've unlocked the list and even blocked.  What's going to
> keep next valid through that fun?

See the comment at the start of the loop in invalidate_list():

                /*
                 * We can reschedule here without worrying about the list's
                 * consistency because the per-sb list of inodes must not
                 * change during umount anymore, and because iprune_sem keeps
                 * shrink_icache_memory() away.
                 */
		cond_resched_lock(&sb->s_inodes_lock);

Hence I've assumed it's ok to add another point that drops locks and blocks
inside the loop and next will still be valid.

> 
> > +		spin_unlock(&inode_lru_lock);
> > +
> > +		dispose_one_inode(inode);
> > +		cond_resched();
> > +
> > +		spin_lock(&inode_lru_lock);
> 
> Same, only worse - in the previous you might hope for lack of activity
> on fs, in this one you really can't.

That one in prune_icache() is safe because the loop always gets the
first inod eon the list:

	for (nr_scanned = 0; nr_scanned < nr_to_scan; nr_scanned++) {
		struct inode *inode;

		if (list_empty(&inode_lru))
			break;

		inode = list_entry(inode_lru.prev, struct inode, i_lru);
		.....

because there is pre-existing branch in the loop that drops all the
locks.

Cheers,

Dave.



> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Dave Chinner
david@fromorbit.com
