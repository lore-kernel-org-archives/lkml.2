Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab0JHMK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 08:10:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57071 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756918Ab0JHMKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 08:10:55 -0400
Date: Fri, 8 Oct 2010 13:10:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/18] fs: Reduce inode I_FREEING and factor inode
 disposal
Message-ID: <20101008121052.GE19804@ZenIV.linux.org.uk>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-19-git-send-email-david@fromorbit.com>
 <20101008101819.GC19804@ZenIV.linux.org.uk>
 <20101008105249.GE4681@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008105249.GE4681@dastard>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 09:52:49PM +1100, Dave Chinner wrote:
> On Fri, Oct 08, 2010 at 11:18:19AM +0100, Al Viro wrote:
> > On Fri, Oct 08, 2010 at 04:21:32PM +1100, Dave Chinner wrote:
> > 
> > > +			spin_unlock(&sb->s_inodes_lock);
> > >  
> > > -			spin_lock(&inode_lru_lock);
> > > -			list_move(&inode->i_lru, dispose);
> > > -			spin_unlock(&inode_lru_lock);
> > > +			dispose_one_inode(inode);
> > >  
> > > -			percpu_counter_dec(&nr_inodes_unused);
> > > +			spin_lock(&sb->s_inodes_lock);
> > 
> > And now you've unlocked the list and even blocked.  What's going to
> > keep next valid through that fun?
> 
> See the comment at the start of the loop in invalidate_list():
> 
>                 /*
>                  * We can reschedule here without worrying about the list's
>                  * consistency because the per-sb list of inodes must not
>                  * change during umount anymore, and because iprune_sem keeps
>                  * shrink_icache_memory() away.
>                  */
> 		cond_resched_lock(&sb->s_inodes_lock);
> 
> Hence I've assumed it's ok to add another point that drops locks and blocks
> inside the loop and next will still be valid.

I'm not convinced, TBH; IOW, the original might have been broken by that.
The trouble is, this function is called not only on umount().  Block device
invalidation paths also can lead to it.  Moreover, even for umount-only
side of things, remember that there's fsnotify as well.  Original code
did _everything_ except the actual dropping inodes without releasing
inode_lock.  I'm not saying that change is broken (or, in case of
non-umount paths, makes breakage worse), but I'd like to see more analysis
of that area.

Umount races that hit only when you have the right subset of inodes with
idiotify watches on those are really not fun to debug post-factum...


> > > +		spin_unlock(&inode_lru_lock);
> > > +
> > > +		dispose_one_inode(inode);
> > > +		cond_resched();
> > > +
> > > +		spin_lock(&inode_lru_lock);
> > 
> > Same, only worse - in the previous you might hope for lack of activity
> > on fs, in this one you really can't.
> 
> That one in prune_icache() is safe because the loop always gets the
> first inod eon the list:
> 
> 	for (nr_scanned = 0; nr_scanned < nr_to_scan; nr_scanned++) {
> 		struct inode *inode;
> 
> 		if (list_empty(&inode_lru))
> 			break;
> 
> 		inode = list_entry(inode_lru.prev, struct inode, i_lru);
> 		.....

D'oh.  OK, that one looks all right.
