Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab0JQBxy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 21:53:54 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:45772 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757169Ab0JQBxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 21:53:53 -0400
Date: Sun, 17 Oct 2010 12:53:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/19] fs: Implement lazy LRU updates for inodes.
Message-ID: <20101017015349.GF32255@dastard>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
 <1287216853-17634-5-git-send-email-david@fromorbit.com>
 <20101016092916.GA32197@amd>
 <20101016165930.GA20626@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016165930.GA20626@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 12:59:30PM -0400, Christoph Hellwig wrote:
> On Sat, Oct 16, 2010 at 08:29:16PM +1100, Nick Piggin wrote:
> > On Sat, Oct 16, 2010 at 07:13:58PM +1100, Dave Chinner wrote:
> > > @@ -502,11 +527,15 @@ static void prune_icache(int nr_to_scan)
> > >  			iput(inode);
> > >  			spin_lock(&inode_lock);
> > >  
> > > -			if (inode != list_entry(inode_unused.next,
> > > -						struct inode, i_list))
> > > -				continue;	/* wrong inode or list_empty */
> > > -			if (!can_unuse(inode))
> > > +			/*
> > > +			 * if we can't reclaim this inode immediately, give it
> > > +			 * another pass through the free list so we don't spin
> > > +			 * on it.
> > > +			 */
> > > +			if (!can_unuse(inode)) {
> > > +				list_move(&inode->i_list, &inode_unused);
> > >  				continue;
> > > +			}
> > >  		}
> > >  		list_move(&inode->i_list, &freeable);
> > >  		WARN_ON(inode->i_state & I_NEW);
> > 
> > This is a bug, actually 2 bugs, which is why I omitted it in the version
> > you picked up. I agree we want the optimisation though, so I've added it
> > back in my tree.
> > 
> > After you iput() and then re take the inode lock, you can't reference
> > the inode because you don't know what happened to it. You need to keep
> > that pointer check to verify it is still there.
> 
> I don't think the pointer check will work either.  By the time we retake
> the lru lock the inode might already have been reaped through a call
> to invalidate_inodes.  There's no way we can do anything with it after
> iput.  What we could do is using variant of can_unuse to decide to move
> the inode to the front of the lru before doing the iput.  That way
> we'll get to it next after retaking the lru lock if it's still there.

But as Nick pointed out I_REFERENCED will be set, and so it'll move
to the back of the list next time around it we leave it on the list.
If we race with another reclaimer, it'll see a reference count, and
move it to the back of the list without clearing the I_REFERENCED
flag we set.

IOWs, there does not seem to any point to me in keeping the can_unuse()
optimisation. All it really is doing is repeating the behaviour that
will occur if we leave the inode where it is on the list and run the
loop again. If we really care that it counts as two scanned items
now, we can add a scan count back in after the iput() call....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
